; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -stop-after=finalize-isel -o - %s | FileCheck -check-prefix=GCN %s

; Make sure nofpexcept flags are emitted when lowering a
; non-constrained fdiv.

define float @fdiv_f32(float %a, float %b) #0 {
  ; GCN-LABEL: name: fdiv_f32
  ; GCN: bb.0.entry:
  ; GCN:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; GCN:   [[COPY:%[0-9]+]]:sreg_64 = COPY $sgpr30_sgpr31
  ; GCN:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   %6:vgpr_32, %7:sreg_64 = nofpexcept V_DIV_SCALE_F32_e64 0, [[COPY2]], 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %8:vgpr_32, %9:sreg_64 = nofpexcept V_DIV_SCALE_F32_e64 0, [[COPY1]], 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %10:vgpr_32 = nofpexcept V_RCP_F32_e64 0, %8, 0, 0, implicit $mode, implicit $exec
  ; GCN:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 3
  ; GCN:   [[S_MOV_B32_1:%[0-9]+]]:sgpr_32 = S_MOV_B32 1065353216
  ; GCN:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN:   S_SETREG_B32_mode killed [[S_MOV_B32_]], 2305, implicit-def $mode, implicit $mode
  ; GCN:   %14:vgpr_32 = nofpexcept V_FMA_F32_e64 1, %8, 0, %10, 0, killed [[S_MOV_B32_1]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %15:vgpr_32 = nofpexcept V_FMA_F32_e64 0, killed %14, 0, %10, 0, %10, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %16:vgpr_32 = nofpexcept V_MUL_F32_e64 0, %6, 0, %15, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %17:vgpr_32 = nofpexcept V_FMA_F32_e64 1, %8, 0, %16, 0, %6, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %18:vgpr_32 = nofpexcept V_FMA_F32_e64 0, killed %17, 0, %15, 0, %16, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %19:vgpr_32 = nofpexcept V_FMA_F32_e64 1, %8, 0, %18, 0, %6, 0, 0, implicit $mode, implicit $exec
  ; GCN:   S_SETREG_B32_mode killed [[S_MOV_B32_2]], 2305, implicit-def dead $mode, implicit $mode
  ; GCN:   $vcc = COPY %7
  ; GCN:   %20:vgpr_32 = nofpexcept V_DIV_FMAS_F32_e64 0, killed %19, 0, %15, 0, %18, 0, 0, implicit $mode, implicit $vcc, implicit $exec
  ; GCN:   %21:vgpr_32 = nofpexcept V_DIV_FIXUP_F32_e64 0, killed %20, 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; GCN:   $vgpr0 = COPY %21
  ; GCN:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; GCN:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
entry:
  %fdiv = fdiv float %a, %b
  ret float %fdiv
}

define float @fdiv_nnan_f32(float %a, float %b) #0 {
  ; GCN-LABEL: name: fdiv_nnan_f32
  ; GCN: bb.0.entry:
  ; GCN:   liveins: $vgpr0, $vgpr1, $sgpr30_sgpr31
  ; GCN:   [[COPY:%[0-9]+]]:sreg_64 = COPY $sgpr30_sgpr31
  ; GCN:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   %6:vgpr_32, %7:sreg_64 = nnan nofpexcept V_DIV_SCALE_F32_e64 0, [[COPY2]], 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %8:vgpr_32, %9:sreg_64 = nnan nofpexcept V_DIV_SCALE_F32_e64 0, [[COPY1]], 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %10:vgpr_32 = nnan nofpexcept V_RCP_F32_e64 0, %8, 0, 0, implicit $mode, implicit $exec
  ; GCN:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 3
  ; GCN:   [[S_MOV_B32_1:%[0-9]+]]:sgpr_32 = S_MOV_B32 1065353216
  ; GCN:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN:   S_SETREG_B32_mode killed [[S_MOV_B32_]], 2305, implicit-def $mode, implicit $mode
  ; GCN:   %14:vgpr_32 = nnan nofpexcept V_FMA_F32_e64 1, %8, 0, %10, 0, killed [[S_MOV_B32_1]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   %15:vgpr_32 = nnan nofpexcept V_FMA_F32_e64 0, killed %14, 0, %10, 0, %10, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %16:vgpr_32 = nnan nofpexcept V_MUL_F32_e64 0, %6, 0, %15, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %17:vgpr_32 = nnan nofpexcept V_FMA_F32_e64 1, %8, 0, %16, 0, %6, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %18:vgpr_32 = nnan nofpexcept V_FMA_F32_e64 0, killed %17, 0, %15, 0, %16, 0, 0, implicit $mode, implicit $exec
  ; GCN:   %19:vgpr_32 = nnan nofpexcept V_FMA_F32_e64 1, %8, 0, %18, 0, %6, 0, 0, implicit $mode, implicit $exec
  ; GCN:   S_SETREG_B32_mode killed [[S_MOV_B32_2]], 2305, implicit-def dead $mode, implicit $mode
  ; GCN:   $vcc = COPY %7
  ; GCN:   %20:vgpr_32 = nnan nofpexcept V_DIV_FMAS_F32_e64 0, killed %19, 0, %15, 0, %18, 0, 0, implicit $mode, implicit $vcc, implicit $exec
  ; GCN:   %21:vgpr_32 = nnan nofpexcept V_DIV_FIXUP_F32_e64 0, killed %20, 0, [[COPY1]], 0, [[COPY2]], 0, 0, implicit $mode, implicit $exec
  ; GCN:   [[COPY3:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY]]
  ; GCN:   $vgpr0 = COPY %21
  ; GCN:   [[COPY4:%[0-9]+]]:ccr_sgpr_64 = COPY [[COPY3]]
  ; GCN:   S_SETPC_B64_return [[COPY4]], implicit $vgpr0
entry:
  %fdiv = fdiv nnan float %a, %b
  ret float %fdiv
}

attributes #0 = { nounwind "denormal-fp-math-f32"="preserve-sign,preserve-sign" }
