; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel  -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define { float, float } @add_complex_float({ float, float }* %a, { float, float }* %b) {
; MIPS32-LABEL: add_complex_float:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    lwc1 $f0, 0($4)
; MIPS32-NEXT:    lwc1 $f1, 4($4)
; MIPS32-NEXT:    lwc1 $f3, 0($5)
; MIPS32-NEXT:    lwc1 $f2, 4($5)
; MIPS32-NEXT:    add.s $f0, $f0, $f3
; MIPS32-NEXT:    add.s $f2, $f1, $f2
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %.realp = getelementptr inbounds { float, float }, { float, float }* %a, i32 0, i32 0
  %.real = load float, float* %.realp, align 4
  %.imagp = getelementptr inbounds { float, float }, { float, float }* %a, i32 0, i32 1
  %.imag = load float, float* %.imagp, align 4
  %.realp1 = getelementptr inbounds { float, float }, { float, float }* %b, i32 0, i32 0
  %.real2 = load float, float* %.realp1, align 4
  %.imagp3 = getelementptr inbounds { float, float }, { float, float }* %b, i32 0, i32 1
  %.imag4 = load float, float* %.imagp3, align 4
  %add.r = fadd float %.real, %.real2
  %add.i = fadd float %.imag, %.imag4
  %.fca.0.insert = insertvalue { float, float } undef, float %add.r, 0
  %.fca.1.insert = insertvalue { float, float } %.fca.0.insert, float %add.i, 1
  ret { float, float } %.fca.1.insert
}

define { double, double } @add_complex_double({ double, double }* %a, { double, double }* %b) {
; MIPS32-LABEL: add_complex_double:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    ldc1 $f0, 0($4)
; MIPS32-NEXT:    ldc1 $f2, 8($4)
; MIPS32-NEXT:    ldc1 $f6, 0($5)
; MIPS32-NEXT:    ldc1 $f4, 8($5)
; MIPS32-NEXT:    add.d $f0, $f0, $f6
; MIPS32-NEXT:    add.d $f2, $f2, $f4
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %.realp = getelementptr inbounds { double, double }, { double, double }* %a, i32 0, i32 0
  %.real = load double, double* %.realp, align 8
  %.imagp = getelementptr inbounds { double, double }, { double, double }* %a, i32 0, i32 1
  %.imag = load double, double* %.imagp, align 8
  %.realp1 = getelementptr inbounds { double, double }, { double, double }* %b, i32 0, i32 0
  %.real2 = load double, double* %.realp1, align 8
  %.imagp3 = getelementptr inbounds { double, double }, { double, double }* %b, i32 0, i32 1
  %.imag4 = load double, double* %.imagp3, align 8
  %add.r = fadd double %.real, %.real2
  %add.i = fadd double %.imag, %.imag4
  %.fca.0.insert = insertvalue { double, double } undef, double %add.r, 0
  %.fca.1.insert = insertvalue { double, double } %.fca.0.insert, double %add.i, 1
  ret { double, double } %.fca.1.insert
}

declare { float, float } @ret_complex_float()
define void @call_ret_complex_float({ float, float }* %z) {
; MIPS32-LABEL: call_ret_complex_float:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    jal ret_complex_float
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $4, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    swc1 $f0, 0($4)
; MIPS32-NEXT:    swc1 $f2, 4($4)
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %call = call { float, float } @ret_complex_float()
  %0 = extractvalue { float, float } %call, 0
  %1 = extractvalue { float, float } %call, 1
  %.realp = getelementptr inbounds { float, float }, { float, float }* %z, i32 0, i32 0
  %.imagp = getelementptr inbounds { float, float }, { float, float }* %z, i32 0, i32 1
  store float %0, float* %.realp, align 4
  store float %1, float* %.imagp, align 4
  ret void
}

declare { double, double } @ret_complex_double()
define void @call_ret_complex_double({ double, double }* %z) {
; MIPS32-LABEL: call_ret_complex_double:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    sw $4, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    jal ret_complex_double
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $4, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    sdc1 $f0, 0($4)
; MIPS32-NEXT:    sdc1 $f2, 8($4)
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %call = call { double, double } @ret_complex_double()
  %0 = extractvalue { double, double } %call, 0
  %1 = extractvalue { double, double } %call, 1
  %.realp = getelementptr inbounds { double, double }, { double, double }* %z, i32 0, i32 0
  %.imagp = getelementptr inbounds { double, double }, { double, double }* %z, i32 0, i32 1
  store double %0, double* %.realp, align 8
  store double %1, double* %.imagp, align 8
  ret void
}
