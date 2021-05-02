; RUN: llvm-mc -triple=m68k -show-encoding %s | FileCheck %s
	.text
	.globl	MxBiArOp_FMI_ARII
; CHECK-LABEL: MxBiArOp_FMI_ARII:
MxBiArOp_FMI_ARII:
	; CHECK:      add.b  #-1, (0,%a0,%d0)
	; CHECK-SAME: encoding: [0x06,0x30,0x00,0xff,0x08,0x00]
	add.b	#-1, (0,%a0,%d0)
	; CHECK:      add.b  #0, (-1,%a3,%a1)
	; CHECK-SAME: encoding: [0x06,0x33,0x00,0x00,0x98,0xff]
	add.b	#0, (-1,%a3,%a1)
	; CHECK:      add.l  #-1, (13,%a2,%d1)
	; CHECK-SAME: encoding: [0x06,0xb2,0xff,0xff,0xff,0xff,0x18,0x0d]
	add.l	#-1, (13,%a2,%d1)

	.globl	MxBiArOp_FMI_ARID
; CHECK-LABEL: MxBiArOp_FMI_ARID:
MxBiArOp_FMI_ARID:
	; CHECK:      add.b  #-1, (0,%a0)
	; CHECK-SAME: encoding: [0x06,0x28,0x00,0xff,0x00,0x00]
	add.b	#-1, (0,%a0)
	; CHECK:      add.b  #0, (-1,%a3)
	; CHECK-SAME: encoding: [0x06,0x2b,0x00,0x00,0xff,0xff]
	add.b	#0, (-1,%a3)
	; CHECK:      add.l  #-1, (13,%a2)
	; CHECK-SAME: encoding: [0x06,0xaa,0xff,0xff,0xff,0xff,0x00,0x0d]
	add.l	#-1, (13,%a2)

	.globl	MxBiArOp_FMI_ARI
; CHECK-LABEL: MxBiArOp_FMI_ARI:
MxBiArOp_FMI_ARI:
	; CHECK:      add.b  #-1, (%a0)
	; CHECK-SAME: encoding: [0x06,0x10,0x00,0xff]
	add.b	#-1, (%a0)
	; CHECK:      add.b  #0, (%a3)
	; CHECK-SAME: encoding: [0x06,0x13,0x00,0x00]
	add.b	#0, (%a3)
	; CHECK:      add.l  #-1, (%a2)
	; CHECK-SAME: encoding: [0x06,0x92,0xff,0xff,0xff,0xff]
	add.l	#-1, (%a2)

