; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -relocation-model=static -verify-machineinstrs < %s --enable-shrink-wrap=false -mtriple=powerpc64le-unknown-linux-gnu | FileCheck %s
%struct.S = type { i8 }

@sg = internal thread_local global %struct.S zeroinitializer, align 1
@__dso_handle = external global i8
@__tls_guard = internal thread_local unnamed_addr global i1 false
@sum1 = internal thread_local global i32 0, align 4

declare void @_ZN1SC1Ev(%struct.S*)
declare void @_ZN1SD1Ev(%struct.S*)
declare i32 @_tlv_atexit(void (i8*)*, i8*, i8*)

define cxx_fast_tlscc nonnull %struct.S* @_ZTW2sg() nounwind {
; CHECK-LABEL: _ZTW2sg:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -48(1)
; CHECK-NEXT:    addis 3, 13, __tls_guard@tprel@ha
; CHECK-NEXT:    lbz 4, __tls_guard@tprel@l(3)
; CHECK-NEXT:    andi. 4, 4, 1
; CHECK-NEXT:    bc 12, 1, .LBB0_2
; CHECK-NEXT:  # %bb.1: # %init.i
; CHECK-NEXT:    li 4, 1
; CHECK-NEXT:    std 31, 40(1) # 8-byte Folded Spill
; CHECK-NEXT:    mr 31, 14
; CHECK-NEXT:    mr 14, 15
; CHECK-NEXT:    mr 15, 16
; CHECK-NEXT:    mr 16, 17
; CHECK-NEXT:    stb 4, __tls_guard@tprel@l(3)
; CHECK-NEXT:    addis 3, 13, sg@tprel@ha
; CHECK-NEXT:    mr 17, 18
; CHECK-NEXT:    mr 18, 19
; CHECK-NEXT:    mr 19, 20
; CHECK-NEXT:    mr 20, 21
; CHECK-NEXT:    mr 21, 22
; CHECK-NEXT:    mr 22, 23
; CHECK-NEXT:    mr 23, 24
; CHECK-NEXT:    mr 24, 25
; CHECK-NEXT:    mr 25, 26
; CHECK-NEXT:    mr 26, 27
; CHECK-NEXT:    mr 27, 28
; CHECK-NEXT:    mr 28, 29
; CHECK-NEXT:    mr 29, 30
; CHECK-NEXT:    addi 30, 3, sg@tprel@l
; CHECK-NEXT:    mr 3, 30
; CHECK-NEXT:    bl _ZN1SC1Ev
; CHECK-NEXT:    nop
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    addis 4, 2, .LC1@toc@ha
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    ld 5, .LC1@toc@l(4)
; CHECK-NEXT:    mr 4, 30
; CHECK-NEXT:    mr 30, 29
; CHECK-NEXT:    mr 29, 28
; CHECK-NEXT:    mr 28, 27
; CHECK-NEXT:    mr 27, 26
; CHECK-NEXT:    mr 26, 25
; CHECK-NEXT:    mr 25, 24
; CHECK-NEXT:    mr 24, 23
; CHECK-NEXT:    mr 23, 22
; CHECK-NEXT:    mr 22, 21
; CHECK-NEXT:    mr 21, 20
; CHECK-NEXT:    mr 20, 19
; CHECK-NEXT:    mr 19, 18
; CHECK-NEXT:    mr 18, 17
; CHECK-NEXT:    mr 17, 16
; CHECK-NEXT:    mr 16, 15
; CHECK-NEXT:    mr 15, 14
; CHECK-NEXT:    mr 14, 31
; CHECK-NEXT:    ld 31, 40(1) # 8-byte Folded Reload
; CHECK-NEXT:    bl _tlv_atexit
; CHECK-NEXT:    nop
; CHECK-NEXT:  .LBB0_2: # %__tls_init.exit
; CHECK-NEXT:    addis 3, 13, sg@tprel@ha
; CHECK-NEXT:    addi 3, 3, sg@tprel@l
; CHECK-NEXT:    addi 1, 1, 48
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
  %.b.i = load i1, i1* @__tls_guard, align 1
  br i1 %.b.i, label %__tls_init.exit, label %init.i

init.i:
  store i1 true, i1* @__tls_guard, align 1
  tail call void @_ZN1SC1Ev(%struct.S* nonnull @sg) #2
  %1 = tail call i32 @_tlv_atexit(void (i8*)* nonnull bitcast (void (%struct.S*)* @_ZN1SD1Ev to void (i8*)*), i8* nonnull getelementptr inbounds (%struct.S, %struct.S* @sg, i64 0, i32 0), i8* nonnull @__dso_handle) #2
  br label %__tls_init.exit

__tls_init.exit:
  ret %struct.S* @sg
}

define cxx_fast_tlscc nonnull i32* @_ZTW4sum1() nounwind {
; CHECK-LABEL: _ZTW4sum1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addis 3, 13, sum1@tprel@ha
; CHECK-NEXT:    addi 3, 3, sum1@tprel@l
; CHECK-NEXT:    blr
  ret i32* @sum1
}

define cxx_fast_tlscc i32* @_ZTW4sum2() #0 {
; CHECK-LABEL: _ZTW4sum2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addis 3, 13, sum1@tprel@ha
; CHECK-NEXT:    addi 3, 3, sum1@tprel@l
; CHECK-NEXT:    blr
  ret i32* @sum1
}

attributes #0 = { nounwind "frame-pointer"="all" }
