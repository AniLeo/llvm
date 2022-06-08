; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown -ppc-vsr-nums-as-vr \
; RUN:   -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown -ppc-vsr-nums-as-vr \
; RUN:   -verify-machineinstrs < %s | FileCheck -check-prefix=CHECK-PWR8 %s

; ==========================================
; Tests for store of fp_to_sint converstions
; ==========================================

; Function Attrs: norecurse nounwind
define void @qpConv2sdw(fp128* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: qpConv2sdw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv 2, 0(3)
; CHECK-NEXT:    xscvqpsdz 2, 2
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: qpConv2sdw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    mflr 0
; CHECK-PWR8-NEXT:    .cfi_def_cfa_offset 48
; CHECK-PWR8-NEXT:    .cfi_offset lr, 16
; CHECK-PWR8-NEXT:    .cfi_offset r30, -16
; CHECK-PWR8-NEXT:    std 30, -16(1) # 8-byte Folded Spill
; CHECK-PWR8-NEXT:    std 0, 16(1)
; CHECK-PWR8-NEXT:    stdu 1, -48(1)
; CHECK-PWR8-NEXT:    lxvd2x 0, 0, 3
; CHECK-PWR8-NEXT:    mr 30, 4
; CHECK-PWR8-NEXT:    xxswapd 2, 0
; CHECK-PWR8-NEXT:    bl __fixkfdi
; CHECK-PWR8-NEXT:    nop
; CHECK-PWR8-NEXT:    std 3, 0(30)
; CHECK-PWR8-NEXT:    addi 1, 1, 48
; CHECK-PWR8-NEXT:    ld 0, 16(1)
; CHECK-PWR8-NEXT:    ld 30, -16(1) # 8-byte Folded Reload
; CHECK-PWR8-NEXT:    mtlr 0
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load fp128, fp128* %a, align 16
  %conv = fptosi fp128 %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @qpConv2sw(fp128* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: qpConv2sw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv 2, 0(3)
; CHECK-NEXT:    xscvqpswz 2, 2
; CHECK-NEXT:    stxsiwx 2, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: qpConv2sw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    mflr 0
; CHECK-PWR8-NEXT:    .cfi_def_cfa_offset 48
; CHECK-PWR8-NEXT:    .cfi_offset lr, 16
; CHECK-PWR8-NEXT:    .cfi_offset r30, -16
; CHECK-PWR8-NEXT:    std 30, -16(1) # 8-byte Folded Spill
; CHECK-PWR8-NEXT:    std 0, 16(1)
; CHECK-PWR8-NEXT:    stdu 1, -48(1)
; CHECK-PWR8-NEXT:    lxvd2x 0, 0, 3
; CHECK-PWR8-NEXT:    mr 30, 4
; CHECK-PWR8-NEXT:    xxswapd 2, 0
; CHECK-PWR8-NEXT:    bl __fixkfsi
; CHECK-PWR8-NEXT:    nop
; CHECK-PWR8-NEXT:    stw 3, 0(30)
; CHECK-PWR8-NEXT:    addi 1, 1, 48
; CHECK-PWR8-NEXT:    ld 0, 16(1)
; CHECK-PWR8-NEXT:    ld 30, -16(1) # 8-byte Folded Reload
; CHECK-PWR8-NEXT:    mtlr 0
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load fp128, fp128* %a, align 16
  %conv = fptosi fp128 %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @qpConv2udw(fp128* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: qpConv2udw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv 2, 0(3)
; CHECK-NEXT:    xscvqpudz 2, 2
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: qpConv2udw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    mflr 0
; CHECK-PWR8-NEXT:    .cfi_def_cfa_offset 48
; CHECK-PWR8-NEXT:    .cfi_offset lr, 16
; CHECK-PWR8-NEXT:    .cfi_offset r30, -16
; CHECK-PWR8-NEXT:    std 30, -16(1) # 8-byte Folded Spill
; CHECK-PWR8-NEXT:    std 0, 16(1)
; CHECK-PWR8-NEXT:    stdu 1, -48(1)
; CHECK-PWR8-NEXT:    lxvd2x 0, 0, 3
; CHECK-PWR8-NEXT:    mr 30, 4
; CHECK-PWR8-NEXT:    xxswapd 2, 0
; CHECK-PWR8-NEXT:    bl __fixunskfdi
; CHECK-PWR8-NEXT:    nop
; CHECK-PWR8-NEXT:    std 3, 0(30)
; CHECK-PWR8-NEXT:    addi 1, 1, 48
; CHECK-PWR8-NEXT:    ld 0, 16(1)
; CHECK-PWR8-NEXT:    ld 30, -16(1) # 8-byte Folded Reload
; CHECK-PWR8-NEXT:    mtlr 0
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load fp128, fp128* %a, align 16
  %conv = fptoui fp128 %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @qpConv2uw(fp128* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: qpConv2uw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lxv 2, 0(3)
; CHECK-NEXT:    xscvqpuwz 2, 2
; CHECK-NEXT:    stxsiwx 2, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: qpConv2uw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    mflr 0
; CHECK-PWR8-NEXT:    .cfi_def_cfa_offset 48
; CHECK-PWR8-NEXT:    .cfi_offset lr, 16
; CHECK-PWR8-NEXT:    .cfi_offset r30, -16
; CHECK-PWR8-NEXT:    std 30, -16(1) # 8-byte Folded Spill
; CHECK-PWR8-NEXT:    std 0, 16(1)
; CHECK-PWR8-NEXT:    stdu 1, -48(1)
; CHECK-PWR8-NEXT:    lxvd2x 0, 0, 3
; CHECK-PWR8-NEXT:    mr 30, 4
; CHECK-PWR8-NEXT:    xxswapd 2, 0
; CHECK-PWR8-NEXT:    bl __fixunskfsi
; CHECK-PWR8-NEXT:    nop
; CHECK-PWR8-NEXT:    stw 3, 0(30)
; CHECK-PWR8-NEXT:    addi 1, 1, 48
; CHECK-PWR8-NEXT:    ld 0, 16(1)
; CHECK-PWR8-NEXT:    ld 30, -16(1) # 8-byte Folded Reload
; CHECK-PWR8-NEXT:    mtlr 0
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load fp128, fp128* %a, align 16
  %conv = fptoui fp128 %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sdw(double* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: dpConv2sdw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpsxds 2, 0
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sdw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sw(double* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: dpConv2sw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stfiwx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2shw(double* nocapture readonly %a, i16* nocapture %b) {
; CHECK-LABEL: dpConv2shw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsihx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2shw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sth 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i16
  store i16 %conv, i16* %b, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sb(double* nocapture readonly %a, i8* nocapture %b) {
; CHECK-LABEL: dpConv2sb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsibx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sb:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stb 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i8
  store i8 %conv, i8* %b, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sdw(float* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: spConv2sdw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxds 2, 0
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sdw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sw(float* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: spConv2sw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stfiwx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2shw(float* nocapture readonly %a, i16* nocapture %b) {
; CHECK-LABEL: spConv2shw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsihx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2shw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sth 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i16
  store i16 %conv, i16* %b, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sb(float* nocapture readonly %a, i8* nocapture %b) {
; CHECK-LABEL: spConv2sb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsibx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sb:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stb 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i8
  store i8 %conv, i8* %b, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sdw_x(double* nocapture readonly %a, i64* nocapture %b,
; CHECK-LABEL: dpConv2sdw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 3
; CHECK-NEXT:    xscvdpsxds 0, 0
; CHECK-NEXT:    stxsdx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sdw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 3
; CHECK-PWR8-NEXT:    xscvdpsxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i64
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sw_x(double* nocapture readonly %a, i32* nocapture %b,
; CHECK-LABEL: dpConv2sw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 2
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stfiwx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 2
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i32
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i32, i32* %b, i64 %idxprom
  store i32 %conv, i32* %arrayidx, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2shw_x(double* nocapture readonly %a, i16* nocapture %b,
; CHECK-LABEL: dpConv2shw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 1
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsihx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2shw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 5, 5, 1
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sthx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i16
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i16, i16* %b, i64 %idxprom
  store i16 %conv, i16* %arrayidx, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2sb_x(double* nocapture readonly %a, i8* nocapture %b,
; CHECK-LABEL: dpConv2sb_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsibx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2sb_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stbx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptosi double %0 to i8
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i8, i8* %b, i64 %idxprom
  store i8 %conv, i8* %arrayidx, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sdw_x(float* nocapture readonly %a, i64* nocapture %b,
; CHECK-LABEL: spConv2sdw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxds 0, 0
; CHECK-NEXT:    sldi 5, 5, 3
; CHECK-NEXT:    stxsdx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sdw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 3
; CHECK-PWR8-NEXT:    xscvdpsxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i64
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sw_x(float* nocapture readonly %a, i32* nocapture %b,
; CHECK-LABEL: spConv2sw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    sldi 5, 5, 2
; CHECK-NEXT:    stfiwx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 2
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i32
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i32, i32* %b, i64 %idxprom
  store i32 %conv, i32* %arrayidx, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2shw_x(float* nocapture readonly %a, i16* nocapture %b,
; CHECK-LABEL: spConv2shw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    sldi 5, 5, 1
; CHECK-NEXT:    stxsihx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2shw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 5, 5, 1
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sthx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i16
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i16, i16* %b, i64 %idxprom
  store i16 %conv, i16* %arrayidx, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2sb_x(float* nocapture readonly %a, i8* nocapture %b,
; CHECK-LABEL: spConv2sb_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpsxws 0, 0
; CHECK-NEXT:    stxsibx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2sb_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stbx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 signext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptosi float %0 to i8
  %idxprom = sext i32 %idx to i64
  %arrayidx = getelementptr inbounds i8, i8* %b, i64 %idxprom
  store i8 %conv, i8* %arrayidx, align 1
  ret void


}

; ==========================================
; Tests for store of fp_to_uint converstions
; ==========================================

; Function Attrs: norecurse nounwind
define void @dpConv2udw(double* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: dpConv2udw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpuxds 2, 0
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2udw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpuxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2uw(double* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: dpConv2uw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stfiwx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2uw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpuxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2uhw(double* nocapture readonly %a, i16* nocapture %b) {
; CHECK-LABEL: dpConv2uhw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsihx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2uhw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sth 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i16
  store i16 %conv, i16* %b, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2ub(double* nocapture readonly %a, i8* nocapture %b) {
; CHECK-LABEL: dpConv2ub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsibx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2ub:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stb 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i8
  store i8 %conv, i8* %b, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2udw(float* nocapture readonly %a, i64* nocapture %b) {
; CHECK-LABEL: spConv2udw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxds 2, 0
; CHECK-NEXT:    stxsd 2, 0(4)
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2udw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpuxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i64
  store i64 %conv, i64* %b, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2uw(float* nocapture readonly %a, i32* nocapture %b) {
; CHECK-LABEL: spConv2uw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stfiwx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2uw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpuxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 0, 4
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i32
  store i32 %conv, i32* %b, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2uhw(float* nocapture readonly %a, i16* nocapture %b) {
; CHECK-LABEL: spConv2uhw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsihx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2uhw:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sth 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i16
  store i16 %conv, i16* %b, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2ub(float* nocapture readonly %a, i8* nocapture %b) {
; CHECK-LABEL: spConv2ub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsibx 0, 0, 4
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2ub:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stb 3, 0(4)
; CHECK-PWR8-NEXT:    blr
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i8
  store i8 %conv, i8* %b, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2udw_x(double* nocapture readonly %a, i64* nocapture %b,
; CHECK-LABEL: dpConv2udw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 3
; CHECK-NEXT:    xscvdpuxds 0, 0
; CHECK-NEXT:    stxsdx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2udw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 3
; CHECK-PWR8-NEXT:    xscvdpuxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i64
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2uw_x(double* nocapture readonly %a, i32* nocapture %b,
; CHECK-LABEL: dpConv2uw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 2
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stfiwx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2uw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 2
; CHECK-PWR8-NEXT:    xscvdpuxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i32
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i32, i32* %b, i64 %idxprom
  store i32 %conv, i32* %arrayidx, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2uhw_x(double* nocapture readonly %a, i16* nocapture %b,
; CHECK-LABEL: dpConv2uhw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    sldi 3, 5, 1
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsihx 0, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2uhw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 5, 5, 1
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sthx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i16
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i16, i16* %b, i64 %idxprom
  store i16 %conv, i16* %arrayidx, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @dpConv2ub_x(double* nocapture readonly %a, i8* nocapture %b,
; CHECK-LABEL: dpConv2ub_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfd 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsibx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: dpConv2ub_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfd 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stbx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load double, double* %a, align 8
  %conv = fptoui double %0 to i8
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i8, i8* %b, i64 %idxprom
  store i8 %conv, i8* %arrayidx, align 1
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2udw_x(float* nocapture readonly %a, i64* nocapture %b,
; CHECK-LABEL: spConv2udw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxds 0, 0
; CHECK-NEXT:    sldi 5, 5, 3
; CHECK-NEXT:    stxsdx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2udw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 3
; CHECK-PWR8-NEXT:    xscvdpuxds 0, 0
; CHECK-PWR8-NEXT:    stxsdx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i64
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i64, i64* %b, i64 %idxprom
  store i64 %conv, i64* %arrayidx, align 8
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2uw_x(float* nocapture readonly %a, i32* nocapture %b,
; CHECK-LABEL: spConv2uw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    sldi 5, 5, 2
; CHECK-NEXT:    stfiwx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2uw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 3, 5, 2
; CHECK-PWR8-NEXT:    xscvdpuxws 0, 0
; CHECK-PWR8-NEXT:    stfiwx 0, 4, 3
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i32
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i32, i32* %b, i64 %idxprom
  store i32 %conv, i32* %arrayidx, align 4
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2uhw_x(float* nocapture readonly %a, i16* nocapture %b,
; CHECK-LABEL: spConv2uhw_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    sldi 5, 5, 1
; CHECK-NEXT:    stxsihx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2uhw_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    sldi 5, 5, 1
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    sthx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i16
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i16, i16* %b, i64 %idxprom
  store i16 %conv, i16* %arrayidx, align 2
  ret void


}

; Function Attrs: norecurse nounwind
define void @spConv2ub_x(float* nocapture readonly %a, i8* nocapture %b,
; CHECK-LABEL: spConv2ub_x:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lfs 0, 0(3)
; CHECK-NEXT:    xscvdpuxws 0, 0
; CHECK-NEXT:    stxsibx 0, 4, 5
; CHECK-NEXT:    blr
;
; CHECK-PWR8-LABEL: spConv2ub_x:
; CHECK-PWR8:       # %bb.0: # %entry
; CHECK-PWR8-NEXT:    lfs 0, 0(3)
; CHECK-PWR8-NEXT:    xscvdpsxws 0, 0
; CHECK-PWR8-NEXT:    mffprwz 3, 0
; CHECK-PWR8-NEXT:    stbx 3, 4, 5
; CHECK-PWR8-NEXT:    blr
                          i32 zeroext %idx) {
entry:
  %0 = load float, float* %a, align 4
  %conv = fptoui float %0 to i8
  %idxprom = zext i32 %idx to i64
  %arrayidx = getelementptr inbounds i8, i8* %b, i64 %idxprom
  store i8 %conv, i8* %arrayidx, align 1
  ret void


}
