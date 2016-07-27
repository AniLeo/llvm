// RUN: llvm-mc -x86-asm-syntax=intel -triple x86_64-unknown-unknown --show-encoding %s | FileCheck %s

// CHECK: encoding: [0x66,0x83,0xf0,0x0c]
	xor	ax, 12
// CHECK: encoding: [0x83,0xf0,0x0c]
	xor	eax, 12
// CHECK: encoding: [0x48,0x83,0xf0,0x0c]
	xor	rax, 12

// CHECK: encoding: [0x66,0x83,0xc8,0x0c]
	or	ax, 12
// CHECK: encoding: [0x83,0xc8,0x0c]
	or	eax, 12
// CHECK: encoding: [0x48,0x83,0xc8,0x0c]
	or	rax, 12

// CHECK: encoding: [0x66,0x83,0xf8,0x0c]
	cmp	ax, 12
// CHECK: encoding: [0x83,0xf8,0x0c]
	cmp	eax, 12
// CHECK: encoding: [0x48,0x83,0xf8,0x0c]
	cmp	rax, 12

// CHECK: encoding: [0x48,0x89,0x44,0x24,0xf0]	
	mov	QWORD PTR [RSP - 16], RAX

// CHECK: encoding: [0x66,0x83,0xc0,0xf4]
	add	ax, -12
// CHECK: encoding: [0x83,0xc0,0xf4]
	add	eax, -12
// CHECK: encoding: [0x48,0x83,0xc0,0xf4]
	add	rax, -12

// CHECK: encoding: [0x66,0x83,0xd0,0xf4]
	adc	ax, -12
// CHECK: encoding: [0x83,0xd0,0xf4]
	adc	eax, -12
// CHECK: encoding: [0x48,0x83,0xd0,0xf4]
	adc	rax, -12

// CHECK: encoding: [0x66,0x83,0xd8,0xf4]
	sbb	ax, -12
// CHECK: encoding: [0x83,0xd8,0xf4]
	sbb	eax, -12
// CHECK: encoding: [0x48,0x83,0xd8,0xf4]
	sbb	rax, -12

// CHECK: encoding: [0x66,0x83,0xf8,0xf4]
	cmp	ax, -12
// CHECK: encoding: [0x83,0xf8,0xf4]
	cmp	eax, -12
// CHECK: encoding: [0x48,0x83,0xf8,0xf4]
	cmp	rax, -12

LBB0_3:
// CHECK: encoding: [0xeb,A]
	jmp	LBB0_3
// CHECK: encoding: [0xf2,0x0f,0x10,0x2c,0x25,0xf8,0xff,0xff,0xff]
        movsd   XMM5, QWORD PTR [-8]

// CHECK: encoding: [0xd1,0xe7]
	shl	EDI, 1

// CHECK: encoding: [0x0f,0xc2,0xd1,0x01]
	cmpltps XMM2, XMM1

// CHECK: encoding: [0xc3]
    ret

// CHECK: encoding: [0xcb]
    retf

// CHECK: encoding: [0xc2,0x08,0x00]
    ret 8

// CHECK: encoding: [0xca,0x08,0x00]
    retf 8

    .set FOO, 2
    cmp eax, FOO
// CHECK: encoding: [0x83,0xf8,0x02]
    cmp eax, FOO[eax]
// CHECK: encoding: [0x67,0x3b,0x40,0x02]
