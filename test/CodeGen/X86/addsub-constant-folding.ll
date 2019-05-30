; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=X86,SSE,X86-SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=X64,SSE,X64-SSE

declare void @use(<4 x i32> %arg)

; (x+c1)+c2

define <4 x i32> @add_const_add_const(<4 x i32> %arg) {
; X86-LABEL: add_const_add_const:
; X86:       # %bb.0:
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_add_const:
; X64:       # %bb.0:
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_add_const_extrause(<4 x i32> %arg) {
; X86-LABEL: add_const_add_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X86-NEXT:    paddd %xmm1, %xmm0
; X86-NEXT:    calll use
; X86-NEXT:    movdqu (%esp), %xmm0 # 16-byte Reload
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: add_const_add_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    callq use
; X64-NEXT:    movdqa (%rsp), %xmm0 # 16-byte Reload
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_add_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: add_const_add_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_add_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (x+c1)-c2

define <4 x i32> @add_const_sub_const(<4 x i32> %arg) {
; X86-LABEL: add_const_sub_const:
; X86:       # %bb.0:
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_sub_const:
; X64:       # %bb.0:
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_sub_const_extrause(<4 x i32> %arg) {
; X86-LABEL: add_const_sub_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    calll use
; X86-NEXT:    movdqu (%esp), %xmm0 # 16-byte Reload
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: add_const_sub_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    callq use
; X64-NEXT:    movdqa (%rsp), %xmm0 # 16-byte Reload
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_sub_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: add_const_sub_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = <4294967277,u,u,4294967290>
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_sub_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = <4294967277,u,u,4294967290>
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; c2-(x+c1)

define <4 x i32> @add_const_const_sub(<4 x i32> %arg) {
; X86-LABEL: add_const_const_sub:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [4294967290,4294967290,4294967290,4294967290]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_const_sub:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [4294967290,4294967290,4294967290,4294967290]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_const_sub_extrause(<4 x i32> %arg) {
; X86-LABEL: add_const_const_sub_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X86-NEXT:    paddd %xmm1, %xmm0
; X86-NEXT:    calll use
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [4294967290,4294967290,4294967290,4294967290]
; X86-NEXT:    movdqu (%esp), %xmm1 # 16-byte Reload
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: add_const_const_sub_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X64-NEXT:    paddd %xmm1, %xmm0
; X64-NEXT:    callq use
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [4294967290,4294967290,4294967290,4294967290]
; X64-NEXT:    psubd (%rsp), %xmm0 # 16-byte Folded Reload
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @add_const_const_sub_nonsplat(<4 x i32> %arg) {
; X86-LABEL: add_const_const_sub_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = <4294967277,u,u,4294967290>
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: add_const_const_sub_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = <4294967277,u,u,4294967290>
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = add <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; (x-c1)+c2

define <4 x i32> @sub_const_add_const(<4 x i32> %arg) {
; X86-LABEL: sub_const_add_const:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_add_const:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_add_const_extrause(<4 x i32> %arg) {
; X86-LABEL: sub_const_add_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    calll use
; X86-NEXT:    movdqu (%esp), %xmm0 # 16-byte Reload
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_add_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    callq use
; X64-NEXT:    movdqa (%rsp), %xmm0 # 16-byte Reload
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_add_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: sub_const_add_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_add_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (x-c1)-c2

define <4 x i32> @sub_const_sub_const(<4 x i32> %arg) {
; X86-LABEL: sub_const_sub_const:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_sub_const:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_sub_const_extrause(<4 x i32> %arg) {
; X86-LABEL: sub_const_sub_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    calll use
; X86-NEXT:    movdqu (%esp), %xmm0 # 16-byte Reload
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_sub_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    callq use
; X64-NEXT:    movdqa (%rsp), %xmm0 # 16-byte Reload
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_sub_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: sub_const_sub_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_sub_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; c2-(x-c1)

define <4 x i32> @sub_const_const_sub(<4 x i32> %arg) {
; X86-LABEL: sub_const_const_sub:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [10,10,10,10]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_const_sub:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [10,10,10,10]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_const_sub_extrause(<4 x i32> %arg) {
; X86-LABEL: sub_const_const_sub_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    calll use
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [2,2,2,2]
; X86-NEXT:    movdqu (%esp), %xmm1 # 16-byte Reload
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_const_sub_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    callq use
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [2,2,2,2]
; X64-NEXT:    psubd (%rsp), %xmm0 # 16-byte Folded Reload
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 8, i32 8, i32 8, i32 8>
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @sub_const_const_sub_nonsplat(<4 x i32> %arg) {
; X86-LABEL: sub_const_const_sub_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: sub_const_const_sub_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> %arg, <i32 21, i32 undef, i32 8, i32 8>
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; (c1-x)+c2

define <4 x i32> @const_sub_add_const(<4 x i32> %arg) {
; X86-LABEL: const_sub_add_const:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [10,10,10,10]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_add_const:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [10,10,10,10]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_add_const_extrause(<4 x i32> %arg) {
; X86-LABEL: const_sub_add_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    movdqa %xmm0, %xmm1
; X86-NEXT:    movdqu %xmm0, (%esp) # 16-byte Spill
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    calll use
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [10,10,10,10]
; X86-NEXT:    movdqu (%esp), %xmm1 # 16-byte Reload
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_add_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    movdqa %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm0, (%rsp) # 16-byte Spill
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [8,8,8,8]
; X64-NEXT:    psubd %xmm1, %xmm0
; X64-NEXT:    callq use
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [10,10,10,10]
; X64-NEXT:    psubd (%rsp), %xmm0 # 16-byte Folded Reload
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = add <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_add_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: const_sub_add_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_add_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = <23,u,u,10>
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = add <4 x i32> %t0, <i32 2, i32 3, i32 undef, i32 2>
  ret <4 x i32> %t1
}

; (c1-x)-c2

define <4 x i32> @const_sub_sub_const(<4 x i32> %arg) {
; X86-LABEL: const_sub_sub_const:
; X86:       # %bb.0:
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm1
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_sub_const:
; X64:       # %bb.0:
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    psubd {{.*}}(%rip), %xmm1
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_sub_const_extrause(<4 x i32> %arg) {
; X86-LABEL: const_sub_sub_const_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqu %xmm1, (%esp) # 16-byte Spill
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    calll use
; X86-NEXT:    movdqu (%esp), %xmm0 # 16-byte Reload
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_sub_const_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, (%rsp) # 16-byte Spill
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    callq use
; X64-NEXT:    movdqa (%rsp), %xmm0 # 16-byte Reload
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> %t0, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_sub_const_nonsplat(<4 x i32> %arg) {
; X86-LABEL: const_sub_sub_const_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_sub_const_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}

; c2-(c1-x)

define <4 x i32> @const_sub_const_sub(<4 x i32> %arg) {
; X86-LABEL: const_sub_const_sub:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_const_sub:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_const_sub_extrause(<4 x i32> %arg) {
; X86-LABEL: const_sub_const_sub_extrause:
; X86:       # %bb.0:
; X86-NEXT:    subl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 32
; X86-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X86-NEXT:    psubd %xmm0, %xmm1
; X86-NEXT:    movdqu %xmm1, (%esp) # 16-byte Spill
; X86-NEXT:    movdqa %xmm1, %xmm0
; X86-NEXT:    calll use
; X86-NEXT:    movdqa {{.*#+}} xmm0 = [2,2,2,2]
; X86-NEXT:    movdqu (%esp), %xmm1 # 16-byte Reload
; X86-NEXT:    psubd %xmm1, %xmm0
; X86-NEXT:    addl $28, %esp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_const_sub_extrause:
; X64:       # %bb.0:
; X64-NEXT:    subq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    movdqa {{.*#+}} xmm1 = [8,8,8,8]
; X64-NEXT:    psubd %xmm0, %xmm1
; X64-NEXT:    movdqa %xmm1, (%rsp) # 16-byte Spill
; X64-NEXT:    movdqa %xmm1, %xmm0
; X64-NEXT:    callq use
; X64-NEXT:    movdqa {{.*#+}} xmm0 = [2,2,2,2]
; X64-NEXT:    psubd (%rsp), %xmm0 # 16-byte Folded Reload
; X64-NEXT:    addq $24, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 8, i32 8, i32 8, i32 8>, %arg
  call void @use(<4 x i32> %t0)
  %t1 = sub <4 x i32> <i32 2, i32 2, i32 2, i32 2>, %t0
  ret <4 x i32> %t1
}

define <4 x i32> @const_sub_const_sub_nonsplat(<4 x i32> %arg) {
; X86-LABEL: const_sub_const_sub_nonsplat:
; X86:       # %bb.0:
; X86-NEXT:    psubd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    paddd {{\.LCPI.*}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: const_sub_const_sub_nonsplat:
; X64:       # %bb.0:
; X64-NEXT:    psubd {{.*}}(%rip), %xmm0
; X64-NEXT:    paddd {{.*}}(%rip), %xmm0
; X64-NEXT:    retq
  %t0 = sub <4 x i32> <i32 21, i32 undef, i32 8, i32 8>, %arg
  %t1 = sub <4 x i32> <i32 2, i32 3, i32 undef, i32 2>, %t0
  ret <4 x i32> %t1
}
