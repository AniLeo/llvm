; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-no-signed-zeros-fp-math=true < %s | FileCheck %s --check-prefix=GFX9
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-no-signed-zeros-fp-math=false < %s | FileCheck %s --check-prefix=GFX9
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -enable-no-signed-zeros-fp-math=true < %s | FileCheck %s --check-prefix=GFX10
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -enable-no-signed-zeros-fp-math=false < %s | FileCheck %s --check-prefix=GFX10

; no-signed-zeros-fp-math should not increase the number of
; instructions emitted.

define { double, double } @testfn(double %arg, double %arg1, double %arg2) {
; GFX9-LABEL: testfn:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_add_f64 v[4:5], v[4:5], -v[0:1]
; GFX9-NEXT:    v_add_f64 v[0:1], v[4:5], -v[2:3]
; GFX9-NEXT:    v_add_f64 v[2:3], -v[2:3], -v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: testfn:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v7, v5
; GFX10-NEXT:    v_mov_b32_e32 v6, v4
; GFX10-NEXT:    v_add_f64 v[4:5], v[6:7], -v[0:1]
; GFX10-NEXT:    v_add_f64 v[0:1], v[4:5], -v[2:3]
; GFX10-NEXT:    v_add_f64 v[2:3], -v[2:3], -v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %tmp = fsub fast double 0.000000e+00, %arg1
  %tmp3 = fsub fast double %arg2, %arg
  %tmp4 = fadd fast double %tmp3, %tmp
  %tmp5 = fsub fast double %tmp, %tmp3
  %tmp6 = insertvalue { double, double } undef, double %tmp4, 0
  %tmp7 = insertvalue { double, double } %tmp6, double %tmp5, 1
  ret { double, double } %tmp7
}
