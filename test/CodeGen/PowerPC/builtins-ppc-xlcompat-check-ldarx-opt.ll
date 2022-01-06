; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-aix \
; RUN:   -mcpu=pwr8 < %s | FileCheck %s --check-prefix=CHECK-AIX

; Function Attrs: nounwind uwtable
define dso_local signext i32 @main() local_unnamed_addr {
; CHECK-LABEL: main:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    li 3, -1
; CHECK-NEXT:    li 4, 0
; CHECK-NEXT:    std 3, -8(1)
; CHECK-NEXT:    addi 3, 1, -8
; CHECK-NEXT:    .p2align 5
; CHECK-NEXT:  .LBB0_1: # %do.body
; CHECK-NEXT:    #
; CHECK-NEXT:    #APP
; CHECK-NEXT:    ldarx 5, 0, 3
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    stdcx. 4, 0, 3
; CHECK-NEXT:    mfocrf 5, 128
; CHECK-NEXT:    srwi 5, 5, 28
; CHECK-NEXT:    cmplwi 5, 0
; CHECK-NEXT:    beq 0, .LBB0_1
; CHECK-NEXT:  # %bb.2: # %do.end
; CHECK-NEXT:    ld 3, -8(1)
; CHECK-NEXT:    li 4, 55
; CHECK-NEXT:    cmpldi 3, 0
; CHECK-NEXT:    li 3, 66
; CHECK-NEXT:    iseleq 3, 4, 3
; CHECK-NEXT:    blr
;
; CHECK-AIX-LABEL: main:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    li 3, -1
; CHECK-AIX-NEXT:    li 4, 0
; CHECK-AIX-NEXT:    std 3, -8(1)
; CHECK-AIX-NEXT:    addi 3, 1, -8
; CHECK-AIX-NEXT:    .align 5
; CHECK-AIX-NEXT:  L..BB0_1: # %do.body
; CHECK-AIX-NEXT:    #
; CHECK-AIX-NEXT:    #APP
; CHECK-AIX-NEXT:    ldarx 5, 0, 3
; CHECK-AIX-NEXT:    #NO_APP
; CHECK-AIX-NEXT:    stdcx. 4, 0, 3
; CHECK-AIX-NEXT:    mfocrf 5, 128
; CHECK-AIX-NEXT:    srwi 5, 5, 28
; CHECK-AIX-NEXT:    cmplwi 5, 0
; CHECK-AIX-NEXT:    beq 0, L..BB0_1
; CHECK-AIX-NEXT:  # %bb.2: # %do.end
; CHECK-AIX-NEXT:    ld 3, -8(1)
; CHECK-AIX-NEXT:    li 4, 55
; CHECK-AIX-NEXT:    cmpldi 3, 0
; CHECK-AIX-NEXT:    li 3, 66
; CHECK-AIX-NEXT:    iseleq 3, 4, 3
; CHECK-AIX-NEXT:    blr
entry:
  %x64 = alloca i64, align 8
  %0 = bitcast i64* %x64 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %0)
  store i64 -1, i64* %x64, align 8
  br label %do.body

do.body:                                          ; preds = %do.body, %entry
  %1 = call i64 asm sideeffect "ldarx $0, ${1:y}", "=r,*Z,~{memory}"(i64* elementtype(i64) nonnull %x64)
  %2 = call i32 @llvm.ppc.stdcx(i8* nonnull %0, i64 0)
  %tobool.not = icmp eq i32 %2, 0
  br i1 %tobool.not, label %do.body, label %do.end

do.end:                                           ; preds = %do.body
  %3 = load i64, i64* %x64, align 8
  %cmp = icmp eq i64 %3, 0
  %. = select i1 %cmp, i32 55, i32 66
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %0)
  ret i32 %.
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)

; Function Attrs: nounwind writeonly
declare i32 @llvm.ppc.stdcx(i8*, i64)

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)
