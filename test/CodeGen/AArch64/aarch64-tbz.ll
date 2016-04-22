; RUN: llc -verify-machineinstrs -mtriple=aarch64-linux-gnueabi < %s | FileCheck %s

; CHECK-LABEL: test1
; CHECK: tbz {{w[0-9]}}, #3, {{.LBB0_3}}
; CHECK: tbz [[REG1:x[0-9]+]], #2, {{.LBB0_3}}
; CHECK-NOT: and [[REG2:x[0-9]+]], [[REG1]], #0x4
; CHECK-NOT: cbz [[REG2]], {{.LBB0_3}}

; CHECK: b
define void @test1(i64 %A, i64 %B) {
entry:
  %and = and i64 %A, 4
  %notlhs = icmp eq i64 %and, 0
  %and.1 = and i64 %B, 8
  %0 = icmp eq i64 %and.1, 0
  %1 = or i1 %0, %notlhs
  br i1 %1, label %if.end3, label %if.then2

if.then2:                                         ; preds = %entry
  tail call void @foo(i64 %A, i64 %B)
  br label %if.end3

if.end3:                                          ; preds = %if.then2, %entry
  ret void
}

; CHECK-LABEL: test2
; CHECK: cbz {{x[0-9]}}, {{.LBB1_3}}
; CHECK: tbz [[REG1:x[0-9]+]], #3, {{.LBB1_3}}
; CHECK-NOT: and [REG2:x[0-9]+], [[REG1]], #0x08
; CHECK-NOT: cbz [[REG2]], {{.LBB1_3}}

define void @test2(i64 %A, i64* readonly %B) #0 {
entry:
  %tobool = icmp eq i64* %B, null
  %and = and i64 %A, 8
  %tobool1 = icmp eq i64 %and, 0
  %or.cond = or i1 %tobool, %tobool1
  br i1 %or.cond, label %if.end3, label %if.then2

if.then2:                                         ; preds = %entry
  %0 = load i64, i64* %B, align 4
  tail call void @foo(i64 %A, i64 %0)
  br label %if.end3

if.end3:                                          ; preds = %entry, %if.then2
  ret void
}


declare void @foo(i64, i64)
