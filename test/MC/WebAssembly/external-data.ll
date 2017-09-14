; RUN: llc -mtriple wasm32-unknown-unknown-wasm -filetype=obj %s -o - | obj2yaml | FileCheck %s
; Verify relocations are correctly generated for addresses of externals
; in the data section.

@myimport = external global i32, align 4

@foo = global i64 7, align 4
@bar = hidden global i32* @myimport, align 4

; CHECK:        - Type:            DATA
; CHECK-NEXT:     Relocations:
; CHECK-NEXT:       - Type:            R_WEBASSEMBLY_MEMORY_ADDR_I32
; CHECK-NEXT:         Index:           0
; CHECK-NEXT:         Offset:          0x00000013
; CHECK-NEXT:     Segments:
; CHECK-NEXT:       - SectionOffset:   6
; CHECK-NEXT:         MemoryIndex:     0
; CHECK-NEXT:         Offset:
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           0
; CHECK-NEXT:         Content:         '0700000000000000'
; CHECK-NEXT:       - SectionOffset:   19
; CHECK-NEXT:         MemoryIndex:     0
; CHECK-NEXT:         Offset:          
; CHECK-NEXT:           Opcode:          I32_CONST
; CHECK-NEXT:           Value:           8
; CHECK-NEXT:         Content:         FFFFFFFF
