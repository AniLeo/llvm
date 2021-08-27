; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -passes=simplifycfg -bonus-inst-threshold=1 | FileCheck %s

declare i8* @llvm.strip.invariant.group.p0i8(i8*)

declare void @g1()
declare void @g2()

define void @f(i8* %a, i8* %b, i1 %c, i1 %d, i1 %e) {
; CHECK-LABEL: @f(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[L1:%.*]], label [[L3:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[A1:%.*]] = call i8* @llvm.strip.invariant.group.p0i8(i8* [[A:%.*]])
; CHECK-NEXT:    [[B1:%.*]] = call i8* @llvm.strip.invariant.group.p0i8(i8* [[B:%.*]])
; CHECK-NEXT:    [[I:%.*]] = icmp eq i8* [[A1]], [[B1]]
; CHECK-NEXT:    br i1 [[I]], label [[L2:%.*]], label [[L3]]
; CHECK:       l2:
; CHECK-NEXT:    call void @g1()
; CHECK-NEXT:    br label [[RET:%.*]]
; CHECK:       l3:
; CHECK-NEXT:    call void @g2()
; CHECK-NEXT:    br label [[RET]]
; CHECK:       ret:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %l1, label %l3
l1:
  %a1 = call i8* @llvm.strip.invariant.group.p0i8(i8* %a)
  %b1 = call i8* @llvm.strip.invariant.group.p0i8(i8* %b)
  %i = icmp eq i8* %a1, %b1
  br i1 %i, label %l2, label %l3
l2:
  call void @g1()
  br label %ret
l3:
  call void @g2()
  br label %ret
ret:
  ret void
}
