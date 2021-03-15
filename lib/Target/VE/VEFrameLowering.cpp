//===-- VEFrameLowering.cpp - VE Frame Information ------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the VE implementation of TargetFrameLowering class.
//
// On VE, stack frames are structured as follows:
//
// The stack grows downward.
//
// All of the individual frame areas on the frame below are optional, i.e. it's
// possible to create a function so that the particular area isn't present
// in the frame.
//
// At function entry, the "frame" looks as follows:
//
// |                                              | Higher address
// |----------------------------------------------|
// | Parameter area for this function             |
// |----------------------------------------------|
// | Register save area (RSA) for this function   |
// |----------------------------------------------|
// | Return address for this function             |
// |----------------------------------------------|
// | Frame pointer for this function              |
// |----------------------------------------------| <- sp
// |                                              | Lower address
//
// VE doesn't use on demand stack allocation, so user code generated by LLVM
// needs to call VEOS to allocate stack frame.  VE's ABI want to reduce the
// number of VEOS calls, so ABI requires to allocate not only RSA (in general
// CSR, callee saved register) area but also call frame at the prologue of
// caller function.
//
// After the prologue has run, the frame has the following general structure.
// Note that technically the last frame area (VLAs) doesn't get created until
// in the main function body, after the prologue is run. However, it's depicted
// here for completeness.
//
// |                                              | Higher address
// |----------------------------------------------|
// | Parameter area for this function             |
// |----------------------------------------------|
// | Register save area (RSA) for this function   |
// |----------------------------------------------|
// | Return address for this function             |
// |----------------------------------------------|
// | Frame pointer for this function              |
// |----------------------------------------------| <- fp(=old sp)
// |.empty.space.to.make.part.below.aligned.in....|
// |.case.it.needs.more.than.the.standard.16-byte.| (size of this area is
// |.alignment....................................|  unknown at compile time)
// |----------------------------------------------|
// | Local variables of fixed size including spill|
// | slots                                        |
// |----------------------------------------------| <- bp(not defined by ABI,
// |.variable-sized.local.variables.(VLAs)........|       LLVM chooses SX17)
// |..............................................| (size of this area is
// |..............................................|  unknown at compile time)
// |----------------------------------------------| <- stack top (returned by
// | Parameter area for callee                    |               alloca)
// |----------------------------------------------|
// | Register save area (RSA) for callee          |
// |----------------------------------------------|
// | Return address for callee                    |
// |----------------------------------------------|
// | Frame pointer for callee                     |
// |----------------------------------------------| <- sp
// |                                              | Lower address
//
// To access the data in a frame, at-compile time, a constant offset must be
// computable from one of the pointers (fp, bp, sp) to access it. The size
// of the areas with a dotted background cannot be computed at compile-time
// if they are present, making it required to have all three of fp, bp and
// sp to be set up to be able to access all contents in the frame areas,
// assuming all of the frame areas are non-empty.
//
// For most functions, some of the frame areas are empty. For those functions,
// it may not be necessary to set up fp or bp:
// * A base pointer is definitely needed when there are both VLAs and local
//   variables with more-than-default alignment requirements.
// * A frame pointer is definitely needed when there are local variables with
//   more-than-default alignment requirements.
//
// In addition, VE ABI defines RSA frame, return address, and frame pointer
// as follows:
//
// |----------------------------------------------| <- sp+176
// | %s18...%s33                                  |
// |----------------------------------------------| <- sp+48
// | Linkage area register (%s17)                 |
// |----------------------------------------------| <- sp+40
// | Procedure linkage table register (%plt=%s16) |
// |----------------------------------------------| <- sp+32
// | Global offset table register (%got=%s15)     |
// |----------------------------------------------| <- sp+24
// | Thread pointer register (%tp=%s14)           |
// |----------------------------------------------| <- sp+16
// | Return address                               |
// |----------------------------------------------| <- sp+8
// | Frame pointer                                |
// |----------------------------------------------| <- sp+0
//
// NOTE: This description is based on VE ABI and description in
//       AArch64FrameLowering.cpp.  Thanks a lot.
//===----------------------------------------------------------------------===//

#include "VEFrameLowering.h"
#include "VEInstrInfo.h"
#include "VEMachineFunctionInfo.h"
#include "VESubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Support/MathExtras.h"

using namespace llvm;

VEFrameLowering::VEFrameLowering(const VESubtarget &ST)
    : TargetFrameLowering(TargetFrameLowering::StackGrowsDown, Align(16), 0,
                          Align(16)),
      STI(ST) {}

void VEFrameLowering::emitPrologueInsns(MachineFunction &MF,
                                        MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator MBBI,
                                        uint64_t NumBytes,
                                        bool RequireFPUpdate) const {
  const VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();
  DebugLoc DL;
  const VEInstrInfo &TII = *STI.getInstrInfo();

  // Insert following codes here as prologue
  //
  //    st %fp, 0(, %sp)   iff !isLeafProc
  //    st %lr, 8(, %sp)   iff !isLeafProc
  //    st %got, 24(, %sp) iff hasGOT
  //    st %plt, 32(, %sp) iff hasGOT
  //    st %s17, 40(, %sp) iff hasBP
  if (!FuncInfo->isLeafProc()) {
    BuildMI(MBB, MBBI, DL, TII.get(VE::STrii))
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(0)
        .addReg(VE::SX9);
    BuildMI(MBB, MBBI, DL, TII.get(VE::STrii))
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(8)
        .addReg(VE::SX10);
  }
  if (hasGOT(MF)) {
    BuildMI(MBB, MBBI, DL, TII.get(VE::STrii))
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(24)
        .addReg(VE::SX15);
    BuildMI(MBB, MBBI, DL, TII.get(VE::STrii))
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(32)
        .addReg(VE::SX16);
  }
  if (hasBP(MF))
    BuildMI(MBB, MBBI, DL, TII.get(VE::STrii))
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(40)
        .addReg(VE::SX17);
}

void VEFrameLowering::emitEpilogueInsns(MachineFunction &MF,
                                        MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator MBBI,
                                        uint64_t NumBytes,
                                        bool RequireFPUpdate) const {
  const VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();
  DebugLoc DL;
  const VEInstrInfo &TII = *STI.getInstrInfo();

  // Insert following codes here as epilogue
  //
  //    ld %s17, 40(, %sp) iff hasBP
  //    ld %plt, 32(, %sp) iff hasGOT
  //    ld %got, 24(, %sp) iff hasGOT
  //    ld %lr, 8(, %sp)   iff !isLeafProc
  //    ld %fp, 0(, %sp)   iff !isLeafProc
  if (hasBP(MF))
    BuildMI(MBB, MBBI, DL, TII.get(VE::LDrii), VE::SX17)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(40);
  if (hasGOT(MF)) {
    BuildMI(MBB, MBBI, DL, TII.get(VE::LDrii), VE::SX16)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(32);
    BuildMI(MBB, MBBI, DL, TII.get(VE::LDrii), VE::SX15)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(24);
  }
  if (!FuncInfo->isLeafProc()) {
    BuildMI(MBB, MBBI, DL, TII.get(VE::LDrii), VE::SX10)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(8);
    BuildMI(MBB, MBBI, DL, TII.get(VE::LDrii), VE::SX9)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(0);
  }
}

void VEFrameLowering::emitSPAdjustment(MachineFunction &MF,
                                       MachineBasicBlock &MBB,
                                       MachineBasicBlock::iterator MBBI,
                                       int64_t NumBytes,
                                       MaybeAlign MaybeAlign) const {
  DebugLoc DL;
  const VEInstrInfo &TII = *STI.getInstrInfo();

  if (NumBytes == 0) {
    // Nothing to do here.
  } else if (isInt<7>(NumBytes)) {
    // adds.l %s11, NumBytes@lo, %s11
    BuildMI(MBB, MBBI, DL, TII.get(VE::ADDSLri), VE::SX11)
        .addReg(VE::SX11)
        .addImm(NumBytes);
  } else if (isInt<32>(NumBytes)) {
    // lea %s11, NumBytes@lo(, %s11)
    BuildMI(MBB, MBBI, DL, TII.get(VE::LEArii), VE::SX11)
        .addReg(VE::SX11)
        .addImm(0)
        .addImm(Lo_32(NumBytes));
  } else {
    // Emit following codes.  This clobbers SX13 which we always know is
    // available here.
    //   lea     %s13, NumBytes@lo
    //   and     %s13, %s13, (32)0
    //   lea.sl  %sp, NumBytes@hi(%s13, %sp)
    BuildMI(MBB, MBBI, DL, TII.get(VE::LEAzii), VE::SX13)
        .addImm(0)
        .addImm(0)
        .addImm(Lo_32(NumBytes));
    BuildMI(MBB, MBBI, DL, TII.get(VE::ANDrm), VE::SX13)
        .addReg(VE::SX13)
        .addImm(M0(32));
    BuildMI(MBB, MBBI, DL, TII.get(VE::LEASLrri), VE::SX11)
        .addReg(VE::SX11)
        .addReg(VE::SX13)
        .addImm(Hi_32(NumBytes));
  }

  if (MaybeAlign) {
    // and %sp, %sp, Align-1
    BuildMI(MBB, MBBI, DL, TII.get(VE::ANDrm), VE::SX11)
        .addReg(VE::SX11)
        .addImm(M1(64 - Log2_64(MaybeAlign.valueOrOne().value())));
  }
}

void VEFrameLowering::emitSPExtend(MachineFunction &MF, MachineBasicBlock &MBB,
                                   MachineBasicBlock::iterator MBBI) const {
  DebugLoc DL;
  const VEInstrInfo &TII = *STI.getInstrInfo();

  // Emit following codes.  It is not possible to insert multiple
  // BasicBlocks in PEI pass, so we emit two pseudo instructions here.
  //
  //   EXTEND_STACK                     // pseudo instrcution
  //   EXTEND_STACK_GUARD               // pseudo instrcution
  //
  // EXTEND_STACK pseudo will be converted by ExpandPostRA pass into
  // following instructions with multiple basic blocks later.
  //
  // thisBB:
  //   brge.l.t %sp, %sl, sinkBB
  // syscallBB:
  //   ld      %s61, 0x18(, %tp)        // load param area
  //   or      %s62, 0, %s0             // spill the value of %s0
  //   lea     %s63, 0x13b              // syscall # of grow
  //   shm.l   %s63, 0x0(%s61)          // store syscall # at addr:0
  //   shm.l   %sl, 0x8(%s61)           // store old limit at addr:8
  //   shm.l   %sp, 0x10(%s61)          // store new limit at addr:16
  //   monc                             // call monitor
  //   or      %s0, 0, %s62             // restore the value of %s0
  // sinkBB:
  //
  // EXTEND_STACK_GUARD pseudo will be simply eliminated by ExpandPostRA
  // pass.  This pseudo is required to be at the next of EXTEND_STACK
  // pseudo in order to protect iteration loop in ExpandPostRA.
  BuildMI(MBB, MBBI, DL, TII.get(VE::EXTEND_STACK));
  BuildMI(MBB, MBBI, DL, TII.get(VE::EXTEND_STACK_GUARD));
}

void VEFrameLowering::emitPrologue(MachineFunction &MF,
                                   MachineBasicBlock &MBB) const {
  const VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();
  assert(&MF.front() == &MBB && "Shrink-wrapping not yet supported");
  MachineFrameInfo &MFI = MF.getFrameInfo();
  const VEInstrInfo &TII = *STI.getInstrInfo();
  const VERegisterInfo &RegInfo = *STI.getRegisterInfo();
  MachineBasicBlock::iterator MBBI = MBB.begin();
  bool NeedsStackRealignment = RegInfo.shouldRealignStack(MF);

  // Debug location must be unknown since the first debug location is used
  // to determine the end of the prologue.
  DebugLoc DL;

  if (NeedsStackRealignment && !RegInfo.canRealignStack(MF))
    report_fatal_error("Function \"" + Twine(MF.getName()) +
                       "\" required "
                       "stack re-alignment, but LLVM couldn't handle it "
                       "(probably because it has a dynamic alloca).");

  // Get the number of bytes to allocate from the FrameInfo.
  // This number of bytes is already aligned to ABI stack alignment.
  uint64_t NumBytes = MFI.getStackSize();

  // Adjust stack size if this function is not a leaf function since the
  // VE ABI requires a reserved area at the top of stack as described in
  // VEFrameLowering.cpp.
  if (!FuncInfo->isLeafProc()) {
    // NOTE: The number is aligned to ABI stack alignment after adjustment.
    NumBytes = STI.getAdjustedFrameSize(NumBytes);
  }

  // Finally, ensure that the size is sufficiently aligned for the
  // data on the stack.
  NumBytes = alignTo(NumBytes, MFI.getMaxAlign());

  // Update stack size with corrected value.
  MFI.setStackSize(NumBytes);

  // Emit Prologue instructions to save multiple registers.
  emitPrologueInsns(MF, MBB, MBBI, NumBytes, true);

  // Emit instructions to save SP in FP as follows if this is not a leaf
  // function:
  //    or %fp, 0, %sp
  if (!FuncInfo->isLeafProc())
    BuildMI(MBB, MBBI, DL, TII.get(VE::ORri), VE::SX9)
        .addReg(VE::SX11)
        .addImm(0);

  // Emit stack adjust instructions
  MaybeAlign RuntimeAlign =
      NeedsStackRealignment ? MaybeAlign(MFI.getMaxAlign()) : None;
  assert((RuntimeAlign == None || !FuncInfo->isLeafProc()) &&
         "SP has to be saved in order to align variable sized stack object!");
  emitSPAdjustment(MF, MBB, MBBI, -(int64_t)NumBytes, RuntimeAlign);

  if (hasBP(MF)) {
    // Copy SP to BP.
    BuildMI(MBB, MBBI, DL, TII.get(VE::ORri), VE::SX17)
        .addReg(VE::SX11)
        .addImm(0);
  }

  // Emit stack extend instructions
  if (NumBytes != 0)
    emitSPExtend(MF, MBB, MBBI);
}

MachineBasicBlock::iterator VEFrameLowering::eliminateCallFramePseudoInstr(
    MachineFunction &MF, MachineBasicBlock &MBB,
    MachineBasicBlock::iterator I) const {
  if (!hasReservedCallFrame(MF)) {
    MachineInstr &MI = *I;
    int64_t Size = MI.getOperand(0).getImm();
    if (MI.getOpcode() == VE::ADJCALLSTACKDOWN)
      Size = -Size;

    if (Size)
      emitSPAdjustment(MF, MBB, I, Size);
  }
  return MBB.erase(I);
}

void VEFrameLowering::emitEpilogue(MachineFunction &MF,
                                   MachineBasicBlock &MBB) const {
  const VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();
  DebugLoc DL;
  MachineBasicBlock::iterator MBBI = MBB.getLastNonDebugInstr();
  MachineFrameInfo &MFI = MF.getFrameInfo();
  const VEInstrInfo &TII = *STI.getInstrInfo();

  uint64_t NumBytes = MFI.getStackSize();

  // Emit instructions to retrieve original SP.
  if (!FuncInfo->isLeafProc()) {
    // If SP is saved in FP, retrieve it as follows:
    //    or %sp, 0, %fp     iff !isLeafProc
    BuildMI(MBB, MBBI, DL, TII.get(VE::ORri), VE::SX11)
        .addReg(VE::SX9)
        .addImm(0);
  } else {
    // Emit stack adjust instructions.
    emitSPAdjustment(MF, MBB, MBBI, NumBytes, None);
  }

  // Emit Epilogue instructions to restore multiple registers.
  emitEpilogueInsns(MF, MBB, MBBI, NumBytes, true);
}

// hasFP - Return true if the specified function should have a dedicated frame
// pointer register.  This is true if the function has variable sized allocas
// or if frame pointer elimination is disabled.
bool VEFrameLowering::hasFP(const MachineFunction &MF) const {
  const TargetRegisterInfo *RegInfo = MF.getSubtarget().getRegisterInfo();

  const MachineFrameInfo &MFI = MF.getFrameInfo();
  return MF.getTarget().Options.DisableFramePointerElim(MF) ||
         RegInfo->hasStackRealignment(MF) || MFI.hasVarSizedObjects() ||
         MFI.isFrameAddressTaken();
}

bool VEFrameLowering::hasBP(const MachineFunction &MF) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const TargetRegisterInfo *TRI = STI.getRegisterInfo();

  return MFI.hasVarSizedObjects() && TRI->hasStackRealignment(MF);
}

bool VEFrameLowering::hasGOT(const MachineFunction &MF) const {
  const VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();

  // If a global base register is assigned (!= 0), GOT is used.
  return FuncInfo->getGlobalBaseReg() != 0;
}

StackOffset VEFrameLowering::getFrameIndexReference(const MachineFunction &MF,
                                                    int FI,
                                                    Register &FrameReg) const {
  const MachineFrameInfo &MFI = MF.getFrameInfo();
  const VERegisterInfo *RegInfo = STI.getRegisterInfo();
  bool isFixed = MFI.isFixedObjectIndex(FI);

  int64_t FrameOffset = MF.getFrameInfo().getObjectOffset(FI);

  if (!hasFP(MF)) {
    // If FP is not used, frame indexies are based on a %sp regiter.
    FrameReg = VE::SX11; // %sp
    return StackOffset::getFixed(FrameOffset +
                                 MF.getFrameInfo().getStackSize());
  }
  if (RegInfo->hasStackRealignment(MF) && !isFixed) {
    // If data on stack require realignemnt, frame indexies are based on a %sp
    // or %s17 (bp) register.  If there is a variable sized object, bp is used.
    if (hasBP(MF))
      FrameReg = VE::SX17; // %bp
    else
      FrameReg = VE::SX11; // %sp
    return StackOffset::getFixed(FrameOffset +
                                 MF.getFrameInfo().getStackSize());
  }
  // Use %fp by default.
  FrameReg = RegInfo->getFrameRegister(MF);
  return StackOffset::getFixed(FrameOffset);
}

bool VEFrameLowering::isLeafProc(MachineFunction &MF) const {

  MachineRegisterInfo &MRI = MF.getRegInfo();
  MachineFrameInfo &MFI = MF.getFrameInfo();

  return !MFI.hasCalls()                 // No calls
         && !MRI.isPhysRegUsed(VE::SX18) // Registers within limits
                                         //   (s18 is first CSR)
         && !MRI.isPhysRegUsed(VE::SX11) // %sp un-used
         && !hasFP(MF);                  // Don't need %fp
}

void VEFrameLowering::determineCalleeSaves(MachineFunction &MF,
                                           BitVector &SavedRegs,
                                           RegScavenger *RS) const {
  TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);

  // Functions having BP need to emit prologue and epilogue to allocate local
  // buffer on the stack even if the function is a leaf function.
  if (isLeafProc(MF) && !hasBP(MF)) {
    VEMachineFunctionInfo *FuncInfo = MF.getInfo<VEMachineFunctionInfo>();
    FuncInfo->setLeafProc(true);
  }
}
