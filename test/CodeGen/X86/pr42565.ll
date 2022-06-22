; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=atom | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mcpu=atom -filetype=obj -o /dev/null

define void @HUF_writeCTable_wksp()  {
; CHECK-LABEL: HUF_writeCTable_wksp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    movb $-2, %cl
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    leal 1(%rcx), %edx
; CHECK-NEXT:    movb %dl, (%rax)
; CHECK-NEXT:    movb %cl, (%rax)
; CHECK-NEXT:    leaq 2(%rax), %rax
; CHECK-NEXT:    addb $-2, %cl
; CHECK-NEXT:    jmp .LBB0_1
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv8 = phi i64 [ 1, %entry ], [ %indvars.iv.next9.1, %for.body ]
  %0 = trunc i64 %indvars.iv8 to i8
  %conv = sub i8 0, %0
  store i8 %conv, ptr undef, align 1
  %indvars.iv.next9 = add nuw nsw i64 %indvars.iv8, 1
  %1 = trunc i64 %indvars.iv.next9 to i8
  %conv.1 = sub i8 0, %1
  %arrayidx.1 = getelementptr inbounds i8, ptr null, i64 %indvars.iv.next9
  store i8 %conv.1, ptr %arrayidx.1, align 1
  %indvars.iv.next9.1 = add nuw nsw i64 %indvars.iv8, 2
  br i1 false, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  ret void
}
