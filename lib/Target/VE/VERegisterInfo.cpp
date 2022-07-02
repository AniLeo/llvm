//===-- VERegisterInfo.cpp - VE Register Information ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the VE implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "VERegisterInfo.h"
#include "VE.h"
#include "VESubtarget.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

#define GET_REGINFO_TARGET_DESC
#include "VEGenRegisterInfo.inc"

// VE uses %s10 == %lp to keep return address
VERegisterInfo::VERegisterInfo() : VEGenRegisterInfo(VE::SX10) {}

const MCPhysReg *
VERegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
  switch (MF->getFunction().getCallingConv()) {
  case CallingConv::Fast:
    // Being explicit (same as standard CC).
  default:
    return CSR_SaveList;
  case CallingConv::PreserveAll:
    return CSR_preserve_all_SaveList;
  }
}

const uint32_t *VERegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                                     CallingConv::ID CC) const {
  switch (CC) {
  case CallingConv::Fast:
    // Being explicit (same as standard CC).
  default:
    return CSR_RegMask;
  case CallingConv::PreserveAll:
    return CSR_preserve_all_RegMask;
  }
}

const uint32_t *VERegisterInfo::getNoPreservedMask() const {
  return CSR_NoRegs_RegMask;
}

BitVector VERegisterInfo::getReservedRegs(const MachineFunction &MF) const {
  BitVector Reserved(getNumRegs());

  const Register ReservedRegs[] = {
      VE::SX8,  // Stack limit
      VE::SX9,  // Frame pointer
      VE::SX10, // Link register (return address)
      VE::SX11, // Stack pointer

      // FIXME: maybe not need to be reserved
      VE::SX12, // Outer register
      VE::SX13, // Id register for dynamic linker

      VE::SX14, // Thread pointer
      VE::SX15, // Global offset table register
      VE::SX16, // Procedure linkage table register
      VE::SX17, // Linkage-area register
                // sx18-sx33 are callee-saved registers
                // sx34-sx63 are temporary registers
  };

  for (auto R : ReservedRegs)
    for (MCRegAliasIterator ItAlias(R, this, true); ItAlias.isValid();
         ++ItAlias)
      Reserved.set(*ItAlias);

  // Reserve constant registers.
  Reserved.set(VE::VM0);
  Reserved.set(VE::VMP0);

  return Reserved;
}

bool VERegisterInfo::isConstantPhysReg(MCRegister PhysReg) const {
  switch (PhysReg) {
  case VE::VM0:
  case VE::VMP0:
    return true;
  default:
    return false;
  }
}

const TargetRegisterClass *
VERegisterInfo::getPointerRegClass(const MachineFunction &MF,
                                   unsigned Kind) const {
  return &VE::I64RegClass;
}

static unsigned offsetToDisp(MachineInstr &MI) {
  // Default offset in instruction's operands (reg+reg+imm).
  unsigned OffDisp = 2;

#define RRCAS_multi_cases(NAME) NAME##rir : case NAME##rii

  {
    using namespace llvm::VE;
    switch (MI.getOpcode()) {
    case RRCAS_multi_cases(TS1AML):
    case RRCAS_multi_cases(TS1AMW):
    case RRCAS_multi_cases(CASL):
    case RRCAS_multi_cases(CASW):
      // These instructions use AS format (reg+imm).
      OffDisp = 1;
      break;
    }
  }
#undef RRCAS_multi_cases

  return OffDisp;
}

class EliminateFrameIndex {
  const TargetInstrInfo &TII;
  const TargetRegisterInfo &TRI;
  const DebugLoc &DL;
  MachineBasicBlock &MBB;
  MachineBasicBlock::iterator II;
  Register clobber;

  // Some helper functions for the ease of instruction building.
  MachineFunction &getFunc() const { return *MBB.getParent(); }
  inline MCRegister getSubReg(MCRegister Reg, unsigned Idx) const {
    return TRI.getSubReg(Reg, Idx);
  }
  inline const MCInstrDesc &get(unsigned Opcode) const {
    return TII.get(Opcode);
  }
  inline MachineInstrBuilder build(const MCInstrDesc &MCID, Register DestReg) {
    return BuildMI(MBB, II, DL, MCID, DestReg);
  }
  inline MachineInstrBuilder build(unsigned InstOpc, Register DestReg) {
    return build(get(InstOpc), DestReg);
  }
  inline MachineInstrBuilder build(const MCInstrDesc &MCID) {
    return BuildMI(MBB, II, DL, MCID);
  }
  inline MachineInstrBuilder build(unsigned InstOpc) {
    return build(get(InstOpc));
  }

  // Calculate an address of frame index from a frame register and a given
  // offset if the offset doesn't fit in the immediate field.  Use a clobber
  // register to hold calculated address.
  void prepareReplaceFI(MachineInstr &MI, Register &FrameReg, int64_t &Offset,
                        int64_t Bytes = 0);
  // Replace the frame index in \p MI with a frame register and a given offset
  // if it fits in the immediate field.  Otherwise, use pre-calculated address
  // in a clobber regsiter.
  void replaceFI(MachineInstr &MI, Register FrameReg, int64_t Offset,
                 int FIOperandNum);

  // Expand and eliminate Frame Index of pseudo STQrii and LDQrii.
  void processSTQ(MachineInstr &MI, Register FrameReg, int64_t Offset,
                  int FIOperandNum);
  void processLDQ(MachineInstr &MI, Register FrameReg, int64_t Offset,
                  int FIOperandNum);

public:
  EliminateFrameIndex(const TargetInstrInfo &TII, const TargetRegisterInfo &TRI,
                      const DebugLoc &DL, MachineBasicBlock &MBB,
                      MachineBasicBlock::iterator II)
      : TII(TII), TRI(TRI), DL(DL), MBB(MBB), II(II), clobber(VE::SX13) {}

  // Expand and eliminate Frame Index from MI
  void processMI(MachineInstr &MI, Register FrameReg, int64_t Offset,
                 int FIOperandNum);
};

// Prepare the frame index if it doesn't fit in the immediate field.  Use
// clobber register to hold calculated address.
void EliminateFrameIndex::prepareReplaceFI(MachineInstr &MI, Register &FrameReg,
                                           int64_t &Offset, int64_t Bytes) {
  if (isInt<32>(Offset) && isInt<32>(Offset + Bytes)) {
    // If the offset is small enough to fit in the immediate field, directly
    // encode it.  So, nothing to prepare here.
    return;
  }

  // If the offset doesn't fit, emit following codes.  This clobbers SX13
  // which we always know is available here.
  //   lea     %clobber, Offset@lo
  //   and     %clobber, %clobber, (32)0
  //   lea.sl  %clobber, Offset@hi(FrameReg, %clobber)
  build(VE::LEAzii, clobber).addImm(0).addImm(0).addImm(Lo_32(Offset));
  build(VE::ANDrm, clobber).addReg(clobber).addImm(M0(32));
  build(VE::LEASLrri, clobber)
      .addReg(clobber)
      .addReg(FrameReg)
      .addImm(Hi_32(Offset));

  // Use clobber register as a frame register and 0 offset
  FrameReg = clobber;
  Offset = 0;
}

// Replace the frame index in \p MI with a proper byte and framereg offset.
void EliminateFrameIndex::replaceFI(MachineInstr &MI, Register FrameReg,
                                    int64_t Offset, int FIOperandNum) {
  assert(isInt<32>(Offset));

  // The offset must be small enough to fit in the immediate field after
  // call of prepareReplaceFI.  Therefore, we directly encode it.
  MI.getOperand(FIOperandNum).ChangeToRegister(FrameReg, false);
  MI.getOperand(FIOperandNum + offsetToDisp(MI)).ChangeToImmediate(Offset);
}

void EliminateFrameIndex::processSTQ(MachineInstr &MI, Register FrameReg,
                                     int64_t Offset, int FIOperandNum) {
  assert(MI.getOpcode() == VE::STQrii);
  LLVM_DEBUG(dbgs() << "processSTQ: "; MI.dump());

  prepareReplaceFI(MI, FrameReg, Offset, 8);

  Register SrcReg = MI.getOperand(3).getReg();
  Register SrcHiReg = getSubReg(SrcReg, VE::sub_even);
  Register SrcLoReg = getSubReg(SrcReg, VE::sub_odd);
  // VE stores HiReg to 8(addr) and LoReg to 0(addr)
  MachineInstr *StMI =
      build(VE::STrii).addReg(FrameReg).addImm(0).addImm(0).addReg(SrcLoReg);
  replaceFI(*StMI, FrameReg, Offset, 0);
  // Mutate to 'hi' store.
  MI.setDesc(get(VE::STrii));
  MI.getOperand(3).setReg(SrcHiReg);
  Offset += 8;
  replaceFI(MI, FrameReg, Offset, FIOperandNum);
}

void EliminateFrameIndex::processLDQ(MachineInstr &MI, Register FrameReg,
                                     int64_t Offset, int FIOperandNum) {
  assert(MI.getOpcode() == VE::LDQrii);
  LLVM_DEBUG(dbgs() << "processLDQ: "; MI.dump());

  prepareReplaceFI(MI, FrameReg, Offset, 8);

  Register DestReg = MI.getOperand(0).getReg();
  Register DestHiReg = getSubReg(DestReg, VE::sub_even);
  Register DestLoReg = getSubReg(DestReg, VE::sub_odd);
  // VE loads HiReg from 8(addr) and LoReg from 0(addr)
  MachineInstr *StMI =
      build(VE::LDrii, DestLoReg).addReg(FrameReg).addImm(0).addImm(0);
  replaceFI(*StMI, FrameReg, Offset, 1);
  MI.setDesc(get(VE::LDrii));
  MI.getOperand(0).setReg(DestHiReg);
  Offset += 8;
  replaceFI(MI, FrameReg, Offset, FIOperandNum);
}

void EliminateFrameIndex::processMI(MachineInstr &MI, Register FrameReg,
                                    int64_t Offset, int FIOperandNum) {
  switch (MI.getOpcode()) {
  case VE::STQrii:
    processSTQ(MI, FrameReg, Offset, FIOperandNum);
    return;
  case VE::LDQrii:
    processLDQ(MI, FrameReg, Offset, FIOperandNum);
    return;
  }
  prepareReplaceFI(MI, FrameReg, Offset);
  replaceFI(MI, FrameReg, Offset, FIOperandNum);
}

void VERegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                         int SPAdj, unsigned FIOperandNum,
                                         RegScavenger *RS) const {
  assert(SPAdj == 0 && "Unexpected");

  MachineInstr &MI = *II;
  int FrameIndex = MI.getOperand(FIOperandNum).getIndex();

  MachineFunction &MF = *MI.getParent()->getParent();
  const VESubtarget &Subtarget = MF.getSubtarget<VESubtarget>();
  const VEFrameLowering &TFI = *getFrameLowering(MF);
  const TargetInstrInfo &TII = *Subtarget.getInstrInfo();
  const VERegisterInfo &TRI = *Subtarget.getRegisterInfo();
  DebugLoc DL = MI.getDebugLoc();
  EliminateFrameIndex EFI(TII, TRI, DL, *MI.getParent(), II);

  // Retrieve FrameReg and byte offset for stack slot.
  Register FrameReg;
  int64_t Offset =
      TFI.getFrameIndexReference(MF, FrameIndex, FrameReg).getFixed();
  Offset += MI.getOperand(FIOperandNum + offsetToDisp(MI)).getImm();

  EFI.processMI(MI, FrameReg, Offset, FIOperandNum);
}

Register VERegisterInfo::getFrameRegister(const MachineFunction &MF) const {
  return VE::SX9;
}
