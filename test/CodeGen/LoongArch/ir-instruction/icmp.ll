; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

;; Exercise the 'icmp' LLVM IR: https://llvm.org/docs/LangRef.html#icmp-instruction

define i1 @icmp_eq(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_eq:
; LA32:       # %bb.0:
; LA32-NEXT:    xor $a0, $a0, $a1
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_eq:
; LA64:       # %bb.0:
; LA64-NEXT:    xor $a0, $a0, $a1
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp eq i32 %a, %b
  ret i1 %res
}

define i1 @icmp_ne(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_ne:
; LA32:       # %bb.0:
; LA32-NEXT:    xor $a0, $a0, $a1
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ne:
; LA64:       # %bb.0:
; LA64-NEXT:    xor $a0, $a0, $a1
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ne i32 %a, %b
  ret i1 %res
}

define i1 @icmp_ugt(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_ugt:
; LA32:       # %bb.0:
; LA32-NEXT:    sltu $a0, $a1, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ugt:
; LA64:       # %bb.0:
; LA64-NEXT:    sltu $a0, $a1, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ugt i32 %a, %b
  ret i1 %res
}

define i1 @icmp_uge(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_uge:
; LA32:       # %bb.0:
; LA32-NEXT:    sltu $a0, $a0, $a1
; LA32-NEXT:    xori $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_uge:
; LA64:       # %bb.0:
; LA64-NEXT:    sltu $a0, $a0, $a1
; LA64-NEXT:    xori $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp uge i32 %a, %b
  ret i1 %res
}

define i1 @icmp_ult(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_ult:
; LA32:       # %bb.0:
; LA32-NEXT:    sltu $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ult:
; LA64:       # %bb.0:
; LA64-NEXT:    sltu $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ult i32 %a, %b
  ret i1 %res
}

define i1 @icmp_ule(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_ule:
; LA32:       # %bb.0:
; LA32-NEXT:    sltu $a0, $a1, $a0
; LA32-NEXT:    xori $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ule:
; LA64:       # %bb.0:
; LA64-NEXT:    sltu $a0, $a1, $a0
; LA64-NEXT:    xori $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ule i32 %a, %b
  ret i1 %res
}

define i1 @icmp_sgt(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_sgt:
; LA32:       # %bb.0:
; LA32-NEXT:    slt $a0, $a1, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_sgt:
; LA64:       # %bb.0:
; LA64-NEXT:    slt $a0, $a1, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp sgt i32 %a, %b
  ret i1 %res
}

define i1 @icmp_sge(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_sge:
; LA32:       # %bb.0:
; LA32-NEXT:    slt $a0, $a0, $a1
; LA32-NEXT:    xori $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_sge:
; LA64:       # %bb.0:
; LA64-NEXT:    slt $a0, $a0, $a1
; LA64-NEXT:    xori $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp sge i32 %a, %b
  ret i1 %res
}

define i1 @icmp_slt(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_slt:
; LA32:       # %bb.0:
; LA32-NEXT:    slt $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_slt:
; LA64:       # %bb.0:
; LA64-NEXT:    slt $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp slt i32 %a, %b
  ret i1 %res
}

define i1 @icmp_sle(i32 signext %a, i32 signext %b) {
; LA32-LABEL: icmp_sle:
; LA32:       # %bb.0:
; LA32-NEXT:    slt $a0, $a1, $a0
; LA32-NEXT:    xori $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_sle:
; LA64:       # %bb.0:
; LA64-NEXT:    slt $a0, $a1, $a0
; LA64-NEXT:    xori $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp sle i32 %a, %b
  ret i1 %res
}

define i1 @icmp_slt_3(i32 signext %a) {
; LA32-LABEL: icmp_slt_3:
; LA32:       # %bb.0:
; LA32-NEXT:    slti $a0, $a0, 3
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_slt_3:
; LA64:       # %bb.0:
; LA64-NEXT:    slti $a0, $a0, 3
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp slt i32 %a, 3
  ret i1 %res
}

define i1 @icmp_ult_3(i32 signext %a) {
; LA32-LABEL: icmp_ult_3:
; LA32:       # %bb.0:
; LA32-NEXT:    sltui $a0, $a0, 3
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ult_3:
; LA64:       # %bb.0:
; LA64-NEXT:    sltui $a0, $a0, 3
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ult i32 %a, 3
  ret i1 %res
}

define i1 @icmp_eq_0(i32 signext %a) {
; LA32-LABEL: icmp_eq_0:
; LA32:       # %bb.0:
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_eq_0:
; LA64:       # %bb.0:
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp eq i32 %a, 0
  ret i1 %res
}

define i1 @icmp_eq_3(i32 signext %a) {
; LA32-LABEL: icmp_eq_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, -3
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_eq_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, -3
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp eq i32 %a, 3
  ret i1 %res
}

define i1 @icmp_ne_0(i32 signext %a) {
; LA32-LABEL: icmp_ne_0:
; LA32:       # %bb.0:
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ne_0:
; LA64:       # %bb.0:
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ne i32 %a, 0
  ret i1 %res
}

define i1 @icmp_ne_3(i32 signext %a) {
; LA32-LABEL: icmp_ne_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, -3
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: icmp_ne_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, -3
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %res = icmp ne i32 %a, 3
  ret i1 %res
}
