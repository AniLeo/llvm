; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -memcpyopt -S < %s | FileCheck %s
; RUN: opt -passes=memcpyopt -S < %s | FileCheck %s
; rdar://8875553

; Memcpyopt shouldn't optimize the second memcpy using the first
; because the first has a smaller size.

target datalayout = "e-p:32:32:32"

%struct.s = type { [11 x i8], i32 }

@.str = private constant [11 x i8] c"0123456789\00"
@cell = external global %struct.s

declare void @check(%struct.s* byval %p) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind

define void @foo() nounwind {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AGG_TMP:%.*]] = alloca [[STRUCT_S:%.*]], align 4
; CHECK-NEXT:    store i32 99, i32* getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 1), align 4
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 0, i32 0), i8* align 1 getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i32 0, i32 0), i32 11, i1 false)
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr inbounds [[STRUCT_S]], %struct.s* [[AGG_TMP]], i32 0, i32 0, i32 0
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 [[TMP]], i8* align 4 getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 0, i32 0), i32 16, i1 false)
; CHECK-NEXT:    call void @check(%struct.s* byval [[AGG_TMP]])
; CHECK-NEXT:    ret void
;
entry:
  %agg.tmp = alloca %struct.s, align 4
  store i32 99, i32* getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 1), align 4
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 0, i32 0), i8* align 1 getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i32 0, i32 0), i32 11, i1 false)
  %tmp = getelementptr inbounds %struct.s, %struct.s* %agg.tmp, i32 0, i32 0, i32 0
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %tmp, i8* align 4 getelementptr inbounds (%struct.s, %struct.s* @cell, i32 0, i32 0, i32 0), i32 16, i1 false)
  call void @check(%struct.s* byval %agg.tmp)
  ret void
}
