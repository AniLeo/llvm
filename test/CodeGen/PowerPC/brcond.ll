; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:   -ppc-reduce-cr-logicals=false < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:   -ppc-reduce-cr-logicals=false < %s | FileCheck %s

define signext i32 @testi32slt(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32slt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB0_2: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp slt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32ult(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32ult:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB1_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB1_2: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp ult i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32sle(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32sle:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB2_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB2_2: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp sle i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32ule(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32ule:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB3_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB3_2: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp ule i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32eq(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32eq:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crxor 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB4_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB4_2: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp eq i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32sge(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32sge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB5_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB5_2: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp sge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32uge(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32uge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB6_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB6_2: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp uge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32sgt(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32sgt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB7_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB7_2: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp sgt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32ugt(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32ugt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB8_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB8_2: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp ugt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define signext i32 @testi32ne(i32 signext %c1, i32 signext %c2, i32 signext %c3, i32 signext %c4, i32 signext %a1, i32 signext %a2) #0 {
; CHECK-LABEL: testi32ne:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpw 5, 6
; CHECK-NEXT:    cmpw 1, 3, 4
; CHECK-NEXT:    creqv 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB9_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    extsw 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB9_2: # %iffalse
; CHECK-NEXT:    extsw 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i32 %c3, %c4
  %cmp3tmp = icmp eq i32 %c1, %c2
  %cmp3 = icmp ne i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i32 %a1
iffalse:
  ret i32 %a2
}

define i64 @testi64slt(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64slt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB10_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB10_2: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp slt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64ult(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64ult:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB11_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB11_2: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp ult i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64sle(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64sle:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB12_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB12_2: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp sle i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64ule(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64ule:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB13_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB13_2: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp ule i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64eq(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64eq:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crxor 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB14_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB14_2: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp eq i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64sge(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64sge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB15_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB15_2: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp sge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64uge(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64uge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB16_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB16_2: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp uge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64sgt(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64sgt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB17_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB17_2: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp sgt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64ugt(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64ugt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB18_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB18_2: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp ugt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define i64 @testi64ne(i64 %c1, i64 %c2, i64 %c3, i64 %c4, i64 %a1, i64 %a2) #0 {
; CHECK-LABEL: testi64ne:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpd 5, 6
; CHECK-NEXT:    cmpd 1, 3, 4
; CHECK-NEXT:    creqv 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB19_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    mr 3, 7
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB19_2: # %iffalse
; CHECK-NEXT:    mr 3, 8
; CHECK-NEXT:    blr
entry:
  %cmp1 = icmp eq i64 %c3, %c4
  %cmp3tmp = icmp eq i64 %c1, %c2
  %cmp3 = icmp ne i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret i64 %a1
iffalse:
  ret i64 %a2
}

define float @testfloatslt(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatslt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB20_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB20_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp slt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatult(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatult:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB21_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB21_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp ult i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatsle(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatsle:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB22_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB22_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp sle i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatule(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatule:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB23_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB23_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp ule i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloateq(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloateq:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crxor 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB24_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB24_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp eq i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatsge(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatsge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB25_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB25_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp sge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatuge(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatuge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB26_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB26_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp uge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatsgt(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatsgt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB27_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB27_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp sgt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatugt(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatugt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB28_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB28_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp ugt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define float @testfloatne(float %c1, float %c2, float %c3, float %c4, float %a1, float %a2) #0 {
; CHECK-LABEL: testfloatne:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    creqv 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB29_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB29_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq float %c3, %c4
  %cmp3tmp = fcmp oeq float %c1, %c2
  %cmp3 = icmp ne i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret float %a1
iffalse:
  ret float %a2
}

define double @testdoubleslt(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleslt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB30_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB30_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp slt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoubleult(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleult:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB31_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB31_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp ult i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoublesle(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoublesle:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB32_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB32_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp sle i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoubleule(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleule:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB33_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB33_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp ule i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoubleeq(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleeq:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crxor 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB34_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB34_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp eq i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoublesge(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoublesge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 6, 2
; CHECK-NEXT:    bc 4, 20, .LBB35_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB35_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp sge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoubleuge(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleuge:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crandc 20, 2, 6
; CHECK-NEXT:    bc 4, 20, .LBB36_2
; CHECK-NEXT:  # %bb.1: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB36_2: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp uge i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoublesgt(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoublesgt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB37_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB37_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp sgt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoubleugt(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoubleugt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    crorc 20, 2, 6
; CHECK-NEXT:    bc 12, 20, .LBB38_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB38_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp ugt i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}

define double @testdoublene(double %c1, double %c2, double %c3, double %c4, double %a1, double %a2) #0 {
; CHECK-LABEL: testdoublene:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fcmpu 0, 3, 4
; CHECK-NEXT:    fcmpu 1, 1, 2
; CHECK-NEXT:    creqv 20, 6, 2
; CHECK-NEXT:    bc 12, 20, .LBB39_2
; CHECK-NEXT:  # %bb.1: # %iftrue
; CHECK-NEXT:    fmr 1, 5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB39_2: # %iffalse
; CHECK-NEXT:    fmr 1, 6
; CHECK-NEXT:    blr
entry:
  %cmp1 = fcmp oeq double %c3, %c4
  %cmp3tmp = fcmp oeq double %c1, %c2
  %cmp3 = icmp ne i1 %cmp3tmp, %cmp1
  br i1 %cmp3, label %iftrue, label %iffalse
iftrue:
  ret double %a1
iffalse:
  ret double %a2
}
