; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -regalloc=fast -optimize-regalloc=0 -mtriple=i686-- -mattr=+mmx | FileCheck %s
; PR2082
; Local register allocator was refusing to use ESI, EDI, and EBP so it ran out of
; registers.
define void @transpose4x4(i8* %dst, i8* %src, i32 %dst_stride, i32 %src_stride) {
; CHECK-LABEL: transpose4x4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %esi, -16
; CHECK-NEXT:    .cfi_offset %edi, -12
; CHECK-NEXT:    .cfi_offset %ebx, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    leal (%ecx,%ecx,2), %edx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK-NEXT:    leal (%edi,%edi,2), %ebx
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movd (%esi), %mm0
; CHECK-NEXT:    movd (%esi,%edi), %mm1
; CHECK-NEXT:    movd (%esi,%edi,2), %mm2
; CHECK-NEXT:    movd (%esi,%ebx), %mm3
; CHECK-NEXT:    punpcklbw %mm1, %mm0 # mm0 = mm0[0],mm1[0],mm0[1],mm1[1],mm0[2],mm1[2],mm0[3],mm1[3]
; CHECK-NEXT:    punpcklbw %mm3, %mm2 # mm2 = mm2[0],mm3[0],mm2[1],mm3[1],mm2[2],mm3[2],mm2[3],mm3[3]
; CHECK-NEXT:    movq %mm0, %mm1
; CHECK-NEXT:    punpcklwd %mm2, %mm0 # mm0 = mm0[0],mm2[0],mm0[1],mm2[1]
; CHECK-NEXT:    punpckhwd %mm2, %mm1 # mm1 = mm1[2],mm2[2],mm1[3],mm2[3]
; CHECK-NEXT:    movd %mm0, (%eax)
; CHECK-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; CHECK-NEXT:    movd %mm0, (%eax,%ecx)
; CHECK-NEXT:    movd %mm1, (%eax,%ecx,2)
; CHECK-NEXT:    punpckhdq %mm1, %mm1 # mm1 = mm1[1,1]
; CHECK-NEXT:    movd %mm1, (%eax,%edx)
; CHECK-EMPTY:
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
	%dst_addr = alloca i8*		; <i8**> [#uses=5]
	%src_addr = alloca i8*		; <i8**> [#uses=5]
	%dst_stride_addr = alloca i32		; <i32*> [#uses=4]
	%src_stride_addr = alloca i32		; <i32*> [#uses=4]
	%"alloca point" = bitcast i32 0 to i32		; <i32> [#uses=0]
	store i8* %dst, i8** %dst_addr
	store i8* %src, i8** %src_addr
	store i32 %dst_stride, i32* %dst_stride_addr
	store i32 %src_stride, i32* %src_stride_addr
	%tmp = load i8*, i8** %dst_addr, align 4		; <i8*> [#uses=1]
	%tmp1 = getelementptr i8, i8* %tmp, i32 0		; <i8*> [#uses=1]
	%tmp12 = bitcast i8* %tmp1 to i32*		; <i32*> [#uses=1]
	%tmp3 = load i8*, i8** %dst_addr, align 4		; <i8*> [#uses=1]
	%tmp4 = load i32, i32* %dst_stride_addr, align 4		; <i32> [#uses=1]
	%tmp5 = getelementptr i8, i8* %tmp3, i32 %tmp4		; <i8*> [#uses=1]
	%tmp56 = bitcast i8* %tmp5 to i32*		; <i32*> [#uses=1]
	%tmp7 = load i32, i32* %dst_stride_addr, align 4		; <i32> [#uses=1]
	%tmp8 = mul i32 %tmp7, 2		; <i32> [#uses=1]
	%tmp9 = load i8*, i8** %dst_addr, align 4		; <i8*> [#uses=1]
	%tmp10 = getelementptr i8, i8* %tmp9, i32 %tmp8		; <i8*> [#uses=1]
	%tmp1011 = bitcast i8* %tmp10 to i32*		; <i32*> [#uses=1]
	%tmp13 = load i32, i32* %dst_stride_addr, align 4		; <i32> [#uses=1]
	%tmp14 = mul i32 %tmp13, 3		; <i32> [#uses=1]
	%tmp15 = load i8*, i8** %dst_addr, align 4		; <i8*> [#uses=1]
	%tmp16 = getelementptr i8, i8* %tmp15, i32 %tmp14		; <i8*> [#uses=1]
	%tmp1617 = bitcast i8* %tmp16 to i32*		; <i32*> [#uses=1]
	%tmp18 = load i8*, i8** %src_addr, align 4		; <i8*> [#uses=1]
	%tmp19 = getelementptr i8, i8* %tmp18, i32 0		; <i8*> [#uses=1]
	%tmp1920 = bitcast i8* %tmp19 to i32*		; <i32*> [#uses=1]
	%tmp21 = load i8*, i8** %src_addr, align 4		; <i8*> [#uses=1]
	%tmp22 = load i32, i32* %src_stride_addr, align 4		; <i32> [#uses=1]
	%tmp23 = getelementptr i8, i8* %tmp21, i32 %tmp22		; <i8*> [#uses=1]
	%tmp2324 = bitcast i8* %tmp23 to i32*		; <i32*> [#uses=1]
	%tmp25 = load i32, i32* %src_stride_addr, align 4		; <i32> [#uses=1]
	%tmp26 = mul i32 %tmp25, 2		; <i32> [#uses=1]
	%tmp27 = load i8*, i8** %src_addr, align 4		; <i8*> [#uses=1]
	%tmp28 = getelementptr i8, i8* %tmp27, i32 %tmp26		; <i8*> [#uses=1]
	%tmp2829 = bitcast i8* %tmp28 to i32*		; <i32*> [#uses=1]
	%tmp30 = load i32, i32* %src_stride_addr, align 4		; <i32> [#uses=1]
	%tmp31 = mul i32 %tmp30, 3		; <i32> [#uses=1]
	%tmp32 = load i8*, i8** %src_addr, align 4		; <i8*> [#uses=1]
	%tmp33 = getelementptr i8, i8* %tmp32, i32 %tmp31		; <i8*> [#uses=1]
	%tmp3334 = bitcast i8* %tmp33 to i32*		; <i32*> [#uses=1]
	call void asm sideeffect "movd  $4, %mm0                \0A\09movd  $5, %mm1                \0A\09movd  $6, %mm2                \0A\09movd  $7, %mm3                \0A\09punpcklbw %mm1, %mm0         \0A\09punpcklbw %mm3, %mm2         \0A\09movq %mm0, %mm1              \0A\09punpcklwd %mm2, %mm0         \0A\09punpckhwd %mm2, %mm1         \0A\09movd  %mm0, $0                \0A\09punpckhdq %mm0, %mm0         \0A\09movd  %mm0, $1                \0A\09movd  %mm1, $2                \0A\09punpckhdq %mm1, %mm1         \0A\09movd  %mm1, $3                \0A\09", "=*m,=*m,=*m,=*m,*m,*m,*m,*m,~{dirflag},~{fpsr},~{flags}"( i32* elementtype( i32) %tmp12, i32* elementtype(i32) %tmp56, i32* elementtype(i32) %tmp1011, i32* elementtype(i32) %tmp1617, i32* elementtype(i32) %tmp1920, i32* elementtype(i32) %tmp2324, i32* elementtype(i32) %tmp2829, i32* elementtype(i32) %tmp3334 ) nounwind
	br label %return

return:		; preds = %entry
	ret void
}
