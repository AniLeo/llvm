//===-- AVRTargetMachine.cpp - Define TargetMachine for AVR ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the AVR specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#include "AVRTargetMachine.h"

#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/TargetRegistry.h"

#include "AVRTargetObjectFile.h"
#include "AVR.h"
#include "MCTargetDesc/AVRMCTargetDesc.h"

namespace llvm {

static const char *AVRDataLayout = "e-p:16:16:16-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-n8";

/// Processes a CPU name.
static StringRef getCPU(StringRef CPU) {
  if (CPU.empty() || CPU == "generic") {
    return "avr2";
  }

  return CPU;
}

static Reloc::Model getEffectiveRelocModel(Optional<Reloc::Model> RM) {
  return RM.hasValue() ? *RM : Reloc::Static;
}

AVRTargetMachine::AVRTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   Optional<Reloc::Model> RM, CodeModel::Model CM,
                                   CodeGenOpt::Level OL)
    : LLVMTargetMachine(
          T, AVRDataLayout, TT,
          getCPU(CPU), FS, Options, getEffectiveRelocModel(RM), CM, OL),
      SubTarget(TT, getCPU(CPU), FS, *this) {
  this->TLOF = make_unique<AVRTargetObjectFile>();
  initAsmInfo();
}

namespace {
/// AVR Code Generator Pass Configuration Options.
class AVRPassConfig : public TargetPassConfig {
public:
  AVRPassConfig(AVRTargetMachine *TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {}

  AVRTargetMachine &getAVRTargetMachine() const {
    return getTM<AVRTargetMachine>();
  }

  bool addInstSelector() override;
  void addPreSched2() override;
  void addPreRegAlloc() override;
};
} // namespace

TargetPassConfig *AVRTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new AVRPassConfig(this, PM);
}

extern "C" void LLVMInitializeAVRTarget() {
  // Register the target.
  RegisterTargetMachine<AVRTargetMachine> X(getTheAVRTarget());
}

const AVRSubtarget *AVRTargetMachine::getSubtargetImpl() const {
  return &SubTarget;
}

const AVRSubtarget *AVRTargetMachine::getSubtargetImpl(const Function &) const {
  return &SubTarget;
}

//===----------------------------------------------------------------------===//
// Pass Pipeline Configuration
//===----------------------------------------------------------------------===//

bool AVRPassConfig::addInstSelector() {
  // Install an instruction selector.
  addPass(createAVRISelDag(getAVRTargetMachine(), getOptLevel()));
  // Create the frame analyzer pass used by the PEI pass.
  addPass(createAVRFrameAnalyzerPass());

  return false;
}

void AVRPassConfig::addPreRegAlloc() {
  // Create the dynalloc SP save/restore pass to handle variable sized allocas.
  addPass(createAVRDynAllocaSRPass());
}

void AVRPassConfig::addPreSched2() { addPass(createAVRExpandPseudoPass()); }

} // end of namespace llvm
