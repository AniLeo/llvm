; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=newgvn -S | FileCheck %s

;; Most of these are borrowed from transforms/DSE/simple.ll
;; NewGVN should be able to eliminate any stores of the same value that are actually redundnat.

;; tmp5 is store of the same value to the same location as the load.
define void @test12({ i32, i32 }* %x) nounwind  {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[X:%.*]], i32 0, i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load i32, i32* [[TMP4]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[X]], i32 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP17:%.*]] = sub i32 0, [[TMP8]]
; CHECK-NEXT:    store i32 [[TMP17]], i32* [[TMP7]], align 4
; CHECK-NEXT:    ret void
;
  %tmp4 = getelementptr { i32, i32 }, { i32, i32 }* %x, i32 0, i32 0
  %tmp5 = load i32, i32* %tmp4, align 4
  %tmp7 = getelementptr { i32, i32 }, { i32, i32 }* %x, i32 0, i32 1
  %tmp8 = load i32, i32* %tmp7, align 4
  %tmp17 = sub i32 0, %tmp8
  store i32 %tmp5, i32* %tmp4, align 4
  store i32 %tmp17, i32* %tmp7, align 4
  ret void
}
; Remove redundant store if loaded value is in another block.
define i32 @test26(i1 %c, i32* %p) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
entry:
  %v = load i32, i32* %p, align 4
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  store i32 %v, i32* %p, align 4
  br label %bb3
bb3:
  ret i32 0
}

declare void @unknown_func()
; Remove redundant store, which is in the same loop as the load.
define i32 @test33(i1 %c, i32* %p, i32 %i) {
; CHECK-LABEL: @test33(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %bb1
bb1:
  %v = load i32, i32* %p, align 4
  br label %bb2
bb2:
  store i32 %v, i32* %p, align 4
  ; Might read and overwrite value at %p, but doesn't matter.
  call void @unknown_func()
  br i1 undef, label %bb1, label %bb3
bb3:
  ret i32 0
}
