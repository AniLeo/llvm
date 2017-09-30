; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -newgvn -enable-phi-of-ops=true -S | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define i32 @test1(i32, i8**) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[TMP4:%.*]], label [[TMP5:%.*]]
; CHECK:         br label [[TMP6:%.*]]
; CHECK:         br label [[TMP6]]
; CHECK:         [[PHIOFOPS:%.*]] = phi i32 [ 75, [[TMP4]] ], [ 105, [[TMP5]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32 [ 5, [[TMP4]] ], [ 7, [[TMP5]] ]
; CHECK-NEXT:    ret i32 [[PHIOFOPS]]
;
  %3 = icmp ne i32 %0, 0
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  br label %6

; <label>:5:                                      ; preds = %2
  br label %6

; <label>:6:                                      ; preds = %5, %4
  %.0 = phi i32 [ 5, %4 ], [ 7, %5 ]
  %7 = mul nsw i32 %.0, 15
  ret i32 %7
}
;; Dependent phi of ops
define i32 @test1b(i32, i8**) {
; CHECK-LABEL: @test1b(
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[TMP4:%.*]], label [[TMP5:%.*]]
; CHECK:         br label [[TMP6:%.*]]
; CHECK:         br label [[TMP6]]
; CHECK:         [[PHIOFOPS1:%.*]] = phi i32 [ 75, [[TMP4]] ], [ 105, [[TMP5]] ]
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i32 [ 1125, [[TMP4]] ], [ 1575, [[TMP5]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32 [ 5, [[TMP4]] ], [ 7, [[TMP5]] ]
; CHECK-NEXT:    ret i32 [[PHIOFOPS]]
;
  %3 = icmp ne i32 %0, 0
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  br label %6

; <label>:5:                                      ; preds = %2
  br label %6

; <label>:6:                                      ; preds = %5, %4
  %.0 = phi i32 [ 5, %4 ], [ 7, %5 ]
  %7 = mul nsw i32 %.0, 15
  %8 = mul nsw i32 %7, 15
  ret i32 %8
}

define i32 @test2(i32) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[TMP3:%.*]], label [[TMP4:%.*]]
; CHECK:         br label [[TMP5:%.*]]
; CHECK:         br label [[TMP5]]
; CHECK:         [[DOT01:%.*]] = phi i32 [ 3, [[TMP3]] ], [ 2, [[TMP4]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32 [ 2, [[TMP3]] ], [ 3, [[TMP4]] ]
; CHECK-NEXT:    ret i32 5
;
  %2 = icmp ne i32 %0, 0
  br i1 %2, label %3, label %4

; <label>:3:                                      ; preds = %1
  br label %5

; <label>:4:                                      ; preds = %1
  br label %5

; <label>:5:                                      ; preds = %4, %3
  %.01 = phi i32 [ 3, %3 ], [ 2, %4 ]
  %.0 = phi i32 [ 2, %3 ], [ 3, %4 ]
  %6 = add nsw i32 %.01, %.0
  ret i32 %6
}
define i32 @test3(i1 %which) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i32 [ -877, [[ENTRY:%.*]] ], [ 113, [[DELAY]] ]
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 1000, [[ENTRY]] ], [ 10, [[DELAY]] ]
; CHECK-NEXT:    ret i32 [[PHIOFOPS]]
;

entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi i32 [ 1000, %entry ], [ 10, %delay ]
  %value = sub i32 123, %A
  ret i32 %value
}

define <2 x i32> @test3vec(i1 %which) {
; CHECK-LABEL: @test3vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi <2 x i32> [ <i32 -877, i32 -877>, [[ENTRY:%.*]] ], [ <i32 113, i32 113>, [[DELAY]] ]
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 1000, i32 1000>, [[ENTRY]] ], [ <i32 10, i32 10>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[PHIOFOPS]]
;

entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 1000>, %entry ], [ <i32 10, i32 10>, %delay ]
  %value = sub <2 x i32> <i32 123, i32 123>, %A
  ret <2 x i32> %value
}

define <2 x i32> @test3vec2(i1 %which) {
; CHECK-LABEL: @test3vec2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi <2 x i32> [ <i32 -877, i32 -2167>, [[ENTRY:%.*]] ], [ <i32 113, i32 303>, [[DELAY]] ]
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 1000, i32 2500>, [[ENTRY]] ], [ <i32 10, i32 30>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[PHIOFOPS]]
;

entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 2500>, %entry ], [ <i32 10, i32 30>, %delay ]
  %value = sub <2 x i32> <i32 123, i32 333>, %A
  ret <2 x i32> %value
}

;; This example is a bit contrived because we can't create fake memoryuses, so we use two loads in the if blocks
define i32 @test4(i32, i8**, i32* noalias, i32* noalias) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    store i32 5, i32* [[TMP2:%.*]], align 4
; CHECK-NEXT:    store i32 7, i32* [[TMP3:%.*]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP0:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[TMP6:%.*]], label [[TMP7:%.*]]
; CHECK:         br label [[TMP8:%.*]]
; CHECK:         br label [[TMP8]]
; CHECK:         [[DOT01:%.*]] = phi i32 [ 5, [[TMP6]] ], [ 7, [[TMP7]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32* [ [[TMP2]], [[TMP6]] ], [ [[TMP3]], [[TMP7]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, i32* [[DOT0]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = mul nsw i32 [[TMP9]], 15
; CHECK-NEXT:    [[TMP11:%.*]] = mul nsw i32 [[TMP10]], [[DOT01]]
; CHECK-NEXT:    ret i32 [[TMP11]]
;
  store i32 5, i32* %2, align 4
  store i32 7, i32* %3, align 4
  %5 = icmp ne i32 %0, 0
  br i1 %5, label %6, label %8

; <label>:6:                                      ; preds = %4
  %7 = load i32, i32* %2, align 4
  br label %10

; <label>:8:                                      ; preds = %4
  %9 = load i32, i32* %3, align 4
  br label %10

; <label>:10:                                     ; preds = %8, %6
  %.01 = phi i32 [ %7, %6 ], [ %9, %8 ]
  %.0 = phi i32* [ %2, %6 ], [ %3, %8 ]
  %11 = load i32, i32* %.0, align 4
  %12 = mul nsw i32 %11, 15
  %13 = mul nsw i32 %12, %.01
  ret i32 %13
}

@global = common global [100 x i64] zeroinitializer, align 16
@global.1 = common global [100 x i64] zeroinitializer, align 16
define i64 @test5(i64 %arg) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = alloca i64, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[ARG:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[BB28:%.*]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB7:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[TMP6:%.*]] = icmp eq i64 [[TMP9:%.*]], 0
; CHECK-NEXT:    br i1 [[TMP6]], label [[BB27:%.*]], label [[BB7]]
; CHECK:       bb7:
; CHECK-NEXT:    [[TMP8:%.*]] = phi i64 [ [[ARG]], [[BB2]] ], [ [[TMP9]], [[BB5]] ]
; CHECK-NEXT:    [[TMP9]] = add nsw i64 [[TMP8]], -1
; CHECK-NEXT:    [[TMP10:%.*]] = load i64, i64* getelementptr inbounds ([100 x i64], [100 x i64]* @global, i64 0, i64 0), align 16
; CHECK-NEXT:    [[TMP11:%.*]] = load i64, i64* getelementptr inbounds ([100 x i64], [100 x i64]* @global.1, i64 0, i64 0), align 16
; CHECK-NEXT:    [[TMP12:%.*]] = mul nsw i64 [[TMP11]], [[TMP10]]
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[TMP12]], 0
; CHECK-NEXT:    br i1 [[TMP13]], label [[BB5]], label [[BB14:%.*]]
; CHECK:       bb14:
; CHECK-NEXT:    br label [[BB15:%.*]]
; CHECK:       bb15:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i64 [ [[TMP25:%.*]], [[BB15]] ], [ [[TMP12]], [[BB14]] ]
; CHECK-NEXT:    [[TMP16:%.*]] = phi i64 [ [[TMP24:%.*]], [[BB15]] ], [ [[TMP11]], [[BB14]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = phi i64 [ [[TMP22:%.*]], [[BB15]] ], [ [[TMP10]], [[BB14]] ]
; CHECK-NEXT:    [[TMP18:%.*]] = phi i64 [ [[TMP20:%.*]], [[BB15]] ], [ 0, [[BB14]] ]
; CHECK-NEXT:    store i64 [[PHIOFOPS]], i64* [[TMP]], align 8
; CHECK-NEXT:    [[TMP20]] = add nuw nsw i64 [[TMP18]], 1
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds [100 x i64], [100 x i64]* @global, i64 0, i64 [[TMP20]]
; CHECK-NEXT:    [[TMP22]] = load i64, i64* [[TMP21]], align 8
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr inbounds [100 x i64], [100 x i64]* @global.1, i64 0, i64 [[TMP20]]
; CHECK-NEXT:    [[TMP24]] = load i64, i64* [[TMP23]], align 8
; CHECK-NEXT:    [[TMP25]] = mul nsw i64 [[TMP24]], [[TMP22]]
; CHECK-NEXT:    [[TMP26:%.*]] = icmp eq i64 [[TMP20]], [[TMP25]]
; CHECK-NEXT:    br i1 [[TMP26]], label [[BB4:%.*]], label [[BB15]]
; CHECK:       bb27:
; CHECK-NEXT:    br label [[BB28]]
; CHECK:       bb28:
; CHECK-NEXT:    ret i64 0
;
bb:
  %tmp = alloca i64, align 8
  %tmp1 = icmp eq i64 %arg, 0
  br i1 %tmp1, label %bb28, label %bb2

bb2:                                              ; preds = %bb
  %tmp3 = bitcast i64* %tmp to i8*
  br label %bb7

bb4:                                              ; preds = %bb15
  br label %bb5

bb5:                                              ; preds = %bb7, %bb4
  %tmp6 = icmp eq i64 %tmp9, 0
  br i1 %tmp6, label %bb27, label %bb7

bb7:                                              ; preds = %bb5, %bb2
  %tmp8 = phi i64 [ %arg, %bb2 ], [ %tmp9, %bb5 ]
  %tmp9 = add nsw i64 %tmp8, -1
  %tmp10 = load i64, i64* getelementptr inbounds ([100 x i64], [100 x i64]* @global, i64 0, i64 0), align 16
  %tmp11 = load i64, i64* getelementptr inbounds ([100 x i64], [100 x i64]* @global.1, i64 0, i64 0), align 16
  %tmp12 = mul nsw i64 %tmp11, %tmp10
  %tmp13 = icmp eq i64 %tmp12, 0
  br i1 %tmp13, label %bb5, label %bb14

bb14:                                             ; preds = %bb7
  br label %bb15

bb15:                                             ; preds = %bb15, %bb14
  %tmp16 = phi i64 [ %tmp24, %bb15 ], [ %tmp11, %bb14 ]
  %tmp17 = phi i64 [ %tmp22, %bb15 ], [ %tmp10, %bb14 ]
  %tmp18 = phi i64 [ %tmp20, %bb15 ], [ 0, %bb14 ]
;; This multiply is an op of phis which is really equivalent to phi(tmp25, tmp12)
  %tmp19 = mul nsw i64 %tmp16, %tmp17
  store i64 %tmp19, i64* %tmp, align 8
  %tmp20 = add nuw nsw i64 %tmp18, 1
  %tmp21 = getelementptr inbounds [100 x i64], [100 x i64]* @global, i64 0, i64 %tmp20
  %tmp22 = load i64, i64* %tmp21, align 8
  %tmp23 = getelementptr inbounds [100 x i64], [100 x i64]* @global.1, i64 0, i64 %tmp20
  %tmp24 = load i64, i64* %tmp23, align 8
  %tmp25 = mul nsw i64 %tmp24, %tmp22
  %tmp26 = icmp eq i64 %tmp20, %tmp25
  br i1 %tmp26, label %bb4, label %bb15

bb27:                                             ; preds = %bb5
  br label %bb28

bb28:                                             ; preds = %bb27, %bb
  ret i64 0
}

;; These icmps are all equivalent to phis of constants
define i8 @test6(i8* %addr) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry-block:
; CHECK-NEXT:    br label %main-loop
; CHECK:       main-loop:
; CHECK-NEXT:    [[PHIOFOPS1:%.*]] = phi i1 [ true, %entry-block ], [ false, [[CORE:%.*]] ]
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i1 [ false, %entry-block ], [ true, [[CORE]] ]
; CHECK-NEXT:    [[PHI:%.*]] = phi i8 [ 0, %entry-block ], [ 1, [[CORE]] ]
; CHECK-NEXT:    store volatile i8 0, i8* [[ADDR:%.*]]
; CHECK-NEXT:    br i1 [[PHIOFOPS1]], label %busy-wait-phi-0, label [[EXIT:%.*]]
; CHECK:       busy-wait-phi-0:
; CHECK-NEXT:    [[LOAD:%.*]] = load volatile i8, i8* [[ADDR]]
; CHECK-NEXT:    [[ICMP:%.*]] = icmp eq i8 [[LOAD]], 0
; CHECK-NEXT:    br i1 [[ICMP]], label %busy-wait-phi-0, label [[CORE]]
; CHECK:       core:
; CHECK-NEXT:    br i1 [[PHIOFOPS]], label [[TRAP:%.*]], label %main-loop
; CHECK:       trap:
; CHECK-NEXT:    ret i8 1
; CHECK:       exit:
; CHECK-NEXT:    ret i8 0
;
entry-block:
  br label %main-loop

main-loop:
  %phi = phi i8 [ 0, %entry-block ], [ 1, %core ]
  %switch_0 = icmp eq i8 %phi, 0
  store volatile i8 0, i8* %addr
  br i1 %switch_0, label %busy-wait-phi-0, label %exit

busy-wait-phi-0:
  %load = load volatile i8, i8* %addr
  %icmp = icmp eq i8 %load, 0
  br i1 %icmp, label %busy-wait-phi-0, label %core

core:
  %switch_1 = icmp eq i8 %phi, 1
  br i1 %switch_1, label %trap, label %main-loop

trap:
  ret i8 1

exit:
  ret i8 0
}

; Test that we don't infinite loop simplifying
; an undefined value that can go both ways.
define void @test7() {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB1]]
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb1, %bb
  %tmp = phi i32 [ undef, %bb ], [ %tmp3, %bb1 ]
  %tmp2 = icmp eq i32 %tmp, 0
  %tmp3 = select i1 %tmp2, i32 1, i32 %tmp
  br label %bb1
}



; Test that we get a consistent answer about what the
; value of this undefined select is.
define void @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB1]]
;
bb:
  %tmp = select i1 undef, i8 0, i8 1
  br label %bb1

bb1:                                              ; preds = %bb1, %bb
  %tmp2 = phi i8 [ %tmp4, %bb1 ], [ %tmp, %bb ]
  %tmp3 = icmp eq i8 %tmp2, 0
  %tmp4 = select i1 %tmp3, i8 1, i8 %tmp2
  br label %bb1
}


;; Make sure we handle the case where we later come up with an expression that we need
;; for a phi of ops.
define void @test9() {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB6:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i32 [ -13, [[BB2]] ], [ [[TMP11:%.*]], [[BB6]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = phi i32 [ 1, [[BB2]] ], [ [[TMP8:%.*]], [[BB6]] ]
; CHECK-NEXT:    [[TMP8]] = add nuw nsw i32 [[TMP7]], 1
; CHECK-NEXT:    [[TMP11]] = add i32 -14, [[TMP8]]
; CHECK-NEXT:    br label [[BB6]]
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb1, %bb
  br i1 undef, label %bb1, label %bb2

bb2:                                              ; preds = %bb1
  %tmp = select i1 true, i32 -14, i32 -10
  %tmp3 = add i32 %tmp, 0
  %tmp4 = select i1 true, i32 -14, i32 -10
  %tmp5 = add i32 %tmp4, 0
  br label %bb6

bb6:                                              ; preds = %bb6, %bb2
  %tmp7 = phi i32 [ 1, %bb2 ], [ %tmp13, %bb6 ]
  %tmp8 = add nuw nsw i32 %tmp7, 1
  %tmp9 = add i32 %tmp3, %tmp7
  %tmp10 = select i1 false, i32 undef, i32 %tmp9
  %tmp11 = add i32 %tmp5, %tmp8
  %tmp12 = select i1 undef, i32 undef, i32 %tmp11
  %tmp13 = add nuw nsw i32 %tmp7, 1
  br label %bb6
}

;; Ensure that we revisit predicateinfo operands at the right points in time.
define void @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:  b:
; CHECK-NEXT:    br label [[G:%.*]]
; CHECK:       g:
; CHECK-NEXT:    [[N:%.*]] = phi i32* [ [[H:%.*]], [[I:%.*]] ], [ null, [[B:%.*]] ]
; CHECK-NEXT:    [[H]] = getelementptr i32, i32* [[N]], i64 1
; CHECK-NEXT:    [[J:%.*]] = icmp eq i32* [[H]], inttoptr (i64 32 to i32*)
; CHECK-NEXT:    br i1 [[J]], label [[C:%.*]], label [[I]]
; CHECK:       i:
; CHECK-NEXT:    br i1 undef, label [[K:%.*]], label [[G]]
; CHECK:       k:
; CHECK-NEXT:    br i1 false, label [[C]], label [[O:%.*]]
; CHECK:       o:
; CHECK-NEXT:    br label [[C]]
; CHECK:       c:
; CHECK-NEXT:    ret void
;
b:
  %m = getelementptr i32, i32* null, i64 8
  br label %g

g:                                                ; preds = %i, %b
  %n = phi i32* [ %h, %i ], [ null, %b ]
  %h = getelementptr i32, i32* %n, i64 1
  %j = icmp eq i32* %h, %m
  br i1 %j, label %c, label %i

i:                                                ; preds = %g
  br i1 undef, label %k, label %g

k:                                                ; preds = %i
  %l = icmp eq i32* %n, %m
  br i1 %l, label %c, label %o

o:                                                ; preds = %k
  br label %c

c:                                                ; preds = %o, %k, %g
  %0 = phi i32* [ undef, %o ], [ %m, %k ], [ %m, %g ]
  ret void
}

;; Ensure we handle VariableExpression properly.
define void @test11() {
; CHECK-LABEL: @test11(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 undef, label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB2]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP:%.*]] = phi i1 [ false, [[BB1]] ], [ true, [[BB:%.*]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = call i32* @wombat()
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i32* [[TMP3]], null
; CHECK-NEXT:    [[TMP5:%.*]] = and i1 [[TMP]], [[TMP4]]
; CHECK-NEXT:    br i1 [[TMP5]], label [[BB6:%.*]], label [[BB7:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    unreachable
; CHECK:       bb7:
; CHECK-NEXT:    ret void
;
bb:
  br i1 undef, label %bb1, label %bb2

bb1:                                              ; preds = %bb
  br label %bb2

bb2:                                              ; preds = %bb1, %bb
  %tmp = phi i1 [ false, %bb1 ], [ true, %bb ]
  %tmp3 = call i32* @wombat()
  %tmp4 = icmp ne i32* %tmp3, null
  %tmp5 = and i1 %tmp, %tmp4
  br i1 %tmp5, label %bb6, label %bb7

bb6:                                              ; preds = %bb2
  unreachable

bb7:                                              ; preds = %bb2
  ret void
}

declare i32* @wombat()

;; Ensure that when reachability affects a phi of ops, we recompute
;; it.  Here, the phi node is marked for recomputation when bb7->bb3
;; becomes live, but the value does not change. if we do not directly
;; recompute the phi of ops instruction (tmp5), the value number will
;; change in the verifier, as it goes from a constant value to a
;; phi of [true, false]

define void @test12() {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* null
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[TMP]], 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[BB2:%.*]], label [[BB8:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i1 [ true, [[BB2]] ], [ false, [[BB7:%.*]] ]
; CHECK-NEXT:    br i1 [[PHIOFOPS]], label [[BB6:%.*]], label [[BB7]]
; CHECK:       bb6:
; CHECK-NEXT:    br label [[BB7]]
; CHECK:       bb7:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb8:
; CHECK-NEXT:    ret void
;
bb:
  %tmp = load i32, i32* null
  %tmp1 = icmp sgt i32 %tmp, 0
  br i1 %tmp1, label %bb2, label %bb8

bb2:                                              ; preds = %bb
  br label %bb3

bb3:                                              ; preds = %bb7, %bb2
  %tmp4 = phi i32 [ %tmp, %bb2 ], [ undef, %bb7 ]
  %tmp5 = icmp sgt i32 %tmp4, 0
  br i1 %tmp5, label %bb6, label %bb7

bb6:                                              ; preds = %bb3
  br label %bb7

bb7:                                              ; preds = %bb6, %bb3
  br label %bb3

bb8:                                              ; preds = %bb
  ret void
}
