; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-unknown-unknown -x86-indirect-branch-tracking | FileCheck %s

; This test is for CET enhancement.
;
; ENDBR32 and ENDBR64 have specific opcodes:
; ENDBR32: F3 0F 1E FB
; ENDBR64: F3 0F 1E FA
; And we want that attackers won’t find unintended ENDBR32/64
; opcode matches in the binary
; Here’s an example:
; If the compiler had to generate asm for the following code:
; a = 0xF30F1EFA
; it could, for example, generate:
; mov 0xF30F1EFA, dword ptr[a]
; In such a case, the binary would include a gadget that starts
; with a fake ENDBR64 opcode. Therefore, we split such generation
; into multiple operations, let it not shows in the binary.

; 0xF30F1EFA == -217112838  ~0xF30F1EFA == 217112837 (0xCF0E105)
; 0x000123F32E0F1EFA == 321002333478650
; ~0x000123F32E0F1EFA == -321002333478651 (0XFFFEDC0CD1F0E105)

; test for MOV64ri
define dso_local i64 @foo(ptr %azx) #0 {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    endbr64
; CHECK-NEXT:    movq %rdi, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movabsq $-321002333478651, %rax # imm = 0xFFFEDC0CD1F0E105
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    andq %rax, (%rdi)
; CHECK-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    retq
entry:
  %azx.addr = alloca ptr, align 8
  store ptr %azx, ptr %azx.addr, align 8
  %0 = load ptr, ptr %azx.addr, align 8
  %1 = load i64, ptr %0, align 8
  %and = and i64 %1, 321002333478650
  %2 = load ptr, ptr %azx.addr, align 8
  store i64 %and, ptr %2, align 8
  %3 = load ptr, ptr %azx.addr, align 8
  %4 = load i64, ptr %3, align 8
  ret i64 %4
}

@bzx = dso_local local_unnamed_addr global i32 -217112837, align 4

; test for AND32ri
define dso_local i32 @foo2() local_unnamed_addr #0 {
; CHECK-LABEL: foo2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    endbr64
; CHECK-NEXT:    movl bzx(%rip), %ecx
; CHECK-NEXT:    addl %ecx, %ecx
; CHECK-NEXT:    movl $217112837, %eax # imm = 0xCF0E105
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    andl %ecx, %eax
; CHECK-NEXT:    retq
entry:
  %0 = load i32, ptr @bzx, align 4
  %mul = shl nsw i32 %0, 1
  %and = and i32 %mul, -217112838
  ret i32 %and
}


@czx = dso_local global i32 -217112837, align 4

; test for AND32mi
define dso_local nonnull ptr @foo3() local_unnamed_addr #0 {
; CHECK-LABEL: foo3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    endbr64
; CHECK-NEXT:    movl $217112837, %eax # imm = 0xCF0E105
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    andl %eax, czx(%rip)
; CHECK-NEXT:    movl $czx, %eax
; CHECK-NEXT:    retq
entry:
  %0 = load i32, ptr @czx, align 4
  %and = and i32 %0, -217112838
  store i32 %and, ptr @czx, align 4
  ret ptr @czx
}

; test for MOV32mi
define dso_local i32 @foo4() #0 {
; CHECK-LABEL: foo4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    endbr64
; CHECK-NEXT:    movl $217112837, %eax # imm = 0xCF0E105
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    movl %eax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    retq
entry:
  %dzx = alloca i32, align 4
  store i32 -217112838, ptr %dzx, align 4
  %0 = load i32, ptr %dzx, align 4
  ret i32 %0
}

define dso_local i64 @foo5() #0 {
; CHECK-LABEL: foo5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    endbr64
; CHECK-NEXT:    movabsq $-4077854459, %rax # imm = 0xFFFFFFFF0CF0E105
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    retq
entry:
  %ezx = alloca i64, align 8
  store i64 4077854458, ptr %ezx, align 8
  %0 = load i64, ptr %ezx, align 8
  ret i64 %0
}
