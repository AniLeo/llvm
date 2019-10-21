; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7m-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2NODSP
; RUN: llc < %s -mtriple=thumbv7em-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2DSP
; RUN: llc < %s -mtriple=armv5te-none-none-eabi | FileCheck %s --check-prefix=CHECK-ARM --check-prefix=CHECK-ARM6
; RUN: llc < %s -mtriple=armv8a-none-eabi | FileCheck %s --check-prefix=CHECK-ARM --check-prefix=CHECK-ARM8

define i32 @qdadd(i32 %x, i32 %y) nounwind {
; CHECK-T2NODSP-LABEL: qdadd:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    .save {r7, lr}
; CHECK-T2NODSP-NEXT:    push {r7, lr}
; CHECK-T2NODSP-NEXT:    movs r3, #0
; CHECK-T2NODSP-NEXT:    adds.w r12, r0, r0
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi r3, #1
; CHECK-T2NODSP-NEXT:    cmp r3, #0
; CHECK-T2NODSP-NEXT:    mov.w r3, #-2147483648
; CHECK-T2NODSP-NEXT:    mov.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r3, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r12, r0
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r3, r12
; CHECK-T2NODSP-NEXT:    adds r0, r3, r1
; CHECK-T2NODSP-NEXT:    mov.w r2, #-2147483648
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi.w lr, #1
; CHECK-T2NODSP-NEXT:    cmp.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r2, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r0, r3
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r2, r0
; CHECK-T2NODSP-NEXT:    mov r0, r2
; CHECK-T2NODSP-NEXT:    pop {r7, pc}
;
; CHECK-T2DSP-LABEL: qdadd:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    qadd r0, r0, r0
; CHECK-T2DSP-NEXT:    qadd r0, r0, r1
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: qdadd:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    qadd r0, r0, r0
; CHECK-ARM-NEXT:    qadd r0, r0, r1
; CHECK-ARM-NEXT:    bx lr
  %z = call i32 @llvm.sadd.sat.i32(i32 %x, i32 %x)
  %tmp = call i32 @llvm.sadd.sat.i32(i32 %z, i32 %y)
  ret i32 %tmp
}

define i32 @qdadd_c(i32 %x, i32 %y) nounwind {
; CHECK-T2NODSP-LABEL: qdadd_c:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    .save {r7, lr}
; CHECK-T2NODSP-NEXT:    push {r7, lr}
; CHECK-T2NODSP-NEXT:    movs r3, #0
; CHECK-T2NODSP-NEXT:    adds.w r12, r0, r0
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi r3, #1
; CHECK-T2NODSP-NEXT:    cmp r3, #0
; CHECK-T2NODSP-NEXT:    mov.w r3, #-2147483648
; CHECK-T2NODSP-NEXT:    mov.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r3, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r12, r0
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r3, r12
; CHECK-T2NODSP-NEXT:    adds r0, r1, r3
; CHECK-T2NODSP-NEXT:    mov.w r2, #-2147483648
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi.w lr, #1
; CHECK-T2NODSP-NEXT:    cmp.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r2, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r0, r1
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r2, r0
; CHECK-T2NODSP-NEXT:    mov r0, r2
; CHECK-T2NODSP-NEXT:    pop {r7, pc}
;
; CHECK-T2DSP-LABEL: qdadd_c:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    qadd r0, r0, r0
; CHECK-T2DSP-NEXT:    qadd r0, r1, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: qdadd_c:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    qadd r0, r0, r0
; CHECK-ARM-NEXT:    qadd r0, r1, r0
; CHECK-ARM-NEXT:    bx lr
  %z = call i32 @llvm.sadd.sat.i32(i32 %x, i32 %x)
  %tmp = call i32 @llvm.sadd.sat.i32(i32 %y, i32 %z)
  ret i32 %tmp
}

define i32 @qdsub(i32 %x, i32 %y) nounwind {
; CHECK-T2NODSP-LABEL: qdsub:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    .save {r7, lr}
; CHECK-T2NODSP-NEXT:    push {r7, lr}
; CHECK-T2NODSP-NEXT:    movs r3, #0
; CHECK-T2NODSP-NEXT:    adds.w r12, r0, r0
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi r3, #1
; CHECK-T2NODSP-NEXT:    cmp r3, #0
; CHECK-T2NODSP-NEXT:    mov.w r3, #-2147483648
; CHECK-T2NODSP-NEXT:    mov.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r3, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r12, r0
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r3, r12
; CHECK-T2NODSP-NEXT:    subs r0, r1, r3
; CHECK-T2NODSP-NEXT:    mov.w r2, #-2147483648
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi.w lr, #1
; CHECK-T2NODSP-NEXT:    cmp.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r2, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r1, r3
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r2, r0
; CHECK-T2NODSP-NEXT:    mov r0, r2
; CHECK-T2NODSP-NEXT:    pop {r7, pc}
;
; CHECK-T2DSP-LABEL: qdsub:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    qadd r0, r0, r0
; CHECK-T2DSP-NEXT:    qsub r0, r1, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: qdsub:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    qadd r0, r0, r0
; CHECK-ARM-NEXT:    qsub r0, r1, r0
; CHECK-ARM-NEXT:    bx lr
  %z = call i32 @llvm.sadd.sat.i32(i32 %x, i32 %x)
  %tmp = call i32 @llvm.ssub.sat.i32(i32 %y, i32 %z)
  ret i32 %tmp
}

define i32 @qdsub_c(i32 %x, i32 %y) nounwind {
; CHECK-T2NODSP-LABEL: qdsub_c:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    .save {r7, lr}
; CHECK-T2NODSP-NEXT:    push {r7, lr}
; CHECK-T2NODSP-NEXT:    movs r3, #0
; CHECK-T2NODSP-NEXT:    adds.w r12, r0, r0
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi r3, #1
; CHECK-T2NODSP-NEXT:    cmp r3, #0
; CHECK-T2NODSP-NEXT:    mov.w r3, #-2147483648
; CHECK-T2NODSP-NEXT:    mov.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r3, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r12, r0
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r3, r12
; CHECK-T2NODSP-NEXT:    subs r0, r3, r1
; CHECK-T2NODSP-NEXT:    mov.w r2, #-2147483648
; CHECK-T2NODSP-NEXT:    it mi
; CHECK-T2NODSP-NEXT:    movmi.w lr, #1
; CHECK-T2NODSP-NEXT:    cmp.w lr, #0
; CHECK-T2NODSP-NEXT:    it ne
; CHECK-T2NODSP-NEXT:    mvnne r2, #-2147483648
; CHECK-T2NODSP-NEXT:    cmp r3, r1
; CHECK-T2NODSP-NEXT:    it vc
; CHECK-T2NODSP-NEXT:    movvc r2, r0
; CHECK-T2NODSP-NEXT:    mov r0, r2
; CHECK-T2NODSP-NEXT:    pop {r7, pc}
;
; CHECK-T2DSP-LABEL: qdsub_c:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    qadd r0, r0, r0
; CHECK-T2DSP-NEXT:    qsub r0, r0, r1
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: qdsub_c:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    qadd r0, r0, r0
; CHECK-ARM-NEXT:    qsub r0, r0, r1
; CHECK-ARM-NEXT:    bx lr
  %z = call i32 @llvm.sadd.sat.i32(i32 %x, i32 %x)
  %tmp = call i32 @llvm.ssub.sat.i32(i32 %z, i32 %y)
  ret i32 %tmp
}

declare i32 @llvm.sadd.sat.i32(i32, i32)
declare i32 @llvm.ssub.sat.i32(i32, i32)
