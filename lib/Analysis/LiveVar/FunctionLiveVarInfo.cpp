/* Title:   MethodLiveVarInfo.cpp
   Author:  Ruchira Sasanka
   Date:    Jun 30, 01
   Purpose: 

   This is the interface for live variable info of a method that is required 
   by any other part of the compiler.

*/


#include "llvm/Analysis/LiveVar/MethodLiveVarInfo.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/BasicBlock.h"
#include "Support/PostOrderIterator.h"
#include <iostream>
using std::cerr;

AnalysisID MethodLiveVarInfo::ID(AnalysisID::create<MethodLiveVarInfo>());


//-----------------------------------------------------------------------------
// Performs live var analysis for a method
//-----------------------------------------------------------------------------

bool MethodLiveVarInfo::runOnMethod(Method *M) {
  if (DEBUG_LV) cerr << "Analysing live variables ...\n";

  // create and initialize all the BBLiveVars of the CFG
  constructBBs(M);

  while (doSingleBackwardPass(M))
    ; // Iterate until we are done.
  
  if (DEBUG_LV) cerr << "Live Variable Analysis complete!\n";
  return false;
}


//-----------------------------------------------------------------------------
// constructs BBLiveVars and init Def and In sets
//-----------------------------------------------------------------------------

void MethodLiveVarInfo::constructBBs(const Method *M) {
  unsigned int POId = 0;                // Reverse Depth-first Order ID
  
  for(po_iterator<const Method*> BBI = po_begin(M), BBE = po_end(M);
      BBI != BBE; ++BBI, ++POId) { 
    const BasicBlock *BB = *BBI;        // get the current BB 

    if (DEBUG_LV) { cerr << " For BB "; printValue(BB); cerr << ":\n"; }

    // create a new BBLiveVar
    BBLiveVar *LVBB = new BBLiveVar(BB, POId);  
    BB2BBLVMap[BB] = LVBB;              // insert the pair to Map
    
    LVBB->calcDefUseSets();             // calculates the def and in set

    if (DEBUG_LV) 
      LVBB->printAllSets();
  }

  // Since the PO iterator does not discover unreachable blocks,
  // go over the random iterator and init those blocks as well.
  // However, LV info is not correct for those blocks (they are not
  // analyzed)
  //
  for (Method::const_iterator BBRI = M->begin(), BBRE = M->end();
       BBRI != BBRE; ++BBRI, ++POId)
    if (!BB2BBLVMap[*BBRI])   // Not yet processed?
      BB2BBLVMap[*BBRI] = new BBLiveVar(*BBRI, POId);
}


//-----------------------------------------------------------------------------
// do one backward pass over the CFG (for iterative analysis)
//-----------------------------------------------------------------------------
bool MethodLiveVarInfo::doSingleBackwardPass(const Method *M) {
  bool ResultFlow, NeedAnotherIteration = false;

  if (DEBUG_LV) 
    cerr << "\n After Backward Pass ...\n";

  po_iterator<const Method*> BBI = po_begin(M);

  for( ; BBI != po_end(M) ; ++BBI) { 
    BBLiveVar *LVBB = BB2BBLVMap[*BBI];
    assert(LVBB);

    if (DEBUG_LV) cerr << " For BB " << (*BBI)->getName() << ":\n";

    if(LVBB->isOutSetChanged()) 
      LVBB->applyTransferFunc();        // apply the Tran Func to calc InSet

    if (LVBB->isInSetChanged())        // to calc Outsets of preds
      NeedAnotherIteration |= LVBB->applyFlowFunc(BB2BBLVMap); 

    if(DEBUG_LV) LVBB->printInOutSets();
  }

  // true if we need to reiterate over the CFG
  return NeedAnotherIteration;         
}


void MethodLiveVarInfo::releaseMemory() {
  // First delete all BBLiveVar objects created in constructBBs(). A new object
  // of type  BBLiveVa is created for every BasicBlock in the method

  // hash map iterator for BB2BBLVMap
  //
  BBToBBLiveVarMapType::iterator HMI = BB2BBLVMap.begin(); 

  for( ; HMI != BB2BBLVMap.end(); ++HMI)
    delete HMI->second;                // delete all BBLiveVar in BB2BBLVMap

  BB2BBLVMap.clear();

  // Then delete all objects of type LiveVarSet created in calcLiveVarSetsForBB
  // and entered into  MInst2LVSetBI and  MInst2LVSetAI (these are caches
  // to return LiveVarSet's before/after a machine instruction quickly). It
  // is sufficient to free up all LiveVarSet using only one cache since 
  // both caches refer to the same sets

  // hash map iterator for MInst2LVSetBI
  //
  MInstToLiveVarSetMapType::iterator MI = MInst2LVSetBI.begin(); 

  for( ; MI != MInst2LVSetBI.end(); ++MI)
    delete MI->second;           // delete all LiveVarSets in  MInst2LVSetBI

  MInst2LVSetBI.clear();
  MInst2LVSetAI.clear();
}




//-----------------------------------------------------------------------------
/* Following functions will give the LiveVar info for any machine instr in
   a method. It should be called after a call to analyze().

   Thsese functions calucluates live var info for all the machine instrs in a 
   BB when LVInfo for one inst is requested. Hence, this function is useful 
   when live var info is required for many (or all) instructions in a basic 
   block. Also, the arguments to this method does not require specific 
   iterators.
*/
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Gives live variable information before a machine instruction
//-----------------------------------------------------------------------------
const LiveVarSet *
MethodLiveVarInfo::getLiveVarSetBeforeMInst(const MachineInstr *MInst,
					    const BasicBlock *CurBB) {
  const LiveVarSet *LVSet = MInst2LVSetBI[MInst];

  if (LVSet) {
    return LVSet;              // if found, just return the set
  } else { 
    calcLiveVarSetsForBB(CurBB);        // else, calc for all instrs in BB
    assert(MInst2LVSetBI[MInst]);
    return MInst2LVSetBI[MInst];
  }
}


//-----------------------------------------------------------------------------
// Gives live variable information after a machine instruction
//-----------------------------------------------------------------------------
const LiveVarSet * 
MethodLiveVarInfo::getLiveVarSetAfterMInst(const MachineInstr *MInst,
                                           const BasicBlock *CurBB) {
  const LiveVarSet *LVSet = MInst2LVSetAI[MInst];

  if(LVSet) {
    return LVSet;                       // if found, just return the set
  } else { 
    calcLiveVarSetsForBB(CurBB);        // else, calc for all instrs in BB
    assert(MInst2LVSetAI[MInst]);
    return MInst2LVSetAI[MInst];
  }
}



//-----------------------------------------------------------------------------
// This method calculates the live variable information for all the 
// instructions in a basic block and enter the newly constructed live
// variable sets into a the caches ( MInst2LVSetAI,  MInst2LVSetBI)
//-----------------------------------------------------------------------------
void MethodLiveVarInfo::calcLiveVarSetsForBB(const BasicBlock *const BB)
{
  const MachineCodeForBasicBlock& MIVec = BB->getMachineInstrVec();
  MachineCodeForBasicBlock::const_reverse_iterator 
    MInstIterator = MIVec.rbegin();

  LiveVarSet *CurSet = new LiveVarSet();
  const LiveVarSet *SetAI = getOutSetOfBB(BB); // init SetAI with OutSet
  CurSet->setUnion(SetAI);                     // CurSet now contains OutSet

  // iterate over all the machine instructions in BB
  for( ; MInstIterator != MIVec.rend(); MInstIterator++) {  

    // MInst is cur machine inst
    const MachineInstr * MInst  = *MInstIterator;  

    MInst2LVSetAI[MInst] = SetAI;              // record in After Inst map
    
    CurSet->applyTranferFuncForMInst( MInst ); // apply the transfer Func
    LiveVarSet *NewSet = new LiveVarSet();     // create a new set and
    NewSet->setUnion( CurSet );                // copy the set after T/F to it
 
    MInst2LVSetBI[MInst] = NewSet;             // record in Before Inst map

    // SetAI will be used in the next iteration
    SetAI = NewSet;                 
  }
  
}

















