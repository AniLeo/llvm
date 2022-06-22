; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown -verify-machineinstrs < %s | FileCheck %s
; RUN: opt < %s -codegenprepare -S -mtriple=x86_64-unknown-unknown | FileCheck --check-prefix=CHECK-CGP %s

@A = global i32 zeroinitializer
@B = global i32 zeroinitializer
@C = global i32 zeroinitializer

; Test that 'and' is sunk into bb0.
define i32 @and_sink1(i32 %a, i1 %c) {
; CHECK-LABEL: and_sink1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, {{[0-9]+}}(%esp)
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    testb $4, %al
; CHECK-NEXT:    movl $0, A
; CHECK-NEXT:    jne .LBB0_3
; CHECK-NEXT:  # %bb.2: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB0_3: # %bb2
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl

; CHECK-CGP-LABEL: @and_sink1(
; CHECK-CGP-NOT: and i32
  %and = and i32 %a, 4
  br i1 %c, label %bb0, label %bb2
bb0:
; CHECK-CGP-LABEL: bb0:
; CHECK-CGP: and i32
; CHECK-CGP-NEXT: icmp eq i32
; CHECK-CGP-NEXT: store
; CHECK-CGP-NEXT: br
  %cmp = icmp eq i32 %and, 0
  store i32 0, ptr @A
  br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 0
}

; Test that both 'and' and cmp get sunk to bb1.
define i32 @and_sink2(i32 %a, i1 %c, i1 %c2) {
; CHECK-LABEL: and_sink2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl $0, A
; CHECK-NEXT:    testb $1, {{[0-9]+}}(%esp)
; CHECK-NEXT:    je .LBB1_5
; CHECK-NEXT:  # %bb.1: # %bb0.preheader
; CHECK-NEXT:    movb {{[0-9]+}}(%esp), %al
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB1_2: # %bb0
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl $0, B
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    je .LBB1_5
; CHECK-NEXT:  # %bb.3: # %bb1
; CHECK-NEXT:    # in Loop: Header=BB1_2 Depth=1
; CHECK-NEXT:    testb $4, %cl
; CHECK-NEXT:    movl $0, C
; CHECK-NEXT:    jne .LBB1_2
; CHECK-NEXT:  # %bb.4: # %bb2
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB1_5: # %bb3
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl

; CHECK-CGP-LABEL: @and_sink2(
; CHECK-CGP-NOT: and i32
  %and = and i32 %a, 4
  store i32 0, ptr @A
  br i1 %c, label %bb0, label %bb3
bb0:
; CHECK-CGP-LABEL: bb0:
; CHECK-CGP-NOT: and i32
; CHECK-CGP-NOT: icmp
  %cmp = icmp eq i32 %and, 0
  store i32 0, ptr @B
  br i1 %c2, label %bb1, label %bb3
bb1:
; CHECK-CGP-LABEL: bb1:
; CHECK-CGP: and i32
; CHECK-CGP-NEXT: icmp eq i32
; CHECK-CGP-NEXT: store
; CHECK-CGP-NEXT: br
  store i32 0, ptr @C
  br i1 %cmp, label %bb2, label %bb0
bb2:
  ret i32 1
bb3:
  ret i32 0
}

; Test that CodeGenPrepare doesn't get stuck in a loop sinking and hoisting a masked load.
define i32 @and_sink3(i1 %c, ptr %p) {
; CHECK-LABEL: and_sink3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, {{[0-9]+}}(%esp)
; CHECK-NEXT:    je .LBB2_3
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movzbl (%eax), %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    movl $0, A
; CHECK-NEXT:    je .LBB2_2
; CHECK-NEXT:  .LBB2_3: # %bb2
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB2_2: # %bb1
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl

; CHECK-CGP-LABEL: @and_sink3(
; CHECK-CGP: load i32
; CHECK-CGP-NEXT: and i32
  %load = load i32, ptr %p
  %and = and i32 %load, 255
  br i1 %c, label %bb0, label %bb2
bb0:
; CHECK-CGP-LABEL: bb0:
; CHECK-CGP-NOT: and i32
; CHECK-CGP: icmp eq i32
  %cmp = icmp eq i32 %and, 0
  store i32 0, ptr @A
  br i1 %cmp, label %bb1, label %bb2
bb1:
  ret i32 1
bb2:
  ret i32 0
}

; Test that CodeGenPrepare sinks/duplicates non-immediate 'and'.
define i32 @and_sink4(i32 %a, i32 %b, i1 %c) {
; CHECK-LABEL: and_sink4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, {{[0-9]+}}(%esp)
; CHECK-NEXT:    je .LBB3_4
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    testl %eax, %ecx
; CHECK-NEXT:    movl $0, A
; CHECK-NEXT:    jne .LBB3_4
; CHECK-NEXT:  # %bb.2: # %bb1
; CHECK-NEXT:    leal (%ecx,%eax), %edx
; CHECK-NEXT:    testl %eax, %ecx
; CHECK-NEXT:    movl %edx, B
; CHECK-NEXT:    je .LBB3_3
; CHECK-NEXT:  .LBB3_4: # %bb3
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB3_3: # %bb2
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl

; CHECK-CGP-LABEL: @and_sink4(
; CHECK-CGP-NOT: and i32
; CHECK-CGP-NOT: icmp
  %and = and i32 %a, %b
  %cmp = icmp eq i32 %and, 0
  br i1 %c, label %bb0, label %bb3
bb0:
; CHECK-CGP-LABEL: bb0:
; CHECK-CGP: and i32
; CHECK-CGP-NEXT: icmp eq i32
  store i32 0, ptr @A
  br i1 %cmp, label %bb1, label %bb3
bb1:
; CHECK-CGP-LABEL: bb1:
; CHECK-CGP: and i32
; CHECK-CGP-NEXT: icmp eq i32
  %add = add i32 %a, %b
  store i32 %add, ptr @B
  br i1 %cmp, label %bb2, label %bb3
bb2:
  ret i32 1
bb3:
  ret i32 0
}


; Test that CodeGenPrepare doesn't sink/duplicate non-immediate 'and'
; when it would increase register pressure.
define i32 @and_sink5(i32 %a, i32 %b, i32 %a2, i32 %b2, i1 %c) {
; CHECK-LABEL: and_sink5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, {{[0-9]+}}(%esp)
; CHECK-NEXT:    je .LBB4_4
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl $0, A
; CHECK-NEXT:    jne .LBB4_4
; CHECK-NEXT:  # %bb.2: # %bb1
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    addl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    movl %ecx, B
; CHECK-NEXT:    je .LBB4_3
; CHECK-NEXT:  .LBB4_4: # %bb3
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB4_3: # %bb2
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    retl

; CHECK-CGP-LABEL: @and_sink5(
; CHECK-CGP: and i32
; CHECK-CGP-NOT: icmp
  %and = and i32 %a, %b
  %cmp = icmp eq i32 %and, 0
  br i1 %c, label %bb0, label %bb3
bb0:
; CHECK-CGP-LABEL: bb0:
; CHECK-CGP-NOT: and i32
; CHECK-CGP: icmp eq i32
  store i32 0, ptr @A
  br i1 %cmp, label %bb1, label %bb3
bb1:
; CHECK-CGP-LABEL: bb1:
; CHECK-CGP-NOT: and i32
; CHECK-CGP: icmp eq i32
  %add = add i32 %a2, %b2
  store i32 %add, ptr @B
  br i1 %cmp, label %bb2, label %bb3
bb2:
  ret i32 1
bb3:
  ret i32 0
}
