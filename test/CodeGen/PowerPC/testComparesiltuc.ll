; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE

@glob = dso_local local_unnamed_addr global i8 0, align 1

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @test_iltuc(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_iltuc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ult i8 %a, %b
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @test_iltuc_sext(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_iltuc_sext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ult i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

; Function Attrs: norecurse nounwind
define dso_local void @test_iltuc_store(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_iltuc_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    stb r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ult i8 %a, %b
  %conv3 = zext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}

; Function Attrs: norecurse nounwind
define dso_local void @test_iltuc_sext_store(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: test_iltuc_sext_store:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    addis r5, r2, glob@toc@ha
; CHECK-NEXT:    sradi r3, r3, 63
; CHECK-NEXT:    stb r3, glob@toc@l(r5)
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ult i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @glob, align 1
  ret void
}
