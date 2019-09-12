; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu | FileCheck %s --check-prefixes=AARCH

define { i128, i8 } @muloti_test(i128 %l, i128 %r) unnamed_addr #0 {
; AARCH-LABEL: muloti_test:
; AARCH:       // %bb.0: // %start
; AARCH-NEXT:    mul x8, x3, x0
; AARCH-NEXT:    umulh x9, x0, x2
; AARCH-NEXT:    madd x11, x1, x2, x8
; AARCH-NEXT:    add x8, x9, x11
; AARCH-NEXT:    cmp x8, x9
; AARCH-NEXT:    cset w9, lo
; AARCH-NEXT:    cmp x11, #0 // =0
; AARCH-NEXT:    csel w9, wzr, w9, eq
; AARCH-NEXT:    cmp x3, #0 // =0
; AARCH-NEXT:    umulh x10, x1, x2
; AARCH-NEXT:    cset w12, ne
; AARCH-NEXT:    cmp x1, #0 // =0
; AARCH-NEXT:    umulh x11, x3, x0
; AARCH-NEXT:    cset w13, ne
; AARCH-NEXT:    cmp xzr, x10
; AARCH-NEXT:    and w10, w13, w12
; AARCH-NEXT:    cset w12, ne
; AARCH-NEXT:    cmp xzr, x11
; AARCH-NEXT:    orr w10, w10, w12
; AARCH-NEXT:    cset w11, ne
; AARCH-NEXT:    orr w10, w10, w11
; AARCH-NEXT:    orr w9, w10, w9
; AARCH-NEXT:    mul x0, x0, x2
; AARCH-DAG:    mov x1, x8
; AARCH-DAG:    mov w2, w9
; AARCH-NEXT:    ret
start:
  %0 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %l, i128 %r) #2
  %1 = extractvalue { i128, i1 } %0, 0
  %2 = extractvalue { i128, i1 } %0, 1
  %3 = zext i1 %2 to i8
  %4 = insertvalue { i128, i8 } undef, i128 %1, 0
  %5 = insertvalue { i128, i8 } %4, i8 %3, 1
  ret { i128, i8 } %5
}

; Function Attrs: nounwind readnone speculatable
declare { i128, i1 } @llvm.umul.with.overflow.i128(i128, i128) #1

attributes #0 = { nounwind readnone uwtable }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
