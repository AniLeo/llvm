; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -verify -iroutliner < %s | FileCheck %s
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s -check-prefix=NOCOST

; This test checks that we have different results from when the cost model
; is on versus when it is off.  That is, if the number of instructions needed to
; handle the arguments is greater than the number of instructions being added,
; we do not outline.

define void @function1() #0 {
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]])
; CHECK-NEXT:    ret void
;
; NOCOST-LABEL: @function1(
; NOCOST-NEXT:  entry:
; NOCOST-NEXT:    [[A:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[B:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]])
; NOCOST-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  %mul = mul i32 %0, %1
  %sub = sub i32 %0, %1
  %div = sdiv i32 %0, %1
  %add1 = add i32 %0, %1
  %mul1 = mul i32 %0, %1
  %sub1 = sub i32 %0, %1
  %div1 = sdiv i32 %0, %1
  %add2 = add i32 %0, %1
  %mul2 = mul i32 %0, %1
  %sub2 = sub i32 %0, %1
  %div2 = sdiv i32 %0, %1
  ret void
}

define void @function2() #0 {
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]])
; CHECK-NEXT:    ret void
;
; NOCOST-LABEL: @function2(
; NOCOST-NEXT:  entry:
; NOCOST-NEXT:    [[A:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[B:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]])
; NOCOST-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  %mul = mul i32 %0, %1
  %sub = sub i32 %0, %1
  %div = sdiv i32 %0, %1
  %add1 = add i32 %0, %1
  %mul1 = mul i32 %0, %1
  %sub1 = sub i32 %0, %1
  %div1 = sdiv i32 %0, %1
  %add2 = add i32 %0, %1
  %mul2 = mul i32 %0, %1
  %sub2 = sub i32 %0, %1
  %div2 = sdiv i32 %0, %1
  ret void
}

define void @function3() #0 {
; CHECK-LABEL: @function3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 2, i32* [[A]], align 4
; CHECK-NEXT:    store i32 3, i32* [[B]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[OUTPUT]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[OUTPUT]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[OUTPUT]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[TMP2]], [[ADD]]
; CHECK-NEXT:    store i32 [[MUL]], i32* [[RESULT]], align 4
; CHECK-NEXT:    ret void
;
; NOCOST-LABEL: @function3(
; NOCOST-NEXT:  entry:
; NOCOST-NEXT:    [[DOTLOC:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[ADD_LOC:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[A:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[B:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[ADD_LOC]] to i8*
; NOCOST-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; NOCOST-NEXT:    [[LT_CAST1:%.*]] = bitcast i32* [[DOTLOC]] to i8*
; NOCOST-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST1]])
; NOCOST-NEXT:    call void @outlined_ir_func_1(i32* [[A]], i32* [[B]], i32* [[OUTPUT]], i32* [[ADD_LOC]], i32* [[DOTLOC]])
; NOCOST-NEXT:    [[ADD_RELOAD:%.*]] = load i32, i32* [[ADD_LOC]], align 4
; NOCOST-NEXT:    [[DOTRELOAD:%.*]] = load i32, i32* [[DOTLOC]], align 4
; NOCOST-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; NOCOST-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST1]])
; NOCOST-NEXT:    [[TMP0:%.*]] = load i32, i32* [[OUTPUT]], align 4
; NOCOST-NEXT:    call void @outlined_ir_func_2(i32 [[DOTRELOAD]], i32 [[ADD_RELOAD]], i32* [[RESULT]])
; NOCOST-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 2, i32* %a, align 4
  store i32 3, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  store i32 %add, i32* %output, align 4
  %2 = load i32, i32* %output, align 4
  %3 = load i32, i32* %output, align 4
  %mul = mul i32 %2, %add
  store i32 %mul, i32* %result, align 4
  ret void
}

define void @function4() #0 {
; CHECK-LABEL: @function4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 2, i32* [[A]], align 4
; CHECK-NEXT:    store i32 3, i32* [[B]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[B]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store i32 [[ADD]], i32* [[OUTPUT]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[OUTPUT]], align 4
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[TMP2]], [[ADD]]
; CHECK-NEXT:    store i32 [[MUL]], i32* [[RESULT]], align 4
; CHECK-NEXT:    ret void
;
; NOCOST-LABEL: @function4(
; NOCOST-NEXT:  entry:
; NOCOST-NEXT:    [[DOTLOC:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[ADD_LOC:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[A:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[B:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[OUTPUT:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[RESULT:%.*]] = alloca i32, align 4
; NOCOST-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[ADD_LOC]] to i8*
; NOCOST-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; NOCOST-NEXT:    [[LT_CAST1:%.*]] = bitcast i32* [[DOTLOC]] to i8*
; NOCOST-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST1]])
; NOCOST-NEXT:    call void @outlined_ir_func_1(i32* [[A]], i32* [[B]], i32* [[OUTPUT]], i32* [[ADD_LOC]], i32* [[DOTLOC]])
; NOCOST-NEXT:    [[ADD_RELOAD:%.*]] = load i32, i32* [[ADD_LOC]], align 4
; NOCOST-NEXT:    [[DOTRELOAD:%.*]] = load i32, i32* [[DOTLOC]], align 4
; NOCOST-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; NOCOST-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST1]])
; NOCOST-NEXT:    call void @outlined_ir_func_2(i32 [[DOTRELOAD]], i32 [[ADD_RELOAD]], i32* [[RESULT]])
; NOCOST-NEXT:    ret void
;
entry:
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %output = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 2, i32* %a, align 4
  store i32 3, i32* %b, align 4
  %0 = load i32, i32* %a, align 4
  %1 = load i32, i32* %b, align 4
  %add = add i32 %0, %1
  store i32 %add, i32* %output, align 4
  %2 = load i32, i32* %output, align 4
  %mul = mul i32 %2, %add
  store i32 %mul, i32* %result, align 4
  ret void
}
