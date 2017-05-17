; RUN: llc -march=amdgcn < %s | FileCheck -check-prefixes=GCN,SI %s
; RUN: llc -march=amdgcn -mcpu=tonga < %s | FileCheck -check-prefixes=GCN,VI %s
; RUN: llc -march=amdgcn -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s

; GCN-LABEL: {{^}}v_test_imin3_slt_i32:
; GCN: v_min3_i32
define amdgpu_kernel void @v_test_imin3_slt_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %aptr, i32 addrspace(1)* %bptr, i32 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep0 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid
  %outgep = getelementptr i32, i32 addrspace(1)* %out, i32 %tid
  %a = load i32, i32 addrspace(1)* %gep0
  %b = load i32, i32 addrspace(1)* %gep1
  %c = load i32, i32 addrspace(1)* %gep2
  %icmp0 = icmp slt i32 %a, %b
  %i0 = select i1 %icmp0, i32 %a, i32 %b
  %icmp1 = icmp slt i32 %i0, %c
  %i1 = select i1 %icmp1, i32 %i0, i32 %c
  store i32 %i1, i32 addrspace(1)* %outgep
  ret void
}

; GCN-LABEL: {{^}}v_test_umin3_ult_i32:
; GCN: v_min3_u32
define amdgpu_kernel void @v_test_umin3_ult_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %aptr, i32 addrspace(1)* %bptr, i32 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep0 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid
  %outgep = getelementptr i32, i32 addrspace(1)* %out, i32 %tid
  %a = load i32, i32 addrspace(1)* %gep0
  %b = load i32, i32 addrspace(1)* %gep1
  %c = load i32, i32 addrspace(1)* %gep2
  %icmp0 = icmp ult i32 %a, %b
  %i0 = select i1 %icmp0, i32 %a, i32 %b
  %icmp1 = icmp ult i32 %i0, %c
  %i1 = select i1 %icmp1, i32 %i0, i32 %c
  store i32 %i1, i32 addrspace(1)* %outgep
  ret void
}

; GCN-LABEL: {{^}}v_test_umin_umin_umin:
; GCN: v_min_i32
; GCN: v_min3_i32
define amdgpu_kernel void @v_test_umin_umin_umin(i32 addrspace(1)* %out, i32 addrspace(1)* %aptr, i32 addrspace(1)* %bptr, i32 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %tid2 = mul i32 %tid, 2
  %gep0 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid

  %gep3 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid2
  %gep4 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid2
  %gep5 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid2

  %outgep0 = getelementptr i32, i32 addrspace(1)* %out, i32 %tid
  %outgep1 = getelementptr i32, i32 addrspace(1)* %out, i32 %tid2

  %a = load i32, i32 addrspace(1)* %gep0
  %b = load i32, i32 addrspace(1)* %gep1
  %c = load i32, i32 addrspace(1)* %gep2
  %d = load i32, i32 addrspace(1)* %gep3

  %icmp0 = icmp slt i32 %a, %b
  %i0 = select i1 %icmp0, i32 %a, i32 %b

  %icmp1 = icmp slt i32 %c, %d
  %i1 = select i1 %icmp1, i32 %c, i32 %d

  %icmp2 = icmp slt i32 %i0, %i1
  %i2 = select i1 %icmp2, i32 %i0, i32 %i1

  store i32 %i2, i32 addrspace(1)* %outgep1
  ret void
}

; GCN-LABEL: {{^}}v_test_umin3_2_uses:
; GCN-NOT: v_min3
define amdgpu_kernel void @v_test_umin3_2_uses(i32 addrspace(1)* %out, i32 addrspace(1)* %aptr, i32 addrspace(1)* %bptr, i32 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %tid2 = mul i32 %tid, 2
  %gep0 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid

  %gep3 = getelementptr i32, i32 addrspace(1)* %aptr, i32 %tid2
  %gep4 = getelementptr i32, i32 addrspace(1)* %bptr, i32 %tid2
  %gep5 = getelementptr i32, i32 addrspace(1)* %cptr, i32 %tid2

  %outgep0 = getelementptr i32, i32 addrspace(1)* %out, i32 %tid
  %outgep1 = getelementptr i32, i32 addrspace(1)* %out, i32 %tid2

  %a = load i32, i32 addrspace(1)* %gep0
  %b = load i32, i32 addrspace(1)* %gep1
  %c = load i32, i32 addrspace(1)* %gep2
  %d = load i32, i32 addrspace(1)* %gep3

  %icmp0 = icmp slt i32 %a, %b
  %i0 = select i1 %icmp0, i32 %a, i32 %b

  %icmp1 = icmp slt i32 %c, %d
  %i1 = select i1 %icmp1, i32 %c, i32 %d

  %icmp2 = icmp slt i32 %i0, %c
  %i2 = select i1 %icmp2, i32 %i0, i32 %c

  store i32 %i2, i32 addrspace(1)* %outgep0
  store i32 %i0, i32 addrspace(1)* %outgep1
  ret void
}

; GCN-LABEL: {{^}}v_test_imin3_slt_i16:
; SI: v_min3_i32

; VI: v_min_i16
; VI: v_min_i16

; GFX9: v_min3_i16
define amdgpu_kernel void @v_test_imin3_slt_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr, i16 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i16, i16 addrspace(1)* %cptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0
  %b = load i16, i16 addrspace(1)* %gep1
  %c = load i16, i16 addrspace(1)* %gep2
  %icmp0 = icmp slt i16 %a, %b
  %i0 = select i1 %icmp0, i16 %a, i16 %b
  %icmp1 = icmp slt i16 %i0, %c
  %i1 = select i1 %icmp1, i16 %i0, i16 %c
  store i16 %i1, i16 addrspace(1)* %outgep
  ret void
}

; GCN-LABEL: {{^}}v_test_umin3_ult_i16:
; SI: v_min3_u32

; VI: v_min_u16
; VI: v_min_u16

; GFX9: v_min3_u16
define amdgpu_kernel void @v_test_umin3_ult_i16(i16 addrspace(1)* %out, i16 addrspace(1)* %aptr, i16 addrspace(1)* %bptr, i16 addrspace(1)* %cptr) #0 {
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep0 = getelementptr i16, i16 addrspace(1)* %aptr, i32 %tid
  %gep1 = getelementptr i16, i16 addrspace(1)* %bptr, i32 %tid
  %gep2 = getelementptr i16, i16 addrspace(1)* %cptr, i32 %tid
  %outgep = getelementptr i16, i16 addrspace(1)* %out, i32 %tid
  %a = load i16, i16 addrspace(1)* %gep0
  %b = load i16, i16 addrspace(1)* %gep1
  %c = load i16, i16 addrspace(1)* %gep2
  %icmp0 = icmp ult i16 %a, %b
  %i0 = select i1 %icmp0, i16 %a, i16 %b
  %icmp1 = icmp ult i16 %i0, %c
  %i1 = select i1 %icmp1, i16 %i0, i16 %c
  store i16 %i1, i16 addrspace(1)* %outgep
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone speculatable }
