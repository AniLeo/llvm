; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-linux-gnu | FileCheck %s
; RUN: llc < %s -global-isel -mtriple=arm64-linux-gnu | FileCheck %s --check-prefix=GISEL

@x1 = external hidden global [2 x i64]
@x2 = external hidden global [16777216 x i64]
@x3 = external hidden global { [9 x i8*], [8 x i8*] }

define i64 @f1() {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x1+16
; CHECK-NEXT:    ldr x0, [x8, :lo12:x1+16]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x8, x1+16
; GISEL-NEXT:    ldr x0, [x8, :lo12:x1+16]
; GISEL-NEXT:    ret
  %l = load i64, i64* getelementptr ([2 x i64], [2 x i64]* @x1, i64 0, i64 2)
  ret i64 %l
}

define i64 @f2() {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x1
; CHECK-NEXT:    add x8, x8, :lo12:x1
; CHECK-NEXT:    ldr x0, [x8, #24]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f2:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x8, x1
; GISEL-NEXT:    add x8, x8, :lo12:x1
; GISEL-NEXT:    ldr x0, [x8, #24]
; GISEL-NEXT:    ret

  %l = load i64, i64* getelementptr ([2 x i64], [2 x i64]* @x1, i64 0, i64 3)
  ret i64 %l
}

define i64 @f3() {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x1+1
; CHECK-NEXT:    add x8, x8, :lo12:x1+1
; CHECK-NEXT:    ldr x0, [x8]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f3:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x8, x1+1
; GISEL-NEXT:    add x8, x8, :lo12:x1+1
; GISEL-NEXT:    ldr x0, [x8]
; GISEL-NEXT:    ret
  %l = load i64, i64* bitcast (i8* getelementptr (i8, i8* bitcast ([2 x i64]* @x1 to i8*), i64 1) to i64*)
  ret i64 %l
}

define [2 x i64] @f4() {
; FIXME: GlobalISel misses the opportunity to form a LDP here.
;
; CHECK-LABEL: f4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x2+8
; CHECK-NEXT:    add x8, x8, :lo12:x2+8
; CHECK-NEXT:    ldp x0, x1, [x8]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f4:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x9, x2+8
; GISEL-NEXT:    adrp x8, x2+8
; GISEL-NEXT:    add x9, x9, :lo12:x2+8
; GISEL-NEXT:    ldr x0, [x8, :lo12:x2+8]
; GISEL-NEXT:    ldr x1, [x9, #8]
; GISEL-NEXT:    ret
  %l = load [2 x i64], [2 x i64]* bitcast (i8* getelementptr (i8, i8* bitcast ([16777216 x i64]* @x2 to i8*), i64 8) to [2 x i64]*)
  ret [2 x i64] %l
}

define i64 @f5() {
; CHECK-LABEL: f5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x2+2097144
; CHECK-NEXT:    ldr x0, [x8, :lo12:x2+2097144]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f5:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x8, x2+2097144
; GISEL-NEXT:    ldr x0, [x8, :lo12:x2+2097144]
; GISEL-NEXT:    ret
  %l = load i64, i64* getelementptr ([16777216 x i64], [16777216 x i64]* @x2, i64 0, i64 262143)
  ret i64 %l
}

define i64 @f6() {
; CHECK-LABEL: f6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, x2
; CHECK-NEXT:    add x8, x8, :lo12:x2
; CHECK-NEXT:    mov w9, #2097152
; CHECK-NEXT:    ldr x0, [x8, x9]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f6:
; GISEL:       // %bb.0:
; GISEL-NEXT:    adrp x9, x2
; GISEL-NEXT:    mov w8, #2097152
; GISEL-NEXT:    add x9, x9, :lo12:x2
; GISEL-NEXT:    ldr x0, [x9, x8]
; GISEL-NEXT:    ret
  %l = load i64, i64* getelementptr ([16777216 x i64], [16777216 x i64]* @x2, i64 0, i64 262144)
  ret i64 %l
}

define i32 @f7() {
; FIXME: GlobalISel doesn't handle vectors well.
;
; CHECK-LABEL: f7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adrp x8, x3+108
; CHECK-NEXT:    ldr w0, [x8, :lo12:x3+108]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: f7:
; GISEL:       // %bb.0: // %entry
; GISEL-NEXT:    adrp x8, x3+88
; GISEL-NEXT:    add x8, x8, :lo12:x3+88
; GISEL-NEXT:    mov v0.d[1], x8
; GISEL-NEXT:    mov d0, v0.d[1]
; GISEL-NEXT:    fmov x8, d0
; GISEL-NEXT:    ldr w0, [x8, #20]
; GISEL-NEXT:    ret

entry:
  %l = load i32, i32* getelementptr (i32, i32* inttoptr (i64 trunc (i128 lshr (i128 bitcast (<2 x i64> <i64 undef, i64 ptrtoint (i8** getelementptr inbounds ({ [9 x i8*], [8 x i8*] }, { [9 x i8*], [8 x i8*] }* @x3, i64 0, inrange i32 1, i64 2) to i64)> to i128), i128 64) to i64) to i32*), i64 5)
  ret i32 %l
}
