; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=+sse2 -mtriple=i686-apple-darwin8 | FileCheck %s


define void @test() {
; CHECK-LABEL: test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subl $60, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [0,1,3,9]
; CHECK-NEXT:    movaps %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $7, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $6, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $5, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $4, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $3, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $2, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl $1, (%esp)
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [4,3,2,1]
; CHECK-NEXT:    movaps {{.*#+}} xmm1 = [8,7,6,5]
; CHECK-NEXT:    movaps {{.*#+}} xmm2 = [6,4,2,0]
; CHECK-NEXT:    movaps {{.*#+}} xmm3 = [8,4,2,1]
; CHECK-NEXT:    calll _xx
; CHECK-NEXT:    addl $60, %esp
; CHECK-NEXT:    retl
        tail call void @xx( i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, <2 x i64> bitcast (<4 x i32> < i32 4, i32 3, i32 2, i32 1 > to <2 x i64>), <2 x i64> bitcast (<4 x i32> < i32 8, i32 7, i32 6, i32 5 > to <2 x i64>), <2 x i64> bitcast (<4 x i32> < i32 6, i32 4, i32 2, i32 0 > to <2 x i64>), <2 x i64> bitcast (<4 x i32> < i32 8, i32 4, i32 2, i32 1 > to <2 x i64>), <2 x i64> bitcast (<4 x i32> < i32 0, i32 1, i32 3, i32 9 > to <2 x i64>) )
        ret void
}

declare void @xx(i32, i32, i32, i32, i32, i32, i32, <2 x i64>, <2 x i64>, <2 x i64>, <2 x i64>, <2 x i64>)

