; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -verify-machineinstrs -stop-after=irtranslator < %s | FileCheck %s

define i8* @ptrmask_flat_i64(i8* %ptr, i64 %mask) {
  ; CHECK-LABEL: name: ptrmask_flat_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(p0) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[MV1:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p0) = G_PTRMASK [[MV]], [[MV1]](s64)
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[PTRMASK]](p0)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %masked = call i8* @llvm.ptrmask.p0i8.i64(i8* %ptr, i64 %mask)
  ret i8* %masked
}

define i8* @ptrmask_flat_i32(i8* %ptr, i32 %mask) {
  ; CHECK-LABEL: name: ptrmask_flat_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(p0) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p0) = G_PTRMASK [[MV]], [[COPY2]](s32)
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[PTRMASK]](p0)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0, implicit $vgpr1
  %masked = call i8* @llvm.ptrmask.p0i8.i32(i8* %ptr, i32 %mask)
  ret i8* %masked
}

define i8* @ptrmask_flat_i16(i8* %ptr, i16 %mask) {
  ; CHECK-LABEL: name: ptrmask_flat_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY2]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(p0) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p0) = G_PTRMASK [[MV]], [[TRUNC]](s16)
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[PTRMASK]](p0)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0, implicit $vgpr1
  %masked = call i8* @llvm.ptrmask.p0i8.i16(i8* %ptr, i16 %mask)
  ret i8* %masked
}

define i8* @ptrmask_flat_i1(i8* %ptr, i1 %mask) {
  ; CHECK-LABEL: name: ptrmask_flat_i1
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s1) = G_TRUNC [[COPY2]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(p0) = G_MERGE_VALUES [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p0) = G_PTRMASK [[MV]], [[TRUNC]](s1)
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[PTRMASK]](p0)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0, implicit $vgpr1
  %masked = call i8* @llvm.ptrmask.p0i8.i1(i8* %ptr, i1 %mask)
  ret i8* %masked
}

define i8 addrspace(3)* @ptrmask_local_i64(i8 addrspace(3)* %ptr, i64 %mask) {
  ; CHECK-LABEL: name: ptrmask_local_i64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[MV:%[0-9]+]]:_(s64) = G_MERGE_VALUES [[COPY1]](s32), [[COPY2]](s32)
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p3) = G_PTRMASK [[COPY]], [[MV]](s64)
  ; CHECK:   $vgpr0 = COPY [[PTRMASK]](p3)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i64(i8 addrspace(3)* %ptr, i64 %mask)
  ret i8 addrspace(3)* %masked
}

define i8 addrspace(3)* @ptrmask_local_i32(i8 addrspace(3)* %ptr, i32 %mask) {
  ; CHECK-LABEL: name: ptrmask_local_i32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p3) = G_PTRMASK [[COPY]], [[COPY1]](s32)
  ; CHECK:   $vgpr0 = COPY [[PTRMASK]](p3)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i32(i8 addrspace(3)* %ptr, i32 %mask)
  ret i8 addrspace(3)* %masked
}

define i8 addrspace(3)* @ptrmask_local_i16(i8 addrspace(3)* %ptr, i16 %mask) {
  ; CHECK-LABEL: name: ptrmask_local_i16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p3) = G_PTRMASK [[COPY]], [[TRUNC]](s16)
  ; CHECK:   $vgpr0 = COPY [[PTRMASK]](p3)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i16(i8 addrspace(3)* %ptr, i16 %mask)
  ret i8 addrspace(3)* %masked
}

define i8 addrspace(3)* @ptrmask_local_i1(i8 addrspace(3)* %ptr, i1 %mask) {
  ; CHECK-LABEL: name: ptrmask_local_i1
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s1) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[PTRMASK:%[0-9]+]]:_(p3) = G_PTRMASK [[COPY]], [[TRUNC]](s1)
  ; CHECK:   $vgpr0 = COPY [[PTRMASK]](p3)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %masked = call i8 addrspace(3)* @llvm.ptrmask.p3i8.i1(i8 addrspace(3)* %ptr, i1 %mask)
  ret i8 addrspace(3)* %masked
}

; Seems to not work
; define <2 x i8*> @ptrmask_flat_i64_v2(<2 x i8*> %ptr, <2 x i64> %mask) {
;   %masked = call <2 x i8*> @llvm.ptrmask.v2p0i8.v2i64(<2 x i8*> %ptr, <2 x i64> %mask)
;   ret <2 x i8*> %masked
; }

declare i8* @llvm.ptrmask.p0i8.i64(i8*, i64)
declare i8* @llvm.ptrmask.p0i8.i32(i8*, i32)
declare i8* @llvm.ptrmask.p0i8.i16(i8*, i16)
declare i8* @llvm.ptrmask.p0i8.i1(i8*, i1)
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i64(i8 addrspace(3)*, i64)
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i32(i8 addrspace(3)*, i32)
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i16(i8 addrspace(3)*, i16)
declare i8 addrspace(3)* @llvm.ptrmask.p3i8.i1(i8 addrspace(3)*, i1)
