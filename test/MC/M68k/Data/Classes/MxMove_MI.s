; RUN: llvm-mc -triple=m68k -show-encoding %s | FileCheck %s
	.text
	.globl	MxMove_MI_ARII
; CHECK-LABEL: MxMove_MI_ARII:
MxMove_MI_ARII:
	; CHECK:      move.b  #-1, (0,%a0,%d1)
	; CHECK-SAME: encoding: [0x11,0xbc,0x00,0xff,0x18,0x00]
	move.b	#-1, (0,%a0,%d1)
	; CHECK:      move.b  #42, (-1,%a0,%d1)
	; CHECK-SAME: encoding: [0x11,0xbc,0x00,0x2a,0x18,0xff]
	move.b	#42, (-1,%a0,%d1)
	; CHECK:      move.l  #-1, (0,%a1,%d1)
	; CHECK-SAME: encoding: [0x23,0xbc,0xff,0xff,0xff,0xff,0x18,0x00]
	move.l	#-1, (0,%a1,%d1)
	; CHECK:      move.l  #0, (0,%a2,%a2)
	; CHECK-SAME: encoding: [0x25,0xbc,0x00,0x00,0x00,0x00,0xa8,0x00]
	move.l	#0, (0,%a2,%a2)

	.globl	MxMove_MI_ARID
; CHECK-LABEL: MxMove_MI_ARID:
MxMove_MI_ARID:
	; CHECK:      move.b  #0, (0,%a0)
	; CHECK-SAME: encoding: [0x11,0x7c,0x00,0x00,0x00,0x00]
	move.b	#0, (0,%a0)
	; CHECK:      move.l  #0, (-1,%a1)
	; CHECK-SAME: encoding: [0x23,0x7c,0x00,0x00,0x00,0x00,0xff,0xff]
	move.l	#0, (-1,%a1)
	; CHECK:      move.l  #0, (-1,%a1)
	; CHECK-SAME: encoding: [0x23,0x7c,0x00,0x00,0x00,0x00,0xff,0xff]
	move.l	#0, (-1,%a1)

	.globl	MxMove_MI_ARI
; CHECK-LABEL: MxMove_MI_ARI:
MxMove_MI_ARI:
	; CHECK:      move.b  #0, (%a0)
	; CHECK-SAME: encoding: [0x10,0xbc,0x00,0x00]
	move.b	#0, (%a0)
	; CHECK:      move.l  #0, (%a1)
	; CHECK-SAME: encoding: [0x22,0xbc,0x00,0x00,0x00,0x00]
	move.l	#0, (%a1)
	; CHECK:      move.l  #0, (%a1)
	; CHECK-SAME: encoding: [0x22,0xbc,0x00,0x00,0x00,0x00]
	move.l	#0, (%a1)

