; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -o - -stop-after=irtranslator %s | FileCheck %s

; Check that the CSEMIRBuilder doesn't fold away the getelementptr during IRTranslator
define i8 addrspace(7)* @no_auto_constfold_gep() {
  ; CHECK-LABEL: name: no_auto_constfold_gep
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(p7) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 123
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p7) = G_PTR_ADD [[C]], [[C1]](s64)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[PTR_ADD]](p7)
  ; CHECK-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY1]], implicit $vgpr0, implicit $vgpr1
  %gep = getelementptr i8, i8 addrspace(7)* null, i64 123
  ret i8 addrspace(7)* %gep
}

; Check that the CSEMIRBuilder doesn't fold away the getelementptr during IRTranslator
define <2 x i8 addrspace(7)*> @no_auto_constfold_gep_vector() {
  ; CHECK-LABEL: name: no_auto_constfold_gep_vector
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr30_sgpr31
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(p7) = G_CONSTANT i64 0
  ; CHECK-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x p7>) = G_BUILD_VECTOR [[C]](p7), [[C]](p7)
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s64) = G_CONSTANT i64 123
  ; CHECK-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s64>) = G_BUILD_VECTOR [[C1]](s64), [[C1]](s64)
  ; CHECK-NEXT:   [[PTR_ADD:%[0-9]+]]:_(<2 x p7>) = G_PTR_ADD [[BUILD_VECTOR]], [[BUILD_VECTOR1]](<2 x s64>)
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(<2 x p7>) = COPY [[PTR_ADD]](<2 x p7>)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32), [[UV3:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[COPY1]](<2 x p7>)
  ; CHECK-NEXT:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   $vgpr2 = COPY [[UV2]](s32)
  ; CHECK-NEXT:   $vgpr3 = COPY [[UV3]](s32)
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; CHECK-NEXT:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3
  %gep = getelementptr i8, <2 x i8 addrspace(7)*> zeroinitializer, <2 x i64> <i64 123, i64 123>
  ret <2 x i8 addrspace(7)*> %gep
}
