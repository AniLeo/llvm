; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64-unknown-linux-gnu
; RUN: llc -verify-machineinstrs < %s -mtriple=powerpc64le-unknown-linux-gnu

%class.Point.1 = type { %class.Tensor.0 }
%class.Tensor.0 = type { [3 x double] }
%class.TriaObjectAccessor.57 = type { %class.TriaAccessor.56 }
%class.TriaAccessor.56 = type { i32, i32, %class.Triangulation.55* }
%class.Triangulation.55 = type { %class.Subscriptor, %"class.std::vector.46", %"class.std::vector", %"class.std::vector.3.8", [255 x %class.Boundary.50*], i32, %struct.TriaNumberCache.54 }
%class.Subscriptor = type { i32 (...)**, i32, %"class.std::type_info.2"* }
%"class.std::type_info.2" = type { i32 (...)**, i8* }
%"class.std::vector.46" = type { %"struct.std::_Vector_base.45" }
%"struct.std::_Vector_base.45" = type { %"struct.std::_Vector_base<TriangulationLevel<3> *, std::allocator<TriangulationLevel<3> *> >::_Vector_impl.44" }
%"struct.std::_Vector_base<TriangulationLevel<3> *, std::allocator<TriangulationLevel<3> *> >::_Vector_impl.44" = type { %class.TriangulationLevel.43**, %class.TriangulationLevel.43**, %class.TriangulationLevel.43** }
%class.TriangulationLevel.43 = type { %class.TriangulationLevel.0.37, %"struct.TriangulationLevel<3>::HexesData.42" }
%class.TriangulationLevel.0.37 = type { %class.TriangulationLevel.1.31, %"struct.TriangulationLevel<2>::QuadsData.36" }
%class.TriangulationLevel.1.31 = type { %class.TriangulationLevel, %"struct.TriangulationLevel<1>::LinesData.30" }
%class.TriangulationLevel = type { %"class.std::vector.3.8", %"class.std::vector.3.8", %"class.std::vector.7.12", %"class.std::vector.12.15" }
%"class.std::vector.7.12" = type { %"struct.std::_Vector_base" }
%"struct.std::_Vector_base" = type { %"struct.std::_Vector_base<std::pair<int, int>, std::allocator<std::pair<int, int> > >::_Vector_impl.10" }
%"struct.std::_Vector_base<std::pair<int, int>, std::allocator<std::pair<int, int> > >::_Vector_impl.10" = type { %"struct.std::pair.9"*, %"struct.std::pair.9"*, %"struct.std::pair.9"* }
%"struct.std::pair.9" = type opaque
%"class.std::vector.12.15" = type { %"struct.std::_Vector_base.13.14" }
%"struct.std::_Vector_base.13.14" = type { %"struct.std::_Vector_base<unsigned int, std::allocator<unsigned int> >::_Vector_impl.13" }
%"struct.std::_Vector_base<unsigned int, std::allocator<unsigned int> >::_Vector_impl.13" = type { i32*, i32*, i32* }
%"struct.TriangulationLevel<1>::LinesData.30" = type { %"class.std::vector.17.20", %"class.std::vector.22.23", %"class.std::vector.3.8", %"class.std::vector.3.8", %"class.std::vector.27.26", %"class.std::vector.32.29" }
%"class.std::vector.17.20" = type { %"struct.std::_Vector_base.18.19" }
%"struct.std::_Vector_base.18.19" = type { %"struct.std::_Vector_base<Line, std::allocator<Line> >::_Vector_impl.18" }
%"struct.std::_Vector_base<Line, std::allocator<Line> >::_Vector_impl.18" = type { %class.Line.17*, %class.Line.17*, %class.Line.17* }
%class.Line.17 = type { [2 x i32] }
%"class.std::vector.22.23" = type { %"struct.std::_Vector_base.23.22" }
%"struct.std::_Vector_base.23.22" = type { %"struct.std::_Vector_base<int, std::allocator<int> >::_Vector_impl.21" }
%"struct.std::_Vector_base<int, std::allocator<int> >::_Vector_impl.21" = type { i32*, i32*, i32* }
%"class.std::vector.27.26" = type { %"struct.std::_Vector_base.28.25" }
%"struct.std::_Vector_base.28.25" = type { %"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char> >::_Vector_impl.24" }
%"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char> >::_Vector_impl.24" = type { i8*, i8*, i8* }
%"class.std::vector.32.29" = type { %"struct.std::_Vector_base.33.28" }
%"struct.std::_Vector_base.33.28" = type { %"struct.std::_Vector_base<void *, std::allocator<void *> >::_Vector_impl.27" }
%"struct.std::_Vector_base<void *, std::allocator<void *> >::_Vector_impl.27" = type { i8**, i8**, i8** }
%"struct.TriangulationLevel<2>::QuadsData.36" = type { %"class.std::vector.37.35", %"class.std::vector.22.23", %"class.std::vector.3.8", %"class.std::vector.3.8", %"class.std::vector.27.26", %"class.std::vector.32.29" }
%"class.std::vector.37.35" = type { %"struct.std::_Vector_base.38.34" }
%"struct.std::_Vector_base.38.34" = type { %"struct.std::_Vector_base<Quad, std::allocator<Quad> >::_Vector_impl.33" }
%"struct.std::_Vector_base<Quad, std::allocator<Quad> >::_Vector_impl.33" = type { %class.Quad.32*, %class.Quad.32*, %class.Quad.32* }
%class.Quad.32 = type { [4 x i32] }
%"struct.TriangulationLevel<3>::HexesData.42" = type { %"class.std::vector.42.41", %"class.std::vector.22.23", %"class.std::vector.3.8", %"class.std::vector.3.8", %"class.std::vector.27.26", %"class.std::vector.32.29", %"class.std::vector.3.8" }
%"class.std::vector.42.41" = type { %"struct.std::_Vector_base.43.40" }
%"struct.std::_Vector_base.43.40" = type { %"struct.std::_Vector_base<Hexahedron, std::allocator<Hexahedron> >::_Vector_impl.39" }
%"struct.std::_Vector_base<Hexahedron, std::allocator<Hexahedron> >::_Vector_impl.39" = type { %class.Hexahedron.38*, %class.Hexahedron.38*, %class.Hexahedron.38* }
%class.Hexahedron.38= type { [6 x i32] }
%"class.std::vector" = type { %"struct.std::_Vector_base.48.48" }
%"struct.std::_Vector_base.48.48" = type { %"struct.std::_Vector_base<Point<3>, std::allocator<Point<3> > >::_Vector_impl.47" }
%"struct.std::_Vector_base<Point<3>, std::allocator<Point<3> > >::_Vector_impl.47" = type { %class.Point.1*, %class.Point.1*, %class.Point.1* }
%"class.std::vector.3.8" = type { %"struct.std::_Bvector_base.7" }
%"struct.std::_Bvector_base.7" = type { %"struct.std::_Bvector_base<std::allocator<bool> >::_Bvector_impl.6" }
%"struct.std::_Bvector_base<std::allocator<bool> >::_Bvector_impl.6" = type { %"struct.std::_Bit_iterator.5", %"struct.std::_Bit_iterator.5", i64* }
%"struct.std::_Bit_iterator.5" = type { %"struct.std::_Bit_iterator_base.base.4", [4 x i8] }
%"struct.std::_Bit_iterator_base.base.4" = type <{ i64*, i32 }>
%class.Boundary.50 = type opaque
%struct.TriaNumberCache.54 = type { %struct.TriaNumberCache.52.52, i32, %"class.std::vector.12.15", i32, %"class.std::vector.12.15" }
%struct.TriaNumberCache.52.52 = type { %struct.TriaNumberCache.53.51, i32, %"class.std::vector.12.15", i32, %"class.std::vector.12.15" }
%struct.TriaNumberCache.53.51 = type { i32, %"class.std::vector.12.15", i32, %"class.std::vector.12.15" }

define void @_ZNK18TriaObjectAccessorILi3ELi3EE10barycenterEv(%class.Point.1* noalias nocapture sret %agg.result, %class.TriaObjectAccessor.57* %this) #0 align 2 {
entry:
  %0 = load double, double* null, align 8
  %1 = load double, double* undef, align 8
  %call18 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 6)
  %2 = load double, double* undef, align 8
  %call21 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 7)
  %3 = load double, double* undef, align 8
  %call33 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 3)
  %4 = load double, double* null, align 8
  %5 = load double, double* undef, align 8
  %call45 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 7)
  %6 = load double, double* undef, align 8
  %call48 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 0)
  %7 = load double, double* undef, align 8
  %call66 = tail call dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57* %this, i32 zeroext 6)
  %8 = load double, double* undef, align 8
  %mul334 = fmul double undef, 2.000000e+00
  %mul579 = fmul double %2, %5
  %mul597 = fmul double undef, %mul579
  %mul679 = fmul double %2, %8
  %mul1307 = fmul double undef, %1
  %mul2092 = fmul double undef, %4
  %mul2679 = fmul double undef, undef
  %mul2931 = fmul double undef, %3
  %mul3094 = fmul double undef, %3
  %mul3096 = fmul double %mul3094, %8
  %sub3097 = fsub double 0.000000e+00, %mul3096
  %add3105 = fadd double undef, %sub3097
  %add3113 = fadd double 0.000000e+00, %add3105
  %sub3121 = fsub double %add3113, undef
  %sub3129 = fsub double %sub3121, undef
  %add3137 = fadd double undef, %sub3129
  %add3145 = fadd double undef, %add3137
  %sub3153 = fsub double %add3145, undef
  %sub3162 = fsub double %sub3153, 0.000000e+00
  %add3171 = fadd double undef, %sub3162
  %add3180 = fadd double undef, %add3171
  %add3189 = fadd double 0.000000e+00, %add3180
  %mul3197 = fmul double %4, %mul2679
  %sub3198 = fsub double %add3189, %mul3197
  %sub3207 = fsub double %sub3198, 0.000000e+00
  %mul3212 = fmul double %2, undef
  %mul3214 = fmul double %mul3212, undef
  %sub3215 = fsub double %sub3207, %mul3214
  %mul3222 = fmul double %5, 0.000000e+00
  %sub3223 = fsub double %sub3215, %mul3222
  %mul3228 = fmul double %2, undef
  %mul3230 = fmul double %3, %mul3228
  %add3231 = fadd double %mul3230, %sub3223
  %mul3236 = fmul double undef, undef
  %mul3238 = fmul double %mul3236, %8
  %add3239 = fadd double %mul3238, %add3231
  %mul3244 = fmul double %mul1307, %3
  %mul3246 = fmul double %mul3244, %7
  %sub3247 = fsub double %add3239, %mul3246
  %mul3252 = fmul double undef, undef
  %mul3254 = fmul double %mul3252, %7
  %add3255 = fadd double %mul3254, %sub3247
  %sub3263 = fsub double %add3255, undef
  %add3271 = fadd double 0.000000e+00, %sub3263
  %sub3279 = fsub double %add3271, undef
  %sub3287 = fsub double %sub3279, undef
  %mul3292 = fmul double %mul1307, %5
  %mul3294 = fmul double %mul3292, undef
  %add3295 = fadd double %mul3294, %sub3287
  %add3303 = fadd double undef, %add3295
  %add3311 = fadd double 0.000000e+00, %add3303
  %mul3318 = fmul double undef, %7
  %sub3319 = fsub double %add3311, %mul3318
  %mul3326 = fmul double %4, %mul3228
  %sub3327 = fsub double %sub3319, %mul3326
  %mul3334 = fmul double undef, %8
  %sub3335 = fsub double %sub3327, %mul3334
  %add3343 = fadd double undef, %sub3335
  %mul3350 = fmul double %mul3212, %7
  %add3351 = fadd double %mul3350, %add3343
  %mul3358 = fmul double %mul2092, undef
  %sub3359 = fsub double %add3351, %mul3358
  %mul3362 = fmul double undef, %1
  %mul3366 = fmul double 0.000000e+00, %8
  %add3367 = fadd double %mul3366, %sub3359
  %mul3372 = fmul double %mul3362, %5
  %sub3375 = fsub double %add3367, undef
  %add3383 = fadd double undef, %sub3375
  %mul3389 = fmul double %2, 0.000000e+00
  %mul3391 = fmul double %4, %mul3389
  %sub3392 = fsub double %add3383, %mul3391
  %mul3396 = fmul double undef, 0.000000e+00
  %mul3400 = fmul double undef, %7
  %sub3401 = fsub double %sub3392, %mul3400
  %mul3407 = fmul double %mul3396, %4
  %mul3409 = fmul double %mul3407, %8
  %add3410 = fadd double %mul3409, %sub3401
  %add3419 = fadd double undef, %add3410
  %mul3423 = fmul double undef, %mul334
  %add3428 = fadd double undef, %add3419
  %add3437 = fadd double undef, %add3428
  %mul3443 = fmul double %mul3423, %3
  %mul3445 = fmul double %mul3443, %8
  %sub3446 = fsub double %add3437, %mul3445
  %mul3453 = fmul double %mul3372, undef
  %add3454 = fadd double %mul3453, %sub3446
  %add3462 = fadd double 0.000000e+00, %add3454
  %mul3467 = fmul double %mul3362, %3
  %mul3469 = fmul double %mul3467, %8
  %sub3470 = fsub double %add3462, %mul3469
  %add3478 = fadd double 0.000000e+00, %sub3470
  %sub3486 = fsub double %add3478, undef
  %mul3490 = fmul double %mul334, 0.000000e+00
  %mul3492 = fmul double %2, %mul3490
  %mul3494 = fmul double %mul3492, undef
  %sub3495 = fsub double %sub3486, %mul3494
  %sub3503 = fsub double %sub3495, undef
  %sub3512 = fsub double %sub3503, undef
  %add3520 = fadd double undef, %sub3512
  %sub3528 = fsub double %add3520, undef
  %add3537 = fadd double undef, %sub3528
  %add3545 = fadd double 0.000000e+00, %add3537
  %sub3553 = fsub double %add3545, undef
  %add3561 = fadd double undef, %sub3553
  %sub3569 = fsub double %add3561, undef
  %mul3574 = fmul double undef, undef
  %mul3576 = fmul double %mul3574, %7
  %add3577 = fadd double %mul3576, %sub3569
  %sub3585 = fsub double %add3577, undef
  %mul3592 = fmul double %4, undef
  %sub3593 = fsub double %sub3585, %mul3592
  %mul3598 = fmul double %2, undef
  %mul3600 = fmul double %mul3598, %7
  %add3601 = fadd double %mul3600, %sub3593
  %mul3608 = fmul double %mul3598, undef
  %sub3609 = fsub double %add3601, %mul3608
  %sub3618 = fsub double %sub3609, undef
  %add3627 = fadd double undef, %sub3618
  %add3635 = fadd double undef, %add3627
  %mul3638 = fmul double undef, %2
  %mul3640 = fmul double %mul3638, %5
  %mul3642 = fmul double %mul3640, %7
  %sub3643 = fsub double %add3635, %mul3642
  %mul3648 = fmul double %1, undef
  %mul3650 = fmul double %mul3648, %8
  %sub3651 = fsub double %sub3643, %mul3650
  %mul3656 = fmul double %mul3638, %4
  %mul3658 = fmul double %mul3656, %8
  %add3659 = fadd double %mul3658, %sub3651
  %mul3666 = fmul double %5, 0.000000e+00
  %add3667 = fadd double %mul3666, %add3659
  %sub3675 = fsub double %add3667, undef
  %mul3680 = fmul double %mul3638, %3
  %mul3682 = fmul double %mul3680, %8
  %sub3683 = fsub double %sub3675, %mul3682
  %add3692 = fadd double 0.000000e+00, %sub3683
  %mul3696 = fmul double undef, undef
  %mul3698 = fmul double %mul3696, %4
  %mul3700 = fmul double %mul3698, %8
  %add3701 = fadd double %mul3700, %add3692
  %sub3710 = fsub double %add3701, undef
  %mul3716 = fmul double undef, %3
  %mul3718 = fmul double %mul3716, %8
  %sub3719 = fsub double %sub3710, %mul3718
  %add3727 = fadd double undef, %sub3719
  %mul3734 = fmul double %mul3574, %8
  %add3735 = fadd double %mul3734, %add3727
  %sub3743 = fsub double %add3735, 0.000000e+00
  %add3751 = fadd double 0.000000e+00, %sub3743
  %mul3758 = fmul double %6, 0.000000e+00
  %sub3759 = fsub double %add3751, %mul3758
  %mul3764 = fmul double undef, %mul2931
  %mul3766 = fmul double %mul3764, undef
  %sub3767 = fsub double %sub3759, %mul3766
  %add3775 = fadd double 0.000000e+00, %sub3767
  %add3783 = fadd double undef, %add3775
  %sub3791 = fsub double %add3783, 0.000000e+00
  %add3799 = fadd double undef, %sub3791
  %sub3807 = fsub double %add3799, undef
  %mul3814 = fmul double 0.000000e+00, undef
  %add3815 = fadd double %mul3814, %sub3807
  %mul3822 = fmul double %mul597, undef
  %sub3823 = fsub double %add3815, %mul3822
  %add3831 = fadd double undef, %sub3823
  %mul3836 = fmul double undef, %mul679
  %mul3838 = fmul double %6, %mul3836
  %sub3839 = fsub double %add3831, %mul3838
  %add3847 = fadd double undef, %sub3839
  %add3855 = fadd double undef, %add3847
  %mul3858 = fmul double undef, %8
  %mul3860 = fmul double undef, %mul3858
  %mul3862 = fmul double %6, %mul3860
  %sub3863 = fsub double %add3855, %mul3862
  %add3872 = fadd double undef, %sub3863
  %sub3880 = fsub double %add3872, undef
  %sub3889 = fsub double %sub3880, undef
  %sub3898 = fsub double %sub3889, undef
  %add3907 = fadd double undef, %sub3898
  %sub3915 = fsub double %add3907, 0.000000e+00
  %add3923 = fadd double undef, %sub3915
  %mul3930 = fmul double %3, undef
  %add3931 = fadd double %mul3930, %add3923
  %add3940 = fadd double undef, %add3931
  %sub3949 = fsub double %add3940, undef
  %mul3952 = fmul double %2, %3
  %sub3957 = fsub double %sub3949, undef
  %sub3966 = fsub double %sub3957, undef
  %add3975 = fadd double undef, %sub3966
  %add3983 = fadd double undef, %add3975
  %sub3992 = fsub double %add3983, undef
  %mul3997 = fmul double undef, %mul3952
  %mul3999 = fmul double %mul3997, %8
  %add4000 = fadd double %mul3999, %sub3992
  %sub4008 = fsub double %add4000, undef
  %add4017 = fadd double undef, %sub4008
  %add4026 = fadd double 0.000000e+00, %add4017
  %mul4034 = fmul double %6, undef
  %sub4035 = fsub double %add4026, %mul4034
  %add4043 = fadd double undef, %sub4035
  %sub4051 = fsub double %add4043, 0.000000e+00
  %mul4916 = fmul double 0.000000e+00, %sub4051
  %mul4917 = fmul double %mul4916, 0x3FC5555555555555
  %mul7317 = fmul double 0.000000e+00, %3
  %mul7670 = fmul double %0, %mul7317
  %mul8882 = fmul double %0, 0.000000e+00
  %mul8884 = fmul double undef, %mul8882
  %sub8885 = fsub double 0.000000e+00, %mul8884
  %mul8892 = fmul double %mul7670, undef
  %add8893 = fadd double %mul8892, %sub8885
  %mul8900 = fmul double undef, undef
  %add8901 = fadd double %mul8900, %add8893
  %mul9767 = fmul double 0.000000e+00, %add8901
  %mul9768 = fmul double %mul9767, 0x3FC5555555555555
  store double %mul4917, double* undef, align 8
  store double %mul9768, double* undef, align 8
  ret void
}

declare dereferenceable(24) %class.Point.1* @_ZNK18TriaObjectAccessorILi3ELi3EE6vertexEj(%class.TriaObjectAccessor.57*, i32 zeroext) #0

