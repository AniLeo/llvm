; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

; These are actually tests of ValueTracking, and so may have test coverage in InstCombine or other
; IR opt passes, but ValueTracking also affects the backend via SelectionDAGBuilder::visitSelect().

define <4 x i32> @smin_vec1(<4 x i32> %x) {
; CHECK-LABEL: smin_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp sgt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %not_x, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %sel
}

define <4 x i32> @smin_vec2(<4 x i32> %x) {
; CHECK-LABEL: smin_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %not_x
  ret <4 x i32> %sel
}

; Z = X -nsw Y
; (X >s Y) ? 0 : Z ==> (Z >s 0) ? 0 : Z ==> SMIN(Z, 0)
define <4 x i32> @smin_vec3(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: smin_vec3:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sub = sub nsw <4 x i32> %x, %y
  %cmp = icmp sgt <4 x i32> %x, %y
  %sel = select <4 x i1> %cmp, <4 x i32> zeroinitializer, <4 x i32> %sub
  ret <4 x i32> %sel
}

; Z = X -nsw Y
; (X <s Y) ? Z : 0 ==> (Z <s 0) ? Z : 0 ==> SMIN(Z, 0)
define <4 x i32> @smin_vec4(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: smin_vec4:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpminsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sub = sub nsw <4 x i32> %x, %y
  %cmp = icmp slt <4 x i32> %x, %y
  %sel = select <4 x i1> %cmp, <4 x i32> %sub, <4 x i32> zeroinitializer
  ret <4 x i32> %sel
}

define <4 x i32> @smax_vec1(<4 x i32> %x) {
; CHECK-LABEL: smax_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %not_x, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %sel
}

define <4 x i32> @smax_vec2(<4 x i32> %x) {
; CHECK-LABEL: smax_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %not_x = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %cmp = icmp sgt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %not_x
  ret <4 x i32> %sel
}

; Z = X -nsw Y
; (X <s Y) ? 0 : Z ==> (Z <s 0) ? 0 : Z ==> SMAX(Z, 0)
define <4 x i32> @smax_vec3(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: smax_vec3:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sub = sub nsw <4 x i32> %x, %y
  %cmp = icmp slt <4 x i32> %x, %y
  %sel = select <4 x i1> %cmp, <4 x i32> zeroinitializer, <4 x i32> %sub
  ret <4 x i32> %sel
}

; Z = X -nsw Y
; (X >s Y) ? Z : 0 ==> (Z >s 0) ? Z : 0 ==> SMAX(Z, 0)
define <4 x i32> @smax_vec4(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: smax_vec4:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpsubd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sub = sub nsw <4 x i32> %x, %y
  %cmp = icmp sgt <4 x i32> %x, %y
  %sel = select <4 x i1> %cmp, <4 x i32> %sub, <4 x i32> zeroinitializer
  ret <4 x i32> %sel
}

define <4 x i32> @umax_vec1(<4 x i32> %x) {
; CHECK-LABEL: umax_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpmaxud {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> %x, <4 x i32> <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  ret <4 x i32> %sel
}

define <4 x i32> @umax_vec2(<4 x i32> %x) {
; CHECK-LABEL: umax_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpmaxud {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>, <4 x i32> %x
  ret <4 x i32> %sel
}

define <4 x i32> @umin_vec1(<4 x i32> %x) {
; CHECK-LABEL: umin_vec1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp slt <4 x i32> %x, zeroinitializer
  %sel = select <4 x i1> %cmp, <4 x i32> <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>, <4 x i32> %x
  ret <4 x i32> %sel
}

define <4 x i32> @umin_vec2(<4 x i32> %x) {
; CHECK-LABEL: umin_vec2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %cmp = icmp sgt <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %sel = select <4 x i1> %cmp, <4 x i32> %x, <4 x i32> <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>
  ret <4 x i32> %sel
}

; The next 4 tests are value clamping with constants:
; https://llvm.org/bugs/show_bug.cgi?id=31693

; (X <s C1) ? C1 : SMIN(X, C2) ==> SMAX(SMIN(X, C2), C1)

define <4 x i32> @clamp_signed1(<4 x i32> %x) {
; CHECK-LABEL: clamp_signed1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpminsd {{.*}}(%rip), %xmm0, %xmm1
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15]
; CHECK-NEXT:    vpcmpgtd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp2 = icmp slt <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %min = select <4 x i1> %cmp2, <4 x i32> %x, <4 x i32><i32 255, i32 255, i32 255, i32 255>
  %cmp1 = icmp slt <4 x i32> %x, <i32 15, i32 15, i32 15, i32 15>
  %r = select <4 x i1> %cmp1, <4 x i32><i32 15, i32 15, i32 15, i32 15>, <4 x i32> %min
  ret <4 x i32> %r
}

; (X >s C1) ? C1 : SMAX(X, C2) ==> SMIN(SMAX(X, C2), C1)

define <4 x i32> @clamp_signed2(<4 x i32> %x) {
; CHECK-LABEL: clamp_signed2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpmaxsd {{.*}}(%rip), %xmm0, %xmm1
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [255,255,255,255]
; CHECK-NEXT:    vpcmpgtd %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp2 = icmp sgt <4 x i32> %x, <i32 15, i32 15, i32 15, i32 15>
  %max = select <4 x i1> %cmp2, <4 x i32> %x, <4 x i32><i32 15, i32 15, i32 15, i32 15>
  %cmp1 = icmp sgt <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %r = select <4 x i1> %cmp1, <4 x i32><i32 255, i32 255, i32 255, i32 255>, <4 x i32> %max
  ret <4 x i32> %r
}

; (X <u C1) ? C1 : UMIN(X, C2) ==> UMAX(UMIN(X, C2), C1)

define <4 x i32> @clamp_unsigned1(<4 x i32> %x) {
; CHECK-LABEL: clamp_unsigned1:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpminud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [2147483663,2147483663,2147483663,2147483663]
; CHECK-NEXT:    vpcmpgtd %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    vblendvps %xmm0, {{.*}}(%rip), %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp2 = icmp ult <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %min = select <4 x i1> %cmp2, <4 x i32> %x, <4 x i32><i32 255, i32 255, i32 255, i32 255>
  %cmp1 = icmp ult <4 x i32> %x, <i32 15, i32 15, i32 15, i32 15>
  %r = select <4 x i1> %cmp1, <4 x i32><i32 15, i32 15, i32 15, i32 15>, <4 x i32> %min
  ret <4 x i32> %r
}

; (X >u C1) ? C1 : UMAX(X, C2) ==> UMIN(UMAX(X, C2), C1)

define <4 x i32> @clamp_unsigned2(<4 x i32> %x) {
; CHECK-LABEL: clamp_unsigned2:
; CHECK:       # BB#0:
; CHECK-NEXT:    vpmaxud {{.*}}(%rip), %xmm0, %xmm1
; CHECK-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vpcmpgtd {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vblendvps %xmm0, {{.*}}(%rip), %xmm1, %xmm0
; CHECK-NEXT:    retq
  %cmp2 = icmp ugt <4 x i32> %x, <i32 15, i32 15, i32 15, i32 15>
  %max = select <4 x i1> %cmp2, <4 x i32> %x, <4 x i32><i32 15, i32 15, i32 15, i32 15>
  %cmp1 = icmp ugt <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %r = select <4 x i1> %cmp1, <4 x i32><i32 255, i32 255, i32 255, i32 255>, <4 x i32> %max
  ret <4 x i32> %r
}

