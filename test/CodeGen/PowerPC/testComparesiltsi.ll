; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl

@glob = dso_local local_unnamed_addr global i32 0, align 4

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @test_iltsi(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: test_iltsi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @test_iltsi_sext(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: test_iltsi_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @test_iltsi_sext_z(i32 signext %a) {
; CHECK-LABEL: test_iltsi_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    srawi r3, r3, 31
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define dso_local void @test_iltsi_store(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: test_iltsi_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    stw r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, %b
  %conv = zext i1 %cmp to i32
  store i32 %conv, i32* @glob, align 4
  ret void
}

; Function Attrs: norecurse nounwind
define dso_local void @test_iltsi_sext_store(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: test_iltsi_sext_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    stw r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @glob, align 4
  ret void
}

; Function Attrs: norecurse nounwind
define dso_local void @test_iltsi_sext_z_store(i32 signext %a) {
; CHECK-LABEL: test_iltsi_sext_z_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis r4, r2, glob@toc@ha
; CHECK-NEXT:    srawi r3, r3, 31
; CHECK-NEXT:    stw r3, glob@toc@l(r4)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp slt i32 %a, 0
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @glob, align 4
  ret void
}
