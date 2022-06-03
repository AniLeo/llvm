; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zfh -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32f | FileCheck -check-prefixes=CHECKIZFH,RV32IZFH %s
; RUN: llc -mtriple=riscv64 -mattr=+zfh -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64f | FileCheck -check-prefixes=CHECKIZFH,RV64IZFH %s

define signext i32 @test_floor_si32(half %x) {
; CHECKIZFH-LABEL: test_floor_si32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB0_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.w.h a0, fa0, rdn
; CHECKIZFH-NEXT:  .LBB0_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.floor.f16(half %x)
  %b = call i32 @llvm.fptosi.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_floor_si64(half %x) nounwind {
; RV32IZFH-LABEL: test_floor_si64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call floorf@plt
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI1_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI1_0)(a0)
; RV32IZFH-NEXT:    fcvt.h.s ft1, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft1
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixsfdi@plt
; RV32IZFH-NEXT:    mv a2, a0
; RV32IZFH-NEXT:    bnez s0, .LBB1_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a2, 0
; RV32IZFH-NEXT:  .LBB1_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI1_1)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI1_1)(a0)
; RV32IZFH-NEXT:    flt.s a3, ft0, fs0
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a3, .LBB1_9
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    beqz a2, .LBB1_10
; RV32IZFH-NEXT:  .LBB1_4:
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    beqz s0, .LBB1_11
; RV32IZFH-NEXT:  .LBB1_5:
; RV32IZFH-NEXT:    bnez a3, .LBB1_12
; RV32IZFH-NEXT:  .LBB1_6:
; RV32IZFH-NEXT:    bnez a2, .LBB1_8
; RV32IZFH-NEXT:  .LBB1_7:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:  .LBB1_8:
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB1_9:
; RV32IZFH-NEXT:    mv a0, a2
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    bnez a2, .LBB1_4
; RV32IZFH-NEXT:  .LBB1_10:
; RV32IZFH-NEXT:    li a0, 0
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    bnez s0, .LBB1_5
; RV32IZFH-NEXT:  .LBB1_11:
; RV32IZFH-NEXT:    lui a1, 524288
; RV32IZFH-NEXT:    beqz a3, .LBB1_6
; RV32IZFH-NEXT:  .LBB1_12:
; RV32IZFH-NEXT:    addi a1, a4, -1
; RV32IZFH-NEXT:    beqz a2, .LBB1_7
; RV32IZFH-NEXT:    j .LBB1_8
;
; RV64IZFH-LABEL: test_floor_si64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB1_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rdn
; RV64IZFH-NEXT:  .LBB1_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.floor.f16(half %x)
  %b = call i64 @llvm.fptosi.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_floor_ui32(half %x) {
; CHECKIZFH-LABEL: test_floor_ui32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB2_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.wu.h a0, fa0, rdn
; CHECKIZFH-NEXT:  .LBB2_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.floor.f16(half %x)
  %b = call i32 @llvm.fptoui.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_floor_ui64(half %x) nounwind {
; RV32IZFH-LABEL: test_floor_ui64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call floorf@plt
; RV32IZFH-NEXT:    fcvt.h.s ft0, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft0
; RV32IZFH-NEXT:    fmv.w.x ft0, zero
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixunssfdi@plt
; RV32IZFH-NEXT:    mv a3, a0
; RV32IZFH-NEXT:    bnez s0, .LBB3_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a3, 0
; RV32IZFH-NEXT:  .LBB3_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI3_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI3_0)(a0)
; RV32IZFH-NEXT:    flt.s a4, ft0, fs0
; RV32IZFH-NEXT:    li a2, -1
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a4, .LBB3_7
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    beqz s0, .LBB3_8
; RV32IZFH-NEXT:  .LBB3_4:
; RV32IZFH-NEXT:    bnez a4, .LBB3_6
; RV32IZFH-NEXT:  .LBB3_5:
; RV32IZFH-NEXT:    mv a2, a1
; RV32IZFH-NEXT:  .LBB3_6:
; RV32IZFH-NEXT:    mv a1, a2
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB3_7:
; RV32IZFH-NEXT:    mv a0, a3
; RV32IZFH-NEXT:    bnez s0, .LBB3_4
; RV32IZFH-NEXT:  .LBB3_8:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:    beqz a4, .LBB3_5
; RV32IZFH-NEXT:    j .LBB3_6
;
; RV64IZFH-LABEL: test_floor_ui64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB3_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rdn
; RV64IZFH-NEXT:  .LBB3_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.floor.f16(half %x)
  %b = call i64 @llvm.fptoui.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_ceil_si32(half %x) {
; CHECKIZFH-LABEL: test_ceil_si32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB4_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.w.h a0, fa0, rup
; CHECKIZFH-NEXT:  .LBB4_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.ceil.f16(half %x)
  %b = call i32 @llvm.fptosi.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_ceil_si64(half %x) nounwind {
; RV32IZFH-LABEL: test_ceil_si64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call ceilf@plt
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI5_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI5_0)(a0)
; RV32IZFH-NEXT:    fcvt.h.s ft1, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft1
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixsfdi@plt
; RV32IZFH-NEXT:    mv a2, a0
; RV32IZFH-NEXT:    bnez s0, .LBB5_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a2, 0
; RV32IZFH-NEXT:  .LBB5_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI5_1)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI5_1)(a0)
; RV32IZFH-NEXT:    flt.s a3, ft0, fs0
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a3, .LBB5_9
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    beqz a2, .LBB5_10
; RV32IZFH-NEXT:  .LBB5_4:
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    beqz s0, .LBB5_11
; RV32IZFH-NEXT:  .LBB5_5:
; RV32IZFH-NEXT:    bnez a3, .LBB5_12
; RV32IZFH-NEXT:  .LBB5_6:
; RV32IZFH-NEXT:    bnez a2, .LBB5_8
; RV32IZFH-NEXT:  .LBB5_7:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:  .LBB5_8:
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB5_9:
; RV32IZFH-NEXT:    mv a0, a2
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    bnez a2, .LBB5_4
; RV32IZFH-NEXT:  .LBB5_10:
; RV32IZFH-NEXT:    li a0, 0
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    bnez s0, .LBB5_5
; RV32IZFH-NEXT:  .LBB5_11:
; RV32IZFH-NEXT:    lui a1, 524288
; RV32IZFH-NEXT:    beqz a3, .LBB5_6
; RV32IZFH-NEXT:  .LBB5_12:
; RV32IZFH-NEXT:    addi a1, a4, -1
; RV32IZFH-NEXT:    beqz a2, .LBB5_7
; RV32IZFH-NEXT:    j .LBB5_8
;
; RV64IZFH-LABEL: test_ceil_si64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB5_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rup
; RV64IZFH-NEXT:  .LBB5_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.ceil.f16(half %x)
  %b = call i64 @llvm.fptosi.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_ceil_ui32(half %x) {
; CHECKIZFH-LABEL: test_ceil_ui32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB6_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.wu.h a0, fa0, rup
; CHECKIZFH-NEXT:  .LBB6_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.ceil.f16(half %x)
  %b = call i32 @llvm.fptoui.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_ceil_ui64(half %x) nounwind {
; RV32IZFH-LABEL: test_ceil_ui64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call ceilf@plt
; RV32IZFH-NEXT:    fcvt.h.s ft0, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft0
; RV32IZFH-NEXT:    fmv.w.x ft0, zero
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixunssfdi@plt
; RV32IZFH-NEXT:    mv a3, a0
; RV32IZFH-NEXT:    bnez s0, .LBB7_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a3, 0
; RV32IZFH-NEXT:  .LBB7_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI7_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI7_0)(a0)
; RV32IZFH-NEXT:    flt.s a4, ft0, fs0
; RV32IZFH-NEXT:    li a2, -1
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a4, .LBB7_7
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    beqz s0, .LBB7_8
; RV32IZFH-NEXT:  .LBB7_4:
; RV32IZFH-NEXT:    bnez a4, .LBB7_6
; RV32IZFH-NEXT:  .LBB7_5:
; RV32IZFH-NEXT:    mv a2, a1
; RV32IZFH-NEXT:  .LBB7_6:
; RV32IZFH-NEXT:    mv a1, a2
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB7_7:
; RV32IZFH-NEXT:    mv a0, a3
; RV32IZFH-NEXT:    bnez s0, .LBB7_4
; RV32IZFH-NEXT:  .LBB7_8:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:    beqz a4, .LBB7_5
; RV32IZFH-NEXT:    j .LBB7_6
;
; RV64IZFH-LABEL: test_ceil_ui64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB7_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rup
; RV64IZFH-NEXT:  .LBB7_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.ceil.f16(half %x)
  %b = call i64 @llvm.fptoui.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_trunc_si32(half %x) {
; CHECKIZFH-LABEL: test_trunc_si32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB8_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; CHECKIZFH-NEXT:  .LBB8_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.trunc.f16(half %x)
  %b = call i32 @llvm.fptosi.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_trunc_si64(half %x) nounwind {
; RV32IZFH-LABEL: test_trunc_si64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call truncf@plt
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI9_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI9_0)(a0)
; RV32IZFH-NEXT:    fcvt.h.s ft1, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft1
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixsfdi@plt
; RV32IZFH-NEXT:    mv a2, a0
; RV32IZFH-NEXT:    bnez s0, .LBB9_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a2, 0
; RV32IZFH-NEXT:  .LBB9_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI9_1)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI9_1)(a0)
; RV32IZFH-NEXT:    flt.s a3, ft0, fs0
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a3, .LBB9_9
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    beqz a2, .LBB9_10
; RV32IZFH-NEXT:  .LBB9_4:
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    beqz s0, .LBB9_11
; RV32IZFH-NEXT:  .LBB9_5:
; RV32IZFH-NEXT:    bnez a3, .LBB9_12
; RV32IZFH-NEXT:  .LBB9_6:
; RV32IZFH-NEXT:    bnez a2, .LBB9_8
; RV32IZFH-NEXT:  .LBB9_7:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:  .LBB9_8:
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB9_9:
; RV32IZFH-NEXT:    mv a0, a2
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    bnez a2, .LBB9_4
; RV32IZFH-NEXT:  .LBB9_10:
; RV32IZFH-NEXT:    li a0, 0
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    bnez s0, .LBB9_5
; RV32IZFH-NEXT:  .LBB9_11:
; RV32IZFH-NEXT:    lui a1, 524288
; RV32IZFH-NEXT:    beqz a3, .LBB9_6
; RV32IZFH-NEXT:  .LBB9_12:
; RV32IZFH-NEXT:    addi a1, a4, -1
; RV32IZFH-NEXT:    beqz a2, .LBB9_7
; RV32IZFH-NEXT:    j .LBB9_8
;
; RV64IZFH-LABEL: test_trunc_si64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB9_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rtz
; RV64IZFH-NEXT:  .LBB9_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.trunc.f16(half %x)
  %b = call i64 @llvm.fptosi.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_trunc_ui32(half %x) {
; CHECKIZFH-LABEL: test_trunc_ui32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB10_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; CHECKIZFH-NEXT:  .LBB10_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.trunc.f16(half %x)
  %b = call i32 @llvm.fptoui.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_trunc_ui64(half %x) nounwind {
; RV32IZFH-LABEL: test_trunc_ui64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call truncf@plt
; RV32IZFH-NEXT:    fcvt.h.s ft0, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft0
; RV32IZFH-NEXT:    fmv.w.x ft0, zero
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixunssfdi@plt
; RV32IZFH-NEXT:    mv a3, a0
; RV32IZFH-NEXT:    bnez s0, .LBB11_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a3, 0
; RV32IZFH-NEXT:  .LBB11_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI11_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI11_0)(a0)
; RV32IZFH-NEXT:    flt.s a4, ft0, fs0
; RV32IZFH-NEXT:    li a2, -1
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a4, .LBB11_7
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    beqz s0, .LBB11_8
; RV32IZFH-NEXT:  .LBB11_4:
; RV32IZFH-NEXT:    bnez a4, .LBB11_6
; RV32IZFH-NEXT:  .LBB11_5:
; RV32IZFH-NEXT:    mv a2, a1
; RV32IZFH-NEXT:  .LBB11_6:
; RV32IZFH-NEXT:    mv a1, a2
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB11_7:
; RV32IZFH-NEXT:    mv a0, a3
; RV32IZFH-NEXT:    bnez s0, .LBB11_4
; RV32IZFH-NEXT:  .LBB11_8:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:    beqz a4, .LBB11_5
; RV32IZFH-NEXT:    j .LBB11_6
;
; RV64IZFH-LABEL: test_trunc_ui64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB11_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IZFH-NEXT:  .LBB11_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.trunc.f16(half %x)
  %b = call i64 @llvm.fptoui.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_round_si32(half %x) {
; CHECKIZFH-LABEL: test_round_si32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB12_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.w.h a0, fa0, rmm
; CHECKIZFH-NEXT:  .LBB12_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.round.f16(half %x)
  %b = call i32 @llvm.fptosi.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_round_si64(half %x) nounwind {
; RV32IZFH-LABEL: test_round_si64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call roundf@plt
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI13_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI13_0)(a0)
; RV32IZFH-NEXT:    fcvt.h.s ft1, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft1
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixsfdi@plt
; RV32IZFH-NEXT:    mv a2, a0
; RV32IZFH-NEXT:    bnez s0, .LBB13_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a2, 0
; RV32IZFH-NEXT:  .LBB13_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI13_1)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI13_1)(a0)
; RV32IZFH-NEXT:    flt.s a3, ft0, fs0
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a3, .LBB13_9
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    beqz a2, .LBB13_10
; RV32IZFH-NEXT:  .LBB13_4:
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    beqz s0, .LBB13_11
; RV32IZFH-NEXT:  .LBB13_5:
; RV32IZFH-NEXT:    bnez a3, .LBB13_12
; RV32IZFH-NEXT:  .LBB13_6:
; RV32IZFH-NEXT:    bnez a2, .LBB13_8
; RV32IZFH-NEXT:  .LBB13_7:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:  .LBB13_8:
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB13_9:
; RV32IZFH-NEXT:    mv a0, a2
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    bnez a2, .LBB13_4
; RV32IZFH-NEXT:  .LBB13_10:
; RV32IZFH-NEXT:    li a0, 0
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    bnez s0, .LBB13_5
; RV32IZFH-NEXT:  .LBB13_11:
; RV32IZFH-NEXT:    lui a1, 524288
; RV32IZFH-NEXT:    beqz a3, .LBB13_6
; RV32IZFH-NEXT:  .LBB13_12:
; RV32IZFH-NEXT:    addi a1, a4, -1
; RV32IZFH-NEXT:    beqz a2, .LBB13_7
; RV32IZFH-NEXT:    j .LBB13_8
;
; RV64IZFH-LABEL: test_round_si64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB13_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rmm
; RV64IZFH-NEXT:  .LBB13_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.round.f16(half %x)
  %b = call i64 @llvm.fptosi.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_round_ui32(half %x) {
; CHECKIZFH-LABEL: test_round_ui32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB14_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.wu.h a0, fa0, rmm
; CHECKIZFH-NEXT:  .LBB14_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.round.f16(half %x)
  %b = call i32 @llvm.fptoui.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_round_ui64(half %x) nounwind {
; RV32IZFH-LABEL: test_round_ui64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call roundf@plt
; RV32IZFH-NEXT:    fcvt.h.s ft0, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft0
; RV32IZFH-NEXT:    fmv.w.x ft0, zero
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixunssfdi@plt
; RV32IZFH-NEXT:    mv a3, a0
; RV32IZFH-NEXT:    bnez s0, .LBB15_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a3, 0
; RV32IZFH-NEXT:  .LBB15_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI15_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI15_0)(a0)
; RV32IZFH-NEXT:    flt.s a4, ft0, fs0
; RV32IZFH-NEXT:    li a2, -1
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a4, .LBB15_7
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    beqz s0, .LBB15_8
; RV32IZFH-NEXT:  .LBB15_4:
; RV32IZFH-NEXT:    bnez a4, .LBB15_6
; RV32IZFH-NEXT:  .LBB15_5:
; RV32IZFH-NEXT:    mv a2, a1
; RV32IZFH-NEXT:  .LBB15_6:
; RV32IZFH-NEXT:    mv a1, a2
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB15_7:
; RV32IZFH-NEXT:    mv a0, a3
; RV32IZFH-NEXT:    bnez s0, .LBB15_4
; RV32IZFH-NEXT:  .LBB15_8:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:    beqz a4, .LBB15_5
; RV32IZFH-NEXT:    j .LBB15_6
;
; RV64IZFH-LABEL: test_round_ui64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB15_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rmm
; RV64IZFH-NEXT:  .LBB15_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.round.f16(half %x)
  %b = call i64 @llvm.fptoui.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_roundeven_si32(half %x) {
; CHECKIZFH-LABEL: test_roundeven_si32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB16_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.w.h a0, fa0, rne
; CHECKIZFH-NEXT:  .LBB16_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.roundeven.f16(half %x)
  %b = call i32 @llvm.fptosi.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_roundeven_si64(half %x) nounwind {
; RV32IZFH-LABEL: test_roundeven_si64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call roundevenf@plt
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI17_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI17_0)(a0)
; RV32IZFH-NEXT:    fcvt.h.s ft1, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft1
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixsfdi@plt
; RV32IZFH-NEXT:    mv a2, a0
; RV32IZFH-NEXT:    bnez s0, .LBB17_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a2, 0
; RV32IZFH-NEXT:  .LBB17_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI17_1)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI17_1)(a0)
; RV32IZFH-NEXT:    flt.s a3, ft0, fs0
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a3, .LBB17_9
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    beqz a2, .LBB17_10
; RV32IZFH-NEXT:  .LBB17_4:
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    beqz s0, .LBB17_11
; RV32IZFH-NEXT:  .LBB17_5:
; RV32IZFH-NEXT:    bnez a3, .LBB17_12
; RV32IZFH-NEXT:  .LBB17_6:
; RV32IZFH-NEXT:    bnez a2, .LBB17_8
; RV32IZFH-NEXT:  .LBB17_7:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:  .LBB17_8:
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB17_9:
; RV32IZFH-NEXT:    mv a0, a2
; RV32IZFH-NEXT:    feq.s a2, fs0, fs0
; RV32IZFH-NEXT:    bnez a2, .LBB17_4
; RV32IZFH-NEXT:  .LBB17_10:
; RV32IZFH-NEXT:    li a0, 0
; RV32IZFH-NEXT:    lui a4, 524288
; RV32IZFH-NEXT:    bnez s0, .LBB17_5
; RV32IZFH-NEXT:  .LBB17_11:
; RV32IZFH-NEXT:    lui a1, 524288
; RV32IZFH-NEXT:    beqz a3, .LBB17_6
; RV32IZFH-NEXT:  .LBB17_12:
; RV32IZFH-NEXT:    addi a1, a4, -1
; RV32IZFH-NEXT:    beqz a2, .LBB17_7
; RV32IZFH-NEXT:    j .LBB17_8
;
; RV64IZFH-LABEL: test_roundeven_si64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB17_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rne
; RV64IZFH-NEXT:  .LBB17_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.roundeven.f16(half %x)
  %b = call i64 @llvm.fptosi.sat.i64.f16(half %a)
  ret i64 %b
}

define signext i32 @test_roundeven_ui32(half %x) {
; CHECKIZFH-LABEL: test_roundeven_ui32:
; CHECKIZFH:       # %bb.0:
; CHECKIZFH-NEXT:    feq.h a0, fa0, fa0
; CHECKIZFH-NEXT:    beqz a0, .LBB18_2
; CHECKIZFH-NEXT:  # %bb.1:
; CHECKIZFH-NEXT:    fcvt.wu.h a0, fa0, rne
; CHECKIZFH-NEXT:  .LBB18_2:
; CHECKIZFH-NEXT:    ret
  %a = call half @llvm.roundeven.f16(half %x)
  %b = call i32 @llvm.fptoui.sat.i32.f16(half %a)
  ret i32 %b
}

define i64 @test_roundeven_ui64(half %x) nounwind {
; RV32IZFH-LABEL: test_roundeven_ui64:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fsw fs0, 4(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call roundevenf@plt
; RV32IZFH-NEXT:    fcvt.h.s ft0, fa0
; RV32IZFH-NEXT:    fcvt.s.h fs0, ft0
; RV32IZFH-NEXT:    fmv.w.x ft0, zero
; RV32IZFH-NEXT:    fle.s s0, ft0, fs0
; RV32IZFH-NEXT:    fmv.s fa0, fs0
; RV32IZFH-NEXT:    call __fixunssfdi@plt
; RV32IZFH-NEXT:    mv a3, a0
; RV32IZFH-NEXT:    bnez s0, .LBB19_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    li a3, 0
; RV32IZFH-NEXT:  .LBB19_2:
; RV32IZFH-NEXT:    lui a0, %hi(.LCPI19_0)
; RV32IZFH-NEXT:    flw ft0, %lo(.LCPI19_0)(a0)
; RV32IZFH-NEXT:    flt.s a4, ft0, fs0
; RV32IZFH-NEXT:    li a2, -1
; RV32IZFH-NEXT:    li a0, -1
; RV32IZFH-NEXT:    beqz a4, .LBB19_7
; RV32IZFH-NEXT:  # %bb.3:
; RV32IZFH-NEXT:    beqz s0, .LBB19_8
; RV32IZFH-NEXT:  .LBB19_4:
; RV32IZFH-NEXT:    bnez a4, .LBB19_6
; RV32IZFH-NEXT:  .LBB19_5:
; RV32IZFH-NEXT:    mv a2, a1
; RV32IZFH-NEXT:  .LBB19_6:
; RV32IZFH-NEXT:    mv a1, a2
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    flw fs0, 4(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB19_7:
; RV32IZFH-NEXT:    mv a0, a3
; RV32IZFH-NEXT:    bnez s0, .LBB19_4
; RV32IZFH-NEXT:  .LBB19_8:
; RV32IZFH-NEXT:    li a1, 0
; RV32IZFH-NEXT:    beqz a4, .LBB19_5
; RV32IZFH-NEXT:    j .LBB19_6
;
; RV64IZFH-LABEL: test_roundeven_ui64:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB19_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rne
; RV64IZFH-NEXT:  .LBB19_2:
; RV64IZFH-NEXT:    ret
  %a = call half @llvm.roundeven.f16(half %x)
  %b = call i64 @llvm.fptoui.sat.i64.f16(half %a)
  ret i64 %b
}

declare half @llvm.floor.f16(half)
declare half @llvm.ceil.f16(half)
declare half @llvm.trunc.f16(half)
declare half @llvm.round.f16(half)
declare half @llvm.roundeven.f16(half)
declare i32 @llvm.fptosi.sat.i32.f16(half)
declare i64 @llvm.fptosi.sat.i64.f16(half)
declare i32 @llvm.fptoui.sat.i32.f16(half)
declare i64 @llvm.fptoui.sat.i64.f16(half)
