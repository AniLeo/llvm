; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O3 -S < %s | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.6.7"

declare i8* @malloc(i64)
declare void @free(i8*)

; PR2338
define void @test1() nounwind ssp {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret void
;
  %retval = alloca i32, align 4
  %i = alloca i8*, align 8
  %call = call i8* @malloc(i64 1)
  store i8* %call, i8** %i, align 8
  %tmp = load i8*, i8** %i, align 8
  store i8 1, i8* %tmp
  %tmp1 = load i8*, i8** %i, align 8
  call void @free(i8* %tmp1)
  ret void

}

; This function exposes a phase ordering problem when InstCombine is
; turning %add into a bitmask, making it difficult to spot a 0 return value.
;
; It it also important that %add is expressed as a multiple of %div so scalar
; evolution can recognize it.
define i32 @test2(i32 %a, i32* %p) nounwind uwtable ssp {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DIV1:%.*]] = lshr i32 [[A:%.*]], 2
; CHECK-NEXT:    store i32 [[DIV1]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = shl nuw nsw i32 [[DIV1]], 1
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    store i32 [[ADD]], i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret i32 0
;
entry:
  %div = udiv i32 %a, 4
  %arrayidx = getelementptr inbounds i32, i32* %p, i64 0
  store i32 %div, i32* %arrayidx, align 4
  %add = add i32 %div, %div
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 1
  store i32 %add, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, i32* %p, i64 1
  %0 = load i32, i32* %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds i32, i32* %p, i64 0
  %1 = load i32, i32* %arrayidx3, align 4
  %mul = mul i32 2, %1
  %sub = sub i32 %0, %mul
  ret i32 %sub

}
