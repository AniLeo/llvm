; RUN: llc < %s -march=arm

define i32 @test(i32 %a1) {
        ret i32 %a1
}
