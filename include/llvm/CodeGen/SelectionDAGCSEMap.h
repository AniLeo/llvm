//===-- llvm/CodeGen/SelectionDAGCSEMap.h - CSE Map for SD ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file was developed by Chris Lattner and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the SelectionDAG class, and transitively defines the
// SDNode class and subclasses.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_SELECTIONDAGCSEMAP_H
#define LLVM_CODEGEN_SELECTIONDAGCSEMAP_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"

namespace llvm {
  class SDNode;
  class SDOperand;
  struct SDVTList;
  
  /// SelectionDAGCSEMap - This class is used for two purposes:
  ///   1. Given information (e.g. opcode and operand info) about a node we want
  ///      to create, look up the unique instance of the node in the map.  If
  ///      the node already exists, return it, otherwise return the bucket it
  ///      should be inserted into.
  ///   2. Given a node that has already been created, remove it from the CSE
  ///      map.
  /// 
  /// This class is implemented as a chained hash table, where the "buckets" are
  /// actually the SDNodes themselves (the next pointer is in the SDNode).
  ///
  class SelectionDAGCSEMap {
    void **Buckets;
    unsigned NumBuckets;  // Always a power of 2.
    unsigned NumNodes;
  public:
    class NodeID;
    SelectionDAGCSEMap();
    ~SelectionDAGCSEMap();
    
    /// RemoveNode - Remove a node from the CSE map, returning true if one was
    /// removed or false if the node was not in the CSE map.
    bool RemoveNode(SDNode *N);
    
    /// GetOrInsertSimpleNode - If there is an existing simple SDNode exactly
    /// equal to the specified node, return it.  Otherwise, insert 'N' and it
    /// instead.  This only works on *simple* SDNodes, not ConstantSDNode or any
    /// other classes derived from SDNode.
    SDNode *GetOrInsertNode(SDNode *N);
    
    /// FindNodeOrInsertPos - Look up the node specified by ID.  If it exists,
    /// return it.  If not, return the insertion token that will make insertion
    /// faster.
    SDNode *FindNodeOrInsertPos(const NodeID &ID, void *&InsertPos);
    
    /// InsertNode - Insert the specified node into the CSE Map, knowing that it
    /// is not already in the map.  InsertPos must be obtained from 
    /// FindNodeOrInsertPos.
    void InsertNode(SDNode *N, void *InsertPos);
    
    class NodeID {
      /// Use a SmallVector to avoid a heap allocation in the common case.
      ///
      SmallVector<unsigned, 32> Bits;
    public:
      NodeID() {}
      NodeID(SDNode *N);
      NodeID(unsigned short ID, SDVTList VTList);
      NodeID(unsigned short ID, SDVTList VTList, SDOperand Op);
      NodeID(unsigned short ID, SDVTList VTList, 
             SDOperand Op1, SDOperand Op2);
      NodeID(unsigned short ID, SDVTList VTList, 
             SDOperand Op1, SDOperand Op2, SDOperand Op3);
      NodeID(unsigned short ID, SDVTList VTList, 
             const SDOperand *OpList, unsigned N);
      
      void SetOpcode(unsigned short ID) {
        Bits.push_back(ID);
      }
      
      /// getOpcode - Return the opcode that has been set for this NodeID.
      ///
      unsigned getOpcode() const {
        return Bits[0];
      }

      void SetValueTypes(SDVTList VTList);
      void SetOperands() {}
      void SetOperands(SDOperand Op) { AddOperand(Op); }
      void SetOperands(SDOperand Op1, SDOperand Op2) {
        AddOperand(Op1); AddOperand(Op2);
      }
      void SetOperands(SDOperand Op1, SDOperand Op2, SDOperand Op3) {
        AddOperand(Op1); AddOperand(Op2); AddOperand(Op3);
      }
      void SetOperands(const SDOperand *Ops, unsigned NumOps);
      void AddOperand(SDOperand Op);
      void AddPointer(const void *Ptr);
      void AddInteger(signed I) {
        Bits.push_back(I);
      }
      void AddInteger(unsigned I) {
        Bits.push_back(I);
      }
      void AddInteger(uint64_t I) {
        Bits.push_back(unsigned(I));
        Bits.push_back(unsigned(I >> 32));
      }
      
      unsigned ComputeHash() const;
      
      bool operator==(const NodeID &RHS) const;
    };
    
  private:
    SDNode *GetNextPtr(void *NextInBucketPtr);
    SDNode *GetNextPtr(void *NextInBucketPtr, void **Buckets, unsigned NumBuck);
    void **GetBucketPtr(void *NextInBucketPtr);
    void **GetBucketFor(const NodeID &ID) const;
    void GrowHashTable();
  };
}  // end namespace llvm

#endif
