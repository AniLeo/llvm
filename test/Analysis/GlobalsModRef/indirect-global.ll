; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -globals-aa -gvn -instcombine -S -enable-unsafe-globalsmodref-alias-results | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa,globals-aa -passes="require<globals-aa>,function(gvn,instcombine)" -S -enable-unsafe-globalsmodref-alias-results | FileCheck %s
;
; Note that this test relies on an unsafe feature of GlobalsModRef. While this
; test is correct and safe, GMR's technique for handling this isn't generally.

target datalayout = "p:32:32:32"

@G = internal global i32* null		; <i32**> [#uses=3]

declare noalias i8* @malloc(i32)
define void @malloc_init() {
; CHECK-LABEL: @malloc_init(
; CHECK-NEXT:    [[A:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i32 4)
; CHECK-NEXT:    store i8* [[A]], i8** bitcast (i32** @G to i8**), align 4
; CHECK-NEXT:    ret void
;
  %a = call i8* @malloc(i32 4)
  %A = bitcast i8* %a to i32*
  store i32* %A, i32** @G
  ret void
}

define i32 @malloc_test(i32* %P) {
; CHECK-LABEL: @malloc_test(
; CHECK-NEXT:    store i32 123, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 0
;
  %g1 = load i32*, i32** @G		; <i32*> [#uses=2]
  %h1 = load i32, i32* %g1		; <i32> [#uses=1]
  store i32 123, i32* %P
  %g2 = load i32*, i32** @G		; <i32*> [#uses=0]
  %h2 = load i32, i32* %g1		; <i32> [#uses=1]
  %X = sub i32 %h1, %h2		; <i32> [#uses=1]
  ret i32 %X
}

@G2 = internal global i32* null		; <i32**> [#uses=3]

declare noalias i8* @calloc(i32, i32)
define void @calloc_init() {
; CHECK-LABEL: @calloc_init(
; CHECK-NEXT:    [[A:%.*]] = call dereferenceable_or_null(4) i8* @calloc(i32 4, i32 1)
; CHECK-NEXT:    store i8* [[A]], i8** bitcast (i32** @G2 to i8**), align 4
; CHECK-NEXT:    ret void
;
  %a = call i8* @calloc(i32 4, i32 1)
  %A = bitcast i8* %a to i32*
  store i32* %A, i32** @G2
  ret void
}

define i32 @calloc_test(i32* %P) {
; CHECK-LABEL: @calloc_test(
; CHECK-NEXT:    store i32 123, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 0
;
  %g1 = load i32*, i32** @G2		; <i32*> [#uses=2]
  %h1 = load i32, i32* %g1		; <i32> [#uses=1]
  store i32 123, i32* %P
  %g2 = load i32*, i32** @G2		; <i32*> [#uses=0]
  %h2 = load i32, i32* %g1		; <i32> [#uses=1]
  %X = sub i32 %h1, %h2		; <i32> [#uses=1]
  ret i32 %X
}

@G3 = internal global i32* null		; <i32**> [#uses=3]

declare noalias i8* @my_alloc(i32)
define void @my_alloc_init() {
; CHECK-LABEL: @my_alloc_init(
; CHECK-NEXT:    [[A:%.*]] = call i8* @my_alloc(i32 4)
; CHECK-NEXT:    store i8* [[A]], i8** bitcast (i32** @G3 to i8**), align 4
; CHECK-NEXT:    ret void
;
  %a = call i8* @my_alloc(i32 4)
  %A = bitcast i8* %a to i32*
  store i32* %A, i32** @G3
  ret void
}

define i32 @my_alloc_test(i32* %P) {
; CHECK-LABEL: @my_alloc_test(
; CHECK-NEXT:    store i32 123, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret i32 0
;
  %g1 = load i32*, i32** @G3		; <i32*> [#uses=2]
  %h1 = load i32, i32* %g1		; <i32> [#uses=1]
  store i32 123, i32* %P
  %g2 = load i32*, i32** @G3		; <i32*> [#uses=0]
  %h2 = load i32, i32* %g1		; <i32> [#uses=1]
  %X = sub i32 %h1, %h2		; <i32> [#uses=1]
  ret i32 %X
}
