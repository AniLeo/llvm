; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -verify-machineinstrs < %s | FileCheck %s

define amdgpu_cs i32 @test_shl_and_1(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_and_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 4
; CHECK-NEXT:    s_and_b32 s0, s0, -16
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 2
  %z2 = and i32 %z1, 1073741820
  %z3 = shl i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_and_2(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_and_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 8
; CHECK-NEXT:    s_and_b32 s0, s0, 0xffffff00
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 5
  %z2 = and i32 %z1, 536870880
  %z3 = shl i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_and_3(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_and_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 5
; CHECK-NEXT:    s_and_b32 s0, s0, 0x7ffffff0
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 3
  %z2 = and i32 %z1, 536870908
  %z3 = shl i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_and_1(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_and_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 4
; CHECK-NEXT:    s_and_b32 s0, s0, 0xfffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 2
  %z2 = and i32 %z1, 1073741820
  %z3 = lshr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_and_2(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_and_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 8
; CHECK-NEXT:    s_and_b32 s0, s0, 0x3fffffc
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 5
  %z2 = and i32 %z1, 536870880
  %z3 = lshr i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_and_3(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_and_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 5
; CHECK-NEXT:    s_and_b32 s0, s0, 0x7ffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 3
  %z2 = and i32 %z1, 536870908
  %z3 = lshr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_and_1(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_and_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 4
; CHECK-NEXT:    s_and_b32 s0, s0, 0xfffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 2
  %z2 = and i32 %z1, 1073741820
  %z3 = ashr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_and_2(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_and_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 8
; CHECK-NEXT:    s_and_b32 s0, s0, 0x3fffffc
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 5
  %z2 = and i32 %z1, 536870880
  %z3 = ashr i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_and_3(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_and_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 5
; CHECK-NEXT:    s_and_b32 s0, s0, 0x7ffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 3
  %z2 = and i32 %z1, 536870908
  %z3 = ashr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_or_1(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_or_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 4
; CHECK-NEXT:    s_or_b32 s0, s0, 12
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 2
  %z2 = or i32 %z1, 3221225475
  %z3 = shl i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_or_2(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_or_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 8
; CHECK-NEXT:    s_or_b32 s0, s0, 0xfffffc00
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 3
  %z2 = or i32 %z1, 536870880
  %z3 = shl i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_or_3(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_or_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 5
; CHECK-NEXT:    s_or_b32 s0, s0, 0x7fffff80
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 2
  %z2 = or i32 %z1, 268435440
  %z3 = shl i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_or_1(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_or_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 4
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 2
  %z2 = or i32 %z1, 3
  %z3 = lshr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_or_2(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_or_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 8
; CHECK-NEXT:    s_or_b32 s0, s0, 0xffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 3
  %z2 = or i32 %z1, 536870880
  %z3 = lshr i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_or_3(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_or_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 5
; CHECK-NEXT:    s_or_b32 s0, s0, 0x1fffffe
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 2
  %z2 = or i32 %z1, 268435440
  %z3 = lshr i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_or_1(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_or_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 4
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 2
  %z2 = or i32 %z1, 3
  %z3 = ashr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_or_2(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_or_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 8
; CHECK-NEXT:    s_or_b32 s0, s0, 0xffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 3
  %z2 = or i32 %z1, 536870880
  %z3 = ashr i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_or_3(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_or_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 5
; CHECK-NEXT:    s_or_b32 s0, s0, 0x1fffffe
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 2
  %z2 = or i32 %z1, 268435440
  %z3 = ashr i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_xor_1(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_xor_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 4
; CHECK-NEXT:    s_xor_b32 s0, s0, -16
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 2
  %z2 = xor i32 %z1, 1073741820
  %z3 = shl i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_xor_2(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_xor_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 6
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 1
  %z2 = xor i32 %z1, 4160749568
  %z3 = shl i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_shl_xor_3(i32 inreg %arg1) {
; CHECK-LABEL: test_shl_xor_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshl_b32 s0, s0, 5
; CHECK-NEXT:    s_xor_b32 s0, s0, 56
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = shl i32 %arg1, 2
  %z2 = xor i32 %z1, 3221225479
  %z3 = shl i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_xor_1(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_xor_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 4
; CHECK-NEXT:    s_xor_b32 s0, s0, 0xfffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 2
  %z2 = xor i32 %z1, 1073741820
  %z3 = lshr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_xor_2(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_xor_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 6
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 1
  %z2 = xor i32 %z1, 31
  %z3 = lshr i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_lshr_xor_3(i32 inreg %arg1) {
; CHECK-LABEL: test_lshr_xor_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_lshr_b32 s0, s0, 5
; CHECK-NEXT:    s_xor_b32 s0, s0, 0x18000000
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = lshr i32 %arg1, 2
  %z2 = xor i32 %z1, 3221225479
  %z3 = lshr i32 %z2, 3
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_xor_1(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_xor_1:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 4
; CHECK-NEXT:    s_xor_b32 s0, s0, 0xfffffff
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 2
  %z2 = xor i32 %z1, 1073741820
  %z3 = ashr i32 %z2, 2
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_xor_2(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_xor_2:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 6
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 1
  %z2 = xor i32 %z1, 31
  %z3 = ashr i32 %z2, 5
  ret i32 %z3
}

define amdgpu_cs i32 @test_ashr_xor_3(i32 inreg %arg1) {
; CHECK-LABEL: test_ashr_xor_3:
; CHECK:       ; %bb.0: ; %.entry
; CHECK-NEXT:    s_ashr_i32 s0, s0, 5
; CHECK-NEXT:    s_xor_b32 s0, s0, 0xf8000000
; CHECK-NEXT:    ; return to shader part epilog
.entry:
  %z1 = ashr i32 %arg1, 2
  %z2 = xor i32 %z1, 3221225479
  %z3 = ashr i32 %z2, 3
  ret i32 %z3
}
