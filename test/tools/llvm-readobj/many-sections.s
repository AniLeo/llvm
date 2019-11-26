## Here we simulate an object with more than ~65k sections and check how we dump it.
## When an ELF object has SHN_LORESERVE (0xff00) or more sections, its e_shnum field
## should be zero and sh_size of the section header at index 0 is used
## to store the value. If the section name string table section index is
## greater than or equal to SHN_LORESERVE, then e_shstrndx field
## should have the value of SHN_XINDEX and sh_link of the section header
## at index 0 is used to store the value.

# RUN: yaml2obj --docnum=1 %s -o %t1
# RUN: llvm-readelf --file-headers -S %t1 | FileCheck %s --check-prefix=GNU1
# GNU1: Number of section headers:         0 (3)
# GNU1: Section header string table index: 65535 (2)
# GNU1: There are 3 section headers, starting at offset 0x58

# RUN: llvm-readobj --file-headers %t1 | FileCheck %s --check-prefix=LLVM1
# LLVM1: SectionHeaderCount: 0 (3)
# LLVM1: StringTableSectionIndex: 65535 (2)

--- !ELF
FileHeader:
  Class:    ELFCLASS64
  Data:     ELFDATA2LSB
  Type:     ET_REL
  Machine:  EM_X86_64
  SHNum:    0
  SHStrNdx: 0xffff ## SHN_XINDEX
Sections:
  - Type: SHT_NULL
    Link: .shstrtab
    Size: 0x3

## Another case is when e_shoff field set to zero, but not e_shstrndx.
## We want to show that this corrupt case is handled correctly.

# RUN: yaml2obj --docnum=2 %s -o %t2

# RUN: llvm-readelf --file-headers %t2 | FileCheck %s --check-prefix=GNU2
# GNU2: Number of section headers:         0
# GNU2: Section header string table index: 65535 (corrupt: out of range)

# RUN: llvm-readobj --file-headers %t2 | FileCheck %s --check-prefix=LLVM2
# LLVM2: SectionHeaderCount: 0
# LLVM2: StringTableSectionIndex: 65535 (corrupt: out of range)

--- !ELF
FileHeader:
  Class:    ELFCLASS64
  Data:     ELFDATA2LSB
  Type:     ET_REL
  Machine:  EM_X86_64
  SHOff:    0
  SHNum:    0
  SHStrNdx: 0xffff ## SHN_XINDEX
Sections:
  - Type: SHT_NULL
    Link: .shstrtab
    Size: 0x3
