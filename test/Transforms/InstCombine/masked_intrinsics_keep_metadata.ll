; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

@g0 = global <4 x i32> zeroinitializer, align 16

define inreg <4 x i32> @mload1(<4 x i32>* nocapture readonly %a0) #0 {
; CHECK-LABEL: @mload1(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[UNMASKEDLOAD:%.*]] = load <4 x i32>, <4 x i32>* [[A0:%.*]], align 16, !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    ret <4 x i32> [[UNMASKEDLOAD]]
;
b0:
  %v0 = call <4 x i32> @llvm.masked.load.v4i1.p0v4i1(<4 x i32>* %a0, i32 16, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> undef), !tbaa !0
  ret <4 x i32> %v0
}

define inreg <4 x i32> @mload2() #0 {
; CHECK-LABEL: @mload2(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    [[UNMASKEDLOAD:%.*]] = load <4 x i32>, <4 x i32>* @g0, align 16, !tbaa [[TBAA0]]
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i32> [[UNMASKEDLOAD]], i32 0, i32 0
; CHECK-NEXT:    ret <4 x i32> [[TMP0]]
;
b0:
  %v0 = call <4 x i32> @llvm.masked.load.v4i1.p0v4i1(<4 x i32>* @g0, i32 16, <4 x i1> <i1 false, i1 true, i1 true, i1 true>, <4 x i32> zeroinitializer), !tbaa !0
  ret <4 x i32> %v0
}

define void @mstore(<4 x i32> %a0, <4 x i32>* nocapture readonly %a1) #0 {
; CHECK-LABEL: @mstore(
; CHECK-NEXT:  b0:
; CHECK-NEXT:    store <4 x i32> [[A0:%.*]], <4 x i32>* [[A1:%.*]], align 16, !tbaa [[TBAA0]]
; CHECK-NEXT:    ret void
;
b0:
  call void @llvm.masked.store.v4i1.p0v4i1(<4 x i32> %a0, <4 x i32>* %a1, i32 16, <4 x i1> <i1 true, i1 true, i1 true, i1 true>), !tbaa !0
  ret void
}

attributes #0 = { norecurse nounwind }

declare <4 x i32> @llvm.masked.load.v4i1.p0v4i1(<4 x i32>*, i32, <4 x i1>, <4 x i32>)
declare void @llvm.masked.store.v4i1.p0v4i1(<4 x i32>, <4 x i32>*, i32, <4 x i1>)

!0 = !{!1, !1, i64 0}
!1 = !{!"omnipotent char", !2, i64 0}
!2 = !{!"Simple C/C++ TBAA"}

