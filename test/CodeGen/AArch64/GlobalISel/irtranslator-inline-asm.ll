; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64-darwin-ios13 -O0 -global-isel -stop-after=irtranslator -verify-machineinstrs -o - %s | FileCheck %s

define void @asm_simple_memory_clobber() {
  ; CHECK-LABEL: name: asm_simple_memory_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"", 25 /* sideeffect mayload maystore attdialect */, !0
  ; CHECK:   INLINEASM &"", 1 /* sideeffect attdialect */, !0
  ; CHECK:   RET_ReallyLR
  call void asm sideeffect "", "~{memory}"(), !srcloc !0
  call void asm sideeffect "", ""(), !srcloc !0
  ret void
}

!0 = !{i32 70}

define void @asm_simple_register_clobber() {
  ; CHECK-LABEL: name: asm_simple_register_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"mov x0, 7", 1 /* sideeffect attdialect */, 12 /* clobber */, implicit-def early-clobber $x0, !0
  ; CHECK:   RET_ReallyLR
  call void asm sideeffect "mov x0, 7", "~{x0}"(), !srcloc !0
  ret void
}

define i64 @asm_register_early_clobber() {
  ; CHECK-LABEL: name: asm_register_early_clobber
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"mov $0, 7; mov $1, 7", 1 /* sideeffect attdialect */, 1441803 /* regdef-ec:GPR64common */, def early-clobber %0, 1441803 /* regdef-ec:GPR64common */, def early-clobber %1, !0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY %0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY %1
  ; CHECK:   [[ADD:%[0-9]+]]:_(s64) = G_ADD [[COPY]], [[COPY1]]
  ; CHECK:   $x0 = COPY [[ADD]](s64)
  ; CHECK:   RET_ReallyLR implicit $x0
  call { i64, i64 } asm sideeffect "mov $0, 7; mov $1, 7", "=&r,=&r"(), !srcloc !0
  %asmresult = extractvalue { i64, i64 } %1, 0
  %asmresult1 = extractvalue { i64, i64 } %1, 1
  %add = add i64 %asmresult, %asmresult1
  ret i64 %add
}

define i32 @test_specific_register_output() nounwind ssp {
  ; CHECK-LABEL: name: test_specific_register_output
  ; CHECK: bb.1.entry:
  ; CHECK:   INLINEASM &"mov ${0:w}, 7", 0 /* attdialect */, 10 /* regdef */, implicit-def $w0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY $w0
  ; CHECK:   $w0 = COPY [[COPY]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %0 = tail call i32 asm "mov ${0:w}, 7", "={w0}"() nounwind
  ret i32 %0
}

define i32 @test_single_register_output() nounwind ssp {
  ; CHECK-LABEL: name: test_single_register_output
  ; CHECK: bb.1.entry:
  ; CHECK:   INLINEASM &"mov ${0:w}, 7", 0 /* attdialect */, 655370 /* regdef:GPR32common */, def %0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY %0
  ; CHECK:   $w0 = COPY [[COPY]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %0 = tail call i32 asm "mov ${0:w}, 7", "=r"() nounwind
  ret i32 %0
}

define i64 @test_single_register_output_s64() nounwind ssp {
  ; CHECK-LABEL: name: test_single_register_output_s64
  ; CHECK: bb.1.entry:
  ; CHECK:   INLINEASM &"mov $0, 7", 0 /* attdialect */, 1441802 /* regdef:GPR64common */, def %0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY %0
  ; CHECK:   $x0 = COPY [[COPY]](s64)
  ; CHECK:   RET_ReallyLR implicit $x0
entry:
  %0 = tail call i64 asm "mov $0, 7", "=r"() nounwind
  ret i64 %0
}

; Check support for returning several floats
define float @test_multiple_register_outputs_same() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_same
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"mov $0, #0; mov $1, #0", 0 /* attdialect */, 655370 /* regdef:GPR32common */, def %0, 655370 /* regdef:GPR32common */, def %1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY %0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[FADD:%[0-9]+]]:_(s32) = G_FADD [[COPY]], [[COPY1]]
  ; CHECK:   $s0 = COPY [[FADD]](s32)
  ; CHECK:   RET_ReallyLR implicit $s0
  %1 = call { float, float } asm "mov $0, #0; mov $1, #0", "=r,=r"()
  %asmresult = extractvalue { float, float } %1, 0
  %asmresult1 = extractvalue { float, float } %1, 1
  %add = fadd float %asmresult, %asmresult1
  ret float %add
}

; Check support for returning several floats
define double @test_multiple_register_outputs_mixed() #0 {
  ; CHECK-LABEL: name: test_multiple_register_outputs_mixed
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"mov $0, #0; mov $1, #0", 0 /* attdialect */, 655370 /* regdef:GPR32common */, def %0, 1245194 /* regdef:FPR64 */, def %1
  ; CHECK:   [[COPY:%[0-9]+]]:_(s32) = COPY %0
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s64) = COPY %1
  ; CHECK:   $d0 = COPY [[COPY1]](s64)
  ; CHECK:   RET_ReallyLR implicit $d0
  %1 = call { float, double } asm "mov $0, #0; mov $1, #0", "=r,=w"()
  %asmresult = extractvalue { float, double } %1, 1
  ret double %asmresult
}

define i32 @test_specific_register_output_trunc() nounwind ssp {
  ; CHECK-LABEL: name: test_specific_register_output_trunc
  ; CHECK: bb.1.entry:
  ; CHECK:   INLINEASM &"mov ${0:w}, 7", 0 /* attdialect */, 10 /* regdef */, implicit-def $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s32) = G_TRUNC [[COPY]](s64)
  ; CHECK:   $w0 = COPY [[TRUNC]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %0 = tail call i32 asm "mov ${0:w}, 7", "={x0}"() nounwind
  ret i32 %0
}

define zeroext i8 @test_register_output_trunc(i8* %src) nounwind {
  ; CHECK-LABEL: name: test_register_output_trunc
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   INLINEASM &"mov ${0:w}, 32", 0 /* attdialect */, 655370 /* regdef:GPR32common */, def %1
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s8) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s32) = G_ZEXT [[TRUNC]](s8)
  ; CHECK:   $w0 = COPY [[ZEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %0 = tail call i8 asm "mov ${0:w}, 32", "=r"() nounwind
  ret i8 %0
}

define float @test_vector_output() nounwind {
  ; CHECK-LABEL: name: test_vector_output
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 0
  ; CHECK:   INLINEASM &"fmov ${0}.2s, #1.0", 1 /* sideeffect attdialect */, 10 /* regdef */, implicit-def $d14
  ; CHECK:   [[COPY:%[0-9]+]]:_(<2 x s32>) = COPY $d14
  ; CHECK:   [[EVEC:%[0-9]+]]:_(s32) = G_EXTRACT_VECTOR_ELT [[COPY]](<2 x s32>), [[C]](s64)
  ; CHECK:   $s0 = COPY [[EVEC]](s32)
  ; CHECK:   RET_ReallyLR implicit $s0
  %1 = tail call <2 x float> asm sideeffect "fmov ${0}.2s, #1.0", "={v14}"() nounwind
  %2 = extractelement <2 x float> %1, i32 0
  ret float %2
}

define void @test_input_register_imm() {
  ; CHECK-LABEL: name: test_input_register_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s64) = G_CONSTANT i64 42
  ; CHECK:   [[COPY:%[0-9]+]]:gpr64common = COPY [[C]](s64)
  ; CHECK:   INLINEASM &"mov x0, $0", 1 /* sideeffect attdialect */, 1441801 /* reguse:GPR64common */, [[COPY]]
  ; CHECK:   RET_ReallyLR
  call void asm sideeffect "mov x0, $0", "r"(i64 42)
  ret void
}

; Make sure that boolean immediates are properly (zero) extended.
define i32 @test_boolean_imm_ext() {
  ; CHECK-LABEL: name: test_boolean_imm_ext
  ; CHECK: bb.1.entry:
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 1
  ; CHECK:   INLINEASM &"#TEST 42 + ${0:c} - .\0A\09", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 1
  ; CHECK:   $w0 = COPY [[C]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  tail call void asm sideeffect "#TEST 42 + ${0:c} - .\0A\09", "i"(i1 true)
  ret i32 1
}

define void @test_input_imm() {
  ; CHECK-LABEL: name: test_input_imm
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   INLINEASM &"mov x0, $0", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42
  ; CHECK:   RET_ReallyLR
  call void asm sideeffect "mov x0, $0", "i"(i64 42)
  ret void
}

define zeroext i8 @test_input_register(i8* %src) nounwind {
  ; CHECK-LABEL: name: test_input_register
  ; CHECK: bb.1.entry:
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[COPY1:%[0-9]+]]:gpr64common = COPY [[COPY]](p0)
  ; CHECK:   INLINEASM &"ldtrb ${0:w}, [$1]", 0 /* attdialect */, 655370 /* regdef:GPR32common */, def %1, 1441801 /* reguse:GPR64common */, [[COPY1]]
  ; CHECK:   [[COPY2:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s8) = G_TRUNC [[COPY2]](s32)
  ; CHECK:   [[ZEXT:%[0-9]+]]:_(s32) = G_ZEXT [[TRUNC]](s8)
  ; CHECK:   $w0 = COPY [[ZEXT]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
entry:
  %0 = tail call i8 asm "ldtrb ${0:w}, [$1]", "=r,r"(i8* %src) nounwind
  ret i8 %0
}

define i32 @test_memory_constraint(i32* %a) nounwind {
  ; CHECK-LABEL: name: test_memory_constraint
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   INLINEASM &"ldr $0, $1", 8 /* mayload attdialect */, 655370 /* regdef:GPR32common */, def %1, 196622 /* mem:m */, [[COPY]](p0)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %1
  ; CHECK:   $w0 = COPY [[COPY1]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %1 = tail call i32 asm "ldr $0, $1", "=r,*m"(i32* %a)
  ret i32 %1
}

define i16 @test_anyext_input() {
  ; CHECK-LABEL: name: test_anyext_input
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[C]](s16)
  ; CHECK:   [[COPY:%[0-9]+]]:gpr32common = COPY [[ANYEXT]](s32)
  ; CHECK:   INLINEASM &"", 1 /* sideeffect attdialect */, 655370 /* regdef:GPR32common */, def %0, 655369 /* reguse:GPR32common */, [[COPY]]
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[TRUNC]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT1]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %1 = call i16 asm sideeffect "", "=r,r"(i16 1)
  ret i16 %1
}

define i16 @test_anyext_input_with_matching_constraint() {
  ; CHECK-LABEL: name: test_anyext_input_with_matching_constraint
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   [[C:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[C]](s16)
  ; CHECK:   [[COPY:%[0-9]+]]:gpr32common = COPY [[ANYEXT]](s32)
  ; CHECK:   INLINEASM &"", 1 /* sideeffect attdialect */, 655370 /* regdef:GPR32common */, def %0, 2147483657 /* reguse tiedto:$0 */, [[COPY]](tied-def 3)
  ; CHECK:   [[COPY1:%[0-9]+]]:_(s32) = COPY %0
  ; CHECK:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY1]](s32)
  ; CHECK:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[TRUNC]](s16)
  ; CHECK:   $w0 = COPY [[ANYEXT1]](s32)
  ; CHECK:   RET_ReallyLR implicit $w0
  %1 = call i16 asm sideeffect "", "=r,0"(i16 1)
  ret i16 %1
}
