; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64le-linux-gnu < %s | FileCheck \
; RUN:   -check-prefix=CHECK-LE %s
; RUN: llc -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc64-linux-gnu < %s | FileCheck \
; RUN:   -check-prefix=CHECK-BE %s
; RUN: llc -ppc-asm-full-reg-names -verify-machineinstrs \
; RUN:   -mtriple=powerpc-linux-gnu < %s | FileCheck \
; RUN:   -check-prefix=CHECK-32 %s

; Free probe
define i8 @f0() #0 nounwind {
; CHECK-LE-LABEL: f0:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, -64(r1)
; CHECK-LE-NEXT:    lbz r3, -64(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f0:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, -64(r1)
; CHECK-BE-NEXT:    lbz r3, -64(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f0:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    stwu r1, -80(r1)
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    addi r1, r1, 80
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 64
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f1() #0 "stack-probe-size"="0" {
; CHECK-LE-LABEL: f1:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    li r0, 259
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:  .LBB1_1: # %entry
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    stdu r12, -16(r1)
; CHECK-LE-NEXT:    bdnz .LBB1_1
; CHECK-LE-NEXT:  # %bb.2: # %entry
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 4144
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    addi r1, r1, 4144
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f1:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    li r0, 260
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:  .LBB1_1: # %entry
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    stdu r12, -16(r1)
; CHECK-BE-NEXT:    bdnz .LBB1_1
; CHECK-BE-NEXT:  # %bb.2: # %entry
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 4160
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    addi r1, r1, 4160
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f1:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    li r0, 257
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:  .LBB1_1: # %entry
; CHECK-32-NEXT:    #
; CHECK-32-NEXT:    stwu r12, -16(r1)
; CHECK-32-NEXT:    bdnz .LBB1_1
; CHECK-32-NEXT:  # %bb.2: # %entry
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 4112
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    addi r1, r1, 4112
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 4096
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f2() #0 {
; CHECK-LE-LABEL: f2:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    stdu r12, -48(r1)
; CHECK-LE-NEXT:    li r0, 16
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:  .LBB2_1: # %entry
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    bdnz .LBB2_1
; CHECK-LE-NEXT:  # %bb.2: # %entry
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 65584
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f2:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    stdu r12, -64(r1)
; CHECK-BE-NEXT:    li r0, 16
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:  .LBB2_1: # %entry
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    bdnz .LBB2_1
; CHECK-BE-NEXT:  # %bb.2: # %entry
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 65600
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f2:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    stwu r12, -16(r1)
; CHECK-32-NEXT:    li r0, 16
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:  .LBB2_1: # %entry
; CHECK-32-NEXT:    #
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    bdnz .LBB2_1
; CHECK-32-NEXT:  # %bb.2: # %entry
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 65552
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 65536
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f3() #0 "stack-probe-size"="32768" {
; CHECK-LE-LABEL: f3:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    stdu r12, -48(r1)
; CHECK-LE-NEXT:    stdu r12, -32768(r1)
; CHECK-LE-NEXT:    stdu r12, -32768(r1)
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 65584
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f3:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    stdu r12, -64(r1)
; CHECK-BE-NEXT:    stdu r12, -32768(r1)
; CHECK-BE-NEXT:    stdu r12, -32768(r1)
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 65600
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f3:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    stwu r12, -16(r1)
; CHECK-32-NEXT:    stwu r12, -32768(r1)
; CHECK-32-NEXT:    stwu r12, -32768(r1)
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 65552
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 65536
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

; Same as f2, but without protection.
define i8 @f4() {
; CHECK-LE-LABEL: f4:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    lis r0, -2
; CHECK-LE-NEXT:    ori r0, r0, 65488
; CHECK-LE-NEXT:    stdux r1, r1, r0
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 65584
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f4:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lis r0, -2
; CHECK-BE-NEXT:    ori r0, r0, 65472
; CHECK-BE-NEXT:    stdux r1, r1, r0
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 65600
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f4:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    lis r0, -2
; CHECK-32-NEXT:    ori r0, r0, 65520
; CHECK-32-NEXT:    stwux r1, r1, r0
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 65552
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 65536
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f5() #0 "stack-probe-size"="65536" {
; CHECK-LE-LABEL: f5:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    stdu r12, -48(r1)
; CHECK-LE-NEXT:    li r0, 16
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:    lis r0, -1
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:  .LBB5_1: # %entry
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    stdux r12, r1, r0
; CHECK-LE-NEXT:    bdnz .LBB5_1
; CHECK-LE-NEXT:  # %bb.2: # %entry
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 1048624
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f5:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    stdu r12, -64(r1)
; CHECK-BE-NEXT:    li r0, 16
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:    lis r0, -1
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:  .LBB5_1: # %entry
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    stdux r12, r1, r0
; CHECK-BE-NEXT:    bdnz .LBB5_1
; CHECK-BE-NEXT:  # %bb.2: # %entry
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 1048640
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f5:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    stwu r12, -16(r1)
; CHECK-32-NEXT:    li r0, 16
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:    lis r0, -1
; CHECK-32-NEXT:    nop
; CHECK-32-NEXT:  .LBB5_1: # %entry
; CHECK-32-NEXT:    #
; CHECK-32-NEXT:    stwux r12, r1, r0
; CHECK-32-NEXT:    bdnz .LBB5_1
; CHECK-32-NEXT:  # %bb.2: # %entry
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 1048592
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 1048576
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f6() #0 {
; CHECK-LE-LABEL: f6:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    stdu r12, -48(r1)
; CHECK-LE-NEXT:    lis r0, 4
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:  .LBB6_1: # %entry
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    bdnz .LBB6_1
; CHECK-LE-NEXT:  # %bb.2: # %entry
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 1073741872
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 48(r1)
; CHECK-LE-NEXT:    lbz r3, 48(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f6:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    stdu r12, -64(r1)
; CHECK-BE-NEXT:    lis r0, 4
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:  .LBB6_1: # %entry
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    bdnz .LBB6_1
; CHECK-BE-NEXT:  # %bb.2: # %entry
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 1073741888
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 64(r1)
; CHECK-BE-NEXT:    lbz r3, 64(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f6:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    stwu r12, -16(r1)
; CHECK-32-NEXT:    lis r0, 4
; CHECK-32-NEXT:    nop
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:  .LBB6_1: # %entry
; CHECK-32-NEXT:    #
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    bdnz .LBB6_1
; CHECK-32-NEXT:  # %bb.2: # %entry
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 1073741840
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 16(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 16(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 1073741824
  %b = getelementptr inbounds i8, i8* %a, i64 63
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

define i8 @f7() #0 "stack-probe-size"="65536" {
; CHECK-LE-LABEL: f7:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    mr r12, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-LE-NEXT:    lis r0, -1
; CHECK-LE-NEXT:    ori r0, r0, 13776
; CHECK-LE-NEXT:    stdux r12, r1, r0
; CHECK-LE-NEXT:    li r0, 15258
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:    lis r0, -1
; CHECK-LE-NEXT:    nop
; CHECK-LE-NEXT:  .LBB7_1: # %entry
; CHECK-LE-NEXT:    #
; CHECK-LE-NEXT:    stdux r12, r1, r0
; CHECK-LE-NEXT:    bdnz .LBB7_1
; CHECK-LE-NEXT:  # %bb.2: # %entry
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_offset 1000000048
; CHECK-LE-NEXT:    li r3, 3
; CHECK-LE-NEXT:    stb r3, 41(r1)
; CHECK-LE-NEXT:    lbz r3, 41(r1)
; CHECK-LE-NEXT:    ld r1, 0(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f7:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mr r12, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r12, 0
; CHECK-BE-NEXT:    lis r0, -1
; CHECK-BE-NEXT:    ori r0, r0, 13760
; CHECK-BE-NEXT:    stdux r12, r1, r0
; CHECK-BE-NEXT:    li r0, 15258
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:    lis r0, -1
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:  .LBB7_1: # %entry
; CHECK-BE-NEXT:    #
; CHECK-BE-NEXT:    stdux r12, r1, r0
; CHECK-BE-NEXT:    bdnz .LBB7_1
; CHECK-BE-NEXT:  # %bb.2: # %entry
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_offset 1000000064
; CHECK-BE-NEXT:    li r3, 3
; CHECK-BE-NEXT:    stb r3, 57(r1)
; CHECK-BE-NEXT:    lbz r3, 57(r1)
; CHECK-BE-NEXT:    ld r1, 0(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f7:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    lis r0, -1
; CHECK-32-NEXT:    ori r0, r0, 13808
; CHECK-32-NEXT:    stwux r12, r1, r0
; CHECK-32-NEXT:    li r0, 15258
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:    lis r0, -1
; CHECK-32-NEXT:    nop
; CHECK-32-NEXT:  .LBB7_1: # %entry
; CHECK-32-NEXT:    #
; CHECK-32-NEXT:    stwux r12, r1, r0
; CHECK-32-NEXT:    bdnz .LBB7_1
; CHECK-32-NEXT:  # %bb.2: # %entry
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    .cfi_def_cfa_offset 1000000016
; CHECK-32-NEXT:    li r3, 3
; CHECK-32-NEXT:    stb r3, 9(r1)
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lbz r3, 9(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
entry:
  %a = alloca i8, i64 1000000007
  %b = getelementptr inbounds i8, i8* %a, i64 101
  store volatile i8 3, i8* %a
  %c = load volatile i8, i8* %a
  ret i8 %c
}

attributes #0 = { "probe-stack"="inline-asm" }
