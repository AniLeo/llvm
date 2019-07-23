; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -O3 < %s | FileCheck %s -check-prefix=PPC64LE

target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-unknown-linux-gnu"

@global.6 = external global i32*

declare void @barney.88(i1, i32*)
declare void @barney.94(i8*, i32)

define void @redundancy_on_ppc_only(i1 %arg7) {
; PPC64LE-LABEL: redundancy_on_ppc_only:
; PPC64LE:       # %bb.0: # %bb
; PPC64LE-NEXT:    mflr 0
; PPC64LE-NEXT:    andi. 3, 3, 1
; PPC64LE-NEXT:    std 0, 16(1)
; PPC64LE-NEXT:    stdu 1, -32(1)
; PPC64LE-NEXT:    .cfi_def_cfa_offset 32
; PPC64LE-NEXT:    .cfi_offset lr, 16
; PPC64LE-NEXT:    li 3, 1
; PPC64LE-NEXT:    li 4, 0
; PPC64LE-NEXT:    isel 3, 3, 4, 1
; PPC64LE-NEXT:    bl barney.88
; PPC64LE-NEXT:    nop
; PPC64LE-NEXT:    addi 1, 1, 32
; PPC64LE-NEXT:    ld 0, 16(1)
; PPC64LE-NEXT:    mtlr 0
; PPC64LE-NEXT:    blr
bb:
  br label %bb10

bb10:                                             ; preds = %bb
  call void @barney.88(i1 %arg7, i32* null)
  ret void
}

define void @redundancy_on_ppc_and_other_targets() {
; PPC64LE-LABEL: redundancy_on_ppc_and_other_targets:
; PPC64LE:       # %bb.0:
; PPC64LE-NEXT:    mflr 0
; PPC64LE-NEXT:    std 0, 16(1)
; PPC64LE-NEXT:    stdu 1, -32(1)
; PPC64LE-NEXT:    .cfi_def_cfa_offset 32
; PPC64LE-NEXT:    .cfi_offset lr, 16
; PPC64LE-NEXT:    addis 3, 2, .LC0@toc@ha
; PPC64LE-NEXT:    ld 3, .LC0@toc@l(3)
; PPC64LE-NEXT:    li 4, 0
; PPC64LE-NEXT:    std 4, 0(3)
; PPC64LE-NEXT:    bl barney.94
; PPC64LE-NEXT:    nop
  store i32* null, i32** @global.6
  call void @barney.94(i8* undef, i32 0)
  unreachable
}
