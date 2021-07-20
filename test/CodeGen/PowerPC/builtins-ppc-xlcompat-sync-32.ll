; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc-unknown-aix \
; RUN:   --ppc-asm-full-reg-names -mcpu=pwr7 < %s | FileCheck %s

define dso_local i32 @test_builtin_ppc_popcntb_i32(i32 %a) local_unnamed_addr {
; CHECK-LABEL: test_builtin_ppc_popcntb_i32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    popcntb 3, 3
; CHECK-NEXT:    blr
entry:
  %popcntb = tail call i32 @llvm.ppc.popcntb.i32.i32(i32 %a)
  ret i32 %popcntb
}
declare i32 @llvm.ppc.popcntb.i32.i32(i32)

define dso_local void @test_builtin_ppc_eieio() {
; CHECK-LABEL: test_builtin_ppc_eieio:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori 2, 2, 0
; CHECK-NEXT:    ori 2, 2, 0
; CHECK-NEXT:    eieio
; CHECK-NEXT:    blr
entry:
  call void @llvm.ppc.eieio()
  ret void
}
declare void @llvm.ppc.eieio()

define dso_local void @test_builtin_ppc_iospace_eieio() {
; CHECK-LABEL: test_builtin_ppc_iospace_eieio:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori 2, 2, 0
; CHECK-NEXT:    ori 2, 2, 0
; CHECK-NEXT:    eieio
; CHECK-NEXT:    blr
entry:
  call void @llvm.ppc.iospace.eieio()
  ret void
}
declare void @llvm.ppc.iospace.eieio()

define dso_local void @test_builtin_ppc_iospace_lwsync() {
; CHECK-LABEL: test_builtin_ppc_iospace_lwsync:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lwsync
; CHECK-NEXT:    blr
entry:
  call void @llvm.ppc.iospace.lwsync()
  ret void
}
declare void @llvm.ppc.iospace.lwsync()

define dso_local void @test_builtin_ppc_iospace_sync() {
; CHECK-LABEL: test_builtin_ppc_iospace_sync:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    sync
; CHECK-NEXT:    blr
entry:
  call void @llvm.ppc.iospace.sync()
  ret void
}
declare void @llvm.ppc.iospace.sync()
