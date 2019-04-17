; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i32 @llvm.x86.tbm.bextri.u32(i32, i32) nounwind readnone
declare i64 @llvm.x86.tbm.bextri.u64(i64, i64) nounwind readnone
declare i32 @llvm.x86.bmi.bextr.32(i32, i32) nounwind readnone
declare i64 @llvm.x86.bmi.bextr.64(i64, i64) nounwind readnone
declare i32 @llvm.x86.bmi.bzhi.32(i32, i32) nounwind readnone
declare i64 @llvm.x86.bmi.bzhi.64(i64, i64) nounwind readnone

define i32 @test_x86_tbm_bextri_u32(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @llvm.x86.tbm.bextri.u32(i32 [[A:%.*]], i32 1296)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %a, i32 1296)
  ret i32 %1
}

define i32 @test_x86_tbm_bextri_u32_zero_length(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32_zero_length(
; CHECK-NEXT:    ret i32 0
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %a, i32 1)
  ret i32 %1
}

define i32 @test_x86_tbm_bextri_u32_large_shift(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32_large_shift(
; CHECK-NEXT:    ret i32 0
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 %a, i32 288)
  ret i32 %1
}

define i64 @test_x86_tbm_bextri_u64(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.x86.tbm.bextri.u64(i64 [[A:%.*]], i64 1312)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 1312)
  ret i64 %1
}

define i64 @test_x86_tbm_bextri_u64_zero_length(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64_zero_length(
; CHECK-NEXT:    ret i64 0
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 1)
  ret i64 %1
}

define i64 @test_x86_tbm_bextri_u64_large_shift(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64_large_shift(
; CHECK-NEXT:    ret i64 0
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 %a, i64 320)
  ret i64 %1
}

define i32 @test_x86_tbm_bextri_u32_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32_constfold(
; CHECK-NEXT:    ret i32 57005
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 3735928559, i32 4112) ; extract bits 31:16 from 0xDEADBEEF
  ret i32 %1
}

define i32 @test_x86_tbm_bextri_u32_constfold2() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32_constfold2(
; CHECK-NEXT:    ret i32 233495534
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 3735928559, i32 8196) ; extract bits 35:4 from 0xDEADBEEF
  ret i32 %1
}

define i32 @test_x86_tbm_bextri_u32_constfold3() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u32_constfold3(
; CHECK-NEXT:    ret i32 233495534
;
  %1 = tail call i32 @llvm.x86.tbm.bextri.u32(i32 3735928559, i32 16388) ; extract bits 67:4 from 0xDEADBEEF
  ret i32 %1
}

define i64 @test_x86_tbm_bextri_u64_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64_constfold(
; CHECK-NEXT:    ret i64 57005
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 3735928559, i64 4112) ; extract bits 31:16 from 0xDEADBEEF
  ret i64 %1
}

define i64 @test_x86_tbm_bextri_u64_constfold2() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64_constfold2(
; CHECK-NEXT:    ret i64 233495534
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 3735928559, i64 16388) ; extract bits 67:4 from 0xDEADBEEF
  ret i64 %1
}

define i64 @test_x86_tbm_bextri_u64_constfold3() nounwind readnone {
; CHECK-LABEL: @test_x86_tbm_bextri_u64_constfold3(
; CHECK-NEXT:    ret i64 233495534
;
  %1 = tail call i64 @llvm.x86.tbm.bextri.u64(i64 3735928559, i64 32772) ; extract bits 131:4 from 0xDEADBEEF
  ret i64 %1
}

define i32 @test_x86_bmi_bextri_32(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @llvm.x86.bmi.bextr.32(i32 [[A:%.*]], i32 1296)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %a, i32 1296)
  ret i32 %1
}

define i32 @test_x86_bmi_bextri_32_zero_length(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32_zero_length(
; CHECK-NEXT:    ret i32 0
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %a, i32 1)
  ret i32 %1
}

define i32 @test_x86_bmi_bextri_32_large_shift(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32_large_shift(
; CHECK-NEXT:    ret i32 0
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 %a, i32 288)
  ret i32 %1
}

define i64 @test_x86_bmi_bextri_64(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.x86.bmi.bextr.64(i64 [[A:%.*]], i64 1312)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 %a, i64 1312)
  ret i64 %1
}

define i64 @test_x86_bmi_bextri_64_zero_length(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64_zero_length(
; CHECK-NEXT:    ret i64 0
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 %a, i64 1)
  ret i64 %1
}

define i64 @test_x86_bmi_bextri_64_large_shift(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64_large_shift(
; CHECK-NEXT:    ret i64 0
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 %a, i64 320)
  ret i64 %1
}

define i32 @test_x86_bmi_bextri_32_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32_constfold(
; CHECK-NEXT:    ret i32 57005
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 3735928559, i32 4112) ; extract bits 31:16 from 0xDEADBEEF
  ret i32 %1
}

define i32 @test_x86_bmi_bextri_32_constfold2() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32_constfold2(
; CHECK-NEXT:    ret i32 233495534
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 3735928559, i32 8196) ; extract bits 35:4 from 0xDEADBEEF
  ret i32 %1
}

define i32 @test_x86_bmi_bextri_32_constfold3() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_32_constfold3(
; CHECK-NEXT:    ret i32 233495534
;
  %1 = tail call i32 @llvm.x86.bmi.bextr.32(i32 3735928559, i32 16388) ; extract bits 67:4 from 0xDEADBEEF
  ret i32 %1
}

define i64 @test_x86_bmi_bextri_64_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64_constfold(
; CHECK-NEXT:    ret i64 57005
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 3735928559, i64 4112) ; extract bits 31:16 from 0xDEADBEEF
  ret i64 %1
}

define i64 @test_x86_bmi_bextri_64_constfold2() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64_constfold2(
; CHECK-NEXT:    ret i64 233495534
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 3735928559, i64 16388) ; extract bits 67:4 from 0xDEADBEEF
  ret i64 %1
}

define i64 @test_x86_bmi_bextri_64_constfold3() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bextri_64_constfold3(
; CHECK-NEXT:    ret i64 233495534
;
  %1 = tail call i64 @llvm.x86.bmi.bextr.64(i64 3735928559, i64 32772) ; extract bits 131:4 from 0xDEADBEEF
  ret i64 %1
}

define i32 @test_x86_bmi_bzhi_32(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_32(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @llvm.x86.bmi.bzhi.32(i32 [[A:%.*]], i32 31)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %a, i32 31)
  ret i32 %1
}

define i32 @test_x86_bmi_bzhi_32_zero(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_32_zero(
; CHECK-NEXT:    ret i32 0
;
  %1 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %a, i32 0)
  ret i32 %1
}

define i32 @test_x86_bmi_bzhi_32_max(i32 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_32_max(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %1 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %a, i32 32)
  ret i32 %1
}

define i32 @test_x86_bmi_bzhi_32_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_32_constfold(
; CHECK-NEXT:    ret i32 1
;
  %1 = tail call i32 @llvm.x86.bmi.bzhi.32(i32 5, i32 1)
  ret i32 %1
}

define i64 @test_x86_bmi_bzhi_64(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_64(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i64 @llvm.x86.bmi.bzhi.64(i64 [[A:%.*]], i64 63)
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %1 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %a, i64 63)
  ret i64 %1
}

define i64 @test_x86_bmi_bzhi_64_zero(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_64_zero(
; CHECK-NEXT:    ret i64 0
;
  %1 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %a, i64 0)
  ret i64 %1
}

define i64 @test_x86_bmi_bzhi_64_max(i64 %a) nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_64_max(
; CHECK-NEXT:    ret i64 [[A:%.*]]
;
  %1 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %a, i64 64)
  ret i64 %1
}

define i64 @test_x86_bmi_bzhi_64_constfold() nounwind readnone {
; CHECK-LABEL: @test_x86_bmi_bzhi_64_constfold(
; CHECK-NEXT:    ret i64 1
;
  %1 = tail call i64 @llvm.x86.bmi.bzhi.64(i64 5, i64 1)
  ret i64 %1
}
