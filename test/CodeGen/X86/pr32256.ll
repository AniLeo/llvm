; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i686-unknown-unknown -O0 -mcpu=skx | FileCheck %s

@c = external global i8, align 1

; Function Attrs: noinline nounwind
define void @_Z1av() {
; CHECK-LABEL: _Z1av:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    subl $6, %esp
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 10
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    kmovd %eax, %k0
; CHECK-NEXT:    movb c, %cl
; CHECK-NEXT:    # implicit-def: %EAX
; CHECK-NEXT:    movb %cl, %al
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    kmovw %eax, %k1
; CHECK-NEXT:    kmovq %k1, %k2
; CHECK-NEXT:    kxnorw %k0, %k0, %k3
; CHECK-NEXT:    kshiftrw $15, %k3, %k3
; CHECK-NEXT:    kxorw %k3, %k1, %k1
; CHECK-NEXT:    kmovd %k1, %eax
; CHECK-NEXT:    movb %al, %cl
; CHECK-NEXT:    testb $1, %cl
; CHECK-NEXT:    kmovw %k2, {{[0-9]+}}(%esp) # 2-byte Spill
; CHECK-NEXT:    kmovw %k0, (%esp) # 2-byte Spill
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:    jmp .LBB0_2
; CHECK-NEXT:  .LBB0_1: # %land.rhs
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    kmovd %eax, %k0
; CHECK-NEXT:    kmovw %k0, (%esp) # 2-byte Spill
; CHECK-NEXT:    jmp .LBB0_2
; CHECK-NEXT:  .LBB0_2: # %land.end
; CHECK-NEXT:    kmovw (%esp), %k0 # 2-byte Reload
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    movb %al, %cl
; CHECK-NEXT:    andb $1, %cl
; CHECK-NEXT:    movb %cl, {{[0-9]+}}(%esp)
; CHECK-NEXT:    addl $6, %esp
; CHECK-NEXT:    retl
entry:
  %b = alloca i8, align 1
  %0 = load i8, i8* @c, align 1
  %tobool = trunc i8 %0 to i1
  %lnot = xor i1 %tobool, true
  br i1 %lnot, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %entry
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %1 = phi i1 [ false, %entry ], [ false, %land.rhs ]
  %conv = zext i1 %1 to i8
  store i8 %conv, i8* %b, align 1
  ret void
}
