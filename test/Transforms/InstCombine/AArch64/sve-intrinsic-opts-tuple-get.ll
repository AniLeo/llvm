; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; This stores %a using st4 after reversing the 4 tuples. Check that the
; redundant sequences of get/set are eliminated.
define void @redundant_tuple_get_set(<vscale x 64 x i8> %a, i8* %ptr) #0 {
; CHECK-LABEL: @redundant_tuple_get_set(
; CHECK-NEXT:    [[TMP1:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> [[A:%.*]], i32 3)
; CHECK-NEXT:    [[TMP2:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> [[A]], i32 0)
; CHECK-NEXT:    [[TMP3:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> [[A]], i32 2)
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> [[A]], i32 1)
; CHECK-NEXT:    call void @llvm.aarch64.sve.st4.nxv16i8(<vscale x 16 x i8> [[TMP1]], <vscale x 16 x i8> [[TMP3]], <vscale x 16 x i8> [[TMP4]], <vscale x 16 x i8> [[TMP2]], <vscale x 16 x i1> shufflevector (<vscale x 16 x i1> insertelement (<vscale x 16 x i1> poison, i1 true, i32 0), <vscale x 16 x i1> poison, <vscale x 16 x i32> zeroinitializer), i8* [[PTR:%.*]])
; CHECK-NEXT:    ret void
;
  %1 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %a, i32 3)
  %2 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %a, i32 0)
  %3 = call <vscale x 64 x i8> @llvm.aarch64.sve.tuple.set.nxv64i8.nxv16i8(<vscale x 64 x i8> %a, i32 3, <vscale x 16 x i8> %2)
  %4 = call <vscale x 64 x i8> @llvm.aarch64.sve.tuple.set.nxv64i8.nxv16i8(<vscale x 64 x i8> %3, i32 0, <vscale x 16 x i8> %1)
  %5 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %4, i32 2)
  %6 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %4, i32 1)
  %7 = call <vscale x 64 x i8> @llvm.aarch64.sve.tuple.set.nxv64i8.nxv16i8(<vscale x 64 x i8> %4, i32 2, <vscale x 16 x i8> %6)
  %8 = call <vscale x 64 x i8> @llvm.aarch64.sve.tuple.set.nxv64i8.nxv16i8(<vscale x 64 x i8> %7, i32 1, <vscale x 16 x i8> %5)
  %9 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %8, i32 0)
  %10 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %8, i32 1)
  %11 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %8, i32 2)
  %12 = call <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8> %8, i32 3)
  call void @llvm.aarch64.sve.st4.nxv16i8(<vscale x 16 x i8> %9, <vscale x 16 x i8> %10, <vscale x 16 x i8> %11, <vscale x 16 x i8> %12, <vscale x 16 x i1> shufflevector (<vscale x 16 x i1> insertelement (<vscale x 16 x i1> poison, i1 true, i32 0), <vscale x 16 x i1> poison, <vscale x 16 x i32> zeroinitializer), i8* %ptr)
  ret void
}

declare <vscale x 64 x i8> @llvm.aarch64.sve.tuple.set.nxv64i8.nxv16i8(<vscale x 64 x i8>, i32, <vscale x 16 x i8>)
declare <vscale x 16 x i8> @llvm.aarch64.sve.tuple.get.nxv16i8.nxv64i8(<vscale x 64 x i8>, i32)
declare void @llvm.aarch64.sve.st4.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i1>, i8*)

attributes #0 = { "target-features"="+sve" }
