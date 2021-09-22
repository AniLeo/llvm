; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -mattr=+m -O0 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O0 %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -mattr=+m -O2 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O2 %s

define <vscale x 1 x i32> @spill_zvlsseg_nxv1i32(i32* %base, i64 %vl) nounwind {
; SPILL-O0-LABEL: spill_zvlsseg_nxv1i32:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a2, vlenb
; SPILL-O0-NEXT:    sub sp, sp, a2
; SPILL-O0-NEXT:    vsetvli zero, a1, e32, mf2, ta, mu
; SPILL-O0-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O0-NEXT:    vmv1r.v v8, v9
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
; SPILL-O2-LABEL: spill_zvlsseg_nxv1i32:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a2, vlenb
; SPILL-O2-NEXT:    slli a2, a2, 1
; SPILL-O2-NEXT:    sub sp, sp, a2
; SPILL-O2-NEXT:    vsetvli zero, a1, e32, mf2, ta, mu
; SPILL-O2-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs1r.v v9, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    vl1r.v v7, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    # kill: def $v8 killed $v8 killed $v7_v8
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 1
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  %0 = tail call {<vscale x 1 x i32>,<vscale x 1 x i32>} @llvm.riscv.vlseg2.nxv1i32(i32* %base, i64 %vl)
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()
  %1 = extractvalue {<vscale x 1 x i32>,<vscale x 1 x i32>} %0, 1
  ret <vscale x 1 x i32> %1
}

define <vscale x 2 x i32> @spill_zvlsseg_nxv2i32(i32* %base, i64 %vl) nounwind {
; SPILL-O0-LABEL: spill_zvlsseg_nxv2i32:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a2, vlenb
; SPILL-O0-NEXT:    sub sp, sp, a2
; SPILL-O0-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; SPILL-O0-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O0-NEXT:    vmv1r.v v8, v9
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
; SPILL-O2-LABEL: spill_zvlsseg_nxv2i32:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a2, vlenb
; SPILL-O2-NEXT:    slli a2, a2, 1
; SPILL-O2-NEXT:    sub sp, sp, a2
; SPILL-O2-NEXT:    vsetvli zero, a1, e32, m1, ta, mu
; SPILL-O2-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    vs1r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs1r.v v9, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    vl1r.v v7, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl1r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    # kill: def $v8 killed $v8 killed $v7_v8
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 1
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  %0 = tail call {<vscale x 2 x i32>,<vscale x 2 x i32>} @llvm.riscv.vlseg2.nxv2i32(i32* %base, i64 %vl)
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()
  %1 = extractvalue {<vscale x 2 x i32>,<vscale x 2 x i32>} %0, 1
  ret <vscale x 2 x i32> %1
}

define <vscale x 4 x i32> @spill_zvlsseg_nxv4i32(i32* %base, i64 %vl) nounwind {
; SPILL-O0-LABEL: spill_zvlsseg_nxv4i32:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a2, vlenb
; SPILL-O0-NEXT:    slli a2, a2, 1
; SPILL-O0-NEXT:    sub sp, sp, a2
; SPILL-O0-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; SPILL-O0-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O0-NEXT:    vmv2r.v v8, v10
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
; SPILL-O2-LABEL: spill_zvlsseg_nxv4i32:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a2, vlenb
; SPILL-O2-NEXT:    slli a2, a2, 2
; SPILL-O2-NEXT:    sub sp, sp, a2
; SPILL-O2-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; SPILL-O2-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 1
; SPILL-O2-NEXT:    vs2r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs2r.v v10, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 1
; SPILL-O2-NEXT:    vl2r.v v6, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl2r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    # kill: def $v8m2 killed $v8m2 killed $v6m2_v8m2
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 2
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  %0 = tail call {<vscale x 4 x i32>,<vscale x 4 x i32>} @llvm.riscv.vlseg2.nxv4i32(i32* %base, i64 %vl)
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()
  %1 = extractvalue {<vscale x 4 x i32>,<vscale x 4 x i32>} %0, 1
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i32> @spill_zvlsseg_nxv8i32(i32* %base, i64 %vl) nounwind {
; SPILL-O0-LABEL: spill_zvlsseg_nxv8i32:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a2, vlenb
; SPILL-O0-NEXT:    slli a2, a2, 2
; SPILL-O0-NEXT:    sub sp, sp, a2
; SPILL-O0-NEXT:    vsetvli zero, a1, e32, m4, ta, mu
; SPILL-O0-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O0-NEXT:    vmv4r.v v8, v12
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
; SPILL-O2-LABEL: spill_zvlsseg_nxv8i32:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a2, vlenb
; SPILL-O2-NEXT:    slli a2, a2, 3
; SPILL-O2-NEXT:    sub sp, sp, a2
; SPILL-O2-NEXT:    vsetvli zero, a1, e32, m4, ta, mu
; SPILL-O2-NEXT:    vlseg2e32.v v8, (a0)
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 2
; SPILL-O2-NEXT:    vs4r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs4r.v v12, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 2
; SPILL-O2-NEXT:    vl4r.v v4, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl4r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    # kill: def $v8m4 killed $v8m4 killed $v4m4_v8m4
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 3
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  %0 = tail call {<vscale x 8 x i32>,<vscale x 8 x i32>} @llvm.riscv.vlseg2.nxv8i32(i32* %base, i64 %vl)
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()
  %1 = extractvalue {<vscale x 8 x i32>,<vscale x 8 x i32>} %0, 1
  ret <vscale x 8 x i32> %1
}

define <vscale x 4 x i32> @spill_zvlsseg3_nxv4i32(i32* %base, i64 %vl) nounwind {
; SPILL-O0-LABEL: spill_zvlsseg3_nxv4i32:
; SPILL-O0:       # %bb.0: # %entry
; SPILL-O0-NEXT:    addi sp, sp, -16
; SPILL-O0-NEXT:    csrr a2, vlenb
; SPILL-O0-NEXT:    slli a2, a2, 1
; SPILL-O0-NEXT:    sub sp, sp, a2
; SPILL-O0-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; SPILL-O0-NEXT:    vlseg3e32.v v8, (a0)
; SPILL-O0-NEXT:    vmv2r.v v8, v10
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
; SPILL-O2-LABEL: spill_zvlsseg3_nxv4i32:
; SPILL-O2:       # %bb.0: # %entry
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    csrr a2, vlenb
; SPILL-O2-NEXT:    addi a3, zero, 6
; SPILL-O2-NEXT:    mul a2, a2, a3
; SPILL-O2-NEXT:    sub sp, sp, a2
; SPILL-O2-NEXT:    vsetvli zero, a1, e32, m2, ta, mu
; SPILL-O2-NEXT:    vlseg3e32.v v8, (a0)
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 1
; SPILL-O2-NEXT:    vs2r.v v8, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs2r.v v10, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vs2r.v v12, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    #APP
; SPILL-O2-NEXT:    #NO_APP
; SPILL-O2-NEXT:    addi a0, sp, 16
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 1
; SPILL-O2-NEXT:    vl2r.v v6, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl2r.v v8, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    add a0, a0, a1
; SPILL-O2-NEXT:    vl2r.v v10, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    # kill: def $v8m2 killed $v8m2 killed $v6m2_v8m2_v10m2
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    addi a1, zero, 6
; SPILL-O2-NEXT:    mul a0, a0, a1
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
entry:
  %0 = tail call {<vscale x 4 x i32>,<vscale x 4 x i32>,<vscale x 4 x i32>} @llvm.riscv.vlseg3.nxv4i32(i32* %base, i64 %vl)
  call void asm sideeffect "",
  "~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v8},~{v9},~{v10},~{v11},~{v12},~{v13},~{v14},~{v15},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31}"()
  %1 = extractvalue {<vscale x 4 x i32>,<vscale x 4 x i32>,<vscale x 4 x i32>} %0, 1
  ret <vscale x 4 x i32> %1
}

declare {<vscale x 1 x i32>,<vscale x 1 x i32>} @llvm.riscv.vlseg2.nxv1i32(i32* , i64)
declare {<vscale x 2 x i32>,<vscale x 2 x i32>} @llvm.riscv.vlseg2.nxv2i32(i32* , i64)
declare {<vscale x 4 x i32>,<vscale x 4 x i32>} @llvm.riscv.vlseg2.nxv4i32(i32* , i64)
declare {<vscale x 8 x i32>,<vscale x 8 x i32>} @llvm.riscv.vlseg2.nxv8i32(i32* , i64)
declare {<vscale x 4 x i32>,<vscale x 4 x i32>,<vscale x 4 x i32>} @llvm.riscv.vlseg3.nxv4i32(i32* , i64)
