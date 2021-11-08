; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -global-isel -stop-after=irtranslator < %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

@.str.2 = private unnamed_addr constant [7 x i8] c"Boom!\0A\00", align 1

define dso_local void @trap() {
  ; CHECK-LABEL: name: trap
  ; CHECK: bb.1.entry:
entry:
  unreachable
}

define dso_local void @test() personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
  ; CHECK-LABEL: name: test
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   successors: %bb.2(0x40000000), %bb.3(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @.str.2
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY [[GV]](p0)
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   INLINEASM &"bl trap", 1 /* sideeffect attdialect */
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.invoke.cont:
  ; CHECK-NEXT:   RET_ReallyLR
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.lpad (landing-pad):
  ; CHECK-NEXT:   liveins: $x0, $x1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(s128) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY $x1
  ; CHECK-NEXT:   [[PTRTOINT:%[0-9]+]]:_(s32) = G_PTRTOINT [[COPY2]](p0)
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   $x0 = COPY [[COPY]](p0)
  ; CHECK-NEXT:   BL @printf, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   $x0 = COPY [[COPY1]](p0)
  ; CHECK-NEXT:   BL @_Unwind_Resume, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
entry:


  invoke void asm sideeffect unwind "bl trap", ""()
          to label %invoke.cont unwind label %lpad

invoke.cont:
  ret void

lpad:

  %0 = landingpad { i8*, i32 }
          cleanup
  call void (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0))
  resume { i8*, i32 } %0

}

define void @test2() #0 personality i32 (...)* @__gcc_personality_v0 {
  ; CHECK-LABEL: name: test2
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x40000000), %bb.3(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[DEF:%[0-9]+]]:_(p0) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:gpr64common = COPY [[DEF]](p0)
  ; CHECK-NEXT:   INLINEASM &"", 1 /* sideeffect attdialect */, 1572873 /* reguse:GPR64common */, [[COPY]]
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.a:
  ; CHECK-NEXT:   RET_ReallyLR
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.b (landing-pad):
  ; CHECK-NEXT:   liveins: $x0, $x1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   [[DEF1:%[0-9]+]]:_(s128) = G_IMPLICIT_DEF
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:_(p0) = COPY $x1
  ; CHECK-NEXT:   [[PTRTOINT:%[0-9]+]]:_(s32) = G_PTRTOINT [[COPY2]](p0)
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   $x0 = COPY [[COPY1]](p0)
  ; CHECK-NEXT:   BL @_Unwind_Resume, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  invoke void asm sideeffect "", "r"(i64* undef) to label %a unwind label %b
a:
  ret void
b:
  %landing_pad = landingpad { i8*, i32 } cleanup
  resume { i8*, i32 } %landing_pad
}

declare i32 @__gcc_personality_v0(...)
declare dso_local i32 @__gxx_personality_v0(...)

declare dso_local void @printf(i8*, ...)
