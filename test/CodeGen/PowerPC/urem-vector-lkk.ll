; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:		-mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,P9LE
; RUN: llc -mcpu=pwr9 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,P9BE
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,P8LE
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,P8BE

define <4 x i16> @fold_urem_vec_1(<4 x i16> %x) {
; P9LE-LABEL: fold_urem_vec_1:
; P9LE:       # %bb.0:
; P9LE-NEXT:    li r3, 4
; P9LE-NEXT:    lis r4, 21399
; P9LE-NEXT:    lis r5, 8456
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    ori r4, r4, 33437
; P9LE-NEXT:    ori r5, r5, 16913
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    srwi r4, r4, 5
; P9LE-NEXT:    mulli r4, r4, 98
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    lis r4, 16727
; P9LE-NEXT:    mtvsrd v3, r3
; P9LE-NEXT:    li r3, 6
; P9LE-NEXT:    ori r4, r4, 2287
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    srwi r4, r4, 8
; P9LE-NEXT:    mulli r4, r4, 1003
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 2
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    clrlwi r4, r3, 16
; P9LE-NEXT:    rlwinm r3, r3, 30, 18, 31
; P9LE-NEXT:    mulhwu r3, r3, r5
; P9LE-NEXT:    srwi r3, r3, 2
; P9LE-NEXT:    mulli r3, r3, 124
; P9LE-NEXT:    sub r3, r4, r3
; P9LE-NEXT:    lis r4, 22765
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 0
; P9LE-NEXT:    ori r4, r4, 8969
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    sub r5, r3, r4
; P9LE-NEXT:    srwi r5, r5, 1
; P9LE-NEXT:    add r4, r5, r4
; P9LE-NEXT:    srwi r4, r4, 6
; P9LE-NEXT:    mulli r4, r4, 95
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mtvsrd v2, r3
; P9LE-NEXT:    vmrghh v2, v4, v2
; P9LE-NEXT:    vmrglw v2, v3, v2
; P9LE-NEXT:    blr
;
; P9BE-LABEL: fold_urem_vec_1:
; P9BE:       # %bb.0:
; P9BE-NEXT:    li r3, 6
; P9BE-NEXT:    lis r4, 16727
; P9BE-NEXT:    lis r5, 8456
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    ori r4, r4, 2287
; P9BE-NEXT:    ori r5, r5, 16913
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    srwi r4, r4, 8
; P9BE-NEXT:    mulli r4, r4, 1003
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    lis r4, 21399
; P9BE-NEXT:    mtvsrwz v3, r3
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    ori r4, r4, 33437
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    srwi r4, r4, 5
; P9BE-NEXT:    mulli r4, r4, 98
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; P9BE-NEXT:    lxv v5, 0(r3)
; P9BE-NEXT:    li r3, 2
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r4, r3, 16
; P9BE-NEXT:    rlwinm r3, r3, 30, 18, 31
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mulhwu r3, r3, r5
; P9BE-NEXT:    srwi r3, r3, 2
; P9BE-NEXT:    mulli r3, r3, 124
; P9BE-NEXT:    sub r3, r4, r3
; P9BE-NEXT:    lis r4, 22765
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    ori r4, r4, 8969
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    sub r5, r3, r4
; P9BE-NEXT:    srwi r5, r5, 1
; P9BE-NEXT:    add r4, r5, r4
; P9BE-NEXT:    srwi r4, r4, 6
; P9BE-NEXT:    mulli r4, r4, 95
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrwz v2, r3
; P9BE-NEXT:    vperm v2, v2, v4, v5
; P9BE-NEXT:    vmrghw v2, v2, v3
; P9BE-NEXT:    blr
;
; P8LE-LABEL: fold_urem_vec_1:
; P8LE:       # %bb.0:
; P8LE-NEXT:    xxswapd vs0, v2
; P8LE-NEXT:    lis r3, 22765
; P8LE-NEXT:    lis r7, 21399
; P8LE-NEXT:    lis r9, 16727
; P8LE-NEXT:    lis r10, 8456
; P8LE-NEXT:    ori r3, r3, 8969
; P8LE-NEXT:    ori r7, r7, 33437
; P8LE-NEXT:    ori r9, r9, 2287
; P8LE-NEXT:    ori r10, r10, 16913
; P8LE-NEXT:    mffprd r4, f0
; P8LE-NEXT:    clrldi r6, r4, 48
; P8LE-NEXT:    rldicl r5, r4, 32, 48
; P8LE-NEXT:    clrlwi r6, r6, 16
; P8LE-NEXT:    rldicl r8, r4, 16, 48
; P8LE-NEXT:    clrlwi r5, r5, 16
; P8LE-NEXT:    mulhwu r3, r6, r3
; P8LE-NEXT:    rldicl r4, r4, 48, 48
; P8LE-NEXT:    clrlwi r8, r8, 16
; P8LE-NEXT:    rlwinm r11, r4, 30, 18, 31
; P8LE-NEXT:    mulhwu r7, r5, r7
; P8LE-NEXT:    clrlwi r4, r4, 16
; P8LE-NEXT:    mulhwu r9, r8, r9
; P8LE-NEXT:    mulhwu r10, r11, r10
; P8LE-NEXT:    sub r11, r6, r3
; P8LE-NEXT:    srwi r11, r11, 1
; P8LE-NEXT:    srwi r7, r7, 5
; P8LE-NEXT:    add r3, r11, r3
; P8LE-NEXT:    srwi r9, r9, 8
; P8LE-NEXT:    srwi r10, r10, 2
; P8LE-NEXT:    srwi r3, r3, 6
; P8LE-NEXT:    mulli r7, r7, 98
; P8LE-NEXT:    mulli r9, r9, 1003
; P8LE-NEXT:    mulli r3, r3, 95
; P8LE-NEXT:    mulli r10, r10, 124
; P8LE-NEXT:    sub r5, r5, r7
; P8LE-NEXT:    sub r7, r8, r9
; P8LE-NEXT:    sub r3, r6, r3
; P8LE-NEXT:    mtvsrd v2, r5
; P8LE-NEXT:    sub r4, r4, r10
; P8LE-NEXT:    mtvsrd v3, r7
; P8LE-NEXT:    mtvsrd v4, r3
; P8LE-NEXT:    mtvsrd v5, r4
; P8LE-NEXT:    vmrghh v2, v3, v2
; P8LE-NEXT:    vmrghh v3, v5, v4
; P8LE-NEXT:    vmrglw v2, v2, v3
; P8LE-NEXT:    blr
;
; P8BE-LABEL: fold_urem_vec_1:
; P8BE:       # %bb.0:
; P8BE-NEXT:    mfvsrd r4, v2
; P8BE-NEXT:    lis r3, 22765
; P8BE-NEXT:    lis r7, 16727
; P8BE-NEXT:    lis r9, 21399
; P8BE-NEXT:    lis r10, 8456
; P8BE-NEXT:    ori r3, r3, 8969
; P8BE-NEXT:    ori r7, r7, 2287
; P8BE-NEXT:    ori r9, r9, 33437
; P8BE-NEXT:    ori r10, r10, 16913
; P8BE-NEXT:    rldicl r6, r4, 16, 48
; P8BE-NEXT:    clrldi r5, r4, 48
; P8BE-NEXT:    clrlwi r6, r6, 16
; P8BE-NEXT:    clrlwi r5, r5, 16
; P8BE-NEXT:    mulhwu r3, r6, r3
; P8BE-NEXT:    rldicl r8, r4, 48, 48
; P8BE-NEXT:    mulhwu r7, r5, r7
; P8BE-NEXT:    rldicl r4, r4, 32, 48
; P8BE-NEXT:    clrlwi r8, r8, 16
; P8BE-NEXT:    rlwinm r11, r4, 30, 18, 31
; P8BE-NEXT:    mulhwu r9, r8, r9
; P8BE-NEXT:    clrlwi r4, r4, 16
; P8BE-NEXT:    mulhwu r10, r11, r10
; P8BE-NEXT:    sub r11, r6, r3
; P8BE-NEXT:    srwi r7, r7, 8
; P8BE-NEXT:    srwi r11, r11, 1
; P8BE-NEXT:    add r3, r11, r3
; P8BE-NEXT:    mulli r7, r7, 1003
; P8BE-NEXT:    srwi r9, r9, 5
; P8BE-NEXT:    srwi r3, r3, 6
; P8BE-NEXT:    srwi r10, r10, 2
; P8BE-NEXT:    mulli r9, r9, 98
; P8BE-NEXT:    mulli r3, r3, 95
; P8BE-NEXT:    mulli r10, r10, 124
; P8BE-NEXT:    sub r5, r5, r7
; P8BE-NEXT:    addis r7, r2, .LCPI0_0@toc@ha
; P8BE-NEXT:    mtvsrwz v2, r5
; P8BE-NEXT:    addi r5, r7, .LCPI0_0@toc@l
; P8BE-NEXT:    sub r8, r8, r9
; P8BE-NEXT:    lxvw4x v3, 0, r5
; P8BE-NEXT:    sub r3, r6, r3
; P8BE-NEXT:    sub r4, r4, r10
; P8BE-NEXT:    mtvsrwz v4, r8
; P8BE-NEXT:    mtvsrwz v5, r3
; P8BE-NEXT:    mtvsrwz v0, r4
; P8BE-NEXT:    vperm v2, v4, v2, v3
; P8BE-NEXT:    vperm v3, v5, v0, v3
; P8BE-NEXT:    vmrghw v2, v3, v2
; P8BE-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 95, i16 124, i16 98, i16 1003>
  ret <4 x i16> %1
}

define <4 x i16> @fold_urem_vec_2(<4 x i16> %x) {
; P9LE-LABEL: fold_urem_vec_2:
; P9LE:       # %bb.0:
; P9LE-NEXT:    li r3, 0
; P9LE-NEXT:    lis r4, 22765
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    ori r4, r4, 8969
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r5, r3, r4
; P9LE-NEXT:    sub r6, r3, r5
; P9LE-NEXT:    srwi r6, r6, 1
; P9LE-NEXT:    add r5, r6, r5
; P9LE-NEXT:    srwi r5, r5, 6
; P9LE-NEXT:    mulli r5, r5, 95
; P9LE-NEXT:    sub r3, r3, r5
; P9LE-NEXT:    mtvsrd v3, r3
; P9LE-NEXT:    li r3, 2
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r5, r3, r4
; P9LE-NEXT:    sub r6, r3, r5
; P9LE-NEXT:    srwi r6, r6, 1
; P9LE-NEXT:    add r5, r6, r5
; P9LE-NEXT:    srwi r5, r5, 6
; P9LE-NEXT:    mulli r5, r5, 95
; P9LE-NEXT:    sub r3, r3, r5
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 4
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r5, r3, r4
; P9LE-NEXT:    sub r6, r3, r5
; P9LE-NEXT:    srwi r6, r6, 1
; P9LE-NEXT:    add r5, r6, r5
; P9LE-NEXT:    srwi r5, r5, 6
; P9LE-NEXT:    mulli r5, r5, 95
; P9LE-NEXT:    sub r3, r3, r5
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 6
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    sub r5, r3, r4
; P9LE-NEXT:    srwi r5, r5, 1
; P9LE-NEXT:    add r4, r5, r4
; P9LE-NEXT:    srwi r4, r4, 6
; P9LE-NEXT:    mulli r4, r4, 95
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mtvsrd v2, r3
; P9LE-NEXT:    vmrghh v2, v2, v4
; P9LE-NEXT:    vmrglw v2, v2, v3
; P9LE-NEXT:    blr
;
; P9BE-LABEL: fold_urem_vec_2:
; P9BE:       # %bb.0:
; P9BE-NEXT:    li r3, 6
; P9BE-NEXT:    lis r4, 22765
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    ori r4, r4, 8969
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r5, r3, r4
; P9BE-NEXT:    sub r6, r3, r5
; P9BE-NEXT:    srwi r6, r6, 1
; P9BE-NEXT:    add r5, r6, r5
; P9BE-NEXT:    srwi r5, r5, 6
; P9BE-NEXT:    mulli r5, r5, 95
; P9BE-NEXT:    sub r3, r3, r5
; P9BE-NEXT:    mtvsrwz v3, r3
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r5, r3, r4
; P9BE-NEXT:    sub r6, r3, r5
; P9BE-NEXT:    srwi r6, r6, 1
; P9BE-NEXT:    add r5, r6, r5
; P9BE-NEXT:    srwi r5, r5, 6
; P9BE-NEXT:    mulli r5, r5, 95
; P9BE-NEXT:    sub r3, r3, r5
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; P9BE-NEXT:    lxv v5, 0(r3)
; P9BE-NEXT:    li r3, 2
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mulhwu r5, r3, r4
; P9BE-NEXT:    sub r6, r3, r5
; P9BE-NEXT:    srwi r6, r6, 1
; P9BE-NEXT:    add r5, r6, r5
; P9BE-NEXT:    srwi r5, r5, 6
; P9BE-NEXT:    mulli r5, r5, 95
; P9BE-NEXT:    sub r3, r3, r5
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    sub r5, r3, r4
; P9BE-NEXT:    srwi r5, r5, 1
; P9BE-NEXT:    add r4, r5, r4
; P9BE-NEXT:    srwi r4, r4, 6
; P9BE-NEXT:    mulli r4, r4, 95
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrwz v2, r3
; P9BE-NEXT:    vperm v2, v2, v4, v5
; P9BE-NEXT:    vmrghw v2, v2, v3
; P9BE-NEXT:    blr
;
; P8LE-LABEL: fold_urem_vec_2:
; P8LE:       # %bb.0:
; P8LE-NEXT:    xxswapd vs0, v2
; P8LE-NEXT:    lis r3, 22765
; P8LE-NEXT:    ori r3, r3, 8969
; P8LE-NEXT:    mffprd r4, f0
; P8LE-NEXT:    clrldi r5, r4, 48
; P8LE-NEXT:    rldicl r6, r4, 48, 48
; P8LE-NEXT:    clrlwi r5, r5, 16
; P8LE-NEXT:    rldicl r7, r4, 32, 48
; P8LE-NEXT:    clrlwi r6, r6, 16
; P8LE-NEXT:    mulhwu r8, r5, r3
; P8LE-NEXT:    rldicl r4, r4, 16, 48
; P8LE-NEXT:    clrlwi r7, r7, 16
; P8LE-NEXT:    mulhwu r9, r6, r3
; P8LE-NEXT:    clrlwi r4, r4, 16
; P8LE-NEXT:    mulhwu r10, r7, r3
; P8LE-NEXT:    mulhwu r3, r4, r3
; P8LE-NEXT:    sub r11, r5, r8
; P8LE-NEXT:    sub r12, r6, r9
; P8LE-NEXT:    srwi r11, r11, 1
; P8LE-NEXT:    add r8, r11, r8
; P8LE-NEXT:    sub r11, r7, r10
; P8LE-NEXT:    srwi r12, r12, 1
; P8LE-NEXT:    add r9, r12, r9
; P8LE-NEXT:    sub r12, r4, r3
; P8LE-NEXT:    srwi r11, r11, 1
; P8LE-NEXT:    srwi r8, r8, 6
; P8LE-NEXT:    add r10, r11, r10
; P8LE-NEXT:    srwi r11, r12, 1
; P8LE-NEXT:    srwi r9, r9, 6
; P8LE-NEXT:    add r3, r11, r3
; P8LE-NEXT:    mulli r8, r8, 95
; P8LE-NEXT:    srwi r10, r10, 6
; P8LE-NEXT:    srwi r3, r3, 6
; P8LE-NEXT:    mulli r9, r9, 95
; P8LE-NEXT:    mulli r10, r10, 95
; P8LE-NEXT:    mulli r3, r3, 95
; P8LE-NEXT:    sub r5, r5, r8
; P8LE-NEXT:    sub r6, r6, r9
; P8LE-NEXT:    mtvsrd v2, r5
; P8LE-NEXT:    sub r5, r7, r10
; P8LE-NEXT:    sub r3, r4, r3
; P8LE-NEXT:    mtvsrd v3, r6
; P8LE-NEXT:    mtvsrd v4, r5
; P8LE-NEXT:    mtvsrd v5, r3
; P8LE-NEXT:    vmrghh v2, v3, v2
; P8LE-NEXT:    vmrghh v3, v5, v4
; P8LE-NEXT:    vmrglw v2, v3, v2
; P8LE-NEXT:    blr
;
; P8BE-LABEL: fold_urem_vec_2:
; P8BE:       # %bb.0:
; P8BE-NEXT:    mfvsrd r4, v2
; P8BE-NEXT:    lis r3, 22765
; P8BE-NEXT:    ori r3, r3, 8969
; P8BE-NEXT:    clrldi r5, r4, 48
; P8BE-NEXT:    rldicl r6, r4, 48, 48
; P8BE-NEXT:    clrlwi r5, r5, 16
; P8BE-NEXT:    rldicl r7, r4, 32, 48
; P8BE-NEXT:    clrlwi r6, r6, 16
; P8BE-NEXT:    mulhwu r8, r5, r3
; P8BE-NEXT:    rldicl r4, r4, 16, 48
; P8BE-NEXT:    clrlwi r7, r7, 16
; P8BE-NEXT:    mulhwu r9, r6, r3
; P8BE-NEXT:    clrlwi r4, r4, 16
; P8BE-NEXT:    mulhwu r10, r7, r3
; P8BE-NEXT:    mulhwu r3, r4, r3
; P8BE-NEXT:    sub r11, r5, r8
; P8BE-NEXT:    sub r12, r6, r9
; P8BE-NEXT:    srwi r11, r11, 1
; P8BE-NEXT:    add r8, r11, r8
; P8BE-NEXT:    sub r11, r7, r10
; P8BE-NEXT:    srwi r12, r12, 1
; P8BE-NEXT:    add r9, r12, r9
; P8BE-NEXT:    sub r12, r4, r3
; P8BE-NEXT:    srwi r11, r11, 1
; P8BE-NEXT:    srwi r8, r8, 6
; P8BE-NEXT:    add r10, r11, r10
; P8BE-NEXT:    srwi r11, r12, 1
; P8BE-NEXT:    srwi r9, r9, 6
; P8BE-NEXT:    mulli r8, r8, 95
; P8BE-NEXT:    add r3, r11, r3
; P8BE-NEXT:    srwi r10, r10, 6
; P8BE-NEXT:    srwi r3, r3, 6
; P8BE-NEXT:    mulli r9, r9, 95
; P8BE-NEXT:    mulli r10, r10, 95
; P8BE-NEXT:    mulli r3, r3, 95
; P8BE-NEXT:    sub r5, r5, r8
; P8BE-NEXT:    addis r8, r2, .LCPI1_0@toc@ha
; P8BE-NEXT:    mtvsrwz v2, r5
; P8BE-NEXT:    addi r5, r8, .LCPI1_0@toc@l
; P8BE-NEXT:    sub r6, r6, r9
; P8BE-NEXT:    lxvw4x v3, 0, r5
; P8BE-NEXT:    sub r5, r7, r10
; P8BE-NEXT:    sub r3, r4, r3
; P8BE-NEXT:    mtvsrwz v4, r6
; P8BE-NEXT:    mtvsrwz v5, r5
; P8BE-NEXT:    mtvsrwz v0, r3
; P8BE-NEXT:    vperm v2, v4, v2, v3
; P8BE-NEXT:    vperm v3, v0, v5, v3
; P8BE-NEXT:    vmrghw v2, v3, v2
; P8BE-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  ret <4 x i16> %1
}


; Don't fold if we can combine urem with udiv.
define <4 x i16> @combine_urem_udiv(<4 x i16> %x) {
; P9LE-LABEL: combine_urem_udiv:
; P9LE:       # %bb.0:
; P9LE-NEXT:    li r3, 0
; P9LE-NEXT:    lis r4, 22765
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    ori r4, r4, 8969
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r5, r3, r4
; P9LE-NEXT:    sub r6, r3, r5
; P9LE-NEXT:    srwi r6, r6, 1
; P9LE-NEXT:    add r5, r6, r5
; P9LE-NEXT:    srwi r5, r5, 6
; P9LE-NEXT:    mulli r6, r5, 95
; P9LE-NEXT:    sub r3, r3, r6
; P9LE-NEXT:    mtvsrd v3, r3
; P9LE-NEXT:    li r3, 2
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r6, r3, 16
; P9LE-NEXT:    mulhwu r7, r6, r4
; P9LE-NEXT:    sub r6, r6, r7
; P9LE-NEXT:    srwi r6, r6, 1
; P9LE-NEXT:    add r6, r6, r7
; P9LE-NEXT:    srwi r6, r6, 6
; P9LE-NEXT:    mulli r7, r6, 95
; P9LE-NEXT:    sub r3, r3, r7
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 4
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    clrlwi r7, r3, 16
; P9LE-NEXT:    mulhwu r8, r7, r4
; P9LE-NEXT:    sub r7, r7, r8
; P9LE-NEXT:    srwi r7, r7, 1
; P9LE-NEXT:    add r7, r7, r8
; P9LE-NEXT:    srwi r7, r7, 6
; P9LE-NEXT:    mulli r8, r7, 95
; P9LE-NEXT:    sub r3, r3, r8
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 6
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r8, r3, 16
; P9LE-NEXT:    mulhwu r4, r8, r4
; P9LE-NEXT:    sub r8, r8, r4
; P9LE-NEXT:    srwi r8, r8, 1
; P9LE-NEXT:    add r4, r8, r4
; P9LE-NEXT:    srwi r4, r4, 6
; P9LE-NEXT:    mulli r8, r4, 95
; P9LE-NEXT:    mtvsrd v5, r4
; P9LE-NEXT:    sub r3, r3, r8
; P9LE-NEXT:    mtvsrd v2, r3
; P9LE-NEXT:    vmrghh v2, v2, v4
; P9LE-NEXT:    mtvsrd v4, r6
; P9LE-NEXT:    vmrglw v2, v2, v3
; P9LE-NEXT:    mtvsrd v3, r5
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    mtvsrd v4, r7
; P9LE-NEXT:    vmrghh v4, v5, v4
; P9LE-NEXT:    vmrglw v3, v4, v3
; P9LE-NEXT:    vadduhm v2, v2, v3
; P9LE-NEXT:    blr
;
; P9BE-LABEL: combine_urem_udiv:
; P9BE:       # %bb.0:
; P9BE-NEXT:    li r3, 6
; P9BE-NEXT:    lis r5, 22765
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    ori r5, r5, 8969
; P9BE-NEXT:    clrlwi r4, r3, 16
; P9BE-NEXT:    mulhwu r6, r4, r5
; P9BE-NEXT:    sub r4, r4, r6
; P9BE-NEXT:    srwi r4, r4, 1
; P9BE-NEXT:    add r4, r4, r6
; P9BE-NEXT:    srwi r4, r4, 6
; P9BE-NEXT:    mulli r6, r4, 95
; P9BE-NEXT:    sub r3, r3, r6
; P9BE-NEXT:    mtvsrwz v3, r3
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r6, r3, 16
; P9BE-NEXT:    mulhwu r7, r6, r5
; P9BE-NEXT:    sub r6, r6, r7
; P9BE-NEXT:    srwi r6, r6, 1
; P9BE-NEXT:    add r6, r6, r7
; P9BE-NEXT:    srwi r6, r6, 6
; P9BE-NEXT:    mulli r7, r6, 95
; P9BE-NEXT:    sub r3, r3, r7
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; P9BE-NEXT:    lxv v5, 0(r3)
; P9BE-NEXT:    li r3, 2
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r7, r3, 16
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mulhwu r8, r7, r5
; P9BE-NEXT:    sub r7, r7, r8
; P9BE-NEXT:    srwi r7, r7, 1
; P9BE-NEXT:    add r7, r7, r8
; P9BE-NEXT:    srwi r7, r7, 6
; P9BE-NEXT:    mulli r8, r7, 95
; P9BE-NEXT:    sub r3, r3, r8
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r5, r3, r5
; P9BE-NEXT:    sub r8, r3, r5
; P9BE-NEXT:    srwi r8, r8, 1
; P9BE-NEXT:    add r5, r8, r5
; P9BE-NEXT:    srwi r5, r5, 6
; P9BE-NEXT:    mulli r8, r5, 95
; P9BE-NEXT:    mtvsrwz v0, r5
; P9BE-NEXT:    sub r3, r3, r8
; P9BE-NEXT:    mtvsrwz v2, r3
; P9BE-NEXT:    vperm v2, v2, v4, v5
; P9BE-NEXT:    mtvsrwz v4, r6
; P9BE-NEXT:    vmrghw v2, v2, v3
; P9BE-NEXT:    mtvsrwz v3, r4
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mtvsrwz v4, r7
; P9BE-NEXT:    vperm v4, v0, v4, v5
; P9BE-NEXT:    vmrghw v3, v4, v3
; P9BE-NEXT:    vadduhm v2, v2, v3
; P9BE-NEXT:    blr
;
; P8LE-LABEL: combine_urem_udiv:
; P8LE:       # %bb.0:
; P8LE-NEXT:    xxswapd vs0, v2
; P8LE-NEXT:    lis r3, 22765
; P8LE-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; P8LE-NEXT:    ori r3, r3, 8969
; P8LE-NEXT:    mffprd r4, f0
; P8LE-NEXT:    clrldi r5, r4, 48
; P8LE-NEXT:    rldicl r6, r4, 48, 48
; P8LE-NEXT:    clrlwi r5, r5, 16
; P8LE-NEXT:    clrlwi r8, r6, 16
; P8LE-NEXT:    rldicl r7, r4, 32, 48
; P8LE-NEXT:    rldicl r4, r4, 16, 48
; P8LE-NEXT:    mulhwu r9, r5, r3
; P8LE-NEXT:    mulhwu r11, r8, r3
; P8LE-NEXT:    clrlwi r10, r7, 16
; P8LE-NEXT:    clrlwi r12, r4, 16
; P8LE-NEXT:    mulhwu r0, r10, r3
; P8LE-NEXT:    mulhwu r3, r12, r3
; P8LE-NEXT:    sub r30, r5, r9
; P8LE-NEXT:    sub r8, r8, r11
; P8LE-NEXT:    srwi r30, r30, 1
; P8LE-NEXT:    srwi r8, r8, 1
; P8LE-NEXT:    sub r10, r10, r0
; P8LE-NEXT:    add r9, r30, r9
; P8LE-NEXT:    add r8, r8, r11
; P8LE-NEXT:    sub r11, r12, r3
; P8LE-NEXT:    srwi r10, r10, 1
; P8LE-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; P8LE-NEXT:    srwi r9, r9, 6
; P8LE-NEXT:    srwi r11, r11, 1
; P8LE-NEXT:    srwi r8, r8, 6
; P8LE-NEXT:    add r10, r10, r0
; P8LE-NEXT:    mulli r12, r9, 95
; P8LE-NEXT:    add r3, r11, r3
; P8LE-NEXT:    mtvsrd v2, r9
; P8LE-NEXT:    srwi r10, r10, 6
; P8LE-NEXT:    mulli r9, r8, 95
; P8LE-NEXT:    srwi r3, r3, 6
; P8LE-NEXT:    mtvsrd v3, r8
; P8LE-NEXT:    mulli r8, r10, 95
; P8LE-NEXT:    mtvsrd v4, r10
; P8LE-NEXT:    mulli r10, r3, 95
; P8LE-NEXT:    vmrghh v2, v3, v2
; P8LE-NEXT:    sub r5, r5, r12
; P8LE-NEXT:    sub r6, r6, r9
; P8LE-NEXT:    mtvsrd v3, r5
; P8LE-NEXT:    mtvsrd v5, r6
; P8LE-NEXT:    sub r5, r7, r8
; P8LE-NEXT:    sub r4, r4, r10
; P8LE-NEXT:    mtvsrd v0, r5
; P8LE-NEXT:    mtvsrd v1, r4
; P8LE-NEXT:    vmrghh v3, v5, v3
; P8LE-NEXT:    mtvsrd v5, r3
; P8LE-NEXT:    vmrghh v0, v1, v0
; P8LE-NEXT:    vmrghh v4, v5, v4
; P8LE-NEXT:    vmrglw v3, v0, v3
; P8LE-NEXT:    vmrglw v2, v4, v2
; P8LE-NEXT:    vadduhm v2, v3, v2
; P8LE-NEXT:    blr
;
; P8BE-LABEL: combine_urem_udiv:
; P8BE:       # %bb.0:
; P8BE-NEXT:    mfvsrd r4, v2
; P8BE-NEXT:    lis r3, 22765
; P8BE-NEXT:    ori r3, r3, 8969
; P8BE-NEXT:    clrldi r5, r4, 48
; P8BE-NEXT:    rldicl r6, r4, 48, 48
; P8BE-NEXT:    clrlwi r8, r5, 16
; P8BE-NEXT:    clrlwi r9, r6, 16
; P8BE-NEXT:    rldicl r7, r4, 32, 48
; P8BE-NEXT:    rldicl r4, r4, 16, 48
; P8BE-NEXT:    mulhwu r10, r8, r3
; P8BE-NEXT:    mulhwu r12, r9, r3
; P8BE-NEXT:    clrlwi r11, r7, 16
; P8BE-NEXT:    clrlwi r4, r4, 16
; P8BE-NEXT:    mulhwu r0, r11, r3
; P8BE-NEXT:    mulhwu r3, r4, r3
; P8BE-NEXT:    sub r8, r8, r10
; P8BE-NEXT:    sub r9, r9, r12
; P8BE-NEXT:    srwi r8, r8, 1
; P8BE-NEXT:    srwi r9, r9, 1
; P8BE-NEXT:    sub r11, r11, r0
; P8BE-NEXT:    add r8, r8, r10
; P8BE-NEXT:    add r9, r9, r12
; P8BE-NEXT:    sub r12, r4, r3
; P8BE-NEXT:    addis r10, r2, .LCPI2_0@toc@ha
; P8BE-NEXT:    srwi r11, r11, 1
; P8BE-NEXT:    srwi r8, r8, 6
; P8BE-NEXT:    srwi r12, r12, 1
; P8BE-NEXT:    srwi r9, r9, 6
; P8BE-NEXT:    addi r10, r10, .LCPI2_0@toc@l
; P8BE-NEXT:    add r11, r11, r0
; P8BE-NEXT:    mulli r0, r8, 95
; P8BE-NEXT:    add r3, r12, r3
; P8BE-NEXT:    mtvsrwz v3, r8
; P8BE-NEXT:    lxvw4x v2, 0, r10
; P8BE-NEXT:    srwi r10, r11, 6
; P8BE-NEXT:    mulli r8, r9, 95
; P8BE-NEXT:    srwi r3, r3, 6
; P8BE-NEXT:    mtvsrwz v4, r9
; P8BE-NEXT:    mulli r9, r10, 95
; P8BE-NEXT:    mtvsrwz v5, r10
; P8BE-NEXT:    mulli r10, r3, 95
; P8BE-NEXT:    vperm v3, v4, v3, v2
; P8BE-NEXT:    sub r5, r5, r0
; P8BE-NEXT:    sub r6, r6, r8
; P8BE-NEXT:    mtvsrwz v4, r5
; P8BE-NEXT:    mtvsrwz v0, r6
; P8BE-NEXT:    sub r5, r7, r9
; P8BE-NEXT:    sub r4, r4, r10
; P8BE-NEXT:    mtvsrwz v1, r5
; P8BE-NEXT:    mtvsrwz v6, r4
; P8BE-NEXT:    vperm v4, v0, v4, v2
; P8BE-NEXT:    mtvsrwz v0, r3
; P8BE-NEXT:    vperm v1, v6, v1, v2
; P8BE-NEXT:    vperm v2, v0, v5, v2
; P8BE-NEXT:    vmrghw v4, v1, v4
; P8BE-NEXT:    vmrghw v2, v2, v3
; P8BE-NEXT:    vadduhm v2, v4, v2
; P8BE-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %2 = udiv <4 x i16> %x, <i16 95, i16 95, i16 95, i16 95>
  %3 = add <4 x i16> %1, %2
  ret <4 x i16> %3
}

; Don't fold for divisors that are a power of two.
define <4 x i16> @dont_fold_urem_power_of_two(<4 x i16> %x) {
; P9LE-LABEL: dont_fold_urem_power_of_two:
; P9LE:       # %bb.0:
; P9LE-NEXT:    li r3, 0
; P9LE-NEXT:    lis r4, 22765
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    ori r4, r4, 8969
; P9LE-NEXT:    clrlwi r3, r3, 26
; P9LE-NEXT:    mtvsrd v3, r3
; P9LE-NEXT:    li r3, 2
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 27
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 6
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    sub r5, r3, r4
; P9LE-NEXT:    srwi r5, r5, 1
; P9LE-NEXT:    add r4, r5, r4
; P9LE-NEXT:    srwi r4, r4, 6
; P9LE-NEXT:    mulli r4, r4, 95
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 4
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 29
; P9LE-NEXT:    mtvsrd v2, r3
; P9LE-NEXT:    vmrghh v2, v4, v2
; P9LE-NEXT:    vmrglw v2, v2, v3
; P9LE-NEXT:    blr
;
; P9BE-LABEL: dont_fold_urem_power_of_two:
; P9BE:       # %bb.0:
; P9BE-NEXT:    li r3, 2
; P9BE-NEXT:    lis r4, 22765
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    ori r4, r4, 8969
; P9BE-NEXT:    clrlwi r3, r3, 27
; P9BE-NEXT:    mtvsrwz v3, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 26
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    addis r3, r2, .LCPI3_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI3_0@toc@l
; P9BE-NEXT:    lxv v5, 0(r3)
; P9BE-NEXT:    li r3, 6
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    sub r5, r3, r4
; P9BE-NEXT:    srwi r5, r5, 1
; P9BE-NEXT:    add r4, r5, r4
; P9BE-NEXT:    srwi r4, r4, 6
; P9BE-NEXT:    mulli r4, r4, 95
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 29
; P9BE-NEXT:    mtvsrwz v2, r3
; P9BE-NEXT:    vperm v2, v2, v4, v5
; P9BE-NEXT:    vmrghw v2, v3, v2
; P9BE-NEXT:    blr
;
; P8LE-LABEL: dont_fold_urem_power_of_two:
; P8LE:       # %bb.0:
; P8LE-NEXT:    xxswapd vs0, v2
; P8LE-NEXT:    lis r3, 22765
; P8LE-NEXT:    ori r3, r3, 8969
; P8LE-NEXT:    mffprd r4, f0
; P8LE-NEXT:    rldicl r5, r4, 16, 48
; P8LE-NEXT:    rldicl r7, r4, 48, 48
; P8LE-NEXT:    clrlwi r5, r5, 16
; P8LE-NEXT:    mulhwu r3, r5, r3
; P8LE-NEXT:    sub r6, r5, r3
; P8LE-NEXT:    srwi r6, r6, 1
; P8LE-NEXT:    add r3, r6, r3
; P8LE-NEXT:    clrldi r6, r4, 48
; P8LE-NEXT:    srwi r3, r3, 6
; P8LE-NEXT:    clrlwi r6, r6, 26
; P8LE-NEXT:    mulli r3, r3, 95
; P8LE-NEXT:    rldicl r4, r4, 32, 48
; P8LE-NEXT:    mtvsrd v2, r6
; P8LE-NEXT:    clrlwi r6, r7, 27
; P8LE-NEXT:    clrlwi r4, r4, 29
; P8LE-NEXT:    mtvsrd v3, r6
; P8LE-NEXT:    mtvsrd v5, r4
; P8LE-NEXT:    vmrghh v2, v3, v2
; P8LE-NEXT:    sub r3, r5, r3
; P8LE-NEXT:    mtvsrd v4, r3
; P8LE-NEXT:    vmrghh v3, v4, v5
; P8LE-NEXT:    vmrglw v2, v3, v2
; P8LE-NEXT:    blr
;
; P8BE-LABEL: dont_fold_urem_power_of_two:
; P8BE:       # %bb.0:
; P8BE-NEXT:    mfvsrd r4, v2
; P8BE-NEXT:    lis r3, 22765
; P8BE-NEXT:    addis r7, r2, .LCPI3_0@toc@ha
; P8BE-NEXT:    ori r3, r3, 8969
; P8BE-NEXT:    clrldi r5, r4, 48
; P8BE-NEXT:    rldicl r8, r4, 16, 48
; P8BE-NEXT:    clrlwi r5, r5, 16
; P8BE-NEXT:    mulhwu r3, r5, r3
; P8BE-NEXT:    sub r6, r5, r3
; P8BE-NEXT:    srwi r6, r6, 1
; P8BE-NEXT:    add r3, r6, r3
; P8BE-NEXT:    rldicl r6, r4, 32, 48
; P8BE-NEXT:    srwi r3, r3, 6
; P8BE-NEXT:    clrlwi r6, r6, 27
; P8BE-NEXT:    mulli r3, r3, 95
; P8BE-NEXT:    mtvsrwz v2, r6
; P8BE-NEXT:    addi r6, r7, .LCPI3_0@toc@l
; P8BE-NEXT:    rldicl r4, r4, 48, 48
; P8BE-NEXT:    clrlwi r7, r8, 26
; P8BE-NEXT:    lxvw4x v3, 0, r6
; P8BE-NEXT:    clrlwi r4, r4, 29
; P8BE-NEXT:    mtvsrwz v4, r7
; P8BE-NEXT:    mtvsrwz v0, r4
; P8BE-NEXT:    sub r3, r5, r3
; P8BE-NEXT:    vperm v2, v4, v2, v3
; P8BE-NEXT:    mtvsrwz v5, r3
; P8BE-NEXT:    vperm v3, v0, v5, v3
; P8BE-NEXT:    vmrghw v2, v2, v3
; P8BE-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 64, i16 32, i16 8, i16 95>
  ret <4 x i16> %1
}

; Don't fold if the divisor is one.
define <4 x i16> @dont_fold_urem_one(<4 x i16> %x) {
; P9LE-LABEL: dont_fold_urem_one:
; P9LE:       # %bb.0:
; P9LE-NEXT:    li r3, 4
; P9LE-NEXT:    lis r4, -19946
; P9LE-NEXT:    lis r5, -14230
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    ori r4, r4, 17097
; P9LE-NEXT:    ori r5, r5, 30865
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    srwi r4, r4, 4
; P9LE-NEXT:    mulli r4, r4, 23
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    lis r4, 24749
; P9LE-NEXT:    mtvsrd v3, r3
; P9LE-NEXT:    li r3, 6
; P9LE-NEXT:    ori r4, r4, 47143
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    clrlwi r3, r3, 16
; P9LE-NEXT:    mulhwu r4, r3, r4
; P9LE-NEXT:    srwi r4, r4, 11
; P9LE-NEXT:    mulli r4, r4, 5423
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    li r3, 2
; P9LE-NEXT:    vextuhrx r3, r3, v2
; P9LE-NEXT:    vmrghh v3, v4, v3
; P9LE-NEXT:    clrlwi r4, r3, 16
; P9LE-NEXT:    rlwinm r3, r3, 31, 17, 31
; P9LE-NEXT:    mulhwu r3, r3, r5
; P9LE-NEXT:    srwi r3, r3, 8
; P9LE-NEXT:    mulli r3, r3, 654
; P9LE-NEXT:    sub r3, r4, r3
; P9LE-NEXT:    mtvsrd v2, r3
; P9LE-NEXT:    li r3, 0
; P9LE-NEXT:    mtvsrd v4, r3
; P9LE-NEXT:    vmrghh v2, v2, v4
; P9LE-NEXT:    vmrglw v2, v3, v2
; P9LE-NEXT:    blr
;
; P9BE-LABEL: dont_fold_urem_one:
; P9BE:       # %bb.0:
; P9BE-NEXT:    li r3, 6
; P9BE-NEXT:    lis r4, 24749
; P9BE-NEXT:    lis r5, -14230
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    ori r4, r4, 47143
; P9BE-NEXT:    ori r5, r5, 30865
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    srwi r4, r4, 11
; P9BE-NEXT:    mulli r4, r4, 5423
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    lis r4, -19946
; P9BE-NEXT:    mtvsrwz v3, r3
; P9BE-NEXT:    li r3, 4
; P9BE-NEXT:    ori r4, r4, 17097
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r3, r3, 16
; P9BE-NEXT:    mulhwu r4, r3, r4
; P9BE-NEXT:    srwi r4, r4, 4
; P9BE-NEXT:    mulli r4, r4, 23
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; P9BE-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; P9BE-NEXT:    lxv v5, 0(r3)
; P9BE-NEXT:    li r3, 2
; P9BE-NEXT:    vextuhlx r3, r3, v2
; P9BE-NEXT:    clrlwi r4, r3, 16
; P9BE-NEXT:    rlwinm r3, r3, 31, 17, 31
; P9BE-NEXT:    vperm v3, v4, v3, v5
; P9BE-NEXT:    mulhwu r3, r3, r5
; P9BE-NEXT:    srwi r3, r3, 8
; P9BE-NEXT:    mulli r3, r3, 654
; P9BE-NEXT:    sub r3, r4, r3
; P9BE-NEXT:    mtvsrwz v2, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    mtvsrwz v4, r3
; P9BE-NEXT:    vperm v2, v4, v2, v5
; P9BE-NEXT:    vmrghw v2, v2, v3
; P9BE-NEXT:    blr
;
; P8LE-LABEL: dont_fold_urem_one:
; P8LE:       # %bb.0:
; P8LE-NEXT:    xxswapd vs0, v2
; P8LE-NEXT:    lis r3, -14230
; P8LE-NEXT:    lis r7, -19946
; P8LE-NEXT:    lis r9, 24749
; P8LE-NEXT:    ori r3, r3, 30865
; P8LE-NEXT:    ori r7, r7, 17097
; P8LE-NEXT:    mffprd r4, f0
; P8LE-NEXT:    rldicl r5, r4, 48, 48
; P8LE-NEXT:    rldicl r6, r4, 32, 48
; P8LE-NEXT:    rldicl r4, r4, 16, 48
; P8LE-NEXT:    rlwinm r8, r5, 31, 17, 31
; P8LE-NEXT:    clrlwi r6, r6, 16
; P8LE-NEXT:    clrlwi r5, r5, 16
; P8LE-NEXT:    mulhwu r3, r8, r3
; P8LE-NEXT:    ori r8, r9, 47143
; P8LE-NEXT:    clrlwi r4, r4, 16
; P8LE-NEXT:    li r9, 0
; P8LE-NEXT:    mulhwu r7, r6, r7
; P8LE-NEXT:    mulhwu r8, r4, r8
; P8LE-NEXT:    mtvsrd v2, r9
; P8LE-NEXT:    srwi r3, r3, 8
; P8LE-NEXT:    srwi r7, r7, 4
; P8LE-NEXT:    mulli r3, r3, 654
; P8LE-NEXT:    srwi r8, r8, 11
; P8LE-NEXT:    mulli r7, r7, 23
; P8LE-NEXT:    mulli r8, r8, 5423
; P8LE-NEXT:    sub r3, r5, r3
; P8LE-NEXT:    sub r5, r6, r7
; P8LE-NEXT:    mtvsrd v3, r3
; P8LE-NEXT:    sub r3, r4, r8
; P8LE-NEXT:    mtvsrd v4, r5
; P8LE-NEXT:    mtvsrd v5, r3
; P8LE-NEXT:    vmrghh v2, v3, v2
; P8LE-NEXT:    vmrghh v3, v5, v4
; P8LE-NEXT:    vmrglw v2, v3, v2
; P8LE-NEXT:    blr
;
; P8BE-LABEL: dont_fold_urem_one:
; P8BE:       # %bb.0:
; P8BE-NEXT:    mfvsrd r4, v2
; P8BE-NEXT:    lis r3, 24749
; P8BE-NEXT:    lis r7, -19946
; P8BE-NEXT:    lis r8, -14230
; P8BE-NEXT:    li r10, 0
; P8BE-NEXT:    ori r3, r3, 47143
; P8BE-NEXT:    ori r7, r7, 17097
; P8BE-NEXT:    ori r8, r8, 30865
; P8BE-NEXT:    mtvsrwz v2, r10
; P8BE-NEXT:    clrldi r5, r4, 48
; P8BE-NEXT:    rldicl r6, r4, 48, 48
; P8BE-NEXT:    clrlwi r5, r5, 16
; P8BE-NEXT:    rldicl r4, r4, 32, 48
; P8BE-NEXT:    clrlwi r6, r6, 16
; P8BE-NEXT:    mulhwu r3, r5, r3
; P8BE-NEXT:    rlwinm r9, r4, 31, 17, 31
; P8BE-NEXT:    mulhwu r7, r6, r7
; P8BE-NEXT:    mulhwu r8, r9, r8
; P8BE-NEXT:    addis r9, r2, .LCPI4_0@toc@ha
; P8BE-NEXT:    srwi r3, r3, 11
; P8BE-NEXT:    mulli r3, r3, 5423
; P8BE-NEXT:    srwi r7, r7, 4
; P8BE-NEXT:    srwi r8, r8, 8
; P8BE-NEXT:    mulli r7, r7, 23
; P8BE-NEXT:    mulli r8, r8, 654
; P8BE-NEXT:    sub r3, r5, r3
; P8BE-NEXT:    addi r5, r9, .LCPI4_0@toc@l
; P8BE-NEXT:    mtvsrwz v4, r3
; P8BE-NEXT:    clrlwi r3, r4, 16
; P8BE-NEXT:    lxvw4x v3, 0, r5
; P8BE-NEXT:    sub r5, r6, r7
; P8BE-NEXT:    sub r3, r3, r8
; P8BE-NEXT:    mtvsrwz v5, r5
; P8BE-NEXT:    mtvsrwz v0, r3
; P8BE-NEXT:    vperm v4, v5, v4, v3
; P8BE-NEXT:    vperm v2, v2, v0, v3
; P8BE-NEXT:    vmrghw v2, v2, v4
; P8BE-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 1, i16 654, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold if the divisor is 2^16.
define <4 x i16> @dont_fold_urem_i16_smax(<4 x i16> %x) {
; CHECK-LABEL: dont_fold_urem_i16_smax:
; CHECK:       # %bb.0:
; CHECK-NEXT:    blr
  %1 = urem <4 x i16> %x, <i16 1, i16 65536, i16 23, i16 5423>
  ret <4 x i16> %1
}

; Don't fold i64 urem.
define <4 x i64> @dont_fold_urem_i64(<4 x i64> %x) {
; P9LE-LABEL: dont_fold_urem_i64:
; P9LE:       # %bb.0:
; P9LE-NEXT:    lis r4, 1602
; P9LE-NEXT:    mfvsrld r3, v3
; P9LE-NEXT:    ori r4, r4, 51289
; P9LE-NEXT:    rldic r4, r4, 36, 1
; P9LE-NEXT:    oris r4, r4, 45590
; P9LE-NEXT:    ori r4, r4, 17097
; P9LE-NEXT:    mulhdu r4, r3, r4
; P9LE-NEXT:    sub r5, r3, r4
; P9LE-NEXT:    rldicl r5, r5, 63, 1
; P9LE-NEXT:    add r4, r5, r4
; P9LE-NEXT:    lis r5, -16037
; P9LE-NEXT:    rldicl r4, r4, 60, 4
; P9LE-NEXT:    ori r5, r5, 28749
; P9LE-NEXT:    mulli r4, r4, 23
; P9LE-NEXT:    rldic r5, r5, 32, 0
; P9LE-NEXT:    oris r5, r5, 52170
; P9LE-NEXT:    ori r5, r5, 12109
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    mfvsrd r4, v3
; P9LE-NEXT:    mulhdu r5, r4, r5
; P9LE-NEXT:    rldicl r5, r5, 52, 12
; P9LE-NEXT:    mulli r5, r5, 5423
; P9LE-NEXT:    sub r4, r4, r5
; P9LE-NEXT:    lis r5, 3206
; P9LE-NEXT:    ori r5, r5, 42889
; P9LE-NEXT:    mtvsrdd v3, r4, r3
; P9LE-NEXT:    mfvsrd r3, v2
; P9LE-NEXT:    rldic r5, r5, 35, 1
; P9LE-NEXT:    rldicl r4, r3, 63, 1
; P9LE-NEXT:    oris r5, r5, 1603
; P9LE-NEXT:    ori r5, r5, 21445
; P9LE-NEXT:    mulhdu r4, r4, r5
; P9LE-NEXT:    rldicl r4, r4, 57, 7
; P9LE-NEXT:    mulli r4, r4, 654
; P9LE-NEXT:    sub r3, r3, r4
; P9LE-NEXT:    li r4, 0
; P9LE-NEXT:    mtvsrdd v2, r3, r4
; P9LE-NEXT:    blr
;
; P9BE-LABEL: dont_fold_urem_i64:
; P9BE:       # %bb.0:
; P9BE-NEXT:    lis r4, 1602
; P9BE-NEXT:    mfvsrd r3, v3
; P9BE-NEXT:    ori r4, r4, 51289
; P9BE-NEXT:    rldic r4, r4, 36, 1
; P9BE-NEXT:    oris r4, r4, 45590
; P9BE-NEXT:    ori r4, r4, 17097
; P9BE-NEXT:    mulhdu r4, r3, r4
; P9BE-NEXT:    sub r5, r3, r4
; P9BE-NEXT:    rldicl r5, r5, 63, 1
; P9BE-NEXT:    add r4, r5, r4
; P9BE-NEXT:    lis r5, -16037
; P9BE-NEXT:    rldicl r4, r4, 60, 4
; P9BE-NEXT:    ori r5, r5, 28749
; P9BE-NEXT:    mulli r4, r4, 23
; P9BE-NEXT:    rldic r5, r5, 32, 0
; P9BE-NEXT:    oris r5, r5, 52170
; P9BE-NEXT:    ori r5, r5, 12109
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mfvsrld r4, v3
; P9BE-NEXT:    mulhdu r5, r4, r5
; P9BE-NEXT:    rldicl r5, r5, 52, 12
; P9BE-NEXT:    mulli r5, r5, 5423
; P9BE-NEXT:    sub r4, r4, r5
; P9BE-NEXT:    lis r5, 3206
; P9BE-NEXT:    ori r5, r5, 42889
; P9BE-NEXT:    mtvsrdd v3, r3, r4
; P9BE-NEXT:    mfvsrld r3, v2
; P9BE-NEXT:    rldic r5, r5, 35, 1
; P9BE-NEXT:    rldicl r4, r3, 63, 1
; P9BE-NEXT:    oris r5, r5, 1603
; P9BE-NEXT:    ori r5, r5, 21445
; P9BE-NEXT:    mulhdu r4, r4, r5
; P9BE-NEXT:    rldicl r4, r4, 57, 7
; P9BE-NEXT:    mulli r4, r4, 654
; P9BE-NEXT:    sub r3, r3, r4
; P9BE-NEXT:    mtvsrdd v2, 0, r3
; P9BE-NEXT:    blr
;
; P8LE-LABEL: dont_fold_urem_i64:
; P8LE:       # %bb.0:
; P8LE-NEXT:    lis r3, 1602
; P8LE-NEXT:    xxswapd vs0, v3
; P8LE-NEXT:    lis r4, -16037
; P8LE-NEXT:    lis r5, 3206
; P8LE-NEXT:    mfvsrd r6, v2
; P8LE-NEXT:    ori r3, r3, 51289
; P8LE-NEXT:    ori r4, r4, 28749
; P8LE-NEXT:    ori r5, r5, 42889
; P8LE-NEXT:    mfvsrd r8, v3
; P8LE-NEXT:    rldic r3, r3, 36, 1
; P8LE-NEXT:    rldic r4, r4, 32, 0
; P8LE-NEXT:    oris r3, r3, 45590
; P8LE-NEXT:    mffprd r7, f0
; P8LE-NEXT:    rldic r5, r5, 35, 1
; P8LE-NEXT:    oris r4, r4, 52170
; P8LE-NEXT:    ori r3, r3, 17097
; P8LE-NEXT:    oris r5, r5, 1603
; P8LE-NEXT:    ori r4, r4, 12109
; P8LE-NEXT:    mulhdu r3, r7, r3
; P8LE-NEXT:    rldicl r9, r6, 63, 1
; P8LE-NEXT:    ori r5, r5, 21445
; P8LE-NEXT:    mulhdu r4, r8, r4
; P8LE-NEXT:    mulhdu r5, r9, r5
; P8LE-NEXT:    sub r9, r7, r3
; P8LE-NEXT:    rldicl r9, r9, 63, 1
; P8LE-NEXT:    rldicl r4, r4, 52, 12
; P8LE-NEXT:    add r3, r9, r3
; P8LE-NEXT:    rldicl r5, r5, 57, 7
; P8LE-NEXT:    mulli r4, r4, 5423
; P8LE-NEXT:    rldicl r3, r3, 60, 4
; P8LE-NEXT:    mulli r5, r5, 654
; P8LE-NEXT:    mulli r3, r3, 23
; P8LE-NEXT:    sub r4, r8, r4
; P8LE-NEXT:    sub r5, r6, r5
; P8LE-NEXT:    mtfprd f0, r4
; P8LE-NEXT:    sub r3, r7, r3
; P8LE-NEXT:    li r4, 0
; P8LE-NEXT:    mtfprd f1, r5
; P8LE-NEXT:    mtfprd f2, r3
; P8LE-NEXT:    mtfprd f3, r4
; P8LE-NEXT:    xxmrghd v3, vs0, vs2
; P8LE-NEXT:    xxmrghd v2, vs1, vs3
; P8LE-NEXT:    blr
;
; P8BE-LABEL: dont_fold_urem_i64:
; P8BE:       # %bb.0:
; P8BE-NEXT:    lis r3, 1602
; P8BE-NEXT:    lis r4, -16037
; P8BE-NEXT:    xxswapd vs0, v3
; P8BE-NEXT:    xxswapd vs1, v2
; P8BE-NEXT:    lis r5, 3206
; P8BE-NEXT:    ori r3, r3, 51289
; P8BE-NEXT:    ori r4, r4, 28749
; P8BE-NEXT:    mfvsrd r6, v3
; P8BE-NEXT:    ori r5, r5, 42889
; P8BE-NEXT:    rldic r3, r3, 36, 1
; P8BE-NEXT:    rldic r4, r4, 32, 0
; P8BE-NEXT:    oris r3, r3, 45590
; P8BE-NEXT:    rldic r5, r5, 35, 1
; P8BE-NEXT:    mffprd r7, f0
; P8BE-NEXT:    oris r4, r4, 52170
; P8BE-NEXT:    ori r3, r3, 17097
; P8BE-NEXT:    mffprd r8, f1
; P8BE-NEXT:    oris r5, r5, 1603
; P8BE-NEXT:    ori r4, r4, 12109
; P8BE-NEXT:    mulhdu r3, r6, r3
; P8BE-NEXT:    ori r5, r5, 21445
; P8BE-NEXT:    mulhdu r4, r7, r4
; P8BE-NEXT:    rldicl r9, r8, 63, 1
; P8BE-NEXT:    mulhdu r5, r9, r5
; P8BE-NEXT:    sub r9, r6, r3
; P8BE-NEXT:    rldicl r9, r9, 63, 1
; P8BE-NEXT:    rldicl r4, r4, 52, 12
; P8BE-NEXT:    add r3, r9, r3
; P8BE-NEXT:    mulli r4, r4, 5423
; P8BE-NEXT:    rldicl r5, r5, 57, 7
; P8BE-NEXT:    rldicl r3, r3, 60, 4
; P8BE-NEXT:    mulli r5, r5, 654
; P8BE-NEXT:    mulli r3, r3, 23
; P8BE-NEXT:    sub r4, r7, r4
; P8BE-NEXT:    mtfprd f0, r4
; P8BE-NEXT:    sub r4, r8, r5
; P8BE-NEXT:    sub r3, r6, r3
; P8BE-NEXT:    mtfprd f1, r4
; P8BE-NEXT:    li r4, 0
; P8BE-NEXT:    mtfprd f2, r3
; P8BE-NEXT:    mtfprd f3, r4
; P8BE-NEXT:    xxmrghd v3, vs2, vs0
; P8BE-NEXT:    xxmrghd v2, vs3, vs1
; P8BE-NEXT:    blr
  %1 = urem <4 x i64> %x, <i64 1, i64 654, i64 23, i64 5423>
  ret <4 x i64> %1
}
