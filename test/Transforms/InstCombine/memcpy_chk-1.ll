; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test lib call simplification of __memcpy_chk calls with various values
; for dstlen and len.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

%struct.T1 = type { [100 x i32], [100 x i32], [1024 x i8] }
%struct.T2 = type { [100 x i32], [100 x i32], [1024 x i8] }
%struct.T3 = type { [100 x i32], [100 x i32], [2048 x i8] }

@t1 = common global %struct.T1 zeroinitializer
@t2 = common global %struct.T2 zeroinitializer
@t3 = common global %struct.T3 zeroinitializer

; Check cases where dstlen >= len.

define i8* @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T1* @t1 to i8*), i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T2* @t2 to i8*), i64 1824, i1 false)
; CHECK-NEXT:    ret i8* bitcast (%struct.T1* @t1 to i8*)
;
  %dst = bitcast %struct.T1* @t1 to i8*
  %src = bitcast %struct.T2* @t2 to i8*
  %ret = call i8* @__memcpy_chk(i8* %dst, i8* %src, i64 1824, i64 1824)
  ret i8* %ret
}

define i8* @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T1* @t1 to i8*), i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T3* @t3 to i8*), i64 1824, i1 false)
; CHECK-NEXT:    ret i8* bitcast (%struct.T1* @t1 to i8*)
;
  %dst = bitcast %struct.T1* @t1 to i8*
  %src = bitcast %struct.T3* @t3 to i8*
  %ret = call i8* @__memcpy_chk(i8* %dst, i8* %src, i64 1824, i64 2848)
  ret i8* %ret
}

; Check cases where dstlen < len.

define i8* @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @__memcpy_chk(i8* bitcast (%struct.T3* @t3 to i8*), i8* bitcast (%struct.T1* @t1 to i8*), i64 2848, i64 1824)
; CHECK-NEXT:    ret i8* [[RET]]
;
  %dst = bitcast %struct.T3* @t3 to i8*
  %src = bitcast %struct.T1* @t1 to i8*
  %ret = call i8* @__memcpy_chk(i8* %dst, i8* %src, i64 2848, i64 1824)
  ret i8* %ret
}

define i8* @test_no_simplify2() {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @__memcpy_chk(i8* bitcast (%struct.T1* @t1 to i8*), i8* bitcast (%struct.T2* @t2 to i8*), i64 1024, i64 0)
; CHECK-NEXT:    ret i8* [[RET]]
;
  %dst = bitcast %struct.T1* @t1 to i8*
  %src = bitcast %struct.T2* @t2 to i8*
  %ret = call i8* @__memcpy_chk(i8* %dst, i8* %src, i64 1024, i64 0)
  ret i8* %ret
}

define i8* @test_simplify_return_indcall(i8* ()* %alloc) {
; CHECK-LABEL: @test_simplify_return_indcall(
; CHECK-NEXT:    [[DST:%.*]] = call i8* [[ALLOC:%.*]]()
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(1824) [[DST]], i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T2* @t2 to i8*), i64 1824, i1 false)
; CHECK-NEXT:    ret i8* [[DST]]
;
  %src = bitcast %struct.T2* @t2 to i8*
  %dst = call i8* %alloc()
  %ret = call i8* @__memcpy_chk(i8* %dst, i8* %src, i64 1824, i64 1824)
  ret i8* %ret
}

define i8* @test_no_incompatible_attr(i8* %mem, i32 %val, i32 %size) {
; CHECK-LABEL: @test_no_incompatible_attr(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T1* @t1 to i8*), i8* nonnull align 4 dereferenceable(1824) bitcast (%struct.T2* @t2 to i8*), i64 1824, i1 false)
; CHECK-NEXT:    ret i8* bitcast (%struct.T1* @t1 to i8*)
;
  %dst = bitcast %struct.T1* @t1 to i8*
  %src = bitcast %struct.T2* @t2 to i8*
  %ret = call dereferenceable(1) i8* @__memcpy_chk(i8* %dst, i8* %src, i64 1824, i64 1824)
  ret i8* %ret
}

declare i8* @__memcpy_chk(i8*, i8*, i64, i64)
