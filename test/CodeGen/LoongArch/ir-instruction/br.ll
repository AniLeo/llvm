; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefixes=ALL,LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefixes=ALL,LA64

define void @foo() noreturn nounwind {
; ALL-LABEL: foo:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:  .LBB0_1: # %loop
; ALL-NEXT:    # =>This Inner Loop Header: Depth=1
; ALL-NEXT:    b .LBB0_1
entry:
  br label %loop
loop:
  br label %loop
}

define void @foo_br_eq(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_eq:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    beq $a2, $a0, .LBB1_2
; LA32-NEXT:    b .LBB1_1
; LA32-NEXT:  .LBB1_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB1_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_eq:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    beq $a2, $a0, .LBB1_2
; LA64-NEXT:    b .LBB1_1
; LA64-NEXT:  .LBB1_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB1_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp eq i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_ne(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_ne:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bne $a2, $a0, .LBB2_2
; LA32-NEXT:    b .LBB2_1
; LA32-NEXT:  .LBB2_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB2_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_ne:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    bne $a2, $a0, .LBB2_2
; LA64-NEXT:    b .LBB2_1
; LA64-NEXT:  .LBB2_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB2_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp ne i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_slt(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_slt:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    blt $a2, $a0, .LBB3_2
; LA32-NEXT:    b .LBB3_1
; LA32-NEXT:  .LBB3_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB3_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_slt:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.w $a2, $a1, 0
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    blt $a2, $a0, .LBB3_2
; LA64-NEXT:    b .LBB3_1
; LA64-NEXT:  .LBB3_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB3_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp slt i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_sge(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_sge:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bge $a2, $a0, .LBB4_2
; LA32-NEXT:    b .LBB4_1
; LA32-NEXT:  .LBB4_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB4_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_sge:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.w $a2, $a1, 0
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    bge $a2, $a0, .LBB4_2
; LA64-NEXT:    b .LBB4_1
; LA64-NEXT:  .LBB4_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB4_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp sge i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_ult(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_ult:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bltu $a2, $a0, .LBB5_2
; LA32-NEXT:    b .LBB5_1
; LA32-NEXT:  .LBB5_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB5_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_ult:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    bltu $a2, $a0, .LBB5_2
; LA64-NEXT:    b .LBB5_1
; LA64-NEXT:  .LBB5_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB5_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp ult i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_uge(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_uge:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bgeu $a2, $a0, .LBB6_2
; LA32-NEXT:    b .LBB6_1
; LA32-NEXT:  .LBB6_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB6_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_uge:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    bgeu $a2, $a0, .LBB6_2
; LA64-NEXT:    b .LBB6_1
; LA64-NEXT:  .LBB6_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB6_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp uge i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

;; Check for condition codes that don't have a matching instruction.
define void @foo_br_sgt(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_sgt:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    blt $a0, $a2, .LBB7_2
; LA32-NEXT:    b .LBB7_1
; LA32-NEXT:  .LBB7_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB7_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_sgt:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.w $a2, $a1, 0
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    blt $a0, $a2, .LBB7_2
; LA64-NEXT:    b .LBB7_1
; LA64-NEXT:  .LBB7_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB7_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp sgt i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_sle(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_sle:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bge $a0, $a2, .LBB8_2
; LA32-NEXT:    b .LBB8_1
; LA32-NEXT:  .LBB8_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB8_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_sle:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.w $a2, $a1, 0
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    bge $a0, $a2, .LBB8_2
; LA64-NEXT:    b .LBB8_1
; LA64-NEXT:  .LBB8_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB8_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp sle i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_ugt(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_ugt:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bltu $a0, $a2, .LBB9_2
; LA32-NEXT:    b .LBB9_1
; LA32-NEXT:  .LBB9_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB9_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_ugt:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    bltu $a0, $a2, .LBB9_2
; LA64-NEXT:    b .LBB9_1
; LA64-NEXT:  .LBB9_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB9_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp ugt i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

define void @foo_br_ule(i32 %a, ptr %b) nounwind {
; LA32-LABEL: foo_br_ule:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a2, $a1, 0
; LA32-NEXT:    bgeu $a0, $a2, .LBB10_2
; LA32-NEXT:    b .LBB10_1
; LA32-NEXT:  .LBB10_1: # %test
; LA32-NEXT:    ld.w $a0, $a1, 0
; LA32-NEXT:  .LBB10_2: # %end
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: foo_br_ule:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.wu $a2, $a1, 0
; LA64-NEXT:    bstrpick.d $a0, $a0, 31, 0
; LA64-NEXT:    bgeu $a0, $a2, .LBB10_2
; LA64-NEXT:    b .LBB10_1
; LA64-NEXT:  .LBB10_1: # %test
; LA64-NEXT:    ld.w $a0, $a1, 0
; LA64-NEXT:  .LBB10_2: # %end
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %b
  %cc = icmp ule i32 %val, %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %b
  br label %end

end:
  ret void
}

;; Check the case of a branch where the condition was generated in another
;; function.
define void @foo_br_cc(ptr %a, i1 %cc) nounwind {
; ALL-LABEL: foo_br_cc:
; ALL:       # %bb.0:
; ALL-NEXT:    ld.w $a2, $a0, 0
; ALL-NEXT:    andi $a1, $a1, 1
; ALL-NEXT:    bnez $a1, .LBB11_2
; ALL-NEXT:    b .LBB11_1
; ALL-NEXT:  .LBB11_1: # %test
; ALL-NEXT:    ld.w $a0, $a0, 0
; ALL-NEXT:  .LBB11_2: # %end
; ALL-NEXT:    jirl $zero, $ra, 0
  %val = load volatile i32, ptr %a
  br i1 %cc, label %end, label %test
test:
  %tmp = load volatile i32, ptr %a
  br label %end

end:
  ret void
}
