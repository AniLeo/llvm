; RUN: llc < %s -asm-verbose=false | FileCheck %s

; Test that basic 32-bit integer comparison operations assemble as expected.

target datalayout = "e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: (func $eq_i32
; CHECK-NEXT: (param i32) (param i32) (result i32)
; CHECK-NEXT: (set_local @0 (argument 1))
; CHECK-NEXT: (set_local @1 (argument 0))
; CHECK-NEXT: (set_local @2 (eq @1 @0))
; CHECK-NEXT: (return @2)
define i32 @eq_i32(i32 %x, i32 %y) {
  %a = icmp eq i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $ne_i32
; CHECK: (set_local @2 (ne @1 @0))
define i32 @ne_i32(i32 %x, i32 %y) {
  %a = icmp ne i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $slt_i32
; CHECK: (set_local @2 (slt @1 @0))
define i32 @slt_i32(i32 %x, i32 %y) {
  %a = icmp slt i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $sle_i32
; CHECK: (set_local @2 (sle @1 @0))
define i32 @sle_i32(i32 %x, i32 %y) {
  %a = icmp sle i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $ult_i32
; CHECK: (set_local @2 (ult @1 @0))
define i32 @ult_i32(i32 %x, i32 %y) {
  %a = icmp ult i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $ule_i32
; CHECK: (set_local @2 (ule @1 @0))
define i32 @ule_i32(i32 %x, i32 %y) {
  %a = icmp ule i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $sgt_i32
; CHECK: (set_local @2 (sgt @1 @0))
define i32 @sgt_i32(i32 %x, i32 %y) {
  %a = icmp sgt i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $sge_i32
; CHECK: (set_local @2 (sge @1 @0))
define i32 @sge_i32(i32 %x, i32 %y) {
  %a = icmp sge i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $ugt_i32
; CHECK: (set_local @2 (ugt @1 @0))
define i32 @ugt_i32(i32 %x, i32 %y) {
  %a = icmp ugt i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}

; CHECK-LABEL: (func $uge_i32
; CHECK: (set_local @2 (uge @1 @0))
define i32 @uge_i32(i32 %x, i32 %y) {
  %a = icmp uge i32 %x, %y
  %b = zext i1 %a to i32
  ret i32 %b
}
