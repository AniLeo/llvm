; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; llvm.vector.insert canonicalizes to shufflevector in the fixed case. In the
; scalable case, we lower to the INSERT_SUBVECTOR ISD node.

declare <8 x i32> @llvm.vector.insert.v8i32.v2i32(<8 x i32> %vec, <2 x i32> %subvec, i64 %idx)
declare <8 x i32> @llvm.vector.insert.v8i32.v3i32(<8 x i32> %vec, <3 x i32> %subvec, i64 %idx)
declare <8 x i32> @llvm.vector.insert.v8i32.v4i32(<8 x i32> %vec, <4 x i32> %subvec, i64 %idx)
declare <8 x i32> @llvm.vector.insert.v8i32.v8i32(<8 x i32> %vec, <8 x i32> %subvec, i64 %idx)
declare <vscale x 4 x i32> @llvm.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32> %vec, <4 x i32> %subvec, i64 %idx)

; ============================================================================ ;
; Trivial cases
; ============================================================================ ;

; An insert that entirely overwrites an <n x ty> with another <n x ty> is a
; nop.
define <8 x i32> @trivial_nop(<8 x i32> %vec, <8 x i32> %subvec) {
; CHECK-LABEL: @trivial_nop(
; CHECK-NEXT:    ret <8 x i32> [[SUBVEC:%.*]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v8i32(<8 x i32> %vec, <8 x i32> %subvec, i64 0)
  ret <8 x i32> %1
}

; ============================================================================ ;
; Valid canonicalizations
; ============================================================================ ;

define <8 x i32> @valid_insertion_a(<8 x i32> %vec, <2 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_a(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i32> [[SUBVEC:%.*]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[VEC:%.*]], <8 x i32> <i32 0, i32 1, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v2i32(<8 x i32> %vec, <2 x i32> %subvec, i64 0)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_b(<8 x i32> %vec, <2 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_b(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i32> [[SUBVEC:%.*]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 8, i32 9, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v2i32(<8 x i32> %vec, <2 x i32> %subvec, i64 2)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_c(<8 x i32> %vec, <2 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_c(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i32> [[SUBVEC:%.*]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v2i32(<8 x i32> %vec, <2 x i32> %subvec, i64 4)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_d(<8 x i32> %vec, <2 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_d(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x i32> [[SUBVEC:%.*]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 9>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v2i32(<8 x i32> %vec, <2 x i32> %subvec, i64 6)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_e(<8 x i32> %vec, <4 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_e(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[SUBVEC:%.*]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[VEC:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v4i32(<8 x i32> %vec, <4 x i32> %subvec, i64 0)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_f(<8 x i32> %vec, <4 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_f(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[SUBVEC:%.*]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v4i32(<8 x i32> %vec, <4 x i32> %subvec, i64 4)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_g(<8 x i32> %vec, <3 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_g(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x i32> [[SUBVEC:%.*]], <3 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[TMP1]], <8 x i32> [[VEC:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v3i32(<8 x i32> %vec, <3 x i32> %subvec, i64 0)
  ret <8 x i32> %1
}

define <8 x i32> @valid_insertion_h(<8 x i32> %vec, <3 x i32> %subvec) {
; CHECK-LABEL: @valid_insertion_h(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <3 x i32> [[SUBVEC:%.*]], <3 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[VEC:%.*]], <8 x i32> [[TMP1]], <8 x i32> <i32 0, i32 1, i32 2, i32 8, i32 9, i32 10, i32 6, i32 7>
; CHECK-NEXT:    ret <8 x i32> [[TMP2]]
;
  %1 = call <8 x i32> @llvm.vector.insert.v8i32.v3i32(<8 x i32> %vec, <3 x i32> %subvec, i64 3)
  ret <8 x i32> %1
}

; ============================================================================ ;
; Scalable cases
; ============================================================================ ;

; Scalable insertions should not be canonicalized. This will be lowered to the
; INSERT_SUBVECTOR ISD node later.
define <vscale x 4 x i32> @scalable_insert(<vscale x 4 x i32> %vec, <4 x i32> %subvec) {
; CHECK-LABEL: @scalable_insert(
; CHECK-NEXT:    [[TMP1:%.*]] = call <vscale x 4 x i32> @llvm.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32> [[VEC:%.*]], <4 x i32> [[SUBVEC:%.*]], i64 0)
; CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP1]]
;
  %1 = call <vscale x 4 x i32> @llvm.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32> %vec, <4 x i32> %subvec, i64 0)
  ret <vscale x 4 x i32> %1
}
