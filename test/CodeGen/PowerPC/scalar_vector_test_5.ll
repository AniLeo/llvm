; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr9 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s --check-prefix=P9LE
; RUN: llc -mcpu=pwr9 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64-unknown-linux-gnu < %s | FileCheck %s --check-prefix=P9BE
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s --check-prefix=P8LE
; RUN: llc -mcpu=pwr8 -verify-machineinstrs -ppc-vsr-nums-as-vr -ppc-asm-full-reg-names \
; RUN:    -mtriple=powerpc64-unknown-linux-gnu < %s | FileCheck %s --check-prefix=P8BE

define i8 @scalar_to_vector_half(i16* nocapture readonly %ad) {
; CHECK-LABEL: scalar_to_vector_half:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lhz 3, 0(3)
; CHECK-NEXT:    sldi 3, 3, 56
; CHECK-NEXT:    mtfprd 0, 3
; CHECK-NEXT:    mffprd 3, 0
; CHECK-NEXT:    rldicl 3, 3, 8, 56
; CHECK-NEXT:    blr
; P9LE-LABEL: scalar_to_vector_half:
; P9LE:       # %bb.0: # %entry
; P9LE-NEXT:    lhz r3, 0(r3)
; P9LE-NEXT:    blr
;
; P9BE-LABEL: scalar_to_vector_half:
; P9BE:       # %bb.0: # %entry
; P9BE-NEXT:    lxsihzx v2, 0, r3
; P9BE-NEXT:    li r3, 0
; P9BE-NEXT:    vsplth v2, v2, 3
; P9BE-NEXT:    vextublx r3, r3, v2
; P9BE-NEXT:    blr
;
; P8LE-LABEL: scalar_to_vector_half:
; P8LE:       # %bb.0: # %entry
; P8LE-NEXT:    lhz r3, 0(r3)
; P8LE-NEXT:    blr
;
; P8BE-LABEL: scalar_to_vector_half:
; P8BE:       # %bb.0: # %entry
; P8BE-NEXT:    lhz r3, 0(r3)
; P8BE-NEXT:    sldi r3, r3, 56
; P8BE-NEXT:    mtfprd f0, r3
; P8BE-NEXT:    mffprd r3, f0
; P8BE-NEXT:    rldicl r3, r3, 8, 56
; P8BE-NEXT:    blr
entry:
    %0 = bitcast i16* %ad to <2 x i8>*
    %1 = load <2 x i8>, <2 x i8>* %0, align 1
    %2 = extractelement <2 x i8> %1, i32 0
    ret i8 %2
}

