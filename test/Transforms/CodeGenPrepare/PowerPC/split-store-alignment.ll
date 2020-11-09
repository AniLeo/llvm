; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -codegenprepare -mtriple=powerpc64-unknown-linux-gnu -data-layout="E-m:e-i64:64-n32:64" -force-split-store < %s  | FileCheck --check-prefix=BE %s
; RUN: opt -S -codegenprepare -mtriple=powerpc64le-unknown-linux-gnu -data-layout="e-m:e-i64:64-n32:64" -force-split-store < %s  | FileCheck --check-prefix=LE %s

define void @split_store_align1(float %x, i64* %p) {
; BE-LABEL: @split_store_align1(
; BE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; BE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; BE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; BE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; BE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; BE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; BE-NEXT:    [[TMP2:%.*]] = getelementptr i32, i32* [[TMP1]], i32 1
; BE-NEXT:    store i32 [[B]], i32* [[TMP2]], align 1
; BE-NEXT:    [[TMP3:%.*]] = bitcast i64* [[P]] to i32*
; BE-NEXT:    store i32 0, i32* [[TMP3]], align 1
; BE-NEXT:    ret void
;
; LE-LABEL: @split_store_align1(
; LE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; LE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; LE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; LE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; LE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; LE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; LE-NEXT:    store i32 [[B]], i32* [[TMP1]], align 1
; LE-NEXT:    [[TMP2:%.*]] = bitcast i64* [[P]] to i32*
; LE-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[TMP2]], i32 1
; LE-NEXT:    store i32 0, i32* [[TMP3]], align 1
; LE-NEXT:    ret void
;
  %b = bitcast float %x to i32
  %z = zext i32 0 to i64
  %s = shl nuw nsw i64 %z, 32
  %z2 = zext i32 %b to i64
  %o = or i64 %s, %z2
  store i64 %o, i64* %p, align 1
  ret void
}

define void @split_store_align2(float %x, i64* %p) {
; BE-LABEL: @split_store_align2(
; BE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; BE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; BE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; BE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; BE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; BE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; BE-NEXT:    [[TMP2:%.*]] = getelementptr i32, i32* [[TMP1]], i32 1
; BE-NEXT:    store i32 [[B]], i32* [[TMP2]], align 2
; BE-NEXT:    [[TMP3:%.*]] = bitcast i64* [[P]] to i32*
; BE-NEXT:    store i32 0, i32* [[TMP3]], align 2
; BE-NEXT:    ret void
;
; LE-LABEL: @split_store_align2(
; LE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; LE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; LE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; LE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; LE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; LE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; LE-NEXT:    store i32 [[B]], i32* [[TMP1]], align 2
; LE-NEXT:    [[TMP2:%.*]] = bitcast i64* [[P]] to i32*
; LE-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[TMP2]], i32 1
; LE-NEXT:    store i32 0, i32* [[TMP3]], align 2
; LE-NEXT:    ret void
;
  %b = bitcast float %x to i32
  %z = zext i32 0 to i64
  %s = shl nuw nsw i64 %z, 32
  %z2 = zext i32 %b to i64
  %o = or i64 %s, %z2
  store i64 %o, i64* %p, align 2
  ret void
}

define void @split_store_align8(float %x, i64* %p) {
; BE-LABEL: @split_store_align8(
; BE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; BE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; BE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; BE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; BE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; BE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; BE-NEXT:    [[TMP2:%.*]] = getelementptr i32, i32* [[TMP1]], i32 1
; BE-NEXT:    store i32 [[B]], i32* [[TMP2]], align 4
; BE-NEXT:    [[TMP3:%.*]] = bitcast i64* [[P]] to i32*
; BE-NEXT:    store i32 0, i32* [[TMP3]], align 8
; BE-NEXT:    ret void
;
; LE-LABEL: @split_store_align8(
; LE-NEXT:    [[B:%.*]] = bitcast float [[X:%.*]] to i32
; LE-NEXT:    [[Z:%.*]] = zext i32 0 to i64
; LE-NEXT:    [[S:%.*]] = shl nuw nsw i64 [[Z]], 32
; LE-NEXT:    [[Z2:%.*]] = zext i32 [[B]] to i64
; LE-NEXT:    [[O:%.*]] = or i64 [[S]], [[Z2]]
; LE-NEXT:    [[TMP1:%.*]] = bitcast i64* [[P:%.*]] to i32*
; LE-NEXT:    store i32 [[B]], i32* [[TMP1]], align 8
; LE-NEXT:    [[TMP2:%.*]] = bitcast i64* [[P]] to i32*
; LE-NEXT:    [[TMP3:%.*]] = getelementptr i32, i32* [[TMP2]], i32 1
; LE-NEXT:    store i32 0, i32* [[TMP3]], align 4
; LE-NEXT:    ret void
;
  %b = bitcast float %x to i32
  %z = zext i32 0 to i64
  %s = shl nuw nsw i64 %z, 32
  %z2 = zext i32 %b to i64
  %o = or i64 %s, %z2
  store i64 %o, i64* %p, align 8
  ret void
}
