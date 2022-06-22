; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s
; PR964

define ptr @FindChar(ptr %CurPtr) {
; CHECK-LABEL: FindChar:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    .cfi_offset %esi, -12
; CHECK-NEXT:    .cfi_offset %edi, -8
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %bb
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl (%esi,%edi), %eax
; CHECK-NEXT:    incl %edi
; CHECK-NEXT:    cmpl $120, %eax
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.2: # %bb
; CHECK-NEXT:    # in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  .LBB0_3: # %bb7
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK-NEXT:    calll foo@PLT
; CHECK-NEXT:    addl $4, %esp
; CHECK-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK-NEXT:    addl %edi, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    popl %edi
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
entry:
        br label %bb

bb:             ; preds = %bb, %entry
        %indvar = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]          ; <i32> [#uses=3]
        %CurPtr_addr.0.rec = bitcast i32 %indvar to i32         ; <i32> [#uses=1]
        %gep.upgrd.1 = zext i32 %indvar to i64          ; <i64> [#uses=1]
        %CurPtr_addr.0 = getelementptr i8, ptr %CurPtr, i64 %gep.upgrd.1            ; <ptr> [#uses=1]
        %tmp = load i8, ptr %CurPtr_addr.0          ; <i8> [#uses=3]
        %tmp2.rec = add i32 %CurPtr_addr.0.rec, 1               ; <i32> [#uses=1]
        %tmp2 = getelementptr i8, ptr %CurPtr, i32 %tmp2.rec                ; <ptr> [#uses=1]
        %indvar.next = add i32 %indvar, 1               ; <i32> [#uses=1]
        switch i8 %tmp, label %bb [
                 i8 0, label %bb7
                 i8 120, label %bb7
        ]

bb7:            ; preds = %bb, %bb
        tail call void @foo( i8 %tmp )
        ret ptr %tmp2
}

declare void @foo(i8)

; PR50080
; The important part of this test is that we emit only 1 bit test rather than
; 2 since the default BB of the switch is unreachable.
define i32 @baz(i32 %0) {
; CHECK-LABEL: baz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl $13056, %edx # imm = 0x3300
; CHECK-NEXT:    btl %ecx, %edx
; CHECK-NEXT:    jae .LBB1_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB1_1: # %sw.epilog8
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
  switch i32 %0, label %if.then.unreachabledefault [
    i32 4, label %sw.epilog8
    i32 5, label %sw.epilog8
    i32 8, label %sw.bb2
    i32 9, label %sw.bb2
    i32 12, label %sw.bb4
    i32 13, label %sw.bb4
  ]

sw.bb2:
  br label %return

sw.bb4:
  br label %return

sw.epilog8:
  br label %return

if.then.unreachabledefault:
  unreachable

return:
  %retval.0 = phi i32 [ 1, %sw.epilog8 ], [ 0, %sw.bb2 ], [ 0, %sw.bb4 ]
  ret i32 %retval.0
}
