; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s
; Bug in FindModifiedNodeSlot cause tmp14 load to become a zextload and shr 31
; is then optimized away.
@tree_code_type = external dso_local global [0 x i32]		; <[0 x i32]*> [#uses=1]

define void @copy_if_shared_r() {
; CHECK-LABEL: copy_if_shared_r:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl 0, %eax
; CHECK-NEXT:    movzbl %al, %ecx
; CHECK-NEXT:    movl tree_code_type(,%ecx,4), %ecx
; CHECK-NEXT:    decl %ecx
; CHECK-NEXT:    cmpl $2, %ecx
; CHECK-NEXT:    ja .LBB0_2
; CHECK-NEXT:  # %bb.1: # %cond_true
; CHECK-NEXT:    shrl $31, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:  .LBB0_2: # %cond_true17
; CHECK-NEXT:    retl
	%tmp = load i32, i32* null		; <i32> [#uses=1]
	%tmp56 = and i32 %tmp, 255		; <i32> [#uses=1]
	%gep.upgrd.1 = zext i32 %tmp56 to i64		; <i64> [#uses=1]
	%tmp8 = getelementptr [0 x i32], [0 x i32]* @tree_code_type, i32 0, i64 %gep.upgrd.1	; <i32*> [#uses=1]
	%tmp9 = load i32, i32* %tmp8		; <i32> [#uses=1]
	%tmp10 = add i32 %tmp9, -1		; <i32> [#uses=1]
	%tmp.upgrd.2 = icmp ugt i32 %tmp10, 2		; <i1> [#uses=1]
	%tmp14 = load i32, i32* null		; <i32> [#uses=1]
	%tmp15 = lshr i32 %tmp14, 31		; <i32> [#uses=1]
	%tmp15.upgrd.3 = trunc i32 %tmp15 to i8		; <i8> [#uses=1]
	%tmp16 = icmp ne i8 %tmp15.upgrd.3, 0		; <i1> [#uses=1]
	br i1 %tmp.upgrd.2, label %cond_false25, label %cond_true
cond_true:		; preds = %0
	br i1 %tmp16, label %cond_true17, label %cond_false
cond_true17:		; preds = %cond_true
	ret void
cond_false:		; preds = %cond_true
	ret void
cond_false25:		; preds = %0
	ret void
}

