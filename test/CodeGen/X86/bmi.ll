; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+bmi,+bmi2 | FileCheck %s

declare i8 @llvm.cttz.i8(i8, i1)
declare i16 @llvm.cttz.i16(i16, i1)
declare i32 @llvm.cttz.i32(i32, i1)
declare i64 @llvm.cttz.i64(i64, i1)

define i8 @t1(i8 %x)   {
; CHECK-LABEL: t1:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    tzcntl %eax, %ecx
; CHECK-NEXT:    cmpl $32, %ecx
; CHECK-NEXT:    movl $8, %eax
; CHECK-NEXT:    cmovnel %ecx, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i8 @llvm.cttz.i8( i8 %x, i1 false )
  ret i8 %tmp
}

define i16 @t2(i16 %x)   {
; CHECK-LABEL: t2:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntw %di, %ax
; CHECK-NEXT:    retq
;
  %tmp = tail call i16 @llvm.cttz.i16( i16 %x, i1 false )
  ret i16 %tmp
}

define i32 @t3(i32 %x)   {
; CHECK-LABEL: t3:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntl %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.cttz.i32( i32 %x, i1 false )
  ret i32 %tmp
}

define i32 @tzcnt32_load(i32* %x)   {
; CHECK-LABEL: tzcnt32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntl (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = tail call i32 @llvm.cttz.i32(i32 %x1, i1 false )
  ret i32 %tmp
}

define i64 @t4(i64 %x)   {
; CHECK-LABEL: t4:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntq %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.cttz.i64( i64 %x, i1 false )
  ret i64 %tmp
}

define i8 @t5(i8 %x)   {
; CHECK-LABEL: t5:
; CHECK:       # BB#0:
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    tzcntl %eax, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i8 @llvm.cttz.i8( i8 %x, i1 true )
  ret i8 %tmp
}

define i16 @t6(i16 %x)   {
; CHECK-LABEL: t6:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntw %di, %ax
; CHECK-NEXT:    retq
;
  %tmp = tail call i16 @llvm.cttz.i16( i16 %x, i1 true )
  ret i16 %tmp
}

define i32 @t7(i32 %x)   {
; CHECK-LABEL: t7:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntl %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.cttz.i32( i32 %x, i1 true )
  ret i32 %tmp
}

define i64 @t8(i64 %x)   {
; CHECK-LABEL: t8:
; CHECK:       # BB#0:
; CHECK-NEXT:    tzcntq %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.cttz.i64( i64 %x, i1 true )
  ret i64 %tmp
}

define i32 @andn32(i32 %x, i32 %y)   {
; CHECK-LABEL: andn32:
; CHECK:       # BB#0:
; CHECK-NEXT:    andnl %esi, %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp1 = xor i32 %x, -1
  %tmp2 = and i32 %y, %tmp1
  ret i32 %tmp2
}

define i32 @andn32_load(i32 %x, i32* %y)   {
; CHECK-LABEL: andn32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    andnl (%rsi), %edi, %eax
; CHECK-NEXT:    retq
;
  %y1 = load i32, i32* %y
  %tmp1 = xor i32 %x, -1
  %tmp2 = and i32 %y1, %tmp1
  ret i32 %tmp2
}

define i64 @andn64(i64 %x, i64 %y)   {
; CHECK-LABEL: andn64:
; CHECK:       # BB#0:
; CHECK-NEXT:    andnq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp1 = xor i64 %x, -1
  %tmp2 = and i64 %tmp1, %y
  ret i64 %tmp2
}

define i32 @bextr32(i32 %x, i32 %y)   {
; CHECK-LABEL: bextr32:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextrl %esi, %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i32 @bextr32_load(i32* %x, i32 %y)   {
; CHECK-LABEL: bextr32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextrl %esi, (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = tail call i32 @llvm.x86.bmi.bextr.32(i32 %x1, i32 %y)
  ret i32 %tmp
}

declare i32 @llvm.x86.bmi.bextr.32(i32, i32)

define i32 @bextr32b(i32 %x)  uwtable  ssp {
; CHECK-LABEL: bextr32b:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $3076, %eax # imm = 0xC04
; CHECK-NEXT:    bextrl %eax, %edi, %eax
; CHECK-NEXT:    retq
;
  %1 = lshr i32 %x, 4
  %2 = and i32 %1, 4095
  ret i32 %2
}

define i32 @bextr32b_load(i32* %x)  uwtable  ssp {
; CHECK-LABEL: bextr32b_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $3076, %eax # imm = 0xC04
; CHECK-NEXT:    bextrl %eax, (%rdi), %eax
; CHECK-NEXT:    retq
;
  %1 = load i32, i32* %x
  %2 = lshr i32 %1, 4
  %3 = and i32 %2, 4095
  ret i32 %3
}

define i64 @bextr64(i64 %x, i64 %y)   {
; CHECK-LABEL: bextr64:
; CHECK:       # BB#0:
; CHECK-NEXT:    bextrq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.x86.bmi.bextr.64(i64 %x, i64 %y)
  ret i64 %tmp
}

declare i64 @llvm.x86.bmi.bextr.64(i64, i64)

define i64 @bextr64b(i64 %x)  uwtable  ssp {
; CHECK-LABEL: bextr64b:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $3076, %eax # imm = 0xC04
; CHECK-NEXT:    bextrq %rax, %rdi, %rax
; CHECK-NEXT:    retq
;
  %1 = lshr i64 %x, 4
  %2 = and i64 %1, 4095
  ret i64 %2
}

define i64 @bextr64b_load(i64* %x) {
; CHECK-LABEL: bextr64b_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $3076, %eax # imm = 0xC04
; CHECK-NEXT:    bextrq %rax, (%rdi), %rax
; CHECK-NEXT:    retq
;
  %1 = load i64, i64* %x, align 8
  %2 = lshr i64 %1, 4
  %3 = and i64 %2, 4095
  ret i64 %3
}

define i32 @non_bextr32(i32 %x) {
; CHECK-LABEL: non_bextr32:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    shrl $2, %edi
; CHECK-NEXT:    andl $111, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
;
entry:
  %shr = lshr i32 %x, 2
  %and = and i32 %shr, 111
  ret i32 %and
}

define i64 @non_bextr64(i64 %x) {
; CHECK-LABEL: non_bextr64:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    shrq $2, %rdi
; CHECK-NEXT:    movabsq $8589934590, %rax # imm = 0x1FFFFFFFE
; CHECK-NEXT:    andq %rdi, %rax
; CHECK-NEXT:    retq
;
entry:
  %shr = lshr i64 %x, 2
  %and = and i64 %shr, 8589934590
  ret i64 %and
}

define i32 @bzhi32(i32 %x, i32 %y)   {
; CHECK-LABEL: bzhi32:
; CHECK:       # BB#0:
; CHECK-NEXT:    bzhil %esi, %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i32 @bzhi32_load(i32* %x, i32 %y)   {
; CHECK-LABEL: bzhi32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    bzhil %esi, (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = tail call i32 @llvm.x86.bmi.bzhi.32(i32 %x1, i32 %y)
  ret i32 %tmp
}

declare i32 @llvm.x86.bmi.bzhi.32(i32, i32)

define i64 @bzhi64(i64 %x, i64 %y)   {
; CHECK-LABEL: bzhi64:
; CHECK:       # BB#0:
; CHECK-NEXT:    bzhiq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.x86.bmi.bzhi.64(i64 %x, i64 %y)
  ret i64 %tmp
}

declare i64 @llvm.x86.bmi.bzhi.64(i64, i64)

define i32 @bzhi32b(i32 %x, i8 zeroext %index) {
; CHECK-LABEL: bzhi32b:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bzhil %esi, %edi, %eax
; CHECK-NEXT:    retq
;
entry:
  %conv = zext i8 %index to i32
  %shl = shl i32 1, %conv
  %sub = add nsw i32 %shl, -1
  %and = and i32 %sub, %x
  ret i32 %and
}

define i32 @bzhi32b_load(i32* %w, i8 zeroext %index) {
; CHECK-LABEL: bzhi32b_load:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bzhil %esi, (%rdi), %eax
; CHECK-NEXT:    retq
;
entry:
  %x = load i32, i32* %w
  %conv = zext i8 %index to i32
  %shl = shl i32 1, %conv
  %sub = add nsw i32 %shl, -1
  %and = and i32 %sub, %x
  ret i32 %and
}

define i32 @bzhi32c(i32 %x, i8 zeroext %index) {
; CHECK-LABEL: bzhi32c:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bzhil %esi, %edi, %eax
; CHECK-NEXT:    retq
;
entry:
  %conv = zext i8 %index to i32
  %shl = shl i32 1, %conv
  %sub = add nsw i32 %shl, -1
  %and = and i32 %x, %sub
  ret i32 %and
}

define i64 @bzhi64b(i64 %x, i8 zeroext %index) {
; CHECK-LABEL: bzhi64b:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    bzhiq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
entry:
  %conv = zext i8 %index to i64
  %shl = shl i64 1, %conv
  %sub = add nsw i64 %shl, -1
  %and = and i64 %x, %sub
  ret i64 %and
}

define i64 @bzhi64_constant_mask(i64 %x) {
; CHECK-LABEL: bzhi64_constant_mask:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movb $62, %al
; CHECK-NEXT:    bzhiq %rax, %rdi, %rax
; CHECK-NEXT:    retq
;
entry:
  %and = and i64 %x, 4611686018427387903
  ret i64 %and
}

define i64 @bzhi64_small_constant_mask(i64 %x) {
; CHECK-LABEL: bzhi64_small_constant_mask:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    andl $2147483647, %edi # imm = 0x7FFFFFFF
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
;
entry:
  %and = and i64 %x, 2147483647
  ret i64 %and
}

define i32 @blsi32(i32 %x)   {
; CHECK-LABEL: blsi32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsil %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = sub i32 0, %x
  %tmp2 = and i32 %x, %tmp
  ret i32 %tmp2
}

define i32 @blsi32_load(i32* %x)   {
; CHECK-LABEL: blsi32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsil (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = sub i32 0, %x1
  %tmp2 = and i32 %x1, %tmp
  ret i32 %tmp2
}

define i64 @blsi64(i64 %x)   {
; CHECK-LABEL: blsi64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsiq %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = sub i64 0, %x
  %tmp2 = and i64 %tmp, %x
  ret i64 %tmp2
}

define i32 @blsmsk32(i32 %x)   {
; CHECK-LABEL: blsmsk32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsmskl %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = sub i32 %x, 1
  %tmp2 = xor i32 %x, %tmp
  ret i32 %tmp2
}

define i32 @blsmsk32_load(i32* %x)   {
; CHECK-LABEL: blsmsk32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsmskl (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = sub i32 %x1, 1
  %tmp2 = xor i32 %x1, %tmp
  ret i32 %tmp2
}

define i64 @blsmsk64(i64 %x)   {
; CHECK-LABEL: blsmsk64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsmskq %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = sub i64 %x, 1
  %tmp2 = xor i64 %tmp, %x
  ret i64 %tmp2
}

define i32 @blsr32(i32 %x)   {
; CHECK-LABEL: blsr32:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsrl %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = sub i32 %x, 1
  %tmp2 = and i32 %x, %tmp
  ret i32 %tmp2
}

define i32 @blsr32_load(i32* %x)   {
; CHECK-LABEL: blsr32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsrl (%rdi), %eax
; CHECK-NEXT:    retq
;
  %x1 = load i32, i32* %x
  %tmp = sub i32 %x1, 1
  %tmp2 = and i32 %x1, %tmp
  ret i32 %tmp2
}

define i64 @blsr64(i64 %x)   {
; CHECK-LABEL: blsr64:
; CHECK:       # BB#0:
; CHECK-NEXT:    blsrq %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = sub i64 %x, 1
  %tmp2 = and i64 %tmp, %x
  ret i64 %tmp2
}

define i32 @pdep32(i32 %x, i32 %y)   {
; CHECK-LABEL: pdep32:
; CHECK:       # BB#0:
; CHECK-NEXT:    pdepl %esi, %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i32 @pdep32_load(i32 %x, i32* %y)   {
; CHECK-LABEL: pdep32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    pdepl (%rsi), %edi, %eax
; CHECK-NEXT:    retq
;
  %y1 = load i32, i32* %y
  %tmp = tail call i32 @llvm.x86.bmi.pdep.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

declare i32 @llvm.x86.bmi.pdep.32(i32, i32)

define i64 @pdep64(i64 %x, i64 %y)   {
; CHECK-LABEL: pdep64:
; CHECK:       # BB#0:
; CHECK-NEXT:    pdepq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.x86.bmi.pdep.64(i64 %x, i64 %y)
  ret i64 %tmp
}

declare i64 @llvm.x86.bmi.pdep.64(i64, i64)

define i32 @pext32(i32 %x, i32 %y)   {
; CHECK-LABEL: pext32:
; CHECK:       # BB#0:
; CHECK-NEXT:    pextl %esi, %edi, %eax
; CHECK-NEXT:    retq
;
  %tmp = tail call i32 @llvm.x86.bmi.pext.32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i32 @pext32_load(i32 %x, i32* %y)   {
; CHECK-LABEL: pext32_load:
; CHECK:       # BB#0:
; CHECK-NEXT:    pextl (%rsi), %edi, %eax
; CHECK-NEXT:    retq
;
  %y1 = load i32, i32* %y
  %tmp = tail call i32 @llvm.x86.bmi.pext.32(i32 %x, i32 %y1)
  ret i32 %tmp
}

declare i32 @llvm.x86.bmi.pext.32(i32, i32)

define i64 @pext64(i64 %x, i64 %y)   {
; CHECK-LABEL: pext64:
; CHECK:       # BB#0:
; CHECK-NEXT:    pextq %rsi, %rdi, %rax
; CHECK-NEXT:    retq
;
  %tmp = tail call i64 @llvm.x86.bmi.pext.64(i64 %x, i64 %y)
  ret i64 %tmp
}

declare i64 @llvm.x86.bmi.pext.64(i64, i64)

