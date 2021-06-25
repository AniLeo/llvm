; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon,+sve | FileCheck %s

define <16 x i8> @subsubii8(<16 x i8> %a, i8 %b) {
; CHECK-LABEL: subsubii8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    dup v0.16b, w0
; CHECK-NEXT:    ret
entry:
  %sub = sub i8 0, %b
  %0 = insertelement <16 x i8> undef, i8 %sub, i32 0
  %sh_prom = shufflevector <16 x i8> %0, <16 x i8> undef, <16 x i32> zeroinitializer
  %sub2 = sub <16 x i8> zeroinitializer, %sh_prom
  ret <16 x i8> %sub2
}

define <vscale x 16 x i8> @subsubni8(<vscale x 16 x i8> %a, i8 %b) {
; CHECK-LABEL: subsubni8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov z0.b, w0
; CHECK-NEXT:    ret
entry:
  %sub = sub i8 0, %b
  %0 = insertelement <vscale x 16 x i8> undef, i8 %sub, i32 0
  %sh_prom = shufflevector <vscale x 16 x i8> %0, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %sub2 = sub <vscale x 16 x i8> zeroinitializer, %sh_prom
  ret <vscale x 16 x i8> %sub2
}
