; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

; In PR17073 ( http://llvm.org/pr17073 ), we illegally hoisted an operation that can trap.
; The first test confirms that we don't do that when the trapping op is reached by the current BB (block1).
; The second test confirms that we don't do that when the trapping op is reached by the previous BB (entry).
; The third test confirms that we can still do this optimization for an operation (add) that doesn't trap.
; The tests must be complicated enough to prevent previous SimplifyCFG actions from optimizing away
; the instructions that we're checking for.

target datalayout = "e-m:o-p:32:32-f64:32:64-f80:128-n8:16:32-S128"
target triple = "i386-apple-macosx10.9.0"

@a = common global i32 0, align 4
@b = common global i8 0, align 1

define i32* @can_trap1() {
; CHECK-LABEL: @can_trap1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[EXIT:%.*]], label [[BLOCK1:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    br i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a), label [[EXIT]], label [[BLOCK2:%.*]]
; CHECK:       block2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32* [ null, [[ENTRY:%.*]] ], [ null, [[BLOCK2]] ], [ select (i1 icmp eq (i64 urem (i64 2, i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64)), i64 0), i32* null, i32* @a), [[BLOCK1]] ]
; CHECK-NEXT:    ret i32* [[STOREMERGE]]
;
entry:
  %0 = load i32, i32* @a, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %exit, label %block1

block1:
  br i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a), label %exit, label %block2

block2:
  br label %exit

exit:
  %storemerge = phi i32* [ null, %entry ],[ null, %block2 ], [ select (i1 icmp eq (i64 urem (i64 2, i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64)), i64 0), i32* null, i32* @a), %block1 ]
  ret i32* %storemerge
}

define i32* @can_trap2() {
; CHECK-LABEL: @can_trap2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[EXIT:%.*]], label [[BLOCK1:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32* [ select (i1 icmp eq (i64 urem (i64 2, i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64)), i64 0), i32* null, i32* @a), [[ENTRY:%.*]] ], [ null, [[BLOCK1]] ]
; CHECK-NEXT:    ret i32* [[STOREMERGE]]
;
entry:
  %0 = load i32, i32* @a, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %exit, label %block1

block1:
  br i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a), label %exit, label %block2

block2:
  br label %exit

exit:
  %storemerge = phi i32* [ select (i1 icmp eq (i64 urem (i64 2, i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64)), i64 0), i32* null, i32* @a), %entry ],[ null, %block2 ], [ null, %block1 ]
  ret i32* %storemerge
}

define i32* @cannot_trap() {
; CHECK-LABEL: @cannot_trap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @a, align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP0]], 0
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a), i32* select (i1 icmp eq (i64 add (i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64), i64 2), i64 0), i32* null, i32* @a), i32* null
; CHECK-NEXT:    [[STOREMERGE:%.*]] = select i1 [[TOBOOL]], i32* null, i32* [[SPEC_SELECT]]
; CHECK-NEXT:    ret i32* [[STOREMERGE]]
;
entry:
  %0 = load i32, i32* @a, align 4
  %tobool = icmp eq i32 %0, 0
  br i1 %tobool, label %exit, label %block1

block1:
  br i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a), label %exit, label %block2

block2:
  br label %exit

exit:
  %storemerge = phi i32* [ null, %entry ],[ null, %block2 ], [ select (i1 icmp eq (i64 add (i64 2, i64 zext (i1 icmp eq (i32* bitcast (i8* @b to i32*), i32* @a) to i64)), i64 0), i32* null, i32* @a), %block1 ]
  ret i32* %storemerge
}
