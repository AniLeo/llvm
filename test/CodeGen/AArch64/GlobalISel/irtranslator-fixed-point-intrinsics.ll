; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -stop-after=irtranslator -mtriple=aarch64-- -verify-machineinstrs -o - %s | FileCheck %s

define i16 @smul_fix(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: smul_fix
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[SMULFIX:%[0-9]+]]:_(s16) = G_SMULFIX [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SMULFIX]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.smul.fix.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @umul_fix(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: umul_fix
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[UMULFIX:%[0-9]+]]:_(s16) = G_UMULFIX [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UMULFIX]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.umul.fix.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @smul_fix_sat(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: smul_fix_sat
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[SMULFIXSAT:%[0-9]+]]:_(s16) = G_SMULFIXSAT [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SMULFIXSAT]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.smul.fix.sat.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @umul_fix_sat(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: umul_fix_sat
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[UMULFIXSAT:%[0-9]+]]:_(s16) = G_UMULFIXSAT [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UMULFIXSAT]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.umul.fix.sat.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @sdiv_fix(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: sdiv_fix
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[SDIVFIX:%[0-9]+]]:_(s16) = G_SDIVFIX [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SDIVFIX]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.sdiv.fix.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @udiv_fix(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: udiv_fix
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[UDIVFIX:%[0-9]+]]:_(s16) = G_UDIVFIX [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UDIVFIX]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.udiv.fix.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @sdiv_fix_sat(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: sdiv_fix_sat
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[SDIVFIXSAT:%[0-9]+]]:_(s16) = G_SDIVFIXSAT [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[SDIVFIXSAT]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.sdiv.fix.sat.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

define i16 @udiv_fix_sat(i16 %arg0, i16 %arg1) {
  ; CHECK-LABEL: name: udiv_fix_sat
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $w0, $w1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $w1
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[UDIVFIXSAT:%[0-9]+]]:_(s16) = G_UDIVFIXSAT [[TRUNC]], [[TRUNC1]], 7
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[UDIVFIXSAT]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %res = call i16 @llvm.udiv.fix.sat.i16(i16 %arg0, i16 %arg1, i32 7)
  ret i16 %res
}

declare i16 @llvm.smul.fix.i16(i16, i16, i32 immarg) #0
declare i16 @llvm.umul.fix.i16(i16, i16, i32 immarg) #0
declare i16 @llvm.smul.fix.sat.i16(i16, i16, i32 immarg) #0
declare i16 @llvm.umul.fix.sat.i16(i16, i16, i32 immarg) #0
declare i16 @llvm.sdiv.fix.i16(i16, i16, i32 immarg) #1
declare i16 @llvm.udiv.fix.i16(i16, i16, i32 immarg) #1
declare i16 @llvm.sdiv.fix.sat.i16(i16, i16, i32 immarg) #1
declare i16 @llvm.udiv.fix.sat.i16(i16, i16, i32 immarg) #1

attributes #0 = { nounwind readnone speculatable willreturn }
attributes #1 = { nounwind readnone }
