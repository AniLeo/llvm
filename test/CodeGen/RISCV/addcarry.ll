; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+m | FileCheck %s --check-prefix=RISCV32

; Test ADDCARRY node expansion on a target that does not currently support ADDCARRY.
; Signed fixed point multiplication eventually expands down to an ADDCARRY.

declare  i64 @llvm.smul.fix.i64  (i64, i64, i32)
declare { i32, i1 } @llvm.uadd.with.overflow.i32(i32, i32)

define i64 @addcarry(i64 %x, i64 %y) nounwind {
; RISCV32-LABEL: addcarry:
; RISCV32:       # %bb.0:
; RISCV32-NEXT:    mul a4, a0, a3
; RISCV32-NEXT:    mulhu a5, a0, a2
; RISCV32-NEXT:    add a6, a5, a4
; RISCV32-NEXT:    mul a4, a1, a2
; RISCV32-NEXT:    add a4, a6, a4
; RISCV32-NEXT:    sltu a7, a4, a6
; RISCV32-NEXT:    sltu a5, a6, a5
; RISCV32-NEXT:    mulhu a6, a0, a3
; RISCV32-NEXT:    add a5, a6, a5
; RISCV32-NEXT:    mulhu a6, a1, a2
; RISCV32-NEXT:    add a5, a5, a6
; RISCV32-NEXT:    add a5, a5, a7
; RISCV32-NEXT:    mul a6, a1, a3
; RISCV32-NEXT:    add a5, a5, a6
; RISCV32-NEXT:    bgez a1, .LBB0_2
; RISCV32-NEXT:  # %bb.1:
; RISCV32-NEXT:    sub a5, a5, a2
; RISCV32-NEXT:  .LBB0_2:
; RISCV32-NEXT:    bgez a3, .LBB0_4
; RISCV32-NEXT:  # %bb.3:
; RISCV32-NEXT:    sub a5, a5, a0
; RISCV32-NEXT:  .LBB0_4:
; RISCV32-NEXT:    slli a1, a5, 30
; RISCV32-NEXT:    srli a3, a4, 2
; RISCV32-NEXT:    or a1, a1, a3
; RISCV32-NEXT:    slli a3, a4, 30
; RISCV32-NEXT:    mul a0, a0, a2
; RISCV32-NEXT:    srli a0, a0, 2
; RISCV32-NEXT:    or a0, a3, a0
; RISCV32-NEXT:    ret
  %tmp = call i64 @llvm.smul.fix.i64(i64 %x, i64 %y, i32 2);
  ret i64 %tmp;
}

; negative test for combineCarryDiamond(): ADDCARRY not legal
define { i32, i32, i1 } @addcarry_2x32(i32 %x0, i32 %x1, i32 %y0, i32 %y1) nounwind {
; RISCV32-LABEL: addcarry_2x32:
; RISCV32:       # %bb.0:
; RISCV32-NEXT:    add a3, a1, a3
; RISCV32-NEXT:    sltu a1, a3, a1
; RISCV32-NEXT:    add a4, a2, a4
; RISCV32-NEXT:    sltu a2, a4, a2
; RISCV32-NEXT:    add a1, a4, a1
; RISCV32-NEXT:    sltu a4, a1, a4
; RISCV32-NEXT:    or a2, a2, a4
; RISCV32-NEXT:    sw a3, 0(a0)
; RISCV32-NEXT:    sw a1, 4(a0)
; RISCV32-NEXT:    sb a2, 8(a0)
; RISCV32-NEXT:    ret
  %t0 = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x0, i32 %y0)
  %s0 = extractvalue { i32, i1 } %t0, 0
  %k0 = extractvalue { i32, i1 } %t0, 1

  %t1 = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %x1, i32 %y1)
  %s1 = extractvalue { i32, i1 } %t1, 0
  %k1 = extractvalue { i32, i1 } %t1, 1

  %zk0 = zext i1 %k0 to i32
  %t2 = call { i32, i1 } @llvm.uadd.with.overflow.i32(i32 %s1, i32 %zk0)
  %s2 = extractvalue { i32, i1 } %t2, 0
  %k2 = extractvalue { i32, i1 } %t2, 1
  %k = or i1 %k1, %k2

  %r0 = insertvalue { i32, i32, i1 } poison, i32 %s0, 0
  %r1 = insertvalue { i32, i32, i1 } %r0, i32 %s2, 1
  %r = insertvalue { i32, i32, i1 } %r1, i1 %k, 2
  ret { i32, i32, i1 } %r
}
