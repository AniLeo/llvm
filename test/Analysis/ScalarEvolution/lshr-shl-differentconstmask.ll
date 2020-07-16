; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -S -analyze -enable-new-pm=0 -scalar-evolution < %s | FileCheck %s
; RUN: opt -S -disable-output "-passes=print<scalar-evolution>" < %s 2>&1 | FileCheck %s

; The obvious case.
define i32 @udiv_biggerLshr(i32 %val) nounwind {
; CHECK-LABEL: 'udiv_biggerLshr'
; CHECK-NEXT:  Classifying expressions for: @udiv_biggerLshr
; CHECK-NEXT:    %tmp1 = udiv i32 %val, 64
; CHECK-NEXT:    -->  (%val /u 64) U: [0,67108864) S: [0,67108864)
; CHECK-NEXT:    %tmp2 = mul i32 %tmp1, 16
; CHECK-NEXT:    -->  (16 * (%val /u 64))<nuw><nsw> U: [0,1073741809) S: [0,1073741809)
; CHECK-NEXT:  Determining loop execution counts for: @udiv_biggerLshr
;
  %tmp1 = udiv i32 %val, 64
  %tmp2 = mul i32 %tmp1, 16
  ret i32 %tmp2
}

define i32 @udiv_biggerShl(i32 %val) nounwind {
; CHECK-LABEL: 'udiv_biggerShl'
; CHECK-NEXT:  Classifying expressions for: @udiv_biggerShl
; CHECK-NEXT:    %tmp1 = udiv i32 %val, 16
; CHECK-NEXT:    -->  (%val /u 16) U: [0,268435456) S: [0,268435456)
; CHECK-NEXT:    %tmp2 = mul i32 %tmp1, 64
; CHECK-NEXT:    -->  (64 * (%val /u 16)) U: [0,-63) S: [-2147483648,2147483585)
; CHECK-NEXT:  Determining loop execution counts for: @udiv_biggerShl
;
  %tmp1 = udiv i32 %val, 16
  %tmp2 = mul i32 %tmp1, 64
  ret i32 %tmp2
}

; Or, it could have been transformed to shifts

define i32 @shifty_biggerLshr(i32 %val) {
; CHECK-LABEL: 'shifty_biggerLshr'
; CHECK-NEXT:  Classifying expressions for: @shifty_biggerLshr
; CHECK-NEXT:    %tmp1 = lshr i32 %val, 6
; CHECK-NEXT:    -->  (%val /u 64) U: [0,67108864) S: [0,67108864)
; CHECK-NEXT:    %tmp2 = shl i32 %tmp1, 4
; CHECK-NEXT:    -->  (16 * (%val /u 64))<nuw><nsw> U: [0,1073741809) S: [0,1073741809)
; CHECK-NEXT:  Determining loop execution counts for: @shifty_biggerLshr
;
  %tmp1 = lshr i32 %val, 6
  %tmp2 = shl i32 %tmp1, 4
  ret i32 %tmp2
}

define i32 @shifty_biggerLshr_lshrexact(i32 %val) {
; CHECK-LABEL: 'shifty_biggerLshr_lshrexact'
; CHECK-NEXT:  Classifying expressions for: @shifty_biggerLshr_lshrexact
; CHECK-NEXT:    %tmp1 = lshr exact i32 %val, 6
; CHECK-NEXT:    -->  (%val /u 64) U: [0,67108864) S: [0,67108864)
; CHECK-NEXT:    %tmp2 = shl i32 %tmp1, 4
; CHECK-NEXT:    -->  (16 * (%val /u 64))<nuw><nsw> U: [0,1073741809) S: [0,1073741809)
; CHECK-NEXT:  Determining loop execution counts for: @shifty_biggerLshr_lshrexact
;
  %tmp1 = lshr exact i32 %val, 6
  %tmp2 = shl i32 %tmp1, 4
  ret i32 %tmp2
}

define i32 @shifty_biggerShr(i32 %val) {
; CHECK-LABEL: 'shifty_biggerShr'
; CHECK-NEXT:  Classifying expressions for: @shifty_biggerShr
; CHECK-NEXT:    %tmp1 = lshr i32 %val, 4
; CHECK-NEXT:    -->  (%val /u 16) U: [0,268435456) S: [0,268435456)
; CHECK-NEXT:    %tmp2 = shl i32 %tmp1, 6
; CHECK-NEXT:    -->  (64 * (%val /u 16)) U: [0,-63) S: [-2147483648,2147483585)
; CHECK-NEXT:  Determining loop execution counts for: @shifty_biggerShr
;
  %tmp1 = lshr i32 %val, 4
  %tmp2 = shl i32 %tmp1, 6
  ret i32 %tmp2
}

define i32 @shifty_biggerShr_lshrexact(i32 %val) {
; CHECK-LABEL: 'shifty_biggerShr_lshrexact'
; CHECK-NEXT:  Classifying expressions for: @shifty_biggerShr_lshrexact
; CHECK-NEXT:    %tmp1 = lshr exact i32 %val, 4
; CHECK-NEXT:    -->  (%val /u 16) U: [0,268435456) S: [0,268435456)
; CHECK-NEXT:    %tmp2 = shl i32 %tmp1, 6
; CHECK-NEXT:    -->  (64 * (%val /u 16)) U: [0,-63) S: [-2147483648,2147483585)
; CHECK-NEXT:  Determining loop execution counts for: @shifty_biggerShr_lshrexact
;
  %tmp1 = lshr exact i32 %val, 4
  %tmp2 = shl i32 %tmp1, 6
  ret i32 %tmp2
}

; Or, further folded into mask variant.

define i32 @masky_biggerLshr(i32 %val) {
; CHECK-LABEL: 'masky_biggerLshr'
; CHECK-NEXT:  Classifying expressions for: @masky_biggerLshr
; CHECK-NEXT:    %tmp1 = lshr i32 %val, 2
; CHECK-NEXT:    -->  (%val /u 4) U: [0,1073741824) S: [0,1073741824)
; CHECK-NEXT:    %tmp2 = and i32 %tmp1, -16
; CHECK-NEXT:    -->  (16 * (%val /u 64))<nuw><nsw> U: [0,1073741809) S: [0,1073741809)
; CHECK-NEXT:  Determining loop execution counts for: @masky_biggerLshr
;
  %tmp1 = lshr i32 %val, 2
  %tmp2 = and i32 %tmp1, -16
  ret i32 %tmp2
}

define i32 @masky_biggerLshr_lshrexact(i32 %val) {
; CHECK-LABEL: 'masky_biggerLshr_lshrexact'
; CHECK-NEXT:  Classifying expressions for: @masky_biggerLshr_lshrexact
; CHECK-NEXT:    %tmp1 = lshr exact i32 %val, 2
; CHECK-NEXT:    -->  (%val /u 4) U: [0,1073741824) S: [0,1073741824)
; CHECK-NEXT:  Determining loop execution counts for: @masky_biggerLshr_lshrexact
;
  %tmp1 = lshr exact i32 %val, 2
  ret i32 %tmp1
}

define i32 @masky_biggerShr(i32 %val) {
; CHECK-LABEL: 'masky_biggerShr'
; CHECK-NEXT:  Classifying expressions for: @masky_biggerShr
; CHECK-NEXT:    %tmp1 = shl i32 %val, 2
; CHECK-NEXT:    -->  (4 * %val) U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:    %tmp2 = and i32 %tmp1, -64
; CHECK-NEXT:    -->  (64 * (zext i26 (trunc i32 (%val /u 16) to i26) to i32))<nuw> U: [0,-63) S: [-2147483648,2147483585)
; CHECK-NEXT:  Determining loop execution counts for: @masky_biggerShr
;
  %tmp1 = shl i32 %val, 2
  %tmp2 = and i32 %tmp1, -64
  ret i32 %tmp2
}

define i32 @masky_biggerShr_lshrexact(i32 %val) {
; CHECK-LABEL: 'masky_biggerShr_lshrexact'
; CHECK-NEXT:  Classifying expressions for: @masky_biggerShr_lshrexact
; CHECK-NEXT:    %tmp1 = shl i32 %val, 2
; CHECK-NEXT:    -->  (4 * %val) U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:  Determining loop execution counts for: @masky_biggerShr_lshrexact
;
  %tmp1 = shl i32 %val, 2
  ret i32 %tmp1
}
