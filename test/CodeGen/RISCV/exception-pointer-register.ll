; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
;
; Before getExceptionPointerRegister() and getExceptionSelectorRegister()
; lowering hooks were defined this would trigger an assertion during live
; variable analysis

declare void @foo(i1* %p);
declare void @bar(i1* %p);
declare dso_local i32 @__gxx_personality_v0(...)

define void @caller(i1* %p) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; RV32I-LABEL: caller:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    .cfi_def_cfa_offset 16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    sw s1, 4(sp)
; RV32I-NEXT:    .cfi_offset ra, -4
; RV32I-NEXT:    .cfi_offset s0, -8
; RV32I-NEXT:    .cfi_offset s1, -12
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    beqz a0, .LBB0_2
; RV32I-NEXT:  # %bb.1: # %bb2
; RV32I-NEXT:  .Ltmp0:
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call bar
; RV32I-NEXT:  .Ltmp1:
; RV32I-NEXT:    j .LBB0_3
; RV32I-NEXT:  .LBB0_2: # %bb1
; RV32I-NEXT:  .Ltmp2:
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call foo
; RV32I-NEXT:  .Ltmp3:
; RV32I-NEXT:  .LBB0_3: # %end2
; RV32I-NEXT:    lw s1, 4(sp)
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    .cfi_restore ra
; RV32I-NEXT:    .cfi_restore s0
; RV32I-NEXT:    .cfi_restore s1
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    .cfi_def_cfa_offset 0
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB0_4: # %lpad
; RV32I-NEXT:  .Ltmp4:
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call callee
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    call _Unwind_Resume
;
; RV64I-LABEL: caller:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    .cfi_def_cfa_offset 32
; RV64I-NEXT:    sd ra, 24(sp)
; RV64I-NEXT:    sd s0, 16(sp)
; RV64I-NEXT:    sd s1, 8(sp)
; RV64I-NEXT:    .cfi_offset ra, -8
; RV64I-NEXT:    .cfi_offset s0, -16
; RV64I-NEXT:    .cfi_offset s1, -24
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    beqz a0, .LBB0_2
; RV64I-NEXT:  # %bb.1: # %bb2
; RV64I-NEXT:  .Ltmp0:
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call bar
; RV64I-NEXT:  .Ltmp1:
; RV64I-NEXT:    j .LBB0_3
; RV64I-NEXT:  .LBB0_2: # %bb1
; RV64I-NEXT:  .Ltmp2:
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call foo
; RV64I-NEXT:  .Ltmp3:
; RV64I-NEXT:  .LBB0_3: # %end2
; RV64I-NEXT:    ld s1, 8(sp)
; RV64I-NEXT:    ld s0, 16(sp)
; RV64I-NEXT:    ld ra, 24(sp)
; RV64I-NEXT:    .cfi_restore ra
; RV64I-NEXT:    .cfi_restore s0
; RV64I-NEXT:    .cfi_restore s1
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    .cfi_def_cfa_offset 0
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB0_4: # %lpad
; RV64I-NEXT:  .Ltmp4:
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call callee
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call _Unwind_Resume
entry:
  %0 = icmp eq i1* %p, null
  br i1 %0, label %bb1, label %bb2

bb1:
  invoke void @foo(i1* %p) to label %end1 unwind label %lpad

bb2:
  invoke void @bar(i1* %p) to label %end2 unwind label %lpad

lpad:
  %1 = landingpad { i8*, i32 } cleanup
  call void @callee(i1* %p)
  resume { i8*, i32 } %1

end1:
  ret void

end2:
  ret void
}

define internal void @callee(i1* %p) {
; RV32I-LABEL: callee:
; RV32I:       # %bb.0:
; RV32I-NEXT:    .cfi_def_cfa_offset 0
; RV32I-NEXT:    ret
;
; RV64I-LABEL: callee:
; RV64I:       # %bb.0:
; RV64I-NEXT:    .cfi_def_cfa_offset 0
; RV64I-NEXT:    ret
  ret void
}
