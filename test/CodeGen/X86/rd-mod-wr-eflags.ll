; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

%struct.obj = type { i64 }

define void @_Z7releaseP3obj(%struct.obj* nocapture %o) nounwind uwtable ssp {
; CHECK-LABEL: _Z7releaseP3obj:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    decq (%rdi)
; CHECK-NEXT:    je .LBB0_2
; CHECK-NEXT:  # %bb.1: # %return
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_2: # %if.end
; CHECK-NEXT:    jmp free # TAILCALL
entry:
  %refcnt = getelementptr inbounds %struct.obj, %struct.obj* %o, i64 0, i32 0
  %0 = load i64, i64* %refcnt, align 8
  %dec = add i64 %0, -1
  store i64 %dec, i64* %refcnt, align 8
  %tobool = icmp eq i64 %dec, 0
  br i1 %tobool, label %if.end, label %return

if.end:                                           ; preds = %entry
  %1 = bitcast %struct.obj* %o to i8*
  tail call void @free(i8* %1)
  br label %return

return:                                           ; preds = %entry, %if.end
  ret void
}

@c = common global i64 0, align 8
@a = common global i32 0, align 4
@.str = private unnamed_addr constant [5 x i8] c"%ld\0A\00", align 1
@b = common global i32 0, align 4

define i32 @test() nounwind uwtable ssp {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq {{.*}}(%rip), %rsi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    decq %rsi
; CHECK-NEXT:    movq %rsi, {{.*}}(%rip)
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    movl $.L.str, %edi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    callq printf
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
%0 = load i64, i64* @c, align 8
%dec.i = add nsw i64 %0, -1
store i64 %dec.i, i64* @c, align 8
%tobool.i = icmp ne i64 %dec.i, 0
%lor.ext.i = zext i1 %tobool.i to i32
store i32 %lor.ext.i, i32* @a, align 4
%call = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i64 %dec.i) nounwind
ret i32 0
}

define i32 @test2() nounwind uwtable ssp {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movq {{.*}}(%rip), %rax
; CHECK-NEXT:    leaq -1(%rax), %rsi
; CHECK-NEXT:    movq %rsi, {{.*}}(%rip)
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    testq %rax, %rax
; CHECK-NEXT:    setne %cl
; CHECK-NEXT:    movl %ecx, {{.*}}(%rip)
; CHECK-NEXT:    movl $.L.str, %edi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    callq printf
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
%0 = load i64, i64* @c, align 8
%dec.i = add nsw i64 %0, -1
store i64 %dec.i, i64* @c, align 8
%tobool.i = icmp ne i64 %0, 0
%lor.ext.i = zext i1 %tobool.i to i32
store i32 %lor.ext.i, i32* @a, align 4
%call = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i64 %dec.i) nounwind
ret i32 0
}

declare i32 @printf(i8* nocapture, ...) nounwind

declare void @free(i8* nocapture) nounwind

%struct.obj2 = type { i64, i32, i16, i8 }

declare void @other(%struct.obj2* ) nounwind;

define void @example_dec(%struct.obj2* %o) nounwind uwtable ssp {
; 64 bit dec
; CHECK-LABEL: example_dec:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    decq (%rdi)
; CHECK-NEXT:    jne .LBB3_4
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    decl 8(%rdi)
; CHECK-NEXT:    jne .LBB3_4
; CHECK-NEXT:  # %bb.2: # %if.end1
; CHECK-NEXT:    decw 12(%rdi)
; CHECK-NEXT:    jne .LBB3_4
; CHECK-NEXT:  # %bb.3: # %if.end2
; CHECK-NEXT:    decb 14(%rdi)
; CHECK-NEXT:    je .LBB3_5
; CHECK-NEXT:  .LBB3_4: # %return
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_5: # %if.end4
; CHECK-NEXT:    jmp other # TAILCALL
entry:
  %s64 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 0
  %0 = load i64, i64* %s64, align 8
  %dec = add i64 %0, -1
  store i64 %dec, i64* %s64, align 8
  %tobool = icmp eq i64 %dec, 0
  br i1 %tobool, label %if.end, label %return

; 32 bit dec
if.end:
  %s32 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 1
  %1 = load i32, i32* %s32, align 4
  %dec1 = add i32 %1, -1
  store i32 %dec1, i32* %s32, align 4
  %tobool2 = icmp eq i32 %dec1, 0
  br i1 %tobool2, label %if.end1, label %return

; 16 bit dec
if.end1:
  %s16 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 2
  %2 = load i16, i16* %s16, align 2
  %dec2 = add i16 %2, -1
  store i16 %dec2, i16* %s16, align 2
  %tobool3 = icmp eq i16 %dec2, 0
  br i1 %tobool3, label %if.end2, label %return

; 8 bit dec
if.end2:
  %s8 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 3
  %3 = load i8, i8* %s8
  %dec3 = add i8 %3, -1
  store i8 %dec3, i8* %s8
  %tobool4 = icmp eq i8 %dec3, 0
  br i1 %tobool4, label %if.end4, label %return

if.end4:
  tail call void @other(%struct.obj2* %o) nounwind
  br label %return

return:                                           ; preds = %if.end4, %if.end, %entry
  ret void
}

define void @example_inc(%struct.obj2* %o) nounwind uwtable ssp {
; 64 bit inc
; CHECK-LABEL: example_inc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    incq (%rdi)
; CHECK-NEXT:    jne .LBB4_4
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    incl 8(%rdi)
; CHECK-NEXT:    jne .LBB4_4
; CHECK-NEXT:  # %bb.2: # %if.end1
; CHECK-NEXT:    incw 12(%rdi)
; CHECK-NEXT:    jne .LBB4_4
; CHECK-NEXT:  # %bb.3: # %if.end2
; CHECK-NEXT:    incb 14(%rdi)
; CHECK-NEXT:    jne .LBB4_4
; CHECK-NEXT:  # %bb.5: # %if.end4
; CHECK-NEXT:    jmp other # TAILCALL
; CHECK-NEXT:  .LBB4_4: # %return
; CHECK-NEXT:    retq
entry:
  %s64 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 0
  %0 = load i64, i64* %s64, align 8
  %inc = add i64 %0, 1
  store i64 %inc, i64* %s64, align 8
  %tobool = icmp eq i64 %inc, 0
  br i1 %tobool, label %if.end, label %return

; 32 bit inc
if.end:
  %s32 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 1
  %1 = load i32, i32* %s32, align 4
  %inc1 = add i32 %1, 1
  store i32 %inc1, i32* %s32, align 4
  %tobool2 = icmp eq i32 %inc1, 0
  br i1 %tobool2, label %if.end1, label %return

; 16 bit inc
if.end1:
  %s16 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 2
  %2 = load i16, i16* %s16, align 2
  %inc2 = add i16 %2, 1
  store i16 %inc2, i16* %s16, align 2
  %tobool3 = icmp eq i16 %inc2, 0
  br i1 %tobool3, label %if.end2, label %return

; 8 bit inc
if.end2:
  %s8 = getelementptr inbounds %struct.obj2, %struct.obj2* %o, i64 0, i32 3
  %3 = load i8, i8* %s8
  %inc3 = add i8 %3, 1
  store i8 %inc3, i8* %s8
  %tobool4 = icmp eq i8 %inc3, 0
  br i1 %tobool4, label %if.end4, label %return

if.end4:
  tail call void @other(%struct.obj2* %o) nounwind
  br label %return

return:
  ret void
}

; Deal with TokenFactor chain
; rdar://11236106
@foo = external global i64*, align 8

define void @test3() nounwind ssp {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq {{.*}}(%rip), %rax
; CHECK-NEXT:    decq 16(%rax)
; CHECK-NEXT:    je .LBB5_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB5_2: # %if.then
; CHECK-NEXT:    jmp baz # TAILCALL
entry:
  %0 = load i64*, i64** @foo, align 8
  %arrayidx = getelementptr inbounds i64, i64* %0, i64 2
  %1 = load i64, i64* %arrayidx, align 8
  %dec = add i64 %1, -1
  store i64 %dec, i64* %arrayidx, align 8
  %cmp = icmp eq i64 %dec, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void @baz() nounwind
  br label %if.end

if.end:
  ret void
}

declare void @baz()

; Avoid creating a cycle in the DAG which would trigger an assert in the
; scheduler.
; PR12565
; rdar://11451474
@x = external global i32, align 4
@y = external global i32, align 4
@z = external global i32, align 4

define void @test4() nounwind uwtable ssp {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    decl {{.*}}(%rip)
; CHECK-NEXT:    je .LBB6_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movl {{.*}}(%rip), %eax
; CHECK-NEXT:  .LBB6_2: # %entry
; CHECK-NEXT:    movl %eax, {{.*}}(%rip)
; CHECK-NEXT:    retq
entry:
  %0 = load i32, i32* @x, align 4
  %1 = load i32, i32* @y, align 4
  %dec = add nsw i32 %1, -1
  store i32 %dec, i32* @y, align 4
  %tobool.i = icmp ne i32 %dec, 0
  %cond.i = select i1 %tobool.i, i32 %0, i32 0
  store i32 %cond.i, i32* @z, align 4
  ret void
}
