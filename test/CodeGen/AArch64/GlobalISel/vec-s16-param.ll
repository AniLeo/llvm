; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -O0 -stop-after=irtranslator -verify-machineinstrs -o - %s | FileCheck %s

define <2 x half> @f16_vec_param(<2 x half> %v) {
  ; CHECK-LABEL: name: f16_vec_param
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<4 x s16>) = COPY $d0
  ; CHECK:   [[UV:%[0-9]+]]:_(<2 x s16>), [[UV1:%[0-9]+]]:_(<2 x s16>) = G_UNMERGE_VALUES [[COPY]](<4 x s16>)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(<2 x s16>) = COPY [[UV]](<2 x s16>)
  ; CHECK:   [[DEF:%[0-9]+]]:_(<2 x s16>) = G_IMPLICIT_DEF
  ; CHECK:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY1]](<2 x s16>), [[DEF]](<2 x s16>)
  ; CHECK:   $d0 = COPY [[CONCAT_VECTORS]](<4 x s16>)
  ; CHECK:   RET_ReallyLR implicit $d0
  ret <2 x half> %v
}

define <2 x i16> @i16_vec_param(<2 x i16> %v) {
  ; CHECK-LABEL: name: i16_vec_param
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s32>) = COPY $d0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(<2 x s16>) = G_TRUNC [[COPY]](<2 x s32>)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(<2 x s32>) = G_ANYEXT [[TRUNC]](<2 x s16>)
  ; CHECK:   $d0 = COPY [[ANYEXT]](<2 x s32>)
  ; CHECK:   RET_ReallyLR implicit $d0
  ret <2 x i16> %v
}
