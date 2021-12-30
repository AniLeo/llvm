; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=avr --mcpu=atmega328 -O0 -verify-machineinstrs \
; RUN:     | FileCheck -check-prefix=CHECK-O0 %s
; RUN: llc < %s -mtriple=avr --mcpu=atmega328 -O3 -verify-machineinstrs \
; RUN:     | FileCheck -check-prefix=CHECK-O3 %s

@arr0 = addrspace(1) constant [4 x i16] [i16 123, i16 234, i16 456, i16 67], align 1
@arr1 = addrspace(1) constant [4 x i8] c"ABCD", align 1

define i16 @foo0(i16 %a) addrspace(1) {
; CHECK-O0-LABEL: foo0:
; CHECK-O0:       ; %bb.0: ; %entry
; CHECK-O0-NEXT:    push r28
; CHECK-O0-NEXT:    push r29
; CHECK-O0-NEXT:    in r28, 61
; CHECK-O0-NEXT:    in r29, 62
; CHECK-O0-NEXT:    sbiw r28, 2
; CHECK-O0-NEXT:    in r0, 63
; CHECK-O0-NEXT:    cli
; CHECK-O0-NEXT:    out 62, r29
; CHECK-O0-NEXT:    out 63, r0
; CHECK-O0-NEXT:    out 61, r28
; CHECK-O0-NEXT:    std Y+1, r24
; CHECK-O0-NEXT:    std Y+2, r25
; CHECK-O0-NEXT:    ldd r24, Y+1
; CHECK-O0-NEXT:    ldd r25, Y+2
; CHECK-O0-NEXT:    lsl r24
; CHECK-O0-NEXT:    rol r25
; CHECK-O0-NEXT:    subi r24, -lo8(arr0)
; CHECK-O0-NEXT:    sbci r25, -hi8(arr0)
; CHECK-O0-NEXT:    movw r30, r24
; CHECK-O0-NEXT:    lpm r24, Z+
; CHECK-O0-NEXT:    lpm r25, Z
; CHECK-O0-NEXT:    adiw r28, 2
; CHECK-O0-NEXT:    in r0, 63
; CHECK-O0-NEXT:    cli
; CHECK-O0-NEXT:    out 62, r29
; CHECK-O0-NEXT:    out 63, r0
; CHECK-O0-NEXT:    out 61, r28
; CHECK-O0-NEXT:    pop r29
; CHECK-O0-NEXT:    pop r28
; CHECK-O0-NEXT:    ret
;
; CHECK-O3-LABEL: foo0:
; CHECK-O3:       ; %bb.0: ; %entry
; CHECK-O3-NEXT:    push r28
; CHECK-O3-NEXT:    push r29
; CHECK-O3-NEXT:    in r28, 61
; CHECK-O3-NEXT:    in r29, 62
; CHECK-O3-NEXT:    sbiw r28, 2
; CHECK-O3-NEXT:    in r0, 63
; CHECK-O3-NEXT:    cli
; CHECK-O3-NEXT:    out 62, r29
; CHECK-O3-NEXT:    out 63, r0
; CHECK-O3-NEXT:    out 61, r28
; CHECK-O3-NEXT:    std Y+1, r24
; CHECK-O3-NEXT:    std Y+2, r25
; CHECK-O3-NEXT:    lsl r24
; CHECK-O3-NEXT:    rol r25
; CHECK-O3-NEXT:    subi r24, -lo8(arr0)
; CHECK-O3-NEXT:    sbci r25, -hi8(arr0)
; CHECK-O3-NEXT:    movw r30, r24
; CHECK-O3-NEXT:    lpm r24, Z+
; CHECK-O3-NEXT:    lpm r25, Z
; CHECK-O3-NEXT:    adiw r28, 2
; CHECK-O3-NEXT:    in r0, 63
; CHECK-O3-NEXT:    cli
; CHECK-O3-NEXT:    out 62, r29
; CHECK-O3-NEXT:    out 63, r0
; CHECK-O3-NEXT:    out 61, r28
; CHECK-O3-NEXT:    pop r29
; CHECK-O3-NEXT:    pop r28
; CHECK-O3-NEXT:    ret
entry:
  %a.addr = alloca i16, align 1
  store i16 %a, i16* %a.addr, align 1
  %0 = load i16, i16* %a.addr, align 1
  %arrayidx = getelementptr inbounds [4 x i16], [4 x i16] addrspace(1)* @arr0, i16 0, i16 %0
  %1 = load i16, i16 addrspace(1)* %arrayidx, align 1
  ret i16 %1
}

define i8 @foo1(i16 %a) addrspace(1) {
; CHECK-O0-LABEL: foo1:
; CHECK-O0:       ; %bb.0: ; %entry
; CHECK-O0-NEXT:    push r28
; CHECK-O0-NEXT:    push r29
; CHECK-O0-NEXT:    in r28, 61
; CHECK-O0-NEXT:    in r29, 62
; CHECK-O0-NEXT:    sbiw r28, 2
; CHECK-O0-NEXT:    in r0, 63
; CHECK-O0-NEXT:    cli
; CHECK-O0-NEXT:    out 62, r29
; CHECK-O0-NEXT:    out 63, r0
; CHECK-O0-NEXT:    out 61, r28
; CHECK-O0-NEXT:    std Y+1, r24
; CHECK-O0-NEXT:    std Y+2, r25
; CHECK-O0-NEXT:    ldd r24, Y+1
; CHECK-O0-NEXT:    ldd r25, Y+2
; CHECK-O0-NEXT:    subi r24, -lo8(arr1)
; CHECK-O0-NEXT:    sbci r25, -hi8(arr1)
; CHECK-O0-NEXT:    movw r30, r24
; CHECK-O0-NEXT:    lpm r24, Z
; CHECK-O0-NEXT:    adiw r28, 2
; CHECK-O0-NEXT:    in r0, 63
; CHECK-O0-NEXT:    cli
; CHECK-O0-NEXT:    out 62, r29
; CHECK-O0-NEXT:    out 63, r0
; CHECK-O0-NEXT:    out 61, r28
; CHECK-O0-NEXT:    pop r29
; CHECK-O0-NEXT:    pop r28
; CHECK-O0-NEXT:    ret
;
; CHECK-O3-LABEL: foo1:
; CHECK-O3:       ; %bb.0: ; %entry
; CHECK-O3-NEXT:    push r28
; CHECK-O3-NEXT:    push r29
; CHECK-O3-NEXT:    in r28, 61
; CHECK-O3-NEXT:    in r29, 62
; CHECK-O3-NEXT:    sbiw r28, 2
; CHECK-O3-NEXT:    in r0, 63
; CHECK-O3-NEXT:    cli
; CHECK-O3-NEXT:    out 62, r29
; CHECK-O3-NEXT:    out 63, r0
; CHECK-O3-NEXT:    out 61, r28
; CHECK-O3-NEXT:    std Y+1, r24
; CHECK-O3-NEXT:    std Y+2, r25
; CHECK-O3-NEXT:    subi r24, -lo8(arr1)
; CHECK-O3-NEXT:    sbci r25, -hi8(arr1)
; CHECK-O3-NEXT:    movw r30, r24
; CHECK-O3-NEXT:    lpm r24, Z
; CHECK-O3-NEXT:    adiw r28, 2
; CHECK-O3-NEXT:    in r0, 63
; CHECK-O3-NEXT:    cli
; CHECK-O3-NEXT:    out 62, r29
; CHECK-O3-NEXT:    out 63, r0
; CHECK-O3-NEXT:    out 61, r28
; CHECK-O3-NEXT:    pop r29
; CHECK-O3-NEXT:    pop r28
; CHECK-O3-NEXT:    ret
entry:
  %a.addr = alloca i16, align 1
  store i16 %a, i16* %a.addr, align 1
  %0 = load i16, i16* %a.addr, align 1
  %arrayidx = getelementptr inbounds [4 x i8], [4 x i8] addrspace(1)* @arr1, i16 0, i16 %0
  %1 = load i8, i8 addrspace(1)* %arrayidx, align 1
  ret i8 %1
}
