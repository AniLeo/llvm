; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-- -amdgpu-codegenprepare %s | FileCheck %s

define amdgpu_kernel void @divrem24_assume(i32 addrspace(1)* %arg, i32 %arg1) {
; CHECK-LABEL: @divrem24_assume(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = tail call i32 @llvm.amdgcn.workitem.id.x(), !range !0
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[ARG1:%.*]], 42
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[TMP2]])
; CHECK-NEXT:    [[TMP0:%.*]] = uitofp i32 [[TMP]] to float
; CHECK-NEXT:    [[TMP1:%.*]] = uitofp i32 [[ARG1]] to float
; CHECK-NEXT:    [[TMP2:%.*]] = call fast float @llvm.amdgcn.rcp.f32(float [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast float [[TMP0]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = call fast float @llvm.trunc.f32(float [[TMP3]])
; CHECK-NEXT:    [[TMP5:%.*]] = fneg fast float [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = call fast float @llvm.amdgcn.fmad.ftz.f32(float [[TMP5]], float [[TMP1]], float [[TMP0]])
; CHECK-NEXT:    [[TMP7:%.*]] = fptoui float [[TMP4]] to i32
; CHECK-NEXT:    [[TMP8:%.*]] = call fast float @llvm.fabs.f32(float [[TMP6]])
; CHECK-NEXT:    [[TMP9:%.*]] = call fast float @llvm.fabs.f32(float [[TMP1]])
; CHECK-NEXT:    [[TMP10:%.*]] = fcmp fast oge float [[TMP8]], [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = select i1 [[TMP10]], i32 1, i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = add i32 [[TMP7]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = and i32 [[TMP12]], 1023
; CHECK-NEXT:    [[TMP4:%.*]] = zext i32 [[TMP13]] to i64
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32 addrspace(1)* [[ARG:%.*]], i64 [[TMP4]]
; CHECK-NEXT:    store i32 0, i32 addrspace(1)* [[TMP5]], align 4
; CHECK-NEXT:    ret void
;
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x(), !range !0
  %tmp2 = icmp ult i32 %arg1, 42
  tail call void @llvm.assume(i1 %tmp2)
  %tmp3 = udiv i32 %tmp, %arg1
  %tmp4 = zext i32 %tmp3 to i64
  %tmp5 = getelementptr inbounds i32, i32 addrspace(1)* %arg, i64 %tmp4
  store i32 0, i32 addrspace(1)* %tmp5, align 4
  ret void
}

declare void @llvm.assume(i1)
declare i32 @llvm.amdgcn.workitem.id.x()

!0 = !{i32 0, i32 1024}
