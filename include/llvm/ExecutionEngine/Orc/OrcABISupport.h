//===- OrcABISupport.h - ABI support code -----------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// ABI specific code for Orc, e.g. callback assembly.
//
// ABI classes should be part of the JIT *target* process, not the host
// process (except where you're doing hosted JITing and the two are one and the
// same).
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_EXECUTIONENGINE_ORC_ORCABISUPPORT_H
#define LLVM_EXECUTIONENGINE_ORC_ORCABISUPPORT_H

#include "llvm/ExecutionEngine/JITSymbol.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/Memory.h"
#include <algorithm>
#include <cstdint>

namespace llvm {
namespace orc {

/// Generic ORC ABI support.
///
/// This class can be substituted as the target architecure support class for
/// ORC templates that require one (e.g. IndirectStubsManagers). It does not
/// support lazy JITing however, and any attempt to use that functionality
/// will result in execution of an llvm_unreachable.
class OrcGenericABI {
public:
  static const unsigned PointerSize = sizeof(uintptr_t);
  static const unsigned TrampolineSize = 1;
  static const unsigned ResolverCodeSize = 1;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);

  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,
                                void *CallbackMgr) {
    llvm_unreachable("writeResolverCode is not supported by the generic host "
                     "support class");
  }

  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,
                               unsigned NumTrampolines) {
    llvm_unreachable("writeTrampolines is not supported by the generic host "
                     "support class");
  }

  class IndirectStubsInfo {
  public:
    const static unsigned StubSize = 1;

    unsigned getNumStubs() const { llvm_unreachable("Not supported"); }
    void *getStub(unsigned Idx) const { llvm_unreachable("Not supported"); }
    void **getPtr(unsigned Idx) const { llvm_unreachable("Not supported"); }
  };

  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,
                                      unsigned MinStubs, void *InitialPtrVal) {
    llvm_unreachable("emitIndirectStubsBlock is not supported by the generic "
                     "host support class");
  }
};

/// Provide information about stub blocks generated by the
///        makeIndirectStubsBlock function.
template <unsigned StubSizeVal> class GenericIndirectStubsInfo {
public:
  const static unsigned StubSize = StubSizeVal;

  GenericIndirectStubsInfo() = default;
  GenericIndirectStubsInfo(unsigned NumStubs, sys::OwningMemoryBlock StubsMem)
      : NumStubs(NumStubs), StubsMem(std::move(StubsMem)) {}
  GenericIndirectStubsInfo(GenericIndirectStubsInfo &&Other)
      : NumStubs(Other.NumStubs), StubsMem(std::move(Other.StubsMem)) {
    Other.NumStubs = 0;
  }

  GenericIndirectStubsInfo &operator=(GenericIndirectStubsInfo &&Other) {
    NumStubs = Other.NumStubs;
    Other.NumStubs = 0;
    StubsMem = std::move(Other.StubsMem);
    return *this;
  }

  /// Number of stubs in this block.
  unsigned getNumStubs() const { return NumStubs; }

  /// Get a pointer to the stub at the given index, which must be in
  ///        the range 0 .. getNumStubs() - 1.
  void *getStub(unsigned Idx) const {
    return static_cast<char *>(StubsMem.base()) + Idx * StubSize;
  }

  /// Get a pointer to the implementation-pointer at the given index,
  ///        which must be in the range 0 .. getNumStubs() - 1.
  void **getPtr(unsigned Idx) const {
    char *PtrsBase = static_cast<char *>(StubsMem.base()) + NumStubs * StubSize;
    return reinterpret_cast<void **>(PtrsBase) + Idx;
  }

private:
  unsigned NumStubs = 0;
  sys::OwningMemoryBlock StubsMem;
};

class OrcAArch64 {
public:
  static const unsigned PointerSize = 8;
  static const unsigned TrampolineSize = 12;
  static const unsigned ResolverCodeSize = 0x120;

  using IndirectStubsInfo = GenericIndirectStubsInfo<8>;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);

  /// Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,
                                void *CallbackMgr);

  /// Write the requsted number of trampolines into the given memory,
  ///        which must be big enough to hold 1 pointer, plus NumTrampolines
  ///        trampolines.
  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,
                               unsigned NumTrampolines);

  /// Emit at least MinStubs worth of indirect call stubs, rounded out to
  ///        the nearest page size.
  ///
  ///   E.g. Asking for 4 stubs on x86-64, where stubs are 8-bytes, with 4k
  /// pages will return a block of 512 stubs (4096 / 8 = 512). Asking for 513
  /// will return a block of 1024 (2-pages worth).
  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,
                                      unsigned MinStubs, void *InitialPtrVal);
};

/// X86_64 code that's common to all ABIs.
///
/// X86_64 supports lazy JITing.
class OrcX86_64_Base {
public:
  static const unsigned PointerSize = 8;
  static const unsigned TrampolineSize = 8;

  using IndirectStubsInfo = GenericIndirectStubsInfo<8>;

  /// Write the requsted number of trampolines into the given memory,
  ///        which must be big enough to hold 1 pointer, plus NumTrampolines
  ///        trampolines.
  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,
                               unsigned NumTrampolines);

  /// Emit at least MinStubs worth of indirect call stubs, rounded out to
  ///        the nearest page size.
  ///
  ///   E.g. Asking for 4 stubs on x86-64, where stubs are 8-bytes, with 4k
  /// pages will return a block of 512 stubs (4096 / 8 = 512). Asking for 513
  /// will return a block of 1024 (2-pages worth).
  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,
                                      unsigned MinStubs, void *InitialPtrVal);
};

/// X86_64 support for SysV ABI (Linux, MacOSX).
///
/// X86_64_SysV supports lazy JITing.
class OrcX86_64_SysV : public OrcX86_64_Base {
public:
  static const unsigned ResolverCodeSize = 0x6C;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);

  /// Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,
                                void *CallbackMgr);
};

/// X86_64 support for Win32.
///
/// X86_64_Win32 supports lazy JITing.
class OrcX86_64_Win32 : public OrcX86_64_Base {
public:
  static const unsigned ResolverCodeSize = 0x74;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);

  /// Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,
                                void *CallbackMgr);
};

/// I386 support.
///
/// I386 supports lazy JITing.
class OrcI386 {
public:
  static const unsigned PointerSize = 4;
  static const unsigned TrampolineSize = 8;
  static const unsigned ResolverCodeSize = 0x4a;

  using IndirectStubsInfo = GenericIndirectStubsInfo<8>;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);

  /// Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,
                                void *CallbackMgr);

  /// Write the requsted number of trampolines into the given memory,
  ///        which must be big enough to hold 1 pointer, plus NumTrampolines
  ///        trampolines.
  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,
                               unsigned NumTrampolines);

  /// Emit at least MinStubs worth of indirect call stubs, rounded out to
  ///        the nearest page size.
  ///
  ///   E.g. Asking for 4 stubs on i386, where stubs are 8-bytes, with 4k
  /// pages will return a block of 512 stubs (4096 / 8 = 512). Asking for 513
  /// will return a block of 1024 (2-pages worth).
  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,
                                      unsigned MinStubs, void *InitialPtrVal);
};

// @brief Mips32 support.
//
// Mips32 supports lazy JITing.
class OrcMips32_Base {
public:
  static const unsigned PointerSize = 4;
  static const unsigned TrampolineSize = 20;
  static const unsigned ResolverCodeSize = 0xfc;
  using IndirectStubsInfo = GenericIndirectStubsInfo<16>;

  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);
  /// @brief Write the requsted number of trampolines into the given memory,
  ///        which must be big enough to hold 1 pointer, plus NumTrampolines
  ///        trampolines.
  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,unsigned NumTrampolines);

  /// @brief Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,void *CallbackMgr, bool isBigEndian);
  /// @brief Emit at least MinStubs worth of indirect call stubs, rounded out to
  ///        the nearest page size.
  ///
  ///   E.g. Asking for 4 stubs on Mips32, where stubs are 8-bytes, with 4k
  /// pages will return a block of 512 stubs (4096 / 8 = 512). Asking for 513
  /// will return a block of 1024 (2-pages worth).
  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,unsigned MinStubs, void *InitialPtrVal);
};


class OrcMips32Le : public OrcMips32_Base {
public:
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,void *CallbackMgr)
  { OrcMips32_Base::writeResolverCode(ResolveMem, Reentry, CallbackMgr, false); }
};

class OrcMips32Be : public OrcMips32_Base {
public:
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,void *CallbackMgr)
  { OrcMips32_Base::writeResolverCode(ResolveMem, Reentry, CallbackMgr, true); }
};

// @brief Mips64 support.
//
// Mips64 supports lazy JITing.
class OrcMips64 {
public:
  static const unsigned PointerSize = 8;
  static const unsigned TrampolineSize = 40;
  static const unsigned ResolverCodeSize = 0x120;

  using IndirectStubsInfo = GenericIndirectStubsInfo<32>;
  using JITReentryFn = JITTargetAddress (*)(void *CallbackMgr,
                                            void *TrampolineId);
  /// @brief Write the resolver code into the given memory. The user is be
  ///        responsible for allocating the memory and setting permissions.
  static void writeResolverCode(uint8_t *ResolveMem, JITReentryFn Reentry,void *CallbackMgr);

  /// @brief Write the requsted number of trampolines into the given memory,
  ///        which must be big enough to hold 1 pointer, plus NumTrampolines
  ///        trampolines.
  static void writeTrampolines(uint8_t *TrampolineMem, void *ResolverAddr,unsigned NumTrampolines);

  /// @brief Emit at least MinStubs worth of indirect call stubs, rounded out to
  ///        the nearest page size.
  ///
  ///   E.g. Asking for 4 stubs on Mips64, where stubs are 8-bytes, with 4k
  /// pages will return a block of 512 stubs (4096 / 8 = 512). Asking for 513
  /// will return a block of 1024 (2-pages worth).
  static Error emitIndirectStubsBlock(IndirectStubsInfo &StubsInfo,unsigned MinStubs, void *InitialPtrVal);
};

 } // end namespace orc
 } // end namespace llvm
#endif // LLVM_EXECUTIONENGINE_ORC_ORCABISUPPORT_H
