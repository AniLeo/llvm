//== llvm/Support/APFloat.h - Arbitrary Precision Floating Point -*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief
/// This file declares a class to represent arbitrary precision floating point
/// values and provide a variety of arithmetic operations on them.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_ADT_APFLOAT_H
#define LLVM_ADT_APFLOAT_H

#include "llvm/ADT/APInt.h"

namespace llvm {

/// A signed type to represent a floating point numbers unbiased exponent.
typedef signed short exponent_t;

struct fltSemantics;
class APSInt;
class StringRef;

/// Enum that represents what fraction of the LSB truncated bits of an fp number
/// represent.
///
/// This essentially combines the roles of guard and sticky bits.
enum lostFraction { // Example of truncated bits:
  lfExactlyZero,    // 000000
  lfLessThanHalf,   // 0xxxxx  x's not all zero
  lfExactlyHalf,    // 100000
  lfMoreThanHalf    // 1xxxxx  x's not all zero
};

/// \brief A self-contained host- and target-independent arbitrary-precision
/// floating-point software implementation.
///
/// APFloat uses bignum integer arithmetic as provided by static functions in
/// the APInt class.  The library will work with bignum integers whose parts are
/// any unsigned type at least 16 bits wide, but 64 bits is recommended.
///
/// Written for clarity rather than speed, in particular with a view to use in
/// the front-end of a cross compiler so that target arithmetic can be correctly
/// performed on the host.  Performance should nonetheless be reasonable,
/// particularly for its intended use.  It may be useful as a base
/// implementation for a run-time library during development of a faster
/// target-specific one.
///
/// All 5 rounding modes in the IEEE-754R draft are handled correctly for all
/// implemented operations.  Currently implemented operations are add, subtract,
/// multiply, divide, fused-multiply-add, conversion-to-float,
/// conversion-to-integer and conversion-from-integer.  New rounding modes
/// (e.g. away from zero) can be added with three or four lines of code.
///
/// Four formats are built-in: IEEE single precision, double precision,
/// quadruple precision, and x87 80-bit extended double (when operating with
/// full extended precision).  Adding a new format that obeys IEEE semantics
/// only requires adding two lines of code: a declaration and definition of the
/// format.
///
/// All operations return the status of that operation as an exception bit-mask,
/// so multiple operations can be done consecutively with their results or-ed
/// together.  The returned status can be useful for compiler diagnostics; e.g.,
/// inexact, underflow and overflow can be easily diagnosed on constant folding,
/// and compiler optimizers can determine what exceptions would be raised by
/// folding operations and optimize, or perhaps not optimize, accordingly.
///
/// At present, underflow tininess is detected after rounding; it should be
/// straight forward to add support for the before-rounding case too.
///
/// The library reads hexadecimal floating point numbers as per C99, and
/// correctly rounds if necessary according to the specified rounding mode.
/// Syntax is required to have been validated by the caller.  It also converts
/// floating point numbers to hexadecimal text as per the C99 %a and %A
/// conversions.  The output precision (or alternatively the natural minimal
/// precision) can be specified; if the requested precision is less than the
/// natural precision the output is correctly rounded for the specified rounding
/// mode.
///
/// It also reads decimal floating point numbers and correctly rounds according
/// to the specified rounding mode.
///
/// Conversion to decimal text is not currently implemented.
///
/// Non-zero finite numbers are represented internally as a sign bit, a 16-bit
/// signed exponent, and the significand as an array of integer parts.  After
/// normalization of a number of precision P the exponent is within the range of
/// the format, and if the number is not denormal the P-th bit of the
/// significand is set as an explicit integer bit.  For denormals the most
/// significant bit is shifted right so that the exponent is maintained at the
/// format's minimum, so that the smallest denormal has just the least
/// significant bit of the significand set.  The sign of zeroes and infinities
/// is significant; the exponent and significand of such numbers is not stored,
/// but has a known implicit (deterministic) value: 0 for the significands, 0
/// for zero exponent, all 1 bits for infinity exponent.  For NaNs the sign and
/// significand are deterministic, although not really meaningful, and preserved
/// in non-conversion operations.  The exponent is implicitly all 1 bits.
///
/// APFloat does not provide any exception handling beyond default exception
/// handling. We represent Signaling NaNs via IEEE-754R 2008 6.2.1 should clause
/// by encoding Signaling NaNs with the first bit of its trailing significand as
/// 0.
///
/// TODO
/// ====
///
/// Some features that may or may not be worth adding:
///
/// Binary to decimal conversion (hard).
///
/// Optional ability to detect underflow tininess before rounding.
///
/// New formats: x87 in single and double precision mode (IEEE apart from
/// extended exponent range) (hard).
///
/// New operations: sqrt, IEEE remainder, C90 fmod, nextafter, nexttoward.
///
class APFloat {
public:

  /// \name Floating Point Semantics.
  /// @{

  static const fltSemantics IEEEhalf;
  static const fltSemantics IEEEsingle;
  static const fltSemantics IEEEdouble;
  static const fltSemantics IEEEquad;
  static const fltSemantics PPCDoubleDouble;
  static const fltSemantics x87DoubleExtended;

  /// A Pseudo fltsemantic used to construct APFloats that cannot conflict with
  /// anything real.
  static const fltSemantics Bogus;

  /// @}

  static unsigned int semanticsPrecision(const fltSemantics &);

  /// IEEE-754R 5.11: Floating Point Comparison Relations.
  enum cmpResult {
    cmpLessThan,
    cmpEqual,
    cmpGreaterThan,
    cmpUnordered
  };

  /// IEEE-754R 4.3: Rounding-direction attributes.
  enum roundingMode {
    rmNearestTiesToEven,
    rmTowardPositive,
    rmTowardNegative,
    rmTowardZero,
    rmNearestTiesToAway
  };

  /// IEEE-754R 7: Default exception handling.
  ///
  /// opUnderflow or opOverflow are always returned or-ed with opInexact.
  enum opStatus {
    opOK = 0x00,
    opInvalidOp = 0x01,
    opDivByZero = 0x02,
    opOverflow = 0x04,
    opUnderflow = 0x08,
    opInexact = 0x10
  };

  /// Category of internally-represented number.
  enum fltCategory {
    fcInfinity,
    fcNaN,
    fcNormal,
    fcZero
  };

  /// Convenience enum used to construct an uninitialized APFloat.
  enum uninitializedTag {
    uninitialized
  };

  /// \name Constructors
  /// @{

  APFloat(const fltSemantics &); // Default construct to 0.0
  APFloat(const fltSemantics &, StringRef);
  APFloat(const fltSemantics &, integerPart);
  APFloat(const fltSemantics &, fltCategory, bool negative);
  APFloat(const fltSemantics &, uninitializedTag);
  APFloat(const fltSemantics &, const APInt &);
  explicit APFloat(double d);
  explicit APFloat(float f);
  APFloat(const APFloat &);
  ~APFloat();

  /// @}

  /// \name Convenience "constructors"
  /// @{

  /// Factory for Positive and Negative Zero.
  ///
  /// \param Negative True iff the number should be negative.
  static APFloat getZero(const fltSemantics &Sem, bool Negative = false) {
    return APFloat(Sem, fcZero, Negative);
  }

  /// Factory for Positive and Negative Infinity.
  ///
  /// \param Negative True iff the number should be negative.
  static APFloat getInf(const fltSemantics &Sem, bool Negative = false) {
    return APFloat(Sem, fcInfinity, Negative);
  }

  /// Factory for QNaN values.
  ///
  /// \param Negative - True iff the NaN generated should be negative.
  /// \param type - The unspecified fill bits for creating the NaN, 0 by
  /// default.  The value is truncated as necessary.
  static APFloat getNaN(const fltSemantics &Sem, bool Negative = false,
                        unsigned type = 0) {
    if (type) {
      APInt fill(64, type);
      return getQNaN(Sem, Negative, &fill);
    } else {
      return getQNaN(Sem, Negative, 0);
    }
  }

  /// Factory for QNaN values.
  static APFloat getQNaN(const fltSemantics &Sem, bool Negative = false,
                         const APInt *payload = 0) {
    return makeNaN(Sem, false, Negative, payload);
  }

  /// Factory for SNaN values.
  static APFloat getSNaN(const fltSemantics &Sem, bool Negative = false,
                         const APInt *payload = 0) {
    return makeNaN(Sem, true, Negative, payload);
  }

  /// Returns the largest finite number in the given semantics.
  ///
  /// \param Negative - True iff the number should be negative
  static APFloat getLargest(const fltSemantics &Sem, bool Negative = false);

  /// Returns the smallest (by magnitude) finite number in the given semantics.
  /// Might be denormalized, which implies a relative loss of precision.
  ///
  /// \param Negative - True iff the number should be negative
  static APFloat getSmallest(const fltSemantics &Sem, bool Negative = false);

  /// Returns the smallest (by magnitude) normalized finite number in the given
  /// semantics.
  ///
  /// \param Negative - True iff the number should be negative
  static APFloat getSmallestNormalized(const fltSemantics &Sem,
                                       bool Negative = false);

  /// Returns a float which is bitcasted from an all one value int.
  ///
  /// \param BitWidth - Select float type
  /// \param isIEEE   - If 128 bit number, select between PPC and IEEE
  static APFloat getAllOnesValue(unsigned BitWidth, bool isIEEE = false);

  /// @}

  /// Used to insert APFloat objects, or objects that contain APFloat objects,
  /// into FoldingSets.
  void Profile(FoldingSetNodeID &NID) const;

  /// \brief Used by the Bitcode serializer to emit APInts to Bitcode.
  void Emit(Serializer &S) const;

  /// \brief Used by the Bitcode deserializer to deserialize APInts.
  static APFloat ReadVal(Deserializer &D);

  /// \name Arithmetic
  /// @{

  opStatus add(const APFloat &, roundingMode);
  opStatus subtract(const APFloat &, roundingMode);
  opStatus multiply(const APFloat &, roundingMode);
  opStatus divide(const APFloat &, roundingMode);
  /// IEEE remainder.
  opStatus remainder(const APFloat &);
  /// C fmod, or llvm frem.
  opStatus mod(const APFloat &, roundingMode);
  opStatus fusedMultiplyAdd(const APFloat &, const APFloat &, roundingMode);
  opStatus roundToIntegral(roundingMode);
  /// IEEE-754R 5.3.1: nextUp/nextDown.
  opStatus next(bool nextDown);

  /// \name Sign operations.
  /// @{

  void changeSign();
  void clearSign();
  void copySign(const APFloat &);

  /// @}

  /// \name Conversions
  /// @{

  opStatus convert(const fltSemantics &, roundingMode, bool *);
  opStatus convertToInteger(integerPart *, unsigned int, bool, roundingMode,
                            bool *) const;
  opStatus convertToInteger(APSInt &, roundingMode, bool *) const;
  opStatus convertFromAPInt(const APInt &, bool, roundingMode);
  opStatus convertFromSignExtendedInteger(const integerPart *, unsigned int,
                                          bool, roundingMode);
  opStatus convertFromZeroExtendedInteger(const integerPart *, unsigned int,
                                          bool, roundingMode);
  opStatus convertFromString(StringRef, roundingMode);
  APInt bitcastToAPInt() const;
  double convertToDouble() const;
  float convertToFloat() const;

  /// @}

  /// The definition of equality is not straightforward for floating point, so
  /// we won't use operator==.  Use one of the following, or write whatever it
  /// is you really mean.
  bool operator==(const APFloat &) const LLVM_DELETED_FUNCTION;

  /// IEEE comparison with another floating point number (NaNs compare
  /// unordered, 0==-0).
  cmpResult compare(const APFloat &) const;

  /// Bitwise comparison for equality (QNaNs compare equal, 0!=-0).
  bool bitwiseIsEqual(const APFloat &) const;

  /// Write out a hexadecimal representation of the floating point value to DST,
  /// which must be of sufficient size, in the C99 form [-]0xh.hhhhp[+-]d.
  /// Return the number of characters written, excluding the terminating NUL.
  unsigned int convertToHexString(char *dst, unsigned int hexDigits,
                                  bool upperCase, roundingMode) const;

  /// \name Simple Queries
  /// @{

  fltCategory getCategory() const { return category; }
  const fltSemantics &getSemantics() const { return *semantics; }
  bool isZero() const { return category == fcZero; }
  bool isNonZero() const { return category != fcZero; }
  bool isNormal() const { return category == fcNormal; }
  bool isNaN() const { return category == fcNaN; }
  bool isInfinity() const { return category == fcInfinity; }
  bool isNegative() const { return sign; }
  bool isPosZero() const { return isZero() && !isNegative(); }
  bool isNegZero() const { return isZero() && isNegative(); }
  bool isDenormal() const;
  /// IEEE-754R 5.7.2: isSignaling. Returns true if this is a signaling NaN.
  bool isSignaling() const;

  /// @}

  APFloat &operator=(const APFloat &);

  /// \brief Overload to compute a hash code for an APFloat value.
  ///
  /// Note that the use of hash codes for floating point values is in general
  /// frought with peril. Equality is hard to define for these values. For
  /// example, should negative and positive zero hash to different codes? Are
  /// they equal or not? This hash value implementation specifically
  /// emphasizes producing different codes for different inputs in order to
  /// be used in canonicalization and memoization. As such, equality is
  /// bitwiseIsEqual, and 0 != -0.
  friend hash_code hash_value(const APFloat &Arg);

  /// Converts this value into a decimal string.
  ///
  /// \param FormatPrecision The maximum number of digits of
  ///   precision to output.  If there are fewer digits available,
  ///   zero padding will not be used unless the value is
  ///   integral and small enough to be expressed in
  ///   FormatPrecision digits.  0 means to use the natural
  ///   precision of the number.
  /// \param FormatMaxPadding The maximum number of zeros to
  ///   consider inserting before falling back to scientific
  ///   notation.  0 means to always use scientific notation.
  ///
  /// Number       Precision    MaxPadding      Result
  /// ------       ---------    ----------      ------
  /// 1.01E+4              5             2       10100
  /// 1.01E+4              4             2       1.01E+4
  /// 1.01E+4              5             1       1.01E+4
  /// 1.01E-2              5             2       0.0101
  /// 1.01E-2              4             2       0.0101
  /// 1.01E-2              4             1       1.01E-2
  void toString(SmallVectorImpl<char> &Str, unsigned FormatPrecision = 0,
                unsigned FormatMaxPadding = 3) const;

  /// If this value has an exact multiplicative inverse, store it in inv and
  /// return true.
  bool getExactInverse(APFloat *inv) const;

private:

  /// \name Simple Queries
  /// @{

  integerPart *significandParts();
  const integerPart *significandParts() const;
  unsigned int partCount() const;

  /// @}

  /// \name Significand operations.
  /// @{

  integerPart addSignificand(const APFloat &);
  integerPart subtractSignificand(const APFloat &, integerPart);
  lostFraction addOrSubtractSignificand(const APFloat &, bool subtract);
  lostFraction multiplySignificand(const APFloat &, const APFloat *);
  lostFraction divideSignificand(const APFloat &);
  void incrementSignificand();
  void initialize(const fltSemantics *);
  void shiftSignificandLeft(unsigned int);
  lostFraction shiftSignificandRight(unsigned int);
  unsigned int significandLSB() const;
  unsigned int significandMSB() const;
  void zeroSignificand();
  /// Return true if the significand excluding the integral bit is all ones.
  bool isSignificandAllOnes() const;
  /// Return true if the significand excluding the integral bit is all zeros.
  bool isSignificandAllZeros() const;

  /// @}

  /// \name Arithmetic on special values.
  /// @{

  opStatus addOrSubtractSpecials(const APFloat &, bool subtract);
  opStatus divideSpecials(const APFloat &);
  opStatus multiplySpecials(const APFloat &);
  opStatus modSpecials(const APFloat &);

  /// @}

  /// \name Special value setters.
  /// @{

  void makeLargest(bool Neg = false);
  void makeSmallest(bool Neg = false);
  void makeNaN(bool SNaN = false, bool Neg = false, const APInt *fill = 0);
  static APFloat makeNaN(const fltSemantics &Sem, bool SNaN, bool Negative,
                         const APInt *fill);

  /// @}

  /// \name Special value queries only useful internally to APFloat
  /// @{

  /// Returns true if and only if the number has the smallest possible non-zero
  /// magnitude in the current semantics.
  bool isSmallest() const;
  /// Returns true if and only if the number has the largest possible finite
  /// magnitude in the current semantics.
  bool isLargest() const;

  /// @}

  /// \name Miscellany
  /// @{

  opStatus normalize(roundingMode, lostFraction);
  opStatus addOrSubtract(const APFloat &, roundingMode, bool subtract);
  cmpResult compareAbsoluteValue(const APFloat &) const;
  opStatus handleOverflow(roundingMode);
  bool roundAwayFromZero(roundingMode, lostFraction, unsigned int) const;
  opStatus convertToSignExtendedInteger(integerPart *, unsigned int, bool,
                                        roundingMode, bool *) const;
  opStatus convertFromUnsignedParts(const integerPart *, unsigned int,
                                    roundingMode);
  opStatus convertFromHexadecimalString(StringRef, roundingMode);
  opStatus convertFromDecimalString(StringRef, roundingMode);
  char *convertNormalToHexString(char *, unsigned int, bool,
                                 roundingMode) const;
  opStatus roundSignificandWithExponent(const integerPart *, unsigned int, int,
                                        roundingMode);

  /// @}

  APInt convertHalfAPFloatToAPInt() const;
  APInt convertFloatAPFloatToAPInt() const;
  APInt convertDoubleAPFloatToAPInt() const;
  APInt convertQuadrupleAPFloatToAPInt() const;
  APInt convertF80LongDoubleAPFloatToAPInt() const;
  APInt convertPPCDoubleDoubleAPFloatToAPInt() const;
  void initFromAPInt(const fltSemantics *Sem, const APInt &api);
  void initFromHalfAPInt(const APInt &api);
  void initFromFloatAPInt(const APInt &api);
  void initFromDoubleAPInt(const APInt &api);
  void initFromQuadrupleAPInt(const APInt &api);
  void initFromF80LongDoubleAPInt(const APInt &api);
  void initFromPPCDoubleDoubleAPInt(const APInt &api);

  void assign(const APFloat &);
  void copySignificand(const APFloat &);
  void freeSignificand();

  /// The semantics that this value obeys.
  const fltSemantics *semantics;

  /// A binary fraction with an explicit integer bit.
  ///
  /// The significand must be at least one bit wider than the target precision.
  union Significand {
    integerPart part;
    integerPart *parts;
  } significand;

  /// The signed unbiased exponent of the value.
  exponent_t exponent;

  /// What kind of floating point number this is.
  ///
  /// Only 2 bits are required, but VisualStudio incorrectly sign extends it.
  /// Using the extra bit keeps it from failing under VisualStudio.
  fltCategory category : 3;

  /// Sign bit of the number.
  unsigned int sign : 1;
};

/// See friend declaration above.
///
/// This additional declaration is required in order to compile LLVM with IBM
/// xlC compiler.
hash_code hash_value(const APFloat &Arg);
} // namespace llvm

#endif // LLVM_ADT_APFLOAT_H
