; RUN: llc < %s -march=thumb -mattr=+thumb2 | grep ldrb | count 1
; RUN: llc < %s -march=thumb -mattr=+thumb2 | grep ldrh | count 1
; RUN: llc < %s -march=thumb -mattr=+thumb2 | grep ldrsb | count 1
; RUN: llc < %s -march=thumb -mattr=+thumb2 | grep ldrsh | count 1

define i32 @test1(i8* %v.pntr.s0.u1) {
    %tmp.u = load i8* %v.pntr.s0.u1
    %tmp1.s = zext i8 %tmp.u to i32
    ret i32 %tmp1.s
}

define i32 @test2(i16* %v.pntr.s0.u1) {
    %tmp.u = load i16* %v.pntr.s0.u1
    %tmp1.s = zext i16 %tmp.u to i32
    ret i32 %tmp1.s
}

define i32 @test3(i8* %v.pntr.s1.u0) {
    %tmp.s = load i8* %v.pntr.s1.u0
    %tmp1.s = sext i8 %tmp.s to i32
    ret i32 %tmp1.s
}

define i32 @test4() {
    %tmp.s = load i16* null
    %tmp1.s = sext i16 %tmp.s to i32
    ret i32 %tmp1.s
}
