; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx90a -show-mc-encoding -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -march=amdgcn -show-mc-encoding -verify-machineinstrs < %s | FileCheck -check-prefix=SI %s
; RUN: llc -global-isel -march=amdgcn -show-mc-encoding -verify-machineinstrs < %s | FileCheck -check-prefix=SI %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx90a -show-mc-encoding -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s

declare void @llvm.amdgcn.s.setprio(i16) #0

define void @test_llvm_amdgcn_s_setprio() #0 {
; GFX9-LABEL: test_llvm_amdgcn_s_setprio:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x8c,0xbf]
; GFX9-NEXT:    s_setprio 0 ; encoding: [0x00,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 1 ; encoding: [0x01,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 2 ; encoding: [0x02,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 3 ; encoding: [0x03,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 10 ; encoding: [0x0a,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio -1 ; encoding: [0xff,0xff,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 0 ; encoding: [0x00,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio 1 ; encoding: [0x01,0x00,0x8f,0xbf]
; GFX9-NEXT:    s_setprio -1 ; encoding: [0xff,0xff,0x8f,0xbf]
; GFX9-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x1d,0x80,0xbe]
;
; SI-LABEL: test_llvm_amdgcn_s_setprio:
; SI:       ; %bb.0:
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x8c,0xbf]
; SI-NEXT:    s_setprio 0 ; encoding: [0x00,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio 1 ; encoding: [0x01,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio 2 ; encoding: [0x02,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio 3 ; encoding: [0x03,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio 10 ; encoding: [0x0a,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio -1 ; encoding: [0xff,0xff,0x8f,0xbf]
; SI-NEXT:    s_setprio 0 ; encoding: [0x00,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio 1 ; encoding: [0x01,0x00,0x8f,0xbf]
; SI-NEXT:    s_setprio -1 ; encoding: [0xff,0xff,0x8f,0xbf]
; SI-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x20,0x80,0xbe]
  call void @llvm.amdgcn.s.setprio(i16 0)
  call void @llvm.amdgcn.s.setprio(i16 1)
  call void @llvm.amdgcn.s.setprio(i16 2)
  call void @llvm.amdgcn.s.setprio(i16 3)
  call void @llvm.amdgcn.s.setprio(i16 10)
  call void @llvm.amdgcn.s.setprio(i16 65535)
  call void @llvm.amdgcn.s.setprio(i16 65536)
  call void @llvm.amdgcn.s.setprio(i16 65537)
  call void @llvm.amdgcn.s.setprio(i16 -1)
  ret void
}

attributes #0 = { nounwind }
