//===- SectionMemoryManager.cpp - Memory manager for MCJIT/RtDyld *- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the section-based memory manager used by the MCJIT
// execution engine and RuntimeDyld
//
//===----------------------------------------------------------------------===//

#include "llvm/Config/config.h"
#include "llvm/ExecutionEngine/SectionMemoryManager.h"
#include "llvm/Support/MathExtras.h"

namespace llvm {

uint8_t *SectionMemoryManager::allocateDataSection(uintptr_t Size,
                                                   unsigned Alignment,
                                                   unsigned SectionID,
                                                   StringRef SectionName,
                                                   bool IsReadOnly) {
  if (IsReadOnly)
    return allocateSection(RODataMem, Size, Alignment);
  return allocateSection(RWDataMem, Size, Alignment);
}

uint8_t *SectionMemoryManager::allocateCodeSection(uintptr_t Size,
                                                   unsigned Alignment,
                                                   unsigned SectionID,
                                                   StringRef SectionName) {
  return allocateSection(CodeMem, Size, Alignment);
}

uint8_t *SectionMemoryManager::allocateSection(MemoryGroup &MemGroup,
                                               uintptr_t Size,
                                               unsigned Alignment) {
  if (!Alignment)
    Alignment = 16;

  assert(!(Alignment & (Alignment - 1)) && "Alignment must be a power of two.");

  uintptr_t RequiredSize = Alignment * ((Size + Alignment - 1)/Alignment + 1);
  uintptr_t Addr = 0;

  // Look in the list of free memory regions and use a block there if one
  // is available.
  for (sys::MemoryBlock &MB : MemGroup.FreeMem) {
    if (MB.size() >= RequiredSize) {
      Addr = (uintptr_t)MB.base();
      uintptr_t EndOfBlock = Addr + MB.size();
      // Align the address.
      Addr = (Addr + Alignment - 1) & ~(uintptr_t)(Alignment - 1);
      // Store cutted free memory block.
      MB = sys::MemoryBlock((void *)(Addr + Size), EndOfBlock - Addr - Size);
      return (uint8_t*)Addr;
    }
  }

  // No pre-allocated free block was large enough. Allocate a new memory region.
  // Note that all sections get allocated as read-write.  The permissions will
  // be updated later based on memory group.
  //
  // FIXME: It would be useful to define a default allocation size (or add
  // it as a constructor parameter) to minimize the number of allocations.
  //
  // FIXME: Initialize the Near member for each memory group to avoid
  // interleaving.
  std::error_code ec;
  sys::MemoryBlock MB = sys::Memory::allocateMappedMemory(RequiredSize,
                                                          &MemGroup.Near,
                                                          sys::Memory::MF_READ |
                                                            sys::Memory::MF_WRITE,
                                                          ec);
  if (ec) {
    // FIXME: Add error propagation to the interface.
    return nullptr;
  }

  // Save this address as the basis for our next request
  MemGroup.Near = MB;

  MemGroup.PendingMem.push_back(MB);
  Addr = (uintptr_t)MB.base();
  uintptr_t EndOfBlock = Addr + MB.size();

  // Align the address.
  Addr = (Addr + Alignment - 1) & ~(uintptr_t)(Alignment - 1);

  // The allocateMappedMemory may allocate much more memory than we need. In
  // this case, we store the unused memory as a free memory block.
  unsigned FreeSize = EndOfBlock-Addr-Size;
  if (FreeSize > 16)
    MemGroup.FreeMem.push_back(sys::MemoryBlock((void*)(Addr + Size), FreeSize));

  // Return aligned address
  return (uint8_t*)Addr;
}

bool SectionMemoryManager::finalizeMemory(std::string *ErrMsg)
{
  // FIXME: Should in-progress permissions be reverted if an error occurs?
  std::error_code ec;

  // Don't allow free memory blocks to be used after setting protection flags.
  CodeMem.FreeMem.clear();

  // Make code memory executable.
  ec = applyMemoryGroupPermissions(CodeMem,
                                   sys::Memory::MF_READ | sys::Memory::MF_EXEC);
  if (ec) {
    if (ErrMsg) {
      *ErrMsg = ec.message();
    }
    return true;
  }

  // Don't allow free memory blocks to be used after setting protection flags.
  RODataMem.FreeMem.clear();

  // Make read-only data memory read-only.
  ec = applyMemoryGroupPermissions(RODataMem,
                                   sys::Memory::MF_READ | sys::Memory::MF_EXEC);
  if (ec) {
    if (ErrMsg) {
      *ErrMsg = ec.message();
    }
    return true;
  }

  // Read-write data memory already has the correct permissions

  // Some platforms with separate data cache and instruction cache require
  // explicit cache flush, otherwise JIT code manipulations (like resolved
  // relocations) will get to the data cache but not to the instruction cache.
  invalidateInstructionCache();

  // Now, remember that we have successfully applied the permissions to avoid
  // having to apply them again.
  CodeMem.AllocatedMem.append(CodeMem.PendingMem.begin(),CodeMem.PendingMem.end());
  CodeMem.PendingMem.clear();

  RODataMem.AllocatedMem.append(RODataMem.PendingMem.begin(),RODataMem.PendingMem.end());
  RODataMem.PendingMem.clear();

  return false;
}

std::error_code
SectionMemoryManager::applyMemoryGroupPermissions(MemoryGroup &MemGroup,
                                                  unsigned Permissions) {

  for (sys::MemoryBlock &MB : MemGroup.PendingMem)
    if (std::error_code EC = sys::Memory::protectMappedMemory(MB, Permissions))
      return EC;

  return std::error_code();
}

void SectionMemoryManager::invalidateInstructionCache() {
  for (sys::MemoryBlock &Block : CodeMem.PendingMem)
    sys::Memory::InvalidateInstructionCache(Block.base(), Block.size());
}

SectionMemoryManager::~SectionMemoryManager() {
  for (MemoryGroup *Group : {&CodeMem, &RWDataMem, &RODataMem}) {
    for (sys::MemoryBlock &Block : Group->AllocatedMem)
      sys::Memory::releaseMappedMemory(Block);
    for (sys::MemoryBlock &Block : Group->PendingMem)
      sys::Memory::releaseMappedMemory(Block);
  }
}

} // namespace llvm

