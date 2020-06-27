; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -S -analyze -scalar-evolution | FileCheck %s

; Reduced from test-suite/MultiSource/Benchmarks/MiBench/office-ispell/correct.c
; getelementptr, obviously, takes pointer as it's base, and returns a pointer.
; SCEV operands are sorted in hope that it increases folding potential,
; and at the same time SCEVAddExpr's type is the type of the last(!) operand.
; Which means, in some exceedingly rare cases, pointer operand may happen to
; end up not being the last operand, and as a result SCEV for GEP will suddenly
; have a non-pointer return type. We should ensure that does not happen.

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@c = dso_local local_unnamed_addr global i32* null, align 8
@a = dso_local local_unnamed_addr global i32 0, align 4
@b = dso_local global [1 x i32] zeroinitializer, align 4

define i32 @d(i32 %base) {
; CHECK-LABEL: 'd'
; CHECK-NEXT:  Classifying expressions for: @d
; CHECK-NEXT:    %e = alloca [1 x [1 x i8]], align 1
; CHECK-NEXT:    --> %e U: full-set S: full-set
; CHECK-NEXT:    %0 = bitcast [1 x [1 x i8]]* %e to i8*
; CHECK-NEXT:    --> %e U: full-set S: full-set
; CHECK-NEXT:    %f.0 = phi i32 [ %base, %entry ], [ %inc, %for.cond ]
; CHECK-NEXT:    --> {%base,+,1}<nsw><%for.cond> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Computable }
; CHECK-NEXT:    %idxprom = sext i32 %f.0 to i64
; CHECK-NEXT:    --> {(sext i32 %base to i64),+,1}<nsw><%for.cond> U: [-2147483648,-9223372036854775808) S: [-2147483648,-9223372036854775808) Exits: <<Unknown>> LoopDispositions: { %for.cond: Computable }
; CHECK-NEXT:    %arrayidx = getelementptr inbounds [1 x [1 x i8]], [1 x [1 x i8]]* %e, i64 0, i64 %idxprom
; CHECK-NEXT:    --> {((sext i32 %base to i64) + %e)<nsw>,+,1}<nsw><%for.cond> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Computable }
; CHECK-NEXT:    %1 = load i32*, i32** @c, align 8
; CHECK-NEXT:    --> %1 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %sub.ptr.lhs.cast = ptrtoint i32* %1 to i64
; CHECK-NEXT:    --> %sub.ptr.lhs.cast U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, ptrtoint ([1 x i32]* @b to i64)
; CHECK-NEXT:    --> ((-1 * ptrtoint ([1 x i32]* @b to i64)) + %sub.ptr.lhs.cast) U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 4
; CHECK-NEXT:    --> %sub.ptr.div U: full-set S: [-2305843009213693952,2305843009213693952) Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %arrayidx1 = getelementptr inbounds [1 x i8], [1 x i8]* %arrayidx, i64 0, i64 %sub.ptr.div
; CHECK-NEXT:    --> ({((sext i32 %base to i64) + %e)<nsw>,+,1}<nsw><%for.cond> + %sub.ptr.div)<nsw> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %2 = load i8, i8* %arrayidx1, align 1
; CHECK-NEXT:    --> %2 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %conv = sext i8 %2 to i32
; CHECK-NEXT:    --> (sext i8 %2 to i32) U: [-128,128) S: [-128,128) Exits: <<Unknown>> LoopDispositions: { %for.cond: Variant }
; CHECK-NEXT:    %inc = add nsw i32 %f.0, 1
; CHECK-NEXT:    --> {(1 + %base),+,1}<nw><%for.cond> U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %for.cond: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @d
; CHECK-NEXT:  Loop %for.cond: <multiple exits> Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %for.cond: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %for.cond: Unpredictable predicated backedge-taken count.
;
entry:
  %e = alloca [1 x [1 x i8]], align 1
  %0 = bitcast [1 x [1 x i8]]* %e to i8*
  call void @llvm.lifetime.start.p0i8(i64 1, i8* %0) #2
  br label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  %f.0 = phi i32 [ %base, %entry ], [ %inc, %for.cond ]
  %idxprom = sext i32 %f.0 to i64
  %arrayidx = getelementptr inbounds [1 x [1 x i8]], [1 x [1 x i8]]* %e, i64 0, i64 %idxprom
  %1 = load i32*, i32** @c, align 8
  %sub.ptr.lhs.cast = ptrtoint i32* %1 to i64
  %sub.ptr.sub = sub i64 %sub.ptr.lhs.cast, ptrtoint ([1 x i32]* @b to i64)
  %sub.ptr.div = sdiv exact i64 %sub.ptr.sub, 4
  %arrayidx1 = getelementptr inbounds [1 x i8], [1 x i8]* %arrayidx, i64 0, i64 %sub.ptr.div
  %2 = load i8, i8* %arrayidx1, align 1
  %conv = sext i8 %2 to i32
  store i32 %conv, i32* @a, align 4
  %inc = add nsw i32 %f.0, 1
  br label %for.cond
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
