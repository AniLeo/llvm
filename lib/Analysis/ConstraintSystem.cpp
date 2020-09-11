//===- ConstraintSytem.cpp - A system of linear constraints. ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/ConstraintSystem.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/Debug.h"

#include <algorithm>
#include <string>

using namespace llvm;

#define DEBUG_TYPE "constraint-system"

bool ConstraintSystem::eliminateUsingFM() {
  // Implementation of Fourier–Motzkin elimination, with some tricks from the
  // paper Pugh, William. "The Omega test: a fast and practical integer
  // programming algorithm for dependence
  //  analysis."
  // Supercomputing'91: Proceedings of the 1991 ACM/
  // IEEE conference on Supercomputing. IEEE, 1991.
  assert(!Constraints.empty() &&
         "should only be called for non-empty constraint systems");
  unsigned NumVariables = Constraints[0].size();
  SmallVector<SmallVector<int64_t, 8>, 4> NewSystem;

  unsigned NumConstraints = Constraints.size();
  uint32_t NewGCD = 1;
  // FIXME do not use copy
  for (unsigned R1 = 0; R1 < NumConstraints; R1++) {
    if (Constraints[R1][1] == 0) {
      SmallVector<int64_t, 8> NR;
      NR.push_back(Constraints[R1][0]);
      for (unsigned i = 2; i < NumVariables; i++) {
        NR.push_back(Constraints[R1][i]);
      }
      NewSystem.push_back(std::move(NR));
      continue;
    }

    // FIXME do not use copy
    bool EliminatedInRow = false;
    for (unsigned R2 = R1 + 1; R2 < NumConstraints; R2++) {
      if (R1 == R2)
        continue;

      // FIXME: can we do better than just dropping things here?
      if (Constraints[R2][1] == 0)
        continue;

      if ((Constraints[R1][1] < 0 && Constraints[R2][1] < 0) ||
          (Constraints[R1][1] > 0 && Constraints[R2][1] > 0))
        continue;

      unsigned LowerR = R1;
      unsigned UpperR = R2;
      if (Constraints[UpperR][1] < 0)
        std::swap(LowerR, UpperR);

      SmallVector<int64_t, 8> NR;
      for (unsigned I = 0; I < NumVariables; I++) {
        if (I == 1)
          continue;

        int64_t M1, M2, N;
        if (__builtin_mul_overflow(Constraints[UpperR][I],
                                   ((-1) * Constraints[LowerR][1] / GCD), &M1))
          return false;
        if (__builtin_mul_overflow(Constraints[LowerR][I],
                                   (Constraints[UpperR][1] / GCD), &M2))
          return false;
        if (__builtin_add_overflow(M1, M2, &N))
          return false;
        NR.push_back(N);

        NewGCD = APIntOps::GreatestCommonDivisor({32, (uint32_t)NR.back()},
                                                 {32, NewGCD})
                     .getZExtValue();
      }
      NewSystem.push_back(std::move(NR));
      EliminatedInRow = true;
    }
  }
  Constraints = std::move(NewSystem);
  GCD = NewGCD;

  return true;
}

bool ConstraintSystem::mayHaveSolutionImpl() {
  while (!Constraints.empty() && Constraints[0].size() > 1) {
    if (!eliminateUsingFM())
      return true;
  }

  if (Constraints.empty() || Constraints[0].size() > 1)
    return true;

  return all_of(Constraints, [](auto &R) { return R[0] >= 0; });
}

void ConstraintSystem::dump(ArrayRef<std::string> Names) const {
  if (Constraints.empty())
    return;

  for (auto &Row : Constraints) {
    SmallVector<std::string, 16> Parts;
    for (unsigned I = 1, S = Row.size(); I < S; ++I) {
      if (Row[I] == 0)
        continue;
      std::string Coefficient = "";
      if (Row[I] != 1)
        Coefficient = std::to_string(Row[I]) + " * ";
      Parts.push_back(Coefficient + Names[I - 1]);
    }
    assert(!Parts.empty() && "need to have at least some parts");
    LLVM_DEBUG(dbgs() << join(Parts, std::string(" + "))
                      << " <= " << std::to_string(Row[0]) << "\n");
  }
}

void ConstraintSystem::dump() const {
  SmallVector<std::string, 16> Names;
  for (unsigned i = 1; i < Constraints.back().size(); ++i)
    Names.push_back("x" + std::to_string(i));
  LLVM_DEBUG(dbgs() << "---\n");
  dump(Names);
}

bool ConstraintSystem::mayHaveSolution() {
  dump();
  bool HasSolution = mayHaveSolutionImpl();
  LLVM_DEBUG(dbgs() << (HasSolution ? "sat" : "unsat") << "\n");
  return HasSolution;
}
