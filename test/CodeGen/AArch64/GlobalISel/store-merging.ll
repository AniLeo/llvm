; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-apple-ios -global-isel -global-isel-abort=1 - < %s | FileCheck %s

define void @test_simple_2xs8(i8 *%ptr) {
; CHECK-LABEL: test_simple_2xs8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    strb w8, [x0]
; CHECK-NEXT:    strb w9, [x0, #1]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i8, i8 *%ptr, i64 0
  store i8 4, i8 *%addr1
  %addr2 = getelementptr i8, i8 *%ptr, i64 1
  store i8 5, i8 *%addr2
  ret void
}

define void @test_simple_2xs16(i16 *%ptr) {
; CHECK-LABEL: test_simple_2xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    movk w8, #5, lsl #16
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 4, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 5, i16 *%addr2
  ret void
}

define void @test_simple_4xs16(i16 *%ptr) {
; CHECK-LABEL: test_simple_4xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov x8, #4
; CHECK-NEXT:    movk x8, #5, lsl #16
; CHECK-NEXT:    movk x8, #9, lsl #32
; CHECK-NEXT:    movk x8, #14, lsl #48
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 4, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 5, i16 *%addr2
  %addr3 = getelementptr i16, i16 *%ptr, i64 2
  store i16 9, i16 *%addr3
  %addr4 = getelementptr i16, i16 *%ptr, i64 3
  store i16 14, i16 *%addr4
  ret void
}

define void @test_simple_2xs32(i32 *%ptr) {
; CHECK-LABEL: test_simple_2xs32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov x8, #4
; CHECK-NEXT:    movk x8, #5, lsl #32
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i32, i32 *%ptr, i64 0
  store i32 4, i32 *%addr1
  %addr2 = getelementptr i32, i32 *%ptr, i64 1
  store i32 5, i32 *%addr2
  ret void
}

define void @test_simple_2xs64_illegal(i64 *%ptr) {
; CHECK-LABEL: test_simple_2xs64_illegal:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    stp x8, x9, [x0]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i64, i64 *%ptr, i64 0
  store i64 4, i64 *%addr1
  %addr2 = getelementptr i64, i64 *%ptr, i64 1
  store i64 5, i64 *%addr2
  ret void
}

; Don't merge vectors...yet.
define void @test_simple_vector(<2 x i16> *%ptr) {
; CHECK-LABEL: test_simple_vector:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #7
; CHECK-NEXT:    mov w10, #5
; CHECK-NEXT:    mov w11, #8
; CHECK-NEXT:    strh w8, [x0]
; CHECK-NEXT:    strh w9, [x0, #2]
; CHECK-NEXT:    strh w10, [x0, #4]
; CHECK-NEXT:    strh w11, [x0, #6]
; CHECK-NEXT:    ret
  %addr1 = getelementptr <2 x i16>, <2 x i16> *%ptr, i64 0
  store <2 x i16> <i16 4, i16 7>, <2 x i16> *%addr1
  %addr2 = getelementptr <2 x i16>, <2 x i16> *%ptr, i64 1
  store <2 x i16> <i16 5, i16 8>, <2 x i16> *%addr2
  ret void
}

define i32 @test_unknown_alias(i32 *%ptr, i32 *%aliasptr) {
; CHECK-LABEL: test_unknown_alias:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w9, #4
; CHECK-NEXT:    mov x8, x0
; CHECK-NEXT:    str w9, [x0]
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    ldr w0, [x1]
; CHECK-NEXT:    str w9, [x8, #4]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i32, i32 *%ptr, i64 0
  store i32 4, i32 *%addr1
  %ld = load i32, i32 *%aliasptr
  %addr2 = getelementptr i32, i32 *%ptr, i64 1
  store i32 5, i32 *%addr2
  ret i32 %ld
}

define void @test_2x_2xs32(i32 *%ptr, i32 *%ptr2) {
; CHECK-LABEL: test_2x_2xs32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov x10, #9
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    movk x10, #17, lsl #32
; CHECK-NEXT:    stp w8, w9, [x0]
; CHECK-NEXT:    str x10, [x1]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i32, i32 *%ptr, i64 0
  store i32 4, i32 *%addr1
  %addr2 = getelementptr i32, i32 *%ptr, i64 1
  store i32 5, i32 *%addr2

  %addr3 = getelementptr i32, i32 *%ptr2, i64 0
  store i32 9, i32 *%addr3
  %addr4 = getelementptr i32, i32 *%ptr2, i64 1
  store i32 17, i32 *%addr4
  ret void
}

define void @test_simple_var_2xs8(i8 *%ptr, i8 %v1, i8 %v2) {
; CHECK-LABEL: test_simple_var_2xs8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    strb w1, [x0]
; CHECK-NEXT:    strb w2, [x0, #1]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i8, i8 *%ptr, i64 0
  store i8 %v1, i8 *%addr1
  %addr2 = getelementptr i8, i8 *%ptr, i64 1
  store i8 %v2, i8 *%addr2
  ret void
}

define void @test_simple_var_2xs16(i16 *%ptr, i16 %v1, i16 %v2) {
; CHECK-LABEL: test_simple_var_2xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    strh w1, [x0]
; CHECK-NEXT:    strh w2, [x0, #2]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 %v1, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 %v2, i16 *%addr2
  ret void
}

define void @test_simple_var_2xs32(i32 *%ptr, i32 %v1, i32 %v2) {
; CHECK-LABEL: test_simple_var_2xs32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    stp w1, w2, [x0]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i32, i32 *%ptr, i64 0
  store i32 %v1, i32 *%addr1
  %addr2 = getelementptr i32, i32 *%ptr, i64 1
  store i32 %v2, i32 *%addr2
  ret void
}


; The store to ptr2 prevents merging into a single store.
; We can still merge the stores into addr1 and addr2.
define void @test_alias_4xs16(i16 *%ptr, i16 *%ptr2) {
; CHECK-LABEL: test_alias_4xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #9
; CHECK-NEXT:    movk w8, #5, lsl #16
; CHECK-NEXT:    mov w10, #14
; CHECK-NEXT:    strh w9, [x0, #4]
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    strh wzr, [x1]
; CHECK-NEXT:    strh w10, [x0, #6]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 4, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 5, i16 *%addr2
  %addr3 = getelementptr i16, i16 *%ptr, i64 2
  store i16 9, i16 *%addr3
  store i16 0, i16 *%ptr2
  %addr4 = getelementptr i16, i16 *%ptr, i64 3
  store i16 14, i16 *%addr4
  ret void
}

; Here store of 5 and 9 can be merged, others have aliasing barriers.
define void @test_alias2_4xs16(i16 *%ptr, i16 *%ptr2, i16* %ptr3) {
; CHECK-LABEL: test_alias2_4xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    movk w9, #9, lsl #16
; CHECK-NEXT:    strh w8, [x0]
; CHECK-NEXT:    mov w8, #14
; CHECK-NEXT:    strh wzr, [x2]
; CHECK-NEXT:    stur w9, [x0, #2]
; CHECK-NEXT:    strh wzr, [x1]
; CHECK-NEXT:    strh w8, [x0, #6]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 4, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 0, i16 *%ptr3
  store i16 5, i16 *%addr2
  %addr3 = getelementptr i16, i16 *%ptr, i64 2
  store i16 9, i16 *%addr3
  store i16 0, i16 *%ptr2
  %addr4 = getelementptr i16, i16 *%ptr, i64 3
  store i16 14, i16 *%addr4
  ret void
}

; No merging can be done here.
define void @test_alias3_4xs16(i16 *%ptr, i16 *%ptr2, i16 *%ptr3, i16 *%ptr4) {
; CHECK-LABEL: test_alias3_4xs16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    strh w8, [x0]
; CHECK-NEXT:    mov w8, #9
; CHECK-NEXT:    strh wzr, [x2]
; CHECK-NEXT:    strh w9, [x0, #2]
; CHECK-NEXT:    mov w9, #14
; CHECK-NEXT:    strh wzr, [x3]
; CHECK-NEXT:    strh w8, [x0, #4]
; CHECK-NEXT:    strh wzr, [x1]
; CHECK-NEXT:    strh w9, [x0, #6]
; CHECK-NEXT:    ret
  %addr1 = getelementptr i16, i16 *%ptr, i64 0
  store i16 4, i16 *%addr1
  %addr2 = getelementptr i16, i16 *%ptr, i64 1
  store i16 0, i16 *%ptr3
  store i16 5, i16 *%addr2
  store i16 0, i16 *%ptr4
  %addr3 = getelementptr i16, i16 *%ptr, i64 2
  store i16 9, i16 *%addr3
  store i16 0, i16 *%ptr2
  %addr4 = getelementptr i16, i16 *%ptr, i64 3
  store i16 14, i16 *%addr4
  ret void
}

; Can merge because the load is from a different alloca and can't alias.
define i32 @test_alias_allocas_2xs32(i32 *%ptr) {
; CHECK-LABEL: test_alias_allocas_2xs32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    mov x8, #4
; CHECK-NEXT:    ldr w0, [sp, #4]
; CHECK-NEXT:    movk x8, #5, lsl #32
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret
  %a1 = alloca [6 x i32]
  %a2 = alloca i32, align 4
  %addr1 = getelementptr [6 x i32], [6 x i32] *%a1, i64 0, i32 0
  store i32 4, i32 *%addr1
  %ld = load i32, i32 *%a2
  %addr2 = getelementptr [6 x i32], [6 x i32] *%a1, i64 0, i32 1
  store i32 5, i32 *%addr2
  ret i32 %ld
}
