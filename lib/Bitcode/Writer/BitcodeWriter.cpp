//===--- Bitcode/Writer/BitcodeWriter.cpp - Bitcode Writer ----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Bitcode writer implementation.
//
//===----------------------------------------------------------------------===//

#include "ValueEnumerator.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/BlockFrequencyInfoImpl.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Bitcode/BitstreamWriter.h"
#include "llvm/Bitcode/LLVMBitCodes.h"
#include "llvm/Bitcode/ReaderWriter.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/UseListOrder.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/Program.h"
#include "llvm/Support/raw_ostream.h"
#include <cctype>
#include <map>
using namespace llvm;

/// These are manifest constants used by the bitcode writer. They do not need to
/// be kept in sync with the reader, but need to be consistent within this file.
enum {
  // VALUE_SYMTAB_BLOCK abbrev id's.
  VST_ENTRY_8_ABBREV = bitc::FIRST_APPLICATION_ABBREV,
  VST_ENTRY_7_ABBREV,
  VST_ENTRY_6_ABBREV,
  VST_BBENTRY_6_ABBREV,

  // CONSTANTS_BLOCK abbrev id's.
  CONSTANTS_SETTYPE_ABBREV = bitc::FIRST_APPLICATION_ABBREV,
  CONSTANTS_INTEGER_ABBREV,
  CONSTANTS_CE_CAST_Abbrev,
  CONSTANTS_NULL_Abbrev,

  // FUNCTION_BLOCK abbrev id's.
  FUNCTION_INST_LOAD_ABBREV = bitc::FIRST_APPLICATION_ABBREV,
  FUNCTION_INST_BINOP_ABBREV,
  FUNCTION_INST_BINOP_FLAGS_ABBREV,
  FUNCTION_INST_CAST_ABBREV,
  FUNCTION_INST_RET_VOID_ABBREV,
  FUNCTION_INST_RET_VAL_ABBREV,
  FUNCTION_INST_UNREACHABLE_ABBREV,
  FUNCTION_INST_GEP_ABBREV,
};

static unsigned GetEncodedCastOpcode(unsigned Opcode) {
  switch (Opcode) {
  default: llvm_unreachable("Unknown cast instruction!");
  case Instruction::Trunc   : return bitc::CAST_TRUNC;
  case Instruction::ZExt    : return bitc::CAST_ZEXT;
  case Instruction::SExt    : return bitc::CAST_SEXT;
  case Instruction::FPToUI  : return bitc::CAST_FPTOUI;
  case Instruction::FPToSI  : return bitc::CAST_FPTOSI;
  case Instruction::UIToFP  : return bitc::CAST_UITOFP;
  case Instruction::SIToFP  : return bitc::CAST_SITOFP;
  case Instruction::FPTrunc : return bitc::CAST_FPTRUNC;
  case Instruction::FPExt   : return bitc::CAST_FPEXT;
  case Instruction::PtrToInt: return bitc::CAST_PTRTOINT;
  case Instruction::IntToPtr: return bitc::CAST_INTTOPTR;
  case Instruction::BitCast : return bitc::CAST_BITCAST;
  case Instruction::AddrSpaceCast: return bitc::CAST_ADDRSPACECAST;
  }
}

static unsigned GetEncodedBinaryOpcode(unsigned Opcode) {
  switch (Opcode) {
  default: llvm_unreachable("Unknown binary instruction!");
  case Instruction::Add:
  case Instruction::FAdd: return bitc::BINOP_ADD;
  case Instruction::Sub:
  case Instruction::FSub: return bitc::BINOP_SUB;
  case Instruction::Mul:
  case Instruction::FMul: return bitc::BINOP_MUL;
  case Instruction::UDiv: return bitc::BINOP_UDIV;
  case Instruction::FDiv:
  case Instruction::SDiv: return bitc::BINOP_SDIV;
  case Instruction::URem: return bitc::BINOP_UREM;
  case Instruction::FRem:
  case Instruction::SRem: return bitc::BINOP_SREM;
  case Instruction::Shl:  return bitc::BINOP_SHL;
  case Instruction::LShr: return bitc::BINOP_LSHR;
  case Instruction::AShr: return bitc::BINOP_ASHR;
  case Instruction::And:  return bitc::BINOP_AND;
  case Instruction::Or:   return bitc::BINOP_OR;
  case Instruction::Xor:  return bitc::BINOP_XOR;
  }
}

static unsigned GetEncodedRMWOperation(AtomicRMWInst::BinOp Op) {
  switch (Op) {
  default: llvm_unreachable("Unknown RMW operation!");
  case AtomicRMWInst::Xchg: return bitc::RMW_XCHG;
  case AtomicRMWInst::Add: return bitc::RMW_ADD;
  case AtomicRMWInst::Sub: return bitc::RMW_SUB;
  case AtomicRMWInst::And: return bitc::RMW_AND;
  case AtomicRMWInst::Nand: return bitc::RMW_NAND;
  case AtomicRMWInst::Or: return bitc::RMW_OR;
  case AtomicRMWInst::Xor: return bitc::RMW_XOR;
  case AtomicRMWInst::Max: return bitc::RMW_MAX;
  case AtomicRMWInst::Min: return bitc::RMW_MIN;
  case AtomicRMWInst::UMax: return bitc::RMW_UMAX;
  case AtomicRMWInst::UMin: return bitc::RMW_UMIN;
  }
}

static unsigned GetEncodedOrdering(AtomicOrdering Ordering) {
  switch (Ordering) {
  case NotAtomic: return bitc::ORDERING_NOTATOMIC;
  case Unordered: return bitc::ORDERING_UNORDERED;
  case Monotonic: return bitc::ORDERING_MONOTONIC;
  case Acquire: return bitc::ORDERING_ACQUIRE;
  case Release: return bitc::ORDERING_RELEASE;
  case AcquireRelease: return bitc::ORDERING_ACQREL;
  case SequentiallyConsistent: return bitc::ORDERING_SEQCST;
  }
  llvm_unreachable("Invalid ordering");
}

static unsigned GetEncodedSynchScope(SynchronizationScope SynchScope) {
  switch (SynchScope) {
  case SingleThread: return bitc::SYNCHSCOPE_SINGLETHREAD;
  case CrossThread: return bitc::SYNCHSCOPE_CROSSTHREAD;
  }
  llvm_unreachable("Invalid synch scope");
}

static void WriteStringRecord(unsigned Code, StringRef Str,
                              unsigned AbbrevToUse, BitstreamWriter &Stream) {
  SmallVector<unsigned, 64> Vals;

  // Code: [strchar x N]
  for (unsigned i = 0, e = Str.size(); i != e; ++i) {
    if (AbbrevToUse && !BitCodeAbbrevOp::isChar6(Str[i]))
      AbbrevToUse = 0;
    Vals.push_back(Str[i]);
  }

  // Emit the finished record.
  Stream.EmitRecord(Code, Vals, AbbrevToUse);
}

static uint64_t getAttrKindEncoding(Attribute::AttrKind Kind) {
  switch (Kind) {
  case Attribute::Alignment:
    return bitc::ATTR_KIND_ALIGNMENT;
  case Attribute::AlwaysInline:
    return bitc::ATTR_KIND_ALWAYS_INLINE;
  case Attribute::ArgMemOnly:
    return bitc::ATTR_KIND_ARGMEMONLY;
  case Attribute::Builtin:
    return bitc::ATTR_KIND_BUILTIN;
  case Attribute::ByVal:
    return bitc::ATTR_KIND_BY_VAL;
  case Attribute::Convergent:
    return bitc::ATTR_KIND_CONVERGENT;
  case Attribute::InAlloca:
    return bitc::ATTR_KIND_IN_ALLOCA;
  case Attribute::Cold:
    return bitc::ATTR_KIND_COLD;
  case Attribute::InaccessibleMemOnly:
    return bitc::ATTR_KIND_INACCESSIBLEMEM_ONLY;
  case Attribute::InaccessibleMemOrArgMemOnly:
    return bitc::ATTR_KIND_INACCESSIBLEMEM_OR_ARGMEMONLY;
  case Attribute::InlineHint:
    return bitc::ATTR_KIND_INLINE_HINT;
  case Attribute::InReg:
    return bitc::ATTR_KIND_IN_REG;
  case Attribute::JumpTable:
    return bitc::ATTR_KIND_JUMP_TABLE;
  case Attribute::MinSize:
    return bitc::ATTR_KIND_MIN_SIZE;
  case Attribute::Naked:
    return bitc::ATTR_KIND_NAKED;
  case Attribute::Nest:
    return bitc::ATTR_KIND_NEST;
  case Attribute::NoAlias:
    return bitc::ATTR_KIND_NO_ALIAS;
  case Attribute::NoBuiltin:
    return bitc::ATTR_KIND_NO_BUILTIN;
  case Attribute::NoCapture:
    return bitc::ATTR_KIND_NO_CAPTURE;
  case Attribute::NoDuplicate:
    return bitc::ATTR_KIND_NO_DUPLICATE;
  case Attribute::NoImplicitFloat:
    return bitc::ATTR_KIND_NO_IMPLICIT_FLOAT;
  case Attribute::NoInline:
    return bitc::ATTR_KIND_NO_INLINE;
  case Attribute::NoRecurse:
    return bitc::ATTR_KIND_NO_RECURSE;
  case Attribute::NonLazyBind:
    return bitc::ATTR_KIND_NON_LAZY_BIND;
  case Attribute::NonNull:
    return bitc::ATTR_KIND_NON_NULL;
  case Attribute::Dereferenceable:
    return bitc::ATTR_KIND_DEREFERENCEABLE;
  case Attribute::DereferenceableOrNull:
    return bitc::ATTR_KIND_DEREFERENCEABLE_OR_NULL;
  case Attribute::NoRedZone:
    return bitc::ATTR_KIND_NO_RED_ZONE;
  case Attribute::NoReturn:
    return bitc::ATTR_KIND_NO_RETURN;
  case Attribute::NoUnwind:
    return bitc::ATTR_KIND_NO_UNWIND;
  case Attribute::OptimizeForSize:
    return bitc::ATTR_KIND_OPTIMIZE_FOR_SIZE;
  case Attribute::OptimizeNone:
    return bitc::ATTR_KIND_OPTIMIZE_NONE;
  case Attribute::ReadNone:
    return bitc::ATTR_KIND_READ_NONE;
  case Attribute::ReadOnly:
    return bitc::ATTR_KIND_READ_ONLY;
  case Attribute::Returned:
    return bitc::ATTR_KIND_RETURNED;
  case Attribute::ReturnsTwice:
    return bitc::ATTR_KIND_RETURNS_TWICE;
  case Attribute::SExt:
    return bitc::ATTR_KIND_S_EXT;
  case Attribute::StackAlignment:
    return bitc::ATTR_KIND_STACK_ALIGNMENT;
  case Attribute::StackProtect:
    return bitc::ATTR_KIND_STACK_PROTECT;
  case Attribute::StackProtectReq:
    return bitc::ATTR_KIND_STACK_PROTECT_REQ;
  case Attribute::StackProtectStrong:
    return bitc::ATTR_KIND_STACK_PROTECT_STRONG;
  case Attribute::SafeStack:
    return bitc::ATTR_KIND_SAFESTACK;
  case Attribute::StructRet:
    return bitc::ATTR_KIND_STRUCT_RET;
  case Attribute::SanitizeAddress:
    return bitc::ATTR_KIND_SANITIZE_ADDRESS;
  case Attribute::SanitizeThread:
    return bitc::ATTR_KIND_SANITIZE_THREAD;
  case Attribute::SanitizeMemory:
    return bitc::ATTR_KIND_SANITIZE_MEMORY;
  case Attribute::UWTable:
    return bitc::ATTR_KIND_UW_TABLE;
  case Attribute::ZExt:
    return bitc::ATTR_KIND_Z_EXT;
  case Attribute::EndAttrKinds:
    llvm_unreachable("Can not encode end-attribute kinds marker.");
  case Attribute::None:
    llvm_unreachable("Can not encode none-attribute.");
  }

  llvm_unreachable("Trying to encode unknown attribute");
}

static void WriteAttributeGroupTable(const ValueEnumerator &VE,
                                     BitstreamWriter &Stream) {
  const std::vector<AttributeSet> &AttrGrps = VE.getAttributeGroups();
  if (AttrGrps.empty()) return;

  Stream.EnterSubblock(bitc::PARAMATTR_GROUP_BLOCK_ID, 3);

  SmallVector<uint64_t, 64> Record;
  for (unsigned i = 0, e = AttrGrps.size(); i != e; ++i) {
    AttributeSet AS = AttrGrps[i];
    for (unsigned i = 0, e = AS.getNumSlots(); i != e; ++i) {
      AttributeSet A = AS.getSlotAttributes(i);

      Record.push_back(VE.getAttributeGroupID(A));
      Record.push_back(AS.getSlotIndex(i));

      for (AttributeSet::iterator I = AS.begin(0), E = AS.end(0);
           I != E; ++I) {
        Attribute Attr = *I;
        if (Attr.isEnumAttribute()) {
          Record.push_back(0);
          Record.push_back(getAttrKindEncoding(Attr.getKindAsEnum()));
        } else if (Attr.isIntAttribute()) {
          Record.push_back(1);
          Record.push_back(getAttrKindEncoding(Attr.getKindAsEnum()));
          Record.push_back(Attr.getValueAsInt());
        } else {
          StringRef Kind = Attr.getKindAsString();
          StringRef Val = Attr.getValueAsString();

          Record.push_back(Val.empty() ? 3 : 4);
          Record.append(Kind.begin(), Kind.end());
          Record.push_back(0);
          if (!Val.empty()) {
            Record.append(Val.begin(), Val.end());
            Record.push_back(0);
          }
        }
      }

      Stream.EmitRecord(bitc::PARAMATTR_GRP_CODE_ENTRY, Record);
      Record.clear();
    }
  }

  Stream.ExitBlock();
}

static void WriteAttributeTable(const ValueEnumerator &VE,
                                BitstreamWriter &Stream) {
  const std::vector<AttributeSet> &Attrs = VE.getAttributes();
  if (Attrs.empty()) return;

  Stream.EnterSubblock(bitc::PARAMATTR_BLOCK_ID, 3);

  SmallVector<uint64_t, 64> Record;
  for (unsigned i = 0, e = Attrs.size(); i != e; ++i) {
    const AttributeSet &A = Attrs[i];
    for (unsigned i = 0, e = A.getNumSlots(); i != e; ++i)
      Record.push_back(VE.getAttributeGroupID(A.getSlotAttributes(i)));

    Stream.EmitRecord(bitc::PARAMATTR_CODE_ENTRY, Record);
    Record.clear();
  }

  Stream.ExitBlock();
}

/// WriteTypeTable - Write out the type table for a module.
static void WriteTypeTable(const ValueEnumerator &VE, BitstreamWriter &Stream) {
  const ValueEnumerator::TypeList &TypeList = VE.getTypes();

  Stream.EnterSubblock(bitc::TYPE_BLOCK_ID_NEW, 4 /*count from # abbrevs */);
  SmallVector<uint64_t, 64> TypeVals;

  uint64_t NumBits = VE.computeBitsRequiredForTypeIndicies();

  // Abbrev for TYPE_CODE_POINTER.
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_POINTER));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, NumBits));
  Abbv->Add(BitCodeAbbrevOp(0));  // Addrspace = 0
  unsigned PtrAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for TYPE_CODE_FUNCTION.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_FUNCTION));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));  // isvararg
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, NumBits));

  unsigned FunctionAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for TYPE_CODE_STRUCT_ANON.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_STRUCT_ANON));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));  // ispacked
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, NumBits));

  unsigned StructAnonAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for TYPE_CODE_STRUCT_NAME.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_STRUCT_NAME));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
  unsigned StructNameAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for TYPE_CODE_STRUCT_NAMED.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_STRUCT_NAMED));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));  // ispacked
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, NumBits));

  unsigned StructNamedAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for TYPE_CODE_ARRAY.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::TYPE_CODE_ARRAY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // size
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, NumBits));

  unsigned ArrayAbbrev = Stream.EmitAbbrev(Abbv);

  // Emit an entry count so the reader can reserve space.
  TypeVals.push_back(TypeList.size());
  Stream.EmitRecord(bitc::TYPE_CODE_NUMENTRY, TypeVals);
  TypeVals.clear();

  // Loop over all of the types, emitting each in turn.
  for (unsigned i = 0, e = TypeList.size(); i != e; ++i) {
    Type *T = TypeList[i];
    int AbbrevToUse = 0;
    unsigned Code = 0;

    switch (T->getTypeID()) {
    case Type::VoidTyID:      Code = bitc::TYPE_CODE_VOID;      break;
    case Type::HalfTyID:      Code = bitc::TYPE_CODE_HALF;      break;
    case Type::FloatTyID:     Code = bitc::TYPE_CODE_FLOAT;     break;
    case Type::DoubleTyID:    Code = bitc::TYPE_CODE_DOUBLE;    break;
    case Type::X86_FP80TyID:  Code = bitc::TYPE_CODE_X86_FP80;  break;
    case Type::FP128TyID:     Code = bitc::TYPE_CODE_FP128;     break;
    case Type::PPC_FP128TyID: Code = bitc::TYPE_CODE_PPC_FP128; break;
    case Type::LabelTyID:     Code = bitc::TYPE_CODE_LABEL;     break;
    case Type::MetadataTyID:  Code = bitc::TYPE_CODE_METADATA;  break;
    case Type::X86_MMXTyID:   Code = bitc::TYPE_CODE_X86_MMX;   break;
    case Type::TokenTyID:     Code = bitc::TYPE_CODE_TOKEN;     break;
    case Type::IntegerTyID:
      // INTEGER: [width]
      Code = bitc::TYPE_CODE_INTEGER;
      TypeVals.push_back(cast<IntegerType>(T)->getBitWidth());
      break;
    case Type::PointerTyID: {
      PointerType *PTy = cast<PointerType>(T);
      // POINTER: [pointee type, address space]
      Code = bitc::TYPE_CODE_POINTER;
      TypeVals.push_back(VE.getTypeID(PTy->getElementType()));
      unsigned AddressSpace = PTy->getAddressSpace();
      TypeVals.push_back(AddressSpace);
      if (AddressSpace == 0) AbbrevToUse = PtrAbbrev;
      break;
    }
    case Type::FunctionTyID: {
      FunctionType *FT = cast<FunctionType>(T);
      // FUNCTION: [isvararg, retty, paramty x N]
      Code = bitc::TYPE_CODE_FUNCTION;
      TypeVals.push_back(FT->isVarArg());
      TypeVals.push_back(VE.getTypeID(FT->getReturnType()));
      for (unsigned i = 0, e = FT->getNumParams(); i != e; ++i)
        TypeVals.push_back(VE.getTypeID(FT->getParamType(i)));
      AbbrevToUse = FunctionAbbrev;
      break;
    }
    case Type::StructTyID: {
      StructType *ST = cast<StructType>(T);
      // STRUCT: [ispacked, eltty x N]
      TypeVals.push_back(ST->isPacked());
      // Output all of the element types.
      for (StructType::element_iterator I = ST->element_begin(),
           E = ST->element_end(); I != E; ++I)
        TypeVals.push_back(VE.getTypeID(*I));

      if (ST->isLiteral()) {
        Code = bitc::TYPE_CODE_STRUCT_ANON;
        AbbrevToUse = StructAnonAbbrev;
      } else {
        if (ST->isOpaque()) {
          Code = bitc::TYPE_CODE_OPAQUE;
        } else {
          Code = bitc::TYPE_CODE_STRUCT_NAMED;
          AbbrevToUse = StructNamedAbbrev;
        }

        // Emit the name if it is present.
        if (!ST->getName().empty())
          WriteStringRecord(bitc::TYPE_CODE_STRUCT_NAME, ST->getName(),
                            StructNameAbbrev, Stream);
      }
      break;
    }
    case Type::ArrayTyID: {
      ArrayType *AT = cast<ArrayType>(T);
      // ARRAY: [numelts, eltty]
      Code = bitc::TYPE_CODE_ARRAY;
      TypeVals.push_back(AT->getNumElements());
      TypeVals.push_back(VE.getTypeID(AT->getElementType()));
      AbbrevToUse = ArrayAbbrev;
      break;
    }
    case Type::VectorTyID: {
      VectorType *VT = cast<VectorType>(T);
      // VECTOR [numelts, eltty]
      Code = bitc::TYPE_CODE_VECTOR;
      TypeVals.push_back(VT->getNumElements());
      TypeVals.push_back(VE.getTypeID(VT->getElementType()));
      break;
    }
    }

    // Emit the finished record.
    Stream.EmitRecord(Code, TypeVals, AbbrevToUse);
    TypeVals.clear();
  }

  Stream.ExitBlock();
}

static unsigned getEncodedLinkage(const GlobalValue::LinkageTypes Linkage) {
  switch (Linkage) {
  case GlobalValue::ExternalLinkage:
    return 0;
  case GlobalValue::WeakAnyLinkage:
    return 16;
  case GlobalValue::AppendingLinkage:
    return 2;
  case GlobalValue::InternalLinkage:
    return 3;
  case GlobalValue::LinkOnceAnyLinkage:
    return 18;
  case GlobalValue::ExternalWeakLinkage:
    return 7;
  case GlobalValue::CommonLinkage:
    return 8;
  case GlobalValue::PrivateLinkage:
    return 9;
  case GlobalValue::WeakODRLinkage:
    return 17;
  case GlobalValue::LinkOnceODRLinkage:
    return 19;
  case GlobalValue::AvailableExternallyLinkage:
    return 12;
  }
  llvm_unreachable("Invalid linkage");
}

static unsigned getEncodedLinkage(const GlobalValue &GV) {
  return getEncodedLinkage(GV.getLinkage());
}

static unsigned getEncodedVisibility(const GlobalValue &GV) {
  switch (GV.getVisibility()) {
  case GlobalValue::DefaultVisibility:   return 0;
  case GlobalValue::HiddenVisibility:    return 1;
  case GlobalValue::ProtectedVisibility: return 2;
  }
  llvm_unreachable("Invalid visibility");
}

static unsigned getEncodedDLLStorageClass(const GlobalValue &GV) {
  switch (GV.getDLLStorageClass()) {
  case GlobalValue::DefaultStorageClass:   return 0;
  case GlobalValue::DLLImportStorageClass: return 1;
  case GlobalValue::DLLExportStorageClass: return 2;
  }
  llvm_unreachable("Invalid DLL storage class");
}

static unsigned getEncodedThreadLocalMode(const GlobalValue &GV) {
  switch (GV.getThreadLocalMode()) {
    case GlobalVariable::NotThreadLocal:         return 0;
    case GlobalVariable::GeneralDynamicTLSModel: return 1;
    case GlobalVariable::LocalDynamicTLSModel:   return 2;
    case GlobalVariable::InitialExecTLSModel:    return 3;
    case GlobalVariable::LocalExecTLSModel:      return 4;
  }
  llvm_unreachable("Invalid TLS model");
}

static unsigned getEncodedComdatSelectionKind(const Comdat &C) {
  switch (C.getSelectionKind()) {
  case Comdat::Any:
    return bitc::COMDAT_SELECTION_KIND_ANY;
  case Comdat::ExactMatch:
    return bitc::COMDAT_SELECTION_KIND_EXACT_MATCH;
  case Comdat::Largest:
    return bitc::COMDAT_SELECTION_KIND_LARGEST;
  case Comdat::NoDuplicates:
    return bitc::COMDAT_SELECTION_KIND_NO_DUPLICATES;
  case Comdat::SameSize:
    return bitc::COMDAT_SELECTION_KIND_SAME_SIZE;
  }
  llvm_unreachable("Invalid selection kind");
}

static void writeComdats(const ValueEnumerator &VE, BitstreamWriter &Stream) {
  SmallVector<unsigned, 64> Vals;
  for (const Comdat *C : VE.getComdats()) {
    // COMDAT: [selection_kind, name]
    Vals.push_back(getEncodedComdatSelectionKind(*C));
    size_t Size = C->getName().size();
    assert(isUInt<32>(Size));
    Vals.push_back(Size);
    for (char Chr : C->getName())
      Vals.push_back((unsigned char)Chr);
    Stream.EmitRecord(bitc::MODULE_CODE_COMDAT, Vals, /*AbbrevToUse=*/0);
    Vals.clear();
  }
}

/// Write a record that will eventually hold the word offset of the
/// module-level VST. For now the offset is 0, which will be backpatched
/// after the real VST is written. Returns the bit offset to backpatch.
static uint64_t WriteValueSymbolTableForwardDecl(BitstreamWriter &Stream) {
  // Write a placeholder value in for the offset of the real VST,
  // which is written after the function blocks so that it can include
  // the offset of each function. The placeholder offset will be
  // updated when the real VST is written.
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::MODULE_CODE_VSTOFFSET));
  // Blocks are 32-bit aligned, so we can use a 32-bit word offset to
  // hold the real VST offset. Must use fixed instead of VBR as we don't
  // know how many VBR chunks to reserve ahead of time.
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 32));
  unsigned VSTOffsetAbbrev = Stream.EmitAbbrev(Abbv);

  // Emit the placeholder
  uint64_t Vals[] = {bitc::MODULE_CODE_VSTOFFSET, 0};
  Stream.EmitRecordWithAbbrev(VSTOffsetAbbrev, Vals);

  // Compute and return the bit offset to the placeholder, which will be
  // patched when the real VST is written. We can simply subtract the 32-bit
  // fixed size from the current bit number to get the location to backpatch.
  return Stream.GetCurrentBitNo() - 32;
}

enum StringEncoding { SE_Char6, SE_Fixed7, SE_Fixed8 };

/// Determine the encoding to use for the given string name and length.
static StringEncoding getStringEncoding(const char *Str, unsigned StrLen) {
  bool isChar6 = true;
  for (const char *C = Str, *E = C + StrLen; C != E; ++C) {
    if (isChar6)
      isChar6 = BitCodeAbbrevOp::isChar6(*C);
    if ((unsigned char)*C & 128)
      // don't bother scanning the rest.
      return SE_Fixed8;
  }
  if (isChar6)
    return SE_Char6;
  else
    return SE_Fixed7;
}

/// Emit top-level description of module, including target triple, inline asm,
/// descriptors for global variables, and function prototype info.
/// Returns the bit offset to backpatch with the location of the real VST.
static uint64_t WriteModuleInfo(const Module *M, const ValueEnumerator &VE,
                                BitstreamWriter &Stream) {
  // Emit various pieces of data attached to a module.
  if (!M->getTargetTriple().empty())
    WriteStringRecord(bitc::MODULE_CODE_TRIPLE, M->getTargetTriple(),
                      0/*TODO*/, Stream);
  const std::string &DL = M->getDataLayoutStr();
  if (!DL.empty())
    WriteStringRecord(bitc::MODULE_CODE_DATALAYOUT, DL, 0 /*TODO*/, Stream);
  if (!M->getModuleInlineAsm().empty())
    WriteStringRecord(bitc::MODULE_CODE_ASM, M->getModuleInlineAsm(),
                      0/*TODO*/, Stream);

  // Emit information about sections and GC, computing how many there are. Also
  // compute the maximum alignment value.
  std::map<std::string, unsigned> SectionMap;
  std::map<std::string, unsigned> GCMap;
  unsigned MaxAlignment = 0;
  unsigned MaxGlobalType = 0;
  for (const GlobalValue &GV : M->globals()) {
    MaxAlignment = std::max(MaxAlignment, GV.getAlignment());
    MaxGlobalType = std::max(MaxGlobalType, VE.getTypeID(GV.getValueType()));
    if (GV.hasSection()) {
      // Give section names unique ID's.
      unsigned &Entry = SectionMap[GV.getSection()];
      if (!Entry) {
        WriteStringRecord(bitc::MODULE_CODE_SECTIONNAME, GV.getSection(),
                          0/*TODO*/, Stream);
        Entry = SectionMap.size();
      }
    }
  }
  for (const Function &F : *M) {
    MaxAlignment = std::max(MaxAlignment, F.getAlignment());
    if (F.hasSection()) {
      // Give section names unique ID's.
      unsigned &Entry = SectionMap[F.getSection()];
      if (!Entry) {
        WriteStringRecord(bitc::MODULE_CODE_SECTIONNAME, F.getSection(),
                          0/*TODO*/, Stream);
        Entry = SectionMap.size();
      }
    }
    if (F.hasGC()) {
      // Same for GC names.
      unsigned &Entry = GCMap[F.getGC()];
      if (!Entry) {
        WriteStringRecord(bitc::MODULE_CODE_GCNAME, F.getGC(),
                          0/*TODO*/, Stream);
        Entry = GCMap.size();
      }
    }
  }

  // Emit abbrev for globals, now that we know # sections and max alignment.
  unsigned SimpleGVarAbbrev = 0;
  if (!M->global_empty()) {
    // Add an abbrev for common globals with no visibility or thread localness.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::MODULE_CODE_GLOBALVAR));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,
                              Log2_32_Ceil(MaxGlobalType+1)));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));   // AddrSpace << 2
                                                           //| explicitType << 1
                                                           //| constant
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));   // Initializer.
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // Linkage.
    if (MaxAlignment == 0)                                 // Alignment.
      Abbv->Add(BitCodeAbbrevOp(0));
    else {
      unsigned MaxEncAlignment = Log2_32(MaxAlignment)+1;
      Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,
                               Log2_32_Ceil(MaxEncAlignment+1)));
    }
    if (SectionMap.empty())                                    // Section.
      Abbv->Add(BitCodeAbbrevOp(0));
    else
      Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,
                               Log2_32_Ceil(SectionMap.size()+1)));
    // Don't bother emitting vis + thread local.
    SimpleGVarAbbrev = Stream.EmitAbbrev(Abbv);
  }

  // Emit the global variable information.
  SmallVector<unsigned, 64> Vals;
  for (const GlobalVariable &GV : M->globals()) {
    unsigned AbbrevToUse = 0;

    // GLOBALVAR: [type, isconst, initid,
    //             linkage, alignment, section, visibility, threadlocal,
    //             unnamed_addr, externally_initialized, dllstorageclass,
    //             comdat]
    Vals.push_back(VE.getTypeID(GV.getValueType()));
    Vals.push_back(GV.getType()->getAddressSpace() << 2 | 2 | GV.isConstant());
    Vals.push_back(GV.isDeclaration() ? 0 :
                   (VE.getValueID(GV.getInitializer()) + 1));
    Vals.push_back(getEncodedLinkage(GV));
    Vals.push_back(Log2_32(GV.getAlignment())+1);
    Vals.push_back(GV.hasSection() ? SectionMap[GV.getSection()] : 0);
    if (GV.isThreadLocal() ||
        GV.getVisibility() != GlobalValue::DefaultVisibility ||
        GV.hasUnnamedAddr() || GV.isExternallyInitialized() ||
        GV.getDLLStorageClass() != GlobalValue::DefaultStorageClass ||
        GV.hasComdat()) {
      Vals.push_back(getEncodedVisibility(GV));
      Vals.push_back(getEncodedThreadLocalMode(GV));
      Vals.push_back(GV.hasUnnamedAddr());
      Vals.push_back(GV.isExternallyInitialized());
      Vals.push_back(getEncodedDLLStorageClass(GV));
      Vals.push_back(GV.hasComdat() ? VE.getComdatID(GV.getComdat()) : 0);
    } else {
      AbbrevToUse = SimpleGVarAbbrev;
    }

    Stream.EmitRecord(bitc::MODULE_CODE_GLOBALVAR, Vals, AbbrevToUse);
    Vals.clear();
  }

  // Emit the function proto information.
  for (const Function &F : *M) {
    // FUNCTION:  [type, callingconv, isproto, linkage, paramattrs, alignment,
    //             section, visibility, gc, unnamed_addr, prologuedata,
    //             dllstorageclass, comdat, prefixdata, personalityfn]
    Vals.push_back(VE.getTypeID(F.getFunctionType()));
    Vals.push_back(F.getCallingConv());
    Vals.push_back(F.isDeclaration());
    Vals.push_back(getEncodedLinkage(F));
    Vals.push_back(VE.getAttributeID(F.getAttributes()));
    Vals.push_back(Log2_32(F.getAlignment())+1);
    Vals.push_back(F.hasSection() ? SectionMap[F.getSection()] : 0);
    Vals.push_back(getEncodedVisibility(F));
    Vals.push_back(F.hasGC() ? GCMap[F.getGC()] : 0);
    Vals.push_back(F.hasUnnamedAddr());
    Vals.push_back(F.hasPrologueData() ? (VE.getValueID(F.getPrologueData()) + 1)
                                       : 0);
    Vals.push_back(getEncodedDLLStorageClass(F));
    Vals.push_back(F.hasComdat() ? VE.getComdatID(F.getComdat()) : 0);
    Vals.push_back(F.hasPrefixData() ? (VE.getValueID(F.getPrefixData()) + 1)
                                     : 0);
    Vals.push_back(
        F.hasPersonalityFn() ? (VE.getValueID(F.getPersonalityFn()) + 1) : 0);

    unsigned AbbrevToUse = 0;
    Stream.EmitRecord(bitc::MODULE_CODE_FUNCTION, Vals, AbbrevToUse);
    Vals.clear();
  }

  // Emit the alias information.
  for (const GlobalAlias &A : M->aliases()) {
    // ALIAS: [alias type, aliasee val#, linkage, visibility]
    Vals.push_back(VE.getTypeID(A.getValueType()));
    Vals.push_back(A.getType()->getAddressSpace());
    Vals.push_back(VE.getValueID(A.getAliasee()));
    Vals.push_back(getEncodedLinkage(A));
    Vals.push_back(getEncodedVisibility(A));
    Vals.push_back(getEncodedDLLStorageClass(A));
    Vals.push_back(getEncodedThreadLocalMode(A));
    Vals.push_back(A.hasUnnamedAddr());
    unsigned AbbrevToUse = 0;
    Stream.EmitRecord(bitc::MODULE_CODE_ALIAS, Vals, AbbrevToUse);
    Vals.clear();
  }

  // Emit the module's source file name.
  {
    StringEncoding Bits = getStringEncoding(M->getSourceFileName().data(),
                                            M->getSourceFileName().size());
    BitCodeAbbrevOp AbbrevOpToUse = BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8);
    if (Bits == SE_Char6)
      AbbrevOpToUse = BitCodeAbbrevOp(BitCodeAbbrevOp::Char6);
    else if (Bits == SE_Fixed7)
      AbbrevOpToUse = BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7);

    // MODULE_CODE_SOURCE_FILENAME: [namechar x N]
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::MODULE_CODE_SOURCE_FILENAME));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(AbbrevOpToUse);
    unsigned FilenameAbbrev = Stream.EmitAbbrev(Abbv);

    for (const auto P : M->getSourceFileName())
      Vals.push_back((unsigned char)P);

    // Emit the finished record.
    Stream.EmitRecord(bitc::MODULE_CODE_SOURCE_FILENAME, Vals, FilenameAbbrev);
    Vals.clear();
  }

  // If we have a VST, write the VSTOFFSET record placeholder and return
  // its offset.
  if (M->getValueSymbolTable().empty())
    return 0;
  return WriteValueSymbolTableForwardDecl(Stream);
}

static uint64_t GetOptimizationFlags(const Value *V) {
  uint64_t Flags = 0;

  if (const auto *OBO = dyn_cast<OverflowingBinaryOperator>(V)) {
    if (OBO->hasNoSignedWrap())
      Flags |= 1 << bitc::OBO_NO_SIGNED_WRAP;
    if (OBO->hasNoUnsignedWrap())
      Flags |= 1 << bitc::OBO_NO_UNSIGNED_WRAP;
  } else if (const auto *PEO = dyn_cast<PossiblyExactOperator>(V)) {
    if (PEO->isExact())
      Flags |= 1 << bitc::PEO_EXACT;
  } else if (const auto *FPMO = dyn_cast<FPMathOperator>(V)) {
    if (FPMO->hasUnsafeAlgebra())
      Flags |= FastMathFlags::UnsafeAlgebra;
    if (FPMO->hasNoNaNs())
      Flags |= FastMathFlags::NoNaNs;
    if (FPMO->hasNoInfs())
      Flags |= FastMathFlags::NoInfs;
    if (FPMO->hasNoSignedZeros())
      Flags |= FastMathFlags::NoSignedZeros;
    if (FPMO->hasAllowReciprocal())
      Flags |= FastMathFlags::AllowReciprocal;
  }

  return Flags;
}

static void writeValueAsMetadata(const ValueAsMetadata *MD,
                                 const ValueEnumerator &VE,
                                 BitstreamWriter &Stream,
                                 SmallVectorImpl<uint64_t> &Record) {
  // Mimic an MDNode with a value as one operand.
  Value *V = MD->getValue();
  Record.push_back(VE.getTypeID(V->getType()));
  Record.push_back(VE.getValueID(V));
  Stream.EmitRecord(bitc::METADATA_VALUE, Record, 0);
  Record.clear();
}

static void writeMDTuple(const MDTuple *N, const ValueEnumerator &VE,
                         BitstreamWriter &Stream,
                         SmallVectorImpl<uint64_t> &Record, unsigned Abbrev) {
  for (unsigned i = 0, e = N->getNumOperands(); i != e; ++i) {
    Metadata *MD = N->getOperand(i);
    assert(!(MD && isa<LocalAsMetadata>(MD)) &&
           "Unexpected function-local metadata");
    Record.push_back(VE.getMetadataOrNullID(MD));
  }
  Stream.EmitRecord(N->isDistinct() ? bitc::METADATA_DISTINCT_NODE
                                    : bitc::METADATA_NODE,
                    Record, Abbrev);
  Record.clear();
}

static unsigned createDILocationAbbrev(BitstreamWriter &Stream) {
  // Assume the column is usually under 128, and always output the inlined-at
  // location (it's never more expensive than building an array size 1).
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::METADATA_LOCATION));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  return Stream.EmitAbbrev(Abbv);
}

static void writeDILocation(const DILocation *N, const ValueEnumerator &VE,
                            BitstreamWriter &Stream,
                            SmallVectorImpl<uint64_t> &Record,
                            unsigned &Abbrev) {
  if (!Abbrev)
    Abbrev = createDILocationAbbrev(Stream);

  Record.push_back(N->isDistinct());
  Record.push_back(N->getLine());
  Record.push_back(N->getColumn());
  Record.push_back(VE.getMetadataID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getInlinedAt()));

  Stream.EmitRecord(bitc::METADATA_LOCATION, Record, Abbrev);
  Record.clear();
}

static unsigned createGenericDINodeAbbrev(BitstreamWriter &Stream) {
  // Assume the column is usually under 128, and always output the inlined-at
  // location (it's never more expensive than building an array size 1).
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::METADATA_GENERIC_DEBUG));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  return Stream.EmitAbbrev(Abbv);
}

static void writeGenericDINode(const GenericDINode *N,
                               const ValueEnumerator &VE,
                               BitstreamWriter &Stream,
                               SmallVectorImpl<uint64_t> &Record,
                               unsigned &Abbrev) {
  if (!Abbrev)
    Abbrev = createGenericDINodeAbbrev(Stream);

  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(0); // Per-tag version field; unused for now.

  for (auto &I : N->operands())
    Record.push_back(VE.getMetadataOrNullID(I));

  Stream.EmitRecord(bitc::METADATA_GENERIC_DEBUG, Record, Abbrev);
  Record.clear();
}

static uint64_t rotateSign(int64_t I) {
  uint64_t U = I;
  return I < 0 ? ~(U << 1) : U << 1;
}

static void writeDISubrange(const DISubrange *N, const ValueEnumerator &,
                            BitstreamWriter &Stream,
                            SmallVectorImpl<uint64_t> &Record,
                            unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getCount());
  Record.push_back(rotateSign(N->getLowerBound()));

  Stream.EmitRecord(bitc::METADATA_SUBRANGE, Record, Abbrev);
  Record.clear();
}

static void writeDIEnumerator(const DIEnumerator *N, const ValueEnumerator &VE,
                              BitstreamWriter &Stream,
                              SmallVectorImpl<uint64_t> &Record,
                              unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(rotateSign(N->getValue()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));

  Stream.EmitRecord(bitc::METADATA_ENUMERATOR, Record, Abbrev);
  Record.clear();
}

static void writeDIBasicType(const DIBasicType *N, const ValueEnumerator &VE,
                             BitstreamWriter &Stream,
                             SmallVectorImpl<uint64_t> &Record,
                             unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(N->getSizeInBits());
  Record.push_back(N->getAlignInBits());
  Record.push_back(N->getEncoding());

  Stream.EmitRecord(bitc::METADATA_BASIC_TYPE, Record, Abbrev);
  Record.clear();
}

static void writeDIDerivedType(const DIDerivedType *N,
                               const ValueEnumerator &VE,
                               BitstreamWriter &Stream,
                               SmallVectorImpl<uint64_t> &Record,
                               unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getBaseType()));
  Record.push_back(N->getSizeInBits());
  Record.push_back(N->getAlignInBits());
  Record.push_back(N->getOffsetInBits());
  Record.push_back(N->getFlags());
  Record.push_back(VE.getMetadataOrNullID(N->getExtraData()));

  Stream.EmitRecord(bitc::METADATA_DERIVED_TYPE, Record, Abbrev);
  Record.clear();
}

static void writeDICompositeType(const DICompositeType *N,
                                 const ValueEnumerator &VE,
                                 BitstreamWriter &Stream,
                                 SmallVectorImpl<uint64_t> &Record,
                                 unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getBaseType()));
  Record.push_back(N->getSizeInBits());
  Record.push_back(N->getAlignInBits());
  Record.push_back(N->getOffsetInBits());
  Record.push_back(N->getFlags());
  Record.push_back(VE.getMetadataOrNullID(N->getElements().get()));
  Record.push_back(N->getRuntimeLang());
  Record.push_back(VE.getMetadataOrNullID(N->getVTableHolder()));
  Record.push_back(VE.getMetadataOrNullID(N->getTemplateParams().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawIdentifier()));

  Stream.EmitRecord(bitc::METADATA_COMPOSITE_TYPE, Record, Abbrev);
  Record.clear();
}

static void writeDISubroutineType(const DISubroutineType *N,
                                  const ValueEnumerator &VE,
                                  BitstreamWriter &Stream,
                                  SmallVectorImpl<uint64_t> &Record,
                                  unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getFlags());
  Record.push_back(VE.getMetadataOrNullID(N->getTypeArray().get()));

  Stream.EmitRecord(bitc::METADATA_SUBROUTINE_TYPE, Record, Abbrev);
  Record.clear();
}

static void writeDIFile(const DIFile *N, const ValueEnumerator &VE,
                        BitstreamWriter &Stream,
                        SmallVectorImpl<uint64_t> &Record, unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getRawFilename()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawDirectory()));

  Stream.EmitRecord(bitc::METADATA_FILE, Record, Abbrev);
  Record.clear();
}

static void writeDICompileUnit(const DICompileUnit *N,
                               const ValueEnumerator &VE,
                               BitstreamWriter &Stream,
                               SmallVectorImpl<uint64_t> &Record,
                               unsigned Abbrev) {
  assert(N->isDistinct() && "Expected distinct compile units");
  Record.push_back(/* IsDistinct */ true);
  Record.push_back(N->getSourceLanguage());
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawProducer()));
  Record.push_back(N->isOptimized());
  Record.push_back(VE.getMetadataOrNullID(N->getRawFlags()));
  Record.push_back(N->getRuntimeVersion());
  Record.push_back(VE.getMetadataOrNullID(N->getRawSplitDebugFilename()));
  Record.push_back(N->getEmissionKind());
  Record.push_back(VE.getMetadataOrNullID(N->getEnumTypes().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getRetainedTypes().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getSubprograms().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getGlobalVariables().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getImportedEntities().get()));
  Record.push_back(N->getDWOId());
  Record.push_back(VE.getMetadataOrNullID(N->getMacros().get()));

  Stream.EmitRecord(bitc::METADATA_COMPILE_UNIT, Record, Abbrev);
  Record.clear();
}

static void writeDISubprogram(const DISubprogram *N, const ValueEnumerator &VE,
                              BitstreamWriter &Stream,
                              SmallVectorImpl<uint64_t> &Record,
                              unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawLinkageName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getType()));
  Record.push_back(N->isLocalToUnit());
  Record.push_back(N->isDefinition());
  Record.push_back(N->getScopeLine());
  Record.push_back(VE.getMetadataOrNullID(N->getContainingType()));
  Record.push_back(N->getVirtuality());
  Record.push_back(N->getVirtualIndex());
  Record.push_back(N->getFlags());
  Record.push_back(N->isOptimized());
  Record.push_back(VE.getMetadataOrNullID(N->getTemplateParams().get()));
  Record.push_back(VE.getMetadataOrNullID(N->getDeclaration()));
  Record.push_back(VE.getMetadataOrNullID(N->getVariables().get()));

  Stream.EmitRecord(bitc::METADATA_SUBPROGRAM, Record, Abbrev);
  Record.clear();
}

static void writeDILexicalBlock(const DILexicalBlock *N,
                                const ValueEnumerator &VE,
                                BitstreamWriter &Stream,
                                SmallVectorImpl<uint64_t> &Record,
                                unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(N->getColumn());

  Stream.EmitRecord(bitc::METADATA_LEXICAL_BLOCK, Record, Abbrev);
  Record.clear();
}

static void writeDILexicalBlockFile(const DILexicalBlockFile *N,
                                    const ValueEnumerator &VE,
                                    BitstreamWriter &Stream,
                                    SmallVectorImpl<uint64_t> &Record,
                                    unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getDiscriminator());

  Stream.EmitRecord(bitc::METADATA_LEXICAL_BLOCK_FILE, Record, Abbrev);
  Record.clear();
}

static void writeDINamespace(const DINamespace *N, const ValueEnumerator &VE,
                             BitstreamWriter &Stream,
                             SmallVectorImpl<uint64_t> &Record,
                             unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(N->getLine());

  Stream.EmitRecord(bitc::METADATA_NAMESPACE, Record, Abbrev);
  Record.clear();
}

static void writeDIMacro(const DIMacro *N, const ValueEnumerator &VE,
                         BitstreamWriter &Stream,
                         SmallVectorImpl<uint64_t> &Record, unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getMacinfoType());
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawValue()));

  Stream.EmitRecord(bitc::METADATA_MACRO, Record, Abbrev);
  Record.clear();
}

static void writeDIMacroFile(const DIMacroFile *N, const ValueEnumerator &VE,
                             BitstreamWriter &Stream,
                             SmallVectorImpl<uint64_t> &Record,
                             unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getMacinfoType());
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(VE.getMetadataOrNullID(N->getElements().get()));

  Stream.EmitRecord(bitc::METADATA_MACRO_FILE, Record, Abbrev);
  Record.clear();
}

static void writeDIModule(const DIModule *N, const ValueEnumerator &VE,
                          BitstreamWriter &Stream,
                          SmallVectorImpl<uint64_t> &Record, unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  for (auto &I : N->operands())
    Record.push_back(VE.getMetadataOrNullID(I));

  Stream.EmitRecord(bitc::METADATA_MODULE, Record, Abbrev);
  Record.clear();
}

static void writeDITemplateTypeParameter(const DITemplateTypeParameter *N,
                                         const ValueEnumerator &VE,
                                         BitstreamWriter &Stream,
                                         SmallVectorImpl<uint64_t> &Record,
                                         unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getType()));

  Stream.EmitRecord(bitc::METADATA_TEMPLATE_TYPE, Record, Abbrev);
  Record.clear();
}

static void writeDITemplateValueParameter(const DITemplateValueParameter *N,
                                          const ValueEnumerator &VE,
                                          BitstreamWriter &Stream,
                                          SmallVectorImpl<uint64_t> &Record,
                                          unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getType()));
  Record.push_back(VE.getMetadataOrNullID(N->getValue()));

  Stream.EmitRecord(bitc::METADATA_TEMPLATE_VALUE, Record, Abbrev);
  Record.clear();
}

static void writeDIGlobalVariable(const DIGlobalVariable *N,
                                  const ValueEnumerator &VE,
                                  BitstreamWriter &Stream,
                                  SmallVectorImpl<uint64_t> &Record,
                                  unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawLinkageName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getType()));
  Record.push_back(N->isLocalToUnit());
  Record.push_back(N->isDefinition());
  Record.push_back(VE.getMetadataOrNullID(N->getRawVariable()));
  Record.push_back(VE.getMetadataOrNullID(N->getStaticDataMemberDeclaration()));

  Stream.EmitRecord(bitc::METADATA_GLOBAL_VAR, Record, Abbrev);
  Record.clear();
}

static void writeDILocalVariable(const DILocalVariable *N,
                                 const ValueEnumerator &VE,
                                 BitstreamWriter &Stream,
                                 SmallVectorImpl<uint64_t> &Record,
                                 unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getType()));
  Record.push_back(N->getArg());
  Record.push_back(N->getFlags());

  Stream.EmitRecord(bitc::METADATA_LOCAL_VAR, Record, Abbrev);
  Record.clear();
}

static void writeDIExpression(const DIExpression *N, const ValueEnumerator &,
                              BitstreamWriter &Stream,
                              SmallVectorImpl<uint64_t> &Record,
                              unsigned Abbrev) {
  Record.reserve(N->getElements().size() + 1);

  Record.push_back(N->isDistinct());
  Record.append(N->elements_begin(), N->elements_end());

  Stream.EmitRecord(bitc::METADATA_EXPRESSION, Record, Abbrev);
  Record.clear();
}

static void writeDIObjCProperty(const DIObjCProperty *N,
                                const ValueEnumerator &VE,
                                BitstreamWriter &Stream,
                                SmallVectorImpl<uint64_t> &Record,
                                unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));
  Record.push_back(VE.getMetadataOrNullID(N->getFile()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getRawSetterName()));
  Record.push_back(VE.getMetadataOrNullID(N->getRawGetterName()));
  Record.push_back(N->getAttributes());
  Record.push_back(VE.getMetadataOrNullID(N->getType()));

  Stream.EmitRecord(bitc::METADATA_OBJC_PROPERTY, Record, Abbrev);
  Record.clear();
}

static void writeDIImportedEntity(const DIImportedEntity *N,
                                  const ValueEnumerator &VE,
                                  BitstreamWriter &Stream,
                                  SmallVectorImpl<uint64_t> &Record,
                                  unsigned Abbrev) {
  Record.push_back(N->isDistinct());
  Record.push_back(N->getTag());
  Record.push_back(VE.getMetadataOrNullID(N->getScope()));
  Record.push_back(VE.getMetadataOrNullID(N->getEntity()));
  Record.push_back(N->getLine());
  Record.push_back(VE.getMetadataOrNullID(N->getRawName()));

  Stream.EmitRecord(bitc::METADATA_IMPORTED_ENTITY, Record, Abbrev);
  Record.clear();
}

static unsigned createNamedMetadataAbbrev(BitstreamWriter &Stream) {
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::METADATA_NAME));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8));
  return Stream.EmitAbbrev(Abbv);
}

static void writeNamedMetadata(const Module &M, const ValueEnumerator &VE,
                               BitstreamWriter &Stream,
                               SmallVectorImpl<uint64_t> &Record) {
  if (M.named_metadata_empty())
    return;

  unsigned Abbrev = createNamedMetadataAbbrev(Stream);
  for (const NamedMDNode &NMD : M.named_metadata()) {
    // Write name.
    StringRef Str = NMD.getName();
    Record.append(Str.bytes_begin(), Str.bytes_end());
    Stream.EmitRecord(bitc::METADATA_NAME, Record, Abbrev);
    Record.clear();

    // Write named metadata operands.
    for (const MDNode *N : NMD.operands())
      Record.push_back(VE.getMetadataID(N));
    Stream.EmitRecord(bitc::METADATA_NAMED_NODE, Record, 0);
    Record.clear();
  }
}

static unsigned createMetadataStringsAbbrev(BitstreamWriter &Stream) {
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::METADATA_STRINGS));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // # of strings
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // offset to chars
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Blob));
  return Stream.EmitAbbrev(Abbv);
}

/// Write out a record for MDString.
///
/// All the metadata strings in a metadata block are emitted in a single
/// record.  The sizes and strings themselves are shoved into a blob.
static void writeMetadataStrings(ArrayRef<const Metadata *> Strings,
                                 BitstreamWriter &Stream,
                                 SmallVectorImpl<uint64_t> &Record) {
  if (Strings.empty())
    return;

  // Start the record with the number of strings.
  Record.push_back(bitc::METADATA_STRINGS);
  Record.push_back(Strings.size());

  // Emit the sizes of the strings in the blob.
  SmallString<256> Blob;
  {
    BitstreamWriter W(Blob);
    for (const Metadata *MD : Strings)
      W.EmitVBR(cast<MDString>(MD)->getLength(), 6);
    W.FlushToWord();
  }

  // Add the offset to the strings to the record.
  Record.push_back(Blob.size());

  // Add the strings to the blob.
  for (const Metadata *MD : Strings)
    Blob.append(cast<MDString>(MD)->getString());

  // Emit the final record.
  Stream.EmitRecordWithBlob(createMetadataStringsAbbrev(Stream), Record, Blob);
  Record.clear();
}

static void writeMetadataRecords(ArrayRef<const Metadata *> MDs,
                                 const ValueEnumerator &VE,
                                 BitstreamWriter &Stream,
                                 SmallVectorImpl<uint64_t> &Record) {
  if (MDs.empty())
    return;

  // Initialize MDNode abbreviations.
#define HANDLE_MDNODE_LEAF(CLASS) unsigned CLASS##Abbrev = 0;
#include "llvm/IR/Metadata.def"

  for (const Metadata *MD : MDs) {
    if (const MDNode *N = dyn_cast<MDNode>(MD)) {
      assert(N->isResolved() && "Expected forward references to be resolved");

      switch (N->getMetadataID()) {
      default:
        llvm_unreachable("Invalid MDNode subclass");
#define HANDLE_MDNODE_LEAF(CLASS)                                              \
  case Metadata::CLASS##Kind:                                                  \
    write##CLASS(cast<CLASS>(N), VE, Stream, Record, CLASS##Abbrev);           \
    continue;
#include "llvm/IR/Metadata.def"
      }
    }
    writeValueAsMetadata(cast<ValueAsMetadata>(MD), VE, Stream, Record);
  }
}

static void writeModuleMetadata(const Module &M,
                                const ValueEnumerator &VE,
                                BitstreamWriter &Stream) {
  if (VE.getMDs().empty() && M.named_metadata_empty())
    return;

  Stream.EnterSubblock(bitc::METADATA_BLOCK_ID, 3);
  SmallVector<uint64_t, 64> Record;
  writeMetadataStrings(VE.getMDStrings(), Stream, Record);
  writeMetadataRecords(VE.getNonMDStrings(), VE, Stream, Record);
  writeNamedMetadata(M, VE, Stream, Record);
  Stream.ExitBlock();
}

static void writeFunctionMetadata(const Function &F, const ValueEnumerator &VE,
                                  BitstreamWriter &Stream) {
  ArrayRef<const Metadata *> MDs = VE.getFunctionMDs();
  if (MDs.empty())
    return;

  Stream.EnterSubblock(bitc::METADATA_BLOCK_ID, 3);
  SmallVector<uint64_t, 64> Record;
  writeMetadataRecords(MDs, VE, Stream, Record);
  Stream.ExitBlock();
}

static void WriteMetadataAttachment(const Function &F,
                                    const ValueEnumerator &VE,
                                    BitstreamWriter &Stream) {
  Stream.EnterSubblock(bitc::METADATA_ATTACHMENT_ID, 3);

  SmallVector<uint64_t, 64> Record;

  // Write metadata attachments
  // METADATA_ATTACHMENT - [m x [value, [n x [id, mdnode]]]
  SmallVector<std::pair<unsigned, MDNode *>, 4> MDs;
  F.getAllMetadata(MDs);
  if (!MDs.empty()) {
    for (const auto &I : MDs) {
      Record.push_back(I.first);
      Record.push_back(VE.getMetadataID(I.second));
    }
    Stream.EmitRecord(bitc::METADATA_ATTACHMENT, Record, 0);
    Record.clear();
  }

  for (const BasicBlock &BB : F)
    for (const Instruction &I : BB) {
      MDs.clear();
      I.getAllMetadataOtherThanDebugLoc(MDs);

      // If no metadata, ignore instruction.
      if (MDs.empty()) continue;

      Record.push_back(VE.getInstructionID(&I));

      for (unsigned i = 0, e = MDs.size(); i != e; ++i) {
        Record.push_back(MDs[i].first);
        Record.push_back(VE.getMetadataID(MDs[i].second));
      }
      Stream.EmitRecord(bitc::METADATA_ATTACHMENT, Record, 0);
      Record.clear();
    }

  Stream.ExitBlock();
}

static void WriteModuleMetadataStore(const Module *M, BitstreamWriter &Stream) {
  SmallVector<uint64_t, 64> Record;

  // Write metadata kinds
  // METADATA_KIND - [n x [id, name]]
  SmallVector<StringRef, 8> Names;
  M->getMDKindNames(Names);

  if (Names.empty()) return;

  Stream.EnterSubblock(bitc::METADATA_KIND_BLOCK_ID, 3);

  for (unsigned MDKindID = 0, e = Names.size(); MDKindID != e; ++MDKindID) {
    Record.push_back(MDKindID);
    StringRef KName = Names[MDKindID];
    Record.append(KName.begin(), KName.end());

    Stream.EmitRecord(bitc::METADATA_KIND, Record, 0);
    Record.clear();
  }

  Stream.ExitBlock();
}

static void WriteOperandBundleTags(const Module *M, BitstreamWriter &Stream) {
  // Write metadata kinds
  //
  // OPERAND_BUNDLE_TAGS_BLOCK_ID : N x OPERAND_BUNDLE_TAG
  //
  // OPERAND_BUNDLE_TAG - [strchr x N]

  SmallVector<StringRef, 8> Tags;
  M->getOperandBundleTags(Tags);

  if (Tags.empty())
    return;

  Stream.EnterSubblock(bitc::OPERAND_BUNDLE_TAGS_BLOCK_ID, 3);

  SmallVector<uint64_t, 64> Record;

  for (auto Tag : Tags) {
    Record.append(Tag.begin(), Tag.end());

    Stream.EmitRecord(bitc::OPERAND_BUNDLE_TAG, Record, 0);
    Record.clear();
  }

  Stream.ExitBlock();
}

static void emitSignedInt64(SmallVectorImpl<uint64_t> &Vals, uint64_t V) {
  if ((int64_t)V >= 0)
    Vals.push_back(V << 1);
  else
    Vals.push_back((-V << 1) | 1);
}

static void WriteConstants(unsigned FirstVal, unsigned LastVal,
                           const ValueEnumerator &VE,
                           BitstreamWriter &Stream, bool isGlobal) {
  if (FirstVal == LastVal) return;

  Stream.EnterSubblock(bitc::CONSTANTS_BLOCK_ID, 4);

  unsigned AggregateAbbrev = 0;
  unsigned String8Abbrev = 0;
  unsigned CString7Abbrev = 0;
  unsigned CString6Abbrev = 0;
  // If this is a constant pool for the module, emit module-specific abbrevs.
  if (isGlobal) {
    // Abbrev for CST_CODE_AGGREGATE.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_AGGREGATE));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, Log2_32_Ceil(LastVal+1)));
    AggregateAbbrev = Stream.EmitAbbrev(Abbv);

    // Abbrev for CST_CODE_STRING.
    Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_STRING));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8));
    String8Abbrev = Stream.EmitAbbrev(Abbv);
    // Abbrev for CST_CODE_CSTRING.
    Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_CSTRING));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7));
    CString7Abbrev = Stream.EmitAbbrev(Abbv);
    // Abbrev for CST_CODE_CSTRING.
    Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_CSTRING));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
    CString6Abbrev = Stream.EmitAbbrev(Abbv);
  }

  SmallVector<uint64_t, 64> Record;

  const ValueEnumerator::ValueList &Vals = VE.getValues();
  Type *LastTy = nullptr;
  for (unsigned i = FirstVal; i != LastVal; ++i) {
    const Value *V = Vals[i].first;
    // If we need to switch types, do so now.
    if (V->getType() != LastTy) {
      LastTy = V->getType();
      Record.push_back(VE.getTypeID(LastTy));
      Stream.EmitRecord(bitc::CST_CODE_SETTYPE, Record,
                        CONSTANTS_SETTYPE_ABBREV);
      Record.clear();
    }

    if (const InlineAsm *IA = dyn_cast<InlineAsm>(V)) {
      Record.push_back(unsigned(IA->hasSideEffects()) |
                       unsigned(IA->isAlignStack()) << 1 |
                       unsigned(IA->getDialect()&1) << 2);

      // Add the asm string.
      const std::string &AsmStr = IA->getAsmString();
      Record.push_back(AsmStr.size());
      Record.append(AsmStr.begin(), AsmStr.end());

      // Add the constraint string.
      const std::string &ConstraintStr = IA->getConstraintString();
      Record.push_back(ConstraintStr.size());
      Record.append(ConstraintStr.begin(), ConstraintStr.end());
      Stream.EmitRecord(bitc::CST_CODE_INLINEASM, Record);
      Record.clear();
      continue;
    }
    const Constant *C = cast<Constant>(V);
    unsigned Code = -1U;
    unsigned AbbrevToUse = 0;
    if (C->isNullValue()) {
      Code = bitc::CST_CODE_NULL;
    } else if (isa<UndefValue>(C)) {
      Code = bitc::CST_CODE_UNDEF;
    } else if (const ConstantInt *IV = dyn_cast<ConstantInt>(C)) {
      if (IV->getBitWidth() <= 64) {
        uint64_t V = IV->getSExtValue();
        emitSignedInt64(Record, V);
        Code = bitc::CST_CODE_INTEGER;
        AbbrevToUse = CONSTANTS_INTEGER_ABBREV;
      } else {                             // Wide integers, > 64 bits in size.
        // We have an arbitrary precision integer value to write whose
        // bit width is > 64. However, in canonical unsigned integer
        // format it is likely that the high bits are going to be zero.
        // So, we only write the number of active words.
        unsigned NWords = IV->getValue().getActiveWords();
        const uint64_t *RawWords = IV->getValue().getRawData();
        for (unsigned i = 0; i != NWords; ++i) {
          emitSignedInt64(Record, RawWords[i]);
        }
        Code = bitc::CST_CODE_WIDE_INTEGER;
      }
    } else if (const ConstantFP *CFP = dyn_cast<ConstantFP>(C)) {
      Code = bitc::CST_CODE_FLOAT;
      Type *Ty = CFP->getType();
      if (Ty->isHalfTy() || Ty->isFloatTy() || Ty->isDoubleTy()) {
        Record.push_back(CFP->getValueAPF().bitcastToAPInt().getZExtValue());
      } else if (Ty->isX86_FP80Ty()) {
        // api needed to prevent premature destruction
        // bits are not in the same order as a normal i80 APInt, compensate.
        APInt api = CFP->getValueAPF().bitcastToAPInt();
        const uint64_t *p = api.getRawData();
        Record.push_back((p[1] << 48) | (p[0] >> 16));
        Record.push_back(p[0] & 0xffffLL);
      } else if (Ty->isFP128Ty() || Ty->isPPC_FP128Ty()) {
        APInt api = CFP->getValueAPF().bitcastToAPInt();
        const uint64_t *p = api.getRawData();
        Record.push_back(p[0]);
        Record.push_back(p[1]);
      } else {
        assert (0 && "Unknown FP type!");
      }
    } else if (isa<ConstantDataSequential>(C) &&
               cast<ConstantDataSequential>(C)->isString()) {
      const ConstantDataSequential *Str = cast<ConstantDataSequential>(C);
      // Emit constant strings specially.
      unsigned NumElts = Str->getNumElements();
      // If this is a null-terminated string, use the denser CSTRING encoding.
      if (Str->isCString()) {
        Code = bitc::CST_CODE_CSTRING;
        --NumElts;  // Don't encode the null, which isn't allowed by char6.
      } else {
        Code = bitc::CST_CODE_STRING;
        AbbrevToUse = String8Abbrev;
      }
      bool isCStr7 = Code == bitc::CST_CODE_CSTRING;
      bool isCStrChar6 = Code == bitc::CST_CODE_CSTRING;
      for (unsigned i = 0; i != NumElts; ++i) {
        unsigned char V = Str->getElementAsInteger(i);
        Record.push_back(V);
        isCStr7 &= (V & 128) == 0;
        if (isCStrChar6)
          isCStrChar6 = BitCodeAbbrevOp::isChar6(V);
      }

      if (isCStrChar6)
        AbbrevToUse = CString6Abbrev;
      else if (isCStr7)
        AbbrevToUse = CString7Abbrev;
    } else if (const ConstantDataSequential *CDS =
                  dyn_cast<ConstantDataSequential>(C)) {
      Code = bitc::CST_CODE_DATA;
      Type *EltTy = CDS->getType()->getElementType();
      if (isa<IntegerType>(EltTy)) {
        for (unsigned i = 0, e = CDS->getNumElements(); i != e; ++i)
          Record.push_back(CDS->getElementAsInteger(i));
      } else {
        for (unsigned i = 0, e = CDS->getNumElements(); i != e; ++i)
          Record.push_back(
              CDS->getElementAsAPFloat(i).bitcastToAPInt().getLimitedValue());
      }
    } else if (isa<ConstantArray>(C) || isa<ConstantStruct>(C) ||
               isa<ConstantVector>(C)) {
      Code = bitc::CST_CODE_AGGREGATE;
      for (const Value *Op : C->operands())
        Record.push_back(VE.getValueID(Op));
      AbbrevToUse = AggregateAbbrev;
    } else if (const ConstantExpr *CE = dyn_cast<ConstantExpr>(C)) {
      switch (CE->getOpcode()) {
      default:
        if (Instruction::isCast(CE->getOpcode())) {
          Code = bitc::CST_CODE_CE_CAST;
          Record.push_back(GetEncodedCastOpcode(CE->getOpcode()));
          Record.push_back(VE.getTypeID(C->getOperand(0)->getType()));
          Record.push_back(VE.getValueID(C->getOperand(0)));
          AbbrevToUse = CONSTANTS_CE_CAST_Abbrev;
        } else {
          assert(CE->getNumOperands() == 2 && "Unknown constant expr!");
          Code = bitc::CST_CODE_CE_BINOP;
          Record.push_back(GetEncodedBinaryOpcode(CE->getOpcode()));
          Record.push_back(VE.getValueID(C->getOperand(0)));
          Record.push_back(VE.getValueID(C->getOperand(1)));
          uint64_t Flags = GetOptimizationFlags(CE);
          if (Flags != 0)
            Record.push_back(Flags);
        }
        break;
      case Instruction::GetElementPtr: {
        Code = bitc::CST_CODE_CE_GEP;
        const auto *GO = cast<GEPOperator>(C);
        if (GO->isInBounds())
          Code = bitc::CST_CODE_CE_INBOUNDS_GEP;
        Record.push_back(VE.getTypeID(GO->getSourceElementType()));
        for (unsigned i = 0, e = CE->getNumOperands(); i != e; ++i) {
          Record.push_back(VE.getTypeID(C->getOperand(i)->getType()));
          Record.push_back(VE.getValueID(C->getOperand(i)));
        }
        break;
      }
      case Instruction::Select:
        Code = bitc::CST_CODE_CE_SELECT;
        Record.push_back(VE.getValueID(C->getOperand(0)));
        Record.push_back(VE.getValueID(C->getOperand(1)));
        Record.push_back(VE.getValueID(C->getOperand(2)));
        break;
      case Instruction::ExtractElement:
        Code = bitc::CST_CODE_CE_EXTRACTELT;
        Record.push_back(VE.getTypeID(C->getOperand(0)->getType()));
        Record.push_back(VE.getValueID(C->getOperand(0)));
        Record.push_back(VE.getTypeID(C->getOperand(1)->getType()));
        Record.push_back(VE.getValueID(C->getOperand(1)));
        break;
      case Instruction::InsertElement:
        Code = bitc::CST_CODE_CE_INSERTELT;
        Record.push_back(VE.getValueID(C->getOperand(0)));
        Record.push_back(VE.getValueID(C->getOperand(1)));
        Record.push_back(VE.getTypeID(C->getOperand(2)->getType()));
        Record.push_back(VE.getValueID(C->getOperand(2)));
        break;
      case Instruction::ShuffleVector:
        // If the return type and argument types are the same, this is a
        // standard shufflevector instruction.  If the types are different,
        // then the shuffle is widening or truncating the input vectors, and
        // the argument type must also be encoded.
        if (C->getType() == C->getOperand(0)->getType()) {
          Code = bitc::CST_CODE_CE_SHUFFLEVEC;
        } else {
          Code = bitc::CST_CODE_CE_SHUFVEC_EX;
          Record.push_back(VE.getTypeID(C->getOperand(0)->getType()));
        }
        Record.push_back(VE.getValueID(C->getOperand(0)));
        Record.push_back(VE.getValueID(C->getOperand(1)));
        Record.push_back(VE.getValueID(C->getOperand(2)));
        break;
      case Instruction::ICmp:
      case Instruction::FCmp:
        Code = bitc::CST_CODE_CE_CMP;
        Record.push_back(VE.getTypeID(C->getOperand(0)->getType()));
        Record.push_back(VE.getValueID(C->getOperand(0)));
        Record.push_back(VE.getValueID(C->getOperand(1)));
        Record.push_back(CE->getPredicate());
        break;
      }
    } else if (const BlockAddress *BA = dyn_cast<BlockAddress>(C)) {
      Code = bitc::CST_CODE_BLOCKADDRESS;
      Record.push_back(VE.getTypeID(BA->getFunction()->getType()));
      Record.push_back(VE.getValueID(BA->getFunction()));
      Record.push_back(VE.getGlobalBasicBlockID(BA->getBasicBlock()));
    } else {
#ifndef NDEBUG
      C->dump();
#endif
      llvm_unreachable("Unknown constant!");
    }
    Stream.EmitRecord(Code, Record, AbbrevToUse);
    Record.clear();
  }

  Stream.ExitBlock();
}

static void WriteModuleConstants(const ValueEnumerator &VE,
                                 BitstreamWriter &Stream) {
  const ValueEnumerator::ValueList &Vals = VE.getValues();

  // Find the first constant to emit, which is the first non-globalvalue value.
  // We know globalvalues have been emitted by WriteModuleInfo.
  for (unsigned i = 0, e = Vals.size(); i != e; ++i) {
    if (!isa<GlobalValue>(Vals[i].first)) {
      WriteConstants(i, Vals.size(), VE, Stream, true);
      return;
    }
  }
}

/// PushValueAndType - The file has to encode both the value and type id for
/// many values, because we need to know what type to create for forward
/// references.  However, most operands are not forward references, so this type
/// field is not needed.
///
/// This function adds V's value ID to Vals.  If the value ID is higher than the
/// instruction ID, then it is a forward reference, and it also includes the
/// type ID.  The value ID that is written is encoded relative to the InstID.
static bool PushValueAndType(const Value *V, unsigned InstID,
                             SmallVectorImpl<unsigned> &Vals,
                             ValueEnumerator &VE) {
  unsigned ValID = VE.getValueID(V);
  // Make encoding relative to the InstID.
  Vals.push_back(InstID - ValID);
  if (ValID >= InstID) {
    Vals.push_back(VE.getTypeID(V->getType()));
    return true;
  }
  return false;
}

static void WriteOperandBundles(BitstreamWriter &Stream, ImmutableCallSite CS,
                                unsigned InstID, ValueEnumerator &VE) {
  SmallVector<unsigned, 64> Record;
  LLVMContext &C = CS.getInstruction()->getContext();

  for (unsigned i = 0, e = CS.getNumOperandBundles(); i != e; ++i) {
    const auto &Bundle = CS.getOperandBundleAt(i);
    Record.push_back(C.getOperandBundleTagID(Bundle.getTagName()));

    for (auto &Input : Bundle.Inputs)
      PushValueAndType(Input, InstID, Record, VE);

    Stream.EmitRecord(bitc::FUNC_CODE_OPERAND_BUNDLE, Record);
    Record.clear();
  }
}

/// pushValue - Like PushValueAndType, but where the type of the value is
/// omitted (perhaps it was already encoded in an earlier operand).
static void pushValue(const Value *V, unsigned InstID,
                      SmallVectorImpl<unsigned> &Vals,
                      ValueEnumerator &VE) {
  unsigned ValID = VE.getValueID(V);
  Vals.push_back(InstID - ValID);
}

static void pushValueSigned(const Value *V, unsigned InstID,
                            SmallVectorImpl<uint64_t> &Vals,
                            ValueEnumerator &VE) {
  unsigned ValID = VE.getValueID(V);
  int64_t diff = ((int32_t)InstID - (int32_t)ValID);
  emitSignedInt64(Vals, diff);
}

/// WriteInstruction - Emit an instruction to the specified stream.
static void WriteInstruction(const Instruction &I, unsigned InstID,
                             ValueEnumerator &VE, BitstreamWriter &Stream,
                             SmallVectorImpl<unsigned> &Vals) {
  unsigned Code = 0;
  unsigned AbbrevToUse = 0;
  VE.setInstructionID(&I);
  switch (I.getOpcode()) {
  default:
    if (Instruction::isCast(I.getOpcode())) {
      Code = bitc::FUNC_CODE_INST_CAST;
      if (!PushValueAndType(I.getOperand(0), InstID, Vals, VE))
        AbbrevToUse = FUNCTION_INST_CAST_ABBREV;
      Vals.push_back(VE.getTypeID(I.getType()));
      Vals.push_back(GetEncodedCastOpcode(I.getOpcode()));
    } else {
      assert(isa<BinaryOperator>(I) && "Unknown instruction!");
      Code = bitc::FUNC_CODE_INST_BINOP;
      if (!PushValueAndType(I.getOperand(0), InstID, Vals, VE))
        AbbrevToUse = FUNCTION_INST_BINOP_ABBREV;
      pushValue(I.getOperand(1), InstID, Vals, VE);
      Vals.push_back(GetEncodedBinaryOpcode(I.getOpcode()));
      uint64_t Flags = GetOptimizationFlags(&I);
      if (Flags != 0) {
        if (AbbrevToUse == FUNCTION_INST_BINOP_ABBREV)
          AbbrevToUse = FUNCTION_INST_BINOP_FLAGS_ABBREV;
        Vals.push_back(Flags);
      }
    }
    break;

  case Instruction::GetElementPtr: {
    Code = bitc::FUNC_CODE_INST_GEP;
    AbbrevToUse = FUNCTION_INST_GEP_ABBREV;
    auto &GEPInst = cast<GetElementPtrInst>(I);
    Vals.push_back(GEPInst.isInBounds());
    Vals.push_back(VE.getTypeID(GEPInst.getSourceElementType()));
    for (unsigned i = 0, e = I.getNumOperands(); i != e; ++i)
      PushValueAndType(I.getOperand(i), InstID, Vals, VE);
    break;
  }
  case Instruction::ExtractValue: {
    Code = bitc::FUNC_CODE_INST_EXTRACTVAL;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    const ExtractValueInst *EVI = cast<ExtractValueInst>(&I);
    Vals.append(EVI->idx_begin(), EVI->idx_end());
    break;
  }
  case Instruction::InsertValue: {
    Code = bitc::FUNC_CODE_INST_INSERTVAL;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    PushValueAndType(I.getOperand(1), InstID, Vals, VE);
    const InsertValueInst *IVI = cast<InsertValueInst>(&I);
    Vals.append(IVI->idx_begin(), IVI->idx_end());
    break;
  }
  case Instruction::Select:
    Code = bitc::FUNC_CODE_INST_VSELECT;
    PushValueAndType(I.getOperand(1), InstID, Vals, VE);
    pushValue(I.getOperand(2), InstID, Vals, VE);
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    break;
  case Instruction::ExtractElement:
    Code = bitc::FUNC_CODE_INST_EXTRACTELT;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    PushValueAndType(I.getOperand(1), InstID, Vals, VE);
    break;
  case Instruction::InsertElement:
    Code = bitc::FUNC_CODE_INST_INSERTELT;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    pushValue(I.getOperand(1), InstID, Vals, VE);
    PushValueAndType(I.getOperand(2), InstID, Vals, VE);
    break;
  case Instruction::ShuffleVector:
    Code = bitc::FUNC_CODE_INST_SHUFFLEVEC;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    pushValue(I.getOperand(1), InstID, Vals, VE);
    pushValue(I.getOperand(2), InstID, Vals, VE);
    break;
  case Instruction::ICmp:
  case Instruction::FCmp: {
    // compare returning Int1Ty or vector of Int1Ty
    Code = bitc::FUNC_CODE_INST_CMP2;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    pushValue(I.getOperand(1), InstID, Vals, VE);
    Vals.push_back(cast<CmpInst>(I).getPredicate());
    uint64_t Flags = GetOptimizationFlags(&I);
    if (Flags != 0)
      Vals.push_back(Flags);
    break;
  }

  case Instruction::Ret:
    {
      Code = bitc::FUNC_CODE_INST_RET;
      unsigned NumOperands = I.getNumOperands();
      if (NumOperands == 0)
        AbbrevToUse = FUNCTION_INST_RET_VOID_ABBREV;
      else if (NumOperands == 1) {
        if (!PushValueAndType(I.getOperand(0), InstID, Vals, VE))
          AbbrevToUse = FUNCTION_INST_RET_VAL_ABBREV;
      } else {
        for (unsigned i = 0, e = NumOperands; i != e; ++i)
          PushValueAndType(I.getOperand(i), InstID, Vals, VE);
      }
    }
    break;
  case Instruction::Br:
    {
      Code = bitc::FUNC_CODE_INST_BR;
      const BranchInst &II = cast<BranchInst>(I);
      Vals.push_back(VE.getValueID(II.getSuccessor(0)));
      if (II.isConditional()) {
        Vals.push_back(VE.getValueID(II.getSuccessor(1)));
        pushValue(II.getCondition(), InstID, Vals, VE);
      }
    }
    break;
  case Instruction::Switch:
    {
      Code = bitc::FUNC_CODE_INST_SWITCH;
      const SwitchInst &SI = cast<SwitchInst>(I);
      Vals.push_back(VE.getTypeID(SI.getCondition()->getType()));
      pushValue(SI.getCondition(), InstID, Vals, VE);
      Vals.push_back(VE.getValueID(SI.getDefaultDest()));
      for (SwitchInst::ConstCaseIt Case : SI.cases()) {
        Vals.push_back(VE.getValueID(Case.getCaseValue()));
        Vals.push_back(VE.getValueID(Case.getCaseSuccessor()));
      }
    }
    break;
  case Instruction::IndirectBr:
    Code = bitc::FUNC_CODE_INST_INDIRECTBR;
    Vals.push_back(VE.getTypeID(I.getOperand(0)->getType()));
    // Encode the address operand as relative, but not the basic blocks.
    pushValue(I.getOperand(0), InstID, Vals, VE);
    for (unsigned i = 1, e = I.getNumOperands(); i != e; ++i)
      Vals.push_back(VE.getValueID(I.getOperand(i)));
    break;

  case Instruction::Invoke: {
    const InvokeInst *II = cast<InvokeInst>(&I);
    const Value *Callee = II->getCalledValue();
    FunctionType *FTy = II->getFunctionType();

    if (II->hasOperandBundles())
      WriteOperandBundles(Stream, II, InstID, VE);

    Code = bitc::FUNC_CODE_INST_INVOKE;

    Vals.push_back(VE.getAttributeID(II->getAttributes()));
    Vals.push_back(II->getCallingConv() | 1 << 13);
    Vals.push_back(VE.getValueID(II->getNormalDest()));
    Vals.push_back(VE.getValueID(II->getUnwindDest()));
    Vals.push_back(VE.getTypeID(FTy));
    PushValueAndType(Callee, InstID, Vals, VE);

    // Emit value #'s for the fixed parameters.
    for (unsigned i = 0, e = FTy->getNumParams(); i != e; ++i)
      pushValue(I.getOperand(i), InstID, Vals, VE);  // fixed param.

    // Emit type/value pairs for varargs params.
    if (FTy->isVarArg()) {
      for (unsigned i = FTy->getNumParams(), e = I.getNumOperands()-3;
           i != e; ++i)
        PushValueAndType(I.getOperand(i), InstID, Vals, VE); // vararg
    }
    break;
  }
  case Instruction::Resume:
    Code = bitc::FUNC_CODE_INST_RESUME;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    break;
  case Instruction::CleanupRet: {
    Code = bitc::FUNC_CODE_INST_CLEANUPRET;
    const auto &CRI = cast<CleanupReturnInst>(I);
    pushValue(CRI.getCleanupPad(), InstID, Vals, VE);
    if (CRI.hasUnwindDest())
      Vals.push_back(VE.getValueID(CRI.getUnwindDest()));
    break;
  }
  case Instruction::CatchRet: {
    Code = bitc::FUNC_CODE_INST_CATCHRET;
    const auto &CRI = cast<CatchReturnInst>(I);
    pushValue(CRI.getCatchPad(), InstID, Vals, VE);
    Vals.push_back(VE.getValueID(CRI.getSuccessor()));
    break;
  }
  case Instruction::CleanupPad:
  case Instruction::CatchPad: {
    const auto &FuncletPad = cast<FuncletPadInst>(I);
    Code = isa<CatchPadInst>(FuncletPad) ? bitc::FUNC_CODE_INST_CATCHPAD
                                         : bitc::FUNC_CODE_INST_CLEANUPPAD;
    pushValue(FuncletPad.getParentPad(), InstID, Vals, VE);

    unsigned NumArgOperands = FuncletPad.getNumArgOperands();
    Vals.push_back(NumArgOperands);
    for (unsigned Op = 0; Op != NumArgOperands; ++Op)
      PushValueAndType(FuncletPad.getArgOperand(Op), InstID, Vals, VE);
    break;
  }
  case Instruction::CatchSwitch: {
    Code = bitc::FUNC_CODE_INST_CATCHSWITCH;
    const auto &CatchSwitch = cast<CatchSwitchInst>(I);

    pushValue(CatchSwitch.getParentPad(), InstID, Vals, VE);

    unsigned NumHandlers = CatchSwitch.getNumHandlers();
    Vals.push_back(NumHandlers);
    for (const BasicBlock *CatchPadBB : CatchSwitch.handlers())
      Vals.push_back(VE.getValueID(CatchPadBB));

    if (CatchSwitch.hasUnwindDest())
      Vals.push_back(VE.getValueID(CatchSwitch.getUnwindDest()));
    break;
  }
  case Instruction::Unreachable:
    Code = bitc::FUNC_CODE_INST_UNREACHABLE;
    AbbrevToUse = FUNCTION_INST_UNREACHABLE_ABBREV;
    break;

  case Instruction::PHI: {
    const PHINode &PN = cast<PHINode>(I);
    Code = bitc::FUNC_CODE_INST_PHI;
    // With the newer instruction encoding, forward references could give
    // negative valued IDs.  This is most common for PHIs, so we use
    // signed VBRs.
    SmallVector<uint64_t, 128> Vals64;
    Vals64.push_back(VE.getTypeID(PN.getType()));
    for (unsigned i = 0, e = PN.getNumIncomingValues(); i != e; ++i) {
      pushValueSigned(PN.getIncomingValue(i), InstID, Vals64, VE);
      Vals64.push_back(VE.getValueID(PN.getIncomingBlock(i)));
    }
    // Emit a Vals64 vector and exit.
    Stream.EmitRecord(Code, Vals64, AbbrevToUse);
    Vals64.clear();
    return;
  }

  case Instruction::LandingPad: {
    const LandingPadInst &LP = cast<LandingPadInst>(I);
    Code = bitc::FUNC_CODE_INST_LANDINGPAD;
    Vals.push_back(VE.getTypeID(LP.getType()));
    Vals.push_back(LP.isCleanup());
    Vals.push_back(LP.getNumClauses());
    for (unsigned I = 0, E = LP.getNumClauses(); I != E; ++I) {
      if (LP.isCatch(I))
        Vals.push_back(LandingPadInst::Catch);
      else
        Vals.push_back(LandingPadInst::Filter);
      PushValueAndType(LP.getClause(I), InstID, Vals, VE);
    }
    break;
  }

  case Instruction::Alloca: {
    Code = bitc::FUNC_CODE_INST_ALLOCA;
    const AllocaInst &AI = cast<AllocaInst>(I);
    Vals.push_back(VE.getTypeID(AI.getAllocatedType()));
    Vals.push_back(VE.getTypeID(I.getOperand(0)->getType()));
    Vals.push_back(VE.getValueID(I.getOperand(0))); // size.
    unsigned AlignRecord = Log2_32(AI.getAlignment()) + 1;
    assert(Log2_32(Value::MaximumAlignment) + 1 < 1 << 5 &&
           "not enough bits for maximum alignment");
    assert(AlignRecord < 1 << 5 && "alignment greater than 1 << 64");
    AlignRecord |= AI.isUsedWithInAlloca() << 5;
    AlignRecord |= 1 << 6;
    // Reserve bit 7 for SwiftError flag.
    // AlignRecord |= AI.isSwiftError() << 7;
    Vals.push_back(AlignRecord);
    break;
  }

  case Instruction::Load:
    if (cast<LoadInst>(I).isAtomic()) {
      Code = bitc::FUNC_CODE_INST_LOADATOMIC;
      PushValueAndType(I.getOperand(0), InstID, Vals, VE);
    } else {
      Code = bitc::FUNC_CODE_INST_LOAD;
      if (!PushValueAndType(I.getOperand(0), InstID, Vals, VE))  // ptr
        AbbrevToUse = FUNCTION_INST_LOAD_ABBREV;
    }
    Vals.push_back(VE.getTypeID(I.getType()));
    Vals.push_back(Log2_32(cast<LoadInst>(I).getAlignment())+1);
    Vals.push_back(cast<LoadInst>(I).isVolatile());
    if (cast<LoadInst>(I).isAtomic()) {
      Vals.push_back(GetEncodedOrdering(cast<LoadInst>(I).getOrdering()));
      Vals.push_back(GetEncodedSynchScope(cast<LoadInst>(I).getSynchScope()));
    }
    break;
  case Instruction::Store:
    if (cast<StoreInst>(I).isAtomic())
      Code = bitc::FUNC_CODE_INST_STOREATOMIC;
    else
      Code = bitc::FUNC_CODE_INST_STORE;
    PushValueAndType(I.getOperand(1), InstID, Vals, VE);  // ptrty + ptr
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);  // valty + val
    Vals.push_back(Log2_32(cast<StoreInst>(I).getAlignment())+1);
    Vals.push_back(cast<StoreInst>(I).isVolatile());
    if (cast<StoreInst>(I).isAtomic()) {
      Vals.push_back(GetEncodedOrdering(cast<StoreInst>(I).getOrdering()));
      Vals.push_back(GetEncodedSynchScope(cast<StoreInst>(I).getSynchScope()));
    }
    break;
  case Instruction::AtomicCmpXchg:
    Code = bitc::FUNC_CODE_INST_CMPXCHG;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);  // ptrty + ptr
    PushValueAndType(I.getOperand(1), InstID, Vals, VE);  // cmp.
    pushValue(I.getOperand(2), InstID, Vals, VE);         // newval.
    Vals.push_back(cast<AtomicCmpXchgInst>(I).isVolatile());
    Vals.push_back(GetEncodedOrdering(
                     cast<AtomicCmpXchgInst>(I).getSuccessOrdering()));
    Vals.push_back(GetEncodedSynchScope(
                     cast<AtomicCmpXchgInst>(I).getSynchScope()));
    Vals.push_back(GetEncodedOrdering(
                     cast<AtomicCmpXchgInst>(I).getFailureOrdering()));
    Vals.push_back(cast<AtomicCmpXchgInst>(I).isWeak());
    break;
  case Instruction::AtomicRMW:
    Code = bitc::FUNC_CODE_INST_ATOMICRMW;
    PushValueAndType(I.getOperand(0), InstID, Vals, VE);  // ptrty + ptr
    pushValue(I.getOperand(1), InstID, Vals, VE);         // val.
    Vals.push_back(GetEncodedRMWOperation(
                     cast<AtomicRMWInst>(I).getOperation()));
    Vals.push_back(cast<AtomicRMWInst>(I).isVolatile());
    Vals.push_back(GetEncodedOrdering(cast<AtomicRMWInst>(I).getOrdering()));
    Vals.push_back(GetEncodedSynchScope(
                     cast<AtomicRMWInst>(I).getSynchScope()));
    break;
  case Instruction::Fence:
    Code = bitc::FUNC_CODE_INST_FENCE;
    Vals.push_back(GetEncodedOrdering(cast<FenceInst>(I).getOrdering()));
    Vals.push_back(GetEncodedSynchScope(cast<FenceInst>(I).getSynchScope()));
    break;
  case Instruction::Call: {
    const CallInst &CI = cast<CallInst>(I);
    FunctionType *FTy = CI.getFunctionType();

    if (CI.hasOperandBundles())
      WriteOperandBundles(Stream, &CI, InstID, VE);

    Code = bitc::FUNC_CODE_INST_CALL;

    Vals.push_back(VE.getAttributeID(CI.getAttributes()));

    unsigned Flags = GetOptimizationFlags(&I);
    Vals.push_back(CI.getCallingConv() << bitc::CALL_CCONV |
                   unsigned(CI.isTailCall()) << bitc::CALL_TAIL |
                   unsigned(CI.isMustTailCall()) << bitc::CALL_MUSTTAIL |
                   1 << bitc::CALL_EXPLICIT_TYPE |
                   unsigned(CI.isNoTailCall()) << bitc::CALL_NOTAIL |
                   unsigned(Flags != 0) << bitc::CALL_FMF);
    if (Flags != 0)
      Vals.push_back(Flags);

    Vals.push_back(VE.getTypeID(FTy));
    PushValueAndType(CI.getCalledValue(), InstID, Vals, VE);  // Callee

    // Emit value #'s for the fixed parameters.
    for (unsigned i = 0, e = FTy->getNumParams(); i != e; ++i) {
      // Check for labels (can happen with asm labels).
      if (FTy->getParamType(i)->isLabelTy())
        Vals.push_back(VE.getValueID(CI.getArgOperand(i)));
      else
        pushValue(CI.getArgOperand(i), InstID, Vals, VE);  // fixed param.
    }

    // Emit type/value pairs for varargs params.
    if (FTy->isVarArg()) {
      for (unsigned i = FTy->getNumParams(), e = CI.getNumArgOperands();
           i != e; ++i)
        PushValueAndType(CI.getArgOperand(i), InstID, Vals, VE);  // varargs
    }
    break;
  }
  case Instruction::VAArg:
    Code = bitc::FUNC_CODE_INST_VAARG;
    Vals.push_back(VE.getTypeID(I.getOperand(0)->getType()));   // valistty
    pushValue(I.getOperand(0), InstID, Vals, VE); // valist.
    Vals.push_back(VE.getTypeID(I.getType())); // restype.
    break;
  }

  Stream.EmitRecord(Code, Vals, AbbrevToUse);
  Vals.clear();
}

/// Emit names for globals/functions etc. The VSTOffsetPlaceholder,
/// BitcodeStartBit and ModuleSummaryIndex are only passed for the module-level
/// VST, where we are including a function bitcode index and need to
/// backpatch the VST forward declaration record.
static void WriteValueSymbolTable(
    const ValueSymbolTable &VST, const ValueEnumerator &VE,
    BitstreamWriter &Stream, uint64_t VSTOffsetPlaceholder = 0,
    uint64_t BitcodeStartBit = 0,
    DenseMap<const Function *, std::unique_ptr<GlobalValueInfo>>
        *FunctionIndex = nullptr) {
  if (VST.empty()) {
    // WriteValueSymbolTableForwardDecl should have returned early as
    // well. Ensure this handling remains in sync by asserting that
    // the placeholder offset is not set.
    assert(VSTOffsetPlaceholder == 0);
    return;
  }

  if (VSTOffsetPlaceholder > 0) {
    // Get the offset of the VST we are writing, and backpatch it into
    // the VST forward declaration record.
    uint64_t VSTOffset = Stream.GetCurrentBitNo();
    // The BitcodeStartBit was the stream offset of the actual bitcode
    // (e.g. excluding any initial darwin header).
    VSTOffset -= BitcodeStartBit;
    assert((VSTOffset & 31) == 0 && "VST block not 32-bit aligned");
    Stream.BackpatchWord(VSTOffsetPlaceholder, VSTOffset / 32);
  }

  Stream.EnterSubblock(bitc::VALUE_SYMTAB_BLOCK_ID, 4);

  // For the module-level VST, add abbrev Ids for the VST_CODE_FNENTRY
  // records, which are not used in the per-function VSTs.
  unsigned FnEntry8BitAbbrev;
  unsigned FnEntry7BitAbbrev;
  unsigned FnEntry6BitAbbrev;
  if (VSTOffsetPlaceholder > 0) {
    // 8-bit fixed-width VST_CODE_FNENTRY function strings.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_FNENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // value id
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // funcoffset
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8));
    FnEntry8BitAbbrev = Stream.EmitAbbrev(Abbv);

    // 7-bit fixed width VST_CODE_FNENTRY function strings.
    Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_FNENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // value id
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // funcoffset
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7));
    FnEntry7BitAbbrev = Stream.EmitAbbrev(Abbv);

    // 6-bit char6 VST_CODE_FNENTRY function strings.
    Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_FNENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // value id
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // funcoffset
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
    FnEntry6BitAbbrev = Stream.EmitAbbrev(Abbv);
  }

  // FIXME: Set up the abbrev, we know how many values there are!
  // FIXME: We know if the type names can use 7-bit ascii.
  SmallVector<unsigned, 64> NameVals;

  for (const ValueName &Name : VST) {
    // Figure out the encoding to use for the name.
    StringEncoding Bits =
        getStringEncoding(Name.getKeyData(), Name.getKeyLength());

    unsigned AbbrevToUse = VST_ENTRY_8_ABBREV;
    NameVals.push_back(VE.getValueID(Name.getValue()));

    Function *F = dyn_cast<Function>(Name.getValue());
    if (!F) {
      // If value is an alias, need to get the aliased base object to
      // see if it is a function.
      auto *GA = dyn_cast<GlobalAlias>(Name.getValue());
      if (GA && GA->getBaseObject())
        F = dyn_cast<Function>(GA->getBaseObject());
    }

    // VST_CODE_ENTRY:   [valueid, namechar x N]
    // VST_CODE_FNENTRY: [valueid, funcoffset, namechar x N]
    // VST_CODE_BBENTRY: [bbid, namechar x N]
    unsigned Code;
    if (isa<BasicBlock>(Name.getValue())) {
      Code = bitc::VST_CODE_BBENTRY;
      if (Bits == SE_Char6)
        AbbrevToUse = VST_BBENTRY_6_ABBREV;
    } else if (F && !F->isDeclaration()) {
      // Must be the module-level VST, where we pass in the Index and
      // have a VSTOffsetPlaceholder. The function-level VST should not
      // contain any Function symbols.
      assert(FunctionIndex);
      assert(VSTOffsetPlaceholder > 0);

      // Save the word offset of the function (from the start of the
      // actual bitcode written to the stream).
      uint64_t BitcodeIndex =
          (*FunctionIndex)[F]->bitcodeIndex() - BitcodeStartBit;
      assert((BitcodeIndex & 31) == 0 && "function block not 32-bit aligned");
      NameVals.push_back(BitcodeIndex / 32);

      Code = bitc::VST_CODE_FNENTRY;
      AbbrevToUse = FnEntry8BitAbbrev;
      if (Bits == SE_Char6)
        AbbrevToUse = FnEntry6BitAbbrev;
      else if (Bits == SE_Fixed7)
        AbbrevToUse = FnEntry7BitAbbrev;
    } else {
      Code = bitc::VST_CODE_ENTRY;
      if (Bits == SE_Char6)
        AbbrevToUse = VST_ENTRY_6_ABBREV;
      else if (Bits == SE_Fixed7)
        AbbrevToUse = VST_ENTRY_7_ABBREV;
    }

    for (const auto P : Name.getKey())
      NameVals.push_back((unsigned char)P);

    // Emit the finished record.
    Stream.EmitRecord(Code, NameVals, AbbrevToUse);
    NameVals.clear();
  }
  Stream.ExitBlock();
}

/// Emit function names and summary offsets for the combined index
/// used by ThinLTO.
static void
WriteCombinedValueSymbolTable(const ModuleSummaryIndex &Index,
                              BitstreamWriter &Stream,
                              std::map<uint64_t, unsigned> &GUIDToValueIdMap,
                              uint64_t VSTOffsetPlaceholder) {
  assert(VSTOffsetPlaceholder > 0 && "Expected non-zero VSTOffsetPlaceholder");
  // Get the offset of the VST we are writing, and backpatch it into
  // the VST forward declaration record.
  uint64_t VSTOffset = Stream.GetCurrentBitNo();
  assert((VSTOffset & 31) == 0 && "VST block not 32-bit aligned");
  Stream.BackpatchWord(VSTOffsetPlaceholder, VSTOffset / 32);

  Stream.EnterSubblock(bitc::VALUE_SYMTAB_BLOCK_ID, 4);

  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_COMBINED_GVDEFENTRY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // valueid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // sumoffset
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // guid
  unsigned DefEntryAbbrev = Stream.EmitAbbrev(Abbv);

  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_COMBINED_ENTRY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // valueid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // refguid
  unsigned EntryAbbrev = Stream.EmitAbbrev(Abbv);

  SmallVector<uint64_t, 64> NameVals;

  for (const auto &FII : Index) {
    uint64_t FuncGUID = FII.first;
    const auto &VMI = GUIDToValueIdMap.find(FuncGUID);
    assert(VMI != GUIDToValueIdMap.end());

    for (const auto &FI : FII.second) {
      // VST_CODE_COMBINED_GVDEFENTRY: [valueid, sumoffset, guid]
      NameVals.push_back(VMI->second);
      NameVals.push_back(FI->bitcodeIndex());
      NameVals.push_back(FuncGUID);

      // Emit the finished record.
      Stream.EmitRecord(bitc::VST_CODE_COMBINED_GVDEFENTRY, NameVals,
                        DefEntryAbbrev);
      NameVals.clear();
    }
    GUIDToValueIdMap.erase(VMI);
  }
  for (const auto &GVI : GUIDToValueIdMap) {
    // VST_CODE_COMBINED_ENTRY: [valueid, refguid]
    NameVals.push_back(GVI.second);
    NameVals.push_back(GVI.first);

    // Emit the finished record.
    Stream.EmitRecord(bitc::VST_CODE_COMBINED_ENTRY, NameVals, EntryAbbrev);
    NameVals.clear();
  }
  Stream.ExitBlock();
}

static void WriteUseList(ValueEnumerator &VE, UseListOrder &&Order,
                         BitstreamWriter &Stream) {
  assert(Order.Shuffle.size() >= 2 && "Shuffle too small");
  unsigned Code;
  if (isa<BasicBlock>(Order.V))
    Code = bitc::USELIST_CODE_BB;
  else
    Code = bitc::USELIST_CODE_DEFAULT;

  SmallVector<uint64_t, 64> Record(Order.Shuffle.begin(), Order.Shuffle.end());
  Record.push_back(VE.getValueID(Order.V));
  Stream.EmitRecord(Code, Record);
}

static void WriteUseListBlock(const Function *F, ValueEnumerator &VE,
                              BitstreamWriter &Stream) {
  assert(VE.shouldPreserveUseListOrder() &&
         "Expected to be preserving use-list order");

  auto hasMore = [&]() {
    return !VE.UseListOrders.empty() && VE.UseListOrders.back().F == F;
  };
  if (!hasMore())
    // Nothing to do.
    return;

  Stream.EnterSubblock(bitc::USELIST_BLOCK_ID, 3);
  while (hasMore()) {
    WriteUseList(VE, std::move(VE.UseListOrders.back()), Stream);
    VE.UseListOrders.pop_back();
  }
  Stream.ExitBlock();
}

// Walk through the operands of a given User via worklist iteration and populate
// the set of GlobalValue references encountered. Invoked either on an
// Instruction or a GlobalVariable (which walks its initializer).
static void findRefEdges(const User *CurUser, const ValueEnumerator &VE,
                         DenseSet<unsigned> &RefEdges,
                         SmallPtrSet<const User *, 8> &Visited) {
  SmallVector<const User *, 32> Worklist;
  Worklist.push_back(CurUser);

  while (!Worklist.empty()) {
    const User *U = Worklist.pop_back_val();

    if (!Visited.insert(U).second)
      continue;

    ImmutableCallSite CS(U);

    for (const auto &OI : U->operands()) {
      const User *Operand = dyn_cast<User>(OI);
      if (!Operand)
        continue;
      if (isa<BlockAddress>(Operand))
        continue;
      if (isa<GlobalValue>(Operand)) {
        // We have a reference to a global value. This should be added to
        // the reference set unless it is a callee. Callees are handled
        // specially by WriteFunction and are added to a separate list.
        if (!(CS && CS.isCallee(&OI)))
          RefEdges.insert(VE.getValueID(Operand));
        continue;
      }
      Worklist.push_back(Operand);
    }
  }
}

/// Emit a function body to the module stream.
static void WriteFunction(
    const Function &F, const Module *M, ValueEnumerator &VE,
    BitstreamWriter &Stream,
    DenseMap<const Function *, std::unique_ptr<GlobalValueInfo>> &FunctionIndex,
    bool EmitSummaryIndex) {
  // Save the bitcode index of the start of this function block for recording
  // in the VST.
  uint64_t BitcodeIndex = Stream.GetCurrentBitNo();

  bool HasProfileData = F.getEntryCount().hasValue();
  std::unique_ptr<BlockFrequencyInfo> BFI;
  if (EmitSummaryIndex && HasProfileData) {
    Function &Func = const_cast<Function &>(F);
    LoopInfo LI{DominatorTree(Func)};
    BranchProbabilityInfo BPI{Func, LI};
    BFI = llvm::make_unique<BlockFrequencyInfo>(Func, BPI, LI);
  }

  Stream.EnterSubblock(bitc::FUNCTION_BLOCK_ID, 4);
  VE.incorporateFunction(F);

  SmallVector<unsigned, 64> Vals;

  // Emit the number of basic blocks, so the reader can create them ahead of
  // time.
  Vals.push_back(VE.getBasicBlocks().size());
  Stream.EmitRecord(bitc::FUNC_CODE_DECLAREBLOCKS, Vals);
  Vals.clear();

  // If there are function-local constants, emit them now.
  unsigned CstStart, CstEnd;
  VE.getFunctionConstantRange(CstStart, CstEnd);
  WriteConstants(CstStart, CstEnd, VE, Stream, false);

  // If there is function-local metadata, emit it now.
  writeFunctionMetadata(F, VE, Stream);

  // Keep a running idea of what the instruction ID is.
  unsigned InstID = CstEnd;

  bool NeedsMetadataAttachment = F.hasMetadata();

  DILocation *LastDL = nullptr;
  unsigned NumInsts = 0;
  // Map from callee ValueId to profile count. Used to accumulate profile
  // counts for all static calls to a given callee.
  DenseMap<unsigned, CalleeInfo> CallGraphEdges;
  DenseSet<unsigned> RefEdges;

  SmallPtrSet<const User *, 8> Visited;
  // Finally, emit all the instructions, in order.
  for (Function::const_iterator BB = F.begin(), E = F.end(); BB != E; ++BB)
    for (BasicBlock::const_iterator I = BB->begin(), E = BB->end();
         I != E; ++I) {
      WriteInstruction(*I, InstID, VE, Stream, Vals);

      if (!isa<DbgInfoIntrinsic>(I))
        ++NumInsts;

      if (!I->getType()->isVoidTy())
        ++InstID;

      if (EmitSummaryIndex) {
        if (auto CS = ImmutableCallSite(&*I)) {
          auto *CalledFunction = CS.getCalledFunction();
          if (CalledFunction && CalledFunction->hasName() &&
              !CalledFunction->isIntrinsic()) {
            auto ScaledCount = BFI ? BFI->getBlockProfileCount(&*BB) : None;
            unsigned CalleeId = VE.getValueID(
                M->getValueSymbolTable().lookup(CalledFunction->getName()));
            CallGraphEdges[CalleeId] +=
                (ScaledCount ? ScaledCount.getValue() : 0);
          }
        }
        findRefEdges(&*I, VE, RefEdges, Visited);
      }

      // If the instruction has metadata, write a metadata attachment later.
      NeedsMetadataAttachment |= I->hasMetadataOtherThanDebugLoc();

      // If the instruction has a debug location, emit it.
      DILocation *DL = I->getDebugLoc();
      if (!DL)
        continue;

      if (DL == LastDL) {
        // Just repeat the same debug loc as last time.
        Stream.EmitRecord(bitc::FUNC_CODE_DEBUG_LOC_AGAIN, Vals);
        continue;
      }

      Vals.push_back(DL->getLine());
      Vals.push_back(DL->getColumn());
      Vals.push_back(VE.getMetadataOrNullID(DL->getScope()));
      Vals.push_back(VE.getMetadataOrNullID(DL->getInlinedAt()));
      Stream.EmitRecord(bitc::FUNC_CODE_DEBUG_LOC, Vals);
      Vals.clear();

      LastDL = DL;
    }

  std::unique_ptr<FunctionSummary> FuncSummary;
  if (EmitSummaryIndex) {
    FuncSummary = llvm::make_unique<FunctionSummary>(F.getLinkage(), NumInsts);
    FuncSummary->addCallGraphEdges(CallGraphEdges);
    FuncSummary->addRefEdges(RefEdges);
  }
  FunctionIndex[&F] =
      llvm::make_unique<GlobalValueInfo>(BitcodeIndex, std::move(FuncSummary));

  // Emit names for all the instructions etc.
  WriteValueSymbolTable(F.getValueSymbolTable(), VE, Stream);

  if (NeedsMetadataAttachment)
    WriteMetadataAttachment(F, VE, Stream);
  if (VE.shouldPreserveUseListOrder())
    WriteUseListBlock(&F, VE, Stream);
  VE.purgeFunction();
  Stream.ExitBlock();
}

// Emit blockinfo, which defines the standard abbreviations etc.
static void WriteBlockInfo(const ValueEnumerator &VE, BitstreamWriter &Stream) {
  // We only want to emit block info records for blocks that have multiple
  // instances: CONSTANTS_BLOCK, FUNCTION_BLOCK and VALUE_SYMTAB_BLOCK.
  // Other blocks can define their abbrevs inline.
  Stream.EnterBlockInfoBlock(2);

  { // 8-bit fixed-width VST_CODE_ENTRY/VST_CODE_BBENTRY strings.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 3));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8));
    if (Stream.EmitBlockInfoAbbrev(bitc::VALUE_SYMTAB_BLOCK_ID,
                                   Abbv) != VST_ENTRY_8_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  { // 7-bit fixed width VST_CODE_ENTRY strings.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_ENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7));
    if (Stream.EmitBlockInfoAbbrev(bitc::VALUE_SYMTAB_BLOCK_ID,
                                   Abbv) != VST_ENTRY_7_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // 6-bit char6 VST_CODE_ENTRY strings.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_ENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
    if (Stream.EmitBlockInfoAbbrev(bitc::VALUE_SYMTAB_BLOCK_ID,
                                   Abbv) != VST_ENTRY_6_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // 6-bit char6 VST_CODE_BBENTRY strings.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::VST_CODE_BBENTRY));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
    if (Stream.EmitBlockInfoAbbrev(bitc::VALUE_SYMTAB_BLOCK_ID,
                                   Abbv) != VST_BBENTRY_6_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }



  { // SETTYPE abbrev for CONSTANTS_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_SETTYPE));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,
                              VE.computeBitsRequiredForTypeIndicies()));
    if (Stream.EmitBlockInfoAbbrev(bitc::CONSTANTS_BLOCK_ID,
                                   Abbv) != CONSTANTS_SETTYPE_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  { // INTEGER abbrev for CONSTANTS_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_INTEGER));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
    if (Stream.EmitBlockInfoAbbrev(bitc::CONSTANTS_BLOCK_ID,
                                   Abbv) != CONSTANTS_INTEGER_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  { // CE_CAST abbrev for CONSTANTS_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_CE_CAST));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 4));  // cast opc
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,       // typeid
                              VE.computeBitsRequiredForTypeIndicies()));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));    // value id

    if (Stream.EmitBlockInfoAbbrev(bitc::CONSTANTS_BLOCK_ID,
                                   Abbv) != CONSTANTS_CE_CAST_Abbrev)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // NULL abbrev for CONSTANTS_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::CST_CODE_NULL));
    if (Stream.EmitBlockInfoAbbrev(bitc::CONSTANTS_BLOCK_ID,
                                   Abbv) != CONSTANTS_NULL_Abbrev)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  // FIXME: This should only use space for first class types!

  { // INST_LOAD abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_LOAD));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // Ptr
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,    // dest ty
                              VE.computeBitsRequiredForTypeIndicies()));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 4)); // Align
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1)); // volatile
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_LOAD_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // INST_BINOP abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_BINOP));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // LHS
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // RHS
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 4)); // opc
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_BINOP_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // INST_BINOP_FLAGS abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_BINOP));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // LHS
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // RHS
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 4)); // opc
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7)); // flags
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_BINOP_FLAGS_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // INST_CAST abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_CAST));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));    // OpVal
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed,       // dest ty
                              VE.computeBitsRequiredForTypeIndicies()));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 4));  // opc
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_CAST_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  { // INST_RET abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_RET));
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_RET_VOID_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // INST_RET abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_RET));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6)); // ValID
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_RET_VAL_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  { // INST_UNREACHABLE abbrev for FUNCTION_BLOCK.
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_UNREACHABLE));
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID,
                                   Abbv) != FUNCTION_INST_UNREACHABLE_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }
  {
    BitCodeAbbrev *Abbv = new BitCodeAbbrev();
    Abbv->Add(BitCodeAbbrevOp(bitc::FUNC_CODE_INST_GEP));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 1));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, // dest ty
                              Log2_32_Ceil(VE.getTypes().size() + 1)));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
    Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
    if (Stream.EmitBlockInfoAbbrev(bitc::FUNCTION_BLOCK_ID, Abbv) !=
        FUNCTION_INST_GEP_ABBREV)
      llvm_unreachable("Unexpected abbrev ordering!");
  }

  Stream.ExitBlock();
}

/// Write the module path strings, currently only used when generating
/// a combined index file.
static void WriteModStrings(const ModuleSummaryIndex &I,
                            BitstreamWriter &Stream) {
  Stream.EnterSubblock(bitc::MODULE_STRTAB_BLOCK_ID, 3);

  // TODO: See which abbrev sizes we actually need to emit

  // 8-bit fixed-width MST_ENTRY strings.
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::MST_CODE_ENTRY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 8));
  unsigned Abbrev8Bit = Stream.EmitAbbrev(Abbv);

  // 7-bit fixed width MST_ENTRY strings.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::MST_CODE_ENTRY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 7));
  unsigned Abbrev7Bit = Stream.EmitAbbrev(Abbv);

  // 6-bit char6 MST_ENTRY strings.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::MST_CODE_ENTRY));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
  unsigned Abbrev6Bit = Stream.EmitAbbrev(Abbv);

  SmallVector<unsigned, 64> NameVals;
  for (const StringMapEntry<uint64_t> &MPSE : I.modulePaths()) {
    StringEncoding Bits =
        getStringEncoding(MPSE.getKey().data(), MPSE.getKey().size());
    unsigned AbbrevToUse = Abbrev8Bit;
    if (Bits == SE_Char6)
      AbbrevToUse = Abbrev6Bit;
    else if (Bits == SE_Fixed7)
      AbbrevToUse = Abbrev7Bit;

    NameVals.push_back(MPSE.getValue());

    for (const auto P : MPSE.getKey())
      NameVals.push_back((unsigned char)P);

    // Emit the finished record.
    Stream.EmitRecord(bitc::MST_CODE_ENTRY, NameVals, AbbrevToUse);
    NameVals.clear();
  }
  Stream.ExitBlock();
}

// Helper to emit a single function summary record.
static void WritePerModuleFunctionSummaryRecord(
    SmallVector<uint64_t, 64> &NameVals, FunctionSummary *FS, unsigned ValueID,
    unsigned FSCallsAbbrev, unsigned FSCallsProfileAbbrev,
    BitstreamWriter &Stream, const Function &F) {
  assert(FS);
  NameVals.push_back(ValueID);
  NameVals.push_back(getEncodedLinkage(FS->linkage()));
  NameVals.push_back(FS->instCount());
  NameVals.push_back(FS->refs().size());

  for (auto &RI : FS->refs())
    NameVals.push_back(RI);

  bool HasProfileData = F.getEntryCount().hasValue();
  for (auto &ECI : FS->calls()) {
    NameVals.push_back(ECI.first);
    assert(ECI.second.CallsiteCount > 0 && "Expected at least one callsite");
    NameVals.push_back(ECI.second.CallsiteCount);
    if (HasProfileData)
      NameVals.push_back(ECI.second.ProfileCount);
  }

  unsigned FSAbbrev = (HasProfileData ? FSCallsProfileAbbrev : FSCallsAbbrev);
  unsigned Code =
      (HasProfileData ? bitc::FS_PERMODULE_PROFILE : bitc::FS_PERMODULE);

  // Emit the finished record.
  Stream.EmitRecord(Code, NameVals, FSAbbrev);
  NameVals.clear();
}

// Collect the global value references in the given variable's initializer,
// and emit them in a summary record.
static void WriteModuleLevelReferences(const GlobalVariable &V,
                                       const ValueEnumerator &VE,
                                       SmallVector<uint64_t, 64> &NameVals,
                                       unsigned FSModRefsAbbrev,
                                       BitstreamWriter &Stream) {
  // Only interested in recording variable defs in the summary.
  if (V.isDeclaration())
    return;
  DenseSet<unsigned> RefEdges;
  SmallPtrSet<const User *, 8> Visited;
  findRefEdges(&V, VE, RefEdges, Visited);
  NameVals.push_back(VE.getValueID(&V));
  NameVals.push_back(getEncodedLinkage(V.getLinkage()));
  for (auto RefId : RefEdges) {
    NameVals.push_back(RefId);
  }
  Stream.EmitRecord(bitc::FS_PERMODULE_GLOBALVAR_INIT_REFS, NameVals,
                    FSModRefsAbbrev);
  NameVals.clear();
}

/// Emit the per-module summary section alongside the rest of
/// the module's bitcode.
static void WritePerModuleGlobalValueSummary(
    DenseMap<const Function *, std::unique_ptr<GlobalValueInfo>> &FunctionIndex,
    const Module *M, const ValueEnumerator &VE, BitstreamWriter &Stream) {
  if (M->empty())
    return;

  Stream.EnterSubblock(bitc::GLOBALVAL_SUMMARY_BLOCK_ID, 3);

  // Abbrev for FS_PERMODULE.
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_PERMODULE));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // valueid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // instcount
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 4));   // numrefs
  // numrefs x valueid, n x (valueid, callsitecount)
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSCallsAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for FS_PERMODULE_PROFILE.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_PERMODULE_PROFILE));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // valueid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // instcount
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 4));   // numrefs
  // numrefs x valueid, n x (valueid, callsitecount, profilecount)
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSCallsProfileAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for FS_PERMODULE_GLOBALVAR_INIT_REFS.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_PERMODULE_GLOBALVAR_INIT_REFS));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8)); // valueid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));  // valueids
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSModRefsAbbrev = Stream.EmitAbbrev(Abbv);

  SmallVector<uint64_t, 64> NameVals;
  // Iterate over the list of functions instead of the FunctionIndex map to
  // ensure the ordering is stable.
  for (const Function &F : *M) {
    if (F.isDeclaration())
      continue;
    // Skip anonymous functions. We will emit a function summary for
    // any aliases below.
    if (!F.hasName())
      continue;

    assert(FunctionIndex.count(&F) == 1);

    WritePerModuleFunctionSummaryRecord(
        NameVals, cast<FunctionSummary>(FunctionIndex[&F]->summary()),
        VE.getValueID(M->getValueSymbolTable().lookup(F.getName())),
        FSCallsAbbrev, FSCallsProfileAbbrev, Stream, F);
  }

  for (const GlobalAlias &A : M->aliases()) {
    if (!A.getBaseObject())
      continue;
    const Function *F = dyn_cast<Function>(A.getBaseObject());
    if (!F || F->isDeclaration())
      continue;

    assert(FunctionIndex.count(F) == 1);
    FunctionSummary *FS =
        cast<FunctionSummary>(FunctionIndex[F]->summary());
    // Add the alias to the reference list of aliasee function.
    FS->addRefEdge(
        VE.getValueID(M->getValueSymbolTable().lookup(A.getName())));
    WritePerModuleFunctionSummaryRecord(
        NameVals, FS,
        VE.getValueID(M->getValueSymbolTable().lookup(A.getName())),
        FSCallsAbbrev, FSCallsProfileAbbrev, Stream, *F);
  }

  // Capture references from GlobalVariable initializers, which are outside
  // of a function scope.
  for (const GlobalVariable &G : M->globals())
    WriteModuleLevelReferences(G, VE, NameVals, FSModRefsAbbrev, Stream);
  for (const GlobalAlias &A : M->aliases())
    if (auto *GV = dyn_cast<GlobalVariable>(A.getBaseObject()))
      WriteModuleLevelReferences(*GV, VE, NameVals, FSModRefsAbbrev, Stream);

  Stream.ExitBlock();
}

/// Emit the combined summary section into the combined index file.
static void WriteCombinedGlobalValueSummary(
    const ModuleSummaryIndex &I, BitstreamWriter &Stream,
    std::map<uint64_t, unsigned> &GUIDToValueIdMap, unsigned GlobalValueId) {
  Stream.EnterSubblock(bitc::GLOBALVAL_SUMMARY_BLOCK_ID, 3);

  // Abbrev for FS_COMBINED.
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_COMBINED));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // modid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // instcount
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 4));   // numrefs
  // numrefs x valueid, n x (valueid, callsitecount)
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSCallsAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for FS_COMBINED_PROFILE.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_COMBINED_PROFILE));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // modid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // instcount
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 4));   // numrefs
  // numrefs x valueid, n x (valueid, callsitecount, profilecount)
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSCallsProfileAbbrev = Stream.EmitAbbrev(Abbv);

  // Abbrev for FS_COMBINED_GLOBALVAR_INIT_REFS.
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::FS_COMBINED_GLOBALVAR_INIT_REFS));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));   // modid
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Fixed, 5)); // linkage
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));    // valueids
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 8));
  unsigned FSModRefsAbbrev = Stream.EmitAbbrev(Abbv);

  SmallVector<uint64_t, 64> NameVals;
  for (const auto &FII : I) {
    for (auto &FI : FII.second) {
      GlobalValueSummary *S = FI->summary();
      assert(S);

      if (auto *VS = dyn_cast<GlobalVarSummary>(S)) {
        NameVals.push_back(I.getModuleId(VS->modulePath()));
        NameVals.push_back(getEncodedLinkage(VS->linkage()));
        for (auto &RI : VS->refs()) {
          const auto &VMI = GUIDToValueIdMap.find(RI);
          unsigned RefId;
          // If this GUID doesn't have an entry, assign one.
          if (VMI == GUIDToValueIdMap.end()) {
            GUIDToValueIdMap[RI] = ++GlobalValueId;
            RefId = GlobalValueId;
          } else {
            RefId = VMI->second;
          }
          NameVals.push_back(RefId);
        }

        // Record the starting offset of this summary entry for use
        // in the VST entry. Add the current code size since the
        // reader will invoke readRecord after the abbrev id read.
        FI->setBitcodeIndex(Stream.GetCurrentBitNo() +
                            Stream.GetAbbrevIDWidth());

        // Emit the finished record.
        Stream.EmitRecord(bitc::FS_COMBINED_GLOBALVAR_INIT_REFS, NameVals,
                          FSModRefsAbbrev);
        NameVals.clear();
        continue;
      }

      auto *FS = cast<FunctionSummary>(S);
      NameVals.push_back(I.getModuleId(FS->modulePath()));
      NameVals.push_back(getEncodedLinkage(FS->linkage()));
      NameVals.push_back(FS->instCount());
      NameVals.push_back(FS->refs().size());

      for (auto &RI : FS->refs()) {
        const auto &VMI = GUIDToValueIdMap.find(RI);
        unsigned RefId;
        // If this GUID doesn't have an entry, assign one.
        if (VMI == GUIDToValueIdMap.end()) {
          GUIDToValueIdMap[RI] = ++GlobalValueId;
          RefId = GlobalValueId;
        } else {
          RefId = VMI->second;
        }
        NameVals.push_back(RefId);
      }

      bool HasProfileData = false;
      for (auto &EI : FS->calls()) {
        HasProfileData |= EI.second.ProfileCount != 0;
        if (HasProfileData)
          break;
      }

      for (auto &EI : FS->calls()) {
        const auto &VMI = GUIDToValueIdMap.find(EI.first);
        // If this GUID doesn't have an entry, it doesn't have a function
        // summary and we don't need to record any calls to it.
        if (VMI == GUIDToValueIdMap.end())
          continue;
        NameVals.push_back(VMI->second);
        assert(EI.second.CallsiteCount > 0 && "Expected at least one callsite");
        NameVals.push_back(EI.second.CallsiteCount);
        if (HasProfileData)
          NameVals.push_back(EI.second.ProfileCount);
      }

      // Record the starting offset of this summary entry for use
      // in the VST entry. Add the current code size since the
      // reader will invoke readRecord after the abbrev id read.
      FI->setBitcodeIndex(Stream.GetCurrentBitNo() + Stream.GetAbbrevIDWidth());

      unsigned FSAbbrev =
          (HasProfileData ? FSCallsProfileAbbrev : FSCallsAbbrev);
      unsigned Code =
          (HasProfileData ? bitc::FS_COMBINED_PROFILE : bitc::FS_COMBINED);

      // Emit the finished record.
      Stream.EmitRecord(Code, NameVals, FSAbbrev);
      NameVals.clear();
    }
  }

  Stream.ExitBlock();
}

// Create the "IDENTIFICATION_BLOCK_ID" containing a single string with the
// current llvm version, and a record for the epoch number.
static void WriteIdentificationBlock(const Module *M, BitstreamWriter &Stream) {
  Stream.EnterSubblock(bitc::IDENTIFICATION_BLOCK_ID, 5);

  // Write the "user readable" string identifying the bitcode producer
  BitCodeAbbrev *Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::IDENTIFICATION_CODE_STRING));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Array));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::Char6));
  auto StringAbbrev = Stream.EmitAbbrev(Abbv);
  WriteStringRecord(bitc::IDENTIFICATION_CODE_STRING,
                    "LLVM" LLVM_VERSION_STRING, StringAbbrev, Stream);

  // Write the epoch version
  Abbv = new BitCodeAbbrev();
  Abbv->Add(BitCodeAbbrevOp(bitc::IDENTIFICATION_CODE_EPOCH));
  Abbv->Add(BitCodeAbbrevOp(BitCodeAbbrevOp::VBR, 6));
  auto EpochAbbrev = Stream.EmitAbbrev(Abbv);
  SmallVector<unsigned, 1> Vals = {bitc::BITCODE_CURRENT_EPOCH};
  Stream.EmitRecord(bitc::IDENTIFICATION_CODE_EPOCH, Vals, EpochAbbrev);
  Stream.ExitBlock();
}

/// WriteModule - Emit the specified module to the bitstream.
static void WriteModule(const Module *M, BitstreamWriter &Stream,
                        bool ShouldPreserveUseListOrder,
                        uint64_t BitcodeStartBit, bool EmitSummaryIndex) {
  Stream.EnterSubblock(bitc::MODULE_BLOCK_ID, 3);

  SmallVector<unsigned, 1> Vals;
  unsigned CurVersion = 1;
  Vals.push_back(CurVersion);
  Stream.EmitRecord(bitc::MODULE_CODE_VERSION, Vals);

  // Analyze the module, enumerating globals, functions, etc.
  ValueEnumerator VE(*M, ShouldPreserveUseListOrder);

  // Emit blockinfo, which defines the standard abbreviations etc.
  WriteBlockInfo(VE, Stream);

  // Emit information about attribute groups.
  WriteAttributeGroupTable(VE, Stream);

  // Emit information about parameter attributes.
  WriteAttributeTable(VE, Stream);

  // Emit information describing all of the types in the module.
  WriteTypeTable(VE, Stream);

  writeComdats(VE, Stream);

  // Emit top-level description of module, including target triple, inline asm,
  // descriptors for global variables, and function prototype info.
  uint64_t VSTOffsetPlaceholder = WriteModuleInfo(M, VE, Stream);

  // Emit constants.
  WriteModuleConstants(VE, Stream);

  // Emit metadata.
  writeModuleMetadata(*M, VE, Stream);

  // Emit metadata.
  WriteModuleMetadataStore(M, Stream);

  // Emit module-level use-lists.
  if (VE.shouldPreserveUseListOrder())
    WriteUseListBlock(nullptr, VE, Stream);

  WriteOperandBundleTags(M, Stream);

  // Emit function bodies.
  DenseMap<const Function *, std::unique_ptr<GlobalValueInfo>> FunctionIndex;
  for (Module::const_iterator F = M->begin(), E = M->end(); F != E; ++F)
    if (!F->isDeclaration())
      WriteFunction(*F, M, VE, Stream, FunctionIndex, EmitSummaryIndex);

  // Need to write after the above call to WriteFunction which populates
  // the summary information in the index.
  if (EmitSummaryIndex)
    WritePerModuleGlobalValueSummary(FunctionIndex, M, VE, Stream);

  WriteValueSymbolTable(M->getValueSymbolTable(), VE, Stream,
                        VSTOffsetPlaceholder, BitcodeStartBit, &FunctionIndex);

  Stream.ExitBlock();
}

/// EmitDarwinBCHeader - If generating a bc file on darwin, we have to emit a
/// header and trailer to make it compatible with the system archiver.  To do
/// this we emit the following header, and then emit a trailer that pads the
/// file out to be a multiple of 16 bytes.
///
/// struct bc_header {
///   uint32_t Magic;         // 0x0B17C0DE
///   uint32_t Version;       // Version, currently always 0.
///   uint32_t BitcodeOffset; // Offset to traditional bitcode file.
///   uint32_t BitcodeSize;   // Size of traditional bitcode file.
///   uint32_t CPUType;       // CPU specifier.
///   ... potentially more later ...
/// };

static void WriteInt32ToBuffer(uint32_t Value, SmallVectorImpl<char> &Buffer,
                               uint32_t &Position) {
  support::endian::write32le(&Buffer[Position], Value);
  Position += 4;
}

static void EmitDarwinBCHeaderAndTrailer(SmallVectorImpl<char> &Buffer,
                                         const Triple &TT) {
  unsigned CPUType = ~0U;

  // Match x86_64-*, i[3-9]86-*, powerpc-*, powerpc64-*, arm-*, thumb-*,
  // armv[0-9]-*, thumbv[0-9]-*, armv5te-*, or armv6t2-*. The CPUType is a magic
  // number from /usr/include/mach/machine.h.  It is ok to reproduce the
  // specific constants here because they are implicitly part of the Darwin ABI.
  enum {
    DARWIN_CPU_ARCH_ABI64      = 0x01000000,
    DARWIN_CPU_TYPE_X86        = 7,
    DARWIN_CPU_TYPE_ARM        = 12,
    DARWIN_CPU_TYPE_POWERPC    = 18
  };

  Triple::ArchType Arch = TT.getArch();
  if (Arch == Triple::x86_64)
    CPUType = DARWIN_CPU_TYPE_X86 | DARWIN_CPU_ARCH_ABI64;
  else if (Arch == Triple::x86)
    CPUType = DARWIN_CPU_TYPE_X86;
  else if (Arch == Triple::ppc)
    CPUType = DARWIN_CPU_TYPE_POWERPC;
  else if (Arch == Triple::ppc64)
    CPUType = DARWIN_CPU_TYPE_POWERPC | DARWIN_CPU_ARCH_ABI64;
  else if (Arch == Triple::arm || Arch == Triple::thumb)
    CPUType = DARWIN_CPU_TYPE_ARM;

  // Traditional Bitcode starts after header.
  assert(Buffer.size() >= BWH_HeaderSize &&
         "Expected header size to be reserved");
  unsigned BCOffset = BWH_HeaderSize;
  unsigned BCSize = Buffer.size() - BWH_HeaderSize;

  // Write the magic and version.
  unsigned Position = 0;
  WriteInt32ToBuffer(0x0B17C0DE , Buffer, Position);
  WriteInt32ToBuffer(0          , Buffer, Position); // Version.
  WriteInt32ToBuffer(BCOffset   , Buffer, Position);
  WriteInt32ToBuffer(BCSize     , Buffer, Position);
  WriteInt32ToBuffer(CPUType    , Buffer, Position);

  // If the file is not a multiple of 16 bytes, insert dummy padding.
  while (Buffer.size() & 15)
    Buffer.push_back(0);
}

/// Helper to write the header common to all bitcode files.
static void WriteBitcodeHeader(BitstreamWriter &Stream) {
  // Emit the file header.
  Stream.Emit((unsigned)'B', 8);
  Stream.Emit((unsigned)'C', 8);
  Stream.Emit(0x0, 4);
  Stream.Emit(0xC, 4);
  Stream.Emit(0xE, 4);
  Stream.Emit(0xD, 4);
}

/// WriteBitcodeToFile - Write the specified module to the specified output
/// stream.
void llvm::WriteBitcodeToFile(const Module *M, raw_ostream &Out,
                              bool ShouldPreserveUseListOrder,
                              bool EmitSummaryIndex) {
  SmallVector<char, 0> Buffer;
  Buffer.reserve(256*1024);

  // If this is darwin or another generic macho target, reserve space for the
  // header.
  Triple TT(M->getTargetTriple());
  if (TT.isOSDarwin() || TT.isOSBinFormatMachO())
    Buffer.insert(Buffer.begin(), BWH_HeaderSize, 0);

  // Emit the module into the buffer.
  {
    BitstreamWriter Stream(Buffer);
    // Save the start bit of the actual bitcode, in case there is space
    // saved at the start for the darwin header above. The reader stream
    // will start at the bitcode, and we need the offset of the VST
    // to line up.
    uint64_t BitcodeStartBit = Stream.GetCurrentBitNo();

    // Emit the file header.
    WriteBitcodeHeader(Stream);

    WriteIdentificationBlock(M, Stream);

    // Emit the module.
    WriteModule(M, Stream, ShouldPreserveUseListOrder, BitcodeStartBit,
                EmitSummaryIndex);
  }

  if (TT.isOSDarwin() || TT.isOSBinFormatMachO())
    EmitDarwinBCHeaderAndTrailer(Buffer, TT);

  // Write the generated bitstream to "Out".
  Out.write((char*)&Buffer.front(), Buffer.size());
}

// Write the specified module summary index to the given raw output stream,
// where it will be written in a new bitcode block. This is used when
// writing the combined index file for ThinLTO.
void llvm::WriteIndexToFile(const ModuleSummaryIndex &Index, raw_ostream &Out) {
  SmallVector<char, 0> Buffer;
  Buffer.reserve(256 * 1024);

  BitstreamWriter Stream(Buffer);

  // Emit the bitcode header.
  WriteBitcodeHeader(Stream);

  Stream.EnterSubblock(bitc::MODULE_BLOCK_ID, 3);

  SmallVector<unsigned, 1> Vals;
  unsigned CurVersion = 1;
  Vals.push_back(CurVersion);
  Stream.EmitRecord(bitc::MODULE_CODE_VERSION, Vals);

  // If we have a VST, write the VSTOFFSET record placeholder and record
  // its offset.
  uint64_t VSTOffsetPlaceholder = WriteValueSymbolTableForwardDecl(Stream);

  // Write the module paths in the combined index.
  WriteModStrings(Index, Stream);

  // Assign unique value ids to all functions in the index for use
  // in writing out the call graph edges. Save the mapping from GUID
  // to the new global value id to use when writing those edges, which
  // are currently saved in the index in terms of GUID.
  std::map<uint64_t, unsigned> GUIDToValueIdMap;
  unsigned GlobalValueId = 0;
  for (auto &II : Index)
    GUIDToValueIdMap[II.first] = ++GlobalValueId;

  // Write the summary combined index records.
  WriteCombinedGlobalValueSummary(Index, Stream, GUIDToValueIdMap,
                                  GlobalValueId);

  // Need a special VST writer for the combined index (we don't have a
  // real VST and real values when this is invoked).
  WriteCombinedValueSymbolTable(Index, Stream, GUIDToValueIdMap,
                                VSTOffsetPlaceholder);

  Stream.ExitBlock();

  Out.write((char *)&Buffer.front(), Buffer.size());
}
