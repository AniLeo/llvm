; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=future -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s | FileCheck %s

; On future CPU with PC Relative addressing enabled, it is possible for the
; linker to optimize GOT indirect accesses. In order for the linker to do this
; the compiler needs to add a hint using the R_PPC64_PCREL_OPT relocation.
; This test checks that the compiler adds the R_PPC64_PCREL_OPT relocation
; correctly.

@input8 = external local_unnamed_addr global i8, align 1
@output8 = external local_unnamed_addr global i8, align 1
@input16 = external local_unnamed_addr global i16, align 2
@output16 = external local_unnamed_addr global i16, align 2
@input32 = external global i32, align 4
@output32 = external local_unnamed_addr global i32, align 4
@input64 = external local_unnamed_addr global i64, align 8
@output64 = external local_unnamed_addr global i64, align 8
@input128 = external local_unnamed_addr global i128, align 16
@output128 = external local_unnamed_addr global i128, align 16
@inputf32 = external local_unnamed_addr global float, align 4
@outputf32 = external local_unnamed_addr global float, align 4
@inputf64 = external local_unnamed_addr global double, align 8
@outputf64 = external local_unnamed_addr global double, align 8
@inputVi32 = external local_unnamed_addr global <4 x i32>, align 16
@outputVi32 = external local_unnamed_addr global <4 x i32>, align 16
@inputVi64 = external local_unnamed_addr global <2 x i64>, align 16
@outputVi64 = external local_unnamed_addr global <2 x i64>, align 16
@ArrayIn = external global [10 x i32], align 4
@ArrayOut = external local_unnamed_addr global [10 x i32], align 4
@IntPtrIn = external local_unnamed_addr global i32*, align 8
@IntPtrOut = external local_unnamed_addr global i32*, align 8
@FuncPtrIn = external local_unnamed_addr global void (...)*, align 8
@FuncPtrOut = external local_unnamed_addr global void (...)*, align 8

define dso_local void @ReadWrite8() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWrite8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input8@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel0:
; CHECK-NEXT:    pld r4, output8@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel0-8,R_PPC64_PCREL_OPT,.-(.Lpcrel0-8)
; CHECK-NEXT:    lbz r3, 0(r3)
; CHECK-NEXT:    stb r3, 0(r4)
; CHECK-NEXT:    blr
; In this test the stb r3, 0(r4) cannot be optimized because it
; uses the register r3 and that register is defined by lbz r3, 0(r3)
; which is defined between the pld and the stb.
entry:
  %0 = load i8, i8* @input8, align 1
  store i8 %0, i8* @output8, align 1
  ret void
}

define dso_local void @ReadWrite16() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWrite16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input16@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel1:
; CHECK-NEXT:    pld r4, output16@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel1-8,R_PPC64_PCREL_OPT,.-(.Lpcrel1-8)
; CHECK-NEXT:    lhz r3, 0(r3)
; CHECK-NEXT:    sth r3, 0(r4)
; CHECK-NEXT:    blr
; In this test the sth r3, 0(r4) cannot be optimized because it
; uses the register r3 and that register is defined by lhz r3, 0(r3)
; which is defined between the pld and the sth.
entry:
  %0 = load i16, i16* @input16, align 2
  store i16 %0, i16* @output16, align 2
  ret void
}

define dso_local void @ReadWrite32() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWrite32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input32@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel2:
; CHECK-NEXT:    pld r4, output32@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel2-8,R_PPC64_PCREL_OPT,.-(.Lpcrel2-8)
; CHECK-NEXT:    lwz r3, 0(r3)
; CHECK-NEXT:    stw r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* @input32, align 4
  store i32 %0, i32* @output32, align 4
  ret void
}

define dso_local void @ReadWrite64() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWrite64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input64@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel3:
; CHECK-NEXT:    pld r4, output64@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel3-8,R_PPC64_PCREL_OPT,.-(.Lpcrel3-8)
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %0 = load i64, i64* @input64, align 8
  store i64 %0, i64* @output64, align 8
  ret void
}

; FIXME: we should always convert X-Form instructions that use
; PPC::ZERO[8] to the corresponding D-Form so we can perform this opt.
define dso_local void @ReadWrite128() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWrite128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input128@got@pcrel(0), 1
; CHECK-NEXT:    lxvx vs0, 0, r3
; CHECK-NEXT:    pld r3, output128@got@pcrel(0), 1
; CHECK-NEXT:    stxvx vs0, 0, r3
; CHECK-NEXT:    blr
entry:
  %0 = load i128, i128* @input128, align 16
  store i128 %0, i128* @output128, align 16
  ret void
}

define dso_local void @ReadWritef32() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWritef32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, inputf32@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel4:
; CHECK-NEXT:    xxspltidp vs1, 1078103900
; CHECK-NEXT:    .reloc .Lpcrel4-8,R_PPC64_PCREL_OPT,.-(.Lpcrel4-8)
; CHECK-NEXT:    lfs f0, 0(r3)
; CHECK-NEXT:    pld r3, outputf32@got@pcrel(0), 1
; CHECK-NEXT:    xsaddsp f0, f0, f1
; CHECK-NEXT:    stfs f0, 0(r3)
; CHECK-NEXT:    blr
entry:
  %0 = load float, float* @inputf32, align 4
  %add = fadd float %0, 0x400851EB80000000
  store float %add, float* @outputf32, align 4
  ret void
}

define dso_local void @ReadWritef64() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWritef64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, inputf64@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel5:
; CHECK-NEXT:    plfd f1, .LCPI6_0@PCREL(0), 1
; CHECK-NEXT:    .reloc .Lpcrel5-8,R_PPC64_PCREL_OPT,.-(.Lpcrel5-8)
; CHECK-NEXT:    lfd f0, 0(r3)
; CHECK-NEXT:    pld r3, outputf64@got@pcrel(0), 1
; CHECK-NEXT:    xsadddp f0, f0, f1
; CHECK-NEXT:    stfd f0, 0(r3)
; CHECK-NEXT:    blr
entry:
  %0 = load double, double* @inputf64, align 8
  %add = fadd double %0, 6.800000e+00
  store double %add, double* @outputf64, align 8
  ret void
}

; FIXME: we should always convert X-Form instructions that use
; PPC::ZERO[8] to the corresponding D-Form so we can perform this opt.
define dso_local void @ReadWriteVi32() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteVi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, inputVi32@got@pcrel(0), 1
; CHECK-NEXT:    li r4, 45
; CHECK-NEXT:    lxvx v2, 0, r3
; CHECK-NEXT:    pld r3, outputVi32@got@pcrel(0), 1
; CHECK-NEXT:    vinsw v2, r4, 8
; CHECK-NEXT:    stxvx v2, 0, r3
; CHECK-NEXT:    blr
entry:
  %0 = load <4 x i32>, <4 x i32>* @inputVi32, align 16
  %vecins = insertelement <4 x i32> %0, i32 45, i32 1
  store <4 x i32> %vecins, <4 x i32>* @outputVi32, align 16
  ret void
}

define dso_local void @ReadWriteVi64() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteVi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, inputVi64@got@pcrel(0), 1
; CHECK-NEXT:    lxvx vs0, 0, r3
; CHECK-NEXT:    pld r3, outputVi64@got@pcrel(0), 1
; CHECK-NEXT:    stxvx vs0, 0, r3
; CHECK-NEXT:    blr
entry:
  %0 = load <2 x i64>, <2 x i64>* @inputVi64, align 16
  store <2 x i64> %0, <2 x i64>* @outputVi64, align 16
  ret void
}

define dso_local void @ReadWriteArray() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteArray:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, ArrayIn@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel6:
; CHECK-NEXT:    pld r4, ArrayOut@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel6-8,R_PPC64_PCREL_OPT,.-(.Lpcrel6-8)
; CHECK-NEXT:    lwz r3, 28(r3)
; CHECK-NEXT:    addi r3, r3, 42
; CHECK-NEXT:    stw r3, 8(r4)
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayIn, i64 0, i64 7), align 4
  %add = add nsw i32 %0, 42
  store i32 %add, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayOut, i64 0, i64 2), align 4
  ret void
}

define dso_local void @ReadWriteSameArray() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteSameArray:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, ArrayIn@got@pcrel(0), 1
; CHECK-NEXT:    lwz r4, 12(r3)
; CHECK-NEXT:    addi r4, r4, 8
; CHECK-NEXT:    stw r4, 24(r3)
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayIn, i64 0, i64 3), align 4
  %add = add nsw i32 %0, 8
  store i32 %add, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayIn, i64 0, i64 6), align 4
  ret void
}

define dso_local void @ReadWriteIntPtr() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteIntPtr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, IntPtrIn@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel7:
; CHECK-NEXT:    pld r4, IntPtrOut@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel8:
; CHECK-NEXT:    .reloc .Lpcrel7-8,R_PPC64_PCREL_OPT,.-(.Lpcrel7-8)
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    .reloc .Lpcrel8-8,R_PPC64_PCREL_OPT,.-(.Lpcrel8-8)
; CHECK-NEXT:    ld r4, 0(r4)
; CHECK-NEXT:    lwz r5, 216(r3)
; CHECK-NEXT:    lwz r3, 48(r3)
; CHECK-NEXT:    add r3, r3, r5
; CHECK-NEXT:    stw r3, 136(r4)
; CHECK-NEXT:    blr
entry:
  %0 = load i32*, i32** @IntPtrIn, align 8
  %arrayidx = getelementptr inbounds i32, i32* %0, i64 54
  %1 = load i32, i32* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %0, i64 12
  %2 = load i32, i32* %arrayidx1, align 4
  %add = add nsw i32 %2, %1
  %3 = load i32*, i32** @IntPtrOut, align 8
  %arrayidx2 = getelementptr inbounds i32, i32* %3, i64 34
  store i32 %add, i32* %arrayidx2, align 4
  ret void
}

define dso_local void @ReadWriteFuncPtr() local_unnamed_addr #0 {
; CHECK-LABEL: ReadWriteFuncPtr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, FuncPtrIn@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel9:
; CHECK-NEXT:    pld r4, FuncPtrOut@got@pcrel(0), 1
; CHECK-NEXT:    .reloc .Lpcrel9-8,R_PPC64_PCREL_OPT,.-(.Lpcrel9-8)
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    std r3, 0(r4)
; CHECK-NEXT:    blr
entry:
  %0 = load i64, i64* bitcast (void (...)** @FuncPtrIn to i64*), align 8
  store i64 %0, i64* bitcast (void (...)** @FuncPtrOut to i64*), align 8
  ret void
}

define dso_local void @FuncPtrCopy() local_unnamed_addr #0 {
; CHECK-LABEL: FuncPtrCopy:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, FuncPtrOut@got@pcrel(0), 1
; CHECK-NEXT:    pld r4, Callee@got@pcrel(0), 1
; CHECK-NEXT:    std r4, 0(r3)
; CHECK-NEXT:    blr
entry:
  store void (...)* @Callee, void (...)** @FuncPtrOut, align 8
  ret void
}

declare void @Callee(...)

define dso_local void @FuncPtrCall() local_unnamed_addr #0 {
; CHECK-LABEL: FuncPtrCall:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, FuncPtrIn@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel10:
; CHECK-NEXT:    .reloc .Lpcrel10-8,R_PPC64_PCREL_OPT,.-(.Lpcrel10-8)
; CHECK-NEXT:    ld r12, 0(r3)
; CHECK-NEXT:    mtctr r12
; CHECK-NEXT:    bctr
; CHECK-NEXT:    #TC_RETURNr8 ctr 0
entry:
  %0 = load void ()*, void ()** bitcast (void (...)** @FuncPtrIn to void ()**), align 8
  tail call void %0()
  ret void
}

define dso_local signext i32 @ReadVecElement() local_unnamed_addr #0 {
; CHECK-LABEL: ReadVecElement:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, inputVi32@got@pcrel(0), 1
; CHECK-NEXT:  .Lpcrel11:
; CHECK-NEXT:    .reloc .Lpcrel11-8,R_PPC64_PCREL_OPT,.-(.Lpcrel11-8)
; CHECK-NEXT:    lwa r3, 4(r3)
; CHECK-NEXT:    blr
entry:
  %0 = load <4 x i32>, <4 x i32>* @inputVi32, align 16
  %vecext = extractelement <4 x i32> %0, i32 1
  ret i32 %vecext
}

define dso_local signext i32 @VecMultiUse() local_unnamed_addr #0 {
; CHECK-LABEL: VecMultiUse:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -64(r1)
; CHECK-NEXT:    pld r30, inputVi32@got@pcrel(0), 1
; CHECK-NEXT:    lwz r29, 4(r30)
; CHECK-NEXT:    bl Callee@notoc
; CHECK-NEXT:    lwz r3, 8(r30)
; CHECK-NEXT:    add r29, r3, r29
; CHECK-NEXT:    bl Callee@notoc
; CHECK-NEXT:    lwz r3, 0(r30)
; CHECK-NEXT:    add r3, r29, r3
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 64
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %0 = load <4 x i32>, <4 x i32>* @inputVi32, align 16
  tail call void bitcast (void (...)* @Callee to void ()*)()
  %1 = load <4 x i32>, <4 x i32>* @inputVi32, align 16
  %2 = extractelement <4 x i32> %1, i32 2
  %3 = extractelement <4 x i32> %0, i64 1
  %4 = add nsw i32 %2, %3
  tail call void bitcast (void (...)* @Callee to void ()*)()
  %5 = load <4 x i32>, <4 x i32>* @inputVi32, align 16
  %vecext2 = extractelement <4 x i32> %5, i32 0
  %add3 = add nsw i32 %4, %vecext2
  ret i32 %add3
}

define dso_local signext i32 @UseAddr(i32 signext %a) local_unnamed_addr #0 {
; CHECK-LABEL: UseAddr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr r0
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r0, 16(r1)
; CHECK-NEXT:    stdu r1, -48(r1)
; CHECK-NEXT:    pld r4, ArrayIn@got@pcrel(0), 1
; CHECK-NEXT:    lwz r5, 16(r4)
; CHECK-NEXT:    add r30, r5, r3
; CHECK-NEXT:    mr r3, r4
; CHECK-NEXT:    bl getAddr@notoc
; CHECK-NEXT:    add r3, r30, r3
; CHECK-NEXT:    extsw r3, r3
; CHECK-NEXT:    addi r1, r1, 48
; CHECK-NEXT:    ld r0, 16(r1)
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    mtlr r0
; CHECK-NEXT:    blr
entry:
  %0 = load i32, i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayIn, i64 0, i64 4), align 4
  %add = add nsw i32 %0, %a
  %call = tail call signext i32 @getAddr(i32* getelementptr inbounds ([10 x i32], [10 x i32]* @ArrayIn, i64 0, i64 0))
  %add1 = add nsw i32 %add, %call
  ret i32 %add1
}

declare signext i32 @getAddr(i32*) local_unnamed_addr

define dso_local nonnull i32* @AddrTaken32() local_unnamed_addr #0 {
; CHECK-LABEL: AddrTaken32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pld r3, input32@got@pcrel(0), 1
; CHECK-NEXT:    blr
entry:
  ret i32* @input32
}

attributes #0 = { nounwind }
