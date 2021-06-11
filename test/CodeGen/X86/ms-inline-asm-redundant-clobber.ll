; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

; This used to crash due to Live Variable analysis removing the redundant eax
; and edx clobbers, but not removing the inline asm flag operands that proceed
; them.

@test_mem = dso_local global [16 x i8] c"UUUUUUUUUUUUUUUU", align 16

; Function Attrs: nounwind uwtable
define dso_local void @foo() local_unnamed_addr {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-EMPTY:
; CHECK-NEXT:    clc
; CHECK-NEXT:    cmpxchg8b test_mem(%rip)
; CHECK-NEXT:    cmpxchg16b test_mem(%rip)
; CHECK-NEXT:    clc
; CHECK-EMPTY:
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    retq
entry:
  tail call void asm sideeffect inteldialect "clc\0A\09cmpxchg8b $0\0A\09cmpxchg16b $1\0A\09clc", "=*m,=*m,~{eax},~{edx},~{flags},~{rax},~{rdx},~{dirflag},~{fpsr},~{flags}"([16 x i8]* nonnull @test_mem, [16 x i8]* nonnull @test_mem) #1
  ret void
}
