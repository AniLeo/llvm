//===-- llvm/CodeGen/MachineBasicBlock.h ------------------------*- C++ -*-===//
// 
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
// 
//===----------------------------------------------------------------------===//
// 
// Collect the sequence of machine instructions for a basic block.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_MACHINEBASICBLOCK_H
#define LLVM_CODEGEN_MACHINEBASICBLOCK_H

#include "llvm/CodeGen/MachineInstr.h"
#include "Support/ilist"
#include <iosfwd>

namespace llvm {
  class MachineFunction;

// ilist_traits
template <>
class ilist_traits<MachineInstr> {
  // this is only set by the MachineBasicBlock owning the ilist
  friend class MachineBasicBlock;
  MachineBasicBlock* parent;

public:
  ilist_traits<MachineInstr>() : parent(0) { }

  static MachineInstr* getPrev(MachineInstr* N) { return N->prev; }
  static MachineInstr* getNext(MachineInstr* N) { return N->next; }

  static const MachineInstr*
  getPrev(const MachineInstr* N) { return N->prev; }

  static const MachineInstr*
  getNext(const MachineInstr* N) { return N->next; }

  static void setPrev(MachineInstr* N, MachineInstr* prev) { N->prev = prev; }
  static void setNext(MachineInstr* N, MachineInstr* next) { N->next = next; }

  static MachineInstr* createNode();
  void addNodeToList(MachineInstr* N);
  void removeNodeFromList(MachineInstr* N);
  void transferNodesFromList(
      iplist<MachineInstr, ilist_traits<MachineInstr> >& toList,
      ilist_iterator<MachineInstr> first,
      ilist_iterator<MachineInstr> last);
};

class BasicBlock;

class MachineBasicBlock {
public:
  typedef ilist<MachineInstr> Instructions;
  Instructions Insts;
  MachineBasicBlock *Prev, *Next;
  const BasicBlock *BB;
public:
  MachineBasicBlock(const BasicBlock *bb = 0) : Prev(0), Next(0), BB(bb) {
    Insts.parent = this;
  }
  ~MachineBasicBlock() {}
  
  /// getBasicBlock - Return the LLVM basic block that this instance
  /// corresponded to originally.
  ///
  const BasicBlock *getBasicBlock() const { return BB; }

  /// getParent - Return the MachineFunction containing this basic block.
  ///
  const MachineFunction *getParent() const;

  typedef ilist<MachineInstr>::iterator                       iterator;
  typedef ilist<MachineInstr>::const_iterator           const_iterator;
  typedef std::reverse_iterator<const_iterator> const_reverse_iterator;
  typedef std::reverse_iterator<iterator>             reverse_iterator;

  unsigned size() const { return Insts.size(); }
  bool empty() const { return Insts.empty(); }

  MachineInstr& front() { return Insts.front(); }
  MachineInstr& back()  { return Insts.back(); }

  iterator                begin()       { return Insts.begin();  }
  const_iterator          begin() const { return Insts.begin();  }
  iterator                  end()       { return Insts.end();    }
  const_iterator            end() const { return Insts.end();    }
  reverse_iterator       rbegin()       { return Insts.rbegin(); }
  const_reverse_iterator rbegin() const { return Insts.rbegin(); }
  reverse_iterator       rend  ()       { return Insts.rend();   }
  const_reverse_iterator rend  () const { return Insts.rend();   }

  /// getFirstTerminator - returns an iterator to the first terminator
  /// instruction of this basic block. If a terminator does not exist,
  /// it returns end()
  iterator getFirstTerminator();

  void push_back(MachineInstr *MI) { Insts.push_back(MI); }
  template<typename IT>
  void insert(iterator I, IT S, IT E) { Insts.insert(I, S, E); }
  iterator insert(iterator I, MachineInstr *M) { return Insts.insert(I, M); }

  // erase - Remove the specified element or range from the instruction list.
  // These functions delete any instructions removed.
  //
  iterator erase(iterator I)             { return Insts.erase(I); }
  iterator erase(iterator I, iterator E) { return Insts.erase(I, E); }
  MachineInstr* remove(iterator &I)      { return Insts.remove(I); }

  // Debugging methods.
  void dump() const;
  void print(std::ostream &OS) const;

private:   // Methods used to maintain doubly linked list of blocks...
  friend class ilist_traits<MachineBasicBlock>;

  MachineBasicBlock *getPrev() const { return Prev; }
  MachineBasicBlock *getNext() const { return Next; }
  void setPrev(MachineBasicBlock *P) { Prev = P; }
  void setNext(MachineBasicBlock *N) { Next = N; }
};

} // End llvm namespace

#endif
