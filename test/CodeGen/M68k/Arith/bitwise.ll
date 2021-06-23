; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux -verify-machineinstrs | FileCheck %s

; op reg, reg

define zeroext i8 @andb(i8 zeroext %a, i8 zeroext %b) nounwind {
; CHECK-LABEL: andb:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.b (11,%sp), %d0
; CHECK-NEXT:    move.b (7,%sp), %d1
; CHECK-NEXT:    and.b %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    rts
  %1 = and i8 %a, %b
  ret i8 %1
}

define zeroext i16 @andw(i16 zeroext %a, i16 zeroext %b) nounwind {
; CHECK-LABEL: andw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    move.w (6,%sp), %d1
; CHECK-NEXT:    and.w %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    rts
  %1 = and i16 %a, %b
  ret i16 %1
}

define i32 @andl(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: andl:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (8,%sp), %d1
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    and.l %d1, %d0
; CHECK-NEXT:    rts
  %1 = and i32 %a, %b
  ret i32 %1
}

define zeroext i8 @orb(i8 zeroext %a, i8 zeroext %b) nounwind {
; CHECK-LABEL: orb:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.b (11,%sp), %d0
; CHECK-NEXT:    move.b (7,%sp), %d1
; CHECK-NEXT:    or.b %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    rts
  %1 = or i8 %a, %b
  ret i8 %1
}

define zeroext i16 @orw(i16 zeroext %a, i16 zeroext %b) nounwind {
; CHECK-LABEL: orw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    move.w (6,%sp), %d1
; CHECK-NEXT:    or.w %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    rts
  %1 = or i16 %a, %b
  ret i16 %1
}

define i32 @orl(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: orl:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (8,%sp), %d1
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    or.l %d1, %d0
; CHECK-NEXT:    rts
  %1 = or i32 %a, %b
  ret i32 %1
}

define zeroext i8 @eorb(i8 zeroext %a, i8 zeroext %b) nounwind {
; CHECK-LABEL: eorb:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.b (11,%sp), %d0
; CHECK-NEXT:    move.b (7,%sp), %d1
; CHECK-NEXT:    eor.b %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    rts
  %1 = xor i8 %a, %b
  ret i8 %1
}

define zeroext i16 @eorw(i16 zeroext %a, i16 zeroext %b) nounwind {
; CHECK-LABEL: eorw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    move.w (6,%sp), %d1
; CHECK-NEXT:    eor.w %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    rts
  %1 = xor i16 %a, %b
  ret i16 %1
}

define i32 @eorl(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: eorl:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (8,%sp), %d1
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    eor.l %d1, %d0
; CHECK-NEXT:    rts
  %1 = xor i32 %a, %b
  ret i32 %1
}

; op reg, imm
; For type i8 and i16, value is loaded from memory to avoid optimizing it to *.l

define void @andib(i8* %a) nounwind {
; CHECK-LABEL: andib:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.b (%a0), %d0
; CHECK-NEXT:    and.b #18, %d0
; CHECK-NEXT:    move.b %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i8, i8* %a
  %2 = and i8 %1, 18
  store i8 %2, i8* %a
  ret void
}

define void @andiw(i16* %a) nounwind {
; CHECK-LABEL: andiw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.w (%a0), %d0
; CHECK-NEXT:    and.w #4660, %d0
; CHECK-NEXT:    move.w %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i16, i16* %a
  %2 = and i16 %1, 4660
  store i16 %2, i16* %a
  ret void
}

define i32 @andil(i32 %a) nounwind {
; CHECK-LABEL: andil:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    and.l #305419896, %d0
; CHECK-NEXT:    rts
  %1 = and i32 %a, 305419896
  ret i32 %1
}

define void @orib(i8* %a) nounwind {
; CHECK-LABEL: orib:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.b (%a0), %d0
; CHECK-NEXT:    or.b #18, %d0
; CHECK-NEXT:    move.b %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i8, i8* %a
  %2 = or i8 %1, 18
  store i8 %2, i8* %a
  ret void
}

define void @oriw(i16* %a) nounwind {
; CHECK-LABEL: oriw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.w (%a0), %d0
; CHECK-NEXT:    or.w #4660, %d0
; CHECK-NEXT:    move.w %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i16, i16* %a
  %2 = or i16 %1, 4660
  store i16 %2, i16* %a
  ret void
}

define i32 @oril(i32 %a) nounwind {
; CHECK-LABEL: oril:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    or.l #305419896, %d0
; CHECK-NEXT:    rts
  %1 = or i32 %a, 305419896
  ret i32 %1
}

define void @eorib(i8* %a) nounwind {
; CHECK-LABEL: eorib:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.b (%a0), %d0
; CHECK-NEXT:    eori.b #18, %d0
; CHECK-NEXT:    move.b %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i8, i8* %a
  %2 = xor i8 %1, 18
  store i8 %2, i8* %a
  ret void
}

define void @eoriw(i16* %a) nounwind {
; CHECK-LABEL: eoriw:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %a0
; CHECK-NEXT:    move.w (%a0), %d0
; CHECK-NEXT:    eori.w #4660, %d0
; CHECK-NEXT:    move.w %d0, (%a0)
; CHECK-NEXT:    rts
  %1 = load i16, i16* %a
  %2 = xor i16 %1, 4660
  store i16 %2, i16* %a
  ret void
}

define i32 @eoril(i32 %a) nounwind {
; CHECK-LABEL: eoril:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    eori.l #305419896, %d0
; CHECK-NEXT:    rts
  %1 = xor i32 %a, 305419896
  ret i32 %1
}
