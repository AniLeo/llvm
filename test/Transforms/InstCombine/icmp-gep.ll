; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S  < %s | FileCheck %s

target datalayout = "e-p:64:64:64-p1:16:16:16-p2:32:32:32-p3:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare i8* @getptr()
declare void @use(i8*)

define i1 @eq_base(i8* %x, i64 %y) {
; CHECK-LABEL: @eq_base(
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, i8* [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8* [[G]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr i8, i8* %x, i64 %y
  %r = icmp eq i8* %g, %x
  ret i1 %r
}

define i1 @ne_base_commute(i64 %y) {
; CHECK-LABEL: @ne_base_commute(
; CHECK-NEXT:    [[X:%.*]] = call i8* @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, i8* [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ne i8* [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call i8* @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr i8, i8* %x, i64 %y
  %r = icmp ne i8* %x, %g
  ret i1 %r
}

define i1 @ne_base_inbounds(i8* %x, i64 %y) {
; CHECK-LABEL: @ne_base_inbounds(
; CHECK-NEXT:    [[R:%.*]] = icmp ne i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  %r = icmp ne i8* %g, %x
  ret i1 %r
}

define i1 @eq_base_inbounds_commute(i64 %y) {
; CHECK-LABEL: @eq_base_inbounds_commute(
; CHECK-NEXT:    [[X:%.*]] = call i8* @getptr()
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call i8* @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  %r = icmp eq i8* %x, %g
  ret i1 %r
}

define i1 @sgt_base(i8* %x, i64 %y) {
; CHECK-LABEL: @sgt_base(
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, i8* [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i8* [[G]], [[X]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr i8, i8* %x, i64 %y
  %r = icmp sgt i8* %g, %x
  ret i1 %r
}

define i1 @ugt_base_commute(i64 %y) {
; CHECK-LABEL: @ugt_base_commute(
; CHECK-NEXT:    [[X:%.*]] = call i8* @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr i8, i8* [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8* [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call i8* @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr i8, i8* %x, i64 %y
  %r = icmp ugt i8* %x, %g
  ret i1 %r
}

define i1 @ult_base_inbounds(i8* %x, i64 %y) {
; CHECK-LABEL: @ult_base_inbounds(
; CHECK-NEXT:    [[R:%.*]] = icmp slt i64 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  %r = icmp ult i8* %g, %x
  ret i1 %r
}

define i1 @slt_base_inbounds_commute(i64 %y) {
; CHECK-LABEL: @slt_base_inbounds_commute(
; CHECK-NEXT:    [[X:%.*]] = call i8* @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, i8* [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp slt i8* [[X]], [[G]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call i8* @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  %r = icmp slt i8* %x, %g
  ret i1 %r
}

define i1 @ne_base_inbounds_use(i8* %x, i64 %y) {
; CHECK-LABEL: @ne_base_inbounds_use(
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, i8* [[X:%.*]], i64 [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8* [[G]])
; CHECK-NEXT:    [[R:%.*]] = icmp ne i64 [[Y]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  call void @use(i8* %g)
  %r = icmp ne i8* %g, %x
  ret i1 %r
}

define i1 @eq_base_inbounds_commute_use(i64 %y) {
; CHECK-LABEL: @eq_base_inbounds_commute_use(
; CHECK-NEXT:    [[X:%.*]] = call i8* @getptr()
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds i8, i8* [[X]], i64 [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8* [[G]])
; CHECK-NEXT:    [[R:%.*]] = icmp eq i64 [[Y]], 0
; CHECK-NEXT:    ret i1 [[R]]
;
  %x = call i8* @getptr() ; thwart complexity-based canonicalization
  %g = getelementptr inbounds i8, i8* %x, i64 %y
  call void @use(i8* %g)
  %r = icmp eq i8* %x, %g
  ret i1 %r
}

@X = global [1000 x i32] zeroinitializer

define i1 @PR8882(i64 %i) {
; CHECK-LABEL: @PR8882(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[I:%.*]], 1000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %p1 = getelementptr inbounds i32, i32* getelementptr inbounds ([1000 x i32], [1000 x i32]* @X, i64 0, i64 0), i64 %i
  %cmp = icmp eq i32* %p1, getelementptr inbounds ([1000 x i32], [1000 x i32]* @X, i64 1, i64 0)
  ret i1 %cmp
}

@X_as1 = addrspace(1) global [1000 x i32] zeroinitializer

define i1 @test24_as1(i64 %i) {
; CHECK-LABEL: @test24_as1(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[I:%.*]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[TMP1]], 1000
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %p1 = getelementptr inbounds i32, i32 addrspace(1)* getelementptr inbounds ([1000 x i32], [1000 x i32] addrspace(1)* @X_as1, i64 0, i64 0), i64 %i
  %cmp = icmp eq i32 addrspace(1)* %p1, getelementptr inbounds ([1000 x i32], [1000 x i32] addrspace(1)* @X_as1, i64 1, i64 0)
  ret i1 %cmp
}

; PR16244
define i1 @test71(i8* %x) {
; CHECK-LABEL: @test71(
; CHECK-NEXT:    ret i1 false
;
  %a = getelementptr i8, i8* %x, i64 8
  %b = getelementptr inbounds i8, i8* %x, i64 8
  %c = icmp ugt i8* %a, %b
  ret i1 %c
}

define i1 @test71_as1(i8 addrspace(1)* %x) {
; CHECK-LABEL: @test71_as1(
; CHECK-NEXT:    ret i1 false
;
  %a = getelementptr i8, i8 addrspace(1)* %x, i64 8
  %b = getelementptr inbounds i8, i8 addrspace(1)* %x, i64 8
  %c = icmp ugt i8 addrspace(1)* %a, %b
  ret i1 %c
}

declare i32 @test58_d(i64)

define i1 @test59(i8* %foo) {
; CHECK-LABEL: @test59(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, i8* [[FOO:%.*]], i64 8
; CHECK-NEXT:    [[USE:%.*]] = ptrtoint i8* [[GEP1]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @test58_d(i64 [[USE]])
; CHECK-NEXT:    ret i1 true
;
  %bit = bitcast i8* %foo to i32*
  %gep1 = getelementptr inbounds i32, i32* %bit, i64 2
  %gep2 = getelementptr inbounds i8, i8* %foo, i64 10
  %cast1 = bitcast i32* %gep1 to i8*
  %cmp = icmp ult i8* %cast1, %gep2
  %use = ptrtoint i8* %cast1 to i64
  %call = call i32 @test58_d(i64 %use)
  ret i1 %cmp
}

define i1 @test59_as1(i8 addrspace(1)* %foo) {
; CHECK-LABEL: @test59_as1(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[FOO:%.*]], i16 8
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i8 addrspace(1)* [[GEP1]] to i16
; CHECK-NEXT:    [[USE:%.*]] = zext i16 [[TMP1]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @test58_d(i64 [[USE]])
; CHECK-NEXT:    ret i1 true
;
  %bit = bitcast i8 addrspace(1)* %foo to i32 addrspace(1)*
  %gep1 = getelementptr inbounds i32, i32 addrspace(1)* %bit, i64 2
  %gep2 = getelementptr inbounds i8, i8 addrspace(1)* %foo, i64 10
  %cast1 = bitcast i32 addrspace(1)* %gep1 to i8 addrspace(1)*
  %cmp = icmp ult i8 addrspace(1)* %cast1, %gep2
  %use = ptrtoint i8 addrspace(1)* %cast1 to i64
  %call = call i32 @test58_d(i64 %use)
  ret i1 %cmp
}

define i1 @test60(i8* %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[I:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i64 [[GEP1_IDX]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %bit = bitcast i8* %foo to i32*
  %gep1 = getelementptr inbounds i32, i32* %bit, i64 %i
  %gep2 = getelementptr inbounds i8, i8* %foo, i64 %j
  %cast1 = bitcast i32* %gep1 to i8*
  %cmp = icmp ult i8* %cast1, %gep2
  ret i1 %cmp
}

define i1 @test60_as1(i8 addrspace(1)* %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_as1(
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[I:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[J:%.*]] to i16
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i16 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i16 [[GEP1_IDX]], [[TMP2]]
; CHECK-NEXT:    ret i1 [[TMP3]]
;
  %bit = bitcast i8 addrspace(1)* %foo to i32 addrspace(1)*
  %gep1 = getelementptr inbounds i32, i32 addrspace(1)* %bit, i64 %i
  %gep2 = getelementptr inbounds i8, i8 addrspace(1)* %foo, i64 %j
  %cast1 = bitcast i32 addrspace(1)* %gep1 to i8 addrspace(1)*
  %cmp = icmp ult i8 addrspace(1)* %cast1, %gep2
  ret i1 %cmp
}

; Same as test60, but look through an addrspacecast instead of a
; bitcast. This uses the same sized addrspace.
define i1 @test60_addrspacecast(i8* %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test60_addrspacecast(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[I:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i64 [[GEP1_IDX]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %bit = addrspacecast i8* %foo to i32 addrspace(3)*
  %gep1 = getelementptr inbounds i32, i32 addrspace(3)* %bit, i64 %i
  %gep2 = getelementptr inbounds i8, i8* %foo, i64 %j
  %cast1 = addrspacecast i32 addrspace(3)* %gep1 to i8*
  %cmp = icmp ult i8* %cast1, %gep2
  ret i1 %cmp
}

define i1 @test60_addrspacecast_smaller(i8* %foo, i16 %i, i64 %j) {
; CHECK-LABEL: @test60_addrspacecast_smaller(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i16 [[I:%.*]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i64 [[J:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i16 [[GEP1_IDX]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %bit = addrspacecast i8* %foo to i32 addrspace(1)*
  %gep1 = getelementptr inbounds i32, i32 addrspace(1)* %bit, i16 %i
  %gep2 = getelementptr inbounds i8, i8* %foo, i64 %j
  %cast1 = addrspacecast i32 addrspace(1)* %gep1 to i8*
  %cmp = icmp ult i8* %cast1, %gep2
  ret i1 %cmp
}

define i1 @test60_addrspacecast_larger(i8 addrspace(1)* %foo, i32 %i, i16 %j) {
; CHECK-LABEL: @test60_addrspacecast_larger(
; CHECK-NEXT:    [[I_TR:%.*]] = trunc i32 [[I:%.*]] to i16
; CHECK-NEXT:    [[TMP1:%.*]] = shl i16 [[I_TR]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i16 [[TMP1]], [[J:%.*]]
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %bit = addrspacecast i8 addrspace(1)* %foo to i32 addrspace(2)*
  %gep1 = getelementptr inbounds i32, i32 addrspace(2)* %bit, i32 %i
  %gep2 = getelementptr inbounds i8, i8 addrspace(1)* %foo, i16 %j
  %cast1 = addrspacecast i32 addrspace(2)* %gep1 to i8 addrspace(1)*
  %cmp = icmp ult i8 addrspace(1)* %cast1, %gep2
  ret i1 %cmp
}

define i1 @test61(i8* %foo, i64 %i, i64 %j) {
; CHECK-LABEL: @test61(
; CHECK-NEXT:    [[BIT:%.*]] = bitcast i8* [[FOO:%.*]] to i32*
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, i32* [[BIT]], i64 [[I:%.*]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, i8* [[FOO]], i64 [[J:%.*]]
; CHECK-NEXT:    [[CAST1:%.*]] = bitcast i32* [[GEP1]] to i8*
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8* [[GEP2]], [[CAST1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = bitcast i8* %foo to i32*
  %gep1 = getelementptr i32, i32* %bit, i64 %i
  %gep2 = getelementptr  i8,  i8* %foo, i64 %j
  %cast1 = bitcast i32* %gep1 to i8*
  %cmp = icmp ult i8* %cast1, %gep2
  ret i1 %cmp
; Don't transform non-inbounds GEPs.
}

define i1 @test61_as1(i8 addrspace(1)* %foo, i16 %i, i16 %j) {
; CHECK-LABEL: @test61_as1(
; CHECK-NEXT:    [[BIT:%.*]] = bitcast i8 addrspace(1)* [[FOO:%.*]] to i32 addrspace(1)*
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, i32 addrspace(1)* [[BIT]], i16 [[I:%.*]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, i8 addrspace(1)* [[FOO]], i16 [[J:%.*]]
; CHECK-NEXT:    [[CAST1:%.*]] = bitcast i32 addrspace(1)* [[GEP1]] to i8 addrspace(1)*
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 addrspace(1)* [[GEP2]], [[CAST1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %bit = bitcast i8 addrspace(1)* %foo to i32 addrspace(1)*
  %gep1 = getelementptr i32, i32 addrspace(1)* %bit, i16 %i
  %gep2 = getelementptr i8, i8 addrspace(1)* %foo, i16 %j
  %cast1 = bitcast i32 addrspace(1)* %gep1 to i8 addrspace(1)*
  %cmp = icmp ult i8 addrspace(1)* %cast1, %gep2
  ret i1 %cmp
; Don't transform non-inbounds GEPs.
}
