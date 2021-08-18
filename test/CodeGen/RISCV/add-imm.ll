; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; These test how the immediate in an addition is materialized.

define i32 @add_positive_low_bound_reject(i32 %a) nounwind {
; RV32I-LABEL: add_positive_low_bound_reject:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 2047
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_positive_low_bound_reject:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    ret
  %1 = add i32 %a, 2047
  ret i32 %1
}

define i32 @add_positive_low_bound_accept(i32 %a) nounwind {
; RV32I-LABEL: add_positive_low_bound_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1024
; RV32I-NEXT:    addi a0, a0, 1024
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_positive_low_bound_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 1024
; RV64I-NEXT:    addi a0, a0, 1024
; RV64I-NEXT:    ret
  %1 = add i32 %a, 2048
  ret i32 %1
}

define i32 @add_positive_high_bound_accept(i32 %a) nounwind {
; RV32I-LABEL: add_positive_high_bound_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 2047
; RV32I-NEXT:    addi a0, a0, 2047
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_positive_high_bound_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    addi a0, a0, 2047
; RV64I-NEXT:    ret
  %1 = add i32 %a, 4094
  ret i32 %1
}

define i32 @add_positive_high_bound_reject(i32 %a) nounwind {
; RV32I-LABEL: add_positive_high_bound_reject:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_positive_high_bound_reject:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
  %1 = add i32 %a, 4095
  ret i32 %1
}

define i32 @add_negative_high_bound_reject(i32 %a) nounwind {
; RV32I-LABEL: add_negative_high_bound_reject:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, -2048
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_negative_high_bound_reject:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, -2048
; RV64I-NEXT:    ret
  %1 = add i32 %a, -2048
  ret i32 %1
}

define i32 @add_negative_high_bound_accept(i32 %a) nounwind {
; RV32I-LABEL: add_negative_high_bound_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, -1025
; RV32I-NEXT:    addi a0, a0, -1024
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_negative_high_bound_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, -1025
; RV64I-NEXT:    addi a0, a0, -1024
; RV64I-NEXT:    ret
  %1 = add i32 %a, -2049
  ret i32 %1
}

define i32 @add_negative_low_bound_accept(i32 %a) nounwind {
; RV32I-LABEL: add_negative_low_bound_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, -2048
; RV32I-NEXT:    addi a0, a0, -2048
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_negative_low_bound_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, -2048
; RV64I-NEXT:    addi a0, a0, -2048
; RV64I-NEXT:    ret
  %1 = add i32 %a, -4096
  ret i32 %1
}

define i32 @add_negative_low_bound_reject(i32 %a) nounwind {
; RV32I-LABEL: add_negative_low_bound_reject:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1048575
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add_negative_low_bound_reject:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1048575
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    ret
  %1 = add i32 %a, -4097
  ret i32 %1
}

define i32 @add32_accept(i32 %a) nounwind {
; RV32I-LABEL: add32_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1500
; RV32I-NEXT:    addi a0, a0, 1499
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add32_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 1500
; RV64I-NEXT:    addi a0, a0, 1499
; RV64I-NEXT:    ret
  %1 = add i32 %a, 2999
  ret i32 %1
}

define signext i32 @add32_sext_accept(i32 signext %a) nounwind {
; RV32I-LABEL: add32_sext_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1500
; RV32I-NEXT:    addi a0, a0, 1499
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add32_sext_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addiw a0, a0, 1500
; RV64I-NEXT:    addiw a0, a0, 1499
; RV64I-NEXT:    ret
  %1 = add i32 %a, 2999
  ret i32 %1
}

@gv0 = global i32 0, align 4
define signext i32 @add32_sext_reject_on_rv64(i32 signext %a) nounwind {
; RV32I-LABEL: add32_sext_reject_on_rv64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1500
; RV32I-NEXT:    addi a0, a0, 1500
; RV32I-NEXT:    lui a1, %hi(gv0)
; RV32I-NEXT:    sw a0, %lo(gv0)(a1)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add32_sext_reject_on_rv64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -1096
; RV64I-NEXT:    addw a0, a0, a1
; RV64I-NEXT:    lui a1, %hi(gv0)
; RV64I-NEXT:    sw a0, %lo(gv0)(a1)
; RV64I-NEXT:    ret
  %b = add nsw i32 %a, 3000
  store i32 %b, i32* @gv0, align 4
  ret i32 %b
}

define i64 @add64_accept(i64 %a) nounwind {
; RV32I-LABEL: add64_accept:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a2, a0, 1500
; RV32I-NEXT:    addi a2, a2, 1499
; RV32I-NEXT:    sltu a0, a2, a0
; RV32I-NEXT:    add a1, a1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add64_accept:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 1500
; RV64I-NEXT:    addi a0, a0, 1499
; RV64I-NEXT:    ret
  %1 = add i64 %a, 2999
  ret i64 %1
}

@ga = global i32 0, align 4
@gb = global i32 0, align 4
define void @add32_reject() nounwind {
; RV32I-LABEL: add32_reject:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a0, %hi(ga)
; RV32I-NEXT:    lw a1, %lo(ga)(a0)
; RV32I-NEXT:    lui a2, %hi(gb)
; RV32I-NEXT:    lw a3, %lo(gb)(a2)
; RV32I-NEXT:    lui a4, 1
; RV32I-NEXT:    addi a4, a4, -1096
; RV32I-NEXT:    add a1, a1, a4
; RV32I-NEXT:    add a3, a3, a4
; RV32I-NEXT:    sw a1, %lo(ga)(a0)
; RV32I-NEXT:    sw a3, %lo(gb)(a2)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: add32_reject:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a0, %hi(ga)
; RV64I-NEXT:    lw a1, %lo(ga)(a0)
; RV64I-NEXT:    lui a2, %hi(gb)
; RV64I-NEXT:    lw a3, %lo(gb)(a2)
; RV64I-NEXT:    lui a4, 1
; RV64I-NEXT:    addiw a4, a4, -1096
; RV64I-NEXT:    addw a1, a1, a4
; RV64I-NEXT:    addw a3, a3, a4
; RV64I-NEXT:    sw a1, %lo(ga)(a0)
; RV64I-NEXT:    sw a3, %lo(gb)(a2)
; RV64I-NEXT:    ret
  %1 = load i32, i32* @ga, align 4
  %2 = load i32, i32* @gb, align 4
  %3 = add i32 %1, 3000
  %4 = add i32 %2, 3000
  store i32 %3, i32* @ga, align 4
  store i32 %4, i32* @gb, align 4
  ret void
}
