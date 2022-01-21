; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -O0 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O0 %s
; RUN: llc -mtriple=riscv32 -mattr=+v -O2 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O2 %s

define <vscale x 1 x i32> @spill_lmul_mf2(<vscale x 1 x i32> %va) nounwind {
; SPILL-O0-LABEL: spill_lmul_mf2:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    sub sp, sp, a0
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    #APP
; SPILL-O0-NEXT:    #NO_APP
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    addi sp, sp, 16
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: spill_lmul_mf2:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    sub sp, sp, a0
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()

  ret <vscale x 1 x i32> %va
}

define <vscale x 2 x i32> @spill_lmul_1(<vscale x 2 x i32> %va) nounwind {
; SPILL-O0-LABEL: spill_lmul_1:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    sub sp, sp, a0
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    #APP
; SPILL-O0-NEXT:    #NO_APP
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    addi sp, sp, 16
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: spill_lmul_1:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    sub sp, sp, a0
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()

  ret <vscale x 2 x i32> %va
}

define <vscale x 4 x i32> @spill_lmul_2(<vscale x 4 x i32> %va) nounwind {
; SPILL-O0-LABEL: spill_lmul_2:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 1
; SPILL-O0-NEXT:    sub sp, sp, a0
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs2r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    #APP
; SPILL-O0-NEXT:    #NO_APP
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vl2re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 1
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    addi sp, sp, 16
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: spill_lmul_2:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 1
; SPILL-O2-NEXT:    sub sp, sp, a0
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vs2r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vl2re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 1
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()

  ret <vscale x 4 x i32> %va
}

define <vscale x 8 x i32> @spill_lmul_4(<vscale x 8 x i32> %va) nounwind {
; SPILL-O0-LABEL: spill_lmul_4:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 2
; SPILL-O0-NEXT:    sub sp, sp, a0
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs4r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    #APP
; SPILL-O0-NEXT:    #NO_APP
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vl4re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 2
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    addi sp, sp, 16
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: spill_lmul_4:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 2
; SPILL-O2-NEXT:    sub sp, sp, a0
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vs4r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vl4re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 2
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()

  ret <vscale x 8 x i32> %va
}

define <vscale x 16 x i32> @spill_lmul_8(<vscale x 16 x i32> %va) nounwind {
; SPILL-O0-LABEL: spill_lmul_8:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 3
; SPILL-O0-NEXT:    sub sp, sp, a0
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs8r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    #APP
; SPILL-O0-NEXT:    #NO_APP
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vl8re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 3
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    addi sp, sp, 16
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: spill_lmul_8:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 3
; SPILL-O2-NEXT:    sub sp, sp, a0
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vs8r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    vl8re8.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 3
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()

  ret <vscale x 16 x i32> %va
}
