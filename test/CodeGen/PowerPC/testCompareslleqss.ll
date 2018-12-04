; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-BE \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-LE \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl

@glob = common local_unnamed_addr global i16 0, align 2

; Function Attrs: norecurse nounwind readnone
define i64 @test_lleqss(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_lleqss:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xor r3, r3, r4
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xor r3, r3, r4
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, %b
  %conv3 = zext i1 %cmp to i64
  ret i64 %conv3
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lleqss_sext(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_lleqss_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_sext:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xor r3, r3, r4
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    neg r3, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_sext:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xor r3, r3, r4
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    neg r3, r3
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lleqss_z(i16 signext %a) {
; CHECK-LABEL: test_lleqss_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_z:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_z:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, 0
  %conv2 = zext i1 %cmp to i64
  ret i64 %conv2
}

; Function Attrs: norecurse nounwind readnone
define i64 @test_lleqss_sext_z(i16 signext %a) {
; CHECK-LABEL: test_lleqss_sext_z:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_sext_z:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    neg r3, r3
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_sext_z:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    neg r3, r3
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, 0
  %conv2 = sext i1 %cmp to i64
  ret i64 %conv2
}

; Function Attrs: norecurse nounwind
define void @test_lleqss_store(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_lleqss_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    sth r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_store:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r5, r2, .LC0@toc@ha
; CHECK-BE-NEXT:    xor r3, r3, r4
; CHECK-BE-NEXT:    ld r4, .LC0@toc@l(r5)
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    sth r3, 0(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_store:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xor r3, r3, r4
; CHECK-LE-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    sth r3, glob@toc@l(r5)
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, %b
  %conv3 = zext i1 %cmp to i16
  store i16 %conv3, i16* @glob, align 2
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lleqss_sext_store(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: test_lleqss_sext_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    sth r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_sext_store:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r5, r2, .LC0@toc@ha
; CHECK-BE-NEXT:    xor r3, r3, r4
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    ld r4, .LC0@toc@l(r5)
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    neg r3, r3
; CHECK-BE-NEXT:    sth r3, 0(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_sext_store:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    xor r3, r3, r4
; CHECK-LE-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    neg r3, r3
; CHECK-LE-NEXT:    sth r3, glob@toc@l(r5)
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @glob, align 2
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lleqss_z_store(i16 signext %a) {
; CHECK-LABEL: test_lleqss_z_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    addis r4, r2, glob@toc@ha
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    sth r3, glob@toc@l(r4)
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_z_store:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    sth r3, 0(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_z_store:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    addis r4, r2, glob@toc@ha
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    sth r3, glob@toc@l(r4)
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, 0
  %conv2 = zext i1 %cmp to i16
  store i16 %conv2, i16* @glob, align 2
  ret void
}

; Function Attrs: norecurse nounwind
define void @test_lleqss_sext_z_store(i16 signext %a) {
; CHECK-LABEL: test_lleqss_sext_z_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cntlzw r3, r3
; CHECK-NEXT:    addis r4, r2, glob@toc@ha
; CHECK-NEXT:    srwi r3, r3, 5
; CHECK-NEXT:    neg r3, r3
; CHECK-NEXT:    sth r3, glob@toc@l(r4)
; CHECK-NEXT:    blr
; CHECK-BE-LABEL: test_lleqss_sext_z_store:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r4, r2, .LC0@toc@ha
; CHECK-BE-NEXT:    cntlzw r3, r3
; CHECK-BE-NEXT:    ld r4, .LC0@toc@l(r4)
; CHECK-BE-NEXT:    srwi r3, r3, 5
; CHECK-BE-NEXT:    neg r3, r3
; CHECK-BE-NEXT:    sth r3, 0(r4)
; CHECK-BE-NEXT:    blr
;
; CHECK-LE-LABEL: test_lleqss_sext_z_store:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cntlzw r3, r3
; CHECK-LE-NEXT:    addis r4, r2, glob@toc@ha
; CHECK-LE-NEXT:    srwi r3, r3, 5
; CHECK-LE-NEXT:    neg r3, r3
; CHECK-LE-NEXT:    sth r3, glob@toc@l(r4)
; CHECK-LE-NEXT:    blr
entry:
  %cmp = icmp eq i16 %a, 0
  %conv2 = sext i1 %cmp to i16
  store i16 %conv2, i16* @glob, align 2
  ret void
}
