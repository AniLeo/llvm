; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

; Range checks: for all the instruction tested in this file, the
; immediate must be within the range [-8, 7] (4-bit immediate). Out of
; range values are tested only in one case (following). Valid values
; are tested all through the rest of the file.

define void @imm_out_of_range(<vscale x 2 x i64> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: imm_out_of_range:
; CHECK:       // %bb.0:
; CHECK-NEXT:    addvl x8, x0, #8
; CHECK-NEXT:    ldnt1d { z0.d }, p0/z, [x8]
; CHECK-NEXT:    addvl x8, x0, #-9
; CHECK-NEXT:    stnt1d { z0.d }, p0, [x8]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64>* %base, i64 8
  %base_load_bc = bitcast <vscale x 2 x i64>* %base_load to i64*
  %data = call <vscale x 2 x i64> @llvm.aarch64.sve.ldnt1.nxv2i64(<vscale x 2 x i1> %mask,
                                                                  i64* %base_load_bc)
  %base_store = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64> * %base, i64 -9
  %base_store_bc = bitcast <vscale x 2 x i64>* %base_store to i64*
  call void @llvm.aarch64.sve.stnt1.nxv2i64(<vscale x 2 x i64> %data,
                                            <vscale x 2 x i1> %mask,
                                            i64* %base_store_bc)
  ret void
}

; 2-lane non-temporal load/stores


define void @test_masked_ldst_sv2i64(<vscale x 2 x i64> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1d { z0.d }, p0/z, [x0, #-8, mul vl]
; CHECK-NEXT:    stnt1d { z0.d }, p0, [x0, #-7, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64>* %base, i64 -8
  %base_load_bc = bitcast <vscale x 2 x i64>* %base_load to i64*
  %data = call <vscale x 2 x i64> @llvm.aarch64.sve.ldnt1.nxv2i64(<vscale x 2 x i1> %mask,
                                                                  i64* %base_load_bc)
  %base_store = getelementptr <vscale x 2 x i64>, <vscale x 2 x i64> * %base, i64 -7
  %base_store_bc = bitcast <vscale x 2 x i64>* %base_store to i64*
  call void @llvm.aarch64.sve.stnt1.nxv2i64(<vscale x 2 x i64> %data,
                                            <vscale x 2 x i1> %mask,
                                            i64* %base_store_bc)
  ret void
}

define void @test_masked_ldst_sv2f64(<vscale x 2 x double> * %base, <vscale x 2 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1d { z0.d }, p0/z, [x0, #-6, mul vl]
; CHECK-NEXT:    stnt1d { z0.d }, p0, [x0, #-5, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 2 x double>, <vscale x 2 x double>* %base, i64 -6
  %base_load_bc = bitcast <vscale x 2 x double>* %base_load to double*
  %data = call <vscale x 2 x double> @llvm.aarch64.sve.ldnt1.nxv2f64(<vscale x 2 x i1> %mask,
                                                                    double* %base_load_bc)
  %base_store = getelementptr <vscale x 2 x double>, <vscale x 2 x double> * %base, i64 -5
  %base_store_bc = bitcast <vscale x 2 x double>* %base_store to double*
  call void @llvm.aarch64.sve.stnt1.nxv2f64(<vscale x 2 x double> %data,
                                            <vscale x 2 x i1> %mask,
                                            double* %base_store_bc)
  ret void
}

; 4-lane non-temporal load/stores.

define void @test_masked_ldst_sv4i32(<vscale x 4 x i32> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1w { z0.s }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT:    stnt1w { z0.s }, p0, [x0, #7, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %base, i64 6
  %base_load_bc = bitcast <vscale x 4 x i32>* %base_load to i32*
  %data = call <vscale x 4 x i32> @llvm.aarch64.sve.ldnt1.nxv4i32(<vscale x 4 x i1> %mask,
                                                                  i32* %base_load_bc)
  %base_store = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32> * %base, i64 7
  %base_store_bc = bitcast <vscale x 4 x i32>* %base_store to i32*
  call void @llvm.aarch64.sve.stnt1.nxv4i32(<vscale x 4 x i32> %data,
                                            <vscale x 4 x i1> %mask,
                                            i32* %base_store_bc)
  ret void
}

define void @test_masked_ldst_sv4f32(<vscale x 4 x float> * %base, <vscale x 4 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1w { z0.s }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT:    stnt1w { z0.s }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 4 x float>, <vscale x 4 x float>* %base, i64 -1
  %base_load_bc = bitcast <vscale x 4 x float>* %base_load to float*
  %data = call <vscale x 4 x float> @llvm.aarch64.sve.ldnt1.nxv4f32(<vscale x 4 x i1> %mask,
                                                                    float* %base_load_bc)
  %base_store = getelementptr <vscale x 4 x float>, <vscale x 4 x float> * %base, i64 2
  %base_store_bc = bitcast <vscale x 4 x float>* %base_store to float*
  call void @llvm.aarch64.sve.stnt1.nxv4f32(<vscale x 4 x float> %data,
                                            <vscale x 4 x i1> %mask,
                                            float* %base_store_bc)
  ret void
}


; 8-lane non-temporal load/stores.

define void @test_masked_ldst_sv8i16(<vscale x 8 x i16> * %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1h { z0.h }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT:    stnt1h { z0.h }, p0, [x0, #7, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 8 x i16>, <vscale x 8 x i16>* %base, i64 6
  %base_load_bc = bitcast <vscale x 8 x i16>* %base_load to i16*
  %data = call <vscale x 8 x i16> @llvm.aarch64.sve.ldnt1.nxv8i16(<vscale x 8 x i1> %mask,
                                                                  i16* %base_load_bc)
  %base_store = getelementptr <vscale x 8 x i16>, <vscale x 8 x i16> * %base, i64 7
  %base_store_bc = bitcast <vscale x 8 x i16>* %base_store to i16*
  call void @llvm.aarch64.sve.stnt1.nxv8i16(<vscale x 8 x i16> %data,
                                            <vscale x 8 x i1> %mask,
                                            i16* %base_store_bc)
  ret void
}

define void @test_masked_ldst_sv8f16(<vscale x 8 x half> * %base, <vscale x 8 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1h { z0.h }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT:    stnt1h { z0.h }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 8 x half>, <vscale x 8 x half>* %base, i64 -1
  %base_load_bc = bitcast <vscale x 8 x half>* %base_load to half*
  %data = call <vscale x 8 x half> @llvm.aarch64.sve.ldnt1.nxv8f16(<vscale x 8 x i1> %mask,
                                                                   half* %base_load_bc)
  %base_store = getelementptr <vscale x 8 x half>, <vscale x 8 x half> * %base, i64 2
  %base_store_bc = bitcast <vscale x 8 x half>* %base_store to half*
  call void @llvm.aarch64.sve.stnt1.nxv8f16(<vscale x 8 x half> %data,
                                            <vscale x 8 x i1> %mask,
                                            half* %base_store_bc)
  ret void
}

define void @test_masked_ldst_sv8bf16(<vscale x 8 x bfloat> * %base, <vscale x 8 x i1> %mask) nounwind #0 {
; CHECK-LABEL: test_masked_ldst_sv8bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1h { z0.h }, p0/z, [x0, #-1, mul vl]
; CHECK-NEXT:    stnt1h { z0.h }, p0, [x0, #2, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 8 x bfloat>, <vscale x 8 x bfloat>* %base, i64 -1
  %base_load_bc = bitcast <vscale x 8 x bfloat>* %base_load to bfloat*
  %data = call <vscale x 8 x bfloat> @llvm.aarch64.sve.ldnt1.nxv8bf16(<vscale x 8 x i1> %mask,
                                                                      bfloat* %base_load_bc)
  %base_store = getelementptr <vscale x 8 x bfloat>, <vscale x 8 x bfloat> * %base, i64 2
  %base_store_bc = bitcast <vscale x 8 x bfloat>* %base_store to bfloat*
  call void @llvm.aarch64.sve.stnt1.nxv8bf16(<vscale x 8 x bfloat> %data,
                                             <vscale x 8 x i1> %mask,
                                             bfloat* %base_store_bc)
  ret void
}

; 16-lane non-temporal load/stores.

define void @test_masked_ldst_sv16i8(<vscale x 16 x i8> * %base, <vscale x 16 x i1> %mask) nounwind {
; CHECK-LABEL: test_masked_ldst_sv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldnt1b { z0.b }, p0/z, [x0, #6, mul vl]
; CHECK-NEXT:    stnt1b { z0.b }, p0, [x0, #7, mul vl]
; CHECK-NEXT:    ret
  %base_load = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8>* %base, i64 6
  %base_load_bc = bitcast <vscale x 16 x i8>* %base_load to i8*
  %data = call <vscale x 16 x i8> @llvm.aarch64.sve.ldnt1.nxv16i8(<vscale x 16 x i1> %mask,
                                                                  i8* %base_load_bc)
  %base_store = getelementptr <vscale x 16 x i8>, <vscale x 16 x i8> * %base, i64 7
  %base_store_bc = bitcast <vscale x 16 x i8>* %base_store to i8*
  call void @llvm.aarch64.sve.stnt1.nxv16i8(<vscale x 16 x i8> %data,
                                            <vscale x 16 x i1> %mask,
                                            i8* %base_store_bc)
  ret void
}

; 2-element non-temporal loads.
declare <vscale x 2 x i64> @llvm.aarch64.sve.ldnt1.nxv2i64(<vscale x 2 x i1>, i64*)
declare <vscale x 2 x double> @llvm.aarch64.sve.ldnt1.nxv2f64(<vscale x 2 x i1>, double*)

; 4-element non-temporal loads.
declare <vscale x 4 x i32> @llvm.aarch64.sve.ldnt1.nxv4i32(<vscale x 4 x i1>, i32*)
declare <vscale x 4 x float> @llvm.aarch64.sve.ldnt1.nxv4f32(<vscale x 4 x i1>, float*)

; 8-element non-temporal loads.
declare <vscale x 8 x i16> @llvm.aarch64.sve.ldnt1.nxv8i16(<vscale x 8 x i1>, i16*)
declare <vscale x 8 x half> @llvm.aarch64.sve.ldnt1.nxv8f16(<vscale x 8 x i1>, half*)
declare <vscale x 8 x bfloat> @llvm.aarch64.sve.ldnt1.nxv8bf16(<vscale x 8 x i1>, bfloat*)

; 16-element non-temporal loads.
declare <vscale x 16 x i8> @llvm.aarch64.sve.ldnt1.nxv16i8(<vscale x 16 x i1>, i8*)

; 2-element non-temporal stores.
declare void @llvm.aarch64.sve.stnt1.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i1>, i64*)
declare void @llvm.aarch64.sve.stnt1.nxv2f64(<vscale x 2 x double>, <vscale x 2 x i1>, double*)

; 4-element non-temporal stores.
declare void @llvm.aarch64.sve.stnt1.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i1>, i32*)
declare void @llvm.aarch64.sve.stnt1.nxv4f32(<vscale x 4 x float>, <vscale x 4 x i1>, float*)

; 8-element non-temporal stores.
declare void @llvm.aarch64.sve.stnt1.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i1>, i16*)
declare void @llvm.aarch64.sve.stnt1.nxv8f16(<vscale x 8 x half>, <vscale x 8 x i1>, half*)
declare void @llvm.aarch64.sve.stnt1.nxv8bf16(<vscale x 8 x bfloat>, <vscale x 8 x i1>, bfloat*)

; 16-element non-temporal stores.
declare void @llvm.aarch64.sve.stnt1.nxv16i8(<vscale x 16 x i8>, <vscale x 16 x i1>, i8*)

; +bf16 is required for the bfloat version.
attributes #0 = { "target-features"="+sve,+bf16" }
