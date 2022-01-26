; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s

target datalayout = "e-p:64:64:64-p1:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

declare void @llvm.memcpy.p0i8.p1i8.i32(i8* nocapture writeonly, i8 addrspace(1)* nocapture readonly, i32, i1 immarg) #0
declare void @llvm.memcpy.p1i8.p0i8.i32(i8 addrspace(1)* nocapture writeonly, i8* nocapture readonly, i32, i1 immarg) #0

define i64 @alloca_addrspacecast_bitcast(i64 %X) {
; CHECK-LABEL: @alloca_addrspacecast_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 [[X:%.*]]
;
entry:
  %A = alloca [8 x i8]
  %A.cast = addrspacecast [8 x i8]* %A to [8 x i8] addrspace(1)*
  %B = bitcast [8 x i8] addrspace(1)* %A.cast to i64 addrspace(1)*
  store i64 %X, i64 addrspace(1)* %B
  %Z = load i64, i64 addrspace(1)* %B
  ret i64 %Z
}

define i64 @alloca_bitcast_addrspacecast(i64 %X) {
; CHECK-LABEL: @alloca_bitcast_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 [[X:%.*]]
;
entry:
  %A = alloca [8 x i8]
  %A.cast = bitcast [8 x i8]* %A to i64*
  %B = addrspacecast i64* %A.cast to i64 addrspace(1)*
  store i64 %X, i64 addrspace(1)* %B
  %Z = load i64, i64 addrspace(1)* %B
  ret i64 %Z
}

define i64 @alloca_addrspacecast_gep(i64 %X) {
; CHECK-LABEL: @alloca_addrspacecast_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 [[X:%.*]]
;
entry:
  %A.as0 = alloca [256 x i8], align 4

  %gepA.as0 = getelementptr [256 x i8], [256 x i8]* %A.as0, i16 0, i16 32
  %gepA.as0.bc = bitcast i8* %gepA.as0 to i64*
  store i64 %X, i64* %gepA.as0.bc, align 4

  %A.as1 = addrspacecast [256 x i8]* %A.as0 to [256 x i8] addrspace(1)*
  %gepA.as1 = getelementptr [256 x i8], [256 x i8] addrspace(1)* %A.as1, i16 0, i16 32
  %gepA.as1.bc = bitcast i8 addrspace(1)* %gepA.as1 to i64 addrspace(1)*
  %Z = load i64, i64 addrspace(1)* %gepA.as1.bc, align 4

  ret i64 %Z
}

define i64 @alloca_gep_addrspacecast(i64 %X) {
; CHECK-LABEL: @alloca_gep_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 [[X:%.*]]
;
entry:
  %A.as0 = alloca [256 x i8], align 4

  %gepA.as0 = getelementptr [256 x i8], [256 x i8]* %A.as0, i16 0, i16 32
  %gepA.as0.bc = bitcast i8* %gepA.as0 to i64*
  store i64 %X, i64* %gepA.as0.bc, align 4

  %gepA.as1.bc = addrspacecast i64* %gepA.as0.bc to i64 addrspace(1)*
  %Z = load i64, i64 addrspace(1)* %gepA.as1.bc, align 4
  ret i64 %Z
}

define i64 @alloca_gep_addrspacecast_gep(i64 %X) {
; CHECK-LABEL: @alloca_gep_addrspacecast_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i64 [[X:%.*]]
;
entry:
  %A.as0 = alloca [256 x i8], align 4

  %gepA.as0 = getelementptr [256 x i8], [256 x i8]* %A.as0, i16 0, i16 32
  %gepA.as0.bc = bitcast i8* %gepA.as0 to i64*
  store i64 %X, i64* %gepA.as0.bc, align 4


  %gepB.as0 = getelementptr [256 x i8], [256 x i8]* %A.as0, i16 0, i16 16
  %gepB.as1 = addrspacecast i8* %gepB.as0 to i8 addrspace(1)*
  %gepC.as1 = getelementptr i8, i8 addrspace(1)* %gepB.as1, i16 16
  %gepC.as1.bc = bitcast i8 addrspace(1)* %gepC.as1 to i64 addrspace(1)*
  %Z = load i64, i64 addrspace(1)* %gepC.as1.bc, align 4

  ret i64 %Z
}

define i64 @getAdjustedPtr_addrspacecast_gep([32 x i8]* %x) {
; CHECK-LABEL: @getAdjustedPtr_addrspacecast_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAST1:%.*]] = addrspacecast [32 x i8]* [[X:%.*]] to i8 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_CAST1_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[CAST1]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_0_0_CAST1_SROA_CAST]], align 1
; CHECK-NEXT:    [[A_SROA_2_0_CAST1_SROA_IDX:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[CAST1]], i16 8
; CHECK-NEXT:    [[A_SROA_2_0_CAST1_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[A_SROA_2_0_CAST1_SROA_IDX]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_2_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_2_0_CAST1_SROA_CAST]], align 1
; CHECK-NEXT:    ret i64 [[A_SROA_0_0_COPYLOAD]]
;
entry:
  %a = alloca [32 x i8], align 8
  %cast1 = addrspacecast [32 x i8]* %x to i8 addrspace(1)*
  %cast2 = bitcast [32 x i8]* %a to i8*
  call void @llvm.memcpy.p0i8.p1i8.i32(i8* %cast2, i8 addrspace(1)* %cast1, i32 16, i1 false)
  %gep = getelementptr [32 x i8], [32 x i8]* %a, i32 0
  %gep.bitcast = bitcast [32 x i8]* %gep to i64*
  %val = load i64, i64* %gep.bitcast
  ret i64 %val
}

define i64 @getAdjustedPtr_gep_addrspacecast([32 x i8]* %x) {
; CHECK-LABEL: @getAdjustedPtr_gep_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP_X:%.*]] = getelementptr [32 x i8], [32 x i8]* [[X:%.*]], i32 0, i32 16
; CHECK-NEXT:    [[CAST1:%.*]] = addrspacecast i8* [[GEP_X]] to i8 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_CAST1_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[CAST1]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_0_0_CAST1_SROA_CAST]], align 1
; CHECK-NEXT:    [[A_SROA_2_0_CAST1_SROA_IDX:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[CAST1]], i16 8
; CHECK-NEXT:    [[A_SROA_2_0_CAST1_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[A_SROA_2_0_CAST1_SROA_IDX]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_2_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_2_0_CAST1_SROA_CAST]], align 1
; CHECK-NEXT:    ret i64 [[A_SROA_0_0_COPYLOAD]]
;
entry:
  %a = alloca [32 x i8], align 8
  %gep.x = getelementptr [32 x i8], [32 x i8]* %x, i32 0, i32 16
  %cast1 = addrspacecast i8* %gep.x to i8 addrspace(1)*

  %cast2 = bitcast [32 x i8]* %a to i8*
  call void @llvm.memcpy.p0i8.p1i8.i32(i8* %cast2, i8 addrspace(1)* %cast1, i32 16, i1 false)
  %gep = getelementptr [32 x i8], [32 x i8]* %a, i32 0
  %gep.bitcast = bitcast [32 x i8]* %gep to i64*
  %val = load i64, i64* %gep.bitcast
  ret i64 %val
}

define i64 @getAdjustedPtr_gep_addrspacecast_gep([32 x i8]* %x) {
; CHECK-LABEL: @getAdjustedPtr_gep_addrspacecast_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP0_X:%.*]] = getelementptr [32 x i8], [32 x i8]* [[X:%.*]], i32 0, i32 8
; CHECK-NEXT:    [[CAST1:%.*]] = addrspacecast i8* [[GEP0_X]] to i8 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_GEP1_X_SROA_IDX:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[CAST1]], i16 8
; CHECK-NEXT:    [[A_SROA_0_0_GEP1_X_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[A_SROA_0_0_GEP1_X_SROA_IDX]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_0_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_0_0_GEP1_X_SROA_CAST]], align 1
; CHECK-NEXT:    [[A_SROA_2_0_GEP1_X_SROA_IDX:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[CAST1]], i16 16
; CHECK-NEXT:    [[A_SROA_2_0_GEP1_X_SROA_CAST:%.*]] = bitcast i8 addrspace(1)* [[A_SROA_2_0_GEP1_X_SROA_IDX]] to i64 addrspace(1)*
; CHECK-NEXT:    [[A_SROA_2_0_COPYLOAD:%.*]] = load i64, i64 addrspace(1)* [[A_SROA_2_0_GEP1_X_SROA_CAST]], align 1
; CHECK-NEXT:    ret i64 [[A_SROA_0_0_COPYLOAD]]
;
entry:
  %a = alloca [32 x i8], align 8
  %gep0.x = getelementptr [32 x i8], [32 x i8]* %x, i32 0, i32 8
  %cast1 = addrspacecast i8* %gep0.x to i8 addrspace(1)*
  %gep1.x = getelementptr i8, i8 addrspace(1)* %cast1, i32 8

  %cast2 = bitcast [32 x i8]* %a to i8*
  call void @llvm.memcpy.p0i8.p1i8.i32(i8* %cast2, i8 addrspace(1)* %gep1.x, i32 16, i1 false)
  %gep = getelementptr [32 x i8], [32 x i8]* %a, i32 0
  %gep.bitcast = bitcast [32 x i8]* %gep to i64*
  %val = load i64, i64* %gep.bitcast
  ret i64 %val
}

; Don't change the address space of a volatile operation
define i64 @alloca_addrspacecast_bitcast_volatile_store(i64 %X) {
; CHECK-LABEL: @alloca_addrspacecast_bitcast_volatile_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [8 x i8], align 1
; CHECK-NEXT:    [[A_CAST:%.*]] = addrspacecast [8 x i8]* [[A]] to [8 x i8] addrspace(1)*
; CHECK-NEXT:    [[B:%.*]] = bitcast [8 x i8] addrspace(1)* [[A_CAST]] to i64 addrspace(1)*
; CHECK-NEXT:    store volatile i64 [[X:%.*]], i64 addrspace(1)* [[B]], align 4
; CHECK-NEXT:    [[Z:%.*]] = load i64, i64 addrspace(1)* [[B]], align 4
; CHECK-NEXT:    ret i64 [[Z]]
;
entry:
  %A = alloca [8 x i8]
  %A.cast = addrspacecast [8 x i8]* %A to [8 x i8] addrspace(1)*
  %B = bitcast [8 x i8] addrspace(1)* %A.cast to i64 addrspace(1)*
  store volatile i64 %X, i64 addrspace(1)* %B
  %Z = load i64, i64 addrspace(1)* %B
  ret i64 %Z
}

; Don't change the address space of a volatile operation
define i64 @alloca_addrspacecast_bitcast_volatile_load(i64 %X) {
; CHECK-LABEL: @alloca_addrspacecast_bitcast_volatile_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [8 x i8], align 1
; CHECK-NEXT:    [[A_CAST:%.*]] = addrspacecast [8 x i8]* [[A]] to [8 x i8] addrspace(1)*
; CHECK-NEXT:    [[B:%.*]] = bitcast [8 x i8] addrspace(1)* [[A_CAST]] to i64 addrspace(1)*
; CHECK-NEXT:    store i64 [[X:%.*]], i64 addrspace(1)* [[B]], align 4
; CHECK-NEXT:    [[Z:%.*]] = load volatile i64, i64 addrspace(1)* [[B]], align 4
; CHECK-NEXT:    ret i64 [[Z]]
;
entry:
  %A = alloca [8 x i8]
  %A.cast = addrspacecast [8 x i8]* %A to [8 x i8] addrspace(1)*
  %B = bitcast [8 x i8] addrspace(1)* %A.cast to i64 addrspace(1)*
  store i64 %X, i64 addrspace(1)* %B
  %Z = load volatile i64, i64 addrspace(1)* %B
  ret i64 %Z
}

declare void @llvm.memset.p1i8.i32(i8 addrspace(1)* nocapture, i8, i32, i1) nounwind

; Don't change the address space of a volatile operation
define i32 @volatile_memset() {
; CHECK-LABEL: @volatile_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [4 x i8], align 1
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr [4 x i8], [4 x i8]* [[A]], i32 0, i32 0
; CHECK-NEXT:    [[ASC:%.*]] = addrspacecast i8* [[PTR]] to i8 addrspace(1)*
; CHECK-NEXT:    call void @llvm.memset.p1i8.i32(i8 addrspace(1)* [[ASC]], i8 42, i32 4, i1 true)
; CHECK-NEXT:    [[IPTR:%.*]] = bitcast i8* [[PTR]] to i32*
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[IPTR]], align 4
; CHECK-NEXT:    ret i32 [[VAL]]
;
entry:
  %a = alloca [4 x i8]
  %ptr = getelementptr [4 x i8], [4 x i8]* %a, i32 0, i32 0
  %asc = addrspacecast i8* %ptr to i8 addrspace(1)*
  call void @llvm.memset.p1i8.i32(i8 addrspace(1)* %asc, i8 42, i32 4, i1 true)
  %iptr = bitcast i8* %ptr to i32*
  %val = load i32, i32* %iptr
  ret i32 %val
}

; Don't change the address space of a volatile operation
define void @volatile_memcpy(i8* %src, i8* %dst) {
; CHECK-LABEL: @volatile_memcpy(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [4 x i8], align 1
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr [4 x i8], [4 x i8]* [[A]], i32 0, i32 0
; CHECK-NEXT:    [[ASC:%.*]] = addrspacecast i8* [[PTR]] to i8 addrspace(1)*
; CHECK-NEXT:    call void @llvm.memcpy.p1i8.p0i8.i32(i8 addrspace(1)* [[ASC]], i8* [[SRC:%.*]], i32 4, i1 true), !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p1i8.i32(i8* [[DST:%.*]], i8 addrspace(1)* [[ASC]], i32 4, i1 true), !tbaa [[TBAA3:![0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  %a = alloca [4 x i8]
  %ptr = getelementptr [4 x i8], [4 x i8]* %a, i32 0, i32 0
  %asc = addrspacecast i8* %ptr to i8 addrspace(1)*
  call void @llvm.memcpy.p1i8.p0i8.i32(i8 addrspace(1)* %asc, i8* %src, i32 4, i1 true), !tbaa !0
  call void @llvm.memcpy.p0i8.p1i8.i32(i8* %dst, i8 addrspace(1)* %asc, i32 4, i1 true), !tbaa !3
  ret void
}

define void @select_addrspacecast(i1 %a, i1 %b) {
; CHECK-LABEL: @select_addrspacecast(
; CHECK-NEXT:    ret void
;
  %c = alloca i64, align 8
  %p.0.c = select i1 undef, i64* %c, i64* %c
  %asc = addrspacecast i64* %p.0.c to i64 addrspace(1)*

  %cond.in = select i1 undef, i64 addrspace(1)* %asc, i64 addrspace(1)* %asc
  %cond = load i64, i64 addrspace(1)* %cond.in, align 8
  ret void
}

define void @select_addrspacecast_const_op(i1 %a, i1 %b) {
; CHECK-LABEL: @select_addrspacecast_const_op(
; CHECK-NEXT:    [[C:%.*]] = alloca i64, align 8
; CHECK-NEXT:    [[C_0_ASC_SROA_CAST:%.*]] = addrspacecast i64* [[C]] to i64 addrspace(1)*
; CHECK-NEXT:    [[COND_IN:%.*]] = select i1 undef, i64 addrspace(1)* [[C_0_ASC_SROA_CAST]], i64 addrspace(1)* null
; CHECK-NEXT:    [[COND:%.*]] = load i64, i64 addrspace(1)* [[COND_IN]], align 8
; CHECK-NEXT:    ret void
;
  %c = alloca i64, align 8
  %p.0.c = select i1 undef, i64* %c, i64* %c
  %asc = addrspacecast i64* %p.0.c to i64 addrspace(1)*

  %cond.in = select i1 undef, i64 addrspace(1)* %asc, i64 addrspace(1)* null
  %cond = load i64, i64 addrspace(1)* %cond.in, align 8
  ret void
}

;; If this was external, we wouldn't be able to prove dereferenceability
;; of the location.
@gv = addrspace(1) global i64 zeroinitializer

define void @select_addrspacecast_gv(i1 %a, i1 %b) {
; CHECK-LABEL: @select_addrspacecast_gv(
; CHECK-NEXT:    [[COND_SROA_SPECULATE_LOAD_FALSE:%.*]] = load i64, i64 addrspace(1)* @gv, align 8
; CHECK-NEXT:    [[COND_SROA_SPECULATED:%.*]] = select i1 undef, i64 undef, i64 [[COND_SROA_SPECULATE_LOAD_FALSE]]
; CHECK-NEXT:    ret void
;
  %c = alloca i64, align 8
  %p.0.c = select i1 undef, i64* %c, i64* %c
  %asc = addrspacecast i64* %p.0.c to i64 addrspace(1)*

  %cond.in = select i1 undef, i64 addrspace(1)* %asc, i64 addrspace(1)* @gv
  %cond = load i64, i64 addrspace(1)* %cond.in, align 8
  ret void
}

define void @select_addrspacecast_gv_constexpr(i1 %a, i1 %b) {
; CHECK-LABEL: @select_addrspacecast_gv_constexpr(
; CHECK-NEXT:    [[COND_SROA_SPECULATE_LOAD_FALSE:%.*]] = load i64, i64 addrspace(2)* addrspacecast (i64 addrspace(1)* @gv to i64 addrspace(2)*), align 8
; CHECK-NEXT:    [[COND_SROA_SPECULATED:%.*]] = select i1 undef, i64 undef, i64 [[COND_SROA_SPECULATE_LOAD_FALSE]]
; CHECK-NEXT:    ret void
;
  %c = alloca i64, align 8
  %p.0.c = select i1 undef, i64* %c, i64* %c
  %asc = addrspacecast i64* %p.0.c to i64 addrspace(2)*

  %cond.in = select i1 undef, i64 addrspace(2)* %asc, i64 addrspace(2)* addrspacecast (i64 addrspace(1)* @gv to i64 addrspace(2)*)
  %cond = load i64, i64 addrspace(2)* %cond.in, align 8
  ret void
}

define i8 @select_addrspacecast_i8() {
; CHECK-LABEL: @select_addrspacecast_i8(
; CHECK-NEXT:    [[RET_SROA_SPECULATED:%.*]] = select i1 undef, i8 undef, i8 undef
; CHECK-NEXT:    ret i8 [[RET_SROA_SPECULATED]]
;
  %a = alloca i8
  %b = alloca i8

  %a.ptr = addrspacecast i8* %a to i8 addrspace(1)*
  %b.ptr = addrspacecast i8* %b to i8 addrspace(1)*

  %ptr = select i1 undef, i8 addrspace(1)* %a.ptr, i8 addrspace(1)* %b.ptr
  %ret = load i8, i8 addrspace(1)* %ptr
  ret i8 %ret
}

!0 = !{!1, !1, i64 0, i64 1}
!1 = !{!2, i64 1, !"type_0"}
!2 = !{!"root"}
!3 = !{!4, !4, i64 0, i64 1}
!4 = !{!2, i64 1, !"type_3"}
