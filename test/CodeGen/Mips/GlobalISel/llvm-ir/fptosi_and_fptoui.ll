; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32,FP32
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -mattr=+fp64,+mips32r2 -global-isel -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32,FP64

define i64 @f32toi64(float %a) {
; MIPS32-LABEL: f32toi64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    jal __fixsfdi
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi float %a to i64
  ret i64 %conv
}

define i32 @f32toi32(float %a) {
; MIPS32-LABEL: f32toi32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $2, $f0
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi float %a to i32
  ret i32 %conv
}

define signext i16 @f32toi16(float %a) {
; MIPS32-LABEL: f32toi16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    sll $1, $1, 16
; MIPS32-NEXT:    sra $2, $1, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi float %a to i16
  ret i16 %conv
}

define signext i8 @f32toi8(float %a) {
; MIPS32-LABEL: f32toi8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    sll $1, $1, 24
; MIPS32-NEXT:    sra $2, $1, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi float %a to i8
  ret i8 %conv
}

define i64 @f64toi64(double %a) {
; MIPS32-LABEL: f64toi64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    jal __fixdfdi
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi double %a to i64
  ret i64 %conv
}

define i32 @f64toi32(double %a) {
; MIPS32-LABEL: f64toi32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.d $f0, $f12
; MIPS32-NEXT:    mfc1 $2, $f0
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi double %a to i32
  ret i32 %conv
}

define signext i16 @f64toi16(double %a) {
; MIPS32-LABEL: f64toi16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.d $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    sll $1, $1, 16
; MIPS32-NEXT:    sra $2, $1, 16
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi double %a to i16
  ret i16 %conv
}

define signext i8 @f64toi8(double %a) {
; MIPS32-LABEL: f64toi8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.d $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    sll $1, $1, 24
; MIPS32-NEXT:    sra $2, $1, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptosi double %a to i8
  ret i8 %conv
}

define i64 @f32tou64(float %a) {
; MIPS32-LABEL: f32tou64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    jal __fixunssfdi
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptoui float %a to i64
  ret i64 %conv
}

define i32 @f32tou32(float %a) {
; MIPS32-LABEL: f32tou32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    lui $2, 20224
; MIPS32-NEXT:    mtc1 $2, $f0
; MIPS32-NEXT:    sub.s $f1, $f12, $f0
; MIPS32-NEXT:    trunc.w.s $f1, $f1
; MIPS32-NEXT:    mfc1 $2, $f1
; MIPS32-NEXT:    lui $3, 32768
; MIPS32-NEXT:    xor $2, $2, $3
; MIPS32-NEXT:    addiu $3, $zero, 1
; MIPS32-NEXT:    c.ult.s $f12, $f0
; MIPS32-NEXT:    movf $3, $zero, $fcc0
; MIPS32-NEXT:    andi $3, $3, 1
; MIPS32-NEXT:    movn $2, $1, $3
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptoui float %a to i32
  ret i32 %conv
}

define zeroext i16 @f32tou16(float %a) {
; MIPS32-LABEL: f32tou16:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    lui $2, 20224
; MIPS32-NEXT:    mtc1 $2, $f0
; MIPS32-NEXT:    sub.s $f1, $f12, $f0
; MIPS32-NEXT:    trunc.w.s $f1, $f1
; MIPS32-NEXT:    mfc1 $2, $f1
; MIPS32-NEXT:    lui $3, 32768
; MIPS32-NEXT:    xor $2, $2, $3
; MIPS32-NEXT:    addiu $3, $zero, 1
; MIPS32-NEXT:    c.ult.s $f12, $f0
; MIPS32-NEXT:    movf $3, $zero, $fcc0
; MIPS32-NEXT:    andi $3, $3, 1
; MIPS32-NEXT:    movn $2, $1, $3
; MIPS32-NEXT:    andi $2, $2, 65535
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptoui float %a to i16
  ret i16 %conv
}

define zeroext i8 @f32tou8(float %a) {
; MIPS32-LABEL: f32tou8:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    trunc.w.s $f0, $f12
; MIPS32-NEXT:    mfc1 $1, $f0
; MIPS32-NEXT:    lui $2, 20224
; MIPS32-NEXT:    mtc1 $2, $f0
; MIPS32-NEXT:    sub.s $f1, $f12, $f0
; MIPS32-NEXT:    trunc.w.s $f1, $f1
; MIPS32-NEXT:    mfc1 $2, $f1
; MIPS32-NEXT:    lui $3, 32768
; MIPS32-NEXT:    xor $2, $2, $3
; MIPS32-NEXT:    addiu $3, $zero, 1
; MIPS32-NEXT:    c.ult.s $f12, $f0
; MIPS32-NEXT:    movf $3, $zero, $fcc0
; MIPS32-NEXT:    andi $3, $3, 1
; MIPS32-NEXT:    movn $2, $1, $3
; MIPS32-NEXT:    andi $2, $2, 255
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptoui float %a to i8
  ret i8 %conv
}

define i64 @f64tou64(double %a) {
; MIPS32-LABEL: f64tou64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -24
; MIPS32-NEXT:    .cfi_def_cfa_offset 24
; MIPS32-NEXT:    sw $ra, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    .cfi_offset 31, -4
; MIPS32-NEXT:    jal __fixunsdfdi
; MIPS32-NEXT:    nop
; MIPS32-NEXT:    lw $ra, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %conv = fptoui double %a to i64
  ret i64 %conv
}

define i32 @f64tou32(double %a) {
; FP32-LABEL: f64tou32:
; FP32:       # %bb.0: # %entry
; FP32-NEXT:    trunc.w.d $f0, $f12
; FP32-NEXT:    mfc1 $1, $f0
; FP32-NEXT:    lui $2, 16864
; FP32-NEXT:    ori $3, $zero, 0
; FP32-NEXT:    mtc1 $3, $f2
; FP32-NEXT:    mtc1 $2, $f3
; FP32-NEXT:    sub.d $f4, $f12, $f2
; FP32-NEXT:    trunc.w.d $f0, $f4
; FP32-NEXT:    mfc1 $2, $f0
; FP32-NEXT:    lui $3, 32768
; FP32-NEXT:    xor $2, $2, $3
; FP32-NEXT:    addiu $3, $zero, 1
; FP32-NEXT:    c.ult.d $f12, $f2
; FP32-NEXT:    movf $3, $zero, $fcc0
; FP32-NEXT:    andi $3, $3, 1
; FP32-NEXT:    movn $2, $1, $3
; FP32-NEXT:    jr $ra
; FP32-NEXT:    nop
;
; FP64-LABEL: f64tou32:
; FP64:       # %bb.0: # %entry
; FP64-NEXT:    trunc.w.d $f0, $f12
; FP64-NEXT:    mfc1 $1, $f0
; FP64-NEXT:    lui $2, 16864
; FP64-NEXT:    ori $3, $zero, 0
; FP64-NEXT:    mtc1 $3, $f1
; FP64-NEXT:    mthc1 $2, $f1
; FP64-NEXT:    sub.d $f2, $f12, $f1
; FP64-NEXT:    trunc.w.d $f0, $f2
; FP64-NEXT:    mfc1 $2, $f0
; FP64-NEXT:    lui $3, 32768
; FP64-NEXT:    xor $2, $2, $3
; FP64-NEXT:    addiu $3, $zero, 1
; FP64-NEXT:    c.ult.d $f12, $f1
; FP64-NEXT:    movf $3, $zero, $fcc0
; FP64-NEXT:    andi $3, $3, 1
; FP64-NEXT:    movn $2, $1, $3
; FP64-NEXT:    jr $ra
; FP64-NEXT:    nop
entry:
  %conv = fptoui double %a to i32
  ret i32 %conv
}

define zeroext i16 @f64tou16(double %a) {
; FP32-LABEL: f64tou16:
; FP32:       # %bb.0: # %entry
; FP32-NEXT:    trunc.w.d $f0, $f12
; FP32-NEXT:    mfc1 $1, $f0
; FP32-NEXT:    lui $2, 16864
; FP32-NEXT:    ori $3, $zero, 0
; FP32-NEXT:    mtc1 $3, $f2
; FP32-NEXT:    mtc1 $2, $f3
; FP32-NEXT:    sub.d $f4, $f12, $f2
; FP32-NEXT:    trunc.w.d $f0, $f4
; FP32-NEXT:    mfc1 $2, $f0
; FP32-NEXT:    lui $3, 32768
; FP32-NEXT:    xor $2, $2, $3
; FP32-NEXT:    addiu $3, $zero, 1
; FP32-NEXT:    c.ult.d $f12, $f2
; FP32-NEXT:    movf $3, $zero, $fcc0
; FP32-NEXT:    andi $3, $3, 1
; FP32-NEXT:    movn $2, $1, $3
; FP32-NEXT:    andi $2, $2, 65535
; FP32-NEXT:    jr $ra
; FP32-NEXT:    nop
;
; FP64-LABEL: f64tou16:
; FP64:       # %bb.0: # %entry
; FP64-NEXT:    trunc.w.d $f0, $f12
; FP64-NEXT:    mfc1 $1, $f0
; FP64-NEXT:    lui $2, 16864
; FP64-NEXT:    ori $3, $zero, 0
; FP64-NEXT:    mtc1 $3, $f1
; FP64-NEXT:    mthc1 $2, $f1
; FP64-NEXT:    sub.d $f2, $f12, $f1
; FP64-NEXT:    trunc.w.d $f0, $f2
; FP64-NEXT:    mfc1 $2, $f0
; FP64-NEXT:    lui $3, 32768
; FP64-NEXT:    xor $2, $2, $3
; FP64-NEXT:    addiu $3, $zero, 1
; FP64-NEXT:    c.ult.d $f12, $f1
; FP64-NEXT:    movf $3, $zero, $fcc0
; FP64-NEXT:    andi $3, $3, 1
; FP64-NEXT:    movn $2, $1, $3
; FP64-NEXT:    andi $2, $2, 65535
; FP64-NEXT:    jr $ra
; FP64-NEXT:    nop
entry:
  %conv = fptoui double %a to i16
  ret i16 %conv
}

define zeroext i8 @f64tou8(double %a) {
; FP32-LABEL: f64tou8:
; FP32:       # %bb.0: # %entry
; FP32-NEXT:    trunc.w.d $f0, $f12
; FP32-NEXT:    mfc1 $1, $f0
; FP32-NEXT:    lui $2, 16864
; FP32-NEXT:    ori $3, $zero, 0
; FP32-NEXT:    mtc1 $3, $f2
; FP32-NEXT:    mtc1 $2, $f3
; FP32-NEXT:    sub.d $f4, $f12, $f2
; FP32-NEXT:    trunc.w.d $f0, $f4
; FP32-NEXT:    mfc1 $2, $f0
; FP32-NEXT:    lui $3, 32768
; FP32-NEXT:    xor $2, $2, $3
; FP32-NEXT:    addiu $3, $zero, 1
; FP32-NEXT:    c.ult.d $f12, $f2
; FP32-NEXT:    movf $3, $zero, $fcc0
; FP32-NEXT:    andi $3, $3, 1
; FP32-NEXT:    movn $2, $1, $3
; FP32-NEXT:    andi $2, $2, 255
; FP32-NEXT:    jr $ra
; FP32-NEXT:    nop
;
; FP64-LABEL: f64tou8:
; FP64:       # %bb.0: # %entry
; FP64-NEXT:    trunc.w.d $f0, $f12
; FP64-NEXT:    mfc1 $1, $f0
; FP64-NEXT:    lui $2, 16864
; FP64-NEXT:    ori $3, $zero, 0
; FP64-NEXT:    mtc1 $3, $f1
; FP64-NEXT:    mthc1 $2, $f1
; FP64-NEXT:    sub.d $f2, $f12, $f1
; FP64-NEXT:    trunc.w.d $f0, $f2
; FP64-NEXT:    mfc1 $2, $f0
; FP64-NEXT:    lui $3, 32768
; FP64-NEXT:    xor $2, $2, $3
; FP64-NEXT:    addiu $3, $zero, 1
; FP64-NEXT:    c.ult.d $f12, $f1
; FP64-NEXT:    movf $3, $zero, $fcc0
; FP64-NEXT:    andi $3, $3, 1
; FP64-NEXT:    movn $2, $1, $3
; FP64-NEXT:    andi $2, $2, 255
; FP64-NEXT:    jr $ra
; FP64-NEXT:    nop
entry:
  %conv = fptoui double %a to i8
  ret i8 %conv
}
