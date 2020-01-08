; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve.fp %s -o 2>/dev/null - | FileCheck --check-prefix NOGATSCAT %s
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=-mve -enable-arm-maskedgatscat %s -o 2>/dev/null - | FileCheck --check-prefix NOMVE %s

define arm_aapcs_vfpcc <4 x i32> @unscaled_i32_i32(i8* %base, <4 x i32>* %offptr) {
; NOGATSCAT-LABEL: unscaled_i32_i32:
; NOGATSCAT:       @ %bb.0: @ %entry
; NOGATSCAT-NEXT:    vldrw.u32	q0, [r1]
; NOGATSCAT-NEXT:    vadd.i32	q0, q0, r0
; NOGATSCAT-NEXT:    vmov r0, s0
; NOGATSCAT-NEXT:    vmov r3, s1
; NOGATSCAT-NEXT:    vmov r1, s2
; NOGATSCAT-NEXT:    vmov r2, s3
; NOGATSCAT-NEXT:    ldr r0, [r0]
; NOGATSCAT-NEXT:    ldr r3, [r3]
; NOGATSCAT-NEXT:    vmov.32 q0[0], r0
; NOGATSCAT-NEXT:    ldr r1, [r1]
; NOGATSCAT-NEXT:    vmov.32 q0[1], r3
; NOGATSCAT-NEXT:    ldr r2, [r2]
; NOGATSCAT-NEXT:    vmov.32 q0[2], r1
; NOGATSCAT-NEXT:    vmov.32 q0[3], r2
; NOGATSCAT-NEXT:    bx lr

; NOMVE-LABEL: unscaled_i32_i32:
; NOMVE:       @ %bb.0: @ %entry
; NOMVE-NEXT:    .save	{r4, lr}
; NOMVE-NEXT:    push	{r4, lr}
; NOMVE-NEXT:    ldm.w	r1, {r2, r3, lr}
; NOMVE-NEXT:    ldr	r4, [r1, #12]
; NOMVE-NEXT:    ldr.w	r12, [r0, r2]
; NOMVE-NEXT:    ldr	r1, [r0, r3]
; NOMVE-NEXT:    ldr.w	r2, [r0, lr]
; NOMVE-NEXT:    ldr	r3, [r0, r4]
; NOMVE-NEXT:    mov	r0, r12
; NOMVE-NEXT:    pop	{r4, pc}

entry:
  %offs = load <4 x i32>, <4 x i32>* %offptr, align 4
  %byte_ptrs = getelementptr inbounds i8, i8* %base, <4 x i32> %offs
  %ptrs = bitcast <4 x i8*> %byte_ptrs to <4 x i32*>
  %gather = call <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*> %ptrs, i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef)
  ret <4 x i32> %gather
}

declare <4 x i32> @llvm.masked.gather.v4i32.v4p0i32(<4 x i32*>, i32, <4 x i1>, <4 x i32>)
