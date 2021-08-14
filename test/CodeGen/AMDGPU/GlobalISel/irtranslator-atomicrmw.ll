; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=fiji -O0 -stop-after=irtranslator -o - %s | FileCheck %s

define float @test_atomicrmw_fadd(float addrspace(3)* %addr) {
  ; CHECK-LABEL: name: test_atomicrmw_fadd
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_FCONSTANT float 1.000000e+00
  ; CHECK-NEXT:   [[ATOMICRMW_FADD:%[0-9]+]]:_(s32) = G_ATOMICRMW_FADD [[COPY]](p3), [[C]] :: (load store seq_cst (s32) on %ir.addr, addrspace 3)
  ; CHECK-NEXT:   $vgpr0 = COPY [[ATOMICRMW_FADD]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %oldval = atomicrmw fadd float addrspace(3)* %addr, float 1.0 seq_cst
  ret float %oldval
}

define float @test_atomicrmw_fsub(float addrspace(3)* %addr) {
  ; CHECK-LABEL: name: test_atomicrmw_fsub
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x80000000)
  ; CHECK-NEXT:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p3) = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_FCONSTANT float 1.000000e+00
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY]](p3) :: (load (s32) from %ir.addr, addrspace 3)
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.atomicrmw.start:
  ; CHECK-NEXT:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[PHI:%[0-9]+]]:_(s64) = G_PHI %16(s64), %bb.2, [[C1]](s64), %bb.1
  ; CHECK-NEXT:   [[PHI1:%[0-9]+]]:_(s32) = G_PHI [[LOAD]](s32), %bb.1, %14(s32), %bb.2
  ; CHECK-NEXT:   [[FSUB:%[0-9]+]]:_(s32) = G_FSUB [[PHI1]], [[C]]
  ; CHECK-NEXT:   [[ATOMIC_CMPXCHG_WITH_SUCCESS:%[0-9]+]]:_(s32), [[ATOMIC_CMPXCHG_WITH_SUCCESS1:%[0-9]+]]:_(s1) = G_ATOMIC_CMPXCHG_WITH_SUCCESS [[COPY]](p3), [[PHI1]], [[FSUB]] :: (load store seq_cst seq_cst (s32) on %ir.2, addrspace 3)
  ; CHECK-NEXT:   [[INT:%[0-9]+]]:_(s64) = G_INTRINSIC intrinsic(@llvm.amdgcn.if.break), [[ATOMIC_CMPXCHG_WITH_SUCCESS1]](s1), [[PHI]](s64)
  ; CHECK-NEXT:   [[INT1:%[0-9]+]]:_(s1) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.loop), [[INT]](s64)
  ; CHECK-NEXT:   G_BRCOND [[INT1]](s1), %bb.3
  ; CHECK-NEXT:   G_BR %bb.2
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.atomicrmw.end:
  ; CHECK-NEXT:   [[PHI2:%[0-9]+]]:_(s32) = G_PHI [[ATOMIC_CMPXCHG_WITH_SUCCESS]](s32), %bb.2
  ; CHECK-NEXT:   [[PHI3:%[0-9]+]]:_(s64) = G_PHI [[INT]](s64), %bb.2
  ; CHECK-NEXT:   G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.end.cf), [[PHI3]](s64)
  ; CHECK-NEXT:   $vgpr0 = COPY [[PHI2]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %oldval = atomicrmw fsub float addrspace(3)* %addr, float 1.0 seq_cst
  ret float %oldval
}
