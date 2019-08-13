; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; Odd+Even divisors
define <4 x i32> @test_srem_odd_even(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI0_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI0_0]
; CHECK-NEXT:    adrp x8, .LCPI0_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI0_1]
; CHECK-NEXT:    adrp x8, .LCPI0_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI0_2]
; CHECK-NEXT:    adrp x8, .LCPI0_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI0_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 25, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;==============================================================================;

; One all-ones divisor in odd divisor
define <4 x i32> @test_srem_odd_allones_eq(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_allones_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x10, .LCPI1_0
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    mov w9, #39321
; CHECK-NEXT:    ldr q1, [x10, :lo12:.LCPI1_0]
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    movk w9, #6553, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    dup v3.4s, w9
; CHECK-NEXT:    mla v3.4s, v0.4s, v2.4s
; CHECK-NEXT:    cmhs v0.4s, v1.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 5, i32 4294967295, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
define <4 x i32> @test_srem_odd_allones_ne(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_allones_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x10, .LCPI2_0
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    mov w9, #39321
; CHECK-NEXT:    ldr q1, [x10, :lo12:.LCPI2_0]
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    movk w9, #6553, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    dup v3.4s, w9
; CHECK-NEXT:    mla v3.4s, v0.4s, v2.4s
; CHECK-NEXT:    cmhi v0.4s, v3.4s, v1.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 5, i32 4294967295, i32 5>
  %cmp = icmp ne <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor in even divisor
define <4 x i32> @test_srem_even_allones_eq(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_allones_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI3_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI3_0]
; CHECK-NEXT:    adrp x8, .LCPI3_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI3_1]
; CHECK-NEXT:    adrp x8, .LCPI3_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI3_2]
; CHECK-NEXT:    adrp x8, .LCPI3_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI3_3]
; CHECK-NEXT:    adrp x8, .LCPI3_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI3_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 14, i32 4294967295, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
define <4 x i32> @test_srem_even_allones_ne(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_allones_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI4_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI4_0]
; CHECK-NEXT:    adrp x8, .LCPI4_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI4_1]
; CHECK-NEXT:    adrp x8, .LCPI4_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI4_2]
; CHECK-NEXT:    adrp x8, .LCPI4_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI4_3]
; CHECK-NEXT:    adrp x8, .LCPI4_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI4_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 14, i32 4294967295, i32 14>
  %cmp = icmp ne <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_allones_eq(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_allones_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI5_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI5_0]
; CHECK-NEXT:    adrp x8, .LCPI5_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI5_1]
; CHECK-NEXT:    adrp x8, .LCPI5_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI5_2]
; CHECK-NEXT:    adrp x8, .LCPI5_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI5_3]
; CHECK-NEXT:    adrp x8, .LCPI5_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI5_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 4294967295, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
define <4 x i32> @test_srem_odd_even_allones_ne(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_allones_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI6_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI6_0]
; CHECK-NEXT:    adrp x8, .LCPI6_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI6_1]
; CHECK-NEXT:    adrp x8, .LCPI6_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI6_2]
; CHECK-NEXT:    adrp x8, .LCPI6_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI6_3]
; CHECK-NEXT:    adrp x8, .LCPI6_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI6_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    mvn v0.16b, v0.16b
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 4294967295, i32 100>
  %cmp = icmp ne <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

; One power-of-two divisor in odd divisor
define <4 x i32> @test_srem_odd_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI7_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI7_0]
; CHECK-NEXT:    adrp x8, .LCPI7_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI7_1]
; CHECK-NEXT:    adrp x8, .LCPI7_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI7_2]
; CHECK-NEXT:    adrp x8, .LCPI7_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI7_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 5, i32 16, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One power-of-two divisor in even divisor
define <4 x i32> @test_srem_even_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI8_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI8_0]
; CHECK-NEXT:    adrp x8, .LCPI8_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI8_1]
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    add v1.4s, v1.4s, v0.4s
; CHECK-NEXT:    sshr v3.4s, v1.4s, #3
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 14, i32 16, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One power-of-two divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI9_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI9_0]
; CHECK-NEXT:    adrp x8, .LCPI9_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI9_1]
; CHECK-NEXT:    adrp x8, .LCPI9_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI9_2]
; CHECK-NEXT:    adrp x8, .LCPI9_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI9_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 16, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

; One one divisor in odd divisor
define <4 x i32> @test_srem_odd_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x10, .LCPI10_0
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    mov w9, #39321
; CHECK-NEXT:    ldr q1, [x10, :lo12:.LCPI10_0]
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    movk w9, #6553, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    dup v3.4s, w9
; CHECK-NEXT:    mla v3.4s, v0.4s, v2.4s
; CHECK-NEXT:    cmhs v0.4s, v1.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 5, i32 1, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One one divisor in even divisor
define <4 x i32> @test_srem_even_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI11_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI11_0]
; CHECK-NEXT:    adrp x8, .LCPI11_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI11_1]
; CHECK-NEXT:    adrp x8, .LCPI11_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI11_2]
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    adrp x8, .LCPI11_3
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI11_3]
; CHECK-NEXT:    neg v2.4s, v2.4s
; CHECK-NEXT:    add v1.4s, v1.4s, v0.4s
; CHECK-NEXT:    sshl v2.4s, v1.4s, v2.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    add v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v4.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 14, i32 1, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One one divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI12_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI12_0]
; CHECK-NEXT:    adrp x8, .LCPI12_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI12_1]
; CHECK-NEXT:    adrp x8, .LCPI12_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI12_2]
; CHECK-NEXT:    adrp x8, .LCPI12_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI12_3]
; CHECK-NEXT:    adrp x8, .LCPI12_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI12_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 1, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

; One INT_MIN divisor in odd divisor
define <4 x i32> @test_srem_odd_INT_MIN(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_INT_MIN:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI13_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI13_0]
; CHECK-NEXT:    adrp x8, .LCPI13_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI13_1]
; CHECK-NEXT:    adrp x8, .LCPI13_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI13_2]
; CHECK-NEXT:    adrp x8, .LCPI13_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI13_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 5, i32 2147483648, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One INT_MIN divisor in even divisor
define <4 x i32> @test_srem_even_INT_MIN(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_INT_MIN:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI14_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI14_0]
; CHECK-NEXT:    adrp x8, .LCPI14_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI14_1]
; CHECK-NEXT:    adrp x8, .LCPI14_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI14_2]
; CHECK-NEXT:    adrp x8, .LCPI14_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI14_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 14, i32 2147483648, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One INT_MIN divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_INT_MIN(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_INT_MIN:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI15_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI15_0]
; CHECK-NEXT:    adrp x8, .LCPI15_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI15_1]
; CHECK-NEXT:    adrp x8, .LCPI15_2
; CHECK-NEXT:    smull2 v3.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v3.4s
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI15_2]
; CHECK-NEXT:    adrp x8, .LCPI15_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI15_3]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    usra v3.4s, v1.4s, #31
; CHECK-NEXT:    mls v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 14, i32 2147483648, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;==============================================================================;

; One all-ones divisor and power-of-two divisor divisor in odd divisor
define <4 x i32> @test_srem_odd_allones_and_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_allones_and_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI16_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI16_0]
; CHECK-NEXT:    adrp x8, .LCPI16_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI16_1]
; CHECK-NEXT:    adrp x8, .LCPI16_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI16_2]
; CHECK-NEXT:    adrp x8, .LCPI16_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI16_3]
; CHECK-NEXT:    adrp x8, .LCPI16_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI16_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 4294967295, i32 16, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor and power-of-two divisor divisor in even divisor
define <4 x i32> @test_srem_even_allones_and_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_allones_and_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI17_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI17_0]
; CHECK-NEXT:    adrp x8, .LCPI17_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI17_1]
; CHECK-NEXT:    adrp x8, .LCPI17_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI17_2]
; CHECK-NEXT:    adrp x8, .LCPI17_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI17_3]
; CHECK-NEXT:    adrp x8, .LCPI17_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI17_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 4294967295, i32 16, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor and power-of-two divisor divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_allones_and_poweroftwo(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_allones_and_poweroftwo:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI18_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI18_0]
; CHECK-NEXT:    adrp x8, .LCPI18_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI18_1]
; CHECK-NEXT:    adrp x8, .LCPI18_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI18_2]
; CHECK-NEXT:    adrp x8, .LCPI18_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI18_3]
; CHECK-NEXT:    adrp x8, .LCPI18_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI18_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 4294967295, i32 16, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

; One all-ones divisor and one one divisor in odd divisor
define <4 x i32> @test_srem_odd_allones_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_allones_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x10, .LCPI19_0
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    mov w9, #39321
; CHECK-NEXT:    ldr q1, [x10, :lo12:.LCPI19_0]
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    movk w9, #6553, lsl #16
; CHECK-NEXT:    dup v2.4s, w8
; CHECK-NEXT:    dup v3.4s, w9
; CHECK-NEXT:    mla v3.4s, v0.4s, v2.4s
; CHECK-NEXT:    cmhs v0.4s, v1.4s, v3.4s
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 4294967295, i32 1, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor and one one divisor in even divisor
define <4 x i32> @test_srem_even_allones_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_allones_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI20_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI20_0]
; CHECK-NEXT:    adrp x8, .LCPI20_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI20_1]
; CHECK-NEXT:    adrp x8, .LCPI20_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI20_2]
; CHECK-NEXT:    adrp x8, .LCPI20_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI20_3]
; CHECK-NEXT:    adrp x8, .LCPI20_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI20_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 4294967295, i32 1, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One all-ones divisor and one one divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_allones_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_allones_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI21_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI21_0]
; CHECK-NEXT:    adrp x8, .LCPI21_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI21_1]
; CHECK-NEXT:    adrp x8, .LCPI21_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI21_2]
; CHECK-NEXT:    adrp x8, .LCPI21_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI21_3]
; CHECK-NEXT:    adrp x8, .LCPI21_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI21_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 4294967295, i32 1, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

; One power-of-two divisor divisor and one divisor in odd divisor
define <4 x i32> @test_srem_odd_poweroftwo_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_poweroftwo_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI22_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI22_0]
; CHECK-NEXT:    adrp x8, .LCPI22_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI22_1]
; CHECK-NEXT:    adrp x8, .LCPI22_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI22_2]
; CHECK-NEXT:    adrp x8, .LCPI22_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI22_3]
; CHECK-NEXT:    adrp x8, .LCPI22_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI22_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 16, i32 1, i32 5>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One power-of-two divisor divisor and one divisor in even divisor
define <4 x i32> @test_srem_even_poweroftwo_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_poweroftwo_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI23_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI23_0]
; CHECK-NEXT:    adrp x8, .LCPI23_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI23_1]
; CHECK-NEXT:    adrp x8, .LCPI23_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI23_2]
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    adrp x8, .LCPI23_3
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI23_3]
; CHECK-NEXT:    neg v2.4s, v2.4s
; CHECK-NEXT:    add v1.4s, v1.4s, v0.4s
; CHECK-NEXT:    sshl v2.4s, v1.4s, v2.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    add v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v4.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 16, i32 1, i32 14>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

; One power-of-two divisor divisor and one divisor in odd+even divisor
define <4 x i32> @test_srem_odd_even_poweroftwo_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_even_poweroftwo_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI24_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI24_0]
; CHECK-NEXT:    adrp x8, .LCPI24_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI24_1]
; CHECK-NEXT:    adrp x8, .LCPI24_2
; CHECK-NEXT:    ldr q3, [x8, :lo12:.LCPI24_2]
; CHECK-NEXT:    adrp x8, .LCPI24_3
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI24_3]
; CHECK-NEXT:    adrp x8, .LCPI24_4
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI24_4]
; CHECK-NEXT:    neg v3.4s, v3.4s
; CHECK-NEXT:    sshl v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v4.16b
; CHECK-NEXT:    add v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 16, i32 1, i32 100>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

;------------------------------------------------------------------------------;

define <4 x i32> @test_srem_odd_allones_and_poweroftwo_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_odd_allones_and_poweroftwo_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI25_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI25_0]
; CHECK-NEXT:    adrp x8, .LCPI25_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI25_1]
; CHECK-NEXT:    adrp x8, .LCPI25_2
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI25_2]
; CHECK-NEXT:    adrp x8, .LCPI25_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI25_3]
; CHECK-NEXT:    neg v4.4s, v4.4s
; CHECK-NEXT:    movi v3.2d, #0x000000ffffffff
; CHECK-NEXT:    sshl v4.4s, v1.4s, v4.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    add v1.4s, v4.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 5, i32 4294967295, i32 16, i32 1>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}

define <4 x i32> @test_srem_even_allones_and_poweroftwo_and_one(<4 x i32> %X) nounwind {
; CHECK-LABEL: test_srem_even_allones_and_poweroftwo_and_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI26_0
; CHECK-NEXT:    ldr q1, [x8, :lo12:.LCPI26_0]
; CHECK-NEXT:    adrp x8, .LCPI26_1
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI26_1]
; CHECK-NEXT:    adrp x8, .LCPI26_2
; CHECK-NEXT:    smull2 v4.2d, v0.4s, v1.4s
; CHECK-NEXT:    smull v1.2d, v0.2s, v1.2s
; CHECK-NEXT:    uzp2 v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    ldr q4, [x8, :lo12:.LCPI26_2]
; CHECK-NEXT:    adrp x8, .LCPI26_3
; CHECK-NEXT:    mla v1.4s, v0.4s, v2.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI26_3]
; CHECK-NEXT:    neg v4.4s, v4.4s
; CHECK-NEXT:    movi v3.2d, #0x000000ffffffff
; CHECK-NEXT:    sshl v4.4s, v1.4s, v4.4s
; CHECK-NEXT:    ushr v1.4s, v1.4s, #31
; CHECK-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    add v1.4s, v4.4s, v1.4s
; CHECK-NEXT:    mls v0.4s, v1.4s, v2.4s
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    movi v1.4s, #1
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ret
  %srem = srem <4 x i32> %X, <i32 14, i32 4294967295, i32 16, i32 1>
  %cmp = icmp eq <4 x i32> %srem, <i32 0, i32 0, i32 0, i32 0>
  %ret = zext <4 x i1> %cmp to <4 x i32>
  ret <4 x i32> %ret
}
