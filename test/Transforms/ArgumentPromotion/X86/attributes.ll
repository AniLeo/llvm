; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -argpromotion < %s | FileCheck %s
; RUN: opt -S -passes=argpromotion < %s | FileCheck %s
; Test that we only promote arguments when the caller/callee have compatible
; function attrubtes.

target triple = "x86_64-unknown-linux-gnu"

define internal fastcc void @no_promote_avx2(<4 x i64>* %arg, <4 x i64>* readonly %arg1) #0 {
; CHECK-LABEL: define {{[^@]+}}@no_promote_avx2
; CHECK-SAME: (<4 x i64>* [[ARG:%.*]], <4 x i64>* readonly [[ARG1:%.*]])
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = load <4 x i64>, <4 x i64>* [[ARG1]]
; CHECK-NEXT:    store <4 x i64> [[TMP]], <4 x i64>* [[ARG]]
; CHECK-NEXT:    ret void
;
bb:
  %tmp = load <4 x i64>, <4 x i64>* %arg1
  store <4 x i64> %tmp, <4 x i64>* %arg
  ret void
}

define void @no_promote(<4 x i64>* %arg) #1 {
; CHECK-LABEL: define {{[^@]+}}@no_promote
; CHECK-SAME: (<4 x i64>* [[ARG:%.*]])
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 32 [[TMP3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    call fastcc void @no_promote_avx2(<4 x i64>* [[TMP2]], <4 x i64>* [[TMP]])
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; CHECK-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; CHECK-NEXT:    ret void
;
bb:
  %tmp = alloca <4 x i64>, align 32
  %tmp2 = alloca <4 x i64>, align 32
  %tmp3 = bitcast <4 x i64>* %tmp to i8*
  call void @llvm.memset.p0i8.i64(i8* align 32 %tmp3, i8 0, i64 32, i1 false)
  call fastcc void @no_promote_avx2(<4 x i64>* %tmp2, <4 x i64>* %tmp)
  %tmp4 = load <4 x i64>, <4 x i64>* %tmp2, align 32
  store <4 x i64> %tmp4, <4 x i64>* %arg, align 2
  ret void
}

define internal fastcc void @promote_avx2(<4 x i64>* %arg, <4 x i64>* readonly %arg1) #0 {
; CHECK-LABEL: define {{[^@]+}}@promote_avx2
; CHECK-SAME: (<4 x i64>* [[ARG:%.*]], <4 x i64> [[ARG1_VAL:%.*]])
; CHECK-NEXT:  bb:
; CHECK-NEXT:    store <4 x i64> [[ARG1_VAL]], <4 x i64>* [[ARG]]
; CHECK-NEXT:    ret void
;
bb:
  %tmp = load <4 x i64>, <4 x i64>* %arg1
  store <4 x i64> %tmp, <4 x i64>* %arg
  ret void
}

define void @promote(<4 x i64>* %arg) #0 {
; CHECK-LABEL: define {{[^@]+}}@promote
; CHECK-SAME: (<4 x i64>* [[ARG:%.*]])
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = alloca <4 x i64>, align 32
; CHECK-NEXT:    [[TMP2:%.*]] = alloca <4 x i64>, align 32
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i64>* [[TMP]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 32 [[TMP3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    [[TMP_VAL:%.*]] = load <4 x i64>, <4 x i64>* [[TMP]]
; CHECK-NEXT:    call fastcc void @promote_avx2(<4 x i64>* [[TMP2]], <4 x i64> [[TMP_VAL]])
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* [[TMP2]], align 32
; CHECK-NEXT:    store <4 x i64> [[TMP4]], <4 x i64>* [[ARG]], align 2
; CHECK-NEXT:    ret void
;
bb:
  %tmp = alloca <4 x i64>, align 32
  %tmp2 = alloca <4 x i64>, align 32
  %tmp3 = bitcast <4 x i64>* %tmp to i8*
  call void @llvm.memset.p0i8.i64(i8* align 32 %tmp3, i8 0, i64 32, i1 false)
  call fastcc void @promote_avx2(<4 x i64>* %tmp2, <4 x i64>* %tmp)
  %tmp4 = load <4 x i64>, <4 x i64>* %tmp2, align 32
  store <4 x i64> %tmp4, <4 x i64>* %arg, align 2
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

attributes #0 = { inlinehint norecurse nounwind uwtable "target-features"="+avx2" }
attributes #1 = { nounwind uwtable }
attributes #2 = { argmemonly nounwind }
