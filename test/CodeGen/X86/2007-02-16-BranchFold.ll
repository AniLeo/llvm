; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -enable-tail-merge=0 | FileCheck %s
; PR 1200
; ModuleID = '<stdin>'
target datalayout = "e-p:32:32"
target triple = "i686-apple-darwin8"
	%struct.FILE = type { ptr, i32, i32, i16, i16, %struct.__sbuf, i32, ptr, ptr, ptr, ptr, ptr, %struct.__sbuf, ptr, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
	%struct.Index_Map = type { i32, ptr }
	%struct.Item = type { [4 x i16], ptr }
	%struct.__sFILEX = type opaque
	%struct.__sbuf = type { ptr, i32 }
	%struct.dimension = type { ptr, %struct.Index_Map, ptr, i32, ptr }
	%struct.item_set = type { i32, i32, ptr, [2 x ptr], ptr, ptr, ptr, ptr }
	%struct.list = type { ptr, ptr }
	%struct.mapping = type { ptr, i32, i32, i32, ptr }
	%struct.nonterminal = type { ptr, i32, i32, i32, ptr, ptr }
	%struct.operator = type { ptr, i8, i32, i32, i32, i32, ptr }
	%struct.pattern = type { ptr, ptr, [2 x ptr] }
	%struct.plank = type { ptr, ptr, i32 }
	%struct.plankMap = type { ptr, i32, ptr }
	%struct.rule = type { [4 x i16], i32, i32, i32, ptr, ptr, i8 }
	%struct.stateMap = type { ptr, ptr, i32, ptr }
	%struct.table = type { ptr, ptr, ptr, [2 x ptr], ptr }
@outfile = external global ptr		; <ptr> [#uses=1]
@str1 = external global [11 x i8]		; <ptr> [#uses=1]

declare i32 @fprintf(ptr, ptr, ...)

define i16 @main_bb_2E_i9_2E_i_2E_i932_2E_ce(ptr %l_addr.01.0.i2.i.i929, ptr %tmp66.i62.i.out) {
; CHECK-LABEL: main_bb_2E_i9_2E_i_2E_i932_2E_ce:
; CHECK:       ## %bb.0: ## %newFuncRoot
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    subl $20, %esp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset %esi, -12
; CHECK-NEXT:    .cfi_offset %edi, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl (%eax), %edi
; CHECK-NEXT:    movl 8(%edi), %eax
; CHECK-NEXT:    movl L_outfile$non_lazy_ptr, %ecx
; CHECK-NEXT:    movl (%ecx), %ecx
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl L_str1$non_lazy_ptr, %eax
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; CHECK-NEXT:    movl %ecx, (%esp)
; CHECK-NEXT:    calll _fprintf
; CHECK-NEXT:    movl 20(%edi), %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    jle LBB0_6
; CHECK-NEXT:  ## %bb.1: ## %NodeBlock4
; CHECK-NEXT:    cmpl $2, %eax
; CHECK-NEXT:    jge LBB0_2
; CHECK-NEXT:  ## %bb.4: ## %LeafBlock2
; CHECK-NEXT:    cmpl $1, %eax
; CHECK-NEXT:    jne LBB0_3
; CHECK-NEXT:  ## %bb.5: ## %bb20.i.i937.exitStub
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    movw $3, %ax
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB0_6: ## %NodeBlock
; CHECK-NEXT:    js LBB0_9
; CHECK-NEXT:  ## %bb.7: ## %LeafBlock1
; CHECK-NEXT:    jne LBB0_3
; CHECK-NEXT:  ## %bb.8: ## %bb12.i.i935.exitStub
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    movw $2, %ax
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB0_2: ## %LeafBlock3
; CHECK-NEXT:    jne LBB0_3
; CHECK-NEXT:  ## %bb.11: ## %bb28.i.i938.exitStub
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    movw $4, %ax
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB0_9: ## %LeafBlock
; CHECK-NEXT:    cmpl $-1, %eax
; CHECK-NEXT:    je LBB0_10
; CHECK-NEXT:  LBB0_3: ## %NewDefault
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
; CHECK-NEXT:  LBB0_10: ## %bb.i14.i.exitStub
; CHECK-NEXT:    movl %edi, (%esi)
; CHECK-NEXT:    movw $1, %ax
; CHECK-NEXT:    addl $20, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    retl
newFuncRoot:
	br label %bb.i9.i.i932.ce

NewDefault:		; preds = %LeafBlock, %LeafBlock1, %LeafBlock2, %LeafBlock3
	br label %bb36.i.i.exitStub

bb36.i.i.exitStub:		; preds = %NewDefault
	store ptr %tmp2.i4.i.i931, ptr %tmp66.i62.i.out
	ret i16 0

bb.i14.i.exitStub:		; preds = %LeafBlock
	store ptr %tmp2.i4.i.i931, ptr %tmp66.i62.i.out
	ret i16 1

bb12.i.i935.exitStub:		; preds = %LeafBlock1
	store ptr %tmp2.i4.i.i931, ptr %tmp66.i62.i.out
	ret i16 2

bb20.i.i937.exitStub:		; preds = %LeafBlock2
	store ptr %tmp2.i4.i.i931, ptr %tmp66.i62.i.out
	ret i16 3

bb28.i.i938.exitStub:		; preds = %LeafBlock3
	store ptr %tmp2.i4.i.i931, ptr %tmp66.i62.i.out
	ret i16 4

bb.i9.i.i932.ce:		; preds = %newFuncRoot
	%tmp1.i3.i.i930 = getelementptr %struct.list, ptr %l_addr.01.0.i2.i.i929, i32 0, i32 0		; <ptr> [#uses=1]
	%tmp2.i4.i.i931 = load ptr, ptr %tmp1.i3.i.i930		; <ptr> [#uses=1]
	%tmp1.i6.i = getelementptr %struct.operator, ptr %tmp2.i4.i.i931, i32 0, i32 2		; <ptr> [#uses=1]
	%tmp2.i7.i = load i32, ptr %tmp1.i6.i		; <i32> [#uses=1]
	%tmp3.i8.i = load ptr, ptr @outfile		; <ptr> [#uses=1]
	%tmp5.i9.i = call i32 (ptr, ptr, ...) @fprintf( ptr %tmp3.i8.i, ptr @str1, i32 %tmp2.i7.i )		; <i32> [#uses=0]
	%tmp7.i10.i = getelementptr %struct.operator, ptr %tmp2.i4.i.i931, i32 0, i32 5		; <ptr> [#uses=1]
	%tmp8.i11.i = load i32, ptr %tmp7.i10.i		; <i32> [#uses=7]
	br label %NodeBlock5

NodeBlock5:		; preds = %bb.i9.i.i932.ce
	icmp slt i32 %tmp8.i11.i, 1		; <i1>:0 [#uses=1]
	br i1 %0, label %NodeBlock, label %NodeBlock4

NodeBlock4:		; preds = %NodeBlock5
	icmp slt i32 %tmp8.i11.i, 2		; <i1>:1 [#uses=1]
	br i1 %1, label %LeafBlock2, label %LeafBlock3

LeafBlock3:		; preds = %NodeBlock4
	icmp eq i32 %tmp8.i11.i, 2		; <i1>:2 [#uses=1]
	br i1 %2, label %bb28.i.i938.exitStub, label %NewDefault

LeafBlock2:		; preds = %NodeBlock4
	icmp eq i32 %tmp8.i11.i, 1		; <i1>:3 [#uses=1]
	br i1 %3, label %bb20.i.i937.exitStub, label %NewDefault

NodeBlock:		; preds = %NodeBlock5
	icmp slt i32 %tmp8.i11.i, 0		; <i1>:4 [#uses=1]
	br i1 %4, label %LeafBlock, label %LeafBlock1

LeafBlock1:		; preds = %NodeBlock
	icmp eq i32 %tmp8.i11.i, 0		; <i1>:5 [#uses=1]
	br i1 %5, label %bb12.i.i935.exitStub, label %NewDefault

LeafBlock:		; preds = %NodeBlock
	icmp eq i32 %tmp8.i11.i, -1		; <i1>:6 [#uses=1]
	br i1 %6, label %bb.i14.i.exitStub, label %NewDefault
}
