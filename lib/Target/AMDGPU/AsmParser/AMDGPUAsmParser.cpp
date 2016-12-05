//===-- AMDGPUAsmParser.cpp - Parse SI asm to MCInst instructions ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "AMDKernelCodeT.h"
#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "MCTargetDesc/AMDGPUTargetStreamer.h"
#include "SIDefines.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "Utils/AMDKernelCodeTUtils.h"
#include "Utils/AMDGPUAsmUtils.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallBitVector.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/Twine.h"
#include "llvm/CodeGen/MachineValueType.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCParser/MCAsmLexer.h"
#include "llvm/MC/MCParser/MCAsmParser.h"
#include "llvm/MC/MCParser/MCParsedAsmOperand.h"
#include "llvm/MC/MCParser/MCTargetAsmParser.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ELF.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/MathExtras.h"

using namespace llvm;
using namespace llvm::AMDGPU;

namespace {

class AMDGPUAsmParser;
struct OptionalOperand;

enum RegisterKind { IS_UNKNOWN, IS_VGPR, IS_SGPR, IS_TTMP, IS_SPECIAL };

//===----------------------------------------------------------------------===//
// Operand
//===----------------------------------------------------------------------===//

class AMDGPUOperand : public MCParsedAsmOperand {
  enum KindTy {
    Token,
    Immediate,
    Register,
    Expression
  } Kind;

  SMLoc StartLoc, EndLoc;
  const AMDGPUAsmParser *AsmParser;

public:
  AMDGPUOperand(enum KindTy Kind_, const AMDGPUAsmParser *AsmParser_)
    : MCParsedAsmOperand(), Kind(Kind_), AsmParser(AsmParser_) {}

  typedef std::unique_ptr<AMDGPUOperand> Ptr;

  struct Modifiers {
    bool Abs = false;
    bool Neg = false;
    bool Sext = false;

    bool hasFPModifiers() const { return Abs || Neg; }
    bool hasIntModifiers() const { return Sext; }
    bool hasModifiers() const { return hasFPModifiers() || hasIntModifiers(); }

    int64_t getFPModifiersOperand() const {
      int64_t Operand = 0;
      Operand |= Abs ? SISrcMods::ABS : 0;
      Operand |= Neg ? SISrcMods::NEG : 0;
      return Operand;
    }

    int64_t getIntModifiersOperand() const {
      int64_t Operand = 0;
      Operand |= Sext ? SISrcMods::SEXT : 0;
      return Operand;
    }

    int64_t getModifiersOperand() const {
      assert(!(hasFPModifiers() && hasIntModifiers())
           && "fp and int modifiers should not be used simultaneously");
      if (hasFPModifiers()) {
        return getFPModifiersOperand();
      } else if (hasIntModifiers()) {
        return getIntModifiersOperand();
      } else {
        return 0;
      }
    }

    friend raw_ostream &operator <<(raw_ostream &OS, AMDGPUOperand::Modifiers Mods);
  };

  enum ImmTy {
    ImmTyNone,
    ImmTyGDS,
    ImmTyOffen,
    ImmTyIdxen,
    ImmTyAddr64,
    ImmTyOffset,
    ImmTyOffset0,
    ImmTyOffset1,
    ImmTyGLC,
    ImmTySLC,
    ImmTyTFE,
    ImmTyClampSI,
    ImmTyOModSI,
    ImmTyDppCtrl,
    ImmTyDppRowMask,
    ImmTyDppBankMask,
    ImmTyDppBoundCtrl,
    ImmTySdwaDstSel,
    ImmTySdwaSrc0Sel,
    ImmTySdwaSrc1Sel,
    ImmTySdwaDstUnused,
    ImmTyDMask,
    ImmTyUNorm,
    ImmTyDA,
    ImmTyR128,
    ImmTyLWE,
    ImmTyExpTgt,
    ImmTyExpCompr,
    ImmTyExpVM,
    ImmTyHwreg,
    ImmTyOff,
    ImmTySendMsg,
  };

  struct TokOp {
    const char *Data;
    unsigned Length;
  };

  struct ImmOp {
    int64_t Val;
    ImmTy Type;
    bool IsFPImm;
    Modifiers Mods;
  };

  struct RegOp {
    unsigned RegNo;
    bool IsForcedVOP3;
    Modifiers Mods;
  };

  union {
    TokOp Tok;
    ImmOp Imm;
    RegOp Reg;
    const MCExpr *Expr;
  };

  bool isToken() const override {
    if (Kind == Token)
      return true;

    if (Kind != Expression || !Expr)
      return false;

    // When parsing operands, we can't always tell if something was meant to be
    // a token, like 'gds', or an expression that references a global variable.
    // In this case, we assume the string is an expression, and if we need to
    // interpret is a token, then we treat the symbol name as the token.
    return isa<MCSymbolRefExpr>(Expr);
  }

  bool isImm() const override {
    return Kind == Immediate;
  }

  bool isInlinableImm(MVT type) const;
  bool isLiteralImm(MVT type) const;

  bool isRegKind() const {
    return Kind == Register;
  }

  bool isReg() const override {
    return isRegKind() && !Reg.Mods.hasModifiers();
  }

  bool isRegOrImmWithInputMods(MVT type) const {
    return isRegKind() || isInlinableImm(type);
  }

  bool isRegOrImmWithInt32InputMods() const {
    return isRegOrImmWithInputMods(MVT::i32);
  }

  bool isRegOrImmWithInt64InputMods() const {
    return isRegOrImmWithInputMods(MVT::i64);
  }

  bool isRegOrImmWithFP32InputMods() const {
    return isRegOrImmWithInputMods(MVT::f32);
  }

  bool isRegOrImmWithFP64InputMods() const {
    return isRegOrImmWithInputMods(MVT::f64);
  }

  bool isVReg32OrOff() const {
    return isOff() || isRegClass(AMDGPU::VGPR_32RegClassID);
  }

  bool isImmTy(ImmTy ImmT) const {
    return isImm() && Imm.Type == ImmT;
  }

  bool isImmModifier() const {
    return isImm() && Imm.Type != ImmTyNone;
  }

  bool isClampSI() const { return isImmTy(ImmTyClampSI); }
  bool isOModSI() const { return isImmTy(ImmTyOModSI); }
  bool isDMask() const { return isImmTy(ImmTyDMask); }
  bool isUNorm() const { return isImmTy(ImmTyUNorm); }
  bool isDA() const { return isImmTy(ImmTyDA); }
  bool isR128() const { return isImmTy(ImmTyUNorm); }
  bool isLWE() const { return isImmTy(ImmTyLWE); }
  bool isOff() const { return isImmTy(ImmTyOff); }
  bool isExpTgt() const { return isImmTy(ImmTyExpTgt); }
  bool isExpVM() const { return isImmTy(ImmTyExpVM); }
  bool isExpCompr() const { return isImmTy(ImmTyExpCompr); }
  bool isOffen() const { return isImmTy(ImmTyOffen); }
  bool isIdxen() const { return isImmTy(ImmTyIdxen); }
  bool isAddr64() const { return isImmTy(ImmTyAddr64); }
  bool isOffset() const { return isImmTy(ImmTyOffset) && isUInt<16>(getImm()); }
  bool isOffset0() const { return isImmTy(ImmTyOffset0) && isUInt<16>(getImm()); }
  bool isOffset1() const { return isImmTy(ImmTyOffset1) && isUInt<8>(getImm()); }
  bool isGDS() const { return isImmTy(ImmTyGDS); }
  bool isGLC() const { return isImmTy(ImmTyGLC); }
  bool isSLC() const { return isImmTy(ImmTySLC); }
  bool isTFE() const { return isImmTy(ImmTyTFE); }
  bool isBankMask() const { return isImmTy(ImmTyDppBankMask); }
  bool isRowMask() const { return isImmTy(ImmTyDppRowMask); }
  bool isBoundCtrl() const { return isImmTy(ImmTyDppBoundCtrl); }
  bool isSDWADstSel() const { return isImmTy(ImmTySdwaDstSel); }
  bool isSDWASrc0Sel() const { return isImmTy(ImmTySdwaSrc0Sel); }
  bool isSDWASrc1Sel() const { return isImmTy(ImmTySdwaSrc1Sel); }
  bool isSDWADstUnused() const { return isImmTy(ImmTySdwaDstUnused); }

  bool isMod() const {
    return isClampSI() || isOModSI();
  }

  bool isRegOrImm() const {
    return isReg() || isImm();
  }

  bool isRegClass(unsigned RCID) const;

  bool isSCSrcB32() const {
    return isRegClass(AMDGPU::SReg_32RegClassID) || isInlinableImm(MVT::i32);
  }

  bool isSCSrcB64() const {
    return isRegClass(AMDGPU::SReg_64RegClassID) || isInlinableImm(MVT::i64);
  }

  bool isSCSrcF32() const {
    return isRegClass(AMDGPU::SReg_32RegClassID) || isInlinableImm(MVT::f32);
  }

  bool isSCSrcF64() const {
    return isRegClass(AMDGPU::SReg_64RegClassID) || isInlinableImm(MVT::f64);
  }

  bool isSSrcB32() const {
    return isSCSrcB32() || isLiteralImm(MVT::i32) || isExpr();
  }

  bool isSSrcB64() const {
    // TODO: Find out how SALU supports extension of 32-bit literals to 64 bits.
    // See isVSrc64().
    return isSCSrcB64() || isLiteralImm(MVT::i64);
  }

  bool isSSrcF32() const {
    return isSCSrcB32() || isLiteralImm(MVT::f32) || isExpr();
  }

  bool isSSrcF64() const {
    return isSCSrcB64() || isLiteralImm(MVT::f64);
  }

  bool isVCSrcB32() const {
    return isRegClass(AMDGPU::VS_32RegClassID) || isInlinableImm(MVT::i32);
  }

  bool isVCSrcB64() const {
    return isRegClass(AMDGPU::VS_64RegClassID) || isInlinableImm(MVT::i64);
  }

  bool isVCSrcF32() const {
    return isRegClass(AMDGPU::VS_32RegClassID) || isInlinableImm(MVT::f32);
  }

  bool isVCSrcF64() const {
    return isRegClass(AMDGPU::VS_64RegClassID) || isInlinableImm(MVT::f64);
  }

  bool isVSrcB32() const {
    return isVCSrcF32() || isLiteralImm(MVT::i32);
  }

  bool isVSrcB64() const {
    return isVCSrcF64() || isLiteralImm(MVT::i64);
  }

  bool isVSrcF32() const {
    return isVCSrcF32() || isLiteralImm(MVT::f32);
  }

  bool isVSrcF64() const {
    return isVCSrcF64() || isLiteralImm(MVT::f64);
  }

  bool isKImmFP32() const {
    return isLiteralImm(MVT::f32);
  }

  bool isMem() const override {
    return false;
  }

  bool isExpr() const {
    return Kind == Expression;
  }

  bool isSoppBrTarget() const {
    return isExpr() || isImm();
  }

  bool isSWaitCnt() const;
  bool isHwreg() const;
  bool isSendMsg() const;
  bool isSMRDOffset8() const;
  bool isSMRDOffset20() const;
  bool isSMRDLiteralOffset() const;
  bool isDPPCtrl() const;
  bool isGPRIdxMode() const;

  StringRef getExpressionAsToken() const {
    assert(isExpr());
    const MCSymbolRefExpr *S = cast<MCSymbolRefExpr>(Expr);
    return S->getSymbol().getName();
  }


  StringRef getToken() const {
    assert(isToken());

    if (Kind == Expression)
      return getExpressionAsToken();

    return StringRef(Tok.Data, Tok.Length);
  }

  int64_t getImm() const {
    assert(isImm());
    return Imm.Val;
  }

  enum ImmTy getImmTy() const {
    assert(isImm());
    return Imm.Type;
  }

  unsigned getReg() const override {
    return Reg.RegNo;
  }

  SMLoc getStartLoc() const override {
    return StartLoc;
  }

  SMLoc getEndLoc() const override {
    return EndLoc;
  }

  Modifiers getModifiers() const {
    assert(isRegKind() || isImmTy(ImmTyNone));
    return isRegKind() ? Reg.Mods : Imm.Mods;
  }

  void setModifiers(Modifiers Mods) {
    assert(isRegKind() || isImmTy(ImmTyNone));
    if (isRegKind())
      Reg.Mods = Mods;
    else
      Imm.Mods = Mods;
  }

  bool hasModifiers() const {
    return getModifiers().hasModifiers();
  }

  bool hasFPModifiers() const {
    return getModifiers().hasFPModifiers();
  }

  bool hasIntModifiers() const {
    return getModifiers().hasIntModifiers();
  }

  void addImmOperands(MCInst &Inst, unsigned N, bool ApplyModifiers = true) const;

  void addLiteralImmOperand(MCInst &Inst, int64_t Val) const;

  void addKImmFP32Operands(MCInst &Inst, unsigned N) const;

  void addRegOperands(MCInst &Inst, unsigned N) const;

  void addRegOrImmOperands(MCInst &Inst, unsigned N) const {
    if (isRegKind())
      addRegOperands(Inst, N);
    else if (isExpr())
      Inst.addOperand(MCOperand::createExpr(Expr));
    else
      addImmOperands(Inst, N);
  }

  void addRegOrImmWithInputModsOperands(MCInst &Inst, unsigned N) const {
    Modifiers Mods = getModifiers();
    Inst.addOperand(MCOperand::createImm(Mods.getModifiersOperand()));
    if (isRegKind()) {
      addRegOperands(Inst, N);
    } else {
      addImmOperands(Inst, N, false);
    }
  }

  void addRegOrImmWithFPInputModsOperands(MCInst &Inst, unsigned N) const {
    assert(!hasIntModifiers());
    addRegOrImmWithInputModsOperands(Inst, N);
  }

  void addRegOrImmWithIntInputModsOperands(MCInst &Inst, unsigned N) const {
    assert(!hasFPModifiers());
    addRegOrImmWithInputModsOperands(Inst, N);
  }

  void addSoppBrTargetOperands(MCInst &Inst, unsigned N) const {
    if (isImm())
      addImmOperands(Inst, N);
    else {
      assert(isExpr());
      Inst.addOperand(MCOperand::createExpr(Expr));
    }
  }

  static void printImmTy(raw_ostream& OS, ImmTy Type) {
    switch (Type) {
    case ImmTyNone: OS << "None"; break;
    case ImmTyGDS: OS << "GDS"; break;
    case ImmTyOffen: OS << "Offen"; break;
    case ImmTyIdxen: OS << "Idxen"; break;
    case ImmTyAddr64: OS << "Addr64"; break;
    case ImmTyOffset: OS << "Offset"; break;
    case ImmTyOffset0: OS << "Offset0"; break;
    case ImmTyOffset1: OS << "Offset1"; break;
    case ImmTyGLC: OS << "GLC"; break;
    case ImmTySLC: OS << "SLC"; break;
    case ImmTyTFE: OS << "TFE"; break;
    case ImmTyClampSI: OS << "ClampSI"; break;
    case ImmTyOModSI: OS << "OModSI"; break;
    case ImmTyDppCtrl: OS << "DppCtrl"; break;
    case ImmTyDppRowMask: OS << "DppRowMask"; break;
    case ImmTyDppBankMask: OS << "DppBankMask"; break;
    case ImmTyDppBoundCtrl: OS << "DppBoundCtrl"; break;
    case ImmTySdwaDstSel: OS << "SdwaDstSel"; break;
    case ImmTySdwaSrc0Sel: OS << "SdwaSrc0Sel"; break;
    case ImmTySdwaSrc1Sel: OS << "SdwaSrc1Sel"; break;
    case ImmTySdwaDstUnused: OS << "SdwaDstUnused"; break;
    case ImmTyDMask: OS << "DMask"; break;
    case ImmTyUNorm: OS << "UNorm"; break;
    case ImmTyDA: OS << "DA"; break;
    case ImmTyR128: OS << "R128"; break;
    case ImmTyLWE: OS << "LWE"; break;
    case ImmTyOff: OS << "Off"; break;
    case ImmTyExpTgt: OS << "ExpTgt"; break;
    case ImmTyExpCompr: OS << "ExpCompr"; break;
    case ImmTyExpVM: OS << "ExpVM"; break;
    case ImmTyHwreg: OS << "Hwreg"; break;
    case ImmTySendMsg: OS << "SendMsg"; break;
    }
  }

  void print(raw_ostream &OS) const override {
    switch (Kind) {
    case Register:
      OS << "<register " << getReg() << " mods: " << Reg.Mods << '>';
      break;
    case Immediate:
      OS << '<' << getImm();
      if (getImmTy() != ImmTyNone) {
        OS << " type: "; printImmTy(OS, getImmTy());
      }
      OS << " mods: " << Imm.Mods << '>';
      break;
    case Token:
      OS << '\'' << getToken() << '\'';
      break;
    case Expression:
      OS << "<expr " << *Expr << '>';
      break;
    }
  }

  static AMDGPUOperand::Ptr CreateImm(const AMDGPUAsmParser *AsmParser,
                                      int64_t Val, SMLoc Loc,
                                      enum ImmTy Type = ImmTyNone,
                                      bool IsFPImm = false) {
    auto Op = llvm::make_unique<AMDGPUOperand>(Immediate, AsmParser);
    Op->Imm.Val = Val;
    Op->Imm.IsFPImm = IsFPImm;
    Op->Imm.Type = Type;
    Op->Imm.Mods = Modifiers();
    Op->StartLoc = Loc;
    Op->EndLoc = Loc;
    return Op;
  }

  static AMDGPUOperand::Ptr CreateToken(const AMDGPUAsmParser *AsmParser,
                                        StringRef Str, SMLoc Loc,
                                        bool HasExplicitEncodingSize = true) {
    auto Res = llvm::make_unique<AMDGPUOperand>(Token, AsmParser);
    Res->Tok.Data = Str.data();
    Res->Tok.Length = Str.size();
    Res->StartLoc = Loc;
    Res->EndLoc = Loc;
    return Res;
  }

  static AMDGPUOperand::Ptr CreateReg(const AMDGPUAsmParser *AsmParser,
                                      unsigned RegNo, SMLoc S,
                                      SMLoc E,
                                      bool ForceVOP3) {
    auto Op = llvm::make_unique<AMDGPUOperand>(Register, AsmParser);
    Op->Reg.RegNo = RegNo;
    Op->Reg.Mods = Modifiers();
    Op->Reg.IsForcedVOP3 = ForceVOP3;
    Op->StartLoc = S;
    Op->EndLoc = E;
    return Op;
  }

  static AMDGPUOperand::Ptr CreateExpr(const AMDGPUAsmParser *AsmParser,
                                       const class MCExpr *Expr, SMLoc S) {
    auto Op = llvm::make_unique<AMDGPUOperand>(Expression, AsmParser);
    Op->Expr = Expr;
    Op->StartLoc = S;
    Op->EndLoc = S;
    return Op;
  }
};

raw_ostream &operator <<(raw_ostream &OS, AMDGPUOperand::Modifiers Mods) {
  OS << "abs:" << Mods.Abs << " neg: " << Mods.Neg << " sext:" << Mods.Sext;
  return OS;
}

//===----------------------------------------------------------------------===//
// AsmParser
//===----------------------------------------------------------------------===//

class AMDGPUAsmParser : public MCTargetAsmParser {
  const MCInstrInfo &MII;
  MCAsmParser &Parser;

  unsigned ForcedEncodingSize;
  bool ForcedDPP;
  bool ForcedSDWA;

  /// @name Auto-generated Match Functions
  /// {

#define GET_ASSEMBLER_HEADER
#include "AMDGPUGenAsmMatcher.inc"

  /// }

private:
  bool ParseDirectiveMajorMinor(uint32_t &Major, uint32_t &Minor);
  bool ParseDirectiveHSACodeObjectVersion();
  bool ParseDirectiveHSACodeObjectISA();
  bool ParseAMDKernelCodeTValue(StringRef ID, amd_kernel_code_t &Header);
  bool ParseDirectiveAMDKernelCodeT();
  bool ParseSectionDirectiveHSAText();
  bool subtargetHasRegister(const MCRegisterInfo &MRI, unsigned RegNo) const;
  bool ParseDirectiveAMDGPUHsaKernel();
  bool ParseDirectiveAMDGPUHsaModuleGlobal();
  bool ParseDirectiveAMDGPUHsaProgramGlobal();
  bool ParseSectionDirectiveHSADataGlobalAgent();
  bool ParseSectionDirectiveHSADataGlobalProgram();
  bool ParseSectionDirectiveHSARodataReadonlyAgent();
  bool AddNextRegisterToList(unsigned& Reg, unsigned& RegWidth, RegisterKind RegKind, unsigned Reg1, unsigned RegNum);
  bool ParseAMDGPURegister(RegisterKind& RegKind, unsigned& Reg, unsigned& RegNum, unsigned& RegWidth);
  void cvtMubufImpl(MCInst &Inst, const OperandVector &Operands, bool IsAtomic, bool IsAtomicReturn);

public:
  enum AMDGPUMatchResultTy {
    Match_PreferE32 = FIRST_TARGET_MATCH_RESULT_TY
  };

  AMDGPUAsmParser(const MCSubtargetInfo &STI, MCAsmParser &_Parser,
               const MCInstrInfo &MII,
               const MCTargetOptions &Options)
      : MCTargetAsmParser(Options, STI), MII(MII), Parser(_Parser),
        ForcedEncodingSize(0),
        ForcedDPP(false),
        ForcedSDWA(false) {
    MCAsmParserExtension::Initialize(Parser);

    if (getSTI().getFeatureBits().none()) {
      // Set default features.
      copySTI().ToggleFeature("SOUTHERN_ISLANDS");
    }

    setAvailableFeatures(ComputeAvailableFeatures(getSTI().getFeatureBits()));

    {
      // TODO: make those pre-defined variables read-only.
      // Currently there is none suitable machinery in the core llvm-mc for this.
      // MCSymbol::isRedefinable is intended for another purpose, and
      // AsmParser::parseDirectiveSet() cannot be specialized for specific target.
      AMDGPU::IsaVersion Isa = AMDGPU::getIsaVersion(getSTI().getFeatureBits());
      MCContext &Ctx = getContext();
      MCSymbol *Sym = Ctx.getOrCreateSymbol(Twine(".option.machine_version_major"));
      Sym->setVariableValue(MCConstantExpr::create(Isa.Major, Ctx));
      Sym = Ctx.getOrCreateSymbol(Twine(".option.machine_version_minor"));
      Sym->setVariableValue(MCConstantExpr::create(Isa.Minor, Ctx));
      Sym = Ctx.getOrCreateSymbol(Twine(".option.machine_version_stepping"));
      Sym->setVariableValue(MCConstantExpr::create(Isa.Stepping, Ctx));
    }
  }

  bool isSI() const {
    return AMDGPU::isSI(getSTI());
  }

  bool isCI() const {
    return AMDGPU::isCI(getSTI());
  }

  bool isVI() const {
    return AMDGPU::isVI(getSTI());
  }

  bool hasSGPR102_SGPR103() const {
    return !isVI();
  }

  AMDGPUTargetStreamer &getTargetStreamer() {
    MCTargetStreamer &TS = *getParser().getStreamer().getTargetStreamer();
    return static_cast<AMDGPUTargetStreamer &>(TS);
  }

  const MCRegisterInfo *getMRI() const {
    // We need this const_cast because for some reason getContext() is not const
    // in MCAsmParser.
    return const_cast<AMDGPUAsmParser*>(this)->getContext().getRegisterInfo();
  }

  const MCInstrInfo *getMII() const {
    return &MII;
  }

  void setForcedEncodingSize(unsigned Size) { ForcedEncodingSize = Size; }
  void setForcedDPP(bool ForceDPP_) { ForcedDPP = ForceDPP_; }
  void setForcedSDWA(bool ForceSDWA_) { ForcedSDWA = ForceSDWA_; }

  unsigned getForcedEncodingSize() const { return ForcedEncodingSize; }
  bool isForcedVOP3() const { return ForcedEncodingSize == 64; }
  bool isForcedDPP() const { return ForcedDPP; }
  bool isForcedSDWA() const { return ForcedSDWA; }

  std::unique_ptr<AMDGPUOperand> parseRegister();
  bool ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) override;
  unsigned checkTargetMatchPredicate(MCInst &Inst) override;
  unsigned validateTargetOperandClass(MCParsedAsmOperand &Op,
                                      unsigned Kind) override;
  bool MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                               OperandVector &Operands, MCStreamer &Out,
                               uint64_t &ErrorInfo,
                               bool MatchingInlineAsm) override;
  bool ParseDirective(AsmToken DirectiveID) override;
  OperandMatchResultTy parseOperand(OperandVector &Operands, StringRef Mnemonic);
  StringRef parseMnemonicSuffix(StringRef Name);
  bool ParseInstruction(ParseInstructionInfo &Info, StringRef Name,
                        SMLoc NameLoc, OperandVector &Operands) override;
  //bool ProcessInstruction(MCInst &Inst);

  OperandMatchResultTy parseIntWithPrefix(const char *Prefix, int64_t &Int);
  OperandMatchResultTy parseIntWithPrefix(const char *Prefix,
                                          OperandVector &Operands,
                                          enum AMDGPUOperand::ImmTy ImmTy = AMDGPUOperand::ImmTyNone,
                                          bool (*ConvertResult)(int64_t&) = 0);
  OperandMatchResultTy parseNamedBit(const char *Name, OperandVector &Operands,
                                     enum AMDGPUOperand::ImmTy ImmTy = AMDGPUOperand::ImmTyNone);
  OperandMatchResultTy parseStringWithPrefix(StringRef Prefix, StringRef &Value);

  OperandMatchResultTy parseImm(OperandVector &Operands);
  OperandMatchResultTy parseRegOrImm(OperandVector &Operands);
  OperandMatchResultTy parseRegOrImmWithFPInputMods(OperandVector &Operands);
  OperandMatchResultTy parseRegOrImmWithIntInputMods(OperandVector &Operands);
  OperandMatchResultTy parseVReg32OrOff(OperandVector &Operands);

  void cvtDSOffset01(MCInst &Inst, const OperandVector &Operands);
  void cvtDS(MCInst &Inst, const OperandVector &Operands);
  void cvtExp(MCInst &Inst, const OperandVector &Operands);

  bool parseCnt(int64_t &IntVal);
  OperandMatchResultTy parseSWaitCntOps(OperandVector &Operands);
  OperandMatchResultTy parseHwreg(OperandVector &Operands);

private:
  struct OperandInfoTy {
    int64_t Id;
    bool IsSymbolic;
    OperandInfoTy(int64_t Id_) : Id(Id_), IsSymbolic(false) { }
  };

  bool parseSendMsgConstruct(OperandInfoTy &Msg, OperandInfoTy &Operation, int64_t &StreamId);
  bool parseHwregConstruct(OperandInfoTy &HwReg, int64_t &Offset, int64_t &Width);

  void errorExpTgt();
  OperandMatchResultTy parseExpTgtImpl(StringRef Str, uint8_t &Val);

public:
  OperandMatchResultTy parseOptionalOperand(OperandVector &Operands);

  OperandMatchResultTy parseExpTgt(OperandVector &Operands);
  OperandMatchResultTy parseSendMsgOp(OperandVector &Operands);
  OperandMatchResultTy parseSOppBrTarget(OperandVector &Operands);

  void cvtMubuf(MCInst &Inst, const OperandVector &Operands) { cvtMubufImpl(Inst, Operands, false, false); }
  void cvtMubufAtomic(MCInst &Inst, const OperandVector &Operands) { cvtMubufImpl(Inst, Operands, true, false); }
  void cvtMubufAtomicReturn(MCInst &Inst, const OperandVector &Operands) { cvtMubufImpl(Inst, Operands, true, true); }
  AMDGPUOperand::Ptr defaultGLC() const;
  AMDGPUOperand::Ptr defaultSLC() const;
  AMDGPUOperand::Ptr defaultTFE() const;

  AMDGPUOperand::Ptr defaultDMask() const;
  AMDGPUOperand::Ptr defaultUNorm() const;
  AMDGPUOperand::Ptr defaultDA() const;
  AMDGPUOperand::Ptr defaultR128() const;
  AMDGPUOperand::Ptr defaultLWE() const;
  AMDGPUOperand::Ptr defaultSMRDOffset8() const;
  AMDGPUOperand::Ptr defaultSMRDOffset20() const;
  AMDGPUOperand::Ptr defaultSMRDLiteralOffset() const;
  AMDGPUOperand::Ptr defaultExpTgt() const;
  AMDGPUOperand::Ptr defaultExpCompr() const;
  AMDGPUOperand::Ptr defaultExpVM() const;

  OperandMatchResultTy parseOModOperand(OperandVector &Operands);

  void cvtId(MCInst &Inst, const OperandVector &Operands);
  void cvtVOP3_2_mod(MCInst &Inst, const OperandVector &Operands);
  void cvtVOP3(MCInst &Inst, const OperandVector &Operands);

  void cvtMIMG(MCInst &Inst, const OperandVector &Operands);
  void cvtMIMGAtomic(MCInst &Inst, const OperandVector &Operands);

  OperandMatchResultTy parseDPPCtrl(OperandVector &Operands);
  AMDGPUOperand::Ptr defaultRowMask() const;
  AMDGPUOperand::Ptr defaultBankMask() const;
  AMDGPUOperand::Ptr defaultBoundCtrl() const;
  void cvtDPP(MCInst &Inst, const OperandVector &Operands);

  OperandMatchResultTy parseSDWASel(OperandVector &Operands, StringRef Prefix,
                                    AMDGPUOperand::ImmTy Type);
  OperandMatchResultTy parseSDWADstUnused(OperandVector &Operands);
  void cvtSdwaVOP1(MCInst &Inst, const OperandVector &Operands);
  void cvtSdwaVOP2(MCInst &Inst, const OperandVector &Operands);
  void cvtSdwaVOPC(MCInst &Inst, const OperandVector &Operands);
  void cvtSDWA(MCInst &Inst, const OperandVector &Operands,
               uint64_t BasicInstType);
};

struct OptionalOperand {
  const char *Name;
  AMDGPUOperand::ImmTy Type;
  bool IsBit;
  bool (*ConvertResult)(int64_t&);
};

}

//===----------------------------------------------------------------------===//
// Operand
//===----------------------------------------------------------------------===//

bool AMDGPUOperand::isInlinableImm(MVT type) const {
  if (!isImmTy(ImmTyNone)) {
    // Only plain immediates are inlinable (e.g. "clamp" attribute is not)
    return false;
  }
  // TODO: We should avoid using host float here. It would be better to
  // check the float bit values which is what a few other places do.
  // We've had bot failures before due to weird NaN support on mips hosts.

  APInt Literal(64, Imm.Val);

  if (Imm.IsFPImm) { // We got fp literal token
    if (type == MVT::f64 || type == MVT::i64) { // Expected 64-bit operand
      return AMDGPU::isInlinableLiteral64(Imm.Val, AsmParser->isVI());
    } else { // Expected 32-bit operand
      bool lost;
      APFloat FPLiteral(APFloat::IEEEdouble, Literal);
      // Convert literal to single precision
      APFloat::opStatus status = FPLiteral.convert(APFloat::IEEEsingle,
                                                    APFloat::rmNearestTiesToEven,
                                                    &lost);
      // We allow precision lost but not overflow or underflow
      if (status != APFloat::opOK &&
          lost &&
          ((status & APFloat::opOverflow)  != 0 ||
            (status & APFloat::opUnderflow) != 0)) {
        return false;
      }
      // Check if single precision literal is inlinable
      return AMDGPU::isInlinableLiteral32(
              static_cast<int32_t>(FPLiteral.bitcastToAPInt().getZExtValue()),
              AsmParser->isVI());
    }
  } else { // We got int literal token
    if (type == MVT::f64 || type == MVT::i64) { // Expected 64-bit operand
      return AMDGPU::isInlinableLiteral64(Imm.Val, AsmParser->isVI());
    } else { // Expected 32-bit operand
      return AMDGPU::isInlinableLiteral32(
            static_cast<int32_t>(Literal.getLoBits(32).getZExtValue()),
            AsmParser->isVI());
    }
  }
  return false;
}

bool AMDGPUOperand::isLiteralImm(MVT type) const {
  // Check that this imediate can be added as literal
  if (!isImmTy(ImmTyNone)) {
    return false;
  }

  APInt Literal(64, Imm.Val);

  if (Imm.IsFPImm) { // We got fp literal token
    if (type == MVT::f64) { // Expected 64-bit fp operand
      // We would set low 64-bits of literal to zeroes but we accept this literals
      return true;
    } else if (type == MVT::i64) { // Expected 64-bit int operand
        // We don't allow fp literals in 64-bit integer instructions. It is
        // unclear how we should encode them.
      return false;
    } else { // Expected 32-bit operand
      bool lost;
      APFloat FPLiteral(APFloat::IEEEdouble, Literal);
      // Convert literal to single precision
      APFloat::opStatus status = FPLiteral.convert(APFloat::IEEEsingle,
                                                    APFloat::rmNearestTiesToEven,
                                                    &lost);
      // We allow precision lost but not overflow or underflow
      if (status != APFloat::opOK &&
          lost &&
          ((status & APFloat::opOverflow)  != 0 ||
            (status & APFloat::opUnderflow) != 0)) {
        return false;
      }
      return true;
    }
  } else { // We got int literal token
    APInt HiBits = Literal.getHiBits(32);
    if (HiBits == 0xffffffff &&
        (*Literal.getLoBits(32).getRawData() & 0x80000000) != 0) {
      // If high 32 bits aren't zeroes then they all should be ones and 32nd
      // bit should be set. So that this 64-bit literal is sign-extension of
      // 32-bit value.
      return true;
    } else if (HiBits == 0) {
      return true;
    }
  }
  return false;
}

bool AMDGPUOperand::isRegClass(unsigned RCID) const {
  return isReg() && AsmParser->getMRI()->getRegClass(RCID).contains(getReg());
}

void AMDGPUOperand::addImmOperands(MCInst &Inst, unsigned N, bool ApplyModifiers) const {
  int64_t Val = Imm.Val;
  if (isImmTy(ImmTyNone) && ApplyModifiers && Imm.Mods.hasFPModifiers() && Imm.Mods.Neg) {
    // Apply modifiers to immediate value. Only negate can get here
    if (Imm.IsFPImm) {
      APFloat F(BitsToDouble(Val));
      F.changeSign();
      Val = F.bitcastToAPInt().getZExtValue();
    } else {
      Val = -Val;
    }
  }

  if (AMDGPU::isSISrcOperand(AsmParser->getMII()->get(Inst.getOpcode()), Inst.getNumOperands())) {
    addLiteralImmOperand(Inst, Val);
  } else {
    Inst.addOperand(MCOperand::createImm(Val));
  }
}

void AMDGPUOperand::addLiteralImmOperand(MCInst &Inst, int64_t Val) const {
  const auto& InstDesc = AsmParser->getMII()->get(Inst.getOpcode());
  auto OpNum = Inst.getNumOperands();
  // Check that this operand accepts literals
  assert(AMDGPU::isSISrcOperand(InstDesc, OpNum));

  APInt Literal(64, Val);
  auto OpSize = AMDGPU::getRegOperandSize(AsmParser->getMRI(), InstDesc, OpNum); // expected operand size

  if (Imm.IsFPImm) { // We got fp literal token
    if (OpSize == 8) { // Expected 64-bit operand
      // Check if literal is inlinable
      if (AMDGPU::isInlinableLiteral64(Literal.getZExtValue(), AsmParser->isVI())) {
        Inst.addOperand(MCOperand::createImm(Literal.getZExtValue()));
      } else if (AMDGPU::isSISrcFPOperand(InstDesc, OpNum)) { // Expected 64-bit fp operand
        // For fp operands we check if low 32 bits are zeros
        if (Literal.getLoBits(32) != 0) {
          const_cast<AMDGPUAsmParser *>(AsmParser)->Warning(Inst.getLoc(),
                            "Can't encode literal as exact 64-bit"
                            " floating-point operand. Low 32-bits will be"
                            " set to zero");
        }
        Inst.addOperand(MCOperand::createImm(Literal.lshr(32).getZExtValue()));
      } else {
        // We don't allow fp literals in 64-bit integer instructions. It is
        // unclear how we should encode them. This case should be checked earlier
        // in predicate methods (isLiteralImm())
        llvm_unreachable("fp literal in 64-bit integer instruction.");
      }
    } else { // Expected 32-bit operand
      bool lost;
      APFloat FPLiteral(APFloat::IEEEdouble, Literal);
      // Convert literal to single precision
      FPLiteral.convert(APFloat::IEEEsingle, APFloat::rmNearestTiesToEven, &lost);
      // We allow precision lost but not overflow or underflow. This should be
      // checked earlier in isLiteralImm()
      Inst.addOperand(MCOperand::createImm(FPLiteral.bitcastToAPInt().getZExtValue()));
    }
  } else { // We got int literal token
    if (OpSize == 8) { // Expected 64-bit operand
      auto LiteralVal = Literal.getZExtValue();
      if (AMDGPU::isInlinableLiteral64(LiteralVal, AsmParser->isVI())) {
        Inst.addOperand(MCOperand::createImm(LiteralVal));
        return;
      }
    } else { // Expected 32-bit operand
      auto LiteralVal = static_cast<int32_t>(Literal.getLoBits(32).getZExtValue());
      if (AMDGPU::isInlinableLiteral32(LiteralVal, AsmParser->isVI())) {
        Inst.addOperand(MCOperand::createImm(LiteralVal));
        return;
      }
    }
    Inst.addOperand(MCOperand::createImm(Literal.getLoBits(32).getZExtValue()));
  }
}

void AMDGPUOperand::addKImmFP32Operands(MCInst &Inst, unsigned N) const {
  APInt Literal(64, Imm.Val);
  if (Imm.IsFPImm) { // We got fp literal
    bool lost;
    APFloat FPLiteral(APFloat::IEEEdouble, Literal);
    FPLiteral.convert(APFloat::IEEEsingle, APFloat::rmNearestTiesToEven, &lost);
    Inst.addOperand(MCOperand::createImm(FPLiteral.bitcastToAPInt().getZExtValue()));
  } else { // We got int literal token
    Inst.addOperand(MCOperand::createImm(Literal.getLoBits(32).getZExtValue()));
  }
}

void AMDGPUOperand::addRegOperands(MCInst &Inst, unsigned N) const {
  Inst.addOperand(MCOperand::createReg(AMDGPU::getMCReg(getReg(), AsmParser->getSTI())));
}

//===----------------------------------------------------------------------===//
// AsmParser
//===----------------------------------------------------------------------===//

static int getRegClass(RegisterKind Is, unsigned RegWidth) {
  if (Is == IS_VGPR) {
    switch (RegWidth) {
      default: return -1;
      case 1: return AMDGPU::VGPR_32RegClassID;
      case 2: return AMDGPU::VReg_64RegClassID;
      case 3: return AMDGPU::VReg_96RegClassID;
      case 4: return AMDGPU::VReg_128RegClassID;
      case 8: return AMDGPU::VReg_256RegClassID;
      case 16: return AMDGPU::VReg_512RegClassID;
    }
  } else if (Is == IS_TTMP) {
    switch (RegWidth) {
      default: return -1;
      case 1: return AMDGPU::TTMP_32RegClassID;
      case 2: return AMDGPU::TTMP_64RegClassID;
      case 4: return AMDGPU::TTMP_128RegClassID;
    }
  } else if (Is == IS_SGPR) {
    switch (RegWidth) {
      default: return -1;
      case 1: return AMDGPU::SGPR_32RegClassID;
      case 2: return AMDGPU::SGPR_64RegClassID;
      case 4: return AMDGPU::SGPR_128RegClassID;
      case 8: return AMDGPU::SReg_256RegClassID;
      case 16: return AMDGPU::SReg_512RegClassID;
    }
  }
  return -1;
}

static unsigned getSpecialRegForName(StringRef RegName) {
  return StringSwitch<unsigned>(RegName)
    .Case("exec", AMDGPU::EXEC)
    .Case("vcc", AMDGPU::VCC)
    .Case("flat_scratch", AMDGPU::FLAT_SCR)
    .Case("m0", AMDGPU::M0)
    .Case("scc", AMDGPU::SCC)
    .Case("tba", AMDGPU::TBA)
    .Case("tma", AMDGPU::TMA)
    .Case("flat_scratch_lo", AMDGPU::FLAT_SCR_LO)
    .Case("flat_scratch_hi", AMDGPU::FLAT_SCR_HI)
    .Case("vcc_lo", AMDGPU::VCC_LO)
    .Case("vcc_hi", AMDGPU::VCC_HI)
    .Case("exec_lo", AMDGPU::EXEC_LO)
    .Case("exec_hi", AMDGPU::EXEC_HI)
    .Case("tma_lo", AMDGPU::TMA_LO)
    .Case("tma_hi", AMDGPU::TMA_HI)
    .Case("tba_lo", AMDGPU::TBA_LO)
    .Case("tba_hi", AMDGPU::TBA_HI)
    .Default(0);
}

bool AMDGPUAsmParser::ParseRegister(unsigned &RegNo, SMLoc &StartLoc, SMLoc &EndLoc) {
  auto R = parseRegister();
  if (!R) return true;
  assert(R->isReg());
  RegNo = R->getReg();
  StartLoc = R->getStartLoc();
  EndLoc = R->getEndLoc();
  return false;
}

bool AMDGPUAsmParser::AddNextRegisterToList(unsigned& Reg, unsigned& RegWidth, RegisterKind RegKind, unsigned Reg1, unsigned RegNum)
{
  switch (RegKind) {
  case IS_SPECIAL:
    if (Reg == AMDGPU::EXEC_LO && Reg1 == AMDGPU::EXEC_HI) { Reg = AMDGPU::EXEC; RegWidth = 2; return true; }
    if (Reg == AMDGPU::FLAT_SCR_LO && Reg1 == AMDGPU::FLAT_SCR_HI) { Reg = AMDGPU::FLAT_SCR; RegWidth = 2; return true; }
    if (Reg == AMDGPU::VCC_LO && Reg1 == AMDGPU::VCC_HI) { Reg = AMDGPU::VCC; RegWidth = 2; return true; }
    if (Reg == AMDGPU::TBA_LO && Reg1 == AMDGPU::TBA_HI) { Reg = AMDGPU::TBA; RegWidth = 2; return true; }
    if (Reg == AMDGPU::TMA_LO && Reg1 == AMDGPU::TMA_HI) { Reg = AMDGPU::TMA; RegWidth = 2; return true; }
    return false;
  case IS_VGPR:
  case IS_SGPR:
  case IS_TTMP:
    if (Reg1 != Reg + RegWidth) { return false; }
    RegWidth++;
    return true;
  default:
    llvm_unreachable("unexpected register kind");
  }
}

bool AMDGPUAsmParser::ParseAMDGPURegister(RegisterKind& RegKind, unsigned& Reg, unsigned& RegNum, unsigned& RegWidth)
{
  const MCRegisterInfo *TRI = getContext().getRegisterInfo();
  if (getLexer().is(AsmToken::Identifier)) {
    StringRef RegName = Parser.getTok().getString();
    if ((Reg = getSpecialRegForName(RegName))) {
      Parser.Lex();
      RegKind = IS_SPECIAL;
    } else {
      unsigned RegNumIndex = 0;
      if (RegName[0] == 'v') {
        RegNumIndex = 1;
        RegKind = IS_VGPR;
      } else if (RegName[0] == 's') {
        RegNumIndex = 1;
        RegKind = IS_SGPR;
      } else if (RegName.startswith("ttmp")) {
        RegNumIndex = strlen("ttmp");
        RegKind = IS_TTMP;
      } else {
        return false;
      }
      if (RegName.size() > RegNumIndex) {
        // Single 32-bit register: vXX.
        if (RegName.substr(RegNumIndex).getAsInteger(10, RegNum))
          return false;
        Parser.Lex();
        RegWidth = 1;
      } else {
        // Range of registers: v[XX:YY]. ":YY" is optional.
        Parser.Lex();
        int64_t RegLo, RegHi;
        if (getLexer().isNot(AsmToken::LBrac))
          return false;
        Parser.Lex();

        if (getParser().parseAbsoluteExpression(RegLo))
          return false;

        const bool isRBrace = getLexer().is(AsmToken::RBrac);
        if (!isRBrace && getLexer().isNot(AsmToken::Colon))
          return false;
        Parser.Lex();

        if (isRBrace) {
          RegHi = RegLo;
        } else {
          if (getParser().parseAbsoluteExpression(RegHi))
            return false;

          if (getLexer().isNot(AsmToken::RBrac))
            return false;
          Parser.Lex();
        }
        RegNum = (unsigned) RegLo;
        RegWidth = (RegHi - RegLo) + 1;
      }
    }
  } else if (getLexer().is(AsmToken::LBrac)) {
    // List of consecutive registers: [s0,s1,s2,s3]
    Parser.Lex();
    if (!ParseAMDGPURegister(RegKind, Reg, RegNum, RegWidth))
      return false;
    if (RegWidth != 1)
      return false;
    RegisterKind RegKind1;
    unsigned Reg1, RegNum1, RegWidth1;
    do {
      if (getLexer().is(AsmToken::Comma)) {
        Parser.Lex();
      } else if (getLexer().is(AsmToken::RBrac)) {
        Parser.Lex();
        break;
      } else if (ParseAMDGPURegister(RegKind1, Reg1, RegNum1, RegWidth1)) {
        if (RegWidth1 != 1) {
          return false;
        }
        if (RegKind1 != RegKind) {
          return false;
        }
        if (!AddNextRegisterToList(Reg, RegWidth, RegKind1, Reg1, RegNum1)) {
          return false;
        }
      } else {
        return false;
      }
    } while (true);
  } else {
    return false;
  }
  switch (RegKind) {
  case IS_SPECIAL:
    RegNum = 0;
    RegWidth = 1;
    break;
  case IS_VGPR:
  case IS_SGPR:
  case IS_TTMP:
  {
    unsigned Size = 1;
    if (RegKind == IS_SGPR || RegKind == IS_TTMP) {
      // SGPR and TTMP registers must be are aligned. Max required alignment is 4 dwords.
      Size = std::min(RegWidth, 4u);
    }
    if (RegNum % Size != 0)
      return false;
    RegNum = RegNum / Size;
    int RCID = getRegClass(RegKind, RegWidth);
    if (RCID == -1)
      return false;
    const MCRegisterClass RC = TRI->getRegClass(RCID);
    if (RegNum >= RC.getNumRegs())
      return false;
    Reg = RC.getRegister(RegNum);
    break;
  }

  default:
    llvm_unreachable("unexpected register kind");
  }

  if (!subtargetHasRegister(*TRI, Reg))
    return false;
  return true;
}

std::unique_ptr<AMDGPUOperand> AMDGPUAsmParser::parseRegister() {
  const auto &Tok = Parser.getTok();
  SMLoc StartLoc = Tok.getLoc();
  SMLoc EndLoc = Tok.getEndLoc();
  RegisterKind RegKind;
  unsigned Reg, RegNum, RegWidth;

  if (!ParseAMDGPURegister(RegKind, Reg, RegNum, RegWidth)) {
    return nullptr;
  }
  return AMDGPUOperand::CreateReg(this, Reg, StartLoc, EndLoc, false);
}

OperandMatchResultTy
AMDGPUAsmParser::parseImm(OperandVector &Operands) {
  // TODO: add syntactic sugar for 1/(2*PI)
  bool Minus = false;
  if (getLexer().getKind() == AsmToken::Minus) {
    Minus = true;
    Parser.Lex();
  }

  SMLoc S = Parser.getTok().getLoc();
  switch(getLexer().getKind()) {
  case AsmToken::Integer: {
    int64_t IntVal;
    if (getParser().parseAbsoluteExpression(IntVal))
      return MatchOperand_ParseFail;
    if (Minus)
      IntVal *= -1;
    Operands.push_back(AMDGPUOperand::CreateImm(this, IntVal, S));
    return MatchOperand_Success;
  }
  case AsmToken::Real: {
    int64_t IntVal;
    if (getParser().parseAbsoluteExpression(IntVal))
      return MatchOperand_ParseFail;

    APFloat F(BitsToDouble(IntVal));
    if (Minus)
      F.changeSign();
    Operands.push_back(
        AMDGPUOperand::CreateImm(this, F.bitcastToAPInt().getZExtValue(), S,
                                 AMDGPUOperand::ImmTyNone, true));
    return MatchOperand_Success;
  }
  default:
    return Minus ? MatchOperand_ParseFail : MatchOperand_NoMatch;
  }
}

OperandMatchResultTy
AMDGPUAsmParser::parseRegOrImm(OperandVector &Operands) {
  auto res = parseImm(Operands);
  if (res != MatchOperand_NoMatch) {
    return res;
  }

  if (auto R = parseRegister()) {
    assert(R->isReg());
    R->Reg.IsForcedVOP3 = isForcedVOP3();
    Operands.push_back(std::move(R));
    return MatchOperand_Success;
  }
  return MatchOperand_ParseFail;
}

OperandMatchResultTy
AMDGPUAsmParser::parseRegOrImmWithFPInputMods(OperandVector &Operands) {
  // XXX: During parsing we can't determine if minus sign means
  // negate-modifier or negative immediate value.
  // By default we suppose it is modifier.
  bool Negate = false, Abs = false, Abs2 = false;

  if (getLexer().getKind()== AsmToken::Minus) {
    Parser.Lex();
    Negate = true;
  }

  if (getLexer().getKind() == AsmToken::Identifier && Parser.getTok().getString() == "abs") {
    Parser.Lex();
    Abs2 = true;
    if (getLexer().isNot(AsmToken::LParen)) {
      Error(Parser.getTok().getLoc(), "expected left paren after abs");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
  }

  if (getLexer().getKind() == AsmToken::Pipe) {
    if (Abs2) {
      Error(Parser.getTok().getLoc(), "expected register or immediate");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
    Abs = true;
  }

  auto Res = parseRegOrImm(Operands);
  if (Res != MatchOperand_Success) {
    return Res;
  }

  AMDGPUOperand::Modifiers Mods;
  if (Negate) {
    Mods.Neg = true;
  }
  if (Abs) {
    if (getLexer().getKind() != AsmToken::Pipe) {
      Error(Parser.getTok().getLoc(), "expected vertical bar");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
    Mods.Abs = true;
  }
  if (Abs2) {
    if (getLexer().isNot(AsmToken::RParen)) {
      Error(Parser.getTok().getLoc(), "expected closing parentheses");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
    Mods.Abs = true;
  }

  if (Mods.hasFPModifiers()) {
    AMDGPUOperand &Op = static_cast<AMDGPUOperand &>(*Operands.back());
    Op.setModifiers(Mods);
  }
  return MatchOperand_Success;
}

OperandMatchResultTy
AMDGPUAsmParser::parseRegOrImmWithIntInputMods(OperandVector &Operands) {
  bool Sext = false;

  if (getLexer().getKind() == AsmToken::Identifier && Parser.getTok().getString() == "sext") {
    Parser.Lex();
    Sext = true;
    if (getLexer().isNot(AsmToken::LParen)) {
      Error(Parser.getTok().getLoc(), "expected left paren after sext");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
  }

  auto Res = parseRegOrImm(Operands);
  if (Res != MatchOperand_Success) {
    return Res;
  }

  AMDGPUOperand::Modifiers Mods;
  if (Sext) {
    if (getLexer().isNot(AsmToken::RParen)) {
      Error(Parser.getTok().getLoc(), "expected closing parentheses");
      return MatchOperand_ParseFail;
    }
    Parser.Lex();
    Mods.Sext = true;
  }

  if (Mods.hasIntModifiers()) {
    AMDGPUOperand &Op = static_cast<AMDGPUOperand &>(*Operands.back());
    Op.setModifiers(Mods);
  }

  return MatchOperand_Success;
}

OperandMatchResultTy AMDGPUAsmParser::parseVReg32OrOff(OperandVector &Operands) {
  std::unique_ptr<AMDGPUOperand> Reg = parseRegister();
  if (Reg) {
    Operands.push_back(std::move(Reg));
    return MatchOperand_Success;
  }

  const AsmToken &Tok = Parser.getTok();
  if (Tok.getString() == "off") {
    Operands.push_back(AMDGPUOperand::CreateImm(this, 0, Tok.getLoc(),
                                                AMDGPUOperand::ImmTyOff, false));
    Parser.Lex();
    return MatchOperand_Success;
  }

  return MatchOperand_NoMatch;
}

unsigned AMDGPUAsmParser::checkTargetMatchPredicate(MCInst &Inst) {

  uint64_t TSFlags = MII.get(Inst.getOpcode()).TSFlags;

  if ((getForcedEncodingSize() == 32 && (TSFlags & SIInstrFlags::VOP3)) ||
      (getForcedEncodingSize() == 64 && !(TSFlags & SIInstrFlags::VOP3)) ||
      (isForcedDPP() && !(TSFlags & SIInstrFlags::DPP)) ||
      (isForcedSDWA() && !(TSFlags & SIInstrFlags::SDWA)) )
    return Match_InvalidOperand;

  if ((TSFlags & SIInstrFlags::VOP3) &&
      (TSFlags & SIInstrFlags::VOPAsmPrefer32Bit) &&
      getForcedEncodingSize() != 64)
    return Match_PreferE32;

  if (Inst.getOpcode() == AMDGPU::V_MAC_F32_sdwa ||
      Inst.getOpcode() == AMDGPU::V_MAC_F16_sdwa) {
    // v_mac_f32/16 allow only dst_sel == DWORD;
    auto OpNum =
        AMDGPU::getNamedOperandIdx(Inst.getOpcode(), AMDGPU::OpName::dst_sel);
    const auto &Op = Inst.getOperand(OpNum);
    if (!Op.isImm() || Op.getImm() != AMDGPU::SDWA::SdwaSel::DWORD) {
      return Match_InvalidOperand;
    }
  }

  return Match_Success;
}

bool AMDGPUAsmParser::MatchAndEmitInstruction(SMLoc IDLoc, unsigned &Opcode,
                                              OperandVector &Operands,
                                              MCStreamer &Out,
                                              uint64_t &ErrorInfo,
                                              bool MatchingInlineAsm) {
  // What asm variants we should check
  std::vector<unsigned> MatchedVariants;
  if (getForcedEncodingSize() == 32) {
    MatchedVariants = {AMDGPUAsmVariants::DEFAULT};
  } else if (isForcedVOP3()) {
    MatchedVariants = {AMDGPUAsmVariants::VOP3};
  } else if (isForcedSDWA()) {
    MatchedVariants = {AMDGPUAsmVariants::SDWA};
  } else if (isForcedDPP()) {
    MatchedVariants = {AMDGPUAsmVariants::DPP};
  } else {
    MatchedVariants = {AMDGPUAsmVariants::DEFAULT,
                       AMDGPUAsmVariants::VOP3,
                       AMDGPUAsmVariants::SDWA,
                       AMDGPUAsmVariants::DPP};
  }

  MCInst Inst;
  unsigned Result = Match_Success;
  for (auto Variant : MatchedVariants) {
    uint64_t EI;
    auto R = MatchInstructionImpl(Operands, Inst, EI, MatchingInlineAsm,
                                  Variant);
    // We order match statuses from least to most specific. We use most specific
    // status as resulting
    // Match_MnemonicFail < Match_InvalidOperand < Match_MissingFeature < Match_PreferE32
    if ((R == Match_Success) ||
        (R == Match_PreferE32) ||
        (R == Match_MissingFeature && Result != Match_PreferE32) ||
        (R == Match_InvalidOperand && Result != Match_MissingFeature
                                   && Result != Match_PreferE32) ||
        (R == Match_MnemonicFail   && Result != Match_InvalidOperand
                                   && Result != Match_MissingFeature
                                   && Result != Match_PreferE32)) {
      Result = R;
      ErrorInfo = EI;
    }
    if (R == Match_Success)
      break;
  }

  switch (Result) {
  default: break;
  case Match_Success:
    Inst.setLoc(IDLoc);
    Out.EmitInstruction(Inst, getSTI());
    return false;

  case Match_MissingFeature:
    return Error(IDLoc, "instruction not supported on this GPU");

  case Match_MnemonicFail:
    return Error(IDLoc, "unrecognized instruction mnemonic");

  case Match_InvalidOperand: {
    SMLoc ErrorLoc = IDLoc;
    if (ErrorInfo != ~0ULL) {
      if (ErrorInfo >= Operands.size()) {
        return Error(IDLoc, "too few operands for instruction");
      }
      ErrorLoc = ((AMDGPUOperand &)*Operands[ErrorInfo]).getStartLoc();
      if (ErrorLoc == SMLoc())
        ErrorLoc = IDLoc;
    }
    return Error(ErrorLoc, "invalid operand for instruction");
  }

  case Match_PreferE32:
    return Error(IDLoc, "internal error: instruction without _e64 suffix "
                        "should be encoded as e32");
  }
  llvm_unreachable("Implement any new match types added!");
}

bool AMDGPUAsmParser::ParseDirectiveMajorMinor(uint32_t &Major,
                                               uint32_t &Minor) {
  if (getLexer().isNot(AsmToken::Integer))
    return TokError("invalid major version");

  Major = getLexer().getTok().getIntVal();
  Lex();

  if (getLexer().isNot(AsmToken::Comma))
    return TokError("minor version number required, comma expected");
  Lex();

  if (getLexer().isNot(AsmToken::Integer))
    return TokError("invalid minor version");

  Minor = getLexer().getTok().getIntVal();
  Lex();

  return false;
}

bool AMDGPUAsmParser::ParseDirectiveHSACodeObjectVersion() {

  uint32_t Major;
  uint32_t Minor;

  if (ParseDirectiveMajorMinor(Major, Minor))
    return true;

  getTargetStreamer().EmitDirectiveHSACodeObjectVersion(Major, Minor);
  return false;
}

bool AMDGPUAsmParser::ParseDirectiveHSACodeObjectISA() {

  uint32_t Major;
  uint32_t Minor;
  uint32_t Stepping;
  StringRef VendorName;
  StringRef ArchName;

  // If this directive has no arguments, then use the ISA version for the
  // targeted GPU.
  if (getLexer().is(AsmToken::EndOfStatement)) {
    AMDGPU::IsaVersion Isa = AMDGPU::getIsaVersion(getSTI().getFeatureBits());
    getTargetStreamer().EmitDirectiveHSACodeObjectISA(Isa.Major, Isa.Minor,
                                                      Isa.Stepping,
                                                      "AMD", "AMDGPU");
    return false;
  }


  if (ParseDirectiveMajorMinor(Major, Minor))
    return true;

  if (getLexer().isNot(AsmToken::Comma))
    return TokError("stepping version number required, comma expected");
  Lex();

  if (getLexer().isNot(AsmToken::Integer))
    return TokError("invalid stepping version");

  Stepping = getLexer().getTok().getIntVal();
  Lex();

  if (getLexer().isNot(AsmToken::Comma))
    return TokError("vendor name required, comma expected");
  Lex();

  if (getLexer().isNot(AsmToken::String))
    return TokError("invalid vendor name");

  VendorName = getLexer().getTok().getStringContents();
  Lex();

  if (getLexer().isNot(AsmToken::Comma))
    return TokError("arch name required, comma expected");
  Lex();

  if (getLexer().isNot(AsmToken::String))
    return TokError("invalid arch name");

  ArchName = getLexer().getTok().getStringContents();
  Lex();

  getTargetStreamer().EmitDirectiveHSACodeObjectISA(Major, Minor, Stepping,
                                                    VendorName, ArchName);
  return false;
}

bool AMDGPUAsmParser::ParseAMDKernelCodeTValue(StringRef ID,
                                               amd_kernel_code_t &Header) {
  SmallString<40> ErrStr;
  raw_svector_ostream Err(ErrStr);
  if (!parseAmdKernelCodeField(ID, getParser(), Header, Err)) {
    return TokError(Err.str());
  }
  Lex();
  return false;
}

bool AMDGPUAsmParser::ParseDirectiveAMDKernelCodeT() {

  amd_kernel_code_t Header;
  AMDGPU::initDefaultAMDKernelCodeT(Header, getSTI().getFeatureBits());

  while (true) {

    // Lex EndOfStatement.  This is in a while loop, because lexing a comment
    // will set the current token to EndOfStatement.
    while(getLexer().is(AsmToken::EndOfStatement))
      Lex();

    if (getLexer().isNot(AsmToken::Identifier))
      return TokError("expected value identifier or .end_amd_kernel_code_t");

    StringRef ID = getLexer().getTok().getIdentifier();
    Lex();

    if (ID == ".end_amd_kernel_code_t")
      break;

    if (ParseAMDKernelCodeTValue(ID, Header))
      return true;
  }

  getTargetStreamer().EmitAMDKernelCodeT(Header);

  return false;
}

bool AMDGPUAsmParser::ParseSectionDirectiveHSAText() {
  getParser().getStreamer().SwitchSection(
      AMDGPU::getHSATextSection(getContext()));
  return false;
}

bool AMDGPUAsmParser::ParseDirectiveAMDGPUHsaKernel() {
  if (getLexer().isNot(AsmToken::Identifier))
    return TokError("expected symbol name");

  StringRef KernelName = Parser.getTok().getString();

  getTargetStreamer().EmitAMDGPUSymbolType(KernelName,
                                           ELF::STT_AMDGPU_HSA_KERNEL);
  Lex();
  return false;
}

bool AMDGPUAsmParser::ParseDirectiveAMDGPUHsaModuleGlobal() {
  if (getLexer().isNot(AsmToken::Identifier))
    return TokError("expected symbol name");

  StringRef GlobalName = Parser.getTok().getIdentifier();

  getTargetStreamer().EmitAMDGPUHsaModuleScopeGlobal(GlobalName);
  Lex();
  return false;
}

bool AMDGPUAsmParser::ParseDirectiveAMDGPUHsaProgramGlobal() {
  if (getLexer().isNot(AsmToken::Identifier))
    return TokError("expected symbol name");

  StringRef GlobalName = Parser.getTok().getIdentifier();

  getTargetStreamer().EmitAMDGPUHsaProgramScopeGlobal(GlobalName);
  Lex();
  return false;
}

bool AMDGPUAsmParser::ParseSectionDirectiveHSADataGlobalAgent() {
  getParser().getStreamer().SwitchSection(
      AMDGPU::getHSADataGlobalAgentSection(getContext()));
  return false;
}

bool AMDGPUAsmParser::ParseSectionDirectiveHSADataGlobalProgram() {
  getParser().getStreamer().SwitchSection(
      AMDGPU::getHSADataGlobalProgramSection(getContext()));
  return false;
}

bool AMDGPUAsmParser::ParseSectionDirectiveHSARodataReadonlyAgent() {
  getParser().getStreamer().SwitchSection(
      AMDGPU::getHSARodataReadonlyAgentSection(getContext()));
  return false;
}

bool AMDGPUAsmParser::ParseDirective(AsmToken DirectiveID) {
  StringRef IDVal = DirectiveID.getString();

  if (IDVal == ".hsa_code_object_version")
    return ParseDirectiveHSACodeObjectVersion();

  if (IDVal == ".hsa_code_object_isa")
    return ParseDirectiveHSACodeObjectISA();

  if (IDVal == ".amd_kernel_code_t")
    return ParseDirectiveAMDKernelCodeT();

  if (IDVal == ".hsatext")
    return ParseSectionDirectiveHSAText();

  if (IDVal == ".amdgpu_hsa_kernel")
    return ParseDirectiveAMDGPUHsaKernel();

  if (IDVal == ".amdgpu_hsa_module_global")
    return ParseDirectiveAMDGPUHsaModuleGlobal();

  if (IDVal == ".amdgpu_hsa_program_global")
    return ParseDirectiveAMDGPUHsaProgramGlobal();

  if (IDVal == ".hsadata_global_agent")
    return ParseSectionDirectiveHSADataGlobalAgent();

  if (IDVal == ".hsadata_global_program")
    return ParseSectionDirectiveHSADataGlobalProgram();

  if (IDVal == ".hsarodata_readonly_agent")
    return ParseSectionDirectiveHSARodataReadonlyAgent();

  return true;
}

bool AMDGPUAsmParser::subtargetHasRegister(const MCRegisterInfo &MRI,
                                           unsigned RegNo) const {
  if (isCI())
    return true;

  if (isSI()) {
    // No flat_scr
    switch (RegNo) {
    case AMDGPU::FLAT_SCR:
    case AMDGPU::FLAT_SCR_LO:
    case AMDGPU::FLAT_SCR_HI:
      return false;
    default:
      return true;
    }
  }

  // VI only has 102 SGPRs, so make sure we aren't trying to use the 2 more that
  // SI/CI have.
  for (MCRegAliasIterator R(AMDGPU::SGPR102_SGPR103, &MRI, true);
       R.isValid(); ++R) {
    if (*R == RegNo)
      return false;
  }

  return true;
}

OperandMatchResultTy
AMDGPUAsmParser::parseOperand(OperandVector &Operands, StringRef Mnemonic) {

  // Try to parse with a custom parser
  OperandMatchResultTy ResTy = MatchOperandParserImpl(Operands, Mnemonic);

  // If we successfully parsed the operand or if there as an error parsing,
  // we are done.
  //
  // If we are parsing after we reach EndOfStatement then this means we
  // are appending default values to the Operands list.  This is only done
  // by custom parser, so we shouldn't continue on to the generic parsing.
  if (ResTy == MatchOperand_Success || ResTy == MatchOperand_ParseFail ||
      getLexer().is(AsmToken::EndOfStatement))
    return ResTy;

  ResTy = parseRegOrImm(Operands);

  if (ResTy == MatchOperand_Success)
    return ResTy;

  if (getLexer().getKind() == AsmToken::Identifier) {
    // If this identifier is a symbol, we want to create an expression for it.
    // It is a little difficult to distinguish between a symbol name, and
    // an instruction flag like 'gds'.  In order to do this, we parse
    // all tokens as expressions and then treate the symbol name as the token
    // string when we want to interpret the operand as a token.
    const auto &Tok = Parser.getTok();
    SMLoc S = Tok.getLoc();
    const MCExpr *Expr = nullptr;
    if (!Parser.parseExpression(Expr)) {
      Operands.push_back(AMDGPUOperand::CreateExpr(this, Expr, S));
      return MatchOperand_Success;
    }

    Operands.push_back(AMDGPUOperand::CreateToken(this, Tok.getString(), Tok.getLoc()));
    Parser.Lex();
    return MatchOperand_Success;
  }
  return MatchOperand_NoMatch;
}

StringRef AMDGPUAsmParser::parseMnemonicSuffix(StringRef Name) {
  // Clear any forced encodings from the previous instruction.
  setForcedEncodingSize(0);
  setForcedDPP(false);
  setForcedSDWA(false);

  if (Name.endswith("_e64")) {
    setForcedEncodingSize(64);
    return Name.substr(0, Name.size() - 4);
  } else if (Name.endswith("_e32")) {
    setForcedEncodingSize(32);
    return Name.substr(0, Name.size() - 4);
  } else if (Name.endswith("_dpp")) {
    setForcedDPP(true);
    return Name.substr(0, Name.size() - 4);
  } else if (Name.endswith("_sdwa")) {
    setForcedSDWA(true);
    return Name.substr(0, Name.size() - 5);
  }
  return Name;
}

bool AMDGPUAsmParser::ParseInstruction(ParseInstructionInfo &Info,
                                       StringRef Name,
                                       SMLoc NameLoc, OperandVector &Operands) {
  // Add the instruction mnemonic
  Name = parseMnemonicSuffix(Name);
  Operands.push_back(AMDGPUOperand::CreateToken(this, Name, NameLoc));

  while (!getLexer().is(AsmToken::EndOfStatement)) {
    OperandMatchResultTy Res = parseOperand(Operands, Name);

    // Eat the comma or space if there is one.
    if (getLexer().is(AsmToken::Comma))
      Parser.Lex();

    switch (Res) {
      case MatchOperand_Success: break;
      case MatchOperand_ParseFail:
        Error(getLexer().getLoc(), "failed parsing operand.");
        while (!getLexer().is(AsmToken::EndOfStatement)) {
          Parser.Lex();
        }
        return true;
      case MatchOperand_NoMatch:
        Error(getLexer().getLoc(), "not a valid operand.");
        while (!getLexer().is(AsmToken::EndOfStatement)) {
          Parser.Lex();
        }
        return true;
    }
  }

  return false;
}

//===----------------------------------------------------------------------===//
// Utility functions
//===----------------------------------------------------------------------===//

OperandMatchResultTy
AMDGPUAsmParser::parseIntWithPrefix(const char *Prefix, int64_t &Int) {
  switch(getLexer().getKind()) {
    default: return MatchOperand_NoMatch;
    case AsmToken::Identifier: {
      StringRef Name = Parser.getTok().getString();
      if (!Name.equals(Prefix)) {
        return MatchOperand_NoMatch;
      }

      Parser.Lex();
      if (getLexer().isNot(AsmToken::Colon))
        return MatchOperand_ParseFail;

      Parser.Lex();
      if (getLexer().isNot(AsmToken::Integer))
        return MatchOperand_ParseFail;

      if (getParser().parseAbsoluteExpression(Int))
        return MatchOperand_ParseFail;
      break;
    }
  }
  return MatchOperand_Success;
}

OperandMatchResultTy
AMDGPUAsmParser::parseIntWithPrefix(const char *Prefix, OperandVector &Operands,
                                    enum AMDGPUOperand::ImmTy ImmTy,
                                    bool (*ConvertResult)(int64_t&)) {
  SMLoc S = Parser.getTok().getLoc();
  int64_t Value = 0;

  OperandMatchResultTy Res = parseIntWithPrefix(Prefix, Value);
  if (Res != MatchOperand_Success)
    return Res;

  if (ConvertResult && !ConvertResult(Value)) {
    return MatchOperand_ParseFail;
  }

  Operands.push_back(AMDGPUOperand::CreateImm(this, Value, S, ImmTy));
  return MatchOperand_Success;
}

OperandMatchResultTy
AMDGPUAsmParser::parseNamedBit(const char *Name, OperandVector &Operands,
                               enum AMDGPUOperand::ImmTy ImmTy) {
  int64_t Bit = 0;
  SMLoc S = Parser.getTok().getLoc();

  // We are at the end of the statement, and this is a default argument, so
  // use a default value.
  if (getLexer().isNot(AsmToken::EndOfStatement)) {
    switch(getLexer().getKind()) {
      case AsmToken::Identifier: {
        StringRef Tok = Parser.getTok().getString();
        if (Tok == Name) {
          Bit = 1;
          Parser.Lex();
        } else if (Tok.startswith("no") && Tok.endswith(Name)) {
          Bit = 0;
          Parser.Lex();
        } else {
          return MatchOperand_NoMatch;
        }
        break;
      }
      default:
        return MatchOperand_NoMatch;
    }
  }

  Operands.push_back(AMDGPUOperand::CreateImm(this, Bit, S, ImmTy));
  return MatchOperand_Success;
}

typedef std::map<enum AMDGPUOperand::ImmTy, unsigned> OptionalImmIndexMap;

void addOptionalImmOperand(MCInst& Inst, const OperandVector& Operands,
                           OptionalImmIndexMap& OptionalIdx,
                           enum AMDGPUOperand::ImmTy ImmT, int64_t Default = 0) {
  auto i = OptionalIdx.find(ImmT);
  if (i != OptionalIdx.end()) {
    unsigned Idx = i->second;
    ((AMDGPUOperand &)*Operands[Idx]).addImmOperands(Inst, 1);
  } else {
    Inst.addOperand(MCOperand::createImm(Default));
  }
}

OperandMatchResultTy
AMDGPUAsmParser::parseStringWithPrefix(StringRef Prefix, StringRef &Value) {
  if (getLexer().isNot(AsmToken::Identifier)) {
    return MatchOperand_NoMatch;
  }
  StringRef Tok = Parser.getTok().getString();
  if (Tok != Prefix) {
    return MatchOperand_NoMatch;
  }

  Parser.Lex();
  if (getLexer().isNot(AsmToken::Colon)) {
    return MatchOperand_ParseFail;
  }

  Parser.Lex();
  if (getLexer().isNot(AsmToken::Identifier)) {
    return MatchOperand_ParseFail;
  }

  Value = Parser.getTok().getString();
  return MatchOperand_Success;
}

//===----------------------------------------------------------------------===//
// ds
//===----------------------------------------------------------------------===//

void AMDGPUAsmParser::cvtDSOffset01(MCInst &Inst,
                                    const OperandVector &Operands) {

  OptionalImmIndexMap OptionalIdx;

  for (unsigned i = 1, e = Operands.size(); i != e; ++i) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[i]);

    // Add the register arguments
    if (Op.isReg()) {
      Op.addRegOperands(Inst, 1);
      continue;
    }

    // Handle optional arguments
    OptionalIdx[Op.getImmTy()] = i;
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyOffset0);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyOffset1);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGDS);

  Inst.addOperand(MCOperand::createReg(AMDGPU::M0)); // m0
}

void AMDGPUAsmParser::cvtDS(MCInst &Inst, const OperandVector &Operands) {

  std::map<enum AMDGPUOperand::ImmTy, unsigned> OptionalIdx;
  bool GDSOnly = false;

  for (unsigned i = 1, e = Operands.size(); i != e; ++i) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[i]);

    // Add the register arguments
    if (Op.isReg()) {
      Op.addRegOperands(Inst, 1);
      continue;
    }

    if (Op.isToken() && Op.getToken() == "gds") {
      GDSOnly = true;
      continue;
    }

    // Handle optional arguments
    OptionalIdx[Op.getImmTy()] = i;
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyOffset);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGDS);

  if (!GDSOnly) {
    addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGDS);
  }
  Inst.addOperand(MCOperand::createReg(AMDGPU::M0)); // m0
}

void AMDGPUAsmParser::cvtExp(MCInst &Inst, const OperandVector &Operands) {
  OptionalImmIndexMap OptionalIdx;

  unsigned EnMask = 0;
  int SrcIdx = 0;

  for (unsigned i = 1, e = Operands.size(); i != e; ++i) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[i]);

    // Add the register arguments
    if (Op.isReg()) {
      EnMask |= (1 << SrcIdx);
      Op.addRegOperands(Inst, 1);
      ++SrcIdx;
      continue;
    }

    if (Op.isOff()) {
      ++SrcIdx;
      Inst.addOperand(MCOperand::createReg(AMDGPU::NoRegister));
      continue;
    }

    if (Op.isImm() && Op.getImmTy() == AMDGPUOperand::ImmTyExpTgt) {
      Op.addImmOperands(Inst, 1);
      continue;
    }

    if (Op.isToken() && Op.getToken() == "done")
      continue;

    // Handle optional arguments
    OptionalIdx[Op.getImmTy()] = i;
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyExpVM);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyExpCompr);

  Inst.addOperand(MCOperand::createImm(EnMask));
}

//===----------------------------------------------------------------------===//
// s_waitcnt
//===----------------------------------------------------------------------===//

bool AMDGPUAsmParser::parseCnt(int64_t &IntVal) {
  StringRef CntName = Parser.getTok().getString();
  int64_t CntVal;

  Parser.Lex();
  if (getLexer().isNot(AsmToken::LParen))
    return true;

  Parser.Lex();
  if (getLexer().isNot(AsmToken::Integer))
    return true;

  if (getParser().parseAbsoluteExpression(CntVal))
    return true;

  if (getLexer().isNot(AsmToken::RParen))
    return true;

  Parser.Lex();
  if (getLexer().is(AsmToken::Amp) || getLexer().is(AsmToken::Comma))
    Parser.Lex();

  IsaVersion IV = getIsaVersion(getSTI().getFeatureBits());
  if (CntName == "vmcnt")
    IntVal = encodeVmcnt(IV, IntVal, CntVal);
  else if (CntName == "expcnt")
    IntVal = encodeExpcnt(IV, IntVal, CntVal);
  else if (CntName == "lgkmcnt")
    IntVal = encodeLgkmcnt(IV, IntVal, CntVal);
  else
    return true;

  return false;
}

OperandMatchResultTy
AMDGPUAsmParser::parseSWaitCntOps(OperandVector &Operands) {
  IsaVersion IV = getIsaVersion(getSTI().getFeatureBits());
  int64_t Waitcnt = getWaitcntBitMask(IV);
  SMLoc S = Parser.getTok().getLoc();

  switch(getLexer().getKind()) {
    default: return MatchOperand_ParseFail;
    case AsmToken::Integer:
      // The operand can be an integer value.
      if (getParser().parseAbsoluteExpression(Waitcnt))
        return MatchOperand_ParseFail;
      break;

    case AsmToken::Identifier:
      do {
        if (parseCnt(Waitcnt))
          return MatchOperand_ParseFail;
      } while(getLexer().isNot(AsmToken::EndOfStatement));
      break;
  }
  Operands.push_back(AMDGPUOperand::CreateImm(this, Waitcnt, S));
  return MatchOperand_Success;
}

bool AMDGPUAsmParser::parseHwregConstruct(OperandInfoTy &HwReg, int64_t &Offset, int64_t &Width) {
  using namespace llvm::AMDGPU::Hwreg;

  if (Parser.getTok().getString() != "hwreg")
    return true;
  Parser.Lex();

  if (getLexer().isNot(AsmToken::LParen))
    return true;
  Parser.Lex();

  if (getLexer().is(AsmToken::Identifier)) {
    HwReg.IsSymbolic = true;
    HwReg.Id = ID_UNKNOWN_;
    const StringRef tok = Parser.getTok().getString();
    for (int i = ID_SYMBOLIC_FIRST_; i < ID_SYMBOLIC_LAST_; ++i) {
      if (tok == IdSymbolic[i]) {
        HwReg.Id = i;
        break;
      }
    }
    Parser.Lex();
  } else {
    HwReg.IsSymbolic = false;
    if (getLexer().isNot(AsmToken::Integer))
      return true;
    if (getParser().parseAbsoluteExpression(HwReg.Id))
      return true;
  }

  if (getLexer().is(AsmToken::RParen)) {
    Parser.Lex();
    return false;
  }

  // optional params
  if (getLexer().isNot(AsmToken::Comma))
    return true;
  Parser.Lex();

  if (getLexer().isNot(AsmToken::Integer))
    return true;
  if (getParser().parseAbsoluteExpression(Offset))
    return true;

  if (getLexer().isNot(AsmToken::Comma))
    return true;
  Parser.Lex();

  if (getLexer().isNot(AsmToken::Integer))
    return true;
  if (getParser().parseAbsoluteExpression(Width))
    return true;

  if (getLexer().isNot(AsmToken::RParen))
    return true;
  Parser.Lex();

  return false;
}

OperandMatchResultTy
AMDGPUAsmParser::parseHwreg(OperandVector &Operands) {
  using namespace llvm::AMDGPU::Hwreg;

  int64_t Imm16Val = 0;
  SMLoc S = Parser.getTok().getLoc();

  switch(getLexer().getKind()) {
    default: return MatchOperand_NoMatch;
    case AsmToken::Integer:
      // The operand can be an integer value.
      if (getParser().parseAbsoluteExpression(Imm16Val))
        return MatchOperand_NoMatch;
      if (Imm16Val < 0 || !isUInt<16>(Imm16Val)) {
        Error(S, "invalid immediate: only 16-bit values are legal");
        // Do not return error code, but create an imm operand anyway and proceed
        // to the next operand, if any. That avoids unneccessary error messages.
      }
      break;

    case AsmToken::Identifier: {
        OperandInfoTy HwReg(ID_UNKNOWN_);
        int64_t Offset = OFFSET_DEFAULT_;
        int64_t Width = WIDTH_M1_DEFAULT_ + 1;
        if (parseHwregConstruct(HwReg, Offset, Width))
          return MatchOperand_ParseFail;
        if (HwReg.Id < 0 || !isUInt<ID_WIDTH_>(HwReg.Id)) {
          if (HwReg.IsSymbolic)
            Error(S, "invalid symbolic name of hardware register");
          else
            Error(S, "invalid code of hardware register: only 6-bit values are legal");
        }
        if (Offset < 0 || !isUInt<OFFSET_WIDTH_>(Offset))
          Error(S, "invalid bit offset: only 5-bit values are legal");
        if ((Width-1) < 0 || !isUInt<WIDTH_M1_WIDTH_>(Width-1))
          Error(S, "invalid bitfield width: only values from 1 to 32 are legal");
        Imm16Val = (HwReg.Id << ID_SHIFT_) | (Offset << OFFSET_SHIFT_) | ((Width-1) << WIDTH_M1_SHIFT_);
      }
      break;
  }
  Operands.push_back(AMDGPUOperand::CreateImm(this, Imm16Val, S, AMDGPUOperand::ImmTyHwreg));
  return MatchOperand_Success;
}

bool AMDGPUOperand::isSWaitCnt() const {
  return isImm();
}

bool AMDGPUOperand::isHwreg() const {
  return isImmTy(ImmTyHwreg);
}

bool AMDGPUAsmParser::parseSendMsgConstruct(OperandInfoTy &Msg, OperandInfoTy &Operation, int64_t &StreamId) {
  using namespace llvm::AMDGPU::SendMsg;

  if (Parser.getTok().getString() != "sendmsg")
    return true;
  Parser.Lex();

  if (getLexer().isNot(AsmToken::LParen))
    return true;
  Parser.Lex();

  if (getLexer().is(AsmToken::Identifier)) {
    Msg.IsSymbolic = true;
    Msg.Id = ID_UNKNOWN_;
    const std::string tok = Parser.getTok().getString();
    for (int i = ID_GAPS_FIRST_; i < ID_GAPS_LAST_; ++i) {
      switch(i) {
        default: continue; // Omit gaps.
        case ID_INTERRUPT: case ID_GS: case ID_GS_DONE:  case ID_SYSMSG: break;
      }
      if (tok == IdSymbolic[i]) {
        Msg.Id = i;
        break;
      }
    }
    Parser.Lex();
  } else {
    Msg.IsSymbolic = false;
    if (getLexer().isNot(AsmToken::Integer))
      return true;
    if (getParser().parseAbsoluteExpression(Msg.Id))
      return true;
    if (getLexer().is(AsmToken::Integer))
      if (getParser().parseAbsoluteExpression(Msg.Id))
        Msg.Id = ID_UNKNOWN_;
  }
  if (Msg.Id == ID_UNKNOWN_) // Don't know how to parse the rest.
    return false;

  if (!(Msg.Id == ID_GS || Msg.Id == ID_GS_DONE || Msg.Id == ID_SYSMSG)) {
    if (getLexer().isNot(AsmToken::RParen))
      return true;
    Parser.Lex();
    return false;
  }

  if (getLexer().isNot(AsmToken::Comma))
    return true;
  Parser.Lex();

  assert(Msg.Id == ID_GS || Msg.Id == ID_GS_DONE || Msg.Id == ID_SYSMSG);
  Operation.Id = ID_UNKNOWN_;
  if (getLexer().is(AsmToken::Identifier)) {
    Operation.IsSymbolic = true;
    const char* const *S = (Msg.Id == ID_SYSMSG) ? OpSysSymbolic : OpGsSymbolic;
    const int F = (Msg.Id == ID_SYSMSG) ? OP_SYS_FIRST_ : OP_GS_FIRST_;
    const int L = (Msg.Id == ID_SYSMSG) ? OP_SYS_LAST_ : OP_GS_LAST_;
    const StringRef Tok = Parser.getTok().getString();
    for (int i = F; i < L; ++i) {
      if (Tok == S[i]) {
        Operation.Id = i;
        break;
      }
    }
    Parser.Lex();
  } else {
    Operation.IsSymbolic = false;
    if (getLexer().isNot(AsmToken::Integer))
      return true;
    if (getParser().parseAbsoluteExpression(Operation.Id))
      return true;
  }

  if ((Msg.Id == ID_GS || Msg.Id == ID_GS_DONE) && Operation.Id != OP_GS_NOP) {
    // Stream id is optional.
    if (getLexer().is(AsmToken::RParen)) {
      Parser.Lex();
      return false;
    }

    if (getLexer().isNot(AsmToken::Comma))
      return true;
    Parser.Lex();

    if (getLexer().isNot(AsmToken::Integer))
      return true;
    if (getParser().parseAbsoluteExpression(StreamId))
      return true;
  }

  if (getLexer().isNot(AsmToken::RParen))
    return true;
  Parser.Lex();
  return false;
}

void AMDGPUAsmParser::errorExpTgt() {
  Error(Parser.getTok().getLoc(), "invalid exp target");
}

OperandMatchResultTy AMDGPUAsmParser::parseExpTgtImpl(StringRef Str,
                                                      uint8_t &Val) {
  if (Str == "null") {
    Val = 9;
    return MatchOperand_Success;
  }

  if (Str.startswith("mrt")) {
    Str = Str.drop_front(3);
    if (Str == "z") { // == mrtz
      Val = 8;
      return MatchOperand_Success;
    }

    if (Str.getAsInteger(10, Val))
      return MatchOperand_ParseFail;

    if (Val > 7)
      errorExpTgt();

    return MatchOperand_Success;
  }

  if (Str.startswith("pos")) {
    Str = Str.drop_front(3);
    if (Str.getAsInteger(10, Val))
      return MatchOperand_ParseFail;

    if (Val > 3)
      errorExpTgt();

    Val += 12;
    return MatchOperand_Success;
  }

  if (Str.startswith("param")) {
    Str = Str.drop_front(5);
    if (Str.getAsInteger(10, Val))
      return MatchOperand_ParseFail;

    if (Val >= 32)
      errorExpTgt();

    Val += 32;
    return MatchOperand_Success;
  }

  if (Str.startswith("invalid_target_")) {
    Str = Str.drop_front(15);
    if (Str.getAsInteger(10, Val))
      return MatchOperand_ParseFail;

    errorExpTgt();
    return MatchOperand_Success;
  }

  return MatchOperand_NoMatch;
}

OperandMatchResultTy AMDGPUAsmParser::parseExpTgt(OperandVector &Operands) {
  uint8_t Val;
  StringRef Str = Parser.getTok().getString();

  auto Res = parseExpTgtImpl(Str, Val);
  if (Res != MatchOperand_Success)
    return Res;

  SMLoc S = Parser.getTok().getLoc();
  Parser.Lex();

  Operands.push_back(AMDGPUOperand::CreateImm(this, Val, S,
                                              AMDGPUOperand::ImmTyExpTgt));
  return MatchOperand_Success;
}

OperandMatchResultTy
AMDGPUAsmParser::parseSendMsgOp(OperandVector &Operands) {
  using namespace llvm::AMDGPU::SendMsg;

  int64_t Imm16Val = 0;
  SMLoc S = Parser.getTok().getLoc();

  switch(getLexer().getKind()) {
  default:
    return MatchOperand_NoMatch;
  case AsmToken::Integer:
    // The operand can be an integer value.
    if (getParser().parseAbsoluteExpression(Imm16Val))
      return MatchOperand_NoMatch;
    if (Imm16Val < 0 || !isUInt<16>(Imm16Val)) {
      Error(S, "invalid immediate: only 16-bit values are legal");
      // Do not return error code, but create an imm operand anyway and proceed
      // to the next operand, if any. That avoids unneccessary error messages.
    }
    break;
  case AsmToken::Identifier: {
      OperandInfoTy Msg(ID_UNKNOWN_);
      OperandInfoTy Operation(OP_UNKNOWN_);
      int64_t StreamId = STREAM_ID_DEFAULT_;
      if (parseSendMsgConstruct(Msg, Operation, StreamId))
        return MatchOperand_ParseFail;
      do {
        // Validate and encode message ID.
        if (! ((ID_INTERRUPT <= Msg.Id && Msg.Id <= ID_GS_DONE)
                || Msg.Id == ID_SYSMSG)) {
          if (Msg.IsSymbolic)
            Error(S, "invalid/unsupported symbolic name of message");
          else
            Error(S, "invalid/unsupported code of message");
          break;
        }
        Imm16Val = (Msg.Id << ID_SHIFT_);
        // Validate and encode operation ID.
        if (Msg.Id == ID_GS || Msg.Id == ID_GS_DONE) {
          if (! (OP_GS_FIRST_ <= Operation.Id && Operation.Id < OP_GS_LAST_)) {
            if (Operation.IsSymbolic)
              Error(S, "invalid symbolic name of GS_OP");
            else
              Error(S, "invalid code of GS_OP: only 2-bit values are legal");
            break;
          }
          if (Operation.Id == OP_GS_NOP
              && Msg.Id != ID_GS_DONE) {
            Error(S, "invalid GS_OP: NOP is for GS_DONE only");
            break;
          }
          Imm16Val |= (Operation.Id << OP_SHIFT_);
        }
        if (Msg.Id == ID_SYSMSG) {
          if (! (OP_SYS_FIRST_ <= Operation.Id && Operation.Id < OP_SYS_LAST_)) {
            if (Operation.IsSymbolic)
              Error(S, "invalid/unsupported symbolic name of SYSMSG_OP");
            else
              Error(S, "invalid/unsupported code of SYSMSG_OP");
            break;
          }
          Imm16Val |= (Operation.Id << OP_SHIFT_);
        }
        // Validate and encode stream ID.
        if ((Msg.Id == ID_GS || Msg.Id == ID_GS_DONE) && Operation.Id != OP_GS_NOP) {
          if (! (STREAM_ID_FIRST_ <= StreamId && StreamId < STREAM_ID_LAST_)) {
            Error(S, "invalid stream id: only 2-bit values are legal");
            break;
          }
          Imm16Val |= (StreamId << STREAM_ID_SHIFT_);
        }
      } while (0);
    }
    break;
  }
  Operands.push_back(AMDGPUOperand::CreateImm(this, Imm16Val, S, AMDGPUOperand::ImmTySendMsg));
  return MatchOperand_Success;
}

bool AMDGPUOperand::isSendMsg() const {
  return isImmTy(ImmTySendMsg);
}

//===----------------------------------------------------------------------===//
// sopp branch targets
//===----------------------------------------------------------------------===//

OperandMatchResultTy
AMDGPUAsmParser::parseSOppBrTarget(OperandVector &Operands) {
  SMLoc S = Parser.getTok().getLoc();

  switch (getLexer().getKind()) {
    default: return MatchOperand_ParseFail;
    case AsmToken::Integer: {
      int64_t Imm;
      if (getParser().parseAbsoluteExpression(Imm))
        return MatchOperand_ParseFail;
      Operands.push_back(AMDGPUOperand::CreateImm(this, Imm, S));
      return MatchOperand_Success;
    }

    case AsmToken::Identifier:
      Operands.push_back(AMDGPUOperand::CreateExpr(this,
          MCSymbolRefExpr::create(getContext().getOrCreateSymbol(
                                  Parser.getTok().getString()), getContext()), S));
      Parser.Lex();
      return MatchOperand_Success;
  }
}

//===----------------------------------------------------------------------===//
// mubuf
//===----------------------------------------------------------------------===//

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultGLC() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyGLC);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultSLC() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTySLC);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultTFE() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyTFE);
}

void AMDGPUAsmParser::cvtMubufImpl(MCInst &Inst,
                               const OperandVector &Operands,
                               bool IsAtomic, bool IsAtomicReturn) {
  OptionalImmIndexMap OptionalIdx;
  assert(IsAtomicReturn ? IsAtomic : true);

  for (unsigned i = 1, e = Operands.size(); i != e; ++i) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[i]);

    // Add the register arguments
    if (Op.isReg()) {
      Op.addRegOperands(Inst, 1);
      continue;
    }

    // Handle the case where soffset is an immediate
    if (Op.isImm() && Op.getImmTy() == AMDGPUOperand::ImmTyNone) {
      Op.addImmOperands(Inst, 1);
      continue;
    }

    // Handle tokens like 'offen' which are sometimes hard-coded into the
    // asm string.  There are no MCInst operands for these.
    if (Op.isToken()) {
      continue;
    }
    assert(Op.isImm());

    // Handle optional arguments
    OptionalIdx[Op.getImmTy()] = i;
  }

  // Copy $vdata_in operand and insert as $vdata for MUBUF_Atomic RTN insns.
  if (IsAtomicReturn) {
    MCInst::iterator I = Inst.begin(); // $vdata_in is always at the beginning.
    Inst.insert(I, *I);
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyOffset);
  if (!IsAtomic) { // glc is hard-coded.
    addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGLC);
  }
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySLC);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyTFE);
}

//===----------------------------------------------------------------------===//
// mimg
//===----------------------------------------------------------------------===//

void AMDGPUAsmParser::cvtMIMG(MCInst &Inst, const OperandVector &Operands) {
  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }

  OptionalImmIndexMap OptionalIdx;

  for (unsigned E = Operands.size(); I != E; ++I) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[I]);

    // Add the register arguments
    if (Op.isRegOrImm()) {
      Op.addRegOrImmOperands(Inst, 1);
      continue;
    } else if (Op.isImmModifier()) {
      OptionalIdx[Op.getImmTy()] = I;
    } else {
      llvm_unreachable("unexpected operand type");
    }
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDMask);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyUNorm);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGLC);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDA);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyR128);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyTFE);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyLWE);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySLC);
}

void AMDGPUAsmParser::cvtMIMGAtomic(MCInst &Inst, const OperandVector &Operands) {
  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }

  // Add src, same as dst
  ((AMDGPUOperand &)*Operands[I]).addRegOperands(Inst, 1);

  OptionalImmIndexMap OptionalIdx;

  for (unsigned E = Operands.size(); I != E; ++I) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[I]);

    // Add the register arguments
    if (Op.isRegOrImm()) {
      Op.addRegOrImmOperands(Inst, 1);
      continue;
    } else if (Op.isImmModifier()) {
      OptionalIdx[Op.getImmTy()] = I;
    } else {
      llvm_unreachable("unexpected operand type");
    }
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDMask);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyUNorm);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyGLC);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDA);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyR128);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyTFE);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyLWE);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySLC);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultDMask() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyDMask);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultUNorm() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyUNorm);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultDA() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyDA);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultR128() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyR128);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultLWE() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyLWE);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultExpTgt() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyExpTgt);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultExpCompr() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyExpCompr);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultExpVM() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyExpVM);
}

//===----------------------------------------------------------------------===//
// smrd
//===----------------------------------------------------------------------===//

bool AMDGPUOperand::isSMRDOffset8() const {
  return isImm() && isUInt<8>(getImm());
}

bool AMDGPUOperand::isSMRDOffset20() const {
  return isImm() && isUInt<20>(getImm());
}

bool AMDGPUOperand::isSMRDLiteralOffset() const {
  // 32-bit literals are only supported on CI and we only want to use them
  // when the offset is > 8-bits.
  return isImm() && !isUInt<8>(getImm()) && isUInt<32>(getImm());
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultSMRDOffset8() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyOffset);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultSMRDOffset20() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyOffset);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultSMRDLiteralOffset() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyOffset);
}

//===----------------------------------------------------------------------===//
// vop3
//===----------------------------------------------------------------------===//

static bool ConvertOmodMul(int64_t &Mul) {
  if (Mul != 1 && Mul != 2 && Mul != 4)
    return false;

  Mul >>= 1;
  return true;
}

static bool ConvertOmodDiv(int64_t &Div) {
  if (Div == 1) {
    Div = 0;
    return true;
  }

  if (Div == 2) {
    Div = 3;
    return true;
  }

  return false;
}

static bool ConvertBoundCtrl(int64_t &BoundCtrl) {
  if (BoundCtrl == 0) {
    BoundCtrl = 1;
    return true;
  }

  if (BoundCtrl == -1) {
    BoundCtrl = 0;
    return true;
  }

  return false;
}

// Note: the order in this table matches the order of operands in AsmString.
static const OptionalOperand AMDGPUOptionalOperandTable[] = {
  {"offen",   AMDGPUOperand::ImmTyOffen, true, nullptr},
  {"idxen",   AMDGPUOperand::ImmTyIdxen, true, nullptr},
  {"addr64",  AMDGPUOperand::ImmTyAddr64, true, nullptr},
  {"offset0", AMDGPUOperand::ImmTyOffset0, false, nullptr},
  {"offset1", AMDGPUOperand::ImmTyOffset1, false, nullptr},
  {"gds",     AMDGPUOperand::ImmTyGDS, true, nullptr},
  {"offset",  AMDGPUOperand::ImmTyOffset, false, nullptr},
  {"glc",     AMDGPUOperand::ImmTyGLC, true, nullptr},
  {"slc",     AMDGPUOperand::ImmTySLC, true, nullptr},
  {"tfe",     AMDGPUOperand::ImmTyTFE, true, nullptr},
  {"clamp",   AMDGPUOperand::ImmTyClampSI, true, nullptr},
  {"omod",    AMDGPUOperand::ImmTyOModSI, false, ConvertOmodMul},
  {"unorm",   AMDGPUOperand::ImmTyUNorm, true, nullptr},
  {"da",      AMDGPUOperand::ImmTyDA,    true, nullptr},
  {"r128",    AMDGPUOperand::ImmTyR128,  true, nullptr},
  {"lwe",     AMDGPUOperand::ImmTyLWE,   true, nullptr},
  {"dmask",   AMDGPUOperand::ImmTyDMask, false, nullptr},
  {"row_mask",   AMDGPUOperand::ImmTyDppRowMask, false, nullptr},
  {"bank_mask",  AMDGPUOperand::ImmTyDppBankMask, false, nullptr},
  {"bound_ctrl", AMDGPUOperand::ImmTyDppBoundCtrl, false, ConvertBoundCtrl},
  {"dst_sel",    AMDGPUOperand::ImmTySdwaDstSel, false, nullptr},
  {"src0_sel",   AMDGPUOperand::ImmTySdwaSrc0Sel, false, nullptr},
  {"src1_sel",   AMDGPUOperand::ImmTySdwaSrc1Sel, false, nullptr},
  {"dst_unused", AMDGPUOperand::ImmTySdwaDstUnused, false, nullptr},
  {"vm", AMDGPUOperand::ImmTyExpVM, true, nullptr},
};

OperandMatchResultTy AMDGPUAsmParser::parseOptionalOperand(OperandVector &Operands) {
  OperandMatchResultTy res;
  for (const OptionalOperand &Op : AMDGPUOptionalOperandTable) {
    // try to parse any optional operand here
    if (Op.IsBit) {
      res = parseNamedBit(Op.Name, Operands, Op.Type);
    } else if (Op.Type == AMDGPUOperand::ImmTyOModSI) {
      res = parseOModOperand(Operands);
    } else if (Op.Type == AMDGPUOperand::ImmTySdwaDstSel ||
               Op.Type == AMDGPUOperand::ImmTySdwaSrc0Sel ||
               Op.Type == AMDGPUOperand::ImmTySdwaSrc1Sel) {
      res = parseSDWASel(Operands, Op.Name, Op.Type);
    } else if (Op.Type == AMDGPUOperand::ImmTySdwaDstUnused) {
      res = parseSDWADstUnused(Operands);
    } else {
      res = parseIntWithPrefix(Op.Name, Operands, Op.Type, Op.ConvertResult);
    }
    if (res != MatchOperand_NoMatch) {
      return res;
    }
  }
  return MatchOperand_NoMatch;
}

OperandMatchResultTy AMDGPUAsmParser::parseOModOperand(OperandVector &Operands) {
  StringRef Name = Parser.getTok().getString();
  if (Name == "mul") {
    return parseIntWithPrefix("mul", Operands,
                              AMDGPUOperand::ImmTyOModSI, ConvertOmodMul);
  }

  if (Name == "div") {
    return parseIntWithPrefix("div", Operands,
                              AMDGPUOperand::ImmTyOModSI, ConvertOmodDiv);
  }

  return MatchOperand_NoMatch;
}

void AMDGPUAsmParser::cvtId(MCInst &Inst, const OperandVector &Operands) {
  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }
  for (unsigned E = Operands.size(); I != E; ++I)
    ((AMDGPUOperand &)*Operands[I]).addRegOrImmOperands(Inst, 1);
}

void AMDGPUAsmParser::cvtVOP3_2_mod(MCInst &Inst, const OperandVector &Operands) {
  uint64_t TSFlags = MII.get(Inst.getOpcode()).TSFlags;
  if (TSFlags & SIInstrFlags::VOP3) {
    cvtVOP3(Inst, Operands);
  } else {
    cvtId(Inst, Operands);
  }
}

static bool isRegOrImmWithInputMods(const MCInstrDesc &Desc, unsigned OpNum) {
      // 1. This operand is input modifiers
  return Desc.OpInfo[OpNum].OperandType == AMDGPU::OPERAND_INPUT_MODS
      // 2. This is not last operand
      && Desc.NumOperands > (OpNum + 1)
      // 3. Next operand is register class
      && Desc.OpInfo[OpNum + 1].RegClass != -1
      // 4. Next register is not tied to any other operand
      && Desc.getOperandConstraint(OpNum + 1, MCOI::OperandConstraint::TIED_TO) == -1;
}

void AMDGPUAsmParser::cvtVOP3(MCInst &Inst, const OperandVector &Operands) {
  OptionalImmIndexMap OptionalIdx;
  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }

  for (unsigned E = Operands.size(); I != E; ++I) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[I]);
    if (isRegOrImmWithInputMods(Desc, Inst.getNumOperands())) {
      Op.addRegOrImmWithFPInputModsOperands(Inst, 2);
    } else if (Op.isImm()) {
      OptionalIdx[Op.getImmTy()] = I;
    } else {
      llvm_unreachable("unhandled operand type");
    }
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyClampSI);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyOModSI);

  // special case v_mac_{f16, f32}:
  // it has src2 register operand that is tied to dst operand
  // we don't allow modifiers for this operand in assembler so src2_modifiers
  // should be 0
  if (Inst.getOpcode() == AMDGPU::V_MAC_F32_e64_si ||
      Inst.getOpcode() == AMDGPU::V_MAC_F32_e64_vi ||
      Inst.getOpcode() == AMDGPU::V_MAC_F16_e64_vi) {
    auto it = Inst.begin();
    std::advance(
      it,
      AMDGPU::getNamedOperandIdx(Inst.getOpcode() == AMDGPU::V_MAC_F16_e64_vi ?
                                     AMDGPU::V_MAC_F16_e64 :
                                     AMDGPU::V_MAC_F32_e64,
                                 AMDGPU::OpName::src2_modifiers));
    it = Inst.insert(it, MCOperand::createImm(0)); // no modifiers for src2
    ++it;
    Inst.insert(it, Inst.getOperand(0)); // src2 = dst
  }
}

//===----------------------------------------------------------------------===//
// dpp
//===----------------------------------------------------------------------===//

bool AMDGPUOperand::isDPPCtrl() const {
  bool result = isImm() && getImmTy() == ImmTyDppCtrl && isUInt<9>(getImm());
  if (result) {
    int64_t Imm = getImm();
    return ((Imm >= 0x000) && (Imm <= 0x0ff)) ||
           ((Imm >= 0x101) && (Imm <= 0x10f)) ||
           ((Imm >= 0x111) && (Imm <= 0x11f)) ||
           ((Imm >= 0x121) && (Imm <= 0x12f)) ||
           (Imm == 0x130) ||
           (Imm == 0x134) ||
           (Imm == 0x138) ||
           (Imm == 0x13c) ||
           (Imm == 0x140) ||
           (Imm == 0x141) ||
           (Imm == 0x142) ||
           (Imm == 0x143);
  }
  return false;
}

bool AMDGPUOperand::isGPRIdxMode() const {
  return isImm() && isUInt<4>(getImm());
}

OperandMatchResultTy
AMDGPUAsmParser::parseDPPCtrl(OperandVector &Operands) {
  SMLoc S = Parser.getTok().getLoc();
  StringRef Prefix;
  int64_t Int;

  if (getLexer().getKind() == AsmToken::Identifier) {
    Prefix = Parser.getTok().getString();
  } else {
    return MatchOperand_NoMatch;
  }

  if (Prefix == "row_mirror") {
    Int = 0x140;
    Parser.Lex();
  } else if (Prefix == "row_half_mirror") {
    Int = 0x141;
    Parser.Lex();
  } else {
    // Check to prevent parseDPPCtrlOps from eating invalid tokens
    if (Prefix != "quad_perm"
        && Prefix != "row_shl"
        && Prefix != "row_shr"
        && Prefix != "row_ror"
        && Prefix != "wave_shl"
        && Prefix != "wave_rol"
        && Prefix != "wave_shr"
        && Prefix != "wave_ror"
        && Prefix != "row_bcast") {
      return MatchOperand_NoMatch;
    }

    Parser.Lex();
    if (getLexer().isNot(AsmToken::Colon))
      return MatchOperand_ParseFail;

    if (Prefix == "quad_perm") {
      // quad_perm:[%d,%d,%d,%d]
      Parser.Lex();
      if (getLexer().isNot(AsmToken::LBrac))
        return MatchOperand_ParseFail;
      Parser.Lex();

      if (getParser().parseAbsoluteExpression(Int) || !(0 <= Int && Int <=3))
        return MatchOperand_ParseFail;

      for (int i = 0; i < 3; ++i) {
        if (getLexer().isNot(AsmToken::Comma))
          return MatchOperand_ParseFail;
        Parser.Lex();

        int64_t Temp;
        if (getParser().parseAbsoluteExpression(Temp) || !(0 <= Temp && Temp <=3))
          return MatchOperand_ParseFail;
        const int shift = i*2 + 2;
        Int += (Temp << shift);
      }

      if (getLexer().isNot(AsmToken::RBrac))
        return MatchOperand_ParseFail;
      Parser.Lex();

    } else {
      // sel:%d
      Parser.Lex();
      if (getParser().parseAbsoluteExpression(Int))
        return MatchOperand_ParseFail;

      if (Prefix == "row_shl" && 1 <= Int && Int <= 15) {
        Int |= 0x100;
      } else if (Prefix == "row_shr" && 1 <= Int && Int <= 15) {
        Int |= 0x110;
      } else if (Prefix == "row_ror" && 1 <= Int && Int <= 15) {
        Int |= 0x120;
      } else if (Prefix == "wave_shl" && 1 == Int) {
        Int = 0x130;
      } else if (Prefix == "wave_rol" && 1 == Int) {
        Int = 0x134;
      } else if (Prefix == "wave_shr" && 1 == Int) {
        Int = 0x138;
      } else if (Prefix == "wave_ror" && 1 == Int) {
        Int = 0x13C;
      } else if (Prefix == "row_bcast") {
        if (Int == 15) {
          Int = 0x142;
        } else if (Int == 31) {
          Int = 0x143;
        } else {
          return MatchOperand_ParseFail;
        }
      } else {
        return MatchOperand_ParseFail;
      }
    }
  }

  Operands.push_back(AMDGPUOperand::CreateImm(this, Int, S, AMDGPUOperand::ImmTyDppCtrl));
  return MatchOperand_Success;
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultRowMask() const {
  return AMDGPUOperand::CreateImm(this, 0xf, SMLoc(), AMDGPUOperand::ImmTyDppRowMask);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultBankMask() const {
  return AMDGPUOperand::CreateImm(this, 0xf, SMLoc(), AMDGPUOperand::ImmTyDppBankMask);
}

AMDGPUOperand::Ptr AMDGPUAsmParser::defaultBoundCtrl() const {
  return AMDGPUOperand::CreateImm(this, 0, SMLoc(), AMDGPUOperand::ImmTyDppBoundCtrl);
}

void AMDGPUAsmParser::cvtDPP(MCInst &Inst, const OperandVector &Operands) {
  OptionalImmIndexMap OptionalIdx;

  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }

  for (unsigned E = Operands.size(); I != E; ++I) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[I]);
    // Add the register arguments
    if (isRegOrImmWithInputMods(Desc, Inst.getNumOperands())) {
      Op.addRegOrImmWithFPInputModsOperands(Inst, 2);
    } else if (Op.isDPPCtrl()) {
      Op.addImmOperands(Inst, 1);
    } else if (Op.isImm()) {
      // Handle optional arguments
      OptionalIdx[Op.getImmTy()] = I;
    } else {
      llvm_unreachable("Invalid operand type");
    }
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDppRowMask, 0xf);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDppBankMask, 0xf);
  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyDppBoundCtrl);

  // special case v_mac_{f16, f32}:
  // it has src2 register operand that is tied to dst operand
  if (Inst.getOpcode() == AMDGPU::V_MAC_F32_dpp ||
      Inst.getOpcode() == AMDGPU::V_MAC_F16_dpp) {
    auto it = Inst.begin();
    std::advance(
        it, AMDGPU::getNamedOperandIdx(Inst.getOpcode(), AMDGPU::OpName::src2));
    Inst.insert(it, Inst.getOperand(0)); // src2 = dst
  }
}

//===----------------------------------------------------------------------===//
// sdwa
//===----------------------------------------------------------------------===//

OperandMatchResultTy
AMDGPUAsmParser::parseSDWASel(OperandVector &Operands, StringRef Prefix,
                              AMDGPUOperand::ImmTy Type) {
  using namespace llvm::AMDGPU::SDWA;

  SMLoc S = Parser.getTok().getLoc();
  StringRef Value;
  OperandMatchResultTy res;

  res = parseStringWithPrefix(Prefix, Value);
  if (res != MatchOperand_Success) {
    return res;
  }

  int64_t Int;
  Int = StringSwitch<int64_t>(Value)
        .Case("BYTE_0", SdwaSel::BYTE_0)
        .Case("BYTE_1", SdwaSel::BYTE_1)
        .Case("BYTE_2", SdwaSel::BYTE_2)
        .Case("BYTE_3", SdwaSel::BYTE_3)
        .Case("WORD_0", SdwaSel::WORD_0)
        .Case("WORD_1", SdwaSel::WORD_1)
        .Case("DWORD", SdwaSel::DWORD)
        .Default(0xffffffff);
  Parser.Lex(); // eat last token

  if (Int == 0xffffffff) {
    return MatchOperand_ParseFail;
  }

  Operands.push_back(AMDGPUOperand::CreateImm(this, Int, S, Type));
  return MatchOperand_Success;
}

OperandMatchResultTy
AMDGPUAsmParser::parseSDWADstUnused(OperandVector &Operands) {
  using namespace llvm::AMDGPU::SDWA;

  SMLoc S = Parser.getTok().getLoc();
  StringRef Value;
  OperandMatchResultTy res;

  res = parseStringWithPrefix("dst_unused", Value);
  if (res != MatchOperand_Success) {
    return res;
  }

  int64_t Int;
  Int = StringSwitch<int64_t>(Value)
        .Case("UNUSED_PAD", DstUnused::UNUSED_PAD)
        .Case("UNUSED_SEXT", DstUnused::UNUSED_SEXT)
        .Case("UNUSED_PRESERVE", DstUnused::UNUSED_PRESERVE)
        .Default(0xffffffff);
  Parser.Lex(); // eat last token

  if (Int == 0xffffffff) {
    return MatchOperand_ParseFail;
  }

  Operands.push_back(AMDGPUOperand::CreateImm(this, Int, S, AMDGPUOperand::ImmTySdwaDstUnused));
  return MatchOperand_Success;
}

void AMDGPUAsmParser::cvtSdwaVOP1(MCInst &Inst, const OperandVector &Operands) {
  cvtSDWA(Inst, Operands, SIInstrFlags::VOP1);
}

void AMDGPUAsmParser::cvtSdwaVOP2(MCInst &Inst, const OperandVector &Operands) {
  cvtSDWA(Inst, Operands, SIInstrFlags::VOP2);
}

void AMDGPUAsmParser::cvtSdwaVOPC(MCInst &Inst, const OperandVector &Operands) {
  cvtSDWA(Inst, Operands, SIInstrFlags::VOPC);
}

void AMDGPUAsmParser::cvtSDWA(MCInst &Inst, const OperandVector &Operands,
                              uint64_t BasicInstType) {
  OptionalImmIndexMap OptionalIdx;

  unsigned I = 1;
  const MCInstrDesc &Desc = MII.get(Inst.getOpcode());
  for (unsigned J = 0; J < Desc.getNumDefs(); ++J) {
    ((AMDGPUOperand &)*Operands[I++]).addRegOperands(Inst, 1);
  }

  for (unsigned E = Operands.size(); I != E; ++I) {
    AMDGPUOperand &Op = ((AMDGPUOperand &)*Operands[I]);
    // Add the register arguments
    if (BasicInstType == SIInstrFlags::VOPC &&
        Op.isReg() &&
        Op.Reg.RegNo == AMDGPU::VCC) {
      // VOPC sdwa use "vcc" token as dst. Skip it.
      continue;
    } else if (isRegOrImmWithInputMods(Desc, Inst.getNumOperands())) {
      Op.addRegOrImmWithInputModsOperands(Inst, 2);
    } else if (Op.isImm()) {
      // Handle optional arguments
      OptionalIdx[Op.getImmTy()] = I;
    } else {
      llvm_unreachable("Invalid operand type");
    }
  }

  addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTyClampSI, 0);

  if (Inst.getOpcode() != AMDGPU::V_NOP_sdwa) {
    // V_NOP_sdwa has no optional sdwa arguments
    switch (BasicInstType) {
    case SIInstrFlags::VOP1: {
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaDstSel, 6);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaDstUnused, 2);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaSrc0Sel, 6);
      break;
    }
    case SIInstrFlags::VOP2: {
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaDstSel, 6);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaDstUnused, 2);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaSrc0Sel, 6);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaSrc1Sel, 6);
      break;
    }
    case SIInstrFlags::VOPC: {
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaSrc0Sel, 6);
      addOptionalImmOperand(Inst, Operands, OptionalIdx, AMDGPUOperand::ImmTySdwaSrc1Sel, 6);
      break;
    }
    default:
      llvm_unreachable("Invalid instruction type. Only VOP1, VOP2 and VOPC allowed");
    }
  }

  // special case v_mac_{f16, f32}:
  // it has src2 register operand that is tied to dst operand
  if (Inst.getOpcode() == AMDGPU::V_MAC_F32_sdwa ||
      Inst.getOpcode() == AMDGPU::V_MAC_F16_sdwa)  {
    auto it = Inst.begin();
    std::advance(
        it, AMDGPU::getNamedOperandIdx(Inst.getOpcode(), AMDGPU::OpName::src2));
    Inst.insert(it, Inst.getOperand(0)); // src2 = dst
  }

}

/// Force static initialization.
extern "C" void LLVMInitializeAMDGPUAsmParser() {
  RegisterMCAsmParser<AMDGPUAsmParser> A(getTheAMDGPUTarget());
  RegisterMCAsmParser<AMDGPUAsmParser> B(getTheGCNTarget());
}

#define GET_REGISTER_MATCHER
#define GET_MATCHER_IMPLEMENTATION
#include "AMDGPUGenAsmMatcher.inc"


// This fuction should be defined after auto-generated include so that we have
// MatchClassKind enum defined
unsigned AMDGPUAsmParser::validateTargetOperandClass(MCParsedAsmOperand &Op,
                                                     unsigned Kind) {
  // Tokens like "glc" would be parsed as immediate operands in ParseOperand().
  // But MatchInstructionImpl() expects to meet token and fails to validate
  // operand. This method checks if we are given immediate operand but expect to
  // get corresponding token.
  AMDGPUOperand &Operand = (AMDGPUOperand&)Op;
  switch (Kind) {
  case MCK_addr64:
    return Operand.isAddr64() ? Match_Success : Match_InvalidOperand;
  case MCK_gds:
    return Operand.isGDS() ? Match_Success : Match_InvalidOperand;
  case MCK_glc:
    return Operand.isGLC() ? Match_Success : Match_InvalidOperand;
  case MCK_idxen:
    return Operand.isIdxen() ? Match_Success : Match_InvalidOperand;
  case MCK_offen:
    return Operand.isOffen() ? Match_Success : Match_InvalidOperand;
  case MCK_SSrcB32:
    // When operands have expression values, they will return true for isToken,
    // because it is not possible to distinguish between a token and an
    // expression at parse time. MatchInstructionImpl() will always try to
    // match an operand as a token, when isToken returns true, and when the
    // name of the expression is not a valid token, the match will fail,
    // so we need to handle it here.
    return Operand.isSSrcB32() ? Match_Success : Match_InvalidOperand;
  case MCK_SSrcF32:
    return Operand.isSSrcF32() ? Match_Success : Match_InvalidOperand;
  case MCK_SoppBrTarget:
    return Operand.isSoppBrTarget() ? Match_Success : Match_InvalidOperand;
  case MCK_VReg32OrOff:
    return Operand.isVReg32OrOff() ? Match_Success : Match_InvalidOperand;
  default:
    return Match_InvalidOperand;
  }
}
