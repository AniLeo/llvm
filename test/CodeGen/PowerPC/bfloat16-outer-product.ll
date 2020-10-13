; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names \
; RUN:   -ppc-vsr-nums-as-vr < %s | FileCheck %s --check-prefix=CHECK-BE

; Function Attrs: nofree nounwind writeonly
define dso_local void @test50(i8* nocapture readnone %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test50:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvbf16ger2 acc0, v2, v2
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test50:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvbf16ger2 acc0, v2, v2
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = tail call <512 x i1> @llvm.ppc.mma.xvbf16ger2(<16 x i8> %vc, <16 x i8> %vc)
  %1 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %0, <512 x i1>* %1, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.xvbf16ger2(<16 x i8>, <16 x i8>)

; Function Attrs: nofree nounwind writeonly
define dso_local void @test51(i8* nocapture readnone %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test51:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pmxvbf16ger2 acc0, v2, v2, 0, 0, 0
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test51:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    pmxvbf16ger2 acc0, v2, v2, 0, 0, 0
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = tail call <512 x i1> @llvm.ppc.mma.pmxvbf16ger2(<16 x i8> %vc, <16 x i8> %vc, i32 0, i32 0, i32 0)
  %1 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %0, <512 x i1>* %1, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.pmxvbf16ger2(<16 x i8>, <16 x i8>, i32, i32, i32)

; Function Attrs: nofree nounwind
define dso_local void @test52(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test52:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    xvbf16ger2pp acc0, v2, v2
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test52:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    xvbf16ger2pp acc0, v2, v2
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.xvbf16ger2pp(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.xvbf16ger2pp(<512 x i1>, <16 x i8>, <16 x i8>)

; Function Attrs: nofree nounwind
define dso_local void @test53(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test53:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    xvbf16ger2pn acc0, v2, v2
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test53:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    xvbf16ger2pn acc0, v2, v2
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.xvbf16ger2pn(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.xvbf16ger2pn(<512 x i1>, <16 x i8>, <16 x i8>)

; Function Attrs: nofree nounwind
define dso_local void @test54(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test54:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    xvbf16ger2np acc0, v2, v2
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test54:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    xvbf16ger2np acc0, v2, v2
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.xvbf16ger2np(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.xvbf16ger2np(<512 x i1>, <16 x i8>, <16 x i8>)

; Function Attrs: nofree nounwind
define dso_local void @test55(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test55:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    xvbf16ger2nn acc0, v2, v2
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test55:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    xvbf16ger2nn acc0, v2, v2
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.xvbf16ger2nn(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.xvbf16ger2nn(<512 x i1>, <16 x i8>, <16 x i8>)

; Function Attrs: nofree nounwind
define dso_local void @test56(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test56:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    pmxvbf16ger2pp acc0, v2, v2, 0, 0, 0
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test56:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    pmxvbf16ger2pp acc0, v2, v2, 0, 0, 0
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.pmxvbf16ger2pp(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc, i32 0, i32 0, i32 0)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.pmxvbf16ger2pp(<512 x i1>, <16 x i8>, <16 x i8>, i32, i32, i32)

; Function Attrs: nofree nounwind
define dso_local void @test57(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test57:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    pmxvbf16ger2pn acc0, v2, v2, 0, 0, 0
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test57:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    pmxvbf16ger2pn acc0, v2, v2, 0, 0, 0
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.pmxvbf16ger2pn(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc, i32 0, i32 0, i32 0)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.pmxvbf16ger2pn(<512 x i1>, <16 x i8>, <16 x i8>, i32, i32, i32)

; Function Attrs: nofree nounwind
define dso_local void @test58(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test58:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    pmxvbf16ger2np acc0, v2, v2, 0, 0, 0
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test58:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    pmxvbf16ger2np acc0, v2, v2, 0, 0, 0
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.pmxvbf16ger2np(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc, i32 0, i32 0, i32 0)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.pmxvbf16ger2np(<512 x i1>, <16 x i8>, <16 x i8>, i32, i32, i32)

; Function Attrs: nofree nounwind
define dso_local void @test59(i8* nocapture readonly %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test59:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv vs1, 32(r3)
; CHECK-NEXT:    lxv vs0, 48(r3)
; CHECK-NEXT:    lxv vs3, 0(r3)
; CHECK-NEXT:    lxv vs2, 16(r3)
; CHECK-NEXT:    xxmtacc acc0
; CHECK-NEXT:    pmxvbf16ger2nn acc0, v2, v2, 0, 0, 0
; CHECK-NEXT:    xxmfacc acc0
; CHECK-NEXT:    stxv vs0, 48(r7)
; CHECK-NEXT:    stxv vs1, 32(r7)
; CHECK-NEXT:    stxv vs2, 16(r7)
; CHECK-NEXT:    stxv vs3, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test59:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs1, 16(r3)
; CHECK-BE-NEXT:    lxv vs0, 0(r3)
; CHECK-BE-NEXT:    lxv vs3, 48(r3)
; CHECK-BE-NEXT:    lxv vs2, 32(r3)
; CHECK-BE-NEXT:    xxmtacc acc0
; CHECK-BE-NEXT:    pmxvbf16ger2nn acc0, v2, v2, 0, 0, 0
; CHECK-BE-NEXT:    xxmfacc acc0
; CHECK-BE-NEXT:    stxv vs1, 16(r7)
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    stxv vs3, 48(r7)
; CHECK-BE-NEXT:    stxv vs2, 32(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i8* %vqp to <512 x i1>*
  %1 = load <512 x i1>, <512 x i1>* %0, align 64
  %2 = tail call <512 x i1> @llvm.ppc.mma.pmxvbf16ger2nn(<512 x i1> %1, <16 x i8> %vc, <16 x i8> %vc, i32 0, i32 0, i32 0)
  %3 = bitcast i8* %resp to <512 x i1>*
  store <512 x i1> %2, <512 x i1>* %3, align 64
  ret void
}

; Function Attrs: nounwind readnone
declare <512 x i1> @llvm.ppc.mma.pmxvbf16ger2nn(<512 x i1>, <16 x i8>, <16 x i8>, i32, i32, i32)

; Function Attrs: nofree nounwind writeonly
define dso_local void @test60(i8* nocapture readnone %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test60:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvcvspbf16 vs0, v2
; CHECK-NEXT:    stxv vs0, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test60:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvspbf16 vs0, v2
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = tail call <16 x i8> @llvm.ppc.vsx.xvcvspbf16(<16 x i8> %vc)
  %1 = bitcast i8* %resp to <16 x i8>*
  store <16 x i8> %0, <16 x i8>* %1, align 16
  ret void
}

; Function Attrs: nounwind readnone
declare <16 x i8> @llvm.ppc.vsx.xvcvspbf16(<16 x i8>)

; Function Attrs: nofree nounwind writeonly
define dso_local void @test61(i8* nocapture readnone %vqp, i8* nocapture readnone %vpp, <16 x i8> %vc, i8* nocapture %resp) {
; CHECK-LABEL: test61:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvcvbf16spn vs0, v2
; CHECK-NEXT:    stxv vs0, 0(r7)
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test61:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvbf16spn vs0, v2
; CHECK-BE-NEXT:    stxv vs0, 0(r7)
; CHECK-BE-NEXT:    blr
entry:
  %0 = tail call <16 x i8> @llvm.ppc.vsx.xvcvbf16spn(<16 x i8> %vc)
  %1 = bitcast i8* %resp to <16 x i8>*
  store <16 x i8> %0, <16 x i8>* %1, align 16
  ret void
}

; Function Attrs: nounwind readnone
declare <16 x i8> @llvm.ppc.vsx.xvcvbf16spn(<16 x i8>)
