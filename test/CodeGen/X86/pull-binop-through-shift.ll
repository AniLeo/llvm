; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --no_x86_scrub_sp
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86

; shift left

define i32 @and_signbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: and_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    andl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_signbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movzbl 6(%esp), %eax
; X86-NEXT:    shll $24, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: and_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    andl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_nosignbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movzbl 6(%esp), %eax
; X86-NEXT:    shll $24, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: or_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_signbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: or_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_nosignbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: xor_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    xorl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_signbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $16711680, %eax # imm = 0xFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: xor_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    xorl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_nosignbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $16711680, %eax # imm = 0xFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: add_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $8, %edi
; X64-NEXT:    leal -16777216(%rdi), %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_signbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_shl(i32 %x, ptr %dst) {
; X64-LABEL: add_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    shll $8, %edi
; X64-NEXT:    leal -16777216(%rdi), %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_nosignbit_shl:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl 4(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

; logical shift right

define i32 @and_signbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: and_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_signbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movzwl 6(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: and_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_nosignbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    andl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: or_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_signbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    orl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: or_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_nosignbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    orl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: xor_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    xorl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_signbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: xor_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    xorl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_nosignbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: add_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -65536(%rdi), %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_signbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    addl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_lshr(i32 %x, ptr %dst) {
; X64-LABEL: add_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 2147418112(%rdi), %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_nosignbit_lshr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    addl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

; arithmetic shift right

define i32 @and_signbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: and_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    andl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_signbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movswl 6(%esp), %eax
; X86-NEXT:    shll $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @and_nosignbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: and_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: and_nosignbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    andl 4(%esp), %eax
; X86-NEXT:    shrl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @or_signbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: or_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_signbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    orl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @or_nosignbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: or_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    orl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: or_nosignbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    orl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @xor_signbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: xor_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    xorl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_signbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @xor_nosignbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: xor_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    xorl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: xor_nosignbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    xorl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}

define i32 @add_signbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: add_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal -65536(%rdi), %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_signbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X86-NEXT:    addl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
define i32 @add_nosignbit_ashr(i32 %x, ptr %dst) {
; X64-LABEL: add_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    leal 2147418112(%rdi), %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X86-LABEL: add_nosignbit_ashr:
; X86:       # %bb.0:
; X86-NEXT:    movl 8(%esp), %ecx
; X86-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X86-NEXT:    addl 4(%esp), %eax
; X86-NEXT:    sarl $8, %eax
; X86-NEXT:    movl %eax, (%ecx)
; X86-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, ptr %dst
  ret i32 %r
}
