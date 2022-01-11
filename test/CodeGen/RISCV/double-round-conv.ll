; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32d | FileCheck -check-prefix=RV32IFD %s
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64d | FileCheck -check-prefix=RV64IFD %s

define signext i8 @test_floor_si8(double %x) {
; RV32IFD-LABEL: test_floor_si8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_si8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptosi double %a to i8
  ret i8 %b
}

define signext i16 @test_floor_si16(double %x) {
; RV32IFD-LABEL: test_floor_si16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_si16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptosi double %a to i16
  ret i16 %b
}

define signext i32 @test_floor_si32(double %x) {
; RV32IFD-LABEL: test_floor_si32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_si32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.w.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptosi double %a to i32
  ret i32 %b
}

define i64 @test_floor_si64(double %x) {
; RV32IFD-LABEL: test_floor_si64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call floor@plt
; RV32IFD-NEXT:    call __fixdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_si64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptosi double %a to i64
  ret i64 %b
}

define zeroext i8 @test_floor_ui8(double %x) {
; RV32IFD-LABEL: test_floor_ui8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_ui8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptoui double %a to i8
  ret i8 %b
}

define zeroext i16 @test_floor_ui16(double %x) {
; RV32IFD-LABEL: test_floor_ui16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_ui16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptoui double %a to i16
  ret i16 %b
}

define signext i32 @test_floor_ui32(double %x) {
; RV32IFD-LABEL: test_floor_ui32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rdn
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_ui32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.wu.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptoui double %a to i32
  ret i32 %b
}

define i64 @test_floor_ui64(double %x) {
; RV32IFD-LABEL: test_floor_ui64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call floor@plt
; RV32IFD-NEXT:    call __fixunsdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_floor_ui64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rdn
; RV64IFD-NEXT:    ret
  %a = call double @llvm.floor.f64(double %x)
  %b = fptoui double %a to i64
  ret i64 %b
}

define signext i8 @test_ceil_si8(double %x) {
; RV32IFD-LABEL: test_ceil_si8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_si8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptosi double %a to i8
  ret i8 %b
}

define signext i16 @test_ceil_si16(double %x) {
; RV32IFD-LABEL: test_ceil_si16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_si16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptosi double %a to i16
  ret i16 %b
}

define signext i32 @test_ceil_si32(double %x) {
; RV32IFD-LABEL: test_ceil_si32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_si32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.w.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptosi double %a to i32
  ret i32 %b
}

define i64 @test_ceil_si64(double %x) {
; RV32IFD-LABEL: test_ceil_si64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call ceil@plt
; RV32IFD-NEXT:    call __fixdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_si64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptosi double %a to i64
  ret i64 %b
}

define zeroext i8 @test_ceil_ui8(double %x) {
; RV32IFD-LABEL: test_ceil_ui8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_ui8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptoui double %a to i8
  ret i8 %b
}

define zeroext i16 @test_ceil_ui16(double %x) {
; RV32IFD-LABEL: test_ceil_ui16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_ui16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptoui double %a to i16
  ret i16 %b
}

define signext i32 @test_ceil_ui32(double %x) {
; RV32IFD-LABEL: test_ceil_ui32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rup
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_ui32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.wu.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptoui double %a to i32
  ret i32 %b
}

define i64 @test_ceil_ui64(double %x) {
; RV32IFD-LABEL: test_ceil_ui64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call ceil@plt
; RV32IFD-NEXT:    call __fixunsdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_ceil_ui64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rup
; RV64IFD-NEXT:    ret
  %a = call double @llvm.ceil.f64(double %x)
  %b = fptoui double %a to i64
  ret i64 %b
}

define signext i8 @test_trunc_si8(double %x) {
; RV32IFD-LABEL: test_trunc_si8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_si8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptosi double %a to i8
  ret i8 %b
}

define signext i16 @test_trunc_si16(double %x) {
; RV32IFD-LABEL: test_trunc_si16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_si16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptosi double %a to i16
  ret i16 %b
}

define signext i32 @test_trunc_si32(double %x) {
; RV32IFD-LABEL: test_trunc_si32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_si32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.w.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptosi double %a to i32
  ret i32 %b
}

define i64 @test_trunc_si64(double %x) {
; RV32IFD-LABEL: test_trunc_si64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call trunc@plt
; RV32IFD-NEXT:    call __fixdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_si64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptosi double %a to i64
  ret i64 %b
}

define zeroext i8 @test_trunc_ui8(double %x) {
; RV32IFD-LABEL: test_trunc_ui8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_ui8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptoui double %a to i8
  ret i8 %b
}

define zeroext i16 @test_trunc_ui16(double %x) {
; RV32IFD-LABEL: test_trunc_ui16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_ui16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptoui double %a to i16
  ret i16 %b
}

define signext i32 @test_trunc_ui32(double %x) {
; RV32IFD-LABEL: test_trunc_ui32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rtz
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_ui32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.wu.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptoui double %a to i32
  ret i32 %b
}

define i64 @test_trunc_ui64(double %x) {
; RV32IFD-LABEL: test_trunc_ui64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call trunc@plt
; RV32IFD-NEXT:    call __fixunsdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_trunc_ui64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rtz
; RV64IFD-NEXT:    ret
  %a = call double @llvm.trunc.f64(double %x)
  %b = fptoui double %a to i64
  ret i64 %b
}

define signext i8 @test_round_si8(double %x) {
; RV32IFD-LABEL: test_round_si8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_si8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptosi double %a to i8
  ret i8 %b
}

define signext i16 @test_round_si16(double %x) {
; RV32IFD-LABEL: test_round_si16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_si16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptosi double %a to i16
  ret i16 %b
}

define signext i32 @test_round_si32(double %x) {
; RV32IFD-LABEL: test_round_si32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_si32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.w.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptosi double %a to i32
  ret i32 %b
}

define i64 @test_round_si64(double %x) {
; RV32IFD-LABEL: test_round_si64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call round@plt
; RV32IFD-NEXT:    call __fixdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_si64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptosi double %a to i64
  ret i64 %b
}

define zeroext i8 @test_round_ui8(double %x) {
; RV32IFD-LABEL: test_round_ui8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_ui8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptoui double %a to i8
  ret i8 %b
}

define zeroext i16 @test_round_ui16(double %x) {
; RV32IFD-LABEL: test_round_ui16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_ui16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptoui double %a to i16
  ret i16 %b
}

define signext i32 @test_round_ui32(double %x) {
; RV32IFD-LABEL: test_round_ui32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rmm
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_ui32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.wu.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptoui double %a to i32
  ret i32 %b
}

define i64 @test_round_ui64(double %x) {
; RV32IFD-LABEL: test_round_ui64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call round@plt
; RV32IFD-NEXT:    call __fixunsdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_round_ui64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rmm
; RV64IFD-NEXT:    ret
  %a = call double @llvm.round.f64(double %x)
  %b = fptoui double %a to i64
  ret i64 %b
}

define signext i8 @test_roundeven_si8(double %x) {
; RV32IFD-LABEL: test_roundeven_si8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_si8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptosi double %a to i8
  ret i8 %b
}

define signext i16 @test_roundeven_si16(double %x) {
; RV32IFD-LABEL: test_roundeven_si16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_si16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptosi double %a to i16
  ret i16 %b
}

define signext i32 @test_roundeven_si32(double %x) {
; RV32IFD-LABEL: test_roundeven_si32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.w.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_si32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.w.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptosi double %a to i32
  ret i32 %b
}

define i64 @test_roundeven_si64(double %x) {
; RV32IFD-LABEL: test_roundeven_si64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call roundeven@plt
; RV32IFD-NEXT:    call __fixdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_si64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.l.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptosi double %a to i64
  ret i64 %b
}

define zeroext i8 @test_roundeven_ui8(double %x) {
; RV32IFD-LABEL: test_roundeven_ui8:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_ui8:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptoui double %a to i8
  ret i8 %b
}

define zeroext i16 @test_roundeven_ui16(double %x) {
; RV32IFD-LABEL: test_roundeven_ui16:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_ui16:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptoui double %a to i16
  ret i16 %b
}

define signext i32 @test_roundeven_ui32(double %x) {
; RV32IFD-LABEL: test_roundeven_ui32:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.wu.d a0, fa0, rne
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_ui32:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.wu.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptoui double %a to i32
  ret i32 %b
}

define i64 @test_roundeven_ui64(double %x) {
; RV32IFD-LABEL: test_roundeven_ui64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    .cfi_def_cfa_offset 16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    .cfi_offset ra, -4
; RV32IFD-NEXT:    call roundeven@plt
; RV32IFD-NEXT:    call __fixunsdfdi@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: test_roundeven_ui64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.lu.d a0, fa0, rne
; RV64IFD-NEXT:    ret
  %a = call double @llvm.roundeven.f64(double %x)
  %b = fptoui double %a to i64
  ret i64 %b
}

declare double @llvm.floor.f64(double)
declare double @llvm.ceil.f64(double)
declare double @llvm.trunc.f64(double)
declare double @llvm.round.f64(double)
declare double @llvm.roundeven.f64(double)
