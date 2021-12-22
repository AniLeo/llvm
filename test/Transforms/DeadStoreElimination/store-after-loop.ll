; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=dse -S | FileCheck %s

target datalayout = "E-m:e-p:32:32-i64:32-f64:32:64-a:0:32-n32-S32"

%struct.ilist = type { i32, %struct.ilist* }

; There is no dead store in this test. Make sure no store is deleted by DSE.
; Test case related to bug report PR52774.

define %struct.ilist* @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[TMP0:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[LIST_NEXT:%.*]] = phi %struct.ilist* [ null, [[TMP0]] ], [ [[LIST_NEW_ILIST_PTR:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[LIST_NEW_I8_PTR:%.*]] = tail call align 8 dereferenceable_or_null(8) i8* @malloc(i32 8)
; CHECK-NEXT:    [[LIST_NEW_ILIST_PTR]] = bitcast i8* [[LIST_NEW_I8_PTR]] to %struct.ilist*
; CHECK-NEXT:    [[GEP_NEW_VALUE:%.*]] = getelementptr inbounds [[STRUCT_ILIST:%.*]], %struct.ilist* [[LIST_NEW_ILIST_PTR]], i32 0, i32 0
; CHECK-NEXT:    store i32 42, i32* [[GEP_NEW_VALUE]], align 8
; CHECK-NEXT:    [[GEP_NEW_NEXT:%.*]] = getelementptr inbounds [[STRUCT_ILIST]], %struct.ilist* [[LIST_NEW_ILIST_PTR]], i32 0, i32 1
; CHECK-NEXT:    store %struct.ilist* [[LIST_NEXT]], %struct.ilist** [[GEP_NEW_NEXT]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[IV_NEXT]], 10
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[LIST_LAST_ILIST_PTR:%.*]] = bitcast i8* [[LIST_NEW_I8_PTR]] to %struct.ilist*
; CHECK-NEXT:    [[GEP_LIST_LAST_NEXT:%.*]] = getelementptr inbounds [[STRUCT_ILIST]], %struct.ilist* [[LIST_LAST_ILIST_PTR]], i32 0, i32 1
; CHECK-NEXT:    store %struct.ilist* null, %struct.ilist** [[GEP_LIST_LAST_NEXT]], align 4
; CHECK-NEXT:    [[GEP_LIST_NEXT_NEXT:%.*]] = getelementptr inbounds [[STRUCT_ILIST]], %struct.ilist* [[LIST_NEXT]], i32 0, i32 1
; CHECK-NEXT:    [[LOADED_PTR:%.*]] = load %struct.ilist*, %struct.ilist** [[GEP_LIST_NEXT_NEXT]], align 4
; CHECK-NEXT:    ret %struct.ilist* [[LOADED_PTR]]
;
  br label %loop

loop:
  %iv = phi i32 [ 0, %0 ], [ %iv.next, %loop ]
  %list.next = phi %struct.ilist* [ null, %0 ], [ %list.new.ilist.ptr, %loop ]
  %list.new.i8.ptr = tail call align 8 dereferenceable_or_null(8) i8* @malloc(i32 8)
  %list.new.ilist.ptr = bitcast i8* %list.new.i8.ptr to %struct.ilist*
  %gep.new.value = getelementptr inbounds %struct.ilist, %struct.ilist* %list.new.ilist.ptr, i32 0, i32 0
  store i32 42, i32* %gep.new.value, align 8
  %gep.new.next = getelementptr inbounds %struct.ilist, %struct.ilist* %list.new.ilist.ptr, i32 0, i32 1
  store %struct.ilist* %list.next, %struct.ilist** %gep.new.next, align 4
  %iv.next = add nuw nsw i32 %iv, 1
  %cond = icmp eq i32 %iv.next, 10
  br i1 %cond, label %exit, label %loop

exit:
  %list.last.ilist.ptr = bitcast i8* %list.new.i8.ptr to %struct.ilist*
  %gep.list.last.next = getelementptr inbounds %struct.ilist, %struct.ilist* %list.last.ilist.ptr, i32 0, i32 1
  store %struct.ilist* null, %struct.ilist** %gep.list.last.next, align 4
  %gep.list.next.next = getelementptr inbounds %struct.ilist, %struct.ilist* %list.next, i32 0, i32 1
  %loaded_ptr = load %struct.ilist*, %struct.ilist** %gep.list.next.next, align 4
  ret %struct.ilist* %loaded_ptr                                      ; use loaded pointer
}

; Function Attrs: inaccessiblememonly nounwind
declare noalias noundef align 8 i8* @malloc(i32 noundef) local_unnamed_addr #0

attributes #0 = { inaccessiblememonly nounwind}
