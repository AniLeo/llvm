; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s

declare i32 @foo()

define i32 @test() {
; CHECK-LABEL: test:
; CHECK:       # BB#0:
; CHECK-NEXT:    calll foo
; CHECK-NEXT:    leal (%eax,%eax,8), %eax
; CHECK-NEXT:    retl
  %tmp.0 = tail call i32 @foo( )
  %tmp.1 = mul i32 %tmp.0, 9
  ret i32 %tmp.1
}

