//===- ListReducer.h - Trim down list while retaining property --*- C++ -*-===//
//
// This class is to be used as a base class for operations that want to zero in
// on a subset of the input which still causes the bug we are tracking.
//
//===----------------------------------------------------------------------===//

#ifndef BUGPOINT_LIST_REDUCER_H
#define BUGPOINT_LIST_REDUCER_H

#include <vector>

template<typename ElTy>
struct ListReducer {
  enum TestResult {
    NoFailure,         // No failure of the predicate was detected
    KeepSuffix,        // The suffix alone satisfies the predicate
    KeepPrefix,        // The prefix alone satisfies the predicate
  };

  // doTest - This virtual function should be overriden by subclasses to
  // implement the test desired.  The testcase is only required to test to see
  // if the Kept list still satisfies the property, but if it is going to check
  // the prefix anyway, it can.
  //
  virtual TestResult doTest(std::vector<ElTy> &Prefix,
                            std::vector<ElTy> &Kept) = 0;

  // reduceList - This function attempts to reduce the length of the specified
  // list while still maintaining the "test" property.  This is the core of the
  // "work" that bugpoint does.
  //
  void reduceList(std::vector<ElTy> &TheList) {
    unsigned MidTop = TheList.size();
    while (MidTop > 1) {
      unsigned Mid = MidTop / 2;
      std::vector<ElTy> Prefix(TheList.begin(), TheList.begin()+Mid);
      std::vector<ElTy> Suffix(TheList.begin()+Mid, TheList.end());

      switch (doTest(Prefix, Suffix)) {
      case KeepSuffix:
        // The property still holds.  We can just drop the prefix elements, and
        // shorten the list to the "kept" elements.
        TheList.swap(Suffix);
        MidTop = TheList.size();
        break;
      case KeepPrefix:
        // The predicate still holds, shorten the list to the prefix elements.
        TheList.swap(Prefix);
        MidTop = TheList.size();
        break;
      case NoFailure:
        // Otherwise the property doesn't hold.  Some of the elements we removed
        // must be neccesary to maintain the property.
        MidTop = Mid;
        break;
      }
    }

    // Okay, we trimmed as much off the top and the bottom of the list as we
    // could.  If there is more two elements in the list, try deleting interior
    // elements and testing that.
    //
    if (TheList.size() > 2) {
      bool Changed = true;
      std::vector<ElTy> EmptyList;
      while (Changed) {
        Changed = false;
        std::vector<ElTy> TrimmedList;
        for (unsigned i = 1; i < TheList.size()-1; ++i) { // Check interior elts
          std::vector<ElTy> TestList(TheList);
          TestList.erase(TestList.begin()+i);

          if (doTest(EmptyList, TestList) == KeepSuffix) {
            // We can trim down the list!
            TheList.swap(TestList);
            --i;  // Don't skip an element of the list
            Changed = true;
          }
        }
      }
    }
  }
};

#endif
