; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+popcnt | FileCheck %s -check-prefixes=CHECK,POPCOUNT
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=-popcnt | FileCheck %s -check-prefixes=CHECK,NO-POPCOUNT

declare i8 @llvm.ctpop.i8(i8) nounwind readnone
declare i64 @llvm.ctpop.i64(i64) nounwind readnone

define i32 @test1(i64 %x) nounwind readnone {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    leaq -1(%rdi), %rcx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rcx, %rdi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cast = trunc i64 %count to i32
  %cmp = icmp ugt i32 %cast, 1
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}


define i32 @test2(i64 %x) nounwind readnone {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    leaq -1(%rdi), %rcx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rcx, %rdi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cmp = icmp ult i64 %count, 2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @test3(i64 %x) nounwind readnone {
; POPCOUNT-LABEL: test3:
; POPCOUNT:       # %bb.0:
; POPCOUNT-NEXT:    popcntq %rdi, %rcx
; POPCOUNT-NEXT:    andb $63, %cl
; POPCOUNT-NEXT:    xorl %eax, %eax
; POPCOUNT-NEXT:    cmpb $2, %cl
; POPCOUNT-NEXT:    setb %al
; POPCOUNT-NEXT:    retq
;
; NO-POPCOUNT-LABEL: test3:
; NO-POPCOUNT:       # %bb.0:
; NO-POPCOUNT-NEXT:    movq %rdi, %rax
; NO-POPCOUNT-NEXT:    shrq %rax
; NO-POPCOUNT-NEXT:    movabsq $6148914691236517205, %rcx # imm = 0x5555555555555555
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    subq %rcx, %rdi
; NO-POPCOUNT-NEXT:    movabsq $3689348814741910323, %rax # imm = 0x3333333333333333
; NO-POPCOUNT-NEXT:    movq %rdi, %rcx
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    shrq $2, %rdi
; NO-POPCOUNT-NEXT:    andq %rax, %rdi
; NO-POPCOUNT-NEXT:    addq %rcx, %rdi
; NO-POPCOUNT-NEXT:    movq %rdi, %rax
; NO-POPCOUNT-NEXT:    shrq $4, %rax
; NO-POPCOUNT-NEXT:    addq %rdi, %rax
; NO-POPCOUNT-NEXT:    movabsq $1085102592571150095, %rcx # imm = 0xF0F0F0F0F0F0F0F
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    movabsq $72340172838076673, %rdx # imm = 0x101010101010101
; NO-POPCOUNT-NEXT:    imulq %rcx, %rdx
; NO-POPCOUNT-NEXT:    shrq $56, %rdx
; NO-POPCOUNT-NEXT:    andb $63, %dl
; NO-POPCOUNT-NEXT:    xorl %eax, %eax
; NO-POPCOUNT-NEXT:    cmpb $2, %dl
; NO-POPCOUNT-NEXT:    setb %al
; NO-POPCOUNT-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cast = trunc i64 %count to i6 ; Too small for 0-64
  %cmp = icmp ult i6 %cast, 2
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i8 @test4(i8 %x) nounwind readnone {
; POPCOUNT-LABEL: test4:
; POPCOUNT:       # %bb.0:
; POPCOUNT-NEXT:    andl $127, %edi
; POPCOUNT-NEXT:    popcntl %edi, %eax
; POPCOUNT-NEXT:    # kill: def $al killed $al killed $eax
; POPCOUNT-NEXT:    retq
;
; NO-POPCOUNT-LABEL: test4:
; NO-POPCOUNT:       # %bb.0:
; NO-POPCOUNT-NEXT:    # kill: def $edi killed $edi def $rdi
; NO-POPCOUNT-NEXT:    andb $127, %dil
; NO-POPCOUNT-NEXT:    movl %edi, %eax
; NO-POPCOUNT-NEXT:    shrb %al
; NO-POPCOUNT-NEXT:    andb $21, %al
; NO-POPCOUNT-NEXT:    subb %al, %dil
; NO-POPCOUNT-NEXT:    movl %edi, %eax
; NO-POPCOUNT-NEXT:    andb $51, %al
; NO-POPCOUNT-NEXT:    shrb $2, %dil
; NO-POPCOUNT-NEXT:    andb $51, %dil
; NO-POPCOUNT-NEXT:    addb %al, %dil
; NO-POPCOUNT-NEXT:    movl %edi, %eax
; NO-POPCOUNT-NEXT:    shrb $4, %al
; NO-POPCOUNT-NEXT:    addl %edi, %eax
; NO-POPCOUNT-NEXT:    andb $15, %al
; NO-POPCOUNT-NEXT:    # kill: def $al killed $al killed $eax
; NO-POPCOUNT-NEXT:    retq
  %x2 = and i8 %x, 127
  %count = tail call i8 @llvm.ctpop.i8(i8 %x2)
  %and = and i8 %count, 7
  ret i8 %and
}

define i32 @ctpop_eq_one(i64 %x) nounwind readnone {
; POPCOUNT-LABEL: ctpop_eq_one:
; POPCOUNT:       # %bb.0:
; POPCOUNT-NEXT:    popcntq %rdi, %rcx
; POPCOUNT-NEXT:    xorl %eax, %eax
; POPCOUNT-NEXT:    cmpq $1, %rcx
; POPCOUNT-NEXT:    sete %al
; POPCOUNT-NEXT:    retq
;
; NO-POPCOUNT-LABEL: ctpop_eq_one:
; NO-POPCOUNT:       # %bb.0:
; NO-POPCOUNT-NEXT:    movq %rdi, %rax
; NO-POPCOUNT-NEXT:    shrq %rax
; NO-POPCOUNT-NEXT:    movabsq $6148914691236517205, %rcx # imm = 0x5555555555555555
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    subq %rcx, %rdi
; NO-POPCOUNT-NEXT:    movabsq $3689348814741910323, %rax # imm = 0x3333333333333333
; NO-POPCOUNT-NEXT:    movq %rdi, %rcx
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    shrq $2, %rdi
; NO-POPCOUNT-NEXT:    andq %rax, %rdi
; NO-POPCOUNT-NEXT:    addq %rcx, %rdi
; NO-POPCOUNT-NEXT:    movq %rdi, %rax
; NO-POPCOUNT-NEXT:    shrq $4, %rax
; NO-POPCOUNT-NEXT:    addq %rdi, %rax
; NO-POPCOUNT-NEXT:    movabsq $1085102592571150095, %rcx # imm = 0xF0F0F0F0F0F0F0F
; NO-POPCOUNT-NEXT:    andq %rax, %rcx
; NO-POPCOUNT-NEXT:    movabsq $72340172838076673, %rdx # imm = 0x101010101010101
; NO-POPCOUNT-NEXT:    imulq %rcx, %rdx
; NO-POPCOUNT-NEXT:    shrq $56, %rdx
; NO-POPCOUNT-NEXT:    xorl %eax, %eax
; NO-POPCOUNT-NEXT:    cmpq $1, %rdx
; NO-POPCOUNT-NEXT:    sete %al
; NO-POPCOUNT-NEXT:    retq
  %count = tail call i64 @llvm.ctpop.i64(i64 %x)
  %cmp = icmp eq i64 %count, 1
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}
