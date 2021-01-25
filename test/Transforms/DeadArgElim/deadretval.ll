; RUN: opt < %s -deadargelim -S | FileCheck %s

@g0 = global i8 0, align 8

; CHECK-NOT: DEAD

; Dead arg only used by dead retval
define internal i32 @test(i32 %DEADARG) {
        ret i32 %DEADARG
}

define i32 @test2(i32 %A) {
        %DEAD = call i32 @test( i32 %A )                ; <i32> [#uses=0]
        ret i32 123
}

define i32 @test3() {
        %X = call i32 @test2( i32 3232 )                ; <i32> [#uses=1]
        %Y = add i32 %X, -123           ; <i32> [#uses=1]
        ret i32 %Y
}

; The callee function's return type shouldn't be changed if there is a call
; annotated with "clang.arc.rv"="retain" or "clang.arc.rv"="claim".

; CHECK-LABEL: define internal i8* @callee4()

define internal i8* @callee4(i8* %a0) {
  ret i8* @g0;
}

; CHECK-LABEL: define i8* @test4(
; CHECK: tail call "clang.arc.rv"="retain" i8* @callee4()

define i8* @test4() {
  %call = tail call "clang.arc.rv"="retain" i8* @callee4(i8* @g0)
  ret i8* @g0
}
