; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; Odd divisor
define <4 x i32> @test_urem_odd_25(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_odd_25:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #23593
; CHECK-NEXT:    movk w8, #49807, lsl #16
; CHECK-NEXT:    mov w9, #28835
; CHECK-NEXT:    movk w9, #2621, lsl #16
; CHECK-NEXT:    dup v1.4s, w8
; CHECK-NEXT:    dup v2.4s, w9
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhs v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 25, i32 25, i32 25, i32 25>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Even divisors
define <4 x i32> @test_urem_even_100(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_even_100:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #23593
; CHECK-NEXT:    movk w8, #49807, lsl #16
; CHECK-NEXT:    dup v1.4s, w8
; CHECK-NEXT:    mov w9, #23592
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    movk w9, #655, lsl #16
; CHECK-NEXT:    shl v1.4s, v0.4s, #30
; CHECK-NEXT:    ushr v0.4s, v0.4s, #2
; CHECK-NEXT:    dup v2.4s, w9
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhs v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 100, i32 100, i32 100, i32 100>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Negative divisors should be negated, and thus this is still splat vectors.

; Odd divisor
define <4 x i32> @test_urem_odd_neg25(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_odd_neg25:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI2_0
; CHECK-NEXT:    adrp x9, .LCPI2_1
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI2_0]
; CHECK-NEXT:    ldr q2, [x9, :lo12:.LCPI2_1]
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    cmhs v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 25, i32 -25, i32 -25, i32 25>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; Even divisors
define <4 x i32> @test_urem_even_neg100(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_even_neg100:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI3_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI3_0]
; CHECK-NEXT:    adrp x8, .LCPI3_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI3_1]
; CHECK-NEXT:    mul v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    shl v1.4s, v0.4s, #30
; CHECK-NEXT:    ushr v0.4s, v0.4s, #2
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmhs v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 -100, i32 100, i32 -100, i32 100>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;
; Comparison constant has undef elements.
;------------------------------------------------------------------------------;

define <4 x i32> @test_urem_odd_undef1(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_odd_undef1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #34079
; CHECK-NEXT:    movk w8, #20971, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    umull2 v3.2d, v0.4s, v2.4s
; CHECK-NEXT:    umull v2.2d, v0.2s, v2.2s
; CHECK-NEXT:    uzp2 v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #25
; CHECK-NEXT:    ushr v2.4s, v2.4s, #3
; CHECK-NEXT:    mls v0.4s, v2.4s, v1.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 25, i32 25, i32 25, i32 25>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 undef, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

define <4 x i32> @test_urem_even_undef1(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_even_undef1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #34079
; CHECK-NEXT:    movk w8, #20971, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    umull2 v3.2d, v0.4s, v2.4s
; CHECK-NEXT:    umull v2.2d, v0.2s, v2.2s
; CHECK-NEXT:    uzp2 v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #100
; CHECK-NEXT:    ushr v2.4s, v2.4s, #5
; CHECK-NEXT:    mls v0.4s, v2.4s, v1.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 100, i32 100, i32 100, i32 100>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 undef, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;
; Negative tests
;------------------------------------------------------------------------------;

define <4 x i32> @test_urem_one_eq(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_one_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.4s, #1
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
define <4 x i32> @test_urem_one_ne(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_one_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 1, i32 1, i32 1, i32 1>
  %cmp = icmp ne <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; We can lower remainder of division by powers of two much better elsewhere.
define <4 x i32> @test_urem_pow2(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_pow2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v1.4s, #15
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 16, i32 16, i32 16, i32 16>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; We could lower remainder of division by INT_MIN much better elsewhere.
define <4 x i32> @test_urem_int_min(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_int_min:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic v0.4s, #128, lsl #24
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 2147483648, i32 2147483648, i32 2147483648, i32 2147483648>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; We could lower remainder of division by all-ones much better elsewhere.
define <4 x i32> @test_urem_allones(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_urem_allones:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg v0.4s, v0.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    cmhs v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %urem = urem <4 x i32> %X, <i32 4294967295, i32 4294967295, i32 4294967295, i32 4294967295>
  %cmp = icmp eq <4 x i32> %urem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
