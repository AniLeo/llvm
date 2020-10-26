; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:     FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:     FileCheck %s

; This test case tests spilling the CR EQ bit on Power10. On Power10, this is
; achieved by setb %reg, %CRREG (eq bit) -> stw %reg, $FI instead of:
; mfocrf %reg, %CRREG -> rlwinm %reg1, %reg, $SH, 0, 0 -> stw %reg1, $FI.

; Without fine-grained control over clobbering individual CR bits,
; it is difficult to produce a concise test case that will ensure a specific
; bit of any CR field is spilled. We need to test the spilling of a CR bit
; other than the LT bit. Hence this test case is rather complex.

%0 = type { i32, %1*, %0*, [1 x i8], i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%1 = type { %1*, %0*, i32 }
%2 = type { [200 x i8], [200 x i8], %3*, %3*, %4*, %4*, %4*, %4*, %4*, i64 }
%3 = type { i64, i32, %3*, %3*, %3*, %3*, %4*, %4*, %4*, %4*, i64, i32, i32 }
%4 = type { i32, i64, %3*, %3*, i16, %4*, %4*, i64, i64 }

define dso_local double @P10_Spill_CR_EQ(%2* %arg) local_unnamed_addr #0 {
; CHECK-LABEL: P10_Spill_CR_EQ:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    mfcr r12
; CHECK-NEXT:    stw r12, 8(r1)
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    ld r4, 0(0)
; CHECK-NEXT:    ld r5, 56(0)
; CHECK-NEXT:    cmpdi cr1, r3, 0
; CHECK-NEXT:    cmpdi cr4, r4, 0
; CHECK-NEXT:    cmpdi cr6, r5, 0
; CHECK-NEXT:    cmpldi r3, 0
; CHECK-NEXT:    beq cr0, .LBB0_3
; CHECK-NEXT:  # %bb.1: # %bb10
; CHECK-NEXT:    lwz r3, 0(r3)
; CHECK-NEXT:    bc 12, 4*cr4+eq, .LBB0_4
; CHECK-NEXT:  .LBB0_2: # %bb14
; CHECK-NEXT:    lwz r5, 0(r3)
; CHECK-NEXT:    b .LBB0_5
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    # implicit-def: $r3
; CHECK-NEXT:    bc 4, 4*cr4+eq, .LBB0_2
; CHECK-NEXT:  .LBB0_4:
; CHECK-NEXT:    # implicit-def: $r5
; CHECK-NEXT:  .LBB0_5: # %bb16
; CHECK-NEXT:    mfocrf r4, 64
; CHECK-NEXT:    crnot 4*cr2+un, 4*cr1+eq
; CHECK-NEXT:    crnot 4*cr5+lt, 4*cr6+eq
; CHECK-NEXT:    rotlwi r4, r4, 4
; CHECK-NEXT:    stw r4, -4(r1)
; CHECK-NEXT:    bc 12, 4*cr6+eq, .LBB0_7
; CHECK-NEXT:  # %bb.6: # %bb18
; CHECK-NEXT:    lwz r4, 0(r3)
; CHECK-NEXT:    b .LBB0_8
; CHECK-NEXT:  .LBB0_7:
; CHECK-NEXT:    # implicit-def: $r4
; CHECK-NEXT:  .LBB0_8: # %bb20
; CHECK-NEXT:    cmpwi r3, -1
; CHECK-NEXT:    cmpwi cr3, r4, -1
; CHECK-NEXT:    cmpwi cr7, r3, 0
; CHECK-NEXT:    cmpwi cr1, r4, 0
; CHECK-NEXT:    # implicit-def: $x3
; CHECK-NEXT:    crand 4*cr5+eq, gt, 4*cr2+un
; CHECK-NEXT:    crand 4*cr5+gt, 4*cr3+gt, 4*cr5+lt
; CHECK-NEXT:    setnbc r4, 4*cr5+eq
; CHECK-NEXT:    stw r4, -20(r1)
; CHECK-NEXT:    bc 4, 4*cr5+eq, .LBB0_10
; CHECK-NEXT:  # %bb.9: # %bb34
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:  .LBB0_10: # %bb36
; CHECK-NEXT:    mfocrf r4, 2
; CHECK-NEXT:    cmpwi cr3, r5, 0
; CHECK-NEXT:    rotlwi r4, r4, 24
; CHECK-NEXT:    stw r4, -12(r1)
; CHECK-NEXT:    # implicit-def: $x4
; CHECK-NEXT:    bc 4, 4*cr5+gt, .LBB0_12
; CHECK-NEXT:  # %bb.11: # %bb38
; CHECK-NEXT:    ld r4, 0(r3)
; CHECK-NEXT:  .LBB0_12: # %bb40
; CHECK-NEXT:    mcrf cr6, cr4
; CHECK-NEXT:    crnot 4*cr4+eq, 4*cr4+eq
; CHECK-NEXT:    crand 4*cr4+lt, 4*cr7+lt, 4*cr2+un
; CHECK-NEXT:    # implicit-def: $x6
; CHECK-NEXT:    crand 4*cr4+gt, 4*cr1+lt, 4*cr5+lt
; CHECK-NEXT:    bc 4, 4*cr4+gt, .LBB0_14
; CHECK-NEXT:  # %bb.13: # %bb48
; CHECK-NEXT:    ld r6, 0(r3)
; CHECK-NEXT:  .LBB0_14: # %bb50
; CHECK-NEXT:    cmpwi r5, -1
; CHECK-NEXT:    crand 4*cr4+un, 4*cr3+lt, 4*cr4+eq
; CHECK-NEXT:    # implicit-def: $r5
; CHECK-NEXT:    bc 4, 4*cr4+lt, .LBB0_16
; CHECK-NEXT:  # %bb.15: # %bb52
; CHECK-NEXT:    lwz r5, 0(r3)
; CHECK-NEXT:  .LBB0_16: # %bb54
; CHECK-NEXT:    setnbc r7, 4*cr5+gt
; CHECK-NEXT:    stw r7, -16(r1)
; CHECK-NEXT:    mfocrf r7, 2
; CHECK-NEXT:    rotlwi r7, r7, 24
; CHECK-NEXT:    stw r7, -8(r1)
; CHECK-NEXT:    # implicit-def: $r7
; CHECK-NEXT:    bc 4, 4*cr4+un, .LBB0_18
; CHECK-NEXT:  # %bb.17: # %bb56
; CHECK-NEXT:    lwz r7, 0(r3)
; CHECK-NEXT:  .LBB0_18: # %bb58
; CHECK-NEXT:    crand 4*cr5+gt, 4*cr7+eq, 4*cr2+un
; CHECK-NEXT:    mcrf cr2, cr1
; CHECK-NEXT:    cmpwi cr1, r5, 1
; CHECK-NEXT:    crand lt, gt, 4*cr4+eq
; CHECK-NEXT:    # implicit-def: $x5
; CHECK-NEXT:    setnbc r8, 4*cr5+gt
; CHECK-NEXT:    crand 4*cr5+lt, 4*cr2+eq, 4*cr5+lt
; CHECK-NEXT:    crand 4*cr4+eq, 4*cr3+eq, 4*cr4+eq
; CHECK-NEXT:    crand gt, 4*cr1+lt, 4*cr4+lt
; CHECK-NEXT:    stw r8, -24(r1)
; CHECK-NEXT:    setnbc r8, 4*cr5+lt
; CHECK-NEXT:    cmpwi cr5, r7, 1
; CHECK-NEXT:    stw r8, -28(r1)
; CHECK-NEXT:    lwz r6, 92(r6)
; CHECK-NEXT:    crand eq, 4*cr5+lt, 4*cr4+un
; CHECK-NEXT:    cmpwi cr6, r6, 1
; CHECK-NEXT:    crand un, 4*cr6+lt, 4*cr4+gt
; CHECK-NEXT:    bc 4, gt, .LBB0_20
; CHECK-NEXT:  # %bb.19: # %bb68
; CHECK-NEXT:    ld r5, 0(r3)
; CHECK-NEXT:  .LBB0_20: # %bb70
; CHECK-NEXT:    lwz r7, -20(r1)
; CHECK-NEXT:    # implicit-def: $cr5lt
; CHECK-NEXT:    mfocrf r6, 4
; CHECK-NEXT:    xxlxor f2, f2, f2
; CHECK-NEXT:    rlwimi r6, r7, 12, 20, 20
; CHECK-NEXT:    mtocrf 4, r6
; CHECK-NEXT:    ld r6, 0(r3)
; CHECK-NEXT:    crandc 4*cr5+gt, lt, 4*cr3+eq
; CHECK-NEXT:    lwz r8, -16(r1)
; CHECK-NEXT:    # implicit-def: $cr5eq
; CHECK-NEXT:    crandc 4*cr5+lt, 4*cr5+lt, 4*cr7+eq
; CHECK-NEXT:    mfocrf r7, 4
; CHECK-NEXT:    rlwimi r7, r8, 10, 22, 22
; CHECK-NEXT:    mtocrf 4, r7
; CHECK-NEXT:    lwz r7, -24(r1)
; CHECK-NEXT:    # implicit-def: $cr5un
; CHECK-NEXT:    lwz r9, -28(r1)
; CHECK-NEXT:    crandc 4*cr5+eq, 4*cr5+eq, 4*cr2+eq
; CHECK-NEXT:    isel r3, r3, r5, 4*cr5+lt
; CHECK-NEXT:    crnor 4*cr5+lt, gt, 4*cr5+lt
; CHECK-NEXT:    crnor 4*cr5+gt, eq, 4*cr5+gt
; CHECK-NEXT:    crnor 4*cr5+eq, un, 4*cr5+eq
; CHECK-NEXT:    mfocrf r5, 4
; CHECK-NEXT:    rlwimi r5, r7, 9, 23, 23
; CHECK-NEXT:    setbc r7, 4*cr4+eq
; CHECK-NEXT:    mtocrf 4, r5
; CHECK-NEXT:    setbc r5, 4*cr5+un
; CHECK-NEXT:    # implicit-def: $cr5un
; CHECK-NEXT:    mfocrf r8, 4
; CHECK-NEXT:    add r5, r7, r5
; CHECK-NEXT:    rlwimi r8, r9, 9, 23, 23
; CHECK-NEXT:    lwz r9, -4(r1)
; CHECK-NEXT:    mtocrf 4, r8
; CHECK-NEXT:    mtocrf 128, r9
; CHECK-NEXT:    lwz r9, -8(r1)
; CHECK-NEXT:    isel r3, 0, r3, 4*cr5+lt
; CHECK-NEXT:    setbc r8, 4*cr5+un
; CHECK-NEXT:    isel r6, 0, r6, 4*cr5+gt
; CHECK-NEXT:    isel r4, 0, r4, 4*cr5+eq
; CHECK-NEXT:    add r5, r8, r5
; CHECK-NEXT:    iseleq r3, 0, r3
; CHECK-NEXT:    mtfprd f0, r5
; CHECK-NEXT:    mtocrf 128, r9
; CHECK-NEXT:    lwz r9, -12(r1)
; CHECK-NEXT:    lwz r12, 8(r1)
; CHECK-NEXT:    xscvsxddp f0, f0
; CHECK-NEXT:    iseleq r6, 0, r6
; CHECK-NEXT:    mtocrf 128, r9
; CHECK-NEXT:    add r3, r6, r3
; CHECK-NEXT:    mtocrf 32, r12
; CHECK-NEXT:    mtocrf 16, r12
; CHECK-NEXT:    mtocrf 8, r12
; CHECK-NEXT:    iseleq r4, 0, r4
; CHECK-NEXT:    add r3, r4, r3
; CHECK-NEXT:    xsmuldp f0, f0, f2
; CHECK-NEXT:    mtfprd f1, r3
; CHECK-NEXT:    xscvsxddp f1, f1
; CHECK-NEXT:    xsadddp f1, f0, f1
; CHECK-NEXT:    blr
bb:
  %tmp = getelementptr inbounds %4, %4* null, i64 undef, i32 7
  %tmp1 = load i64, i64* undef, align 8
  %tmp2 = load i64, i64* null, align 8
  %tmp3 = load i64, i64* %tmp, align 8
  %tmp4 = icmp eq i64 %tmp1, 0
  %tmp5 = icmp eq i64 %tmp2, 0
  %tmp6 = icmp eq i64 %tmp3, 0
  %tmp7 = xor i1 %tmp4, true
  %tmp8 = xor i1 %tmp5, true
  %tmp9 = xor i1 %tmp6, true
  br i1 %tmp4, label %bb12, label %bb10

bb10:                                             ; preds = %bb
  %tmp11 = load i32, i32* undef, align 8
  br label %bb12

bb12:                                             ; preds = %bb10, %bb
  %tmp13 = phi i32 [ undef, %bb ], [ %tmp11, %bb10 ]
  br i1 %tmp5, label %bb16, label %bb14

bb14:                                             ; preds = %bb12
  %tmp15 = load i32, i32* undef, align 8
  br label %bb16

bb16:                                             ; preds = %bb14, %bb12
  %tmp17 = phi i32 [ undef, %bb12 ], [ %tmp15, %bb14 ]
  br i1 %tmp6, label %bb20, label %bb18

bb18:                                             ; preds = %bb16
  %tmp19 = load i32, i32* undef, align 8
  br label %bb20

bb20:                                             ; preds = %bb18, %bb16
  %tmp21 = phi i32 [ undef, %bb16 ], [ %tmp19, %bb18 ]
  %tmp22 = icmp slt i32 %tmp13, 0
  %tmp23 = icmp slt i32 %tmp17, 0
  %tmp24 = icmp slt i32 %tmp21, 0
  %tmp25 = icmp eq i32 %tmp13, 0
  %tmp26 = icmp eq i32 %tmp17, 0
  %tmp27 = icmp eq i32 %tmp21, 0
  %tmp28 = xor i1 %tmp22, true
  %tmp29 = xor i1 %tmp23, true
  %tmp30 = xor i1 %tmp24, true
  %tmp31 = and i1 %tmp28, %tmp7
  %tmp32 = and i1 %tmp29, %tmp8
  %tmp33 = and i1 %tmp30, %tmp9
  br i1 %tmp31, label %bb34, label %bb36

bb34:                                             ; preds = %bb20
  %tmp35 = load i64, i64* undef, align 8
  br label %bb36

bb36:                                             ; preds = %bb34, %bb20
  %tmp37 = phi i64 [ undef, %bb20 ], [ %tmp35, %bb34 ]
  br i1 %tmp33, label %bb38, label %bb40

bb38:                                             ; preds = %bb36
  %tmp39 = load i64, i64* undef, align 8
  br label %bb40

bb40:                                             ; preds = %bb38, %bb36
  %tmp41 = phi i64 [ undef, %bb36 ], [ %tmp39, %bb38 ]
  %tmp42 = and i1 %tmp25, %tmp7
  %tmp43 = and i1 %tmp26, %tmp8
  %tmp44 = and i1 %tmp27, %tmp9
  %tmp45 = and i1 %tmp22, %tmp7
  %tmp46 = and i1 %tmp23, %tmp8
  %tmp47 = and i1 %tmp24, %tmp9
  br i1 %tmp47, label %bb48, label %bb50

bb48:                                             ; preds = %bb40
  %tmp49 = load %3*, %3** undef, align 8
  br label %bb50

bb50:                                             ; preds = %bb48, %bb40
  %tmp51 = phi %3* [ undef, %bb40 ], [ %tmp49, %bb48 ]
  br i1 %tmp45, label %bb52, label %bb54

bb52:                                             ; preds = %bb50
  %tmp53 = load i32, i32* undef, align 8
  br label %bb54

bb54:                                             ; preds = %bb52, %bb50
  %tmp55 = phi i32 [ undef, %bb50 ], [ %tmp53, %bb52 ]
  br i1 %tmp46, label %bb56, label %bb58

bb56:                                             ; preds = %bb54
  %tmp57 = load i32, i32* undef, align 8
  br label %bb58

bb58:                                             ; preds = %bb56, %bb54
  %tmp59 = phi i32 [ undef, %bb54 ], [ %tmp57, %bb56 ]
  %tmp60 = getelementptr inbounds %3, %3* %tmp51, i64 0, i32 12
  %tmp61 = load i32, i32* %tmp60, align 8
  %tmp62 = icmp slt i32 %tmp55, 1
  %tmp63 = icmp slt i32 %tmp59, 1
  %tmp64 = icmp slt i32 %tmp61, 1
  %tmp65 = and i1 %tmp62, %tmp45
  %tmp66 = and i1 %tmp63, %tmp46
  %tmp67 = and i1 %tmp64, %tmp47
  br i1 %tmp65, label %bb68, label %bb70

bb68:                                             ; preds = %bb58
  %tmp69 = load i64, i64* undef, align 8
  br label %bb70

bb70:                                             ; preds = %bb68, %bb58
  %tmp71 = phi i64 [ undef, %bb58 ], [ %tmp69, %bb68 ]
  %tmp72 = load i64, i64* undef, align 8
  %tmp73 = xor i1 %tmp25, true
  %tmp74 = xor i1 %tmp26, true
  %tmp75 = xor i1 %tmp27, true
  %tmp76 = and i1 %tmp31, %tmp73
  %tmp77 = and i1 %tmp32, %tmp74
  %tmp78 = and i1 %tmp33, %tmp75
  %tmp79 = select i1 %tmp76, i64 %tmp37, i64 %tmp71
  %tmp80 = select i1 %tmp77, i64 undef, i64 %tmp72
  %tmp81 = select i1 %tmp78, i64 %tmp41, i64 undef
  %tmp82 = or i1 %tmp65, %tmp76
  %tmp83 = or i1 %tmp66, %tmp77
  %tmp84 = or i1 %tmp67, %tmp78
  %tmp85 = zext i1 %tmp42 to i64
  %tmp86 = add i64 0, %tmp85
  %tmp87 = zext i1 %tmp43 to i64
  %tmp88 = add i64 0, %tmp87
  %tmp89 = zext i1 %tmp44 to i64
  %tmp90 = add i64 0, %tmp89
  %tmp91 = select i1 %tmp82, i64 %tmp79, i64 0
  %tmp92 = add i64 0, %tmp91
  %tmp93 = select i1 %tmp83, i64 %tmp80, i64 0
  %tmp94 = add i64 0, %tmp93
  %tmp95 = select i1 %tmp84, i64 %tmp81, i64 0
  %tmp96 = add i64 0, %tmp95
  %tmp97 = select i1 %tmp42, i64 undef, i64 %tmp92
  %tmp98 = select i1 %tmp43, i64 undef, i64 %tmp94
  %tmp99 = select i1 %tmp44, i64 undef, i64 %tmp96
  %tmp100 = select i1 %tmp4, i64 0, i64 %tmp97
  %tmp101 = select i1 %tmp5, i64 0, i64 %tmp98
  %tmp102 = select i1 %tmp6, i64 0, i64 %tmp99
  %tmp103 = add i64 %tmp88, %tmp86
  %tmp104 = add i64 %tmp90, %tmp103
  %tmp105 = add i64 0, %tmp104
  %tmp106 = add i64 %tmp101, %tmp100
  %tmp107 = add i64 %tmp102, %tmp106
  %tmp108 = add i64 0, %tmp107
  %tmp109 = sitofp i64 %tmp105 to double
  %tmp110 = sitofp i64 %tmp108 to double
  %tmp111 = fmul double %tmp109, 0.000000e+00
  %tmp112 = fadd double %tmp111, %tmp110
  ret double %tmp112
}
