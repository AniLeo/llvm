; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips64-unknown-freebsd -O0 -o - %s | FileCheck %s

; Previously SelectionDAGBuilder would always set alignment to 1 for hidden sret
; parameters so we were generating ldl+ldr/lwl+lwr to load those values even
; though we know that they are aligned (since we allocated an aligned frame index)

declare dso_local void @use_sret(i32, i128, i64) unnamed_addr
declare dso_local { i32, i128, i64 } @implicit_sret_decl() unnamed_addr

define internal void @test() unnamed_addr nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %start
; CHECK-NEXT:    daddiu $sp, $sp, -48
; CHECK-NEXT:    sd $ra, 40($sp) # 8-byte Folded Spill
; CHECK-NEXT:    daddiu $4, $sp, 8
; CHECK-NEXT:    jal implicit_sret_decl
; CHECK-NEXT:    nop
; CHECK-NEXT:    ld $6, 24($sp)
; CHECK-NEXT:    ld $5, 16($sp)
; CHECK-NEXT:    ld $7, 32($sp)
; CHECK-NEXT:    lw $1, 8($sp)
; CHECK-NEXT:    # implicit-def: $v0_64
; CHECK-NEXT:    move $2, $1
; CHECK-NEXT:    move $4, $2
; CHECK-NEXT:    jal use_sret
; CHECK-NEXT:    nop
; CHECK-NEXT:    ld $ra, 40($sp) # 8-byte Folded Reload
; CHECK-NEXT:    daddiu $sp, $sp, 48
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
start:
  %0 = call { i32, i128, i64 } @implicit_sret_decl()
  %1 = extractvalue { i32, i128, i64 } %0, 0
  %2 = extractvalue { i32, i128, i64 } %0, 1
  %3 = extractvalue { i32, i128, i64 } %0, 2
  call void @use_sret(i32 %1, i128 %2, i64 %3)
  ret void
}

define internal { i32, i128, i64 } @implicit_sret_impl() unnamed_addr nounwind {
; CHECK-LABEL: implicit_sret_impl:
; CHECK:       # %bb.0:
; CHECK-NEXT:    move $1, $4
; CHECK-NEXT:    daddiu $2, $zero, 20
; CHECK-NEXT:    sd $2, 16($4)
; CHECK-NEXT:    daddiu $2, $zero, 0
; CHECK-NEXT:    sd $zero, 8($4)
; CHECK-NEXT:    daddiu $3, $zero, 30
; CHECK-NEXT:    sd $3, 24($4)
; CHECK-NEXT:    addiu $5, $zero, 10
; CHECK-NEXT:    sw $5, 0($4)
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
  ret { i32, i128, i64 } { i32 10, i128 20, i64 30 }
}

declare dso_local { i32, i32, i32, i32, i32, i32 } @implicit_sret_decl2() unnamed_addr
declare dso_local void @use_sret2(i32, i32, i32) unnamed_addr
define internal void @test2() unnamed_addr nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %start
; CHECK-NEXT:    daddiu $sp, $sp, -32
; CHECK-NEXT:    sd $ra, 24($sp) # 8-byte Folded Spill
; CHECK-NEXT:    daddiu $4, $sp, 0
; CHECK-NEXT:    jal implicit_sret_decl2
; CHECK-NEXT:    nop
; CHECK-NEXT:    lw $1, 20($sp)
; CHECK-NEXT:    lw $2, 12($sp)
; CHECK-NEXT:    lw $3, 4($sp)
; CHECK-NEXT:    # implicit-def: $a0_64
; CHECK-NEXT:    move $4, $3
; CHECK-NEXT:    # implicit-def: $a1_64
; CHECK-NEXT:    move $5, $2
; CHECK-NEXT:    # implicit-def: $a2_64
; CHECK-NEXT:    move $6, $1
; CHECK-NEXT:    jal use_sret2
; CHECK-NEXT:    nop
; CHECK-NEXT:    ld $ra, 24($sp) # 8-byte Folded Reload
; CHECK-NEXT:    daddiu $sp, $sp, 32
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
start:
  %0 = call { i32, i32, i32, i32, i32, i32 } @implicit_sret_decl2()
  %1 = extractvalue { i32, i32, i32, i32, i32, i32 } %0, 1
  %2 = extractvalue { i32, i32, i32, i32, i32, i32 } %0, 3
  %3 = extractvalue { i32, i32, i32, i32, i32, i32 } %0, 5
  call void @use_sret2(i32 %1, i32 %2, i32 %3)
  ret void
}


define internal { i32, i32, i32, i32, i32, i32 } @implicit_sret_impl2() unnamed_addr nounwind {
; CHECK-LABEL: implicit_sret_impl2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    move $1, $4
; CHECK-NEXT:    addiu $2, $zero, 6
; CHECK-NEXT:    sw $2, 20($4)
; CHECK-NEXT:    addiu $2, $zero, 5
; CHECK-NEXT:    sw $2, 16($4)
; CHECK-NEXT:    addiu $2, $zero, 4
; CHECK-NEXT:    sw $2, 12($4)
; CHECK-NEXT:    addiu $2, $zero, 3
; CHECK-NEXT:    sw $2, 8($4)
; CHECK-NEXT:    addiu $2, $zero, 2
; CHECK-NEXT:    sw $2, 4($4)
; CHECK-NEXT:    addiu $2, $zero, 1
; CHECK-NEXT:    sw $2, 0($4)
; CHECK-NEXT:    jr $ra
; CHECK-NEXT:    nop
  ret { i32, i32, i32, i32, i32, i32 } { i32 1, i32 2, i32 3, i32 4, i32 5, i32 6 }
}
