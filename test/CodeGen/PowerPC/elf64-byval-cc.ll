; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-n32:64-S128-v256:256:256-v512:512:512"
target triple = "powerpc64le-unknown-linux-gnu"

%struct_S1 = type { [1 x i8] }
@gS1 = external global %struct_S1, align 1

define void @call_test_byval_mem1() #0 {
; CHECK-LABEL: call_test_byval_mem1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    lbz 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem1
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem1(%struct_S1* byval(%struct_S1) align 1 @gS1)
  ret void
}

define zeroext i8 @test_byval_mem1(%struct_S1* byval(%struct_S1) align 1 %s) {
; CHECK-LABEL: test_byval_mem1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mr 4, 3
; CHECK-NEXT:    clrldi 3, 3, 56
; CHECK-NEXT:    stb 4, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S1, %struct_S1* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem1_2() #0 {
; CHECK-LABEL: call_test_byval_mem1_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    li 5, 2
; CHECK-NEXT:    li 6, 3
; CHECK-NEXT:    li 7, 4
; CHECK-NEXT:    li 8, 5
; CHECK-NEXT:    li 9, 6
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    li 10, 7
; CHECK-NEXT:    lbz 3, 0(3)
; CHECK-NEXT:    stb 3, 96(1)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    bl test_byval_mem1_2
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem1_2(i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7, %struct_S1* byval(%struct_S1) align 1 @gS1)
  ret void
}

define zeroext i8 @test_byval_mem1_2(i64 %v1, i64 %v2, i64 %v3, i64 %v4, i64 %v5, i64 %v6, i64 %v7, i64 %v8, %struct_S1* byval(%struct_S1) align 1 %s) {
; CHECK-LABEL: test_byval_mem1_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lbz 3, 96(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S1, %struct_S1* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem1_3() #0 {
; CHECK-LABEL: call_test_byval_mem1_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    li 5, 2
; CHECK-NEXT:    li 6, 3
; CHECK-NEXT:    li 7, 4
; CHECK-NEXT:    li 8, 5
; CHECK-NEXT:    li 9, 6
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    lbz 10, 0(3)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    bl test_byval_mem1_3
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem1_3(i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, %struct_S1* byval(%struct_S1) align 1 @gS1)
  ret void
}

define zeroext i8 @test_byval_mem1_3(i64 %v1, i64 %v2, i64 %v3, i64 %v4, i64 %v5, i64 %v6, i64 %v7, %struct_S1* byval(%struct_S1) align 1 %s) {
; CHECK-LABEL: test_byval_mem1_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrldi 3, 10, 56
; CHECK-NEXT:    stb 10, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S1, %struct_S1* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem1_4() #0 {
; CHECK-LABEL: call_test_byval_mem1_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    li 4, 7
; CHECK-NEXT:    li 5, 2
; CHECK-NEXT:    li 7, 3
; CHECK-NEXT:    li 8, 4
; CHECK-NEXT:    li 9, 5
; CHECK-NEXT:    li 10, 6
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    std 4, 96(1)
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    lbz 6, 0(3)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    bl test_byval_mem1_4
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem1_4(i64 0, i64 1, i64 2, %struct_S1* byval(%struct_S1) align 1 @gS1, i64 3, i64 4, i64 5, i64 6, i64 7)
  ret void
}

define zeroext i8 @test_byval_mem1_4(i64 %v1, i64 %v2, i64 %v3, %struct_S1* byval(%struct_S1) align 1 %s, i64 %v4, i64 %v5, i64 %v6, i64 %v7, i64 %v8) {
; CHECK-LABEL: test_byval_mem1_4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrldi 3, 6, 56
; CHECK-NEXT:    stb 6, 56(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S1, %struct_S1* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem1_5() #0 {
; CHECK-LABEL: call_test_byval_mem1_5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    li 5, 2
; CHECK-NEXT:    li 7, 3
; CHECK-NEXT:    li 8, 4
; CHECK-NEXT:    li 9, 5
; CHECK-NEXT:    li 10, 6
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    lbz 6, 0(3)
; CHECK-NEXT:    li 3, 0
; CHECK-NEXT:    bl test_byval_mem1_5
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem1_5(i64 0, i64 1, i64 2, %struct_S1* byval(%struct_S1) align 1 @gS1, i64 3, i64 4, i64 5, i64 6)
  ret void
}

define zeroext i8 @test_byval_mem1_5(i64 %v1, i64 %v2, i64 %v3, %struct_S1* byval(%struct_S1) align 1 %s, i64 %v4, i64 %v5, i64 %v6, i64 %v7) {
; CHECK-LABEL: test_byval_mem1_5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrldi 3, 6, 56
; CHECK-NEXT:    stb 6, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S1, %struct_S1* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S2 = type { [2 x i8] }
@gS2 = external global %struct_S2, align 1

define void @call_test_byval_mem2() #0 {
; CHECK-LABEL: call_test_byval_mem2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC1@toc@ha
; CHECK-NEXT:    ld 3, .LC1@toc@l(3)
; CHECK-NEXT:    lhz 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem2
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem2(%struct_S2* byval(%struct_S2) align 1 @gS2)
  ret void
}

define zeroext i8 @test_byval_mem2(%struct_S2* byval(%struct_S2) align 1 %s) {
; CHECK-LABEL: test_byval_mem2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sth 3, -8(1)
; CHECK-NEXT:    lbz 3, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S2, %struct_S2* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S3 = type { [3 x i8] }
@gS3 = external global %struct_S3, align 1

define void @call_test_byval_mem3() #0 {
; CHECK-LABEL: call_test_byval_mem3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC2@toc@ha
; CHECK-NEXT:    ld 3, .LC2@toc@l(3)
; CHECK-NEXT:    lbz 4, 2(3)
; CHECK-NEXT:    stb 4, 34(1)
; CHECK-NEXT:    lhz 3, 0(3)
; CHECK-NEXT:    sth 3, 32(1)
; CHECK-NEXT:    ld 3, 32(1)
; CHECK-NEXT:    bl test_byval_mem3
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem3(%struct_S3* byval(%struct_S3) align 1 @gS3)
  ret void
}

define zeroext i8 @test_byval_mem3(%struct_S3* byval(%struct_S3) align 1 %s) {
; CHECK-LABEL: test_byval_mem3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sth 3, -8(1)
; CHECK-NEXT:    rldicl 5, 3, 48, 16
; CHECK-NEXT:    lbz 4, -8(1)
; CHECK-NEXT:    stb 5, -6(1)
; CHECK-NEXT:    mr 3, 4
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S3, %struct_S3* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S4 = type { [4 x i8] }
@gS4 = external global %struct_S4, align 1

define void @call_test_byval_mem4() #0 {
; CHECK-LABEL: call_test_byval_mem4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC3@toc@ha
; CHECK-NEXT:    ld 3, .LC3@toc@l(3)
; CHECK-NEXT:    lwz 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem4
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem4(%struct_S4* byval(%struct_S4) align 1 @gS4)
  ret void
}

define zeroext i8 @test_byval_mem4(%struct_S4* byval(%struct_S4) align 1 %s) {
; CHECK-LABEL: test_byval_mem4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stw 3, -8(1)
; CHECK-NEXT:    lbz 3, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S4, %struct_S4* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S8 = type { [8 x i8] }
@gS8 = external global %struct_S8, align 1

define void @call_test_byval_mem8() #0 {
; CHECK-LABEL: call_test_byval_mem8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC4@toc@ha
; CHECK-NEXT:    ld 3, .LC4@toc@l(3)
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem8
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem8(%struct_S8* byval(%struct_S8) align 1 @gS8)
  ret void
}

define zeroext i8 @test_byval_mem8(%struct_S8* byval(%struct_S8) align 1 %s) {
; CHECK-LABEL: test_byval_mem8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mr 4, 3
; CHECK-NEXT:    clrldi 3, 3, 56
; CHECK-NEXT:    std 4, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S8, %struct_S8* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S32 = type {[32 x i8] }
@gS32 = external global %struct_S32, align 1

define void @call_test_byval_mem32() #0 {
; CHECK-LABEL: call_test_byval_mem32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC5@toc@ha
; CHECK-NEXT:    ld 3, .LC5@toc@l(3)
; CHECK-NEXT:    ld 6, 24(3)
; CHECK-NEXT:    ld 5, 16(3)
; CHECK-NEXT:    ld 4, 8(3)
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem32
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem32(%struct_S32* byval(%struct_S32) align 1 @gS32)
  ret void
}

define zeroext i8 @test_byval_mem32(%struct_S32* byval(%struct_S32) align 1 %s) {
; CHECK-LABEL: test_byval_mem32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mr 7, 3
; CHECK-NEXT:    clrldi 3, 3, 56
; CHECK-NEXT:    std 4, -24(1)
; CHECK-NEXT:    std 5, -16(1)
; CHECK-NEXT:    std 6, -8(1)
; CHECK-NEXT:    std 7, -32(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S32, %struct_S32* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem32_2() #0 {
; CHECK-LABEL: call_test_byval_mem32_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC5@toc@ha
; CHECK-NEXT:    addis 8, 2, .LCPI20_0@toc@ha
; CHECK-NEXT:    ld 3, .LC5@toc@l(3)
; CHECK-NEXT:    lfs 1, .LCPI20_0@toc@l(8)
; CHECK-NEXT:    ld 7, 24(3)
; CHECK-NEXT:    ld 6, 16(3)
; CHECK-NEXT:    ld 5, 8(3)
; CHECK-NEXT:    ld 4, 0(3)
; CHECK-NEXT:    bl test_byval_mem32_2
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem32_2(float 1.0, %struct_S32* byval(%struct_S32) align 1 @gS32)
  ret void
}

define zeroext i8 @test_byval_mem32_2(float %f, %struct_S32* byval(%struct_S32) align 1 %s) {
; CHECK-LABEL: test_byval_mem32_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrldi 3, 4, 56
; CHECK-NEXT:    std 4, -32(1)
; CHECK-NEXT:    std 5, -24(1)
; CHECK-NEXT:    std 6, -16(1)
; CHECK-NEXT:    std 7, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S32, %struct_S32* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

define void @call_test_byval_mem32_3() #0 {
; CHECK-LABEL: call_test_byval_mem32_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC5@toc@ha
; CHECK-NEXT:    li 4, 16
; CHECK-NEXT:    addis 5, 2, .LCPI22_1@toc@ha
; CHECK-NEXT:    li 7, 2
; CHECK-NEXT:    ld 3, .LC5@toc@l(3)
; CHECK-NEXT:    lfs 2, .LCPI22_1@toc@l(5)
; CHECK-NEXT:    li 5, 3
; CHECK-NEXT:    lxvd2x 0, 3, 4
; CHECK-NEXT:    li 4, 88
; CHECK-NEXT:    stxvd2x 0, 1, 4
; CHECK-NEXT:    li 4, 72
; CHECK-NEXT:    lxvd2x 0, 0, 3
; CHECK-NEXT:    stxvd2x 0, 1, 4
; CHECK-NEXT:    addis 4, 2, .LCPI22_0@toc@ha
; CHECK-NEXT:    lfs 1, .LCPI22_0@toc@l(4)
; CHECK-NEXT:    ld 10, 16(3)
; CHECK-NEXT:    ld 9, 8(3)
; CHECK-NEXT:    ld 8, 0(3)
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    bl test_byval_mem32_3
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem32_3(i64 1, float 1.0, i64 3, double 4.0, i32 2, %struct_S32* byval(%struct_S32) align 1 @gS32)
  ret void
}

define zeroext i8 @test_byval_mem32_3(i64 %i1, float %f, i64 %i2, double %d, i32 %i3, %struct_S32* byval(%struct_S32) align 1 %s) {
; CHECK-LABEL: test_byval_mem32_3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrldi 3, 8, 56
; CHECK-NEXT:    std 8, 72(1)
; CHECK-NEXT:    std 9, 80(1)
; CHECK-NEXT:    std 10, 88(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S32, %struct_S32* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S64 = type {[64 x i8] }
@gS64= external global %struct_S64, align 1

define void @call_test_byval_mem64() #0 {
; CHECK-LABEL: call_test_byval_mem64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC6@toc@ha
; CHECK-NEXT:    ld 3, .LC6@toc@l(3)
; CHECK-NEXT:    ld 10, 56(3)
; CHECK-NEXT:    ld 9, 48(3)
; CHECK-NEXT:    ld 8, 40(3)
; CHECK-NEXT:    ld 7, 32(3)
; CHECK-NEXT:    ld 6, 24(3)
; CHECK-NEXT:    ld 5, 16(3)
; CHECK-NEXT:    ld 4, 8(3)
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem64
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem64(%struct_S64* byval(%struct_S64) align 1 @gS64)
  ret void
}

define zeroext i8 @test_byval_mem64(%struct_S64* byval(%struct_S64) align 1 %s) {
; CHECK-LABEL: test_byval_mem64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    std 3, -64(1)
; CHECK-NEXT:    clrldi 3, 3, 56
; CHECK-NEXT:    std 4, -56(1)
; CHECK-NEXT:    std 5, -48(1)
; CHECK-NEXT:    std 6, -40(1)
; CHECK-NEXT:    std 7, -32(1)
; CHECK-NEXT:    std 8, -24(1)
; CHECK-NEXT:    std 9, -16(1)
; CHECK-NEXT:    std 10, -8(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S64, %struct_S64* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}

%struct_S65 = type { [65 x i8] }
@gS65 = external global %struct_S65, align 1

define void @call_test_byval_mem65() #0 {
; CHECK-LABEL: call_test_byval_mem65:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -112(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 112
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC7@toc@ha
; CHECK-NEXT:    li 4, 48
; CHECK-NEXT:    li 5, 80
; CHECK-NEXT:    li 6, 64
; CHECK-NEXT:    ld 3, .LC7@toc@l(3)
; CHECK-NEXT:    lxvd2x 0, 3, 4
; CHECK-NEXT:    stxvd2x 0, 1, 5
; CHECK-NEXT:    li 5, 32
; CHECK-NEXT:    lxvd2x 0, 3, 5
; CHECK-NEXT:    stxvd2x 0, 1, 6
; CHECK-NEXT:    li 6, 16
; CHECK-NEXT:    lxvd2x 0, 3, 6
; CHECK-NEXT:    stxvd2x 0, 1, 4
; CHECK-NEXT:    lxvd2x 0, 0, 3
; CHECK-NEXT:    stxvd2x 0, 1, 5
; CHECK-NEXT:    lbz 4, 64(3)
; CHECK-NEXT:    stb 4, 96(1)
; CHECK-NEXT:    ld 10, 56(3)
; CHECK-NEXT:    ld 9, 48(3)
; CHECK-NEXT:    ld 8, 40(3)
; CHECK-NEXT:    ld 7, 32(3)
; CHECK-NEXT:    ld 6, 24(3)
; CHECK-NEXT:    ld 5, 16(3)
; CHECK-NEXT:    ld 4, 8(3)
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    bl test_byval_mem65
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 112
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = call zeroext i8 @test_byval_mem65(%struct_S65* byval(%struct_S65) align 1 @gS65)
  ret void
}

define zeroext i8 @test_byval_mem65(%struct_S65* byval(%struct_S65) align 1 %s) {
; CHECK-LABEL: test_byval_mem65:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    std 3, 32(1)
; CHECK-NEXT:    clrldi 3, 3, 56
; CHECK-NEXT:    std 4, 40(1)
; CHECK-NEXT:    std 5, 48(1)
; CHECK-NEXT:    std 6, 56(1)
; CHECK-NEXT:    std 7, 64(1)
; CHECK-NEXT:    std 8, 72(1)
; CHECK-NEXT:    std 9, 80(1)
; CHECK-NEXT:    std 10, 88(1)
; CHECK-NEXT:    blr
entry:
  %arrayidx = getelementptr inbounds %struct_S65, %struct_S65* %s, i32 0, i32 0, i32 0
  %0 = load i8, i8* %arrayidx, align 1
  ret i8 %0
}
