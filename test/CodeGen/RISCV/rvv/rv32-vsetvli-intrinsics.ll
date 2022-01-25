; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -verify-machineinstrs < %s | FileCheck %s

declare i32 @llvm.riscv.vsetvli.i32(i32, i32, i32)
declare i32 @llvm.riscv.vsetvlimax.i32(i32, i32)
declare i32 @llvm.riscv.vsetvli.opt.i32(i32, i32, i32)
declare i32 @llvm.riscv.vsetvlimax.opt.i32(i32, i32)

define void @test_vsetvli_e64mf8(i32 %avl) nounwind {
; CHECK-LABEL: test_vsetvli_e64mf8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, a0, e64, mf8, ta, mu
; CHECK-NEXT:    ret
  call i32 @llvm.riscv.vsetvli.i32(i32 %avl, i32 3, i32 5)
  ret void
}

define void @test_vsetvli_e8mf2_zero_avl() nounwind {
; CHECK-LABEL: test_vsetvli_e8mf2_zero_avl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a0, 0, e8, mf2, ta, mu
; CHECK-NEXT:    ret
  call i32 @llvm.riscv.vsetvli.i32(i32 0, i32 0, i32 7)
  ret void
}

define void @test_vsetvlimax_e64m8() nounwind {
; CHECK-LABEL: test_vsetvlimax_e64m8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, mu
; CHECK-NEXT:    ret
  call i32 @llvm.riscv.vsetvlimax.i32(i32 3, i32 3)
  ret void
}

define i32 @test_vsetvli_opt_e8m1(i32 %avl) nounwind {
; CHECK-LABEL: test_vsetvli_opt_e8m1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, a0, e8, m1, ta, mu
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvli.opt.i32(i32 %avl, i32 0, i32 0)
  ret i32 %vl
}

; Check that we remove the intrinsic if it's unused.
define void @test_vsetvli_opt_e8m1_nouse(i32 %avl) nounwind {
; CHECK-LABEL: test_vsetvli_opt_e8m1_nouse:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  call i32 @llvm.riscv.vsetvli.opt.i32(i32 %avl, i32 0, i32 0)
  ret void
}

define i32 @test_vsetvli_opt_e16mf4(i32 %avl) nounwind {
; CHECK-LABEL: test_vsetvli_opt_e16mf4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, a0, e16, mf4, ta, mu
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvli.opt.i32(i32 %avl, i32 1, i32 6)
  ret i32 %vl
}

define i32 @test_vsetvli_opt_e32mf8_zero_avl() nounwind {
; CHECK-LABEL: test_vsetvli_opt_e32mf8_zero_avl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli a0, 0, e16, mf4, ta, mu
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvli.opt.i32(i32 0, i32 1, i32 6)
  ret i32 %vl
}

define i32 @test_vsetvlimax_opt_e32m2() nounwind {
; CHECK-LABEL: test_vsetvlimax_opt_e32m2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, mu
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvlimax.opt.i32(i32 2, i32 1)
  ret i32 %vl
}

define void @test_vsetvlimax_opt_e32m2_nouse() nounwind {
; CHECK-LABEL: test_vsetvlimax_opt_e32m2_nouse:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  call i32 @llvm.riscv.vsetvlimax.opt.i32(i32 2, i32 1)
  ret void
}

define i32 @test_vsetvlimax_opt_e64m4() nounwind {
; CHECK-LABEL: test_vsetvlimax_opt_e64m4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, mu
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvlimax.opt.i32(i32 3, i32 2)
  ret i32 %vl
}

declare <vscale x 4 x i32> @llvm.riscv.vle.nxv4i32.i32(<vscale x 4 x i32>, <vscale x 4 x i32>*, i32)

; Check that we remove the redundant vsetvli when followed by another operation
define <vscale x 4 x i32> @redundant_vsetvli(i32 %avl, <vscale x 4 x i32>* %ptr) nounwind {
; CHECK-LABEL: redundant_vsetvli:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, a0, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    ret
  %vl = call i32 @llvm.riscv.vsetvli.i32(i32 %avl, i32 2, i32 1)
  %x = call <vscale x 4 x i32> @llvm.riscv.vle.nxv4i32.i32(<vscale x 4 x i32> undef, <vscale x 4 x i32>* %ptr, i32 %vl)
  ret <vscale x 4 x i32> %x
}

; Check that we remove the repeated/redundant vsetvli when followed by another
; operation
; FIXME: We don't catch the second vsetvli because it has a use of its output.
; We could replace it with the output of the first vsetvli.
define <vscale x 4 x i32> @repeated_vsetvli(i32 %avl, <vscale x 4 x i32>* %ptr) nounwind {
; CHECK-LABEL: repeated_vsetvli:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, a0, e32, m2, ta, mu
; CHECK-NEXT:    vsetvli a0, a0, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a1)
; CHECK-NEXT:    ret
  %vl0 = call i32 @llvm.riscv.vsetvli.i32(i32 %avl, i32 2, i32 1)
  %vl1 = call i32 @llvm.riscv.vsetvli.i32(i32 %vl0, i32 2, i32 1)
  %x = call <vscale x 4 x i32> @llvm.riscv.vle.nxv4i32.i32(<vscale x 4 x i32> undef, <vscale x 4 x i32>* %ptr, i32 %vl1)
  ret <vscale x 4 x i32> %x
}
