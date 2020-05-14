; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -basicaa -gvn -dce | FileCheck %s

; Analyze Load from clobbering Load.

define <vscale x 4 x i32> @load_store_clobber_load(<vscale x 4 x i32> *%p)  {
; CHECK-LABEL: @load_store_clobber_load(
; CHECK-NEXT:    [[LOAD1:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* undef, align 16
; CHECK-NEXT:    [[ADD:%.*]] = add <vscale x 4 x i32> [[LOAD1]], [[LOAD1]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[ADD]]
;
  %load1 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* undef
  %load2 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p ; <- load to be eliminated
  %add = add <vscale x 4 x i32> %load1, %load2
  ret <vscale x 4 x i32> %add
}

define <vscale x 4 x i32> @load_store_clobber_load_mayalias(<vscale x 4 x i32>* %p, <vscale x 4 x i32>* %p2) {
; CHECK-LABEL: @load_store_clobber_load_mayalias(
; CHECK-NEXT:    [[LOAD1:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[P2:%.*]], align 16
; CHECK-NEXT:    [[LOAD2:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], align 16
; CHECK-NEXT:    [[SUB:%.*]] = sub <vscale x 4 x i32> [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[SUB]]
;
  %load1 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %p2
  %load2 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  %sub = sub <vscale x 4 x i32> %load1, %load2
  ret <vscale x 4 x i32> %sub
}

define <vscale x 4 x i32> @load_store_clobber_load_noalias(<vscale x 4 x i32>* noalias %p, <vscale x 4 x i32>* noalias %p2) {
; CHECK-LABEL: @load_store_clobber_load_noalias(
; CHECK-NEXT:    [[LOAD1:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[P2:%.*]], align 16
; CHECK-NEXT:    [[ADD:%.*]] = add <vscale x 4 x i32> [[LOAD1]], [[LOAD1]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[ADD]]
;
  %load1 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %p2
  %load2 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p ; <- load to be eliminated
  %add = add <vscale x 4 x i32> %load1, %load2
  ret <vscale x 4 x i32> %add
}

; TODO: BasicAA return MayAlias for %gep1,%gep2, could improve as MustAlias.
define i32 @load_clobber_load_gep1(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @load_clobber_load_gep1(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], i64 0, i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, i32* [[GEP1]], align 4
; CHECK-NEXT:    [[P2:%.*]] = bitcast <vscale x 4 x i32>* [[P]] to i32*
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i32, i32* [[P2]], i64 1
; CHECK-NEXT:    [[LOAD2:%.*]] = load i32, i32* [[GEP2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %gep1 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 0, i64 1
  %load1 = load i32, i32* %gep1
  %p2 = bitcast <vscale x 4 x i32>* %p to i32*
  %gep2 = getelementptr i32, i32* %p2, i64 1
  %load2 = load i32, i32* %gep2 ; <- load could be eliminated
  %add = add i32 %load1, %load2
  ret i32 %add
}

define i32 @load_clobber_load_gep2(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @load_clobber_load_gep2(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, i32* [[GEP1]], align 4
; CHECK-NEXT:    [[P2:%.*]] = bitcast <vscale x 4 x i32>* [[P]] to i32*
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i32, i32* [[P2]], i64 4
; CHECK-NEXT:    [[LOAD2:%.*]] = load i32, i32* [[GEP2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %gep1 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 0
  %load1 = load i32, i32* %gep1
  %p2 = bitcast <vscale x 4 x i32>* %p to i32*
  %gep2 = getelementptr i32, i32* %p2, i64 4
  %load2 = load i32, i32* %gep2 ; <- can not determine at compile-time if %load1 and %load2 are same addr
  %add = add i32 %load1, %load2
  ret i32 %add
}

; TODO: BasicAA return MayAlias for %gep1,%gep2, could improve as MustAlias.
define i32 @load_clobber_load_gep3(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @load_clobber_load_gep3(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], i64 1, i64 0
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, i32* [[GEP1]], align 4
; CHECK-NEXT:    [[P2:%.*]] = bitcast <vscale x 4 x i32>* [[P]] to <vscale x 4 x float>*
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr <vscale x 4 x float>, <vscale x 4 x float>* [[P2]], i64 1, i64 0
; CHECK-NEXT:    [[LOAD2:%.*]] = load float, float* [[GEP2]], align 4
; CHECK-NEXT:    [[CAST:%.*]] = bitcast float [[LOAD2]] to i32
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LOAD1]], [[CAST]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %gep1 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 0
  %load1 = load i32, i32* %gep1
  %p2 = bitcast <vscale x 4 x i32>* %p to <vscale x 4 x float>*
  %gep2 = getelementptr <vscale x 4 x float>, <vscale x 4 x float>* %p2, i64 1, i64 0
  %load2 = load float, float* %gep2 ; <- load could be eliminated
  %cast = bitcast float %load2 to i32
  %add = add i32 %load1, %cast
  ret i32 %add
}

define <vscale x 4 x i32> @load_clobber_load_fence(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @load_clobber_load_fence(
; CHECK-NEXT:    [[LOAD1:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    call void asm "", "~{memory}"()
; CHECK-NEXT:    [[LOAD2:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], align 16
; CHECK-NEXT:    [[SUB:%.*]] = sub <vscale x 4 x i32> [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[SUB]]
;
  %load1 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  call void asm "", "~{memory}"()
  %load2 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  %sub = sub <vscale x 4 x i32> %load1, %load2
  ret <vscale x 4 x i32> %sub
}

define <vscale x 4 x i32> @load_clobber_load_sideeffect(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @load_clobber_load_sideeffect(
; CHECK-NEXT:    [[LOAD1:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    call void asm sideeffect "", ""()
; CHECK-NEXT:    [[LOAD2:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], align 16
; CHECK-NEXT:    [[ADD:%.*]] = add <vscale x 4 x i32> [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    ret <vscale x 4 x i32> [[ADD]]
;
  %load1 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  call void asm sideeffect "", ""()
  %load2 = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  %add = add <vscale x 4 x i32> %load1, %load2
  ret <vscale x 4 x i32> %add
}

; Analyze Load from clobbering Store.

define <vscale x 4 x i32> @store_forward_to_load(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @store_forward_to_load(
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    ret <vscale x 4 x i32> zeroinitializer
;
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %p
  %load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  ret <vscale x 4 x i32> %load
}

define <vscale x 4 x i32> @store_forward_to_load_sideeffect(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @store_forward_to_load_sideeffect(
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    call void asm sideeffect "", ""()
; CHECK-NEXT:    [[LOAD:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], align 16
; CHECK-NEXT:    ret <vscale x 4 x i32> [[LOAD]]
;
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %p
  call void asm sideeffect "", ""()
  %load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p
  ret <vscale x 4 x i32> %load
}

define i32 @store_clobber_load() {
; CHECK-LABEL: @store_clobber_load(
; CHECK-NEXT:    [[ALLOC:%.*]] = alloca <vscale x 4 x i32>
; CHECK-NEXT:    store <vscale x 4 x i32> undef, <vscale x 4 x i32>* [[ALLOC]], align 16
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[ALLOC]], i32 0, i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[PTR]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %alloc = alloca <vscale x 4 x i32>
  store <vscale x 4 x i32> undef, <vscale x 4 x i32>* %alloc
  %ptr = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %alloc, i32 0, i32 1
  %load = load i32, i32* %ptr
  ret i32 %load
}

; Analyze Load from clobbering MemInst.

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)

define i32 @memset_clobber_load(<vscale x 4 x i32> *%p) {
; CHECK-LABEL: @memset_clobber_load(
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <vscale x 4 x i32>* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[CONV]], i8 1, i64 200, i1 false)
; CHECK-NEXT:    ret i32 16843009
;
  %conv = bitcast <vscale x 4 x i32>* %p to i8*
  tail call void @llvm.memset.p0i8.i64(i8* %conv, i8 1, i64 200, i1 false)
  %gep = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 0, i64 5
  %load = load i32, i32* %gep
  ret i32 %load
}

define i32 @memset_clobber_load_vscaled_base(<vscale x 4 x i32> *%p) {
; CHECK-LABEL: @memset_clobber_load_vscaled_base(
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <vscale x 4 x i32>* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[CONV]], i8 1, i64 200, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], i64 1, i64 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %conv = bitcast <vscale x 4 x i32>* %p to i8*
  tail call void @llvm.memset.p0i8.i64(i8* %conv, i8 1, i64 200, i1 false)
  %gep = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 1
  %load = load i32, i32* %gep
  ret i32 %load
}

define i32 @memset_clobber_load_nonconst_index(<vscale x 4 x i32> *%p, i64 %idx1, i64 %idx2) {
; CHECK-LABEL: @memset_clobber_load_nonconst_index(
; CHECK-NEXT:    [[CONV:%.*]] = bitcast <vscale x 4 x i32>* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[CONV]], i8 1, i64 200, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], i64 [[IDX1:%.*]], i64 [[IDX2:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
  %conv = bitcast <vscale x 4 x i32>* %p to i8*
  tail call void @llvm.memset.p0i8.i64(i8* %conv, i8 1, i64 200, i1 false)
  %gep = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 %idx1, i64 %idx2
  %load = load i32, i32* %gep
  ret i32 %load
}


; Load elimination across BBs

define <vscale x 4 x i32>* @load_from_alloc_replaced_with_undef() {
; CHECK-LABEL: @load_from_alloc_replaced_with_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca <vscale x 4 x i32>
; CHECK-NEXT:    br i1 undef, label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[A]], align 16
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret <vscale x 4 x i32>* [[A]]
;
entry:
  %a = alloca <vscale x 4 x i32>
  %gep = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %a, i64 0, i64 1
  %load = load i32, i32* %gep ; <- load to be eliminated
  %tobool = icmp eq i32 %load, 0 ; <- icmp to be eliminated
  br i1 %tobool, label %if.end, label %if.then

if.then:
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %a
  br label %if.end

if.end:
  ret <vscale x 4 x i32>* %a
}

define i32 @redundant_load_elimination_1(<vscale x 4 x i32>* %p) {
; CHECK-LABEL: @redundant_load_elimination_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], i64 1, i64 1
; CHECK-NEXT:    [[LOAD1:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[LOAD1]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i32 [[LOAD1]]
;
entry:
  %gep = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 1
  %load1 = load i32, i32* %gep
  %cmp = icmp eq i32 %load1, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %load2 = load i32, i32* %gep ; <- load to be eliminated
  %add = add i32 %load1, %load2
  br label %if.end

if.end:
  %result = phi i32 [ %add, %if.then ], [ %load1, %entry ]
  ret i32 %result
}

; TODO: BasicAA return MayAlias for %gep1,%gep2, could improve as NoAlias.
define void @redundant_load_elimination_2(i1 %c, <vscale x 4 x i32>* %p, i32* %q, <vscale x 4 x i32> %v) {
; CHECK-LABEL: @redundant_load_elimination_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P:%.*]], i64 1, i64 1
; CHECK-NEXT:    store i32 0, i32* [[GEP1]], align 4
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], i64 1, i64 0
; CHECK-NEXT:    store i32 1, i32* [[GEP2]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_ELSE:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[T:%.*]] = load i32, i32* [[GEP1]], align 4
; CHECK-NEXT:    store i32 [[T]], i32* [[Q:%.*]], align 4
; CHECK-NEXT:    ret void
; CHECK:       if.else:
; CHECK-NEXT:    ret void
;
entry:
  %gep1 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 1
  store i32 0, i32* %gep1
  %gep2 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1, i64 0
  store i32 1, i32* %gep2
  br i1 %c, label %if.else, label %if.then

if.then:
  %t = load i32, i32* %gep1 ; <- load could be eliminated
  store i32 %t, i32* %q
  ret void

if.else:
  ret void
}

; TODO: load in if.then could have been eliminated
define void @missing_load_elimination(i1 %c, <vscale x 4 x i32>* %p, <vscale x 4 x i32>* %q, <vscale x 4 x i32> %v) {
; CHECK-LABEL: @missing_load_elimination(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* [[P:%.*]], align 16
; CHECK-NEXT:    [[P1:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], i64 1
; CHECK-NEXT:    store <vscale x 4 x i32> [[V:%.*]], <vscale x 4 x i32>* [[P1]], align 16
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_ELSE:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[T:%.*]] = load <vscale x 4 x i32>, <vscale x 4 x i32>* [[P]], align 16
; CHECK-NEXT:    store <vscale x 4 x i32> [[T]], <vscale x 4 x i32>* [[Q:%.*]], align 16
; CHECK-NEXT:    ret void
; CHECK:       if.else:
; CHECK-NEXT:    ret void
;
entry:
  store <vscale x 4 x i32> zeroinitializer, <vscale x 4 x i32>* %p
  %p1 = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* %p, i64 1
  store <vscale x 4 x i32> %v, <vscale x 4 x i32>* %p1
  br i1 %c, label %if.else, label %if.then

if.then:
  %t = load <vscale x 4 x i32>, <vscale x 4 x i32>* %p ; load could be eliminated
  store <vscale x 4 x i32> %t, <vscale x 4 x i32>* %q
  ret void

if.else:
  ret void
}
