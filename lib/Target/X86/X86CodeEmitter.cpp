//===-- X86/X86CodeEmitter.cpp - Convert X86 code to machine code ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the pass that transforms the X86 machine instructions into
// relocatable machine code.
//
//===----------------------------------------------------------------------===//

#include "X86TargetMachine.h"
#include "X86Relocations.h"
#include "X86.h"
#include "llvm/PassManager.h"
#include "llvm/CodeGen/MachineCodeEmitter.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/Function.h"
#include "llvm/ADT/Statistic.h"
#include <iostream>
using namespace llvm;

namespace {
  Statistic<>
  NumEmitted("x86-emitter", "Number of machine instructions emitted");
}

namespace {
  class Emitter : public MachineFunctionPass {
    const X86InstrInfo  *II;
    MachineCodeEmitter  &MCE;
    std::map<const MachineBasicBlock*, unsigned> BasicBlockAddrs;
    std::vector<std::pair<const MachineBasicBlock *, unsigned> > BBRefs;
  public:
    explicit Emitter(MachineCodeEmitter &mce) : II(0), MCE(mce) {}
    Emitter(MachineCodeEmitter &mce, const X86InstrInfo& ii)
        : II(&ii), MCE(mce) {}

    bool runOnMachineFunction(MachineFunction &MF);

    virtual const char *getPassName() const {
      return "X86 Machine Code Emitter";
    }

    void emitInstruction(const MachineInstr &MI);

  private:
    void emitBasicBlock(const MachineBasicBlock &MBB);

    void emitPCRelativeBlockAddress(const MachineBasicBlock *BB);
    void emitPCRelativeValue(unsigned Address);
    void emitGlobalAddressForCall(GlobalValue *GV, bool isTailCall);
    void emitGlobalAddressForPtr(GlobalValue *GV, int Disp = 0);
    void emitExternalSymbolAddress(const char *ES, bool isPCRelative,
                                   bool isTailCall);

    void emitRegModRMByte(unsigned ModRMReg, unsigned RegOpcodeField);
    void emitSIBByte(unsigned SS, unsigned Index, unsigned Base);
    void emitConstant(unsigned Val, unsigned Size);

    void emitMemModRMByte(const MachineInstr &MI,
                          unsigned Op, unsigned RegOpcodeField);

  };
}

/// createX86CodeEmitterPass - Return a pass that emits the collected X86 code
/// to the specified MCE object.
FunctionPass *llvm::createX86CodeEmitterPass(MachineCodeEmitter &MCE) {
  return new Emitter(MCE);
}

bool Emitter::runOnMachineFunction(MachineFunction &MF) {
  II = ((X86TargetMachine&)MF.getTarget()).getInstrInfo();

  MCE.startFunction(MF);
  MCE.emitConstantPool(MF.getConstantPool());
  for (MachineFunction::iterator I = MF.begin(), E = MF.end(); I != E; ++I)
    emitBasicBlock(*I);
  MCE.finishFunction(MF);

  // Resolve all forward branches now...
  for (unsigned i = 0, e = BBRefs.size(); i != e; ++i) {
    unsigned Location = BasicBlockAddrs[BBRefs[i].first];
    unsigned Ref = BBRefs[i].second;
    MCE.emitWordAt(Location-Ref-4, (unsigned*)(intptr_t)Ref);
  }
  BBRefs.clear();
  BasicBlockAddrs.clear();
  return false;
}

void Emitter::emitBasicBlock(const MachineBasicBlock &MBB) {
  if (uint64_t Addr = MCE.getCurrentPCValue())
    BasicBlockAddrs[&MBB] = Addr;

  for (MachineBasicBlock::const_iterator I = MBB.begin(), E = MBB.end();
       I != E; ++I)
    emitInstruction(*I);
}

/// emitPCRelativeValue - Emit a 32-bit PC relative address.
///
void Emitter::emitPCRelativeValue(unsigned Address) {
  MCE.emitWord(Address-MCE.getCurrentPCValue()-4);
}

/// emitPCRelativeBlockAddress - This method emits the PC relative address of
/// the specified basic block, or if the basic block hasn't been emitted yet
/// (because this is a forward branch), it keeps track of the information
/// necessary to resolve this address later (and emits a dummy value).
///
void Emitter::emitPCRelativeBlockAddress(const MachineBasicBlock *MBB) {
  // If this is a backwards branch, we already know the address of the target,
  // so just emit the value.
  std::map<const MachineBasicBlock*, unsigned>::iterator I =
    BasicBlockAddrs.find(MBB);
  if (I != BasicBlockAddrs.end()) {
    emitPCRelativeValue(I->second);
  } else {
    // Otherwise, remember where this reference was and where it is to so we can
    // deal with it later.
    BBRefs.push_back(std::make_pair(MBB, MCE.getCurrentPCValue()));
    MCE.emitWord(0);
  }
}

/// emitGlobalAddressForCall - Emit the specified address to the code stream
/// assuming this is part of a function call, which is PC relative.
///
void Emitter::emitGlobalAddressForCall(GlobalValue *GV, bool isTailCall) {
  MCE.addRelocation(MachineRelocation(MCE.getCurrentPCOffset(),
                                      X86::reloc_pcrel_word, GV, 0,
                                      !isTailCall /*Doesn'tNeedStub*/));
  MCE.emitWord(0);
}

/// emitGlobalAddress - Emit the specified address to the code stream assuming
/// this is part of a "take the address of a global" instruction, which is not
/// PC relative.
///
void Emitter::emitGlobalAddressForPtr(GlobalValue *GV, int Disp /* = 0 */) {
  MCE.addRelocation(MachineRelocation(MCE.getCurrentPCOffset(),
                                      X86::reloc_absolute_word, GV));
  MCE.emitWord(Disp);   // The relocated value will be added to the displacement
}

/// emitExternalSymbolAddress - Arrange for the address of an external symbol to
/// be emitted to the current location in the function, and allow it to be PC
/// relative.
void Emitter::emitExternalSymbolAddress(const char *ES, bool isPCRelative,
                                        bool isTailCall) {
  MCE.addRelocation(MachineRelocation(MCE.getCurrentPCOffset(),
          isPCRelative ? X86::reloc_pcrel_word : X86::reloc_absolute_word, ES));
  MCE.emitWord(0);
}

/// N86 namespace - Native X86 Register numbers... used by X86 backend.
///
namespace N86 {
  enum {
    EAX = 0, ECX = 1, EDX = 2, EBX = 3, ESP = 4, EBP = 5, ESI = 6, EDI = 7
  };
}


// getX86RegNum - This function maps LLVM register identifiers to their X86
// specific numbering, which is used in various places encoding instructions.
//
static unsigned getX86RegNum(unsigned RegNo) {
  switch(RegNo) {
  case X86::EAX: case X86::AX: case X86::AL: return N86::EAX;
  case X86::ECX: case X86::CX: case X86::CL: return N86::ECX;
  case X86::EDX: case X86::DX: case X86::DL: return N86::EDX;
  case X86::EBX: case X86::BX: case X86::BL: return N86::EBX;
  case X86::ESP: case X86::SP: case X86::AH: return N86::ESP;
  case X86::EBP: case X86::BP: case X86::CH: return N86::EBP;
  case X86::ESI: case X86::SI: case X86::DH: return N86::ESI;
  case X86::EDI: case X86::DI: case X86::BH: return N86::EDI;

  case X86::ST0: case X86::ST1: case X86::ST2: case X86::ST3:
  case X86::ST4: case X86::ST5: case X86::ST6: case X86::ST7:
    return RegNo-X86::ST0;

  case X86::XMM0: case X86::XMM1: case X86::XMM2: case X86::XMM3:
  case X86::XMM4: case X86::XMM5: case X86::XMM6: case X86::XMM7:
    return RegNo-X86::XMM0;

  default:
    assert(MRegisterInfo::isVirtualRegister(RegNo) &&
           "Unknown physical register!");
    assert(0 && "Register allocator hasn't allocated reg correctly yet!");
    return 0;
  }
}

inline static unsigned char ModRMByte(unsigned Mod, unsigned RegOpcode,
                                      unsigned RM) {
  assert(Mod < 4 && RegOpcode < 8 && RM < 8 && "ModRM Fields out of range!");
  return RM | (RegOpcode << 3) | (Mod << 6);
}

void Emitter::emitRegModRMByte(unsigned ModRMReg, unsigned RegOpcodeFld){
  MCE.emitByte(ModRMByte(3, RegOpcodeFld, getX86RegNum(ModRMReg)));
}

void Emitter::emitSIBByte(unsigned SS, unsigned Index, unsigned Base) {
  // SIB byte is in the same format as the ModRMByte...
  MCE.emitByte(ModRMByte(SS, Index, Base));
}

void Emitter::emitConstant(unsigned Val, unsigned Size) {
  // Output the constant in little endian byte order...
  for (unsigned i = 0; i != Size; ++i) {
    MCE.emitByte(Val & 255);
    Val >>= 8;
  }
}

static bool isDisp8(int Value) {
  return Value == (signed char)Value;
}

void Emitter::emitMemModRMByte(const MachineInstr &MI,
                               unsigned Op, unsigned RegOpcodeField) {
  const MachineOperand &Op3 = MI.getOperand(Op+3);
  GlobalValue *GV = 0;
  int DispVal = 0;

  if (Op3.isGlobalAddress()) {
    GV = Op3.getGlobal();
    DispVal = Op3.getOffset();
  } else {
    DispVal = Op3.getImmedValue();
  }

  const MachineOperand &Base     = MI.getOperand(Op);
  const MachineOperand &Scale    = MI.getOperand(Op+1);
  const MachineOperand &IndexReg = MI.getOperand(Op+2);

  unsigned BaseReg = 0;

  if (Base.isConstantPoolIndex()) {
    // Emit a direct address reference [disp32] where the displacement of the
    // constant pool entry is controlled by the MCE.
    assert(!GV && "Constant Pool reference cannot be relative to global!");
    DispVal += MCE.getConstantPoolEntryAddress(Base.getConstantPoolIndex());
  } else {
    BaseReg = Base.getReg();
  }

  // Is a SIB byte needed?
  if (IndexReg.getReg() == 0 && BaseReg != X86::ESP) {
    if (BaseReg == 0) {  // Just a displacement?
      // Emit special case [disp32] encoding
      MCE.emitByte(ModRMByte(0, RegOpcodeField, 5));
      if (GV)
        emitGlobalAddressForPtr(GV, DispVal);
      else
        emitConstant(DispVal, 4);
    } else {
      unsigned BaseRegNo = getX86RegNum(BaseReg);
      if (GV) {
        // Emit the most general non-SIB encoding: [REG+disp32]
        MCE.emitByte(ModRMByte(2, RegOpcodeField, BaseRegNo));
        emitGlobalAddressForPtr(GV, DispVal);
      } else if (DispVal == 0 && BaseRegNo != N86::EBP) {
        // Emit simple indirect register encoding... [EAX] f.e.
        MCE.emitByte(ModRMByte(0, RegOpcodeField, BaseRegNo));
      } else if (isDisp8(DispVal)) {
        // Emit the disp8 encoding... [REG+disp8]
        MCE.emitByte(ModRMByte(1, RegOpcodeField, BaseRegNo));
        emitConstant(DispVal, 1);
      } else {
        // Emit the most general non-SIB encoding: [REG+disp32]
        MCE.emitByte(ModRMByte(2, RegOpcodeField, BaseRegNo));
        emitConstant(DispVal, 4);
      }
    }

  } else {  // We need a SIB byte, so start by outputting the ModR/M byte first
    assert(IndexReg.getReg() != X86::ESP && "Cannot use ESP as index reg!");

    bool ForceDisp32 = false;
    bool ForceDisp8  = false;
    if (BaseReg == 0) {
      // If there is no base register, we emit the special case SIB byte with
      // MOD=0, BASE=5, to JUST get the index, scale, and displacement.
      MCE.emitByte(ModRMByte(0, RegOpcodeField, 4));
      ForceDisp32 = true;
    } else if (GV) {
      // Emit the normal disp32 encoding...
      MCE.emitByte(ModRMByte(2, RegOpcodeField, 4));
      ForceDisp32 = true;
    } else if (DispVal == 0 && BaseReg != X86::EBP) {
      // Emit no displacement ModR/M byte
      MCE.emitByte(ModRMByte(0, RegOpcodeField, 4));
    } else if (isDisp8(DispVal)) {
      // Emit the disp8 encoding...
      MCE.emitByte(ModRMByte(1, RegOpcodeField, 4));
      ForceDisp8 = true;           // Make sure to force 8 bit disp if Base=EBP
    } else {
      // Emit the normal disp32 encoding...
      MCE.emitByte(ModRMByte(2, RegOpcodeField, 4));
    }

    // Calculate what the SS field value should be...
    static const unsigned SSTable[] = { ~0, 0, 1, ~0, 2, ~0, ~0, ~0, 3 };
    unsigned SS = SSTable[Scale.getImmedValue()];

    if (BaseReg == 0) {
      // Handle the SIB byte for the case where there is no base.  The
      // displacement has already been output.
      assert(IndexReg.getReg() && "Index register must be specified!");
      emitSIBByte(SS, getX86RegNum(IndexReg.getReg()), 5);
    } else {
      unsigned BaseRegNo = getX86RegNum(BaseReg);
      unsigned IndexRegNo;
      if (IndexReg.getReg())
        IndexRegNo = getX86RegNum(IndexReg.getReg());
      else
        IndexRegNo = 4;   // For example [ESP+1*<noreg>+4]
      emitSIBByte(SS, IndexRegNo, BaseRegNo);
    }

    // Do we need to output a displacement?
    if (DispVal != 0 || ForceDisp32 || ForceDisp8) {
      if (!ForceDisp32 && isDisp8(DispVal))
        emitConstant(DispVal, 1);
      else if (GV)
        emitGlobalAddressForPtr(GV, DispVal);
      else
        emitConstant(DispVal, 4);
    }
  }
}

static unsigned sizeOfImm(const TargetInstrDescriptor &Desc) {
  switch (Desc.TSFlags & X86II::ImmMask) {
  case X86II::Imm8:   return 1;
  case X86II::Imm16:  return 2;
  case X86II::Imm32:  return 4;
  default: assert(0 && "Immediate size not set!");
    return 0;
  }
}

void Emitter::emitInstruction(const MachineInstr &MI) {
  NumEmitted++;  // Keep track of the # of mi's emitted

  unsigned Opcode = MI.getOpcode();
  const TargetInstrDescriptor &Desc = II->get(Opcode);

  // Emit the repeat opcode prefix as needed.
  if ((Desc.TSFlags & X86II::Op0Mask) == X86II::REP) MCE.emitByte(0xF3);

  // Emit the operand size opcode prefix as needed.
  if (Desc.TSFlags & X86II::OpSize) MCE.emitByte(0x66);

  switch (Desc.TSFlags & X86II::Op0Mask) {
  case X86II::TB:
    MCE.emitByte(0x0F);   // Two-byte opcode prefix
    break;
  case X86II::REP: break; // already handled.
  case X86II::XS:   // F3 0F
    MCE.emitByte(0xF3);
    MCE.emitByte(0x0F);
    break;
  case X86II::XD:   // F2 0F
    MCE.emitByte(0xF2);
    MCE.emitByte(0x0F);
    break;
  case X86II::D8: case X86II::D9: case X86II::DA: case X86II::DB:
  case X86II::DC: case X86II::DD: case X86II::DE: case X86II::DF:
    MCE.emitByte(0xD8+
                 (((Desc.TSFlags & X86II::Op0Mask)-X86II::D8)
                                   >> X86II::Op0Shift));
    break; // Two-byte opcode prefix
  default: assert(0 && "Invalid prefix!");
  case 0: break;  // No prefix!
  }

  unsigned char BaseOpcode = II->getBaseOpcodeFor(Opcode);
  switch (Desc.TSFlags & X86II::FormMask) {
  default: assert(0 && "Unknown FormMask value in X86 MachineCodeEmitter!");
  case X86II::Pseudo:
#ifndef NDEBUG
    switch (Opcode) {
    default: 
      assert(0 && "psuedo instructions should be removed before code emission");
    case X86::IMPLICIT_USE:
    case X86::IMPLICIT_DEF:
    case X86::IMPLICIT_DEF_R8:
    case X86::IMPLICIT_DEF_R16:
    case X86::IMPLICIT_DEF_R32:
    case X86::IMPLICIT_DEF_FR32:
    case X86::IMPLICIT_DEF_FR64:
    case X86::FP_REG_KILL:
      break;
    }
#endif
    break;

  case X86II::RawFrm:
    MCE.emitByte(BaseOpcode);
    if (MI.getNumOperands() == 1) {
      const MachineOperand &MO = MI.getOperand(0);
      if (MO.isMachineBasicBlock()) {
        emitPCRelativeBlockAddress(MO.getMachineBasicBlock());
      } else if (MO.isGlobalAddress()) {
        bool isTailCall = Opcode == X86::TAILJMPd ||
                          Opcode == X86::TAILJMPr || Opcode == X86::TAILJMPm;
        emitGlobalAddressForCall(MO.getGlobal(), isTailCall);
      } else if (MO.isExternalSymbol()) {
        bool isTailCall = Opcode == X86::TAILJMPd ||
                          Opcode == X86::TAILJMPr || Opcode == X86::TAILJMPm;
        emitExternalSymbolAddress(MO.getSymbolName(), true, isTailCall);
      } else if (MO.isImmediate()) {
        emitConstant(MO.getImmedValue(), sizeOfImm(Desc));
      } else {
        assert(0 && "Unknown RawFrm operand!");
      }
    }
    break;

  case X86II::AddRegFrm:
    MCE.emitByte(BaseOpcode + getX86RegNum(MI.getOperand(0).getReg()));
    if (MI.getNumOperands() == 2) {
      const MachineOperand &MO1 = MI.getOperand(1);
      if (Value *V = MO1.getVRegValueOrNull()) {
        assert(sizeOfImm(Desc) == 4 &&
               "Don't know how to emit non-pointer values!");
        emitGlobalAddressForPtr(cast<GlobalValue>(V));
      } else if (MO1.isGlobalAddress()) {
        assert(sizeOfImm(Desc) == 4 &&
               "Don't know how to emit non-pointer values!");
        assert(!MO1.isPCRelative() && "Function pointer ref is PC relative?");
        emitGlobalAddressForPtr(MO1.getGlobal(), MO1.getOffset());
      } else if (MO1.isExternalSymbol()) {
        assert(sizeOfImm(Desc) == 4 &&
               "Don't know how to emit non-pointer values!");
        emitExternalSymbolAddress(MO1.getSymbolName(), false, false);
      } else {
        emitConstant(MO1.getImmedValue(), sizeOfImm(Desc));
      }
    }
    break;

  case X86II::MRMDestReg: {
    MCE.emitByte(BaseOpcode);
    emitRegModRMByte(MI.getOperand(0).getReg(),
                     getX86RegNum(MI.getOperand(1).getReg()));
    if (MI.getNumOperands() == 3)
      emitConstant(MI.getOperand(2).getImmedValue(), sizeOfImm(Desc));
    break;
  }
  case X86II::MRMDestMem:
    MCE.emitByte(BaseOpcode);
    emitMemModRMByte(MI, 0, getX86RegNum(MI.getOperand(4).getReg()));
    if (MI.getNumOperands() == 6)
      emitConstant(MI.getOperand(5).getImmedValue(), sizeOfImm(Desc));
    break;

  case X86II::MRMSrcReg:
    MCE.emitByte(BaseOpcode);
    emitRegModRMByte(MI.getOperand(1).getReg(),
                     getX86RegNum(MI.getOperand(0).getReg()));
    if (MI.getNumOperands() == 3)
      emitConstant(MI.getOperand(2).getImmedValue(), sizeOfImm(Desc));
    break;

  case X86II::MRMSrcMem:
    MCE.emitByte(BaseOpcode);
    emitMemModRMByte(MI, 1, getX86RegNum(MI.getOperand(0).getReg()));
    if (MI.getNumOperands() == 2+4)
      emitConstant(MI.getOperand(5).getImmedValue(), sizeOfImm(Desc));
    break;

  case X86II::MRM0r: case X86II::MRM1r:
  case X86II::MRM2r: case X86II::MRM3r:
  case X86II::MRM4r: case X86II::MRM5r:
  case X86II::MRM6r: case X86II::MRM7r:
    MCE.emitByte(BaseOpcode);
    emitRegModRMByte(MI.getOperand(0).getReg(),
                     (Desc.TSFlags & X86II::FormMask)-X86II::MRM0r);

    if (MI.getOperand(MI.getNumOperands()-1).isImmediate()) {
      emitConstant(MI.getOperand(MI.getNumOperands()-1).getImmedValue(),
                   sizeOfImm(Desc));
    }
    break;

  case X86II::MRM0m: case X86II::MRM1m:
  case X86II::MRM2m: case X86II::MRM3m:
  case X86II::MRM4m: case X86II::MRM5m:
  case X86II::MRM6m: case X86II::MRM7m:
    MCE.emitByte(BaseOpcode);
    emitMemModRMByte(MI, 0, (Desc.TSFlags & X86II::FormMask)-X86II::MRM0m);

    if (MI.getNumOperands() == 5) {
      if (MI.getOperand(4).isImmediate())
        emitConstant(MI.getOperand(4).getImmedValue(), sizeOfImm(Desc));
      else if (MI.getOperand(4).isGlobalAddress())
        emitGlobalAddressForPtr(MI.getOperand(4).getGlobal(),
                                MI.getOperand(4).getOffset());
      else
        assert(0 && "Unknown operand!");
    }
    break;

  case X86II::MRMInitReg:
    MCE.emitByte(BaseOpcode);
    emitRegModRMByte(MI.getOperand(0).getReg(),
                     getX86RegNum(MI.getOperand(0).getReg()));
    break;
  }
}
