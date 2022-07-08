; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv6m-none-eabi | FileCheck %s --check-prefix=CHECK-T1
; RUN: llc < %s -mtriple=thumbv7m-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2NODSP
; RUN: llc < %s -mtriple=thumbv7em-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2DSP
; RUN: llc < %s -mtriple=armv8a-none-eabi | FileCheck %s --check-prefix=CHECK-ARM

declare i4 @llvm.usub.sat.i4(i4, i4)
declare i8 @llvm.usub.sat.i8(i8, i8)
declare i16 @llvm.usub.sat.i16(i16, i16)
declare i32 @llvm.usub.sat.i32(i32, i32)
declare i64 @llvm.usub.sat.i64(i64, i64)

define i32 @func(i32 %x, i32 %y) nounwind {
; CHECK-T1-LABEL: func:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    bhs .LBB0_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:  .LBB0_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r1
; CHECK-T2-NEXT:    it lo
; CHECK-T2-NEXT:    movlo r0, #0
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    subs r0, r0, r1
; CHECK-ARM-NEXT:    movlo r0, #0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i32 @llvm.usub.sat.i32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; CHECK-T1-LABEL: func2:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, lr}
; CHECK-T1-NEXT:    push {r4, lr}
; CHECK-T1-NEXT:    mov r4, r1
; CHECK-T1-NEXT:    movs r1, #0
; CHECK-T1-NEXT:    subs r2, r0, r2
; CHECK-T1-NEXT:    sbcs r4, r3
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:    adcs r0, r1
; CHECK-T1-NEXT:    movs r3, #1
; CHECK-T1-NEXT:    eors r3, r0
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:    beq .LBB1_3
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    cmp r3, #0
; CHECK-T1-NEXT:    beq .LBB1_4
; CHECK-T1-NEXT:  .LBB1_2:
; CHECK-T1-NEXT:    pop {r4, pc}
; CHECK-T1-NEXT:  .LBB1_3:
; CHECK-T1-NEXT:    mov r0, r2
; CHECK-T1-NEXT:    cmp r3, #0
; CHECK-T1-NEXT:    bne .LBB1_2
; CHECK-T1-NEXT:  .LBB1_4:
; CHECK-T1-NEXT:    mov r1, r4
; CHECK-T1-NEXT:    pop {r4, pc}
;
; CHECK-T2-LABEL: func2:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r2
; CHECK-T2-NEXT:    mov.w r12, #0
; CHECK-T2-NEXT:    sbcs r1, r3
; CHECK-T2-NEXT:    adc r2, r12, #0
; CHECK-T2-NEXT:    eors r2, r2, #1
; CHECK-T2-NEXT:    itt ne
; CHECK-T2-NEXT:    movne r0, #0
; CHECK-T2-NEXT:    movne r1, #0
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func2:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    subs r0, r0, r2
; CHECK-ARM-NEXT:    mov r12, #0
; CHECK-ARM-NEXT:    sbcs r1, r1, r3
; CHECK-ARM-NEXT:    adc r2, r12, #0
; CHECK-ARM-NEXT:    eors r2, r2, #1
; CHECK-ARM-NEXT:    movwne r0, #0
; CHECK-ARM-NEXT:    movwne r1, #0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i64 @llvm.usub.sat.i64(i64 %x, i64 %y)
  ret i64 %tmp
}

define zeroext i16 @func16(i16 zeroext %x, i16 zeroext %y) nounwind {
; CHECK-T1-LABEL: func16:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    bhs .LBB2_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:  .LBB2_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2NODSP-LABEL: func16:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    subs r0, r0, r1
; CHECK-T2NODSP-NEXT:    it lo
; CHECK-T2NODSP-NEXT:    movlo r0, #0
; CHECK-T2NODSP-NEXT:    bx lr
;
; CHECK-T2DSP-LABEL: func16:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    uqsub16 r0, r0, r1
; CHECK-T2DSP-NEXT:    uxth r0, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func16:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    uqsub16 r0, r0, r1
; CHECK-ARM-NEXT:    uxth r0, r0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i16 @llvm.usub.sat.i16(i16 %x, i16 %y)
  ret i16 %tmp
}

define zeroext i8 @func8(i8 zeroext %x, i8 zeroext %y) nounwind {
; CHECK-T1-LABEL: func8:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    bhs .LBB3_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:  .LBB3_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2NODSP-LABEL: func8:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    subs r0, r0, r1
; CHECK-T2NODSP-NEXT:    it lo
; CHECK-T2NODSP-NEXT:    movlo r0, #0
; CHECK-T2NODSP-NEXT:    bx lr
;
; CHECK-T2DSP-LABEL: func8:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    uqsub8 r0, r0, r1
; CHECK-T2DSP-NEXT:    uxtb r0, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func8:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    uqsub8 r0, r0, r1
; CHECK-ARM-NEXT:    uxtb r0, r0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i8 @llvm.usub.sat.i8(i8 %x, i8 %y)
  ret i8 %tmp
}

define zeroext i4 @func3(i4 zeroext %x, i4 zeroext %y) nounwind {
; CHECK-T1-LABEL: func3:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    subs r0, r0, r1
; CHECK-T1-NEXT:    bhs .LBB4_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:  .LBB4_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func3:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    subs r0, r0, r1
; CHECK-T2-NEXT:    it lo
; CHECK-T2-NEXT:    movlo r0, #0
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func3:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    subs r0, r0, r1
; CHECK-ARM-NEXT:    movlo r0, #0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i4 @llvm.usub.sat.i4(i4 %x, i4 %y)
  ret i4 %tmp
}
