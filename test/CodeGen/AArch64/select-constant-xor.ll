; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-none-none-eabi %s -o - | FileCheck %s

define i32 @xori64i32(i64 %a) {
; CHECK-LABEL: xori64i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr x8, x0, #63
; CHECK-NEXT:    eor w0, w8, #0x7fffffff
; CHECK-NEXT:    ret
  %shr4 = ashr i64 %a, 63
  %conv5 = trunc i64 %shr4 to i32
  %xor = xor i32 %conv5, 2147483647
  ret i32 %xor
}

define i64 @selecti64i64(i64 %a) {
; CHECK-LABEL: selecti64i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x0, #0
; CHECK-NEXT:    mov w8, #2147483647
; CHECK-NEXT:    cinv x0, x8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}

define i32 @selecti64i32(i64 %a) {
; CHECK-LABEL: selecti64i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp x0, #0
; CHECK-NEXT:    mov w8, #2147483647
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i32 2147483647, i32 -2147483648
  ret i32 %s
}

define i64 @selecti32i64(i32 %a) {
; CHECK-LABEL: selecti32i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #2147483647
; CHECK-NEXT:    cinv x0, x8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}



define i8 @xori32i8(i32 %a) {
; CHECK-LABEL: xori32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #84
; CHECK-NEXT:    eor w0, w8, w0, asr #31
; CHECK-NEXT:    ret
  %shr4 = ashr i32 %a, 31
  %conv5 = trunc i32 %shr4 to i8
  %xor = xor i8 %conv5, 84
  ret i8 %xor
}

define i32 @selecti32i32(i32 %a) {
; CHECK-LABEL: selecti32i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #84
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i8 @selecti32i8(i32 %a) {
; CHECK-LABEL: selecti32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #84
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i8 84, i8 -85
  ret i8 %s
}

define i32 @selecti8i32(i8 %a) {
; CHECK-LABEL: selecti8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    mov w8, #84
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i8 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i32 @icmpasreq(i32 %input, i32 %a, i32 %b) {
; CHECK-LABEL: icmpasreq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csel w0, w1, w2, lt
; CHECK-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp eq i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @icmpasrne(i32 %input, i32 %a, i32 %b) {
; CHECK-LABEL: icmpasrne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csel w0, w1, w2, gt
; CHECK-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp ne i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @selecti32i32_0(i32 %a) {
; CHECK-LABEL: selecti32i32_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    asr w0, w0, #31
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 0, i32 -1
  ret i32 %s
}

define i32 @selecti32i32_m1(i32 %a) {
; CHECK-LABEL: selecti32i32_m1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w0
; CHECK-NEXT:    asr w0, w8, #31
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 -1, i32 0
  ret i32 %s
}

define i32 @selecti32i32_1(i32 %a) {
; CHECK-LABEL: selecti32i32_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 1, i32 -2
  ret i32 %s
}

define i32 @selecti32i32_sge(i32 %a) {
; CHECK-LABEL: selecti32i32_sge:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #12
; CHECK-NEXT:    cinv w0, w8, lt
; CHECK-NEXT:    ret
  %c = icmp sge i32 %a, 0
  %s = select i1 %c, i32 12, i32 -13
  ret i32 %s
}

define i32 @selecti32i32_slt(i32 %a) {
; CHECK-LABEL: selecti32i32_slt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #-13
; CHECK-NEXT:    cinv w0, w8, ge
; CHECK-NEXT:    ret
  %c = icmp slt i32 %a, 0
  %s = select i1 %c, i32 -13, i32 12
  ret i32 %s
}

define i32 @selecti32i32_sle(i32 %a) {
; CHECK-LABEL: selecti32i32_sle:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #-13
; CHECK-NEXT:    cinv w0, w8, ge
; CHECK-NEXT:    ret
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -13, i32 12
  ret i32 %s
}

define i32 @selecti32i32_sgt(i32 %a) {
; CHECK-LABEL: selecti32i32_sgt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #-13
; CHECK-NEXT:    cinv w0, w8, ge
; CHECK-NEXT:    ret
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -13, i32 12
  ret i32 %s
}

define i32 @oneusecmp(i32 %a, i32 %b, i32 %d) {
; CHECK-LABEL: oneusecmp:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    mov w8, #-128
; CHECK-NEXT:    cinv w8, w8, ge
; CHECK-NEXT:    csel w9, w2, w1, lt
; CHECK-NEXT:    add w0, w8, w9
; CHECK-NEXT:    ret
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -128, i32 127
  %s2 = select i1 %c, i32 %d, i32 %b
  %x = add i32 %s, %s2
  ret i32 %x
}
