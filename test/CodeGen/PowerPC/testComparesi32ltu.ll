; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -relocation-model=pic -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,BE
; RUN: llc -relocation-model=pic -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl \
; RUN:  --check-prefixes=CHECK,LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefixes=CHECK-P10,CHECK-P10-LE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:     -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:     FileCheck %s --check-prefixes=CHECK-P10,CHECK-P10-BE
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:   FileCheck %s --check-prefixes=CHECK-P10-CMP,CHECK-P10-CMP-LE \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd \
; RUN:   --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-gpr-icmps=all -ppc-asm-full-reg-names -mcpu=pwr10 < %s | \
; RUN:   FileCheck %s --check-prefixes=CHECK-P10-CMP,CHECK-P10-CMP-BE \
; RUN:   --implicit-check-not cmpw --implicit-check-not cmpd \
; RUN:   --implicit-check-not cmpl

%struct.tree_common = type { i8, [3 x i8] }
declare signext i32 @fn2(...) local_unnamed_addr #1

; Function Attrs: nounwind
define dso_local i32 @testCompare1(%struct.tree_common* nocapture readonly %arg1) nounwind {
; BE-LABEL: testCompare1:
; BE:       # %bb.0: # %entry
; BE-NEXT:    mflr r0
; BE-NEXT:    std r0, 16(r1)
; BE-NEXT:    stdu r1, -112(r1)
; BE-NEXT:    addis r4, r2, testCompare1@toc@ha
; BE-NEXT:    lbz r3, 0(r3)
; BE-NEXT:    lbz r4, testCompare1@toc@l(r4)
; BE-NEXT:    clrlwi r3, r3, 31
; BE-NEXT:    clrlwi r4, r4, 31
; BE-NEXT:    clrldi r3, r3, 32
; BE-NEXT:    clrldi r4, r4, 32
; BE-NEXT:    sub r3, r4, r3
; BE-NEXT:    rldicl r3, r3, 1, 63
; BE-NEXT:    bl fn2
; BE-NEXT:    nop
; BE-NEXT:    addi r1, r1, 112
; BE-NEXT:    ld r0, 16(r1)
; BE-NEXT:    mtlr r0
; BE-NEXT:    blr
;
; LE-LABEL: testCompare1:
; LE:       # %bb.0: # %entry
; LE-NEXT:    mflr r0
; LE-NEXT:    std r0, 16(r1)
; LE-NEXT:    stdu r1, -32(r1)
; LE-NEXT:    addis r4, r2, testCompare1@toc@ha
; LE-NEXT:    lbz r3, 0(r3)
; LE-NEXT:    lbz r4, testCompare1@toc@l(r4)
; LE-NEXT:    clrlwi r3, r3, 31
; LE-NEXT:    clrlwi r4, r4, 31
; LE-NEXT:    clrldi r3, r3, 32
; LE-NEXT:    clrldi r4, r4, 32
; LE-NEXT:    sub r3, r4, r3
; LE-NEXT:    rldicl r3, r3, 1, 63
; LE-NEXT:    bl fn2
; LE-NEXT:    nop
; LE-NEXT:    addi r1, r1, 32
; LE-NEXT:    ld r0, 16(r1)
; LE-NEXT:    mtlr r0
; LE-NEXT:    blr
;
; CHECK-P10-LE-LABEL: testCompare1:
; CHECK-P10-LE:       # %bb.0: # %entry
; CHECK-P10-LE-NEXT:    plbz r4, testCompare1@PCREL(0), 1
; CHECK-P10-LE-NEXT:    lbz r3, 0(r3)
; CHECK-P10-LE-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-LE-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-LE-NEXT:    cmplw r4, r3
; CHECK-P10-LE-NEXT:    setbc r3, lt
; CHECK-P10-LE-NEXT:    b fn2@notoc
; CHECK-P10-LE-NEXT:    #TC_RETURNd8 fn2@notoc 0
;
; CHECK-P10-BE-LABEL: testCompare1:
; CHECK-P10-BE:       # %bb.0: # %entry
; CHECK-P10-BE-NEXT:    mflr r0
; CHECK-P10-BE-NEXT:    std r0, 16(r1)
; CHECK-P10-BE-NEXT:    stdu r1, -112(r1)
; CHECK-P10-BE-NEXT:    addis r4, r2, testCompare1@toc@ha
; CHECK-P10-BE-NEXT:    lbz r3, 0(r3)
; CHECK-P10-BE-NEXT:    lbz r4, testCompare1@toc@l(r4)
; CHECK-P10-BE-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-BE-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-BE-NEXT:    cmplw r4, r3
; CHECK-P10-BE-NEXT:    setbc r3, lt
; CHECK-P10-BE-NEXT:    bl fn2
; CHECK-P10-BE-NEXT:    nop
; CHECK-P10-BE-NEXT:    addi r1, r1, 112
; CHECK-P10-BE-NEXT:    ld r0, 16(r1)
; CHECK-P10-BE-NEXT:    mtlr r0
; CHECK-P10-BE-NEXT:    blr
;
; CHECK-P10-CMP-LE-LABEL: testCompare1:
; CHECK-P10-CMP-LE:       # %bb.0: # %entry
; CHECK-P10-CMP-LE-NEXT:    mflr r0
; CHECK-P10-CMP-LE-NEXT:    std r0, 16(r1)
; CHECK-P10-CMP-LE-NEXT:    stdu r1, -112(r1)
; CHECK-P10-CMP-LE-NEXT:    addis r4, r2, testCompare1@toc@ha
; CHECK-P10-CMP-LE-NEXT:    lbz r3, 0(r3)
; CHECK-P10-CMP-LE-NEXT:    lbz r4, testCompare1@toc@l(r4)
; CHECK-P10-CMP-LE-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-CMP-LE-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-CMP-LE-NEXT:    clrldi r3, r3, 32
; CHECK-P10-CMP-LE-NEXT:    clrldi r4, r4, 32
; CHECK-P10-CMP-LE-NEXT:    sub r3, r4, r3
; CHECK-P10-CMP-LE-NEXT:    rldicl r3, r3, 1, 63
; CHECK-P10-CMP-LE-NEXT:    bl fn2
; CHECK-P10-CMP-LE-NEXT:    nop
; CHECK-P10-CMP-LE-NEXT:    addi r1, r1, 112
; CHECK-P10-CMP-LE-NEXT:    ld r0, 16(r1)
; CHECK-P10-CMP-LE-NEXT:    mtlr r0
; CHECK-P10-CMP-LE-NEXT:    blr
;
; CHECK-P10-CMP-BE-LABEL: testCompare1:
; CHECK-P10-CMP-BE:       # %bb.0: # %entry
; CHECK-P10-CMP-BE-NEXT:    plbz r4, testCompare1@PCREL(0), 1
; CHECK-P10-CMP-BE-NEXT:    lbz r3, 0(r3)
; CHECK-P10-CMP-BE-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-CMP-BE-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-CMP-BE-NEXT:    clrldi r4, r4, 32
; CHECK-P10-CMP-BE-NEXT:    clrldi r3, r3, 32
; CHECK-P10-CMP-BE-NEXT:    sub r3, r4, r3
; CHECK-P10-CMP-BE-NEXT:    rldicl r3, r3, 1, 63
; CHECK-P10-CMP-BE-NEXT:    b fn2@notoc
; CHECK-P10-CMP-BE-NEXT:    #TC_RETURNd8 fn2@notoc 0
entry:
  %bf.load = load i8, i8* bitcast (i32 (%struct.tree_common*)* @testCompare1 to i8*), align 4
  %bf.clear = and i8 %bf.load, 1
  %0 = getelementptr inbounds %struct.tree_common, %struct.tree_common* %arg1, i64 0, i32 0
  %bf.load1 = load i8, i8* %0, align 4
  %bf.clear2 = and i8 %bf.load1, 1
  %cmp = icmp ult i8 %bf.clear, %bf.clear2
  %conv = zext i1 %cmp to i32
  %call = tail call signext i32 bitcast (i32 (...)* @fn2 to i32 (i32)*)(i32 signext %conv) #2
  ret i32 undef
}

; Function Attrs: norecurse nounwind readnone
define dso_local signext i32 @testCompare2(i32 zeroext %a, i32 zeroext %b) {
; CHECK-LABEL: testCompare2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    clrlwi r3, r3, 31
; CHECK-NEXT:    clrlwi r4, r4, 31
; CHECK-NEXT:    clrldi r3, r3, 32
; CHECK-NEXT:    clrldi r4, r4, 32
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    rldicl r3, r3, 1, 63
; CHECK-NEXT:    blr
;
; CHECK-P10-LABEL: testCompare2:
; CHECK-P10:       # %bb.0: # %entry
; CHECK-P10-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-NEXT:    cmplw r3, r4
; CHECK-P10-NEXT:    setbc r3, lt
; CHECK-P10-NEXT:    blr
;
; CHECK-P10-CMP-LABEL: testCompare2:
; CHECK-P10-CMP:       # %bb.0: # %entry
; CHECK-P10-CMP-NEXT:    clrlwi r3, r3, 31
; CHECK-P10-CMP-NEXT:    clrlwi r4, r4, 31
; CHECK-P10-CMP-NEXT:    clrldi r3, r3, 32
; CHECK-P10-CMP-NEXT:    clrldi r4, r4, 32
; CHECK-P10-CMP-NEXT:    sub r3, r3, r4
; CHECK-P10-CMP-NEXT:    rldicl r3, r3, 1, 63
; CHECK-P10-CMP-NEXT:    blr
entry:
  %and = and i32 %a, 1
  %and1 = and i32 %b, 1
  %cmp = icmp ult i32 %and, %and1
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}
