//===-- llvm/Support/CFG.h - Process LLVM structures as graphs ---*- C++ -*--=//
//
// This file defines specializations of GraphTraits that allow Function and
// BasicBlock graphs to be treated as proper graphs for generic algorithms.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CFG_H
#define LLVM_CFG_H

#include "Support/GraphTraits.h"
#include "llvm/Function.h"
#include "llvm/BasicBlock.h"
#include "llvm/InstrTypes.h"
#include <iterator>

//===--------------------------------------------------------------------===//
// BasicBlock pred_iterator definition
//===--------------------------------------------------------------------===//

template <class _Ptr,  class _USE_iterator> // Predecessor Iterator
class PredIterator : public std::bidirectional_iterator<_Ptr, ptrdiff_t> {
  _Ptr *BB;
  _USE_iterator It;
public:
  typedef PredIterator<_Ptr,_USE_iterator> _Self;
  
  inline void advancePastConstants() {
    // TODO: This is bad
    // Loop to ignore constant pool references
    while (It != BB->use_end() && !isa<TerminatorInst>(*It))
      ++It;
  }
  
  inline PredIterator(_Ptr *bb) : BB(bb), It(bb->use_begin()) {
    advancePastConstants();
  }
  inline PredIterator(_Ptr *bb, bool) : BB(bb), It(bb->use_end()) {}
    
  inline bool operator==(const _Self& x) const { return It == x.It; }
  inline bool operator!=(const _Self& x) const { return !operator==(x); }
  
  inline pointer operator*() const { 
    assert(It != BB->use_end() && "pred_iterator out of range!");
    return cast<Instruction>(*It)->getParent(); 
  }
  inline pointer *operator->() const { return &(operator*()); }
  
  inline _Self& operator++() {   // Preincrement
    assert(It != BB->use_end() && "pred_iterator out of range!");
    ++It; advancePastConstants();
    return *this; 
  }
  
  inline _Self operator++(int) { // Postincrement
    _Self tmp = *this; ++*this; return tmp; 
  }
  
  inline _Self& operator--() { --It; return *this; }  // Predecrement
  inline _Self operator--(int) { // Postdecrement
    _Self tmp = *this; --*this; return tmp;
  }
};

typedef PredIterator<BasicBlock, Value::use_iterator> pred_iterator;
typedef PredIterator<const BasicBlock, 
                     Value::use_const_iterator> pred_const_iterator;

inline pred_iterator pred_begin(BasicBlock *BB) { return pred_iterator(BB); }
inline pred_const_iterator pred_begin(const BasicBlock *BB) {
  return pred_const_iterator(BB);
}
inline pred_iterator pred_end(BasicBlock *BB) { return pred_iterator(BB, true);}
inline pred_const_iterator pred_end(const BasicBlock *BB) {
  return pred_const_iterator(BB, true);
}



//===--------------------------------------------------------------------===//
// BasicBlock succ_iterator definition
//===--------------------------------------------------------------------===//

template <class _Term, class _BB>           // Successor Iterator
class SuccIterator : public std::bidirectional_iterator<_BB, ptrdiff_t> {
  const _Term Term;
  unsigned idx;
public:
  typedef SuccIterator<_Term, _BB> _Self;
  // TODO: This can be random access iterator, need operator+ and stuff tho
    
  inline SuccIterator(_Term T) : Term(T), idx(0) {         // begin iterator
    assert(T && "getTerminator returned null!");
  }
  inline SuccIterator(_Term T, bool)                       // end iterator
    : Term(T), idx(Term->getNumSuccessors()) {
    assert(T && "getTerminator returned null!");
  }
    
  inline bool operator==(const _Self& x) const { return idx == x.idx; }
  inline bool operator!=(const _Self& x) const { return !operator==(x); }
  
  inline pointer operator*() const { return Term->getSuccessor(idx); }
  inline pointer operator->() const { return operator*(); }
  
  inline _Self& operator++() { ++idx; return *this; } // Preincrement
  inline _Self operator++(int) { // Postincrement
    _Self tmp = *this; ++*this; return tmp; 
  }
    
  inline _Self& operator--() { --idx; return *this; }  // Predecrement
  inline _Self operator--(int) { // Postdecrement
    _Self tmp = *this; --*this; return tmp;
  }
};

typedef SuccIterator<TerminatorInst*, BasicBlock> succ_iterator;
typedef SuccIterator<const TerminatorInst*,
                     const BasicBlock> succ_const_iterator;

inline succ_iterator succ_begin(BasicBlock *BB) {
  return succ_iterator(BB->getTerminator());
}
inline succ_const_iterator succ_begin(const BasicBlock *BB) {
  return succ_const_iterator(BB->getTerminator());
}
inline succ_iterator succ_end(BasicBlock *BB) {
  return succ_iterator(BB->getTerminator(), true);
}
inline succ_const_iterator succ_end(const BasicBlock *BB) {
  return succ_const_iterator(BB->getTerminator(), true);
}



//===--------------------------------------------------------------------===//
// GraphTraits specializations for basic block graphs (CFGs)
//===--------------------------------------------------------------------===//

// Provide specializations of GraphTraits to be able to treat a function as a 
// graph of basic blocks...

template <> struct GraphTraits<BasicBlock*> {
  typedef BasicBlock NodeType;
  typedef succ_iterator ChildIteratorType;

  static NodeType *getEntryNode(BasicBlock *BB) { return BB; }
  static inline ChildIteratorType child_begin(NodeType *N) { 
    return succ_begin(N);
  }
  static inline ChildIteratorType child_end(NodeType *N) { 
    return succ_end(N);
  }
};

template <> struct GraphTraits<const BasicBlock*> {
  typedef const BasicBlock NodeType;
  typedef succ_const_iterator ChildIteratorType;

  static NodeType *getEntryNode(const BasicBlock *BB) { return BB; }

  static inline ChildIteratorType child_begin(NodeType *N) { 
    return succ_begin(N);
  }
  static inline ChildIteratorType child_end(NodeType *N) { 
    return succ_end(N);
  }
};

// Provide specializations of GraphTraits to be able to treat a function as a 
// graph of basic blocks... and to walk it in inverse order.  Inverse order for
// a function is considered to be when traversing the predecessor edges of a BB
// instead of the successor edges.
//
template <> struct GraphTraits<Inverse<BasicBlock*> > {
  typedef BasicBlock NodeType;
  typedef pred_iterator ChildIteratorType;
  static NodeType *getEntryNode(Inverse<BasicBlock *> G) { return G.Graph; }
  static inline ChildIteratorType child_begin(NodeType *N) { 
    return pred_begin(N);
  }
  static inline ChildIteratorType child_end(NodeType *N) { 
    return pred_end(N);
  }
};

template <> struct GraphTraits<Inverse<const BasicBlock*> > {
  typedef const BasicBlock NodeType;
  typedef pred_const_iterator ChildIteratorType;
  static NodeType *getEntryNode(Inverse<const BasicBlock*> G) {
    return G.Graph; 
  }
  static inline ChildIteratorType child_begin(NodeType *N) { 
    return pred_begin(N);
  }
  static inline ChildIteratorType child_end(NodeType *N) { 
    return pred_end(N);
  }
};



//===--------------------------------------------------------------------===//
// GraphTraits specializations for function basic block graphs (CFGs)
//===--------------------------------------------------------------------===//

// Provide specializations of GraphTraits to be able to treat a function as a 
// graph of basic blocks... these are the same as the basic block iterators,
// except that the root node is implicitly the first node of the function.
//
template <> struct GraphTraits<Function*> : public GraphTraits<BasicBlock*> {
  static NodeType *getEntryNode(Function *F) { return &F->getEntryNode(); }
};
template <> struct GraphTraits<const Function*> :
  public GraphTraits<const BasicBlock*> {
  static NodeType *getEntryNode(const Function *F) { return &F->getEntryNode();}
};


// Provide specializations of GraphTraits to be able to treat a function as a 
// graph of basic blocks... and to walk it in inverse order.  Inverse order for
// a function is considered to be when traversing the predecessor edges of a BB
// instead of the successor edges.
//
template <> struct GraphTraits<Inverse<Function*> > :
  public GraphTraits<Inverse<BasicBlock*> > {
  static NodeType *getEntryNode(Inverse<Function*> G) {
    return &G.Graph->getEntryNode();
  }
};
template <> struct GraphTraits<Inverse<const Function*> > :
  public GraphTraits<Inverse<const BasicBlock*> > {
  static NodeType *getEntryNode(Inverse<const Function *> G) {
    return &G.Graph->getEntryNode();
  }
};

#endif
