; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mattr=+shstk -mattr=+ibt | FileCheck %s

define void @test_incsspd(i32 %a) local_unnamed_addr {
; CHECK-LABEL: test_incsspd:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    incsspd %eax
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.incsspd(i32 %a)
  ret void
}

declare void @llvm.x86.incsspd(i32)

define i32 @test_rdsspd(i32 %a) {
; CHECK-LABEL: test_rdsspd:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    rdsspd %eax
; CHECK-NEXT:    retl
entry:
  %0 = call i32 @llvm.x86.rdsspd(i32 %a)
  ret i32 %0
}

declare i32 @llvm.x86.rdsspd(i32)

define void @test_saveprevssp() {
; CHECK-LABEL: test_saveprevssp:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    saveprevssp
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.saveprevssp()
  ret void
}

declare void @llvm.x86.saveprevssp()

define void @test_rstorssp(i8* %__p) {
; CHECK-LABEL: test_rstorssp:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    rstorssp (%eax)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.rstorssp(i8* %__p)
  ret void
}

declare void @llvm.x86.rstorssp(i8*)

define void @test_wrssd(i32 %a, i8* %__p) {
; CHECK-LABEL: test_wrssd:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    wrssd %eax, (%ecx)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.wrssd(i32 %a, i8* %__p)
  ret void
}

declare void @llvm.x86.wrssd(i32, i8*)

define void @test_wrussd(i32 %a, i8* %__p) {
; CHECK-LABEL: test_wrussd:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    wrussd %eax, (%ecx)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.wrussd(i32 %a, i8* %__p)
  ret void
}

declare void @llvm.x86.wrussd(i32, i8*)

define void @test_setssbsy() {
; CHECK-LABEL: test_setssbsy:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    setssbsy
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.setssbsy()
  ret void
}

declare void @llvm.x86.setssbsy()

define void @test_clrssbsy(i8* %__p) {
; CHECK-LABEL: test_clrssbsy:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    clrssbsy (%eax)
; CHECK-NEXT:    retl
entry:
  tail call void @llvm.x86.clrssbsy(i8* %__p)
  ret void
}

declare void @llvm.x86.clrssbsy(i8* %__p)
