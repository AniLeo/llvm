//===- TopDownClosure.cpp - Compute the top-down interprocedure closure ---===//
//
// This file implements the TDDataStructures class, which represents the
// Top-down Interprocedural closure of the data structure graph over the
// program.  This is useful (but not strictly necessary?) for applications
// like pointer analysis.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/DataStructure.h"
#include "llvm/Analysis/DSGraph.h"
#include "llvm/Module.h"
#include "llvm/DerivedTypes.h"
#include "Support/Statistic.h"

namespace {
  RegisterAnalysis<TDDataStructures>   // Register the pass
  Y("tddatastructure", "Top-down Data Structure Analysis");
}

// run - Calculate the top down data structure graphs for each function in the
// program.
//
bool TDDataStructures::run(Module &M) {
  BUDataStructures &BU = getAnalysis<BUDataStructures>();
  GlobalsGraph = new DSGraph(BU.getGlobalsGraph());

  // Calculate top-down from main...
  if (Function *F = M.getMainFunction())
    calculateGraph(*F);

  // Next calculate the graphs for each function unreachable function...
  for (Module::reverse_iterator I = M.rbegin(), E = M.rend(); I != E; ++I)
    if (!I->isExternal())
      calculateGraph(*I);

  GraphDone.clear();    // Free temporary memory...
  return false;
}

// releaseMemory - If the pass pipeline is done with this pass, we can release
// our memory... here...
//
// FIXME: This should be releaseMemory and will work fine, except that LoadVN
// has no way to extend the lifetime of the pass, which screws up ds-aa.
//
void TDDataStructures::releaseMyMemory() {
  for (hash_map<Function*, DSGraph*>::iterator I = DSInfo.begin(),
         E = DSInfo.end(); I != E; ++I) {
    I->second->getReturnNodes().erase(I->first);
    if (I->second->getReturnNodes().empty())
      delete I->second;
  }

  // Empty map so next time memory is released, data structures are not
  // re-deleted.
  DSInfo.clear();
  delete GlobalsGraph;
  GlobalsGraph = 0;
}


DSGraph &TDDataStructures::getOrCreateDSGraph(Function &F) {
  DSGraph *&G = DSInfo[&F];
  if (G == 0) { // Not created yet?  Clone BU graph...
    G = new DSGraph(getAnalysis<BUDataStructures>().getDSGraph(F));
    G->getAuxFunctionCalls().clear();
    G->setPrintAuxCalls();
    G->setGlobalsGraph(GlobalsGraph);
  }
  return *G;
}


/// FunctionHasCompleteArguments - This function returns true if it is safe not
/// to mark arguments to the function complete.
///
/// FIXME: Need to check if all callers have been found, or rather if a
/// funcpointer escapes!
///
static bool FunctionHasCompleteArguments(Function &F) {
  return F.hasInternalLinkage();
}


void TDDataStructures::calculateGraph(Function &F) {
  // Make sure this graph has not already been calculated, and that we don't get
  // into an infinite loop with mutually recursive functions.
  //
  if (GraphDone.count(&F)) return;
  GraphDone.insert(&F);

  // Get the current functions graph...
  DSGraph &Graph = getOrCreateDSGraph(F);

  // Recompute the Incomplete markers and eliminate unreachable nodes.
  Graph.maskIncompleteMarkers();
  unsigned Flags = FunctionHasCompleteArguments(F) ?
                            DSGraph::IgnoreFormalArgs : DSGraph::MarkFormalArgs;
  Graph.markIncompleteNodes(Flags | DSGraph::IgnoreGlobals);
  Graph.removeDeadNodes(DSGraph::RemoveUnreachableGlobals);

  const std::vector<DSCallSite> &CallSites = Graph.getFunctionCalls();
  if (CallSites.empty()) {
    DEBUG(std::cerr << "  [TD] No callees for: " << F.getName() << "\n");
  } else {
    // Loop over all of the call sites, building a multi-map from Callees to
    // DSCallSite*'s.  With this map we can then loop over each callee, cloning
    // this graph once into it, then resolving arguments.
    //
    std::multimap<Function*, const DSCallSite*> CalleeSites;
    for (unsigned i = 0, e = CallSites.size(); i != e; ++i) {
      const DSCallSite &CS = CallSites[i];
      if (CS.isDirectCall()) {
        if (!CS.getCalleeFunc()->isExternal())           // If it's not external
          CalleeSites.insert(std::make_pair(CS.getCalleeFunc(), &CS));// Keep it
      } else {
        const std::vector<GlobalValue*> &Callees =
          CS.getCalleeNode()->getGlobals();

        // Loop over all of the functions that this call may invoke...
        for (unsigned c = 0, e = Callees.size(); c != e; ++c)
          if (Function *F = dyn_cast<Function>(Callees[c]))// If this is a fn...
            if (!F->isExternal())                          // If it's not extern
              CalleeSites.insert(std::make_pair(F, &CS));  // Keep track of it!
      }
    }

    // Now that we have information about all of the callees, propagate the
    // current graph into the callees.
    //
    DEBUG(std::cerr << "  [TD] Inlining '" << F.getName() << "' into "
          << CalleeSites.size() << " callees.\n");

    // Loop over all the callees...
    for (std::multimap<Function*, const DSCallSite*>::iterator
           I = CalleeSites.begin(), E = CalleeSites.end(); I != E; )
      if (I->first == &F) {  // Bottom-up pass takes care of self loops!
        ++I;
      } else {
        // For each callee...
        Function &Callee = *I->first;
        DSGraph &CG = getOrCreateDSGraph(Callee);  // Get the callee's graph...
      
        DEBUG(std::cerr << "\t [TD] Inlining into callee '" << Callee.getName()
                        << "'\n");
      
        // Clone our current graph into the callee...
        DSGraph::ScalarMapTy OldValMap;
        DSGraph::NodeMapTy OldNodeMap;
        DSGraph::ReturnNodesTy ReturnNodes;
        CG.cloneInto(Graph, OldValMap, ReturnNodes, OldNodeMap,
                     DSGraph::StripModRefBits |
                     DSGraph::KeepAllocaBit | DSGraph::DontCloneCallNodes |
                     DSGraph::DontCloneAuxCallNodes);
        OldValMap.clear();  // We don't care about the ValMap
        ReturnNodes.clear();  // We don't care about return values either

        // Loop over all of the invocation sites of the callee, resolving
        // arguments to our graph.  This loop may iterate multiple times if the
        // current function calls this callee multiple times with different
        // signatures.
        //
        for (; I != E && I->first == &Callee; ++I) {
          // Map call site into callee graph
          DSCallSite NewCS(*I->second, OldNodeMap);
        
          // Resolve the return values...
          NewCS.getRetVal().mergeWith(CG.getReturnNodeFor(Callee));
        
          // Resolve all of the arguments...
          Function::aiterator AI = Callee.abegin();
          for (unsigned i = 0, e = NewCS.getNumPtrArgs();
               i != e && AI != Callee.aend(); ++i, ++AI) {
            // Advance the argument iterator to the first pointer argument...
            while (AI != Callee.aend() && !DS::isPointerType(AI->getType()))
              ++AI;
            if (AI == Callee.aend()) break;

            // Add the link from the argument scalar to the provided value
            DSNodeHandle &NH = CG.getNodeForValue(AI);
            assert(NH.getNode() && "Pointer argument without scalarmap entry?");
            NH.mergeWith(NewCS.getPtrArg(i));
          }
        }

        // Done with the nodemap...
        OldNodeMap.clear();

        // Recompute the Incomplete markers and eliminate unreachable nodes.
        CG.removeTriviallyDeadNodes();
        CG.maskIncompleteMarkers();
        CG.markIncompleteNodes(DSGraph::MarkFormalArgs |DSGraph::IgnoreGlobals);
        CG.removeDeadNodes(DSGraph::RemoveUnreachableGlobals);
      }

    DEBUG(std::cerr << "  [TD] Done inlining into callees for: " << F.getName()
          << " [" << Graph.getGraphSize() << "+"
          << Graph.getFunctionCalls().size() << "]\n");

    // Loop over all the callees... making sure they are all resolved now...
    Function *LastFunc = 0;
    for (std::multimap<Function*, const DSCallSite*>::iterator
           I = CalleeSites.begin(), E = CalleeSites.end(); I != E; ++I)
      if (I->first != LastFunc) {  // Only visit each callee once...
        LastFunc = I->first;
        calculateGraph(*I->first);
      }
  }
}

