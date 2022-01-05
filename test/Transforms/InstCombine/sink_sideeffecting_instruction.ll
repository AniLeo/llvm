; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

; Function Attrs: noinline uwtable
define i32 @foo(i32* nocapture writeonly %arg) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[VAR:%.*]] = call i32 @baz()
; CHECK-NEXT:    store i32 [[VAR]], i32* [[ARG:%.*]], align 4
; CHECK-NEXT:    [[VAR1:%.*]] = call i32 @baz()
; CHECK-NEXT:    ret i32 [[VAR1]]
;
bb:
  %var = call i32 @baz()
  store i32 %var, i32* %arg, align 4
  %var1 = call i32 @baz()
  ret i32 %var1
}
declare i32 @baz()

; Function Attrs: uwtable
; This is an equivalent IR for a c-style example with a large function (foo)
; with out-params which are unused in the caller(test8). Note that foo is
; marked noinline to prevent IPO transforms.
; int foo();
;
; extern int foo(int *out) __attribute__((noinline));
; int foo(int *out) {
;   *out = baz();
;   return baz();
; }
;
; int test() {
;
;   int notdead;
;   if (foo(&notdead))
;     return 0;
;
;   int dead;
;   int tmp = foo(&dead);
;   if (notdead)
;     return tmp;
;   return bar();
; }

; TODO: We should be able to sink the second call @foo at bb5 down to bb_crit_edge
define i32 @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[VAR1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[VAR2:%.*]] = bitcast i32* [[VAR]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[VAR2]])
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @foo(i32* nonnull writeonly [[VAR]])
; CHECK-NEXT:    [[VAR4:%.*]] = icmp eq i32 [[VAR3]], 0
; CHECK-NEXT:    br i1 [[VAR4]], label [[BB5:%.*]], label [[BB14:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[VAR6:%.*]] = bitcast i32* [[VAR1]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[VAR6]])
; CHECK-NEXT:    [[VAR8:%.*]] = load i32, i32* [[VAR]], align 4
; CHECK-NEXT:    [[VAR9:%.*]] = icmp eq i32 [[VAR8]], 0
; CHECK-NEXT:    [[VAR7:%.*]] = call i32 @foo(i32* nonnull writeonly [[VAR1]])
; CHECK-NEXT:    br i1 [[VAR9]], label [[BB10:%.*]], label [[BB_CRIT_EDGE:%.*]]
; CHECK:       bb10:
; CHECK-NEXT:    [[VAR11:%.*]] = call i32 @bar()
; CHECK-NEXT:    br label [[BB12:%.*]]
; CHECK:       bb_crit_edge:
; CHECK-NEXT:    br label [[BB12]]
; CHECK:       bb12:
; CHECK-NEXT:    [[VAR13:%.*]] = phi i32 [ [[VAR11]], [[BB10]] ], [ [[VAR7]], [[BB_CRIT_EDGE]] ]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[VAR6]])
; CHECK-NEXT:    br label [[BB14]]
; CHECK:       bb14:
; CHECK-NEXT:    [[VAR15:%.*]] = phi i32 [ [[VAR13]], [[BB12]] ], [ 0, [[BB:%.*]] ]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[VAR2]])
; CHECK-NEXT:    ret i32 [[VAR15]]
;
bb:
  %var = alloca i32, align 4
  %var1 = alloca i32, align 4
  %var2 = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %var2) #4
  %var3 = call i32 @foo(i32* nonnull writeonly %var)
  %var4 = icmp eq i32 %var3, 0
  br i1 %var4, label %bb5, label %bb14

bb5:                                              ; preds = %bb
  %var6 = bitcast i32* %var1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %var6) #4
  %var8 = load i32, i32* %var, align 4
  %var9 = icmp eq i32 %var8, 0
  %var7 = call i32 @foo(i32* nonnull writeonly %var1)
  br i1 %var9, label %bb10, label %bb_crit_edge

bb10:                                             ; preds = %bb5
  %var11 = call i32 @bar()
  br label %bb12

bb_crit_edge:
  br label %bb12

bb12:                                             ; preds = %bb10, %bb5
  %var13 = phi i32 [ %var11, %bb10 ], [ %var7, %bb_crit_edge ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %var6) #4
  br label %bb14

bb14:                                             ; preds = %bb12, %bb
  %var15 = phi i32 [ %var13, %bb12 ], [ 0, %bb ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %var2)
  ret i32 %var15
}

declare i32 @unknown(i32* %dest)
declare i32 @unknown.as2(i32 addrspace(2)* %dest)

define i32 @sink_write_to_use(i1 %c) {
; CHECK-LABEL: @sink_write_to_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull writeonly [[VAR]]) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %var3 = call i32 @unknown(i32* writeonly %var) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_readwrite_to_use(i1 %c) {
; CHECK-LABEL: @sink_readwrite_to_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_bitcast(i1 %c) {
; CHECK-LABEL: @sink_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i8, align 8
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i8* [[VAR]] to i32*
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[BITCAST]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i8, align 8
  %bitcast = bitcast i8* %var to i32*
  %var3 = call i32 @unknown(i32* %bitcast) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}


define i32 @sink_gep1(i1 %c) {
; CHECK-LABEL: @sink_gep1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR1:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[VAR1]], i64 0, i64 1
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[GEP]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i64, align 8
  %bitcast = bitcast i64* %var to i32*
  %gep = getelementptr i32, i32* %bitcast, i32 1
  %var3 = call i32 @unknown(i32* %gep) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_gep2(i1 %c) {
; CHECK-LABEL: @sink_gep2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR1:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[VAR1_SUB:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[VAR1]], i64 0, i64 0
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR1_SUB]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i64, align 8
  %bitcast = bitcast i64* %var to i32*
  %var3 = call i32 @unknown(i32* %bitcast) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_addrspacecast(i1 %c) {
; CHECK-LABEL: @sink_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 8
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[CAST:%.*]] = addrspacecast i32* [[VAR]] to i32 addrspace(2)*
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown.as2(i32 addrspace(2)* [[CAST]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 8
  %cast = addrspacecast i32* %var to i32 addrspace(2)*
  %var3 = call i32 @unknown.as2(i32 addrspace(2)* %cast) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @neg_infinite_loop(i1 %c) {
; CHECK-LABEL: @neg_infinite_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @neg_throw(i1 %c) {
; CHECK-LABEL: @neg_throw(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %var3 = call i32 @unknown(i32* %var) argmemonly willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @neg_unknown_write(i1 %c) {
; CHECK-LABEL: @neg_unknown_write(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %var3 = call i32 @unknown(i32* %var) nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_lifetime1(i1 %c) {
; CHECK-LABEL: @sink_lifetime1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[VAR]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %bitcast = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  ret i32 %var3
}

define i32 @sink_lifetime2(i1 %c) {
; CHECK-LABEL: @sink_lifetime2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[VAR]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[MERGE:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       merge:
; CHECK-NEXT:    [[RET:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[VAR3]], [[USE_BLOCK]] ]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    ret i32 [[RET]]
; CHECK:       use_block:
; CHECK-NEXT:    br label [[MERGE]]
;
entry:
  %var = alloca i32, align 4
  %bitcast = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind willreturn
  br i1 %c, label %merge, label %use_block

merge:
  %ret = phi i32 [0, %entry], [%var3, %use_block]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  ret i32 %ret

use_block:
  br label %merge
}

define i32 @sink_lifetime3(i1 %c) {
; CHECK-LABEL: @sink_lifetime3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %bitcast = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  ; If unknown accesses %var, that's UB
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind willreturn
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

define i32 @sink_lifetime4a(i1 %c) {
; CHECK-LABEL: @sink_lifetime4a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[VAR]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %bitcast = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  %var3 = call i32 @unknown(i32* %var) argmemonly nounwind willreturn
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}

; Version which only writes to var, and thus can't rely on may-read scan for
; clobbers to prevent the transform
define i32 @sink_lifetime4b(i1 %c) {
; CHECK-LABEL: @sink_lifetime4b(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[VAR]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    [[VAR3:%.*]] = call i32 @unknown(i32* nonnull writeonly [[VAR]]) #[[ATTR1]]
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull [[BITCAST]])
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  %bitcast = bitcast i32* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  %var3 = call i32 @unknown(i32* writeonly %var) argmemonly nounwind willreturn
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}
; Mostly checking that trying to sink a non-call doesn't crash (i.e. prior bug)
define i32 @sink_atomicrmw_to_use(i1 %c) {
; CHECK-LABEL: @sink_atomicrmw_to_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 0, i32* [[VAR]], align 4
; CHECK-NEXT:    [[VAR3:%.*]] = atomicrmw add i32* [[VAR]], i32 1 seq_cst, align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[EARLY_RETURN:%.*]], label [[USE_BLOCK:%.*]]
; CHECK:       early_return:
; CHECK-NEXT:    ret i32 0
; CHECK:       use_block:
; CHECK-NEXT:    ret i32 [[VAR3]]
;
entry:
  %var = alloca i32, align 4
  store i32 0, i32* %var
  %var3 = atomicrmw add i32* %var, i32 1 seq_cst, align 4
  br i1 %c, label %early_return, label %use_block

early_return:
  ret i32 0

use_block:
  ret i32 %var3
}


declare i32 @bar()
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

