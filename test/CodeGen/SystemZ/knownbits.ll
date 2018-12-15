; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=s390x-linux-gnu -mcpu=z13 < %s  | FileCheck %s

; Test that DAGCombiner gets helped by computeKnownBitsForTargetNode().

; SystemZISD::REPLICATE
define i32 @f0() {
; CHECK-LABEL: f0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vgbm %v0, 0
; CHECK-NEXT:    vceqf %v0, %v0, %v0
; CHECK-NEXT:    vrepif %v1, 1
; CHECK-NEXT:    vnc %v0, %v1, %v0
; CHECK-NEXT:    vlgvf %r2, %v0, 3
; CHECK-NEXT:    # kill: def $r2l killed $r2l killed $r2d
; CHECK-NEXT:    br %r14
  %cmp0 = icmp ne <4 x i32> undef, zeroinitializer
  %zxt0 = zext <4 x i1> %cmp0 to <4 x i32>
  %ext0 = extractelement <4 x i32> %zxt0, i32 3
  br label %exit

exit:
; The vector icmp+zext involves a REPLICATE of 1's. If KnownBits reflects
; this, DAGCombiner can see that the i32 icmp and zext here are not needed.
  %cmp1 = icmp ne i32 %ext0, 0
  %zxt1 = zext i1 %cmp1 to i32
  ret i32 %zxt1
}

; SystemZISD::JOIN_DWORDS (and REPLICATE)
; The DAG XOR has JOIN_DWORDS and REPLICATE operands. With KnownBits properly set
; for both these nodes, ICMP is used instead of TM during lowering because
; adjustForRedundantAnd() succeeds.
define void @f1() {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    clhhsi 0, 0
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    lochie %r0, 1
; CHECK-NEXT:    lghi %r1, 1
; CHECK-NEXT:    vlvgp %v0, %r0, %r1
; CHECK-NEXT:    vrepig %v1, 1
; CHECK-NEXT:    vx %v0, %v0, %v1
; CHECK-NEXT:    vlgvf %r0, %v0, 1
; CHECK-NEXT:    cijlh %r0, 0, .LBB1_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    vlgvf %r0, %v0, 3
; CHECK-NEXT:    cijlh %r0, 0, .LBB1_3
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:  .LBB1_3:
  %1 = load i16, i16* null, align 2
  %2 = icmp eq i16 %1, 0
  %3 = insertelement <2 x i1> undef, i1 %2, i32 0
  %4 = insertelement <2 x i1> %3, i1 true, i32 1
  %5 = xor <2 x i1> %4, <i1 true, i1 true>
  %6 = extractelement <2 x i1> %5, i32 0
  %7 = extractelement <2 x i1> %5, i32 1
  %8 = or i1 %6, %7
  br i1 %8, label %10, label %9

; <label>:8:                                      ; preds = %0
  unreachable

; <label>:9:                                      ; preds = %0
  unreachable
}
