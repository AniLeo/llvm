; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s --check-prefix=CHECK-LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s --check-prefix=CHECK-BE
; RUN: opt --passes=sroa,loop-vectorize,loop-unroll,instcombine -S \
; RUN: -vectorizer-maximize-bandwidth --mtriple=powerpc64le-- -mcpu=pwr10 < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-OPT

target datalayout = "e-m:e-i64:64-n32:64-S128-v256:256:256-v512:512:512"

define dso_local signext i32 @test_32byte_vector() nounwind {
; CHECK-LE-LABEL: test_32byte_vector:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mflr r0
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    std r0, 16(r1)
; CHECK-LE-NEXT:    clrldi r0, r1, 59
; CHECK-LE-NEXT:    subfic r0, r0, -96
; CHECK-LE-NEXT:    stdux r1, r1, r0
; CHECK-LE-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-LE-NEXT:    addis r4, r2, .LCPI0_1@toc@ha
; CHECK-LE-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-LE-NEXT:    addi r4, r4, .LCPI0_1@toc@l
; CHECK-LE-NEXT:    lxvd2x vs0, 0, r3
; CHECK-LE-NEXT:    lxvd2x vs1, 0, r4
; CHECK-LE-NEXT:    addi r4, r1, 48
; CHECK-LE-NEXT:    addi r3, r1, 32
; CHECK-LE-NEXT:    stxvd2x vs0, 0, r4
; CHECK-LE-NEXT:    stxvd2x vs1, 0, r3
; CHECK-LE-NEXT:    bl test
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:    lwa r3, 32(r1)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r0, 16(r1)
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    mtlr r0
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_32byte_vector:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mflr r0
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    std r0, 16(r1)
; CHECK-BE-NEXT:    clrldi r0, r1, 59
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    subfic r0, r0, -192
; CHECK-BE-NEXT:    stdux r1, r1, r0
; CHECK-BE-NEXT:    lis r3, -8192
; CHECK-BE-NEXT:    li r4, 5
; CHECK-BE-NEXT:    lis r5, -16384
; CHECK-BE-NEXT:    lis r6, -32768
; CHECK-BE-NEXT:    ori r3, r3, 1
; CHECK-BE-NEXT:    rldic r4, r4, 32, 29
; CHECK-BE-NEXT:    ori r5, r5, 1
; CHECK-BE-NEXT:    ori r6, r6, 1
; CHECK-BE-NEXT:    rldic r3, r3, 3, 29
; CHECK-BE-NEXT:    ori r4, r4, 6
; CHECK-BE-NEXT:    rldic r5, r5, 2, 30
; CHECK-BE-NEXT:    rldic r6, r6, 1, 31
; CHECK-BE-NEXT:    std r3, 152(r1)
; CHECK-BE-NEXT:    addi r3, r1, 128
; CHECK-BE-NEXT:    std r4, 144(r1)
; CHECK-BE-NEXT:    std r5, 136(r1)
; CHECK-BE-NEXT:    std r6, 128(r1)
; CHECK-BE-NEXT:    bl test
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:    lwa r3, 128(r1)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r0, 16(r1)
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    mtlr r0
; CHECK-BE-NEXT:    blr
entry:
  %a = alloca <8 x i32>, align 32
  %0 = bitcast <8 x i32>* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %0)
  store <8 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8>, <8 x i32>* %a, align 32
  call void @test(<8 x i32>* %a)
  %1 = load <8 x i32>, <8 x i32>* %a, align 32
  %vecext = extractelement <8 x i32> %1, i32 0
  %2 = bitcast <8 x i32>* %a to i8*
  call void @llvm.lifetime.end.p0i8(i64 32, i8* %2)
  ret i32 %vecext
}

define dso_local signext i32 @test_32byte_aligned_vector() nounwind {
; CHECK-LE-LABEL: test_32byte_aligned_vector:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mflr r0
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    std r0, 16(r1)
; CHECK-LE-NEXT:    clrldi r0, r1, 59
; CHECK-LE-NEXT:    subfic r0, r0, -64
; CHECK-LE-NEXT:    stdux r1, r1, r0
; CHECK-LE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-LE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-LE-NEXT:    lxvd2x vs0, 0, r3
; CHECK-LE-NEXT:    addi r3, r1, 32
; CHECK-LE-NEXT:    stxvd2x vs0, 0, r3
; CHECK-LE-NEXT:    bl test1
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:    lwa r3, 32(r1)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r0, 16(r1)
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    mtlr r0
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_32byte_aligned_vector:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mflr r0
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    std r0, 16(r1)
; CHECK-BE-NEXT:    clrldi r0, r1, 59
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    subfic r0, r0, -160
; CHECK-BE-NEXT:    stdux r1, r1, r0
; CHECK-BE-NEXT:    lis r3, -16384
; CHECK-BE-NEXT:    lis r4, -32768
; CHECK-BE-NEXT:    ori r3, r3, 1
; CHECK-BE-NEXT:    ori r4, r4, 1
; CHECK-BE-NEXT:    rldic r3, r3, 2, 30
; CHECK-BE-NEXT:    rldic r4, r4, 1, 31
; CHECK-BE-NEXT:    std r3, 136(r1)
; CHECK-BE-NEXT:    addi r3, r1, 128
; CHECK-BE-NEXT:    std r4, 128(r1)
; CHECK-BE-NEXT:    bl test1
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:    lwa r3, 128(r1)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r0, 16(r1)
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    mtlr r0
; CHECK-BE-NEXT:    blr
entry:
  %a = alloca <4 x i32>, align 32
  %0 = bitcast <4 x i32>* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %0)
  store <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32>* %a, align 32
  call void @test1(<4 x i32>* %a)
  %1 = load <4 x i32>, <4 x i32>* %a, align 32
  %vecext = extractelement <4 x i32> %1, i32 0
  %2 = bitcast <4 x i32>* %a to i8*
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %2)
  ret i32 %vecext
}


@Arr1 = dso_local global [64 x i8] zeroinitializer, align 1

define dso_local void @test_Array() nounwind {
; CHECK-OPT-LABEL: @test_Array(
; CHECK-OPT-NEXT: entry:
; CHECK-OPT-NEXT: %Arr2 = alloca [64 x i16], align 2
; CHECK-OPT: store <16 x i16> [[TMP0:%.*]], <16 x i16>* [[TMP0:%.*]], align 2
; CHECK-LE-LABEL: test_Array:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mflr r0
; CHECK-LE-NEXT:    std r0, 16(r1)
; CHECK-LE-NEXT:    stdu r1, -176(r1)
; CHECK-LE-NEXT:    addis r4, r2, Arr1@toc@ha
; CHECK-LE-NEXT:    li r3, 0
; CHECK-LE-NEXT:    li r6, 65
; CHECK-LE-NEXT:    addi r5, r1, 46
; CHECK-LE-NEXT:    addi r4, r4, Arr1@toc@l
; CHECK-LE-NEXT:    stw r3, 44(r1)
; CHECK-LE-NEXT:    addi r4, r4, -1
; CHECK-LE-NEXT:    mtctr r6
; CHECK-LE-NEXT:    bdz .LBB2_2
; CHECK-LE-NEXT:    .p2align 5
; CHECK-LE-NEXT:  .LBB2_1: # %for.body
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    lbz r6, 1(r4)
; CHECK-LE-NEXT:    addi r7, r5, 2
; CHECK-LE-NEXT:    addi r4, r4, 1
; CHECK-LE-NEXT:    addi r3, r3, 1
; CHECK-LE-NEXT:    sth r6, 2(r5)
; CHECK-LE-NEXT:    mr r5, r7
; CHECK-LE-NEXT:    bdnz .LBB2_1
; CHECK-LE-NEXT:  .LBB2_2: # %for.cond.cleanup
; CHECK-LE-NEXT:    addi r3, r1, 48
; CHECK-LE-NEXT:    bl test_arr
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:    addi r1, r1, 176
; CHECK-LE-NEXT:    ld r0, 16(r1)
; CHECK-LE-NEXT:    mtlr r0
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_Array:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mflr r0
; CHECK-BE-NEXT:    std r0, 16(r1)
; CHECK-BE-NEXT:    stdu r1, -256(r1)
; CHECK-BE-NEXT:    addis r5, r2, Arr1@toc@ha
; CHECK-BE-NEXT:    li r3, 0
; CHECK-BE-NEXT:    addi r5, r5, Arr1@toc@l
; CHECK-BE-NEXT:    addi r4, r1, 126
; CHECK-BE-NEXT:    li r6, 65
; CHECK-BE-NEXT:    stw r3, 124(r1)
; CHECK-BE-NEXT:    addi r5, r5, -1
; CHECK-BE-NEXT:    mtctr r6
; CHECK-BE-NEXT:    bdz .LBB2_2
; CHECK-BE-NEXT:  .LBB2_1: # %for.body
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    lbz r6, 1(r5)
; CHECK-BE-NEXT:    addi r5, r5, 1
; CHECK-BE-NEXT:    addi r3, r3, 1
; CHECK-BE-NEXT:    sth r6, 2(r4)
; CHECK-BE-NEXT:    addi r4, r4, 2
; CHECK-BE-NEXT:    bdnz .LBB2_1
; CHECK-BE-NEXT:  .LBB2_2: # %for.cond.cleanup
; CHECK-BE-NEXT:    addi r3, r1, 128
; CHECK-BE-NEXT:    bl test_arr
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:    addi r1, r1, 256
; CHECK-BE-NEXT:    ld r0, 16(r1)
; CHECK-BE-NEXT:    mtlr r0
; CHECK-BE-NEXT:    blr
entry:
  %Arr2 = alloca [64 x i16], align 2
  %i = alloca i32, align 4
  %0 = bitcast [64 x i16]* %Arr2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 128, i8* %0)
  %1 = bitcast i32* %i to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %1)
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %2, 64
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  %3 = bitcast i32* %i to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %3)
  br label %for.end

for.body:                                         ; preds = %for.cond
  %4 = load i32, i32* %i, align 4
  %idxprom = sext i32 %4 to i64
  %arrayidx = getelementptr inbounds [64 x i8], [64 x i8]* @Arr1, i64 0, i64 %idxprom
  %5 = load i8, i8* %arrayidx, align 1
  %conv = zext i8 %5 to i16
  %6 = load i32, i32* %i, align 4
  %idxprom1 = sext i32 %6 to i64
  %arrayidx2 = getelementptr inbounds [64 x i16], [64 x i16]* %Arr2, i64 0, i64 %idxprom1
  store i16 %conv, i16* %arrayidx2, align 2
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32, i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond.cleanup
  %arraydecay = getelementptr inbounds [64 x i16], [64 x i16]* %Arr2, i64 0, i64 0
  call void @test_arr(i16* %arraydecay)
  %8 = bitcast [64 x i16]* %Arr2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 128, i8* %8)
  ret void
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) nounwind

declare void @test(<8 x i32>*) nounwind
declare void @test1(<4 x i32>*) nounwind
declare void @test_arr(i16*)

declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) nounwind
