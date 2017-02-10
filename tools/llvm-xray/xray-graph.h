//===-- xray-graph.h - XRay Function Call Graph Renderer --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Generate a DOT file to represent the function call graph encountered in
// the trace.
//
//===----------------------------------------------------------------------===//

#ifndef XRAY_GRAPH_H
#define XRAY_GRAPH_H

#include <string>
#include <vector>

#include "func-id-helper.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/Errc.h"
#include "llvm/Support/Program.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/XRay/Graph.h"
#include "llvm/XRay/Trace.h"
#include "llvm/XRay/XRayRecord.h"

namespace llvm {
namespace xray {

/// A class encapsulating the logic related to analyzing XRay traces, producting
/// Graphs from them and then exporting those graphs for review.
class GraphRenderer {
public:
  /// An enum for enumerating the various statistics gathered on latencies
  enum class StatType { NONE, COUNT, MIN, MED, PCT90, PCT99, MAX, SUM };

  /// An inner struct for common timing statistics information
  struct TimeStat {
    uint64_t Count = 0;
    double Min = 0;
    double Median = 0;
    double Pct90 = 0;
    double Pct99 = 0;
    double Max = 0;
    double Sum = 0;
    std::string getAsString(StatType T) const;
    double compare(StatType T, const TimeStat &Other) const;
  };
  typedef uint64_t TimestampT;

  /// An inner struct for storing edge attributes for our graph. Here the
  /// attributes are mainly function call statistics.
  ///
  /// FIXME: expand to contain more information eg call latencies.
  struct CallStats {
    TimeStat S;
    std::vector<TimestampT> Timings;
  };

  /// An Inner Struct for storing vertex attributes, at the moment just
  /// SymbolNames, however in future we could store bulk function statistics.
  ///
  /// FIXME: Store more attributes based on instrumentation map.
  struct FunctionStats {
    std::string SymbolName;
    TimeStat S;
  };

  struct FunctionAttr {
    int32_t FuncId;
    uint64_t TSC;
  };

  typedef SmallVector<FunctionAttr, 4> FunctionStack;

  typedef DenseMap<llvm::sys::ProcessInfo::ProcessId, FunctionStack>
      PerThreadFunctionStackMap;

  class GraphT : public Graph<FunctionStats, CallStats, int32_t> {
  public:
    TimeStat GraphEdgeMax = {};
    TimeStat GraphVertexMax = {};
  };

  GraphT G;
  typedef typename decltype(G)::VertexIdentifier VertexIdentifier;
  typedef typename decltype(G)::EdgeIdentifier EdgeIdentifier;

  /// Use a Map to store the Function stack for each thread whilst building the
  /// graph.
  ///
  /// FIXME: Perhaps we can Build this into LatencyAccountant? or vise versa?
  PerThreadFunctionStackMap PerThreadFunctionStack;

  /// Usefull object for getting human readable Symbol Names.
  FuncIdConversionHelper &FuncIdHelper;
  bool DeduceSiblingCalls = false;
  TimestampT CurrentMaxTSC = 0;

  /// A private function to help implement the statistic generation functions;
  template <typename U>
  void getStats(U begin, U end, GraphRenderer::TimeStat &S);
  void updateMaxStats(const TimeStat &S, TimeStat &M);

  /// Calculates latency statistics for each edge and stores the data in the
  /// Graph
  void calculateEdgeStatistics();

  /// Calculates latency statistics for each vertex and stores the data in the
  /// Graph
  void calculateVertexStatistics();

  /// Normalises latency statistics for each edge and vertex by CycleFrequency;
  void normalizeStatistics(double CycleFrequency);

public:
  /// Takes in a reference to a FuncIdHelper in order to have ready access to
  /// Symbol names.
  explicit GraphRenderer(FuncIdConversionHelper &FuncIdHelper, bool DSC)
      : FuncIdHelper(FuncIdHelper), DeduceSiblingCalls(DSC) {
    G[0] = {};
  }

  /// Process an Xray record and expand the graph.
  ///
  /// This Function will return true on success, or false if records are not
  /// presented in per-thread call-tree DFS order. (That is for each thread the
  /// Records should be in order runtime on an ideal system.)
  ///
  /// FIXME: Make this more robust against small irregularities.
  Error accountRecord(const XRayRecord &Record);

  const PerThreadFunctionStackMap &getPerThreadFunctionStack() const {
    return PerThreadFunctionStack;
  }

  /// Output the Embedded graph in DOT format on \p OS, labeling the edges by
  /// \p T
  void exportGraphAsDOT(raw_ostream &OS, const XRayFileHeader &H,
                        StatType EdgeLabel = StatType::NONE,
                        StatType EdgeColor = StatType::NONE,
                        StatType VertexLabel = StatType::NONE,
                        StatType VertexColor = StatType::NONE);

  /// Get a reference to the internal graph.
  const GraphT &getGraph() {
    calculateEdgeStatistics();
    calculateVertexStatistics();
    return G;
  }
};
}
}

#endif // XRAY_GRAPH_H
