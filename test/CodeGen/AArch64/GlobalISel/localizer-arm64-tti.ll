; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -o - -verify-machineinstrs -O0 -global-isel -stop-after=localizer %s | FileCheck %s
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios5.0.0"

@var1 = common global i32 0, align 4
@var2 = common global i32 0, align 4
@var3 = common global i32 0, align 4
@var4 = common global i32 0, align 4

; This is an ll test instead of MIR because -run-pass doesn't seem to support
; initializing the target TTI which we need for this test.

; Some of the instructions in entry block are dead after this pass so don't
; strictly need to be checked for.

define i32 @foo() {
  ; CHECK-LABEL: name: foo
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   successors: %bb.2(0x40000000), %bb.3(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var1
  ; CHECK-NEXT:   [[C:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 2
  ; CHECK-NEXT:   [[GV1:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var2
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 3
  ; CHECK-NEXT:   [[GV2:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var3
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 0
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:gpr(s32) = G_LOAD [[GV]](p0) :: (dereferenceable load (s32) from @var1)
  ; CHECK-NEXT:   [[C3:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 1
  ; CHECK-NEXT:   [[ICMP:%[0-9]+]]:gpr(s32) = G_ICMP intpred(ne), [[LOAD]](s32), [[C3]]
  ; CHECK-NEXT:   [[AND:%[0-9]+]]:gpr(s32) = G_AND [[ICMP]], [[C3]]
  ; CHECK-NEXT:   G_BRCOND [[AND]](s32), %bb.3
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.if.then:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[GV3:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var2
  ; CHECK-NEXT:   [[C4:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 2
  ; CHECK-NEXT:   G_STORE [[C4]](s32), [[GV3]](p0) :: (store (s32) into @var2)
  ; CHECK-NEXT:   [[C5:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 3
  ; CHECK-NEXT:   G_STORE [[C5]](s32), [[GV]](p0) :: (store (s32) into @var1)
  ; CHECK-NEXT:   [[GV4:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var3
  ; CHECK-NEXT:   G_STORE [[C4]](s32), [[GV4]](p0) :: (store (s32) into @var3)
  ; CHECK-NEXT:   G_STORE [[C5]](s32), [[GV]](p0) :: (store (s32) into @var1)
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.if.end:
  ; CHECK-NEXT:   [[C6:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 0
  ; CHECK-NEXT:   $w0 = COPY [[C6]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %0 = load i32, i32* @var1, align 4
  %cmp = icmp eq i32 %0, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 2, i32* @var2, align 4
  store i32 3, i32* @var1, align 4
  store i32 2, i32* @var3, align 4
  store i32 3, i32* @var1, align 4
  br label %if.end

if.end:
  ret i32 0
}

@tls_gv = common thread_local global i32 0, align 4

; This test checks that we don't try to localize TLS variables on Darwin.
; If the user happens to be inside a call sequence, we could end up rematerializing
; below a physreg write, clobbering it (TLS accesses on Darwin need a function call).
; For now, we check we don't localize at all. We could in theory make sure that
; we don't localize into the middle of a call sequence instead.
define i32 @darwin_tls() {
  ; CHECK-LABEL: name: darwin_tls
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   successors: %bb.2(0x40000000), %bb.3(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @tls_gv
  ; CHECK-NEXT:   [[GV1:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var2
  ; CHECK-NEXT:   [[C:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 0
  ; CHECK-NEXT:   [[GV2:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var1
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:gpr(s32) = G_LOAD [[GV2]](p0) :: (dereferenceable load (s32) from @var1)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 1
  ; CHECK-NEXT:   [[ICMP:%[0-9]+]]:gpr(s32) = G_ICMP intpred(ne), [[LOAD]](s32), [[C1]]
  ; CHECK-NEXT:   [[AND:%[0-9]+]]:gpr(s32) = G_AND [[ICMP]], [[C1]]
  ; CHECK-NEXT:   G_BRCOND [[AND]](s32), %bb.3
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.if.then:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[LOAD1:%[0-9]+]]:gpr(s32) = G_LOAD [[GV]](p0) :: (dereferenceable load (s32) from @tls_gv)
  ; CHECK-NEXT:   [[GV3:%[0-9]+]]:gpr(p0) = G_GLOBAL_VALUE @var2
  ; CHECK-NEXT:   G_STORE [[LOAD1]](s32), [[GV3]](p0) :: (store (s32) into @var2)
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.if.end:
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:gpr(s32) = G_CONSTANT i32 0
  ; CHECK-NEXT:   $w0 = COPY [[C2]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %0 = load i32, i32* @var1, align 4
  %cmp = icmp eq i32 %0, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %tls = load i32, i32* @tls_gv, align 4
  store i32 %tls, i32* @var2, align 4
  br label %if.end

if.end:
  ret i32 0
}

