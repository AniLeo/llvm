; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown | FileCheck %s

; PR32273

define void @signbits_vXi1(<4 x i16> %a1) {
; CHECK-LABEL: signbits_vXi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI0_0
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    movi v2.4h, #1
; CHECK-NEXT:    dup v0.4h, v0.h[0]
; CHECK-NEXT:    mov w1, wzr
; CHECK-NEXT:    mov w2, wzr
; CHECK-NEXT:    ldr d1, [x8, :lo12:.LCPI0_0]
; CHECK-NEXT:    add v0.4h, v0.4h, v1.4h
; CHECK-NEXT:    cmgt v0.4h, v2.4h, v0.4h
; CHECK-NEXT:    umov w0, v0.h[0]
; CHECK-NEXT:    umov w3, v0.h[3]
; CHECK-NEXT:    b foo
  %tmp3 = shufflevector <4 x i16> %a1, <4 x i16> undef, <4 x i32> zeroinitializer
  %tmp5 = add <4 x i16> %tmp3, <i16 18249, i16 6701, i16 -18744, i16 -25086>
  %tmp6 = icmp slt <4 x i16> %tmp5, <i16 1, i16 1, i16 1, i16 1>
  %tmp7 = and <4 x i1> %tmp6, <i1 true, i1 false, i1 false, i1 true>
  %tmp8 = sext <4 x i1> %tmp7 to <4 x i16>
  %tmp9 = extractelement <4 x i16> %tmp8, i32 0
  %tmp10 = zext i16 %tmp9 to i32
  %tmp11 = extractelement <4 x i16> %tmp8, i32 1
  %tmp12 = zext i16 %tmp11 to i32
  %tmp13 = extractelement <4 x i16> %tmp8, i32 2
  %tmp14 = zext i16 %tmp13 to i32
  %tmp15 = extractelement <4 x i16> %tmp8, i32 3
  %tmp16 = zext i16 %tmp15 to i32
  tail call void @foo(i32 %tmp10, i32 %tmp12, i32 %tmp14, i32 %tmp16)
  ret void
}

declare void @foo(i32, i32, i32, i32)
