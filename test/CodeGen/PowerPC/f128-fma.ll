; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names < %s | FileCheck %s
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names < %s | FileCheck %s \
; RUN:   -check-prefix=CHECK-P8

define void @qpFmadd(fp128* nocapture readonly %a, fp128* nocapture %b,
; CHECK-LABEL: qpFmadd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsmaddqp v4, v2, v3
; CHECK-NEXT:    stxv v4, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFmadd:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -80(r1)
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 80
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    .cfi_offset v31, -32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    std r30, 64(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    stvx v31, r1, r7 # 16-byte Folded Spill
; CHECK-P8-NEXT:    lvx v31, 0, r5
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    vmr v3, v31
; CHECK-P8-NEXT:    bl __addkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    li r3, 48
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    ld r30, 64(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    lvx v31, r1, r3 # 16-byte Folded Reload
; CHECK-P8-NEXT:    addi r1, r1, 80
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                   fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %madd = tail call fp128 @llvm.fmuladd.f128(fp128 %0, fp128 %1, fp128 %2)
  store fp128 %madd, fp128* %res, align 16
  ret void
}
declare fp128 @llvm.fmuladd.f128(fp128, fp128, fp128)

; Function Attrs: norecurse nounwind
define void @qpFmadd_02(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFmadd_02:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsmaddqp v2, v3, v4
; CHECK-NEXT:    stxv v2, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFmadd_02:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -80(r1)
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 80
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    .cfi_offset v31, -32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lvx v2, 0, r4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    std r30, 64(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    stvx v31, r1, r7 # 16-byte Folded Spill
; CHECK-P8-NEXT:    lvx v31, 0, r3
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    vmr v3, v2
; CHECK-P8-NEXT:    vmr v2, v31
; CHECK-P8-NEXT:    bl __addkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    li r3, 48
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    ld r30, 64(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    lvx v31, r1, r3 # 16-byte Folded Reload
; CHECK-P8-NEXT:    addi r1, r1, 80
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                        fp128* nocapture readonly %b,
                        fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %add = fadd contract fp128 %0, %mul
  store fp128 %add, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFmadd_03(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFmadd_03:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsmaddqp v4, v2, v3
; CHECK-NEXT:    stxv v4, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFmadd_03:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 64
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r29, -24
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -64(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    mr r29, r5
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    lvx v3, 0, r29
; CHECK-P8-NEXT:    bl __addkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    addi r1, r1, 64
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                        fp128* nocapture readonly %b,
                        fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %add = fadd contract fp128 %mul, %2
  store fp128 %add, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFnmadd(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFnmadd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsnmaddqp v2, v3, v4
; CHECK-NEXT:    stxv v2, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFnmadd:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -96(r1)
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 96
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    .cfi_offset v31, -32
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    lvx v2, 0, r4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    std r30, 80(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    stvx v31, r1, r7 # 16-byte Folded Spill
; CHECK-P8-NEXT:    lvx v31, 0, r3
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    vmr v3, v2
; CHECK-P8-NEXT:    vmr v2, v31
; CHECK-P8-NEXT:    bl __addkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    addi r3, r1, 48
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    lbz r4, 63(r1)
; CHECK-P8-NEXT:    xori r4, r4, 128
; CHECK-P8-NEXT:    stb r4, 63(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    li r3, 64
; CHECK-P8-NEXT:    lvx v31, r1, r3 # 16-byte Folded Reload
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    ld r30, 80(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    addi r1, r1, 96
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %add = fadd contract fp128 %0, %mul
  %sub = fsub fp128 0xL00000000000000008000000000000000, %add
  store fp128 %sub, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFnmadd_02(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFnmadd_02:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsnmaddqp v4, v2, v3
; CHECK-NEXT:    stxv v4, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFnmadd_02:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 80
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r29, -24
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -80(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    mr r29, r5
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    lvx v3, 0, r29
; CHECK-P8-NEXT:    bl __addkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    addi r3, r1, 32
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    lbz r4, 47(r1)
; CHECK-P8-NEXT:    xori r4, r4, 128
; CHECK-P8-NEXT:    stb r4, 47(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    addi r1, r1, 80
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %add = fadd contract fp128 %mul, %2
  %sub = fsub fp128 0xL00000000000000008000000000000000, %add
  store fp128 %sub, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFmsub(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFmsub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsnmsubqp v2, v3, v4
; CHECK-NEXT:    stxv v2, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFmsub:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -80(r1)
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 80
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    .cfi_offset v31, -32
; CHECK-P8-NEXT:    li r7, 48
; CHECK-P8-NEXT:    lvx v2, 0, r4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    std r30, 64(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    stvx v31, r1, r7 # 16-byte Folded Spill
; CHECK-P8-NEXT:    lvx v31, 0, r3
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    vmr v3, v2
; CHECK-P8-NEXT:    vmr v2, v31
; CHECK-P8-NEXT:    bl __subkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    li r3, 48
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    ld r30, 64(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    lvx v31, r1, r3 # 16-byte Folded Reload
; CHECK-P8-NEXT:    addi r1, r1, 80
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %sub = fsub contract nsz fp128 %0, %mul
  store fp128 %sub, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFmsub_02(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFmsub_02:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsmsubqp v4, v2, v3
; CHECK-NEXT:    stxv v4, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFmsub_02:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 64
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r29, -24
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -64(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    mr r29, r5
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    lvx v3, 0, r29
; CHECK-P8-NEXT:    bl __subkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    addi r1, r1, 64
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %sub = fsub contract fp128 %mul, %2
  store fp128 %sub, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFnmsub(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFnmsub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsnegqp v3, v3
; CHECK-NEXT:    xsnmaddqp v2, v3, v4
; CHECK-NEXT:    stxv v2, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFnmsub:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -96(r1)
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 96
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    .cfi_offset v31, -32
; CHECK-P8-NEXT:    li r7, 64
; CHECK-P8-NEXT:    lvx v2, 0, r4
; CHECK-P8-NEXT:    lvx v3, 0, r5
; CHECK-P8-NEXT:    std r30, 80(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    stvx v31, r1, r7 # 16-byte Folded Spill
; CHECK-P8-NEXT:    lvx v31, 0, r3
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    vmr v3, v2
; CHECK-P8-NEXT:    vmr v2, v31
; CHECK-P8-NEXT:    bl __subkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    addi r3, r1, 48
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    lbz r4, 63(r1)
; CHECK-P8-NEXT:    xori r4, r4, 128
; CHECK-P8-NEXT:    stb r4, 63(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    li r3, 64
; CHECK-P8-NEXT:    lvx v31, r1, r3 # 16-byte Folded Reload
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    ld r30, 80(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    addi r1, r1, 96
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %2 = load fp128, fp128* %c, align 16
  %mul = fmul contract fp128 %1, %2
  %sub = fsub contract fp128 %0, %mul
  %sub1 = fsub fp128 0xL00000000000000008000000000000000, %sub
  store fp128 %sub1, fp128* %res, align 16
  ret void
}

; Function Attrs: norecurse nounwind
define void @qpFnmsub_02(fp128* nocapture readonly %a,
; CHECK-LABEL: qpFnmsub_02:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv v2, 0(r3)
; CHECK-NEXT:    lxv v3, 0(r4)
; CHECK-NEXT:    lxv v4, 0(r5)
; CHECK-NEXT:    xsnmsubqp v4, v2, v3
; CHECK-NEXT:    stxv v4, 0(r6)
; CHECK-NEXT:    blr
;
; CHECK-P8-LABEL: qpFnmsub_02:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mflr r0
; CHECK-P8-NEXT:    .cfi_def_cfa_offset 80
; CHECK-P8-NEXT:    .cfi_offset lr, 16
; CHECK-P8-NEXT:    .cfi_offset r29, -24
; CHECK-P8-NEXT:    .cfi_offset r30, -16
; CHECK-P8-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-P8-NEXT:    std r0, 16(r1)
; CHECK-P8-NEXT:    stdu r1, -80(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    lvx v3, 0, r4
; CHECK-P8-NEXT:    mr r30, r6
; CHECK-P8-NEXT:    mr r29, r5
; CHECK-P8-NEXT:    bl __mulkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    lvx v3, 0, r29
; CHECK-P8-NEXT:    bl __subkf3
; CHECK-P8-NEXT:    nop
; CHECK-P8-NEXT:    addi r3, r1, 32
; CHECK-P8-NEXT:    stvx v2, 0, r3
; CHECK-P8-NEXT:    lbz r4, 47(r1)
; CHECK-P8-NEXT:    xori r4, r4, 128
; CHECK-P8-NEXT:    stb r4, 47(r1)
; CHECK-P8-NEXT:    lvx v2, 0, r3
; CHECK-P8-NEXT:    stvx v2, 0, r30
; CHECK-P8-NEXT:    addi r1, r1, 80
; CHECK-P8-NEXT:    ld r0, 16(r1)
; CHECK-P8-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-P8-NEXT:    mtlr r0
; CHECK-P8-NEXT:    blr
                      fp128* nocapture readonly %b,
                      fp128* nocapture readonly %c, fp128* nocapture %res) {
entry:
  %0 = load fp128, fp128* %a, align 16
  %1 = load fp128, fp128* %b, align 16
  %mul = fmul contract fp128 %0, %1
  %2 = load fp128, fp128* %c, align 16
  %sub = fsub contract fp128 %mul, %2
  %sub1 = fsub fp128 0xL00000000000000008000000000000000, %sub
  store fp128 %sub1, fp128* %res, align 16
  ret void
}
