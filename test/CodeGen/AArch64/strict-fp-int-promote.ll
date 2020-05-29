; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -o - %s | FileCheck %s
; RUN: llc -O3 -o - %s | FileCheck %s --check-prefix=SUBOPTIMAL
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-arm-none-eabi"

declare float @llvm.experimental.constrained.sitofp.f32.i32(i32, metadata, metadata)
declare float @llvm.experimental.constrained.sitofp.f32.i16(i16, metadata, metadata)
declare i1 @llvm.experimental.constrained.fcmp.f32(float, float, metadata, metadata)
declare float @llvm.experimental.constrained.uitofp.f32.i16(i16, metadata, metadata)

define i32 @test() #0 {
; CHECK-LABEL: test:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    scvtf s0, w8
; CHECK-NEXT:    fcmp s0, s0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
;
; SUBOPTIMAL-LABEL: test:
; SUBOPTIMAL:       // %bb.0: // %entry
; SUBOPTIMAL-NEXT:    mov w8, #1
; SUBOPTIMAL-NEXT:    scvtf s0, w8
; SUBOPTIMAL-NEXT:    mov w8, #1
; SUBOPTIMAL-NEXT:    scvtf s1, w8
; SUBOPTIMAL-NEXT:    fcmp s0, s1
; SUBOPTIMAL-NEXT:    cset w8, eq
; SUBOPTIMAL-NEXT:    and w0, w8, #0x1
; SUBOPTIMAL-NEXT:    ret
entry:
  %conv = call float @llvm.experimental.constrained.sitofp.f32.i32(i32 1, metadata !"round.tonearest", metadata !"fpexcept.strict") #1
  %conv1 = call float @llvm.experimental.constrained.sitofp.f32.i16(i16 1, metadata !"round.tonearest", metadata !"fpexcept.strict") #1
  %cmp = call i1 @llvm.experimental.constrained.fcmp.f32(float %conv, float %conv1, metadata !"oeq", metadata !"fpexcept.strict") #1
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

define i32 @test2() #0 {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    scvtf s0, w8
; CHECK-NEXT:    ucvtf s1, w8
; CHECK-NEXT:    fcmp s0, s1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
;
; SUBOPTIMAL-LABEL: test2:
; SUBOPTIMAL:       // %bb.0: // %entry
; SUBOPTIMAL-NEXT:    mov w8, #1
; SUBOPTIMAL-NEXT:    scvtf s0, w8
; SUBOPTIMAL-NEXT:    mov w8, #1
; SUBOPTIMAL-NEXT:    ucvtf s1, w8
; SUBOPTIMAL-NEXT:    fcmp s0, s1
; SUBOPTIMAL-NEXT:    cset w8, eq
; SUBOPTIMAL-NEXT:    and w0, w8, #0x1
; SUBOPTIMAL-NEXT:    ret
entry:
  %conv = call float @llvm.experimental.constrained.sitofp.f32.i32(i32 1, metadata !"round.tonearest", metadata !"fpexcept.strict") #1
  %conv1 = call float @llvm.experimental.constrained.uitofp.f32.i16(i16 1, metadata !"round.tonearest", metadata !"fpexcept.strict") #1
  %cmp = call i1 @llvm.experimental.constrained.fcmp.f32(float %conv, float %conv1, metadata !"oeq", metadata !"fpexcept.strict") #1
  %conv2 = zext i1 %cmp to i32
  ret i32 %conv2
}

attributes #0 = { strictfp noinline optnone }
attributes #1 = { strictfp }
