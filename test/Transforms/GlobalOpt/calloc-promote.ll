; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=globalopt -S < %s | FileCheck %s

@g = internal global i32* null, align 8

define signext i32 @f() local_unnamed_addr {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @g.body, i32 0, i32 0), i8 0, i64 4, i1 false)
; CHECK-NEXT:    store i16 -1, i16* bitcast ([4 x i8]* @g.body to i16*), align 2
; CHECK-NEXT:    ret i32 0
;
entry:
  %call = call i8* @calloc(i64 1, i64 4)
  %b = bitcast i8* %call to i32*
  store i32* %b, i32** @g, align 8
  %b2 = bitcast i8* %call to i16*
  store i16 -1, i16* %b2
  ret i32 0
}

define signext i32 @main() {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call signext i32 @f()
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    store i32 1, i32* bitcast ([4 x i8]* @g.body to i32*), align 4
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    store i8 2, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @g.body, i32 0, i32 0), align 4
; CHECK-NEXT:    call void @f1()
; CHECK-NEXT:    [[RES:%.*]] = load i32, i32* bitcast ([4 x i8]* @g.body to i32*), align 4
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %call = call signext i32 @f()
  call void @f1()
  %v0 = load i32*, i32** @g, align 8
  store i32 1, i32* %v0, align 4
  call void @f1()
  %v1 = load i8*, i8** bitcast (i32** @g to i8**), align 8
  store i8 2, i8* %v1, align 4
  call void @f1()
  %v2 = load i32*, i32** @g, align 8
  %res = load i32, i32* %v2, align 4
  ret i32 %res
}

declare noalias align 16 i8* @calloc(i64, i64) allockind("alloc,zeroed") allocsize(0,1)
declare void @f1()
