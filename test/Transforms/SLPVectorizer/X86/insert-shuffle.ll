; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -o - -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

%struct.sw = type { float, float, float, float }

define { <2 x float>, <2 x float> } @foo(%struct.sw* %v) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* undef, align 4
; CHECK-NEXT:    [[X:%.*]] = getelementptr inbounds [[STRUCT_SW:%.*]], %struct.sw* [[V:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* undef, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast float* [[X]] to <2 x float>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x float>, <2 x float>* [[TMP2]], align 16
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x float> [[TMP3]], <2 x float> poison, <4 x i32> <i32 1, i32 0, i32 0, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = insertelement <4 x float> poison, float [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x float> [[TMP4]], float [[TMP1]], i32 1
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <4 x float> [[TMP5]], <4 x float> poison, <4 x i32> <i32 0, i32 undef, i32 1, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = fmul <4 x float> [[SHUFFLE]], [[SHUFFLE1]]
; CHECK-NEXT:    [[TMP7:%.*]] = fadd <4 x float> [[TMP6]], poison
; CHECK-NEXT:    [[TMP8:%.*]] = fadd <4 x float> [[TMP7]], poison
; CHECK-NEXT:    [[TMP9:%.*]] = fadd <4 x float> [[TMP8]], poison
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x float> [[TMP9]], i32 0
; CHECK-NEXT:    [[VEC1:%.*]] = insertelement <2 x float> undef, float [[TMP10]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x float> [[TMP9]], i32 1
; CHECK-NEXT:    [[VEC2:%.*]] = insertelement <2 x float> [[VEC1]], float [[TMP11]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x float> [[TMP9]], i32 2
; CHECK-NEXT:    [[VEC3:%.*]] = insertelement <2 x float> undef, float [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x float> [[TMP9]], i32 3
; CHECK-NEXT:    [[VEC4:%.*]] = insertelement <2 x float> [[VEC3]], float [[TMP13]], i32 1
; CHECK-NEXT:    [[INS1:%.*]] = insertvalue { <2 x float>, <2 x float> } undef, <2 x float> [[VEC2]], 0
; CHECK-NEXT:    [[INS2:%.*]] = insertvalue { <2 x float>, <2 x float> } [[INS1]], <2 x float> [[VEC4]], 1
; CHECK-NEXT:    ret { <2 x float>, <2 x float> } [[INS2]]
;
entry:
  %0 = load float, float* undef, align 4
  %x = getelementptr inbounds %struct.sw, %struct.sw* %v, i64 0, i32 0
  %1 = load float, float* %x, align 16
  %y = getelementptr inbounds %struct.sw, %struct.sw* %v, i64 0, i32 1
  %2 = load float, float* %y, align 4
  %mul3 = fmul float %0, %2
  %add = fadd float undef, %mul3
  %add6 = fadd float %add, undef
  %add9 = fadd float %add6, undef
  %mul12 = fmul float %1, undef
  %add16 = fadd float %mul12, undef
  %add20 = fadd float undef, %add16
  %add24 = fadd float undef, %add20
  %3 = load float, float* undef, align 4
  %mul27 = fmul float %1, %3
  %add31 = fadd float %mul27, undef
  %add35 = fadd float undef, %add31
  %add39 = fadd float undef, %add35
  %mul45 = fmul float %2, undef
  %add46 = fadd float undef, %mul45
  %add50 = fadd float undef, %add46
  %add54 = fadd float undef, %add50
  %vec1 = insertelement <2 x float> undef, float %add9, i32 0
  %vec2 = insertelement <2 x float> %vec1, float %add24, i32 1
  %vec3 = insertelement <2 x float> undef, float %add39, i32 0
  %vec4 = insertelement <2 x float> %vec3, float %add54, i32 1
  %ins1 = insertvalue { <2 x float>, <2 x float> } undef, <2 x float> %vec2, 0
  %ins2 = insertvalue { <2 x float>, <2 x float> } %ins1, <2 x float> %vec4, 1
  ret { <2 x float>, <2 x float> } %ins2
}
