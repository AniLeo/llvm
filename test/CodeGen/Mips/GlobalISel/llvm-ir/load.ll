; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i32 @load_i32(i32* %ptr) {
; MIPS32-LABEL: load_i32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $2, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i32, i32* %ptr
  ret i32 %0
}

define i64 @load_i64(i64* %ptr) {
; MIPS32-LABEL: load_i64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $2, 0($4)
; MIPS32-NEXT:    ori $1, $zero, 4
; MIPS32-NEXT:    addu $1, $4, $1
; MIPS32-NEXT:    lw $3, 0($1)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i64, i64* %ptr
  ret i64 %0
}

define void @load_ambiguous_i64_in_fpr(i64* %i64_ptr_a, i64* %i64_ptr_b) {
; MIPS32-LABEL: load_ambiguous_i64_in_fpr:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ldc1 $f0, 0($4)
; MIPS32-NEXT:    sdc1 $f0, 0($5)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load i64, i64* %i64_ptr_a
  store i64 %0, i64* %i64_ptr_b
  ret void
}

define float @load_float(float* %ptr) {
; MIPS32-LABEL: load_float:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lwc1 $f0, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load float, float* %ptr
  ret float %0
}

define void @load_ambiguous_float_in_gpr(float* %float_ptr_a, float* %float_ptr_b) {
; MIPS32-LABEL: load_ambiguous_float_in_gpr:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lw $1, 0($4)
; MIPS32-NEXT:    sw $1, 0($5)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load float, float* %float_ptr_a
  store float %0, float* %float_ptr_b
  ret void
}

define double @load_double(double* %ptr) {
; MIPS32-LABEL: load_double:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ldc1 $f0, 0($4)
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = load double, double* %ptr
  ret double %0
}
