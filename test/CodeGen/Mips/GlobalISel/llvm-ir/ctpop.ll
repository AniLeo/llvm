; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32

define i32 @ctpop_i32(i32 %a) {
; MIPS32-LABEL: ctpop_i32:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    srl $1, $4, 1
; MIPS32-NEXT:    lui $2, 21845
; MIPS32-NEXT:    ori $2, $2, 21845
; MIPS32-NEXT:    and $1, $1, $2
; MIPS32-NEXT:    subu $2, $4, $1
; MIPS32-NEXT:    srl $1, $2, 2
; MIPS32-NEXT:    lui $3, 13107
; MIPS32-NEXT:    ori $3, $3, 13107
; MIPS32-NEXT:    and $1, $1, $3
; MIPS32-NEXT:    and $2, $2, $3
; MIPS32-NEXT:    addu $2, $1, $2
; MIPS32-NEXT:    srl $1, $2, 4
; MIPS32-NEXT:    addu $1, $1, $2
; MIPS32-NEXT:    lui $2, 3855
; MIPS32-NEXT:    ori $2, $2, 3855
; MIPS32-NEXT:    and $1, $1, $2
; MIPS32-NEXT:    lui $2, 257
; MIPS32-NEXT:    ori $2, $2, 257
; MIPS32-NEXT:    mul $1, $1, $2
; MIPS32-NEXT:    srl $2, $1, 24
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %0
}
declare i32 @llvm.ctpop.i32(i32)


define i64 @ctpop_i64(i64 %a) {
; MIPS32-LABEL: ctpop_i64:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    srl $1, $4, 1
; MIPS32-NEXT:    lui $2, 21845
; MIPS32-NEXT:    ori $7, $2, 21845
; MIPS32-NEXT:    and $1, $1, $7
; MIPS32-NEXT:    subu $2, $4, $1
; MIPS32-NEXT:    srl $1, $2, 2
; MIPS32-NEXT:    lui $3, 13107
; MIPS32-NEXT:    ori $6, $3, 13107
; MIPS32-NEXT:    and $1, $1, $6
; MIPS32-NEXT:    and $2, $2, $6
; MIPS32-NEXT:    addu $2, $1, $2
; MIPS32-NEXT:    srl $1, $2, 4
; MIPS32-NEXT:    addu $1, $1, $2
; MIPS32-NEXT:    lui $2, 3855
; MIPS32-NEXT:    ori $4, $2, 3855
; MIPS32-NEXT:    and $1, $1, $4
; MIPS32-NEXT:    lui $2, 257
; MIPS32-NEXT:    ori $3, $2, 257
; MIPS32-NEXT:    mul $1, $1, $3
; MIPS32-NEXT:    srl $2, $1, 24
; MIPS32-NEXT:    srl $1, $5, 1
; MIPS32-NEXT:    and $1, $1, $7
; MIPS32-NEXT:    subu $5, $5, $1
; MIPS32-NEXT:    srl $1, $5, 2
; MIPS32-NEXT:    and $1, $1, $6
; MIPS32-NEXT:    and $5, $5, $6
; MIPS32-NEXT:    addu $5, $1, $5
; MIPS32-NEXT:    srl $1, $5, 4
; MIPS32-NEXT:    addu $1, $1, $5
; MIPS32-NEXT:    and $1, $1, $4
; MIPS32-NEXT:    mul $1, $1, $3
; MIPS32-NEXT:    srl $1, $1, 24
; MIPS32-NEXT:    addu $2, $1, $2
; MIPS32-NEXT:    ori $3, $zero, 0
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
entry:
  %0 = call i64 @llvm.ctpop.i64(i64 %a)
  ret i64 %0
}
declare i64 @llvm.ctpop.i64(i64)
