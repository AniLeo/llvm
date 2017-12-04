; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 | FileCheck %s

define i8 @shl_i8(i8 %a, i8 %b) {
; CHECK-LABEL: shl_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    shlb %cl, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i8 %a, %b
  ret i8 %c
}

define i16 @shl_i16(i16 %a, i16 %b) {
; CHECK-LABEL: shl_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %cx<kill>
; CHECK-NEXT:    shlw %cl, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i16 %a, %b
  ret i16 %c
}

define i32 @shl_i32(i32 %a, i32 %b) {
; CHECK-LABEL: shl_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %ecx<kill>
; CHECK-NEXT:    shll %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i32 %a, %b
  ret i32 %c
}

define i64 @shl_i64(i64 %a, i64 %b) {
; CHECK-LABEL: shl_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movq %rsi, %rcx
; CHECK-NEXT:    ## kill: %cl<def> %rcx<kill>
; CHECK-NEXT:    shlq %cl, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = shl i64 %a, %b
  ret i64 %c
}

define i8 @lshr_i8(i8 %a, i8 %b) {
; CHECK-LABEL: lshr_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    shrb %cl, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i8 %a, %b
  ret i8 %c
}

define i16 @lshr_i16(i16 %a, i16 %b) {
; CHECK-LABEL: lshr_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %cx<kill>
; CHECK-NEXT:    shrw %cl, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i16 %a, %b
  ret i16 %c
}

define i32 @lshr_i32(i32 %a, i32 %b) {
; CHECK-LABEL: lshr_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %ecx<kill>
; CHECK-NEXT:    shrl %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i32 %a, %b
  ret i32 %c
}

define i64 @lshr_i64(i64 %a, i64 %b) {
; CHECK-LABEL: lshr_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movq %rsi, %rcx
; CHECK-NEXT:    ## kill: %cl<def> %rcx<kill>
; CHECK-NEXT:    shrq %cl, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = lshr i64 %a, %b
  ret i64 %c
}

define i8 @ashr_i8(i8 %a, i8 %b) {
; CHECK-LABEL: ashr_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    sarb %cl, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i8 %a, %b
  ret i8 %c
}

define i16 @ashr_i16(i16 %a, i16 %b) {
; CHECK-LABEL: ashr_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %cx<kill>
; CHECK-NEXT:    sarw %cl, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i16 %a, %b
  ret i16 %c
}

define i32 @ashr_i32(i32 %a, i32 %b) {
; CHECK-LABEL: ashr_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    ## kill: %cl<def> %ecx<kill>
; CHECK-NEXT:    sarl %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i32 %a, %b
  ret i32 %c
}

define i64 @ashr_i64(i64 %a, i64 %b) {
; CHECK-LABEL: ashr_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movq %rsi, %rcx
; CHECK-NEXT:    ## kill: %cl<def> %rcx<kill>
; CHECK-NEXT:    sarq %cl, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = ashr i64 %a, %b
  ret i64 %c
}

define i8 @shl_imm1_i8(i8 %a) {
; CHECK-LABEL: shl_imm1_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shlb $1, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i8 %a, 1
  ret i8 %c
}

define i16 @shl_imm1_i16(i16 %a) {
; CHECK-LABEL: shl_imm1_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    ## kill: %edi<def> %edi<kill> %rdi<def>
; CHECK-NEXT:    leal (,%rdi,2), %eax
; CHECK-NEXT:    ## kill: %ax<def> %ax<kill> %eax<kill>
; CHECK-NEXT:    retq
  %c = shl i16 %a, 1
  ret i16 %c
}

define i32 @shl_imm1_i32(i32 %a) {
; CHECK-LABEL: shl_imm1_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    ## kill: %edi<def> %edi<kill> %rdi<def>
; CHECK-NEXT:    leal (,%rdi,2), %eax
; CHECK-NEXT:    retq
  %c = shl i32 %a, 1
  ret i32 %c
}

define i64 @shl_imm1_i64(i64 %a) {
; CHECK-LABEL: shl_imm1_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    leaq (,%rdi,2), %rax
; CHECK-NEXT:    retq
  %c = shl i64 %a, 1
  ret i64 %c
}

define i8 @lshr_imm1_i8(i8 %a) {
; CHECK-LABEL: lshr_imm1_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrb $1, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i8 %a, 1
  ret i8 %c
}

define i16 @lshr_imm1_i16(i16 %a) {
; CHECK-LABEL: lshr_imm1_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrw $1, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i16 %a, 1
  ret i16 %c
}

define i32 @lshr_imm1_i32(i32 %a) {
; CHECK-LABEL: lshr_imm1_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrl $1, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i32 %a, 1
  ret i32 %c
}

define i64 @lshr_imm1_i64(i64 %a) {
; CHECK-LABEL: lshr_imm1_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrq $1, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = lshr i64 %a, 1
  ret i64 %c
}

define i8 @ashr_imm1_i8(i8 %a) {
; CHECK-LABEL: ashr_imm1_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarb $1, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i8 %a, 1
  ret i8 %c
}

define i16 @ashr_imm1_i16(i16 %a) {
; CHECK-LABEL: ashr_imm1_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarw $1, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i16 %a, 1
  ret i16 %c
}

define i32 @ashr_imm1_i32(i32 %a) {
; CHECK-LABEL: ashr_imm1_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarl $1, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i32 %a, 1
  ret i32 %c
}

define i64 @ashr_imm1_i64(i64 %a) {
; CHECK-LABEL: ashr_imm1_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarq $1, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = ashr i64 %a, 1
  ret i64 %c
}

define i8 @shl_imm4_i8(i8 %a) {
; CHECK-LABEL: shl_imm4_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shlb $4, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i8 %a, 4
  ret i8 %c
}

define i16 @shl_imm4_i16(i16 %a) {
; CHECK-LABEL: shl_imm4_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shlw $4, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i16 %a, 4
  ret i16 %c
}

define i32 @shl_imm4_i32(i32 %a) {
; CHECK-LABEL: shl_imm4_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shll $4, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = shl i32 %a, 4
  ret i32 %c
}

define i64 @shl_imm4_i64(i64 %a) {
; CHECK-LABEL: shl_imm4_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shlq $4, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = shl i64 %a, 4
  ret i64 %c
}

define i8 @lshr_imm4_i8(i8 %a) {
; CHECK-LABEL: lshr_imm4_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrb $4, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i8 %a, 4
  ret i8 %c
}

define i16 @lshr_imm4_i16(i16 %a) {
; CHECK-LABEL: lshr_imm4_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrw $4, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i16 %a, 4
  ret i16 %c
}

define i32 @lshr_imm4_i32(i32 %a) {
; CHECK-LABEL: lshr_imm4_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrl $4, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = lshr i32 %a, 4
  ret i32 %c
}

define i64 @lshr_imm4_i64(i64 %a) {
; CHECK-LABEL: lshr_imm4_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    shrq $4, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = lshr i64 %a, 4
  ret i64 %c
}

define i8 @ashr_imm4_i8(i8 %a) {
; CHECK-LABEL: ashr_imm4_i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarb $4, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i8 %a, 4
  ret i8 %c
}

define i16 @ashr_imm4_i16(i16 %a) {
; CHECK-LABEL: ashr_imm4_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarw $4, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i16 %a, 4
  ret i16 %c
}

define i32 @ashr_imm4_i32(i32 %a) {
; CHECK-LABEL: ashr_imm4_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarl $4, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %c = ashr i32 %a, 4
  ret i32 %c
}

define i64 @ashr_imm4_i64(i64 %a) {
; CHECK-LABEL: ashr_imm4_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sarq $4, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %c = ashr i64 %a, 4
  ret i64 %c
}
