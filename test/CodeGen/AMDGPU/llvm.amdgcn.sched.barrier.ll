; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_kernel void @test_sched_barrier() #0 {
; GCN-LABEL: test_sched_barrier:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    ; sched_barrier mask(0x00000000)
; GCN-NEXT:    ; sched_barrier mask(0x00000001)
; GCN-NEXT:    ; sched_barrier mask(0x00000004)
; GCN-NEXT:    ; sched_barrier mask(0x0000000F)
; GCN-NEXT:    s_endpgm
entry:
  call void @llvm.amdgcn.sched.barrier(i32 0) #1
  call void @llvm.amdgcn.sched.barrier(i32 1) #1
  call void @llvm.amdgcn.sched.barrier(i32 4) #1
  call void @llvm.amdgcn.sched.barrier(i32 15) #1
  ret void
}

declare void @llvm.amdgcn.sched.barrier(i32) #1

attributes #0 = { nounwind }
attributes #1 = { convergent nounwind }
