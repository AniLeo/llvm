; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips-mti-linux-gnu -mcpu=mips32r2 < %s -asm-show-inst | FileCheck %s --check-prefix=MIPS32
; RUN: llc -mtriple=mips-mti-linux-gnu -mcpu=mips32r2 -mattr=+micromips < %s -asm-show-inst | FileCheck %s --check-prefix=MMR3
; RUN: llc -mtriple=mips-img-linux-gnu -mcpu=mips32r6 < %s -asm-show-inst | FileCheck %s --check-prefix=MIPS32R6
; RUN: llc -mtriple=mips-img-linux-gnu -mcpu=mips32r6 -mattr=+micromips < %s -asm-show-inst | FileCheck %s --check-prefix=MMR6
; RUN: llc -mtriple=mips64-mti-linux-gnu -mcpu=mips4 < %s -asm-show-inst | FileCheck %s --check-prefix=MIPS4
; RUN: llc -mtriple=mips64-img-linux-gnu -mcpu=mips64r6 < %s -asm-show-inst | FileCheck %s --check-prefix=MIPS64R6

; Test subword and word stores.

@a = common global i8 0, align 4
@b = common global i16 0, align 4
@c = common global i32 0, align 4
@d = common global i64 0, align 8

define void @f1(i8 %a) {
; MIPS32-LABEL: f1:
; MIPS32:       # %bb.0:
; MIPS32-NEXT:    lui $1, %hi(a) # <MCInst #{{[0-9]+}} LUi
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MIPS32-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%lo(a))>>
;
; MMR3-LABEL: f1:
; MMR3:       # %bb.0:
; MMR3-NEXT:    lui $1, %hi(a) # <MCInst #{{[0-9]+}} LUi
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MMR3-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MMR3-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%lo(a))>>
;
; MIPS32R6-LABEL: f1:
; MIPS32R6:       # %bb.0:
; MIPS32R6-NEXT:    lui $1, %hi(a) # <MCInst #{{[0-9]+}} LUi
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MIPS32R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32R6-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%lo(a))>>
;
; MMR6-LABEL: f1:
; MMR6:       # %bb.0:
; MMR6-NEXT:    lui $1, %hi(a) # <MCInst #{{[0-9]+}} LUi
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MMR6-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%lo(a))>>
; MMR6-NEXT:    jrc $ra # <MCInst #{{[0-9]+}} JRC16_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
;
; MIPS4-LABEL: f1:
; MIPS4:       # %bb.0:
; MIPS4-NEXT:    lui $1, %highest(a) # <MCInst #{{[0-9]+}} LUi64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%highest(a))>>
; MIPS4-NEXT:    daddiu $1, $1, %higher(a) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%higher(a))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    daddiu $1, $1, %hi(a) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS4-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%lo(a))>>
;
; MIPS64R6-LABEL: f1:
; MIPS64R6:       # %bb.0:
; MIPS64R6-NEXT:    lui $1, %highest(a) # <MCInst #{{[0-9]+}} LUi64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%highest(a))>>
; MIPS64R6-NEXT:    daddiu $1, $1, %higher(a) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%higher(a))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    daddiu $1, $1, %hi(a) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%hi(a))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS64R6-NEXT:    sb $4, %lo(a)($1) # <MCInst #{{[0-9]+}} SB64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%lo(a))>>
  store i8 %a, i8 * @a
  ret void
}

define void @f2(i16 %a) {
; MIPS32-LABEL: f2:
; MIPS32:       # %bb.0:
; MIPS32-NEXT:    lui $1, %hi(b) # <MCInst #{{[0-9]+}} LUi
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MIPS32-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%lo(b))>>
;
; MMR3-LABEL: f2:
; MMR3:       # %bb.0:
; MMR3-NEXT:    lui $1, %hi(b) # <MCInst #{{[0-9]+}} LUi
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MMR3-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MMR3-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%lo(b))>>
;
; MIPS32R6-LABEL: f2:
; MIPS32R6:       # %bb.0:
; MIPS32R6-NEXT:    lui $1, %hi(b) # <MCInst #{{[0-9]+}} LUi
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MIPS32R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32R6-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%lo(b))>>
;
; MMR6-LABEL: f2:
; MMR6:       # %bb.0:
; MMR6-NEXT:    lui $1, %hi(b) # <MCInst #{{[0-9]+}} LUi
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MMR6-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%lo(b))>>
; MMR6-NEXT:    jrc $ra # <MCInst #{{[0-9]+}} JRC16_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
;
; MIPS4-LABEL: f2:
; MIPS4:       # %bb.0:
; MIPS4-NEXT:    lui $1, %highest(b) # <MCInst #{{[0-9]+}} LUi64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%highest(b))>>
; MIPS4-NEXT:    daddiu $1, $1, %higher(b) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%higher(b))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    daddiu $1, $1, %hi(b) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS4-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%lo(b))>>
;
; MIPS64R6-LABEL: f2:
; MIPS64R6:       # %bb.0:
; MIPS64R6-NEXT:    lui $1, %highest(b) # <MCInst #{{[0-9]+}} LUi64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%highest(b))>>
; MIPS64R6-NEXT:    daddiu $1, $1, %higher(b) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%higher(b))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    daddiu $1, $1, %hi(b) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%hi(b))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS64R6-NEXT:    sh $4, %lo(b)($1) # <MCInst #{{[0-9]+}} SH64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%lo(b))>>
  store i16 %a, i16 * @b
  ret void
}

define void @f3(i32 %a) {
; MIPS32-LABEL: f3:
; MIPS32:       # %bb.0:
; MIPS32-NEXT:    lui $1, %hi(c) # <MCInst #{{[0-9]+}} LUi
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MIPS32-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%lo(c))>>
;
; MMR3-LABEL: f3:
; MMR3:       # %bb.0:
; MMR3-NEXT:    lui $1, %hi(c) # <MCInst #{{[0-9]+}} LUi
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MMR3-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MMR3-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%lo(c))>>
;
; MIPS32R6-LABEL: f3:
; MIPS32R6:       # %bb.0:
; MIPS32R6-NEXT:    lui $1, %hi(c) # <MCInst #{{[0-9]+}} LUi
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MIPS32R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32R6-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%lo(c))>>
;
; MMR6-LABEL: f3:
; MMR6:       # %bb.0:
; MMR6-NEXT:    lui $1, %hi(c) # <MCInst #{{[0-9]+}} LUi
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MMR6-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%lo(c))>>
; MMR6-NEXT:    jrc $ra # <MCInst #{{[0-9]+}} JRC16_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
;
; MIPS4-LABEL: f3:
; MIPS4:       # %bb.0:
; MIPS4-NEXT:    lui $1, %highest(c) # <MCInst #{{[0-9]+}} LUi64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%highest(c))>>
; MIPS4-NEXT:    daddiu $1, $1, %higher(c) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%higher(c))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    daddiu $1, $1, %hi(c) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS4-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%lo(c))>>
;
; MIPS64R6-LABEL: f3:
; MIPS64R6:       # %bb.0:
; MIPS64R6-NEXT:    lui $1, %highest(c) # <MCInst #{{[0-9]+}} LUi64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%highest(c))>>
; MIPS64R6-NEXT:    daddiu $1, $1, %higher(c) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%higher(c))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    daddiu $1, $1, %hi(c) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%hi(c))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS64R6-NEXT:    sw $4, %lo(c)($1) # <MCInst #{{[0-9]+}} SW
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%lo(c))>>
  store i32 %a, i32 * @c
  ret void
}

define void @f4(i64 %a) {
; MIPS32-LABEL: f4:
; MIPS32:       # %bb.0:
; MIPS32-NEXT:    lui $1, %hi(d) # <MCInst #{{[0-9]+}} LUi
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MIPS32-NEXT:    sw $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SW
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MIPS32-NEXT:    addiu $1, $1, %lo(d) # <MCInst #{{[0-9]+}} ADDiu
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MIPS32-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32-NEXT:    sw $5, 4($1) # <MCInst #{{[0-9]+}} SW
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32-NEXT:    # <MCOperand Imm:4>>
;
; MMR3-LABEL: f4:
; MMR3:       # %bb.0:
; MMR3-NEXT:    lui $1, %hi(d) # <MCInst #{{[0-9]+}} LUi
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MMR3-NEXT:    sw $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SW_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MMR3-NEXT:    addiu $2, $1, %lo(d) # <MCInst #{{[0-9]+}} ADDiu
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MMR3-NEXT:    sw16 $5, 4($2) # <MCInst #{{[0-9]+}} SW16_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR3-NEXT:    # <MCOperand Imm:4>>
; MMR3-NEXT:    jrc $ra # <MCInst #{{[0-9]+}} JRC16_MM
; MMR3-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
;
; MIPS32R6-LABEL: f4:
; MIPS32R6:       # %bb.0:
; MIPS32R6-NEXT:    lui $1, %hi(d) # <MCInst #{{[0-9]+}} LUi
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MIPS32R6-NEXT:    sw $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SW
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MIPS32R6-NEXT:    addiu $1, $1, %lo(d) # <MCInst #{{[0-9]+}} ADDiu
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MIPS32R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS32R6-NEXT:    sw $5, 4($1) # <MCInst #{{[0-9]+}} SW
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS32R6-NEXT:    # <MCOperand Imm:4>>
;
; MMR6-LABEL: f4:
; MMR6:       # %bb.0:
; MMR6-NEXT:    lui $1, %hi(d) # <MCInst #{{[0-9]+}} LUi
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MMR6-NEXT:    sw $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SW_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MMR6-NEXT:    addiu $2, $1, %lo(d) # <MCInst #{{[0-9]+}} ADDiu
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Expr:(%lo(d))>>
; MMR6-NEXT:    sw16 $5, 4($2) # <MCInst #{{[0-9]+}} SW16_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MMR6-NEXT:    # <MCOperand Imm:4>>
; MMR6-NEXT:    jrc $ra # <MCInst #{{[0-9]+}} JRC16_MM
; MMR6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
;
; MIPS4-LABEL: f4:
; MIPS4:       # %bb.0:
; MIPS4-NEXT:    lui $1, %highest(d) # <MCInst #{{[0-9]+}} LUi64
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%highest(d))>>
; MIPS4-NEXT:    daddiu $1, $1, %higher(d) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%higher(d))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    daddiu $1, $1, %hi(d) # <MCInst #{{[0-9]+}} DADDiu
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MIPS4-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Imm:16>>
; MIPS4-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JR
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS4-NEXT:    sd $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SD
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS4-NEXT:    # <MCOperand Expr:(%lo(d))>>
;
; MIPS64R6-LABEL: f4:
; MIPS64R6:       # %bb.0:
; MIPS64R6-NEXT:    lui $1, %highest(d) # <MCInst #{{[0-9]+}} LUi64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%highest(d))>>
; MIPS64R6-NEXT:    daddiu $1, $1, %higher(d) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%higher(d))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    daddiu $1, $1, %hi(d) # <MCInst #{{[0-9]+}} DADDiu
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%hi(d))>>
; MIPS64R6-NEXT:    dsll $1, $1, 16 # <MCInst #{{[0-9]+}} DSLL
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Imm:16>>
; MIPS64R6-NEXT:    jr $ra # <MCInst #{{[0-9]+}} JALR64
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>>
; MIPS64R6-NEXT:    sd $4, %lo(d)($1) # <MCInst #{{[0-9]+}} SD
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Reg:{{[0-9]+}}>
; MIPS64R6-NEXT:    # <MCOperand Expr:(%lo(d))>>
  store i64 %a, i64 * @d
  ret void
}
