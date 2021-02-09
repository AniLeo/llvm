; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -stop-after=legalizer -o - %s | FileCheck %s

; Make sure legalizer info doesn't assert on dummy targets

define i16 @vop3p_add_i16(i16 %arg0) #0 {
  ; CHECK-LABEL: name: vop3p_add_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY]](s32)
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[ADD:%[0-9]+]]:_(s16) = G_ADD [[TRUNC]], [[TRUNC]]
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[ADD]](s16)
  ; CHECK:   $vgpr0 = COPY [[ANYEXT]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %add = add i16 %arg0, %arg0
  ret i16 %add
}

define <2 x i16> @vop3p_add_v2i16(<2 x i16> %arg0) #0 {
  ; CHECK-LABEL: name: vop3p_add_v2i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY]](<2 x s16>)
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[BITCAST]](s32)
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; CHECK:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; CHECK:   [[TRUNC1:%[0-9]+]]:_(s16) = G_TRUNC [[LSHR]](s32)
  ; CHECK:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY]](<2 x s16>)
  ; CHECK:   [[TRUNC2:%[0-9]+]]:_(s16) = G_TRUNC [[BITCAST1]](s32)
  ; CHECK:   [[LSHR1:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST1]], [[C]](s32)
  ; CHECK:   [[TRUNC3:%[0-9]+]]:_(s16) = G_TRUNC [[LSHR1]](s32)
  ; CHECK:   [[ADD:%[0-9]+]]:_(s16) = G_ADD [[TRUNC]], [[TRUNC2]]
  ; CHECK:   [[ADD1:%[0-9]+]]:_(s16) = G_ADD [[TRUNC1]], [[TRUNC3]]
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s32) = G_ZEXT [[ADD]](s16)
  ; CHECK:   [[ZEXT1:%[0-9]+]]:_(s32) = G_ZEXT [[ADD1]](s16)
  ; CHECK:   [[SHL:%[0-9]+]]:_(s32) = G_SHL [[ZEXT1]], [[C]](s32)
  ; CHECK:   [[OR:%[0-9]+]]:_(s32) = G_OR [[ZEXT]], [[SHL]]
  ; CHECK:   [[BITCAST2:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR]](s32)
  ; CHECK:   $vgpr0 = COPY [[BITCAST2]](<2 x s16>)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %add = add <2 x i16> %arg0, %arg0
  ret <2 x i16> %add
}

define i16 @halfinsts_add_i16(i16 %arg0) #1 {
  ; CHECK-LABEL: name: halfinsts_add_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY [[COPY]](s32)
  ; CHECK:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY2]], [[COPY2]]
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY [[ADD]](s32)
  ; CHECK:   $vgpr0 = COPY [[COPY3]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
  %add = add i16 %arg0, %arg0
  ret i16 %add
}

define <2 x i16> @halfinsts_add_v2i16(<2 x i16> %arg0) #1 {
  ; CHECK-LABEL: name: halfinsts_add_v2i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY]](<2 x s16>)
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; CHECK:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; CHECK:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY]](<2 x s16>)
  ; CHECK:   [[LSHR1:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST1]], [[C]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY [[BITCAST]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY [[BITCAST1]](s32)
  ; CHECK:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY2]], [[COPY3]]
  ; CHECK:   [[COPY4:%[0-9]+]]:_(s32) = COPY [[LSHR]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:_(s32) = COPY [[LSHR1]](s32)
  ; CHECK:   [[ADD1:%[0-9]+]]:_(s32) = G_ADD [[COPY4]], [[COPY5]]
  ; CHECK:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 65535
  ; CHECK:   [[COPY6:%[0-9]+]]:_(s32) = COPY [[ADD]](s32)
  ; CHECK:   [[AND:%[0-9]+]]:_(s32) = G_AND [[COPY6]], [[C1]]
  ; CHECK:   [[COPY7:%[0-9]+]]:_(s32) = COPY [[ADD1]](s32)
  ; CHECK:   [[AND1:%[0-9]+]]:_(s32) = G_AND [[COPY7]], [[C1]]
  ; CHECK:   [[SHL:%[0-9]+]]:_(s32) = G_SHL [[AND1]], [[C]](s32)
  ; CHECK:   [[OR:%[0-9]+]]:_(s32) = G_OR [[AND]], [[SHL]]
  ; CHECK:   [[BITCAST2:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR]](s32)
  ; CHECK:   $vgpr0 = COPY [[BITCAST2]](<2 x s16>)
  ; CHECK:   [[COPY8:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY8]], implicit $vgpr0
  %add = add <2 x i16> %arg0, %arg0
  ret <2 x i16> %add
}

attributes #0 = { "target-features"="+vop3p" }
attributes #0 = { "target-features"="+16-bit-insts" }
