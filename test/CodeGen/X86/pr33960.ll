; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=X64

@b = external dso_local local_unnamed_addr global i32, align 4

define void @PR33960() {
; X86-LABEL: PR33960:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl $-1, b
; X86-NEXT:    retl
;
; X64-LABEL: PR33960:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl $-1, b(%rip)
; X64-NEXT:    retq
entry:
  %tmp = insertelement <4 x i32> <i32 undef, i32 -7, i32 -3, i32 undef>, i32 -2, i32 3
  %predphi26 = insertelement <4 x i32> %tmp, i32 -7, i32 0
  %tmp1 = trunc <4 x i32> %predphi26 to <4 x i16>
  %tmp2 = icmp eq <4 x i16> %tmp1, zeroinitializer
  %tmp3 = icmp eq <4 x i32> undef, zeroinitializer
  %tmp4 = and <4 x i1> %tmp2, %tmp3
  %predphi17 = select <4 x i1> %tmp4, <4 x i32> undef, <4 x i32> zeroinitializer
  %tmp5 = shl <4 x i32> %predphi17, <i32 16, i32 16, i32 16, i32 16>
  %tmp6 = ashr exact <4 x i32> %tmp5, <i32 16, i32 16, i32 16, i32 16>
  %tmp7 = or <4 x i32> %tmp6, undef
  %tmp8 = or <4 x i32> undef, %tmp7
  %tmp9 = or <4 x i32> undef, %tmp8
  %tmp10 = or <4 x i32> undef, %tmp9
  %tmp11 = or <4 x i32> undef, %tmp10
  %tmp12 = or <4 x i32> undef, %tmp11
  %bin.rdx = or <4 x i32> %tmp12, undef
  %bin.rdx19 = or <4 x i32> %bin.rdx, undef
  %tmp13 = extractelement <4 x i32> %bin.rdx19, i32 0
  %or = or i32 0, %tmp13
  store i32 %or, i32* @b, align 4
  ret void
}
