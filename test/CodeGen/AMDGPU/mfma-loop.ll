; RUN: llc -march=amdgcn -mcpu=gfx908 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; GCN-LABEL: {{^}}test_mfma_loop_zeroinit:

; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}

; Check that we do not copy agprs to vgprs and back inside the loop.

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; Final result should be read only once after the loop.

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_zeroinit(<32 x float> addrspace(1)* %arg) {
entry:
  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ zeroinitializer, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_unfoldable_splat:

; Check that we do not use 32 temp vgprs, but rotate 3 vgprs only.
; 3 vgprs are needed to avoid wait states between writes.
; Check that we do not use 32 temp sgprs as well.

; GCN:         v_mov_b32_e32 [[TMP:v[0-9]+]], 0x42f60000
; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP]]

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_unfoldable_splat(<32 x float> addrspace(1)* %arg) {
entry:
  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ <float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0, float 123.0>, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_non_splat:

; GCN:         v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN:         v_accvgpr_write_b32 a{{[0-9]+}}, 1.0{{$}}
; GCN-COUNT-30: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_non_splat(<32 x float> addrspace(1)* %arg) {
entry:
  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ <float 0.0, float 1.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0>, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_unfoldable_seq:

; Check that we do not use 32 temp vgprs, but rotate 3 vgprs only.
; 3 vgprs are needed to avoid wait states between writes.

; GCN: v_mov_b32_e32 [[TMP1:v[0-9]+]], 0x42f60000
; GCN: v_mov_b32_e32 [[TMP2:v[0-9]+]], 0x42f80000
; GCN: v_mov_b32_e32 [[TMP3:v[0-9]+]], 0x42fe0000
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]
; GCN: v_mov_b32_e32 [[TMP1]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP2]], 0x4{{[0-9a-f]+}}
; GCN: v_mov_b32_e32 [[TMP3]], 0x4{{[0-9a-f]+}}
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP1]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP2]]
; GCN: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP3]]

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_unfoldable_seq(<32 x float> addrspace(1)* %arg) {
entry:
  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ <float 123.0, float 124.0, float 125.0, float 126.0, float 127.0, float 128.0, float 129.0, float 130.0, float 131.0, float 132.0, float 133.0, float 134.0, float 135.0, float 136.0, float 137.0, float 138.0, float 139.0, float 140.0, float 141.0, float 142.0, float 143.0, float 144.0, float 145.0, float 146.0, float 147.0, float 148.0, float 149.0, float 150.0, float 151.0, float 152.0, float 153.0, float 154.0>, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_vgpr_init:

; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, v0{{$}}

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_vgpr_init(<32 x float> addrspace(1)* %arg) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %init = bitcast i32 %tid to float
  %tmp0 = insertelement <32 x float> undef, float %init, i32 0
  %tmp1 = insertelement <32 x float> %tmp0, float %init, i32 1
  %tmp2 = insertelement <32 x float> %tmp1, float %init, i32 2
  %tmp3 = insertelement <32 x float> %tmp2, float %init, i32 3
  %tmp4 = insertelement <32 x float> %tmp3, float %init, i32 4
  %tmp5 = insertelement <32 x float> %tmp4, float %init, i32 5
  %tmp6 = insertelement <32 x float> %tmp5, float %init, i32 6
  %tmp7 = insertelement <32 x float> %tmp6, float %init, i32 7
  %tmp8 = insertelement <32 x float> %tmp7, float %init, i32 8
  %tmp9 = insertelement <32 x float> %tmp8, float %init, i32 9
  %tmp10 = insertelement <32 x float> %tmp9, float %init, i32 10
  %tmp11 = insertelement <32 x float> %tmp10, float %init, i32 11
  %tmp12 = insertelement <32 x float> %tmp11, float %init, i32 12
  %tmp13 = insertelement <32 x float> %tmp12, float %init, i32 13
  %tmp14 = insertelement <32 x float> %tmp13, float %init, i32 14
  %tmp15 = insertelement <32 x float> %tmp14, float %init, i32 15
  %tmp16 = insertelement <32 x float> %tmp15, float %init, i32 16
  %tmp17 = insertelement <32 x float> %tmp16, float %init, i32 17
  %tmp18 = insertelement <32 x float> %tmp17, float %init, i32 18
  %tmp19 = insertelement <32 x float> %tmp18, float %init, i32 19
  %tmp20 = insertelement <32 x float> %tmp19, float %init, i32 20
  %tmp21 = insertelement <32 x float> %tmp20, float %init, i32 21
  %tmp22 = insertelement <32 x float> %tmp21, float %init, i32 22
  %tmp23 = insertelement <32 x float> %tmp22, float %init, i32 23
  %tmp24 = insertelement <32 x float> %tmp23, float %init, i32 24
  %tmp25 = insertelement <32 x float> %tmp24, float %init, i32 25
  %tmp26 = insertelement <32 x float> %tmp25, float %init, i32 26
  %tmp27 = insertelement <32 x float> %tmp26, float %init, i32 27
  %tmp28 = insertelement <32 x float> %tmp27, float %init, i32 28
  %tmp29 = insertelement <32 x float> %tmp28, float %init, i32 29
  %tmp30 = insertelement <32 x float> %tmp29, float %init, i32 30
  %tmp31 = insertelement <32 x float> %tmp30, float %init, i32 31

  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ %tmp31, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_sgpr_init:

; GCN:         v_mov_b32_e32 [[TMP:v[0-9]+]], s{{[0-9]+}}
; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP]]

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_sgpr_init(<32 x float> addrspace(1)* %arg, float %init) {
entry:
  %tmp0 = insertelement <32 x float> undef, float %init, i32 0
  %tmp1 = insertelement <32 x float> %tmp0, float %init, i32 1
  %tmp2 = insertelement <32 x float> %tmp1, float %init, i32 2
  %tmp3 = insertelement <32 x float> %tmp2, float %init, i32 3
  %tmp4 = insertelement <32 x float> %tmp3, float %init, i32 4
  %tmp5 = insertelement <32 x float> %tmp4, float %init, i32 5
  %tmp6 = insertelement <32 x float> %tmp5, float %init, i32 6
  %tmp7 = insertelement <32 x float> %tmp6, float %init, i32 7
  %tmp8 = insertelement <32 x float> %tmp7, float %init, i32 8
  %tmp9 = insertelement <32 x float> %tmp8, float %init, i32 9
  %tmp10 = insertelement <32 x float> %tmp9, float %init, i32 10
  %tmp11 = insertelement <32 x float> %tmp10, float %init, i32 11
  %tmp12 = insertelement <32 x float> %tmp11, float %init, i32 12
  %tmp13 = insertelement <32 x float> %tmp12, float %init, i32 13
  %tmp14 = insertelement <32 x float> %tmp13, float %init, i32 14
  %tmp15 = insertelement <32 x float> %tmp14, float %init, i32 15
  %tmp16 = insertelement <32 x float> %tmp15, float %init, i32 16
  %tmp17 = insertelement <32 x float> %tmp16, float %init, i32 17
  %tmp18 = insertelement <32 x float> %tmp17, float %init, i32 18
  %tmp19 = insertelement <32 x float> %tmp18, float %init, i32 19
  %tmp20 = insertelement <32 x float> %tmp19, float %init, i32 20
  %tmp21 = insertelement <32 x float> %tmp20, float %init, i32 21
  %tmp22 = insertelement <32 x float> %tmp21, float %init, i32 22
  %tmp23 = insertelement <32 x float> %tmp22, float %init, i32 23
  %tmp24 = insertelement <32 x float> %tmp23, float %init, i32 24
  %tmp25 = insertelement <32 x float> %tmp24, float %init, i32 25
  %tmp26 = insertelement <32 x float> %tmp25, float %init, i32 26
  %tmp27 = insertelement <32 x float> %tmp26, float %init, i32 27
  %tmp28 = insertelement <32 x float> %tmp27, float %init, i32 28
  %tmp29 = insertelement <32 x float> %tmp28, float %init, i32 29
  %tmp30 = insertelement <32 x float> %tmp29, float %init, i32 30
  %tmp31 = insertelement <32 x float> %tmp30, float %init, i32 31

  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ %tmp31, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_mixed_init:

; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, v0
; GCN-DAG: v_mov_b32_e32 [[TMP:v[0-9]+]], s{{[0-9]+}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP]]
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}
; GCN-DAG: v_accvgpr_write_b32 a{{[0-9]+}}, 0{{$}}

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32

define amdgpu_kernel void @test_mfma_loop_mixed_init(<32 x float> addrspace(1)* %arg, float %x) {
entry:
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %init = bitcast i32 %tid to float
  %tmp0 = insertelement <32 x float> zeroinitializer, float %init, i32 0
  %tmp1 = insertelement <32 x float> %tmp0, float %x, i32 1

  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ %tmp1, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_mfma_forward_init:

; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, 0
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32
define amdgpu_kernel void @test_mfma_loop_mfma_forward_init(<32 x float> addrspace(1)* %arg) {
entry:
  %mai.0 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> zeroinitializer, i32 0, i32 0, i32 0)

  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ %mai.0, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

; GCN-LABEL: {{^}}test_mfma_loop_agpr_init:

; GCN-COUNT-32: v_accvgpr_write_b32 a{{[0-9]+}}, 0
; GCN: v_mfma_f32_32x32x1f32

; Check that we are using only one tmp VGPR.

; GCN: v_accvgpr_read_b32 [[TMP:v[0-9]+]], a{{[0-9]+}}
; GCN-COUNT-31: v_accvgpr_write_b32 a{{[0-9]+}}, [[TMP]]{{$}}

; GCN: [[LOOP:BB[0-9_]+]]:
; GCN-NOT: v_accvgpr
; GCN: v_mfma_f32_32x32x1f32
; GCN-NOT: v_accvgpr
; GCN: s_cbranch_scc1 [[LOOP]]

; GCN-COUNT-32: v_accvgpr_read_b32
define amdgpu_kernel void @test_mfma_loop_agpr_init(<32 x float> addrspace(1)* %arg) {
entry:
  %mai.0 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> zeroinitializer, i32 0, i32 0, i32 0)
  %init = extractelement <32 x float> %mai.0, i32 0
  %tmp0 = insertelement <32 x float> undef, float %init, i32 0
  %tmp1 = insertelement <32 x float> %tmp0, float %init, i32 1
  %tmp2 = insertelement <32 x float> %tmp1, float %init, i32 2
  %tmp3 = insertelement <32 x float> %tmp2, float %init, i32 3
  %tmp4 = insertelement <32 x float> %tmp3, float %init, i32 4
  %tmp5 = insertelement <32 x float> %tmp4, float %init, i32 5
  %tmp6 = insertelement <32 x float> %tmp5, float %init, i32 6
  %tmp7 = insertelement <32 x float> %tmp6, float %init, i32 7
  %tmp8 = insertelement <32 x float> %tmp7, float %init, i32 8
  %tmp9 = insertelement <32 x float> %tmp8, float %init, i32 9
  %tmp10 = insertelement <32 x float> %tmp9, float %init, i32 10
  %tmp11 = insertelement <32 x float> %tmp10, float %init, i32 11
  %tmp12 = insertelement <32 x float> %tmp11, float %init, i32 12
  %tmp13 = insertelement <32 x float> %tmp12, float %init, i32 13
  %tmp14 = insertelement <32 x float> %tmp13, float %init, i32 14
  %tmp15 = insertelement <32 x float> %tmp14, float %init, i32 15
  %tmp16 = insertelement <32 x float> %tmp15, float %init, i32 16
  %tmp17 = insertelement <32 x float> %tmp16, float %init, i32 17
  %tmp18 = insertelement <32 x float> %tmp17, float %init, i32 18
  %tmp19 = insertelement <32 x float> %tmp18, float %init, i32 19
  %tmp20 = insertelement <32 x float> %tmp19, float %init, i32 20
  %tmp21 = insertelement <32 x float> %tmp20, float %init, i32 21
  %tmp22 = insertelement <32 x float> %tmp21, float %init, i32 22
  %tmp23 = insertelement <32 x float> %tmp22, float %init, i32 23
  %tmp24 = insertelement <32 x float> %tmp23, float %init, i32 24
  %tmp25 = insertelement <32 x float> %tmp24, float %init, i32 25
  %tmp26 = insertelement <32 x float> %tmp25, float %init, i32 26
  %tmp27 = insertelement <32 x float> %tmp26, float %init, i32 27
  %tmp28 = insertelement <32 x float> %tmp27, float %init, i32 28
  %tmp29 = insertelement <32 x float> %tmp28, float %init, i32 29
  %tmp30 = insertelement <32 x float> %tmp29, float %init, i32 30
  %tmp31 = insertelement <32 x float> %tmp30, float %init, i32 31

  br label %for.cond.preheader

for.cond.preheader:
  %phi = phi <32 x float> [ %tmp31, %entry ], [ %mai.1, %for.cond.preheader ]
  %c = phi i32 [ 0, %entry ], [ %inc, %for.cond.preheader ]
  %mai.1 = tail call <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float 1.0, float 2.0, <32 x float> %phi, i32 0, i32 0, i32 0)
  %inc = add nuw nsw i32 %c, 1
  %cc = icmp eq i32 %inc, 16
  br i1 %cc, label %exit, label %for.cond.preheader

exit:
  store <32 x float> %mai.1, <32 x float> addrspace(1)* %arg
  ret void
}

declare <32 x float> @llvm.amdgcn.mfma.f32.32x32x1f32(float, float, <32 x float>, i32, i32, i32)
declare i32 @llvm.amdgcn.workitem.id.x()
