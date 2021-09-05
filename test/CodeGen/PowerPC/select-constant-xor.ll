; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64-unknown-unknown %s -o - | FileCheck %s

define i32 @xori64i32(i64 %a) {
; CHECK-LABEL: xori64i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sradi 3, 3, 63
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 32767
; CHECK-NEXT:    blr
  %shr4 = ashr i64 %a, 63
  %conv5 = trunc i64 %shr4 to i32
  %xor = xor i32 %conv5, 2147483647
  ret i32 %xor
}

define i64 @selecti64i64(i64 %a) {
; CHECK-LABEL: selecti64i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sradi 3, 3, 63
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 32767
; CHECK-NEXT:    blr
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}

define i32 @selecti64i32(i64 %a) {
; CHECK-LABEL: selecti64i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sradi 3, 3, 63
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 32767
; CHECK-NEXT:    blr
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i32 2147483647, i32 -2147483648
  ret i32 %s
}

define i64 @selecti32i64(i32 %a) {
; CHECK-LABEL: selecti32i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    srawi 3, 3, 31
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    xori 3, 3, 65535
; CHECK-NEXT:    xoris 3, 3, 32767
; CHECK-NEXT:    blr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}



define i8 @xori32i8(i32 %a) {
; CHECK-LABEL: xori32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    srawi 3, 3, 31
; CHECK-NEXT:    xori 3, 3, 84
; CHECK-NEXT:    blr
  %shr4 = ashr i32 %a, 31
  %conv5 = trunc i32 %shr4 to i8
  %xor = xor i8 %conv5, 84
  ret i8 %xor
}

define i32 @selecti32i32(i32 %a) {
; CHECK-LABEL: selecti32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    srawi 3, 3, 31
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    xori 3, 3, 84
; CHECK-NEXT:    blr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i8 @selecti32i8(i32 %a) {
; CHECK-LABEL: selecti32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    srawi 3, 3, 31
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    xori 3, 3, 84
; CHECK-NEXT:    blr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i8 84, i8 -85
  ret i8 %s
}

define i32 @selecti8i32(i8 %a) {
; CHECK-LABEL: selecti8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    extsb 3, 3
; CHECK-NEXT:    srawi 3, 3, 7
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    xori 3, 3, 84
; CHECK-NEXT:    blr
  %c = icmp sgt i8 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i32 @icmpasreq(i32 %input, i32 %a, i32 %b) {
; CHECK-LABEL: icmpasreq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpwi 3, 0
; CHECK-NEXT:    isellt 3, 4, 5
; CHECK-NEXT:    blr
  %sh = ashr i32 %input, 31
  %c = icmp eq i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @icmpasrne(i32 %input, i32 %a, i32 %b) {
; CHECK-LABEL: icmpasrne:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpwi 3, 0
; CHECK-NEXT:    iselgt 3, 4, 5
; CHECK-NEXT:    blr
  %sh = ashr i32 %input, 31
  %c = icmp ne i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @oneusecmp(i32 %a, i32 %b, i32 %d) {
; CHECK-LABEL: oneusecmp:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li 6, 127
; CHECK-NEXT:    cmpwi 3, 0
; CHECK-NEXT:    li 3, -128
; CHECK-NEXT:    isellt 3, 3, 6
; CHECK-NEXT:    isellt 4, 5, 4
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    blr
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -128, i32 127
  %s2 = select i1 %c, i32 %d, i32 %b
  %x = add i32 %s, %s2
  ret i32 %x
}
