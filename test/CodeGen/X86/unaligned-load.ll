; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin10.0 -mcpu=core2  -relocation-model=dynamic-no-pic    | FileCheck -check-prefix=I386 %s
; RUN: llc < %s -mtriple=x86_64-apple-darwin10.0 -mcpu=core2  -relocation-model=dynamic-no-pic  | FileCheck -check-prefix=CORE2 %s
; RUN: llc < %s -mtriple=x86_64-apple-darwin10.0 -mcpu=corei7 -relocation-model=dynamic-no-pic  | FileCheck -check-prefix=COREI7 %s

@.str1 = internal constant [31 x i8] c"DHRYSTONE PROGRAM, SOME STRING\00", align 8
@.str3 = internal constant [31 x i8] c"DHRYSTONE PROGRAM, 2'ND STRING\00", align 8

define void @func() nounwind ssp {
; I386-LABEL: func:
; I386:       ## %bb.0: ## %entry
; I386-NEXT:    pushl %esi
; I386-NEXT:    subl $40, %esp
; I386-NEXT:    leal {{[0-9]+}}(%esp), %esi
; I386-NEXT:    .p2align 4, 0x90
; I386-NEXT:  LBB0_1: ## %bb
; I386-NEXT:    ## =>This Inner Loop Header: Depth=1
; I386-NEXT:    subl $4, %esp
; I386-NEXT:    pushl $31
; I386-NEXT:    pushl $_.str3
; I386-NEXT:    pushl %esi
; I386-NEXT:    calll _memcpy
; I386-NEXT:    addl $16, %esp
; I386-NEXT:    jmp LBB0_1
;
; CORE2-LABEL: func:
; CORE2:       ## %bb.0: ## %entry
; CORE2-NEXT:    movabsq $20070800167293728, %rax ## imm = 0x474E4952545320
; CORE2-NEXT:    movabsq $2325069237881678925, %rcx ## imm = 0x20444E2732202C4D
; CORE2-NEXT:    movabsq $4706902966564560965, %rdx ## imm = 0x4152474F52502045
; CORE2-NEXT:    movabsq $5642821575076104260, %rsi ## imm = 0x4E4F545359524844
; CORE2-NEXT:    .p2align 4, 0x90
; CORE2-NEXT:  LBB0_1: ## %bb
; CORE2-NEXT:    ## =>This Inner Loop Header: Depth=1
; CORE2-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; CORE2-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; CORE2-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; CORE2-NEXT:    movq %rsi, -{{[0-9]+}}(%rsp)
; CORE2-NEXT:    jmp LBB0_1
;
; COREI7-LABEL: func:
; COREI7:       ## %bb.0: ## %entry
; COREI7-NEXT:    movups _.str3+{{.*}}(%rip), %xmm0
; COREI7-NEXT:    movups {{.*}}(%rip), %xmm1
; COREI7-NEXT:    .p2align 4, 0x90
; COREI7-NEXT:  LBB0_1: ## %bb
; COREI7-NEXT:    ## =>This Inner Loop Header: Depth=1
; COREI7-NEXT:    movups %xmm0, -{{[0-9]+}}(%rsp)
; COREI7-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp)
; COREI7-NEXT:    jmp LBB0_1
entry:
  %String2Loc = alloca [31 x i8], align 1
  br label %bb

bb:                                               ; preds = %bb, %entry
  %String2Loc9 = getelementptr inbounds [31 x i8], [31 x i8]* %String2Loc, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %String2Loc9, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str3, i64 0, i64 0), i64 31, i1 false)
  br label %bb

return:                                           ; No predecessors!
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
