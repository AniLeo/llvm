//===-- PPCTargetMachine.cpp - Define TargetMachine for PowerPC -----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Top-level implementation for the PowerPC target.
//
//===----------------------------------------------------------------------===//

#include "PPCTargetMachine.h"
#include "MCTargetDesc/PPCMCTargetDesc.h"
#include "PPC.h"
#include "PPCMachineScheduler.h"
#include "PPCSubtarget.h"
#include "PPCTargetObjectFile.h"
#include "PPCTargetTransformInfo.h"
#include "TargetInfo/PowerPCTargetInfo.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/CodeGen/MachineScheduler.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Pass.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Transforms/Scalar.h"
#include <cassert>
#include <memory>
#include <string>

using namespace llvm;


static cl::opt<bool>
    EnableBranchCoalescing("enable-ppc-branch-coalesce", cl::Hidden,
                           cl::desc("enable coalescing of duplicate branches for PPC"));
static cl::
opt<bool> DisableCTRLoops("disable-ppc-ctrloops", cl::Hidden,
                        cl::desc("Disable CTR loops for PPC"));

static cl::
opt<bool> DisableInstrFormPrep("disable-ppc-instr-form-prep", cl::Hidden,
                            cl::desc("Disable PPC loop instr form prep"));

static cl::opt<bool>
VSXFMAMutateEarly("schedule-ppc-vsx-fma-mutation-early",
  cl::Hidden, cl::desc("Schedule VSX FMA instruction mutation early"));

static cl::
opt<bool> DisableVSXSwapRemoval("disable-ppc-vsx-swap-removal", cl::Hidden,
                                cl::desc("Disable VSX Swap Removal for PPC"));

static cl::
opt<bool> DisableQPXLoadSplat("disable-ppc-qpx-load-splat", cl::Hidden,
                              cl::desc("Disable QPX load splat simplification"));

static cl::
opt<bool> DisableMIPeephole("disable-ppc-peephole", cl::Hidden,
                            cl::desc("Disable machine peepholes for PPC"));

static cl::opt<bool>
EnableGEPOpt("ppc-gep-opt", cl::Hidden,
             cl::desc("Enable optimizations on complex GEPs"),
             cl::init(true));

static cl::opt<bool>
EnablePrefetch("enable-ppc-prefetching",
                  cl::desc("enable software prefetching on PPC"),
                  cl::init(false), cl::Hidden);

static cl::opt<bool>
EnableExtraTOCRegDeps("enable-ppc-extra-toc-reg-deps",
                      cl::desc("Add extra TOC register dependencies"),
                      cl::init(true), cl::Hidden);

static cl::opt<bool>
EnableMachineCombinerPass("ppc-machine-combiner",
                          cl::desc("Enable the machine combiner pass"),
                          cl::init(true), cl::Hidden);

static cl::opt<bool>
  ReduceCRLogical("ppc-reduce-cr-logicals",
                  cl::desc("Expand eligible cr-logical binary ops to branches"),
                  cl::init(true), cl::Hidden);
extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializePowerPCTarget() {
  // Register the targets
  RegisterTargetMachine<PPCTargetMachine> A(getThePPC32Target());
  RegisterTargetMachine<PPCTargetMachine> B(getThePPC64Target());
  RegisterTargetMachine<PPCTargetMachine> C(getThePPC64LETarget());

  PassRegistry &PR = *PassRegistry::getPassRegistry();
#ifndef NDEBUG
  initializePPCCTRLoopsVerifyPass(PR);
#endif
  initializePPCLoopInstrFormPrepPass(PR);
  initializePPCTOCRegDepsPass(PR);
  initializePPCEarlyReturnPass(PR);
  initializePPCVSXCopyPass(PR);
  initializePPCVSXFMAMutatePass(PR);
  initializePPCVSXSwapRemovalPass(PR);
  initializePPCReduceCRLogicalsPass(PR);
  initializePPCBSelPass(PR);
  initializePPCBranchCoalescingPass(PR);
  initializePPCQPXLoadSplatPass(PR);
  initializePPCBoolRetToIntPass(PR);
  initializePPCExpandISELPass(PR);
  initializePPCPreEmitPeepholePass(PR);
  initializePPCTLSDynamicCallPass(PR);
  initializePPCMIPeepholePass(PR);
  initializePPCLowerMASSVEntriesPass(PR);
}

/// Return the datalayout string of a subtarget.
static std::string getDataLayoutString(const Triple &T) {
  bool is64Bit = T.getArch() == Triple::ppc64 || T.getArch() == Triple::ppc64le;
  std::string Ret;

  // Most PPC* platforms are big endian, PPC64LE is little endian.
  if (T.getArch() == Triple::ppc64le)
    Ret = "e";
  else
    Ret = "E";

  Ret += DataLayout::getManglingComponent(T);

  // PPC32 has 32 bit pointers. The PS3 (OS Lv2) is a PPC64 machine with 32 bit
  // pointers.
  if (!is64Bit || T.getOS() == Triple::Lv2)
    Ret += "-p:32:32";

  // Note, the alignment values for f64 and i64 on ppc64 in Darwin
  // documentation are wrong; these are correct (i.e. "what gcc does").
  if (is64Bit || !T.isOSDarwin())
    Ret += "-i64:64";
  else
    Ret += "-f64:32:64";

  // PPC64 has 32 and 64 bit registers, PPC32 has only 32 bit ones.
  if (is64Bit)
    Ret += "-n32:64";
  else
    Ret += "-n32";

  return Ret;
}

static std::string computeFSAdditions(StringRef FS, CodeGenOpt::Level OL,
                                      const Triple &TT) {
  std::string FullFS = std::string(FS);

  // Make sure 64-bit features are available when CPUname is generic
  if (TT.getArch() == Triple::ppc64 || TT.getArch() == Triple::ppc64le) {
    if (!FullFS.empty())
      FullFS = "+64bit," + FullFS;
    else
      FullFS = "+64bit";
  }

  if (OL >= CodeGenOpt::Default) {
    if (!FullFS.empty())
      FullFS = "+crbits," + FullFS;
    else
      FullFS = "+crbits";
  }

  if (OL != CodeGenOpt::None) {
    if (!FullFS.empty())
      FullFS = "+invariant-function-descriptors," + FullFS;
    else
      FullFS = "+invariant-function-descriptors";
  }

  return FullFS;
}

static std::unique_ptr<TargetLoweringObjectFile> createTLOF(const Triple &TT) {
  if (TT.isOSDarwin())
    return std::make_unique<TargetLoweringObjectFileMachO>();

  if (TT.isOSAIX())
    return std::make_unique<TargetLoweringObjectFileXCOFF>();

  return std::make_unique<PPC64LinuxTargetObjectFile>();
}

static PPCTargetMachine::PPCABI computeTargetABI(const Triple &TT,
                                                 const TargetOptions &Options) {
  if (TT.isOSDarwin())
    report_fatal_error("Darwin is no longer supported for PowerPC");
  
  if (Options.MCOptions.getABIName().startswith("elfv1"))
    return PPCTargetMachine::PPC_ABI_ELFv1;
  else if (Options.MCOptions.getABIName().startswith("elfv2"))
    return PPCTargetMachine::PPC_ABI_ELFv2;

  assert(Options.MCOptions.getABIName().empty() &&
         "Unknown target-abi option!");

  if (TT.isMacOSX())
    return PPCTargetMachine::PPC_ABI_UNKNOWN;

  switch (TT.getArch()) {
  case Triple::ppc64le:
    return PPCTargetMachine::PPC_ABI_ELFv2;
  case Triple::ppc64:
    return PPCTargetMachine::PPC_ABI_ELFv1;
  default:
    return PPCTargetMachine::PPC_ABI_UNKNOWN;
  }
}

static Reloc::Model getEffectiveRelocModel(const Triple &TT,
                                           Optional<Reloc::Model> RM) {
  assert((!TT.isOSAIX() || !RM.hasValue() || *RM == Reloc::PIC_) &&
         "Invalid relocation model for AIX.");

  if (RM.hasValue())
    return *RM;

  // Darwin defaults to dynamic-no-pic.
  if (TT.isOSDarwin())
    return Reloc::DynamicNoPIC;

  // Big Endian PPC and AIX default to PIC.
  if (TT.getArch() == Triple::ppc64 || TT.isOSAIX())
    return Reloc::PIC_;

  // Rest are static by default.
  return Reloc::Static;
}

static CodeModel::Model getEffectivePPCCodeModel(const Triple &TT,
                                                 Optional<CodeModel::Model> CM,
                                                 bool JIT) {
  if (CM) {
    if (*CM == CodeModel::Tiny)
      report_fatal_error("Target does not support the tiny CodeModel", false);
    if (*CM == CodeModel::Kernel)
      report_fatal_error("Target does not support the kernel CodeModel", false);
    return *CM;
  }

  if (JIT)
    return CodeModel::Small;
  if (TT.isOSAIX())
    return CodeModel::Small;

  assert(TT.isOSBinFormatELF() && "All remaining PPC OSes are ELF based.");

  if (TT.isArch32Bit())
    return CodeModel::Small;

  assert(TT.isArch64Bit() && "Unsupported PPC architecture.");
  return CodeModel::Medium;
}


static ScheduleDAGInstrs *createPPCMachineScheduler(MachineSchedContext *C) {
  const PPCSubtarget &ST = C->MF->getSubtarget<PPCSubtarget>();
  ScheduleDAGMILive *DAG =
    new ScheduleDAGMILive(C, ST.usePPCPreRASchedStrategy() ?
                          std::make_unique<PPCPreRASchedStrategy>(C) :
                          std::make_unique<GenericScheduler>(C));
  // add DAG Mutations here.
  DAG->addMutation(createCopyConstrainDAGMutation(DAG->TII, DAG->TRI));
  return DAG;
}

static ScheduleDAGInstrs *createPPCPostMachineScheduler(
  MachineSchedContext *C) {
  const PPCSubtarget &ST = C->MF->getSubtarget<PPCSubtarget>();
  ScheduleDAGMI *DAG =
    new ScheduleDAGMI(C, ST.usePPCPostRASchedStrategy() ?
                      std::make_unique<PPCPostRASchedStrategy>(C) :
                      std::make_unique<PostGenericScheduler>(C), true);
  // add DAG Mutations here.
  return DAG;
}

// The FeatureString here is a little subtle. We are modifying the feature
// string with what are (currently) non-function specific overrides as it goes
// into the LLVMTargetMachine constructor and then using the stored value in the
// Subtarget constructor below it.
PPCTargetMachine::PPCTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   Optional<Reloc::Model> RM,
                                   Optional<CodeModel::Model> CM,
                                   CodeGenOpt::Level OL, bool JIT)
    : LLVMTargetMachine(T, getDataLayoutString(TT), TT, CPU,
                        computeFSAdditions(FS, OL, TT), Options,
                        getEffectiveRelocModel(TT, RM),
                        getEffectivePPCCodeModel(TT, CM, JIT), OL),
      TLOF(createTLOF(getTargetTriple())),
      TargetABI(computeTargetABI(TT, Options)) {
  initAsmInfo();
}

PPCTargetMachine::~PPCTargetMachine() = default;

const PPCSubtarget *
PPCTargetMachine::getSubtargetImpl(const Function &F) const {
  Attribute CPUAttr = F.getFnAttribute("target-cpu");
  Attribute FSAttr = F.getFnAttribute("target-features");

  std::string CPU = !CPUAttr.hasAttribute(Attribute::None)
                        ? CPUAttr.getValueAsString().str()
                        : TargetCPU;
  std::string FS = !FSAttr.hasAttribute(Attribute::None)
                       ? FSAttr.getValueAsString().str()
                       : TargetFS;

  // FIXME: This is related to the code below to reset the target options,
  // we need to know whether or not the soft float flag is set on the
  // function before we can generate a subtarget. We also need to use
  // it as a key for the subtarget since that can be the only difference
  // between two functions.
  bool SoftFloat =
      F.getFnAttribute("use-soft-float").getValueAsString() == "true";
  // If the soft float attribute is set on the function turn on the soft float
  // subtarget feature.
  if (SoftFloat)
    FS += FS.empty() ? "-hard-float" : ",-hard-float";

  auto &I = SubtargetMap[CPU + FS];
  if (!I) {
    // This needs to be done before we create a new subtarget since any
    // creation will depend on the TM and the code generation flags on the
    // function that reside in TargetOptions.
    resetTargetOptions(F);
    I = std::make_unique<PPCSubtarget>(
        TargetTriple, CPU,
        // FIXME: It would be good to have the subtarget additions here
        // not necessary. Anything that turns them on/off (overrides) ends
        // up being put at the end of the feature string, but the defaults
        // shouldn't require adding them. Fixing this means pulling Feature64Bit
        // out of most of the target cpus in the .td file and making it set only
        // as part of initialization via the TargetTriple.
        computeFSAdditions(FS, getOptLevel(), getTargetTriple()), *this);
  }
  return I.get();
}

//===----------------------------------------------------------------------===//
// Pass Pipeline Configuration
//===----------------------------------------------------------------------===//

namespace {

/// PPC Code Generator Pass Configuration Options.
class PPCPassConfig : public TargetPassConfig {
public:
  PPCPassConfig(PPCTargetMachine &TM, PassManagerBase &PM)
    : TargetPassConfig(TM, PM) {
    // At any optimization level above -O0 we use the Machine Scheduler and not
    // the default Post RA List Scheduler.
    if (TM.getOptLevel() != CodeGenOpt::None)
      substitutePass(&PostRASchedulerID, &PostMachineSchedulerID);
  }

  PPCTargetMachine &getPPCTargetMachine() const {
    return getTM<PPCTargetMachine>();
  }

  void addIRPasses() override;
  bool addPreISel() override;
  bool addILPOpts() override;
  bool addInstSelector() override;
  void addMachineSSAOptimization() override;
  void addPreRegAlloc() override;
  void addPreSched2() override;
  void addPreEmitPass() override;
  ScheduleDAGInstrs *
  createMachineScheduler(MachineSchedContext *C) const override {
    return createPPCMachineScheduler(C);
  }
  ScheduleDAGInstrs *
  createPostMachineScheduler(MachineSchedContext *C) const override {
    return createPPCPostMachineScheduler(C);
  }
};

} // end anonymous namespace

TargetPassConfig *PPCTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new PPCPassConfig(*this, PM);
}

void PPCPassConfig::addIRPasses() {
  if (TM->getOptLevel() != CodeGenOpt::None)
    addPass(createPPCBoolRetToIntPass());
  addPass(createAtomicExpandPass());

  // Lower generic MASSV routines to PowerPC subtarget-specific entries.
  addPass(createPPCLowerMASSVEntriesPass());
  
  // For the BG/Q (or if explicitly requested), add explicit data prefetch
  // intrinsics.
  bool UsePrefetching = TM->getTargetTriple().getVendor() == Triple::BGQ &&
                        getOptLevel() != CodeGenOpt::None;
  if (EnablePrefetch.getNumOccurrences() > 0)
    UsePrefetching = EnablePrefetch;
  if (UsePrefetching)
    addPass(createLoopDataPrefetchPass());

  if (TM->getOptLevel() >= CodeGenOpt::Default && EnableGEPOpt) {
    // Call SeparateConstOffsetFromGEP pass to extract constants within indices
    // and lower a GEP with multiple indices to either arithmetic operations or
    // multiple GEPs with single index.
    addPass(createSeparateConstOffsetFromGEPPass(true));
    // Call EarlyCSE pass to find and remove subexpressions in the lowered
    // result.
    addPass(createEarlyCSEPass());
    // Do loop invariant code motion in case part of the lowered result is
    // invariant.
    addPass(createLICMPass());
  }

  TargetPassConfig::addIRPasses();
}

bool PPCPassConfig::addPreISel() {
  if (!DisableInstrFormPrep && getOptLevel() != CodeGenOpt::None)
    addPass(createPPCLoopInstrFormPrepPass(getPPCTargetMachine()));

  if (!DisableCTRLoops && getOptLevel() != CodeGenOpt::None)
    addPass(createHardwareLoopsPass());

  return false;
}

bool PPCPassConfig::addILPOpts() {
  addPass(&EarlyIfConverterID);

  if (EnableMachineCombinerPass)
    addPass(&MachineCombinerID);

  return true;
}

bool PPCPassConfig::addInstSelector() {
  // Install an instruction selector.
  addPass(createPPCISelDag(getPPCTargetMachine(), getOptLevel()));

#ifndef NDEBUG
  if (!DisableCTRLoops && getOptLevel() != CodeGenOpt::None)
    addPass(createPPCCTRLoopsVerify());
#endif

  addPass(createPPCVSXCopyPass());
  return false;
}

void PPCPassConfig::addMachineSSAOptimization() {
  // PPCBranchCoalescingPass need to be done before machine sinking
  // since it merges empty blocks.
  if (EnableBranchCoalescing && getOptLevel() != CodeGenOpt::None)
    addPass(createPPCBranchCoalescingPass());
  TargetPassConfig::addMachineSSAOptimization();
  // For little endian, remove where possible the vector swap instructions
  // introduced at code generation to normalize vector element order.
  if (TM->getTargetTriple().getArch() == Triple::ppc64le &&
      !DisableVSXSwapRemoval)
    addPass(createPPCVSXSwapRemovalPass());
  // Reduce the number of cr-logical ops.
  if (ReduceCRLogical && getOptLevel() != CodeGenOpt::None)
    addPass(createPPCReduceCRLogicalsPass());
  // Target-specific peephole cleanups performed after instruction
  // selection.
  if (!DisableMIPeephole) {
    addPass(createPPCMIPeepholePass());
    addPass(&DeadMachineInstructionElimID);
  }
}

void PPCPassConfig::addPreRegAlloc() {
  if (getOptLevel() != CodeGenOpt::None) {
    initializePPCVSXFMAMutatePass(*PassRegistry::getPassRegistry());
    insertPass(VSXFMAMutateEarly ? &RegisterCoalescerID : &MachineSchedulerID,
               &PPCVSXFMAMutateID);
  }

  // FIXME: We probably don't need to run these for -fPIE.
  if (getPPCTargetMachine().isPositionIndependent()) {
    // FIXME: LiveVariables should not be necessary here!
    // PPCTLSDynamicCallPass uses LiveIntervals which previously dependent on
    // LiveVariables. This (unnecessary) dependency has been removed now,
    // however a stage-2 clang build fails without LiveVariables computed here.
    addPass(&LiveVariablesID, false);
    addPass(createPPCTLSDynamicCallPass());
  }
  if (EnableExtraTOCRegDeps)
    addPass(createPPCTOCRegDepsPass());

  if (getOptLevel() != CodeGenOpt::None)
    addPass(&MachinePipelinerID);
}

void PPCPassConfig::addPreSched2() {
  if (getOptLevel() != CodeGenOpt::None) {
    addPass(&IfConverterID);

    // This optimization must happen after anything that might do store-to-load
    // forwarding. Here we're after RA (and, thus, when spills are inserted)
    // but before post-RA scheduling.
    if (!DisableQPXLoadSplat)
      addPass(createPPCQPXLoadSplatPass());
  }
}

void PPCPassConfig::addPreEmitPass() {
  addPass(createPPCPreEmitPeepholePass());
  addPass(createPPCExpandISELPass());

  if (getOptLevel() != CodeGenOpt::None)
    addPass(createPPCEarlyReturnPass(), false);
  // Must run branch selection immediately preceding the asm printer.
  addPass(createPPCBranchSelectionPass(), false);
}

TargetTransformInfo
PPCTargetMachine::getTargetTransformInfo(const Function &F) {
  return TargetTransformInfo(PPCTTIImpl(this, F));
}

static MachineSchedRegistry
PPCPreRASchedRegistry("ppc-prera",
                      "Run PowerPC PreRA specific scheduler",
                      createPPCMachineScheduler);

static MachineSchedRegistry
PPCPostRASchedRegistry("ppc-postra",
                       "Run PowerPC PostRA specific scheduler",
                       createPPCPostMachineScheduler);
