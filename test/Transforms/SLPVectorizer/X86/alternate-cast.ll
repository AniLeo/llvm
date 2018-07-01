; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=slm -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=corei7-avx -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=core-avx2 -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=knl -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: opt < %s -mtriple=x86_64-unknown -mcpu=skx -basicaa -slp-vectorizer -instcombine -S | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512 --check-prefix=AVX512BW

define <8 x float> @sitofp_uitofp(<8 x i32> %a) {
; CHECK-LABEL: @sitofp_uitofp(
; CHECK-NEXT:    [[A0:%.*]] = extractelement <8 x i32> [[A:%.*]], i32 0
; CHECK-NEXT:    [[A1:%.*]] = extractelement <8 x i32> [[A]], i32 1
; CHECK-NEXT:    [[A2:%.*]] = extractelement <8 x i32> [[A]], i32 2
; CHECK-NEXT:    [[A3:%.*]] = extractelement <8 x i32> [[A]], i32 3
; CHECK-NEXT:    [[A4:%.*]] = extractelement <8 x i32> [[A]], i32 4
; CHECK-NEXT:    [[A5:%.*]] = extractelement <8 x i32> [[A]], i32 5
; CHECK-NEXT:    [[A6:%.*]] = extractelement <8 x i32> [[A]], i32 6
; CHECK-NEXT:    [[A7:%.*]] = extractelement <8 x i32> [[A]], i32 7
; CHECK-NEXT:    [[AB0:%.*]] = sitofp i32 [[A0]] to float
; CHECK-NEXT:    [[AB1:%.*]] = sitofp i32 [[A1]] to float
; CHECK-NEXT:    [[AB2:%.*]] = sitofp i32 [[A2]] to float
; CHECK-NEXT:    [[AB3:%.*]] = sitofp i32 [[A3]] to float
; CHECK-NEXT:    [[AB4:%.*]] = uitofp i32 [[A4]] to float
; CHECK-NEXT:    [[AB5:%.*]] = uitofp i32 [[A5]] to float
; CHECK-NEXT:    [[AB6:%.*]] = uitofp i32 [[A6]] to float
; CHECK-NEXT:    [[AB7:%.*]] = uitofp i32 [[A7]] to float
; CHECK-NEXT:    [[R0:%.*]] = insertelement <8 x float> undef, float [[AB0]], i32 0
; CHECK-NEXT:    [[R1:%.*]] = insertelement <8 x float> [[R0]], float [[AB1]], i32 1
; CHECK-NEXT:    [[R2:%.*]] = insertelement <8 x float> [[R1]], float [[AB2]], i32 2
; CHECK-NEXT:    [[R3:%.*]] = insertelement <8 x float> [[R2]], float [[AB3]], i32 3
; CHECK-NEXT:    [[R4:%.*]] = insertelement <8 x float> [[R3]], float [[AB4]], i32 4
; CHECK-NEXT:    [[R5:%.*]] = insertelement <8 x float> [[R4]], float [[AB5]], i32 5
; CHECK-NEXT:    [[R6:%.*]] = insertelement <8 x float> [[R5]], float [[AB6]], i32 6
; CHECK-NEXT:    [[R7:%.*]] = insertelement <8 x float> [[R6]], float [[AB7]], i32 7
; CHECK-NEXT:    ret <8 x float> [[R7]]
;
  %a0 = extractelement <8 x i32> %a, i32 0
  %a1 = extractelement <8 x i32> %a, i32 1
  %a2 = extractelement <8 x i32> %a, i32 2
  %a3 = extractelement <8 x i32> %a, i32 3
  %a4 = extractelement <8 x i32> %a, i32 4
  %a5 = extractelement <8 x i32> %a, i32 5
  %a6 = extractelement <8 x i32> %a, i32 6
  %a7 = extractelement <8 x i32> %a, i32 7
  %ab0 = sitofp i32 %a0 to float
  %ab1 = sitofp i32 %a1 to float
  %ab2 = sitofp i32 %a2 to float
  %ab3 = sitofp i32 %a3 to float
  %ab4 = uitofp i32 %a4 to float
  %ab5 = uitofp i32 %a5 to float
  %ab6 = uitofp i32 %a6 to float
  %ab7 = uitofp i32 %a7 to float
  %r0 = insertelement <8 x float> undef, float %ab0, i32 0
  %r1 = insertelement <8 x float>   %r0, float %ab1, i32 1
  %r2 = insertelement <8 x float>   %r1, float %ab2, i32 2
  %r3 = insertelement <8 x float>   %r2, float %ab3, i32 3
  %r4 = insertelement <8 x float>   %r3, float %ab4, i32 4
  %r5 = insertelement <8 x float>   %r4, float %ab5, i32 5
  %r6 = insertelement <8 x float>   %r5, float %ab6, i32 6
  %r7 = insertelement <8 x float>   %r6, float %ab7, i32 7
  ret <8 x float> %r7
}

define <8 x i32> @fptosi_fptoui(<8 x float> %a) {
; CHECK-LABEL: @fptosi_fptoui(
; CHECK-NEXT:    [[A0:%.*]] = extractelement <8 x float> [[A:%.*]], i32 0
; CHECK-NEXT:    [[A1:%.*]] = extractelement <8 x float> [[A]], i32 1
; CHECK-NEXT:    [[A2:%.*]] = extractelement <8 x float> [[A]], i32 2
; CHECK-NEXT:    [[A3:%.*]] = extractelement <8 x float> [[A]], i32 3
; CHECK-NEXT:    [[A4:%.*]] = extractelement <8 x float> [[A]], i32 4
; CHECK-NEXT:    [[A5:%.*]] = extractelement <8 x float> [[A]], i32 5
; CHECK-NEXT:    [[A6:%.*]] = extractelement <8 x float> [[A]], i32 6
; CHECK-NEXT:    [[A7:%.*]] = extractelement <8 x float> [[A]], i32 7
; CHECK-NEXT:    [[AB0:%.*]] = fptosi float [[A0]] to i32
; CHECK-NEXT:    [[AB1:%.*]] = fptosi float [[A1]] to i32
; CHECK-NEXT:    [[AB2:%.*]] = fptosi float [[A2]] to i32
; CHECK-NEXT:    [[AB3:%.*]] = fptosi float [[A3]] to i32
; CHECK-NEXT:    [[AB4:%.*]] = fptoui float [[A4]] to i32
; CHECK-NEXT:    [[AB5:%.*]] = fptoui float [[A5]] to i32
; CHECK-NEXT:    [[AB6:%.*]] = fptoui float [[A6]] to i32
; CHECK-NEXT:    [[AB7:%.*]] = fptoui float [[A7]] to i32
; CHECK-NEXT:    [[R0:%.*]] = insertelement <8 x i32> undef, i32 [[AB0]], i32 0
; CHECK-NEXT:    [[R1:%.*]] = insertelement <8 x i32> [[R0]], i32 [[AB1]], i32 1
; CHECK-NEXT:    [[R2:%.*]] = insertelement <8 x i32> [[R1]], i32 [[AB2]], i32 2
; CHECK-NEXT:    [[R3:%.*]] = insertelement <8 x i32> [[R2]], i32 [[AB3]], i32 3
; CHECK-NEXT:    [[R4:%.*]] = insertelement <8 x i32> [[R3]], i32 [[AB4]], i32 4
; CHECK-NEXT:    [[R5:%.*]] = insertelement <8 x i32> [[R4]], i32 [[AB5]], i32 5
; CHECK-NEXT:    [[R6:%.*]] = insertelement <8 x i32> [[R5]], i32 [[AB6]], i32 6
; CHECK-NEXT:    [[R7:%.*]] = insertelement <8 x i32> [[R6]], i32 [[AB7]], i32 7
; CHECK-NEXT:    ret <8 x i32> [[R7]]
;
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %a2 = extractelement <8 x float> %a, i32 2
  %a3 = extractelement <8 x float> %a, i32 3
  %a4 = extractelement <8 x float> %a, i32 4
  %a5 = extractelement <8 x float> %a, i32 5
  %a6 = extractelement <8 x float> %a, i32 6
  %a7 = extractelement <8 x float> %a, i32 7
  %ab0 = fptosi float %a0 to i32
  %ab1 = fptosi float %a1 to i32
  %ab2 = fptosi float %a2 to i32
  %ab3 = fptosi float %a3 to i32
  %ab4 = fptoui float %a4 to i32
  %ab5 = fptoui float %a5 to i32
  %ab6 = fptoui float %a6 to i32
  %ab7 = fptoui float %a7 to i32
  %r0 = insertelement <8 x i32> undef, i32 %ab0, i32 0
  %r1 = insertelement <8 x i32>   %r0, i32 %ab1, i32 1
  %r2 = insertelement <8 x i32>   %r1, i32 %ab2, i32 2
  %r3 = insertelement <8 x i32>   %r2, i32 %ab3, i32 3
  %r4 = insertelement <8 x i32>   %r3, i32 %ab4, i32 4
  %r5 = insertelement <8 x i32>   %r4, i32 %ab5, i32 5
  %r6 = insertelement <8 x i32>   %r5, i32 %ab6, i32 6
  %r7 = insertelement <8 x i32>   %r6, i32 %ab7, i32 7
  ret <8 x i32> %r7
}

define <8 x float> @fneg_fabs(<8 x float> %a) {
; CHECK-LABEL: @fneg_fabs(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x float> [[A:%.*]] to <8 x i32>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <8 x i32> [[TMP1]], <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = and <8 x i32> [[TMP1]], <i32 undef, i32 undef, i32 undef, i32 undef, i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <8 x i32> [[TMP2]], <8 x i32> [[TMP3]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast <8 x i32> [[TMP4]] to <8 x float>
; CHECK-NEXT:    ret <8 x float> [[TMP5]]
;
  %a0 = extractelement <8 x float> %a, i32 0
  %a1 = extractelement <8 x float> %a, i32 1
  %a2 = extractelement <8 x float> %a, i32 2
  %a3 = extractelement <8 x float> %a, i32 3
  %a4 = extractelement <8 x float> %a, i32 4
  %a5 = extractelement <8 x float> %a, i32 5
  %a6 = extractelement <8 x float> %a, i32 6
  %a7 = extractelement <8 x float> %a, i32 7
  %aa0 = bitcast float %a0 to i32
  %aa1 = bitcast float %a1 to i32
  %aa2 = bitcast float %a2 to i32
  %aa3 = bitcast float %a3 to i32
  %aa4 = bitcast float %a4 to i32
  %aa5 = bitcast float %a5 to i32
  %aa6 = bitcast float %a6 to i32
  %aa7 = bitcast float %a7 to i32
  %ab0 = xor i32 %aa0, -2147483648
  %ab1 = xor i32 %aa1, -2147483648
  %ab2 = xor i32 %aa2, -2147483648
  %ab3 = xor i32 %aa3, -2147483648
  %ab4 = and i32 %aa4, 2147483647
  %ab5 = and i32 %aa5, 2147483647
  %ab6 = and i32 %aa6, 2147483647
  %ab7 = and i32 %aa7, 2147483647
  %ac0 = bitcast i32 %ab0 to float
  %ac1 = bitcast i32 %ab1 to float
  %ac2 = bitcast i32 %ab2 to float
  %ac3 = bitcast i32 %ab3 to float
  %ac4 = bitcast i32 %ab4 to float
  %ac5 = bitcast i32 %ab5 to float
  %ac6 = bitcast i32 %ab6 to float
  %ac7 = bitcast i32 %ab7 to float
  %r0 = insertelement <8 x float> undef, float %ac0, i32 0
  %r1 = insertelement <8 x float>   %r0, float %ac1, i32 1
  %r2 = insertelement <8 x float>   %r1, float %ac2, i32 2
  %r3 = insertelement <8 x float>   %r2, float %ac3, i32 3
  %r4 = insertelement <8 x float>   %r3, float %ac4, i32 4
  %r5 = insertelement <8 x float>   %r4, float %ac5, i32 5
  %r6 = insertelement <8 x float>   %r5, float %ac6, i32 6
  %r7 = insertelement <8 x float>   %r6, float %ac7, i32 7
  ret <8 x float> %r7
}
