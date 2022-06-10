; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt < %s -passes='cgscc(coro-split),simplifycfg,early-cse,coro-cleanup' -S | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

define {i8*, i32*} @f(i8* %buffer, i32* %ptr) presplitcoroutine {
entry:
  %temp = alloca i32, align 4
  %id = call token @llvm.coro.id.retcon.once(i32 8, i32 8, i8* %buffer, i8* bitcast (void (i8*, i1)* @prototype to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  %oldvalue = load i32, i32* %ptr
  store i32 %oldvalue, i32* %temp
  %unwind = call i1 (...) @llvm.coro.suspend.retcon.i1(i32* %temp)
  br i1 %unwind, label %cleanup, label %cont

cont:
  %newvalue = load i32, i32* %temp
  store i32 %newvalue, i32* %ptr
  br label %cleanup

cleanup:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}



declare token @llvm.coro.id.retcon.once(i32, i32, i8*, i8*, i8*, i8*)
declare i8* @llvm.coro.begin(token, i8*)
declare i1 @llvm.coro.suspend.retcon.i1(...)
declare i1 @llvm.coro.end(i8*, i1)

declare void @prototype(i8*, i1 zeroext)

declare noalias i8* @allocate(i32 %size)
declare fastcc void @deallocate(i8* %ptr)

declare void @print(i32)
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i8* @allocate(i32 16)
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[BUFFER:%.*]] to i8**
; CHECK-NEXT:    store i8* [[TMP0]], i8** [[TMP1]], align 8
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = bitcast i8* [[TMP0]] to %f.Frame*
; CHECK-NEXT:    [[TEMP:%.*]] = getelementptr inbounds [[F_FRAME:%.*]], %f.Frame* [[FRAMEPTR]], i32 0, i32 1
; CHECK-NEXT:    [[PTR_SPILL_ADDR:%.*]] = getelementptr inbounds [[F_FRAME]], %f.Frame* [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    store i32* [[PTR:%.*]], i32** [[PTR_SPILL_ADDR]], align 8
; CHECK-NEXT:    [[OLDVALUE:%.*]] = load i32, i32* [[PTR]], align 4
; CHECK-NEXT:    store i32 [[OLDVALUE]], i32* [[TEMP]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { i8*, i32* } { i8* bitcast (void (i8*, i1)* @f.resume.0 to i8*), i32* undef }, i32* [[TEMP]], 1
; CHECK-NEXT:    ret { i8*, i32* } [[TMP2]]
;
;
; CHECK-LABEL: @f.resume.0(
; CHECK-NEXT:  entryresume.0:
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP0:%.*]] to %f.Frame**
; CHECK-NEXT:    [[FRAMEPTR:%.*]] = load %f.Frame*, %f.Frame** [[TMP2]], align 8
; CHECK-NEXT:    [[TEMP:%.*]] = getelementptr inbounds [[F_FRAME:%.*]], %f.Frame* [[FRAMEPTR]], i32 0, i32 1
; CHECK-NEXT:    br i1 [[TMP1:%.*]], label [[COROEND:%.*]], label [[CONT:%.*]]
; CHECK:       cont:
; CHECK-NEXT:    [[PTR_RELOAD_ADDR:%.*]] = getelementptr inbounds [[F_FRAME]], %f.Frame* [[FRAMEPTR]], i32 0, i32 0
; CHECK-NEXT:    [[PTR_RELOAD:%.*]] = load i32*, i32** [[PTR_RELOAD_ADDR]], align 8
; CHECK-NEXT:    [[NEWVALUE:%.*]] = load i32, i32* [[TEMP]], align 4
; CHECK-NEXT:    store i32 [[NEWVALUE]], i32* [[PTR_RELOAD]], align 4
; CHECK-NEXT:    br label [[COROEND]]
; CHECK:       CoroEnd:
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast %f.Frame* [[FRAMEPTR]] to i8*
; CHECK-NEXT:    call fastcc void @deallocate(i8* [[TMP3]])
; CHECK-NEXT:    ret void
;
