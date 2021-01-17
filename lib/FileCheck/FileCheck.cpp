//===- FileCheck.cpp - Check that File's Contents match what is expected --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// FileCheck does a line-by line check of a file that validates whether it
// contains the expected content.  This is useful for regression tests etc.
//
// This file implements most of the API that will be used by the FileCheck utility
// as well as various unittests.
//===----------------------------------------------------------------------===//

#include "llvm/FileCheck/FileCheck.h"
#include "FileCheckImpl.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/FormatVariadic.h"
#include <cstdint>
#include <list>
#include <set>
#include <tuple>
#include <utility>

using namespace llvm;

StringRef ExpressionFormat::toString() const {
  switch (Value) {
  case Kind::NoFormat:
    return StringRef("<none>");
  case Kind::Unsigned:
    return StringRef("%u");
  case Kind::Signed:
    return StringRef("%d");
  case Kind::HexUpper:
    return StringRef("%X");
  case Kind::HexLower:
    return StringRef("%x");
  }
  llvm_unreachable("unknown expression format");
}

Expected<std::string> ExpressionFormat::getWildcardRegex() const {
  auto CreatePrecisionRegex = [this](StringRef S) {
    return (S + Twine('{') + Twine(Precision) + "}").str();
  };

  switch (Value) {
  case Kind::Unsigned:
    if (Precision)
      return CreatePrecisionRegex("([1-9][0-9]*)?[0-9]");
    return std::string("[0-9]+");
  case Kind::Signed:
    if (Precision)
      return CreatePrecisionRegex("-?([1-9][0-9]*)?[0-9]");
    return std::string("-?[0-9]+");
  case Kind::HexUpper:
    if (Precision)
      return CreatePrecisionRegex("([1-9A-F][0-9A-F]*)?[0-9A-F]");
    return std::string("[0-9A-F]+");
  case Kind::HexLower:
    if (Precision)
      return CreatePrecisionRegex("([1-9a-f][0-9a-f]*)?[0-9a-f]");
    return std::string("[0-9a-f]+");
  default:
    return createStringError(std::errc::invalid_argument,
                             "trying to match value with invalid format");
  }
}

Expected<std::string>
ExpressionFormat::getMatchingString(ExpressionValue IntegerValue) const {
  uint64_t AbsoluteValue;
  StringRef SignPrefix = IntegerValue.isNegative() ? "-" : "";

  if (Value == Kind::Signed) {
    Expected<int64_t> SignedValue = IntegerValue.getSignedValue();
    if (!SignedValue)
      return SignedValue.takeError();
    if (*SignedValue < 0)
      AbsoluteValue = cantFail(IntegerValue.getAbsolute().getUnsignedValue());
    else
      AbsoluteValue = *SignedValue;
  } else {
    Expected<uint64_t> UnsignedValue = IntegerValue.getUnsignedValue();
    if (!UnsignedValue)
      return UnsignedValue.takeError();
    AbsoluteValue = *UnsignedValue;
  }

  std::string AbsoluteValueStr;
  switch (Value) {
  case Kind::Unsigned:
  case Kind::Signed:
    AbsoluteValueStr = utostr(AbsoluteValue);
    break;
  case Kind::HexUpper:
  case Kind::HexLower:
    AbsoluteValueStr = utohexstr(AbsoluteValue, Value == Kind::HexLower);
    break;
  default:
    return createStringError(std::errc::invalid_argument,
                             "trying to match value with invalid format");
  }

  if (Precision > AbsoluteValueStr.size()) {
    unsigned LeadingZeros = Precision - AbsoluteValueStr.size();
    return (Twine(SignPrefix) + std::string(LeadingZeros, '0') +
            AbsoluteValueStr)
        .str();
  }

  return (Twine(SignPrefix) + AbsoluteValueStr).str();
}

Expected<ExpressionValue>
ExpressionFormat::valueFromStringRepr(StringRef StrVal,
                                      const SourceMgr &SM) const {
  bool ValueIsSigned = Value == Kind::Signed;
  StringRef OverflowErrorStr = "unable to represent numeric value";
  if (ValueIsSigned) {
    int64_t SignedValue;

    if (StrVal.getAsInteger(10, SignedValue))
      return ErrorDiagnostic::get(SM, StrVal, OverflowErrorStr);

    return ExpressionValue(SignedValue);
  }

  bool Hex = Value == Kind::HexUpper || Value == Kind::HexLower;
  uint64_t UnsignedValue;
  if (StrVal.getAsInteger(Hex ? 16 : 10, UnsignedValue))
    return ErrorDiagnostic::get(SM, StrVal, OverflowErrorStr);

  return ExpressionValue(UnsignedValue);
}

static int64_t getAsSigned(uint64_t UnsignedValue) {
  // Use memcpy to reinterpret the bitpattern in Value since casting to
  // signed is implementation-defined if the unsigned value is too big to be
  // represented in the signed type and using an union violates type aliasing
  // rules.
  int64_t SignedValue;
  memcpy(&SignedValue, &UnsignedValue, sizeof(SignedValue));
  return SignedValue;
}

Expected<int64_t> ExpressionValue::getSignedValue() const {
  if (Negative)
    return getAsSigned(Value);

  if (Value > (uint64_t)std::numeric_limits<int64_t>::max())
    return make_error<OverflowError>();

  // Value is in the representable range of int64_t so we can use cast.
  return static_cast<int64_t>(Value);
}

Expected<uint64_t> ExpressionValue::getUnsignedValue() const {
  if (Negative)
    return make_error<OverflowError>();

  return Value;
}

ExpressionValue ExpressionValue::getAbsolute() const {
  if (!Negative)
    return *this;

  int64_t SignedValue = getAsSigned(Value);
  int64_t MaxInt64 = std::numeric_limits<int64_t>::max();
  // Absolute value can be represented as int64_t.
  if (SignedValue >= -MaxInt64)
    return ExpressionValue(-getAsSigned(Value));

  // -X == -(max int64_t + Rem), negate each component independently.
  SignedValue += MaxInt64;
  uint64_t RemainingValueAbsolute = -SignedValue;
  return ExpressionValue(MaxInt64 + RemainingValueAbsolute);
}

Expected<ExpressionValue> llvm::operator+(const ExpressionValue &LeftOperand,
                                          const ExpressionValue &RightOperand) {
  if (LeftOperand.isNegative() && RightOperand.isNegative()) {
    int64_t LeftValue = cantFail(LeftOperand.getSignedValue());
    int64_t RightValue = cantFail(RightOperand.getSignedValue());
    Optional<int64_t> Result = checkedAdd<int64_t>(LeftValue, RightValue);
    if (!Result)
      return make_error<OverflowError>();

    return ExpressionValue(*Result);
  }

  // (-A) + B == B - A.
  if (LeftOperand.isNegative())
    return RightOperand - LeftOperand.getAbsolute();

  // A + (-B) == A - B.
  if (RightOperand.isNegative())
    return LeftOperand - RightOperand.getAbsolute();

  // Both values are positive at this point.
  uint64_t LeftValue = cantFail(LeftOperand.getUnsignedValue());
  uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
  Optional<uint64_t> Result =
      checkedAddUnsigned<uint64_t>(LeftValue, RightValue);
  if (!Result)
    return make_error<OverflowError>();

  return ExpressionValue(*Result);
}

Expected<ExpressionValue> llvm::operator-(const ExpressionValue &LeftOperand,
                                          const ExpressionValue &RightOperand) {
  // Result will be negative and thus might underflow.
  if (LeftOperand.isNegative() && !RightOperand.isNegative()) {
    int64_t LeftValue = cantFail(LeftOperand.getSignedValue());
    uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
    // Result <= -1 - (max int64_t) which overflows on 1- and 2-complement.
    if (RightValue > (uint64_t)std::numeric_limits<int64_t>::max())
      return make_error<OverflowError>();
    Optional<int64_t> Result =
        checkedSub(LeftValue, static_cast<int64_t>(RightValue));
    if (!Result)
      return make_error<OverflowError>();

    return ExpressionValue(*Result);
  }

  // (-A) - (-B) == B - A.
  if (LeftOperand.isNegative())
    return RightOperand.getAbsolute() - LeftOperand.getAbsolute();

  // A - (-B) == A + B.
  if (RightOperand.isNegative())
    return LeftOperand + RightOperand.getAbsolute();

  // Both values are positive at this point.
  uint64_t LeftValue = cantFail(LeftOperand.getUnsignedValue());
  uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
  if (LeftValue >= RightValue)
    return ExpressionValue(LeftValue - RightValue);
  else {
    uint64_t AbsoluteDifference = RightValue - LeftValue;
    uint64_t MaxInt64 = std::numeric_limits<int64_t>::max();
    // Value might underflow.
    if (AbsoluteDifference > MaxInt64) {
      AbsoluteDifference -= MaxInt64;
      int64_t Result = -MaxInt64;
      int64_t MinInt64 = std::numeric_limits<int64_t>::min();
      // Underflow, tested by:
      //   abs(Result + (max int64_t)) > abs((min int64_t) + (max int64_t))
      if (AbsoluteDifference > static_cast<uint64_t>(-(MinInt64 - Result)))
        return make_error<OverflowError>();
      Result -= static_cast<int64_t>(AbsoluteDifference);
      return ExpressionValue(Result);
    }

    return ExpressionValue(-static_cast<int64_t>(AbsoluteDifference));
  }
}

Expected<ExpressionValue> llvm::operator*(const ExpressionValue &LeftOperand,
                                          const ExpressionValue &RightOperand) {
  // -A * -B == A * B
  if (LeftOperand.isNegative() && RightOperand.isNegative())
    return LeftOperand.getAbsolute() * RightOperand.getAbsolute();

  // A * -B == -B * A
  if (RightOperand.isNegative())
    return RightOperand * LeftOperand;

  assert(!RightOperand.isNegative() && "Unexpected negative operand!");

  // Result will be negative and can underflow.
  if (LeftOperand.isNegative()) {
    auto Result = LeftOperand.getAbsolute() * RightOperand.getAbsolute();
    if (!Result)
      return Result;

    return ExpressionValue(0) - *Result;
  }

  // Result will be positive and can overflow.
  uint64_t LeftValue = cantFail(LeftOperand.getUnsignedValue());
  uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
  Optional<uint64_t> Result =
      checkedMulUnsigned<uint64_t>(LeftValue, RightValue);
  if (!Result)
    return make_error<OverflowError>();

  return ExpressionValue(*Result);
}

Expected<ExpressionValue> llvm::operator/(const ExpressionValue &LeftOperand,
                                          const ExpressionValue &RightOperand) {
  // -A / -B == A / B
  if (LeftOperand.isNegative() && RightOperand.isNegative())
    return LeftOperand.getAbsolute() / RightOperand.getAbsolute();

  // Check for divide by zero.
  if (RightOperand == ExpressionValue(0))
    return make_error<OverflowError>();

  // Result will be negative and can underflow.
  if (LeftOperand.isNegative() || RightOperand.isNegative())
    return ExpressionValue(0) -
           cantFail(LeftOperand.getAbsolute() / RightOperand.getAbsolute());

  uint64_t LeftValue = cantFail(LeftOperand.getUnsignedValue());
  uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
  return ExpressionValue(LeftValue / RightValue);
}

Expected<ExpressionValue> llvm::max(const ExpressionValue &LeftOperand,
                                    const ExpressionValue &RightOperand) {
  if (LeftOperand.isNegative() && RightOperand.isNegative()) {
    int64_t LeftValue = cantFail(LeftOperand.getSignedValue());
    int64_t RightValue = cantFail(RightOperand.getSignedValue());
    return ExpressionValue(std::max(LeftValue, RightValue));
  }

  if (!LeftOperand.isNegative() && !RightOperand.isNegative()) {
    uint64_t LeftValue = cantFail(LeftOperand.getUnsignedValue());
    uint64_t RightValue = cantFail(RightOperand.getUnsignedValue());
    return ExpressionValue(std::max(LeftValue, RightValue));
  }

  if (LeftOperand.isNegative())
    return RightOperand;

  return LeftOperand;
}

Expected<ExpressionValue> llvm::min(const ExpressionValue &LeftOperand,
                                    const ExpressionValue &RightOperand) {
  if (cantFail(max(LeftOperand, RightOperand)) == LeftOperand)
    return RightOperand;

  return LeftOperand;
}

Expected<ExpressionValue> NumericVariableUse::eval() const {
  Optional<ExpressionValue> Value = Variable->getValue();
  if (Value)
    return *Value;

  return make_error<UndefVarError>(getExpressionStr());
}

Expected<ExpressionValue> BinaryOperation::eval() const {
  Expected<ExpressionValue> LeftOp = LeftOperand->eval();
  Expected<ExpressionValue> RightOp = RightOperand->eval();

  // Bubble up any error (e.g. undefined variables) in the recursive
  // evaluation.
  if (!LeftOp || !RightOp) {
    Error Err = Error::success();
    if (!LeftOp)
      Err = joinErrors(std::move(Err), LeftOp.takeError());
    if (!RightOp)
      Err = joinErrors(std::move(Err), RightOp.takeError());
    return std::move(Err);
  }

  return EvalBinop(*LeftOp, *RightOp);
}

Expected<ExpressionFormat>
BinaryOperation::getImplicitFormat(const SourceMgr &SM) const {
  Expected<ExpressionFormat> LeftFormat = LeftOperand->getImplicitFormat(SM);
  Expected<ExpressionFormat> RightFormat = RightOperand->getImplicitFormat(SM);
  if (!LeftFormat || !RightFormat) {
    Error Err = Error::success();
    if (!LeftFormat)
      Err = joinErrors(std::move(Err), LeftFormat.takeError());
    if (!RightFormat)
      Err = joinErrors(std::move(Err), RightFormat.takeError());
    return std::move(Err);
  }

  if (*LeftFormat != ExpressionFormat::Kind::NoFormat &&
      *RightFormat != ExpressionFormat::Kind::NoFormat &&
      *LeftFormat != *RightFormat)
    return ErrorDiagnostic::get(
        SM, getExpressionStr(),
        "implicit format conflict between '" + LeftOperand->getExpressionStr() +
            "' (" + LeftFormat->toString() + ") and '" +
            RightOperand->getExpressionStr() + "' (" + RightFormat->toString() +
            "), need an explicit format specifier");

  return *LeftFormat != ExpressionFormat::Kind::NoFormat ? *LeftFormat
                                                         : *RightFormat;
}

Expected<std::string> NumericSubstitution::getResult() const {
  assert(ExpressionPointer->getAST() != nullptr &&
         "Substituting empty expression");
  Expected<ExpressionValue> EvaluatedValue =
      ExpressionPointer->getAST()->eval();
  if (!EvaluatedValue)
    return EvaluatedValue.takeError();
  ExpressionFormat Format = ExpressionPointer->getFormat();
  return Format.getMatchingString(*EvaluatedValue);
}

Expected<std::string> StringSubstitution::getResult() const {
  // Look up the value and escape it so that we can put it into the regex.
  Expected<StringRef> VarVal = Context->getPatternVarValue(FromStr);
  if (!VarVal)
    return VarVal.takeError();
  return Regex::escape(*VarVal);
}

bool Pattern::isValidVarNameStart(char C) { return C == '_' || isAlpha(C); }

Expected<Pattern::VariableProperties>
Pattern::parseVariable(StringRef &Str, const SourceMgr &SM) {
  if (Str.empty())
    return ErrorDiagnostic::get(SM, Str, "empty variable name");

  size_t I = 0;
  bool IsPseudo = Str[0] == '@';

  // Global vars start with '$'.
  if (Str[0] == '$' || IsPseudo)
    ++I;

  if (!isValidVarNameStart(Str[I++]))
    return ErrorDiagnostic::get(SM, Str, "invalid variable name");

  for (size_t E = Str.size(); I != E; ++I)
    // Variable names are composed of alphanumeric characters and underscores.
    if (Str[I] != '_' && !isAlnum(Str[I]))
      break;

  StringRef Name = Str.take_front(I);
  Str = Str.substr(I);
  return VariableProperties {Name, IsPseudo};
}

// StringRef holding all characters considered as horizontal whitespaces by
// FileCheck input canonicalization.
constexpr StringLiteral SpaceChars = " \t";

// Parsing helper function that strips the first character in S and returns it.
static char popFront(StringRef &S) {
  char C = S.front();
  S = S.drop_front();
  return C;
}

char OverflowError::ID = 0;
char UndefVarError::ID = 0;
char ErrorDiagnostic::ID = 0;
char NotFoundError::ID = 0;

Expected<NumericVariable *> Pattern::parseNumericVariableDefinition(
    StringRef &Expr, FileCheckPatternContext *Context,
    Optional<size_t> LineNumber, ExpressionFormat ImplicitFormat,
    const SourceMgr &SM) {
  Expected<VariableProperties> ParseVarResult = parseVariable(Expr, SM);
  if (!ParseVarResult)
    return ParseVarResult.takeError();
  StringRef Name = ParseVarResult->Name;

  if (ParseVarResult->IsPseudo)
    return ErrorDiagnostic::get(
        SM, Name, "definition of pseudo numeric variable unsupported");

  // Detect collisions between string and numeric variables when the latter
  // is created later than the former.
  if (Context->DefinedVariableTable.find(Name) !=
      Context->DefinedVariableTable.end())
    return ErrorDiagnostic::get(
        SM, Name, "string variable with name '" + Name + "' already exists");

  Expr = Expr.ltrim(SpaceChars);
  if (!Expr.empty())
    return ErrorDiagnostic::get(
        SM, Expr, "unexpected characters after numeric variable name");

  NumericVariable *DefinedNumericVariable;
  auto VarTableIter = Context->GlobalNumericVariableTable.find(Name);
  if (VarTableIter != Context->GlobalNumericVariableTable.end()) {
    DefinedNumericVariable = VarTableIter->second;
    if (DefinedNumericVariable->getImplicitFormat() != ImplicitFormat)
      return ErrorDiagnostic::get(
          SM, Expr, "format different from previous variable definition");
  } else
    DefinedNumericVariable =
        Context->makeNumericVariable(Name, ImplicitFormat, LineNumber);

  return DefinedNumericVariable;
}

Expected<std::unique_ptr<NumericVariableUse>> Pattern::parseNumericVariableUse(
    StringRef Name, bool IsPseudo, Optional<size_t> LineNumber,
    FileCheckPatternContext *Context, const SourceMgr &SM) {
  if (IsPseudo && !Name.equals("@LINE"))
    return ErrorDiagnostic::get(
        SM, Name, "invalid pseudo numeric variable '" + Name + "'");

  // Numeric variable definitions and uses are parsed in the order in which
  // they appear in the CHECK patterns. For each definition, the pointer to the
  // class instance of the corresponding numeric variable definition is stored
  // in GlobalNumericVariableTable in parsePattern. Therefore, if the pointer
  // we get below is null, it means no such variable was defined before. When
  // that happens, we create a dummy variable so that parsing can continue. All
  // uses of undefined variables, whether string or numeric, are then diagnosed
  // in printSubstitutions() after failing to match.
  auto VarTableIter = Context->GlobalNumericVariableTable.find(Name);
  NumericVariable *NumericVariable;
  if (VarTableIter != Context->GlobalNumericVariableTable.end())
    NumericVariable = VarTableIter->second;
  else {
    NumericVariable = Context->makeNumericVariable(
        Name, ExpressionFormat(ExpressionFormat::Kind::Unsigned));
    Context->GlobalNumericVariableTable[Name] = NumericVariable;
  }

  Optional<size_t> DefLineNumber = NumericVariable->getDefLineNumber();
  if (DefLineNumber && LineNumber && *DefLineNumber == *LineNumber)
    return ErrorDiagnostic::get(
        SM, Name,
        "numeric variable '" + Name +
            "' defined earlier in the same CHECK directive");

  return std::make_unique<NumericVariableUse>(Name, NumericVariable);
}

Expected<std::unique_ptr<ExpressionAST>> Pattern::parseNumericOperand(
    StringRef &Expr, AllowedOperand AO, bool MaybeInvalidConstraint,
    Optional<size_t> LineNumber, FileCheckPatternContext *Context,
    const SourceMgr &SM) {
  if (Expr.startswith("(")) {
    if (AO != AllowedOperand::Any)
      return ErrorDiagnostic::get(
          SM, Expr, "parenthesized expression not permitted here");
    return parseParenExpr(Expr, LineNumber, Context, SM);
  }

  if (AO == AllowedOperand::LineVar || AO == AllowedOperand::Any) {
    // Try to parse as a numeric variable use.
    Expected<Pattern::VariableProperties> ParseVarResult =
        parseVariable(Expr, SM);
    if (ParseVarResult) {
      // Try to parse a function call.
      if (Expr.ltrim(SpaceChars).startswith("(")) {
        if (AO != AllowedOperand::Any)
          return ErrorDiagnostic::get(SM, ParseVarResult->Name,
                                      "unexpected function call");

        return parseCallExpr(Expr, ParseVarResult->Name, LineNumber, Context,
                             SM);
      }

      return parseNumericVariableUse(ParseVarResult->Name,
                                     ParseVarResult->IsPseudo, LineNumber,
                                     Context, SM);
    }

    if (AO == AllowedOperand::LineVar)
      return ParseVarResult.takeError();
    // Ignore the error and retry parsing as a literal.
    consumeError(ParseVarResult.takeError());
  }

  // Otherwise, parse it as a literal.
  int64_t SignedLiteralValue;
  uint64_t UnsignedLiteralValue;
  StringRef SaveExpr = Expr;
  // Accept both signed and unsigned literal, default to signed literal.
  if (!Expr.consumeInteger((AO == AllowedOperand::LegacyLiteral) ? 10 : 0,
                           UnsignedLiteralValue))
    return std::make_unique<ExpressionLiteral>(SaveExpr.drop_back(Expr.size()),
                                               UnsignedLiteralValue);
  Expr = SaveExpr;
  if (AO == AllowedOperand::Any && !Expr.consumeInteger(0, SignedLiteralValue))
    return std::make_unique<ExpressionLiteral>(SaveExpr.drop_back(Expr.size()),
                                               SignedLiteralValue);

  return ErrorDiagnostic::get(
      SM, Expr,
      Twine("invalid ") +
          (MaybeInvalidConstraint ? "matching constraint or " : "") +
          "operand format");
}

Expected<std::unique_ptr<ExpressionAST>>
Pattern::parseParenExpr(StringRef &Expr, Optional<size_t> LineNumber,
                        FileCheckPatternContext *Context, const SourceMgr &SM) {
  Expr = Expr.ltrim(SpaceChars);
  assert(Expr.startswith("("));

  // Parse right operand.
  Expr.consume_front("(");
  Expr = Expr.ltrim(SpaceChars);
  if (Expr.empty())
    return ErrorDiagnostic::get(SM, Expr, "missing operand in expression");

  // Note: parseNumericOperand handles nested opening parentheses.
  Expected<std::unique_ptr<ExpressionAST>> SubExprResult = parseNumericOperand(
      Expr, AllowedOperand::Any, /*MaybeInvalidConstraint=*/false, LineNumber,
      Context, SM);
  Expr = Expr.ltrim(SpaceChars);
  while (SubExprResult && !Expr.empty() && !Expr.startswith(")")) {
    StringRef OrigExpr = Expr;
    SubExprResult = parseBinop(OrigExpr, Expr, std::move(*SubExprResult), false,
                               LineNumber, Context, SM);
    Expr = Expr.ltrim(SpaceChars);
  }
  if (!SubExprResult)
    return SubExprResult;

  if (!Expr.consume_front(")")) {
    return ErrorDiagnostic::get(SM, Expr,
                                "missing ')' at end of nested expression");
  }
  return SubExprResult;
}

Expected<std::unique_ptr<ExpressionAST>>
Pattern::parseBinop(StringRef Expr, StringRef &RemainingExpr,
                    std::unique_ptr<ExpressionAST> LeftOp,
                    bool IsLegacyLineExpr, Optional<size_t> LineNumber,
                    FileCheckPatternContext *Context, const SourceMgr &SM) {
  RemainingExpr = RemainingExpr.ltrim(SpaceChars);
  if (RemainingExpr.empty())
    return std::move(LeftOp);

  // Check if this is a supported operation and select a function to perform
  // it.
  SMLoc OpLoc = SMLoc::getFromPointer(RemainingExpr.data());
  char Operator = popFront(RemainingExpr);
  binop_eval_t EvalBinop;
  switch (Operator) {
  case '+':
    EvalBinop = operator+;
    break;
  case '-':
    EvalBinop = operator-;
    break;
  default:
    return ErrorDiagnostic::get(
        SM, OpLoc, Twine("unsupported operation '") + Twine(Operator) + "'");
  }

  // Parse right operand.
  RemainingExpr = RemainingExpr.ltrim(SpaceChars);
  if (RemainingExpr.empty())
    return ErrorDiagnostic::get(SM, RemainingExpr,
                                "missing operand in expression");
  // The second operand in a legacy @LINE expression is always a literal.
  AllowedOperand AO =
      IsLegacyLineExpr ? AllowedOperand::LegacyLiteral : AllowedOperand::Any;
  Expected<std::unique_ptr<ExpressionAST>> RightOpResult =
      parseNumericOperand(RemainingExpr, AO, /*MaybeInvalidConstraint=*/false,
                          LineNumber, Context, SM);
  if (!RightOpResult)
    return RightOpResult;

  Expr = Expr.drop_back(RemainingExpr.size());
  return std::make_unique<BinaryOperation>(Expr, EvalBinop, std::move(LeftOp),
                                           std::move(*RightOpResult));
}

Expected<std::unique_ptr<ExpressionAST>>
Pattern::parseCallExpr(StringRef &Expr, StringRef FuncName,
                       Optional<size_t> LineNumber,
                       FileCheckPatternContext *Context, const SourceMgr &SM) {
  Expr = Expr.ltrim(SpaceChars);
  assert(Expr.startswith("("));

  auto OptFunc = StringSwitch<Optional<binop_eval_t>>(FuncName)
                     .Case("add", operator+)
                     .Case("div", operator/)
                     .Case("max", max)
                     .Case("min", min)
                     .Case("mul", operator*)
                     .Case("sub", operator-)
                     .Default(None);

  if (!OptFunc)
    return ErrorDiagnostic::get(
        SM, FuncName, Twine("call to undefined function '") + FuncName + "'");

  Expr.consume_front("(");
  Expr = Expr.ltrim(SpaceChars);

  // Parse call arguments, which are comma separated.
  SmallVector<std::unique_ptr<ExpressionAST>, 4> Args;
  while (!Expr.empty() && !Expr.startswith(")")) {
    if (Expr.startswith(","))
      return ErrorDiagnostic::get(SM, Expr, "missing argument");

    // Parse the argument, which is an arbitary expression.
    StringRef OuterBinOpExpr = Expr;
    Expected<std::unique_ptr<ExpressionAST>> Arg = parseNumericOperand(
        Expr, AllowedOperand::Any, /*MaybeInvalidConstraint=*/false, LineNumber,
        Context, SM);
    while (Arg && !Expr.empty()) {
      Expr = Expr.ltrim(SpaceChars);
      // Have we reached an argument terminator?
      if (Expr.startswith(",") || Expr.startswith(")"))
        break;

      // Arg = Arg <op> <expr>
      Arg = parseBinop(OuterBinOpExpr, Expr, std::move(*Arg), false, LineNumber,
                       Context, SM);
    }

    // Prefer an expression error over a generic invalid argument message.
    if (!Arg)
      return Arg.takeError();
    Args.push_back(std::move(*Arg));

    // Have we parsed all available arguments?
    Expr = Expr.ltrim(SpaceChars);
    if (!Expr.consume_front(","))
      break;

    Expr = Expr.ltrim(SpaceChars);
    if (Expr.startswith(")"))
      return ErrorDiagnostic::get(SM, Expr, "missing argument");
  }

  if (!Expr.consume_front(")"))
    return ErrorDiagnostic::get(SM, Expr,
                                "missing ')' at end of call expression");

  const unsigned NumArgs = Args.size();
  if (NumArgs == 2)
    return std::make_unique<BinaryOperation>(Expr, *OptFunc, std::move(Args[0]),
                                             std::move(Args[1]));

  // TODO: Support more than binop_eval_t.
  return ErrorDiagnostic::get(SM, FuncName,
                              Twine("function '") + FuncName +
                                  Twine("' takes 2 arguments but ") +
                                  Twine(NumArgs) + " given");
}

Expected<std::unique_ptr<Expression>> Pattern::parseNumericSubstitutionBlock(
    StringRef Expr, Optional<NumericVariable *> &DefinedNumericVariable,
    bool IsLegacyLineExpr, Optional<size_t> LineNumber,
    FileCheckPatternContext *Context, const SourceMgr &SM) {
  std::unique_ptr<ExpressionAST> ExpressionASTPointer = nullptr;
  StringRef DefExpr = StringRef();
  DefinedNumericVariable = None;
  ExpressionFormat ExplicitFormat = ExpressionFormat();
  unsigned Precision = 0;

  // Parse format specifier (NOTE: ',' is also an argument seperator).
  size_t FormatSpecEnd = Expr.find(',');
  size_t FunctionStart = Expr.find('(');
  if (FormatSpecEnd != StringRef::npos && FormatSpecEnd < FunctionStart) {
    StringRef FormatExpr = Expr.take_front(FormatSpecEnd);
    Expr = Expr.drop_front(FormatSpecEnd + 1);
    FormatExpr = FormatExpr.trim(SpaceChars);
    if (!FormatExpr.consume_front("%"))
      return ErrorDiagnostic::get(
          SM, FormatExpr,
          "invalid matching format specification in expression");

    // Parse precision.
    if (FormatExpr.consume_front(".")) {
      if (FormatExpr.consumeInteger(10, Precision))
        return ErrorDiagnostic::get(SM, FormatExpr,
                                    "invalid precision in format specifier");
    }

    if (!FormatExpr.empty()) {
      // Check for unknown matching format specifier and set matching format in
      // class instance representing this expression.
      SMLoc FmtLoc = SMLoc::getFromPointer(FormatExpr.data());
      switch (popFront(FormatExpr)) {
      case 'u':
        ExplicitFormat =
            ExpressionFormat(ExpressionFormat::Kind::Unsigned, Precision);
        break;
      case 'd':
        ExplicitFormat =
            ExpressionFormat(ExpressionFormat::Kind::Signed, Precision);
        break;
      case 'x':
        ExplicitFormat =
            ExpressionFormat(ExpressionFormat::Kind::HexLower, Precision);
        break;
      case 'X':
        ExplicitFormat =
            ExpressionFormat(ExpressionFormat::Kind::HexUpper, Precision);
        break;
      default:
        return ErrorDiagnostic::get(SM, FmtLoc,
                                    "invalid format specifier in expression");
      }
    }

    FormatExpr = FormatExpr.ltrim(SpaceChars);
    if (!FormatExpr.empty())
      return ErrorDiagnostic::get(
          SM, FormatExpr,
          "invalid matching format specification in expression");
  }

  // Save variable definition expression if any.
  size_t DefEnd = Expr.find(':');
  if (DefEnd != StringRef::npos) {
    DefExpr = Expr.substr(0, DefEnd);
    Expr = Expr.substr(DefEnd + 1);
  }

  // Parse matching constraint.
  Expr = Expr.ltrim(SpaceChars);
  bool HasParsedValidConstraint = false;
  if (Expr.consume_front("=="))
    HasParsedValidConstraint = true;

  // Parse the expression itself.
  Expr = Expr.ltrim(SpaceChars);
  if (Expr.empty()) {
    if (HasParsedValidConstraint)
      return ErrorDiagnostic::get(
          SM, Expr, "empty numeric expression should not have a constraint");
  } else {
    Expr = Expr.rtrim(SpaceChars);
    StringRef OuterBinOpExpr = Expr;
    // The first operand in a legacy @LINE expression is always the @LINE
    // pseudo variable.
    AllowedOperand AO =
        IsLegacyLineExpr ? AllowedOperand::LineVar : AllowedOperand::Any;
    Expected<std::unique_ptr<ExpressionAST>> ParseResult = parseNumericOperand(
        Expr, AO, !HasParsedValidConstraint, LineNumber, Context, SM);
    while (ParseResult && !Expr.empty()) {
      ParseResult = parseBinop(OuterBinOpExpr, Expr, std::move(*ParseResult),
                               IsLegacyLineExpr, LineNumber, Context, SM);
      // Legacy @LINE expressions only allow 2 operands.
      if (ParseResult && IsLegacyLineExpr && !Expr.empty())
        return ErrorDiagnostic::get(
            SM, Expr,
            "unexpected characters at end of expression '" + Expr + "'");
    }
    if (!ParseResult)
      return ParseResult.takeError();
    ExpressionASTPointer = std::move(*ParseResult);
  }

  // Select format of the expression, i.e. (i) its explicit format, if any,
  // otherwise (ii) its implicit format, if any, otherwise (iii) the default
  // format (unsigned). Error out in case of conflicting implicit format
  // without explicit format.
  ExpressionFormat Format;
  if (ExplicitFormat)
    Format = ExplicitFormat;
  else if (ExpressionASTPointer) {
    Expected<ExpressionFormat> ImplicitFormat =
        ExpressionASTPointer->getImplicitFormat(SM);
    if (!ImplicitFormat)
      return ImplicitFormat.takeError();
    Format = *ImplicitFormat;
  }
  if (!Format)
    Format = ExpressionFormat(ExpressionFormat::Kind::Unsigned, Precision);

  std::unique_ptr<Expression> ExpressionPointer =
      std::make_unique<Expression>(std::move(ExpressionASTPointer), Format);

  // Parse the numeric variable definition.
  if (DefEnd != StringRef::npos) {
    DefExpr = DefExpr.ltrim(SpaceChars);
    Expected<NumericVariable *> ParseResult = parseNumericVariableDefinition(
        DefExpr, Context, LineNumber, ExpressionPointer->getFormat(), SM);

    if (!ParseResult)
      return ParseResult.takeError();
    DefinedNumericVariable = *ParseResult;
  }

  return std::move(ExpressionPointer);
}

bool Pattern::parsePattern(StringRef PatternStr, StringRef Prefix,
                           SourceMgr &SM, const FileCheckRequest &Req) {
  bool MatchFullLinesHere = Req.MatchFullLines && CheckTy != Check::CheckNot;
  IgnoreCase = Req.IgnoreCase;

  PatternLoc = SMLoc::getFromPointer(PatternStr.data());

  if (!(Req.NoCanonicalizeWhiteSpace && Req.MatchFullLines))
    // Ignore trailing whitespace.
    while (!PatternStr.empty() &&
           (PatternStr.back() == ' ' || PatternStr.back() == '\t'))
      PatternStr = PatternStr.substr(0, PatternStr.size() - 1);

  // Check that there is something on the line.
  if (PatternStr.empty() && CheckTy != Check::CheckEmpty) {
    SM.PrintMessage(PatternLoc, SourceMgr::DK_Error,
                    "found empty check string with prefix '" + Prefix + ":'");
    return true;
  }

  if (!PatternStr.empty() && CheckTy == Check::CheckEmpty) {
    SM.PrintMessage(
        PatternLoc, SourceMgr::DK_Error,
        "found non-empty check string for empty check with prefix '" + Prefix +
            ":'");
    return true;
  }

  if (CheckTy == Check::CheckEmpty) {
    RegExStr = "(\n$)";
    return false;
  }

  // If literal check, set fixed string.
  if (CheckTy.isLiteralMatch()) {
    FixedStr = PatternStr;
    return false;
  }

  // Check to see if this is a fixed string, or if it has regex pieces.
  if (!MatchFullLinesHere &&
      (PatternStr.size() < 2 || (PatternStr.find("{{") == StringRef::npos &&
                                 PatternStr.find("[[") == StringRef::npos))) {
    FixedStr = PatternStr;
    return false;
  }

  if (MatchFullLinesHere) {
    RegExStr += '^';
    if (!Req.NoCanonicalizeWhiteSpace)
      RegExStr += " *";
  }

  // Paren value #0 is for the fully matched string.  Any new parenthesized
  // values add from there.
  unsigned CurParen = 1;

  // Otherwise, there is at least one regex piece.  Build up the regex pattern
  // by escaping scary characters in fixed strings, building up one big regex.
  while (!PatternStr.empty()) {
    // RegEx matches.
    if (PatternStr.startswith("{{")) {
      // This is the start of a regex match.  Scan for the }}.
      size_t End = PatternStr.find("}}");
      if (End == StringRef::npos) {
        SM.PrintMessage(SMLoc::getFromPointer(PatternStr.data()),
                        SourceMgr::DK_Error,
                        "found start of regex string with no end '}}'");
        return true;
      }

      // Enclose {{}} patterns in parens just like [[]] even though we're not
      // capturing the result for any purpose.  This is required in case the
      // expression contains an alternation like: CHECK:  abc{{x|z}}def.  We
      // want this to turn into: "abc(x|z)def" not "abcx|zdef".
      RegExStr += '(';
      ++CurParen;

      if (AddRegExToRegEx(PatternStr.substr(2, End - 2), CurParen, SM))
        return true;
      RegExStr += ')';

      PatternStr = PatternStr.substr(End + 2);
      continue;
    }

    // String and numeric substitution blocks. Pattern substitution blocks come
    // in two forms: [[foo:.*]] and [[foo]]. The former matches .* (or some
    // other regex) and assigns it to the string variable 'foo'. The latter
    // substitutes foo's value. Numeric substitution blocks recognize the same
    // form as string ones, but start with a '#' sign after the double
    // brackets. They also accept a combined form which sets a numeric variable
    // to the evaluation of an expression. Both string and numeric variable
    // names must satisfy the regular expression "[a-zA-Z_][0-9a-zA-Z_]*" to be
    // valid, as this helps catch some common errors.
    if (PatternStr.startswith("[[")) {
      StringRef UnparsedPatternStr = PatternStr.substr(2);
      // Find the closing bracket pair ending the match.  End is going to be an
      // offset relative to the beginning of the match string.
      size_t End = FindRegexVarEnd(UnparsedPatternStr, SM);
      StringRef MatchStr = UnparsedPatternStr.substr(0, End);
      bool IsNumBlock = MatchStr.consume_front("#");

      if (End == StringRef::npos) {
        SM.PrintMessage(SMLoc::getFromPointer(PatternStr.data()),
                        SourceMgr::DK_Error,
                        "Invalid substitution block, no ]] found");
        return true;
      }
      // Strip the substitution block we are parsing. End points to the start
      // of the "]]" closing the expression so account for it in computing the
      // index of the first unparsed character.
      PatternStr = UnparsedPatternStr.substr(End + 2);

      bool IsDefinition = false;
      bool SubstNeeded = false;
      // Whether the substitution block is a legacy use of @LINE with string
      // substitution block syntax.
      bool IsLegacyLineExpr = false;
      StringRef DefName;
      StringRef SubstStr;
      std::string MatchRegexp;
      size_t SubstInsertIdx = RegExStr.size();

      // Parse string variable or legacy @LINE expression.
      if (!IsNumBlock) {
        size_t VarEndIdx = MatchStr.find(':');
        size_t SpacePos = MatchStr.substr(0, VarEndIdx).find_first_of(" \t");
        if (SpacePos != StringRef::npos) {
          SM.PrintMessage(SMLoc::getFromPointer(MatchStr.data() + SpacePos),
                          SourceMgr::DK_Error, "unexpected whitespace");
          return true;
        }

        // Get the name (e.g. "foo") and verify it is well formed.
        StringRef OrigMatchStr = MatchStr;
        Expected<Pattern::VariableProperties> ParseVarResult =
            parseVariable(MatchStr, SM);
        if (!ParseVarResult) {
          logAllUnhandledErrors(ParseVarResult.takeError(), errs());
          return true;
        }
        StringRef Name = ParseVarResult->Name;
        bool IsPseudo = ParseVarResult->IsPseudo;

        IsDefinition = (VarEndIdx != StringRef::npos);
        SubstNeeded = !IsDefinition;
        if (IsDefinition) {
          if ((IsPseudo || !MatchStr.consume_front(":"))) {
            SM.PrintMessage(SMLoc::getFromPointer(Name.data()),
                            SourceMgr::DK_Error,
                            "invalid name in string variable definition");
            return true;
          }

          // Detect collisions between string and numeric variables when the
          // former is created later than the latter.
          if (Context->GlobalNumericVariableTable.find(Name) !=
              Context->GlobalNumericVariableTable.end()) {
            SM.PrintMessage(
                SMLoc::getFromPointer(Name.data()), SourceMgr::DK_Error,
                "numeric variable with name '" + Name + "' already exists");
            return true;
          }
          DefName = Name;
          MatchRegexp = MatchStr.str();
        } else {
          if (IsPseudo) {
            MatchStr = OrigMatchStr;
            IsLegacyLineExpr = IsNumBlock = true;
          } else
            SubstStr = Name;
        }
      }

      // Parse numeric substitution block.
      std::unique_ptr<Expression> ExpressionPointer;
      Optional<NumericVariable *> DefinedNumericVariable;
      if (IsNumBlock) {
        Expected<std::unique_ptr<Expression>> ParseResult =
            parseNumericSubstitutionBlock(MatchStr, DefinedNumericVariable,
                                          IsLegacyLineExpr, LineNumber, Context,
                                          SM);
        if (!ParseResult) {
          logAllUnhandledErrors(ParseResult.takeError(), errs());
          return true;
        }
        ExpressionPointer = std::move(*ParseResult);
        SubstNeeded = ExpressionPointer->getAST() != nullptr;
        if (DefinedNumericVariable) {
          IsDefinition = true;
          DefName = (*DefinedNumericVariable)->getName();
        }
        if (SubstNeeded)
          SubstStr = MatchStr;
        else {
          ExpressionFormat Format = ExpressionPointer->getFormat();
          MatchRegexp = cantFail(Format.getWildcardRegex());
        }
      }

      // Handle variable definition: [[<def>:(...)]] and [[#(...)<def>:(...)]].
      if (IsDefinition) {
        RegExStr += '(';
        ++SubstInsertIdx;

        if (IsNumBlock) {
          NumericVariableMatch NumericVariableDefinition = {
              *DefinedNumericVariable, CurParen};
          NumericVariableDefs[DefName] = NumericVariableDefinition;
          // This store is done here rather than in match() to allow
          // parseNumericVariableUse() to get the pointer to the class instance
          // of the right variable definition corresponding to a given numeric
          // variable use.
          Context->GlobalNumericVariableTable[DefName] =
              *DefinedNumericVariable;
        } else {
          VariableDefs[DefName] = CurParen;
          // Mark string variable as defined to detect collisions between
          // string and numeric variables in parseNumericVariableUse() and
          // defineCmdlineVariables() when the latter is created later than the
          // former. We cannot reuse GlobalVariableTable for this by populating
          // it with an empty string since we would then lose the ability to
          // detect the use of an undefined variable in match().
          Context->DefinedVariableTable[DefName] = true;
        }

        ++CurParen;
      }

      if (!MatchRegexp.empty() && AddRegExToRegEx(MatchRegexp, CurParen, SM))
        return true;

      if (IsDefinition)
        RegExStr += ')';

      // Handle substitutions: [[foo]] and [[#<foo expr>]].
      if (SubstNeeded) {
        // Handle substitution of string variables that were defined earlier on
        // the same line by emitting a backreference. Expressions do not
        // support substituting a numeric variable defined on the same line.
        if (!IsNumBlock && VariableDefs.find(SubstStr) != VariableDefs.end()) {
          unsigned CaptureParenGroup = VariableDefs[SubstStr];
          if (CaptureParenGroup < 1 || CaptureParenGroup > 9) {
            SM.PrintMessage(SMLoc::getFromPointer(SubstStr.data()),
                            SourceMgr::DK_Error,
                            "Can't back-reference more than 9 variables");
            return true;
          }
          AddBackrefToRegEx(CaptureParenGroup);
        } else {
          // Handle substitution of string variables ([[<var>]]) defined in
          // previous CHECK patterns, and substitution of expressions.
          Substitution *Substitution =
              IsNumBlock
                  ? Context->makeNumericSubstitution(
                        SubstStr, std::move(ExpressionPointer), SubstInsertIdx)
                  : Context->makeStringSubstitution(SubstStr, SubstInsertIdx);
          Substitutions.push_back(Substitution);
        }
      }
    }

    // Handle fixed string matches.
    // Find the end, which is the start of the next regex.
    size_t FixedMatchEnd = PatternStr.find("{{");
    FixedMatchEnd = std::min(FixedMatchEnd, PatternStr.find("[["));
    RegExStr += Regex::escape(PatternStr.substr(0, FixedMatchEnd));
    PatternStr = PatternStr.substr(FixedMatchEnd);
  }

  if (MatchFullLinesHere) {
    if (!Req.NoCanonicalizeWhiteSpace)
      RegExStr += " *";
    RegExStr += '$';
  }

  return false;
}

bool Pattern::AddRegExToRegEx(StringRef RS, unsigned &CurParen, SourceMgr &SM) {
  Regex R(RS);
  std::string Error;
  if (!R.isValid(Error)) {
    SM.PrintMessage(SMLoc::getFromPointer(RS.data()), SourceMgr::DK_Error,
                    "invalid regex: " + Error);
    return true;
  }

  RegExStr += RS.str();
  CurParen += R.getNumMatches();
  return false;
}

void Pattern::AddBackrefToRegEx(unsigned BackrefNum) {
  assert(BackrefNum >= 1 && BackrefNum <= 9 && "Invalid backref number");
  std::string Backref = std::string("\\") + std::string(1, '0' + BackrefNum);
  RegExStr += Backref;
}

Expected<size_t> Pattern::match(StringRef Buffer, size_t &MatchLen,
                                const SourceMgr &SM) const {
  // If this is the EOF pattern, match it immediately.
  if (CheckTy == Check::CheckEOF) {
    MatchLen = 0;
    return Buffer.size();
  }

  // If this is a fixed string pattern, just match it now.
  if (!FixedStr.empty()) {
    MatchLen = FixedStr.size();
    size_t Pos =
        IgnoreCase ? Buffer.find_lower(FixedStr) : Buffer.find(FixedStr);
    if (Pos == StringRef::npos)
      return make_error<NotFoundError>();
    return Pos;
  }

  // Regex match.

  // If there are substitutions, we need to create a temporary string with the
  // actual value.
  StringRef RegExToMatch = RegExStr;
  std::string TmpStr;
  if (!Substitutions.empty()) {
    TmpStr = RegExStr;
    if (LineNumber)
      Context->LineVariable->setValue(ExpressionValue(*LineNumber));

    size_t InsertOffset = 0;
    // Substitute all string variables and expressions whose values are only
    // now known. Use of string variables defined on the same line are handled
    // by back-references.
    for (const auto &Substitution : Substitutions) {
      // Substitute and check for failure (e.g. use of undefined variable).
      Expected<std::string> Value = Substitution->getResult();
      if (!Value) {
        // Convert to an ErrorDiagnostic to get location information. This is
        // done here rather than PrintNoMatch since now we know which
        // substitution block caused the overflow.
        Error Err =
            handleErrors(Value.takeError(), [&](const OverflowError &E) {
              return ErrorDiagnostic::get(SM, Substitution->getFromString(),
                                          "unable to substitute variable or "
                                          "numeric expression: overflow error");
            });
        return std::move(Err);
      }

      // Plop it into the regex at the adjusted offset.
      TmpStr.insert(TmpStr.begin() + Substitution->getIndex() + InsertOffset,
                    Value->begin(), Value->end());
      InsertOffset += Value->size();
    }

    // Match the newly constructed regex.
    RegExToMatch = TmpStr;
  }

  SmallVector<StringRef, 4> MatchInfo;
  unsigned int Flags = Regex::Newline;
  if (IgnoreCase)
    Flags |= Regex::IgnoreCase;
  if (!Regex(RegExToMatch, Flags).match(Buffer, &MatchInfo))
    return make_error<NotFoundError>();

  // Successful regex match.
  assert(!MatchInfo.empty() && "Didn't get any match");
  StringRef FullMatch = MatchInfo[0];

  // If this defines any string variables, remember their values.
  for (const auto &VariableDef : VariableDefs) {
    assert(VariableDef.second < MatchInfo.size() && "Internal paren error");
    Context->GlobalVariableTable[VariableDef.first] =
        MatchInfo[VariableDef.second];
  }

  // If this defines any numeric variables, remember their values.
  for (const auto &NumericVariableDef : NumericVariableDefs) {
    const NumericVariableMatch &NumericVariableMatch =
        NumericVariableDef.getValue();
    unsigned CaptureParenGroup = NumericVariableMatch.CaptureParenGroup;
    assert(CaptureParenGroup < MatchInfo.size() && "Internal paren error");
    NumericVariable *DefinedNumericVariable =
        NumericVariableMatch.DefinedNumericVariable;

    StringRef MatchedValue = MatchInfo[CaptureParenGroup];
    ExpressionFormat Format = DefinedNumericVariable->getImplicitFormat();
    Expected<ExpressionValue> Value =
        Format.valueFromStringRepr(MatchedValue, SM);
    if (!Value)
      return Value.takeError();
    DefinedNumericVariable->setValue(*Value, MatchedValue);
  }

  // Like CHECK-NEXT, CHECK-EMPTY's match range is considered to start after
  // the required preceding newline, which is consumed by the pattern in the
  // case of CHECK-EMPTY but not CHECK-NEXT.
  size_t MatchStartSkip = CheckTy == Check::CheckEmpty;
  MatchLen = FullMatch.size() - MatchStartSkip;
  return FullMatch.data() - Buffer.data() + MatchStartSkip;
}

unsigned Pattern::computeMatchDistance(StringRef Buffer) const {
  // Just compute the number of matching characters. For regular expressions, we
  // just compare against the regex itself and hope for the best.
  //
  // FIXME: One easy improvement here is have the regex lib generate a single
  // example regular expression which matches, and use that as the example
  // string.
  StringRef ExampleString(FixedStr);
  if (ExampleString.empty())
    ExampleString = RegExStr;

  // Only compare up to the first line in the buffer, or the string size.
  StringRef BufferPrefix = Buffer.substr(0, ExampleString.size());
  BufferPrefix = BufferPrefix.split('\n').first;
  return BufferPrefix.edit_distance(ExampleString);
}

void Pattern::printSubstitutions(const SourceMgr &SM, StringRef Buffer,
                                 SMRange Range,
                                 FileCheckDiag::MatchType MatchTy,
                                 std::vector<FileCheckDiag> *Diags) const {
  // Print what we know about substitutions.
  if (!Substitutions.empty()) {
    for (const auto &Substitution : Substitutions) {
      SmallString<256> Msg;
      raw_svector_ostream OS(Msg);
      Expected<std::string> MatchedValue = Substitution->getResult();

      // Substitution failed or is not known at match time, print the undefined
      // variables it uses.
      if (!MatchedValue) {
        bool UndefSeen = false;
        handleAllErrors(
            MatchedValue.takeError(), [](const NotFoundError &E) {},
            // Handled in PrintNoMatch().
            [](const ErrorDiagnostic &E) {},
            // Handled in match().
            [](const OverflowError &E) {},
            [&](const UndefVarError &E) {
              if (!UndefSeen) {
                OS << "uses undefined variable(s):";
                UndefSeen = true;
              }
              OS << " ";
              E.log(OS);
            });
      } else {
        // Substitution succeeded. Print substituted value.
        OS << "with \"";
        OS.write_escaped(Substitution->getFromString()) << "\" equal to \"";
        OS.write_escaped(*MatchedValue) << "\"";
      }

      // We report only the start of the match/search range to suggest we are
      // reporting the substitutions as set at the start of the match/search.
      // Indicating a non-zero-length range might instead seem to imply that the
      // substitution matches or was captured from exactly that range.
      if (Diags)
        Diags->emplace_back(SM, CheckTy, getLoc(), MatchTy,
                            SMRange(Range.Start, Range.Start), OS.str());
      else
        SM.PrintMessage(Range.Start, SourceMgr::DK_Note, OS.str());
    }
  }
}

void Pattern::printVariableDefs(const SourceMgr &SM,
                                FileCheckDiag::MatchType MatchTy,
                                std::vector<FileCheckDiag> *Diags) const {
  if (VariableDefs.empty() && NumericVariableDefs.empty())
    return;
  // Build list of variable captures.
  struct VarCapture {
    StringRef Name;
    SMRange Range;
  };
  SmallVector<VarCapture, 2> VarCaptures;
  for (const auto &VariableDef : VariableDefs) {
    VarCapture VC;
    VC.Name = VariableDef.first;
    StringRef Value = Context->GlobalVariableTable[VC.Name];
    SMLoc Start = SMLoc::getFromPointer(Value.data());
    SMLoc End = SMLoc::getFromPointer(Value.data() + Value.size());
    VC.Range = SMRange(Start, End);
    VarCaptures.push_back(VC);
  }
  for (const auto &VariableDef : NumericVariableDefs) {
    VarCapture VC;
    VC.Name = VariableDef.getKey();
    StringRef StrValue = VariableDef.getValue()
                             .DefinedNumericVariable->getStringValue()
                             .getValue();
    SMLoc Start = SMLoc::getFromPointer(StrValue.data());
    SMLoc End = SMLoc::getFromPointer(StrValue.data() + StrValue.size());
    VC.Range = SMRange(Start, End);
    VarCaptures.push_back(VC);
  }
  // Sort variable captures by the order in which they matched the input.
  // Ranges shouldn't be overlapping, so we can just compare the start.
  llvm::sort(VarCaptures, [](const VarCapture &A, const VarCapture &B) {
    assert(A.Range.Start != B.Range.Start &&
           "unexpected overlapping variable captures");
    return A.Range.Start.getPointer() < B.Range.Start.getPointer();
  });
  // Create notes for the sorted captures.
  for (const VarCapture &VC : VarCaptures) {
    SmallString<256> Msg;
    raw_svector_ostream OS(Msg);
    OS << "captured var \"" << VC.Name << "\"";
    if (Diags)
      Diags->emplace_back(SM, CheckTy, getLoc(), MatchTy, VC.Range, OS.str());
    else
      SM.PrintMessage(VC.Range.Start, SourceMgr::DK_Note, OS.str(), VC.Range);
  }
}

static SMRange ProcessMatchResult(FileCheckDiag::MatchType MatchTy,
                                  const SourceMgr &SM, SMLoc Loc,
                                  Check::FileCheckType CheckTy,
                                  StringRef Buffer, size_t Pos, size_t Len,
                                  std::vector<FileCheckDiag> *Diags,
                                  bool AdjustPrevDiags = false) {
  SMLoc Start = SMLoc::getFromPointer(Buffer.data() + Pos);
  SMLoc End = SMLoc::getFromPointer(Buffer.data() + Pos + Len);
  SMRange Range(Start, End);
  if (Diags) {
    if (AdjustPrevDiags) {
      SMLoc CheckLoc = Diags->rbegin()->CheckLoc;
      for (auto I = Diags->rbegin(), E = Diags->rend();
           I != E && I->CheckLoc == CheckLoc; ++I)
        I->MatchTy = MatchTy;
    } else
      Diags->emplace_back(SM, CheckTy, Loc, MatchTy, Range);
  }
  return Range;
}

void Pattern::printFuzzyMatch(const SourceMgr &SM, StringRef Buffer,
                              std::vector<FileCheckDiag> *Diags) const {
  // Attempt to find the closest/best fuzzy match.  Usually an error happens
  // because some string in the output didn't exactly match. In these cases, we
  // would like to show the user a best guess at what "should have" matched, to
  // save them having to actually check the input manually.
  size_t NumLinesForward = 0;
  size_t Best = StringRef::npos;
  double BestQuality = 0;

  // Use an arbitrary 4k limit on how far we will search.
  for (size_t i = 0, e = std::min(size_t(4096), Buffer.size()); i != e; ++i) {
    if (Buffer[i] == '\n')
      ++NumLinesForward;

    // Patterns have leading whitespace stripped, so skip whitespace when
    // looking for something which looks like a pattern.
    if (Buffer[i] == ' ' || Buffer[i] == '\t')
      continue;

    // Compute the "quality" of this match as an arbitrary combination of the
    // match distance and the number of lines skipped to get to this match.
    unsigned Distance = computeMatchDistance(Buffer.substr(i));
    double Quality = Distance + (NumLinesForward / 100.);

    if (Quality < BestQuality || Best == StringRef::npos) {
      Best = i;
      BestQuality = Quality;
    }
  }

  // Print the "possible intended match here" line if we found something
  // reasonable and not equal to what we showed in the "scanning from here"
  // line.
  if (Best && Best != StringRef::npos && BestQuality < 50) {
    SMRange MatchRange =
        ProcessMatchResult(FileCheckDiag::MatchFuzzy, SM, getLoc(),
                           getCheckTy(), Buffer, Best, 0, Diags);
    SM.PrintMessage(MatchRange.Start, SourceMgr::DK_Note,
                    "possible intended match here");

    // FIXME: If we wanted to be really friendly we would show why the match
    // failed, as it can be hard to spot simple one character differences.
  }
}

Expected<StringRef>
FileCheckPatternContext::getPatternVarValue(StringRef VarName) {
  auto VarIter = GlobalVariableTable.find(VarName);
  if (VarIter == GlobalVariableTable.end())
    return make_error<UndefVarError>(VarName);

  return VarIter->second;
}

template <class... Types>
NumericVariable *FileCheckPatternContext::makeNumericVariable(Types... args) {
  NumericVariables.push_back(std::make_unique<NumericVariable>(args...));
  return NumericVariables.back().get();
}

Substitution *
FileCheckPatternContext::makeStringSubstitution(StringRef VarName,
                                                size_t InsertIdx) {
  Substitutions.push_back(
      std::make_unique<StringSubstitution>(this, VarName, InsertIdx));
  return Substitutions.back().get();
}

Substitution *FileCheckPatternContext::makeNumericSubstitution(
    StringRef ExpressionStr, std::unique_ptr<Expression> Expression,
    size_t InsertIdx) {
  Substitutions.push_back(std::make_unique<NumericSubstitution>(
      this, ExpressionStr, std::move(Expression), InsertIdx));
  return Substitutions.back().get();
}

size_t Pattern::FindRegexVarEnd(StringRef Str, SourceMgr &SM) {
  // Offset keeps track of the current offset within the input Str
  size_t Offset = 0;
  // [...] Nesting depth
  size_t BracketDepth = 0;

  while (!Str.empty()) {
    if (Str.startswith("]]") && BracketDepth == 0)
      return Offset;
    if (Str[0] == '\\') {
      // Backslash escapes the next char within regexes, so skip them both.
      Str = Str.substr(2);
      Offset += 2;
    } else {
      switch (Str[0]) {
      default:
        break;
      case '[':
        BracketDepth++;
        break;
      case ']':
        if (BracketDepth == 0) {
          SM.PrintMessage(SMLoc::getFromPointer(Str.data()),
                          SourceMgr::DK_Error,
                          "missing closing \"]\" for regex variable");
          exit(1);
        }
        BracketDepth--;
        break;
      }
      Str = Str.substr(1);
      Offset++;
    }
  }

  return StringRef::npos;
}

StringRef FileCheck::CanonicalizeFile(MemoryBuffer &MB,
                                      SmallVectorImpl<char> &OutputBuffer) {
  OutputBuffer.reserve(MB.getBufferSize());

  for (const char *Ptr = MB.getBufferStart(), *End = MB.getBufferEnd();
       Ptr != End; ++Ptr) {
    // Eliminate trailing dosish \r.
    if (Ptr <= End - 2 && Ptr[0] == '\r' && Ptr[1] == '\n') {
      continue;
    }

    // If current char is not a horizontal whitespace or if horizontal
    // whitespace canonicalization is disabled, dump it to output as is.
    if (Req.NoCanonicalizeWhiteSpace || (*Ptr != ' ' && *Ptr != '\t')) {
      OutputBuffer.push_back(*Ptr);
      continue;
    }

    // Otherwise, add one space and advance over neighboring space.
    OutputBuffer.push_back(' ');
    while (Ptr + 1 != End && (Ptr[1] == ' ' || Ptr[1] == '\t'))
      ++Ptr;
  }

  // Add a null byte and then return all but that byte.
  OutputBuffer.push_back('\0');
  return StringRef(OutputBuffer.data(), OutputBuffer.size() - 1);
}

FileCheckDiag::FileCheckDiag(const SourceMgr &SM,
                             const Check::FileCheckType &CheckTy,
                             SMLoc CheckLoc, MatchType MatchTy,
                             SMRange InputRange, StringRef Note)
    : CheckTy(CheckTy), CheckLoc(CheckLoc), MatchTy(MatchTy), Note(Note) {
  auto Start = SM.getLineAndColumn(InputRange.Start);
  auto End = SM.getLineAndColumn(InputRange.End);
  InputStartLine = Start.first;
  InputStartCol = Start.second;
  InputEndLine = End.first;
  InputEndCol = End.second;
}

static bool IsPartOfWord(char c) {
  return (isAlnum(c) || c == '-' || c == '_');
}

Check::FileCheckType &Check::FileCheckType::setCount(int C) {
  assert(Count > 0 && "zero and negative counts are not supported");
  assert((C == 1 || Kind == CheckPlain) &&
         "count supported only for plain CHECK directives");
  Count = C;
  return *this;
}

std::string Check::FileCheckType::getModifiersDescription() const {
  if (Modifiers.none())
    return "";
  std::string Ret;
  raw_string_ostream OS(Ret);
  OS << '{';
  if (isLiteralMatch())
    OS << "LITERAL";
  OS << '}';
  return OS.str();
}

std::string Check::FileCheckType::getDescription(StringRef Prefix) const {
  // Append directive modifiers.
  auto WithModifiers = [this, Prefix](StringRef Str) -> std::string {
    return (Prefix + Str + getModifiersDescription()).str();
  };

  switch (Kind) {
  case Check::CheckNone:
    return "invalid";
  case Check::CheckPlain:
    if (Count > 1)
      return WithModifiers("-COUNT");
    return WithModifiers("");
  case Check::CheckNext:
    return WithModifiers("-NEXT");
  case Check::CheckSame:
    return WithModifiers("-SAME");
  case Check::CheckNot:
    return WithModifiers("-NOT");
  case Check::CheckDAG:
    return WithModifiers("-DAG");
  case Check::CheckLabel:
    return WithModifiers("-LABEL");
  case Check::CheckEmpty:
    return WithModifiers("-EMPTY");
  case Check::CheckComment:
    return std::string(Prefix);
  case Check::CheckEOF:
    return "implicit EOF";
  case Check::CheckBadNot:
    return "bad NOT";
  case Check::CheckBadCount:
    return "bad COUNT";
  }
  llvm_unreachable("unknown FileCheckType");
}

static std::pair<Check::FileCheckType, StringRef>
FindCheckType(const FileCheckRequest &Req, StringRef Buffer, StringRef Prefix) {
  if (Buffer.size() <= Prefix.size())
    return {Check::CheckNone, StringRef()};

  StringRef Rest = Buffer.drop_front(Prefix.size());
  // Check for comment.
  if (llvm::is_contained(Req.CommentPrefixes, Prefix)) {
    if (Rest.consume_front(":"))
      return {Check::CheckComment, Rest};
    // Ignore a comment prefix if it has a suffix like "-NOT".
    return {Check::CheckNone, StringRef()};
  }

  auto ConsumeModifiers = [&](Check::FileCheckType Ret)
      -> std::pair<Check::FileCheckType, StringRef> {
    if (Rest.consume_front(":"))
      return {Ret, Rest};
    if (!Rest.consume_front("{"))
      return {Check::CheckNone, StringRef()};

    // Parse the modifiers, speparated by commas.
    do {
      // Allow whitespace in modifiers list.
      Rest = Rest.ltrim();
      if (Rest.consume_front("LITERAL"))
        Ret.setLiteralMatch();
      else
        return {Check::CheckNone, Rest};
      // Allow whitespace in modifiers list.
      Rest = Rest.ltrim();
    } while (Rest.consume_front(","));
    if (!Rest.consume_front("}:"))
      return {Check::CheckNone, Rest};
    return {Ret, Rest};
  };

  // Verify that the prefix is followed by directive modifiers or a colon.
  if (Rest.consume_front(":"))
    return {Check::CheckPlain, Rest};
  if (Rest.front() == '{')
    return ConsumeModifiers(Check::CheckPlain);

  if (!Rest.consume_front("-"))
    return {Check::CheckNone, StringRef()};

  if (Rest.consume_front("COUNT-")) {
    int64_t Count;
    if (Rest.consumeInteger(10, Count))
      // Error happened in parsing integer.
      return {Check::CheckBadCount, Rest};
    if (Count <= 0 || Count > INT32_MAX)
      return {Check::CheckBadCount, Rest};
    if (Rest.front() != ':' && Rest.front() != '{')
      return {Check::CheckBadCount, Rest};
    return ConsumeModifiers(
        Check::FileCheckType(Check::CheckPlain).setCount(Count));
  }

  // You can't combine -NOT with another suffix.
  if (Rest.startswith("DAG-NOT:") || Rest.startswith("NOT-DAG:") ||
      Rest.startswith("NEXT-NOT:") || Rest.startswith("NOT-NEXT:") ||
      Rest.startswith("SAME-NOT:") || Rest.startswith("NOT-SAME:") ||
      Rest.startswith("EMPTY-NOT:") || Rest.startswith("NOT-EMPTY:"))
    return {Check::CheckBadNot, Rest};

  if (Rest.consume_front("NEXT"))
    return ConsumeModifiers(Check::CheckNext);

  if (Rest.consume_front("SAME"))
    return ConsumeModifiers(Check::CheckSame);

  if (Rest.consume_front("NOT"))
    return ConsumeModifiers(Check::CheckNot);

  if (Rest.consume_front("DAG"))
    return ConsumeModifiers(Check::CheckDAG);

  if (Rest.consume_front("LABEL"))
    return ConsumeModifiers(Check::CheckLabel);

  if (Rest.consume_front("EMPTY"))
    return ConsumeModifiers(Check::CheckEmpty);

  return {Check::CheckNone, Rest};
}

// From the given position, find the next character after the word.
static size_t SkipWord(StringRef Str, size_t Loc) {
  while (Loc < Str.size() && IsPartOfWord(Str[Loc]))
    ++Loc;
  return Loc;
}

/// Searches the buffer for the first prefix in the prefix regular expression.
///
/// This searches the buffer using the provided regular expression, however it
/// enforces constraints beyond that:
/// 1) The found prefix must not be a suffix of something that looks like
///    a valid prefix.
/// 2) The found prefix must be followed by a valid check type suffix using \c
///    FindCheckType above.
///
/// \returns a pair of StringRefs into the Buffer, which combines:
///   - the first match of the regular expression to satisfy these two is
///   returned,
///     otherwise an empty StringRef is returned to indicate failure.
///   - buffer rewound to the location right after parsed suffix, for parsing
///     to continue from
///
/// If this routine returns a valid prefix, it will also shrink \p Buffer to
/// start at the beginning of the returned prefix, increment \p LineNumber for
/// each new line consumed from \p Buffer, and set \p CheckTy to the type of
/// check found by examining the suffix.
///
/// If no valid prefix is found, the state of Buffer, LineNumber, and CheckTy
/// is unspecified.
static std::pair<StringRef, StringRef>
FindFirstMatchingPrefix(const FileCheckRequest &Req, Regex &PrefixRE,
                        StringRef &Buffer, unsigned &LineNumber,
                        Check::FileCheckType &CheckTy) {
  SmallVector<StringRef, 2> Matches;

  while (!Buffer.empty()) {
    // Find the first (longest) match using the RE.
    if (!PrefixRE.match(Buffer, &Matches))
      // No match at all, bail.
      return {StringRef(), StringRef()};

    StringRef Prefix = Matches[0];
    Matches.clear();

    assert(Prefix.data() >= Buffer.data() &&
           Prefix.data() < Buffer.data() + Buffer.size() &&
           "Prefix doesn't start inside of buffer!");
    size_t Loc = Prefix.data() - Buffer.data();
    StringRef Skipped = Buffer.substr(0, Loc);
    Buffer = Buffer.drop_front(Loc);
    LineNumber += Skipped.count('\n');

    // Check that the matched prefix isn't a suffix of some other check-like
    // word.
    // FIXME: This is a very ad-hoc check. it would be better handled in some
    // other way. Among other things it seems hard to distinguish between
    // intentional and unintentional uses of this feature.
    if (Skipped.empty() || !IsPartOfWord(Skipped.back())) {
      // Now extract the type.
      StringRef AfterSuffix;
      std::tie(CheckTy, AfterSuffix) = FindCheckType(Req, Buffer, Prefix);

      // If we've found a valid check type for this prefix, we're done.
      if (CheckTy != Check::CheckNone)
        return {Prefix, AfterSuffix};
    }

    // If we didn't successfully find a prefix, we need to skip this invalid
    // prefix and continue scanning. We directly skip the prefix that was
    // matched and any additional parts of that check-like word.
    Buffer = Buffer.drop_front(SkipWord(Buffer, Prefix.size()));
  }

  // We ran out of buffer while skipping partial matches so give up.
  return {StringRef(), StringRef()};
}

void FileCheckPatternContext::createLineVariable() {
  assert(!LineVariable && "@LINE pseudo numeric variable already created");
  StringRef LineName = "@LINE";
  LineVariable = makeNumericVariable(
      LineName, ExpressionFormat(ExpressionFormat::Kind::Unsigned));
  GlobalNumericVariableTable[LineName] = LineVariable;
}

FileCheck::FileCheck(FileCheckRequest Req)
    : Req(Req), PatternContext(std::make_unique<FileCheckPatternContext>()),
      CheckStrings(std::make_unique<std::vector<FileCheckString>>()) {}

FileCheck::~FileCheck() = default;

bool FileCheck::readCheckFile(
    SourceMgr &SM, StringRef Buffer, Regex &PrefixRE,
    std::pair<unsigned, unsigned> *ImpPatBufferIDRange) {
  if (ImpPatBufferIDRange)
    ImpPatBufferIDRange->first = ImpPatBufferIDRange->second = 0;

  Error DefineError =
      PatternContext->defineCmdlineVariables(Req.GlobalDefines, SM);
  if (DefineError) {
    logAllUnhandledErrors(std::move(DefineError), errs());
    return true;
  }

  PatternContext->createLineVariable();

  std::vector<Pattern> ImplicitNegativeChecks;
  for (StringRef PatternString : Req.ImplicitCheckNot) {
    // Create a buffer with fake command line content in order to display the
    // command line option responsible for the specific implicit CHECK-NOT.
    std::string Prefix = "-implicit-check-not='";
    std::string Suffix = "'";
    std::unique_ptr<MemoryBuffer> CmdLine = MemoryBuffer::getMemBufferCopy(
        (Prefix + PatternString + Suffix).str(), "command line");

    StringRef PatternInBuffer =
        CmdLine->getBuffer().substr(Prefix.size(), PatternString.size());
    unsigned BufferID = SM.AddNewSourceBuffer(std::move(CmdLine), SMLoc());
    if (ImpPatBufferIDRange) {
      if (ImpPatBufferIDRange->first == ImpPatBufferIDRange->second) {
        ImpPatBufferIDRange->first = BufferID;
        ImpPatBufferIDRange->second = BufferID + 1;
      } else {
        assert(BufferID == ImpPatBufferIDRange->second &&
               "expected consecutive source buffer IDs");
        ++ImpPatBufferIDRange->second;
      }
    }

    ImplicitNegativeChecks.push_back(
        Pattern(Check::CheckNot, PatternContext.get()));
    ImplicitNegativeChecks.back().parsePattern(PatternInBuffer,
                                               "IMPLICIT-CHECK", SM, Req);
  }

  std::vector<Pattern> DagNotMatches = ImplicitNegativeChecks;

  // LineNumber keeps track of the line on which CheckPrefix instances are
  // found.
  unsigned LineNumber = 1;

  std::set<StringRef> PrefixesNotFound(Req.CheckPrefixes.begin(),
                                       Req.CheckPrefixes.end());
  const size_t DistinctPrefixes = PrefixesNotFound.size();
  while (true) {
    Check::FileCheckType CheckTy;

    // See if a prefix occurs in the memory buffer.
    StringRef UsedPrefix;
    StringRef AfterSuffix;
    std::tie(UsedPrefix, AfterSuffix) =
        FindFirstMatchingPrefix(Req, PrefixRE, Buffer, LineNumber, CheckTy);
    if (UsedPrefix.empty())
      break;
    if (CheckTy != Check::CheckComment)
      PrefixesNotFound.erase(UsedPrefix);

    assert(UsedPrefix.data() == Buffer.data() &&
           "Failed to move Buffer's start forward, or pointed prefix outside "
           "of the buffer!");
    assert(AfterSuffix.data() >= Buffer.data() &&
           AfterSuffix.data() < Buffer.data() + Buffer.size() &&
           "Parsing after suffix doesn't start inside of buffer!");

    // Location to use for error messages.
    const char *UsedPrefixStart = UsedPrefix.data();

    // Skip the buffer to the end of parsed suffix (or just prefix, if no good
    // suffix was processed).
    Buffer = AfterSuffix.empty() ? Buffer.drop_front(UsedPrefix.size())
                                 : AfterSuffix;

    // Complain about useful-looking but unsupported suffixes.
    if (CheckTy == Check::CheckBadNot) {
      SM.PrintMessage(SMLoc::getFromPointer(Buffer.data()), SourceMgr::DK_Error,
                      "unsupported -NOT combo on prefix '" + UsedPrefix + "'");
      return true;
    }

    // Complain about invalid count specification.
    if (CheckTy == Check::CheckBadCount) {
      SM.PrintMessage(SMLoc::getFromPointer(Buffer.data()), SourceMgr::DK_Error,
                      "invalid count in -COUNT specification on prefix '" +
                          UsedPrefix + "'");
      return true;
    }

    // Okay, we found the prefix, yay. Remember the rest of the line, but ignore
    // leading whitespace.
    if (!(Req.NoCanonicalizeWhiteSpace && Req.MatchFullLines))
      Buffer = Buffer.substr(Buffer.find_first_not_of(" \t"));

    // Scan ahead to the end of line.
    size_t EOL = Buffer.find_first_of("\n\r");

    // Remember the location of the start of the pattern, for diagnostics.
    SMLoc PatternLoc = SMLoc::getFromPointer(Buffer.data());

    // Extract the pattern from the buffer.
    StringRef PatternBuffer = Buffer.substr(0, EOL);
    Buffer = Buffer.substr(EOL);

    // If this is a comment, we're done.
    if (CheckTy == Check::CheckComment)
      continue;

    // Parse the pattern.
    Pattern P(CheckTy, PatternContext.get(), LineNumber);
    if (P.parsePattern(PatternBuffer, UsedPrefix, SM, Req))
      return true;

    // Verify that CHECK-LABEL lines do not define or use variables
    if ((CheckTy == Check::CheckLabel) && P.hasVariable()) {
      SM.PrintMessage(
          SMLoc::getFromPointer(UsedPrefixStart), SourceMgr::DK_Error,
          "found '" + UsedPrefix + "-LABEL:'"
                                   " with variable definition or use");
      return true;
    }

    // Verify that CHECK-NEXT/SAME/EMPTY lines have at least one CHECK line before them.
    if ((CheckTy == Check::CheckNext || CheckTy == Check::CheckSame ||
         CheckTy == Check::CheckEmpty) &&
        CheckStrings->empty()) {
      StringRef Type = CheckTy == Check::CheckNext
                           ? "NEXT"
                           : CheckTy == Check::CheckEmpty ? "EMPTY" : "SAME";
      SM.PrintMessage(SMLoc::getFromPointer(UsedPrefixStart),
                      SourceMgr::DK_Error,
                      "found '" + UsedPrefix + "-" + Type +
                          "' without previous '" + UsedPrefix + ": line");
      return true;
    }

    // Handle CHECK-DAG/-NOT.
    if (CheckTy == Check::CheckDAG || CheckTy == Check::CheckNot) {
      DagNotMatches.push_back(P);
      continue;
    }

    // Okay, add the string we captured to the output vector and move on.
    CheckStrings->emplace_back(P, UsedPrefix, PatternLoc);
    std::swap(DagNotMatches, CheckStrings->back().DagNotStrings);
    DagNotMatches = ImplicitNegativeChecks;
  }

  // When there are no used prefixes we report an error except in the case that
  // no prefix is specified explicitly but -implicit-check-not is specified.
  const bool NoPrefixesFound = PrefixesNotFound.size() == DistinctPrefixes;
  const bool SomePrefixesUnexpectedlyNotUsed =
      !Req.AllowUnusedPrefixes && !PrefixesNotFound.empty();
  if ((NoPrefixesFound || SomePrefixesUnexpectedlyNotUsed) &&
      (ImplicitNegativeChecks.empty() || !Req.IsDefaultCheckPrefix)) {
    errs() << "error: no check strings found with prefix"
           << (PrefixesNotFound.size() > 1 ? "es " : " ");
    bool First = true;
    for (StringRef MissingPrefix : PrefixesNotFound) {
      if (!First)
        errs() << ", ";
      errs() << "\'" << MissingPrefix << ":'";
      First = false;
    }
    errs() << '\n';
    return true;
  }

  // Add an EOF pattern for any trailing --implicit-check-not/CHECK-DAG/-NOTs,
  // and use the first prefix as a filler for the error message.
  if (!DagNotMatches.empty()) {
    CheckStrings->emplace_back(
        Pattern(Check::CheckEOF, PatternContext.get(), LineNumber + 1),
        *Req.CheckPrefixes.begin(), SMLoc::getFromPointer(Buffer.data()));
    std::swap(DagNotMatches, CheckStrings->back().DagNotStrings);
  }

  return false;
}

static void PrintMatch(bool ExpectedMatch, const SourceMgr &SM,
                       StringRef Prefix, SMLoc Loc, const Pattern &Pat,
                       int MatchedCount, StringRef Buffer, size_t MatchPos,
                       size_t MatchLen, const FileCheckRequest &Req,
                       std::vector<FileCheckDiag> *Diags) {
  bool PrintDiag = true;
  if (ExpectedMatch) {
    if (!Req.Verbose)
      return;
    if (!Req.VerboseVerbose && Pat.getCheckTy() == Check::CheckEOF)
      return;
    // Due to their verbosity, we don't print verbose diagnostics here if we're
    // gathering them for a different rendering, but we always print other
    // diagnostics.
    PrintDiag = !Diags;
  }
  FileCheckDiag::MatchType MatchTy = ExpectedMatch
                                         ? FileCheckDiag::MatchFoundAndExpected
                                         : FileCheckDiag::MatchFoundButExcluded;
  SMRange MatchRange = ProcessMatchResult(MatchTy, SM, Loc, Pat.getCheckTy(),
                                          Buffer, MatchPos, MatchLen, Diags);
  if (Diags) {
    Pat.printSubstitutions(SM, Buffer, MatchRange, MatchTy, Diags);
    Pat.printVariableDefs(SM, MatchTy, Diags);
  }
  if (!PrintDiag)
    return;

  std::string Message = formatv("{0}: {1} string found in input",
                                Pat.getCheckTy().getDescription(Prefix),
                                (ExpectedMatch ? "expected" : "excluded"))
                            .str();
  if (Pat.getCount() > 1)
    Message += formatv(" ({0} out of {1})", MatchedCount, Pat.getCount()).str();

  SM.PrintMessage(
      Loc, ExpectedMatch ? SourceMgr::DK_Remark : SourceMgr::DK_Error, Message);
  SM.PrintMessage(MatchRange.Start, SourceMgr::DK_Note, "found here",
                  {MatchRange});
  Pat.printSubstitutions(SM, Buffer, MatchRange, MatchTy, nullptr);
  Pat.printVariableDefs(SM, MatchTy, nullptr);
}

static void PrintMatch(bool ExpectedMatch, const SourceMgr &SM,
                       const FileCheckString &CheckStr, int MatchedCount,
                       StringRef Buffer, size_t MatchPos, size_t MatchLen,
                       FileCheckRequest &Req,
                       std::vector<FileCheckDiag> *Diags) {
  PrintMatch(ExpectedMatch, SM, CheckStr.Prefix, CheckStr.Loc, CheckStr.Pat,
             MatchedCount, Buffer, MatchPos, MatchLen, Req, Diags);
}

static void PrintNoMatch(bool ExpectedMatch, const SourceMgr &SM,
                         StringRef Prefix, SMLoc Loc, const Pattern &Pat,
                         int MatchedCount, StringRef Buffer,
                         bool VerboseVerbose, std::vector<FileCheckDiag> *Diags,
                         Error MatchErrors) {
  assert(MatchErrors && "Called on successful match");
  bool PrintDiag = true;
  if (!ExpectedMatch) {
    if (!VerboseVerbose) {
      consumeError(std::move(MatchErrors));
      return;
    }
    // Due to their verbosity, we don't print verbose diagnostics here if we're
    // gathering them for a different rendering, but we always print other
    // diagnostics.
    PrintDiag = !Diags;
  }

  // If the current position is at the end of a line, advance to the start of
  // the next line.
  Buffer = Buffer.substr(Buffer.find_first_not_of(" \t\n\r"));
  FileCheckDiag::MatchType MatchTy = ExpectedMatch
                                         ? FileCheckDiag::MatchNoneButExpected
                                         : FileCheckDiag::MatchNoneAndExcluded;
  SMRange SearchRange = ProcessMatchResult(MatchTy, SM, Loc, Pat.getCheckTy(),
                                           Buffer, 0, Buffer.size(), Diags);
  if (Diags)
    Pat.printSubstitutions(SM, Buffer, SearchRange, MatchTy, Diags);
  if (!PrintDiag) {
    consumeError(std::move(MatchErrors));
    return;
  }

  MatchErrors = handleErrors(std::move(MatchErrors),
                             [](const ErrorDiagnostic &E) { E.log(errs()); });

  // No problem matching the string per se.
  if (!MatchErrors)
    return;
  consumeError(std::move(MatchErrors));

  // Print "not found" diagnostic.
  std::string Message = formatv("{0}: {1} string not found in input",
                                Pat.getCheckTy().getDescription(Prefix),
                                (ExpectedMatch ? "expected" : "excluded"))
                            .str();
  if (Pat.getCount() > 1)
    Message += formatv(" ({0} out of {1})", MatchedCount, Pat.getCount()).str();
  SM.PrintMessage(
      Loc, ExpectedMatch ? SourceMgr::DK_Error : SourceMgr::DK_Remark, Message);

  // Print the "scanning from here" line.
  SM.PrintMessage(SearchRange.Start, SourceMgr::DK_Note, "scanning from here");

  // Allow the pattern to print additional information if desired.
  Pat.printSubstitutions(SM, Buffer, SearchRange, MatchTy, nullptr);

  if (ExpectedMatch)
    Pat.printFuzzyMatch(SM, Buffer, Diags);
}

static void PrintNoMatch(bool ExpectedMatch, const SourceMgr &SM,
                         const FileCheckString &CheckStr, int MatchedCount,
                         StringRef Buffer, bool VerboseVerbose,
                         std::vector<FileCheckDiag> *Diags, Error MatchErrors) {
  PrintNoMatch(ExpectedMatch, SM, CheckStr.Prefix, CheckStr.Loc, CheckStr.Pat,
               MatchedCount, Buffer, VerboseVerbose, Diags,
               std::move(MatchErrors));
}

/// Counts the number of newlines in the specified range.
static unsigned CountNumNewlinesBetween(StringRef Range,
                                        const char *&FirstNewLine) {
  unsigned NumNewLines = 0;
  while (1) {
    // Scan for newline.
    Range = Range.substr(Range.find_first_of("\n\r"));
    if (Range.empty())
      return NumNewLines;

    ++NumNewLines;

    // Handle \n\r and \r\n as a single newline.
    if (Range.size() > 1 && (Range[1] == '\n' || Range[1] == '\r') &&
        (Range[0] != Range[1]))
      Range = Range.substr(1);
    Range = Range.substr(1);

    if (NumNewLines == 1)
      FirstNewLine = Range.begin();
  }
}

size_t FileCheckString::Check(const SourceMgr &SM, StringRef Buffer,
                              bool IsLabelScanMode, size_t &MatchLen,
                              FileCheckRequest &Req,
                              std::vector<FileCheckDiag> *Diags) const {
  size_t LastPos = 0;
  std::vector<const Pattern *> NotStrings;

  // IsLabelScanMode is true when we are scanning forward to find CHECK-LABEL
  // bounds; we have not processed variable definitions within the bounded block
  // yet so cannot handle any final CHECK-DAG yet; this is handled when going
  // over the block again (including the last CHECK-LABEL) in normal mode.
  if (!IsLabelScanMode) {
    // Match "dag strings" (with mixed "not strings" if any).
    LastPos = CheckDag(SM, Buffer, NotStrings, Req, Diags);
    if (LastPos == StringRef::npos)
      return StringRef::npos;
  }

  // Match itself from the last position after matching CHECK-DAG.
  size_t LastMatchEnd = LastPos;
  size_t FirstMatchPos = 0;
  // Go match the pattern Count times. Majority of patterns only match with
  // count 1 though.
  assert(Pat.getCount() != 0 && "pattern count can not be zero");
  for (int i = 1; i <= Pat.getCount(); i++) {
    StringRef MatchBuffer = Buffer.substr(LastMatchEnd);
    size_t CurrentMatchLen;
    // get a match at current start point
    Expected<size_t> MatchResult = Pat.match(MatchBuffer, CurrentMatchLen, SM);

    // report
    if (!MatchResult) {
      PrintNoMatch(true, SM, *this, i, MatchBuffer, Req.VerboseVerbose, Diags,
                   MatchResult.takeError());
      return StringRef::npos;
    }
    size_t MatchPos = *MatchResult;
    PrintMatch(true, SM, *this, i, MatchBuffer, MatchPos, CurrentMatchLen, Req,
               Diags);
    if (i == 1)
      FirstMatchPos = LastPos + MatchPos;

    // move start point after the match
    LastMatchEnd += MatchPos + CurrentMatchLen;
  }
  // Full match len counts from first match pos.
  MatchLen = LastMatchEnd - FirstMatchPos;

  // Similar to the above, in "label-scan mode" we can't yet handle CHECK-NEXT
  // or CHECK-NOT
  if (!IsLabelScanMode) {
    size_t MatchPos = FirstMatchPos - LastPos;
    StringRef MatchBuffer = Buffer.substr(LastPos);
    StringRef SkippedRegion = Buffer.substr(LastPos, MatchPos);

    // If this check is a "CHECK-NEXT", verify that the previous match was on
    // the previous line (i.e. that there is one newline between them).
    if (CheckNext(SM, SkippedRegion)) {
      ProcessMatchResult(FileCheckDiag::MatchFoundButWrongLine, SM, Loc,
                         Pat.getCheckTy(), MatchBuffer, MatchPos, MatchLen,
                         Diags, Req.Verbose);
      return StringRef::npos;
    }

    // If this check is a "CHECK-SAME", verify that the previous match was on
    // the same line (i.e. that there is no newline between them).
    if (CheckSame(SM, SkippedRegion)) {
      ProcessMatchResult(FileCheckDiag::MatchFoundButWrongLine, SM, Loc,
                         Pat.getCheckTy(), MatchBuffer, MatchPos, MatchLen,
                         Diags, Req.Verbose);
      return StringRef::npos;
    }

    // If this match had "not strings", verify that they don't exist in the
    // skipped region.
    if (CheckNot(SM, SkippedRegion, NotStrings, Req, Diags))
      return StringRef::npos;
  }

  return FirstMatchPos;
}

bool FileCheckString::CheckNext(const SourceMgr &SM, StringRef Buffer) const {
  if (Pat.getCheckTy() != Check::CheckNext &&
      Pat.getCheckTy() != Check::CheckEmpty)
    return false;

  Twine CheckName =
      Prefix +
      Twine(Pat.getCheckTy() == Check::CheckEmpty ? "-EMPTY" : "-NEXT");

  // Count the number of newlines between the previous match and this one.
  const char *FirstNewLine = nullptr;
  unsigned NumNewLines = CountNumNewlinesBetween(Buffer, FirstNewLine);

  if (NumNewLines == 0) {
    SM.PrintMessage(Loc, SourceMgr::DK_Error,
                    CheckName + ": is on the same line as previous match");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.end()), SourceMgr::DK_Note,
                    "'next' match was here");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.data()), SourceMgr::DK_Note,
                    "previous match ended here");
    return true;
  }

  if (NumNewLines != 1) {
    SM.PrintMessage(Loc, SourceMgr::DK_Error,
                    CheckName +
                        ": is not on the line after the previous match");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.end()), SourceMgr::DK_Note,
                    "'next' match was here");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.data()), SourceMgr::DK_Note,
                    "previous match ended here");
    SM.PrintMessage(SMLoc::getFromPointer(FirstNewLine), SourceMgr::DK_Note,
                    "non-matching line after previous match is here");
    return true;
  }

  return false;
}

bool FileCheckString::CheckSame(const SourceMgr &SM, StringRef Buffer) const {
  if (Pat.getCheckTy() != Check::CheckSame)
    return false;

  // Count the number of newlines between the previous match and this one.
  const char *FirstNewLine = nullptr;
  unsigned NumNewLines = CountNumNewlinesBetween(Buffer, FirstNewLine);

  if (NumNewLines != 0) {
    SM.PrintMessage(Loc, SourceMgr::DK_Error,
                    Prefix +
                        "-SAME: is not on the same line as the previous match");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.end()), SourceMgr::DK_Note,
                    "'next' match was here");
    SM.PrintMessage(SMLoc::getFromPointer(Buffer.data()), SourceMgr::DK_Note,
                    "previous match ended here");
    return true;
  }

  return false;
}

bool FileCheckString::CheckNot(const SourceMgr &SM, StringRef Buffer,
                               const std::vector<const Pattern *> &NotStrings,
                               const FileCheckRequest &Req,
                               std::vector<FileCheckDiag> *Diags) const {
  bool DirectiveFail = false;
  for (const Pattern *Pat : NotStrings) {
    assert((Pat->getCheckTy() == Check::CheckNot) && "Expect CHECK-NOT!");

    size_t MatchLen = 0;
    Expected<size_t> MatchResult = Pat->match(Buffer, MatchLen, SM);

    if (!MatchResult) {
      PrintNoMatch(false, SM, Prefix, Pat->getLoc(), *Pat, 1, Buffer,
                   Req.VerboseVerbose, Diags, MatchResult.takeError());
      continue;
    }
    size_t Pos = *MatchResult;

    PrintMatch(false, SM, Prefix, Pat->getLoc(), *Pat, 1, Buffer, Pos, MatchLen,
               Req, Diags);
    DirectiveFail = true;
  }

  return DirectiveFail;
}

size_t FileCheckString::CheckDag(const SourceMgr &SM, StringRef Buffer,
                                 std::vector<const Pattern *> &NotStrings,
                                 const FileCheckRequest &Req,
                                 std::vector<FileCheckDiag> *Diags) const {
  if (DagNotStrings.empty())
    return 0;

  // The start of the search range.
  size_t StartPos = 0;

  struct MatchRange {
    size_t Pos;
    size_t End;
  };
  // A sorted list of ranges for non-overlapping CHECK-DAG matches.  Match
  // ranges are erased from this list once they are no longer in the search
  // range.
  std::list<MatchRange> MatchRanges;

  // We need PatItr and PatEnd later for detecting the end of a CHECK-DAG
  // group, so we don't use a range-based for loop here.
  for (auto PatItr = DagNotStrings.begin(), PatEnd = DagNotStrings.end();
       PatItr != PatEnd; ++PatItr) {
    const Pattern &Pat = *PatItr;
    assert((Pat.getCheckTy() == Check::CheckDAG ||
            Pat.getCheckTy() == Check::CheckNot) &&
           "Invalid CHECK-DAG or CHECK-NOT!");

    if (Pat.getCheckTy() == Check::CheckNot) {
      NotStrings.push_back(&Pat);
      continue;
    }

    assert((Pat.getCheckTy() == Check::CheckDAG) && "Expect CHECK-DAG!");

    // CHECK-DAG always matches from the start.
    size_t MatchLen = 0, MatchPos = StartPos;

    // Search for a match that doesn't overlap a previous match in this
    // CHECK-DAG group.
    for (auto MI = MatchRanges.begin(), ME = MatchRanges.end(); true; ++MI) {
      StringRef MatchBuffer = Buffer.substr(MatchPos);
      Expected<size_t> MatchResult = Pat.match(MatchBuffer, MatchLen, SM);
      // With a group of CHECK-DAGs, a single mismatching means the match on
      // that group of CHECK-DAGs fails immediately.
      if (!MatchResult) {
        PrintNoMatch(true, SM, Prefix, Pat.getLoc(), Pat, 1, MatchBuffer,
                     Req.VerboseVerbose, Diags, MatchResult.takeError());
        return StringRef::npos;
      }
      size_t MatchPosBuf = *MatchResult;
      // Re-calc it as the offset relative to the start of the original string.
      MatchPos += MatchPosBuf;
      if (Req.VerboseVerbose)
        PrintMatch(true, SM, Prefix, Pat.getLoc(), Pat, 1, Buffer, MatchPos,
                   MatchLen, Req, Diags);
      MatchRange M{MatchPos, MatchPos + MatchLen};
      if (Req.AllowDeprecatedDagOverlap) {
        // We don't need to track all matches in this mode, so we just maintain
        // one match range that encompasses the current CHECK-DAG group's
        // matches.
        if (MatchRanges.empty())
          MatchRanges.insert(MatchRanges.end(), M);
        else {
          auto Block = MatchRanges.begin();
          Block->Pos = std::min(Block->Pos, M.Pos);
          Block->End = std::max(Block->End, M.End);
        }
        break;
      }
      // Iterate previous matches until overlapping match or insertion point.
      bool Overlap = false;
      for (; MI != ME; ++MI) {
        if (M.Pos < MI->End) {
          // !Overlap => New match has no overlap and is before this old match.
          // Overlap => New match overlaps this old match.
          Overlap = MI->Pos < M.End;
          break;
        }
      }
      if (!Overlap) {
        // Insert non-overlapping match into list.
        MatchRanges.insert(MI, M);
        break;
      }
      if (Req.VerboseVerbose) {
        // Due to their verbosity, we don't print verbose diagnostics here if
        // we're gathering them for a different rendering, but we always print
        // other diagnostics.
        if (!Diags) {
          SMLoc OldStart = SMLoc::getFromPointer(Buffer.data() + MI->Pos);
          SMLoc OldEnd = SMLoc::getFromPointer(Buffer.data() + MI->End);
          SMRange OldRange(OldStart, OldEnd);
          SM.PrintMessage(OldStart, SourceMgr::DK_Note,
                          "match discarded, overlaps earlier DAG match here",
                          {OldRange});
        } else {
          SMLoc CheckLoc = Diags->rbegin()->CheckLoc;
          for (auto I = Diags->rbegin(), E = Diags->rend();
               I != E && I->CheckLoc == CheckLoc; ++I)
            I->MatchTy = FileCheckDiag::MatchFoundButDiscarded;
        }
      }
      MatchPos = MI->End;
    }
    if (!Req.VerboseVerbose)
      PrintMatch(true, SM, Prefix, Pat.getLoc(), Pat, 1, Buffer, MatchPos,
                 MatchLen, Req, Diags);

    // Handle the end of a CHECK-DAG group.
    if (std::next(PatItr) == PatEnd ||
        std::next(PatItr)->getCheckTy() == Check::CheckNot) {
      if (!NotStrings.empty()) {
        // If there are CHECK-NOTs between two CHECK-DAGs or from CHECK to
        // CHECK-DAG, verify that there are no 'not' strings occurred in that
        // region.
        StringRef SkippedRegion =
            Buffer.slice(StartPos, MatchRanges.begin()->Pos);
        if (CheckNot(SM, SkippedRegion, NotStrings, Req, Diags))
          return StringRef::npos;
        // Clear "not strings".
        NotStrings.clear();
      }
      // All subsequent CHECK-DAGs and CHECK-NOTs should be matched from the
      // end of this CHECK-DAG group's match range.
      StartPos = MatchRanges.rbegin()->End;
      // Don't waste time checking for (impossible) overlaps before that.
      MatchRanges.clear();
    }
  }

  return StartPos;
}

static bool ValidatePrefixes(StringRef Kind, StringSet<> &UniquePrefixes,
                             ArrayRef<StringRef> SuppliedPrefixes) {
  for (StringRef Prefix : SuppliedPrefixes) {
    if (Prefix.empty()) {
      errs() << "error: supplied " << Kind << " prefix must not be the empty "
             << "string\n";
      return false;
    }
    static const Regex Validator("^[a-zA-Z0-9_-]*$");
    if (!Validator.match(Prefix)) {
      errs() << "error: supplied " << Kind << " prefix must start with a "
             << "letter and contain only alphanumeric characters, hyphens, and "
             << "underscores: '" << Prefix << "'\n";
      return false;
    }
    if (!UniquePrefixes.insert(Prefix).second) {
      errs() << "error: supplied " << Kind << " prefix must be unique among "
             << "check and comment prefixes: '" << Prefix << "'\n";
      return false;
    }
  }
  return true;
}

static const char *DefaultCheckPrefixes[] = {"CHECK"};
static const char *DefaultCommentPrefixes[] = {"COM", "RUN"};

bool FileCheck::ValidateCheckPrefixes() {
  StringSet<> UniquePrefixes;
  // Add default prefixes to catch user-supplied duplicates of them below.
  if (Req.CheckPrefixes.empty()) {
    for (const char *Prefix : DefaultCheckPrefixes)
      UniquePrefixes.insert(Prefix);
  }
  if (Req.CommentPrefixes.empty()) {
    for (const char *Prefix : DefaultCommentPrefixes)
      UniquePrefixes.insert(Prefix);
  }
  // Do not validate the default prefixes, or diagnostics about duplicates might
  // incorrectly indicate that they were supplied by the user.
  if (!ValidatePrefixes("check", UniquePrefixes, Req.CheckPrefixes))
    return false;
  if (!ValidatePrefixes("comment", UniquePrefixes, Req.CommentPrefixes))
    return false;
  return true;
}

Regex FileCheck::buildCheckPrefixRegex() {
  if (Req.CheckPrefixes.empty()) {
    for (const char *Prefix : DefaultCheckPrefixes)
      Req.CheckPrefixes.push_back(Prefix);
    Req.IsDefaultCheckPrefix = true;
  }
  if (Req.CommentPrefixes.empty()) {
    for (const char *Prefix : DefaultCommentPrefixes)
      Req.CommentPrefixes.push_back(Prefix);
  }

  // We already validated the contents of CheckPrefixes and CommentPrefixes so
  // just concatenate them as alternatives.
  SmallString<32> PrefixRegexStr;
  for (size_t I = 0, E = Req.CheckPrefixes.size(); I != E; ++I) {
    if (I != 0)
      PrefixRegexStr.push_back('|');
    PrefixRegexStr.append(Req.CheckPrefixes[I]);
  }
  for (StringRef Prefix : Req.CommentPrefixes) {
    PrefixRegexStr.push_back('|');
    PrefixRegexStr.append(Prefix);
  }

  return Regex(PrefixRegexStr);
}

Error FileCheckPatternContext::defineCmdlineVariables(
    ArrayRef<StringRef> CmdlineDefines, SourceMgr &SM) {
  assert(GlobalVariableTable.empty() && GlobalNumericVariableTable.empty() &&
         "Overriding defined variable with command-line variable definitions");

  if (CmdlineDefines.empty())
    return Error::success();

  // Create a string representing the vector of command-line definitions. Each
  // definition is on its own line and prefixed with a definition number to
  // clarify which definition a given diagnostic corresponds to.
  unsigned I = 0;
  Error Errs = Error::success();
  std::string CmdlineDefsDiag;
  SmallVector<std::pair<size_t, size_t>, 4> CmdlineDefsIndices;
  for (StringRef CmdlineDef : CmdlineDefines) {
    std::string DefPrefix = ("Global define #" + Twine(++I) + ": ").str();
    size_t EqIdx = CmdlineDef.find('=');
    if (EqIdx == StringRef::npos) {
      CmdlineDefsIndices.push_back(std::make_pair(CmdlineDefsDiag.size(), 0));
      continue;
    }
    // Numeric variable definition.
    if (CmdlineDef[0] == '#') {
      // Append a copy of the command-line definition adapted to use the same
      // format as in the input file to be able to reuse
      // parseNumericSubstitutionBlock.
      CmdlineDefsDiag += (DefPrefix + CmdlineDef + " (parsed as: [[").str();
      std::string SubstitutionStr = std::string(CmdlineDef);
      SubstitutionStr[EqIdx] = ':';
      CmdlineDefsIndices.push_back(
          std::make_pair(CmdlineDefsDiag.size(), SubstitutionStr.size()));
      CmdlineDefsDiag += (SubstitutionStr + Twine("]])\n")).str();
    } else {
      CmdlineDefsDiag += DefPrefix;
      CmdlineDefsIndices.push_back(
          std::make_pair(CmdlineDefsDiag.size(), CmdlineDef.size()));
      CmdlineDefsDiag += (CmdlineDef + "\n").str();
    }
  }

  // Create a buffer with fake command line content in order to display
  // parsing diagnostic with location information and point to the
  // global definition with invalid syntax.
  std::unique_ptr<MemoryBuffer> CmdLineDefsDiagBuffer =
      MemoryBuffer::getMemBufferCopy(CmdlineDefsDiag, "Global defines");
  StringRef CmdlineDefsDiagRef = CmdLineDefsDiagBuffer->getBuffer();
  SM.AddNewSourceBuffer(std::move(CmdLineDefsDiagBuffer), SMLoc());

  for (std::pair<size_t, size_t> CmdlineDefIndices : CmdlineDefsIndices) {
    StringRef CmdlineDef = CmdlineDefsDiagRef.substr(CmdlineDefIndices.first,
                                                     CmdlineDefIndices.second);
    if (CmdlineDef.empty()) {
      Errs = joinErrors(
          std::move(Errs),
          ErrorDiagnostic::get(SM, CmdlineDef,
                               "missing equal sign in global definition"));
      continue;
    }

    // Numeric variable definition.
    if (CmdlineDef[0] == '#') {
      // Now parse the definition both to check that the syntax is correct and
      // to create the necessary class instance.
      StringRef CmdlineDefExpr = CmdlineDef.substr(1);
      Optional<NumericVariable *> DefinedNumericVariable;
      Expected<std::unique_ptr<Expression>> ExpressionResult =
          Pattern::parseNumericSubstitutionBlock(
              CmdlineDefExpr, DefinedNumericVariable, false, None, this, SM);
      if (!ExpressionResult) {
        Errs = joinErrors(std::move(Errs), ExpressionResult.takeError());
        continue;
      }
      std::unique_ptr<Expression> Expression = std::move(*ExpressionResult);
      // Now evaluate the expression whose value this variable should be set
      // to, since the expression of a command-line variable definition should
      // only use variables defined earlier on the command-line. If not, this
      // is an error and we report it.
      Expected<ExpressionValue> Value = Expression->getAST()->eval();
      if (!Value) {
        Errs = joinErrors(std::move(Errs), Value.takeError());
        continue;
      }

      assert(DefinedNumericVariable && "No variable defined");
      (*DefinedNumericVariable)->setValue(*Value);

      // Record this variable definition.
      GlobalNumericVariableTable[(*DefinedNumericVariable)->getName()] =
          *DefinedNumericVariable;
    } else {
      // String variable definition.
      std::pair<StringRef, StringRef> CmdlineNameVal = CmdlineDef.split('=');
      StringRef CmdlineName = CmdlineNameVal.first;
      StringRef OrigCmdlineName = CmdlineName;
      Expected<Pattern::VariableProperties> ParseVarResult =
          Pattern::parseVariable(CmdlineName, SM);
      if (!ParseVarResult) {
        Errs = joinErrors(std::move(Errs), ParseVarResult.takeError());
        continue;
      }
      // Check that CmdlineName does not denote a pseudo variable is only
      // composed of the parsed numeric variable. This catches cases like
      // "FOO+2" in a "FOO+2=10" definition.
      if (ParseVarResult->IsPseudo || !CmdlineName.empty()) {
        Errs = joinErrors(std::move(Errs),
                          ErrorDiagnostic::get(
                              SM, OrigCmdlineName,
                              "invalid name in string variable definition '" +
                                  OrigCmdlineName + "'"));
        continue;
      }
      StringRef Name = ParseVarResult->Name;

      // Detect collisions between string and numeric variables when the former
      // is created later than the latter.
      if (GlobalNumericVariableTable.find(Name) !=
          GlobalNumericVariableTable.end()) {
        Errs = joinErrors(std::move(Errs),
                          ErrorDiagnostic::get(SM, Name,
                                               "numeric variable with name '" +
                                                   Name + "' already exists"));
        continue;
      }
      GlobalVariableTable.insert(CmdlineNameVal);
      // Mark the string variable as defined to detect collisions between
      // string and numeric variables in defineCmdlineVariables when the latter
      // is created later than the former. We cannot reuse GlobalVariableTable
      // for this by populating it with an empty string since we would then
      // lose the ability to detect the use of an undefined variable in
      // match().
      DefinedVariableTable[Name] = true;
    }
  }

  return Errs;
}

void FileCheckPatternContext::clearLocalVars() {
  SmallVector<StringRef, 16> LocalPatternVars, LocalNumericVars;
  for (const StringMapEntry<StringRef> &Var : GlobalVariableTable)
    if (Var.first()[0] != '$')
      LocalPatternVars.push_back(Var.first());

  // Numeric substitution reads the value of a variable directly, not via
  // GlobalNumericVariableTable. Therefore, we clear local variables by
  // clearing their value which will lead to a numeric substitution failure. We
  // also mark the variable for removal from GlobalNumericVariableTable since
  // this is what defineCmdlineVariables checks to decide that no global
  // variable has been defined.
  for (const auto &Var : GlobalNumericVariableTable)
    if (Var.first()[0] != '$') {
      Var.getValue()->clearValue();
      LocalNumericVars.push_back(Var.first());
    }

  for (const auto &Var : LocalPatternVars)
    GlobalVariableTable.erase(Var);
  for (const auto &Var : LocalNumericVars)
    GlobalNumericVariableTable.erase(Var);
}

bool FileCheck::checkInput(SourceMgr &SM, StringRef Buffer,
                           std::vector<FileCheckDiag> *Diags) {
  bool ChecksFailed = false;

  unsigned i = 0, j = 0, e = CheckStrings->size();
  while (true) {
    StringRef CheckRegion;
    if (j == e) {
      CheckRegion = Buffer;
    } else {
      const FileCheckString &CheckLabelStr = (*CheckStrings)[j];
      if (CheckLabelStr.Pat.getCheckTy() != Check::CheckLabel) {
        ++j;
        continue;
      }

      // Scan to next CHECK-LABEL match, ignoring CHECK-NOT and CHECK-DAG
      size_t MatchLabelLen = 0;
      size_t MatchLabelPos =
          CheckLabelStr.Check(SM, Buffer, true, MatchLabelLen, Req, Diags);
      if (MatchLabelPos == StringRef::npos)
        // Immediately bail if CHECK-LABEL fails, nothing else we can do.
        return false;

      CheckRegion = Buffer.substr(0, MatchLabelPos + MatchLabelLen);
      Buffer = Buffer.substr(MatchLabelPos + MatchLabelLen);
      ++j;
    }

    // Do not clear the first region as it's the one before the first
    // CHECK-LABEL and it would clear variables defined on the command-line
    // before they get used.
    if (i != 0 && Req.EnableVarScope)
      PatternContext->clearLocalVars();

    for (; i != j; ++i) {
      const FileCheckString &CheckStr = (*CheckStrings)[i];

      // Check each string within the scanned region, including a second check
      // of any final CHECK-LABEL (to verify CHECK-NOT and CHECK-DAG)
      size_t MatchLen = 0;
      size_t MatchPos =
          CheckStr.Check(SM, CheckRegion, false, MatchLen, Req, Diags);

      if (MatchPos == StringRef::npos) {
        ChecksFailed = true;
        i = j;
        break;
      }

      CheckRegion = CheckRegion.substr(MatchPos + MatchLen);
    }

    if (j == e)
      break;
  }

  // Success if no checks failed.
  return !ChecksFailed;
}
