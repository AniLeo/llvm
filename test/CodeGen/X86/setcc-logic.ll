; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

define zeroext i1 @all_bits_clear(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %a = icmp eq i32 %P, 0
  %b = icmp eq i32 %Q, 0
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_sign_bits_clear(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_sign_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    retq
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_bits_set(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl %esi, %edi
; CHECK-NEXT:    cmpl $-1, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %a = icmp eq i32 %P, -1
  %b = icmp eq i32 %Q, -1
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @all_sign_bits_set(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_sign_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl %esi, %edi
; CHECK-NEXT:    shrl $31, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = and i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_bits_set(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %a = icmp ne i32 %P, 0
  %b = icmp ne i32 %Q, 0
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_sign_bits_set(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_sign_bits_set:
; CHECK:       # BB#0:
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    shrl $31, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_bits_clear(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl %esi, %edi
; CHECK-NEXT:    cmpl $-1, %edi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %a = icmp ne i32 %P, -1
  %b = icmp ne i32 %Q, -1
  %c = or i1 %a, %b
  ret i1 %c
}

define zeroext i1 @any_sign_bits_clear(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_sign_bits_clear:
; CHECK:       # BB#0:
; CHECK-NEXT:    testl %esi, %edi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    retq
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = or i1 %a, %b
  ret i1 %c
}

; PR3351 - (P == 0) & (Q == 0) -> (P|Q) == 0
define i32 @all_bits_clear_branch(i32* %P, i32* %Q) nounwind {
; CHECK-LABEL: all_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    orq %rsi, %rdi
; CHECK-NEXT:    jne .LBB8_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB8_2: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp eq i32* %P, null
  %b = icmp eq i32* %Q, null
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_sign_bits_clear_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_sign_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    js .LBB9_3
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    js .LBB9_3
; CHECK-NEXT:  # BB#2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB9_3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_bits_set_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    cmpl $-1, %edi
; CHECK-NEXT:    jne .LBB10_3
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    cmpl $-1, %esi
; CHECK-NEXT:    jne .LBB10_3
; CHECK-NEXT:  # BB#2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB10_3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp eq i32 %P, -1
  %b = icmp eq i32 %Q, -1
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @all_sign_bits_set_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: all_sign_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    jns .LBB11_3
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    jns .LBB11_3
; CHECK-NEXT:  # BB#2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB11_3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = and i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

; PR3351 - (P != 0) | (Q != 0) -> (P|Q) != 0
define i32 @any_bits_set_branch(i32* %P, i32* %Q) nounwind {
; CHECK-LABEL: any_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    orq %rsi, %rdi
; CHECK-NEXT:    je .LBB12_2
; CHECK-NEXT:  # BB#1: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB12_2: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp ne i32* %P, null
  %b = icmp ne i32* %Q, null
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_sign_bits_set_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_sign_bits_set_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    js .LBB13_2
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    js .LBB13_2
; CHECK-NEXT:  # BB#3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB13_2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp slt i32 %P, 0
  %b = icmp slt i32 %Q, 0
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_bits_clear_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    cmpl $-1, %edi
; CHECK-NEXT:    jne .LBB14_2
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    cmpl $-1, %esi
; CHECK-NEXT:    jne .LBB14_2
; CHECK-NEXT:  # BB#3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB14_2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp ne i32 %P, -1
  %b = icmp ne i32 %Q, -1
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define i32 @any_sign_bits_clear_branch(i32 %P, i32 %Q) nounwind {
; CHECK-LABEL: any_sign_bits_clear_branch:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    jns .LBB15_2
; CHECK-NEXT:  # BB#1: # %entry
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    jns .LBB15_2
; CHECK-NEXT:  # BB#3: # %return
; CHECK-NEXT:    movl $192, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB15_2: # %bb1
; CHECK-NEXT:    movl $4, %eax
; CHECK-NEXT:    retq
entry:
  %a = icmp sgt i32 %P, -1
  %b = icmp sgt i32 %Q, -1
  %c = or i1 %a, %b
  br i1 %c, label %bb1, label %return

bb1:
  ret i32 4

return:
  ret i32 192
}

define zeroext i1 @ne_neg1_and_ne_zero(i64 %x) nounwind {
; CHECK-LABEL: ne_neg1_and_ne_zero:
; CHECK:       # BB#0:
; CHECK-NEXT:    incq %rdi
; CHECK-NEXT:    cmpq $1, %rdi
; CHECK-NEXT:    seta %al
; CHECK-NEXT:    retq
  %cmp1 = icmp ne i64 %x, -1
  %cmp2 = icmp ne i64 %x, 0
  %and = and i1 %cmp1, %cmp2
  ret i1 %and
}

; PR32401 - https://bugs.llvm.org/show_bug.cgi?id=32401

define zeroext i1 @cmpeq_logical(i8 %a, i8 %b, i8 %c, i8 %d) nounwind {
; CHECK-LABEL: cmpeq_logical:
; CHECK:       # BB#0:
; CHECK-NEXT:    cmpb %sil, %dil
; CHECK-NEXT:    sete %sil
; CHECK-NEXT:    cmpb %cl, %dl
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    retq
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp eq i8 %c, %d
  %and = and i1 %cmp1, %cmp2
  ret i1 %and
}

