; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=penryn | FileCheck %s

; rdar://7475489

define i32 @test1(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: test1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movb {{[0-9]+}}(%esp), %al
; CHECK-NEXT:    xorb {{[0-9]+}}(%esp), %al
; CHECK-NEXT:    testb $64, %al
; CHECK-NEXT:    je LBB0_1
; CHECK-NEXT:  ## %bb.2: ## %bb1
; CHECK-NEXT:    jmp _bar ## TAILCALL
; CHECK-NEXT:  LBB0_1: ## %bb
; CHECK-NEXT:    jmp _foo ## TAILCALL
entry:
  %0 = and i32 %a, 16384
  %1 = icmp ne i32 %0, 0
  %2 = and i32 %b, 16384
  %3 = icmp ne i32 %2, 0
  %4 = xor i1 %1, %3
  br i1 %4, label %bb1, label %bb

bb:                                               ; preds = %entry
  %5 = tail call i32 (...) @foo() nounwind       ; <i32> [#uses=1]
  ret i32 %5

bb1:                                              ; preds = %entry
  %6 = tail call i32 (...) @bar() nounwind       ; <i32> [#uses=1]
  ret i32 %6
}

declare i32 @foo(...)

declare i32 @bar(...)


; <rdar://problem/7598384>:
;
;    jCC  L1
;    jmp  L2
; L1:
;   ...
; L2:
;   ...
;
; to:
;
;    jnCC L2
; L1:
;   ...
; L2:
;   ...
define float @test4(float %x, float %y) nounwind readnone optsize ssp {
; CHECK-LABEL: test4:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    cvtss2sd {{[0-9]+}}(%esp), %xmm1
; CHECK-NEXT:    cvtss2sd {{[0-9]+}}(%esp), %xmm0
; CHECK-NEXT:    mulsd %xmm1, %xmm0
; CHECK-NEXT:    xorpd %xmm1, %xmm1
; CHECK-NEXT:    ucomisd %xmm1, %xmm0
; CHECK-NEXT:    jne LBB1_1
; CHECK-NEXT:    jnp LBB1_2
; CHECK-NEXT:  LBB1_1: ## %bb1
; CHECK-NEXT:    addsd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; CHECK-NEXT:  LBB1_2: ## %bb2
; CHECK-NEXT:    cvtsd2ss %xmm0, %xmm0
; CHECK-NEXT:    movss %xmm0, (%esp)
; CHECK-NEXT:    flds (%esp)
; CHECK-NEXT:    popl %eax
; CHECK-NEXT:    retl
entry:
  %0 = fpext float %x to double                   ; <double> [#uses=1]
  %1 = fpext float %y to double                   ; <double> [#uses=1]
  %2 = fmul double %0, %1                         ; <double> [#uses=3]
  %3 = fcmp oeq double %2, 0.000000e+00           ; <i1> [#uses=1]
  br i1 %3, label %bb2, label %bb1


bb1:                                              ; preds = %entry
  %4 = fadd double %2, -1.000000e+00              ; <double> [#uses=1]
  br label %bb2

bb2:                                              ; preds = %entry, %bb1
  %.0.in = phi double [ %4, %bb1 ], [ %2, %entry ] ; <double> [#uses=1]
  %.0 = fptrunc double %.0.in to float            ; <float> [#uses=1]
  ret float %.0
}

declare i32 @llvm.x86.sse41.ptestz(<4 x float> %p1, <4 x float> %p2) nounwind
declare i32 @llvm.x86.sse41.ptestc(<4 x float> %p1, <4 x float> %p2) nounwind

define <4 x float> @test5(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test5:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jne LBB2_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB2_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestz(<4 x float> %a, <4 x float> %a) nounwind
  %one = icmp ne i32 %res, 0
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

define <4 x float> @test7(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test7:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jne LBB3_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB3_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestz(<4 x float> %a, <4 x float> %a) nounwind
  %one = trunc i32 %res to i1
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

define <4 x float> @test8(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test8:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jae LBB4_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB4_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestc(<4 x float> %a, <4 x float> %a) nounwind
  %one = icmp ne i32 %res, 0
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

define <4 x float> @test10(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test10:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jae LBB5_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB5_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestc(<4 x float> %a, <4 x float> %a) nounwind
  %one = trunc i32 %res to i1
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

define <4 x float> @test11(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test11:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    jne LBB6_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB6_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestz(<4 x float> %a, <4 x float> %a) nounwind
  %one = icmp eq i32 %res, 1
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

define <4 x float> @test12(<4 x float> %a, <4 x float> %b) nounwind {
; CHECK-LABEL: test12:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ptest %xmm0, %xmm0
; CHECK-NEXT:    je LBB7_2
; CHECK-NEXT:  ## %bb.1: ## %bb1
; CHECK-NEXT:    addps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB7_2: ## %bb2
; CHECK-NEXT:    divps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retl
entry:

  %res = call i32 @llvm.x86.sse41.ptestz(<4 x float> %a, <4 x float> %a) nounwind
  %one = icmp ne i32 %res, 1
  br i1 %one, label %bb1, label %bb2

bb1:
  %c = fadd <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
  br label %return

bb2:
	%d = fdiv <4 x float> %b, < float 1.000000e+002, float 2.000000e+002, float 3.000000e+002, float 4.000000e+002 >
	br label %return

return:
  %e = phi <4 x float> [%c, %bb1], [%d, %bb2]
  ret <4 x float> %e
}

