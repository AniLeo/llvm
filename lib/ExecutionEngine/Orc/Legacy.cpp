//===------- Legacy.cpp - Adapters for ExecutionEngine API interop --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ExecutionEngine/Orc/Legacy.h"

namespace llvm {
namespace orc {

void SymbolResolver::anchor() {}

JITSymbolResolverAdapter::JITSymbolResolverAdapter(
    ExecutionSession &ES, SymbolResolver &R, MaterializationResponsibility *MR)
    : ES(ES), R(R), MR(MR) {}

Expected<JITSymbolResolverAdapter::LookupResult>
JITSymbolResolverAdapter::lookup(const LookupSet &Symbols) {
  SymbolNameSet InternedSymbols;
  for (auto &S : Symbols)
    InternedSymbols.insert(ES.getSymbolStringPool().intern(S));

  auto LookupFn = [&, this](std::shared_ptr<AsynchronousSymbolQuery> Q,
                            SymbolNameSet Unresolved) {
    return R.lookup(std::move(Q), std::move(Unresolved));
  };

  auto RegisterDependencies = [&](const SymbolDependenceMap &Deps) {
    if (MR)
      MR->addDependenciesForAll(Deps);
  };

  auto InternedResult =
      ES.legacyLookup(std::move(LookupFn), std::move(InternedSymbols),
                      false, RegisterDependencies);

  if (!InternedResult)
    return InternedResult.takeError();

  JITSymbolResolver::LookupResult Result;
  for (auto &KV : *InternedResult)
    Result[*KV.first] = KV.second;

  return Result;
}

Expected<JITSymbolResolverAdapter::LookupSet>
JITSymbolResolverAdapter::getResponsibilitySet(const LookupSet &Symbols) {
  SymbolNameSet InternedSymbols;
  for (auto &S : Symbols)
    InternedSymbols.insert(ES.getSymbolStringPool().intern(S));

  auto InternedResult = R.getResponsibilitySet(InternedSymbols);
  LookupSet Result;
  for (auto &S : InternedResult) {
    ResolvedStrings.insert(S);
    Result.insert(*S);
  }

  return Result;
}

} // End namespace orc.
} // End namespace llvm.
