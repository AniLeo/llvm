; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -verify-machineinstrs -O2 < %s | FileCheck %s
$test = comdat any

; Function Attrs: noinline nounwind
define void @test() local_unnamed_addr #0 comdat align 2 {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    cmpdi 1, 3, 0
; CHECK-NEXT:    andi. 4, 3, 3
; CHECK-NEXT:    crand 20, 2, 5
; CHECK-NEXT:    isel 3, 0, 3, 20
; CHECK-NEXT:    addi 3, 3, -1
; CHECK-NEXT:    cmpldi 3, 3
; CHECK-NEXT:    bltlr+ 0
; CHECK-NEXT:  # %bb.1: # %for.body.i.i.i.i.i.i.i
entry:
  %0 = load float*, float** undef, align 8
  %1 = load i64, i64* undef, align 8
  %add.ptr.i.i.i.i = getelementptr inbounds float, float* %0, i64 undef
  %2 = ptrtoint float* %add.ptr.i.i.i.i to i64
  %and.i.i.i.i.i.i.i = and i64 %2, 3
  %tobool.i.i.i.i.i.i.i = icmp eq i64 %and.i.i.i.i.i.i.i, 0
  %cmp.i.i.i.i.i.i.i = icmp slt i64 0, %1
  %3 = and i1 %tobool.i.i.i.i.i.i.i, %cmp.i.i.i.i.i.i.i
  %spec.select.i.i.i.i.i.i.i = select i1 %3, i64 0, i64 %1
  %4 = add i64 %spec.select.i.i.i.i.i.i.i, -1
  %5 = sub i64 %4, 0
  br label %for.body.i.i.i.i.i.i.i.prol.loopexit

for.body.i.i.i.i.i.i.i.prol.loopexit:             ; preds = %entry
  %6 = icmp ult i64 %5, 3
  br i1 %6, label %exitBB, label %for.body.i.i.i.i.i.i.i

for.body.i.i.i.i.i.i.i:                           ; preds = %for.body.i.i.i.i.i.i.i.prol.loopexit
  unreachable

exitBB: ; preds = %for.body.i.i.i.i.i.i.i.prol.loopexit
  ret void
}

define signext i32 @andis_bot(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: andis_bot:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andis. 5, 3, 1
; CHECK-NEXT:    li 5, 1
; CHECK-NEXT:    isel 4, 4, 5, 2
; CHECK-NEXT:    mullw 3, 4, 3
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
entry:
  %and = and i32 %a, 65536
  %tobool = icmp eq i32 %and, 0
  %mul = select i1 %tobool, i32 %b, i32 1
  %cond = mul nsw i32 %mul, %a
  ret i32 %cond
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @andis_mid(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: andis_mid:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andis. 5, 3, 252
; CHECK-NEXT:    li 5, 1
; CHECK-NEXT:    isel 4, 4, 5, 2
; CHECK-NEXT:    mullw 3, 4, 3
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
entry:
  %and = and i32 %a, 16515072
  %tobool = icmp eq i32 %and, 0
  %mul = select i1 %tobool, i32 %b, i32 1
  %cond = mul nsw i32 %mul, %a
  ret i32 %cond
}

; Function Attrs: norecurse nounwind readnone
define signext i32 @andis_top(i32 signext %a, i32 signext %b) {
; CHECK-LABEL: andis_top:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    andis. 5, 3, 64512
; CHECK-NEXT:    li 5, 1
; CHECK-NEXT:    isel 4, 4, 5, 2
; CHECK-NEXT:    mullw 3, 4, 3
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
entry:
  %tobool = icmp ugt i32 %a, 67108863
  %mul = select i1 %tobool, i32 1, i32 %b
  %cond = mul nsw i32 %mul, %a
  ret i32 %cond
}

define i64 @andis_no_cmp(i64 %a, i64 %b) {
entry:
  %and = and i64 %a, 65536
  %tobool = icmp eq i64 %and, 0
  %mul = select i1 %tobool, i64 %b, i64 1
  %cond = mul nsw i64 %mul, %a
  ret i64 %cond
}
