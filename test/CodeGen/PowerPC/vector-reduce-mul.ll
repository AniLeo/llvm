; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mcpu=pwr9 -mtriple=powerpc64le < %s | FileCheck %s --check-prefix=PWR9LE
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mcpu=pwr9 -mtriple=powerpc64 < %s | FileCheck %s --check-prefix=PWR9BE
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mcpu=pwr10 -mtriple=powerpc64le < %s | FileCheck %s --check-prefix=PWR10LE
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   -mcpu=pwr10 -mtriple=powerpc64 < %s | FileCheck %s --check-prefix=PWR10BE

define dso_local i32 @v2i32(<2 x i32> %a) local_unnamed_addr #0 {
; PWR9LE-LABEL: v2i32:
; PWR9LE:       # %bb.0: # %entry
; PWR9LE-NEXT:    xxspltw v3, v2, 2
; PWR9LE-NEXT:    li r3, 0
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    vextuwrx r3, r3, v2
; PWR9LE-NEXT:    blr
;
; PWR9BE-LABEL: v2i32:
; PWR9BE:       # %bb.0: # %entry
; PWR9BE-NEXT:    xxspltw v3, v2, 1
; PWR9BE-NEXT:    li r3, 0
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    vextuwlx r3, r3, v2
; PWR9BE-NEXT:    blr
;
; PWR10LE-LABEL: v2i32:
; PWR10LE:       # %bb.0: # %entry
; PWR10LE-NEXT:    xxspltw v3, v2, 2
; PWR10LE-NEXT:    li r3, 0
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    vextuwrx r3, r3, v2
; PWR10LE-NEXT:    blr
;
; PWR10BE-LABEL: v2i32:
; PWR10BE:       # %bb.0: # %entry
; PWR10BE-NEXT:    xxspltw v3, v2, 1
; PWR10BE-NEXT:    li r3, 0
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    vextuwlx r3, r3, v2
; PWR10BE-NEXT:    blr
entry:
  %0 = call i32 @llvm.vector.reduce.mul.v2i32(<2 x i32> %a)
  ret i32 %0
}

define dso_local i32 @v4i32(<4 x i32> %a) local_unnamed_addr #0 {
; PWR9LE-LABEL: v4i32:
; PWR9LE:       # %bb.0: # %entry
; PWR9LE-NEXT:    xxswapd v3, v2
; PWR9LE-NEXT:    li r3, 0
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    xxspltw v3, v2, 2
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    vextuwrx r3, r3, v2
; PWR9LE-NEXT:    blr
;
; PWR9BE-LABEL: v4i32:
; PWR9BE:       # %bb.0: # %entry
; PWR9BE-NEXT:    xxswapd v3, v2
; PWR9BE-NEXT:    li r3, 0
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    xxspltw v3, v2, 1
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    vextuwlx r3, r3, v2
; PWR9BE-NEXT:    blr
;
; PWR10LE-LABEL: v4i32:
; PWR10LE:       # %bb.0: # %entry
; PWR10LE-NEXT:    xxswapd v3, v2
; PWR10LE-NEXT:    li r3, 0
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    xxspltw v3, v2, 2
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    vextuwrx r3, r3, v2
; PWR10LE-NEXT:    blr
;
; PWR10BE-LABEL: v4i32:
; PWR10BE:       # %bb.0: # %entry
; PWR10BE-NEXT:    xxswapd v3, v2
; PWR10BE-NEXT:    li r3, 0
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    xxspltw v3, v2, 1
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    vextuwlx r3, r3, v2
; PWR10BE-NEXT:    blr
entry:
  %0 = call i32 @llvm.vector.reduce.mul.v4i32(<4 x i32> %a)
  ret i32 %0
}

define dso_local i32 @v8i32(<8 x i32> %a) local_unnamed_addr #0 {
; PWR9LE-LABEL: v8i32:
; PWR9LE:       # %bb.0: # %entry
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    li r3, 0
; PWR9LE-NEXT:    xxswapd v3, v2
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    xxspltw v3, v2, 2
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    vextuwrx r3, r3, v2
; PWR9LE-NEXT:    blr
;
; PWR9BE-LABEL: v8i32:
; PWR9BE:       # %bb.0: # %entry
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    li r3, 0
; PWR9BE-NEXT:    xxswapd v3, v2
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    xxspltw v3, v2, 1
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    vextuwlx r3, r3, v2
; PWR9BE-NEXT:    blr
;
; PWR10LE-LABEL: v8i32:
; PWR10LE:       # %bb.0: # %entry
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    li r3, 0
; PWR10LE-NEXT:    xxswapd v3, v2
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    xxspltw v3, v2, 2
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    vextuwrx r3, r3, v2
; PWR10LE-NEXT:    blr
;
; PWR10BE-LABEL: v8i32:
; PWR10BE:       # %bb.0: # %entry
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    li r3, 0
; PWR10BE-NEXT:    xxswapd v3, v2
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    xxspltw v3, v2, 1
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    vextuwlx r3, r3, v2
; PWR10BE-NEXT:    blr
entry:
  %0 = call i32 @llvm.vector.reduce.mul.v8i32(<8 x i32> %a)
  ret i32 %0
}

define dso_local i32 @v16i32(<16 x i32> %a) local_unnamed_addr #0 {
; PWR9LE-LABEL: v16i32:
; PWR9LE:       # %bb.0: # %entry
; PWR9LE-NEXT:    vmuluwm v3, v3, v5
; PWR9LE-NEXT:    vmuluwm v2, v2, v4
; PWR9LE-NEXT:    li r3, 0
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    xxswapd v3, v2
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    xxspltw v3, v2, 2
; PWR9LE-NEXT:    vmuluwm v2, v2, v3
; PWR9LE-NEXT:    vextuwrx r3, r3, v2
; PWR9LE-NEXT:    blr
;
; PWR9BE-LABEL: v16i32:
; PWR9BE:       # %bb.0: # %entry
; PWR9BE-NEXT:    vmuluwm v3, v3, v5
; PWR9BE-NEXT:    vmuluwm v2, v2, v4
; PWR9BE-NEXT:    li r3, 0
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    xxswapd v3, v2
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    xxspltw v3, v2, 1
; PWR9BE-NEXT:    vmuluwm v2, v2, v3
; PWR9BE-NEXT:    vextuwlx r3, r3, v2
; PWR9BE-NEXT:    blr
;
; PWR10LE-LABEL: v16i32:
; PWR10LE:       # %bb.0: # %entry
; PWR10LE-NEXT:    vmuluwm v3, v3, v5
; PWR10LE-NEXT:    vmuluwm v2, v2, v4
; PWR10LE-NEXT:    li r3, 0
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    xxswapd v3, v2
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    xxspltw v3, v2, 2
; PWR10LE-NEXT:    vmuluwm v2, v2, v3
; PWR10LE-NEXT:    vextuwrx r3, r3, v2
; PWR10LE-NEXT:    blr
;
; PWR10BE-LABEL: v16i32:
; PWR10BE:       # %bb.0: # %entry
; PWR10BE-NEXT:    vmuluwm v3, v3, v5
; PWR10BE-NEXT:    vmuluwm v2, v2, v4
; PWR10BE-NEXT:    li r3, 0
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    xxswapd v3, v2
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    xxspltw v3, v2, 1
; PWR10BE-NEXT:    vmuluwm v2, v2, v3
; PWR10BE-NEXT:    vextuwlx r3, r3, v2
; PWR10BE-NEXT:    blr
entry:
  %0 = call i32 @llvm.vector.reduce.mul.v16i32(<16 x i32> %a)
  ret i32 %0
}

declare i32 @llvm.vector.reduce.mul.v2i32(<2 x i32>) #0
declare i32 @llvm.vector.reduce.mul.v4i32(<4 x i32>) #0
declare i32 @llvm.vector.reduce.mul.v8i32(<8 x i32>) #0
declare i32 @llvm.vector.reduce.mul.v16i32(<16 x i32>) #0

attributes #0 = { nounwind }
