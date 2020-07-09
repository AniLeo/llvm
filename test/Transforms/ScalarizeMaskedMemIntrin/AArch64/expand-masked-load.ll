; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=aarch64-linux-gnu | FileCheck %s
; RUN: opt -S %s -scalarize-masked-mem-intrin -mtriple=aarch64-linux-gnu -mattr=+sve | FileCheck %s

define <2 x i64> @scalarize_v2i64(<2 x i64>* %p, <2 x i1> %mask, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP2:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i2 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[COND_LOAD:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.load:
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load i64, i64* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i64> [[PASSTHRU:%.*]], i64 [[TMP5]], i64 0
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[RES_PHI_ELSE:%.*]] = phi <2 x i64> [ [[TMP6]], [[COND_LOAD]] ], [ [[PASSTHRU]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ne i2 [[TMP7]], 0
; CHECK-NEXT:    br i1 [[TMP8]], label [[COND_LOAD1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.load1:
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = load i64, i64* [[TMP9]], align 8
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x i64> [[RES_PHI_ELSE]], i64 [[TMP10]], i64 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    [[RES_PHI_ELSE3:%.*]] = phi <2 x i64> [ [[TMP11]], [[COND_LOAD1]] ], [ [[RES_PHI_ELSE]], [[ELSE]] ]
; CHECK-NEXT:    ret <2 x i64> [[RES_PHI_ELSE3]]
;
  %ret = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* %p, i32 128, <2 x i1> %mask, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_ones_mask(<2 x i64>* %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_ones_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x i64>, <2 x i64>* [[P:%.*]], align 8
; CHECK-NEXT:    ret <2 x i64> [[TMP1]]
;
  %ret = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* %p, i32 8, <2 x i1> <i1 true, i1 true>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_zero_mask(<2 x i64>* %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_zero_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-NEXT:    ret <2 x i64> [[PASSTHRU:%.*]]
;
  %ret = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* %p, i32 8, <2 x i1> <i1 false, i1 false>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

define <2 x i64> @scalarize_v2i64_const_mask(<2 x i64>* %p, <2 x i64> %passthru) {
; CHECK-LABEL: @scalarize_v2i64_const_mask(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i64>* [[P:%.*]] to i64*
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i64, i64* [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i64, i64* [[TMP2]], align 8
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <2 x i64> [[PASSTHRU:%.*]], i64 [[TMP3]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[TMP4]]
;
  %ret = call <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>* %p, i32 8, <2 x i1> <i1 false, i1 true>, <2 x i64> %passthru)
  ret <2 x i64> %ret
}

; This use a byte sized but non power of 2 element size. This used to crash due to bad alignment calculation.
define <2 x i24> @scalarize_v2i24(<2 x i24>* %p, <2 x i1> %mask, <2 x i24> %passthru) {
; CHECK-LABEL: @scalarize_v2i24(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i24>* [[P:%.*]] to i24*
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP2:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i2 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[COND_LOAD:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.load:
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i24, i24* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load i24, i24* [[TMP4]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i24> [[PASSTHRU:%.*]], i24 [[TMP5]], i64 0
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[RES_PHI_ELSE:%.*]] = phi <2 x i24> [ [[TMP6]], [[COND_LOAD]] ], [ [[PASSTHRU]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ne i2 [[TMP7]], 0
; CHECK-NEXT:    br i1 [[TMP8]], label [[COND_LOAD1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.load1:
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i24, i24* [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = load i24, i24* [[TMP9]], align 1
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x i24> [[RES_PHI_ELSE]], i24 [[TMP10]], i64 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    [[RES_PHI_ELSE3:%.*]] = phi <2 x i24> [ [[TMP11]], [[COND_LOAD1]] ], [ [[RES_PHI_ELSE]], [[ELSE]] ]
; CHECK-NEXT:    ret <2 x i24> [[RES_PHI_ELSE3]]
;
  %ret = call <2 x i24> @llvm.masked.load.v2i24.p0v2i24(<2 x i24>* %p, i32 8, <2 x i1> %mask, <2 x i24> %passthru)
  ret <2 x i24> %ret
}

; This use a byte sized but non power of 2 element size. This used to crash due to bad alignment calculation.
define <2 x i48> @scalarize_v2i48(<2 x i48>* %p, <2 x i1> %mask, <2 x i48> %passthru) {
; CHECK-LABEL: @scalarize_v2i48(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x i48>* [[P:%.*]] to i48*
; CHECK-NEXT:    [[SCALAR_MASK:%.*]] = bitcast <2 x i1> [[MASK:%.*]] to i2
; CHECK-NEXT:    [[TMP2:%.*]] = and i2 [[SCALAR_MASK]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i2 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[COND_LOAD:%.*]], label [[ELSE:%.*]]
; CHECK:       cond.load:
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i48, i48* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = load i48, i48* [[TMP4]], align 2
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i48> [[PASSTHRU:%.*]], i48 [[TMP5]], i64 0
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[RES_PHI_ELSE:%.*]] = phi <2 x i48> [ [[TMP6]], [[COND_LOAD]] ], [ [[PASSTHRU]], [[TMP0:%.*]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = and i2 [[SCALAR_MASK]], -2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ne i2 [[TMP7]], 0
; CHECK-NEXT:    br i1 [[TMP8]], label [[COND_LOAD1:%.*]], label [[ELSE2:%.*]]
; CHECK:       cond.load1:
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i48, i48* [[TMP1]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = load i48, i48* [[TMP9]], align 2
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x i48> [[RES_PHI_ELSE]], i48 [[TMP10]], i64 1
; CHECK-NEXT:    br label [[ELSE2]]
; CHECK:       else2:
; CHECK-NEXT:    [[RES_PHI_ELSE3:%.*]] = phi <2 x i48> [ [[TMP11]], [[COND_LOAD1]] ], [ [[RES_PHI_ELSE]], [[ELSE]] ]
; CHECK-NEXT:    ret <2 x i48> [[RES_PHI_ELSE3]]
;
  %ret = call <2 x i48> @llvm.masked.load.v2i48.p0v2i48(<2 x i48>* %p, i32 16, <2 x i1> %mask, <2 x i48> %passthru)
  ret <2 x i48> %ret
}

declare <2 x i24> @llvm.masked.load.v2i24.p0v2i24(<2 x i24>*, i32, <2 x i1>, <2 x i24>)
declare <2 x i48> @llvm.masked.load.v2i48.p0v2i48(<2 x i48>*, i32, <2 x i1>, <2 x i48>)
declare <2 x i64> @llvm.masked.load.v2i64.p0v2i64(<2 x i64>*, i32, <2 x i1>, <2 x i64>)
