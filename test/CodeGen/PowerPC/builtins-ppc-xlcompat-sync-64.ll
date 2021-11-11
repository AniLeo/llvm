; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-unknown \
; RUN:   --ppc-asm-full-reg-names -mcpu=pwr7 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-unknown \
; RUN:   --ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-aix \
; RUN:   --ppc-asm-full-reg-names -mcpu=pwr7 < %s | FileCheck %s

define dso_local i64 @test_builtin_ppc_popcntb_i64(i64 %a) local_unnamed_addr {
; CHECK-LABEL: test_builtin_ppc_popcntb_i64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    popcntb r3, r3
; CHECK-NEXT:    blr
entry:
  %popcntb = tail call i64 @llvm.ppc.popcntb.i64.i64(i64 %a)
  ret i64 %popcntb
}
declare i64 @llvm.ppc.popcntb.i64.i64(i64)

define dso_local void @test_builtin_ppc_eieio() {
; CHECK-LABEL: test_builtin_ppc_eieio:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ori r2, r2, 0
; CHECK-NEXT:    ori r2, r2, 0
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
; CHECK-NEXT:    ori r2, r2, 0
; CHECK-NEXT:    ori r2, r2, 0
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

define dso_local void @test_builtin_ppc_icbt() {
; CHECK-LABEL: test_builtin_ppc_icbt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    ld r3, -8(r1)
; CHECK-NEXT:    icbt 0, 0, r3
; CHECK-NEXT:    blr
entry:
  %a = alloca i8*, align 8
  %0 = load i8*, i8** %a, align 8
  call void @llvm.ppc.icbt(i8* %0)
  ret void
}
declare void @llvm.ppc.icbt(i8*)
