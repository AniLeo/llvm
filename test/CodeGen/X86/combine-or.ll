; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7 | FileCheck %s

define i32 @or_self(i32 %x) {
; CHECK-LABEL: or_self:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %or = or i32 %x, %x
  ret i32 %or
}

define <4 x i32> @or_self_vec(<4 x i32> %x) {
; CHECK-LABEL: or_self_vec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %or = or <4 x i32> %x, %x
  ret <4 x i32> %or
}

; Verify that each of the following test cases is folded into a single
; instruction which performs a blend operation.

define <2 x i64> @test1(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 1>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test2(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test3(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 1>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test4(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 1, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test5(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 1, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test6(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test7(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; CHECK-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 -1, i32 -1, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 0, i32 -1, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <2 x i64> @test8(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; CHECK-NEXT:    retq
  %and1 = and <2 x i64> %a, <i64 -1, i64 0>
  %and2 = and <2 x i64> %b, <i64 0, i64 -1>
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}


define <4 x i32> @test9(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 0, i32 0, i32 -1, i32 -1>
  %and2 = and <4 x i32> %b, <i32 -1, i32 -1, i32 0, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <2 x i64> @test10(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %and1 = and <2 x i64> %a, <i64 0, i64 -1>
  %and2 = and <2 x i64> %b, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  ret <2 x i64> %or
}


define <4 x i32> @test11(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm0[0],xmm1[1,2,3]
; CHECK-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 -1, i32 0, i32 0, i32 0>
  %and2 = and <4 x i32> %b, <i32 0, i32 -1, i32 -1, i32 -1>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


define <4 x i32> @test12(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2,3]
; CHECK-NEXT:    retq
  %and1 = and <4 x i32> %a, <i32 0, i32 -1, i32 -1, i32 -1>
  %and2 = and <4 x i32> %b, <i32 -1, i32 0, i32 0, i32 0>
  %or = or <4 x i32> %and1, %and2
  ret <4 x i32> %or
}


; Verify that the following test cases are folded into single shuffles.

define <4 x i32> @test13(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1],xmm1[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 1, i32 1, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test14(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <4 x i32> @test15(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,1],xmm0[2,1]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 1>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 2, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test16(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


; Verify that the dag-combiner does not fold a OR of two shuffles into a single
; shuffle instruction when the shuffle indexes are not compatible.

define <4 x i32> @test17(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test17:
; CHECK:       # %bb.0:
; CHECK-NEXT:    psllq $32, %xmm0
; CHECK-NEXT:    movq {{.*#+}} xmm1 = xmm1[0],zero
; CHECK-NEXT:    por %xmm1, %xmm0
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 2>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test18(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test18:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pxor %xmm2, %xmm2
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3,4,5,6,7]
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,0,1,1]
; CHECK-NEXT:    pblendw {{.*#+}} xmm2 = xmm1[0,1],xmm2[2,3,4,5,6,7]
; CHECK-NEXT:    por %xmm0, %xmm2
; CHECK-NEXT:    movdqa %xmm2, %xmm0
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 4>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test19(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test19:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[0,0,2,3]
; CHECK-NEXT:    pxor %xmm3, %xmm3
; CHECK-NEXT:    pblendw {{.*#+}} xmm2 = xmm3[0,1],xmm2[2,3],xmm3[4,5],xmm2[6,7]
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[0,1,2,2]
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm3[2,3],xmm0[4,5,6,7]
; CHECK-NEXT:    por %xmm2, %xmm0
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 0, i32 4, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 4, i32 2, i32 2>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <2 x i64> @test20(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test20:
; CHECK:       # %bb.0:
; CHECK-NEXT:    por %xmm1, %xmm0
; CHECK-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 0, i32 2>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


define <2 x i64> @test21(<2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: test21:
; CHECK:       # %bb.0:
; CHECK-NEXT:    por %xmm1, %xmm0
; CHECK-NEXT:    pslldq {{.*#+}} xmm0 = zero,zero,zero,zero,zero,zero,zero,zero,xmm0[0,1,2,3,4,5,6,7]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <2 x i64> %a, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %shuf2 = shufflevector <2 x i64> %b, <2 x i64> zeroinitializer, <2 x i32><i32 2, i32 0>
  %or = or <2 x i64> %shuf1, %shuf2
  ret <2 x i64> %or
}


; Verify that the dag-combiner keeps the correct domain for float/double vectors
; bitcast to use the mask-or blend combine.

define <2 x double> @test22(<2 x double> %a0, <2 x double> %a1) {
; CHECK-LABEL: test22:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %bc1 = bitcast <2 x double> %a0 to <2 x i64>
  %bc2 = bitcast <2 x double> %a1 to <2 x i64>
  %and1 = and <2 x i64> %bc1, <i64 0, i64 -1>
  %and2 = and <2 x i64> %bc2, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  %bc3 = bitcast <2 x i64> %or to <2 x double>
  ret <2 x double> %bc3
}


define <4 x float> @test23(<4 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test23:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0],xmm0[1,2],xmm1[3]
; CHECK-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <4 x i32>
  %bc2 = bitcast <4 x float> %a1 to <4 x i32>
  %and1 = and <4 x i32> %bc1, <i32 0, i32 -1, i32 -1, i32 0>
  %and2 = and <4 x i32> %bc2, <i32 -1, i32 0, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  %bc3 = bitcast <4 x i32> %or to <4 x float>
  ret <4 x float> %bc3
}


define <4 x float> @test24(<4 x float> %a0, <4 x float> %a1) {
; CHECK-LABEL: test24:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <2 x i64>
  %bc2 = bitcast <4 x float> %a1 to <2 x i64>
  %and1 = and <2 x i64> %bc1, <i64 0, i64 -1>
  %and2 = and <2 x i64> %bc2, <i64 -1, i64 0>
  %or = or <2 x i64> %and1, %and2
  %bc3 = bitcast <2 x i64> %or to <4 x float>
  ret <4 x float> %bc3
}


define <4 x float> @test25(<4 x float> %a0) {
; CHECK-LABEL: test25:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = mem[0],xmm0[1,2],mem[3]
; CHECK-NEXT:    retq
  %bc1 = bitcast <4 x float> %a0 to <4 x i32>
  %bc2 = bitcast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0> to <4 x i32>
  %and1 = and <4 x i32> %bc1, <i32 0, i32 -1, i32 -1, i32 0>
  %and2 = and <4 x i32> %bc2, <i32 -1, i32 0, i32 0, i32 -1>
  %or = or <4 x i32> %and1, %and2
  %bc3 = bitcast <4 x i32> %or to <4 x float>
  ret <4 x float> %bc3
}


; Verify that the DAGCombiner doesn't crash in the attempt to check if a shuffle
; with illegal type has a legal mask. Method 'isShuffleMaskLegal' only knows how to
; handle legal vector value types.
define <4 x i8> @test_crash(<4 x i8> %a, <4 x i8> %b) {
; CHECK-LABEL: test_crash:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pblendw {{.*#+}} xmm0 = xmm1[0],xmm0[1],xmm1[2,3,4,5,6,7]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i8> %a, <4 x i8> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i8> %b, <4 x i8> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i8> %shuf1, %shuf2
  ret <4 x i8> %or
}

; Verify that we can fold regardless of which operand is the zeroinitializer

define <4 x i32> @test2b(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %a, <4 x i32><i32 0, i32 0, i32 6, i32 7>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> zeroinitializer, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

define <4 x i32> @test2c(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2c:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %a, <4 x i32><i32 0, i32 0, i32 6, i32 7>
  %shuf2 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %b, <4 x i32><i32 4, i32 5, i32 0, i32 0>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}


define <4 x i32> @test2d(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2d:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> zeroinitializer, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> zeroinitializer, <4 x i32> %b, <4 x i32><i32 4, i32 5, i32 0, i32 0>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

; Make sure we can have an undef where an index pointing to the zero vector should be

define <4 x i32> @test2e(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2e:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 undef, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 0, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

define <4 x i32> @test2f(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: test2f:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blendps {{.*#+}} xmm0 = xmm1[0,1],xmm0[2,3]
; CHECK-NEXT:    retq
  %shuf1 = shufflevector <4 x i32> %a, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 4, i32 4, i32 2, i32 3>
  %shuf2 = shufflevector <4 x i32> %b, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>, <4 x i32><i32 undef, i32 1, i32 4, i32 4>
  %or = or <4 x i32> %shuf1, %shuf2
  ret <4 x i32> %or
}

; (or (and X, c1), c2) -> (and (or X, c2), c1|c2) iff (c1 & c2) != 0

define <2 x i64> @or_and_v2i64(<2 x i64> %a0) {
; CHECK-LABEL: or_and_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %1 = and <2 x i64> %a0, <i64 7, i64 7>
  %2 = or <2 x i64> %1, <i64 3, i64 3>
  ret <2 x i64> %2
}

define <4 x i32> @or_and_v4i32(<4 x i32> %a0) {
; CHECK-LABEL: or_and_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    orps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 1, i32 3, i32 5, i32 7>
  %2 = or <4 x i32> %1, <i32 3, i32 2, i32 15, i32 2>
  ret <4 x i32> %2
}

; If all masked bits are going to be set, that's a constant fold.

define <4 x i32> @or_and_v4i32_fold(<4 x i32> %a0) {
; CHECK-LABEL: or_and_v4i32_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [3,3,3,3]
; CHECK-NEXT:    retq
  %1 = and <4 x i32> %a0, <i32 1, i32 1, i32 1, i32 1>
  %2 = or <4 x i32> %1, <i32 3, i32 3, i32 3, i32 3>
  ret <4 x i32> %2
}

; fold (or x, c) -> c iff (x & ~c) == 0

define <2 x i64> @or_zext_v2i32(<2 x i32> %a0) {
; CHECK-LABEL: or_zext_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [4294967295,4294967295]
; CHECK-NEXT:    retq
  %1 = zext <2 x i32> %a0 to <2 x i64>
  %2 = or <2 x i64> %1, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %2
}

define <4 x i32> @or_zext_v4i16(<4 x i16> %a0) {
; CHECK-LABEL: or_zext_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movaps {{.*#+}} xmm0 = [65535,65535,65535,65535]
; CHECK-NEXT:    retq
  %1 = zext <4 x i16> %a0 to <4 x i32>
  %2 = or <4 x i32> %1, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %2
}

; FIXME: fold (or (and X, C1), (and (or X, Y), C2)) -> (or (and X, C1|C2), (and Y, C2))

define i32 @or_and_and_i32(i32 %x, i32 %y) {
; CHECK-LABEL: or_and_and_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    orl %edi, %esi
; CHECK-NEXT:    andl $8, %edi
; CHECK-NEXT:    andl $-11, %esi
; CHECK-NEXT:    leal (%rsi,%rdi), %eax
; CHECK-NEXT:    retq
  %xy = or i32 %x, %y
  %mx = and i32 %x, 8
  %mxy = and i32 %xy, -11
  %r = or i32 %mx, %mxy
  ret i32 %r
}

define i64 @or_and_and_commute_i64(i64 %x, i64 %y) {
; CHECK-LABEL: or_and_and_commute_i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    andl $8, %edi
; CHECK-NEXT:    andq $-3, %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    retq
  %xy = or i64 %x, %y
  %mx = and i64 %x, 8
  %mxy = and i64 %xy, -3
  %r = or i64 %mxy, %mx
  ret i64 %r
}

define <4 x i32> @or_and_and_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: or_and_and_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    orps %xmm0, %xmm1
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-NEXT:    orps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %xy = or <4 x i32> %x, %y
  %mx = and <4 x i32> %x, <i32 2, i32 4, i32 8, i32 16>
  %mxy = and <4 x i32> %xy, <i32 1, i32 -1, i32 -5, i32 -25>
  %r = or <4 x i32> %mx, %mxy
  ret <4 x i32> %r
}

define i32 @or_and_and_multiuse_i32(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: or_and_and_multiuse_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    orl %edi, %esi
; CHECK-NEXT:    andl $8, %edi
; CHECK-NEXT:    andl $-11, %esi
; CHECK-NEXT:    leal (%rdi,%rsi), %ebx
; CHECK-NEXT:    movl %esi, %edi
; CHECK-NEXT:    callq use_i32@PLT
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %xy = or i32 %x, %y
  %mx = and i32 %x, 8
  %mxy = and i32 %xy, -11
  %r = or i32 %mx, %mxy
  call void @use_i32(i32 %mxy)
  ret i32 %r
}

define i32 @or_and_multiuse_and_i32(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: or_and_multiuse_and_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    # kill: def $esi killed $esi def $rsi
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    orl %edi, %esi
; CHECK-NEXT:    andl $8, %edi
; CHECK-NEXT:    andl $-11, %esi
; CHECK-NEXT:    leal (%rsi,%rdi), %ebx
; CHECK-NEXT:    # kill: def $edi killed $edi killed $rdi
; CHECK-NEXT:    callq use_i32@PLT
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
  %xy = or i32 %x, %y
  %mx = and i32 %x, 8
  %mxy = and i32 %xy, -11
  %r = or i32 %mx, %mxy
  call void @use_i32(i32 %mx)
  ret i32 %r
}

define i32 @or_and_multiuse_and_multiuse_i32(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: or_and_multiuse_and_multiuse_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    orl %edi, %ebx
; CHECK-NEXT:    andl $8, %edi
; CHECK-NEXT:    andl $-11, %ebx
; CHECK-NEXT:    leal (%rdi,%rbx), %ebp
; CHECK-NEXT:    # kill: def $edi killed $edi killed $rdi
; CHECK-NEXT:    callq use_i32@PLT
; CHECK-NEXT:    movl %ebx, %edi
; CHECK-NEXT:    callq use_i32@PLT
; CHECK-NEXT:    movl %ebp, %eax
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
  %xy = or i32 %x, %y
  %mx = and i32 %x, 8
  %mxy = and i32 %xy, -11
  %r = or i32 %mx, %mxy
  call void @use_i32(i32 %mx)
  call void @use_i32(i32 %mxy)
  ret i32 %r
}

declare void @use_i32(i32)
