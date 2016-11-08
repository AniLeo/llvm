# RUN: not llvm-mc -triple s390x-linux-gnu < %s 2> %t
# RUN: FileCheck < %t %s

# Test GR32 operands
#
#CHECK: error: invalid operand for instruction
#CHECK: lr	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: lr	%a0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: lr	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: lr	%r0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: lr	%r0,0
#CHECK: error: invalid operand for instruction
#CHECK: lr	%r0,0(%r1)

	lr	%f0,%r1
	lr	%a0,%r1
	lr	%r0,%f1
	lr	%r0,%a1
	lr	%r0,0
	lr	%r0,0(%r1)

# Test GR64 operands
#
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%a0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%r0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%r0,0
#CHECK: error: invalid operand for instruction
#CHECK: lgr	%r0,0(%r1)

	lgr	%f0,%r1
	lgr	%a0,%r1
	lgr	%r0,%f1
	lgr	%r0,%a1
	lgr	%r0,0
	lgr	%r0,0(%r1)

# Test GR128 operands
#
#CHECK: error: invalid register pair
#CHECK: dlr	%r1,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r3,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r5,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r7,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r9,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r11,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r13,%r0
#CHECK: error: invalid register pair
#CHECK: dlr	%r15,%r0
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%a0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%r0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%r0,0
#CHECK: error: invalid operand for instruction
#CHECK: dlr	%r0,0(%r1)

	dlr	%r1,%r0
	dlr	%r3,%r0
	dlr	%r5,%r0
	dlr	%r7,%r0
	dlr	%r9,%r0
	dlr	%r11,%r0
	dlr	%r13,%r0
	dlr	%r15,%r0
	dlr	%f0,%r1
	dlr	%a0,%r1
	dlr	%r0,%f1
	dlr	%r0,%a1
	dlr	%r0,0
	dlr	%r0,0(%r1)

# Test FP32 operands
#
#CHECK: error: invalid operand for instruction
#CHECK: ler	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: ler	%a0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: ler	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: ler	%f0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: ler	%f0,0
#CHECK: error: invalid operand for instruction
#CHECK: ler	%f0,0(%r1)

	ler	%r0,%f1
	ler	%a0,%f1
	ler	%f0,%r1
	ler	%f0,%a1
	ler	%f0,0
	ler	%f0,0(%r1)

# Test FP64 operands
#
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%a0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%f0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%f0,0
#CHECK: error: invalid operand for instruction
#CHECK: ldr	%f0,0(%r1)

	ldr	%r0,%f1
	ldr	%a0,%f1
	ldr	%f0,%r1
	ldr	%f0,%a1
	ldr	%f0,0
	ldr	%f0,0(%r1)

# Test FP128 operands
#
#CHECK: error: invalid register pair
#CHECK: lxr	%f2,%f0
#CHECK: error: invalid register pair
#CHECK: lxr	%f0,%f3
#CHECK: error: invalid register pair
#CHECK: lxr	%f6,%f0
#CHECK: error: invalid register pair
#CHECK: lxr	%f0,%f7
#CHECK: error: invalid register pair
#CHECK: lxr	%f10,%f0
#CHECK: error: invalid register pair
#CHECK: lxr	%f0,%f11
#CHECK: error: invalid register pair
#CHECK: lxr	%f14,%f0
#CHECK: error: invalid register pair
#CHECK: lxr	%f0,%f15
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%r0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%a0,%f1
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%f0,%r1
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%f0,%a1
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%f0,0
#CHECK: error: invalid operand for instruction
#CHECK: lxr	%f0,0(%r1)

	lxr	%f2,%f0
	lxr	%f0,%f3
	lxr	%f6,%f0
	lxr	%f0,%f7
	lxr	%f10,%f0
	lxr	%f0,%f11
	lxr	%f14,%f0
	lxr	%f0,%f15
	lxr	%r0,%f1
	lxr	%a0,%f1
	lxr	%f0,%r1
	lxr	%f0,%a1
	lxr	%f0,0
	lxr	%f0,0(%r1)

# Test access register operands
#
#CHECK: error: invalid operand for instruction
#CHECK: ear	%r0,%r0
#CHECK: error: invalid operand for instruction
#CHECK: ear	%r0,%f0
#CHECK: error: invalid operand for instruction
#CHECK: ear	%r0,0
#CHECK: error: invalid operand for instruction
#CHECK: ear	%r0,0(%r1)

	ear	%r0,%r0
	ear	%r0,%f0
	ear	%r0,0
	ear	%r0,0(%r1)

	.cfi_startproc

# Test general register parsing, with no predetermined class in mind.
#
#CHECK: error: register expected
#CHECK: .cfi_offset r0,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %r,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %f,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %a,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %0,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %c0,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %r16,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %f16,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %a16,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %reef,0
#CHECK: error: invalid register
#CHECK: .cfi_offset %arid,0

	.cfi_offset r0,0
	.cfi_offset %,0
	.cfi_offset %r,0
	.cfi_offset %f,0
	.cfi_offset %a,0
	.cfi_offset %0,0
	.cfi_offset %c0,0
	.cfi_offset %r16,0
	.cfi_offset %f16,0
	.cfi_offset %a16,0
	.cfi_offset %reef,0
	.cfi_offset %arid,0

	.cfi_endproc

#CHECK: error: %r0 used in an address
#CHECK: sll	%r2,8(%r0)
#CHECK: error: %r0 used in an address
#CHECK: br	%r0
#CHECK: error: %r0 used in an address
#CHECK: l	%r1,8(%r0)
#CHECK: error: %r0 used in an address
#CHECK: l	%r1,8(%r0,%r15)
#CHECK: error: %r0 used in an address
#CHECK: l	%r1,8(%r15,%r0)

	sll	%r2,8(%r0)
	br	%r0
	l	%r1,8(%r0)
	l	%r1,8(%r0,%r15)
	l	%r1,8(%r15,%r0)
