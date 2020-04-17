; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -verify-machineinstrs -stop-after=irtranslator -o - %s | FileCheck %s

@var = global i32 undef

define i32 @test() {
  ; CHECK-LABEL: name: test
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 -1
  ; CHECK:   [[INTTOPTR:%[0-9]+]]:_(p0) = G_INTTOPTR [[C]](s32)
  ; CHECK:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @var
  ; CHECK:   [[ICMP:%[0-9]+]]:_(s1) = G_ICMP intpred(eq), [[INTTOPTR]](p0), [[GV]]
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s32) = G_ZEXT [[ICMP]](s1)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY [[ZEXT]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY [[COPY1]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY [[COPY2]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:_(s32) = COPY [[COPY3]](s32)
  ; CHECK:   $vgpr0 = COPY [[COPY4]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0
  ret i32 bitcast (<1 x i32> <i32 extractelement (<1 x i32> bitcast (i32 zext (i1 icmp eq (i32* @var, i32* inttoptr (i32 -1 to i32*)) to i32) to <1 x i32>), i64 0)> to i32)
}
