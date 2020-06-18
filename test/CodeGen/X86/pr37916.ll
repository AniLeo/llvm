; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-unknown-linux-gnu %s -o - | FileCheck %s

@f = external dso_local local_unnamed_addr global i64*, align 4
@a = external dso_local global i64, align 8

define void @fn1() local_unnamed_addr {
; CHECK-LABEL: fn1:
; CHECK:       # %bb.0: # %entry
; CHECK:       .LBB0_1: # %if.end
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl a+4, %eax
; CHECK-NEXT:    orl a, %eax
; CHECK-NEXT:    movl $a, f
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.2: # %if.end
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  .LBB0_3: # %cond.false
entry:
  br label %if.end

if.end:                                           ; preds = %cond.end, %entry
  br label %if.then7

if.then7:                                         ; preds = %if.end
  store i64* @a, i64** @f, align 4
  %0 = load i64*, i64** @f, align 4
  %1 = load i64, i64* %0, align 4
  %tobool12 = icmp ne i64 %1, 0
  %2 = load i64, i64* @a, align 8
  %tobool13 = icmp ne i64 %2, 0
  %3 = and i1 %tobool12, %tobool13
  %tobool14.demorgan = and i1 %tobool12, %tobool13
  br i1 %tobool14.demorgan, label %cond.end, label %cond.false

cond.false:                                       ; preds = %if.then7
  unreachable

cond.end:                                         ; preds = %if.then7
  %conv17 = sext i1 %3 to i8
  br label %if.end
}
