; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=avr --mcpu=atmega328 -O0 -verify-machineinstrs | FileCheck %s

;; This .ll file is generated from the following cpp program:
;; struct foo {
;;   foo();
;; };
;; foo::foo() {}
;; foo f2;
;; Check https://github.com/llvm/llvm-project/issues/43443 for details.

%struct.foo = type { i8 }

@f2 = global %struct.foo zeroinitializer

@llvm.global_ctors = appending global [1 x { i32, void () addrspace(1)*, i8* }] [{ i32, void () addrspace(1)*, i8* } { i32 65535, void () addrspace(1)* @_GLOBAL__sub_I_failed.cc, i8* null }]

@_ZN3fooC1Ev = alias void (%struct.foo*), void (%struct.foo*) addrspace(1)* @_ZN3fooC2Ev

define void @_ZN3fooC2Ev(%struct.foo* dereferenceable(1) %this) {
; CHECK-LABEL: _ZN3fooC2Ev:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    push r28
; CHECK-NEXT:    push r29
; CHECK-NEXT:    in r28, 61
; CHECK-NEXT:    in r29, 62
; CHECK-NEXT:    sbiw r28, 2
; CHECK-NEXT:    in r0, 63
; CHECK-NEXT:    cli
; CHECK-NEXT:    out 62, r29
; CHECK-NEXT:    out 63, r0
; CHECK-NEXT:    out 61, r28
; CHECK-NEXT:    std Y+1, r24
; CHECK-NEXT:    std Y+2, r25
; CHECK-NEXT:    adiw r28, 2
; CHECK-NEXT:    in r0, 63
; CHECK-NEXT:    cli
; CHECK-NEXT:    out 62, r29
; CHECK-NEXT:    out 63, r0
; CHECK-NEXT:    out 61, r28
; CHECK-NEXT:    pop r29
; CHECK-NEXT:    pop r28
; CHECK-NEXT:    ret
entry:
  %this.addr = alloca %struct.foo*
  store %struct.foo* %this, %struct.foo** %this.addr
  %this1 = load %struct.foo*, %struct.foo** %this.addr
  ret void
}

define internal void @__cxx_global_var_init() addrspace(1) {
; CHECK-LABEL: __cxx_global_var_init:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    ldi r24, lo8(f2)
; CHECK-NEXT:    ldi r25, hi8(f2)
; CHECK-NEXT:    call _ZN3fooC1Ev
; CHECK-NEXT:    ret
entry:
  call addrspace(1) void @_ZN3fooC1Ev(%struct.foo* dereferenceable(1) @f2)
  ret void
}

define internal void @_GLOBAL__sub_I_failed.cc() addrspace(1) {
; CHECK-LABEL: _GLOBAL__sub_I_failed.cc:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    call __cxx_global_var_init
; CHECK-NEXT:    ret
entry:
  call addrspace(1) void @__cxx_global_var_init()
  ret void
}
