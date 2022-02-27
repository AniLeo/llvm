; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx2 | FileCheck %s

define i8 @or_lshr_commute0(i8 %x0, i8 %x1, i8 %y, i8 %z) {
; CHECK-LABEL: or_lshr_commute0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shrb %cl, %dil
; CHECK-NEXT:    orb %dil, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %sh1 = lshr i8 %x0, %y
  %sh2 = lshr i8 %x1, %y
  %logic = or i8 %sh1, %z
  %r = or i8 %logic, %sh2
  ret i8 %r
}

define i32 @or_lshr_commute1(i32 %x0, i32 %x1, i32 %y, i32 %z) {
; CHECK-LABEL: or_lshr_commute1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shrl %cl, %edi
; CHECK-NEXT:    orl %edi, %eax
; CHECK-NEXT:    retq
  %sh1 = lshr i32 %x0, %y
  %sh2 = lshr i32 %x1, %y
  %logic = or i32 %z, %sh1
  %r = or i32 %logic, %sh2
  ret i32 %r
}

define <8 x i16> @or_lshr_commute2(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %y, <8 x i16> %z) {
; CHECK-LABEL: or_lshr_commute2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
; CHECK-NEXT:    vpsrlvd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vextracti128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vpackusdw %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %sh1 = lshr <8 x i16> %x0, %y
  %sh2 = lshr <8 x i16> %x1, %y
  %logic = or <8 x i16> %sh1, %z
  %r = or <8 x i16> %sh2, %logic
  ret <8 x i16> %r
}

define <2 x i64> @or_lshr_commute3(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %y, <2 x i64> %z) {
; CHECK-LABEL: or_lshr_commute3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpsrlvq %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sh1 = lshr <2 x i64> %x0, %y
  %sh2 = lshr <2 x i64> %x1, %y
  %logic = or <2 x i64> %z, %sh1
  %r = or <2 x i64> %sh2, %logic
  ret <2 x i64> %r
}

define i16 @or_ashr_commute0(i16 %x0, i16 %x1, i16 %y, i16 %z) {
; CHECK-LABEL: or_ashr_commute0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %r8d
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    movswl %di, %eax
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    sarl %cl, %eax
; CHECK-NEXT:    orl %r8d, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
  %sh1 = ashr i16 %x0, %y
  %sh2 = ashr i16 %x1, %y
  %logic = or i16 %sh1, %z
  %r = or i16 %logic, %sh2
  ret i16 %r
}

define i64 @or_ashr_commute1(i64 %x0, i64 %x1, i64 %y, i64 %z) {
; CHECK-LABEL: or_ashr_commute1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    orq %rsi, %rdi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $rcx
; CHECK-NEXT:    sarq %cl, %rdi
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    retq
  %sh1 = ashr i64 %x0, %y
  %sh2 = ashr i64 %x1, %y
  %logic = or i64 %z, %sh1
  %r = or i64 %logic, %sh2
  ret i64 %r
}

define <4 x i32> @or_ashr_commute2(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %y, <4 x i32> %z) {
; CHECK-LABEL: or_ashr_commute2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpsravd %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sh1 = ashr <4 x i32> %x0, %y
  %sh2 = ashr <4 x i32> %x1, %y
  %logic = or <4 x i32> %sh1, %z
  %r = or <4 x i32> %sh2, %logic
  ret <4 x i32> %r
}

define <16 x i8> @or_ashr_commute3(<16 x i8> %x0, <16 x i8> %x1, <16 x i8> %y, <16 x i8> %z) {
; CHECK-LABEL: or_ashr_commute3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsllw $5, %xmm2, %xmm2
; CHECK-NEXT:    vpunpckhbw {{.*#+}} xmm4 = xmm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpunpckhbw {{.*#+}} xmm1 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; CHECK-NEXT:    vpsraw $4, %xmm1, %xmm5
; CHECK-NEXT:    vpblendvb %xmm4, %xmm5, %xmm1, %xmm1
; CHECK-NEXT:    vpsraw $2, %xmm1, %xmm5
; CHECK-NEXT:    vpaddw %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpblendvb %xmm4, %xmm5, %xmm1, %xmm1
; CHECK-NEXT:    vpsraw $1, %xmm1, %xmm5
; CHECK-NEXT:    vpaddw %xmm4, %xmm4, %xmm4
; CHECK-NEXT:    vpblendvb %xmm4, %xmm5, %xmm1, %xmm1
; CHECK-NEXT:    vpsrlw $8, %xmm1, %xmm1
; CHECK-NEXT:    vpunpcklbw {{.*#+}} xmm2 = xmm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpsraw $4, %xmm0, %xmm4
; CHECK-NEXT:    vpblendvb %xmm2, %xmm4, %xmm0, %xmm0
; CHECK-NEXT:    vpsraw $2, %xmm0, %xmm4
; CHECK-NEXT:    vpaddw %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vpblendvb %xmm2, %xmm4, %xmm0, %xmm0
; CHECK-NEXT:    vpsraw $1, %xmm0, %xmm4
; CHECK-NEXT:    vpaddw %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vpblendvb %xmm2, %xmm4, %xmm0, %xmm0
; CHECK-NEXT:    vpsrlw $8, %xmm0, %xmm0
; CHECK-NEXT:    vpackuswb %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sh1 = ashr <16 x i8> %x0, %y
  %sh2 = ashr <16 x i8> %x1, %y
  %logic = or <16 x i8> %z, %sh1
  %r = or <16 x i8> %sh2, %logic
  ret <16 x i8> %r
}

define i32 @or_shl_commute0(i32 %x0, i32 %x1, i32 %y, i32 %z) {
; CHECK-LABEL: or_shl_commute0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shll %cl, %edi
; CHECK-NEXT:    orl %edi, %eax
; CHECK-NEXT:    retq
  %sh1 = shl i32 %x0, %y
  %sh2 = shl i32 %x1, %y
  %logic = or i32 %sh1, %z
  %r = or i32 %logic, %sh2
  ret i32 %r
}

define i8 @or_shl_commute1(i8 %x0, i8 %x1, i8 %y, i8 %z) {
; CHECK-LABEL: or_shl_commute1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    orl %esi, %edi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $ecx
; CHECK-NEXT:    shlb %cl, %dil
; CHECK-NEXT:    orb %dil, %al
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %sh1 = shl i8 %x0, %y
  %sh2 = shl i8 %x1, %y
  %logic = or i8 %z, %sh1
  %r = or i8 %logic, %sh2
  ret i8 %r
}

define <2 x i64> @or_shl_commute2(<2 x i64> %x0, <2 x i64> %x1, <2 x i64> %y, <2 x i64> %z) {
; CHECK-LABEL: or_shl_commute2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpsllvq %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %sh1 = shl <2 x i64> %x0, %y
  %sh2 = shl <2 x i64> %x1, %y
  %logic = or <2 x i64> %sh1, %z
  %r = or <2 x i64> %sh2, %logic
  ret <2 x i64> %r
}

define <8 x i16> @or_shl_commute3(<8 x i16> %x0, <8 x i16> %x1, <8 x i16> %y, <8 x i16> %z) {
; CHECK-LABEL: or_shl_commute3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vpmovzxwd {{.*#+}} ymm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
; CHECK-NEXT:    vpsllvd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,u,u,u,u,u,u,u,u,16,17,20,21,24,25,28,29,u,u,u,u,u,u,u,u]
; CHECK-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; CHECK-NEXT:    vpor %xmm3, %xmm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %sh1 = shl <8 x i16> %x0, %y
  %sh2 = shl <8 x i16> %x1, %y
  %logic = or <8 x i16> %z, %sh1
  %r = or <8 x i16> %sh2, %logic
  ret <8 x i16> %r
}

; negative test - mismatched shift opcodes

define i64 @or_mix_shr(i64 %x0, i64 %x1, i64 %y, i64 %z) {
; CHECK-LABEL: or_mix_shr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    sarq %cl, %rdi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $rcx
; CHECK-NEXT:    shrq %cl, %rsi
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    retq
  %sh1 = ashr i64 %x0, %y
  %sh2 = lshr i64 %x1, %y
  %logic = or i64 %sh1, %z
  %r = or i64 %logic, %sh2
  ret i64 %r
}

; negative test - mismatched shift amounts

define i64 @or_lshr_mix_shift_amount(i64 %x0, i64 %x1, i64 %y, i64 %z, i64 %w) {
; CHECK-LABEL: or_lshr_mix_shift_amount:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    # kill: def $cl killed $cl killed $rcx
; CHECK-NEXT:    shrq %cl, %rdi
; CHECK-NEXT:    movl %r8d, %ecx
; CHECK-NEXT:    shrq %cl, %rsi
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    orq %rdi, %rax
; CHECK-NEXT:    retq
  %sh1 = lshr i64 %x0, %y
  %sh2 = lshr i64 %x1, %w
  %logic = or i64 %sh1, %z
  %r = or i64 %logic, %sh2
  ret i64 %r
}

; negative test - mismatched logic opcodes

define i64 @mix_logic_lshr(i64 %x0, i64 %x1, i64 %y, i64 %z) {
; CHECK-LABEL: mix_logic_lshr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    shrq %cl, %rdi
; CHECK-NEXT:    # kill: def $cl killed $cl killed $rcx
; CHECK-NEXT:    shrq %cl, %rsi
; CHECK-NEXT:    xorq %rdi, %rax
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    retq
  %sh1 = lshr i64 %x0, %y
  %sh2 = lshr i64 %x1, %y
  %logic = xor i64 %sh1, %z
  %r = or i64 %logic, %sh2
  ret i64 %r
}
