; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s \
; RUN:     --check-prefixes=CHECK,CHECK-LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | FileCheck %s \
; RUN:     --check-prefixes=CHECK,CHECK-BE

; This file does not contain many test cases involving comparisons and logical
; comparisons (cmplwi, cmpldi). This is because alternative code is generated
; when there is a compare (logical or not), followed by a sign or zero extend.
; This codegen will be re-evaluated at a later time on whether or not it should
; be emitted on P10.

@globalVal = common dso_local local_unnamed_addr global i8 0, align 1
@globalVal2 = common dso_local local_unnamed_addr global i32 0, align 4
@globalVal3 = common dso_local local_unnamed_addr global i64 0, align 8
@globalVal4 = common dso_local local_unnamed_addr global i16 0, align 2

define dso_local signext i32 @setnbcr1(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: setnbcr1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i32 %a, %b
  %lnot.ext = sext i1 %cmp to i32
  ret i32 %lnot.ext
}

define dso_local signext i32 @setnbcr2(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: setnbcr2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i32 %a, %b
  %lnot.ext = sext i1 %cmp to i32
  ret i32 %lnot.ext
}

define dso_local signext i32 @setnbcr3(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: setnbcr3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i32 %a, %b
  %lnot.ext = sext i1 %cmp to i32
  ret i32 %lnot.ext
}

define dso_local signext i32 @setnbcr4(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: setnbcr4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i8 %a, %b
  %conv = sext i1 %cmp to i32
  ret i32 %conv
}

define dso_local void @setnbcr5(i8 signext %a, i8 signext %b) {
; CHECK-LE-LABEL: setnbcr5:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr5:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define dso_local void @setnbcr6(i32 signext %a, i32 signext %b) {
; CHECK-LE-LABEL: setnbcr6:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr6:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2, align 4
  ret void
}

define dso_local signext i32 @setnbcr7(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i64 %a, %b
  %conv = sext i1 %cmp to i32
  ret i32 %conv
}

define signext i64 @setnbcr8(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i64 %a, %b
  %conv = sext i1 %cmp to i64
  ret i64 %conv
}

define dso_local void @setnbcr9(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr9:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr9:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

define dso_local signext i32 @setnbcr10(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: setnbcr10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr11(i16 signext %a, i16 signext %b) {
; CHECK-LE-LABEL: setnbcr11:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr11:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define dso_local signext i32 @setnbcr12(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: setnbcr12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr13(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LE-LABEL: setnbcr13:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr13:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal
  ret void
}

define dso_local signext i32 @setnbcr14(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: setnbcr14:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr15(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LE-LABEL: setnbcr15:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr15:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2
  ret void
}

define dso_local signext i32 @setnbcr16(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpld r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr17(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr17:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpld r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr17:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpld r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3
  ret void
}

define dso_local signext i32 @setnbcr18(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: setnbcr18:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr19(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LE-LABEL: setnbcr19:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr19:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4
  ret void
}

define dso_local signext i32 @setnbcr20(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: setnbcr20:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr21(i8 signext %a, i8 signext %b) {
; CHECK-LE-LABEL: setnbcr21:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr21:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define dso_local signext i32 @setnbcr22(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: setnbcr22:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i32 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr23(i32 signext %a, i32 signext %b) {
; CHECK-LE-LABEL: setnbcr23:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr23:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2, align 4
  ret void
}

define dso_local signext i32 @setnbcr24(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr24:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr25(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr25:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr25:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

define dso_local signext i32 @setnbcr26(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: setnbcr26:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr27(i16 signext %a, i16 signext %b) {
; CHECK-LE-LABEL: setnbcr27:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr27:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define dso_local signext i32 @setnbcr28(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: setnbcr28:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr29(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LE-LABEL: setnbcr29:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr29:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal
  ret void
}

define dso_local signext i32 @setnbcr30(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: setnbcr30:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i32 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr31(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LE-LABEL: setnbcr31:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr31:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2
  ret void
}

define dso_local signext i32 @setnbcr32(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpld r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i64 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr33(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr33:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpld r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr33:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpld r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3
  ret void
}

define dso_local signext i32 @setnbcr34(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: setnbcr34:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr35(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LE-LABEL: setnbcr35:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr35:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4
  ret void
}

define dso_local signext i32 @setnbcr36(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: setnbcr36:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr37(i8 signext %a, i8 signext %b) {
; CHECK-LE-LABEL: setnbcr37:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr37:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define dso_local void @setnbcr38(i32 signext %a, i32 signext %b) {
; CHECK-LE-LABEL: setnbcr38:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr38:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2, align 4
  ret void
}

define dso_local signext i32 @setnbcr39(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr39:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr40(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr40:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr40:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

define dso_local signext i32 @setnbcr41(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: setnbcr41:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr42(i16 signext %a, i16 signext %b) {
; CHECK-LE-LABEL: setnbcr42:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr42:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define dso_local signext i32 @setnbcr43(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: setnbcr43:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @sernbcr44(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LE-LABEL: sernbcr44:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: sernbcr44:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define dso_local signext i32 @setnbcr45(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: setnbcr45:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i32 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr46(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LE-LABEL: setnbcr46:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr46:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i32 %a, %b
  %conv = sext i1 %cmp to i32
  store i32 %conv, i32* @globalVal2, align 4
  ret void
}

define dso_local signext i32 @setnbcr47(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: setnbcr47:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i16 %a, %b
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define dso_local void @setnbcr48(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LE-LABEL: setnbcr48:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr48:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define i64 @setnbcr49(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: setnbcr49:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i8 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr50(i8 signext %a, i8 signext %b) {
; CHECK-LE-LABEL: setnbcr50:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr50:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define i64 @setnbcr51(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: setnbcr51:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i32 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr52(i32 signext %a, i32 signext %b) {
; CHECK-LE-LABEL: setnbcr52:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr52:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2, align 4
  ret void
}

define i64 @setnbcr53(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr53:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr54(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr54:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr54:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

define i64 @setnbcr55(i16 signext %a, i16 signext %b) {
; CHECK-LABEL: setnbcr55:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sge i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr56(i16 signext %a, i16 signext %b) {
; CHECK-LE-LABEL: setnbcr56:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr56:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sge i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define i64 @setnbcr57(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: setnbcr57:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i8 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr58(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LE-LABEL: setnbcr58:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr58:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal
  ret void
}

define i64 @setnbcr59(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: setnbcr59:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr60(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LE-LABEL: setnbcr60:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr60:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2
  ret void
}

define i64 @setnbcr61(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr61:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpld r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr62(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr62:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpld r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr62:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpld r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3
  ret void
}

define i64 @setnbcr63(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: setnbcr63:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, lt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr64(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LE-LABEL: setnbcr64:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, lt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr64:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, lt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp uge i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4
  ret void
}

define i64 @setnbcr65(i8 signext %a, i8 signext %b) {
; CHECK-LABEL: setnbcr65:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i8 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr66(i8 signext %a, i8 signext %b) {
; CHECK-LE-LABEL: setnbcr66:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr66:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal, align 1
  ret void
}

define i64 @setnbcr67(i32 signext %a, i32 signext %b)  {
; CHECK-LABEL: setnbcr67:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i32 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr68(i32 signext %a, i32 signext %b) {
; CHECK-LE-LABEL: setnbcr68:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr68:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2, align 4
  ret void
}

define i64 @setnbcr69(i64 %a, i64 %b)  {
; CHECK-LABEL: setnbcr69:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr70(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr70:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr70:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

define i64 @setnbcr71(i16 signext %a, i16 signext %b)  {
; CHECK-LABEL: setnbcr71:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp sle i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr72(i16 signext %a, i16 signext %b) {
; CHECK-LE-LABEL: setnbcr72:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr72:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp sle i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4, align 2
  ret void
}

define i64 @setnbcr73(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: setnbcr73:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr74(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LE-LABEL: setnbcr74:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstb r3, globalVal@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr74:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stb r3, globalVal@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i8 %a, %b
  %conv3 = sext i1 %cmp to i8
  store i8 %conv3, i8* @globalVal
  ret void
}

define i64 @setnbcr75(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: setnbcr75:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i32 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr76(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LE-LABEL: setnbcr76:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstw r3, globalVal2@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr76:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal2@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    stw r3, globalVal2@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i32 %a, %b
  %sub = sext i1 %cmp to i32
  store i32 %sub, i32* @globalVal2
  ret void
}

define i64 @setnbcr77(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr77:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpld r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr78(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr78:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpld r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr78:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpld r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3
  ret void
}

define i64 @setnbcr79(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: setnbcr79:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplw r3, r4
; CHECK-NEXT:    setnbcr r3, gt
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ule i16 %a, %b
  %conv3 = sext i1 %cmp to i64
  ret i64 %conv3
}

define dso_local void @setnbcr80(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LE-LABEL: setnbcr80:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmplw r3, r4
; CHECK-LE-NEXT:    setnbcr r3, gt
; CHECK-LE-NEXT:    psth r3, globalVal4@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr80:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmplw r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal4@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, gt
; CHECK-BE-NEXT:    sth r3, globalVal4@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ule i16 %a, %b
  %conv3 = sext i1 %cmp to i16
  store i16 %conv3, i16* @globalVal4
  ret void
}

define i64 @setnbcr81(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr81:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define i64 @setnbcr82(i64 %a, i64 %b) {
; CHECK-LABEL: setnbcr82:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd r3, r4
; CHECK-NEXT:    setnbcr r3, eq
; CHECK-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define dso_local void @setnbcr83(i64 %a, i64 %b) {
; CHECK-LE-LABEL: setnbcr83:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    cmpd r3, r4
; CHECK-LE-NEXT:    setnbcr r3, eq
; CHECK-LE-NEXT:    pstd r3, globalVal3@PCREL(0), 1
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: setnbcr83:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    cmpd r3, r4
; CHECK-BE-NEXT:    addis r4, r2, globalVal3@toc@ha
; CHECK-BE-NEXT:    setnbcr r3, eq
; CHECK-BE-NEXT:    std r3, globalVal3@toc@l(r4)
; CHECK-BE-NEXT:    blr
entry:
  %cmp = icmp ne i64 %a, %b
  %conv1 = sext i1 %cmp to i64
  store i64 %conv1, i64* @globalVal3, align 8
  ret void
}

