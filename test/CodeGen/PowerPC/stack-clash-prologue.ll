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

; alloca + align < probe_size
define i32 @f8(i64 %i) local_unnamed_addr #0 {
; CHECK-LE-LABEL: f8:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    clrldi r0, r1, 58
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    subfic r0, r0, -896
; CHECK-LE-NEXT:    stdux r1, r1, r0
; CHECK-LE-NEXT:    .cfi_def_cfa_register r30
; CHECK-LE-NEXT:    .cfi_offset r30, -16
; CHECK-LE-NEXT:    addi r4, r1, 64
; CHECK-LE-NEXT:    sldi r3, r3, 2
; CHECK-LE-NEXT:    li r5, 1
; CHECK-LE-NEXT:    stwx r5, r4, r3
; CHECK-LE-NEXT:    lwz r3, 64(r1)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f8:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    clrldi r0, r1, 58
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    subfic r0, r0, -896
; CHECK-BE-NEXT:    stdux r1, r1, r0
; CHECK-BE-NEXT:    .cfi_def_cfa_register r30
; CHECK-BE-NEXT:    .cfi_offset r30, -16
; CHECK-BE-NEXT:    addi r4, r1, 64
; CHECK-BE-NEXT:    li r5, 1
; CHECK-BE-NEXT:    sldi r3, r3, 2
; CHECK-BE-NEXT:    stwx r5, r4, r3
; CHECK-BE-NEXT:    lwz r3, 64(r1)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f8:
; CHECK-32:       # %bb.0:
; CHECK-32-NEXT:    clrlwi r0, r1, 26
; CHECK-32-NEXT:    subfic r0, r0, -896
; CHECK-32-NEXT:    stwux r1, r1, r0
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    addic r0, r0, -8
; CHECK-32-NEXT:    stwx r30, 0, r0
; CHECK-32-NEXT:    addic r30, r0, 8
; CHECK-32-NEXT:    .cfi_def_cfa_register r30
; CHECK-32-NEXT:    .cfi_offset r30, -8
; CHECK-32-NEXT:    addi r3, r1, 64
; CHECK-32-NEXT:    li r5, 1
; CHECK-32-NEXT:    slwi r4, r4, 2
; CHECK-32-NEXT:    stwx r5, r3, r4
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lwz r3, 64(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    lwz r30, -8(r31)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
  %a = alloca i32, i32 200, align 64
  %b = getelementptr inbounds i32, i32* %a, i64 %i
  store volatile i32 1, i32* %b
  %c = load volatile i32, i32* %a
  ret i32 %c
}

; alloca > probe_size, align > probe_size
define i32 @f9(i64 %i) local_unnamed_addr #0 {
; CHECK-LE-LABEL: f9:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-LE-NEXT:    clrldi r0, r30, 53
; CHECK-LE-NEXT:    subc r12, r30, r0
; CHECK-LE-NEXT:    clrldi r0, r0, 52
; CHECK-LE-NEXT:    cmpdi r0, 0
; CHECK-LE-NEXT:    beq cr0, .LBB9_2
; CHECK-LE-NEXT:  # %bb.1:
; CHECK-LE-NEXT:    neg r0, r0
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:  .LBB9_2:
; CHECK-LE-NEXT:    li r0, -4096
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    beq cr0, .LBB9_4
; CHECK-LE-NEXT:  .LBB9_3:
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    bne cr0, .LBB9_3
; CHECK-LE-NEXT:  .LBB9_4:
; CHECK-LE-NEXT:    mr r12, r30
; CHECK-LE-NEXT:    stdu r12, -2048(r1)
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_register r30
; CHECK-LE-NEXT:    .cfi_offset r30, -16
; CHECK-LE-NEXT:    addi r4, r1, 2048
; CHECK-LE-NEXT:    sldi r3, r3, 2
; CHECK-LE-NEXT:    li r5, 1
; CHECK-LE-NEXT:    stwx r5, r4, r3
; CHECK-LE-NEXT:    lwz r3, 2048(r1)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f9:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-BE-NEXT:    clrldi r0, r30, 53
; CHECK-BE-NEXT:    subc r12, r30, r0
; CHECK-BE-NEXT:    clrldi r0, r0, 52
; CHECK-BE-NEXT:    cmpdi r0, 0
; CHECK-BE-NEXT:    beq cr0, .LBB9_2
; CHECK-BE-NEXT:  # %bb.1:
; CHECK-BE-NEXT:    neg r0, r0
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:  .LBB9_2:
; CHECK-BE-NEXT:    li r0, -4096
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    beq cr0, .LBB9_4
; CHECK-BE-NEXT:  .LBB9_3:
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    bne cr0, .LBB9_3
; CHECK-BE-NEXT:  .LBB9_4:
; CHECK-BE-NEXT:    mr r12, r30
; CHECK-BE-NEXT:    stdu r12, -2048(r1)
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_register r30
; CHECK-BE-NEXT:    .cfi_offset r30, -16
; CHECK-BE-NEXT:    addi r4, r1, 2048
; CHECK-BE-NEXT:    li r5, 1
; CHECK-BE-NEXT:    sldi r3, r3, 2
; CHECK-BE-NEXT:    stwx r5, r4, r3
; CHECK-BE-NEXT:    lwz r3, 2048(r1)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f9:
; CHECK-32:       # %bb.0:
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    clrlwi r0, r12, 21
; CHECK-32-NEXT:    subc r1, r1, r0
; CHECK-32-NEXT:    stwu r12, -2048(r1)
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    addic r0, r0, -8
; CHECK-32-NEXT:    stwx r30, 0, r0
; CHECK-32-NEXT:    addic r30, r0, 8
; CHECK-32-NEXT:    .cfi_def_cfa_register r30
; CHECK-32-NEXT:    .cfi_offset r30, -8
; CHECK-32-NEXT:    addi r3, r1, 2048
; CHECK-32-NEXT:    li r5, 1
; CHECK-32-NEXT:    slwi r4, r4, 2
; CHECK-32-NEXT:    stwx r5, r3, r4
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lwz r3, 2048(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    lwz r30, -8(r31)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
  %a = alloca i32, i32 2000, align 2048
  %b = getelementptr inbounds i32, i32* %a, i64 %i
  store volatile i32 1, i32* %b
  %c = load volatile i32, i32* %a
  ret i32 %c
}

; alloca < probe_size, align < probe_size, alloca + align > probe_size
define i32 @f10(i64 %i) local_unnamed_addr #0 {
; CHECK-LE-LABEL: f10:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-LE-NEXT:    clrldi r0, r30, 54
; CHECK-LE-NEXT:    subc r12, r30, r0
; CHECK-LE-NEXT:    clrldi r0, r0, 52
; CHECK-LE-NEXT:    cmpdi r0, 0
; CHECK-LE-NEXT:    beq cr0, .LBB10_2
; CHECK-LE-NEXT:  # %bb.1:
; CHECK-LE-NEXT:    neg r0, r0
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:  .LBB10_2:
; CHECK-LE-NEXT:    li r0, -4096
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    beq cr0, .LBB10_4
; CHECK-LE-NEXT:  .LBB10_3:
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    bne cr0, .LBB10_3
; CHECK-LE-NEXT:  .LBB10_4:
; CHECK-LE-NEXT:    mr r12, r30
; CHECK-LE-NEXT:    stdu r12, -1024(r1)
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_register r30
; CHECK-LE-NEXT:    .cfi_offset r30, -16
; CHECK-LE-NEXT:    addi r4, r1, 1024
; CHECK-LE-NEXT:    sldi r3, r3, 2
; CHECK-LE-NEXT:    li r5, 1
; CHECK-LE-NEXT:    stwx r5, r4, r3
; CHECK-LE-NEXT:    lwz r3, 1024(r1)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f10:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-BE-NEXT:    clrldi r0, r30, 54
; CHECK-BE-NEXT:    subc r12, r30, r0
; CHECK-BE-NEXT:    clrldi r0, r0, 52
; CHECK-BE-NEXT:    cmpdi r0, 0
; CHECK-BE-NEXT:    beq cr0, .LBB10_2
; CHECK-BE-NEXT:  # %bb.1:
; CHECK-BE-NEXT:    neg r0, r0
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:  .LBB10_2:
; CHECK-BE-NEXT:    li r0, -4096
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    beq cr0, .LBB10_4
; CHECK-BE-NEXT:  .LBB10_3:
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    bne cr0, .LBB10_3
; CHECK-BE-NEXT:  .LBB10_4:
; CHECK-BE-NEXT:    mr r12, r30
; CHECK-BE-NEXT:    stdu r12, -1024(r1)
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_register r30
; CHECK-BE-NEXT:    .cfi_offset r30, -16
; CHECK-BE-NEXT:    addi r4, r1, 1024
; CHECK-BE-NEXT:    li r5, 1
; CHECK-BE-NEXT:    sldi r3, r3, 2
; CHECK-BE-NEXT:    stwx r5, r4, r3
; CHECK-BE-NEXT:    lwz r3, 1024(r1)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f10:
; CHECK-32:       # %bb.0:
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    clrlwi r0, r12, 22
; CHECK-32-NEXT:    subc r1, r1, r0
; CHECK-32-NEXT:    stwu r12, -1024(r1)
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    addic r0, r0, -8
; CHECK-32-NEXT:    stwx r30, 0, r0
; CHECK-32-NEXT:    addic r30, r0, 8
; CHECK-32-NEXT:    .cfi_def_cfa_register r30
; CHECK-32-NEXT:    .cfi_offset r30, -8
; CHECK-32-NEXT:    addi r3, r1, 1024
; CHECK-32-NEXT:    li r5, 1
; CHECK-32-NEXT:    slwi r4, r4, 2
; CHECK-32-NEXT:    stwx r5, r3, r4
; CHECK-32-NEXT:    mr r0, r31
; CHECK-32-NEXT:    lwz r3, 1024(r1)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    lwz r30, -8(r31)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
  %a = alloca i32, i32 1000, align 1024
  %b = getelementptr inbounds i32, i32* %a, i64 %i
  store volatile i32 1, i32* %b
  %c = load volatile i32, i32* %a
  ret i32 %c
}

define void @f11(i32 %vla_size, i64 %i) #0 {
; CHECK-LE-LABEL: f11:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    std r31, -8(r1)
; CHECK-LE-NEXT:    std r30, -16(r1)
; CHECK-LE-NEXT:    mr r30, r1
; CHECK-LE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-LE-NEXT:    clrldi r0, r30, 49
; CHECK-LE-NEXT:    subc r12, r30, r0
; CHECK-LE-NEXT:    clrldi r0, r0, 52
; CHECK-LE-NEXT:    cmpdi r0, 0
; CHECK-LE-NEXT:    beq cr0, .LBB11_2
; CHECK-LE-NEXT:  # %bb.1:
; CHECK-LE-NEXT:    neg r0, r0
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:  .LBB11_2:
; CHECK-LE-NEXT:    li r0, -4096
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    beq cr0, .LBB11_4
; CHECK-LE-NEXT:  .LBB11_3:
; CHECK-LE-NEXT:    stdux r30, r1, r0
; CHECK-LE-NEXT:    cmpd r1, r12
; CHECK-LE-NEXT:    bne cr0, .LBB11_3
; CHECK-LE-NEXT:  .LBB11_4:
; CHECK-LE-NEXT:    mr r12, r30
; CHECK-LE-NEXT:    li r0, 24
; CHECK-LE-NEXT:    mtctr r0
; CHECK-LE-NEXT:  .LBB11_5:
; CHECK-LE-NEXT:    stdu r12, -4096(r1)
; CHECK-LE-NEXT:    bdnz .LBB11_5
; CHECK-LE-NEXT:  # %bb.6:
; CHECK-LE-NEXT:    .cfi_def_cfa_register r1
; CHECK-LE-NEXT:    .cfi_def_cfa_register r30
; CHECK-LE-NEXT:    .cfi_offset r31, -8
; CHECK-LE-NEXT:    .cfi_offset r30, -16
; CHECK-LE-NEXT:    clrldi r3, r3, 32
; CHECK-LE-NEXT:    lis r5, 1
; CHECK-LE-NEXT:    mr r31, r1
; CHECK-LE-NEXT:    li r6, 1
; CHECK-LE-NEXT:    addi r3, r3, 15
; CHECK-LE-NEXT:    ori r5, r5, 0
; CHECK-LE-NEXT:    rldicl r3, r3, 60, 4
; CHECK-LE-NEXT:    sldi r4, r4, 2
; CHECK-LE-NEXT:    add r5, r31, r5
; CHECK-LE-NEXT:    rldicl r3, r3, 4, 31
; CHECK-LE-NEXT:    stwx r6, r5, r4
; CHECK-LE-NEXT:    li r4, -32768
; CHECK-LE-NEXT:    neg r7, r3
; CHECK-LE-NEXT:    ld r3, 0(r1)
; CHECK-LE-NEXT:    and r4, r7, r4
; CHECK-LE-NEXT:    mr r7, r4
; CHECK-LE-NEXT:    li r4, -4096
; CHECK-LE-NEXT:    divd r5, r7, r4
; CHECK-LE-NEXT:    mulld r4, r5, r4
; CHECK-LE-NEXT:    sub r5, r7, r4
; CHECK-LE-NEXT:    add r4, r1, r7
; CHECK-LE-NEXT:    stdux r3, r1, r5
; CHECK-LE-NEXT:    cmpd r1, r4
; CHECK-LE-NEXT:    beq cr0, .LBB11_8
; CHECK-LE-NEXT:  .LBB11_7:
; CHECK-LE-NEXT:    stdu r3, -4096(r1)
; CHECK-LE-NEXT:    cmpd r1, r4
; CHECK-LE-NEXT:    bne cr0, .LBB11_7
; CHECK-LE-NEXT:  .LBB11_8:
; CHECK-LE-NEXT:    addi r3, r1, -32768
; CHECK-LE-NEXT:    lbz r3, 0(r3)
; CHECK-LE-NEXT:    mr r1, r30
; CHECK-LE-NEXT:    ld r31, -8(r1)
; CHECK-LE-NEXT:    ld r30, -16(r1)
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: f11:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    std r31, -8(r1)
; CHECK-BE-NEXT:    std r30, -16(r1)
; CHECK-BE-NEXT:    mr r30, r1
; CHECK-BE-NEXT:    .cfi_def_cfa r30, 0
; CHECK-BE-NEXT:    clrldi r0, r30, 49
; CHECK-BE-NEXT:    subc r12, r30, r0
; CHECK-BE-NEXT:    clrldi r0, r0, 52
; CHECK-BE-NEXT:    cmpdi r0, 0
; CHECK-BE-NEXT:    beq cr0, .LBB11_2
; CHECK-BE-NEXT:  # %bb.1:
; CHECK-BE-NEXT:    neg r0, r0
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:  .LBB11_2:
; CHECK-BE-NEXT:    li r0, -4096
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    beq cr0, .LBB11_4
; CHECK-BE-NEXT:  .LBB11_3:
; CHECK-BE-NEXT:    stdux r30, r1, r0
; CHECK-BE-NEXT:    cmpd r1, r12
; CHECK-BE-NEXT:    bne cr0, .LBB11_3
; CHECK-BE-NEXT:  .LBB11_4:
; CHECK-BE-NEXT:    mr r12, r30
; CHECK-BE-NEXT:    li r0, 24
; CHECK-BE-NEXT:    mtctr r0
; CHECK-BE-NEXT:  .LBB11_5:
; CHECK-BE-NEXT:    stdu r12, -4096(r1)
; CHECK-BE-NEXT:    bdnz .LBB11_5
; CHECK-BE-NEXT:  # %bb.6:
; CHECK-BE-NEXT:    .cfi_def_cfa_register r1
; CHECK-BE-NEXT:    .cfi_def_cfa_register r30
; CHECK-BE-NEXT:    .cfi_offset r31, -8
; CHECK-BE-NEXT:    .cfi_offset r30, -16
; CHECK-BE-NEXT:    clrldi r3, r3, 32
; CHECK-BE-NEXT:    lis r5, 1
; CHECK-BE-NEXT:    addi r3, r3, 15
; CHECK-BE-NEXT:    mr r31, r1
; CHECK-BE-NEXT:    ori r5, r5, 0
; CHECK-BE-NEXT:    rldicl r3, r3, 60, 4
; CHECK-BE-NEXT:    add r5, r31, r5
; CHECK-BE-NEXT:    sldi r4, r4, 2
; CHECK-BE-NEXT:    li r6, 1
; CHECK-BE-NEXT:    rldicl r3, r3, 4, 31
; CHECK-BE-NEXT:    stwx r6, r5, r4
; CHECK-BE-NEXT:    neg r7, r3
; CHECK-BE-NEXT:    li r4, -32768
; CHECK-BE-NEXT:    and r4, r7, r4
; CHECK-BE-NEXT:    ld r3, 0(r1)
; CHECK-BE-NEXT:    mr r7, r4
; CHECK-BE-NEXT:    li r4, -4096
; CHECK-BE-NEXT:    divd r5, r7, r4
; CHECK-BE-NEXT:    mulld r4, r5, r4
; CHECK-BE-NEXT:    sub r5, r7, r4
; CHECK-BE-NEXT:    add r4, r1, r7
; CHECK-BE-NEXT:    stdux r3, r1, r5
; CHECK-BE-NEXT:    cmpd r1, r4
; CHECK-BE-NEXT:    beq cr0, .LBB11_8
; CHECK-BE-NEXT:  .LBB11_7:
; CHECK-BE-NEXT:    stdu r3, -4096(r1)
; CHECK-BE-NEXT:    cmpd r1, r4
; CHECK-BE-NEXT:    bne cr0, .LBB11_7
; CHECK-BE-NEXT:  .LBB11_8:
; CHECK-BE-NEXT:    addi r3, r1, -32768
; CHECK-BE-NEXT:    lbz r3, 0(r3)
; CHECK-BE-NEXT:    mr r1, r30
; CHECK-BE-NEXT:    ld r31, -8(r1)
; CHECK-BE-NEXT:    ld r30, -16(r1)
; CHECK-BE-NEXT:    blr
;
; CHECK-32-LABEL: f11:
; CHECK-32:       # %bb.0:
; CHECK-32-NEXT:    mr r12, r1
; CHECK-32-NEXT:    .cfi_def_cfa r12, 0
; CHECK-32-NEXT:    clrlwi r0, r12, 17
; CHECK-32-NEXT:    subc r1, r1, r0
; CHECK-32-NEXT:    li r0, 24
; CHECK-32-NEXT:    mtctr r0
; CHECK-32-NEXT:  .LBB11_1:
; CHECK-32-NEXT:    stwu r12, -4096(r1)
; CHECK-32-NEXT:    bdnz .LBB11_1
; CHECK-32-NEXT:  # %bb.2:
; CHECK-32-NEXT:    .cfi_def_cfa_register r1
; CHECK-32-NEXT:    sub r0, r1, r12
; CHECK-32-NEXT:    sub r0, r1, r0
; CHECK-32-NEXT:    addic r0, r0, -4
; CHECK-32-NEXT:    stwx r31, 0, r0
; CHECK-32-NEXT:    addic r0, r0, -4
; CHECK-32-NEXT:    stwx r30, 0, r0
; CHECK-32-NEXT:    addic r30, r0, 8
; CHECK-32-NEXT:    .cfi_def_cfa_register r30
; CHECK-32-NEXT:    .cfi_offset r31, -4
; CHECK-32-NEXT:    .cfi_offset r30, -8
; CHECK-32-NEXT:    lis r4, 1
; CHECK-32-NEXT:    mr r31, r1
; CHECK-32-NEXT:    ori r4, r4, 0
; CHECK-32-NEXT:    addi r3, r3, 15
; CHECK-32-NEXT:    add r4, r31, r4
; CHECK-32-NEXT:    li r5, 1
; CHECK-32-NEXT:    slwi r6, r6, 2
; CHECK-32-NEXT:    rlwinm r3, r3, 0, 0, 27
; CHECK-32-NEXT:    neg r7, r3
; CHECK-32-NEXT:    stwx r5, r4, r6
; CHECK-32-NEXT:    li r4, -32768
; CHECK-32-NEXT:    and r4, r7, r4
; CHECK-32-NEXT:    lwz r3, 0(r1)
; CHECK-32-NEXT:    mr r7, r4
; CHECK-32-NEXT:    li r4, -4096
; CHECK-32-NEXT:    divw r5, r7, r4
; CHECK-32-NEXT:    mullw r4, r5, r4
; CHECK-32-NEXT:    sub r5, r7, r4
; CHECK-32-NEXT:    add r4, r1, r7
; CHECK-32-NEXT:    stwux r3, r1, r5
; CHECK-32-NEXT:    cmpw r1, r4
; CHECK-32-NEXT:    beq cr0, .LBB11_4
; CHECK-32-NEXT:  .LBB11_3:
; CHECK-32-NEXT:    stwu r3, -4096(r1)
; CHECK-32-NEXT:    cmpw r1, r4
; CHECK-32-NEXT:    bne cr0, .LBB11_3
; CHECK-32-NEXT:  .LBB11_4:
; CHECK-32-NEXT:    addi r3, r1, -32768
; CHECK-32-NEXT:    lbz r3, 0(r3)
; CHECK-32-NEXT:    lwz r31, 0(r1)
; CHECK-32-NEXT:    lwz r0, -4(r31)
; CHECK-32-NEXT:    lwz r30, -8(r31)
; CHECK-32-NEXT:    mr r1, r31
; CHECK-32-NEXT:    mr r31, r0
; CHECK-32-NEXT:    blr
  %a = alloca i32, i32 4096, align 32768
  %b = getelementptr inbounds i32, i32* %a, i64 %i
  store volatile i32 1, i32* %b
  %1 = zext i32 %vla_size to i64
  %vla = alloca i8, i64 %1, align 2048
  %2 = load volatile i8, i8* %vla, align 2048
  ret void
}

attributes #0 = { "probe-stack"="inline-asm" }
