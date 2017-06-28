; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm-eabi-unknown-unknown | FileCheck %s

; Select of constants: control flow / conditional moves can always be replaced by logic+math (but may not be worth it?).
; Test the zeroext/signext variants of each pattern to see if that makes a difference.

; select Cond, 0, 1 --> zext (!Cond)

define i32 @select_0_or_1(i1 %cond) {
; CHECK-LABEL: select_0_or_1:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #1
; CHECK-NEXT:    bic r0, r1, r0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

define i32 @select_0_or_1_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_0_or_1_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    eor r0, r0, #1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

define i32 @select_0_or_1_signext(i1 signext %cond) {
; CHECK-LABEL: select_0_or_1_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #1
; CHECK-NEXT:    bic r0, r1, r0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

; select Cond, 1, 0 --> zext (Cond)

define i32 @select_1_or_0(i1 %cond) {
; CHECK-LABEL: select_1_or_0:
; CHECK:       @ BB#0:
; CHECK-NEXT:    and r0, r0, #1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

define i32 @select_1_or_0_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_1_or_0_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

define i32 @select_1_or_0_signext(i1 signext %cond) {
; CHECK-LABEL: select_1_or_0_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    and r0, r0, #1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

; select Cond, 0, -1 --> sext (!Cond)

define i32 @select_0_or_neg1(i1 %cond) {
; CHECK-LABEL: select_0_or_neg1:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #1
; CHECK-NEXT:    bic r0, r1, r0
; CHECK-NEXT:    rsb r0, r0, #0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

define i32 @select_0_or_neg1_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_0_or_neg1_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    eor r0, r0, #1
; CHECK-NEXT:    rsb r0, r0, #0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

define i32 @select_0_or_neg1_signext(i1 signext %cond) {
; CHECK-LABEL: select_0_or_neg1_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mvn r0, r0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

define i32 @select_0_or_neg1_alt(i1 %cond) {
; CHECK-LABEL: select_0_or_neg1_alt:
; CHECK:       @ BB#0:
; CHECK-NEXT:    and r0, r0, #1
; CHECK-NEXT:    sub r0, r0, #1
; CHECK-NEXT:    mov pc, lr
  %z = zext i1 %cond to i32
  %add = add i32 %z, -1
  ret i32 %add
}

define i32 @select_0_or_neg1_alt_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_0_or_neg1_alt_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    sub r0, r0, #1
; CHECK-NEXT:    mov pc, lr
  %z = zext i1 %cond to i32
  %add = add i32 %z, -1
  ret i32 %add
}

define i32 @select_0_or_neg1_alt_signext(i1 signext %cond) {
; CHECK-LABEL: select_0_or_neg1_alt_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mvn r0, r0
; CHECK-NEXT:    mov pc, lr
  %z = zext i1 %cond to i32
  %add = add i32 %z, -1
  ret i32 %add
}

; select Cond, -1, 0 --> sext (Cond)

define i32 @select_neg1_or_0(i1 %cond) {
; CHECK-LABEL: select_neg1_or_0:
; CHECK:       @ BB#0:
; CHECK-NEXT:    and r0, r0, #1
; CHECK-NEXT:    rsb r0, r0, #0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

define i32 @select_neg1_or_0_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_neg1_or_0_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    rsb r0, r0, #0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

define i32 @select_neg1_or_0_signext(i1 signext %cond) {
; CHECK-LABEL: select_neg1_or_0_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

; select Cond, C+1, C --> add (zext Cond), C

define i32 @select_Cplus1_C(i1 %cond) {
; CHECK-LABEL: select_Cplus1_C:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #41
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    movne r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

define i32 @select_Cplus1_C_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_Cplus1_C_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #41
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

define i32 @select_Cplus1_C_signext(i1 signext %cond) {
; CHECK-LABEL: select_Cplus1_C_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #41
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    movne r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

; select Cond, C, C+1 --> add (sext Cond), C

define i32 @select_C_Cplus1(i1 %cond) {
; CHECK-LABEL: select_C_Cplus1:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #42
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    movne r1, #41
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

define i32 @select_C_Cplus1_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_C_Cplus1_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #42
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    movne r1, #41
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

define i32 @select_C_Cplus1_signext(i1 signext %cond) {
; CHECK-LABEL: select_C_Cplus1_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #42
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    movne r1, #41
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

; In general, select of 2 constants could be:
; select Cond, C1, C2 --> add (mul (zext Cond), C1-C2), C2 --> add (and (sext Cond), C1-C2), C2

define i32 @select_C1_C2(i1 %cond) {
; CHECK-LABEL: select_C1_C2:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #165
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    orr r1, r1, #256
; CHECK-NEXT:    moveq r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

define i32 @select_C1_C2_zeroext(i1 zeroext %cond) {
; CHECK-LABEL: select_C1_C2_zeroext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #165
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    orr r1, r1, #256
; CHECK-NEXT:    moveq r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

define i32 @select_C1_C2_signext(i1 signext %cond) {
; CHECK-LABEL: select_C1_C2_signext:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #165
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    orr r1, r1, #256
; CHECK-NEXT:    moveq r1, #42
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

; 4295032833 = 0x100010001.
; This becomes an opaque constant via ConstantHoisting, so we don't fold it into the select.

define i64 @opaque_constant1(i1 %cond, i64 %x) {
; CHECK-LABEL: opaque_constant1:
; CHECK:       @ BB#0:
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    mov lr, #1
; CHECK-NEXT:    ands r12, r0, #1
; CHECK-NEXT:    mov r0, #23
; CHECK-NEXT:    orr lr, lr, #65536
; CHECK-NEXT:    mvnne r0, #3
; CHECK-NEXT:    and r4, r0, lr
; CHECK-NEXT:    movne r12, #1
; CHECK-NEXT:    subs r0, r4, #1
; CHECK-NEXT:    eor r2, r2, lr
; CHECK-NEXT:    eor r3, r3, #1
; CHECK-NEXT:    sbc r1, r12, #0
; CHECK-NEXT:    orrs r2, r2, r3
; CHECK-NEXT:    movne r0, r4
; CHECK-NEXT:    movne r1, r12
; CHECK-NEXT:    pop {r4, lr}
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i64 -4, i64 23
  %bo = and i64 %sel, 4295032833  ; 0x100010001
  %cmp = icmp eq i64 %x, 4295032833
  %sext = sext i1 %cmp to i64
  %add = add i64 %bo, %sext
  ret i64 %add
}

; 65537 == 0x10001.
; This becomes an opaque constant via ConstantHoisting, so we don't fold it into the select.

define i64 @opaque_constant2(i1 %cond, i64 %x) {
; CHECK-LABEL: opaque_constant2:
; CHECK:       @ BB#0:
; CHECK-NEXT:    mov r1, #1
; CHECK-NEXT:    tst r0, #1
; CHECK-NEXT:    orr r1, r1, #65536
; CHECK-NEXT:    mov r0, r1
; CHECK-NEXT:    moveq r0, #23
; CHECK-NEXT:    and r0, r0, r1
; CHECK-NEXT:    mov r1, #0
; CHECK-NEXT:    mov pc, lr
  %sel = select i1 %cond, i64 65537, i64 23
  %bo = and i64 %sel, 65537
  ret i64 %bo
}

