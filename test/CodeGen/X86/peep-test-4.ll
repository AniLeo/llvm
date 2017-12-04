; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+bmi,+bmi2,+popcnt,+lzcnt | FileCheck %s
declare void @foo(i32)
declare void @foo32(i32)
declare void @foo64(i64)

define void @neg(i32 %x) nounwind {
; CHECK-LABEL: neg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    negl %edi
; CHECK-NEXT:    je .LBB0_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB0_1: # %return
; CHECK-NEXT:    retq
  %sub = sub i32 0, %x
  %cmp = icmp eq i32 %sub, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %sub)
  br label %return

return:
  ret void
}

define void @sar(i32 %x) nounwind {
; CHECK-LABEL: sar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sarl %edi
; CHECK-NEXT:    je .LBB1_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB1_1: # %return
; CHECK-NEXT:    retq
  %ashr = ashr i32 %x, 1
  %cmp = icmp eq i32 %ashr, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %ashr)
  br label %return

return:
  ret void
}

define void @shr(i32 %x) nounwind {
; CHECK-LABEL: shr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrl %edi
; CHECK-NEXT:    je .LBB2_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB2_1: # %return
; CHECK-NEXT:    retq
  %ashr = lshr i32 %x, 1
  %cmp = icmp eq i32 %ashr, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %ashr)
  br label %return

return:
  ret void
}

define void @shri(i32 %x) nounwind {
; CHECK-LABEL: shri:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrl $3, %edi
; CHECK-NEXT:    je .LBB3_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB3_1: # %return
; CHECK-NEXT:    retq
  %ashr = lshr i32 %x, 3
  %cmp = icmp eq i32 %ashr, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %ashr)
  br label %return

return:
  ret void
}

define void @shl(i32 %x) nounwind {
; CHECK-LABEL: shl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addl %edi, %edi
; CHECK-NEXT:    je .LBB4_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB4_1: # %return
; CHECK-NEXT:    retq
  %shl = shl i32 %x, 1
  %cmp = icmp eq i32 %shl, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %shl)
  br label %return

return:
  ret void
}

define void @shli(i32 %x) nounwind {
; CHECK-LABEL: shli:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shll $4, %edi
; CHECK-NEXT:    je .LBB5_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB5_1: # %return
; CHECK-NEXT:    retq
  %shl = shl i32 %x, 4
  %cmp = icmp eq i32 %shl, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %shl)
  br label %return

return:
  ret void
}

define zeroext i1 @adc(i128 %x) nounwind {
; CHECK-LABEL: adc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movabsq $-9223372036854775808, %rax # imm = 0x8000000000000000
; CHECK-NEXT:    addq %rdi, %rax
; CHECK-NEXT:    adcq $0, %rsi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %add = add i128 %x, 9223372036854775808
  %cmp = icmp ult i128 %add, 18446744073709551616
  ret i1 %cmp
}

define zeroext i1 @sbb(i128 %x, i128 %y) nounwind {
; CHECK-LABEL: sbb:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpq %rdx, %rdi
; CHECK-NEXT:    sbbq %rcx, %rsi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    retq
  %sub = sub i128 %x, %y
  %cmp = icmp sge i128 %sub, 0
  ret i1 %cmp
}

define void @andn(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: andn:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andnl %esi, %edi, %edi
; CHECK-NEXT:    je .LBB8_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB8_1: # %return
; CHECK-NEXT:    retq
  %not = xor i32 %x, -1
  %andn = and i32 %y, %not
  %cmp = icmp eq i32 %andn, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %andn)
  br label %return

return:
  ret void
}

declare i32 @llvm.x86.bmi.bextr.32(i32, i32) nounwind readnone
define void @bextr(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: bextr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    bextrl %esi, %edi, %edi
; CHECK-NEXT:    je .LBB9_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB9_1: # %return
; CHECK-NEXT:    retq
  %bextr = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x, i32 %y)
  %cmp = icmp eq i32 %bextr, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %bextr)
  br label %return

return:
  ret void
}

declare i32 @llvm.ctpop.i32(i32) nounwind readnone
define void @popcnt(i32 %x) nounwind {
; CHECK-LABEL: popcnt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    popcntl %edi, %edi
; CHECK-NEXT:    je .LBB10_1
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    jmp foo # TAILCALL
; CHECK-NEXT:  .LBB10_1: # %return
; CHECK-NEXT:    retq
  %popcnt = tail call i32 @llvm.ctpop.i32(i32 %x)
  %cmp = icmp eq i32 %popcnt, 0
  br i1 %cmp, label %return, label %bb
bb:
  tail call void @foo(i32 %popcnt)
  br label %return
return:
  ret void
}

declare i64 @llvm.cttz.i64(i64, i1)
define i64 @testCTZ(i64 %v) nounwind {
; CHECK-LABEL: testCTZ:
; CHECK:       # %bb.0:
; CHECK-NEXT:    tzcntq %rdi, %rcx
; CHECK-NEXT:    movl $255, %eax
; CHECK-NEXT:    cmovaeq %rcx, %rax
; CHECK-NEXT:    retq
  %cnt = tail call i64 @llvm.cttz.i64(i64 %v, i1 true)
  %tobool = icmp eq i64 %v, 0
  %cond = select i1 %tobool, i64 255, i64 %cnt
  ret i64 %cond
}

declare i32 @llvm.cttz.i32(i32, i1)
define void @testCTZ2(i32 %v) nounwind {
; CHECK-LABEL: testCTZ2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    tzcntl %edi, %ebx
; CHECK-NEXT:    jb .LBB12_2
; CHECK-NEXT:  # %bb.1: # %bb
; CHECK-NEXT:    movl %ebx, %edi
; CHECK-NEXT:    callq foo
; CHECK-NEXT:  .LBB12_2: # %return
; CHECK-NEXT:    movl %ebx, %edi
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    jmp foo32 # TAILCALL
  %cnt = tail call i32 @llvm.cttz.i32(i32 %v, i1 true)
  %cmp = icmp eq i32 %v, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %cnt)
  br label %return

return:
  tail call void @foo32(i32 %cnt)
  ret void
}

define void @testCTZ3(i32 %v) nounwind {
; CHECK-LABEL: testCTZ3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    tzcntl %edi, %ebx
; CHECK-NEXT:    jae .LBB13_2
; CHECK-NEXT:  # %bb.1: # %bb
; CHECK-NEXT:    movl %ebx, %edi
; CHECK-NEXT:    callq foo
; CHECK-NEXT:  .LBB13_2: # %return
; CHECK-NEXT:    movl %ebx, %edi
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    jmp foo32 # TAILCALL
  %cnt = tail call i32 @llvm.cttz.i32(i32 %v, i1 true)
  %cmp = icmp ne i32 %v, 0
  br i1 %cmp, label %return, label %bb

bb:
  tail call void @foo(i32 %cnt)
  br label %return

return:
  tail call void @foo32(i32 %cnt)
  ret void
}

declare i64 @llvm.ctlz.i64(i64, i1)
define i64 @testCLZ(i64 %v) nounwind {
; CHECK-LABEL: testCLZ:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lzcntq %rdi, %rcx
; CHECK-NEXT:    movl $255, %eax
; CHECK-NEXT:    cmovaeq %rcx, %rax
; CHECK-NEXT:    retq
  %cnt = tail call i64 @llvm.ctlz.i64(i64 %v, i1 true)
  %tobool = icmp ne i64 %v, 0
  %cond = select i1 %tobool, i64 %cnt, i64 255
  ret i64 %cond
}

declare i64 @llvm.ctpop.i64(i64)
define i64 @testPOPCNT(i64 %v) nounwind {
; CHECK-LABEL: testPOPCNT:
; CHECK:       # %bb.0:
; CHECK-NEXT:    popcntq %rdi, %rcx
; CHECK-NEXT:    movl $255, %eax
; CHECK-NEXT:    cmovneq %rcx, %rax
; CHECK-NEXT:    retq
  %cnt = tail call i64 @llvm.ctpop.i64(i64 %v)
  %tobool = icmp ne i64 %v, 0
  %cond = select i1 %tobool, i64 %cnt, i64 255
  ret i64 %cond
}
