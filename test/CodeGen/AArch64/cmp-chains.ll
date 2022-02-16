; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

; Ensure chains of comparisons produce chains of `ccmp`

; (x0 < x1) && (x2 > x3)
define i32 @cmp_and2(i32 %0, i32 %1, i32 %2, i32 %3) {
; CHECK-LABEL: cmp_and2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #0, lo
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
  %5 = icmp ult i32 %0, %1
  %6 = icmp ugt i32 %2, %3
  %7 = select i1 %5, i1 %6, i1 false
  %8 = zext i1 %7 to i32
  ret i32 %8
}

; (x0 < x1) && (x2 > x3) && (x4 != x5)
define i32 @cmp_and3(i32 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5) {
; CHECK-LABEL: cmp_and3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #0, lo
; CHECK-NEXT:    ccmp w4, w5, #4, hi
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %7 = icmp ult i32 %0, %1
  %8 = icmp ugt i32 %2, %3
  %9 = select i1 %7, i1 %8, i1 false
  %10 = icmp ne i32 %4, %5
  %11 = select i1 %9, i1 %10, i1 false
  %12 = zext i1 %11 to i32
  ret i32 %12
}

; (x0 < x1) && (x2 > x3) && (x4 != x5) && (x6 == x7)
define i32 @cmp_and4(i32 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7) {
; CHECK-LABEL: cmp_and4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w2, w3
; CHECK-NEXT:    ccmp w0, w1, #2, hi
; CHECK-NEXT:    ccmp w4, w5, #4, lo
; CHECK-NEXT:    ccmp w6, w7, #0, ne
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %9 = icmp ugt i32 %2, %3
  %10 = icmp ult i32 %0, %1
  %11 = select i1 %9, i1 %10, i1 false
  %12 = icmp ne i32 %4, %5
  %13 = select i1 %11, i1 %12, i1 false
  %14 = icmp eq i32 %6, %7
  %15 = select i1 %13, i1 %14, i1 false
  %16 = zext i1 %15 to i32
  ret i32 %16
}

; (x0 < x1) || (x2 > x3)
define i32 @cmp_or2(i32 %0, i32 %1, i32 %2, i32 %3) {
; CHECK-LABEL: cmp_or2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #0, hs
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %5 = icmp ult i32 %0, %1
  %6 = icmp ne i32 %2, %3
  %7 = select i1 %5, i1 true, i1 %6
  %8 = zext i1 %7 to i32
  ret i32 %8
}

; (x0 < x1) || (x2 > x3) || (x4 != x5)
define i32 @cmp_or3(i32 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5) {
; CHECK-LABEL: cmp_or3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #2, hs
; CHECK-NEXT:    ccmp w4, w5, #0, ls
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %7 = icmp ult i32 %0, %1
  %8 = icmp ugt i32 %2, %3
  %9 = select i1 %7, i1 true, i1 %8
  %10 = icmp ne i32 %4, %5
  %11 = select i1 %9, i1 true, i1 %10
  %12 = zext i1 %11 to i32
 ret i32 %12
}

; (x0 < x1) || (x2 > x3) || (x4 != x5) || (x6 == x7)
define i32 @cmp_or4(i32 %0, i32 %1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7) {
; CHECK-LABEL: cmp_or4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    ccmp w2, w3, #2, hs
; CHECK-NEXT:    ccmp w4, w5, #0, ls
; CHECK-NEXT:    ccmp w6, w7, #4, eq
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %9 = icmp ult i32 %0, %1
  %10 = icmp ugt i32 %2, %3
  %11 = select i1 %9, i1 true, i1 %10
  %12 = icmp ne i32 %4, %5
  %13 = select i1 %11, i1 true, i1 %12
  %14 = icmp eq i32 %6, %7
  %15 = select i1 %13, i1 true, i1 %14
  %16 = zext i1 %15 to i32
  ret i32 %16
}

; (x0 != 0) || (x1 != 0)
define i32 @true_or2(i32 %0, i32 %1) {
; CHECK-LABEL: true_or2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w8, w0, w1
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %3 = icmp ne i32 %0, 0
  %4 = icmp ne i32 %1, 0
  %5 = select i1 %3, i1 true, i1 %4
  %6 = zext i1 %5 to i32
  ret i32 %6
}

; (x0 != 0) || (x1 != 0) || (x2 != 0)
define i32 @true_or3(i32 %0, i32 %1, i32 %2) {
; CHECK-LABEL: true_or3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w8, w0, w1
; CHECK-NEXT:    orr w8, w8, w2
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %4 = icmp ne i32 %0, 0
  %5 = icmp ne i32 %1, 0
  %6 = select i1 %4, i1 true, i1 %5
  %7 = icmp ne i32 %2, 0
  %8 = select i1 %6, i1 true, i1 %7
  %9 = zext i1 %8 to i32
  ret i32 %9
}
