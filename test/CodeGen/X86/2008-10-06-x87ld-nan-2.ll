; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; ModuleID = 'nan.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-f80:32:32-v64:64:64-v128:128:128-a0:0:64"
target triple = "i686-apple-darwin8"
; RUN: llc < %s -mattr=-sse2,-sse3,-sse | FileCheck %s
; it is not safe to shorten any of these NaNs.

declare x86_stdcallcc void @_D3nan5printFeZv(x86_fp80 %f)

@_D3nan4rvale = global x86_fp80 0xK7FFF8001234000000000   ; <x86_fp80*> [#uses=1]

define i32 @main() {
; CHECK-LABEL: main:
; CHECK:       ## %bb.0: ## %entry_nan.main
; CHECK-NEXT:    subl $28, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    fldt __D3nan4rvale
; CHECK-NEXT:    fstpt (%esp)
; CHECK-NEXT:    calll __D3nan5printFeZv
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    fldt LCPI0_0
; CHECK-NEXT:    fstpt (%esp)
; CHECK-NEXT:    calll __D3nan5printFeZv
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    fldt LCPI0_1
; CHECK-NEXT:    fstpt (%esp)
; CHECK-NEXT:    calll __D3nan5printFeZv
; CHECK-NEXT:    subl $16, %esp
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addl $28, %esp
; CHECK-NEXT:    retl
entry_nan.main:
  %tmp = load x86_fp80, x86_fp80* @_D3nan4rvale   ; <x86_fp80> [#uses=1]
  call x86_stdcallcc void @_D3nan5printFeZv(x86_fp80 %tmp)
  call x86_stdcallcc void @_D3nan5printFeZv(x86_fp80 0xK7FFF8001234000000000)
  call x86_stdcallcc void @_D3nan5printFeZv(x86_fp80 0xK7FFFC001234000000400)
  ret i32 0
}
