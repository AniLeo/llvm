; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -verify-machineinstrs -amdgpu-mem-intrinsic-expand-size=19 %s -o - | FileCheck -check-prefix=LOOP %s
; RUN: llc -global-isel -march=amdgcn -verify-machineinstrs -amdgpu-mem-intrinsic-expand-size=21 %s -o - | FileCheck -check-prefix=UNROLL %s

declare void @llvm.memcpy.p1i8.p1i8.i32(i8 addrspace(1)*, i8 addrspace(1)*, i32, i1 immarg)

define amdgpu_cs void @memcpy_p1i8(i8 addrspace(1)* %dst, i8 addrspace(1)* %src) {
; LOOP-LABEL: memcpy_p1i8:
; LOOP:       ; %bb.0:
; LOOP-NEXT:    s_mov_b32 s6, 0
; LOOP-NEXT:    s_mov_b32 s7, 0xf000
; LOOP-NEXT:    s_mov_b64 s[4:5], 0
; LOOP-NEXT:    v_mov_b32_e32 v5, v3
; LOOP-NEXT:    v_mov_b32_e32 v4, v2
; LOOP-NEXT:    v_mov_b32_e32 v7, v1
; LOOP-NEXT:    v_mov_b32_e32 v6, v0
; LOOP-NEXT:    v_mov_b32_e32 v8, s6
; LOOP-NEXT:  BB0_1: ; %load-store-loop
; LOOP-NEXT:    ; =>This Inner Loop Header: Depth=1
; LOOP-NEXT:    buffer_load_ubyte v9, v[4:5], s[4:7], 0 addr64
; LOOP-NEXT:    buffer_load_ubyte v10, v[4:5], s[4:7], 0 addr64 offset:1
; LOOP-NEXT:    buffer_load_ubyte v11, v[4:5], s[4:7], 0 addr64 offset:2
; LOOP-NEXT:    buffer_load_ubyte v12, v[4:5], s[4:7], 0 addr64 offset:3
; LOOP-NEXT:    buffer_load_ubyte v13, v[4:5], s[4:7], 0 addr64 offset:4
; LOOP-NEXT:    buffer_load_ubyte v14, v[4:5], s[4:7], 0 addr64 offset:5
; LOOP-NEXT:    buffer_load_ubyte v15, v[4:5], s[4:7], 0 addr64 offset:6
; LOOP-NEXT:    buffer_load_ubyte v16, v[4:5], s[4:7], 0 addr64 offset:7
; LOOP-NEXT:    buffer_load_ubyte v17, v[4:5], s[4:7], 0 addr64 offset:8
; LOOP-NEXT:    s_waitcnt expcnt(6)
; LOOP-NEXT:    buffer_load_ubyte v18, v[4:5], s[4:7], 0 addr64 offset:9
; LOOP-NEXT:    s_waitcnt expcnt(5)
; LOOP-NEXT:    buffer_load_ubyte v19, v[4:5], s[4:7], 0 addr64 offset:10
; LOOP-NEXT:    s_waitcnt expcnt(4)
; LOOP-NEXT:    buffer_load_ubyte v20, v[4:5], s[4:7], 0 addr64 offset:11
; LOOP-NEXT:    s_waitcnt expcnt(3)
; LOOP-NEXT:    buffer_load_ubyte v21, v[4:5], s[4:7], 0 addr64 offset:12
; LOOP-NEXT:    s_waitcnt expcnt(2)
; LOOP-NEXT:    buffer_load_ubyte v22, v[4:5], s[4:7], 0 addr64 offset:13
; LOOP-NEXT:    s_waitcnt expcnt(1)
; LOOP-NEXT:    buffer_load_ubyte v23, v[4:5], s[4:7], 0 addr64 offset:14
; LOOP-NEXT:    s_waitcnt expcnt(0)
; LOOP-NEXT:    buffer_load_ubyte v24, v[4:5], s[4:7], 0 addr64 offset:15
; LOOP-NEXT:    v_add_i32_e32 v8, vcc, 1, v8
; LOOP-NEXT:    s_xor_b64 s[0:1], vcc, -1
; LOOP-NEXT:    s_xor_b64 s[0:1], s[0:1], -1
; LOOP-NEXT:    s_and_b64 vcc, s[0:1], exec
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v9, v[6:7], s[4:7], 0 addr64
; LOOP-NEXT:    buffer_store_byte v10, v[6:7], s[4:7], 0 addr64 offset:1
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v11, v[6:7], s[4:7], 0 addr64 offset:2
; LOOP-NEXT:    buffer_store_byte v12, v[6:7], s[4:7], 0 addr64 offset:3
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v13, v[6:7], s[4:7], 0 addr64 offset:4
; LOOP-NEXT:    buffer_store_byte v14, v[6:7], s[4:7], 0 addr64 offset:5
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v15, v[6:7], s[4:7], 0 addr64 offset:6
; LOOP-NEXT:    buffer_store_byte v16, v[6:7], s[4:7], 0 addr64 offset:7
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v17, v[6:7], s[4:7], 0 addr64 offset:8
; LOOP-NEXT:    buffer_store_byte v18, v[6:7], s[4:7], 0 addr64 offset:9
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v19, v[6:7], s[4:7], 0 addr64 offset:10
; LOOP-NEXT:    buffer_store_byte v20, v[6:7], s[4:7], 0 addr64 offset:11
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v21, v[6:7], s[4:7], 0 addr64 offset:12
; LOOP-NEXT:    buffer_store_byte v22, v[6:7], s[4:7], 0 addr64 offset:13
; LOOP-NEXT:    s_waitcnt vmcnt(14)
; LOOP-NEXT:    buffer_store_byte v23, v[6:7], s[4:7], 0 addr64 offset:14
; LOOP-NEXT:    buffer_store_byte v24, v[6:7], s[4:7], 0 addr64 offset:15
; LOOP-NEXT:    v_add_i32_e64 v6, s[0:1], 16, v6
; LOOP-NEXT:    v_addc_u32_e64 v7, s[0:1], 0, v7, s[0:1]
; LOOP-NEXT:    v_add_i32_e64 v4, s[0:1], 16, v4
; LOOP-NEXT:    v_addc_u32_e64 v5, s[0:1], 0, v5, s[0:1]
; LOOP-NEXT:    s_cbranch_vccnz BB0_1
; LOOP-NEXT:  ; %bb.2: ; %memcpy-split
; LOOP-NEXT:    s_mov_b32 s2, 0
; LOOP-NEXT:    s_mov_b32 s3, 0xf000
; LOOP-NEXT:    s_mov_b64 s[0:1], 0
; LOOP-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:16
; LOOP-NEXT:    buffer_load_ubyte v5, v[2:3], s[0:3], 0 addr64 offset:17
; LOOP-NEXT:    buffer_load_ubyte v6, v[2:3], s[0:3], 0 addr64 offset:18
; LOOP-NEXT:    buffer_load_ubyte v2, v[2:3], s[0:3], 0 addr64 offset:19
; LOOP-NEXT:    s_waitcnt vmcnt(3)
; LOOP-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:16
; LOOP-NEXT:    s_waitcnt vmcnt(3)
; LOOP-NEXT:    buffer_store_byte v5, v[0:1], s[0:3], 0 addr64 offset:17
; LOOP-NEXT:    s_waitcnt vmcnt(3)
; LOOP-NEXT:    buffer_store_byte v6, v[0:1], s[0:3], 0 addr64 offset:18
; LOOP-NEXT:    s_waitcnt vmcnt(3)
; LOOP-NEXT:    buffer_store_byte v2, v[0:1], s[0:3], 0 addr64 offset:19
; LOOP-NEXT:    s_endpgm
;
; UNROLL-LABEL: memcpy_p1i8:
; UNROLL:       ; %bb.0:
; UNROLL-NEXT:    s_mov_b32 s2, 0
; UNROLL-NEXT:    s_mov_b32 s3, 0xf000
; UNROLL-NEXT:    s_mov_b64 s[0:1], 0
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:1
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:1
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:2
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:2
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:3
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:3
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:4
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:4
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:5
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:5
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:6
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:6
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:7
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:7
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:8
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:8
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:9
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:9
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:10
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:10
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:11
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:11
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:12
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:12
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:13
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:13
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:14
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:14
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:15
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:15
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:16
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:16
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:17
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:17
; UNROLL-NEXT:    s_waitcnt expcnt(0)
; UNROLL-NEXT:    buffer_load_ubyte v4, v[2:3], s[0:3], 0 addr64 offset:18
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v4, v[0:1], s[0:3], 0 addr64 offset:18
; UNROLL-NEXT:    buffer_load_ubyte v2, v[2:3], s[0:3], 0 addr64 offset:19
; UNROLL-NEXT:    s_waitcnt vmcnt(0)
; UNROLL-NEXT:    buffer_store_byte v2, v[0:1], s[0:3], 0 addr64 offset:19
; UNROLL-NEXT:    s_endpgm
  call void @llvm.memcpy.p1i8.p1i8.i32(i8 addrspace(1)* %dst, i8 addrspace(1)* %src, i32 20, i1 false)
  ret void
}

