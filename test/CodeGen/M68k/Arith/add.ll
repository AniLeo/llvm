; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux -verify-machineinstrs | FileCheck %s

define i64 @test1(i64 %A, i32 %B) nounwind {
; CHECK-LABEL: test1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l (12,%sp), %d0
; CHECK-NEXT:    add.l (4,%sp), %d0
; CHECK-NEXT:    move.l (8,%sp), %d1
; CHECK-NEXT:    rts
  %tmp12 = zext i32 %B to i64
  %tmp3 = shl i64 %tmp12, 32
  %tmp5 = add i64 %tmp3, %A
  ret i64 %tmp5
}

define void @test2(i32* inreg %a) nounwind {
; CHECK-LABEL: test2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.l %d0, %a0
; CHECK-NEXT:    add.l #128, (%a0)
; CHECK-NEXT:    rts
  %aa = load i32, i32* %a
  %b = add i32 %aa, 128
  store i32 %b, i32* %a
  ret void
}

define fastcc void @test2_fast(i32* inreg %a) nounwind {
; CHECK-LABEL: test2_fast:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add.l #128, (%a0)
; CHECK-NEXT:    rts
  %aa = load i32, i32* %a
  %b = add i32 %aa, 128
  store i32 %b, i32* %a
  ret void
}

define fastcc void @test3(i64* inreg %a) nounwind {
; CHECK-LABEL: test3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    suba.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.l (%a0), %d0
; CHECK-NEXT:    move.l #0, %d1
; CHECK-NEXT:    move.l #-2147483648, %d2
; CHECK-NEXT:    add.l (4,%a0), %d2
; CHECK-NEXT:    addx.l %d0, %d1
; CHECK-NEXT:    move.l %d2, (4,%a0)
; CHECK-NEXT:    move.l %d1, (%a0)
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    adda.l #4, %sp
; CHECK-NEXT:    rts
  %aa = load i64, i64* %a
  %b = add i64 %aa, 2147483648
  store i64 %b, i64* %a
  ret void
}

define fastcc void @test4(i64* inreg %a) nounwind {
; CHECK-LABEL: test4:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    suba.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.l (%a0), %d0
; CHECK-NEXT:    move.l #0, %d1
; CHECK-NEXT:    move.l #128, %d2
; CHECK-NEXT:    add.l (4,%a0), %d2
; CHECK-NEXT:    addx.l %d0, %d1
; CHECK-NEXT:    move.l %d2, (4,%a0)
; CHECK-NEXT:    move.l %d1, (%a0)
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    adda.l #4, %sp
; CHECK-NEXT:    rts
  %aa = load i64, i64* %a
  %b = add i64 %aa, 128
  store i64 %b, i64* %a
  ret void
}

define fastcc i32 @test9(i32 %x, i32 %y) nounwind readnone {
; CHECK-LABEL: test9:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub.l #10, %d0
; CHECK-NEXT:    seq %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    sub.l %d0, %d1
; CHECK-NEXT:    move.l %d1, %d0
; CHECK-NEXT:    rts
  %cmp = icmp eq i32 %x, 10
  %sub = sext i1 %cmp to i32
  %cond = add i32 %sub, %y
  ret i32 %cond
}
