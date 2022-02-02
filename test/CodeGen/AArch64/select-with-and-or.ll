; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

define i1 @and(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: and:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #4, eq
; CHECK-NEXT:    cset w0, gt
; CHECK-NEXT:    ret
  %a = icmp eq i32 %x, %y
  %b = icmp sgt i32 %z, %w
  %s = select i1 %a, i1 %b, i1 false
  ret i1 %s
}

define i1 @or(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: or:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    cset w8, eq
; CHECK-NEXT:    cmp w2, w3
; CHECK-NEXT:    cset w9, gt
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %a = icmp eq i32 %x, %y
  %b = icmp sgt i32 %z, %w
  %s = select i1 %a, i1 true, i1 %b
  ret i1 %s
}

define i1 @and_not(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: and_not:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #4, ne
; CHECK-NEXT:    cset w0, gt
; CHECK-NEXT:    ret
  %a = icmp eq i32 %x, %y
  %b = icmp sgt i32 %z, %w
  %s = select i1 %a, i1 false, i1 %b
  ret i1 %s
}

define i1 @or_not(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: or_not:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    cset w8, ne
; CHECK-NEXT:    cmp w2, w3
; CHECK-NEXT:    cset w9, gt
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %a = icmp eq i32 %x, %y
  %b = icmp sgt i32 %z, %w
  %s = select i1 %a, i1 %b, i1 true
  ret i1 %s
}

define <4 x i1> @and_vec(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: and_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> %b, <4 x i1> zeroinitializer
  ret <4 x i1> %s
}

define <4 x i1> @or_vec(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: or_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orr v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> <i1 1, i1 1, i1 1, i1 1>, <4 x i1> %b
  ret <4 x i1> %s
}

define <4 x i1> @and_not_vec(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: and_not_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bic v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> zeroinitializer, <4 x i1> %b
  ret <4 x i1> %s
}

define <4 x i1> @or_not_vec(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: or_not_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orn v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> %b, <4 x i1> <i1 1, i1 1, i1 1, i1 1>
  ret <4 x i1> %s
}

define <4 x i1> @and_vec_undef(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: and_vec_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> %b, <4 x i1> <i1 0, i1 undef, i1 0, i1 undef>
  ret <4 x i1> %s
}

define <4 x i1> @or_vec_undef(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: or_vec_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orr v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> <i1 undef, i1 1, i1 1, i1 undef>, <4 x i1> %b
  ret <4 x i1> %s
}

define <4 x i1> @and_not_vec_undef(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: and_not_vec_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    bic v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> <i1 0, i1 0, i1 undef, i1 0>, <4 x i1> %b
  ret <4 x i1> %s
}

define <4 x i1> @or_not_vec_undef(<4 x i32> %x, <4 x i32> %y, <4 x i32> %z, <4 x i32> %w) {
; CHECK-LABEL: or_not_vec_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmgt v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    orn v0.16b, v2.16b, v0.16b
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %a = icmp eq <4 x i32> %x, %y
  %b = icmp sgt <4 x i32> %z, %w
  %s = select <4 x i1> %a, <4 x i1> %b, <4 x i1> <i1 1, i1 undef, i1 1, i1 1>
  ret <4 x i1> %s
}
