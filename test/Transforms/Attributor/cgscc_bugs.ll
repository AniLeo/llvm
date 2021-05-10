; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=12 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=12 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%0 = type { i32, %1, %2* }
%1 = type { i32 }
%2 = type opaque

define hidden %0* @f1(i64 %0, i64 %1) {
; CHECK-LABEL: define {{[^@]+}}@f1
; CHECK-SAME: (i64 [[TMP0:%.*]], i64 [[TMP1:%.*]]) {
; CHECK-NEXT:    [[TMP3:%.*]] = call { %0*, i64 } @f3(i64 [[TMP0]])
; CHECK-NEXT:    ret %0* undef
;
  %3 = call { %0*, i64 } @f3(i64 %0)
  ret %0* undef
}

define linkonce_odr hidden { %0*, i64 } @f3(i64 %0) align 2 {
; CHECK-LABEL: define {{[^@]+}}@f3
; CHECK-SAME: (i64 [[TMP0:%.*]]) align 2 {
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @f4()
; CHECK-NEXT:    [[TMP3:%.*]] = zext i32 [[TMP2]] to i64
; CHECK-NEXT:    call void @f5(i64 [[TMP3]], i64 [[TMP0]]) #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    ret { %0*, i64 } undef
;
  %2 = call i32 @f4()
  %3 = zext i32 %2 to i64
  call void @f5(i64 %3, i64 %0)
  ret { %0*, i64 } undef
}

define linkonce_odr hidden i32 @f4() align 2 {
; CHECK-LABEL: define {{[^@]+}}@f4() align 2 {
; CHECK-NEXT:    ret i32 16
;
  ret i32 16
}

define internal void @f5(i64 %0, i64 %1) {
; CHECK: Function Attrs: nounwind
; CHECK-LABEL: define {{[^@]+}}@f5
; CHECK-SAME: (i64 [[TMP0:%.*]], i64 [[TMP1:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br label [[TMP3:%.*]]
; CHECK:       3:
; CHECK-NEXT:    call void @f6(i64 [[TMP0]]) #[[ATTR0]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp sgt i64 [[TMP1]], [[TMP0]]
; CHECK-NEXT:    br i1 [[TMP4]], label [[TMP5:%.*]], label [[TMP6:%.*]]
; CHECK:       5:
; CHECK-NEXT:    ret void
; CHECK:       6:
; CHECK-NEXT:    call void @f5(i64 [[TMP0]], i64 [[TMP1]]) #[[ATTR0]]
; CHECK-NEXT:    br label [[TMP3]]
;
  br label %3

3:                                                ; preds = %6, %2
  call void @f6(i64 %0)
  %4 = icmp sgt i64 %1, %0
  br i1 %4, label %5, label %6

5:                                                ; preds = %3
  ret void

6:                                                ; preds = %3
  call void @f5(i64 %0, i64 %1)
  br label %3
}

define internal void @f6(i64 %0) {
; CHECK: Function Attrs: nounwind
; CHECK-LABEL: define {{[^@]+}}@f6
; CHECK-SAME: (i64 [[TMP0:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i64 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[TMP3:%.*]], label [[TMP4:%.*]]
; CHECK:       3:
; CHECK-NEXT:    call void @llvm.trap() #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    unreachable
; CHECK:       4:
; CHECK-NEXT:    ret void
;
  %2 = icmp sgt i64 %0, 0
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  call void @llvm.trap()
  ret void

4:                                                ; preds = %1
  ret void
}

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #0

attributes #0 = { cold noreturn nounwind }

;.
; CHECK: attributes #[[ATTR0]] = { nounwind }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { cold noreturn nounwind }
; CHECK: attributes #[[ATTR2]] = { noreturn }
;.
