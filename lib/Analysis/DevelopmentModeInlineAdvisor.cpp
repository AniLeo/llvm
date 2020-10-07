//===- DevelopmentModeInlineAdvisor.cpp - runtime-loadable model runner  --===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements a model runner using Tensorflow C APIs, allowing the
// loading of a model from a command line option.
//
//===----------------------------------------------------------------------===//
#include "llvm/Config/config.h"
#if defined(LLVM_HAVE_TF_API)

#include "llvm/Analysis/CallGraph.h"
#include "llvm/Analysis/InlineSizeEstimatorAnalysis.h"
#include "llvm/Analysis/MLInlineAdvisor.h"
#include "llvm/Analysis/Utils/TFUtils.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ManagedStatic.h"
#include "llvm/Support/Path.h"

#include <vector>

using namespace llvm;

static cl::opt<std::string> TrainingLog(
    "training-log", cl::Hidden,
    cl::desc("Path where the development - mode inlining log is saved."));

static cl::opt<std::string> TFModelUnderTrainingPath(
    "ml-inliner-model-under-training", cl::Hidden,
    cl::desc(R"(Path to SavedModel from the previous training iteration.
The directory is also expected to contain a JSON specification of the 
outputs expected to be logged, where the first entry must be the 
inlining decision. The file containing the specification should be 
called output_spec.json. The expected JSON value is an array of 
dictionaries. Each dictionary should have 2 keys: 

- "tensor_spec, followed by the TensorSpec description of the
output; and 
- "logging_name", a string indicating the name to use when
logging the output values. 

Example:
[
  {
    "logging_name" : "some_name", 
    "tensor_spec" : { 
      "name" : "model_name", 
      "port" : 0,
      "shape" : [2, 3],
      "type" : "float"
      }
  }
]

The first value must always correspond to the decision.)"));

static cl::opt<std::string> TFOutputSpecOverride(
    "ml-inliner-output-spec-override", cl::Hidden,
    cl::desc("Override the path to the output spec json file. See "
             "-ml-inliner-model-under-training documentation for the "
             "specification of that file."));

static cl::opt<std::string> TFFeedPrefix("ml-inliner-trained-model-feed-prefix",
                                         cl::Hidden, cl::init("action_"),
                                         cl::desc("Prefix for feature names."));

namespace {
/// An InlineEvent, used by TrainingLogger.
struct InlineEvent {
  /// What the default policy's decision would have been.
  int64_t DefaultDecision = 0;

  /// What we advised. When training off the default policy, this is the same as
  /// DefaultDecision.
  int64_t AdvisedDecision = 0;

  /// What actually happened. This would be 'false' in the case of an inline
  /// error, even if AdvisedDecision were true, otherwise it agrees with
  /// AdvisedDecision.
  bool Effect = false;

  /// What the change in size was: size_after - size_before
  int64_t Reward = 0;
};

/// Collect data we may use for training a model, and write it as a textual
/// Tensorflow SequenceExample
/// (https://www.tensorflow.org/api_docs/python/tf/train/SequenceExample)
/// protobuf (https://developers.google.com/protocol-buffers).
/// Because this is a protobuf, we cannot just stream the events as they come.
/// Internally, TrainingLogger stores data in column-major format, because that
/// lines up with how TF SequenceExample represents it.
class ModelUnderTrainingRunner;
class TrainingLogger final {
public:
  TrainingLogger(StringRef LogFileName, const ModelUnderTrainingRunner *MUTR);

  /// Log one inlining event.
  void logInlineEvent(const InlineEvent &Event,
                      const MLModelRunner &ModelRunner);

  /// Print the stored tensors.
  void print();

private:
  StringRef LogFileName;
  const ModelUnderTrainingRunner *const MUTR;
  std::unique_ptr<Logger> L;
  std::vector<bool> Effects;
  /// There's at least one output. We'll set this to a different value if MUTR
  /// is avaliable.
  size_t OutputCount = 1;
  /// Set these 2 clearly OOB, to make sure we set them later.
  size_t DefaultDecisionPos = std::numeric_limits<size_t>::max();
  size_t DecisionPos = std::numeric_limits<size_t>::max();
};

/// An extension of the MLInlineAdvisor for the 'development' mode, targeting
/// the offline training scenario. Note that training happens outside of the
/// compiler, this facility is concerned with producing training data ("logs").
/// This InlineAdvisor can operate in the following modes:
///
/// 1) collect logs for the default policy. This is useful for bootstrapping
/// training, which will be considerably faster by starting from a reasonable
/// policy.
///
/// 2) collect logs for the ML policy, using a model from a previous
/// training. Potentially, that model uses internally some small random
/// perturbation of its weights, to induce exploration (setting this up is the
/// responsibility of the training algorithm). The logs would then be used to
/// retrain and improve on this model.
///
/// 3) use the provided model, with no logging. This is useful for end to end
/// validation - the model, in this case, is a release candidate and shouldn't
/// have random perturbations. It is a convenience feature: rather than needing
/// to take the release candidate model and compile it in 'release' mode,
/// validate it, then potentially discard it, it's easier to just pass the model
/// to the compiler, albeit compilation would be slower, as a one-off. Once the
/// model behaves satisfactorily, it can be compiled AOT, for efficiency, in
/// release mode. The expectation is that a well-trained model provides a good
/// policy over a sufficiently diverse codebase, over many changes (i.e.
/// training happens seldom).
class DevelopmentModeMLInlineAdvisor : public MLInlineAdvisor {
public:
  DevelopmentModeMLInlineAdvisor(
      Module &M, ModuleAnalysisManager &MAM,
      std::unique_ptr<MLModelRunner> ModelRunner,
      std::function<bool(CallBase &)> GetDefaultAdvice, bool IsDoingInference,
      std::unique_ptr<TrainingLogger> Logger);

  size_t getTotalSizeEstimate();

  virtual ~DevelopmentModeMLInlineAdvisor();
  void updateNativeSizeEstimate(int64_t Change) {
    *CurrentNativeSize += Change;
  }
  void resetNativeSize(Function *F) {
    FAM.invalidate<InlineSizeEstimatorAnalysis>(*F);
  }

  std::unique_ptr<MLInlineAdvice>
  getMandatoryAdvice(CallBase &CB, OptimizationRemarkEmitter &ORE) override;
  std::unique_ptr<MLInlineAdvice>
  getAdviceFromModel(CallBase &CB, OptimizationRemarkEmitter &ORE) override;

  Optional<size_t> getNativeSizeEstimate(const Function &F) const;

private:
  bool isLogging() const { return !!Logger; }

  std::function<bool(CallBase &)> GetDefaultAdvice;
  const bool IsDoingInference;
  std::unique_ptr<TrainingLogger> Logger;

  const Optional<int32_t> InitialNativeSize;
  Optional<int32_t> CurrentNativeSize;
};

/// A variant of MLInlineAdvice that tracks all non-trivial inlining
/// decisions, for training/logging.
class LoggingMLInlineAdvice : public MLInlineAdvice {
public:
  LoggingMLInlineAdvice(DevelopmentModeMLInlineAdvisor *Advisor, CallBase &CB,
                        OptimizationRemarkEmitter &ORE, bool Recommendation,
                        TrainingLogger &Logger,
                        Optional<size_t> CallerSizeEstimateBefore,
                        Optional<size_t> CalleeSizeEstimateBefore,
                        bool DefaultDecision, bool Mandatory = false)
      : MLInlineAdvice(Advisor, CB, ORE, Recommendation), Logger(Logger),
        CallerSizeEstimateBefore(CallerSizeEstimateBefore),
        CalleeSizeEstimateBefore(CalleeSizeEstimateBefore),
        DefaultDecision(DefaultDecision), Mandatory(Mandatory) {}

  virtual ~LoggingMLInlineAdvice() = default;

private:
  DevelopmentModeMLInlineAdvisor *getAdvisor() const {
    return static_cast<DevelopmentModeMLInlineAdvisor *>(Advisor);
  }
  void recordInliningImpl() override {
    MLInlineAdvice::recordInliningImpl();
    getAdvisor()->resetNativeSize(Caller);
    int Reward = std::numeric_limits<int>::max();
    if (InlineSizeEstimatorAnalysis::isEvaluatorRequested() &&
        !getAdvisor()->isForcedToStop()) {
      int NativeSizeAfter = *getAdvisor()->getNativeSizeEstimate(*Caller) +
                            *CalleeSizeEstimateBefore;
      Reward = NativeSizeAfter -
               (*CallerSizeEstimateBefore + *CalleeSizeEstimateBefore);
      getAdvisor()->updateNativeSizeEstimate(Reward);
    }
    log(Reward, /*Success=*/true);
  }

  void recordInliningWithCalleeDeletedImpl() override {
    MLInlineAdvice::recordInliningWithCalleeDeletedImpl();
    getAdvisor()->resetNativeSize(Caller);
    if (InlineSizeEstimatorAnalysis::isEvaluatorRequested() &&
        !getAdvisor()->isForcedToStop()) {
      int NativeSizeAfter = *getAdvisor()->getNativeSizeEstimate(*Caller);
      int Reward = NativeSizeAfter -
                   (*CallerSizeEstimateBefore + *CalleeSizeEstimateBefore);
      getAdvisor()->updateNativeSizeEstimate(Reward);
      log(Reward, /*Success=*/true);
    }
  }

  void recordUnsuccessfulInliningImpl(const InlineResult &Result) override {
    MLInlineAdvice::recordUnsuccessfulInliningImpl(Result);
    log(NoReward, /*Success=*/false);
  }

  void recordUnattemptedInliningImpl() override {
    MLInlineAdvice::recordUnattemptedInliningImpl();
    log(NoReward, /*Success=*/false);
  }

  void log(int64_t Reward, bool Success) {
    if (Mandatory)
      return;
    InlineEvent Event;
    Event.AdvisedDecision = isInliningRecommended();
    Event.DefaultDecision = DefaultDecision;
    Event.Effect = Success;
    Event.Reward = Reward;
    Logger.logInlineEvent(Event, getAdvisor()->getModelRunner());
  }

  static const int64_t NoReward = 0;
  TrainingLogger &Logger;
  const Optional<size_t> CallerSizeEstimateBefore;
  const Optional<size_t> CalleeSizeEstimateBefore;
  const int64_t DefaultDecision;
  const int64_t Mandatory;
};

/// A pseudo model runner. We use it to store feature values when collecting
/// logs for the default policy, but never ask it to 'run'.
class NoInferenceModelRunner : public MLModelRunner {
public:
  NoInferenceModelRunner(LLVMContext &Ctx)
      : MLModelRunner(Ctx), Features(NumberOfFeatures) {}
  void setFeature(FeatureIndex Index, int64_t Value) override {
    Features[static_cast<int>(Index)] = Value;
  }

  int64_t getFeature(int Index) const override { return Features[Index]; }
  bool run() override {
    llvm_unreachable("We shouldn't call run on this model runner.");
  }

private:
  InlineFeatures Features;
};

/// ModelUnderTrainingRunner - training mode implementation. It uses TF C APIs
/// to dynamically load and evaluate a TF SavedModel
/// (https://www.tensorflow.org/guide/saved_model). Runtime performance is
/// sacrificed for ease of use while training.
class ModelUnderTrainingRunner final : public MLModelRunner {
public:
  ModelUnderTrainingRunner(LLVMContext &Ctx, const std::string &ModelPath);

  bool run() override;

  // Disallows copy and assign.
  ModelUnderTrainingRunner(const ModelUnderTrainingRunner &) = delete;
  ModelUnderTrainingRunner &
  operator=(const ModelUnderTrainingRunner &) = delete;

  void setFeature(FeatureIndex Index, int64_t Value) override;
  int64_t getFeature(int Index) const override;
  bool isValid() const { return !!Evaluator; }

  const std::vector<std::string> &outputNames() const { return OutputNames; }

  const std::vector<TensorSpec> &outputSpecs() const { return OutputSpecs; }

  const Optional<TFModelEvaluator::EvaluationResult> &
  lastEvaluationResult() const {
    return LastEvaluationResult;
  }

private:
  std::unique_ptr<TFModelEvaluator> Evaluator;
  std::vector<std::string> OutputNames;
  std::vector<TensorSpec> OutputSpecs;
  Optional<TFModelEvaluator::EvaluationResult> LastEvaluationResult;

  bool loadOutputSpecs(LLVMContext &Ctx, StringRef FileName);

  // The training framework needs some additional features.
  const std::vector<TensorSpec> TrainingOnlyFeatures{
      TensorSpec::createSpec<int64_t>(TFFeedPrefix + "inlining_default", {1}),
      TensorSpec::createSpec<float>(TFFeedPrefix + "discount", {1}),
      TensorSpec::createSpec<float>(TFFeedPrefix + "reward", {1}),
      TensorSpec::createSpec<int32_t>(TFFeedPrefix + "step_type", {1})};
};
} // namespace

TrainingLogger::TrainingLogger(StringRef LogFileName,
                               const ModelUnderTrainingRunner *MUTR)
    : LogFileName(LogFileName), MUTR(MUTR) {
  // The first output is the inlining decision.
  if (MUTR)
    OutputCount = MUTR->outputSpecs().size();
  std::vector<Logger::LoggedFeatureSpec> FT;

  for (size_t I = 0; I < NumberOfFeatures; ++I)
    FT.push_back(
        {TensorSpec::createSpec<int64_t>(FeatureNameMap.at(I), {1}), None});
  for (size_t I = 1; I < OutputCount; ++I)
    FT.push_back({MUTR->outputSpecs()[I], MUTR->outputNames()[I]});

  DefaultDecisionPos = FT.size();
  FT.push_back(
      {TensorSpec::createSpec<int64_t>(DefaultDecisionName, {1}), None});

  DecisionPos = FT.size();
  FT.push_back({TensorSpec::createSpec<int64_t>(DecisionName, {1}), None});

  L = std::make_unique<Logger>(
      FT, TensorSpec::createSpec<int64_t>(RewardName, {1}),
      InlineSizeEstimatorAnalysis::isEvaluatorRequested());
}

/// Log one inlining event.
void TrainingLogger::logInlineEvent(const InlineEvent &Event,
                                    const MLModelRunner &ModelRunner) {
  size_t CurrentFeature = 0;
  for (; CurrentFeature < NumberOfFeatures; ++CurrentFeature) {
    int64_t F = ModelRunner.getFeature(CurrentFeature);
    L->logTensorValue(CurrentFeature, &F);
  }

  for (size_t I = 1; I < OutputCount; ++I) {
    const auto &Result = *MUTR->lastEvaluationResult();
    auto &Spec = MUTR->outputSpecs()[I];
    const char *RawData =
        reinterpret_cast<const char *>(Result.getUntypedTensorValue(I));
    L->logTensorValue(CurrentFeature, RawData,
                      Spec.getElementCount() * Spec.getElementByteSize());
    ++CurrentFeature;
  }

  assert(CurrentFeature == DefaultDecisionPos);
  L->logTensorValue(DefaultDecisionPos, &Event.DefaultDecision);
  L->logTensorValue(DecisionPos, &Event.AdvisedDecision);
  if (InlineSizeEstimatorAnalysis::isEvaluatorRequested())
    L->logReward(Event.Reward);

  // For debugging / later use
  Effects.push_back(Event.Effect);
}

void TrainingLogger::print() {
  std::error_code EC;
  raw_fd_ostream OutFile(LogFileName, EC);
  L->print(OutFile);
}

DevelopmentModeMLInlineAdvisor::DevelopmentModeMLInlineAdvisor(
    Module &M, ModuleAnalysisManager &MAM,
    std::unique_ptr<MLModelRunner> ModelRunner,
    std::function<bool(CallBase &)> GetDefaultAdvice, bool IsDoingInference,
    std::unique_ptr<TrainingLogger> Logger)
    : MLInlineAdvisor(M, MAM, std::move(ModelRunner)),
      GetDefaultAdvice(GetDefaultAdvice), IsDoingInference(IsDoingInference),
      Logger(std::move(Logger)),
      InitialNativeSize(isLogging() ? getTotalSizeEstimate() : 0),
      CurrentNativeSize(InitialNativeSize) {
  // We cannot have the case of neither inference nor logging.
  assert(IsDoingInference || isLogging());
}

DevelopmentModeMLInlineAdvisor::~DevelopmentModeMLInlineAdvisor() {
  if (isLogging())
    Logger->print();
}

Optional<size_t>
DevelopmentModeMLInlineAdvisor::getNativeSizeEstimate(const Function &F) const {
  if (!InlineSizeEstimatorAnalysis::isEvaluatorRequested())
    return None;
  auto &R =
      FAM.getResult<InlineSizeEstimatorAnalysis>(const_cast<Function &>(F));
  if (!R) {
    F.getParent()->getContext().emitError(
        "Native size estimator is not present.");
    return 0;
  }
  return *R;
}

std::unique_ptr<MLInlineAdvice>
DevelopmentModeMLInlineAdvisor::getMandatoryAdvice(
    CallBase &CB, OptimizationRemarkEmitter &ORE) {
  if (!isLogging())
    return MLInlineAdvisor::getMandatoryAdvice(CB, ORE);

  return std::make_unique<LoggingMLInlineAdvice>(
      /*Advisor=*/this,
      /*CB=*/CB, /*ORE=*/ORE, /*Recommendation=*/true, /*Logger=*/*Logger,
      /*CallerSizeEstimateBefore=*/getNativeSizeEstimate(*CB.getCaller()),
      /*CalleeSizeEstimateBefore=*/
      getNativeSizeEstimate(*CB.getCalledFunction()),
      /*DefaultDecision=*/true, /*Mandatory*/ true);
}

std::unique_ptr<MLInlineAdvice>
DevelopmentModeMLInlineAdvisor::getAdviceFromModel(
    CallBase &CB, OptimizationRemarkEmitter &ORE) {
  if (IsDoingInference && !isLogging())
    return MLInlineAdvisor::getAdviceFromModel(CB, ORE);

  bool DefaultAdvice = GetDefaultAdvice(CB);
  auto Recommendation = IsDoingInference ? ModelRunner->run() : DefaultAdvice;
  return std::make_unique<LoggingMLInlineAdvice>(
      /*Advisor=*/this,
      /*CB=*/CB, /*ORE=*/ORE, /*Recommendation=*/Recommendation,
      /*Logger=*/*Logger,
      /*CallerSizeEstimateBefore=*/getNativeSizeEstimate(*CB.getCaller()),
      /*CalleeSizeEstimateBefore=*/
      getNativeSizeEstimate(*CB.getCalledFunction()),
      /*DefaultDecision=*/DefaultAdvice);
}

size_t DevelopmentModeMLInlineAdvisor::getTotalSizeEstimate() {
  if (!InlineSizeEstimatorAnalysis::isEvaluatorRequested())
    return 0;
  size_t Ret = 0;
  for (auto &F : M) {
    if (F.isDeclaration())
      continue;
    if (isFunctionDeleted(&F))
      continue;
    Ret += *getNativeSizeEstimate(F);
  }
  return Ret;
}

ModelUnderTrainingRunner::ModelUnderTrainingRunner(LLVMContext &Ctx,
                                                   const std::string &ModelPath)
    : MLModelRunner(Ctx) {
  std::vector<TensorSpec> InputSpecs;
  for (size_t I = 0; I < NumberOfFeatures; ++I)
    InputSpecs.push_back(
        TensorSpec::createSpec<int64_t>(TFFeedPrefix + FeatureNameMap[I], {1}));
  InputSpecs.insert(InputSpecs.end(), TrainingOnlyFeatures.begin(),
                    TrainingOnlyFeatures.end());
  SmallVector<char, 128> OutputSpecsPath;
  StringRef OutputSpecPath = TFOutputSpecOverride;
  if (OutputSpecPath.empty()) {
    llvm::sys::path::append(OutputSpecsPath, ModelPath, "output_spec.json");
    OutputSpecPath = {OutputSpecsPath.data(), OutputSpecsPath.size()};
  }
  if (!loadOutputSpecs(Ctx, OutputSpecPath))
    return;

  Evaluator =
      std::make_unique<TFModelEvaluator>(ModelPath, InputSpecs, OutputSpecs);
  if (!Evaluator || !Evaluator->isValid()) {
    Ctx.emitError("Failed to create inliner saved model evaluator");
    Evaluator.reset();
    return;
  }
}

bool ModelUnderTrainingRunner::loadOutputSpecs(LLVMContext &Ctx,
                                               StringRef FileName) {
  auto BufferOrError = MemoryBuffer::getFileOrSTDIN(FileName);
  if (!BufferOrError) {
    Ctx.emitError("Error opening output specs file: " + FileName + " : " +
                  BufferOrError.getError().message());
    return false;
  }
  auto ParsedJSONValues = json::parse(BufferOrError.get()->getBuffer());
  if (!ParsedJSONValues) {
    Ctx.emitError("Could not parse specs file: " + FileName);
    return false;
  }
  auto ValuesArray = ParsedJSONValues->getAsArray();
  if (!ValuesArray) {
    Ctx.emitError("Expected an array of {tensor_spec:<TensorSpec>, "
                  "logging_name:<name>} dictionaries");
    return false;
  }

  for (const auto &Value : *ValuesArray)
    if (const auto *Obj = Value.getAsObject())
      if (const auto *SpecPart = Obj->get("tensor_spec"))
        if (auto TensorSpec = getTensorSpecFromJSON(Ctx, *SpecPart))
          if (auto LoggingName = Obj->getString("logging_name")) {
            if (!TensorSpec->isElementType<int64_t>() &&
                !TensorSpec->isElementType<int32_t>() &&
                !TensorSpec->isElementType<float>()) {
              Ctx.emitError(
                  "Only int64, int32, and float tensors are supported. "
                  "Found unsupported type for tensor named " +
                  TensorSpec->name());
              return false;
            }
            OutputNames.push_back(LoggingName->str());
            OutputSpecs.push_back(*TensorSpec);
          }

  if (ValuesArray->size() != OutputNames.size()) {
    Ctx.emitError(
        "Unable to parse output spec. It should be a json file containing an "
        "array of dictionaries. Each dictionary must have a 'tensor_spec' key, "
        "with a json object describing a TensorSpec; and a 'logging_name' key, "
        "which is a string to use as name when logging this tensor in the "
        "training log.");
    return false;
  }
  assert(OutputNames.size() == OutputSpecs.size());
  if (OutputNames.empty() || OutputNames[0] != DecisionName) {
    Ctx.emitError("The first output spec must describe the decision tensor, "
                  "and must have the logging_name " +
                  StringRef(DecisionName));
    return false;
  }
  return true;
}

bool ModelUnderTrainingRunner::run() {
  LastEvaluationResult = Evaluator->evaluate();
  if (!LastEvaluationResult.hasValue()) {
    Ctx.emitError("Error evaluating model.");
    return false;
  }
  int64_t Decision = *LastEvaluationResult->getTensorValue<int64_t>(0);
  return static_cast<bool>(Decision);
}

int64_t ModelUnderTrainingRunner::getFeature(int Index) const {
  return *Evaluator->getInput<int64_t>(Index);
}

void ModelUnderTrainingRunner::setFeature(FeatureIndex Index, int64_t Value) {
  size_t NumericIndex = static_cast<size_t>(Index);
  *(Evaluator->getInput<int64_t>(NumericIndex)) = Value;
}

std::unique_ptr<InlineAdvisor> llvm::getDevelopmentModeAdvisor(
    Module &M, ModuleAnalysisManager &MAM,
    std::function<bool(CallBase &)> GetDefaultAdvice) {
  auto &Ctx = M.getContext();
  std::unique_ptr<MLModelRunner> Runner;
  ModelUnderTrainingRunner *MUTRPtr = nullptr;
  bool IsDoingInference = false;
  if (TFModelUnderTrainingPath.empty())
    Runner.reset(new NoInferenceModelRunner(Ctx));
  else {
    auto MUTR = std::make_unique<ModelUnderTrainingRunner>(
        Ctx, TFModelUnderTrainingPath);
    if (!MUTR || !MUTR->isValid()) {
      Ctx.emitError("Could not load the policy model from the provided path");
      return nullptr;
    }
    IsDoingInference = true;
    MUTRPtr = MUTR.get();
    Runner = std::move(MUTR);
  }
  std::unique_ptr<TrainingLogger> Logger;
  if (!TrainingLog.empty())
    Logger = std::make_unique<TrainingLogger>(TrainingLog, MUTRPtr);

  return std::make_unique<DevelopmentModeMLInlineAdvisor>(
      M, MAM, std::move(Runner), GetDefaultAdvice, IsDoingInference,
      std::move(Logger));
}
#endif // defined(LLVM_HAVE_TF_API)
