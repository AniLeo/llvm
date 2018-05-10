//===- AMDGPUInstructionSelector.cpp ----------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AMDGPUInstructionSelector.h"
#include "AMDGPUInstrInfo.h"
#include "AMDGPURegisterBankInfo.h"
#include "AMDGPURegisterInfo.h"
#include "AMDGPUSubtarget.h"
#include "AMDGPUTargetMachine.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelector.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelectorImpl.h"
#include "llvm/CodeGen/GlobalISel/Utils.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#define DEBUG_TYPE "amdgpu-isel"

using namespace llvm;

#define GET_GLOBALISEL_IMPL
#include "AMDGPUGenGlobalISel.inc"
#undef GET_GLOBALISEL_IMPL

AMDGPUInstructionSelector::AMDGPUInstructionSelector(
    const SISubtarget &STI, const AMDGPURegisterBankInfo &RBI,
    const AMDGPUTargetMachine &TM)
    : InstructionSelector(), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI), TM(TM),
      STI(STI),
      EnableLateStructurizeCFG(AMDGPUTargetMachine::EnableLateStructurizeCFG),
#define GET_GLOBALISEL_PREDICATES_INIT
#include "AMDGPUGenGlobalISel.inc"
#undef GET_GLOBALISEL_PREDICATES_INIT
#define GET_GLOBALISEL_TEMPORARIES_INIT
#include "AMDGPUGenGlobalISel.inc"
#undef GET_GLOBALISEL_TEMPORARIES_INIT
      ,AMDGPUASI(STI.getAMDGPUAS())
{
}

const char *AMDGPUInstructionSelector::getName() { return DEBUG_TYPE; }

bool AMDGPUInstructionSelector::selectCOPY(MachineInstr &I) const {
  MachineBasicBlock *BB = I.getParent();
  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  I.setDesc(TII.get(TargetOpcode::COPY));
  for (const MachineOperand &MO : I.operands()) {
    if (TargetRegisterInfo::isPhysicalRegister(MO.getReg()))
      continue;

    const TargetRegisterClass *RC =
            TRI.getConstrainedRegClassForOperand(MO, MRI);
    if (!RC)
      continue;
    RBI.constrainGenericRegister(MO.getReg(), *RC, MRI);
  }
  return true;
}

MachineOperand
AMDGPUInstructionSelector::getSubOperand64(MachineOperand &MO,
                                           unsigned SubIdx) const {

  MachineInstr *MI = MO.getParent();
  MachineBasicBlock *BB = MO.getParent()->getParent();
  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  unsigned DstReg = MRI.createVirtualRegister(&AMDGPU::SGPR_32RegClass);

  if (MO.isReg()) {
    unsigned ComposedSubIdx = TRI.composeSubRegIndices(MO.getSubReg(), SubIdx);
    unsigned Reg = MO.getReg();
    BuildMI(*BB, MI, MI->getDebugLoc(), TII.get(AMDGPU::COPY), DstReg)
            .addReg(Reg, 0, ComposedSubIdx);

    return MachineOperand::CreateReg(DstReg, MO.isDef(), MO.isImplicit(),
                                     MO.isKill(), MO.isDead(), MO.isUndef(),
                                     MO.isEarlyClobber(), 0, MO.isDebug(),
                                     MO.isInternalRead());
  }

  assert(MO.isImm());

  APInt Imm(64, MO.getImm());

  switch (SubIdx) {
  default:
    llvm_unreachable("do not know to split immediate with this sub index.");
  case AMDGPU::sub0:
    return MachineOperand::CreateImm(Imm.getLoBits(32).getSExtValue());
  case AMDGPU::sub1:
    return MachineOperand::CreateImm(Imm.getHiBits(32).getSExtValue());
  }
}

bool AMDGPUInstructionSelector::selectG_ADD(MachineInstr &I) const {
  MachineBasicBlock *BB = I.getParent();
  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  unsigned Size = RBI.getSizeInBits(I.getOperand(0).getReg(), MRI, TRI);
  unsigned DstLo = MRI.createVirtualRegister(&AMDGPU::SReg_32RegClass);
  unsigned DstHi = MRI.createVirtualRegister(&AMDGPU::SReg_32RegClass);

  if (Size != 64)
    return false;

  DebugLoc DL = I.getDebugLoc();

  MachineOperand Lo1(getSubOperand64(I.getOperand(1), AMDGPU::sub0));
  MachineOperand Lo2(getSubOperand64(I.getOperand(2), AMDGPU::sub0));

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::S_ADD_U32), DstLo)
          .add(Lo1)
          .add(Lo2);

  MachineOperand Hi1(getSubOperand64(I.getOperand(1), AMDGPU::sub1));
  MachineOperand Hi2(getSubOperand64(I.getOperand(2), AMDGPU::sub1));

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::S_ADDC_U32), DstHi)
          .add(Hi1)
          .add(Hi2);

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::REG_SEQUENCE), I.getOperand(0).getReg())
          .addReg(DstLo)
          .addImm(AMDGPU::sub0)
          .addReg(DstHi)
          .addImm(AMDGPU::sub1);

  for (MachineOperand &MO : I.explicit_operands()) {
    if (!MO.isReg() || TargetRegisterInfo::isPhysicalRegister(MO.getReg()))
      continue;
    RBI.constrainGenericRegister(MO.getReg(), AMDGPU::SReg_64RegClass, MRI);
  }

  I.eraseFromParent();
  return true;
}

bool AMDGPUInstructionSelector::selectG_GEP(MachineInstr &I) const {
  return selectG_ADD(I);
}

bool AMDGPUInstructionSelector::selectG_STORE(MachineInstr &I) const {
  MachineBasicBlock *BB = I.getParent();
  DebugLoc DL = I.getDebugLoc();

  // FIXME: Select store instruction based on address space
  MachineInstr *Flat = BuildMI(*BB, &I, DL, TII.get(AMDGPU::FLAT_STORE_DWORD))
          .add(I.getOperand(1))
          .add(I.getOperand(0))
          .addImm(0)  // offset
          .addImm(0)  // glc
          .addImm(0); // slc


  // Now that we selected an opcode, we need to constrain the register
  // operands to use appropriate classes.
  bool Ret = constrainSelectedInstRegOperands(*Flat, TII, TRI, RBI);

  I.eraseFromParent();
  return Ret;
}

bool AMDGPUInstructionSelector::selectG_CONSTANT(MachineInstr &I) const {
  MachineBasicBlock *BB = I.getParent();
  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  unsigned DstReg = I.getOperand(0).getReg();
  unsigned Size = RBI.getSizeInBits(DstReg, MRI, TRI);

  if (Size == 32) {
    I.setDesc(TII.get(AMDGPU::S_MOV_B32));
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  assert(Size == 64);

  DebugLoc DL = I.getDebugLoc();
  unsigned LoReg = MRI.createVirtualRegister(&AMDGPU::SReg_32RegClass);
  unsigned HiReg = MRI.createVirtualRegister(&AMDGPU::SReg_32RegClass);
  const APInt &Imm = I.getOperand(1).getCImm()->getValue();

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::S_MOV_B32), LoReg)
          .addImm(Imm.trunc(32).getZExtValue());

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::S_MOV_B32), HiReg)
          .addImm(Imm.ashr(32).getZExtValue());

  BuildMI(*BB, &I, DL, TII.get(AMDGPU::REG_SEQUENCE), DstReg)
          .addReg(LoReg)
          .addImm(AMDGPU::sub0)
          .addReg(HiReg)
          .addImm(AMDGPU::sub1);
  // We can't call constrainSelectedInstRegOperands here, because it doesn't
  // work for target independent opcodes
  I.eraseFromParent();
  return RBI.constrainGenericRegister(DstReg, AMDGPU::SReg_64RegClass, MRI);
}

static bool isConstant(const MachineInstr &MI) {
  return MI.getOpcode() == TargetOpcode::G_CONSTANT;
}

void AMDGPUInstructionSelector::getAddrModeInfo(const MachineInstr &Load,
    const MachineRegisterInfo &MRI, SmallVectorImpl<GEPInfo> &AddrInfo) const {

  const MachineInstr *PtrMI = MRI.getUniqueVRegDef(Load.getOperand(1).getReg());

  assert(PtrMI);

  if (PtrMI->getOpcode() != TargetOpcode::G_GEP)
    return;

  GEPInfo GEPInfo(*PtrMI);

  for (unsigned i = 1, e = 3; i < e; ++i) {
    const MachineOperand &GEPOp = PtrMI->getOperand(i);
    const MachineInstr *OpDef = MRI.getUniqueVRegDef(GEPOp.getReg());
    assert(OpDef);
    if (isConstant(*OpDef)) {
      // FIXME: Is it possible to have multiple Imm parts?  Maybe if we
      // are lacking other optimizations.
      assert(GEPInfo.Imm == 0);
      GEPInfo.Imm = OpDef->getOperand(1).getCImm()->getSExtValue();
      continue;
    }
    const RegisterBank *OpBank = RBI.getRegBank(GEPOp.getReg(), MRI, TRI);
    if (OpBank->getID() == AMDGPU::SGPRRegBankID)
      GEPInfo.SgprParts.push_back(GEPOp.getReg());
    else
      GEPInfo.VgprParts.push_back(GEPOp.getReg());
  }

  AddrInfo.push_back(GEPInfo);
  getAddrModeInfo(*PtrMI, MRI, AddrInfo);
}

static bool isInstrUniform(const MachineInstr &MI) {
  if (!MI.hasOneMemOperand())
    return false;

  const MachineMemOperand *MMO = *MI.memoperands_begin();
  const Value *Ptr = MMO->getValue();

  // UndefValue means this is a load of a kernel input.  These are uniform.
  // Sometimes LDS instructions have constant pointers.
  // If Ptr is null, then that means this mem operand contains a
  // PseudoSourceValue like GOT.
  if (!Ptr || isa<UndefValue>(Ptr) || isa<Argument>(Ptr) ||
      isa<Constant>(Ptr) || isa<GlobalValue>(Ptr))
    return true;

  if (MMO->getAddrSpace() == AMDGPUAS::CONSTANT_ADDRESS_32BIT)
    return true;

  const Instruction *I = dyn_cast<Instruction>(Ptr);
  return I && I->getMetadata("amdgpu.uniform");
}

static unsigned getSmrdOpcode(unsigned BaseOpcode, unsigned LoadSize) {

  if (LoadSize == 32)
    return BaseOpcode;

  switch (BaseOpcode) {
  case AMDGPU::S_LOAD_DWORD_IMM:
    switch (LoadSize) {
    case 64:
      return AMDGPU::S_LOAD_DWORDX2_IMM;
    case 128:
      return AMDGPU::S_LOAD_DWORDX4_IMM;
    case 256:
      return AMDGPU::S_LOAD_DWORDX8_IMM;
    case 512:
      return AMDGPU::S_LOAD_DWORDX16_IMM;
    }
    break;
  case AMDGPU::S_LOAD_DWORD_IMM_ci:
    switch (LoadSize) {
    case 64:
      return AMDGPU::S_LOAD_DWORDX2_IMM_ci;
    case 128:
      return AMDGPU::S_LOAD_DWORDX4_IMM_ci;
    case 256:
      return AMDGPU::S_LOAD_DWORDX8_IMM_ci;
    case 512:
      return AMDGPU::S_LOAD_DWORDX16_IMM_ci;
    }
    break;
  case AMDGPU::S_LOAD_DWORD_SGPR:
    switch (LoadSize) {
    case 64:
      return AMDGPU::S_LOAD_DWORDX2_SGPR;
    case 128:
      return AMDGPU::S_LOAD_DWORDX4_SGPR;
    case 256:
      return AMDGPU::S_LOAD_DWORDX8_SGPR;
    case 512:
      return AMDGPU::S_LOAD_DWORDX16_SGPR;
    }
    break;
  }
  llvm_unreachable("Invalid base smrd opcode or size");
}

bool AMDGPUInstructionSelector::hasVgprParts(ArrayRef<GEPInfo> AddrInfo) const {
  for (const GEPInfo &GEPInfo : AddrInfo) {
    if (!GEPInfo.VgprParts.empty())
      return true;
  }
  return false;
}

bool AMDGPUInstructionSelector::selectSMRD(MachineInstr &I,
                                           ArrayRef<GEPInfo> AddrInfo) const {

  if (!I.hasOneMemOperand())
    return false;

  if ((*I.memoperands_begin())->getAddrSpace() != AMDGPUASI.CONSTANT_ADDRESS &&
      (*I.memoperands_begin())->getAddrSpace() != AMDGPUASI.CONSTANT_ADDRESS_32BIT)
    return false;

  if (!isInstrUniform(I))
    return false;

  if (hasVgprParts(AddrInfo))
    return false;

  MachineBasicBlock *BB = I.getParent();
  MachineFunction *MF = BB->getParent();
  const SISubtarget &Subtarget = MF->getSubtarget<SISubtarget>();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  unsigned DstReg = I.getOperand(0).getReg();
  const DebugLoc &DL = I.getDebugLoc();
  unsigned Opcode;
  unsigned LoadSize = RBI.getSizeInBits(DstReg, MRI, TRI);

  if (!AddrInfo.empty() && AddrInfo[0].SgprParts.size() == 1) {

    const GEPInfo &GEPInfo = AddrInfo[0];

    unsigned PtrReg = GEPInfo.SgprParts[0];
    int64_t EncodedImm = AMDGPU::getSMRDEncodedOffset(Subtarget, GEPInfo.Imm);
    if (AMDGPU::isLegalSMRDImmOffset(Subtarget, GEPInfo.Imm)) {
      Opcode = getSmrdOpcode(AMDGPU::S_LOAD_DWORD_IMM, LoadSize);

      MachineInstr *SMRD = BuildMI(*BB, &I, DL, TII.get(Opcode), DstReg)
                                 .addReg(PtrReg)
                                 .addImm(EncodedImm)
                                 .addImm(0); // glc
      return constrainSelectedInstRegOperands(*SMRD, TII, TRI, RBI);
    }

    if (Subtarget.getGeneration() == AMDGPUSubtarget::SEA_ISLANDS &&
        isUInt<32>(EncodedImm)) {
      Opcode = getSmrdOpcode(AMDGPU::S_LOAD_DWORD_IMM_ci, LoadSize);
      MachineInstr *SMRD = BuildMI(*BB, &I, DL, TII.get(Opcode), DstReg)
                                   .addReg(PtrReg)
                                   .addImm(EncodedImm)
                                   .addImm(0); // glc
      return constrainSelectedInstRegOperands(*SMRD, TII, TRI, RBI);
    }

    if (isUInt<32>(GEPInfo.Imm)) {
      Opcode = getSmrdOpcode(AMDGPU::S_LOAD_DWORD_SGPR, LoadSize);
      unsigned OffsetReg = MRI.createVirtualRegister(&AMDGPU::SReg_32RegClass);
      BuildMI(*BB, &I, DL, TII.get(AMDGPU::S_MOV_B32), OffsetReg)
              .addImm(GEPInfo.Imm);

      MachineInstr *SMRD = BuildMI(*BB, &I, DL, TII.get(Opcode), DstReg)
                                   .addReg(PtrReg)
                                   .addReg(OffsetReg)
                                   .addImm(0); // glc
      return constrainSelectedInstRegOperands(*SMRD, TII, TRI, RBI);
    }
  }

  unsigned PtrReg = I.getOperand(1).getReg();
  Opcode = getSmrdOpcode(AMDGPU::S_LOAD_DWORD_IMM, LoadSize);
  MachineInstr *SMRD = BuildMI(*BB, &I, DL, TII.get(Opcode), DstReg)
                               .addReg(PtrReg)
                               .addImm(0)
                               .addImm(0); // glc
  return constrainSelectedInstRegOperands(*SMRD, TII, TRI, RBI);
}


bool AMDGPUInstructionSelector::selectG_LOAD(MachineInstr &I) const {
  MachineBasicBlock *BB = I.getParent();
  MachineFunction *MF = BB->getParent();
  MachineRegisterInfo &MRI = MF->getRegInfo();
  DebugLoc DL = I.getDebugLoc();
  unsigned DstReg = I.getOperand(0).getReg();
  unsigned PtrReg = I.getOperand(1).getReg();
  unsigned LoadSize = RBI.getSizeInBits(DstReg, MRI, TRI);
  unsigned Opcode;

  SmallVector<GEPInfo, 4> AddrInfo;

  getAddrModeInfo(I, MRI, AddrInfo);

  if (selectSMRD(I, AddrInfo)) {
    I.eraseFromParent();
    return true;
  }

  switch (LoadSize) {
  default:
    llvm_unreachable("Load size not supported\n");
  case 32:
    Opcode = AMDGPU::FLAT_LOAD_DWORD;
    break;
  case 64:
    Opcode = AMDGPU::FLAT_LOAD_DWORDX2;
    break;
  }

  MachineInstr *Flat = BuildMI(*BB, &I, DL, TII.get(Opcode))
                               .add(I.getOperand(0))
                               .addReg(PtrReg)
                               .addImm(0)  // offset
                               .addImm(0)  // glc
                               .addImm(0); // slc

  bool Ret = constrainSelectedInstRegOperands(*Flat, TII, TRI, RBI);
  I.eraseFromParent();
  return Ret;
}

bool AMDGPUInstructionSelector::select(MachineInstr &I,
                                       CodeGenCoverage &CoverageInfo) const {

  if (!isPreISelGenericOpcode(I.getOpcode()))
    return true;

  switch (I.getOpcode()) {
  default:
    break;
  case TargetOpcode::G_OR:
    return selectImpl(I, CoverageInfo);
  case TargetOpcode::G_ADD:
    return selectG_ADD(I);
  case TargetOpcode::G_BITCAST:
    return selectCOPY(I);
  case TargetOpcode::G_CONSTANT:
    return selectG_CONSTANT(I);
  case TargetOpcode::G_GEP:
    return selectG_GEP(I);
  case TargetOpcode::G_LOAD:
    return selectG_LOAD(I);
  case TargetOpcode::G_STORE:
    return selectG_STORE(I);
  }
  return false;
}

///
/// This will select either an SGPR or VGPR operand and will save us from
/// having to write an extra tablegen pattern.
InstructionSelector::ComplexRendererFns
AMDGPUInstructionSelector::selectVSRC0(MachineOperand &Root) const {
  return {{
      [=](MachineInstrBuilder &MIB) { MIB.add(Root); }
  }};
}
