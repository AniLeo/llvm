; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 %s -o - | FileCheck %s --check-prefix=RV32
; RUN: llc -mtriple=riscv64 %s -o - | FileCheck %s --check-prefix=RV64

define i32 @xori64i32(i64 %a) {
; RV32-LABEL: xori64i32:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a0, a1, 31
; RV32-NEXT:    lui a1, 524288
; RV32-NEXT:    addi a1, a1, -1
; RV32-NEXT:    xor a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: xori64i32:
; RV64:       # %bb.0:
; RV64-NEXT:    srai a0, a0, 63
; RV64-NEXT:    lui a1, 524288
; RV64-NEXT:    addiw a1, a1, -1
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    ret
  %shr4 = ashr i64 %a, 63
  %conv5 = trunc i64 %shr4 to i32
  %xor = xor i32 %conv5, 2147483647
  ret i32 %xor
}

define i64 @selecti64i64(i64 %a) {
; RV32-LABEL: selecti64i64:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a1, a1, 31
; RV32-NEXT:    lui a0, 524288
; RV32-NEXT:    addi a0, a0, -1
; RV32-NEXT:    xor a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti64i64:
; RV64:       # %bb.0:
; RV64-NEXT:    srai a0, a0, 63
; RV64-NEXT:    lui a1, 524288
; RV64-NEXT:    addiw a1, a1, -1
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}

define i32 @selecti64i32(i64 %a) {
; RV32-LABEL: selecti64i32:
; RV32:       # %bb.0:
; RV32-NEXT:    slti a0, a1, 0
; RV32-NEXT:    xori a0, a0, 1
; RV32-NEXT:    lui a1, 524288
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti64i32:
; RV64:       # %bb.0:
; RV64-NEXT:    srai a0, a0, 63
; RV64-NEXT:    lui a1, 524288
; RV64-NEXT:    addiw a1, a1, -1
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    ret
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i32 2147483647, i32 -2147483648
  ret i32 %s
}

define i64 @selecti32i64(i32 %a) {
; RV32-LABEL: selecti32i64:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a1, a0, 31
; RV32-NEXT:    lui a0, 524288
; RV32-NEXT:    addi a0, a0, -1
; RV32-NEXT:    xor a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti32i64:
; RV64:       # %bb.0:
; RV64-NEXT:    sraiw a0, a0, 31
; RV64-NEXT:    lui a1, 524288
; RV64-NEXT:    addiw a1, a1, -1
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}



define i8 @xori32i8(i32 %a) {
; RV32-LABEL: xori32i8:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a0, a0, 31
; RV32-NEXT:    xori a0, a0, 84
; RV32-NEXT:    ret
;
; RV64-LABEL: xori32i8:
; RV64:       # %bb.0:
; RV64-NEXT:    sraiw a0, a0, 31
; RV64-NEXT:    xori a0, a0, 84
; RV64-NEXT:    ret
  %shr4 = ashr i32 %a, 31
  %conv5 = trunc i32 %shr4 to i8
  %xor = xor i8 %conv5, 84
  ret i8 %xor
}

define i32 @selecti32i32(i32 %a) {
; RV32-LABEL: selecti32i32:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a0, a0, 31
; RV32-NEXT:    xori a0, a0, 84
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti32i32:
; RV64:       # %bb.0:
; RV64-NEXT:    sraiw a0, a0, 31
; RV64-NEXT:    xori a0, a0, 84
; RV64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i8 @selecti32i8(i32 %a) {
; RV32-LABEL: selecti32i8:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a0, a0, 31
; RV32-NEXT:    xori a0, a0, 84
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti32i8:
; RV64:       # %bb.0:
; RV64-NEXT:    sraiw a0, a0, 31
; RV64-NEXT:    xori a0, a0, 84
; RV64-NEXT:    ret
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i8 84, i8 -85
  ret i8 %s
}

define i32 @selecti8i32(i8 %a) {
; RV32-LABEL: selecti8i32:
; RV32:       # %bb.0:
; RV32-NEXT:    slli a0, a0, 24
; RV32-NEXT:    srai a0, a0, 31
; RV32-NEXT:    xori a0, a0, 84
; RV32-NEXT:    ret
;
; RV64-LABEL: selecti8i32:
; RV64:       # %bb.0:
; RV64-NEXT:    slli a0, a0, 56
; RV64-NEXT:    srai a0, a0, 63
; RV64-NEXT:    xori a0, a0, 84
; RV64-NEXT:    ret
  %c = icmp sgt i8 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i32 @icmpasreq(i32 %input, i32 %a, i32 %b) {
; RV32-LABEL: icmpasreq:
; RV32:       # %bb.0:
; RV32-NEXT:    bltz a0, .LBB8_2
; RV32-NEXT:  # %bb.1:
; RV32-NEXT:    mv a1, a2
; RV32-NEXT:  .LBB8_2:
; RV32-NEXT:    mv a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: icmpasreq:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a3, a0
; RV64-NEXT:    mv a0, a1
; RV64-NEXT:    bltz a3, .LBB8_2
; RV64-NEXT:  # %bb.1:
; RV64-NEXT:    mv a0, a2
; RV64-NEXT:  .LBB8_2:
; RV64-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp eq i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @icmpasrne(i32 %input, i32 %a, i32 %b) {
; RV32-LABEL: icmpasrne:
; RV32:       # %bb.0:
; RV32-NEXT:    bgez a0, .LBB9_2
; RV32-NEXT:  # %bb.1:
; RV32-NEXT:    mv a1, a2
; RV32-NEXT:  .LBB9_2:
; RV32-NEXT:    mv a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: icmpasrne:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a3, a0
; RV64-NEXT:    mv a0, a1
; RV64-NEXT:    bgez a3, .LBB9_2
; RV64-NEXT:  # %bb.1:
; RV64-NEXT:    mv a0, a2
; RV64-NEXT:  .LBB9_2:
; RV64-NEXT:    ret
  %sh = ashr i32 %input, 31
  %c = icmp ne i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @oneusecmp(i32 %a, i32 %b, i32 %d) {
; RV32-LABEL: oneusecmp:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a3, a0, 31
; RV32-NEXT:    xori a3, a3, 127
; RV32-NEXT:    bltz a0, .LBB10_2
; RV32-NEXT:  # %bb.1:
; RV32-NEXT:    mv a2, a1
; RV32-NEXT:  .LBB10_2:
; RV32-NEXT:    add a0, a3, a2
; RV32-NEXT:    ret
;
; RV64-LABEL: oneusecmp:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a3, a0
; RV64-NEXT:    srli a0, a3, 31
; RV64-NEXT:    xori a0, a0, 127
; RV64-NEXT:    bltz a3, .LBB10_2
; RV64-NEXT:  # %bb.1:
; RV64-NEXT:    mv a2, a1
; RV64-NEXT:  .LBB10_2:
; RV64-NEXT:    addw a0, a0, a2
; RV64-NEXT:    ret
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -128, i32 127
  %s2 = select i1 %c, i32 %d, i32 %b
  %x = add i32 %s, %s2
  ret i32 %x
}
