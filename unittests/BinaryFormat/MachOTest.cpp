//===- unittest/BinaryFormat/MachOTest.cpp - MachO support tests ----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/BinaryFormat/MachO.h"
#include "gtest/gtest.h"

using namespace llvm;
using namespace llvm::MachO;

TEST(MachOTest, UnalignedLC) {
  unsigned char Valid32BitMachO[] = {
      0xCE, 0xFA, 0xED, 0xFE, 0x07, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
      0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00,
      0x85, 0x80, 0x21, 0x01, 0x01, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00,
      0x5F, 0x5F, 0x50, 0x41, 0x47, 0x45, 0x5A, 0x45, 0x52, 0x4F, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x01, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00, 0x5F, 0x5F, 0x4C, 0x49,
      0x4E, 0x4B, 0x45, 0x44, 0x49, 0x54, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x40, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00,
      0x8C, 0x0B, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

  mach_header *Header =
      reinterpret_cast<mach_header *>(Valid32BitMachO);
  if (!sys::IsLittleEndianHost)
    swapStruct(*Header);
  ASSERT_EQ(Header->magic, MH_MAGIC);
  unsigned char *Current = Valid32BitMachO + sizeof(mach_header);
  unsigned char *BufferEnd =
      Valid32BitMachO + sizeof(mach_header) + Header->sizeofcmds;
  while (Current < BufferEnd) {
    macho_load_command *LC =
        reinterpret_cast<macho_load_command *>(Current);
    if (!sys::IsLittleEndianHost)
      swapStruct(LC->load_command_data);
    ASSERT_EQ(LC->load_command_data.cmd, LC_SEGMENT);
    Current += LC->load_command_data.cmdsize;
  }
}
