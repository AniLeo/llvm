; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu -mcpu=corei7-avx | FileCheck %s

define void @julia_2xdouble([2 x double]* sret, [2 x double]*, [2 x double]*, [2 x double]*) {
; CHECK-LABEL: @julia_2xdouble(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[PX0:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP2:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PY0:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP3:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PX1:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP2]], i64 0, i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast double* [[PX0]] to <2 x double>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x double>, <2 x double>* [[TMP4]], align 4
; CHECK-NEXT:    [[PY1:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP3]], i64 0, i64 1
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast double* [[PY0]] to <2 x double>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <2 x double>, <2 x double>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <2 x double> [[TMP5]], [[TMP7]]
; CHECK-NEXT:    [[PZ0:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP1:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PZ1:%.*]] = getelementptr inbounds [2 x double], [2 x double]* [[TMP1]], i64 0, i64 1
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast double* [[PZ0]] to <2 x double>*
; CHECK-NEXT:    [[TMP10:%.*]] = load <2 x double>, <2 x double>* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = fadd <2 x double> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double> [[TMP11]], i32 0
; CHECK-NEXT:    [[I0:%.*]] = insertvalue [2 x double] undef, double [[TMP12]], 0
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x double> [[TMP11]], i32 1
; CHECK-NEXT:    [[I1:%.*]] = insertvalue [2 x double] [[I0]], double [[TMP13]], 1
; CHECK-NEXT:    store [2 x double] [[I1]], [2 x double]* [[TMP0:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %px0 = getelementptr inbounds [2 x double], [2 x double]* %2, i64 0, i64 0
  %x0 = load double, double* %px0, align 4
  %py0 = getelementptr inbounds [2 x double], [2 x double]* %3, i64 0, i64 0
  %y0 = load double, double* %py0, align 4
  %m0 = fmul double %x0, %y0
  %px1 = getelementptr inbounds [2 x double], [2 x double]* %2, i64 0, i64 1
  %x1 = load double, double* %px1, align 4
  %py1 = getelementptr inbounds [2 x double], [2 x double]* %3, i64 0, i64 1
  %y1 = load double, double* %py1, align 4
  %m1 = fmul double %x1, %y1
  %pz0 = getelementptr inbounds [2 x double], [2 x double]* %1, i64 0, i64 0
  %z0 = load double, double* %pz0, align 4
  %a0 = fadd double %m0, %z0
  %i0 = insertvalue [2 x double] undef, double %a0, 0
  %pz1 = getelementptr inbounds [2 x double], [2 x double]* %1, i64 0, i64 1
  %z1 = load double, double* %pz1, align 4
  %a1 = fadd double %m1, %z1
  %i1 = insertvalue [2 x double] %i0, double %a1, 1
  store [2 x double] %i1, [2 x double]* %0, align 4
  ret void
}

define void @julia_4xfloat([4 x float]* sret, [4 x float]*, [4 x float]*, [4 x float]*) {
; CHECK-LABEL: @julia_4xfloat(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[PX0:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP2:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PY0:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP3:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PX1:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP2]], i64 0, i64 1
; CHECK-NEXT:    [[PY1:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP3]], i64 0, i64 1
; CHECK-NEXT:    [[PX2:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP2]], i64 0, i64 2
; CHECK-NEXT:    [[PY2:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP3]], i64 0, i64 2
; CHECK-NEXT:    [[PX3:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP2]], i64 0, i64 3
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast float* [[PX0]] to <4 x float>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <4 x float>, <4 x float>* [[TMP4]], align 4
; CHECK-NEXT:    [[PY3:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP3]], i64 0, i64 3
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[PY0]] to <4 x float>*
; CHECK-NEXT:    [[TMP7:%.*]] = load <4 x float>, <4 x float>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <4 x float> [[TMP5]], [[TMP7]]
; CHECK-NEXT:    [[PZ0:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP1:%.*]], i64 0, i64 0
; CHECK-NEXT:    [[PZ1:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP1]], i64 0, i64 1
; CHECK-NEXT:    [[PZ2:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP1]], i64 0, i64 2
; CHECK-NEXT:    [[PZ3:%.*]] = getelementptr inbounds [4 x float], [4 x float]* [[TMP1]], i64 0, i64 3
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[PZ0]] to <4 x float>*
; CHECK-NEXT:    [[TMP10:%.*]] = load <4 x float>, <4 x float>* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP11:%.*]] = fadd <4 x float> [[TMP8]], [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x float> [[TMP11]], i32 0
; CHECK-NEXT:    [[I0:%.*]] = insertvalue [4 x float] undef, float [[TMP12]], 0
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x float> [[TMP11]], i32 1
; CHECK-NEXT:    [[I1:%.*]] = insertvalue [4 x float] [[I0]], float [[TMP13]], 1
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <4 x float> [[TMP11]], i32 2
; CHECK-NEXT:    [[I2:%.*]] = insertvalue [4 x float] [[I1]], float [[TMP14]], 2
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x float> [[TMP11]], i32 3
; CHECK-NEXT:    [[I3:%.*]] = insertvalue [4 x float] [[I2]], float [[TMP15]], 3
; CHECK-NEXT:    store [4 x float] [[I3]], [4 x float]* [[TMP0:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %px0 = getelementptr inbounds [4 x float], [4 x float]* %2, i64 0, i64 0
  %x0 = load float, float* %px0, align 4
  %py0 = getelementptr inbounds [4 x float], [4 x float]* %3, i64 0, i64 0
  %y0 = load float, float* %py0, align 4
  %m0 = fmul float %x0, %y0
  %px1 = getelementptr inbounds [4 x float], [4 x float]* %2, i64 0, i64 1
  %x1 = load float, float* %px1, align 4
  %py1 = getelementptr inbounds [4 x float], [4 x float]* %3, i64 0, i64 1
  %y1 = load float, float* %py1, align 4
  %m1 = fmul float %x1, %y1
  %px2 = getelementptr inbounds [4 x float], [4 x float]* %2, i64 0, i64 2
  %x2 = load float, float* %px2, align 4
  %py2 = getelementptr inbounds [4 x float], [4 x float]* %3, i64 0, i64 2
  %y2 = load float, float* %py2, align 4
  %m2 = fmul float %x2, %y2
  %px3 = getelementptr inbounds [4 x float], [4 x float]* %2, i64 0, i64 3
  %x3 = load float, float* %px3, align 4
  %py3 = getelementptr inbounds [4 x float], [4 x float]* %3, i64 0, i64 3
  %y3 = load float, float* %py3, align 4
  %m3 = fmul float %x3, %y3
  %pz0 = getelementptr inbounds [4 x float], [4 x float]* %1, i64 0, i64 0
  %z0 = load float, float* %pz0, align 4
  %a0 = fadd float %m0, %z0
  %i0 = insertvalue [4 x float] undef, float %a0, 0
  %pz1 = getelementptr inbounds [4 x float], [4 x float]* %1, i64 0, i64 1
  %z1 = load float, float* %pz1, align 4
  %a1 = fadd float %m1, %z1
  %i1 = insertvalue [4 x float] %i0, float %a1, 1
  %pz2 = getelementptr inbounds [4 x float], [4 x float]* %1, i64 0, i64 2
  %z2 = load float, float* %pz2, align 4
  %a2 = fadd float %m2, %z2
  %i2 = insertvalue [4 x float] %i1, float %a2, 2
  %pz3 = getelementptr inbounds [4 x float], [4 x float]* %1, i64 0, i64 3
  %z3 = load float, float* %pz3, align 4
  %a3 = fadd float %m3, %z3
  %i3 = insertvalue [4 x float] %i2, float %a3, 3
  store [4 x float] %i3, [4 x float]* %0, align 4
  ret void
}

define void @julia_load_array_of_float([4 x float]* %a, [4 x float]* %b, [4 x float]* %c) {
; CHECK-LABEL: @julia_load_array_of_float(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [4 x float]* [[A:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[A_ARR:%.*]] = load [4 x float], [4 x float]* [[A]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast [4 x float]* [[B:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x float>, <4 x float>* [[TMP2]], align 4
; CHECK-NEXT:    [[B_ARR:%.*]] = load [4 x float], [4 x float]* [[B]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <4 x float> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP4]], i32 0
; CHECK-NEXT:    [[C_ARR0:%.*]] = insertvalue [4 x float] undef, float [[TMP5]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP4]], i32 1
; CHECK-NEXT:    [[C_ARR1:%.*]] = insertvalue [4 x float] [[C_ARR0]], float [[TMP6]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x float> [[TMP4]], i32 2
; CHECK-NEXT:    [[C_ARR2:%.*]] = insertvalue [4 x float] [[C_ARR1]], float [[TMP7]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x float> [[TMP4]], i32 3
; CHECK-NEXT:    [[C_ARR3:%.*]] = insertvalue [4 x float] [[C_ARR2]], float [[TMP8]], 3
; CHECK-NEXT:    store [4 x float] [[C_ARR3]], [4 x float]* [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %a_arr = load [4 x float], [4 x float]* %a, align 4
  %a0 = extractvalue [4 x float] %a_arr, 0
  %a2 = extractvalue [4 x float] %a_arr, 2
  %a1 = extractvalue [4 x float] %a_arr, 1
  %b_arr = load [4 x float], [4 x float]* %b, align 4
  %b0 = extractvalue [4 x float] %b_arr, 0
  %b2 = extractvalue [4 x float] %b_arr, 2
  %b1 = extractvalue [4 x float] %b_arr, 1
  %a3 = extractvalue [4 x float] %a_arr, 3
  %c1 = fsub float %a1, %b1
  %b3 = extractvalue [4 x float] %b_arr, 3
  %c0 = fsub float %a0, %b0
  %c2 = fsub float %a2, %b2
  %c_arr0 = insertvalue [4 x float] undef, float %c0, 0
  %c_arr1 = insertvalue [4 x float] %c_arr0, float %c1, 1
  %c3 = fsub float %a3, %b3
  %c_arr2 = insertvalue [4 x float] %c_arr1, float %c2, 2
  %c_arr3 = insertvalue [4 x float] %c_arr2, float %c3, 3
  store [4 x float] %c_arr3, [4 x float]* %c, align 4
  ret void
}

define void @julia_load_array_of_i32([4 x i32]* %a, [4 x i32]* %b, [4 x i32]* %c) {
; CHECK-LABEL: @julia_load_array_of_i32(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [4 x i32]* [[A:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, <4 x i32>* [[TMP0]], align 4
; CHECK-NEXT:    [[A_ARR:%.*]] = load [4 x i32], [4 x i32]* [[A]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast [4 x i32]* [[B:%.*]] to <4 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x i32>, <4 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[B_ARR:%.*]] = load [4 x i32], [4 x i32]* [[B]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub <4 x i32> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i32> [[TMP4]], i32 0
; CHECK-NEXT:    [[C_ARR0:%.*]] = insertvalue [4 x i32] undef, i32 [[TMP5]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i32> [[TMP4]], i32 1
; CHECK-NEXT:    [[C_ARR1:%.*]] = insertvalue [4 x i32] [[C_ARR0]], i32 [[TMP6]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i32> [[TMP4]], i32 2
; CHECK-NEXT:    [[C_ARR2:%.*]] = insertvalue [4 x i32] [[C_ARR1]], i32 [[TMP7]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x i32> [[TMP4]], i32 3
; CHECK-NEXT:    [[C_ARR3:%.*]] = insertvalue [4 x i32] [[C_ARR2]], i32 [[TMP8]], 3
; CHECK-NEXT:    store [4 x i32] [[C_ARR3]], [4 x i32]* [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %a_arr = load [4 x i32], [4 x i32]* %a, align 4
  %a0 = extractvalue [4 x i32] %a_arr, 0
  %a2 = extractvalue [4 x i32] %a_arr, 2
  %a1 = extractvalue [4 x i32] %a_arr, 1
  %b_arr = load [4 x i32], [4 x i32]* %b, align 4
  %b0 = extractvalue [4 x i32] %b_arr, 0
  %b2 = extractvalue [4 x i32] %b_arr, 2
  %b1 = extractvalue [4 x i32] %b_arr, 1
  %a3 = extractvalue [4 x i32] %a_arr, 3
  %c1 = sub i32 %a1, %b1
  %b3 = extractvalue [4 x i32] %b_arr, 3
  %c0 = sub i32 %a0, %b0
  %c2 = sub i32 %a2, %b2
  %c_arr0 = insertvalue [4 x i32] undef, i32 %c0, 0
  %c_arr1 = insertvalue [4 x i32] %c_arr0, i32 %c1, 1
  %c3 = sub i32 %a3, %b3
  %c_arr2 = insertvalue [4 x i32] %c_arr1, i32 %c2, 2
  %c_arr3 = insertvalue [4 x i32] %c_arr2, i32 %c3, 3
  store [4 x i32] %c_arr3, [4 x i32]* %c, align 4
  ret void
}

; Almost identical to previous test, but for type that should NOT be vectorized.
;
define void @julia_load_array_of_i16([4 x i16]* %a, [4 x i16]* %b, [4 x i16]* %c) {
; CHECK-LABEL: @julia_load_array_of_i16(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[A_ARR:%.*]] = load [4 x i16], [4 x i16]* [[A:%.*]], align 4
; CHECK-NEXT:    [[A0:%.*]] = extractvalue [4 x i16] [[A_ARR]], 0
; CHECK-NEXT:    [[A2:%.*]] = extractvalue [4 x i16] [[A_ARR]], 2
; CHECK-NEXT:    [[A1:%.*]] = extractvalue [4 x i16] [[A_ARR]], 1
; CHECK-NEXT:    [[B_ARR:%.*]] = load [4 x i16], [4 x i16]* [[B:%.*]], align 4
; CHECK-NEXT:    [[B0:%.*]] = extractvalue [4 x i16] [[B_ARR]], 0
; CHECK-NEXT:    [[B2:%.*]] = extractvalue [4 x i16] [[B_ARR]], 2
; CHECK-NEXT:    [[B1:%.*]] = extractvalue [4 x i16] [[B_ARR]], 1
; CHECK-NEXT:    [[A3:%.*]] = extractvalue [4 x i16] [[A_ARR]], 3
; CHECK-NEXT:    [[C1:%.*]] = sub i16 [[A1]], [[B1]]
; CHECK-NEXT:    [[B3:%.*]] = extractvalue [4 x i16] [[B_ARR]], 3
; CHECK-NEXT:    [[C0:%.*]] = sub i16 [[A0]], [[B0]]
; CHECK-NEXT:    [[C2:%.*]] = sub i16 [[A2]], [[B2]]
; CHECK-NEXT:    [[C_ARR0:%.*]] = insertvalue [4 x i16] undef, i16 [[C0]], 0
; CHECK-NEXT:    [[C_ARR1:%.*]] = insertvalue [4 x i16] [[C_ARR0]], i16 [[C1]], 1
; CHECK-NEXT:    [[C3:%.*]] = sub i16 [[A3]], [[B3]]
; CHECK-NEXT:    [[C_ARR2:%.*]] = insertvalue [4 x i16] [[C_ARR1]], i16 [[C2]], 2
; CHECK-NEXT:    [[C_ARR3:%.*]] = insertvalue [4 x i16] [[C_ARR2]], i16 [[C3]], 3
; CHECK-NEXT:    store [4 x i16] [[C_ARR3]], [4 x i16]* [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %a_arr = load [4 x i16], [4 x i16]* %a, align 4
  %a0 = extractvalue [4 x i16] %a_arr, 0
  %a2 = extractvalue [4 x i16] %a_arr, 2
  %a1 = extractvalue [4 x i16] %a_arr, 1
  %b_arr = load [4 x i16], [4 x i16]* %b, align 4
  %b0 = extractvalue [4 x i16] %b_arr, 0
  %b2 = extractvalue [4 x i16] %b_arr, 2
  %b1 = extractvalue [4 x i16] %b_arr, 1
  %a3 = extractvalue [4 x i16] %a_arr, 3
  %c1 = sub i16 %a1, %b1
  %b3 = extractvalue [4 x i16] %b_arr, 3
  %c0 = sub i16 %a0, %b0
  %c2 = sub i16 %a2, %b2
  %c_arr0 = insertvalue [4 x i16] undef, i16 %c0, 0
  %c_arr1 = insertvalue [4 x i16] %c_arr0, i16 %c1, 1
  %c3 = sub i16 %a3, %b3
  %c_arr2 = insertvalue [4 x i16] %c_arr1, i16 %c2, 2
  %c_arr3 = insertvalue [4 x i16] %c_arr2, i16 %c3, 3
  store [4 x i16] %c_arr3, [4 x i16]* %c, align 4
  ret void
}

%pseudovec = type { float, float, float, float }

define void @julia_load_struct_of_float(%pseudovec* %a, %pseudovec* %b, %pseudovec* %c) {
; CHECK-LABEL: @julia_load_struct_of_float(
; CHECK-NEXT:  top:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %pseudovec* [[A:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, <4 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[A_STRUCT:%.*]] = load [[PSEUDOVEC:%.*]], %pseudovec* [[A]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast %pseudovec* [[B:%.*]] to <4 x float>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <4 x float>, <4 x float>* [[TMP2]], align 4
; CHECK-NEXT:    [[B_STRUCT:%.*]] = load [[PSEUDOVEC]], %pseudovec* [[B]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <4 x float> [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP4]], i32 0
; CHECK-NEXT:    [[C_STRUCT0:%.*]] = insertvalue [[PSEUDOVEC]] undef, float [[TMP5]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP4]], i32 1
; CHECK-NEXT:    [[C_STRUCT1:%.*]] = insertvalue [[PSEUDOVEC]] %c_struct0, float [[TMP6]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x float> [[TMP4]], i32 2
; CHECK-NEXT:    [[C_STRUCT2:%.*]] = insertvalue [[PSEUDOVEC]] %c_struct1, float [[TMP7]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x float> [[TMP4]], i32 3
; CHECK-NEXT:    [[C_STRUCT3:%.*]] = insertvalue [[PSEUDOVEC]] %c_struct2, float [[TMP8]], 3
; CHECK-NEXT:    store [[PSEUDOVEC]] %c_struct3, %pseudovec* [[C:%.*]], align 4
; CHECK-NEXT:    ret void
;
top:
  %a_struct = load %pseudovec, %pseudovec* %a, align 4
  %a0 = extractvalue %pseudovec %a_struct, 0
  %a1 = extractvalue %pseudovec %a_struct, 1
  %b_struct = load %pseudovec, %pseudovec* %b, align 4
  %a2 = extractvalue %pseudovec %a_struct, 2
  %b0 = extractvalue %pseudovec %b_struct, 0
  %a3 = extractvalue %pseudovec %a_struct, 3
  %c0 = fsub float %a0, %b0
  %b1 = extractvalue %pseudovec %b_struct, 1
  %b2 = extractvalue %pseudovec %b_struct, 2
  %c1 = fsub float %a1, %b1
  %c_struct0 = insertvalue %pseudovec undef, float %c0, 0
  %b3 = extractvalue %pseudovec %b_struct, 3
  %c3 = fsub float %a3, %b3
  %c_struct1 = insertvalue %pseudovec %c_struct0, float %c1, 1
  %c2 = fsub float %a2, %b2
  %c_struct2 = insertvalue %pseudovec %c_struct1, float %c2, 2
  %c_struct3 = insertvalue %pseudovec %c_struct2, float %c3, 3
  store %pseudovec %c_struct3, %pseudovec* %c, align 4
  ret void
}
