; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; This tests the BuildREMEqFold optimization with UREM, i32, odd divisor, SETEQ.
; The corresponding pseudocode is:
; Q <- [N * multInv(5, 2^32)] <=> [N * 0xCCCCCCCD] <=> [N * (-858993459)]
; res <- [Q <= (2^32 - 1) / 5] <=> [Q <= 858993459] <=> [Q < 858993460]
define i32 @test_urem_odd(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_odd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #52429
; CHECK-NEXT:    movk w8, #52428, lsl #16
; CHECK-NEXT:    umull x8, w0, w8
; CHECK-NEXT:    lsr x8, x8, #34
; CHECK-NEXT:    add w8, w8, w8, lsl #2
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 30 set.
define i32 @test_urem_odd_bit30(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_odd_bit30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-11
; CHECK-NEXT:    umull x8, w0, w8
; CHECK-NEXT:    mov w9, #3
; CHECK-NEXT:    lsr x8, x8, #62
; CHECK-NEXT:    movk w9, #16384, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 1073741827
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 31 set.
define i32 @test_urem_odd_bit31(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_odd_bit31:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, w0
; CHECK-NEXT:    lsl x9, x8, #30
; CHECK-NEXT:    sub x8, x9, x8
; CHECK-NEXT:    lsr x8, x8, #61
; CHECK-NEXT:    mov w9, #-2147483645
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 2147483651
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This tests the BuildREMEqFold optimization with UREM, i16, even divisor, SETNE.
; In this case, D <=> 14 <=> 7 * 2^1, so D0 = 7 and K = 1.
; The corresponding pseudocode is:
; Q <- [N * multInv(D0, 2^16)] <=> [N * multInv(7, 2^16)] <=> [N * 28087]
; Q <- [Q >>rot K] <=> [Q >>rot 1]
; res <- ![Q <= (2^16 - 1) / 7] <=> ![Q <= 9362] <=> [Q > 9362]
define i16 @test_urem_even(i16 %X) nounwind readnone {
; CHECK-LABEL: test_urem_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w10, #9363
; CHECK-NEXT:    ubfx w9, w0, #1, #15
; CHECK-NEXT:    movk w10, #37449, lsl #16
; CHECK-NEXT:    umull x9, w9, w10
; CHECK-NEXT:    and w8, w0, #0xffff
; CHECK-NEXT:    lsr x9, x9, #34
; CHECK-NEXT:    orr w10, wzr, #0xe
; CHECK-NEXT:    msub w8, w9, w10, w8
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %urem = urem i16 %X, 14
  %cmp = icmp ne i16 %urem, 0
  %ret = zext i1 %cmp to i16
  ret i16 %ret
}

; This is like test_urem_even, except the divisor has bit 30 set.
define i32 @test_urem_even_bit30(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_even_bit30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-415
; CHECK-NEXT:    umull x8, w0, w8
; CHECK-NEXT:    mov w9, #104
; CHECK-NEXT:    lsr x8, x8, #62
; CHECK-NEXT:    movk w9, #16384, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 1073741928
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; This is like test_urem_odd, except the divisor has bit 31 set.
define i32 @test_urem_even_bit31(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_even_bit31:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65435
; CHECK-NEXT:    movk w8, #32767, lsl #16
; CHECK-NEXT:    umull x8, w0, w8
; CHECK-NEXT:    mov w9, #102
; CHECK-NEXT:    lsr x8, x8, #62
; CHECK-NEXT:    movk w9, #32768, lsl #16
; CHECK-NEXT:    msub w8, w8, w9, w0
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 2147483750
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We should not proceed with this fold if the divisor is 1 or -1
define i32 @test_urem_one(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w0, wzr, #0x1
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 1
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

; We can lower remainder of division by powers of two much better elsewhere;
; also, BuildREMEqFold does not work when the only odd factor of the divisor is 1.
; This ensures we don't touch powers of two.
define i32 @test_urem_pow2(i32 %X) nounwind readnone {
; CHECK-LABEL: test_urem_pow2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0xf
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %urem = urem i32 %X, 16
  %cmp = icmp eq i32 %urem, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}
