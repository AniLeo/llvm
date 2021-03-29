; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii -mattr=-unaligned-scratch-access < %s | FileCheck --check-prefix=GFX7-ALIGNED %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii -mattr=+unaligned-scratch-access < %s | FileCheck --check-prefix=GFX7-UNALIGNED %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -mattr=+unaligned-scratch-access < %s | FileCheck --check-prefix=GFX9 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -mattr=+unaligned-scratch-access -amdgpu-enable-flat-scratch < %s | FileCheck --check-prefix=GFX9-FLASTSCR %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -mattr=+unaligned-scratch-access < %s | FileCheck --check-prefix=GFX10 %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx1010 -mattr=+unaligned-scratch-access -amdgpu-enable-flat-scratch < %s | FileCheck --check-prefix=GFX10-FLASTSCR %s

; Should not merge this to a dword load
define i32 @private_load_2xi16_align2(i16 addrspace(5)* %p) #0 {
; GFX7-ALIGNED-LABEL: private_load_2xi16_align2:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v1, vcc, 2, v0
; GFX7-ALIGNED-NEXT:    buffer_load_ushort v0, v0, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_load_ushort v1, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-ALIGNED-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_load_2xi16_align2:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_add_i32_e32 v1, vcc, 2, v0
; GFX7-UNALIGNED-NEXT:    buffer_load_ushort v0, v0, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    buffer_load_ushort v1, v1, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-UNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_load_2xi16_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    buffer_load_ushort v1, v0, s[0:3], 0 offen
; GFX9-NEXT:    buffer_load_ushort v2, v0, s[0:3], 0 offen offset:2
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshl_or_b32 v0, v2, 16, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_load_2xi16_align2:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    scratch_load_ushort v1, v0, off
; GFX9-FLASTSCR-NEXT:    scratch_load_ushort v2, v0, off offset:2
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_lshl_or_b32 v0, v2, 16, v1
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_load_2xi16_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    buffer_load_ushort v1, v0, s[0:3], 0 offen
; GFX10-NEXT:    buffer_load_ushort v2, v0, s[0:3], 0 offen offset:2
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_lshl_or_b32 v0, v2, 16, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_load_2xi16_align2:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    s_clause 0x1
; GFX10-FLASTSCR-NEXT:    scratch_load_ushort v1, v0, off
; GFX10-FLASTSCR-NEXT:    scratch_load_ushort v2, v0, off offset:2
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX10-FLASTSCR-NEXT:    v_lshl_or_b32 v0, v2, 16, v1
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.p = getelementptr i16, i16 addrspace(5)* %p, i64 1
  %p.0 = load i16, i16 addrspace(5)* %p, align 2
  %p.1 = load i16, i16 addrspace(5)* %gep.p, align 2
  %zext.0 = zext i16 %p.0 to i32
  %zext.1 = zext i16 %p.1 to i32
  %shl.1 = shl i32 %zext.1, 16
  %or = or i32 %zext.0, %shl.1
  ret i32 %or
}

; Should not merge this to a dword store
define void @private_store_2xi16_align2(i16 addrspace(5)* %p, i16 addrspace(5)* %r) #0 {
; GFX7-ALIGNED-LABEL: private_store_2xi16_align2:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v3, 1
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v0, 2
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v2, vcc, 2, v1
; GFX7-ALIGNED-NEXT:    buffer_store_short v3, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_store_short v0, v2, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_store_2xi16_align2:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v3, 1
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v0, 2
; GFX7-UNALIGNED-NEXT:    v_add_i32_e32 v2, vcc, 2, v1
; GFX7-UNALIGNED-NEXT:    buffer_store_short v3, v1, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    buffer_store_short v0, v2, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_store_2xi16_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 1
; GFX9-NEXT:    buffer_store_short v0, v1, s[0:3], 0 offen
; GFX9-NEXT:    v_mov_b32_e32 v0, 2
; GFX9-NEXT:    buffer_store_short v0, v1, s[0:3], 0 offen offset:2
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_store_2xi16_align2:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 1
; GFX9-FLASTSCR-NEXT:    scratch_store_short v1, v0, off
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 2
; GFX9-FLASTSCR-NEXT:    scratch_store_short v1, v0, off offset:2
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_store_2xi16_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v0, 1
; GFX10-NEXT:    v_mov_b32_e32 v2, 2
; GFX10-NEXT:    buffer_store_short v0, v1, s[0:3], 0 offen
; GFX10-NEXT:    buffer_store_short v2, v1, s[0:3], 0 offen offset:2
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_store_2xi16_align2:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 1
; GFX10-FLASTSCR-NEXT:    v_mov_b32_e32 v2, 2
; GFX10-FLASTSCR-NEXT:    scratch_store_short v1, v0, off
; GFX10-FLASTSCR-NEXT:    scratch_store_short v1, v2, off offset:2
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.r = getelementptr i16, i16 addrspace(5)* %r, i64 1
  store i16 1, i16 addrspace(5)* %r, align 2
  store i16 2, i16 addrspace(5)* %gep.r, align 2
  ret void
}

; Should produce align 1 dword when legal
define i32 @private_load_2xi16_align1(i16 addrspace(5)* %p) #0 {
; GFX7-ALIGNED-LABEL: private_load_2xi16_align1:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v1, vcc, 2, v0
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v2, vcc, 1, v0
; GFX7-ALIGNED-NEXT:    buffer_load_ubyte v3, v0, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v0, vcc, 3, v0
; GFX7-ALIGNED-NEXT:    buffer_load_ubyte v0, v0, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_load_ubyte v2, v2, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_load_ubyte v1, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(2)
; GFX7-ALIGNED-NEXT:    v_lshlrev_b32_e32 v0, 8, v0
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(1)
; GFX7-ALIGNED-NEXT:    v_lshlrev_b32_e32 v2, 8, v2
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-ALIGNED-NEXT:    v_or_b32_e32 v2, v2, v3
; GFX7-ALIGNED-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX7-ALIGNED-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_load_2xi16_align1:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_load_2xi16_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX9-NEXT:    v_mov_b32_e32 v1, 0xffff
; GFX9-NEXT:    s_mov_b32 s4, 0xffff
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_bfi_b32 v1, v1, 0, v0
; GFX9-NEXT:    v_and_or_b32 v0, v0, s4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_load_2xi16_align1:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    scratch_load_dword v0, v0, off
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v1, 0xffff
; GFX9-FLASTSCR-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_bfi_b32 v1, v1, 0, v0
; GFX9-FLASTSCR-NEXT:    v_and_or_b32 v0, v0, s0, v1
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_load_2xi16_align1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_bfi_b32 v1, 0xffff, 0, v0
; GFX10-NEXT:    v_and_or_b32 v0, 0xffff, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_load_2xi16_align1:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    scratch_load_dword v0, v0, off
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX10-FLASTSCR-NEXT:    v_bfi_b32 v1, 0xffff, 0, v0
; GFX10-FLASTSCR-NEXT:    v_and_or_b32 v0, 0xffff, v0, v1
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.p = getelementptr i16, i16 addrspace(5)* %p, i64 1
  %p.0 = load i16, i16 addrspace(5)* %p, align 1
  %p.1 = load i16, i16 addrspace(5)* %gep.p, align 1
  %zext.0 = zext i16 %p.0 to i32
  %zext.1 = zext i16 %p.1 to i32
  %shl.1 = shl i32 %zext.1, 16
  %or = or i32 %zext.0, %shl.1
  ret i32 %or
}

; Should produce align 1 dword when legal
define void @private_store_2xi16_align1(i16 addrspace(5)* %p, i16 addrspace(5)* %r) #0 {
; GFX7-ALIGNED-LABEL: private_store_2xi16_align1:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v3, 1
; GFX7-ALIGNED-NEXT:    buffer_store_byte v3, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v2, vcc, 2, v1
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v3, vcc, 1, v1
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v4, 0
; GFX7-ALIGNED-NEXT:    v_add_i32_e32 v1, vcc, 3, v1
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v0, 2
; GFX7-ALIGNED-NEXT:    buffer_store_byte v4, v3, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_store_byte v4, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    buffer_store_byte v0, v2, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_store_2xi16_align1:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX7-UNALIGNED-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_store_2xi16_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX9-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_store_2xi16_align1:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX9-FLASTSCR-NEXT:    scratch_store_dword v1, v0, off
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_store_2xi16_align1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX10-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_store_2xi16_align1:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX10-FLASTSCR-NEXT:    scratch_store_dword v1, v0, off
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.r = getelementptr i16, i16 addrspace(5)* %r, i64 1
  store i16 1, i16 addrspace(5)* %r, align 1
  store i16 2, i16 addrspace(5)* %gep.r, align 1
  ret void
}

; Should merge this to a dword load
define i32 @private_load_2xi16_align4(i16 addrspace(5)* %p) #0 {
; GFX7-LABEL: load_2xi16_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    flat_load_dword v0, v[0:1]
; GFX7-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-ALIGNED-LABEL: private_load_2xi16_align4:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_load_2xi16_align4:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_load_2xi16_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX9-NEXT:    v_mov_b32_e32 v1, 0xffff
; GFX9-NEXT:    s_mov_b32 s4, 0xffff
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_bfi_b32 v1, v1, 0, v0
; GFX9-NEXT:    v_and_or_b32 v0, v0, s4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_load_2xi16_align4:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    scratch_load_dword v0, v0, off
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v1, 0xffff
; GFX9-FLASTSCR-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_bfi_b32 v1, v1, 0, v0
; GFX9-FLASTSCR-NEXT:    v_and_or_b32 v0, v0, s0, v1
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_load_2xi16_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_bfi_b32 v1, 0xffff, 0, v0
; GFX10-NEXT:    v_and_or_b32 v0, 0xffff, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_load_2xi16_align4:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    scratch_load_dword v0, v0, off
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX10-FLASTSCR-NEXT:    v_bfi_b32 v1, 0xffff, 0, v0
; GFX10-FLASTSCR-NEXT:    v_and_or_b32 v0, 0xffff, v0, v1
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.p = getelementptr i16, i16 addrspace(5)* %p, i64 1
  %p.0 = load i16, i16 addrspace(5)* %p, align 4
  %p.1 = load i16, i16 addrspace(5)* %gep.p, align 2
  %zext.0 = zext i16 %p.0 to i32
  %zext.1 = zext i16 %p.1 to i32
  %shl.1 = shl i32 %zext.1, 16
  %or = or i32 %zext.0, %shl.1
  ret i32 %or
}

; Should merge this to a dword store
define void @private_store_2xi16_align4(i16 addrspace(5)* %p, i16 addrspace(5)* %r) #0 {
; GFX7-LABEL: private_store_2xi16_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x2
; GFX7-NEXT:    v_mov_b32_e32 v2, 0x20001
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    v_mov_b32_e32 v1, s1
; GFX7-NEXT:    flat_store_dword v[0:1], v2
; GFX7-NEXT:    s_endpgm
;
; GFX7-ALIGNED-LABEL: private_store_2xi16_align4:
; GFX7-ALIGNED:       ; %bb.0:
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-ALIGNED-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX7-ALIGNED-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX7-ALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-ALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: private_store_2xi16_align4:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX7-UNALIGNED-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: private_store_2xi16_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX9-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-FLASTSCR-LABEL: private_store_2xi16_align4:
; GFX9-FLASTSCR:       ; %bb.0:
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX9-FLASTSCR-NEXT:    scratch_store_dword v1, v0, off
; GFX9-FLASTSCR-NEXT:    s_waitcnt vmcnt(0)
; GFX9-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_store_2xi16_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX10-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-FLASTSCR-LABEL: private_store_2xi16_align4:
; GFX10-FLASTSCR:       ; %bb.0:
; GFX10-FLASTSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    v_mov_b32_e32 v0, 0x20001
; GFX10-FLASTSCR-NEXT:    scratch_store_dword v1, v0, off
; GFX10-FLASTSCR-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-FLASTSCR-NEXT:    s_setpc_b64 s[30:31]
  %gep.r = getelementptr i16, i16 addrspace(5)* %r, i64 1
  store i16 1, i16 addrspace(5)* %r, align 4
  store i16 2, i16 addrspace(5)* %gep.r, align 2
  ret void
}
