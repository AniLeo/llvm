; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=aarch64-unknown-unknown -stop-after=irtranslator -verify-machineinstrs -o - %s | FileCheck %s
declare i1 @llvm.isnan.f16(half)
declare <4 x i1> @llvm.isnan.v4f16(<4 x half>)

define i1 @s16(half %x) {
  ; CHECK-LABEL: name: s16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $h0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s16) = COPY $h0
  ; CHECK:   %1:_(s1) = nofpexcept G_ISNAN [[COPY]](s16)
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s8) = G_ZEXT %1(s1)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[ZEXT]](s8)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %isnan = tail call i1 @llvm.isnan.f16(half %x)
  ret i1 %isnan
}

define <4 x i1> @v4s16(<4 x half> %x) {
  ; CHECK-LABEL: name: v4s16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<4 x s16>) = COPY $d0
  ; CHECK:   %1:_(<4 x s1>) = nofpexcept G_ISNAN [[COPY]](<4 x s16>)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(<4 x s16>) = G_ANYEXT %1(<4 x s1>)
  ; CHECK:   $d0 = COPY [[ANYEXT]](<4 x s16>)
  ; CHECK:   RET_ReallyLR implicit $d0
  %isnan = tail call <4 x i1> @llvm.isnan.v4f16(<4 x half> %x)
  ret <4 x i1> %isnan
}

define i1 @strictfp(half %x) strictfp {
  ; CHECK-LABEL: name: strictfp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $h0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s16) = COPY $h0
  ; CHECK:   [[ISNAN:%[0-9]+]]:_(s1) = G_ISNAN [[COPY]](s16)
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s8) = G_ZEXT [[ISNAN]](s1)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[ZEXT]](s8)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %isnan = tail call i1 @llvm.isnan.f16(half %x)
  ret i1 %isnan
}
