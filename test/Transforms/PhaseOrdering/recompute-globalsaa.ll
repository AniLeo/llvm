; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='default<O2>' -S < %s | FileCheck %s
@a = internal global i32 0, align 4
@c = internal global i32** @b, align 8
@b = internal global i32* null, align 8
@e = internal global i32* @d, align 8
@d = internal global i32 0, align 4

define i32 @main() {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32*, i32** @e, align 8
; CHECK-NEXT:    store i32 0, i32* [[TMP0]], align 4
; CHECK-NEXT:    store i32* null, i32** @e, align 8
; CHECK-NEXT:    ret i32 0
;
entry:
  %h = alloca i32*, align 8
  %i = alloca i32*, align 8
  %j = alloca i32*, align 8
  %0 = bitcast i32** %h to i8*
  store i32* @a, i32** %h, align 8
  %1 = bitcast i32** %i to i8*
  %2 = bitcast i32** %j to i8*
  store i32* @a, i32** %j, align 8
  %3 = load i32*, i32** %j, align 8
  store i32 1, i32* %3, align 4
  store i32* @a, i32** %i, align 8
  %4 = load i32*, i32** %i, align 8
  %5 = load i32**, i32*** @c, align 8
  store i32* %4, i32** %5, align 8
  %6 = load i32*, i32** %h, align 8
  %call = call i32* @bar(i32* %6)
  %7 = bitcast i32** %j to i8*
  %8 = bitcast i32** %i to i8*
  %9 = bitcast i32** %h to i8*
  ret i32 0
}

define internal i32* @bar(i32* %g) {
entry:
  %g.addr = alloca i32*, align 8
  store i32* %g, i32** %g.addr, align 8
  %0 = load i32*, i32** @e, align 8
  store i32 0, i32* %0, align 4
  %1 = load i32*, i32** %g.addr, align 8
  %2 = load i32, i32* %1, align 4
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @foo()
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  store i32* null, i32** @e, align 8
  %3 = load i32*, i32** @b, align 8
  ret i32* %3
}

declare void @foo()

