; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mcpu=skx | FileCheck %s -check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown -mcpu=skx | FileCheck %s -check-prefix=X64

%struct.AA = type { i24, [4 x i8] }

@obj = external local_unnamed_addr global %struct.AA, align 8
@var_27 = external local_unnamed_addr constant i8, align 1
@var_2 = external local_unnamed_addr constant i16, align 2
@var_24 = external local_unnamed_addr constant i64, align 8
@var_310 = external local_unnamed_addr global i64, align 8
@var_50 = external local_unnamed_addr global i64, align 8
@var_205 = external local_unnamed_addr global i8, align 1
@var_218 = external local_unnamed_addr global i8, align 1

define void @foo() local_unnamed_addr {
; X86-LABEL: foo:
; X86:       # BB#0: # %entry
; X86-NEXT:    pushl %ebp
; X86-NEXT:  .Lcfi0:
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %ebx
; X86-NEXT:  .Lcfi1:
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %edi
; X86-NEXT:  .Lcfi2:
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    pushl %esi
; X86-NEXT:  .Lcfi3:
; X86-NEXT:    .cfi_def_cfa_offset 20
; X86-NEXT:  .Lcfi4:
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:  .Lcfi5:
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:  .Lcfi6:
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:  .Lcfi7:
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl obj, %edx
; X86-NEXT:    movsbl var_27, %eax
; X86-NEXT:    movzwl var_2, %esi
; X86-NEXT:    movl var_310, %ecx
; X86-NEXT:    imull %eax, %ecx
; X86-NEXT:    addl var_24, %ecx
; X86-NEXT:    andl $4194303, %edx # imm = 0x3FFFFF
; X86-NEXT:    leal (%edx,%edx), %ebx
; X86-NEXT:    subl %eax, %ebx
; X86-NEXT:    movl %ebx, %edi
; X86-NEXT:    subl %esi, %edi
; X86-NEXT:    imull %edi, %ecx
; X86-NEXT:    addl $-1437483407, %ecx # imm = 0xAA51BE71
; X86-NEXT:    movl $9, %esi
; X86-NEXT:    xorl %ebp, %ebp
; X86-NEXT:    shldl %cl, %esi, %ebp
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovnel %esi, %ebp
; X86-NEXT:    movl $0, %ecx
; X86-NEXT:    cmovnel %ecx, %esi
; X86-NEXT:    cmpl %edx, %edi
; X86-NEXT:    movl %ebp, var_50+4
; X86-NEXT:    setge var_205
; X86-NEXT:    movl %esi, var_50
; X86-NEXT:    imull %eax, %ebx
; X86-NEXT:    movb %bl, var_218
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
;
; X64-LABEL: foo:
; X64:       # BB#0: # %entry
; X64-NEXT:    movl {{.*}}(%rip), %eax
; X64-NEXT:    movsbl {{.*}}(%rip), %r9d
; X64-NEXT:    movzwl {{.*}}(%rip), %r8d
; X64-NEXT:    movl {{.*}}(%rip), %esi
; X64-NEXT:    imull %r9d, %esi
; X64-NEXT:    addl {{.*}}(%rip), %esi
; X64-NEXT:    andl $4194303, %eax # imm = 0x3FFFFF
; X64-NEXT:    leal (%rax,%rax), %edi
; X64-NEXT:    subl %r9d, %edi
; X64-NEXT:    movl %edi, %edx
; X64-NEXT:    subl %r8d, %edx
; X64-NEXT:    imull %edx, %esi
; X64-NEXT:    addl $-1437483407, %esi # imm = 0xAA51BE71
; X64-NEXT:    movl $9, %ecx
; X64-NEXT:    shlxq %rsi, %rcx, %rcx
; X64-NEXT:    movq %rcx, {{.*}}(%rip)
; X64-NEXT:    cmpl %eax, %edx
; X64-NEXT:    setge {{.*}}(%rip)
; X64-NEXT:    imull %r9d, %edi
; X64-NEXT:    movb %dil, {{.*}}(%rip)
; X64-NEXT:    retq
  entry:
  %bf.load = load i32, i32* bitcast (%struct.AA* @obj to i32*), align 8
  %bf.clear = shl i32 %bf.load, 1
  %add = and i32 %bf.clear, 8388606
  %0 = load i8, i8* @var_27, align 1
  %conv5 = sext i8 %0 to i32
  %sub = sub nsw i32 %add, %conv5
  %1 = load i16, i16* @var_2, align 2
  %conv6 = zext i16 %1 to i32
  %sub7 = sub nsw i32 %sub, %conv6
  %conv8 = sext i32 %sub7 to i64
  %2 = load i64, i64* @var_24, align 8
  %3 = load i64, i64* @var_310, align 8
  %conv9 = sext i8 %0 to i64
  %mul = mul i64 %3, %conv9
  %add10 = add i64 %mul, %2
  %mul11 = mul i64 %add10, %conv8
  %sub12 = add i64 %mul11, 8662905354777116273
  %shl = shl i64 9, %sub12
  store i64 %shl, i64* @var_50, align 8
  %bf.clear14 = and i32 %bf.load, 4194303
  %add21 = shl nuw nsw i32 %bf.clear14, 1
  %sub23 = sub nsw i32 %add21, %conv5
  %sub25 = sub nsw i32 %sub23, %conv6
  %cmp = icmp sge i32 %sub25, %bf.clear14
  %conv30 = zext i1 %cmp to i8
  store i8 %conv30, i8* @var_205, align 1
  %mul43 = mul nsw i32 %sub, %conv5
  %conv44 = trunc i32 %mul43 to i8
  store i8 %conv44, i8* @var_218, align 1
  ret void
}
