; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -sroa -S | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define float @_Z8stdclampfff(float %x, float %lo, float %hi) {
; CHECK-LABEL: @_Z8stdclampfff(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[I4:%.*]] = alloca float, align 4
; CHECK-NEXT:    store float [[HI:%.*]], float* [[I4]], align 4
; CHECK-NEXT:    [[I5:%.*]] = fcmp fast olt float [[X:%.*]], [[LO:%.*]]
; CHECK-NEXT:    [[I6:%.*]] = fcmp fast olt float [[HI]], [[X]]
; CHECK-NEXT:    [[I9_SROA_SPECULATE_LOAD_FALSE_SROA_SPECULATE_LOAD_TRUE:%.*]] = load float, float* [[I4]], align 4
; CHECK-NEXT:    [[I9_SROA_SPECULATE_LOAD_FALSE_SROA_SPECULATED:%.*]] = select i1 [[I6]], float [[I9_SROA_SPECULATE_LOAD_FALSE_SROA_SPECULATE_LOAD_TRUE]], float [[X]]
; CHECK-NEXT:    [[I9_SROA_SPECULATED:%.*]] = select i1 [[I5]], float [[LO]], float [[I9_SROA_SPECULATE_LOAD_FALSE_SROA_SPECULATED]]
; CHECK-NEXT:    ret float [[I9_SROA_SPECULATED]]
;
bb:
  %i = alloca float, align 4
  %i3 = alloca float, align 4
  %i4 = alloca float, align 4
  store float %x, float* %i, align 4
  store float %lo, float* %i3, align 4
  store float %hi, float* %i4, align 4
  %i5 = fcmp fast olt float %x, %lo
  %i6 = fcmp fast olt float %hi, %x
  %i7 = select i1 %i6, float* %i4, float* %i
  %i8 = select i1 %i5, float* %i3, float* %i7
  %i9 = load float, float* %i8, align 4
  ret float %i9
}
