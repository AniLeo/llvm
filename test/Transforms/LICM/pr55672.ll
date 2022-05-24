; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='licm' < %s | FileCheck %s

define void @test_01(i8 addrspace(1)* addrspace(1)* %arg, i32 %arg2) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP103:%.*]] = load atomic i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[ARG:%.*]] unordered, align 8, !dereferenceable_or_null !0, !align !1
; CHECK-NEXT:    [[TMP117:%.*]] = icmp eq i8 addrspace(1)* [[TMP103]], null
; CHECK-NEXT:    [[TMP118:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[TMP103]], i64 8
; CHECK-NEXT:    [[TMP119:%.*]] = bitcast i8 addrspace(1)* [[TMP118]] to i32 addrspace(1)*
; CHECK-NEXT:    br i1 [[TMP117]], label [[FAIL:%.*]], label [[PREHEADER:%.*]]
; CHECK:       fail:
; CHECK-NEXT:    ret void
; CHECK:       preheader:
; CHECK-NEXT:    [[TMP157:%.*]] = load atomic i32, i32 addrspace(1)* [[TMP119]] unordered, align 8
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP151:%.*]] = phi i32 [ 0, [[PREHEADER]] ], [ [[TMP163:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP152:%.*]] = icmp ult i32 [[TMP151]], [[ARG2:%.*]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP152]]) [ "deopt"() ]
; CHECK-NEXT:    [[TMP158:%.*]] = icmp ult i32 [[TMP151]], [[TMP157]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP158]]) [ "deopt"() ]
; CHECK-NEXT:    [[TMP163]] = add i32 [[TMP151]], 1
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  %tmp103 = load atomic i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arg unordered, align 8, !dereferenceable_or_null !0, !align !1
  %tmp117 = icmp eq i8 addrspace(1)* %tmp103, null
  %tmp118 = getelementptr inbounds i8, i8 addrspace(1)* %tmp103, i64 8
  %tmp119 = bitcast i8 addrspace(1)* %tmp118 to i32 addrspace(1)*
  br i1 %tmp117, label %fail, label %preheader

fail:                                             ; preds = %entry
  ret void

preheader:                                        ; preds = %entry
  br label %loop

loop:                                             ; preds = %loop, %preheader
  %tmp151 = phi i32 [ 0, %preheader ], [ %tmp163, %loop ]
  %tmp152 = icmp ult i32 %tmp151, %arg2
  call void (i1, ...) @llvm.experimental.guard(i1 %tmp152) [ "deopt"() ]
  %tmp157 = load atomic i32, i32 addrspace(1)* %tmp119 unordered, align 8
  %tmp158 = icmp ult i32 %tmp151, %tmp157
  call void (i1, ...) @llvm.experimental.guard(i1 %tmp158) [ "deopt"() ]
  %tmp163 = add i32 %tmp151, 1
  br label %loop
}

; FIXME: should be able to hoist load just as test_01
define void @test_02(i8 addrspace(1)* addrspace(1)* %arg, i32 %arg2) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP103:%.*]] = load atomic i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* [[ARG:%.*]] unordered, align 8, !dereferenceable_or_null !0, !align !1
; CHECK-NEXT:    [[TMP117:%.*]] = icmp eq i8 addrspace(1)* [[TMP103]], null
; CHECK-NEXT:    [[TMP118:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[TMP103]], i64 8
; CHECK-NEXT:    [[TMP119:%.*]] = bitcast i8 addrspace(1)* [[TMP118]] to i32 addrspace(1)*
; CHECK-NEXT:    [[FREEZE:%.*]] = freeze i1 [[TMP117]]
; CHECK-NEXT:    br i1 [[FREEZE]], label [[FAIL:%.*]], label [[PREHEADER:%.*]]
; CHECK:       fail:
; CHECK-NEXT:    ret void
; CHECK:       preheader:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[TMP151:%.*]] = phi i32 [ 0, [[PREHEADER]] ], [ [[TMP163:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[TMP152:%.*]] = icmp ult i32 [[TMP151]], [[ARG2:%.*]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP152]]) [ "deopt"() ]
; CHECK-NEXT:    [[TMP157:%.*]] = load atomic i32, i32 addrspace(1)* [[TMP119]] unordered, align 8
; CHECK-NEXT:    [[TMP158:%.*]] = icmp ult i32 [[TMP151]], [[TMP157]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP158]]) [ "deopt"() ]
; CHECK-NEXT:    [[TMP163]] = add i32 [[TMP151]], 1
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  %tmp103 = load atomic i8 addrspace(1)*, i8 addrspace(1)* addrspace(1)* %arg unordered, align 8, !dereferenceable_or_null !0, !align !1
  %tmp117 = icmp eq i8 addrspace(1)* %tmp103, null
  %tmp118 = getelementptr inbounds i8, i8 addrspace(1)* %tmp103, i64 8
  %tmp119 = bitcast i8 addrspace(1)* %tmp118 to i32 addrspace(1)*
  %freeze = freeze i1 %tmp117
  br i1 %freeze, label %fail, label %preheader

fail:                                             ; preds = %entry
  ret void

preheader:                                        ; preds = %entry
  br label %loop

loop:                                             ; preds = %loop, %preheader
  %tmp151 = phi i32 [ 0, %preheader ], [ %tmp163, %loop ]
  %tmp152 = icmp ult i32 %tmp151, %arg2
  call void (i1, ...) @llvm.experimental.guard(i1 %tmp152) [ "deopt"() ]
  %tmp157 = load atomic i32, i32 addrspace(1)* %tmp119 unordered, align 8
  %tmp158 = icmp ult i32 %tmp151, %tmp157
  call void (i1, ...) @llvm.experimental.guard(i1 %tmp158) [ "deopt"() ]
  %tmp163 = add i32 %tmp151, 1
  br label %loop
}

; Function Attrs: nocallback nofree nosync willreturn
declare void @llvm.experimental.guard(i1, ...) #0

attributes #0 = { nocallback nofree nosync willreturn }

!0 = !{i64 16}
!1 = !{i64 8}
