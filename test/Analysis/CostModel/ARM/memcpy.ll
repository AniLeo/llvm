; RUN: opt < %s  -cost-model -analyze -cost-kind=code-size | \
; RUN:    FileCheck %s --check-prefixes=COMMON,CHECK-NO-SA
; RUN: opt < %s  -cost-model -analyze -cost-kind=code-size -mattr=+strict-align | \
; RUN:    FileCheck %s --check-prefixes=COMMON,CHECK-SA

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-arm-unknown-eabi"

;;;;;;;;;;;;
; Align 1, 1
;;;;;;;;;;;;

define void @memcpy_1(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r1, [r1]
; strb r1, [r0]
;
; COMMON:           function 'memcpy_1'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 1, i1 false)
  ret void
}

define void @memcpy_2(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldrh	r1, [r1]
; strh	r1, [r0]
;
; strict-align:
;
; ldrb  r2, [r1]
; ldrb  r1, [r1, #1]
; strb  r1, [r0, #1]
; strb  r2, [r0]
;
; COMMON:           function 'memcpy_2'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 2, i1 false)
  ret void
}

define void @memcpy_3(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldrb	r2, [r1, #2]
; strb	r2, [r0, #2]
; ldrh	r1, [r1]
; strh	r1, [r0]
;
; strict-align:
;
; ldrb  r2, [r1]
; ldrb  r3, [r1, #1]
; ldrb  r1, [r1, #2]
; strb  r1, [r0, #2]
; strb  r3, [r0, #1]
; strb  r2, [r0]
;
; COMMON:           function 'memcpy_3'
; CHECK-NO-SA-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 6 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 3, i1 false)
  ret void
}

define void @memcpy_4(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr	r1, [r1]
; str	r1, [r0]
;
; strict-align:
;
; ldrb.w  r12, [r1]
; ldrb  r3, [r1, #1]
; ldrb  r2, [r1, #2]
; ldrb  r1, [r1, #3]
; strb  r1, [r0, #3]
; strb  r2, [r0, #2]
; strb  r3, [r0, #1]
; strb.w  r12, [r0]
;
; COMMON:           function 'memcpy_4'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 4, i1 false)
  ret void
}

define void @memcpy_8(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr	r2, [r1]
; ldr	r1, [r1, #4]
; str	r1, [r0, #4]
; str	r2, [r0]
;
; strict-align:
;
; push  {r7, lr}
; movs  r2, #8
; bl  __aeabi_memcpy
; pop {r7, pc}
;
; COMMON:      function 'memcpy_8'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 8, i1 false)
  ret void
}

define void @memcpy_16(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr.w	r12, [r1]
; ldr	r3, [r1, #4]
; ldr	r2, [r1, #8]
; ldr	r1, [r1, #12]
; str	r1, [r0, #12]
; str	r2, [r0, #8]
; str	r3, [r0, #4]
; str.w	r12, [r0]
;
; strict-align:
;
; push  {r7, lr}
; movs  r2, #8
; bl  __aeabi_memcpy
; pop {r7, pc}
;
; COMMON:           function 'memcpy_16'
; CHECK-NO-SA-NEXT: cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 16, i1 false)
  ret void
}

define void @memcpy_32(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; movs	r2, #32
; bl	__aeabi_memcpy
;
; COMMON:      function 'memcpy_32'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 32, i1 false)
  ret void
}

define void @memcpy_N(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; bl __aeabi_memcpy
;
; COMMON:      function 'memcpy_N'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 1 %s, i32 %N, i1 false)
  ret void
}

;;;;;;;;;;;;;
; Align 2, 2
;;;;;;;;;;;;;

define void @memcpy_1_al2(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r1, [r1]
; strb r1, [r0]
;
; COMMON:      function 'memcpy_1_al2'
; COMMON-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 1, i1 false)
  ret void
}

define void @memcpy_2_al2(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrh r1, [r1]
; strh r1, [r0]
;
; COMMON:      function 'memcpy_2_al2'
; COMMON-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 2, i1 false)
  ret void
}

define void @memcpy_3_al2(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r2, [r1, #2]
; strb r2, [r0, #2]
; ldrh r1, [r1]
; strh r1, [r0]
;
; COMMON:      function 'memcpy_3_al2'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 3, i1 false)
  ret void
}

define void @memcpy_4_al2(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr r1, [r1]
; str r1, [r0]
;
; strict-align:
;
; ldrh  r2, [r1, #2]
; strh  r2, [r0, #2]
; ldrh  r1, [r1]
; strh  r1, [r0]
;
; COMMON:           function 'memcpy_4_al2'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 4, i1 false)
  ret void
}

define void @memcpy_8_al2(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr r2, [r1]
; ldr r1, [r1, #4]
; str r1, [r0, #4]
; str r2, [r0]
;
; strict-align:
;
;	ldrh	r2, [r1, #6]
;	strh	r2, [r0, #6]
;	ldrh	r2, [r1, #4]
;	strh	r2, [r0, #4]
;	ldrh	r2, [r1, #2]
;	strh	r2, [r0, #2]
;	ldrh	r1, [r1]
;	strh	r1, [r0]
;
; COMMON:           function 'memcpy_8_al2'
; CHECK-NO-SA-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 8, i1 false)
  ret void
}

define void @memcpy_16_al2(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr.w	r12, [r1]
; ldr r3, [r1, #4]
; ldr r2, [r1, #8]
; ldr r1, [r1, #12]
; str r1, [r0, #12]
; str r2, [r0, #8]
; str r3, [r0, #4]
; str.w r12, [r0]
;
; strict-align:
;
;	movs	r2, #16
;	bl	__aeabi_memcpy
;
; COMMON:           function 'memcpy_16_al2'
; CHECK-NO-SA-NEXT: cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 16, i1 false)
  ret void
}

define void @memcpy_32_al2(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; movs r2, #32
; bl __aeabi_memcpy
;
; COMMON:      function 'memcpy_32_al2'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 32, i1 false)
  ret void
}

define void @memcpy_N_al2(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; bl __aeabi_memcpy
;
; COMMON:      function 'memcpy_N_al2'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 2 %d, i8* align 2 %s, i32 %N, i1 false)
  ret void
}

;;;;;;;;;;;;;
; Align 4, 4
;;;;;;;;;;;;;

define void @memcpy_1_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r1, [r1]
; strb r1, [r0]
;
; COMMON:      function 'memcpy_1_al4'
; COMMON-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 1, i1 false)
  ret void
}

define void @memcpy_2_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrh r1, [r1]
; strh r1, [r0]
;
; COMMON:      function 'memcpy_2_al4'
; COMMON-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 2, i1 false)
  ret void
}

define void @memcpy_3_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r2, [r1, #2]
; strb r2, [r0, #2]
; ldrh r1, [r1]
; strh r1, [r0]
;
; COMMON:      function 'memcpy_3_al4'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 3, i1 false)
  ret void
}

define void @memcpy_4_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldr r1, [r1]
; str r1, [r0]
;
; COMMON:      function 'memcpy_4_al4'
; COMMON-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 4, i1 false)
  ret void
}

define void @memcpy_8_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrd r2, r1, [r1]
; strd r2, r1, [r0]
;
; COMMON:      function 'memcpy_8_al4'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 8, i1 false)
  ret void
}

define void @memcpy_16_al4(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldm.w  r1, {r2, r3, r12}
; ldr    r1, [r1, #12]
; stm.w  r0, {r2, r3, r12}
; str    r1, [r0, #12]
;
; COMMON:      function 'memcpy_16_al4'
; COMMON-NEXT: cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 16, i1 false)
  ret void
}

define void @memcpy_32_al4(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; ldm.w  r1!, {r2, r3, r12, lr}
; stm.w  r0!, {r2, r3, r12, lr}
; ldm.w  r1, {r2, r3, r12, lr}
; stm.w  r0, {r2, r3, r12, lr}
;
; COMMON:      function 'memcpy_32_al4'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 32, i1 false)
  ret void
}

define void @memcpy_N_al4(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; bl  __aeabi_memcpy4
;
; COMMON:      function 'memcpy_N_al4'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 4 %s, i32 %N, i1 false)
  ret void
}

;;;;;;;;;;;;;
; Align 1, 4
;;;;;;;;;;;;;

define void @memcpy_1_al14(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb r1, [r1]
; strb r1, [r0]
;
; COMMON:       function 'memcpy_1_al14'
; COMMON-NEXT:  cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 1, i1 false)
  ret void
}

define void @memcpy_2_al14(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldrh r1, [r1]
; strh r1, [r0]
;
; strict-align:
;
; ldrb	r2, [r1]
; ldrb	r1, [r1, #1]
; strb	r1, [r0, #1]
; strb	r2, [r0]
;
; COMMON:           function 'memcpy_2_al14'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 2, i1 false)
  ret void
}

define void @memcpy_3_al14(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldrb r2, [r1, #2]
; strb r2, [r0, #2]
; ldrh r1, [r1]
; strh r1, [r0]
;
; strict-align:
;
; ldrb	r2, [r1]
; ldrb	r3, [r1, #1]
; ldrb	r1, [r1, #2]
; strb	r1, [r0, #2]
; strb	r3, [r0, #1]
; strb	r2, [r0]
;
; COMMON:           function 'memcpy_3_al14'
; CHECK-NO-SA-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 6 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 3, i1 false)
  ret void
}

define void @memcpy_4_al14(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr r1, [r1]
; str r1, [r0]
;
; strict-align:
;
; ldrb.w	r12, [r1]
; ldrb	r3, [r1, #1]
; ldrb	r2, [r1, #2]
; ldrb	r1, [r1, #3]
; strb	r1, [r0, #3]
; strb	r2, [r0, #2]
; strb	r3, [r0, #1]
; strb.w	r12, [r0]
;
; COMMON:      function 'memcpy_4_al14'
; CHECK-NO-SA-NEXT: cost of 2 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 4, i1 false)
  ret void
}

define void @memcpy_8_al14(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr r2, [r1]
; ldr r1, [r1, #4]
; str r1, [r0, #4]
; str r2, [r0]
;
; strict-align:
;
; push  {r7, lr}
; movs  r2, #8
; bl  __aeabi_memcpy
; pop {r7, pc}
;
; COMMON:      function 'memcpy_8_al14'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 8, i1 false)
  ret void
}

define void @memcpy_16_al14(i8* %d, i8* %s) {
;
; no strict-align:
;
; ldr.w r12, [r1]
; ldr   r3, [r1, #4]
; ldr   r2, [r1, #8]
; ldr   r1, [r1, #12]
; str   r1, [r0, #12]
; str   r2, [r0, #8]
; str   r3, [r0, #4]
; str.w r12, [r0]
;
; strict-align:
;
;	movs	r2, #16
;	bl	__aeabi_memcpy
;
; COMMON:           function 'memcpy_16_al14'
; CHECK-NO-SA-NEXT: cost of 8 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
; CHECK-SA-NEXT:    cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 16, i1 false)
  ret void
}

define void @memcpy_32_al14(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; movs r2, #32
; bl   __aeabi_memcpy
;
; COMMON:      function 'memcpy_32_al14'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 32, i1 false)
  ret void
}

define void @memcpy_N_al14(i8* %d, i8* %s, i32 %N) {
;
; with/without strict-align:
;
; bl  __aeabi_memcpy4
;
; COMMON:      function 'memcpy_N_al14'
; COMMON-NEXT: cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %d, i8* align 4 %s, i32 %N, i1 false)
  ret void
}

;;;;;;;;;;;;;
; Align 4, 1
;;;;;;;;;;;;;

define void @memcpy_1_al41(i8* %d, i8* %s) {
;
; with/without strict-align:
;
; ldrb  r1, [r1]
; strb  r1, [r0]
;
; COMMON:       function 'memcpy_1_al41'
; COMMON-NEXT:  cost of 4 for instruction: call void @llvm.memcpy.p0i8.p0i8.i32
;
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %d, i8* align 1 %s, i32 1, i1 false)
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1) #1
