; RUN: llc < %s -mtriple=ve-unknown-unknown | FileCheck %s

declare i128 @llvm.ctlz.i128(i128, i1)
declare i64 @llvm.ctlz.i64(i64, i1)
declare i32 @llvm.ctlz.i32(i32, i1)
declare i16 @llvm.ctlz.i16(i16, i1)
declare i8 @llvm.ctlz.i8(i8, i1)

define i128 @func128(i128 %p){
; CHECK-LABEL: func128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmps.l %s2, %s1, (0)1
; CHECK-NEXT:    ldz %s1, %s1
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, 64(, %s0)
; CHECK-NEXT:    cmov.l.ne %s0, %s1, %s2
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i128 @llvm.ctlz.i128(i128 %p, i1 true)
  ret i128 %r
}

define i64 @func64(i64 %p) {
; CHECK-LABEL: func64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i64 @llvm.ctlz.i64(i64 %p, i1 true)
  ret i64 %r
}

define signext i32 @func32s(i32 signext %p) {
; CHECK-LABEL: func32s:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 %p, i1 true)
  ret i32 %r
}

define zeroext i32 @func32z(i32 zeroext %p) {
; CHECK-LABEL: func32z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 %p, i1 true)
  ret i32 %r
}

define signext i16 @func16s(i16 signext %p) {
; CHECK-LABEL: func16s:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -16, %s0
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 %p, i1 true)
  ret i16 %r
}

define zeroext i16 @func16z(i16 zeroext %p) {
; CHECK-LABEL: func16z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -16, %s0
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 %p, i1 true)
  ret i16 %r
}

define signext i8 @func8s(i8 signext %p) {
; CHECK-LABEL: func8s:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -24, %s0
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 %p, i1 true)
  ret i8 %r
}

define zeroext i8 @func8z(i8 zeroext %p) {
; CHECK-LABEL: func8z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -24, %s0
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 %p, i1 true)
  ret i8 %r
}

define i128 @func128i(){
; CHECK-LABEL: func128i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s0, 112
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i128 @llvm.ctlz.i128(i128 65535, i1 true)
  ret i128 %r
}

define i64 @func64i() {
; CHECK-LABEL: func64i:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 48, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i64 @llvm.ctlz.i64(i64 65535, i1 true)
  ret i64 %r
}

define signext i32 @func32is() {
; CHECK-LABEL: func32is:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 16, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 65535, i1 true)
  ret i32 %r
}

define zeroext i32 @func32iz() {
; CHECK-LABEL: func32iz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 16, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 65535, i1 true)
  ret i32 %r
}

define signext i16 @func16is() {
; CHECK-LABEL: func16is:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 8, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 255, i1 true)
  ret i16 %r
}

define zeroext i16 @func16iz() {
; CHECK-LABEL: func16iz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 8, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 255, i1 true)
  ret i16 %r
}

define signext i8 @func8is() {
; CHECK-LABEL: func8is:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 255, i1 true)
  ret i8 %r
}

define zeroext i8 @func8iz() {
; CHECK-LABEL: func8iz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 255, i1 true)
  ret i8 %r
}

define i128 @func128x(i128 %p){
; CHECK-LABEL: func128x:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmps.l %s2, %s1, (0)1
; CHECK-NEXT:    ldz %s1, %s1
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, 64(, %s0)
; CHECK-NEXT:    cmov.l.ne %s0, %s1, %s2
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i128 @llvm.ctlz.i128(i128 %p, i1 false)
  ret i128 %r
}

define i64 @func64x(i64 %p) {
; CHECK-LABEL: func64x:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i64 @llvm.ctlz.i64(i64 %p, i1 false)
  ret i64 %r
}

define signext i32 @func32sx(i32 signext %p) {
; CHECK-LABEL: func32sx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 %p, i1 false)
  ret i32 %r
}

define zeroext i32 @func32zx(i32 zeroext %p) {
; CHECK-LABEL: func32zx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i32 @llvm.ctlz.i32(i32 %p, i1 false)
  ret i32 %r
}

define signext i16 @func16sx(i16 signext %p) {
; CHECK-LABEL: func16sx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -16, %s0
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 %p, i1 false)
  ret i16 %r
}

define zeroext i16 @func16zx(i16 zeroext %p) {
; CHECK-LABEL: func16zx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -16, %s0
; CHECK-NEXT:    and %s0, %s0, (48)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i16 @llvm.ctlz.i16(i16 %p, i1 false)
  ret i16 %r
}

define signext i8 @func8sx(i8 signext %p) {
; CHECK-LABEL: func8sx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -24, %s0
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 %p, i1 false)
  ret i8 %r
}

define zeroext i8 @func8zx(i8 zeroext %p) {
; CHECK-LABEL: func8zx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ldz %s0, %s0
; CHECK-NEXT:    lea %s0, -32(, %s0)
; CHECK-NEXT:    adds.w.sx %s0, -24, %s0
; CHECK-NEXT:    and %s0, %s0, (56)0
; CHECK-NEXT:    b.l.t (, %s10)
  %r = tail call i8 @llvm.ctlz.i8(i8 %p, i1 false)
  ret i8 %r
}
