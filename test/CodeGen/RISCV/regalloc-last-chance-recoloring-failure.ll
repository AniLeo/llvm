; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+f,+m,+zfh,+experimental-zvfh < %s | FileCheck %s

; This testcase failed to compile after
; c46aab01c002b7a04135b8b7f1f52d8c9ae23a58, which was reverted.

; FIXME: The failure does not reproduce with -stop-before=greedy
; output MIR with -start-before=greedy

define void @last_chance_recoloring_failure() {
; CHECK-LABEL: last_chance_recoloring_failure:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; CHECK-NEXT:    .cfi_offset ra, -8
; CHECK-NEXT:    .cfi_offset s0, -16
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    li a1, 24
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    sub sp, sp, a0
; CHECK-NEXT:    li a0, 55
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vloxseg2ei32.v v8, (a0), v8
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    add a0, sp, a0
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 2
; CHECK-NEXT:    vs4r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    add a0, a0, a1
; CHECK-NEXT:    vs4r.v v12, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    vsetvli a0, zero, e8, m2, ta, mu
; CHECK-NEXT:    vmclr.m v0
; CHECK-NEXT:    li s0, 36
; CHECK-NEXT:    vsetvli zero, s0, e16, m4, tu, mu
; CHECK-NEXT:    vfwadd.vv v8, v8, v8, v0.t
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 4
; CHECK-NEXT:    add a0, sp, a0
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vs8r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    call func@plt
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vrgather.vv v4, v8, v8, v0.t
; CHECK-NEXT:    vsetvli zero, s0, e16, m4, ta, mu
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 3
; CHECK-NEXT:    add a1, sp, a1
; CHECK-NEXT:    addi a1, a1, 16
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 2
; CHECK-NEXT:    vl4r.v v24, (a1) # Unknown-size Folded Reload
; CHECK-NEXT:    add a1, a1, a2
; CHECK-NEXT:    vl4r.v v28, (a1) # Unknown-size Folded Reload
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 4
; CHECK-NEXT:    add a1, sp, a1
; CHECK-NEXT:    addi a1, a1, 16
; CHECK-NEXT:    vl8re8.v v8, (a1) # Unknown-size Folded Reload
; CHECK-NEXT:    vfwsub.wv v16, v8, v24
; CHECK-NEXT:    addi a1, sp, 16
; CHECK-NEXT:    vs8r.v v16, (a1) # Unknown-size Folded Spill
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, tu, mu
; CHECK-NEXT:    vssubu.vv v4, v4, v8, v0.t
; CHECK-NEXT:    vsetvli zero, s0, e32, m8, tu, mu
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 4
; CHECK-NEXT:    add a0, sp, a0
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    vl8re8.v v16, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl8re8.v v8, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vfdiv.vv v8, v16, v8, v0.t
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    li a1, 24
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %i = call { <vscale x 16 x half>, <vscale x 16 x half> } @llvm.riscv.vloxseg2.nxv16f16.nxv16i32.i64(half* nonnull poison, <vscale x 16 x i32> poison, i64 55)
  %i1 = extractvalue { <vscale x 16 x half>, <vscale x 16 x half> } %i, 0
  %i2 = call <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.nxv16f16.i64(<vscale x 16 x float> poison, <vscale x 16 x half> poison, <vscale x 16 x half> poison, <vscale x 16 x i1> zeroinitializer, i64 36, i64 0)
  call void @func()
  %i3 = call <vscale x 16 x i16> @llvm.riscv.vrgather.vv.mask.nxv16i16.i64(<vscale x 16 x i16> poison, <vscale x 16 x i16> poison, <vscale x 16 x i16> poison, <vscale x 16 x i1> poison, i64 32, i64 0)
  %i4 = call <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.nxv16f16.i64(<vscale x 16 x float> poison, <vscale x 16 x float> %i2, <vscale x 16 x half> %i1, i64 36)
  %i5 = call <vscale x 16 x i16> @llvm.riscv.vssubu.mask.nxv16i16.nxv16i16.i64(<vscale x 16 x i16> %i3, <vscale x 16 x i16> %i3, <vscale x 16 x i16> poison, <vscale x 16 x i1> poison, i64 32, i64 0)
  %i6 = call <vscale x 16 x float> @llvm.riscv.vfdiv.mask.nxv16f32.nxv16f32.i64(<vscale x 16 x float> %i4, <vscale x 16 x float> %i2, <vscale x 16 x float> poison, <vscale x 16 x i1> poison, i64 36, i64 0)
  call void @llvm.riscv.vse.nxv16f32.i64(<vscale x 16 x float> %i6, <vscale x 16 x float>* nonnull poison, i64 36)
  ret void
}

declare void @func()
declare { <vscale x 16 x half>, <vscale x 16 x half> } @llvm.riscv.vloxseg2.nxv16f16.nxv16i32.i64(half* nocapture, <vscale x 16 x i32>, i64)
declare <vscale x 16 x float> @llvm.riscv.vfwadd.mask.nxv16f32.nxv16f16.nxv16f16.i64(<vscale x 16 x float>, <vscale x 16 x half>, <vscale x 16 x half>, <vscale x 16 x i1>, i64, i64 immarg)
declare <vscale x 16 x i16> @llvm.riscv.vrgather.vv.mask.nxv16i16.i64(<vscale x 16 x i16>, <vscale x 16 x i16>, <vscale x 16 x i16>, <vscale x 16 x i1>, i64, i64 immarg)
declare <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.nxv16f16.i64(<vscale x 16 x float>, <vscale x 16 x float>, <vscale x 16 x half>, i64)
declare <vscale x 16 x i16> @llvm.riscv.vssubu.mask.nxv16i16.nxv16i16.i64(<vscale x 16 x i16>, <vscale x 16 x i16>, <vscale x 16 x i16>, <vscale x 16 x i1>, i64, i64 immarg)
declare <vscale x 16 x float> @llvm.riscv.vfdiv.mask.nxv16f32.nxv16f32.i64(<vscale x 16 x float>, <vscale x 16 x float>, <vscale x 16 x float>, <vscale x 16 x i1>, i64, i64 immarg)
declare void @llvm.riscv.vse.nxv16f32.i64(<vscale x 16 x float>, <vscale x 16 x float>* nocapture, i64) #3
