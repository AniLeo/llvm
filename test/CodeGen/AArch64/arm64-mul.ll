; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-eabi | FileCheck %s

; rdar://9296808
; rdar://9349137

define i128 @t1(i64 %a, i64 %b) nounwind readnone ssp {
; CHECK-LABEL: t1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul x8, x0, x1
; CHECK-NEXT:    umulh x1, x0, x1
; CHECK-NEXT:    mov x0, x8
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i64 %a to i128
  %tmp2 = zext i64 %b to i128
  %tmp3 = mul i128 %tmp1, %tmp2
  ret i128 %tmp3
}

define i128 @t2(i64 %a, i64 %b) nounwind readnone ssp {
; CHECK-LABEL: t2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul x8, x0, x1
; CHECK-NEXT:    smulh x1, x0, x1
; CHECK-NEXT:    mov x0, x8
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i64 %a to i128
  %tmp2 = sext i64 %b to i128
  %tmp3 = mul i128 %tmp1, %tmp2
  ret i128 %tmp3
}

define i64 @t3(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: t3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umull x0, w0, w1
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i32 %a to i64
  %tmp2 = zext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  ret i64 %tmp3
}

define i64 @t4(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: t4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smull x0, w0, w1
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i32 %a to i64
  %tmp2 = sext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  ret i64 %tmp3
}

define i64 @t5(i32 %a, i32 %b, i64 %c) nounwind {
; CHECK-LABEL: t5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umaddl x0, w0, w1, x2
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i32 %a to i64
  %tmp2 = zext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  %tmp4 = add i64 %c, %tmp3
  ret i64 %tmp4
}

define i64 @t6(i32 %a, i32 %b, i64 %c) nounwind {
; CHECK-LABEL: t6:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smsubl x0, w0, w1, x2
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i32 %a to i64
  %tmp2 = sext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  %tmp4 = sub i64 %c, %tmp3
  ret i64 %tmp4
}

define i64 @t7(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: t7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    umnegl x0, w0, w1
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i32 %a to i64
  %tmp2 = zext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  %tmp4 = sub i64 0, %tmp3
  ret i64 %tmp4
}

define i64 @t8(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: t8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    smnegl x0, w0, w1
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i32 %a to i64
  %tmp2 = sext i32 %b to i64
  %tmp3 = mul i64 %tmp1, %tmp2
  %tmp4 = sub i64 0, %tmp3
  ret i64 %tmp4
}

define i64 @t9(i32 %a) nounwind {
; CHECK-LABEL: t9:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #8896
; CHECK-NEXT:    movk w8, #2, lsl #16
; CHECK-NEXT:    umull x0, w0, w8
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i32 %a to i64
  %tmp2 = mul i64 %tmp1, 139968
  ret i64 %tmp2
}

; Check 64-bit multiplication is used for constants > 32 bits.
define i64 @t10(i32 %a) nounwind {
; CHECK-LABEL: t10:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #2
; CHECK-NEXT:    // kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sxtw x9, w0
; CHECK-NEXT:    movk w8, #32768, lsl #16
; CHECK-NEXT:    mul x0, x9, x8
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i32 %a to i64
  %tmp2 = mul i64 %tmp1, 2147483650 ; = 2^31 + 2
  ret i64 %tmp2
}

; Check the sext_inreg case.
define i64 @t11(i64 %a) nounwind {
; CHECK-LABEL: t11:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #29594
; CHECK-NEXT:    movk w8, #65499, lsl #16
; CHECK-NEXT:    smnegl x0, w0, w8
; CHECK-NEXT:    ret
entry:
  %tmp1 = trunc i64 %a to i32
  %tmp2 = sext i32 %tmp1 to i64
  %tmp3 = mul i64 %tmp2, -2395238
  %tmp4 = sub i64 0, %tmp3
  ret i64 %tmp4
}

define i64 @t12(i64 %a, i64 %b) nounwind {
; CHECK-LABEL: t12:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #35118
; CHECK-NEXT:    movk w8, #65008, lsl #16
; CHECK-NEXT:    smaddl x0, w0, w8, x1
; CHECK-NEXT:    ret
entry:
  %tmp1 = trunc i64 %a to i32
  %tmp2 = sext i32 %tmp1 to i64
  %tmp3 = mul i64 %tmp2, -34567890
  %tmp4 = add i64 %b, %tmp3
  ret i64 %tmp4
}

define i64 @t13(i32 %a, i64 %b) nounwind {
; CHECK-LABEL: t13:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #24910
; CHECK-NEXT:    movk w8, #188, lsl #16
; CHECK-NEXT:    umsubl x0, w0, w8, x1
; CHECK-NEXT:    ret
entry:
  %tmp1 = zext i32 %a to i64
  %tmp3 = mul i64 %tmp1, 12345678
  %tmp4 = sub i64 %b, %tmp3
  ret i64 %tmp4
}

define i64 @t14(i32 %a, i64 %b) nounwind {
; CHECK-LABEL: t14:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #40626
; CHECK-NEXT:    movk w8, #65347, lsl #16
; CHECK-NEXT:    smsubl x0, w0, w8, x1
; CHECK-NEXT:    ret
entry:
  %tmp1 = sext i32 %a to i64
  %tmp3 = mul i64 %tmp1, -12345678
  %tmp4 = sub i64 %b, %tmp3
  ret i64 %tmp4
}
