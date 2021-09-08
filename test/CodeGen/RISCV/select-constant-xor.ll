; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 %s -o - | FileCheck %s --check-prefix=CHECK32
; RUN: llc -mtriple=riscv64 %s -o - | FileCheck %s --check-prefix=CHECK64

define i32 @xori64i32(i64 %a) {
; CHECK32-LABEL: xori64i32:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a0, a1, 31
; CHECK32-NEXT:    lui a1, 524288
; CHECK32-NEXT:    addi a1, a1, -1
; CHECK32-NEXT:    xor a0, a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: xori64i32:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    srai a0, a0, 63
; CHECK64-NEXT:    lui a1, 524288
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    xor a0, a0, a1
; CHECK64-NEXT:    ret
  %shr4 = ashr i64 %a, 63
  %conv5 = trunc i64 %shr4 to i32
  %xor = xor i32 %conv5, 2147483647
  ret i32 %xor
}

define i64 @selecti64i64(i64 %a) {
; CHECK32-LABEL: selecti64i64:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a1, a1, 31
; CHECK32-NEXT:    lui a0, 524288
; CHECK32-NEXT:    addi a0, a0, -1
; CHECK32-NEXT:    xor a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti64i64:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    srai a0, a0, 63
; CHECK64-NEXT:    lui a1, 524288
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    xor a0, a0, a1
; CHECK64-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}

define i32 @selecti64i32(i64 %a) {
; CHECK32-LABEL: selecti64i32:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    addi a0, zero, -1
; CHECK32-NEXT:    slt a0, a0, a1
; CHECK32-NEXT:    lui a1, 524288
; CHECK32-NEXT:    sub a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti64i32:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    srai a0, a0, 63
; CHECK64-NEXT:    lui a1, 524288
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    xor a0, a0, a1
; CHECK64-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i32 2147483647, i32 -2147483648
  ret i32 %s
}

define i64 @selecti32i64(i32 %a) {
; CHECK32-LABEL: selecti32i64:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a1, a0, 31
; CHECK32-NEXT:    lui a0, 524288
; CHECK32-NEXT:    addi a0, a0, -1
; CHECK32-NEXT:    xor a0, a1, a0
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti32i64:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sraiw a0, a0, 31
; CHECK64-NEXT:    lui a1, 524288
; CHECK64-NEXT:    addiw a1, a1, -1
; CHECK64-NEXT:    xor a0, a0, a1
; CHECK64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}



define i8 @xori32i8(i32 %a) {
; CHECK32-LABEL: xori32i8:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a0, a0, 31
; CHECK32-NEXT:    xori a0, a0, 84
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: xori32i8:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sraiw a0, a0, 31
; CHECK64-NEXT:    xori a0, a0, 84
; CHECK64-NEXT:    ret
  %shr4 = ashr i32 %a, 31
  %conv5 = trunc i32 %shr4 to i8
  %xor = xor i8 %conv5, 84
  ret i8 %xor
}

define i32 @selecti32i32(i32 %a) {
; CHECK32-LABEL: selecti32i32:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a0, a0, 31
; CHECK32-NEXT:    xori a0, a0, 84
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti32i32:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sraiw a0, a0, 31
; CHECK64-NEXT:    xori a0, a0, 84
; CHECK64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i8 @selecti32i8(i32 %a) {
; CHECK32-LABEL: selecti32i8:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a0, a0, 31
; CHECK32-NEXT:    xori a0, a0, 84
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti32i8:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sraiw a0, a0, 31
; CHECK64-NEXT:    xori a0, a0, 84
; CHECK64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i8 84, i8 -85
  ret i8 %s
}

define i32 @selecti8i32(i8 %a) {
; CHECK32-LABEL: selecti8i32:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    slli a0, a0, 24
; CHECK32-NEXT:    srai a0, a0, 31
; CHECK32-NEXT:    xori a0, a0, 84
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: selecti8i32:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    slli a0, a0, 56
; CHECK64-NEXT:    srai a0, a0, 63
; CHECK64-NEXT:    xori a0, a0, 84
; CHECK64-NEXT:    ret
  %c = icmp sgt i8 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i32 @icmpasreq(i32 %input, i32 %a, i32 %b) {
; CHECK32-LABEL: icmpasreq:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    bltz a0, .LBB8_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    mv a1, a2
; CHECK32-NEXT:  .LBB8_2:
; CHECK32-NEXT:    mv a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: icmpasreq:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sext.w a3, a0
; CHECK64-NEXT:    mv a0, a1
; CHECK64-NEXT:    bltz a3, .LBB8_2
; CHECK64-NEXT:  # %bb.1:
; CHECK64-NEXT:    mv a0, a2
; CHECK64-NEXT:  .LBB8_2:
; CHECK64-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp eq i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @icmpasrne(i32 %input, i32 %a, i32 %b) {
; CHECK32-LABEL: icmpasrne:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    bgez a0, .LBB9_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    mv a1, a2
; CHECK32-NEXT:  .LBB9_2:
; CHECK32-NEXT:    mv a0, a1
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: icmpasrne:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sext.w a3, a0
; CHECK64-NEXT:    mv a0, a1
; CHECK64-NEXT:    bgez a3, .LBB9_2
; CHECK64-NEXT:  # %bb.1:
; CHECK64-NEXT:    mv a0, a2
; CHECK64-NEXT:  .LBB9_2:
; CHECK64-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp ne i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @oneusecmp(i32 %a, i32 %b, i32 %d) {
; CHECK32-LABEL: oneusecmp:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    srai a3, a0, 31
; CHECK32-NEXT:    xori a3, a3, 127
; CHECK32-NEXT:    bltz a0, .LBB10_2
; CHECK32-NEXT:  # %bb.1:
; CHECK32-NEXT:    mv a2, a1
; CHECK32-NEXT:  .LBB10_2:
; CHECK32-NEXT:    add a0, a3, a2
; CHECK32-NEXT:    ret
;
; CHECK64-LABEL: oneusecmp:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    sext.w a3, a0
; CHECK64-NEXT:    srli a0, a3, 31
; CHECK64-NEXT:    xori a0, a0, 127
; CHECK64-NEXT:    bltz a3, .LBB10_2
; CHECK64-NEXT:  # %bb.1:
; CHECK64-NEXT:    mv a2, a1
; CHECK64-NEXT:  .LBB10_2:
; CHECK64-NEXT:    addw a0, a0, a2
; CHECK64-NEXT:    ret
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -128, i32 127
  %s2 = select i1 %c, i32 %d, i32 %b
  %x = add i32 %s, %s2
  ret i32 %x
}
