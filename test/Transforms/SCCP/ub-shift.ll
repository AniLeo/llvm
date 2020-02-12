; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -sccp -S | FileCheck %s

define void @shift_undef_64(i64* %p) {
; CHECK-LABEL: @shift_undef_64(
; CHECK-NEXT:    [[R1:%.*]] = lshr i64 -1, 4294967296
; CHECK-NEXT:    store i64 [[R1]], i64* [[P:%.*]]
; CHECK-NEXT:    [[R2:%.*]] = ashr i64 -1, 4294967297
; CHECK-NEXT:    store i64 [[R2]], i64* [[P]]
; CHECK-NEXT:    [[R3:%.*]] = shl i64 -1, 4294967298
; CHECK-NEXT:    store i64 [[R3]], i64* [[P]]
; CHECK-NEXT:    ret void
;
  %r1 = lshr i64 -1, 4294967296 ; 2^32
  store i64 %r1, i64* %p

  %r2 = ashr i64 -1, 4294967297 ; 2^32 + 1
  store i64 %r2, i64* %p

  %r3 = shl i64 -1, 4294967298 ; 2^32 + 2
  store i64 %r3, i64* %p

  ret void
}

define void @shift_undef_65(i65* %p) {
; CHECK-LABEL: @shift_undef_65(
; CHECK-NEXT:    [[R1:%.*]] = lshr i65 2, -18446744073709551615
; CHECK-NEXT:    store i65 [[R1]], i65* [[P:%.*]]
; CHECK-NEXT:    [[R2:%.*]] = ashr i65 4, -18446744073709551615
; CHECK-NEXT:    store i65 [[R2]], i65* [[P]]
; CHECK-NEXT:    [[R3:%.*]] = shl i65 1, -18446744073709551615
; CHECK-NEXT:    store i65 [[R3]], i65* [[P]]
; CHECK-NEXT:    ret void
;
  %r1 = lshr i65 2, 18446744073709551617
  store i65 %r1, i65* %p

  %r2 = ashr i65 4, 18446744073709551617
  store i65 %r2, i65* %p

  %r3 = shl i65 1, 18446744073709551617
  store i65 %r3, i65* %p

  ret void
}

define void @shift_undef_256(i256* %p) {
; CHECK-LABEL: @shift_undef_256(
; CHECK-NEXT:    [[R1:%.*]] = lshr i256 2, 18446744073709551617
; CHECK-NEXT:    store i256 [[R1]], i256* [[P:%.*]]
; CHECK-NEXT:    [[R2:%.*]] = ashr i256 4, 18446744073709551618
; CHECK-NEXT:    store i256 [[R2]], i256* [[P]]
; CHECK-NEXT:    [[R3:%.*]] = shl i256 1, 18446744073709551619
; CHECK-NEXT:    store i256 [[R3]], i256* [[P]]
; CHECK-NEXT:    ret void
;
  %r1 = lshr i256 2, 18446744073709551617
  store i256 %r1, i256* %p

  %r2 = ashr i256 4, 18446744073709551618
  store i256 %r2, i256* %p

  %r3 = shl i256 1, 18446744073709551619
  store i256 %r3, i256* %p

  ret void
}

define void @shift_undef_511(i511* %p) {
; CHECK-LABEL: @shift_undef_511(
; CHECK-NEXT:    [[R1:%.*]] = lshr i511 -1, 1208925819614629174706276
; CHECK-NEXT:    store i511 [[R1]], i511* [[P:%.*]]
; CHECK-NEXT:    [[R2:%.*]] = ashr i511 -2, 1208925819614629174706200
; CHECK-NEXT:    store i511 [[R2]], i511* [[P]]
; CHECK-NEXT:    [[R3:%.*]] = shl i511 -3, 1208925819614629174706180
; CHECK-NEXT:    store i511 [[R3]], i511* [[P]]
; CHECK-NEXT:    ret void
;
  %r1 = lshr i511 -1, 1208925819614629174706276 ; 2^80 + 100
  store i511 %r1, i511* %p

  %r2 = ashr i511 -2, 1208925819614629174706200
  store i511 %r2, i511* %p

  %r3 = shl i511 -3, 1208925819614629174706180
  store i511 %r3, i511* %p

  ret void
}
