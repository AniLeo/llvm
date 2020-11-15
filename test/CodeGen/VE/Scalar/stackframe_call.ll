; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=ve | FileCheck %s
; RUN: llc < %s -mtriple=ve -relocation-model=pic | FileCheck %s --check-prefix=PIC

;; Check stack frame allocation of a function which calls other functions

; Function Attrs: norecurse nounwind readnone
define signext i32 @test_frame0(i32 signext %0) {
; CHECK-LABEL: test_frame0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    adds.w.sx %s0, 3, %s0
; CHECK-NEXT:    adds.w.sx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame0:
; PIC:       # %bb.0:
; PIC-NEXT:    adds.w.sx %s0, 3, %s0
; PIC-NEXT:    adds.w.sx %s0, %s0, (0)1
; PIC-NEXT:    b.l.t (, %s10)
  %2 = add nsw i32 %0, 3
  ret i32 %2
}

; Function Attrs: nounwind
define i8* @test_frame32(i8* %0) {
; CHECK-LABEL: test_frame32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    st %s15, 24(, %s11)
; CHECK-NEXT:    st %s16, 32(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s13, -272
; CHECK-NEXT:    and %s13, %s13, (32)0
; CHECK-NEXT:    lea.sl %s11, -1(%s13, %s11)
; CHECK-NEXT:    brge.l.t %s11, %s8, .LBB1_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    or %s1, 0, %s0
; CHECK-NEXT:    lea %s0, fun@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, fun@hi(, %s0)
; CHECK-NEXT:    lea %s0, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s16, 32(, %s11)
; CHECK-NEXT:    ld %s15, 24(, %s11)
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame32:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s13, -272
; PIC-NEXT:    and %s13, %s13, (32)0
; PIC-NEXT:    lea.sl %s11, -1(%s13, %s11)
; PIC-NEXT:    brge.l.t %s11, %s8, .LBB1_2
; PIC-NEXT:  # %bb.1:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB1_2:
; PIC-NEXT:    or %s1, 0, %s0
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s12, fun@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, fun@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, 240(, %s11)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
  %2 = alloca [32 x i8], align 1
  %3 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %3)
  %4 = call i8* @fun(i8* nonnull %3, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %3)
  ret i8* %4
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)

declare i8* @fun(i8*, i8*)

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

; Function Attrs: nounwind
define i8* @test_frame64(i8* %0) {
; CHECK-LABEL: test_frame64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    st %s15, 24(, %s11)
; CHECK-NEXT:    st %s16, 32(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s13, -304
; CHECK-NEXT:    and %s13, %s13, (32)0
; CHECK-NEXT:    lea.sl %s11, -1(%s13, %s11)
; CHECK-NEXT:    brge.l.t %s11, %s8, .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    or %s1, 0, %s0
; CHECK-NEXT:    lea %s0, fun@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, fun@hi(, %s0)
; CHECK-NEXT:    lea %s0, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s16, 32(, %s11)
; CHECK-NEXT:    ld %s15, 24(, %s11)
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame64:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s13, -304
; PIC-NEXT:    and %s13, %s13, (32)0
; PIC-NEXT:    lea.sl %s11, -1(%s13, %s11)
; PIC-NEXT:    brge.l.t %s11, %s8, .LBB2_2
; PIC-NEXT:  # %bb.1:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB2_2:
; PIC-NEXT:    or %s1, 0, %s0
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s12, fun@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, fun@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, 240(, %s11)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
  %2 = alloca [64 x i8], align 1
  %3 = getelementptr inbounds [64 x i8], [64 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %3)
  %4 = call i8* @fun(i8* nonnull %3, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %3)
  ret i8* %4
}

; Function Attrs: nounwind
define i8* @test_frame128(i8* %0) {
; CHECK-LABEL: test_frame128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    st %s15, 24(, %s11)
; CHECK-NEXT:    st %s16, 32(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s13, -368
; CHECK-NEXT:    and %s13, %s13, (32)0
; CHECK-NEXT:    lea.sl %s11, -1(%s13, %s11)
; CHECK-NEXT:    brge.l.t %s11, %s8, .LBB3_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    or %s1, 0, %s0
; CHECK-NEXT:    lea %s0, fun@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, fun@hi(, %s0)
; CHECK-NEXT:    lea %s0, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s16, 32(, %s11)
; CHECK-NEXT:    ld %s15, 24(, %s11)
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame128:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s13, -368
; PIC-NEXT:    and %s13, %s13, (32)0
; PIC-NEXT:    lea.sl %s11, -1(%s13, %s11)
; PIC-NEXT:    brge.l.t %s11, %s8, .LBB3_2
; PIC-NEXT:  # %bb.1:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB3_2:
; PIC-NEXT:    or %s1, 0, %s0
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s12, fun@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, fun@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, 240(, %s11)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
  %2 = alloca [128 x i8], align 1
  %3 = getelementptr inbounds [128 x i8], [128 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %3)
  %4 = call i8* @fun(i8* nonnull %3, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %3)
  ret i8* %4
}

; Function Attrs: nounwind
define i8* @test_frame65536(i8* %0) {
; CHECK-LABEL: test_frame65536:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    st %s15, 24(, %s11)
; CHECK-NEXT:    st %s16, 32(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s13, -65776
; CHECK-NEXT:    and %s13, %s13, (32)0
; CHECK-NEXT:    lea.sl %s11, -1(%s13, %s11)
; CHECK-NEXT:    brge.l.t %s11, %s8, .LBB4_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB4_2:
; CHECK-NEXT:    or %s1, 0, %s0
; CHECK-NEXT:    lea %s0, fun@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, fun@hi(, %s0)
; CHECK-NEXT:    lea %s0, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s16, 32(, %s11)
; CHECK-NEXT:    ld %s15, 24(, %s11)
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame65536:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s13, -65776
; PIC-NEXT:    and %s13, %s13, (32)0
; PIC-NEXT:    lea.sl %s11, -1(%s13, %s11)
; PIC-NEXT:    brge.l.t %s11, %s8, .LBB4_2
; PIC-NEXT:  # %bb.1:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB4_2:
; PIC-NEXT:    or %s1, 0, %s0
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s12, fun@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, fun@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, 240(, %s11)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
  %2 = alloca [65536 x i8], align 1
  %3 = getelementptr inbounds [65536 x i8], [65536 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 65536, i8* nonnull %3)
  %4 = call i8* @fun(i8* nonnull %3, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 65536, i8* nonnull %3)
  ret i8* %4
}

; Function Attrs: nounwind
define i8* @test_frame4294967296(i8* %0) {
; CHECK-LABEL: test_frame4294967296:
; CHECK:       # %bb.0:
; CHECK-NEXT:    st %s9, (, %s11)
; CHECK-NEXT:    st %s10, 8(, %s11)
; CHECK-NEXT:    st %s15, 24(, %s11)
; CHECK-NEXT:    st %s16, 32(, %s11)
; CHECK-NEXT:    or %s9, 0, %s11
; CHECK-NEXT:    lea %s13, -240
; CHECK-NEXT:    and %s13, %s13, (32)0
; CHECK-NEXT:    lea.sl %s11, -2(%s13, %s11)
; CHECK-NEXT:    brge.l.t %s11, %s8, .LBB5_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    ld %s61, 24(, %s14)
; CHECK-NEXT:    or %s62, 0, %s0
; CHECK-NEXT:    lea %s63, 315
; CHECK-NEXT:    shm.l %s63, (%s61)
; CHECK-NEXT:    shm.l %s8, 8(%s61)
; CHECK-NEXT:    shm.l %s11, 16(%s61)
; CHECK-NEXT:    monc
; CHECK-NEXT:    or %s0, 0, %s62
; CHECK-NEXT:  .LBB5_2:
; CHECK-NEXT:    or %s1, 0, %s0
; CHECK-NEXT:    lea %s0, fun@lo
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lea.sl %s12, fun@hi(, %s0)
; CHECK-NEXT:    lea %s0, 240(, %s11)
; CHECK-NEXT:    bsic %s10, (, %s12)
; CHECK-NEXT:    or %s11, 0, %s9
; CHECK-NEXT:    ld %s16, 32(, %s11)
; CHECK-NEXT:    ld %s15, 24(, %s11)
; CHECK-NEXT:    ld %s10, 8(, %s11)
; CHECK-NEXT:    ld %s9, (, %s11)
; CHECK-NEXT:    b.l.t (, %s10)
;
; PIC-LABEL: test_frame4294967296:
; PIC:       # %bb.0:
; PIC-NEXT:    st %s9, (, %s11)
; PIC-NEXT:    st %s10, 8(, %s11)
; PIC-NEXT:    st %s15, 24(, %s11)
; PIC-NEXT:    st %s16, 32(, %s11)
; PIC-NEXT:    or %s9, 0, %s11
; PIC-NEXT:    lea %s13, -240
; PIC-NEXT:    and %s13, %s13, (32)0
; PIC-NEXT:    lea.sl %s11, -2(%s13, %s11)
; PIC-NEXT:    brge.l.t %s11, %s8, .LBB5_2
; PIC-NEXT:  # %bb.1:
; PIC-NEXT:    ld %s61, 24(, %s14)
; PIC-NEXT:    or %s62, 0, %s0
; PIC-NEXT:    lea %s63, 315
; PIC-NEXT:    shm.l %s63, (%s61)
; PIC-NEXT:    shm.l %s8, 8(%s61)
; PIC-NEXT:    shm.l %s11, 16(%s61)
; PIC-NEXT:    monc
; PIC-NEXT:    or %s0, 0, %s62
; PIC-NEXT:  .LBB5_2:
; PIC-NEXT:    or %s1, 0, %s0
; PIC-NEXT:    lea %s15, _GLOBAL_OFFSET_TABLE_@pc_lo(-24)
; PIC-NEXT:    and %s15, %s15, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s15, _GLOBAL_OFFSET_TABLE_@pc_hi(%s16, %s15)
; PIC-NEXT:    lea %s12, fun@plt_lo(-24)
; PIC-NEXT:    and %s12, %s12, (32)0
; PIC-NEXT:    sic %s16
; PIC-NEXT:    lea.sl %s12, fun@plt_hi(%s16, %s12)
; PIC-NEXT:    lea %s0, 240(, %s11)
; PIC-NEXT:    bsic %s10, (, %s12)
; PIC-NEXT:    or %s11, 0, %s9
; PIC-NEXT:    ld %s16, 32(, %s11)
; PIC-NEXT:    ld %s15, 24(, %s11)
; PIC-NEXT:    ld %s10, 8(, %s11)
; PIC-NEXT:    ld %s9, (, %s11)
; PIC-NEXT:    b.l.t (, %s10)
  %2 = alloca [4294967296 x i8], align 1
  %3 = getelementptr inbounds [4294967296 x i8], [4294967296 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 4294967296, i8* nonnull %3)
  %4 = call i8* @fun(i8* nonnull %3, i8* %0)
  call void @llvm.lifetime.end.p0i8(i64 4294967296, i8* nonnull %3)
  ret i8* %4
}
