; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-pc-linux | FileCheck %s

; Checks that the stores aren't eliminated by the DAG combiner, because the address
; spaces are different. In X86, we're checking this for the non-zero address space :fs.
; The test's 'same' and 'diff' notation depicts whether the pointer value is the same
; or different.

; FIXME: DAG combine incorrectly eliminates store if pointer is of same value.

define i32 @copy_fs_same() {
; CHECK-LABEL: copy_fs_same:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl 1, %eax
; CHECK-NEXT:    retl
entry:
   %0 = load i32, i32* inttoptr (i64 1 to i32*), align 4
  store i32 %0, i32 addrspace(257)* inttoptr (i64 1 to i32 addrspace(257)*), align 4
  ret i32 %0
}

define i32 @copy_fs_diff() {
; CHECK-LABEL: copy_fs_diff:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl 1, %eax
; CHECK-NEXT:    movl %eax, %fs:2
; CHECK-NEXT:    retl
entry:
   %0 = load i32, i32* inttoptr (i64 1 to i32*), align 4
  store i32 %0, i32 addrspace(257)* inttoptr (i64 2 to i32 addrspace(257)*), align 4
  ret i32 %0
}

define void @output_fs_same(i32 %v) {
; CHECK-LABEL: output_fs_same:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, 1
; CHECK-NEXT:    retl
entry:
  store i32 %v, i32* inttoptr (i64 1 to i32*), align 4
  store i32 %v, i32 addrspace(257)* inttoptr (i64 1 to i32 addrspace(257)*), align 4
  ret void
}

define void @output_fs_diff(i32 %v) {
; CHECK-LABEL: output_fs_diff:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, 1
; CHECK-NEXT:    movl %eax, %fs:2
; CHECK-NEXT:    retl
entry:
  store i32 %v, i32* inttoptr (i64 1 to i32*), align 4
  store i32 %v, i32 addrspace(257)* inttoptr (i64 2 to i32 addrspace(257)*), align 4
  ret void
}

define void @output_indexed_fs_same(i32 %v, i32* %b) {
; CHECK-LABEL: output_indexed_fs_same:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %eax, 168(%ecx)
; CHECK-NEXT:    retl
  %p = getelementptr i32, i32* %b, i64 42
  %pa = addrspacecast i32* %p to i32 addrspace(257)*
  store i32 %v, i32* %p, align 4
  store i32 %v, i32 addrspace(257)* %pa, align 4
  ret void
}

define void @output_indexed_fs_diff(i32 %v, i32* %b) {
; CHECK-LABEL: output_indexed_fs_diff:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %eax, 168(%ecx)
; CHECK-NEXT:    movl %eax, %fs:184(%ecx)
; CHECK-NEXT:    retl
  %p = getelementptr i32, i32* %b, i64 42
  %pa = addrspacecast i32* %p to i32 addrspace(257)*
  %pad = getelementptr i32, i32 addrspace(257)* %pa, i64 4
  store i32 %v, i32* %p, align 4
  store i32 %v, i32 addrspace(257)* %pad, align 4
  ret void
}
