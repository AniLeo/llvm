; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S 2>&1 | FileCheck %s


declare void @site_for_call_safpeoint()

; derived %merged_value base %merged_value.base
define i64 addrspace(1)* @test(i64 addrspace(1)* %base_obj_x, i64 addrspace(1)* %base_obj_y, i1 %runtime_condition_x, i1 %runtime_condition_y) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[RUNTIME_CONDITION_X:%.*]], label [[HERE:%.*]], label [[THERE:%.*]]
; CHECK:       here:
; CHECK-NEXT:    br i1 [[RUNTIME_CONDITION_Y:%.*]], label [[BUMP_HERE_A:%.*]], label [[BUMP_HERE_B:%.*]]
; CHECK:       bump_here_a:
; CHECK-NEXT:    [[X_A:%.*]] = getelementptr i64, i64 addrspace(1)* [[BASE_OBJ_X:%.*]], i32 1
; CHECK-NEXT:    br label [[MERGE_HERE:%.*]]
; CHECK:       bump_here_b:
; CHECK-NEXT:    [[X_B:%.*]] = getelementptr i64, i64 addrspace(1)* [[BASE_OBJ_X]], i32 2
; CHECK-NEXT:    br label [[MERGE_HERE]]
; CHECK:       merge_here:
; CHECK-NEXT:    [[X:%.*]] = phi i64 addrspace(1)* [ [[X_A]], [[BUMP_HERE_A]] ], [ [[X_B]], [[BUMP_HERE_B]] ]
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       there:
; CHECK-NEXT:    [[Y:%.*]] = getelementptr i64, i64 addrspace(1)* [[BASE_OBJ_Y:%.*]], i32 1
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[MERGED_VALUE_BASE:%.*]] = phi i64 addrspace(1)* [ [[BASE_OBJ_X]], [[MERGE_HERE]] ], [ [[BASE_OBJ_Y]], [[THERE]] ], !is_base_value !0
; CHECK-NEXT:    [[MERGED_VALUE:%.*]] = phi i64 addrspace(1)* [ [[X]], [[MERGE_HERE]] ], [ [[Y]], [[THERE]] ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @site_for_call_safpeoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0), "gc-live"(i64 addrspace(1)* [[MERGED_VALUE]], i64 addrspace(1)* [[MERGED_VALUE_BASE]]) ]
; CHECK-NEXT:    [[MERGED_VALUE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[MERGED_VALUE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[MERGED_VALUE_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    [[MERGED_VALUE_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[MERGED_VALUE_BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[MERGED_VALUE_BASE_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    ret i64 addrspace(1)* [[MERGED_VALUE_RELOCATED_CASTED]]
;
entry:
  br i1 %runtime_condition_x, label %here, label %there

here:                                             ; preds = %entry
  br i1 %runtime_condition_y, label %bump_here_a, label %bump_here_b

bump_here_a:                                      ; preds = %here
  %x_a = getelementptr i64, i64 addrspace(1)* %base_obj_x, i32 1
  br label %merge_here

bump_here_b:                                      ; preds = %here
  %x_b = getelementptr i64, i64 addrspace(1)* %base_obj_x, i32 2
  br label %merge_here

merge_here:                                       ; preds = %bump_here_b, %bump_here_a
  %x = phi i64 addrspace(1)* [ %x_a, %bump_here_a ], [ %x_b, %bump_here_b ]
  br label %merge

there:                                            ; preds = %entry
  %y = getelementptr i64, i64 addrspace(1)* %base_obj_y, i32 1
  br label %merge

merge:                                            ; preds = %there, %merge_here
  %merged_value = phi i64 addrspace(1)* [ %x, %merge_here ], [ %y, %there ]
  call void @site_for_call_safpeoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  ret i64 addrspace(1)* %merged_value
}
