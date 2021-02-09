# RUN: yaml2obj %s -o %t.o
# RUN: llvm-readobj --notes %t.o | FileCheck %s --check-prefix=LLVM
# RUN: llvm-readelf --notes %t.o | FileCheck %s --check-prefix=GNU

# GNU:      Displaying notes found in: .note.foo
# GNU-NEXT:   Owner                Data size        Description
# GNU-NEXT:   AMDGPU               0x000000d4       NT_AMDGPU_METADATA (AMDGPU Metadata)
# GNU-NEXT:     AMDGPU Metadata:
# GNU-NEXT:         Invalid AMDGPU Metadata
# GNU-NEXT:         ---
# GNU-NEXT: amdhsa.kernels:
# GNU-NEXT:   - .group_segment_fixed_size: 2
# GNU-NEXT:     .kernarg_segment_align: 4
# GNU-NEXT:     .kernarg_segment_size: 1
# GNU-NEXT:     .max_flat_workgroup_size: 8
# GNU-NEXT:     .name:           foo
# GNU-NEXT:     .private_segment_fixed_size: 3
# GNU-NEXT:     .sgpr_count:     6
# GNU-NEXT:     .symbol:         foo
# GNU-NEXT:     .vgpr_count:     7
# GNU-NEXT:     .wavefront_size: 5
# GNU-NEXT: ...
# GNU-EMPTY:

# LLVM:      Notes [
# LLVM-NEXT:   NoteSection {
# LLVM-NEXT:     Name: .note.foo
# LLVM-NEXT:     Offset: 0x40
# LLVM-NEXT:     Size: 0xE8
# LLVM-NEXT:     Note {
# LLVM-NEXT:       Owner: AMDGPU
# LLVM-NEXT:       Data size: 0xD4
# LLVM-NEXT:       Type: NT_AMDGPU_METADATA (AMDGPU Metadata)
# LLVM-NEXT:       AMDGPU Metadata: Invalid AMDGPU Metadata
# LLVM-NEXT: ---
# LLVM-NEXT: amdhsa.kernels:
# LLVM-NEXT:   - .group_segment_fixed_size: 2
# LLVM-NEXT:     .kernarg_segment_align: 4
# LLVM-NEXT:     .kernarg_segment_size: 1
# LLVM-NEXT:     .max_flat_workgroup_size: 8
# LLVM-NEXT:     .name:           foo
# LLVM-NEXT:     .private_segment_fixed_size: 3
# LLVM-NEXT:     .sgpr_count:     6
# LLVM-NEXT:     .symbol:         foo
# LLVM-NEXT:     .vgpr_count:     7
# LLVM-NEXT:     .wavefront_size: 5
# LLVM-NEXT: ...
# LLVM-EMPTY:
# LLVM-NEXT:     }
# LLVM-NEXT:   }
# LLVM-NEXT: ]

## Use yaml2obj instead of llvm-mc for more test portability. This was
## generated by grabbing section data from note-amdgpu.s and removing the amdhsa.version field.

--- !ELF
FileHeader:
  Class: ELFCLASS64
  Data:  ELFDATA2LSB
  Type:  ET_REL
Sections:
  - Name:        .note.foo
    Type:        SHT_NOTE
    Content:     07000000D400000020000000414D44475055000081ae616d646873612e6b65726e656c73918ab92e67726f75705f7365676d656e745f66697865645f73697a6502b62e6b65726e6172675f7365676d656e745f616c69676e04b52e6b65726e6172675f7365676d656e745f73697a6501b82e6d61785f666c61745f776f726b67726f75705f73697a6508a52e6e616d65a3666f6fbb2e707269766174655f7365676d656e745f66697865645f73697a6503ab2e736770725f636f756e7406a72e73796d626f6ca3666f6fab2e766770725f636f756e7407af2e7761766566726f6e745f73697a6505
