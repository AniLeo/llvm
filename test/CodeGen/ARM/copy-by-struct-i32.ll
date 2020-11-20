; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7-unknown-linux < %s -stop-before=finalize-isel | FileCheck --check-prefix=BEFORE-EXPAND %s
; RUN: llc -mtriple=armv7-unknown-linux < %s | FileCheck --check-prefix=ASSEMBLY %s

; Check COPY_STRUCT_BYVAL_I32 has CPSR as operand.
; BEFORE-EXPAND: COPY_STRUCT_BYVAL_I32 {{.*}} implicit-def dead $cpsr
; BEFORE-EXPAND: COPY_STRUCT_BYVAL_I32 {{.*}} implicit-def dead $cpsr

%struct.anon = type { i32, i32, i32, i32, i32, i32, i32, %struct.f, i32, i64, i32 }
%struct.f = type { i32, i32, i32, i32, i32 }

define arm_aapcscc void @s(i64* %q, %struct.anon* %p) {
; ASSEMBLY-LABEL: s:
; ASSEMBLY:       @ %bb.0: @ %entry
; ASSEMBLY-NEXT:    push {r4, r5, r11, lr}
; ASSEMBLY-NEXT:    sub sp, sp, #136
; ASSEMBLY-NEXT:    ldrd r4, r5, [r0]
; ASSEMBLY-NEXT:    add lr, sp, #56
; ASSEMBLY-NEXT:    ldm r1, {r0, r12}
; ASSEMBLY-NEXT:    subs r4, r4, #1
; ASSEMBLY-NEXT:    sbc r5, r5, #0
; ASSEMBLY-NEXT:    ldr r2, [r1, #8]
; ASSEMBLY-NEXT:    ldr r3, [r1, #12]
; ASSEMBLY-NEXT:    str r5, [sp, #132]
; ASSEMBLY-NEXT:    add r5, r1, #16
; ASSEMBLY-NEXT:    str r4, [sp, #128]
; ASSEMBLY-NEXT:    mov r4, sp
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r5]!
; ASSEMBLY-NEXT:    vst1.32 {d16}, [r4]!
; ASSEMBLY-NEXT:    movw r4, #72
; ASSEMBLY-NEXT:  .LBB0_1: @ %entry
; ASSEMBLY-NEXT:    @ =>This Inner Loop Header: Depth=1
; ASSEMBLY-NEXT:    vld1.32 {d16}, [r1]!
; ASSEMBLY-NEXT:    subs r4, r4, #8
; ASSEMBLY-NEXT:    vst1.32 {d16}, [lr]!
; ASSEMBLY-NEXT:    bne .LBB0_1
; ASSEMBLY-NEXT:  @ %bb.2: @ %entry
; ASSEMBLY-NEXT:    mov r1, r12
; ASSEMBLY-NEXT:    bl r
; ASSEMBLY-NEXT:    add sp, sp, #136
; ASSEMBLY-NEXT:    pop {r4, r5, r11, pc}
entry:
  %0 = load i64, i64* %q, align 8
  %sub = add nsw i64 %0, -1
  tail call arm_aapcscc void bitcast (void (...)* @r to void (%struct.anon*, %struct.anon*, i64)*)(%struct.anon* byval(%struct.anon) nonnull align 8 %p, %struct.anon* byval(%struct.anon) nonnull align 8 %p, i64 %sub)
  ret void
}

declare arm_aapcscc void @r(...)
