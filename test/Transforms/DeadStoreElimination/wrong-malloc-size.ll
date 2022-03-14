; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -dse < %s | FileCheck %s

; malloc should have i64 argument under default data layout
declare noalias i8* @malloc(i32)

define i8* @malloc_and_memset_intrinsic(i32 %n) {
; CHECK-LABEL: @malloc_and_memset_intrinsic(
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @malloc(i32 [[N:%.*]])
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* align 1 [[CALL]], i8 0, i32 [[N]], i1 false)
; CHECK-NEXT:    ret i8* [[CALL]]
;
  %call = call i8* @malloc(i32 %n)
  call void @llvm.memset.p0i8.i32(i8* align 1 %call, i8 0, i32 %n, i1 false)
  ret i8* %call
}

declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg) #2
