; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare half @llvm.fabs.f16(half)
declare double @llvm.fabs.f64(double)
declare <2 x float> @llvm.fabs.v2f32(<2 x float>)
declare double @llvm.copysign.f64(double, double)
declare <2 x double> @llvm.copysign.v2f64(<2 x double>, <2 x double>)

define i1 @fpext_fpext(float %x, float %y) {
; CHECK-LABEL: @fpext_fpext(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ext1 = fpext float %x to double
  %ext2 = fpext float %y to double
  %cmp = fcmp nnan ogt double %ext1, %ext2
  ret i1 %cmp
}

define i1 @fpext_constant(float %a) {
; CHECK-LABEL: @fpext_constant(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt float [[A:%.*]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ext = fpext float %a to double
  %cmp = fcmp ninf ogt double %ext, 1.000000e+00
  ret i1 %cmp
}

define <2 x i1> @fpext_constant_vec_splat(<2 x half> %a) {
; CHECK-LABEL: @fpext_constant_vec_splat(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ole <2 x half> [[A:%.*]], <half 0xH5140, half 0xH5140>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %ext = fpext <2 x half> %a to <2 x double>
  %cmp = fcmp nnan ole <2 x double> %ext, <double 42.0, double 42.0>
  ret <2 x i1> %cmp
}

define i1 @fpext_constant_lossy(float %a) {
; CHECK-LABEL: @fpext_constant_lossy(
; CHECK-NEXT:    [[EXT:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt double [[EXT]], 0x3FF0000000000001
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ext = fpext float %a to double
  %cmp = fcmp ogt double %ext, 0x3FF0000000000001 ; more precision than float.
  ret i1 %cmp
}

define i1 @fpext_constant_denorm(float %a) {
; CHECK-LABEL: @fpext_constant_denorm(
; CHECK-NEXT:    [[EXT:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt double [[EXT]], 0x36A0000000000000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ext = fpext float %a to double
  %cmp = fcmp ogt double %ext, 0x36A0000000000000 ; denormal in float.
  ret i1 %cmp
}

define i1 @fneg_constant_swap_pred(float %x) {
; CHECK-LABEL: @fneg_constant_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg = fsub float -0.0, %x
  %cmp = fcmp ogt float %neg, 1.0
  ret i1 %cmp
}

define i1 @unary_fneg_constant_swap_pred(float %x) {
; CHECK-LABEL: @unary_fneg_constant_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg = fneg float %x
  %cmp = fcmp ogt float %neg, 1.0
  ret i1 %cmp
}

define <2 x i1> @fneg_constant_swap_pred_vec(<2 x float> %x) {
; CHECK-LABEL: @fneg_constant_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt <2 x float> [[X:%.*]], <float -1.000000e+00, float -2.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg = fsub <2 x float> <float -0.0, float -0.0>, %x
  %cmp = fcmp ogt <2 x float> %neg, <float 1.0, float 2.0>
  ret <2 x i1> %cmp
}

define <2 x i1> @unary_fneg_constant_swap_pred_vec(<2 x float> %x) {
; CHECK-LABEL: @unary_fneg_constant_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt <2 x float> [[X:%.*]], <float -1.000000e+00, float -2.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg = fneg <2 x float> %x
  %cmp = fcmp ogt <2 x float> %neg, <float 1.0, float 2.0>
  ret <2 x i1> %cmp
}

define <2 x i1> @fneg_constant_swap_pred_vec_undef(<2 x float> %x) {
; CHECK-LABEL: @fneg_constant_swap_pred_vec_undef(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt <2 x float> [[X:%.*]], <float -1.000000e+00, float -2.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg = fsub <2 x float> <float undef, float -0.0>, %x
  %cmp = fcmp ogt <2 x float> %neg, <float 1.0, float 2.0>
  ret <2 x i1> %cmp
}

; The new fcmp should have the same FMF as the original.

define i1 @fneg_fmf(float %x) {
; CHECK-LABEL: @fneg_fmf(
; CHECK-NEXT:    [[R:%.*]] = fcmp fast oeq float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    ret i1 [[R]]
;
  %n = fsub fast float -0.0, %x
  %r = fcmp fast oeq float %n, 42.0
  ret i1 %r
}

define i1 @unary_fneg_fmf(float %x) {
; CHECK-LABEL: @unary_fneg_fmf(
; CHECK-NEXT:    [[R:%.*]] = fcmp fast oeq float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    ret i1 [[R]]
;
  %n = fneg fast float %x
  %r = fcmp fast oeq float %n, 42.0
  ret i1 %r
}

; The new fcmp should have the same FMF as the original, vector edition.

define <2 x i1> @fcmp_fneg_fmf_vec(<2 x float> %x) {
; CHECK-LABEL: @fcmp_fneg_fmf_vec(
; CHECK-NEXT:    [[R:%.*]] = fcmp reassoc nnan ule <2 x float> [[X:%.*]], <float -4.200000e+01, float 1.900000e+01>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %n = fsub nsz <2 x float> zeroinitializer, %x
  %r = fcmp nnan reassoc uge <2 x float> %n, <float 42.0, float -19.0>
  ret <2 x i1> %r
}

define i1 @fneg_fneg_swap_pred(float %x, float %y) {
; CHECK-LABEL: @fneg_fneg_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg1 = fsub float -0.0, %x
  %neg2 = fsub float -0.0, %y
  %cmp = fcmp nnan olt float %neg1, %neg2
  ret i1 %cmp
}

define i1 @unary_fneg_unary_fneg_swap_pred(float %x, float %y) {
; CHECK-LABEL: @unary_fneg_unary_fneg_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg1 = fneg float %x
  %neg2 = fneg float %y
  %cmp = fcmp nnan olt float %neg1, %neg2
  ret i1 %cmp
}

define i1 @unary_fneg_fneg_swap_pred(float %x, float %y) {
; CHECK-LABEL: @unary_fneg_fneg_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg1 = fneg float %x
  %neg2 = fsub float -0.0, %y
  %cmp = fcmp nnan olt float %neg1, %neg2
  ret i1 %cmp
}

define i1 @fneg_unary_fneg_swap_pred(float %x, float %y) {
; CHECK-LABEL: @fneg_unary_fneg_swap_pred(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ogt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg1 = fsub float -0.0, %x
  %neg2 = fneg float %y
  %cmp = fcmp nnan olt float %neg1, %neg2
  ret i1 %cmp
}

define <2 x i1> @fneg_fneg_swap_pred_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fneg_fneg_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fsub <2 x float> <float -0.0, float -0.0>, %x
  %neg2 = fsub <2 x float> <float -0.0, float -0.0>, %y
  %cmp = fcmp ninf olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @unary_fneg_unary_fneg_swap_pred_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @unary_fneg_unary_fneg_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fneg <2 x float> %x
  %neg2 = fneg <2 x float> %y
  %cmp = fcmp ninf olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @unary_fneg_fneg_swap_pred_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @unary_fneg_fneg_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fneg <2 x float> %x
  %neg2 = fsub <2 x float> <float -0.0, float -0.0>, %y
  %cmp = fcmp ninf olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @fneg_unary_fneg_swap_pred_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fneg_unary_fneg_swap_pred_vec(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fsub <2 x float> <float -0.0, float -0.0>, %x
  %neg2 = fneg <2 x float> %y
  %cmp = fcmp ninf olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @fneg_fneg_swap_pred_vec_undef(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fneg_fneg_swap_pred_vec_undef(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fsub <2 x float> <float -0.0, float undef>, %x
  %neg2 = fsub <2 x float> <float undef, float -0.0>, %y
  %cmp = fcmp olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @unary_fneg_fneg_swap_pred_vec_undef(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @unary_fneg_fneg_swap_pred_vec_undef(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fneg <2 x float> %x
  %neg2 = fsub <2 x float> <float undef, float -0.0>, %y
  %cmp = fcmp olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define <2 x i1> @fneg_unary_fneg_swap_pred_vec_undef(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fneg_unary_fneg_swap_pred_vec_undef(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %neg1 = fsub <2 x float> <float -0.0, float undef>, %x
  %neg2 = fneg <2 x float> %y
  %cmp = fcmp olt <2 x float> %neg1, %neg2
  ret <2 x i1> %cmp
}

define i1 @test7(float %x) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %ext = fpext float %x to ppc_fp128
  %cmp = fcmp ogt ppc_fp128 %ext, 0xM00000000000000000000000000000000
  ret i1 %cmp
}

define float @test8(float %x) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[CONV2:%.*]] = uitofp i1 [[CMP]] to float
; CHECK-NEXT:    ret float [[CONV2]]
;
  %conv = fpext float %x to double
  %cmp = fcmp olt double %conv, 0.000000e+00
  %conv1 = zext i1 %cmp to i32
  %conv2 = sitofp i32 %conv1 to float
  ret float %conv2
; Float comparison to zero shouldn't cast to double.
}

define i1 @fabs_uge(double %a) {
; CHECK-LABEL: @fabs_uge(
; CHECK-NEXT:    ret i1 true
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp uge double %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_olt(half %a) {
; CHECK-LABEL: @fabs_olt(
; CHECK-NEXT:    ret i1 false
;
  %call = call half @llvm.fabs.f16(half %a)
  %cmp = fcmp olt half %call, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_ole(<2 x float> %a) {
; CHECK-LABEL: @fabs_ole(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf oeq <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp ninf ole <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_ule(<2 x float> %a) {
; CHECK-LABEL: @fabs_ule(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf arcp ueq <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp ninf arcp ule <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @fabs_ogt(double %a) {
; CHECK-LABEL: @fabs_ogt(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp reassoc one double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp reassoc ogt double %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_ugt(double %a) {
; CHECK-LABEL: @fabs_ugt(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp reassoc ninf une double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp ninf reassoc ugt double %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_oge(double %a) {
; CHECK-LABEL: @fabs_oge(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp afn ord double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp afn oge double %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_ult(double %a) {
; CHECK-LABEL: @fabs_ult(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp reassoc arcp uno double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp reassoc arcp ult double %call, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_ult_nnan(<2 x float> %a) {
; CHECK-LABEL: @fabs_ult_nnan(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp nnan reassoc arcp ult <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

define i1 @fabs_une(half %a) {
; CHECK-LABEL: @fabs_une(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf une half [[A:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call half @llvm.fabs.f16(half %a)
  %cmp = fcmp ninf une half %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_oeq(double %a) {
; CHECK-LABEL: @fabs_oeq(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp reassoc ninf oeq double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp ninf reassoc oeq double %call, 0.0
  ret i1 %cmp
}

define i1 @fabs_one(double %a) {
; CHECK-LABEL: @fabs_one(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp fast one double [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp fast one double %call, 0.0
  ret i1 %cmp
}

define <2 x i1> @fabs_ueq(<2 x float> %a) {
; CHECK-LABEL: @fabs_ueq(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp arcp ueq <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp arcp ueq <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_ord(<2 x float> %a) {
; CHECK-LABEL: @fabs_ord(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp arcp ord <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp arcp ord <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

define <2 x i1> @fabs_uno(<2 x float> %a) {
; CHECK-LABEL: @fabs_uno(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp arcp uno <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x float> @llvm.fabs.v2f32(<2 x float> %a)
  %cmp = fcmp arcp uno <2 x float> %call, zeroinitializer
  ret <2 x i1> %cmp
}

; Don't crash.
define i32 @test17(double %a, double (double)* %p) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[CALL:%.*]] = tail call double [[P:%.*]](double [[A:%.*]])
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ueq double [[CALL]], 0.000000e+00
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[CONV]]
;
  %call = tail call double %p(double %a)
  %cmp = fcmp ueq double %call, 0.000000e+00
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Can fold fcmp with undef on one side by choosing NaN for the undef
define i32 @test18_undef_unordered(float %a) {
; CHECK-LABEL: @test18_undef_unordered(
; CHECK-NEXT:    ret i32 1
;
  %cmp = fcmp ueq float %a, undef
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}
; Can fold fcmp with undef on one side by choosing NaN for the undef
define i32 @test18_undef_ordered(float %a) {
; CHECK-LABEL: @test18_undef_ordered(
; CHECK-NEXT:    ret i32 0
;
  %cmp = fcmp oeq float %a, undef
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Can fold fcmp with undef on both side
;   fcmp u_pred undef, undef -> true
;   fcmp o_pred undef, undef -> false
; because whatever you choose for the first undef
; you can choose NaN for the other undef
define i1 @test19_undef_unordered() {
; CHECK-LABEL: @test19_undef_unordered(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ueq float undef, undef
  ret i1 %cmp
}

define i1 @test19_undef_ordered() {
; CHECK-LABEL: @test19_undef_ordered(
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp oeq float undef, undef
  ret i1 %cmp
}

; Can fold 1.0 / X < 0.0 --> X < 0 with ninf
define i1 @test20_recipX_olt_0(float %X) {
; CHECK-LABEL: @test20_recipX_olt_0(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf olt float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float 1.0, %X
  %cmp = fcmp ninf olt float %div, 0.0
  ret i1 %cmp
}

; Can fold -2.0 / X <= 0.0 --> X >= 0 with ninf
define i1 @test21_recipX_ole_0(float %X) {
; CHECK-LABEL: @test21_recipX_ole_0(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf oge float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float -2.0, %X
  %cmp = fcmp ninf ole float %div, 0.0
  ret i1 %cmp
}

; Can fold 2.0 / X > 0.0 --> X > 0 with ninf
define i1 @test22_recipX_ogt_0(float %X) {
; CHECK-LABEL: @test22_recipX_ogt_0(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float 2.0, %X
  %cmp = fcmp ninf ogt float %div, 0.0
  ret i1 %cmp
}

; Can fold -1.0 / X >= 0.0 --> X <= 0 with ninf
define i1 @test23_recipX_oge_0(float %X) {
; CHECK-LABEL: @test23_recipX_oge_0(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ole float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float -1.0, %X
  %cmp = fcmp ninf oge float %div, 0.0
  ret i1 %cmp
}

; Do not fold 1.0 / X > 0.0 when ninf is missing
define i1 @test24_recipX_noninf_cmp(float %X) {
; CHECK-LABEL: @test24_recipX_noninf_cmp(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv ninf float 2.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[DIV]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float 2.0, %X
  %cmp = fcmp ogt float %div, 0.0
  ret i1 %cmp
}

; Do not fold 1.0 / X > 0.0 when ninf is missing
define i1 @test25_recipX_noninf_div(float %X) {
; CHECK-LABEL: @test25_recipX_noninf_div(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv float 2.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ogt float [[DIV]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv float 2.0, %X
  %cmp = fcmp ninf ogt float %div, 0.0
  ret i1 %cmp
}

; Do not fold 1.0 / X > 0.0 with unordered predicates
define i1 @test26_recipX_unorderd(float %X) {
; CHECK-LABEL: @test26_recipX_unorderd(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv ninf float 2.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ugt float [[DIV]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %div = fdiv ninf float 2.0, %X
  %cmp = fcmp ninf ugt float %div, 0.0
  ret i1 %cmp
}

; Fold <-1.0, -1.0> / X > <-0.0, -0.0>
define <2 x i1> @test27_recipX_gt_vecsplat(<2 x float> %X) {
; CHECK-LABEL: @test27_recipX_gt_vecsplat(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf olt <2 x float> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %div = fdiv ninf <2 x float> <float -1.0, float -1.0>, %X
  %cmp = fcmp ninf ogt <2 x float> %div, <float -0.0, float -0.0>
  ret <2 x i1> %cmp
}

define i1 @is_signbit_set(double %x) {
; CHECK-LABEL: @is_signbit_set(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast double [[X:%.*]] to i64
; CHECK-NEXT:    [[R:%.*]] = icmp slt i64 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 1.0, double %x)
  %r = fcmp olt double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_set_1(double %x) {
; CHECK-LABEL: @is_signbit_set_1(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 1.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ult double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 1.0, double %x)
  %r = fcmp ult double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_set_2(double %x) {
; CHECK-LABEL: @is_signbit_set_2(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 1.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ole double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 1.0, double %x)
  %r = fcmp ole double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_set_3(double %x) {
; CHECK-LABEL: @is_signbit_set_3(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 1.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ule double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 1.0, double %x)
  %r = fcmp ule double %s, 0.0
  ret i1 %r
}

; Vectors are ok; the sign of zero in the compare doesn't matter; the copysign constant can be any non-zero number.

define <2 x i1> @is_signbit_set_anyzero(<2 x double> %x) {
; CHECK-LABEL: @is_signbit_set_anyzero(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x double> [[X:%.*]] to <2 x i64>
; CHECK-NEXT:    [[R:%.*]] = icmp slt <2 x i64> [[TMP1]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %s = call <2 x double> @llvm.copysign.v2f64(<2 x double> <double 42.0, double 42.0>, <2 x double> %x)
  %r = fcmp olt <2 x double> %s, <double -0.0, double 0.0>
  ret <2 x i1> %r
}

; TODO: Handle different predicates.

define i1 @is_signbit_clear(double %x) {
; CHECK-LABEL: @is_signbit_clear(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double -4.200000e+01, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ogt double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double -42.0, double %x)
  %r = fcmp ogt double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_clear_1(double %x) {
; CHECK-LABEL: @is_signbit_clear_1(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double -4.200000e+01, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ugt double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double -42.0, double %x)
  %r = fcmp ugt double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_clear_2(double %x) {
; CHECK-LABEL: @is_signbit_clear_2(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double -4.200000e+01, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp oge double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double -42.0, double %x)
  %r = fcmp oge double %s, 0.0
  ret i1 %r
}

define i1 @is_signbit_clear_3(double %x) {
; CHECK-LABEL: @is_signbit_clear_3(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double -4.200000e+01, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp uge double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double -42.0, double %x)
  %r = fcmp uge double %s, 0.0
  ret i1 %r
}

; Negative test - uses

define i1 @is_signbit_set_extra_use(double %x, double* %p) {
; CHECK-LABEL: @is_signbit_set_extra_use(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 1.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    store double [[S]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = fcmp olt double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 1.0, double %x)
  store double %s, double* %p
  %r = fcmp olt double %s, 0.0
  ret i1 %r
}

; TODO: Handle non-zero compare constant.

define i1 @is_signbit_clear_nonzero(double %x) {
; CHECK-LABEL: @is_signbit_clear_nonzero(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double -4.200000e+01, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ogt double [[S]], 1.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double -42.0, double %x)
  %r = fcmp ogt double %s, 1.0
  ret i1 %r
}

; TODO: Handle zero copysign constant.

define i1 @is_signbit_set_simplify_zero(double %x) {
; CHECK-LABEL: @is_signbit_set_simplify_zero(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 0.000000e+00, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ogt double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 0.0, double %x)
  %r = fcmp ogt double %s, 0.0
  ret i1 %r
}

; TODO: Handle NaN copysign constant.

define i1 @is_signbit_set_simplify_nan(double %x) {
; CHECK-LABEL: @is_signbit_set_simplify_nan(
; CHECK-NEXT:    [[S:%.*]] = call double @llvm.copysign.f64(double 0xFFFFFFFFFFFFFFFF, double [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fcmp ogt double [[S]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %s = call double @llvm.copysign.f64(double 0xffffffffffffffff, double %x)
  %r = fcmp ogt double %s, 0.0
  ret i1 %r
}

define <2 x i1> @lossy_oeq(<2 x float> %x) {
; CHECK-LABEL: @lossy_oeq(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %e = fpext <2 x float> %x to <2 x double>
  %r = fcmp oeq <2 x double> %e, <double 0.1, double 0.1>
  ret <2 x i1> %r
}

define i1 @lossy_one(float %x, double* %p) {
; CHECK-LABEL: @lossy_one(
; CHECK-NEXT:    [[E:%.*]] = fpext float [[X:%.*]] to double
; CHECK-NEXT:    store double [[E]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = fcmp ord float [[X]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext float %x to double
  store double %e, double* %p
  %r = fcmp one double %e, 0.1
  ret i1 %r
}

define i1 @lossy_ueq(half %x) {
; CHECK-LABEL: @lossy_ueq(
; CHECK-NEXT:    [[R:%.*]] = fcmp uno half [[X:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to double
  %r = fcmp ueq double %e, 65536.0
  ret i1 %r
}

define i1 @lossy_une(half %x) {
; CHECK-LABEL: @lossy_une(
; CHECK-NEXT:    ret i1 true
;
  %e = fpext half %x to float
  %r = fcmp une float %e, 2049.0
  ret i1 %r
}

define <2 x i1> @lossy_ogt(<2 x float> %x) {
; CHECK-LABEL: @lossy_ogt(
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x float> [[X:%.*]] to <2 x double>
; CHECK-NEXT:    [[R:%.*]] = fcmp ogt <2 x double> [[E]], <double 1.000000e-01, double 1.000000e-01>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %e = fpext <2 x float> %x to <2 x double>
  %r = fcmp ogt <2 x double> %e, <double 0.1, double 0.1>
  ret <2 x i1> %r
}

define i1 @lossy_oge(float %x, double* %p) {
; CHECK-LABEL: @lossy_oge(
; CHECK-NEXT:    [[E:%.*]] = fpext float [[X:%.*]] to double
; CHECK-NEXT:    store double [[E]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = fcmp oge double [[E]], 1.000000e-01
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext float %x to double
  store double %e, double* %p
  %r = fcmp oge double %e, 0.1
  ret i1 %r
}

define i1 @lossy_olt(half %x) {
; CHECK-LABEL: @lossy_olt(
; CHECK-NEXT:    [[E:%.*]] = fpext half [[X:%.*]] to double
; CHECK-NEXT:    [[R:%.*]] = fcmp olt double [[E]], 6.553600e+04
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to double
  %r = fcmp olt double %e, 65536.0
  ret i1 %r
}

define i1 @lossy_ole(half %x) {
; CHECK-LABEL: @lossy_ole(
; CHECK-NEXT:    [[E:%.*]] = fpext half [[X:%.*]] to float
; CHECK-NEXT:    [[R:%.*]] = fcmp ole float [[E]], 2.049000e+03
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to float
  %r = fcmp ole float %e, 2049.0
  ret i1 %r
}

define <2 x i1> @lossy_ugt(<2 x float> %x) {
; CHECK-LABEL: @lossy_ugt(
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x float> [[X:%.*]] to <2 x double>
; CHECK-NEXT:    [[R:%.*]] = fcmp ugt <2 x double> [[E]], <double 1.000000e-01, double 1.000000e-01>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %e = fpext <2 x float> %x to <2 x double>
  %r = fcmp ugt <2 x double> %e, <double 0.1, double 0.1>
  ret <2 x i1> %r
}

define i1 @lossy_uge(float %x, double* %p) {
; CHECK-LABEL: @lossy_uge(
; CHECK-NEXT:    [[E:%.*]] = fpext float [[X:%.*]] to double
; CHECK-NEXT:    store double [[E]], double* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = fcmp uge double [[E]], 1.000000e-01
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext float %x to double
  store double %e, double* %p
  %r = fcmp uge double %e, 0.1
  ret i1 %r
}

define i1 @lossy_ult(half %x) {
; CHECK-LABEL: @lossy_ult(
; CHECK-NEXT:    [[E:%.*]] = fpext half [[X:%.*]] to double
; CHECK-NEXT:    [[R:%.*]] = fcmp ult double [[E]], 6.553600e+04
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to double
  %r = fcmp ult double %e, 65536.0
  ret i1 %r
}

define i1 @lossy_ule(half %x) {
; CHECK-LABEL: @lossy_ule(
; CHECK-NEXT:    [[E:%.*]] = fpext half [[X:%.*]] to float
; CHECK-NEXT:    [[R:%.*]] = fcmp ule float [[E]], 2.049000e+03
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to float
  %r = fcmp ule float %e, 2049.0
  ret i1 %r
}

define i1 @lossy_ord(half %x) {
; CHECK-LABEL: @lossy_ord(
; CHECK-NEXT:    [[R:%.*]] = fcmp ord half [[X:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to double
  %r = fcmp ord double %e, 65536.0
  ret i1 %r
}

define i1 @lossy_uno(half %x) {
; CHECK-LABEL: @lossy_uno(
; CHECK-NEXT:    [[R:%.*]] = fcmp uno half [[X:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[R]]
;
  %e = fpext half %x to float
  %r = fcmp uno float %e, 2049.0
  ret i1 %r
}

define i1 @fneg_oeq(float %a) {
; CHECK-LABEL: @fneg_oeq(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp oeq float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ogt(half %a) {
; CHECK-LABEL: @fneg_ogt(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp fast olt half [[A:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg half %a
  %cmp = fcmp fast ogt half %fneg, %a
  ret i1 %cmp
}

define <2 x i1> @fneg_oge(<2 x float> %a) {
; CHECK-LABEL: @fneg_oge(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ole <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %fneg = fneg fast <2 x float> %a
  %cmp = fcmp oge <2 x float> %fneg, %a
  ret <2 x i1> %cmp
}

define i1 @fneg_olt(float %a, float* %q) {
; CHECK-LABEL: @fneg_olt(
; CHECK-NEXT:    [[FNEG:%.*]] = fneg float [[A:%.*]]
; CHECK-NEXT:    store float [[FNEG]], float* [[Q:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  store float %fneg, float* %q
  %cmp = fcmp olt float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ole(float %a) {
; CHECK-LABEL: @fneg_ole(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nsz oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp nsz ole float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_one(float %a) {
; CHECK-LABEL: @fneg_one(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan one float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp nnan one float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ord(float %a) {
; CHECK-LABEL: @fneg_ord(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ord float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp ninf ord float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_uno(float %a) {
; CHECK-LABEL: @fneg_uno(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uno float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp uno float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ueq(half %a) {
; CHECK-LABEL: @fneg_ueq(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp fast ueq half [[A:%.*]], 0xH0000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg half %a
  %cmp = fcmp fast ueq half %fneg, %a
  ret i1 %cmp
}

define <2 x i1> @fneg_ugt(<2 x float> %a) {
; CHECK-LABEL: @fneg_ugt(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ult <2 x float> [[A:%.*]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %fneg = fneg fast <2 x float> %a
  %cmp = fcmp ugt <2 x float> %fneg, %a
  ret <2 x i1> %cmp
}

define i1 @fneg_uge(float %a, float* %q) {
; CHECK-LABEL: @fneg_uge(
; CHECK-NEXT:    [[FNEG:%.*]] = fneg float [[A:%.*]]
; CHECK-NEXT:    store float [[FNEG]], float* [[Q:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ule float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  store float %fneg, float* %q
  %cmp = fcmp uge float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ult(float %a) {
; CHECK-LABEL: @fneg_ult(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nsz ugt float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp nsz ult float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_ule(float %a) {
; CHECK-LABEL: @fneg_ule(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan uge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp nnan ule float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_une(float %a) {
; CHECK-LABEL: @fneg_une(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf une float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %fneg = fneg float %a
  %cmp = fcmp ninf une float %fneg, %a
  ret i1 %cmp
}

define i1 @fneg_oeq_swap(float %p) {
; CHECK-LABEL: @fneg_oeq_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp oeq float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ogt_swap(half %p) {
; CHECK-LABEL: @fneg_ogt_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd half [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp fast ogt half [[A]], 0xH0000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd half %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg half %a
  %cmp = fcmp fast ogt half %a, %fneg
  ret i1 %cmp
}

define <2 x i1> @fneg_oge_swap(<2 x float> %p) {
; CHECK-LABEL: @fneg_oge_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd <2 x float> [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oge <2 x float> [[A]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %a = fadd <2 x float> %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg fast <2 x float> %a
  %cmp = fcmp oge <2 x float> %a, %fneg
  ret <2 x i1> %cmp
}

define i1 @fneg_olt_swap(float %p, float* %q) {
; CHECK-LABEL: @fneg_olt_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[FNEG:%.*]] = fneg float [[A]]
; CHECK-NEXT:    store float [[FNEG]], float* [[Q:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  store float %fneg, float* %q
  %cmp = fcmp olt float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ole_swap(float %p) {
; CHECK-LABEL: @fneg_ole_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nsz ole float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp nsz ole float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_one_swap(float %p) {
; CHECK-LABEL: @fneg_one_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan one float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp nnan one float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ord_swap(float %p) {
; CHECK-LABEL: @fneg_ord_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf ord float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp ninf ord float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_uno_swap(float %p) {
; CHECK-LABEL: @fneg_uno_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uno float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp uno float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ueq_swap(half %p) {
; CHECK-LABEL: @fneg_ueq_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd half [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp fast ueq half [[A]], 0xH0000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd half %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg half %a
  %cmp = fcmp fast ueq half %a, %fneg
  ret i1 %cmp
}

define <2 x i1> @fneg_ugt_swap(<2 x float> %p) {
; CHECK-LABEL: @fneg_ugt_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd <2 x float> [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ugt <2 x float> [[A]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %a = fadd <2 x float> %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg fast <2 x float> %a
  %cmp = fcmp ugt <2 x float> %a, %fneg
  ret <2 x i1> %cmp
}

define i1 @fneg_uge_swap(float %p, float* %q) {
; CHECK-LABEL: @fneg_uge_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[FNEG:%.*]] = fneg float [[A]]
; CHECK-NEXT:    store float [[FNEG]], float* [[Q:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uge float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  store float %fneg, float* %q
  %cmp = fcmp uge float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ult_swap(float %p) {
; CHECK-LABEL: @fneg_ult_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nsz ult float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp nsz ult float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_ule_swap(float %p) {
; CHECK-LABEL: @fneg_ule_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp nnan ule float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp nnan ule float %a, %fneg
  ret i1 %cmp
}

define i1 @fneg_une_swap(float %p) {
; CHECK-LABEL: @fneg_une_swap(
; CHECK-NEXT:    [[A:%.*]] = fadd float [[P:%.*]], [[P]]
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ninf une float [[A]], 0.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %a = fadd float %p, %p ; thwart complexity-based canonicalization
  %fneg = fneg float %a
  %cmp = fcmp ninf une float %a, %fneg
  ret i1 %cmp
}
