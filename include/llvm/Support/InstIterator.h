//===-- llvm/Support/InstIterator.h - Classes for inst iteration -*- C++ -*--=//
//
// This file contains definitions of two iterators for iterating over the
// instructions in a function.  This is effectively a wrapper around a two level
// iterator that can probably be genericized later.
//
// Note that this iterator gets invalidated any time that basic blocks or
// instructions are moved around.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_INST_ITERATOR_H
#define LLVM_INST_ITERATOR_H

#include "llvm/BasicBlock.h"
#include "llvm/Function.h"

// This class is implements inst_begin() & inst_end() for
// inst_iterator and const_inst_iterator's.
//
template <class _BB_t, class _BB_i_t, class _BI_t, class _II_t>
class InstIterator {
  typedef _BB_t   BBty;
  typedef _BB_i_t BBIty;
  typedef _BI_t   BIty;
  typedef _II_t   IIty;
  _BB_t  &BBs;      // BasicBlocksType
  _BB_i_t BB;       // BasicBlocksType::iterator
  _BI_t   BI;       // BasicBlock::iterator
public:
  typedef std::bidirectional_iterator_tag iterator_category;
  typedef IIty                            value_type;
  typedef unsigned                        difference_type;
  typedef BIty                            pointer;
  typedef IIty                            reference;
  
  template<class M> InstIterator(M &m) 
    : BBs(m.getBasicBlockList()), BB(BBs.begin()) {    // begin ctor
    if (BB != BBs.end()) {
      BI = BB->begin();
      advanceToNextBB();
    }
  }

  template<class M> InstIterator(M &m, bool) 
    : BBs(m.getBasicBlockList()), BB(BBs.end()) {    // end ctor
  }

  // Accessors to get at the underlying iterators...
  inline BBIty &getBasicBlockIterator()  { return BB; }
  inline BIty  &getInstructionIterator() { return BI; }
  
  inline IIty operator*()  const { return &*BI; }
  inline IIty operator->() const { return operator*(); }
  
  inline bool operator==(const InstIterator &y) const { 
    return BB == y.BB && (BB == BBs.end() || BI == y.BI);
  }
  inline bool operator!=(const InstIterator& y) const { 
    return !operator==(y);
  }

  InstIterator& operator++() { 
    ++BI;
    advanceToNextBB();
    return *this; 
  }
  inline InstIterator operator++(int) { 
    InstIterator tmp = *this; ++*this; return tmp; 
  }
    
  InstIterator& operator--() { 
    while (BB == BBs.end() || BI == BB->begin()) {
      --BB;
      BI = BB->end();
    }
    --BI;
    return *this; 
  }
  inline InstIterator  operator--(int) { 
    InstIterator tmp = *this; --*this; return tmp; 
  }

  inline bool atEnd() const { return BB == BBs.end(); }

private:
  inline void advanceToNextBB() {
    // The only way that the II could be broken is if it is now pointing to
    // the end() of the current BasicBlock and there are successor BBs.
    while (BI == BB->end()) {
      ++BB;
      if (BB == BBs.end()) break;
      BI = BB->begin();
    }
  }
};


typedef InstIterator<iplist<BasicBlock>,
                     Function::iterator, BasicBlock::iterator,
                     Instruction*> inst_iterator;
typedef InstIterator<const iplist<BasicBlock>,
                     Function::const_iterator, 
                     BasicBlock::const_iterator,
                     const Instruction*> const_inst_iterator;

inline inst_iterator inst_begin(Function *F) { return inst_iterator(*F); }
inline inst_iterator inst_end(Function *F)   { return inst_iterator(*F, true); }
inline const_inst_iterator inst_begin(const Function *F) {
  return const_inst_iterator(*F);
}
inline const_inst_iterator inst_end(const Function *F) {
  return const_inst_iterator(*F, true);
}
inline inst_iterator inst_begin(Function &F) { return inst_iterator(F); }
inline inst_iterator inst_end(Function &F)   { return inst_iterator(F, true); }
inline const_inst_iterator inst_begin(const Function &F) {
  return const_inst_iterator(F);
}
inline const_inst_iterator inst_end(const Function &F) {
  return const_inst_iterator(F, true);
}

#endif
