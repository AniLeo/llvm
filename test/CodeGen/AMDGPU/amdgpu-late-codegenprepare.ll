; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -amdgpu-late-codegenprepare %s | FileCheck %s

; Make sure we don't crash when trying to create a bitcast between
; address spaces
define amdgpu_kernel void @constant_from_offset_cast_generic_null() {
; CHECK-LABEL: @constant_from_offset_cast_generic_null(
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32 addrspace(4)* bitcast (i8 addrspace(4)* getelementptr (i8, i8 addrspace(4)* addrspacecast (i8* null to i8 addrspace(4)*), i64 4) to i32 addrspace(4)*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; CHECK-NEXT:    store i8 [[TMP3]], i8 addrspace(1)* undef, align 1
; CHECK-NEXT:    ret void
;
  %load = load i8, i8 addrspace(4)* getelementptr inbounds (i8, i8 addrspace(4)* addrspacecast (i8* null to i8 addrspace(4)*), i64 6), align 1
  store i8 %load, i8 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @constant_from_offset_cast_global_null() {
; CHECK-LABEL: @constant_from_offset_cast_global_null(
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32 addrspace(4)* bitcast (i8 addrspace(4)* getelementptr (i8, i8 addrspace(4)* addrspacecast (i8 addrspace(1)* null to i8 addrspace(4)*), i64 4) to i32 addrspace(4)*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; CHECK-NEXT:    store i8 [[TMP3]], i8 addrspace(1)* undef, align 1
; CHECK-NEXT:    ret void
;
  %load = load i8, i8 addrspace(4)* getelementptr inbounds (i8, i8 addrspace(4)* addrspacecast (i8 addrspace(1)* null to i8 addrspace(4)*), i64 6), align 1
  store i8 %load, i8 addrspace(1)* undef
  ret void
}

@gv = unnamed_addr addrspace(1) global [64 x i8] undef, align 4

define amdgpu_kernel void @constant_from_offset_cast_global_gv() {
; CHECK-LABEL: @constant_from_offset_cast_global_gv(
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32 addrspace(4)* bitcast (i8 addrspace(4)* getelementptr (i8, i8 addrspace(4)* addrspacecast (i8 addrspace(1)* getelementptr inbounds ([64 x i8], [64 x i8] addrspace(1)* @gv, i32 0, i32 0) to i8 addrspace(4)*), i64 4) to i32 addrspace(4)*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; CHECK-NEXT:    store i8 [[TMP3]], i8 addrspace(1)* undef, align 1
; CHECK-NEXT:    ret void
;
  %load = load i8, i8 addrspace(4)* getelementptr inbounds (i8, i8 addrspace(4)* addrspacecast ([64 x i8] addrspace(1)* @gv to i8 addrspace(4)*), i64 6), align 1
  store i8 %load, i8 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @constant_from_offset_cast_generic_inttoptr() {
; CHECK-LABEL: @constant_from_offset_cast_generic_inttoptr(
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32 addrspace(4)* bitcast (i8 addrspace(4)* getelementptr (i8, i8 addrspace(4)* addrspacecast (i8* inttoptr (i64 128 to i8*) to i8 addrspace(4)*), i64 4) to i32 addrspace(4)*), align 4
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP1]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP2]] to i8
; CHECK-NEXT:    store i8 [[TMP3]], i8 addrspace(1)* undef, align 1
; CHECK-NEXT:    ret void
;
  %load = load i8, i8 addrspace(4)* getelementptr inbounds (i8, i8 addrspace(4)* addrspacecast (i8* inttoptr (i64 128 to i8*) to i8 addrspace(4)*), i64 6), align 1
  store i8 %load, i8 addrspace(1)* undef
  ret void
}

define amdgpu_kernel void @constant_from_inttoptr() {
; CHECK-LABEL: @constant_from_inttoptr(
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, i8 addrspace(4)* inttoptr (i64 128 to i8 addrspace(4)*), align 4
; CHECK-NEXT:    store i8 [[LOAD]], i8 addrspace(1)* undef, align 1
; CHECK-NEXT:    ret void
;
  %load = load i8, i8 addrspace(4)* inttoptr (i64 128 to i8 addrspace(4)*), align 1
  store i8 %load, i8 addrspace(1)* undef
  ret void
}
