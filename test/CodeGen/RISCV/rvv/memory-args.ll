; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -O2 < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IV

declare <vscale x 64 x i8> @llvm.riscv.vmacc.nxv64i8.nxv64i8(
  <vscale x 64 x i8>,
  <vscale x 64 x i8>,
  <vscale x 64 x i8>,
  i64);

define <vscale x 64 x i8> @callee(<vscale x 64 x i8> %arg0, <vscale x 64 x i8> %arg1, <vscale x 64 x i8> %arg2) {
; RV64IV-LABEL: callee:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    vl8r.v v24, (a0)
; RV64IV-NEXT:    li a0, 1024
; RV64IV-NEXT:    vsetvli zero, a0, e8, m8, tu, mu
; RV64IV-NEXT:    vmacc.vv v8, v16, v24
; RV64IV-NEXT:    ret
  %ret = call <vscale x 64 x i8> @llvm.riscv.vmacc.nxv64i8.nxv64i8(
                                  <vscale x 64 x i8> %arg0,
                                  <vscale x 64 x i8> %arg1,
                                  <vscale x 64 x i8> %arg2, i64 1024)
  ret <vscale x 64 x i8> %ret
}

define <vscale x 64 x i8> @caller() {
; RV64IV-LABEL: caller:
; RV64IV:       # %bb.0:
; RV64IV-NEXT:    addi sp, sp, -64
; RV64IV-NEXT:    .cfi_def_cfa_offset 64
; RV64IV-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64IV-NEXT:    .cfi_offset ra, -8
; RV64IV-NEXT:    .cfi_offset s0, -16
; RV64IV-NEXT:    addi s0, sp, 64
; RV64IV-NEXT:    .cfi_def_cfa s0, 0
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 5
; RV64IV-NEXT:    sub sp, sp, a0
; RV64IV-NEXT:    andi sp, sp, -64
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    li a1, 24
; RV64IV-NEXT:    mul a0, a0, a1
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    addi a0, a0, 48
; RV64IV-NEXT:    vl8r.v v8, (a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 4
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    addi a0, a0, 48
; RV64IV-NEXT:    vl8r.v v16, (a0)
; RV64IV-NEXT:    csrr a0, vlenb
; RV64IV-NEXT:    slli a0, a0, 3
; RV64IV-NEXT:    add a0, sp, a0
; RV64IV-NEXT:    addi a0, a0, 48
; RV64IV-NEXT:    vl8r.v v24, (a0)
; RV64IV-NEXT:    addi a0, sp, 48
; RV64IV-NEXT:    addi a1, sp, 48
; RV64IV-NEXT:    vs8r.v v24, (a1)
; RV64IV-NEXT:    call callee@plt
; RV64IV-NEXT:    addi sp, s0, -64
; RV64IV-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64IV-NEXT:    addi sp, sp, 64
; RV64IV-NEXT:    ret
  %local0 = alloca <vscale x 64 x i8>
  %local1 = alloca <vscale x 64 x i8>
  %local2 = alloca <vscale x 64 x i8>
  %arg0 = load volatile <vscale x 64 x i8>, <vscale x 64 x i8>* %local0
  %arg1 = load volatile <vscale x 64 x i8>, <vscale x 64 x i8>* %local1
  %arg2 = load volatile <vscale x 64 x i8>, <vscale x 64 x i8>* %local2
  %ret = call <vscale x 64 x i8> @callee(<vscale x 64 x i8> %arg0,
                                         <vscale x 64 x i8> %arg1,
                                         <vscale x 64 x i8> %arg2)
  ret <vscale x 64 x i8> %ret
}
