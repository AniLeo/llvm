; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-windows-msvc19.11.0 | FileCheck %s

; This matches the code produced by clang/lib/CodeGen/bittest-intrin.c

@sink = global i8 0, align 1

define void @test32(i32* %base, i32 %idx) {
; CHECK-LABEL: test32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btcl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btrl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btsl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    lock btrl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    lock btsl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    lock btsl %edx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = tail call i8 asm sideeffect "btl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %0, i8* @sink, align 1
  %1 = tail call i8 asm sideeffect "btcl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %1, i8* @sink, align 1
  %2 = tail call i8 asm sideeffect "btrl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %2, i8* @sink, align 1
  %3 = tail call i8 asm sideeffect "btsl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %3, i8* @sink, align 1
  %4 = tail call i8 asm sideeffect "lock btrl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %4, i8* @sink, align 1
  %5 = tail call i8 asm sideeffect "lock btsl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %5, i8* @sink, align 1
  %6 = tail call i8 asm sideeffect "lock btsl $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i32* %base, i32 %idx)
  store volatile i8 %6, i8* @sink, align 1
  ret void
}

; Function Attrs: nounwind uwtable
define void @test64(i64* %base, i64 %idx) {
; CHECK-LABEL: test64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btcq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btrq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    btsq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    lock btrq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    #APP
; CHECK-NEXT:    lock btsq %rdx, (%rcx)
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    setb sink(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = tail call i8 asm sideeffect "btq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %0, i8* @sink, align 1
  %1 = tail call i8 asm sideeffect "btcq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %1, i8* @sink, align 1
  %2 = tail call i8 asm sideeffect "btrq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %2, i8* @sink, align 1
  %3 = tail call i8 asm sideeffect "btsq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %3, i8* @sink, align 1
  %4 = tail call i8 asm sideeffect "lock btrq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %4, i8* @sink, align 1
  %5 = tail call i8 asm sideeffect "lock btsq $2, ($1)", "={@ccc},r,r,~{cc},~{memory},~{dirflag},~{fpsr},~{flags}"(i64* %base, i64 %idx)
  store volatile i8 %5, i8* @sink, align 1
  ret void
}
