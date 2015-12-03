; RUN: llc < %s -march=r600 -mcpu=redwood | FileCheck %s

; These tests are for condition codes that are not supported by the hardware

; CHECK-LABEL: {{^}}slt:
; CHECK: SETGT_INT {{\** *}}T{{[0-9]+\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR
; CHECK-NEXT: 5(7.006492e-45)
define void @slt(i32 addrspace(1)* %out, i32 %in) {
entry:
  %0 = icmp slt i32 %in, 5
  %1 = select i1 %0, i32 -1, i32 0
  store i32 %1, i32 addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ult_i32:
; CHECK: SETGT_UINT {{\** *}}T{{[0-9]+\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR
; CHECK-NEXT: 5(7.006492e-45)
define void @ult_i32(i32 addrspace(1)* %out, i32 %in) {
entry:
  %0 = icmp ult i32 %in, 5
  %1 = select i1 %0, i32 -1, i32 0
  store i32 %1, i32 addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ult_float:
; CHECK: SETGE * T{{[0-9]}}.[[CHAN:[XYZW]]], KC0[2].Z, literal.x
; CHECK-NEXT: 1084227584(5.000000e+00)
; CHECK-NEXT: SETE T{{[0-9]\.[XYZW]}}, PV.[[CHAN]], 0.0
; CHECK-NEXT: LSHR *
define void @ult_float(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp ult float %in, 5.0
  %1 = select i1 %0, float 1.0, float 0.0
  store float %1, float addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ult_float_native:
; CHECK: SETGE T{{[0-9]\.[XYZW]}}, KC0[2].Z, literal.x
; CHECK-NEXT: LSHR *
; CHECK-NEXT: 1084227584(5.000000e+00)
define void @ult_float_native(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp ult float %in, 5.0
  %1 = select i1 %0, float 0.0, float 1.0
  store float %1, float addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}olt:
; CHECK: SETGT T{{[0-9]+\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR *
; CHECK-NEXT: 1084227584(5.000000e+00)
define void @olt(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp olt float %in, 5.0
  %1 = select i1 %0, float 1.0, float 0.0
  store float %1, float addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}sle:
; CHECK: SETGT_INT {{\** *}}T{{[0-9]+\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR
; CHECK-NEXT: 6(8.407791e-45)
define void @sle(i32 addrspace(1)* %out, i32 %in) {
entry:
  %0 = icmp sle i32 %in, 5
  %1 = select i1 %0, i32 -1, i32 0
  store i32 %1, i32 addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ule_i32:
; CHECK: SETGT_UINT {{\** *}}T{{[0-9]+\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR
; CHECK-NEXT: 6(8.407791e-45)
define void @ule_i32(i32 addrspace(1)* %out, i32 %in) {
entry:
  %0 = icmp ule i32 %in, 5
  %1 = select i1 %0, i32 -1, i32 0
  store i32 %1, i32 addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ule_float:
; CHECK: SETGT * T{{[0-9]}}.[[CHAN:[XYZW]]], KC0[2].Z, literal.x
; CHECK-NEXT: 1084227584(5.000000e+00)
; CHECK-NEXT: SETE T{{[0-9]\.[XYZW]}}, PV.[[CHAN]], 0.0
; CHECK-NEXT: LSHR *
define void @ule_float(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp ule float %in, 5.0
  %1 = select i1 %0, float 1.0, float 0.0
  store float %1, float addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ule_float_native:
; CHECK: SETGT T{{[0-9]\.[XYZW]}}, KC0[2].Z, literal.x
; CHECK-NEXT: LSHR *
; CHECK-NEXT: 1084227584(5.000000e+00)
define void @ule_float_native(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp ule float %in, 5.0
  %1 = select i1 %0, float 0.0, float 1.0
  store float %1, float addrspace(1)* %out
  ret void
}

; CHECK-LABEL: {{^}}ole:
; CHECK: SETGE T{{[0-9]\.[XYZW]}}, literal.x, KC0[2].Z
; CHECK-NEXT: LSHR *
; CHECK-NEXT:1084227584(5.000000e+00)
define void @ole(float addrspace(1)* %out, float %in) {
entry:
  %0 = fcmp ole float %in, 5.0
  %1 = select i1 %0, float 1.0, float 0.0
  store float %1, float addrspace(1)* %out
  ret void
}
