; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -stop-after=irtranslator -global-isel -verify-machineinstrs %s -o - | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-apple-ios9.0"

declare void @varargs(i32, double, i64, ...)
define void @test_varargs() {
  ; CHECK-LABEL: name: test_varargs
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_FCONSTANT double 1.000000e+00
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 12
  ; CHECK:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK:   [[C5:%[0-9]+]]:_(s32) = G_CONSTANT i32 4
  ; CHECK:   [[C6:%[0-9]+]]:_(s32) = G_FCONSTANT float 1.000000e+00
  ; CHECK:   [[C7:%[0-9]+]]:_(s64) = G_FCONSTANT double 2.000000e+00
  ; CHECK:   ADJCALLSTACKDOWN 40, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $w0 = COPY [[C]](s32)
  ; CHECK:   $d0 = COPY [[C1]](s64)
  ; CHECK:   $x1 = COPY [[C2]](s64)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[C3]](s8)
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK:   [[C8:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C8]](s64)
  ; CHECK:   [[ANYEXT1:%[0-9]+]]:_(s64) = G_ANYEXT [[ANYEXT]](s32)
  ; CHECK:   G_STORE [[ANYEXT1]](s64), [[PTR_ADD]](p0) :: (store 8 into stack, align 1)
  ; CHECK:   [[ANYEXT2:%[0-9]+]]:_(s32) = G_ANYEXT [[C4]](s16)
  ; CHECK:   [[C9:%[0-9]+]]:_(s64) = G_CONSTANT i64 8
  ; CHECK:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C9]](s64)
  ; CHECK:   [[ANYEXT3:%[0-9]+]]:_(s64) = G_ANYEXT [[ANYEXT2]](s32)
  ; CHECK:   G_STORE [[ANYEXT3]](s64), [[PTR_ADD1]](p0) :: (store 8 into stack + 8, align 1)
  ; CHECK:   [[C10:%[0-9]+]]:_(s64) = G_CONSTANT i64 16
  ; CHECK:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C10]](s64)
  ; CHECK:   [[ANYEXT4:%[0-9]+]]:_(s64) = G_ANYEXT [[C5]](s32)
  ; CHECK:   G_STORE [[ANYEXT4]](s64), [[PTR_ADD2]](p0) :: (store 8 into stack + 16, align 1)
  ; CHECK:   [[C11:%[0-9]+]]:_(s64) = G_CONSTANT i64 24
  ; CHECK:   [[PTR_ADD3:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C11]](s64)
  ; CHECK:   G_STORE [[C6]](s32), [[PTR_ADD3]](p0) :: (store 4 into stack + 24, align 1)
  ; CHECK:   [[C12:%[0-9]+]]:_(s64) = G_CONSTANT i64 32
  ; CHECK:   [[PTR_ADD4:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C12]](s64)
  ; CHECK:   G_STORE [[C7]](s64), [[PTR_ADD4]](p0) :: (store 8 into stack + 32, align 1)
  ; CHECK:   BL @varargs, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $w0, implicit $d0, implicit $x1
  ; CHECK:   ADJCALLSTACKUP 40, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  call void(i32, double, i64, ...) @varargs(i32 42, double 1.0, i64 12, i8 3, i16 1, i32 4, float 1.0, double 2.0)
  ret void
}

declare i64 @i8i16callee(i64 %a1, i64 %a2, i64 %a3, i8 signext %a4, i16 signext %a5, i64 %a6, i64 %a7, i64 %a8, i8 signext %b1, i16 signext %b2, i8 signext %b3, i8 signext %b4) nounwind readnone noinline

define i32 @i8i16caller() nounwind readnone {
  ; CHECK-LABEL: name: i8i16caller
  ; CHECK: bb.1.entry:
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 1
  ; CHECK:   [[C2:%[0-9]+]]:_(s64) = G_CONSTANT i64 2
  ; CHECK:   [[C3:%[0-9]+]]:_(s8) = G_CONSTANT i8 3
  ; CHECK:   [[C4:%[0-9]+]]:_(s16) = G_CONSTANT i16 4
  ; CHECK:   [[C5:%[0-9]+]]:_(s64) = G_CONSTANT i64 5
  ; CHECK:   [[C6:%[0-9]+]]:_(s64) = G_CONSTANT i64 6
  ; CHECK:   [[C7:%[0-9]+]]:_(s64) = G_CONSTANT i64 7
  ; CHECK:   [[C8:%[0-9]+]]:_(s8) = G_CONSTANT i8 97
  ; CHECK:   [[C9:%[0-9]+]]:_(s16) = G_CONSTANT i16 98
  ; CHECK:   [[C10:%[0-9]+]]:_(s8) = G_CONSTANT i8 99
  ; CHECK:   [[C11:%[0-9]+]]:_(s8) = G_CONSTANT i8 100
  ; CHECK:   ADJCALLSTACKDOWN 6, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $x0 = COPY [[C]](s64)
  ; CHECK:   $x1 = COPY [[C1]](s64)
  ; CHECK:   $x2 = COPY [[C2]](s64)
  ; CHECK:   [[SEXT:%[0-9]+]]:_(s32) = G_SEXT [[C3]](s8)
  ; CHECK:   $w3 = COPY [[SEXT]](s32)
  ; CHECK:   [[SEXT1:%[0-9]+]]:_(s32) = G_SEXT [[C4]](s16)
  ; CHECK:   $w4 = COPY [[SEXT1]](s32)
  ; CHECK:   $x5 = COPY [[C5]](s64)
  ; CHECK:   $x6 = COPY [[C6]](s64)
  ; CHECK:   $x7 = COPY [[C7]](s64)
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $sp
  ; CHECK:   [[C12:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C12]](s64)
  ; CHECK:   G_STORE [[C8]](s8), [[PTR_ADD]](p0) :: (store 1 into stack)
  ; CHECK:   [[C13:%[0-9]+]]:_(s64) = G_CONSTANT i64 2
  ; CHECK:   [[PTR_ADD1:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C13]](s64)
  ; CHECK:   G_STORE [[C9]](s16), [[PTR_ADD1]](p0) :: (store 2 into stack + 2, align 1)
  ; CHECK:   [[C14:%[0-9]+]]:_(s64) = G_CONSTANT i64 4
  ; CHECK:   [[PTR_ADD2:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C14]](s64)
  ; CHECK:   G_STORE [[C10]](s8), [[PTR_ADD2]](p0) :: (store 1 into stack + 4)
  ; CHECK:   [[C15:%[0-9]+]]:_(s64) = G_CONSTANT i64 5
  ; CHECK:   [[PTR_ADD3:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY]], [[C15]](s64)
  ; CHECK:   G_STORE [[C11]](s8), [[PTR_ADD3]](p0) :: (store 1 into stack + 5)
  ; CHECK:   BL @i8i16callee, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $x0, implicit $x1, implicit $x2, implicit $w3, implicit $w4, implicit $x5, implicit $x6, implicit $x7, implicit-def $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK:   ADJCALLSTACKUP 6, 0, implicit-def $sp, implicit $sp
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s32) = G_TRUNC [[COPY1]](s64)
  ; CHECK:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %call = tail call i64 @i8i16callee(i64 0, i64 1, i64 2, i8 signext 3, i16 signext 4, i64 5, i64 6, i64 7, i8 97, i16  98, i8  99, i8  100)
  %conv = trunc i64 %call to i32
  ret i32 %conv
}

