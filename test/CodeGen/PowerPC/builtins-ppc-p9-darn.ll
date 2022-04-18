; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple powerpc64le -mcpu=pwr9 | FileCheck %s
; RUN: llc < %s -verify-machineinstrs -mtriple powerpc64-ibm-aix-xcoff -vec-extabi -mcpu=pwr9 | FileCheck %s
; RUN: opt < %s -passes="default<O3>" -S -mtriple powerpc64le -mcpu=pwr9 | FileCheck %s --check-prefix=OPT

define i64 @raw() {
; CHECK-LABEL: raw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    darn 3, 2
; CHECK-NEXT:    blr
entry:
  %0 = call i64 @llvm.ppc.darnraw()
  ret i64 %0
}

define i64 @conditioned() {
; CHECK-LABEL: conditioned:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    darn 3, 1
; CHECK-NEXT:    blr
entry:
  %0 = call i64 @llvm.ppc.darn()
  ret i64 %0
}

define signext i32 @word() {
; CHECK-LABEL: word:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    darn 3, 0
; CHECK-NEXT:    extsw 3, 3
; CHECK-NEXT:    blr
entry:
  %0 = call i32 @llvm.ppc.darn32()
  ret i32 %0
}

define i64 @darn_side_effect() {
; CHECK-LABEL: darn_side_effect:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    darn 3, 2
; CHECK-NEXT:    darn 3, 1
; CHECK-NEXT:    blr

; OPT-LABEL: @darn_side_effect
; OPT: call i64 @llvm.ppc.darnraw()
; OPT-NEXT: call i64 @llvm.ppc.darn()
entry:
  %0 = call i64 @llvm.ppc.darnraw()
  %1 = call i64 @llvm.ppc.darn()
  ret i64 %1
}

define void @darn_loop(i64* noundef %darn) {
; OPT-LABEL: @darn_loop
; OPT-COUNT-32: tail call i64 @llvm.ppc.darn()
entry:
  %inc = alloca i32, align 4
  store i32 0, i32* %inc, align 4
  br label %cond

cond:
  %0 = load i32, i32* %inc, align 4
  %cmp = icmp ne i32 %0, 32
  br i1 %cmp, label %body, label %end_loop

body:
  %1 = call i64 @llvm.ppc.darn()
  %2 = load i32, i32* %inc, align 4
  %idx = getelementptr inbounds i64, i64* %darn, i32 %2
  store i64 %1, i64* %idx, align 8
  br label %incr

incr:
  %3 = load i32, i32* %inc, align 4
  %ninc = add nsw i32 %3, 1
  store i32 %ninc, i32* %inc, align 4
  br label %cond

end_loop:
  ret void
}

declare i64 @llvm.ppc.darn()
declare i64 @llvm.ppc.darnraw()
declare i32 @llvm.ppc.darn32()
