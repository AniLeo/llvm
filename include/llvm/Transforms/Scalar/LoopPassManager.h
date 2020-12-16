//===- LoopPassManager.h - Loop pass management -----------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This header provides classes for managing a pipeline of passes over loops
/// in LLVM IR.
///
/// The primary loop pass pipeline is managed in a very particular way to
/// provide a set of core guarantees:
/// 1) Loops are, where possible, in simplified form.
/// 2) Loops are *always* in LCSSA form.
/// 3) A collection of Loop-specific analysis results are available:
///    - LoopInfo
///    - DominatorTree
///    - ScalarEvolution
///    - AAManager
/// 4) All loop passes preserve #1 (where possible), #2, and #3.
/// 5) Loop passes run over each loop in the loop nest from the innermost to
///    the outermost. Specifically, all inner loops are processed before
///    passes run over outer loops. When running the pipeline across an inner
///    loop creates new inner loops, those are added and processed in this
///    order as well.
///
/// This process is designed to facilitate transformations which simplify,
/// reduce, and remove loops. For passes which are more oriented towards
/// optimizing loops, especially optimizing loop *nests* instead of single
/// loops in isolation, this framework is less interesting.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_SCALAR_LOOPPASSMANAGER_H
#define LLVM_TRANSFORMS_SCALAR_LOOPPASSMANAGER_H

#include "llvm/ADT/PostOrderIterator.h"
#include "llvm/ADT/PriorityWorklist.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/BasicAliasAnalysis.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopNestAnalysis.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionAliasAnalysis.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/PassInstrumentation.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Utils/LCSSA.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include <memory>

namespace llvm {

// Forward declarations of an update tracking API used in the pass manager.
class LPMUpdater;

// Explicit specialization and instantiation declarations for the pass manager.
// See the comments on the definition of the specialization for details on how
// it differs from the primary template.
template <>
class PassManager<Loop, LoopAnalysisManager, LoopStandardAnalysisResults &,
                  LPMUpdater &>
    : public PassInfoMixin<
          PassManager<Loop, LoopAnalysisManager, LoopStandardAnalysisResults &,
                      LPMUpdater &>> {
private:
  template <typename PassT>
  using HasRunOnLoopT = decltype(std::declval<PassT>().run(
      std::declval<Loop &>(), std::declval<LoopAnalysisManager &>(),
      std::declval<LoopStandardAnalysisResults &>(),
      std::declval<LPMUpdater &>()));

public:
  /// Construct a pass manager.
  ///
  /// If \p DebugLogging is true, we'll log our progress to llvm::dbgs().
  explicit PassManager(bool DebugLogging = false)
      : DebugLogging(DebugLogging) {}

  // FIXME: These are equivalent to the default move constructor/move
  // assignment. However, using = default triggers linker errors due to the
  // explicit instantiations below. Find a way to use the default and remove the
  // duplicated code here.
  PassManager(PassManager &&Arg)
      : IsLoopNestPass(std::move(Arg.IsLoopNestPass)),
        LoopPasses(std::move(Arg.LoopPasses)),
        LoopNestPasses(std::move(Arg.LoopNestPasses)),
        DebugLogging(std::move(Arg.DebugLogging)) {}

  PassManager &operator=(PassManager &&RHS) {
    IsLoopNestPass = std::move(RHS.IsLoopNestPass);
    LoopPasses = std::move(RHS.LoopPasses);
    LoopNestPasses = std::move(RHS.LoopNestPasses);
    DebugLogging = std::move(RHS.DebugLogging);
    return *this;
  }

  PreservedAnalyses run(Loop &L, LoopAnalysisManager &AM,
                        LoopStandardAnalysisResults &AR, LPMUpdater &U);

  /// Add either a loop pass or a loop-nest pass to the pass manager. Append \p
  /// Pass to the list of loop passes if it has a dedicated \fn run() method for
  /// loops and to the list of loop-nest passes if the \fn run() method is for
  /// loop-nests instead. Also append whether \p Pass is loop-nest pass or not
  /// to the end of \var IsLoopNestPass so we can easily identify the types of
  /// passes in the pass manager later.
  template <typename PassT>
  std::enable_if_t<is_detected<HasRunOnLoopT, PassT>::value>
  addPass(PassT Pass) {
    using LoopPassModelT =
        detail::PassModel<Loop, PassT, PreservedAnalyses, LoopAnalysisManager,
                          LoopStandardAnalysisResults &, LPMUpdater &>;
    IsLoopNestPass.push_back(false);
    LoopPasses.emplace_back(new LoopPassModelT(std::move(Pass)));
  }

  template <typename PassT>
  std::enable_if_t<!is_detected<HasRunOnLoopT, PassT>::value>
  addPass(PassT Pass) {
    using LoopNestPassModelT =
        detail::PassModel<LoopNest, PassT, PreservedAnalyses,
                          LoopAnalysisManager, LoopStandardAnalysisResults &,
                          LPMUpdater &>;
    IsLoopNestPass.push_back(true);
    LoopNestPasses.emplace_back(new LoopNestPassModelT(std::move(Pass)));
  }

  // Specializations of `addPass` for `RepeatedPass`. These are necessary since
  // `RepeatedPass` has a templated `run` method that will result in incorrect
  // detection of `HasRunOnLoopT`.
  template <typename PassT>
  std::enable_if_t<is_detected<HasRunOnLoopT, PassT>::value>
  addPass(RepeatedPass<PassT> Pass) {
    using RepeatedLoopPassModelT =
        detail::PassModel<Loop, RepeatedPass<PassT>, PreservedAnalyses,
                          LoopAnalysisManager, LoopStandardAnalysisResults &,
                          LPMUpdater &>;
    IsLoopNestPass.push_back(false);
    LoopPasses.emplace_back(new RepeatedLoopPassModelT(std::move(Pass)));
  }

  template <typename PassT>
  std::enable_if_t<!is_detected<HasRunOnLoopT, PassT>::value>
  addPass(RepeatedPass<PassT> Pass) {
    using RepeatedLoopNestPassModelT =
        detail::PassModel<LoopNest, RepeatedPass<PassT>, PreservedAnalyses,
                          LoopAnalysisManager, LoopStandardAnalysisResults &,
                          LPMUpdater &>;
    IsLoopNestPass.push_back(true);
    LoopNestPasses.emplace_back(
        new RepeatedLoopNestPassModelT(std::move(Pass)));
  }

  bool isEmpty() const { return LoopPasses.empty() && LoopNestPasses.empty(); }

  static bool isRequired() { return true; }

protected:
  using LoopPassConceptT =
      detail::PassConcept<Loop, LoopAnalysisManager,
                          LoopStandardAnalysisResults &, LPMUpdater &>;
  using LoopNestPassConceptT =
      detail::PassConcept<LoopNest, LoopAnalysisManager,
                          LoopStandardAnalysisResults &, LPMUpdater &>;

  // BitVector that identifies whether the passes are loop passes or loop-nest
  // passes (true for loop-nest passes).
  BitVector IsLoopNestPass;
  std::vector<std::unique_ptr<LoopPassConceptT>> LoopPasses;
  std::vector<std::unique_ptr<LoopNestPassConceptT>> LoopNestPasses;

  /// Flag indicating whether we should do debug logging.
  bool DebugLogging;

  /// Run either a loop pass or a loop-nest pass. Returns `None` if
  /// PassInstrumentation's BeforePass returns false. Otherwise, returns the
  /// preserved analyses of the pass.
  template <typename IRUnitT, typename PassT>
  Optional<PreservedAnalyses>
  runSinglePass(IRUnitT &IR, PassT &Pass, LoopAnalysisManager &AM,
                LoopStandardAnalysisResults &AR, LPMUpdater &U,
                PassInstrumentation &PI);

  PreservedAnalyses runWithLoopNestPasses(Loop &L, LoopAnalysisManager &AM,
                                          LoopStandardAnalysisResults &AR,
                                          LPMUpdater &U);
  PreservedAnalyses runWithoutLoopNestPasses(Loop &L, LoopAnalysisManager &AM,
                                             LoopStandardAnalysisResults &AR,
                                             LPMUpdater &U);
};

/// The Loop pass manager.
///
/// See the documentation for the PassManager template for details. It runs
/// a sequence of Loop passes over each Loop that the manager is run over. This
/// typedef serves as a convenient way to refer to this construct.
typedef PassManager<Loop, LoopAnalysisManager, LoopStandardAnalysisResults &,
                    LPMUpdater &>
    LoopPassManager;

/// A partial specialization of the require analysis template pass to forward
/// the extra parameters from a transformation's run method to the
/// AnalysisManager's getResult.
template <typename AnalysisT>
struct RequireAnalysisPass<AnalysisT, Loop, LoopAnalysisManager,
                           LoopStandardAnalysisResults &, LPMUpdater &>
    : PassInfoMixin<
          RequireAnalysisPass<AnalysisT, Loop, LoopAnalysisManager,
                              LoopStandardAnalysisResults &, LPMUpdater &>> {
  PreservedAnalyses run(Loop &L, LoopAnalysisManager &AM,
                        LoopStandardAnalysisResults &AR, LPMUpdater &) {
    (void)AM.template getResult<AnalysisT>(L, AR);
    return PreservedAnalyses::all();
  }
};

/// An alias template to easily name a require analysis loop pass.
template <typename AnalysisT>
using RequireAnalysisLoopPass =
    RequireAnalysisPass<AnalysisT, Loop, LoopAnalysisManager,
                        LoopStandardAnalysisResults &, LPMUpdater &>;

class FunctionToLoopPassAdaptor;

/// This class provides an interface for updating the loop pass manager based
/// on mutations to the loop nest.
///
/// A reference to an instance of this class is passed as an argument to each
/// Loop pass, and Loop passes should use it to update LPM infrastructure if
/// they modify the loop nest structure.
class LPMUpdater {
public:
  /// This can be queried by loop passes which run other loop passes (like pass
  /// managers) to know whether the loop needs to be skipped due to updates to
  /// the loop nest.
  ///
  /// If this returns true, the loop object may have been deleted, so passes
  /// should take care not to touch the object.
  bool skipCurrentLoop() const { return SkipCurrentLoop; }

  /// Loop passes should use this method to indicate they have deleted a loop
  /// from the nest.
  ///
  /// Note that this loop must either be the current loop or a subloop of the
  /// current loop. This routine must be called prior to removing the loop from
  /// the loop nest.
  ///
  /// If this is called for the current loop, in addition to clearing any
  /// state, this routine will mark that the current loop should be skipped by
  /// the rest of the pass management infrastructure.
  void markLoopAsDeleted(Loop &L, llvm::StringRef Name) {
    LAM.clear(L, Name);
    assert((&L == CurrentL || CurrentL->contains(&L)) &&
           "Cannot delete a loop outside of the "
           "subloop tree currently being processed.");
    if (&L == CurrentL)
      SkipCurrentLoop = true;
  }

  /// Loop passes should use this method to indicate they have added new child
  /// loops of the current loop.
  ///
  /// \p NewChildLoops must contain only the immediate children. Any nested
  /// loops within them will be visited in postorder as usual for the loop pass
  /// manager.
  void addChildLoops(ArrayRef<Loop *> NewChildLoops) {
    // Insert ourselves back into the worklist first, as this loop should be
    // revisited after all the children have been processed.
    Worklist.insert(CurrentL);

#ifndef NDEBUG
    for (Loop *NewL : NewChildLoops)
      assert(NewL->getParentLoop() == CurrentL && "All of the new loops must "
                                                  "be immediate children of "
                                                  "the current loop!");
#endif

    appendLoopsToWorklist(NewChildLoops, Worklist);

    // Also skip further processing of the current loop--it will be revisited
    // after all of its newly added children are accounted for.
    SkipCurrentLoop = true;
  }

  /// Loop passes should use this method to indicate they have added new
  /// sibling loops to the current loop.
  ///
  /// \p NewSibLoops must only contain the immediate sibling loops. Any nested
  /// loops within them will be visited in postorder as usual for the loop pass
  /// manager.
  void addSiblingLoops(ArrayRef<Loop *> NewSibLoops) {
#ifndef NDEBUG
    for (Loop *NewL : NewSibLoops)
      assert(NewL->getParentLoop() == ParentL &&
             "All of the new loops must be siblings of the current loop!");
#endif

    appendLoopsToWorklist(NewSibLoops, Worklist);

    // No need to skip the current loop or revisit it, as sibling loops
    // shouldn't impact anything.
  }

  /// Restart the current loop.
  ///
  /// Loop passes should call this method to indicate the current loop has been
  /// sufficiently changed that it should be re-visited from the begining of
  /// the loop pass pipeline rather than continuing.
  void revisitCurrentLoop() {
    // Tell the currently in-flight pipeline to stop running.
    SkipCurrentLoop = true;

    // And insert ourselves back into the worklist.
    Worklist.insert(CurrentL);
  }

private:
  friend class llvm::FunctionToLoopPassAdaptor;

  /// The \c FunctionToLoopPassAdaptor's worklist of loops to process.
  SmallPriorityWorklist<Loop *, 4> &Worklist;

  /// The analysis manager for use in the current loop nest.
  LoopAnalysisManager &LAM;

  Loop *CurrentL;
  bool SkipCurrentLoop;

#ifndef NDEBUG
  // In debug builds we also track the parent loop to implement asserts even in
  // the face of loop deletion.
  Loop *ParentL;
#endif

  LPMUpdater(SmallPriorityWorklist<Loop *, 4> &Worklist,
             LoopAnalysisManager &LAM)
      : Worklist(Worklist), LAM(LAM) {}
};

template <typename IRUnitT, typename PassT>
Optional<PreservedAnalyses> LoopPassManager::runSinglePass(
    IRUnitT &IR, PassT &Pass, LoopAnalysisManager &AM,
    LoopStandardAnalysisResults &AR, LPMUpdater &U, PassInstrumentation &PI) {
  // Check the PassInstrumentation's BeforePass callbacks before running the
  // pass, skip its execution completely if asked to (callback returns false).
  if (!PI.runBeforePass<IRUnitT>(*Pass, IR))
    return None;

  PreservedAnalyses PA;
  {
    TimeTraceScope TimeScope(Pass->name(), IR.getName());
    PA = Pass->run(IR, AM, AR, U);
  }

  // do not pass deleted Loop into the instrumentation
  if (U.skipCurrentLoop())
    PI.runAfterPassInvalidated<IRUnitT>(*Pass, PA);
  else
    PI.runAfterPass<IRUnitT>(*Pass, IR, PA);
  return PA;
}

/// Adaptor that maps from a function to its loops.
///
/// Designed to allow composition of a LoopPass(Manager) and a
/// FunctionPassManager. Note that if this pass is constructed with a \c
/// FunctionAnalysisManager it will run the \c LoopAnalysisManagerFunctionProxy
/// analysis prior to running the loop passes over the function to enable a \c
/// LoopAnalysisManager to be used within this run safely.
class FunctionToLoopPassAdaptor
    : public PassInfoMixin<FunctionToLoopPassAdaptor> {
public:
  using PassConceptT =
      detail::PassConcept<Loop, LoopAnalysisManager,
                          LoopStandardAnalysisResults &, LPMUpdater &>;

  explicit FunctionToLoopPassAdaptor(std::unique_ptr<PassConceptT> Pass,
                                     bool UseMemorySSA = false,
                                     bool UseBlockFrequencyInfo = false,
                                     bool DebugLogging = false)
      : Pass(std::move(Pass)), LoopCanonicalizationFPM(DebugLogging),
        UseMemorySSA(UseMemorySSA),
        UseBlockFrequencyInfo(UseBlockFrequencyInfo) {
    LoopCanonicalizationFPM.addPass(LoopSimplifyPass());
    LoopCanonicalizationFPM.addPass(LCSSAPass());
  }

  /// Runs the loop passes across every loop in the function.
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);

  static bool isRequired() { return true; }

private:
  std::unique_ptr<PassConceptT> Pass;

  FunctionPassManager LoopCanonicalizationFPM;

  bool UseMemorySSA = false;
  bool UseBlockFrequencyInfo = false;
};

/// A function to deduce a loop pass type and wrap it in the templated
/// adaptor.
template <typename LoopPassT>
FunctionToLoopPassAdaptor
createFunctionToLoopPassAdaptor(LoopPassT Pass, bool UseMemorySSA = false,
                                bool UseBlockFrequencyInfo = false,
                                bool DebugLogging = false) {
  using PassModelT =
      detail::PassModel<Loop, LoopPassT, PreservedAnalyses, LoopAnalysisManager,
                        LoopStandardAnalysisResults &, LPMUpdater &>;
  return FunctionToLoopPassAdaptor(
      std::make_unique<PassModelT>(std::move(Pass)), UseMemorySSA,
      UseBlockFrequencyInfo, DebugLogging);
}

/// Pass for printing a loop's contents as textual IR.
class PrintLoopPass : public PassInfoMixin<PrintLoopPass> {
  raw_ostream &OS;
  std::string Banner;

public:
  PrintLoopPass();
  PrintLoopPass(raw_ostream &OS, const std::string &Banner = "");

  PreservedAnalyses run(Loop &L, LoopAnalysisManager &,
                        LoopStandardAnalysisResults &, LPMUpdater &);
};
}

#endif // LLVM_TRANSFORMS_SCALAR_LOOPPASSMANAGER_H
