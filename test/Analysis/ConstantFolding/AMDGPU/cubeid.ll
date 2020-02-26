; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

declare float @llvm.amdgcn.cubeid(float, float, float)

define void @test(float* %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P:%.*]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 0.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 2.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 4.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 5.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 3.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    store volatile float 1.000000e+00, float* [[P]]
; CHECK-NEXT:    ret void
;
  %p3p4p5 = call float @llvm.amdgcn.cubeid(float +3.0, float +4.0, float +5.0)
  store volatile float %p3p4p5, float* %p
  %p3p5p4 = call float @llvm.amdgcn.cubeid(float +3.0, float +5.0, float +4.0)
  store volatile float %p3p5p4, float* %p
  %p4p3p5 = call float @llvm.amdgcn.cubeid(float +4.0, float +3.0, float +5.0)
  store volatile float %p4p3p5, float* %p
  %p4p5p3 = call float @llvm.amdgcn.cubeid(float +4.0, float +5.0, float +3.0)
  store volatile float %p4p5p3, float* %p
  %p5p3p4 = call float @llvm.amdgcn.cubeid(float +5.0, float +3.0, float +4.0)
  store volatile float %p5p3p4, float* %p
  %p5p4p3 = call float @llvm.amdgcn.cubeid(float +5.0, float +4.0, float +3.0)
  store volatile float %p5p4p3, float* %p
  %p3p4n5 = call float @llvm.amdgcn.cubeid(float +3.0, float +4.0, float -5.0)
  store volatile float %p3p4n5, float* %p
  %p3p5n4 = call float @llvm.amdgcn.cubeid(float +3.0, float +5.0, float -4.0)
  store volatile float %p3p5n4, float* %p
  %p4p3n5 = call float @llvm.amdgcn.cubeid(float +4.0, float +3.0, float -5.0)
  store volatile float %p4p3n5, float* %p
  %p4p5n3 = call float @llvm.amdgcn.cubeid(float +4.0, float +5.0, float -3.0)
  store volatile float %p4p5n3, float* %p
  %p5p3n4 = call float @llvm.amdgcn.cubeid(float +5.0, float +3.0, float -4.0)
  store volatile float %p5p3n4, float* %p
  %p5p4n3 = call float @llvm.amdgcn.cubeid(float +5.0, float +4.0, float -3.0)
  store volatile float %p5p4n3, float* %p
  %p3n4p5 = call float @llvm.amdgcn.cubeid(float +3.0, float -4.0, float +5.0)
  store volatile float %p3n4p5, float* %p
  %p3n5p4 = call float @llvm.amdgcn.cubeid(float +3.0, float -5.0, float +4.0)
  store volatile float %p3n5p4, float* %p
  %p4n3p5 = call float @llvm.amdgcn.cubeid(float +4.0, float -3.0, float +5.0)
  store volatile float %p4n3p5, float* %p
  %p4n5p3 = call float @llvm.amdgcn.cubeid(float +4.0, float -5.0, float +3.0)
  store volatile float %p4n5p3, float* %p
  %p5n3p4 = call float @llvm.amdgcn.cubeid(float +5.0, float -3.0, float +4.0)
  store volatile float %p5n3p4, float* %p
  %p5n4p3 = call float @llvm.amdgcn.cubeid(float +5.0, float -4.0, float +3.0)
  store volatile float %p5n4p3, float* %p
  %p3n4n5 = call float @llvm.amdgcn.cubeid(float +3.0, float -4.0, float -5.0)
  store volatile float %p3n4n5, float* %p
  %p3n5n4 = call float @llvm.amdgcn.cubeid(float +3.0, float -5.0, float -4.0)
  store volatile float %p3n5n4, float* %p
  %p4n3n5 = call float @llvm.amdgcn.cubeid(float +4.0, float -3.0, float -5.0)
  store volatile float %p4n3n5, float* %p
  %p4n5n3 = call float @llvm.amdgcn.cubeid(float +4.0, float -5.0, float -3.0)
  store volatile float %p4n5n3, float* %p
  %p5n3n4 = call float @llvm.amdgcn.cubeid(float +5.0, float -3.0, float -4.0)
  store volatile float %p5n3n4, float* %p
  %p5n4n3 = call float @llvm.amdgcn.cubeid(float +5.0, float -4.0, float -3.0)
  store volatile float %p5n4n3, float* %p
  %n3p4p5 = call float @llvm.amdgcn.cubeid(float -3.0, float +4.0, float +5.0)
  store volatile float %n3p4p5, float* %p
  %n3p5p4 = call float @llvm.amdgcn.cubeid(float -3.0, float +5.0, float +4.0)
  store volatile float %n3p5p4, float* %p
  %n4p3p5 = call float @llvm.amdgcn.cubeid(float -4.0, float +3.0, float +5.0)
  store volatile float %n4p3p5, float* %p
  %n4p5p3 = call float @llvm.amdgcn.cubeid(float -4.0, float +5.0, float +3.0)
  store volatile float %n4p5p3, float* %p
  %n5p3p4 = call float @llvm.amdgcn.cubeid(float -5.0, float +3.0, float +4.0)
  store volatile float %n5p3p4, float* %p
  %n5p4p3 = call float @llvm.amdgcn.cubeid(float -5.0, float +4.0, float +3.0)
  store volatile float %n5p4p3, float* %p
  %n3p4n5 = call float @llvm.amdgcn.cubeid(float -3.0, float +4.0, float -5.0)
  store volatile float %n3p4n5, float* %p
  %n3p5n4 = call float @llvm.amdgcn.cubeid(float -3.0, float +5.0, float -4.0)
  store volatile float %n3p5n4, float* %p
  %n4p3n5 = call float @llvm.amdgcn.cubeid(float -4.0, float +3.0, float -5.0)
  store volatile float %n4p3n5, float* %p
  %n4p5n3 = call float @llvm.amdgcn.cubeid(float -4.0, float +5.0, float -3.0)
  store volatile float %n4p5n3, float* %p
  %n5p3n4 = call float @llvm.amdgcn.cubeid(float -5.0, float +3.0, float -4.0)
  store volatile float %n5p3n4, float* %p
  %n5p4n3 = call float @llvm.amdgcn.cubeid(float -5.0, float +4.0, float -3.0)
  store volatile float %n5p4n3, float* %p
  %n3n4p5 = call float @llvm.amdgcn.cubeid(float -3.0, float -4.0, float +5.0)
  store volatile float %n3n4p5, float* %p
  %n3n5p4 = call float @llvm.amdgcn.cubeid(float -3.0, float -5.0, float +4.0)
  store volatile float %n3n5p4, float* %p
  %n4n3p5 = call float @llvm.amdgcn.cubeid(float -4.0, float -3.0, float +5.0)
  store volatile float %n4n3p5, float* %p
  %n4n5p3 = call float @llvm.amdgcn.cubeid(float -4.0, float -5.0, float +3.0)
  store volatile float %n4n5p3, float* %p
  %n5n3p4 = call float @llvm.amdgcn.cubeid(float -5.0, float -3.0, float +4.0)
  store volatile float %n5n3p4, float* %p
  %n5n4p3 = call float @llvm.amdgcn.cubeid(float -5.0, float -4.0, float +3.0)
  store volatile float %n5n4p3, float* %p
  %n3n4n5 = call float @llvm.amdgcn.cubeid(float -3.0, float -4.0, float -5.0)
  store volatile float %n3n4n5, float* %p
  %n3n5n4 = call float @llvm.amdgcn.cubeid(float -3.0, float -5.0, float -4.0)
  store volatile float %n3n5n4, float* %p
  %n4n3n5 = call float @llvm.amdgcn.cubeid(float -4.0, float -3.0, float -5.0)
  store volatile float %n4n3n5, float* %p
  %n4n5n3 = call float @llvm.amdgcn.cubeid(float -4.0, float -5.0, float -3.0)
  store volatile float %n4n5n3, float* %p
  %n5n3n4 = call float @llvm.amdgcn.cubeid(float -5.0, float -3.0, float -4.0)
  store volatile float %n5n3n4, float* %p
  %n5n4n3 = call float @llvm.amdgcn.cubeid(float -5.0, float -4.0, float -3.0)
  store volatile float %n5n4n3, float* %p
  ret void
}
