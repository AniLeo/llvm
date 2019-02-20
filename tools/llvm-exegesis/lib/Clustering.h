//===-- Clustering.h --------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// Utilities to compute benchmark result clusters.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_EXEGESIS_CLUSTERING_H
#define LLVM_TOOLS_LLVM_EXEGESIS_CLUSTERING_H

#include "BenchmarkResult.h"
#include "llvm/ADT/Optional.h"
#include "llvm/Support/Error.h"
#include <limits>
#include <vector>

namespace llvm {
namespace exegesis {

class InstructionBenchmarkClustering {
public:
  // Clusters `Points` using DBSCAN with the given parameters. See the cc file
  // for more explanations on the algorithm.
  static llvm::Expected<InstructionBenchmarkClustering>
  create(const std::vector<InstructionBenchmark> &Points, size_t MinPts,
         double Epsilon, llvm::Optional<unsigned> NumOpcodes = llvm::None);

  class ClusterId {
  public:
    static ClusterId noise() { return ClusterId(kNoise); }
    static ClusterId error() { return ClusterId(kError); }
    static ClusterId makeValid(size_t Id) { return ClusterId(Id); }
    static ClusterId makeValidUnstable(size_t Id) {
      return ClusterId(Id, /*IsUnstable=*/true);
    }

    ClusterId() : Id_(kUndef), IsUnstable_(false) {}

    // Compare id's, ignoring the 'unstability' bit.
    bool operator==(const ClusterId &O) const { return Id_ == O.Id_; }
    bool operator<(const ClusterId &O) const { return Id_ < O.Id_; }

    bool isValid() const { return Id_ <= kMaxValid; }
    bool isUnstable() const { return IsUnstable_; }
    bool isNoise() const { return Id_ == kNoise; }
    bool isError() const { return Id_ == kError; }
    bool isUndef() const { return Id_ == kUndef; }

    // Precondition: isValid().
    size_t getId() const {
      assert(isValid());
      return Id_;
    }

  private:
    ClusterId(size_t Id, bool IsUnstable = false)
        : Id_(Id), IsUnstable_(IsUnstable) {}

    static constexpr const size_t kMaxValid =
        (std::numeric_limits<size_t>::max() >> 1) - 4;
    static constexpr const size_t kNoise = kMaxValid + 1;
    static constexpr const size_t kError = kMaxValid + 2;
    static constexpr const size_t kUndef = kMaxValid + 3;

    size_t Id_ : (std::numeric_limits<size_t>::digits - 1);
    size_t IsUnstable_ : 1;
  };
  static_assert(sizeof(ClusterId) == sizeof(size_t), "should be a bit field.");

  struct Cluster {
    Cluster() = delete;
    explicit Cluster(const ClusterId &Id) : Id(Id) {}

    const ClusterId Id;
    // Indices of benchmarks within the cluster.
    std::vector<int> PointIndices;
  };

  ClusterId getClusterIdForPoint(size_t P) const {
    return ClusterIdForPoint_[P];
  }

  const std::vector<InstructionBenchmark> &getPoints() const { return Points_; }

  const Cluster &getCluster(ClusterId Id) const {
    assert(!Id.isUndef() && "unlabeled cluster");
    if (Id.isNoise()) {
      return NoiseCluster_;
    }
    if (Id.isError()) {
      return ErrorCluster_;
    }
    return Clusters_[Id.getId()];
  }

  const std::vector<Cluster> &getValidClusters() const { return Clusters_; }

  // Returns true if the given point is within a distance Epsilon of each other.
  bool isNeighbour(const std::vector<BenchmarkMeasure> &P,
                   const std::vector<BenchmarkMeasure> &Q) const {
    double DistanceSquared = 0.0;
    for (size_t I = 0, E = P.size(); I < E; ++I) {
      const auto Diff = P[I].PerInstructionValue - Q[I].PerInstructionValue;
      DistanceSquared += Diff * Diff;
    }
    return DistanceSquared <= EpsilonSquared_;
  }

private:
  InstructionBenchmarkClustering(
      const std::vector<InstructionBenchmark> &Points, double EpsilonSquared);

  llvm::Error validateAndSetup();
  void dbScan(size_t MinPts);
  void stabilize(unsigned NumOpcodes);
  void rangeQuery(size_t Q, std::vector<size_t> &Scratchpad) const;

  const std::vector<InstructionBenchmark> &Points_;
  const double EpsilonSquared_;
  int NumDimensions_ = 0;
  // ClusterForPoint_[P] is the cluster id for Points[P].
  std::vector<ClusterId> ClusterIdForPoint_;
  std::vector<Cluster> Clusters_;
  Cluster NoiseCluster_;
  Cluster ErrorCluster_;
};

} // namespace exegesis
} // namespace llvm

#endif // LLVM_TOOLS_LLVM_EXEGESIS_CLUSTERING_H
