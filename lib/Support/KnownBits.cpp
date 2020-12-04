//===-- KnownBits.cpp - Stores known zeros/ones ---------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains a class for representing known zeros and ones used by
// computeKnownBits.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/KnownBits.h"
#include <cassert>

using namespace llvm;

static KnownBits computeForAddCarry(
    const KnownBits &LHS, const KnownBits &RHS,
    bool CarryZero, bool CarryOne) {
  assert(!(CarryZero && CarryOne) &&
         "Carry can't be zero and one at the same time");

  APInt PossibleSumZero = LHS.getMaxValue() + RHS.getMaxValue() + !CarryZero;
  APInt PossibleSumOne = LHS.getMinValue() + RHS.getMinValue() + CarryOne;

  // Compute known bits of the carry.
  APInt CarryKnownZero = ~(PossibleSumZero ^ LHS.Zero ^ RHS.Zero);
  APInt CarryKnownOne = PossibleSumOne ^ LHS.One ^ RHS.One;

  // Compute set of known bits (where all three relevant bits are known).
  APInt LHSKnownUnion = LHS.Zero | LHS.One;
  APInt RHSKnownUnion = RHS.Zero | RHS.One;
  APInt CarryKnownUnion = std::move(CarryKnownZero) | CarryKnownOne;
  APInt Known = std::move(LHSKnownUnion) & RHSKnownUnion & CarryKnownUnion;

  assert((PossibleSumZero & Known) == (PossibleSumOne & Known) &&
         "known bits of sum differ");

  // Compute known bits of the result.
  KnownBits KnownOut;
  KnownOut.Zero = ~std::move(PossibleSumZero) & Known;
  KnownOut.One = std::move(PossibleSumOne) & Known;
  return KnownOut;
}

KnownBits KnownBits::computeForAddCarry(
    const KnownBits &LHS, const KnownBits &RHS, const KnownBits &Carry) {
  assert(Carry.getBitWidth() == 1 && "Carry must be 1-bit");
  return ::computeForAddCarry(
      LHS, RHS, Carry.Zero.getBoolValue(), Carry.One.getBoolValue());
}

KnownBits KnownBits::computeForAddSub(bool Add, bool NSW,
                                      const KnownBits &LHS, KnownBits RHS) {
  KnownBits KnownOut;
  if (Add) {
    // Sum = LHS + RHS + 0
    KnownOut = ::computeForAddCarry(
        LHS, RHS, /*CarryZero*/true, /*CarryOne*/false);
  } else {
    // Sum = LHS + ~RHS + 1
    std::swap(RHS.Zero, RHS.One);
    KnownOut = ::computeForAddCarry(
        LHS, RHS, /*CarryZero*/false, /*CarryOne*/true);
  }

  // Are we still trying to solve for the sign bit?
  if (!KnownOut.isNegative() && !KnownOut.isNonNegative()) {
    if (NSW) {
      // Adding two non-negative numbers, or subtracting a negative number from
      // a non-negative one, can't wrap into negative.
      if (LHS.isNonNegative() && RHS.isNonNegative())
        KnownOut.makeNonNegative();
      // Adding two negative numbers, or subtracting a non-negative number from
      // a negative one, can't wrap into non-negative.
      else if (LHS.isNegative() && RHS.isNegative())
        KnownOut.makeNegative();
    }
  }

  return KnownOut;
}

KnownBits KnownBits::sextInReg(unsigned SrcBitWidth) const {
  unsigned BitWidth = getBitWidth();
  assert(BitWidth >= SrcBitWidth && "Illegal sext-in-register");

  // Sign extension.  Compute the demanded bits in the result that are not
  // present in the input.
  APInt NewBits = APInt::getHighBitsSet(BitWidth, BitWidth - SrcBitWidth);

  // If the sign extended bits are demanded, we know that the sign
  // bit is demanded.
  APInt InSignMask = APInt::getSignMask(SrcBitWidth).zext(BitWidth);
  APInt InDemandedBits = APInt::getLowBitsSet(BitWidth, SrcBitWidth);
  if (NewBits.getBoolValue())
    InDemandedBits |= InSignMask;

  KnownBits Result;
  Result.One = One & InDemandedBits;
  Result.Zero = Zero & InDemandedBits;

  // If the sign bit of the input is known set or clear, then we know the
  // top bits of the result.
  if (Result.Zero.intersects(InSignMask)) { // Input sign bit known clear
    Result.Zero |= NewBits;
    Result.One &= ~NewBits;
  } else if (Result.One.intersects(InSignMask)) { // Input sign bit known set
    Result.One |= NewBits;
    Result.Zero &= ~NewBits;
  } else { // Input sign bit unknown
    Result.Zero &= ~NewBits;
    Result.One &= ~NewBits;
  }

  return Result;
}

KnownBits KnownBits::makeGE(const APInt &Val) const {
  // Count the number of leading bit positions where our underlying value is
  // known to be less than or equal to Val.
  unsigned N = (Zero | Val).countLeadingOnes();

  // For each of those bit positions, if Val has a 1 in that bit then our
  // underlying value must also have a 1.
  APInt MaskedVal(Val);
  MaskedVal.clearLowBits(getBitWidth() - N);
  return KnownBits(Zero, One | MaskedVal);
}

KnownBits KnownBits::umax(const KnownBits &LHS, const KnownBits &RHS) {
  // If we can prove that LHS >= RHS then use LHS as the result. Likewise for
  // RHS. Ideally our caller would already have spotted these cases and
  // optimized away the umax operation, but we handle them here for
  // completeness.
  if (LHS.getMinValue().uge(RHS.getMaxValue()))
    return LHS;
  if (RHS.getMinValue().uge(LHS.getMaxValue()))
    return RHS;

  // If the result of the umax is LHS then it must be greater than or equal to
  // the minimum possible value of RHS. Likewise for RHS. Any known bits that
  // are common to these two values are also known in the result.
  KnownBits L = LHS.makeGE(RHS.getMinValue());
  KnownBits R = RHS.makeGE(LHS.getMinValue());
  return KnownBits::commonBits(L, R);
}

KnownBits KnownBits::umin(const KnownBits &LHS, const KnownBits &RHS) {
  // Flip the range of values: [0, 0xFFFFFFFF] <-> [0xFFFFFFFF, 0]
  auto Flip = [](const KnownBits &Val) { return KnownBits(Val.One, Val.Zero); };
  return Flip(umax(Flip(LHS), Flip(RHS)));
}

KnownBits KnownBits::smax(const KnownBits &LHS, const KnownBits &RHS) {
  // Flip the range of values: [-0x80000000, 0x7FFFFFFF] <-> [0, 0xFFFFFFFF]
  auto Flip = [](const KnownBits &Val) {
    unsigned SignBitPosition = Val.getBitWidth() - 1;
    APInt Zero = Val.Zero;
    APInt One = Val.One;
    Zero.setBitVal(SignBitPosition, Val.One[SignBitPosition]);
    One.setBitVal(SignBitPosition, Val.Zero[SignBitPosition]);
    return KnownBits(Zero, One);
  };
  return Flip(umax(Flip(LHS), Flip(RHS)));
}

KnownBits KnownBits::smin(const KnownBits &LHS, const KnownBits &RHS) {
  // Flip the range of values: [-0x80000000, 0x7FFFFFFF] <-> [0xFFFFFFFF, 0]
  auto Flip = [](const KnownBits &Val) {
    unsigned SignBitPosition = Val.getBitWidth() - 1;
    APInt Zero = Val.One;
    APInt One = Val.Zero;
    Zero.setBitVal(SignBitPosition, Val.Zero[SignBitPosition]);
    One.setBitVal(SignBitPosition, Val.One[SignBitPosition]);
    return KnownBits(Zero, One);
  };
  return Flip(umax(Flip(LHS), Flip(RHS)));
}

KnownBits KnownBits::shl(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  KnownBits Known(BitWidth);

  // If the shift amount is a valid constant then transform LHS directly.
  if (RHS.isConstant() && RHS.getConstant().ult(BitWidth)) {
    unsigned Shift = RHS.getConstant().getZExtValue();
    Known = LHS;
    Known.Zero <<= Shift;
    Known.One <<= Shift;
    // Low bits are known zero.
    Known.Zero.setLowBits(Shift);
    return Known;
  }

  // No matter the shift amount, the trailing zeros will stay zero.
  unsigned MinTrailingZeros = LHS.countMinTrailingZeros();

  // Minimum shift amount low bits are known zero.
  if (RHS.getMinValue().ult(BitWidth)) {
    MinTrailingZeros += RHS.getMinValue().getZExtValue();
    MinTrailingZeros = std::min(MinTrailingZeros, BitWidth);
  }

  Known.Zero.setLowBits(MinTrailingZeros);
  return Known;
}

KnownBits KnownBits::lshr(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  KnownBits Known(BitWidth);

  if (RHS.isConstant() && RHS.getConstant().ult(BitWidth)) {
    unsigned Shift = RHS.getConstant().getZExtValue();
    Known = LHS;
    Known.Zero.lshrInPlace(Shift);
    Known.One.lshrInPlace(Shift);
    // High bits are known zero.
    Known.Zero.setHighBits(Shift);
    return Known;
  }

  // No matter the shift amount, the leading zeros will stay zero.
  unsigned MinLeadingZeros = LHS.countMinLeadingZeros();

  // Minimum shift amount high bits are known zero.
  if (RHS.getMinValue().ult(BitWidth)) {
    MinLeadingZeros += RHS.getMinValue().getZExtValue();
    MinLeadingZeros = std::min(MinLeadingZeros, BitWidth);
  }

  Known.Zero.setHighBits(MinLeadingZeros);
  return Known;
}

KnownBits KnownBits::ashr(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  KnownBits Known(BitWidth);

  if (RHS.isConstant() && RHS.getConstant().ult(BitWidth)) {
    unsigned Shift = RHS.getConstant().getZExtValue();
    Known = LHS;
    Known.Zero.ashrInPlace(Shift);
    Known.One.ashrInPlace(Shift);
    return Known;
  }

  // No matter the shift amount, the leading sign bits will stay.
  unsigned MinLeadingZeros = LHS.countMinLeadingZeros();
  unsigned MinLeadingOnes = LHS.countMinLeadingOnes();

  // Minimum shift amount high bits are known sign bits.
  if (RHS.getMinValue().ult(BitWidth)) {
    if (MinLeadingZeros) {
      MinLeadingZeros += RHS.getMinValue().getZExtValue();
      MinLeadingZeros = std::min(MinLeadingZeros, BitWidth);
    }
    if (MinLeadingOnes) {
      MinLeadingOnes += RHS.getMinValue().getZExtValue();
      MinLeadingOnes = std::min(MinLeadingOnes, BitWidth);
    }
  }

  Known.Zero.setHighBits(MinLeadingZeros);
  Known.One.setHighBits(MinLeadingOnes);
  return Known;
}

KnownBits KnownBits::abs(bool IntMinIsPoison) const {
  // If the source's MSB is zero then we know the rest of the bits already.
  if (isNonNegative())
    return *this;

  // Absolute value preserves trailing zero count.
  KnownBits KnownAbs(getBitWidth());
  KnownAbs.Zero.setLowBits(countMinTrailingZeros());

  // We only know that the absolute values's MSB will be zero if INT_MIN is
  // poison, or there is a set bit that isn't the sign bit (otherwise it could
  // be INT_MIN).
  if (IntMinIsPoison || (!One.isNullValue() && !One.isMinSignedValue()))
    KnownAbs.Zero.setSignBit();

  // FIXME: Handle known negative input?
  // FIXME: Calculate the negated Known bits and combine them?
  return KnownAbs;
}

KnownBits KnownBits::computeForMul(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();

  assert(!LHS.hasConflict() && !RHS.hasConflict());
  // Compute a conservative estimate for high known-0 bits.
  unsigned LeadZ =
      std::max(LHS.countMinLeadingZeros() + RHS.countMinLeadingZeros(),
               BitWidth) -
      BitWidth;
  LeadZ = std::min(LeadZ, BitWidth);

  // The result of the bottom bits of an integer multiply can be
  // inferred by looking at the bottom bits of both operands and
  // multiplying them together.
  // We can infer at least the minimum number of known trailing bits
  // of both operands. Depending on number of trailing zeros, we can
  // infer more bits, because (a*b) <=> ((a/m) * (b/n)) * (m*n) assuming
  // a and b are divisible by m and n respectively.
  // We then calculate how many of those bits are inferrable and set
  // the output. For example, the i8 mul:
  //  a = XXXX1100 (12)
  //  b = XXXX1110 (14)
  // We know the bottom 3 bits are zero since the first can be divided by
  // 4 and the second by 2, thus having ((12/4) * (14/2)) * (2*4).
  // Applying the multiplication to the trimmed arguments gets:
  //    XX11 (3)
  //    X111 (7)
  // -------
  //    XX11
  //   XX11
  //  XX11
  // XX11
  // -------
  // XXXXX01
  // Which allows us to infer the 2 LSBs. Since we're multiplying the result
  // by 8, the bottom 3 bits will be 0, so we can infer a total of 5 bits.
  // The proof for this can be described as:
  // Pre: (C1 >= 0) && (C1 < (1 << C5)) && (C2 >= 0) && (C2 < (1 << C6)) &&
  //      (C7 == (1 << (umin(countTrailingZeros(C1), C5) +
  //                    umin(countTrailingZeros(C2), C6) +
  //                    umin(C5 - umin(countTrailingZeros(C1), C5),
  //                         C6 - umin(countTrailingZeros(C2), C6)))) - 1)
  // %aa = shl i8 %a, C5
  // %bb = shl i8 %b, C6
  // %aaa = or i8 %aa, C1
  // %bbb = or i8 %bb, C2
  // %mul = mul i8 %aaa, %bbb
  // %mask = and i8 %mul, C7
  //   =>
  // %mask = i8 ((C1*C2)&C7)
  // Where C5, C6 describe the known bits of %a, %b
  // C1, C2 describe the known bottom bits of %a, %b.
  // C7 describes the mask of the known bits of the result.
  const APInt &Bottom0 = LHS.One;
  const APInt &Bottom1 = RHS.One;

  // How many times we'd be able to divide each argument by 2 (shr by 1).
  // This gives us the number of trailing zeros on the multiplication result.
  unsigned TrailBitsKnown0 = (LHS.Zero | LHS.One).countTrailingOnes();
  unsigned TrailBitsKnown1 = (RHS.Zero | RHS.One).countTrailingOnes();
  unsigned TrailZero0 = LHS.countMinTrailingZeros();
  unsigned TrailZero1 = RHS.countMinTrailingZeros();
  unsigned TrailZ = TrailZero0 + TrailZero1;

  // Figure out the fewest known-bits operand.
  unsigned SmallestOperand =
      std::min(TrailBitsKnown0 - TrailZero0, TrailBitsKnown1 - TrailZero1);
  unsigned ResultBitsKnown = std::min(SmallestOperand + TrailZ, BitWidth);

  APInt BottomKnown =
      Bottom0.getLoBits(TrailBitsKnown0) * Bottom1.getLoBits(TrailBitsKnown1);

  KnownBits Res(BitWidth);
  Res.Zero.setHighBits(LeadZ);
  Res.Zero |= (~BottomKnown).getLoBits(ResultBitsKnown);
  Res.One = BottomKnown.getLoBits(ResultBitsKnown);
  return Res;
}

KnownBits KnownBits::udiv(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  assert(!LHS.hasConflict() && !RHS.hasConflict());
  KnownBits Known(BitWidth);

  // For the purposes of computing leading zeros we can conservatively
  // treat a udiv as a logical right shift by the power of 2 known to
  // be less than the denominator.
  unsigned LeadZ = LHS.countMinLeadingZeros();
  unsigned RHSMaxLeadingZeros = RHS.countMaxLeadingZeros();

  if (RHSMaxLeadingZeros != BitWidth)
    LeadZ = std::min(BitWidth, LeadZ + BitWidth - RHSMaxLeadingZeros - 1);

  Known.Zero.setHighBits(LeadZ);
  return Known;
}

KnownBits KnownBits::urem(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  assert(!LHS.hasConflict() && !RHS.hasConflict());
  KnownBits Known(BitWidth);

  if (RHS.isConstant() && RHS.getConstant().isPowerOf2()) {
    // The upper bits are all zero, the lower ones are unchanged.
    APInt LowBits = RHS.getConstant() - 1;
    Known.Zero = LHS.Zero | ~LowBits;
    Known.One = LHS.One & LowBits;
    return Known;
  }

  // Since the result is less than or equal to either operand, any leading
  // zero bits in either operand must also exist in the result.
  uint32_t Leaders =
      std::max(LHS.countMinLeadingZeros(), RHS.countMinLeadingZeros());
  Known.Zero.setHighBits(Leaders);
  return Known;
}

KnownBits KnownBits::srem(const KnownBits &LHS, const KnownBits &RHS) {
  unsigned BitWidth = LHS.getBitWidth();
  assert(!LHS.hasConflict() && !RHS.hasConflict());
  KnownBits Known(BitWidth);

  if (RHS.isConstant() && RHS.getConstant().isPowerOf2()) {
    // The low bits of the first operand are unchanged by the srem.
    APInt LowBits = RHS.getConstant() - 1;
    Known.Zero = LHS.Zero & LowBits;
    Known.One = LHS.One & LowBits;

    // If the first operand is non-negative or has all low bits zero, then
    // the upper bits are all zero.
    if (LHS.isNonNegative() || LowBits.isSubsetOf(LHS.Zero))
      Known.Zero |= ~LowBits;

    // If the first operand is negative and not all low bits are zero, then
    // the upper bits are all one.
    if (LHS.isNegative() && LowBits.intersects(LHS.One))
      Known.One |= ~LowBits;
    return Known;
  }

  // The sign bit is the LHS's sign bit, except when the result of the
  // remainder is zero. If it's known zero, our sign bit is also zero.
  if (LHS.isNonNegative())
    Known.makeNonNegative();
  return Known;
}

KnownBits &KnownBits::operator&=(const KnownBits &RHS) {
  // Result bit is 0 if either operand bit is 0.
  Zero |= RHS.Zero;
  // Result bit is 1 if both operand bits are 1.
  One &= RHS.One;
  return *this;
}

KnownBits &KnownBits::operator|=(const KnownBits &RHS) {
  // Result bit is 0 if both operand bits are 0.
  Zero &= RHS.Zero;
  // Result bit is 1 if either operand bit is 1.
  One |= RHS.One;
  return *this;
}

KnownBits &KnownBits::operator^=(const KnownBits &RHS) {
  // Result bit is 0 if both operand bits are 0 or both are 1.
  APInt Z = (Zero & RHS.Zero) | (One & RHS.One);
  // Result bit is 1 if one operand bit is 0 and the other is 1.
  One = (Zero & RHS.One) | (One & RHS.Zero);
  Zero = std::move(Z);
  return *this;
}
