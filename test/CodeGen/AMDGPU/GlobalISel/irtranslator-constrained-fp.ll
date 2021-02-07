; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -march=amdgcn -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s

define float @v_constained_fadd_f32_fpexcept_strict(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_f32_fpexcept_strict
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FADD:%[0-9]+]]:_(s32) = G_STRICT_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[STRICT_FADD]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fadd_f32_fpexcept_strict_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_f32_fpexcept_strict_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FADD:%[0-9]+]]:_(s32) = nsz G_STRICT_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[STRICT_FADD]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fadd_f32_fpexcept_ignore(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_f32_fpexcept_ignore
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nofpexcept G_STRICT_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fadd_f32_fpexcept_ignore_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nsz nofpexcept G_STRICT_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fadd_f32_fpexcept_maytrap(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_f32_fpexcept_maytrap
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FADD:%[0-9]+]]:_(s32) = G_STRICT_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY [[STRICT_FADD]](s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call float @llvm.experimental.constrained.fadd.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret float %val
}

define <2 x float> @v_constained_fadd_v2f32_fpexcept_strict(<2 x float> %x, <2 x float> %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_v2f32_fpexcept_strict
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FADD:%[0-9]+]]:_(<2 x s32>) = G_STRICT_FADD [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[STRICT_FADD]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %val
}

define <2 x float> @v_constained_fadd_v2f32_fpexcept_ignore(<2 x float> %x, <2 x float> %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_v2f32_fpexcept_ignore
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %7:_(<2 x s32>) = nofpexcept G_STRICT_FADD [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES %7(<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret <2 x float> %val
}

define <2 x float> @v_constained_fadd_v2f32_fpexcept_maytrap(<2 x float> %x, <2 x float> %y) #0 {
  ; CHECK-LABEL: name: v_constained_fadd_v2f32_fpexcept_maytrap
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:_(s32) = COPY $vgpr3
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY2]](s32), [[COPY3]](s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FADD:%[0-9]+]]:_(<2 x s32>) = G_STRICT_FADD [[BUILD_VECTOR]], [[BUILD_VECTOR1]]
  ; CHECK:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[STRICT_FADD]](<2 x s32>)
  ; CHECK:   $vgpr0 = COPY [[UV]](s32)
  ; CHECK:   $vgpr1 = COPY [[UV1]](s32)
  ; CHECK:   [[COPY5:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY4]]
  ; CHECK:   S_SETPC_B64_return [[COPY5]], implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret <2 x float> %val
}

define float @v_constained_fsub_f32_fpexcept_ignore_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fsub_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nsz nofpexcept G_STRICT_FSUB [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fmul_f32_fpexcept_ignore_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fmul_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nsz nofpexcept G_STRICT_FMUL [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fmul.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fdiv_f32_fpexcept_ignore_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_fdiv_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nsz nofpexcept G_STRICT_FDIV [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fdiv.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_frem_f32_fpexcept_ignore_flags(float %x, float %y) #0 {
  ; CHECK-LABEL: name: v_constained_frem_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %3:_(s32) = nsz nofpexcept G_STRICT_FREM [[COPY]], [[COPY1]]
  ; CHECK:   $vgpr0 = COPY %3(s32)
  ; CHECK:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY2]]
  ; CHECK:   S_SETPC_B64_return [[COPY3]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.frem.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fma_f32_fpexcept_ignore_flags(float %x, float %y, float %z) #0 {
  ; CHECK-LABEL: name: v_constained_fma_f32_fpexcept_ignore_flags
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   %4:_(s32) = nsz nofpexcept G_STRICT_FMA [[COPY]], [[COPY1]], [[COPY2]]
  ; CHECK:   $vgpr0 = COPY %4(s32)
  ; CHECK:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; CHECK:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
  %val = call nsz float @llvm.experimental.constrained.fma.f32(float %x, float %y, float %z, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_sqrt_f32_fpexcept_strict(float %x) #0 {
  ; CHECK-LABEL: name: v_constained_sqrt_f32_fpexcept_strict
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $vgpr0, $sgpr30_sgpr31
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr_64 = COPY $sgpr30_sgpr31
  ; CHECK:   [[STRICT_FSQRT:%[0-9]+]]:_(s32) = G_STRICT_FSQRT [[COPY]]
  ; CHECK:   $vgpr0 = COPY [[STRICT_FSQRT]](s32)
  ; CHECK:   [[COPY2:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY1]]
  ; CHECK:   S_SETPC_B64_return [[COPY2]], implicit $vgpr0
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %x, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

declare float @llvm.experimental.constrained.fadd.f32(float, float, metadata, metadata) #1
declare <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float>, <2 x float>, metadata, metadata) #1
declare <3 x float> @llvm.experimental.constrained.fadd.v3f32(<3 x float>, <3 x float>, metadata, metadata) #1
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata) #1
declare float @llvm.experimental.constrained.fmul.f32(float, float, metadata, metadata) #1
declare float @llvm.experimental.constrained.fdiv.f32(float, float, metadata, metadata) #1
declare float @llvm.experimental.constrained.frem.f32(float, float, metadata, metadata) #1
declare float @llvm.experimental.constrained.fma.f32(float, float, float, metadata, metadata) #1
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata) #1

attributes #0 = { strictfp }
attributes #1 = { inaccessiblememonly nounwind willreturn }
