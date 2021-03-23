; RUN: llc < %s -asm-verbose=false -O2 | FileCheck --check-prefix=CHECK %s
; RUN: llc < %s -asm-verbose=false -O2 --filetype=obj | obj2yaml | FileCheck --check-prefix=OBJ %s

; Test that compilation units with call_indirect but without any
; function pointer declarations still get a table.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: call_indirect_void:
; CHECK-NEXT: .functype call_indirect_void (i32) -> ()
; CHECK-NEXT: local.get 0
; CHECK-NEXT: call_indirect () -> ()
; CHECK-NEXT: end_function
define void @call_indirect_void(void ()* %callee) {
  call void %callee()
  ret void
}

; OBJ:    Imports:
; OBJ-NEXT:      - Module:          env
; OBJ-NEXT:        Field:           __linear_memory
; OBJ-NEXT:        Kind:            MEMORY
; OBJ-NEXT:        Memory:
; OBJ-NEXT:          Minimum:         0x0
; OBJ-NEXT:      - Module:          env
; OBJ-NEXT:        Field:           __indirect_function_table
; OBJ-NEXT:        Kind:            TABLE
