; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-none--eabi"

@glob = external unnamed_addr constant [16 x i8]

define void @f(i1 %c) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  entr:
; CHECK-NEXT:    br i1 %c, label [[NEXT:%.*]], label [[EXIT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    [[PAT:%.*]] = getelementptr [16 x i8], [16 x i8]* @glob
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entr:
  br i1 %c, label %next, label %exit

next:
  %pat = getelementptr [16 x i8], [16 x i8]* @glob
  br label %exit

exit:
  ret void
}
