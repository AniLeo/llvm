; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -O0 -stop-after=irtranslator -global-isel -verify-machineinstrs %s -o - 2>&1 | FileCheck %s

define i8 @v1s8_add(<1 x i8> %a0) {
  ; CHECK-LABEL: name: v1s8_add
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<8 x s8>) = COPY $d0
  ; CHECK:   [[UV:%[0-9]+]]:_(s8), [[UV1:%[0-9]+]]:_(s8), [[UV2:%[0-9]+]]:_(s8), [[UV3:%[0-9]+]]:_(s8), [[UV4:%[0-9]+]]:_(s8), [[UV5:%[0-9]+]]:_(s8), [[UV6:%[0-9]+]]:_(s8), [[UV7:%[0-9]+]]:_(s8) = G_UNMERGE_VALUES [[COPY]](<8 x s8>)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UV]](s8)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = bitcast <1 x i8> %a0 to i8
  ret i8 %res
}

define i24 @test_v3i8(<3 x i8> %a) {
  ; CHECK-LABEL: name: test_v3i8
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1, $w2
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $w2
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<3 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32)
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(<3 x s8>) = G_TRUNC [[BUILD_VECTOR]](<3 x s32>)
  ; CHECK:   [[BITCAST:%[0-9]+]]:_(s24) = G_BITCAST [[TRUNC]](<3 x s8>)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[BITCAST]](s24)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = bitcast <3 x i8> %a to i24
  ret i24 %res
}


define <1 x half> @test_v1s16(<1 x float> %x) {
  ; CHECK-LABEL: name: test_v1s16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $d0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s32>) = COPY $d0
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[COPY]](<2 x s32>)
  ; CHECK:   [[FPTRUNC:%[0-9]+]]:_(s16) = G_FPTRUNC [[UV]](s32)
  ; CHECK:   $h0 = COPY [[FPTRUNC]](s16)
  ; CHECK:   RET_ReallyLR implicit $h0
  %tmp = fptrunc <1 x float> %x to <1 x half>
  ret <1 x half> %tmp
}

declare <3 x float> @bar(float)
define void @test_return_v3f32() {
  ; CHECK-LABEL: name: test_return_v3f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; CHECK:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   $s0 = COPY [[DEF]](s32)
  ; CHECK:   BL @bar, csr_aarch64_aapcs, implicit-def $lr, implicit $sp, implicit $s0, implicit-def $q0
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s64>) = COPY $q0
  ; CHECK:   [[BITCAST:%[0-9]+]]:_(<4 x s32>) = G_BITCAST [[COPY]](<2 x s64>)
  ; CHECK:   [[DEF1:%[0-9]+]]:_(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[CONCAT_VECTORS:%[0-9]+]]:_(<12 x s32>) = G_CONCAT_VECTORS [[BITCAST]](<4 x s32>), [[DEF1]](<4 x s32>), [[DEF1]](<4 x s32>)
  ; CHECK:   [[UV:%[0-9]+]]:_(<3 x s32>), [[UV1:%[0-9]+]]:_(<3 x s32>), [[UV2:%[0-9]+]]:_(<3 x s32>), [[UV3:%[0-9]+]]:_(<3 x s32>) = G_UNMERGE_VALUES [[CONCAT_VECTORS]](<12 x s32>)
  ; CHECK:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK:   RET_ReallyLR
  %call = call <3 x float> @bar(float undef)
  ret void
}
