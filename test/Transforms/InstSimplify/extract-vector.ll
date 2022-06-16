; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define <16 x i8> @redundant_insert_extract_chain(<16 x i8> %x) {
; CHECK-LABEL: @redundant_insert_extract_chain(
; CHECK-NEXT:    ret <16 x i8> [[X:%.*]]
;
  %inserted = call <vscale x 32 x i8> @llvm.vector.insert.nxv32i8.v16i8(<vscale x 32 x i8> undef, <16 x i8> %x, i64 0)
  %extracted = call <16 x i8> @llvm.vector.extract.v16i8.nxv32i8(<vscale x 32 x i8> %inserted, i64 0)
  ret <16 x i8> %extracted
}

define <8 x i8> @non_redundant_insert_extract_chain(<16 x i8> %x) {
; CHECK-LABEL: @non_redundant_insert_extract_chain(
; CHECK-NEXT:    [[INSERTED:%.*]] = call <vscale x 32 x i8> @llvm.vector.insert.nxv32i8.v16i8(<vscale x 32 x i8> undef, <16 x i8> [[X:%.*]], i64 0)
; CHECK-NEXT:    [[EXTRACTED:%.*]] = call <8 x i8> @llvm.vector.extract.v8i8.nxv32i8(<vscale x 32 x i8> [[INSERTED]], i64 0)
; CHECK-NEXT:    ret <8 x i8> [[EXTRACTED]]
;
  %inserted = call <vscale x 32 x i8> @llvm.vector.insert.nxv32i8.v16i8(<vscale x 32 x i8> undef, <16 x i8> %x, i64 0)
  %extracted = call <8 x i8> @llvm.vector.extract.v8i8.nxv32i8(<vscale x 32 x i8> %inserted, i64 0)
  ret <8 x i8> %extracted
}

declare <16 x i8> @llvm.vector.extract.v16i8.nxv32i8(<vscale x 32 x i8>, i64)
declare <8 x i8> @llvm.vector.extract.v8i8.nxv32i8(<vscale x 32 x i8>, i64)
declare <vscale x 32 x i8> @llvm.vector.insert.nxv32i8.v16i8(<vscale x 32 x i8>, <16 x i8>, i64)
