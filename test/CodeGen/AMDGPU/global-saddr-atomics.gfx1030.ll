; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1030 < %s | FileCheck --check-prefix=GCN %s

; --------------------------------------------------------------------------------
; amdgcn atomic csub
; --------------------------------------------------------------------------------

define amdgpu_ps float @global_csub_saddr_i32_rtn(i8 addrspace(1)* inreg %sbase, i32 %voffset, i32 %data) {
; GCN-LABEL: global_csub_saddr_i32_rtn:
; GCN:       ; %bb.0:
; GCN-NEXT:    global_atomic_csub v0, v0, v1, s[2:3] glc
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %zext.offset = zext i32 %voffset to i64
  %gep0 = getelementptr inbounds i8, i8 addrspace(1)* %sbase, i64 %zext.offset
  %cast.gep0 = bitcast i8 addrspace(1)* %gep0 to i32 addrspace(1)*
  %rtn = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* %cast.gep0, i32 %data)
  %cast.rtn = bitcast i32 %rtn to float
  ret float %cast.rtn
}

define amdgpu_ps float @global_csub_saddr_i32_rtn_neg128(i8 addrspace(1)* inreg %sbase, i32 %voffset, i32 %data) {
; GCN-LABEL: global_csub_saddr_i32_rtn_neg128:
; GCN:       ; %bb.0:
; GCN-NEXT:    global_atomic_csub v0, v0, v1, s[2:3] offset:-128 glc
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %zext.offset = zext i32 %voffset to i64
  %gep0 = getelementptr inbounds i8, i8 addrspace(1)* %sbase, i64 %zext.offset
  %gep1 = getelementptr inbounds i8, i8 addrspace(1)* %gep0, i64 -128
  %cast.gep1 = bitcast i8 addrspace(1)* %gep1 to i32 addrspace(1)*
  %rtn = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* %cast.gep1, i32 %data)
  %cast.rtn = bitcast i32 %rtn to float
  ret float %cast.rtn
}

define amdgpu_ps void @global_csub_saddr_i32_nortn(i8 addrspace(1)* inreg %sbase, i32 %voffset, i32 %data) {
; GCN-LABEL: global_csub_saddr_i32_nortn:
; GCN:       ; %bb.0:
; GCN-NEXT:    global_atomic_csub v0, v0, v1, s[2:3] glc
; GCN-NEXT:    s_endpgm
  %zext.offset = zext i32 %voffset to i64
  %gep0 = getelementptr inbounds i8, i8 addrspace(1)* %sbase, i64 %zext.offset
  %cast.gep0 = bitcast i8 addrspace(1)* %gep0 to i32 addrspace(1)*
  %unused = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* %cast.gep0, i32 %data)
  ret void
}

define amdgpu_ps void @global_csub_saddr_i32_nortn_neg128(i8 addrspace(1)* inreg %sbase, i32 %voffset, i32 %data) {
; GCN-LABEL: global_csub_saddr_i32_nortn_neg128:
; GCN:       ; %bb.0:
; GCN-NEXT:    global_atomic_csub v0, v0, v1, s[2:3] offset:-128 glc
; GCN-NEXT:    s_endpgm
  %zext.offset = zext i32 %voffset to i64
  %gep0 = getelementptr inbounds i8, i8 addrspace(1)* %sbase, i64 %zext.offset
  %gep1 = getelementptr inbounds i8, i8 addrspace(1)* %gep0, i64 -128
  %cast.gep1 = bitcast i8 addrspace(1)* %gep1 to i32 addrspace(1)*
  %unused = call i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* %cast.gep1, i32 %data)
  ret void
}

declare i32 @llvm.amdgcn.global.atomic.csub.p1i32(i32 addrspace(1)* nocapture, i32) #0

attributes #0 = { argmemonly nounwind willreturn }
