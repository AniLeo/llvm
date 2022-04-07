; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-linux-unknown | FileCheck %s


; Ensure we use a "vscale x 4" wide scatter for the maximum supported offset.
define void @scatter_i8_index_offset_maximum(i8* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i8> %data) #0 {
; CHECK-LABEL: scatter_i8_index_offset_maximum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #33554431
; CHECK-NEXT:    add x9, x0, x1
; CHECK-NEXT:    index z1.s, #0, w8
; CHECK-NEXT:    st1b { z0.s }, p0, [x9, z1.s, sxtw]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 33554431, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr i8, i8* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x i8*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure we use a "vscale x 4" wide scatter for the minimum supported offset.
define void @scatter_i16_index_offset_minimum(i16* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i16> %data) #0 {
; CHECK-LABEL: scatter_i16_index_offset_minimum:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-33554432
; CHECK-NEXT:    add x9, x0, x1, lsl #1
; CHECK-NEXT:    index z1.s, #0, w8
; CHECK-NEXT:    st1h { z0.s }, p0, [x9, z1.s, sxtw #1]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 -33554432, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr i16, i16* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> %data, <vscale x 4 x i16*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure we use a "vscale x 4" gather for an offset in the limits of 32 bits.
define <vscale x 4 x i8> @gather_i8_index_offset_8(i8* %base, i64 %offset, <vscale x 4 x i1> %pg) #0 {
; CHECK-LABEL: gather_i8_index_offset_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x0, x1
; CHECK-NEXT:    index z0.s, #0, #1
; CHECK-NEXT:    ld1b { z0.s }, p0/z, [x8, z0.s, sxtw]
; CHECK-NEXT:    ret
  %splat.insert0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %splat0 = shufflevector <vscale x 4 x i64> %splat.insert0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %splat.insert1 = insertelement <vscale x 4 x i64> undef, i64 1, i32 0
  %splat1 = shufflevector <vscale x 4 x i64> %splat.insert1, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t1 = mul <vscale x 4 x i64> %splat1, %step
  %t2 = add <vscale x 4 x i64> %splat0, %t1
  %t3 = getelementptr i8, i8* %base, <vscale x 4 x i64> %t2
  %load = call <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*> %t3, i32 4, <vscale x 4 x i1> %pg, <vscale x 4 x i8> undef)
   ret <vscale x 4 x i8> %load
}

;; Negative tests

; Ensure we don't use a "vscale x 4" scatter. Cannot prove that variable stride
; will not wrap when shrunk to be i32 based.
define void @scatter_f16_index_offset_var(half* %base, i64 %offset, i64 %scale, <vscale x 4 x i1> %pg, <vscale x 4 x half> %data) #0 {
; CHECK-LABEL: scatter_f16_index_offset_var:
; CHECK:       // %bb.0:
; CHECK-NEXT:    index z1.d, #0, #1
; CHECK-NEXT:    mov z3.d, x1
; CHECK-NEXT:    mov z2.d, z1.d
; CHECK-NEXT:    mov z4.d, z3.d
; CHECK-NEXT:    ptrue p1.d
; CHECK-NEXT:    incd z2.d
; CHECK-NEXT:    mla z3.d, p1/m, z1.d, z3.d
; CHECK-NEXT:    mla z4.d, p1/m, z2.d, z4.d
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    st1h { z1.d }, p1, [x0, z3.d, lsl #1]
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z4.d, lsl #1]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 %scale, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr half, half* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure we don't use a "vscale x 4" wide scatter when the offset is too big.
define void @scatter_i8_index_offset_maximum_plus_one(i8* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i8> %data) #0 {
; CHECK-LABEL: scatter_i8_index_offset_maximum_plus_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    mov w9, #67108864
; CHECK-NEXT:    lsr x8, x8, #4
; CHECK-NEXT:    mov z1.d, x1
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    mul x8, x8, x9
; CHECK-NEXT:    mov w9, #33554432
; CHECK-NEXT:    index z2.d, #0, x9
; CHECK-NEXT:    mov z3.d, x8
; CHECK-NEXT:    add z3.d, z2.d, z3.d
; CHECK-NEXT:    add z2.d, z2.d, z1.d
; CHECK-NEXT:    add z1.d, z3.d, z1.d
; CHECK-NEXT:    uunpklo z3.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    st1b { z3.d }, p1, [x0, z2.d]
; CHECK-NEXT:    st1b { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 33554432, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr i8, i8* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x i8*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure we don't use a "vscale x 4" wide scatter when the offset is too small.
define void @scatter_i8_index_offset_minimum_minus_one(i8* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i8> %data) #0 {
; CHECK-LABEL: scatter_i8_index_offset_minimum_minus_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    mov x9, #-2
; CHECK-NEXT:    lsr x8, x8, #4
; CHECK-NEXT:    movk x9, #64511, lsl #16
; CHECK-NEXT:    mov z1.d, x1
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    mul x8, x8, x9
; CHECK-NEXT:    mov x9, #-33554433
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    index z2.d, #0, x9
; CHECK-NEXT:    mov z3.d, x8
; CHECK-NEXT:    add z3.d, z2.d, z3.d
; CHECK-NEXT:    add z2.d, z2.d, z1.d
; CHECK-NEXT:    add z1.d, z3.d, z1.d
; CHECK-NEXT:    uunpklo z3.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    st1b { z3.d }, p1, [x0, z2.d]
; CHECK-NEXT:    st1b { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 -33554433, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr i8, i8* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x i8*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure we don't use a "vscale x 4" wide scatter when the stride is too big .
define void @scatter_i8_index_stride_too_big(i8* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i8> %data) #0 {
; CHECK-LABEL: scatter_i8_index_stride_too_big:
; CHECK:       // %bb.0:
; CHECK-NEXT:    rdvl x8, #1
; CHECK-NEXT:    mov x9, #-9223372036854775808
; CHECK-NEXT:    lsr x8, x8, #4
; CHECK-NEXT:    mov z1.d, x1
; CHECK-NEXT:    punpklo p1.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    mul x8, x8, x9
; CHECK-NEXT:    mov x9, #4611686018427387904
; CHECK-NEXT:    index z2.d, #0, x9
; CHECK-NEXT:    mov z3.d, x8
; CHECK-NEXT:    add z3.d, z2.d, z3.d
; CHECK-NEXT:    add z2.d, z2.d, z1.d
; CHECK-NEXT:    add z1.d, z3.d, z1.d
; CHECK-NEXT:    uunpklo z3.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    st1b { z3.d }, p1, [x0, z2.d]
; CHECK-NEXT:    st1b { z0.d }, p0, [x0, z1.d]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %t2 = insertelement <vscale x 4 x i64> undef, i64 4611686018427387904, i32 0
  %t3 = shufflevector <vscale x 4 x i64> %t2, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t4 = mul <vscale x 4 x i64> %t3, %step
  %t5 = add <vscale x 4 x i64> %t1, %t4
  %t6 = getelementptr i8, i8* %base, <vscale x 4 x i64> %t5
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x i8*> %t6, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure the resulting load is "vscale x 4" wide, despite the offset giving the
; impression the gather must be split due to it's <vscale x 4 x i64> offset.
; gather_f32(base, index(offset, 8 * sizeof(float))
define <vscale x 4 x i8> @gather_8i8_index_offset_8([8 x i8]* %base, i64 %offset, <vscale x 4 x i1> %pg) #0 {
; CHECK-LABEL: gather_8i8_index_offset_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x0, x1, lsl #3
; CHECK-NEXT:    index z0.s, #0, #8
; CHECK-NEXT:    ld1b { z0.s }, p0/z, [x8, z0.s, sxtw]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t2 = add <vscale x 4 x i64> %t1, %step
  %t3 = getelementptr [8 x i8], [8 x i8]* %base, <vscale x 4 x i64> %t2
  %t4 = bitcast <vscale x 4 x [8 x i8]*> %t3 to <vscale x 4 x i8*>
  %load = call <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*> %t4, i32 4, <vscale x 4 x i1> %pg, <vscale x 4 x i8> undef)
  ret <vscale x 4 x i8> %load
}

; Ensure the resulting load is "vscale x 4" wide, despite the offset giving the
; impression the gather must be split due to it's <vscale x 4 x i64> offset.
; gather_f32(base, index(offset, 8 * sizeof(float))
define <vscale x 4 x float> @gather_f32_index_offset_8([8 x float]* %base, i64 %offset, <vscale x 4 x i1> %pg) #0 {
; CHECK-LABEL: gather_f32_index_offset_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #32
; CHECK-NEXT:    add x9, x0, x1, lsl #5
; CHECK-NEXT:    index z0.s, #0, w8
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x9, z0.s, sxtw]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t2 = add <vscale x 4 x i64> %t1, %step
  %t3 = getelementptr [8 x float], [8 x float]* %base, <vscale x 4 x i64> %t2
  %t4 = bitcast <vscale x 4 x [8 x float]*> %t3 to <vscale x 4 x float*>
  %load = call <vscale x 4 x float> @llvm.masked.gather.nxv4f32(<vscale x 4 x float*> %t4, i32 4, <vscale x 4 x i1> %pg, <vscale x 4 x float> undef)
  ret <vscale x 4 x float> %load
}

; Ensure the resulting store is "vscale x 4" wide, despite the offset giving the
; impression the scatter must be split due to it's <vscale x 4 x i64> offset.
; scatter_f16(base, index(offset, 8 * sizeof(i8))
define void @scatter_i8_index_offset_8([8 x i8]* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x i8> %data) #0 {
; CHECK-LABEL: scatter_i8_index_offset_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x0, x1, lsl #3
; CHECK-NEXT:    index z1.s, #0, #8
; CHECK-NEXT:    st1b { z0.s }, p0, [x8, z1.s, sxtw]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t2 = add <vscale x 4 x i64> %t1, %step
  %t3 = getelementptr [8 x i8], [8 x i8]* %base, <vscale x 4 x i64> %t2
  %t4 = bitcast <vscale x 4 x [8 x i8]*> %t3 to <vscale x 4 x i8*>
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x i8*> %t4, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; Ensure the resulting store is "vscale x 4" wide, despite the offset giving the
; impression the scatter must be split due to it's <vscale x 4 x i64> offset.
; scatter_f16(base, index(offset, 8 * sizeof(half))
define void @scatter_f16_index_offset_8([8 x half]* %base, i64 %offset, <vscale x 4 x i1> %pg, <vscale x 4 x half> %data) #0 {
; CHECK-LABEL: scatter_f16_index_offset_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    add x9, x0, x1, lsl #4
; CHECK-NEXT:    index z1.s, #0, w8
; CHECK-NEXT:    st1h { z0.s }, p0, [x9, z1.s, sxtw]
; CHECK-NEXT:    ret
  %t0 = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %t1 = shufflevector <vscale x 4 x i64> %t0, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %t2 = add <vscale x 4 x i64> %t1, %step
  %t3 = getelementptr [8 x half], [8 x half]* %base, <vscale x 4 x i64> %t2
  %t4 = bitcast <vscale x 4 x [8 x half]*> %t3 to <vscale x 4 x half*>
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %t4, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; stepvector is hidden further behind GEP and two adds.
define void @scatter_f16_index_add_add([8 x half]* %base, i64 %offset, i64 %offset2, <vscale x 4 x i1> %pg, <vscale x 4 x half> %data) #0 {
; CHECK-LABEL: scatter_f16_index_add_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    add x9, x0, x2, lsl #4
; CHECK-NEXT:    add x9, x9, x1, lsl #4
; CHECK-NEXT:    index z1.s, #0, w8
; CHECK-NEXT:    st1h { z0.s }, p0, [x9, z1.s, sxtw]
; CHECK-NEXT:    ret
  %splat.offset.ins = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %splat.offset = shufflevector <vscale x 4 x i64> %splat.offset.ins, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %splat.offset2.ins = insertelement <vscale x 4 x i64> undef, i64 %offset2, i32 0
  %splat.offset2 = shufflevector <vscale x 4 x i64> %splat.offset2.ins, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %add1 = add <vscale x 4 x i64> %splat.offset, %step
  %add2 = add <vscale x 4 x i64> %add1, %splat.offset2
  %gep = getelementptr [8 x half], [8 x half]* %base, <vscale x 4 x i64> %add2
  %gep.bc = bitcast <vscale x 4 x [8 x half]*> %gep to <vscale x 4 x half*>
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %gep.bc, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

; stepvector is hidden further behind GEP two adds and a shift.
define void @scatter_f16_index_add_add_mul([8 x half]* %base, i64 %offset, i64 %offset2, <vscale x 4 x i1> %pg, <vscale x 4 x half> %data) #0 {
; CHECK-LABEL: scatter_f16_index_add_add_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #128
; CHECK-NEXT:    add x9, x0, x2, lsl #7
; CHECK-NEXT:    add x9, x9, x1, lsl #7
; CHECK-NEXT:    index z1.s, #0, w8
; CHECK-NEXT:    st1h { z0.s }, p0, [x9, z1.s, sxtw]
; CHECK-NEXT:    ret
  %splat.offset.ins = insertelement <vscale x 4 x i64> undef, i64 %offset, i32 0
  %splat.offset = shufflevector <vscale x 4 x i64> %splat.offset.ins, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %splat.offset2.ins = insertelement <vscale x 4 x i64> undef, i64 %offset2, i32 0
  %splat.offset2 = shufflevector <vscale x 4 x i64> %splat.offset2.ins, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %step = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
  %add1 = add <vscale x 4 x i64> %splat.offset, %step
  %add2 = add <vscale x 4 x i64> %add1, %splat.offset2
  %splat.const8.ins = insertelement <vscale x 4 x i64> undef, i64 8, i32 0
  %splat.const8 = shufflevector <vscale x 4 x i64> %splat.const8.ins, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %mul = mul <vscale x 4 x i64> %add2, %splat.const8
  %gep = getelementptr [8 x half], [8 x half]* %base, <vscale x 4 x i64> %mul
  %gep.bc = bitcast <vscale x 4 x [8 x half]*> %gep to <vscale x 4 x half*>
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x half*> %gep.bc, i32 2, <vscale x 4 x i1> %pg)
  ret void
}

define <vscale x 2 x i64> @masked_gather_nxv2i64_const_with_vec_offsets(<vscale x 2 x i64> %vector_offsets, <vscale x 2 x i1> %pg) #0 {
; CHECK-LABEL: masked_gather_nxv2i64_const_with_vec_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #8
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i64, i64* inttoptr (i64 8 to i64*), <vscale x 2 x i64> %vector_offsets
  %data = call <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %data
}

define <vscale x 2 x i64> @masked_gather_nxv2i64_null_with_vec_plus_scalar_offsets(<vscale x 2 x i64> %vector_offsets, i64 %scalar_offset, <vscale x 2 x i1> %pg) #0 {
; CHECK-LABEL: masked_gather_nxv2i64_null_with_vec_plus_scalar_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    mov z1.d, x0
; CHECK-NEXT:    add z0.d, z0.d, z1.d
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %scalar_offset.ins = insertelement <vscale x 2 x i64> undef, i64 %scalar_offset, i64 0
  %scalar_offset.splat = shufflevector <vscale x 2 x i64> %scalar_offset.ins, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %offsets = add <vscale x 2 x i64> %vector_offsets, %scalar_offset.splat
  %ptrs = getelementptr i64, i64* null, <vscale x 2 x i64> %offsets
  %data = call <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %data
}

define <vscale x 2 x i64> @masked_gather_nxv2i64_null_with__vec_plus_imm_offsets(<vscale x 2 x i64> %vector_offsets, <vscale x 2 x i1> %pg) #0 {
; CHECK-LABEL: masked_gather_nxv2i64_null_with__vec_plus_imm_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    add z0.d, z0.d, #1 // =0x1
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %scalar_offset.ins = insertelement <vscale x 2 x i64> undef, i64 1, i64 0
  %scalar_offset.splat = shufflevector <vscale x 2 x i64> %scalar_offset.ins, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %offsets = add <vscale x 2 x i64> %vector_offsets, %scalar_offset.splat
  %ptrs = getelementptr i64, i64* null, <vscale x 2 x i64> %offsets
  %data = call <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %data
}

define <vscale x 4 x i32> @masked_gather_nxv4i32_s8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask) #0 {
; CHECK-LABEL: masked_gather_nxv4i32_s8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    sxtb z0.s, p1/m, z0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, z0.s, sxtw #2]
; CHECK-NEXT:    ret
  %offsets.sext = sext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i32> %offsets.sext
  %data = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x i32> undef)
  ret <vscale x 4 x i32> %data
}

define <vscale x 4 x i32> @masked_gather_nxv4i32_u8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask) #0 {
; CHECK-LABEL: masked_gather_nxv4i32_u8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.s, z0.s, #0xff
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, z0.s, uxtw #2]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i32> %offsets.zext
  %data = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x i32> undef)
  ret <vscale x 4 x i32> %data
}

define <vscale x 4 x i32> @masked_gather_nxv4i32_u32s8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask) #0 {
; CHECK-LABEL: masked_gather_nxv4i32_u32s8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    sxtb z0.s, p1/m, z0.s
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, z0.s, uxtw #2]
; CHECK-NEXT:    ret
  %offsets.sext = sext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %offsets.sext.zext = zext <vscale x 4 x i32> %offsets.sext to <vscale x 4 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i64> %offsets.sext.zext
  %data = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x i32> undef)
  ret <vscale x 4 x i32> %data
}

define void @masked_scatter_nxv2i64_const_with_vec_offsets(<vscale x 2 x i64> %vector_offsets, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv2i64_const_with_vec_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #8
; CHECK-NEXT:    st1d { z1.d }, p0, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %ptrs = getelementptr i64, i64* inttoptr (i64 8 to i64*), <vscale x 2 x i64> %vector_offsets
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg)
  ret void
}

define void @masked_scatter_nxv2i64_null_with_vec_plus_scalar_offsets(<vscale x 2 x i64> %vector_offsets, i64 %scalar_offset, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv2i64_null_with_vec_plus_scalar_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    mov z2.d, x0
; CHECK-NEXT:    add z0.d, z0.d, z2.d
; CHECK-NEXT:    st1d { z1.d }, p0, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %scalar_offset.ins = insertelement <vscale x 2 x i64> undef, i64 %scalar_offset, i64 0
  %scalar_offset.splat = shufflevector <vscale x 2 x i64> %scalar_offset.ins, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %offsets = add <vscale x 2 x i64> %vector_offsets, %scalar_offset.splat
  %ptrs = getelementptr i64, i64* null, <vscale x 2 x i64> %offsets
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg)
  ret void
}

define void @masked_scatter_nxv2i64_null_with__vec_plus_imm_offsets(<vscale x 2 x i64> %vector_offsets, <vscale x 2 x i1> %pg, <vscale x 2 x i64> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv2i64_null_with__vec_plus_imm_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    add z0.d, z0.d, #1 // =0x1
; CHECK-NEXT:    st1d { z1.d }, p0, [x8, z0.d, lsl #3]
; CHECK-NEXT:    ret
  %scalar_offset.ins = insertelement <vscale x 2 x i64> undef, i64 1, i64 0
  %scalar_offset.splat = shufflevector <vscale x 2 x i64> %scalar_offset.ins, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %offsets = add <vscale x 2 x i64> %vector_offsets, %scalar_offset.splat
  %ptrs = getelementptr i64, i64* null, <vscale x 2 x i64> %offsets
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %pg)
  ret void
}

define void @masked_scatter_nxv4i32_s8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask, <vscale x 4 x i32> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv4i32_s8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    sxtb z0.s, p1/m, z0.s
; CHECK-NEXT:    st1w { z1.s }, p0, [x0, z0.s, sxtw #2]
; CHECK-NEXT:    ret
  %offsets.sext = sext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i32> %offsets.sext
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv4i32_u8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask, <vscale x 4 x i32> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv4i32_u8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.s, z0.s, #0xff
; CHECK-NEXT:    st1w { z1.s }, p0, [x0, z0.s, uxtw #2]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i32> %offsets.zext
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask)
  ret void
}

define void @masked_scatter_nxv4i32_u32s8_offsets(i32* %base, <vscale x 4 x i8> %offsets, <vscale x 4 x i1> %mask, <vscale x 4 x i32> %data) #0 {
; CHECK-LABEL: masked_scatter_nxv4i32_u32s8_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ptrue p1.s
; CHECK-NEXT:    sxtb z0.s, p1/m, z0.s
; CHECK-NEXT:    st1w { z1.s }, p0, [x0, z0.s, uxtw #2]
; CHECK-NEXT:    ret
  %offsets.sext = sext <vscale x 4 x i8> %offsets to <vscale x 4 x i32>
  %offsets.sext.zext = zext <vscale x 4 x i32> %offsets.sext to <vscale x 4 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i64> %offsets.sext.zext
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask)
  ret void
}

attributes #0 = { "target-features"="+sve" vscale_range(1, 16) }

declare <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*>, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)
declare <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*>, i32, <vscale x 4 x i1>, <vscale x 4 x i8>)
declare <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*>, i32, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 4 x float> @llvm.masked.gather.nxv4f32(<vscale x 4 x float*>, i32, <vscale x 4 x i1>, <vscale x 4 x float>)

declare void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8>, <vscale x 4 x i8*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x i16*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half>, <vscale x 4 x half*>, i32, <vscale x 4 x i1>)

declare <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
