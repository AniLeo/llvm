; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v < %s \
; RUN:     --verify-machineinstrs | FileCheck %s

define <vscale x 1 x i1> @test_1xi1(<vscale x 1 x i1> %in, <vscale x 1 x i1> %in2) nounwind {
; CHECK-LABEL: test_1xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 1 x i1> %in, <vscale x 1 x i1> %in2)
  ret <vscale x 1 x i1> %0
}

define <vscale x 2 x i1> @test_2xi1(<vscale x 2 x i1> %in, <vscale x 2 x i1> %in2) nounwind {
; CHECK-LABEL: test_2xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 2 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 2 x i1> %in, <vscale x 2 x i1> %in2)
  ret <vscale x 2 x i1> %0
}

define <vscale x 4 x i1> @test_4xi1(<vscale x 4 x i1> %in, <vscale x 4 x i1> %in2) nounwind {
; CHECK-LABEL: test_4xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 4 x i1> %in, <vscale x 4 x i1> %in2)
  ret <vscale x 4 x i1> %0
}

define <vscale x 8 x i1> @test_8xi1(<vscale x 8 x i1> %in, <vscale x 8 x i1> %in2) nounwind {
; CHECK-LABEL: test_8xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 8 x i1> %in, <vscale x 8 x i1> %in2)
  ret <vscale x 8 x i1> %0
}

define <vscale x 16 x i1> @test_16xi1(<vscale x 16 x i1> %in, <vscale x 16 x i1> %in2) nounwind {
; CHECK-LABEL: test_16xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 16 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 16 x i1> %in, <vscale x 16 x i1> %in2)
  ret <vscale x 16 x i1> %0
}

define <vscale x 32 x i1> @test_32xi1(<vscale x 32 x i1> %in, <vscale x 32 x i1> %in2) nounwind {
; CHECK-LABEL: test_32xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 32 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 32 x i1> %in, <vscale x 32 x i1> %in2)
  ret <vscale x 32 x i1> %0
}

define <vscale x 64 x i1> @test_64xi1(<vscale x 64 x i1> %in, <vscale x 64 x i1> %in2) nounwind {
; CHECK-LABEL: test_64xi1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 64 x i1> asm "vmand.mm $0, $1, $2", "=^vm,^vm,^vm"(<vscale x 64 x i1> %in, <vscale x 64 x i1> %in2)
  ret <vscale x 64 x i1> %0
}

define <vscale x 1 x i64> @test_1xi64(<vscale x 1 x i64> %in, <vscale x 1 x i64> %in2) nounwind {
; CHECK-LABEL: test_1xi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i64> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 1 x i64> %in, <vscale x 1 x i64> %in2)
  ret <vscale x 1 x i64> %0
}

define <vscale x 2 x i64> @test_2xi64(<vscale x 2 x i64> %in, <vscale x 2 x i64> %in2) nounwind {
; CHECK-LABEL: test_2xi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v10
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 2 x i64> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 2 x i64> %in, <vscale x 2 x i64> %in2)
  ret <vscale x 2 x i64> %0
}

define <vscale x 4 x i64> @test_4xi64(<vscale x 4 x i64> %in, <vscale x 4 x i64> %in2) nounwind {
; CHECK-LABEL: test_4xi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v12
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i64> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 4 x i64> %in, <vscale x 4 x i64> %in2)
  ret <vscale x 4 x i64> %0
}

define <vscale x 8 x i64> @test_8xi64(<vscale x 8 x i64> %in, <vscale x 8 x i64> %in2) nounwind {
; CHECK-LABEL: test_8xi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v16
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i64> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 8 x i64> %in, <vscale x 8 x i64> %in2)
  ret <vscale x 8 x i64> %0
}

define <vscale x 1 x i32> @test_1xi32(<vscale x 1 x i32> %in, <vscale x 1 x i32> %in2) nounwind {
; CHECK-LABEL: test_1xi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i32> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 1 x i32> %in, <vscale x 1 x i32> %in2)
  ret <vscale x 1 x i32> %0
}

define <vscale x 2 x i32> @test_2xi32(<vscale x 2 x i32> %in, <vscale x 2 x i32> %in2) nounwind {
; CHECK-LABEL: test_2xi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 2 x i32> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 2 x i32> %in, <vscale x 2 x i32> %in2)
  ret <vscale x 2 x i32> %0
}

define <vscale x 4 x i32> @test_4xi32(<vscale x 4 x i32> %in, <vscale x 4 x i32> %in2) nounwind {
; CHECK-LABEL: test_4xi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v10
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i32> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 4 x i32> %in, <vscale x 4 x i32> %in2)
  ret <vscale x 4 x i32> %0
}

define <vscale x 8 x i32> @test_8xi32(<vscale x 8 x i32> %in, <vscale x 8 x i32> %in2) nounwind {
; CHECK-LABEL: test_8xi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v12
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i32> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 8 x i32> %in, <vscale x 8 x i32> %in2)
  ret <vscale x 8 x i32> %0
}

define <vscale x 16 x i32> @test_16xi32(<vscale x 16 x i32> %in, <vscale x 16 x i32> %in2) nounwind {
; CHECK-LABEL: test_16xi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v16
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 16 x i32> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 16 x i32> %in, <vscale x 16 x i32> %in2)
  ret <vscale x 16 x i32> %0
}

define <vscale x 1 x i16> @test_1xi16(<vscale x 1 x i16> %in, <vscale x 1 x i16> %in2) nounwind {
; CHECK-LABEL: test_1xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 1 x i16> %in, <vscale x 1 x i16> %in2)
  ret <vscale x 1 x i16> %0
}

define <vscale x 2 x i16> @test_2xi16(<vscale x 2 x i16> %in, <vscale x 2 x i16> %in2) nounwind {
; CHECK-LABEL: test_2xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 2 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 2 x i16> %in, <vscale x 2 x i16> %in2)
  ret <vscale x 2 x i16> %0
}

define <vscale x 4 x i16> @test_4xi16(<vscale x 4 x i16> %in, <vscale x 4 x i16> %in2) nounwind {
; CHECK-LABEL: test_4xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 4 x i16> %in, <vscale x 4 x i16> %in2)
  ret <vscale x 4 x i16> %0
}

define <vscale x 8 x i16> @test_8xi16(<vscale x 8 x i16> %in, <vscale x 8 x i16> %in2) nounwind {
; CHECK-LABEL: test_8xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v10
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 8 x i16> %in, <vscale x 8 x i16> %in2)
  ret <vscale x 8 x i16> %0
}

define <vscale x 16 x i16> @test_16xi16(<vscale x 16 x i16> %in, <vscale x 16 x i16> %in2) nounwind {
; CHECK-LABEL: test_16xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v12
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 16 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 16 x i16> %in, <vscale x 16 x i16> %in2)
  ret <vscale x 16 x i16> %0
}

define <vscale x 32 x i16> @test_32xi16(<vscale x 32 x i16> %in, <vscale x 32 x i16> %in2) nounwind {
; CHECK-LABEL: test_32xi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v16
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 32 x i16> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 32 x i16> %in, <vscale x 32 x i16> %in2)
  ret <vscale x 32 x i16> %0
}

define <vscale x 1 x i8> @test_1xi8(<vscale x 1 x i8> %in, <vscale x 1 x i8> %in2) nounwind {
; CHECK-LABEL: test_1xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 1 x i8> %in, <vscale x 1 x i8> %in2)
  ret <vscale x 1 x i8> %0
}

define <vscale x 2 x i8> @test_2xi8(<vscale x 2 x i8> %in, <vscale x 2 x i8> %in2) nounwind {
; CHECK-LABEL: test_2xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 2 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 2 x i8> %in, <vscale x 2 x i8> %in2)
  ret <vscale x 2 x i8> %0
}

define <vscale x 4 x i8> @test_4xi8(<vscale x 4 x i8> %in, <vscale x 4 x i8> %in2) nounwind {
; CHECK-LABEL: test_4xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 4 x i8> %in, <vscale x 4 x i8> %in2)
  ret <vscale x 4 x i8> %0
}

define <vscale x 8 x i8> @test_8xi8(<vscale x 8 x i8> %in, <vscale x 8 x i8> %in2) nounwind {
; CHECK-LABEL: test_8xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v9
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 8 x i8> %in, <vscale x 8 x i8> %in2)
  ret <vscale x 8 x i8> %0
}

define <vscale x 16 x i8> @test_16xi8(<vscale x 16 x i8> %in, <vscale x 16 x i8> %in2) nounwind {
; CHECK-LABEL: test_16xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v10
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 16 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 16 x i8> %in, <vscale x 16 x i8> %in2)
  ret <vscale x 16 x i8> %0
}

define <vscale x 32 x i8> @test_32xi8(<vscale x 32 x i8> %in, <vscale x 32 x i8> %in2) nounwind {
; CHECK-LABEL: test_32xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v12
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 32 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 32 x i8> %in, <vscale x 32 x i8> %in2)
  ret <vscale x 32 x i8> %0
}

define <vscale x 64 x i8> @test_64xi8(<vscale x 64 x i8> %in, <vscale x 64 x i8> %in2) nounwind {
; CHECK-LABEL: test_64xi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v8, v8, v16
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 64 x i8> asm "vadd.vv $0, $1, $2", "=^vr,^vr,^vr"(<vscale x 64 x i8> %in, <vscale x 64 x i8> %in2)
  ret <vscale x 64 x i8> %0
}

define <vscale x 4 x i8> @test_specify_reg_mf2(<vscale x 4 x i8> %in, <vscale x 4 x i8> %in2) nounwind {
; CHECK-LABEL: test_specify_reg_mf2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv1r.v v2, v9
; CHECK-NEXT:    vmv1r.v v1, v8
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v0, v1, v2
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmv1r.v v8, v0
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 4 x i8> asm "vadd.vv $0, $1, $2", "={v0},{v1},{v2}"(<vscale x 4 x i8> %in, <vscale x 4 x i8> %in2)
  ret <vscale x 4 x i8> %0
}

define <vscale x 8 x i8> @test_specify_reg_m1(<vscale x 8 x i8> %in, <vscale x 8 x i8> %in2) nounwind {
; CHECK-LABEL: test_specify_reg_m1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv1r.v v2, v9
; CHECK-NEXT:    vmv1r.v v1, v8
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v0, v1, v2
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmv1r.v v8, v0
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 8 x i8> asm "vadd.vv $0, $1, $2", "={v0},{v1},{v2}"(<vscale x 8 x i8> %in, <vscale x 8 x i8> %in2)
  ret <vscale x 8 x i8> %0
}

define <vscale x 16 x i8> @test_specify_reg_m2(<vscale x 16 x i8> %in, <vscale x 16 x i8> %in2) nounwind {
; CHECK-LABEL: test_specify_reg_m2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv2r.v v4, v10
; CHECK-NEXT:    vmv2r.v v2, v8
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vadd.vv v0, v2, v4
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    vmv2r.v v8, v0
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 16 x i8> asm "vadd.vv $0, $1, $2", "={v0},{v2},{v4}"(<vscale x 16 x i8> %in, <vscale x 16 x i8> %in2)
  ret <vscale x 16 x i8> %0
}

define <vscale x 1 x i1> @test_specify_reg_mask(<vscale x 1 x i1> %in, <vscale x 1 x i1> %in2) nounwind {
; CHECK-LABEL: test_specify_reg_mask:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv1r.v v2, v8
; CHECK-NEXT:    vmv1r.v v1, v0
; CHECK-NEXT:    #APP
; CHECK-NEXT:    vmand.mm v0, v1, v2
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x i1> asm "vmand.mm $0, $1, $2", "={v0},{v1},{v2}"(<vscale x 1 x i1> %in, <vscale x 1 x i1> %in2)
  ret <vscale x 1 x i1> %0
}
