; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names \
; RUN:     -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:     -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:     < %s | FileCheck %s --check-prefixes=CHECK,CHECK-P10
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:     -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:     < %s | FileCheck %s --check-prefixes=CHECK,CHECK-P10-BE
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr \
; RUN:   -ppc-asm-full-reg-names -mtriple=powerpc64-ibm-aix-xcoff < %s | \
; RUN: FileCheck %s --check-prefix=AIX-64
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr \
; RUN:   -ppc-asm-full-reg-names -mtriple=powerpc-ibm-aix-xcoff < %s | \
; RUN: FileCheck %s --check-prefix=AIX-32

; Function Attrs: norecurse nounwind readonly
define dso_local <2 x double> @test1(<2 x float>* nocapture readonly %Ptr) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 0(r3)
; CHECK-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-NEXT:    xvcvspdp v2, vs0
; CHECK-NEXT:    blr
;
; AIX-64-LABEL: test1:
; AIX-64:       # %bb.0: # %entry
; AIX-64-NEXT:    lfdx f0, 0, r3
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp v2, vs0
; AIX-64-NEXT:    blr
;
; AIX-32-LABEL: test1:
; AIX-32:       # %bb.0: # %entry
; AIX-32-NEXT:    lfs f0, 4(r3)
; AIX-32-NEXT:    lfs f1, 0(r3)
; AIX-32-NEXT:    xxmrghd v2, vs1, vs0
; AIX-32-NEXT:    blr
entry:
  %0 = load <2 x float>, <2 x float>* %Ptr, align 8
  %1 = fpext <2 x float> %0 to <2 x double>
  ret <2 x double> %1
}

; Function Attrs: norecurse nounwind readonly
define dso_local <2 x double> @test2(<2 x float>* nocapture readonly %a, <2 x float>* nocapture readonly %b) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 0(r4)
; CHECK-NEXT:    lfd f1, 0(r3)
; CHECK-NEXT:    xvsubsp vs0, vs1, vs0
; CHECK-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-NEXT:    xvcvspdp v2, vs0
; CHECK-NEXT:    blr
;
; AIX-64-LABEL: test2:
; AIX-64:       # %bb.0: # %entry
; AIX-64-NEXT:    lfdx f0, 0, r3
; AIX-64-NEXT:    lfdx f1, 0, r4
; AIX-64-NEXT:    xvsubsp vs0, vs0, vs1
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp v2, vs0
; AIX-64-NEXT:    blr
;
; AIX-32-LABEL: test2:
; AIX-32:       # %bb.0: # %entry
; AIX-32-NEXT:    lwz r5, L..C0(r2) # %const.0
; AIX-32-NEXT:    li r6, 4
; AIX-32-NEXT:    lxsiwzx v3, 0, r3
; AIX-32-NEXT:    lxsiwzx v0, 0, r4
; AIX-32-NEXT:    lxsiwzx v2, r3, r6
; AIX-32-NEXT:    lxsiwzx v5, r4, r6
; AIX-32-NEXT:    lxvw4x v4, 0, r5
; AIX-32-NEXT:    vperm v2, v3, v2, v4
; AIX-32-NEXT:    vperm v3, v0, v5, v4
; AIX-32-NEXT:    xvsubsp vs0, v2, v3
; AIX-32-NEXT:    xxsldwi vs1, vs0, vs0, 1
; AIX-32-NEXT:    xscvspdpn f0, vs0
; AIX-32-NEXT:    xscvspdpn f1, vs1
; AIX-32-NEXT:    xxmrghd v2, vs0, vs1
; AIX-32-NEXT:    blr
entry:
  %0 = load <2 x float>, <2 x float>* %a, align 8
  %1 = load <2 x float>, <2 x float>* %b, align 8
  %sub = fsub <2 x float> %0, %1
  %2 = fpext <2 x float> %sub to <2 x double>
  ret <2 x double> %2
}

; Function Attrs: norecurse nounwind readonly
; Function Attrs: norecurse nounwind readonly
define dso_local <2 x double> @test3(<2 x float>* nocapture readonly %a, <2 x float>* nocapture readonly %b) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 0(r4)
; CHECK-NEXT:    lfd f1, 0(r3)
; CHECK-NEXT:    xvaddsp vs0, vs1, vs0
; CHECK-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-NEXT:    xvcvspdp v2, vs0
; CHECK-NEXT:    blr
;
; AIX-64-LABEL: test3:
; AIX-64:       # %bb.0: # %entry
; AIX-64-NEXT:    lfdx f0, 0, r3
; AIX-64-NEXT:    lfdx f1, 0, r4
; AIX-64-NEXT:    xvaddsp vs0, vs0, vs1
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp v2, vs0
; AIX-64-NEXT:    blr
;
; AIX-32-LABEL: test3:
; AIX-32:       # %bb.0: # %entry
; AIX-32-NEXT:    lwz r5, L..C1(r2) # %const.0
; AIX-32-NEXT:    li r6, 4
; AIX-32-NEXT:    lxsiwzx v3, 0, r3
; AIX-32-NEXT:    lxsiwzx v0, 0, r4
; AIX-32-NEXT:    lxsiwzx v2, r3, r6
; AIX-32-NEXT:    lxsiwzx v5, r4, r6
; AIX-32-NEXT:    lxvw4x v4, 0, r5
; AIX-32-NEXT:    vperm v2, v3, v2, v4
; AIX-32-NEXT:    vperm v3, v0, v5, v4
; AIX-32-NEXT:    xvaddsp vs0, v2, v3
; AIX-32-NEXT:    xxsldwi vs1, vs0, vs0, 1
; AIX-32-NEXT:    xscvspdpn f0, vs0
; AIX-32-NEXT:    xscvspdpn f1, vs1
; AIX-32-NEXT:    xxmrghd v2, vs0, vs1
; AIX-32-NEXT:    blr
entry:
  %0 = load <2 x float>, <2 x float>* %a, align 8
  %1 = load <2 x float>, <2 x float>* %b, align 8
  %sub = fadd <2 x float> %0, %1
  %2 = fpext <2 x float> %sub to <2 x double>
  ret <2 x double> %2
}

; Function Attrs: norecurse nounwind readonly
; Function Attrs: norecurse nounwind readonly
define dso_local <2 x double> @test4(<2 x float>* nocapture readonly %a, <2 x float>* nocapture readonly %b) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd f0, 0(r4)
; CHECK-NEXT:    lfd f1, 0(r3)
; CHECK-NEXT:    xvmulsp vs0, vs1, vs0
; CHECK-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-NEXT:    xvcvspdp v2, vs0
; CHECK-NEXT:    blr
;
; AIX-64-LABEL: test4:
; AIX-64:       # %bb.0: # %entry
; AIX-64-NEXT:    lfdx f0, 0, r3
; AIX-64-NEXT:    lfdx f1, 0, r4
; AIX-64-NEXT:    xvmulsp vs0, vs0, vs1
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp v2, vs0
; AIX-64-NEXT:    blr
;
; AIX-32-LABEL: test4:
; AIX-32:       # %bb.0: # %entry
; AIX-32-NEXT:    lwz r5, L..C2(r2) # %const.0
; AIX-32-NEXT:    li r6, 4
; AIX-32-NEXT:    lxsiwzx v3, 0, r3
; AIX-32-NEXT:    lxsiwzx v0, 0, r4
; AIX-32-NEXT:    lxsiwzx v2, r3, r6
; AIX-32-NEXT:    lxsiwzx v5, r4, r6
; AIX-32-NEXT:    lxvw4x v4, 0, r5
; AIX-32-NEXT:    vperm v2, v3, v2, v4
; AIX-32-NEXT:    vperm v3, v0, v5, v4
; AIX-32-NEXT:    xvmulsp vs0, v2, v3
; AIX-32-NEXT:    xxsldwi vs1, vs0, vs0, 1
; AIX-32-NEXT:    xscvspdpn f0, vs0
; AIX-32-NEXT:    xscvspdpn f1, vs1
; AIX-32-NEXT:    xxmrghd v2, vs0, vs1
; AIX-32-NEXT:    blr
entry:
  %0 = load <2 x float>, <2 x float>* %a, align 8
  %1 = load <2 x float>, <2 x float>* %b, align 8
  %sub = fmul <2 x float> %0, %1
  %2 = fpext <2 x float> %sub to <2 x double>
  ret <2 x double> %2
}

@G = dso_local local_unnamed_addr global <2 x float> <float 3.000000e+00, float 0x3FF3333340000000>, align 8

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly uwtable willreturn
define dso_local <2 x double> @test5(<2 x double> %a) {
; CHECK-P10-LABEL: test5:
; CHECK-P10:       # %bb.0: # %entry
; CHECK-P10-NEXT:    plfd f0, G@PCREL(0), 1
; CHECK-P10-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P10-NEXT:    xvcvspdp vs0, vs0
; CHECK-P10-NEXT:    xvadddp v2, vs0, v2
; CHECK-P10-NEXT:    blr
;
; CHECK-P10-BE-LABEL: test5:
; CHECK-P10-BE:       # %bb.0: # %entry
; CHECK-P10-BE-NEXT:    addis r3, r2, G@toc@ha
; CHECK-P10-BE-NEXT:    lfd f0, G@toc@l(r3)
; CHECK-P10-BE-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P10-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-P10-BE-NEXT:    xvadddp v2, vs0, v2
; CHECK-P10-BE-NEXT:    blr
;
; AIX-64-LABEL: test5:
; AIX-64:       # %bb.0: # %entry
; AIX-64-NEXT:    ld r3, L..C0(r2) # @G
; AIX-64-NEXT:    lfdx f0, 0, r3
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp vs0, vs0
; AIX-64-NEXT:    xvadddp v2, vs0, v2
; AIX-64-NEXT:    blr
;
; AIX-32-LABEL: test5:
; AIX-32:       # %bb.0: # %entry
; AIX-32-NEXT:    lwz r3, L..C3(r2) # @G
; AIX-32-NEXT:    lfs f0, 4(r3)
; AIX-32-NEXT:    lfs f1, 0(r3)
; AIX-32-NEXT:    xxmrghd vs0, vs1, vs0
; AIX-32-NEXT:    xvadddp v2, vs0, v2
; AIX-32-NEXT:    blr
entry:
  %0 = load <2 x float>, <2 x float>* @G, align 8
  %1 = fpext <2 x float> %0 to <2 x double>
  %add = fadd <2 x double> %1, %a
  ret <2 x double> %add
}

%0 = type <{ i32, i8, [1 x i8], i16, i32, i32, i8, [1 x i8], i16, i32, float, float, double, double, ppc_fp128, { float, float }, { float, float }, { double, double }, { double, double }, { ppc_fp128, ppc_fp128 }, [89856 x i8] }>
@Glob1 = external dso_local unnamed_addr global [25 x %0], align 16

define dso_local i32 @test6() #0 {
; CHECK-P10-LABEL: test6:
; CHECK-P10:       # %bb.0: # %bb
; CHECK-P10-NEXT:    plfd f0, Glob1@PCREL+562536(0), 1
; CHECK-P10-NEXT:    xxlxor vs1, vs1, vs1
; CHECK-P10-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P10-NEXT:    xvcvspdp vs0, vs0
; CHECK-P10-NEXT:    xvcmpeqdp v2, vs1, vs0
; CHECK-P10-NEXT:    xxswapd v3, v2
; CHECK-P10-NEXT:    xxland vs0, v2, v3
; CHECK-P10-NEXT:    mfvsrld r3, vs0
; CHECK-P10-NEXT:    andi. r3, r3, 1
; CHECK-P10-NEXT:    bc 4, gt, .LBB5_2
; CHECK-P10-NEXT:  # %bb.1: # %bb8
; CHECK-P10-NEXT:  .LBB5_2: # %bb7
;
; CHECK-P10-BE-LABEL: test6:
; CHECK-P10-BE:       # %bb.0: # %bb
; CHECK-P10-BE-NEXT:    addis r3, r2, Glob1@toc@ha
; CHECK-P10-BE-NEXT:    xxlxor vs1, vs1, vs1
; CHECK-P10-BE-NEXT:    addi r3, r3, Glob1@toc@l
; CHECK-P10-BE-NEXT:    plfd f0, 562536(r3), 0
; CHECK-P10-BE-NEXT:    xxmrghw vs0, vs0, vs0
; CHECK-P10-BE-NEXT:    xvcvspdp vs0, vs0
; CHECK-P10-BE-NEXT:    xvcmpeqdp v2, vs1, vs0
; CHECK-P10-BE-NEXT:    xxswapd v3, v2
; CHECK-P10-BE-NEXT:    xxland vs0, v2, v3
; CHECK-P10-BE-NEXT:    mffprd r3, f0
; CHECK-P10-BE-NEXT:    andi. r3, r3, 1
; CHECK-P10-BE-NEXT:    bc 4, gt, .LBB5_2
; CHECK-P10-BE-NEXT:  # %bb.1: # %bb8
; CHECK-P10-BE-NEXT:  .LBB5_2: # %bb7
;
; AIX-64-LABEL: test6:
; AIX-64:       # %bb.0: # %bb
; AIX-64-NEXT:    ld r3, L..C1(r2) # @Glob1
; AIX-64-NEXT:    lis r4, 8
; AIX-64-NEXT:    xxlxor vs1, vs1, vs1
; AIX-64-NEXT:    ori r4, r4, 38248
; AIX-64-NEXT:    lfdx f0, r3, r4
; AIX-64-NEXT:    xxmrghw vs0, vs0, vs0
; AIX-64-NEXT:    xvcvspdp vs0, vs0
; AIX-64-NEXT:    xvcmpeqdp v2, vs1, vs0
; AIX-64-NEXT:    xxswapd v3, v2
; AIX-64-NEXT:    xxland vs0, v2, v3
; AIX-64-NEXT:    mffprd r3, f0
; AIX-64-NEXT:    andi. r3, r3, 1
; AIX-64-NEXT:    bc 4, gt, L..BB5_2
; AIX-64-NEXT:  # %bb.1: # %bb8
; AIX-64-NEXT:  L..BB5_2: # %bb7
;
; AIX-32-LABEL: test6:
; AIX-32:       # %bb.0: # %bb
; AIX-32-NEXT:    lwz r3, L..C4(r2) # @Glob1
; AIX-32-NEXT:    lis r4, 8
; AIX-32-NEXT:    ori r4, r4, 38248
; AIX-32-NEXT:    lfsux f0, r3, r4
; AIX-32-NEXT:    lfs f1, 4(r3)
; AIX-32-NEXT:    addi r3, r1, -16
; AIX-32-NEXT:    xxmrghd vs0, vs0, vs1
; AIX-32-NEXT:    xxlxor vs1, vs1, vs1
; AIX-32-NEXT:    xvcmpeqdp v2, vs1, vs0
; AIX-32-NEXT:    xxswapd v3, v2
; AIX-32-NEXT:    xxland vs0, v2, v3
; AIX-32-NEXT:    stxvw4x vs0, 0, r3
; AIX-32-NEXT:    lwz r3, -12(r1)
; AIX-32-NEXT:    andi. r3, r3, 1
; AIX-32-NEXT:    bc 4, gt, L..BB5_2
; AIX-32-NEXT:  # %bb.1: # %bb8
; AIX-32-NEXT:  L..BB5_2: # %bb7
bb:
  br label %bb1

bb1:                                              ; preds = %bb
  %i = load <2 x float>, <2 x float>* bitcast (i8* getelementptr inbounds ([25 x %0], [25 x %0]* @Glob1, i64 0, i64 6, i32 20, i64 22392) to <2 x float>*), align 8
  %i2 = fpext <2 x float> %i to <2 x double>
  %i3 = fcmp contract oeq <2 x double> zeroinitializer, %i2
  %i4 = shufflevector <2 x i1> %i3, <2 x i1> poison, <2 x i32> <i32 1, i32 undef>
  %i5 = and <2 x i1> %i3, %i4
  %i6 = extractelement <2 x i1> %i5, i32 0
  br i1 %i6, label %bb8, label %bb7

bb7:                                              ; preds = %bb1
  unreachable

bb8:                                              ; preds = %bb1
  unreachable
}
