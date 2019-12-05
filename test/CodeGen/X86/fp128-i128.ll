; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-android -mattr=+mmx -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-gnu     -mattr=+mmx -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-android -mattr=+mmx,avx2 -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-gnu     -mattr=+mmx,avx2 -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-android -mattr=+mmx,avx512vl -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,AVX
; RUN: llc < %s -O2 -verify-machineinstrs -mtriple=x86_64-linux-gnu     -mattr=+mmx,avx512vl -enable-legalize-types-checking | FileCheck %s --check-prefixes=CHECK,AVX

; These tests were generated from simplified libm C code.
; When compiled for the x86_64-linux-android target,
; long double is mapped to f128 type that should be passed
; in SSE registers. When the f128 type calling convention
; problem was fixed, old llvm code failed to handle f128 values
; in several f128/i128 type operations. These unit tests hopefully
; will catch regression in any future change in this area.
; To modified or enhance these test cases, please consult libm
; code pattern and compile with -target x86_64-linux-android
; to generate IL. The __float128 keyword if not accepted by
; clang, just define it to "long double".
;

; typedef long double __float128;
; union IEEEl2bits {
;   __float128 e;
;   struct {
;     unsigned long manl :64;
;     unsigned long manh :48;
;     unsigned int exp :15;
;     unsigned int sign :1;
;   } bits;
;   struct {
;     unsigned long manl :64;
;     unsigned long manh :48;
;     unsigned int expsign :16;
;   } xbits;
; };

; C code:
; void foo(__float128 x);
; void TestUnionLD1(__float128 s, unsigned long n) {
;      union IEEEl2bits u;
;      __float128 w;
;      u.e = s;
;      u.bits.manh = n;
;      w = u.e;
;      foo(w);
; }
define void @TestUnionLD1(fp128 %s, i64 %n) #0 {
; SSE-LABEL: TestUnionLD1:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    shlq $48, %rax
; SSE-NEXT:    movq -{{[0-9]+}}(%rsp), %rcx
; SSE-NEXT:    movabsq $281474976710655, %rdx # imm = 0xFFFFFFFFFFFF
; SSE-NEXT:    andq %rdi, %rdx
; SSE-NEXT:    orq %rax, %rdx
; SSE-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    jmp foo # TAILCALL
;
; AVX-LABEL: TestUnionLD1:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; AVX-NEXT:    shlq $48, %rax
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    movabsq $281474976710655, %rdx # imm = 0xFFFFFFFFFFFF
; AVX-NEXT:    andq %rdi, %rdx
; AVX-NEXT:    orq %rax, %rdx
; AVX-NEXT:    movq %rcx, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq %rdx, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    jmp foo # TAILCALL
entry:
  %0 = bitcast fp128 %s to i128
  %1 = zext i64 %n to i128
  %bf.value = shl nuw i128 %1, 64
  %bf.shl = and i128 %bf.value, 5192296858534809181786422619668480
  %bf.clear = and i128 %0, -5192296858534809181786422619668481
  %bf.set = or i128 %bf.shl, %bf.clear
  %2 = bitcast i128 %bf.set to fp128
  tail call void @foo(fp128 %2) #2
  ret void
}

; C code:
; __float128 TestUnionLD2(__float128 s) {
;      union IEEEl2bits u;
;      __float128 w;
;      u.e = s;
;      u.bits.manl = 0;
;      w = u.e;
;      return w;
; }
define fp128 @TestUnionLD2(fp128 %s) #0 {
; SSE-LABEL: TestUnionLD2:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; SSE-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: TestUnionLD2:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; AVX-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    retq
entry:
  %0 = bitcast fp128 %s to i128
  %bf.clear = and i128 %0, -18446744073709551616
  %1 = bitcast i128 %bf.clear to fp128
  ret fp128 %1
}

; C code:
; __float128 TestI128_1(__float128 x)
; {
;  union IEEEl2bits z;
;  z.e = x;
;  z.bits.sign = 0;
;  return (z.e < 0.1L) ? 1.0L : 2.0L;
; }
define fp128 @TestI128_1(fp128 %x) #0 {
; SSE-LABEL: TestI128_1:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    subq $40, %rsp
; SSE-NEXT:    movaps %xmm0, {{[0-9]+}}(%rsp)
; SSE-NEXT:    movabsq $9223372036854775807, %rax # imm = 0x7FFFFFFFFFFFFFFF
; SSE-NEXT:    andq {{[0-9]+}}(%rsp), %rax
; SSE-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; SSE-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, (%rsp)
; SSE-NEXT:    movaps (%rsp), %xmm0
; SSE-NEXT:    movaps {{.*}}(%rip), %xmm1
; SSE-NEXT:    callq __lttf2
; SSE-NEXT:    xorl %ecx, %ecx
; SSE-NEXT:    testl %eax, %eax
; SSE-NEXT:    sets %cl
; SSE-NEXT:    shlq $4, %rcx
; SSE-NEXT:    movaps {{\.LCPI.*}}(%rcx), %xmm0
; SSE-NEXT:    addq $40, %rsp
; SSE-NEXT:    retq
;
; AVX-LABEL: TestI128_1:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    subq $40, %rsp
; AVX-NEXT:    vmovaps %xmm0, {{[0-9]+}}(%rsp)
; AVX-NEXT:    movabsq $9223372036854775807, %rax # imm = 0x7FFFFFFFFFFFFFFF
; AVX-NEXT:    andq {{[0-9]+}}(%rsp), %rax
; AVX-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; AVX-NEXT:    movq %rcx, (%rsp)
; AVX-NEXT:    vmovaps (%rsp), %xmm0
; AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm1
; AVX-NEXT:    callq __lttf2
; AVX-NEXT:    xorl %ecx, %ecx
; AVX-NEXT:    testl %eax, %eax
; AVX-NEXT:    sets %cl
; AVX-NEXT:    shlq $4, %rcx
; AVX-NEXT:    vmovaps {{\.LCPI.*}}(%rcx), %xmm0
; AVX-NEXT:    addq $40, %rsp
; AVX-NEXT:    retq
entry:
  %0 = bitcast fp128 %x to i128
  %bf.clear = and i128 %0, 170141183460469231731687303715884105727
  %1 = bitcast i128 %bf.clear to fp128
  %cmp = fcmp olt fp128 %1, 0xL999999999999999A3FFB999999999999
  %cond = select i1 %cmp, fp128 0xL00000000000000003FFF000000000000, fp128 0xL00000000000000004000000000000000
  ret fp128 %cond
}

; C code:
; __float128 TestI128_2(__float128 x, __float128 y)
; {
;  unsigned short hx;
;  union IEEEl2bits ge_u;
;  ge_u.e = x;
;  hx = ge_u.xbits.expsign;
;  return (hx & 0x8000) == 0 ? x : y;
; }
define fp128 @TestI128_2(fp128 %x, fp128 %y) #0 {
; SSE-LABEL: TestI128_2:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    cmpq $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    jns .LBB3_2
; SSE-NEXT:  # %bb.1: # %entry
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:  .LBB3_2: # %entry
; SSE-NEXT:    retq
;
; AVX-LABEL: TestI128_2:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    cmpq $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    jns .LBB3_2
; AVX-NEXT:  # %bb.1: # %entry
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:  .LBB3_2: # %entry
; AVX-NEXT:    retq
entry:
  %0 = bitcast fp128 %x to i128
  %cmp = icmp sgt i128 %0, -1
  %cond = select i1 %cmp, fp128 %x, fp128 %y
  ret fp128 %cond
}

; C code:
; __float128 TestI128_3(__float128 x, int *ex)
; {
;  union IEEEl2bits u;
;  u.e = x;
;  if (u.bits.exp == 0) {
;    u.e *= 0x1.0p514;
;    u.bits.exp = 0x3ffe;
;  }
;  return (u.e);
; }
define fp128 @TestI128_3(fp128 %x, i32* nocapture readnone %ex) #0 {
; SSE-LABEL: TestI128_3:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    subq $56, %rsp
; SSE-NEXT:    movaps %xmm0, {{[0-9]+}}(%rsp)
; SSE-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; SSE-NEXT:    movabsq $9223090561878065152, %rcx # imm = 0x7FFF000000000000
; SSE-NEXT:    testq %rcx, %rax
; SSE-NEXT:    je .LBB4_2
; SSE-NEXT:  # %bb.1:
; SSE-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; SSE-NEXT:    jmp .LBB4_3
; SSE-NEXT:  .LBB4_2: # %if.then
; SSE-NEXT:    movaps {{.*}}(%rip), %xmm1
; SSE-NEXT:    callq __multf3
; SSE-NEXT:    movaps %xmm0, {{[0-9]+}}(%rsp)
; SSE-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; SSE-NEXT:    movabsq $-9223090561878065153, %rdx # imm = 0x8000FFFFFFFFFFFF
; SSE-NEXT:    andq {{[0-9]+}}(%rsp), %rdx
; SSE-NEXT:    movabsq $4611123068473966592, %rax # imm = 0x3FFE000000000000
; SSE-NEXT:    orq %rdx, %rax
; SSE-NEXT:  .LBB4_3: # %if.end
; SSE-NEXT:    movq %rcx, (%rsp)
; SSE-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; SSE-NEXT:    movaps (%rsp), %xmm0
; SSE-NEXT:    addq $56, %rsp
; SSE-NEXT:    retq
;
; AVX-LABEL: TestI128_3:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    subq $56, %rsp
; AVX-NEXT:    vmovaps %xmm0, {{[0-9]+}}(%rsp)
; AVX-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; AVX-NEXT:    movabsq $9223090561878065152, %rcx # imm = 0x7FFF000000000000
; AVX-NEXT:    testq %rcx, %rax
; AVX-NEXT:    je .LBB4_2
; AVX-NEXT:  # %bb.1:
; AVX-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    jmp .LBB4_3
; AVX-NEXT:  .LBB4_2: # %if.then
; AVX-NEXT:    vmovaps {{.*}}(%rip), %xmm1
; AVX-NEXT:    callq __multf3
; AVX-NEXT:    vmovaps %xmm0, {{[0-9]+}}(%rsp)
; AVX-NEXT:    movq {{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    movabsq $-9223090561878065153, %rdx # imm = 0x8000FFFFFFFFFFFF
; AVX-NEXT:    andq {{[0-9]+}}(%rsp), %rdx
; AVX-NEXT:    movabsq $4611123068473966592, %rax # imm = 0x3FFE000000000000
; AVX-NEXT:    orq %rdx, %rax
; AVX-NEXT:  .LBB4_3: # %if.end
; AVX-NEXT:    movq %rcx, (%rsp)
; AVX-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps (%rsp), %xmm0
; AVX-NEXT:    addq $56, %rsp
; AVX-NEXT:    retq
entry:
  %0 = bitcast fp128 %x to i128
  %bf.cast = and i128 %0, 170135991163610696904058773219554885632
  %cmp = icmp eq i128 %bf.cast, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %mul = fmul fp128 %x, 0xL00000000000000004201000000000000
  %1 = bitcast fp128 %mul to i128
  %bf.clear4 = and i128 %1, -170135991163610696904058773219554885633
  %bf.set = or i128 %bf.clear4, 85060207136517546210586590865283612672
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %u.sroa.0.0 = phi i128 [ %bf.set, %if.then ], [ %0, %entry ]
  %2 = bitcast i128 %u.sroa.0.0 to fp128
  ret fp128 %2
}

; C code:
; __float128 TestI128_4(__float128 x)
; {
;  union IEEEl2bits u;
;  __float128 df;
;  u.e = x;
;  u.xbits.manl = 0;
;  df = u.e;
;  return x + df;
; }
define fp128 @TestI128_4(fp128 %x) #0 {
; SSE-LABEL: TestI128_4:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; SSE-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    jmp __addtf3 # TAILCALL
;
; AVX-LABEL: TestI128_4:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, %xmm1
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; AVX-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    jmp __addtf3 # TAILCALL
entry:
  %0 = bitcast fp128 %x to i128
  %bf.clear = and i128 %0, -18446744073709551616
  %1 = bitcast i128 %bf.clear to fp128
  %add = fadd fp128 %1, %x
  ret fp128 %add
}

@v128 = common global i128 0, align 16
@v128_2 = common global i128 0, align 16

; C code:
; unsigned __int128 v128, v128_2;
; void TestShift128_2() {
;   v128 = ((v128 << 96) | v128_2);
; }
define void @TestShift128_2() #2 {
; CHECK-LABEL: TestShift128_2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq {{.*}}(%rip), %rax
; CHECK-NEXT:    shlq $32, %rax
; CHECK-NEXT:    movq {{.*}}(%rip), %rcx
; CHECK-NEXT:    orq v128_2+{{.*}}(%rip), %rax
; CHECK-NEXT:    movq %rcx, {{.*}}(%rip)
; CHECK-NEXT:    movq %rax, v128+{{.*}}(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = load i128, i128* @v128, align 16
  %shl = shl i128 %0, 96
  %1 = load i128, i128* @v128_2, align 16
  %or = or i128 %shl, %1
  store i128 %or, i128* @v128, align 16
  ret void
}

define fp128 @acosl(fp128 %x) #0 {
; SSE-LABEL: acosl:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; SSE-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    jmp __addtf3 # TAILCALL
;
; AVX-LABEL: acosl:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, %xmm1
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rax
; AVX-NEXT:    movq %rax, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    jmp __addtf3 # TAILCALL
entry:
  %0 = bitcast fp128 %x to i128
  %bf.clear = and i128 %0, -18446744073709551616
  %1 = bitcast i128 %bf.clear to fp128
  %add = fadd fp128 %1, %x
  ret fp128 %add
}

; Compare i128 values and check i128 constants.
define fp128 @TestComp(fp128 %x, fp128 %y) #0 {
; SSE-LABEL: TestComp:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    cmpq $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    jns .LBB8_2
; SSE-NEXT:  # %bb.1: # %entry
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:  .LBB8_2: # %entry
; SSE-NEXT:    retq
;
; AVX-LABEL: TestComp:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    cmpq $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    jns .LBB8_2
; AVX-NEXT:  # %bb.1: # %entry
; AVX-NEXT:    vmovaps %xmm1, %xmm0
; AVX-NEXT:  .LBB8_2: # %entry
; AVX-NEXT:    retq
entry:
  %0 = bitcast fp128 %x to i128
  %cmp = icmp sgt i128 %0, -1
  %cond = select i1 %cmp, fp128 %x, fp128 %y
  ret fp128 %cond
}

declare void @foo(fp128) #1

; Test logical operations on fp128 values.
define fp128 @TestFABS_LD(fp128 %x) #0 {
; SSE-LABEL: TestFABS_LD:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: TestFABS_LD:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
entry:
  %call = tail call fp128 @fabsl(fp128 %x) #2
  ret fp128 %call
}

declare fp128 @fabsl(fp128) #1

declare fp128 @copysignl(fp128, fp128) #1

; Test more complicated logical operations generated from copysignl.
define void @TestCopySign({ fp128, fp128 }* noalias nocapture sret %agg.result, { fp128, fp128 }* byval nocapture readonly align 16 %z) #0 {
; SSE-LABEL: TestCopySign:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    pushq %rbp
; SSE-NEXT:    pushq %rbx
; SSE-NEXT:    subq $40, %rsp
; SSE-NEXT:    movq %rdi, %rbx
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm0
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm1
; SSE-NEXT:    movaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; SSE-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; SSE-NEXT:    callq __gttf2
; SSE-NEXT:    movl %eax, %ebp
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    callq __subtf3
; SSE-NEXT:    testl %ebp, %ebp
; SSE-NEXT:    jle .LBB10_1
; SSE-NEXT:  # %bb.2: # %if.then
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; SSE-NEXT:    jmp .LBB10_3
; SSE-NEXT:  .LBB10_1:
; SSE-NEXT:    movaps (%rsp), %xmm1 # 16-byte Reload
; SSE-NEXT:  .LBB10_3: # %cleanup
; SSE-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm2 # 16-byte Reload
; SSE-NEXT:    andps {{.*}}(%rip), %xmm2
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    orps %xmm2, %xmm0
; SSE-NEXT:    movaps %xmm1, (%rbx)
; SSE-NEXT:    movaps %xmm0, 16(%rbx)
; SSE-NEXT:    movq %rbx, %rax
; SSE-NEXT:    addq $40, %rsp
; SSE-NEXT:    popq %rbx
; SSE-NEXT:    popq %rbp
; SSE-NEXT:    retq
;
; AVX-LABEL: TestCopySign:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    pushq %rbp
; AVX-NEXT:    pushq %rbx
; AVX-NEXT:    subq $40, %rsp
; AVX-NEXT:    movq %rdi, %rbx
; AVX-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm1
; AVX-NEXT:    vmovaps %xmm1, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; AVX-NEXT:    vmovaps %xmm0, (%rsp) # 16-byte Spill
; AVX-NEXT:    callq __gttf2
; AVX-NEXT:    movl %eax, %ebp
; AVX-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; AVX-NEXT:    vmovaps %xmm0, %xmm1
; AVX-NEXT:    callq __subtf3
; AVX-NEXT:    testl %ebp, %ebp
; AVX-NEXT:    jle .LBB10_1
; AVX-NEXT:  # %bb.2: # %if.then
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm1
; AVX-NEXT:    vmovaps (%rsp), %xmm0 # 16-byte Reload
; AVX-NEXT:    vmovaps %xmm1, %xmm2
; AVX-NEXT:    jmp .LBB10_3
; AVX-NEXT:  .LBB10_1:
; AVX-NEXT:    vmovaps (%rsp), %xmm2 # 16-byte Reload
; AVX-NEXT:  .LBB10_3: # %cleanup
; AVX-NEXT:    vmovaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vorps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovaps %xmm2, (%rbx)
; AVX-NEXT:    vmovaps %xmm0, 16(%rbx)
; AVX-NEXT:    movq %rbx, %rax
; AVX-NEXT:    addq $40, %rsp
; AVX-NEXT:    popq %rbx
; AVX-NEXT:    popq %rbp
; AVX-NEXT:    retq
entry:
  %z.realp = getelementptr inbounds { fp128, fp128 }, { fp128, fp128 }* %z, i64 0, i32 0
  %z.real = load fp128, fp128* %z.realp, align 16
  %z.imagp = getelementptr inbounds { fp128, fp128 }, { fp128, fp128 }* %z, i64 0, i32 1
  %z.imag4 = load fp128, fp128* %z.imagp, align 16
  %cmp = fcmp ogt fp128 %z.real, %z.imag4
  %sub = fsub fp128 %z.imag4, %z.imag4
  br i1 %cmp, label %if.then, label %cleanup

if.then:                                          ; preds = %entry
  %call = tail call fp128 @fabsl(fp128 %sub) #2
  br label %cleanup

cleanup:                                          ; preds = %entry, %if.then
  %z.real.sink = phi fp128 [ %z.real, %if.then ], [ %sub, %entry ]
  %call.sink = phi fp128 [ %call, %if.then ], [ %z.real, %entry ]
  %call5 = tail call fp128 @copysignl(fp128 %z.real.sink, fp128 %z.imag4) #2
  %0 = getelementptr inbounds { fp128, fp128 }, { fp128, fp128 }* %agg.result, i64 0, i32 0
  %1 = getelementptr inbounds { fp128, fp128 }, { fp128, fp128 }* %agg.result, i64 0, i32 1
  store fp128 %call.sink, fp128* %0, align 16
  store fp128 %call5, fp128* %1, align 16
  ret void
}


attributes #0 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+popcnt,+sse,+sse2,+sse4.1,+sse4.2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+ssse3,+sse3,+popcnt,+sse,+sse2,+sse4.1,+sse4.2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone }
