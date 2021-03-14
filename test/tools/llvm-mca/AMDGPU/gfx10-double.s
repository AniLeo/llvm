# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=amdgcn -mcpu=gfx1010 --timeline --iterations=1 < %s | FileCheck %s

v_cvt_i32_f64 v0, v[0:1]
v_cvt_f64_i32 v[2:3], v2
v_cvt_f32_f64 v4, v[4:5]
v_cvt_f64_f32 v[6:7], v6
v_cvt_u32_f64 v8, v[8:9]
v_cvt_f64_u32 v[10:11], v10

v_frexp_exp_i32_f64 v0, v[0:1]
v_frexp_mant_f64 v[2:3], v[2:3]
v_fract_f64 v[4:5], v[4:5]

v_trunc_f64 v[0:1], v[0:1]
v_ceil_f64 v[2:3], v[2:3]
v_rndne_f64 v[4:5], v[4:5]
v_floor_f64 v[6:7], v[6:7]

v_fma_f64 v[0:1], v[0:1], v[0:1], v[0:1]
v_add_f64 v[2:3], v[2:3], v[2:3]
v_mul_f64 v[4:5], v[4:5], v[4:5]
v_min_f64 v[6:7], v[6:7], v[6:7]
v_max_f64 v[8:9], v[8:9], v[8:9]

v_div_fmas_f64 v[0:1], v[0:1], v[0:1], v[0:1]

v_div_fixup_f64 v[0:1], v[0:1], v[0:1], v[0:1]
v_ldexp_f64 v[2:3], v[2:3], v0

; FIXME: This instructions sends llvm-mca into an infinite loop
;v_div_scale_f64 v[0:1], vcc_lo, v[0:1], v[0:1], v[0:1]

v_trig_preop_f64 v[2:3], v[2:3], v0

v_cmp_eq_f64 v[0:1], v[0:1]
v_cmp_class_f64 vcc_lo, v[2:3], s0

v_rcp_f64 v[0:1], v[0:1]
v_rsq_f64 v[2:3], v[2:3]
v_sqrt_f64 v[4:5], v[4:5]

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      27
# CHECK-NEXT: Total Cycles:      204
# CHECK-NEXT: Total uOps:        27

# CHECK:      Dispatch Width:    1
# CHECK-NEXT: uOps Per Cycle:    0.13
# CHECK-NEXT: IPC:               0.13
# CHECK-NEXT: Block RThroughput: 27.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_f64_i32_e32 v[2:3], v2
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_f32_f64_e32 v4, v[4:5]
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_f64_f32_e32 v[6:7], v6
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_u32_f64_e32 v8, v[8:9]
# CHECK-NEXT:  1      22    1.00                  U     v_cvt_f64_u32_e32 v[10:11], v10
# CHECK-NEXT:  1      22    1.00                  U     v_frexp_exp_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_frexp_mant_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  1      22    1.00                  U     v_fract_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT:  1      22    1.00                  U     v_trunc_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_ceil_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  1      22    1.00                  U     v_rndne_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT:  1      22    1.00                  U     v_floor_f64_e32 v[6:7], v[6:7]
# CHECK-NEXT:  1      22    1.00                  U     v_fma_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_add_f64 v[2:3], v[2:3], v[2:3]
# CHECK-NEXT:  1      22    1.00                  U     v_mul_f64 v[4:5], v[4:5], v[4:5]
# CHECK-NEXT:  1      22    1.00                  U     v_min_f64 v[6:7], v[6:7], v[6:7]
# CHECK-NEXT:  1      22    1.00                  U     v_max_f64 v[8:9], v[8:9], v[8:9]
# CHECK-NEXT:  1      22    1.00                  U     v_div_fmas_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_div_fixup_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_ldexp_f64 v[2:3], v[2:3], v0
# CHECK-NEXT:  1      22    1.00                  U     v_trig_preop_f64 v[2:3], v[2:3], v0
# CHECK-NEXT:  1      22    1.00                  U     v_cmp_eq_f64_e32 vcc_lo, v[0:1], v[0:1]
# CHECK-NEXT:  1      22    1.00                  U     v_cmp_class_f64_e64 vcc_lo, v[2:3], s0
# CHECK-NEXT:  1      24    1.00                  U     v_rcp_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT:  1      24    1.00                  U     v_rsq_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  1      24    1.00                  U     v_sqrt_f64_e32 v[4:5], v[4:5]

# CHECK:      Resources:
# CHECK-NEXT: [0]   - HWBranch
# CHECK-NEXT: [1]   - HWExport
# CHECK-NEXT: [2]   - HWLGKM
# CHECK-NEXT: [3]   - HWRC
# CHECK-NEXT: [4]   - HWSALU
# CHECK-NEXT: [5]   - HWVALU
# CHECK-NEXT: [6]   - HWVMEM

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]
# CHECK-NEXT:  -      -      -     27.00   -     27.00   -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_f64_i32_e32 v[2:3], v2
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_f32_f64_e32 v4, v[4:5]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_f64_f32_e32 v[6:7], v6
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_u32_f64_e32 v8, v[8:9]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cvt_f64_u32_e32 v[10:11], v10
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_frexp_exp_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_frexp_mant_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_fract_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_trunc_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_ceil_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_rndne_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_floor_f64_e32 v[6:7], v[6:7]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_fma_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_add_f64 v[2:3], v[2:3], v[2:3]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_mul_f64 v[4:5], v[4:5], v[4:5]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_min_f64 v[6:7], v[6:7], v[6:7]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_max_f64 v[8:9], v[8:9], v[8:9]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_div_fmas_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_div_fixup_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_ldexp_f64 v[2:3], v[2:3], v0
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_trig_preop_f64 v[2:3], v[2:3], v0
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cmp_eq_f64_e32 vcc_lo, v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_cmp_class_f64_e64 vcc_lo, v[2:3], s0
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_rcp_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_rsq_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT:  -      -      -     1.00    -     1.00    -     v_sqrt_f64_e32 v[4:5], v[4:5]

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          0123456789          0123456789          0
# CHECK-NEXT: Index     0123456789          0123456789          0123456789          0123456789

# CHECK:      [0,0]     DeeeeeeeeeeeeeeeeeeeeeE  .    .    .    .    .    .    .    .    .    .   v_cvt_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT: [0,1]     .DeeeeeeeeeeeeeeeeeeeeeE .    .    .    .    .    .    .    .    .    .   v_cvt_f64_i32_e32 v[2:3], v2
# CHECK-NEXT: [0,2]     . DeeeeeeeeeeeeeeeeeeeeeE.    .    .    .    .    .    .    .    .    .   v_cvt_f32_f64_e32 v4, v[4:5]
# CHECK-NEXT: [0,3]     .  DeeeeeeeeeeeeeeeeeeeeeE    .    .    .    .    .    .    .    .    .   v_cvt_f64_f32_e32 v[6:7], v6
# CHECK-NEXT: [0,4]     .   DeeeeeeeeeeeeeeeeeeeeeE   .    .    .    .    .    .    .    .    .   v_cvt_u32_f64_e32 v8, v[8:9]
# CHECK-NEXT: [0,5]     .    DeeeeeeeeeeeeeeeeeeeeeE  .    .    .    .    .    .    .    .    .   v_cvt_f64_u32_e32 v[10:11], v10
# CHECK-NEXT: [0,6]     .    .    .    .    . DeeeeeeeeeeeeeeeeeeeeeE.    .    .    .    .    .   v_frexp_exp_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT: [0,7]     .    .    .    .    .  DeeeeeeeeeeeeeeeeeeeeeE    .    .    .    .    .   v_frexp_mant_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT: [0,8]     .    .    .    .    .   DeeeeeeeeeeeeeeeeeeeeeE   .    .    .    .    .   v_fract_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT: [0,9]     .    .    .    .    .    .    .    .    .   DeeeeeeeeeeeeeeeeeeeeeE   .   v_trunc_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT: [0,10]    .    .    .    .    .    .    .    .    .    DeeeeeeeeeeeeeeeeeeeeeE  .   v_ceil_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT: [0,11]    .    .    .    .    .    .    .    .    .    .DeeeeeeeeeeeeeeeeeeeeeE .   v_rndne_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT: [0,12]    .    .    .    .    .    .    .    .    .    . DeeeeeeeeeeeeeeeeeeeeeE.   v_floor_f64_e32 v[6:7], v[6:7]

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     0.0    0.0    0.0       v_cvt_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT: 1.     1     0.0    0.0    0.0       v_cvt_f64_i32_e32 v[2:3], v2
# CHECK-NEXT: 2.     1     0.0    0.0    0.0       v_cvt_f32_f64_e32 v4, v[4:5]
# CHECK-NEXT: 3.     1     0.0    0.0    0.0       v_cvt_f64_f32_e32 v[6:7], v6
# CHECK-NEXT: 4.     1     0.0    0.0    0.0       v_cvt_u32_f64_e32 v8, v[8:9]
# CHECK-NEXT: 5.     1     0.0    0.0    0.0       v_cvt_f64_u32_e32 v[10:11], v10
# CHECK-NEXT: 6.     1     0.0    0.0    0.0       v_frexp_exp_i32_f64_e32 v0, v[0:1]
# CHECK-NEXT: 7.     1     0.0    0.0    0.0       v_frexp_mant_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT: 8.     1     0.0    0.0    0.0       v_fract_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT: 9.     1     0.0    0.0    0.0       v_trunc_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT: 10.    1     0.0    0.0    0.0       v_ceil_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT: 11.    1     0.0    0.0    0.0       v_rndne_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT: 12.    1     0.0    0.0    0.0       v_floor_f64_e32 v[6:7], v[6:7]
# CHECK-NEXT: 13.    1     0.0    0.0    0.0       v_fma_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT: 14.    1     0.0    0.0    0.0       v_add_f64 v[2:3], v[2:3], v[2:3]
# CHECK-NEXT: 15.    1     0.0    0.0    0.0       v_mul_f64 v[4:5], v[4:5], v[4:5]
# CHECK-NEXT: 16.    1     0.0    0.0    0.0       v_min_f64 v[6:7], v[6:7], v[6:7]
# CHECK-NEXT: 17.    1     0.0    0.0    0.0       v_max_f64 v[8:9], v[8:9], v[8:9]
# CHECK-NEXT: 18.    1     0.0    0.0    0.0       v_div_fmas_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT: 19.    1     0.0    0.0    0.0       v_div_fixup_f64 v[0:1], v[0:1], v[0:1], v[0:1]
# CHECK-NEXT: 20.    1     0.0    0.0    0.0       v_ldexp_f64 v[2:3], v[2:3], v0
# CHECK-NEXT: 21.    1     0.0    0.0    0.0       v_trig_preop_f64 v[2:3], v[2:3], v0
# CHECK-NEXT: 22.    1     0.0    0.0    0.0       v_cmp_eq_f64_e32 vcc_lo, v[0:1], v[0:1]
# CHECK-NEXT: 23.    1     0.0    0.0    0.0       v_cmp_class_f64_e64 vcc_lo, v[2:3], s0
# CHECK-NEXT: 24.    1     0.0    0.0    0.0       v_rcp_f64_e32 v[0:1], v[0:1]
# CHECK-NEXT: 25.    1     0.0    0.0    0.0       v_rsq_f64_e32 v[2:3], v[2:3]
# CHECK-NEXT: 26.    1     0.0    0.0    0.0       v_sqrt_f64_e32 v[4:5], v[4:5]
# CHECK-NEXT:        1     0.0    0.0    0.0       <total>
