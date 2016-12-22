; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck -check-prefix=GCN -check-prefix=SI %s
; RUN: llc -march=amdgcn -mcpu=tonga -mattr=-fp16-denormals -verify-machineinstrs < %s | FileCheck -check-prefix=GCN -check-prefix=VI %s

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare float @llvm.fabs.f32(float) #0
declare half @llvm.fabs.f16(half) #0

; GCN-LABEL: {{^}}mad_sub_f32:
; GCN: {{buffer|flat}}_load_dword [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGC:v[0-9]+]]
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], [[REGA]], [[REGB]], -[[REGC]]

; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %mul = fmul float %a, %b
  %sub = fsub float %mul, %c
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}mad_sub_inv_f32:
; GCN: {{buffer|flat}}_load_dword [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGC:v[0-9]+]]
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], -[[REGA]], [[REGB]], [[REGC]]

; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_inv_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %mul = fmul float %a, %b
  %sub = fsub float %c, %mul
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}mad_sub_f64:
; GCN: v_mul_f64
; GCN: v_add_f64
define void @mad_sub_f64(double addrspace(1)* noalias nocapture %out, double addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr double, double addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr double, double addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr double, double addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr double, double addrspace(1)* %out, i64 %tid.ext
  %a = load volatile double, double addrspace(1)* %gep0, align 8
  %b = load volatile double, double addrspace(1)* %gep1, align 8
  %c = load volatile double, double addrspace(1)* %gep2, align 8
  %mul = fmul double %a, %b
  %sub = fsub double %mul, %c
  store double %sub, double addrspace(1)* %outgep, align 8
  ret void
}

; GCN-LABEL: {{^}}mad_sub_fabs_f32:
; GCN: {{buffer|flat}}_load_dword [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGC:v[0-9]+]]
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], [[REGA]], [[REGB]], -|[[REGC]]|
; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_fabs_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %c.abs = call float @llvm.fabs.f32(float %c) #0
  %mul = fmul float %a, %b
  %sub = fsub float %mul, %c.abs
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}mad_sub_fabs_inv_f32:
; GCN: {{buffer|flat}}_load_dword [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGC:v[0-9]+]]
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], -[[REGA]], [[REGB]], |[[REGC]]|
; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_fabs_inv_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %c.abs = call float @llvm.fabs.f32(float %c) #0
  %mul = fmul float %a, %b
  %sub = fsub float %c.abs, %mul
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}neg_neg_mad_f32:
; GCN: v_mac_f32_e32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
define void @neg_neg_mad_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %nega = fsub float -0.000000e+00, %a
  %negb = fsub float -0.000000e+00, %b
  %mul = fmul float %nega, %negb
  %sub = fadd float %mul, %c
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}mad_fabs_sub_f32:
; GCN: {{buffer|flat}}_load_dword [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_dword [[REGC:v[0-9]+]]
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], [[REGA]], |[[REGB]]|, -[[REGC]]
; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_fabs_sub_f32(float addrspace(1)* noalias nocapture %out, float addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr float, float addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr float, float addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr float, float addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr float, float addrspace(1)* %out, i64 %tid.ext
  %a = load volatile float, float addrspace(1)* %gep0, align 4
  %b = load volatile float, float addrspace(1)* %gep1, align 4
  %c = load volatile float, float addrspace(1)* %gep2, align 4
  %b.abs = call float @llvm.fabs.f32(float %b) #0
  %mul = fmul float %a, %b.abs
  %sub = fsub float %mul, %c
  store float %sub, float addrspace(1)* %outgep, align 4
  ret void
}

; GCN-LABEL: {{^}}fsub_c_fadd_a_a_f32:
; GCN: {{buffer|flat}}_load_dword [[R1:v[0-9]+]],
; GCN: {{buffer|flat}}_load_dword [[R2:v[0-9]+]],
; GCN: v_mac_f32_e32 [[R2]], -2.0, [[R1]]

; SI: buffer_store_dword [[R2]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[R2]]
define void @fsub_c_fadd_a_a_f32(float addrspace(1)* %out, float addrspace(1)* %in) {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep.0 = getelementptr float, float addrspace(1)* %out, i32 %tid
  %gep.1 = getelementptr float, float addrspace(1)* %gep.0, i32 1
  %gep.out = getelementptr float, float addrspace(1)* %out, i32 %tid

  %r1 = load volatile float, float addrspace(1)* %gep.0
  %r2 = load volatile float, float addrspace(1)* %gep.1

  %add = fadd float %r1, %r1
  %r3 = fsub float %r2, %add

  store float %r3, float addrspace(1)* %gep.out
  ret void
}

; GCN-LABEL: {{^}}fsub_fadd_a_a_c_f32:
; GCN: {{buffer|flat}}_load_dword [[R1:v[0-9]+]],
; GCN: {{buffer|flat}}_load_dword [[R2:v[0-9]+]],
; GCN: v_mad_f32 [[RESULT:v[0-9]+]], 2.0, [[R1]], -[[R2]]

; SI: buffer_store_dword [[RESULT]]
; VI: flat_store_dword v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @fsub_fadd_a_a_c_f32(float addrspace(1)* %out, float addrspace(1)* %in) {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep.0 = getelementptr float, float addrspace(1)* %out, i32 %tid
  %gep.1 = getelementptr float, float addrspace(1)* %gep.0, i32 1
  %gep.out = getelementptr float, float addrspace(1)* %out, i32 %tid

  %r1 = load volatile float, float addrspace(1)* %gep.0
  %r2 = load volatile float, float addrspace(1)* %gep.1

  %add = fadd float %r1, %r1
  %r3 = fsub float %add, %r2

  store float %r3, float addrspace(1)* %gep.out
  ret void
}

; GCN-LABEL: {{^}}mad_sub_f16:
; GCN: {{buffer|flat}}_load_ushort [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGC:v[0-9]+]]

; VI: v_mad_f16 [[RESULT:v[0-9]+]], [[REGA]], [[REGB]], -[[REGC]]
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %mul = fmul half %a, %b
  %sub = fsub half %mul, %c
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}mad_sub_inv_f16:
; GCN: {{buffer|flat}}_load_ushort [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGC:v[0-9]+]]
; VI: v_mad_f16 [[RESULT:v[0-9]+]], -[[REGA]], [[REGB]], [[REGC]]
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_inv_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %mul = fmul half %a, %b
  %sub = fsub half %c, %mul
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}mad_sub_fabs_f16:
; GCN: {{buffer|flat}}_load_ushort [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGC:v[0-9]+]]
; VI: v_mad_f16 [[RESULT:v[0-9]+]], [[REGA]], [[REGB]], -|[[REGC]]|
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_fabs_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %c.abs = call half @llvm.fabs.f16(half %c) #0
  %mul = fmul half %a, %b
  %sub = fsub half %mul, %c.abs
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}mad_sub_fabs_inv_f16:
; GCN: {{buffer|flat}}_load_ushort [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGC:v[0-9]+]]

; VI: v_mad_f16 [[RESULT:v[0-9]+]], -[[REGA]], [[REGB]], |[[REGC]]|
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_sub_fabs_inv_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %c.abs = call half @llvm.fabs.f16(half %c) #0
  %mul = fmul half %a, %b
  %sub = fsub half %c.abs, %mul
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}neg_neg_mad_f16:
; VI: v_mac_f16_e32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
define void @neg_neg_mad_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %nega = fsub half -0.000000e+00, %a
  %negb = fsub half -0.000000e+00, %b
  %mul = fmul half %nega, %negb
  %sub = fadd half %mul, %c
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}mad_fabs_sub_f16:
; GCN: {{buffer|flat}}_load_ushort [[REGA:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGB:v[0-9]+]]
; GCN: {{buffer|flat}}_load_ushort [[REGC:v[0-9]+]]

; VI: v_mad_f16 [[RESULT:v[0-9]+]], [[REGA]], |[[REGB]]|, -[[REGC]]
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @mad_fabs_sub_f16(half addrspace(1)* noalias nocapture %out, half addrspace(1)* noalias nocapture readonly %ptr) #1 {
  %tid = tail call i32 @llvm.amdgcn.workitem.id.x() #0
  %tid.ext = sext i32 %tid to i64
  %gep0 = getelementptr half, half addrspace(1)* %ptr, i64 %tid.ext
  %add1 = add i64 %tid.ext, 1
  %gep1 = getelementptr half, half addrspace(1)* %ptr, i64 %add1
  %add2 = add i64 %tid.ext, 2
  %gep2 = getelementptr half, half addrspace(1)* %ptr, i64 %add2
  %outgep = getelementptr half, half addrspace(1)* %out, i64 %tid.ext
  %a = load volatile half, half addrspace(1)* %gep0, align 2
  %b = load volatile half, half addrspace(1)* %gep1, align 2
  %c = load volatile half, half addrspace(1)* %gep2, align 2
  %b.abs = call half @llvm.fabs.f16(half %b) #0
  %mul = fmul half %a, %b.abs
  %sub = fsub half %mul, %c
  store half %sub, half addrspace(1)* %outgep, align 2
  ret void
}

; GCN-LABEL: {{^}}fsub_c_fadd_a_a_f16:
; GCN: {{buffer|flat}}_load_ushort [[R1:v[0-9]+]],
; GCN: {{buffer|flat}}_load_ushort [[R2:v[0-9]+]],
; VI: v_mac_f16_e32 [[R2]], -2.0, [[R1]]

; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[R2]]
define void @fsub_c_fadd_a_a_f16(half addrspace(1)* %out, half addrspace(1)* %in) {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep.0 = getelementptr half, half addrspace(1)* %out, i32 %tid
  %gep.1 = getelementptr half, half addrspace(1)* %gep.0, i32 1
  %gep.out = getelementptr half, half addrspace(1)* %out, i32 %tid

  %r1 = load volatile half, half addrspace(1)* %gep.0
  %r2 = load volatile half, half addrspace(1)* %gep.1

  %add = fadd half %r1, %r1
  %r3 = fsub half %r2, %add

  store half %r3, half addrspace(1)* %gep.out
  ret void
}

; GCN-LABEL: {{^}}fsub_fadd_a_a_c_f16:
; GCN: {{buffer|flat}}_load_ushort [[R1:v[0-9]+]],
; GCN: {{buffer|flat}}_load_ushort [[R2:v[0-9]+]],

; VI: v_mad_f16 [[RESULT:v[0-9]+]], 2.0, [[R1]], -[[R2]]
; VI: flat_store_short v{{\[[0-9]+:[0-9]+\]}}, [[RESULT]]
define void @fsub_fadd_a_a_c_f16(half addrspace(1)* %out, half addrspace(1)* %in) {
  %tid = call i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
  %gep.0 = getelementptr half, half addrspace(1)* %out, i32 %tid
  %gep.1 = getelementptr half, half addrspace(1)* %gep.0, i32 1
  %gep.out = getelementptr half, half addrspace(1)* %out, i32 %tid

  %r1 = load volatile half, half addrspace(1)* %gep.0
  %r2 = load volatile half, half addrspace(1)* %gep.1

  %add = fadd half %r1, %r1
  %r3 = fsub half %add, %r2

  store half %r3, half addrspace(1)* %gep.out
  ret void
}

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
