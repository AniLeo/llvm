; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=sse | FileCheck %s

define i32 @test_load(<4 x float>* %a) {
; CHECK-LABEL: test_load:
; CHECK:       ## %bb.0: ## %start
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movaps (%eax), %xmm0
; CHECK-NEXT:    movmskps %xmm0, %eax
; CHECK-NEXT:    retl
start:
  %0 = bitcast <4 x float>* %a to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 16
  %2 = icmp slt <4 x i32> %1, zeroinitializer
  %3 = bitcast <4 x i1> %2 to i4
  %4 = zext i4 %3 to i32
  ret i32 %4
}

define i32 @test_bitcast(<4 x float> %a) {
; CHECK-LABEL: test_bitcast:
; CHECK:       ## %bb.0: ## %start
; CHECK-NEXT:    movmskps %xmm0, %eax
; CHECK-NEXT:    retl
start:
  %0 = bitcast <4 x float> %a to <4 x i32>
  %1 = icmp slt <4 x i32> %0, zeroinitializer
  %2 = bitcast <4 x i1> %1 to i4
  %3 = zext i4 %2 to i32
  ret i32 %3
}

define i32 @test_and(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_and:
; CHECK:       ## %bb.0: ## %start
; CHECK-NEXT:    subl $28, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    andps %xmm1, %xmm0
; CHECK-NEXT:    movaps %xmm0, (%esp)
; CHECK-NEXT:    cmpl $0, (%esp)
; CHECK-NEXT:    sets %al
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %cl
; CHECK-NEXT:    addb %cl, %cl
; CHECK-NEXT:    orb %al, %cl
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %al
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %dl
; CHECK-NEXT:    addb %dl, %dl
; CHECK-NEXT:    orb %al, %dl
; CHECK-NEXT:    shlb $2, %dl
; CHECK-NEXT:    orb %cl, %dl
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    addl $28, %esp
; CHECK-NEXT:    retl
start:
  %0 = bitcast <4 x float> %a to <4 x i32>
  %1 = bitcast <4 x float> %b to <4 x i32>
  %2 = icmp slt <4 x i32> %0, zeroinitializer
  %3 = icmp slt <4 x i32> %1, zeroinitializer
  %4 = and <4 x i1> %2, %3
  %5 = bitcast <4 x i1> %4 to i4
  %6 = zext i4 %5 to i32
  ret i32 %6
}

define i32 @test_or(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_or:
; CHECK:       ## %bb.0: ## %start
; CHECK-NEXT:    subl $28, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    orps %xmm1, %xmm0
; CHECK-NEXT:    movaps %xmm0, (%esp)
; CHECK-NEXT:    cmpl $0, (%esp)
; CHECK-NEXT:    sets %al
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %cl
; CHECK-NEXT:    addb %cl, %cl
; CHECK-NEXT:    orb %al, %cl
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %al
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %dl
; CHECK-NEXT:    addb %dl, %dl
; CHECK-NEXT:    orb %al, %dl
; CHECK-NEXT:    shlb $2, %dl
; CHECK-NEXT:    orb %cl, %dl
; CHECK-NEXT:    movzbl %dl, %eax
; CHECK-NEXT:    addl $28, %esp
; CHECK-NEXT:    retl
start:
  %0 = bitcast <4 x float> %a to <4 x i32>
  %1 = bitcast <4 x float> %b to <4 x i32>
  %2 = icmp slt <4 x i32> %0, zeroinitializer
  %3 = icmp slt <4 x i32> %1, zeroinitializer
  %4 = or <4 x i1> %2, %3
  %5 = bitcast <4 x i1> %4 to i4
  %6 = zext i4 %5 to i32
  ret i32 %6
}

define i32 @test_xor(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: test_xor:
; CHECK:       ## %bb.0: ## %start
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    subl $40, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    .cfi_offset %ebx, -8
; CHECK-NEXT:    movaps %xmm0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movaps %xmm1, (%esp)
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %al
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %cl
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %dl
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %ah
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %ch
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %dh
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    sets %bl
; CHECK-NEXT:    cmpl $0, (%esp)
; CHECK-NEXT:    sets %bh
; CHECK-NEXT:    xorb %ah, %bh
; CHECK-NEXT:    xorb %dl, %bl
; CHECK-NEXT:    addb %bl, %bl
; CHECK-NEXT:    orb %bh, %bl
; CHECK-NEXT:    xorb %cl, %dh
; CHECK-NEXT:    xorb %al, %ch
; CHECK-NEXT:    addb %ch, %ch
; CHECK-NEXT:    orb %dh, %ch
; CHECK-NEXT:    shlb $2, %ch
; CHECK-NEXT:    orb %bl, %ch
; CHECK-NEXT:    movzbl %ch, %eax
; CHECK-NEXT:    addl $40, %esp
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    retl
start:
  %0 = bitcast <4 x float> %a to <4 x i32>
  %1 = bitcast <4 x float> %b to <4 x i32>
  %2 = icmp slt <4 x i32> %0, zeroinitializer
  %3 = icmp slt <4 x i32> %1, zeroinitializer
  %4 = xor <4 x i1> %2, %3
  %5 = bitcast <4 x i1> %4 to i4
  %6 = zext i4 %5 to i32
  ret i32 %6
}
