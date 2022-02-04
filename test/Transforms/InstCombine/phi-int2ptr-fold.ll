; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S -disable-i2p-p2i-opt < %s | FileCheck %s

target datalayout = "e-p:64:64-p1:16:16-p2:32:32:32-p3:64:64:64"
target triple = "x86_64-unknown-linux-gnu"

; convert ptrtoint [ phi[ inttoptr (ptrtoint (x) ) ] ---> ptrtoint (phi[x])

define i64 @func(i32** %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_IN_IN:%.*]] = phi i32** [ [[X:%.*]], [[BB1]] ], [ [[Y:%.*]], [[BB2]] ]
; CHECK-NEXT:    [[PHI_IN:%.*]] = ptrtoint i32** [[PHI_IN_IN]] to i64
; CHECK-NEXT:    ret i64 [[PHI_IN]]
;
  br i1 %cond, label %bb1, label %bb2

bb1:
  %X.i = ptrtoint i32** %X to i64
  %X.p = inttoptr i64 %X.i to i32*
  br label %exit

bb2:
  %Y.i = ptrtoint i32** %Y to i64
  %Y.p = inttoptr i64 %Y.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %bb2]
  %X.p.i = ptrtoint i32* %phi to i64
  ret i64 %X.p.i
}

define i64 @func_single_operand(i32** %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func_single_operand(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_IN:%.*]] = phi i32** [ [[X:%.*]], [[BB1]] ], [ [[Y:%.*]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[X_P_I:%.*]] = ptrtoint i32** [[PHI_IN]] to i64
; CHECK-NEXT:    ret i64 [[X_P_I]]
;
  %Y.p = bitcast i32** %Y to i32*
  br i1 %cond, label %bb1, label %exit

bb1:
  %X.i = ptrtoint i32** %X to i64
  %X.p = inttoptr i64 %X.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %0]
  %X.p.i = ptrtoint i32* %phi to i64
  ret i64 %X.p.i
}

define i64 @func_pointer_different_types(i16** %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func_pointer_different_types(
; CHECK-NEXT:    [[Y_P:%.*]] = bitcast i32** [[Y:%.*]] to i32*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16** [[X:%.*]] to i32*
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[TMP1]], [[BB1]] ], [ [[Y_P]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[X_P_I:%.*]] = ptrtoint i32* [[PHI]] to i64
; CHECK-NEXT:    ret i64 [[X_P_I]]
;
  %Y.p = bitcast i32** %Y to i32*
  br i1 %cond, label %bb1, label %exit

bb1:
  %X.i = ptrtoint i16** %X to i64
  %X.p = inttoptr i64 %X.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %0]
  %X.p.i = ptrtoint i32* %phi to i64
  ret i64 %X.p.i
}

; Negative test - Wrong Integer type

define i64 @func_integer_type_too_small(i32** %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func_integer_type_too_small(
; CHECK-NEXT:    [[Y_P:%.*]] = bitcast i32** [[Y:%.*]] to i32*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i32** [[X:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], 4294967295
; CHECK-NEXT:    [[X_P:%.*]] = inttoptr i64 [[TMP2]] to i32*
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[X_P]], [[BB1]] ], [ [[Y_P]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[X_P_I:%.*]] = ptrtoint i32* [[PHI]] to i64
; CHECK-NEXT:    ret i64 [[X_P_I]]
;
  %Y.p = bitcast i32** %Y to i32*
  br i1 %cond, label %bb1, label %exit

bb1:
  %X.i = ptrtoint i32** %X to i32
  %X.p = inttoptr i32 %X.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %0]
  %X.p.i = ptrtoint i32* %phi to i64
  ret i64 %X.p.i
}

; Negative test - phi not used in ptrtoint

define i32* @func_phi_not_use_in_ptr2int(i32** %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func_phi_not_use_in_ptr2int(
; CHECK-NEXT:    [[Y_P:%.*]] = bitcast i32** [[Y:%.*]] to i32*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i32** [[X:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], 4294967295
; CHECK-NEXT:    [[X_P:%.*]] = inttoptr i64 [[TMP2]] to i32*
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[X_P]], [[BB1]] ], [ [[Y_P]], [[TMP0:%.*]] ]
; CHECK-NEXT:    ret i32* [[PHI]]
;
  %Y.p = bitcast i32** %Y to i32*
  br i1 %cond, label %bb1, label %exit

bb1:
  %X.i = ptrtoint i32** %X to i32
  %X.p = inttoptr i32 %X.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %0]
  ret i32* %phi
}

; Negative test - Pointers in different address spaces

define i64 @func_ptr_different_addrspace(i16 addrspace(2)* %X, i32** %Y, i1 %cond) {
; CHECK-LABEL: @func_ptr_different_addrspace(
; CHECK-NEXT:    [[Y_P:%.*]] = bitcast i32** [[Y:%.*]] to i32*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i16 addrspace(2)* [[X:%.*]] to i32
; CHECK-NEXT:    [[X_I:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[X_P:%.*]] = inttoptr i64 [[X_I]] to i32*
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[X_P]], [[BB1]] ], [ [[Y_P]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[X_P_I:%.*]] = ptrtoint i32* [[PHI]] to i64
; CHECK-NEXT:    ret i64 [[X_P_I]]
;
  %Y.p = bitcast i32** %Y to i32*
  br i1 %cond, label %bb1, label %exit

bb1:
  %X.i = ptrtoint i16 addrspace(2)* %X to i64
  %X.p = inttoptr i64 %X.i to i32*
  br label %exit

exit:
  %phi = phi i32* [%X.p, %bb1], [%Y.p, %0]
  %X.p.i = ptrtoint i32* %phi to i64
  ret i64 %X.p.i
}
