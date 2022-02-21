; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck %s -check-prefix=MUBUF
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -mattr=+enable-flat-scratch < %s | FileCheck %s -check-prefix=FLATSCR

; Make sure there's no assertion from passing a 0 alignment value
define void @memcpy_fixed_align(i8 addrspace(5)*  %dst, i8 addrspace(1)* %src) {
; MUBUF-LABEL: memcpy_fixed_align:
; MUBUF:       ; %bb.0:
; MUBUF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; MUBUF-NEXT:    global_load_dwordx2 v[11:12], v[1:2], off offset:32
; MUBUF-NEXT:    global_load_dwordx4 v[3:6], v[1:2], off offset:16
; MUBUF-NEXT:    global_load_dwordx4 v[7:10], v[1:2], off
; MUBUF-NEXT:    s_waitcnt vmcnt(2)
; MUBUF-NEXT:    buffer_store_dword v12, off, s[0:3], s32 offset:36
; MUBUF-NEXT:    buffer_store_dword v11, off, s[0:3], s32 offset:32
; MUBUF-NEXT:    s_waitcnt vmcnt(3)
; MUBUF-NEXT:    buffer_store_dword v6, off, s[0:3], s32 offset:28
; MUBUF-NEXT:    buffer_store_dword v5, off, s[0:3], s32 offset:24
; MUBUF-NEXT:    buffer_store_dword v4, off, s[0:3], s32 offset:20
; MUBUF-NEXT:    buffer_store_dword v3, off, s[0:3], s32 offset:16
; MUBUF-NEXT:    s_waitcnt vmcnt(6)
; MUBUF-NEXT:    buffer_store_dword v10, off, s[0:3], s32 offset:12
; MUBUF-NEXT:    buffer_store_dword v9, off, s[0:3], s32 offset:8
; MUBUF-NEXT:    buffer_store_dword v8, off, s[0:3], s32 offset:4
; MUBUF-NEXT:    buffer_store_dword v7, off, s[0:3], s32
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: memcpy_fixed_align:
; FLATSCR:       ; %bb.0:
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    global_load_dwordx2 v[11:12], v[1:2], off offset:32
; FLATSCR-NEXT:    global_load_dwordx4 v[3:6], v[1:2], off offset:16
; FLATSCR-NEXT:    global_load_dwordx4 v[7:10], v[1:2], off
; FLATSCR-NEXT:    s_waitcnt vmcnt(2)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[11:12], s32 offset:32
; FLATSCR-NEXT:    s_waitcnt vmcnt(2)
; FLATSCR-NEXT:    scratch_store_dwordx4 off, v[3:6], s32 offset:16
; FLATSCR-NEXT:    s_waitcnt vmcnt(2)
; FLATSCR-NEXT:    scratch_store_dwordx4 off, v[7:10], s32
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
  %alloca = alloca [40 x i8], addrspace(5)
  %cast = bitcast [40 x i8] addrspace(5)* %alloca to i8 addrspace(5)*
  call void @llvm.memcpy.p5i8.p1i8.i64(i8 addrspace(5)* align 4 dereferenceable(40) %cast, i8 addrspace(1)* align 4 dereferenceable(40) %src, i64 40, i1 false)
  ret void
}

declare void @llvm.memcpy.p5i8.p1i8.i64(i8 addrspace(5)* noalias nocapture writeonly, i8 addrspace(1)* noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nounwind willreturn }
