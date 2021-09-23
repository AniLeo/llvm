; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s
; RUN: llc -march=hexagon -early-live-intervals -verify-machineinstrs < %s | FileCheck %s

target datalayout = "e-m:e-p:32:32:32-a:0-n16:32-i64:64:64-i32:32:32-i16:16:16-i1:8:8-f32:32:32-f64:64:64-v32:32:32-v64:64:64-v512:512:512-v1024:1024:1024-v2048:2048:2048"
target triple = "hexagon"

define i64 @f0(i32 %a0, i64 %a1, i32 %a2, i32 %a3, i1 zeroext %a4) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r29+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = sext i1 %a4 to i64
  ret i64 %v0
}

attributes #0 = { nounwind "target-cpu"="hexagonv66" "target-features"="+v66,-long-calls" }
