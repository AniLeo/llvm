; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -mtriple=amdgcn-unknown-amdhsa -S -amdgpu-annotate-kernel-features < %s | FileCheck -check-prefixes=HSA,AKF_HSA %s
; RUN: opt -mtriple=amdgcn-unknown-amdhsa -S -amdgpu-attributor < %s | FileCheck -check-prefixes=HSA,ATTRIBUTOR_HSA %s

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5"

declare i32 @llvm.amdgcn.workgroup.id.x() #0
declare i32 @llvm.amdgcn.workgroup.id.y() #0
declare i32 @llvm.amdgcn.workgroup.id.z() #0

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare i32 @llvm.amdgcn.workitem.id.y() #0
declare i32 @llvm.amdgcn.workitem.id.z() #0

declare i8 addrspace(4)* @llvm.amdgcn.dispatch.ptr() #0
declare i8 addrspace(4)* @llvm.amdgcn.queue.ptr() #0
declare i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr() #0

declare i1 @llvm.amdgcn.is.shared(i8* nocapture) #2
declare i1 @llvm.amdgcn.is.private(i8* nocapture) #2

define amdgpu_kernel void @use_tgid_x(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_x
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR1:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.x()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_y(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_y
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR2:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.y()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @multi_use_tgid_y(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@multi_use_tgid_y
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR2]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_y(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_x_y
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR2]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR3:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workgroup.id.z()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_x_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR3]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_y_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_y_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR4:[0-9]+]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tgid_x_y_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tgid_x_y_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR4]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL2]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val2 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  store volatile i32 %val2, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_x
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.x()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_y(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_y
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR5:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.y()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR6:[0-9]+]] {
; HSA-NEXT:    [[VAL:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val = call i32 @llvm.amdgcn.workitem.id.z()
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x_tgid_x(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_x_tgid_x
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.x()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_y_tgid_y(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_y_tgid_y
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR7:[0-9]+]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.y()
  %val1 = call i32 @llvm.amdgcn.workgroup.id.y()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_tidig_x_y_z(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_tidig_x_y_z
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR8:[0-9]+]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL2]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workitem.id.y()
  %val2 = call i32 @llvm.amdgcn.workitem.id.z()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  store volatile i32 %val2, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_all_workitems(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_all_workitems
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR9:[0-9]+]] {
; HSA-NEXT:    [[VAL0:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; HSA-NEXT:    [[VAL1:%.*]] = call i32 @llvm.amdgcn.workitem.id.y()
; HSA-NEXT:    [[VAL2:%.*]] = call i32 @llvm.amdgcn.workitem.id.z()
; HSA-NEXT:    [[VAL3:%.*]] = call i32 @llvm.amdgcn.workgroup.id.x()
; HSA-NEXT:    [[VAL4:%.*]] = call i32 @llvm.amdgcn.workgroup.id.y()
; HSA-NEXT:    [[VAL5:%.*]] = call i32 @llvm.amdgcn.workgroup.id.z()
; HSA-NEXT:    store volatile i32 [[VAL0]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL1]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL2]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL3]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL4]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    store volatile i32 [[VAL5]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %val0 = call i32 @llvm.amdgcn.workitem.id.x()
  %val1 = call i32 @llvm.amdgcn.workitem.id.y()
  %val2 = call i32 @llvm.amdgcn.workitem.id.z()
  %val3 = call i32 @llvm.amdgcn.workgroup.id.x()
  %val4 = call i32 @llvm.amdgcn.workgroup.id.y()
  %val5 = call i32 @llvm.amdgcn.workgroup.id.z()
  store volatile i32 %val0, i32 addrspace(1)* %ptr
  store volatile i32 %val1, i32 addrspace(1)* %ptr
  store volatile i32 %val2, i32 addrspace(1)* %ptr
  store volatile i32 %val3, i32 addrspace(1)* %ptr
  store volatile i32 %val4, i32 addrspace(1)* %ptr
  store volatile i32 %val5, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_dispatch_ptr(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_dispatch_ptr
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR10:[0-9]+]] {
; HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call i8 addrspace(4)* @llvm.amdgcn.dispatch.ptr()
; HSA-NEXT:    [[BC:%.*]] = bitcast i8 addrspace(4)* [[DISPATCH_PTR]] to i32 addrspace(4)*
; HSA-NEXT:    [[VAL:%.*]] = load i32, i32 addrspace(4)* [[BC]], align 4
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %dispatch.ptr = call i8 addrspace(4)* @llvm.amdgcn.dispatch.ptr()
  %bc = bitcast i8 addrspace(4)* %dispatch.ptr to i32 addrspace(4)*
  %val = load i32, i32 addrspace(4)* %bc
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_queue_ptr(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_queue_ptr
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR11:[0-9]+]] {
; HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call i8 addrspace(4)* @llvm.amdgcn.queue.ptr()
; HSA-NEXT:    [[BC:%.*]] = bitcast i8 addrspace(4)* [[DISPATCH_PTR]] to i32 addrspace(4)*
; HSA-NEXT:    [[VAL:%.*]] = load i32, i32 addrspace(4)* [[BC]], align 4
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %dispatch.ptr = call i8 addrspace(4)* @llvm.amdgcn.queue.ptr()
  %bc = bitcast i8 addrspace(4)* %dispatch.ptr to i32 addrspace(4)*
  %val = load i32, i32 addrspace(4)* %bc
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_kernarg_segment_ptr(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_kernarg_segment_ptr
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[DISPATCH_PTR:%.*]] = call i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr()
; HSA-NEXT:    [[BC:%.*]] = bitcast i8 addrspace(4)* [[DISPATCH_PTR]] to i32 addrspace(4)*
; HSA-NEXT:    [[VAL:%.*]] = load i32, i32 addrspace(4)* [[BC]], align 4
; HSA-NEXT:    store i32 [[VAL]], i32 addrspace(1)* [[PTR]], align 4
; HSA-NEXT:    ret void
;
  %dispatch.ptr = call i8 addrspace(4)* @llvm.amdgcn.kernarg.segment.ptr()
  %bc = bitcast i8 addrspace(4)* %dispatch.ptr to i32 addrspace(4)*
  %val = load i32, i32 addrspace(4)* %bc
  store i32 %val, i32 addrspace(1)* %ptr
  ret void
}

define amdgpu_kernel void @use_group_to_flat_addrspacecast(i32 addrspace(3)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_group_to_flat_addrspacecast
; HSA-SAME: (i32 addrspace(3)* [[PTR:%.*]]) #[[ATTR11]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast i32 addrspace(3)* [[PTR]] to i32*
; HSA-NEXT:    store volatile i32 0, i32* [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast i32 addrspace(3)* %ptr to i32*
  store volatile i32 0, i32* %stof
  ret void
}

define amdgpu_kernel void @use_private_to_flat_addrspacecast(i32 addrspace(5)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_private_to_flat_addrspacecast
; HSA-SAME: (i32 addrspace(5)* [[PTR:%.*]]) #[[ATTR11]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast i32 addrspace(5)* [[PTR]] to i32*
; HSA-NEXT:    store volatile i32 0, i32* [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast i32 addrspace(5)* %ptr to i32*
  store volatile i32 0, i32* %stof
  ret void
}

define amdgpu_kernel void @use_flat_to_group_addrspacecast(i32* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_group_addrspacecast
; HSA-SAME: (i32* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast i32* [[PTR]] to i32 addrspace(3)*
; HSA-NEXT:    store volatile i32 0, i32 addrspace(3)* [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast i32* %ptr to i32 addrspace(3)*
  store volatile i32 0, i32 addrspace(3)* %ftos
  ret void
}

define amdgpu_kernel void @use_flat_to_private_addrspacecast(i32* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_private_addrspacecast
; HSA-SAME: (i32* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast i32* [[PTR]] to i32 addrspace(5)*
; HSA-NEXT:    store volatile i32 0, i32 addrspace(5)* [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast i32* %ptr to i32 addrspace(5)*
  store volatile i32 0, i32 addrspace(5)* %ftos
  ret void
}

; No-op addrspacecast should not use queue ptr
define amdgpu_kernel void @use_global_to_flat_addrspacecast(i32 addrspace(1)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_global_to_flat_addrspacecast
; HSA-SAME: (i32 addrspace(1)* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast i32 addrspace(1)* [[PTR]] to i32*
; HSA-NEXT:    store volatile i32 0, i32* [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast i32 addrspace(1)* %ptr to i32*
  store volatile i32 0, i32* %stof
  ret void
}

define amdgpu_kernel void @use_constant_to_flat_addrspacecast(i32 addrspace(4)* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_constant_to_flat_addrspacecast
; HSA-SAME: (i32 addrspace(4)* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[STOF:%.*]] = addrspacecast i32 addrspace(4)* [[PTR]] to i32*
; HSA-NEXT:    [[LD:%.*]] = load volatile i32, i32* [[STOF]], align 4
; HSA-NEXT:    ret void
;
  %stof = addrspacecast i32 addrspace(4)* %ptr to i32*
  %ld = load volatile i32, i32* %stof
  ret void
}

define amdgpu_kernel void @use_flat_to_global_addrspacecast(i32* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_global_addrspacecast
; HSA-SAME: (i32* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast i32* [[PTR]] to i32 addrspace(1)*
; HSA-NEXT:    store volatile i32 0, i32 addrspace(1)* [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast i32* %ptr to i32 addrspace(1)*
  store volatile i32 0, i32 addrspace(1)* %ftos
  ret void
}

define amdgpu_kernel void @use_flat_to_constant_addrspacecast(i32* %ptr) #1 {
; HSA-LABEL: define {{[^@]+}}@use_flat_to_constant_addrspacecast
; HSA-SAME: (i32* [[PTR:%.*]]) #[[ATTR1]] {
; HSA-NEXT:    [[FTOS:%.*]] = addrspacecast i32* [[PTR]] to i32 addrspace(4)*
; HSA-NEXT:    [[LD:%.*]] = load volatile i32, i32 addrspace(4)* [[FTOS]], align 4
; HSA-NEXT:    ret void
;
  %ftos = addrspacecast i32* %ptr to i32 addrspace(4)*
  %ld = load volatile i32, i32 addrspace(4)* %ftos
  ret void
}

define amdgpu_kernel void @use_is_shared(i8* %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_is_shared
; AKF_HSA-SAME: (i8* [[PTR:%.*]]) #[[ATTR11]] {
; AKF_HSA-NEXT:    [[IS_SHARED:%.*]] = call i1 @llvm.amdgcn.is.shared(i8* [[PTR]])
; AKF_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_SHARED]] to i32
; AKF_HSA-NEXT:    store i32 [[EXT]], i32 addrspace(1)* undef, align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_is_shared
; ATTRIBUTOR_HSA-SAME: (i8* [[PTR:%.*]]) #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %is.shared = call i1 @llvm.amdgcn.is.shared(i8* %ptr)
  %ext = zext i1 %is.shared to i32
  store i32 %ext, i32 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @use_is_private(i8* %ptr) #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_is_private
; AKF_HSA-SAME: (i8* [[PTR:%.*]]) #[[ATTR11]] {
; AKF_HSA-NEXT:    [[IS_PRIVATE:%.*]] = call i1 @llvm.amdgcn.is.private(i8* [[PTR]])
; AKF_HSA-NEXT:    [[EXT:%.*]] = zext i1 [[IS_PRIVATE]] to i32
; AKF_HSA-NEXT:    store i32 [[EXT]], i32 addrspace(1)* undef, align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_is_private
; ATTRIBUTOR_HSA-SAME: (i8* [[PTR:%.*]]) #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %is.private = call i1 @llvm.amdgcn.is.private(i8* %ptr)
  %ext = zext i1 %is.private to i32
  store i32 %ext, i32 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @use_alloca() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca
; AKF_HSA-SAME: () #[[ATTR12:[0-9]+]] {
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca
; ATTRIBUTOR_HSA-SAME: () #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %alloca = alloca i32, addrspace(5)
  store i32 0, i32 addrspace(5)* %alloca
  ret void
}

define amdgpu_kernel void @use_alloca_non_entry_block() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca_non_entry_block
; AKF_HSA-SAME: () #[[ATTR12]] {
; AKF_HSA-NEXT:  entry:
; AKF_HSA-NEXT:    br label [[BB:%.*]]
; AKF_HSA:       bb:
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca_non_entry_block
; ATTRIBUTOR_HSA-SAME: () #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:  entry:
; ATTRIBUTOR_HSA-NEXT:    br label [[BB:%.*]]
; ATTRIBUTOR_HSA:       bb:
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
entry:
  br label %bb

bb:
  %alloca = alloca i32, addrspace(5)
  store i32 0, i32 addrspace(5)* %alloca
  ret void
}

define void @use_alloca_func() #1 {
; AKF_HSA-LABEL: define {{[^@]+}}@use_alloca_func
; AKF_HSA-SAME: () #[[ATTR12]] {
; AKF_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; AKF_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; AKF_HSA-NEXT:    ret void
;
; ATTRIBUTOR_HSA-LABEL: define {{[^@]+}}@use_alloca_func
; ATTRIBUTOR_HSA-SAME: () #[[ATTR1]] {
; ATTRIBUTOR_HSA-NEXT:    [[ALLOCA:%.*]] = alloca i32, align 4, addrspace(5)
; ATTRIBUTOR_HSA-NEXT:    store i32 0, i32 addrspace(5)* [[ALLOCA]], align 4
; ATTRIBUTOR_HSA-NEXT:    ret void
;
  %alloca = alloca i32, addrspace(5)
  store i32 0, i32 addrspace(5)* %alloca
  ret void
}

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { nounwind }

;.
; AKF_HSA: attributes #[[ATTR0:[0-9]+]] = { nounwind readnone speculatable willreturn }
; AKF_HSA: attributes #[[ATTR1]] = { nounwind }
; AKF_HSA: attributes #[[ATTR2]] = { nounwind "amdgpu-work-group-id-y" }
; AKF_HSA: attributes #[[ATTR3]] = { nounwind "amdgpu-work-group-id-z" }
; AKF_HSA: attributes #[[ATTR4]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" }
; AKF_HSA: attributes #[[ATTR5]] = { nounwind "amdgpu-work-item-id-y" }
; AKF_HSA: attributes #[[ATTR6]] = { nounwind "amdgpu-work-item-id-z" }
; AKF_HSA: attributes #[[ATTR7]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-item-id-y" }
; AKF_HSA: attributes #[[ATTR8]] = { nounwind "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" }
; AKF_HSA: attributes #[[ATTR9]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" }
; AKF_HSA: attributes #[[ATTR10]] = { nounwind "amdgpu-dispatch-ptr" }
; AKF_HSA: attributes #[[ATTR11]] = { nounwind "amdgpu-queue-ptr" }
; AKF_HSA: attributes #[[ATTR12]] = { nounwind "amdgpu-stack-objects" }
;.
; ATTRIBUTOR_HSA: attributes #[[ATTR0:[0-9]+]] = { nounwind readnone speculatable willreturn }
; ATTRIBUTOR_HSA: attributes #[[ATTR1]] = { nounwind "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR2]] = { nounwind "amdgpu-work-group-id-y" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR3]] = { nounwind "amdgpu-work-group-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR4]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR5]] = { nounwind "amdgpu-work-item-id-y" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR6]] = { nounwind "amdgpu-work-item-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR7]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-item-id-y" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR8]] = { nounwind "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR9]] = { nounwind "amdgpu-work-group-id-y" "amdgpu-work-group-id-z" "amdgpu-work-item-id-y" "amdgpu-work-item-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR10]] = { nounwind "amdgpu-dispatch-ptr" "uniform-work-group-size"="false" }
; ATTRIBUTOR_HSA: attributes #[[ATTR11]] = { nounwind "amdgpu-queue-ptr" "uniform-work-group-size"="false" }
;.
