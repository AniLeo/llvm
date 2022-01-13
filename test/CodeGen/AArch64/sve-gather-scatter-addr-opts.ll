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
; CHECK-NEXT:    ld1sb { z0.s }, p0/z, [x8, z0.s, sxtw]
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


attributes #0 = { "target-features"="+sve" vscale_range(1, 16) }


declare <vscale x 4 x i8> @llvm.masked.gather.nxv4i8(<vscale x 4 x i8*>, i32, <vscale x 4 x i1>, <vscale x 4 x i8>)
declare void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8>, <vscale x 4 x i8*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x i16*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half>, <vscale x 4 x half*>, i32, <vscale x 4 x i1>)
declare <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
