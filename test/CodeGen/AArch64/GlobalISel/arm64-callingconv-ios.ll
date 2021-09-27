; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -stop-after=irtranslator -global-isel -verify-machineinstrs %s -o - | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-apple-ios9.0"

declare void @varargs(i32, double, i64, ...)
define void @test_varargs() {
  ; CHECK-LABEL: name: test_varargs
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_FCONSTANT double 1.000000e+00
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 12
  ; CHECK-NEXT:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK-NEXT:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK-NEXT:   [[C5:%[0-9]+]]:_(s32) = G_CONSTANT i32 4
  ; CHECK-NEXT:   [[C6:%[0-9]+]]:_(s32) = G_FCONSTANT float 1.000000e+00
  ; CHECK-NEXT:   [[C7:%[0-9]+]]:_(s64) = G_FCONSTANT double 2.000000e+00
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 40, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[C3]](s8)
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK-NEXT:   [[C8:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C8]](s64)
  ; CHECK-NEXT:   [[ANYEXT1:%[0-9]+]]:_(s64) = G_ANYEXT [[ANYEXT]](s32)
  ; CHECK-NEXT:   G_STORE [[ANYEXT1]](s64), [[PTR_ADD]](p0) :: (store (s64) into stack, align 1)
  ; CHECK-NEXT:   [[ANYEXT2:%[0-9]+]]:_(s32) = G_ANYEXT [[C4]](s16)
  ; CHECK-NEXT:   [[C9:%[0-9]+]]:_(s64) = G_CONSTANT i64 8
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C9]](s64)
  ; CHECK-NEXT:   [[ANYEXT3:%[0-9]+]]:_(s64) = G_ANYEXT [[ANYEXT2]](s32)
  ; CHECK-NEXT:   G_STORE [[ANYEXT3]](s64), [[PTR_ADD1]](p0) :: (store (s64) into stack + 8, align 1)
  ; CHECK-NEXT:   [[C10:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C10]](s64)
  ; CHECK-NEXT:   [[ANYEXT4:%[0-9]+]]:_(s64) = G_ANYEXT [[C5]](s32)
  ; CHECK-NEXT:   G_STORE [[ANYEXT4]](s64), [[PTR_ADD2]](p0) :: (store (s64) into stack + 16, align 1)
  ; CHECK-NEXT:   [[C11:%[0-9]+]]:_(s64) = G_CONSTANT i64 24
  ; CHECK-NEXT:   [[PTR_ADD3:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C11]](s64)
  ; CHECK-NEXT:   G_STORE [[C6]](s32), [[PTR_ADD3]](p0) :: (store (s32) into stack + 24, align 1)
  ; CHECK-NEXT:   [[C12:%[0-9]+]]:_(s64) = G_CONSTANT i64 32
  ; CHECK-NEXT:   [[PTR_ADD4:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C12]](s64)
  ; CHECK-NEXT:   G_STORE [[C7]](s64), [[PTR_ADD4]](p0) :: (store (s64) into stack + 32, align 1)
  ; CHECK-NEXT:   $w0 = COPY [[C]](s32)
  ; CHECK-NEXT:   $d0 = COPY [[C1]](s64)
  ; CHECK-NEXT:   $x1 = COPY [[C2]](s64)
  ; CHECK-NEXT:   BL @varargs, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $w0, implicit $d0, implicit $x1
  ; CHECK-NEXT:   ADJCALLSTACKUP 40, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   RET_ReallyLR
  call void(i32, double, i64, ...) @varargs(i32 42, double 1.0, i64 12, i8 3, i16 1, i32 4, float 1.0, double 2.0)
  ret void
}

declare i64 @i8i16callee(i64 %a1, i64 %a2, i64 %a3, i8 signext %a4, i16 signext %a5, i64 %a6, i64 %a7, i64 %a8, i8 signext %b1, i16 signext %b2, i8 signext %b3, i8 signext %b4) nounwind readnone noinline

define i32 @i8i16caller() nounwind readnone {
  ; CHECK-LABEL: name: i8i16caller
  ; CHECK: bb.1.entry:
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 1
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 2
  ; CHECK-NEXT:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK-NEXT:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 4
  ; CHECK-NEXT:   [[C5:%[0-9]+]]:_(s64) = G_CONSTANT i64 5
  ; CHECK-NEXT:   [[C6:%[0-9]+]]:_(s64) = G_CONSTANT i64 6
  ; CHECK-NEXT:   [[C7:%[0-9]+]]:_(s64) = G_CONSTANT i64 7
  ; CHECK-NEXT:   [[C8:%[0-9]+]]:_(s8) = G_CONSTANT i8 97
  ; CHECK-NEXT:   [[C9:%[0-9]+]]:_(s16) = G_CONSTANT i16 98
  ; CHECK-NEXT:   [[C10:%[0-9]+]]:_(s8) = G_CONSTANT i8 99
  ; CHECK-NEXT:   [[C11:%[0-9]+]]:_(s8) = G_CONSTANT i8 100
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 6, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK-NEXT:   [[C12:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C12]](s64)
  ; CHECK-NEXT:   G_STORE [[C8]](s8), [[PTR_ADD]](p0) :: (store (s8) into stack)
  ; CHECK-NEXT:   [[C13:%[0-9]+]]:_(s64) = G_CONSTANT i64 2
  ; CHECK-NEXT:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C13]](s64)
  ; CHECK-NEXT:   G_STORE [[C9]](s16), [[PTR_ADD1]](p0) :: (store (s16) into stack + 2, align 1)
  ; CHECK-NEXT:   [[C14:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK-NEXT:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C14]](s64)
  ; CHECK-NEXT:   G_STORE [[C10]](s8), [[PTR_ADD2]](p0) :: (store (s8) into stack + 4)
  ; CHECK-NEXT:   [[C15:%[0-9]+]]:_(s64) = G_CONSTANT i64 5
  ; CHECK-NEXT:   [[PTR_ADD3:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C15]](s64)
  ; CHECK-NEXT:   G_STORE [[C11]](s8), [[PTR_ADD3]](p0) :: (store (s8) into stack + 5)
  ; CHECK-NEXT:   $x0 = COPY [[C]](s64)
  ; CHECK-NEXT:   $x1 = COPY [[C1]](s64)
  ; CHECK-NEXT:   $x2 = COPY [[C2]](s64)
  ; CHECK-NEXT:   [[SEXT:%[0-9]+]]:_(s32) = G_SEXT [[C3]](s8)
  ; CHECK-NEXT:   $w3 = COPY [[SEXT]](s32)
  ; CHECK-NEXT:   [[SEXT1:%[0-9]+]]:_(s32) = G_SEXT [[C4]](s16)
  ; CHECK-NEXT:   $w4 = COPY [[SEXT1]](s32)
  ; CHECK-NEXT:   $x5 = COPY [[C5]](s64)
  ; CHECK-NEXT:   $x6 = COPY [[C6]](s64)
  ; CHECK-NEXT:   $x7 = COPY [[C7]](s64)
  ; CHECK-NEXT:   BL @i8i16callee, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0, implicit $x1, implicit $x2, implicit $w3, implicit $w4, implicit $x5, implicit $x6, implicit $x7, implicit-def $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   ADJCALLSTACKUP 6, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   [[TRUNC:%[0-9]+]]:_(s32) = G_TRUNC [[COPY1]](s64)
  ; CHECK-NEXT:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
entry:
  %call = tail call i64 @i8i16callee(i64 0, i64 1, i64 2, i8 signext 3, i16 signext 4, i64 5, i64 6, i64 7, i8 97, i16  98, i8  99, i8  100)
  %conv = trunc i64 %call to i32
  ret i32 %conv
}

