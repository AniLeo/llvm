; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux -verify-machineinstrs | FileCheck %s

;; TODO All these can be improved

define zeroext i16 @t1(i16 zeroext %x) nounwind readnone ssp {
; CHECK-LABEL: t1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.w (6,%sp), %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    sub.l #26, %d0
; CHECK-NEXT:    shi %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    lsl.l #5, %d0
; CHECK-NEXT:    rts
entry:
  %0 = icmp ugt i16 %x, 26                        ; <i1> [#uses=1]
  %iftmp.1.0 = select i1 %0, i16 32, i16 0        ; <i16> [#uses=1]
  ret i16 %iftmp.1.0
}

define zeroext i16 @t2(i16 zeroext %x) nounwind readnone ssp {
; CHECK-LABEL: t2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.w (6,%sp), %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    sub.l #26, %d0
; CHECK-NEXT:    scs %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    lsl.l #5, %d0
; CHECK-NEXT:    rts
entry:
  %0 = icmp ult i16 %x, 26                        ; <i1> [#uses=1]
  %iftmp.0.0 = select i1 %0, i16 32, i16 0        ; <i16> [#uses=1]
  ret i16 %iftmp.0.0
}

define fastcc i64 @t3(i64 %x) nounwind readnone ssp {
; CHECK-LABEL: t3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.l #0, %d2
; CHECK-NEXT:    sub.l #18, %d1
; CHECK-NEXT:    subx.l %d2, %d0
; CHECK-NEXT:    scs %d0
; CHECK-NEXT:    move.l %d0, %d1
; CHECK-NEXT:    and.l #255, %d1
; CHECK-NEXT:    and.l #1, %d1
; CHECK-NEXT:    lsl.l #6, %d1
; CHECK-NEXT:    move.l %d2, %d0
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
  %0 = icmp ult i64 %x, 18                        ; <i1> [#uses=1]
  %iftmp.2.0 = select i1 %0, i64 64, i64 0        ; <i64> [#uses=1]
  ret i64 %iftmp.2.0
}

define i8 @t5(i32 %a) {
; CHECK-LABEL: t5:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l #31, %d1
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    lsr.l %d1, %d0
; CHECK-NEXT:    eori.b #1, %d0
; CHECK-NEXT:    ; kill: def $bd0 killed $bd0 killed $d0
; CHECK-NEXT:    rts
entry:
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i8
  %.not = xor i8 %trunc, 1
  ret i8 %.not
}


;
; TODO: Should it be like this?
; cmp.l
; smi
; since we are intereseted in sign bit only
; and.l in the end is superfluous

define zeroext i1 @t6(i32 %a) {
; CHECK-LABEL: t6:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.l #31, %d0
; CHECK-NEXT:    move.l (4,%sp), %d1
; CHECK-NEXT:    lsr.l %d0, %d1
; CHECK-NEXT:    eori.b #1, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    rts
entry:
  %.lobit = lshr i32 %a, 31
  %trunc = trunc i32 %.lobit to i1
  %.not = xor i1 %trunc, 1
  ret i1 %.not
}
