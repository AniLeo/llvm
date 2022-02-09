; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s  -passes='print<cost-model>' 2>&1 -disable-output -mtriple=armv7-linux-gnueabihf -mcpu=cortex-a9 | FileCheck --check-prefix=COST %s
; To see the assembly output: llc -mcpu=cortex-a9 < %s | FileCheck --check-prefix=ASM %s
; ASM lines below are only for reference, tests on that direction should go to tests/CodeGen/ARM

; ModuleID = 'arm.ll'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:64:128-a0:0:64-n32-S64"
target triple = "armv7--linux-gnueabihf"

%T216 = type <2 x i16>
%T232 = type <2 x i32>
%T264 = type <2 x i64>

%T416 = type <4 x i16>
%T432 = type <4 x i32>
%T464 = type <4 x i64>

define void @direct(%T432* %loadaddr, %T432* %loadaddr2, %T432* %storeaddr) {
; COST-LABEL: 'direct'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <4 x i32>, <4 x i32>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <4 x i32>, <4 x i32>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <4 x i32> %v0, %v1
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %r3, <4 x i32>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T432, %T432* %loadaddr
; ASM: vld1.64
  %v1 = load %T432, %T432* %loadaddr2
; ASM: vld1.64
  %r3 = sub %T432 %v0, %v1
; ASM: vsub.i32
  store %T432 %r3, %T432* %storeaddr
; ASM: vst1.64
  ret void
}

define void @ups1632(%T416* %loadaddr, %T416* %loadaddr2, %T432* %storeaddr) {
; COST-LABEL: 'ups1632'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <4 x i16>, <4 x i16>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <4 x i16>, <4 x i16>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %r1 = sext <4 x i16> %v0 to <4 x i32>
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %r2 = sext <4 x i16> %v1 to <4 x i32>
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <4 x i32> %r1, %r2
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %r3, <4 x i32>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T416, %T416* %loadaddr
; ASM: vldr
  %v1 = load %T416, %T416* %loadaddr2
; ASM: vldr
  %r1 = sext %T416 %v0 to %T432
  %r2 = sext %T416 %v1 to %T432
  %r3 = sub %T432 %r1, %r2
; ASM: vsubl.s16
  store %T432 %r3, %T432* %storeaddr
; ASM: vst1.64
  ret void
}

define void @upu1632(%T416* %loadaddr, %T416* %loadaddr2, %T432* %storeaddr) {
; COST-LABEL: 'upu1632'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <4 x i16>, <4 x i16>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <4 x i16>, <4 x i16>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %r1 = zext <4 x i16> %v0 to <4 x i32>
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %r2 = zext <4 x i16> %v1 to <4 x i32>
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <4 x i32> %r1, %r2
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %r3, <4 x i32>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T416, %T416* %loadaddr
; ASM: vldr
  %v1 = load %T416, %T416* %loadaddr2
; ASM: vldr
  %r1 = zext %T416 %v0 to %T432
  %r2 = zext %T416 %v1 to %T432
  %r3 = sub %T432 %r1, %r2
; ASM: vsubl.u16
  store %T432 %r3, %T432* %storeaddr
; ASM: vst1.64
  ret void
}

define void @ups3264(%T232* %loadaddr, %T232* %loadaddr2, %T264* %storeaddr) {
; COST-LABEL: 'ups3264'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <2 x i32>, <2 x i32>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <2 x i32>, <2 x i32>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <2 x i32> %v0, %v1
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %st = sext <2 x i32> %r3 to <2 x i64>
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> %st, <2 x i64>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T232, %T232* %loadaddr
; ASM: vldr
  %v1 = load %T232, %T232* %loadaddr2
; ASM: vldr
  %r3 = sub %T232 %v0, %v1
; ASM: vsub.i32
  %st = sext %T232 %r3 to %T264
; ASM: vmovl.s32
  store %T264 %st, %T264* %storeaddr
; ASM: vst1.64
  ret void
}

define void @upu3264(%T232* %loadaddr, %T232* %loadaddr2, %T264* %storeaddr) {
; COST-LABEL: 'upu3264'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <2 x i32>, <2 x i32>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <2 x i32>, <2 x i32>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <2 x i32> %v0, %v1
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %st = zext <2 x i32> %r3 to <2 x i64>
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> %st, <2 x i64>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T232, %T232* %loadaddr
; ASM: vldr
  %v1 = load %T232, %T232* %loadaddr2
; ASM: vldr
  %r3 = sub %T232 %v0, %v1
; ASM: vsub.i32
  %st = zext %T232 %r3 to %T264
; ASM: vmovl.u32
  store %T264 %st, %T264* %storeaddr
; ASM: vst1.64
  ret void
}

define void @dn3216(%T432* %loadaddr, %T432* %loadaddr2, %T416* %storeaddr) {
; COST-LABEL: 'dn3216'
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v0 = load <4 x i32>, <4 x i32>* %loadaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = load <4 x i32>, <4 x i32>* %loadaddr2, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r3 = sub <4 x i32> %v0, %v1
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %st = trunc <4 x i32> %r3 to <4 x i16>
; COST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %st, <4 x i16>* %storeaddr, align 8
; COST-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v0 = load %T432, %T432* %loadaddr
; ASM: vld1.64
  %v1 = load %T432, %T432* %loadaddr2
; ASM: vld1.64
  %r3 = sub %T432 %v0, %v1
; ASM: vsub.i32
  %st = trunc %T432 %r3 to %T416
; ASM: vmovn.i32
  store %T416 %st, %T416* %storeaddr
; ASM: vstr
  ret void
}
