; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=CHECK64

; Check a few invalid patterns for halfword bswap pattern matching

; Don't match a near-miss 32-bit packed halfword bswap
; (with only half of the swap tree valid).
  define i32 @test1(i32 %x) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    andl $16711680, %ecx # imm = 0xFF0000
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    orl $-16777216, %edx # imm = 0xFF000000
; CHECK-NEXT:    shll $8, %ecx
; CHECK-NEXT:    shrl $8, %edx
; CHECK-NEXT:    orl %ecx, %edx
; CHECK-NEXT:    bswapl %eax
; CHECK-NEXT:    shrl $16, %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: test1:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    movl %edi, %ecx
; CHECK64-NEXT:    andl $16711680, %ecx # imm = 0xFF0000
; CHECK64-NEXT:    movl %edi, %edx
; CHECK64-NEXT:    orl $-16777216, %edx # imm = 0xFF000000
; CHECK64-NEXT:    shll $8, %ecx
; CHECK64-NEXT:    shrl $8, %edx
; CHECK64-NEXT:    orl %ecx, %edx
; CHECK64-NEXT:    bswapl %eax
; CHECK64-NEXT:    shrl $16, %eax
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    retq
  %byte0 = and i32 %x, 255        ; 0x000000ff
  %byte1 = and i32 %x, 65280      ; 0x0000ff00
  %byte2 = and i32 %x, 16711680   ; 0x00ff0000
  %byte3 = or  i32 %x, 4278190080 ; 0xff000000
  %tmp0 = shl  i32 %byte0, 8
  %tmp1 = lshr i32 %byte1, 8
  %tmp2 = shl  i32 %byte2, 8
  %tmp3 = lshr i32 %byte3, 8
  %or0 = or i32 %tmp0, %tmp1
  %or1 = or i32 %tmp2, %tmp3
  %result = or i32 %or0, %or1
  ret i32 %result
}

; Don't match a near-miss 32-bit packed halfword bswap
; (with swapped lshr/shl)
; ((x >> 8) & 0x0000ff00) |
; ((x << 8) & 0x000000ff) |
; ((x << 8) & 0xff000000) |
; ((x >> 8) & 0x00ff0000)
define i32 @test2(i32 %x) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    shrl $8, %eax
; CHECK-NEXT:    shll $8, %ecx
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    andl $65280, %edx # imm = 0xFF00
; CHECK-NEXT:    andl $-16777216, %ecx # imm = 0xFF000000
; CHECK-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: test2:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    movl %edi, %eax
; CHECK64-NEXT:    shrl $8, %eax
; CHECK64-NEXT:    shll $8, %edi
; CHECK64-NEXT:    movl %eax, %ecx
; CHECK64-NEXT:    andl $65280, %ecx # imm = 0xFF00
; CHECK64-NEXT:    andl $-16777216, %edi # imm = 0xFF000000
; CHECK64-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; CHECK64-NEXT:    orl %edi, %eax
; CHECK64-NEXT:    leal (%rax,%rcx), %eax
; CHECK64-NEXT:    retq
  %byte1 = lshr i32 %x, 8
  %byte0 = shl  i32 %x, 8
  %byte3 = shl  i32 %x, 8
  %byte2 = lshr i32 %x, 8
  %tmp1 = and i32 %byte1, 65280      ; 0x0000ff00
  %tmp0 = and i32 %byte0, 255        ; 0x000000ff
  %tmp3 = and i32 %byte3, 4278190080 ; 0xff000000
  %tmp2 = and i32 %byte2, 16711680   ; 0x00ff0000
  %or0 = or i32 %tmp0, %tmp1
  %or1 = or i32 %tmp2, %tmp3
  %result = or i32 %or0, %or1
  ret i32 %result
}

; Invalid pattern involving a unary op
define i32 @test3(float %x) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subl $8, %esp
; CHECK-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-NEXT:    fnstcw {{[0-9]+}}(%esp)
; CHECK-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movw $3199, {{[0-9]+}}(%esp) # imm = 0xC7F
; CHECK-NEXT:    fldcw {{[0-9]+}}(%esp)
; CHECK-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    fistpl {{[0-9]+}}(%esp)
; CHECK-NEXT:    fldcw {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, %edx
; CHECK-NEXT:    shll $8, %edx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    shrl $8, %eax
; CHECK-NEXT:    andl $65280, %ecx # imm = 0xFF00
; CHECK-NEXT:    andl $-16777216, %edx # imm = 0xFF000000
; CHECK-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    retl
;
; CHECK64-LABEL: test3:
; CHECK64:       # %bb.0:
; CHECK64-NEXT:    cvttss2si %xmm0, %ecx
; CHECK64-NEXT:    movl %ecx, %edx
; CHECK64-NEXT:    shll $8, %edx
; CHECK64-NEXT:    movl %ecx, %eax
; CHECK64-NEXT:    shrl $8, %eax
; CHECK64-NEXT:    andl $65280, %ecx # imm = 0xFF00
; CHECK64-NEXT:    andl $-16777216, %edx # imm = 0xFF000000
; CHECK64-NEXT:    andl $16711680, %eax # imm = 0xFF0000
; CHECK64-NEXT:    orl %edx, %eax
; CHECK64-NEXT:    orl %ecx, %eax
; CHECK64-NEXT:    retq
  %integer = fptosi float %x to i32
  %byte0 = shl  i32 %integer, 8
  %byte3 = shl  i32 %integer, 8
  %byte2 = lshr i32 %integer, 8
  %tmp1 = and i32 %integer, 65280      ; 0x0000ff00
  %tmp0 = and i32 %byte0,   255        ; 0x000000ff
  %tmp3 = and i32 %byte3,   4278190080 ; 0xff000000
  %tmp2 = and i32 %byte2,   16711680   ; 0x00ff0000
  %or0 = or i32 %tmp0, %tmp1
  %or1 = or i32 %tmp2, %tmp3
  %result = or i32 %or0, %or1
  ret i32 %result
}
