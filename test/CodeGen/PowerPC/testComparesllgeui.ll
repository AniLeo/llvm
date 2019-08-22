; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = common local_unnamed_addr global i32 0, align 4

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeui(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: test_llgeui:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    not r3, r3
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeui_sext(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: test_llgeui_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    addi r3, r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeui_z(i32 zeroext %a) {
; CHECK-LABEL: test_llgeui_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, 1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, 0
  %conv1 = zext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_llgeui_sext_z(i32 zeroext %a) {
; CHECK-LABEL: test_llgeui_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li r3, -1
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, 0
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

; Function Attrs: norecurse nounwind
define void @test_llgeui_store(i32 zeroext %a, i32 zeroext %b) {
; BE-LABEL: test_llgeui_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    not r3, r3
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    stw r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeui_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    not r3, r3
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    stw r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %conv = zext i1 %cmp to i32
  store i32 %conv, i32* @glob
  ret void
; CHECK_LABEL: test_igeuc_store:
}

; Function Attrs: norecurse nounwind
define void @test_llgeui_sext_store(i32 zeroext %a, i32 zeroext %b) {
; BE-LABEL: test_llgeui_sext_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r5, r2, .LC0@toc@ha
; BE-NEXT:    sub r3, r3, r4
; BE-NEXT:    ld r4, .LC0@toc@l(r5)
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    addi r3, r3, -1
; BE-NEXT:    stw r3, 0(r4)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeui_sext_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    sub r3, r3, r4
; LE-NEXT:    addis r5, r2, glob@toc@ha
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    addi r3, r3, -1
; LE-NEXT:    stw r3, glob@toc@l(r5)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeui_z_store(i32 zeroext %a) {
; BE-LABEL: test_llgeui_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, 1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    stw r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeui_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, 1
; LE-NEXT:    stw r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, 0
  %sub = zext i1 %cmp to i32
  store i32 %sub, i32* @glob
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_llgeui_sext_z_store(i32 zeroext %a) {
; BE-LABEL: test_llgeui_sext_z_store:
; BE:       # %bb.0: # %entry
; BE-NEXT:    addis r3, r2, .LC0@toc@ha
; BE-NEXT:    li r4, -1
; BE-NEXT:    ld r3, .LC0@toc@l(r3)
; BE-NEXT:    stw r4, 0(r3)
; BE-NEXT:    blr
;
; LE-LABEL: test_llgeui_sext_z_store:
; LE:       # %bb.0: # %entry
; LE-NEXT:    addis r3, r2, glob@toc@ha
; LE-NEXT:    li r4, -1
; LE-NEXT:    stw r4, glob@toc@l(r3)
; LE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, 0
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @glob
  ret void
}

