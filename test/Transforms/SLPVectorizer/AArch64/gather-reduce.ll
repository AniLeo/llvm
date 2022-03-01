; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -dce -instcombine < %s | FileCheck %s --check-prefix=GENERIC
; RUN: opt -S -mcpu=kryo -slp-vectorizer -dce -instcombine < %s | FileCheck %s --check-prefix=KRYO

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"
target triple = "aarch64--linux-gnu"

; These tests check that we vectorize the index calculations in the
; gather-reduce pattern shown below. We check cases having i32 and i64
; subtraction.
;
; int gather_reduce_8x16(short *a, short *b, short *g, int n) {
;   int sum = 0;
;   for (int i = 0; i < n ; ++i) {
;     sum += g[*a++ - b[0]]; sum += g[*a++ - b[1]];
;     sum += g[*a++ - b[2]]; sum += g[*a++ - b[3]];
;     sum += g[*a++ - b[4]]; sum += g[*a++ - b[5]];
;     sum += g[*a++ - b[6]]; sum += g[*a++ - b[7]];
;   }
;   return sum;
; }

define i32 @gather_reduce_8x16_i32(i16* nocapture readonly %a, i16* nocapture readonly %b, i16* nocapture readonly %g, i32 %n) {
; GENERIC-LABEL: @gather_reduce_8x16_i32(
; GENERIC-NEXT:  entry:
; GENERIC-NEXT:    [[CMP_99:%.*]] = icmp sgt i32 [[N:%.*]], 0
; GENERIC-NEXT:    br i1 [[CMP_99]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; GENERIC:       for.body.preheader:
; GENERIC-NEXT:    br label [[FOR_BODY:%.*]]
; GENERIC:       for.cond.cleanup.loopexit:
; GENERIC-NEXT:    br label [[FOR_COND_CLEANUP]]
; GENERIC:       for.cond.cleanup:
; GENERIC-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD66:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; GENERIC-NEXT:    ret i32 [[SUM_0_LCSSA]]
; GENERIC:       for.body:
; GENERIC-NEXT:    [[I_0103:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[SUM_0102:%.*]] = phi i32 [ [[ADD66]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[A_ADDR_0101:%.*]] = phi i16* [ [[INCDEC_PTR58:%.*]], [[FOR_BODY]] ], [ [[A:%.*]], [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[TMP0:%.*]] = bitcast i16* [[A_ADDR_0101]] to <8 x i16>*
; GENERIC-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* [[TMP0]], align 2
; GENERIC-NEXT:    [[TMP2:%.*]] = zext <8 x i16> [[TMP1]] to <8 x i32>
; GENERIC-NEXT:    [[TMP3:%.*]] = bitcast i16* [[B:%.*]] to <8 x i16>*
; GENERIC-NEXT:    [[TMP4:%.*]] = load <8 x i16>, <8 x i16>* [[TMP3]], align 2
; GENERIC-NEXT:    [[TMP5:%.*]] = zext <8 x i16> [[TMP4]] to <8 x i32>
; GENERIC-NEXT:    [[TMP6:%.*]] = sub nsw <8 x i32> [[TMP2]], [[TMP5]]
; GENERIC-NEXT:    [[TMP7:%.*]] = extractelement <8 x i32> [[TMP6]], i64 0
; GENERIC-NEXT:    [[TMP8:%.*]] = sext i32 [[TMP7]] to i64
; GENERIC-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[G:%.*]], i64 [[TMP8]]
; GENERIC-NEXT:    [[TMP9:%.*]] = load i16, i16* [[ARRAYIDX]], align 2
; GENERIC-NEXT:    [[CONV3:%.*]] = zext i16 [[TMP9]] to i32
; GENERIC-NEXT:    [[ADD:%.*]] = add nsw i32 [[SUM_0102]], [[CONV3]]
; GENERIC-NEXT:    [[TMP10:%.*]] = extractelement <8 x i32> [[TMP6]], i64 1
; GENERIC-NEXT:    [[TMP11:%.*]] = sext i32 [[TMP10]] to i64
; GENERIC-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP11]]
; GENERIC-NEXT:    [[TMP12:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; GENERIC-NEXT:    [[CONV11:%.*]] = zext i16 [[TMP12]] to i32
; GENERIC-NEXT:    [[ADD12:%.*]] = add nsw i32 [[ADD]], [[CONV11]]
; GENERIC-NEXT:    [[TMP13:%.*]] = extractelement <8 x i32> [[TMP6]], i64 2
; GENERIC-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; GENERIC-NEXT:    [[ARRAYIDX19:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP14]]
; GENERIC-NEXT:    [[TMP15:%.*]] = load i16, i16* [[ARRAYIDX19]], align 2
; GENERIC-NEXT:    [[CONV20:%.*]] = zext i16 [[TMP15]] to i32
; GENERIC-NEXT:    [[ADD21:%.*]] = add nsw i32 [[ADD12]], [[CONV20]]
; GENERIC-NEXT:    [[TMP16:%.*]] = extractelement <8 x i32> [[TMP6]], i64 3
; GENERIC-NEXT:    [[TMP17:%.*]] = sext i32 [[TMP16]] to i64
; GENERIC-NEXT:    [[ARRAYIDX28:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP17]]
; GENERIC-NEXT:    [[TMP18:%.*]] = load i16, i16* [[ARRAYIDX28]], align 2
; GENERIC-NEXT:    [[CONV29:%.*]] = zext i16 [[TMP18]] to i32
; GENERIC-NEXT:    [[ADD30:%.*]] = add nsw i32 [[ADD21]], [[CONV29]]
; GENERIC-NEXT:    [[TMP19:%.*]] = extractelement <8 x i32> [[TMP6]], i64 4
; GENERIC-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; GENERIC-NEXT:    [[ARRAYIDX37:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP20]]
; GENERIC-NEXT:    [[TMP21:%.*]] = load i16, i16* [[ARRAYIDX37]], align 2
; GENERIC-NEXT:    [[CONV38:%.*]] = zext i16 [[TMP21]] to i32
; GENERIC-NEXT:    [[ADD39:%.*]] = add nsw i32 [[ADD30]], [[CONV38]]
; GENERIC-NEXT:    [[TMP22:%.*]] = extractelement <8 x i32> [[TMP6]], i64 5
; GENERIC-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; GENERIC-NEXT:    [[ARRAYIDX46:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP23]]
; GENERIC-NEXT:    [[TMP24:%.*]] = load i16, i16* [[ARRAYIDX46]], align 2
; GENERIC-NEXT:    [[CONV47:%.*]] = zext i16 [[TMP24]] to i32
; GENERIC-NEXT:    [[ADD48:%.*]] = add nsw i32 [[ADD39]], [[CONV47]]
; GENERIC-NEXT:    [[TMP25:%.*]] = extractelement <8 x i32> [[TMP6]], i64 6
; GENERIC-NEXT:    [[TMP26:%.*]] = sext i32 [[TMP25]] to i64
; GENERIC-NEXT:    [[ARRAYIDX55:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP26]]
; GENERIC-NEXT:    [[TMP27:%.*]] = load i16, i16* [[ARRAYIDX55]], align 2
; GENERIC-NEXT:    [[CONV56:%.*]] = zext i16 [[TMP27]] to i32
; GENERIC-NEXT:    [[ADD57:%.*]] = add nsw i32 [[ADD48]], [[CONV56]]
; GENERIC-NEXT:    [[INCDEC_PTR58]] = getelementptr inbounds i16, i16* [[A_ADDR_0101]], i64 8
; GENERIC-NEXT:    [[TMP28:%.*]] = extractelement <8 x i32> [[TMP6]], i64 7
; GENERIC-NEXT:    [[TMP29:%.*]] = sext i32 [[TMP28]] to i64
; GENERIC-NEXT:    [[ARRAYIDX64:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP29]]
; GENERIC-NEXT:    [[TMP30:%.*]] = load i16, i16* [[ARRAYIDX64]], align 2
; GENERIC-NEXT:    [[CONV65:%.*]] = zext i16 [[TMP30]] to i32
; GENERIC-NEXT:    [[ADD66]] = add nsw i32 [[ADD57]], [[CONV65]]
; GENERIC-NEXT:    [[INC]] = add nuw nsw i32 [[I_0103]], 1
; GENERIC-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; GENERIC-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
; KRYO-LABEL: @gather_reduce_8x16_i32(
; KRYO-NEXT:  entry:
; KRYO-NEXT:    [[CMP_99:%.*]] = icmp sgt i32 [[N:%.*]], 0
; KRYO-NEXT:    br i1 [[CMP_99]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; KRYO:       for.body.preheader:
; KRYO-NEXT:    br label [[FOR_BODY:%.*]]
; KRYO:       for.cond.cleanup.loopexit:
; KRYO-NEXT:    br label [[FOR_COND_CLEANUP]]
; KRYO:       for.cond.cleanup:
; KRYO-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD66:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; KRYO-NEXT:    ret i32 [[SUM_0_LCSSA]]
; KRYO:       for.body:
; KRYO-NEXT:    [[I_0103:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[SUM_0102:%.*]] = phi i32 [ [[ADD66]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[A_ADDR_0101:%.*]] = phi i16* [ [[INCDEC_PTR58:%.*]], [[FOR_BODY]] ], [ [[A:%.*]], [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[TMP0:%.*]] = bitcast i16* [[A_ADDR_0101]] to <8 x i16>*
; KRYO-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* [[TMP0]], align 2
; KRYO-NEXT:    [[TMP2:%.*]] = zext <8 x i16> [[TMP1]] to <8 x i32>
; KRYO-NEXT:    [[TMP3:%.*]] = bitcast i16* [[B:%.*]] to <8 x i16>*
; KRYO-NEXT:    [[TMP4:%.*]] = load <8 x i16>, <8 x i16>* [[TMP3]], align 2
; KRYO-NEXT:    [[TMP5:%.*]] = zext <8 x i16> [[TMP4]] to <8 x i32>
; KRYO-NEXT:    [[TMP6:%.*]] = sub nsw <8 x i32> [[TMP2]], [[TMP5]]
; KRYO-NEXT:    [[TMP7:%.*]] = extractelement <8 x i32> [[TMP6]], i64 0
; KRYO-NEXT:    [[TMP8:%.*]] = sext i32 [[TMP7]] to i64
; KRYO-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[G:%.*]], i64 [[TMP8]]
; KRYO-NEXT:    [[TMP9:%.*]] = load i16, i16* [[ARRAYIDX]], align 2
; KRYO-NEXT:    [[CONV3:%.*]] = zext i16 [[TMP9]] to i32
; KRYO-NEXT:    [[ADD:%.*]] = add nsw i32 [[SUM_0102]], [[CONV3]]
; KRYO-NEXT:    [[TMP10:%.*]] = extractelement <8 x i32> [[TMP6]], i64 1
; KRYO-NEXT:    [[TMP11:%.*]] = sext i32 [[TMP10]] to i64
; KRYO-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP11]]
; KRYO-NEXT:    [[TMP12:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; KRYO-NEXT:    [[CONV11:%.*]] = zext i16 [[TMP12]] to i32
; KRYO-NEXT:    [[ADD12:%.*]] = add nsw i32 [[ADD]], [[CONV11]]
; KRYO-NEXT:    [[TMP13:%.*]] = extractelement <8 x i32> [[TMP6]], i64 2
; KRYO-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; KRYO-NEXT:    [[ARRAYIDX19:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP14]]
; KRYO-NEXT:    [[TMP15:%.*]] = load i16, i16* [[ARRAYIDX19]], align 2
; KRYO-NEXT:    [[CONV20:%.*]] = zext i16 [[TMP15]] to i32
; KRYO-NEXT:    [[ADD21:%.*]] = add nsw i32 [[ADD12]], [[CONV20]]
; KRYO-NEXT:    [[TMP16:%.*]] = extractelement <8 x i32> [[TMP6]], i64 3
; KRYO-NEXT:    [[TMP17:%.*]] = sext i32 [[TMP16]] to i64
; KRYO-NEXT:    [[ARRAYIDX28:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP17]]
; KRYO-NEXT:    [[TMP18:%.*]] = load i16, i16* [[ARRAYIDX28]], align 2
; KRYO-NEXT:    [[CONV29:%.*]] = zext i16 [[TMP18]] to i32
; KRYO-NEXT:    [[ADD30:%.*]] = add nsw i32 [[ADD21]], [[CONV29]]
; KRYO-NEXT:    [[TMP19:%.*]] = extractelement <8 x i32> [[TMP6]], i64 4
; KRYO-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; KRYO-NEXT:    [[ARRAYIDX37:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP20]]
; KRYO-NEXT:    [[TMP21:%.*]] = load i16, i16* [[ARRAYIDX37]], align 2
; KRYO-NEXT:    [[CONV38:%.*]] = zext i16 [[TMP21]] to i32
; KRYO-NEXT:    [[ADD39:%.*]] = add nsw i32 [[ADD30]], [[CONV38]]
; KRYO-NEXT:    [[TMP22:%.*]] = extractelement <8 x i32> [[TMP6]], i64 5
; KRYO-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; KRYO-NEXT:    [[ARRAYIDX46:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP23]]
; KRYO-NEXT:    [[TMP24:%.*]] = load i16, i16* [[ARRAYIDX46]], align 2
; KRYO-NEXT:    [[CONV47:%.*]] = zext i16 [[TMP24]] to i32
; KRYO-NEXT:    [[ADD48:%.*]] = add nsw i32 [[ADD39]], [[CONV47]]
; KRYO-NEXT:    [[TMP25:%.*]] = extractelement <8 x i32> [[TMP6]], i64 6
; KRYO-NEXT:    [[TMP26:%.*]] = sext i32 [[TMP25]] to i64
; KRYO-NEXT:    [[ARRAYIDX55:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP26]]
; KRYO-NEXT:    [[TMP27:%.*]] = load i16, i16* [[ARRAYIDX55]], align 2
; KRYO-NEXT:    [[CONV56:%.*]] = zext i16 [[TMP27]] to i32
; KRYO-NEXT:    [[ADD57:%.*]] = add nsw i32 [[ADD48]], [[CONV56]]
; KRYO-NEXT:    [[INCDEC_PTR58]] = getelementptr inbounds i16, i16* [[A_ADDR_0101]], i64 8
; KRYO-NEXT:    [[TMP28:%.*]] = extractelement <8 x i32> [[TMP6]], i64 7
; KRYO-NEXT:    [[TMP29:%.*]] = sext i32 [[TMP28]] to i64
; KRYO-NEXT:    [[ARRAYIDX64:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP29]]
; KRYO-NEXT:    [[TMP30:%.*]] = load i16, i16* [[ARRAYIDX64]], align 2
; KRYO-NEXT:    [[CONV65:%.*]] = zext i16 [[TMP30]] to i32
; KRYO-NEXT:    [[ADD66]] = add nsw i32 [[ADD57]], [[CONV65]]
; KRYO-NEXT:    [[INC]] = add nuw nsw i32 [[I_0103]], 1
; KRYO-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; KRYO-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp.99 = icmp sgt i32 %n, 0
  br i1 %cmp.99, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add66, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %i.0103 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %sum.0102 = phi i32 [ %add66, %for.body ], [ 0, %for.body.preheader ]
  %a.addr.0101 = phi i16* [ %incdec.ptr58, %for.body ], [ %a, %for.body.preheader ]
  %incdec.ptr = getelementptr inbounds i16, i16* %a.addr.0101, i64 1
  %0 = load i16, i16* %a.addr.0101, align 2
  %conv = zext i16 %0 to i32
  %incdec.ptr1 = getelementptr inbounds i16, i16* %b, i64 1
  %1 = load i16, i16* %b, align 2
  %conv2 = zext i16 %1 to i32
  %sub = sub nsw i32 %conv, %conv2
  %arrayidx = getelementptr inbounds i16, i16* %g, i32 %sub
  %2 = load i16, i16* %arrayidx, align 2
  %conv3 = zext i16 %2 to i32
  %add = add nsw i32 %conv3, %sum.0102
  %incdec.ptr4 = getelementptr inbounds i16, i16* %a.addr.0101, i64 2
  %3 = load i16, i16* %incdec.ptr, align 2
  %conv5 = zext i16 %3 to i32
  %incdec.ptr6 = getelementptr inbounds i16, i16* %b, i64 2
  %4 = load i16, i16* %incdec.ptr1, align 2
  %conv7 = zext i16 %4 to i32
  %sub8 = sub nsw i32 %conv5, %conv7
  %arrayidx10 = getelementptr inbounds i16, i16* %g, i32 %sub8
  %5 = load i16, i16* %arrayidx10, align 2
  %conv11 = zext i16 %5 to i32
  %add12 = add nsw i32 %add, %conv11
  %incdec.ptr13 = getelementptr inbounds i16, i16* %a.addr.0101, i64 3
  %6 = load i16, i16* %incdec.ptr4, align 2
  %conv14 = zext i16 %6 to i32
  %incdec.ptr15 = getelementptr inbounds i16, i16* %b, i64 3
  %7 = load i16, i16* %incdec.ptr6, align 2
  %conv16 = zext i16 %7 to i32
  %sub17 = sub nsw i32 %conv14, %conv16
  %arrayidx19 = getelementptr inbounds i16, i16* %g, i32 %sub17
  %8 = load i16, i16* %arrayidx19, align 2
  %conv20 = zext i16 %8 to i32
  %add21 = add nsw i32 %add12, %conv20
  %incdec.ptr22 = getelementptr inbounds i16, i16* %a.addr.0101, i64 4
  %9 = load i16, i16* %incdec.ptr13, align 2
  %conv23 = zext i16 %9 to i32
  %incdec.ptr24 = getelementptr inbounds i16, i16* %b, i64 4
  %10 = load i16, i16* %incdec.ptr15, align 2
  %conv25 = zext i16 %10 to i32
  %sub26 = sub nsw i32 %conv23, %conv25
  %arrayidx28 = getelementptr inbounds i16, i16* %g, i32 %sub26
  %11 = load i16, i16* %arrayidx28, align 2
  %conv29 = zext i16 %11 to i32
  %add30 = add nsw i32 %add21, %conv29
  %incdec.ptr31 = getelementptr inbounds i16, i16* %a.addr.0101, i64 5
  %12 = load i16, i16* %incdec.ptr22, align 2
  %conv32 = zext i16 %12 to i32
  %incdec.ptr33 = getelementptr inbounds i16, i16* %b, i64 5
  %13 = load i16, i16* %incdec.ptr24, align 2
  %conv34 = zext i16 %13 to i32
  %sub35 = sub nsw i32 %conv32, %conv34
  %arrayidx37 = getelementptr inbounds i16, i16* %g, i32 %sub35
  %14 = load i16, i16* %arrayidx37, align 2
  %conv38 = zext i16 %14 to i32
  %add39 = add nsw i32 %add30, %conv38
  %incdec.ptr40 = getelementptr inbounds i16, i16* %a.addr.0101, i64 6
  %15 = load i16, i16* %incdec.ptr31, align 2
  %conv41 = zext i16 %15 to i32
  %incdec.ptr42 = getelementptr inbounds i16, i16* %b, i64 6
  %16 = load i16, i16* %incdec.ptr33, align 2
  %conv43 = zext i16 %16 to i32
  %sub44 = sub nsw i32 %conv41, %conv43
  %arrayidx46 = getelementptr inbounds i16, i16* %g, i32 %sub44
  %17 = load i16, i16* %arrayidx46, align 2
  %conv47 = zext i16 %17 to i32
  %add48 = add nsw i32 %add39, %conv47
  %incdec.ptr49 = getelementptr inbounds i16, i16* %a.addr.0101, i64 7
  %18 = load i16, i16* %incdec.ptr40, align 2
  %conv50 = zext i16 %18 to i32
  %incdec.ptr51 = getelementptr inbounds i16, i16* %b, i64 7
  %19 = load i16, i16* %incdec.ptr42, align 2
  %conv52 = zext i16 %19 to i32
  %sub53 = sub nsw i32 %conv50, %conv52
  %arrayidx55 = getelementptr inbounds i16, i16* %g, i32 %sub53
  %20 = load i16, i16* %arrayidx55, align 2
  %conv56 = zext i16 %20 to i32
  %add57 = add nsw i32 %add48, %conv56
  %incdec.ptr58 = getelementptr inbounds i16, i16* %a.addr.0101, i64 8
  %21 = load i16, i16* %incdec.ptr49, align 2
  %conv59 = zext i16 %21 to i32
  %22 = load i16, i16* %incdec.ptr51, align 2
  %conv61 = zext i16 %22 to i32
  %sub62 = sub nsw i32 %conv59, %conv61
  %arrayidx64 = getelementptr inbounds i16, i16* %g, i32 %sub62
  %23 = load i16, i16* %arrayidx64, align 2
  %conv65 = zext i16 %23 to i32
  %add66 = add nsw i32 %add57, %conv65
  %inc = add nuw nsw i32 %i.0103, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}

define i32 @gather_reduce_8x16_i64(i16* nocapture readonly %a, i16* nocapture readonly %b, i16* nocapture readonly %g, i32 %n) {
; GENERIC-LABEL: @gather_reduce_8x16_i64(
; GENERIC-NEXT:  entry:
; GENERIC-NEXT:    [[CMP_99:%.*]] = icmp sgt i32 [[N:%.*]], 0
; GENERIC-NEXT:    br i1 [[CMP_99]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; GENERIC:       for.body.preheader:
; GENERIC-NEXT:    br label [[FOR_BODY:%.*]]
; GENERIC:       for.cond.cleanup.loopexit:
; GENERIC-NEXT:    br label [[FOR_COND_CLEANUP]]
; GENERIC:       for.cond.cleanup:
; GENERIC-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD66:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; GENERIC-NEXT:    ret i32 [[SUM_0_LCSSA]]
; GENERIC:       for.body:
; GENERIC-NEXT:    [[I_0103:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[SUM_0102:%.*]] = phi i32 [ [[ADD66]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[A_ADDR_0101:%.*]] = phi i16* [ [[INCDEC_PTR58:%.*]], [[FOR_BODY]] ], [ [[A:%.*]], [[FOR_BODY_PREHEADER]] ]
; GENERIC-NEXT:    [[TMP0:%.*]] = bitcast i16* [[A_ADDR_0101]] to <8 x i16>*
; GENERIC-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* [[TMP0]], align 2
; GENERIC-NEXT:    [[TMP2:%.*]] = zext <8 x i16> [[TMP1]] to <8 x i32>
; GENERIC-NEXT:    [[TMP3:%.*]] = bitcast i16* [[B:%.*]] to <8 x i16>*
; GENERIC-NEXT:    [[TMP4:%.*]] = load <8 x i16>, <8 x i16>* [[TMP3]], align 2
; GENERIC-NEXT:    [[TMP5:%.*]] = zext <8 x i16> [[TMP4]] to <8 x i32>
; GENERIC-NEXT:    [[TMP6:%.*]] = sub nsw <8 x i32> [[TMP2]], [[TMP5]]
; GENERIC-NEXT:    [[TMP7:%.*]] = extractelement <8 x i32> [[TMP6]], i64 0
; GENERIC-NEXT:    [[TMP8:%.*]] = sext i32 [[TMP7]] to i64
; GENERIC-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[G:%.*]], i64 [[TMP8]]
; GENERIC-NEXT:    [[TMP9:%.*]] = load i16, i16* [[ARRAYIDX]], align 2
; GENERIC-NEXT:    [[CONV3:%.*]] = zext i16 [[TMP9]] to i32
; GENERIC-NEXT:    [[ADD:%.*]] = add nsw i32 [[SUM_0102]], [[CONV3]]
; GENERIC-NEXT:    [[TMP10:%.*]] = extractelement <8 x i32> [[TMP6]], i64 1
; GENERIC-NEXT:    [[TMP11:%.*]] = sext i32 [[TMP10]] to i64
; GENERIC-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP11]]
; GENERIC-NEXT:    [[TMP12:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; GENERIC-NEXT:    [[CONV11:%.*]] = zext i16 [[TMP12]] to i32
; GENERIC-NEXT:    [[ADD12:%.*]] = add nsw i32 [[ADD]], [[CONV11]]
; GENERIC-NEXT:    [[TMP13:%.*]] = extractelement <8 x i32> [[TMP6]], i64 2
; GENERIC-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; GENERIC-NEXT:    [[ARRAYIDX19:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP14]]
; GENERIC-NEXT:    [[TMP15:%.*]] = load i16, i16* [[ARRAYIDX19]], align 2
; GENERIC-NEXT:    [[CONV20:%.*]] = zext i16 [[TMP15]] to i32
; GENERIC-NEXT:    [[ADD21:%.*]] = add nsw i32 [[ADD12]], [[CONV20]]
; GENERIC-NEXT:    [[TMP16:%.*]] = extractelement <8 x i32> [[TMP6]], i64 3
; GENERIC-NEXT:    [[TMP17:%.*]] = sext i32 [[TMP16]] to i64
; GENERIC-NEXT:    [[ARRAYIDX28:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP17]]
; GENERIC-NEXT:    [[TMP18:%.*]] = load i16, i16* [[ARRAYIDX28]], align 2
; GENERIC-NEXT:    [[CONV29:%.*]] = zext i16 [[TMP18]] to i32
; GENERIC-NEXT:    [[ADD30:%.*]] = add nsw i32 [[ADD21]], [[CONV29]]
; GENERIC-NEXT:    [[TMP19:%.*]] = extractelement <8 x i32> [[TMP6]], i64 4
; GENERIC-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; GENERIC-NEXT:    [[ARRAYIDX37:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP20]]
; GENERIC-NEXT:    [[TMP21:%.*]] = load i16, i16* [[ARRAYIDX37]], align 2
; GENERIC-NEXT:    [[CONV38:%.*]] = zext i16 [[TMP21]] to i32
; GENERIC-NEXT:    [[ADD39:%.*]] = add nsw i32 [[ADD30]], [[CONV38]]
; GENERIC-NEXT:    [[TMP22:%.*]] = extractelement <8 x i32> [[TMP6]], i64 5
; GENERIC-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; GENERIC-NEXT:    [[ARRAYIDX46:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP23]]
; GENERIC-NEXT:    [[TMP24:%.*]] = load i16, i16* [[ARRAYIDX46]], align 2
; GENERIC-NEXT:    [[CONV47:%.*]] = zext i16 [[TMP24]] to i32
; GENERIC-NEXT:    [[ADD48:%.*]] = add nsw i32 [[ADD39]], [[CONV47]]
; GENERIC-NEXT:    [[TMP25:%.*]] = extractelement <8 x i32> [[TMP6]], i64 6
; GENERIC-NEXT:    [[TMP26:%.*]] = sext i32 [[TMP25]] to i64
; GENERIC-NEXT:    [[ARRAYIDX55:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP26]]
; GENERIC-NEXT:    [[TMP27:%.*]] = load i16, i16* [[ARRAYIDX55]], align 2
; GENERIC-NEXT:    [[CONV56:%.*]] = zext i16 [[TMP27]] to i32
; GENERIC-NEXT:    [[ADD57:%.*]] = add nsw i32 [[ADD48]], [[CONV56]]
; GENERIC-NEXT:    [[INCDEC_PTR58]] = getelementptr inbounds i16, i16* [[A_ADDR_0101]], i64 8
; GENERIC-NEXT:    [[TMP28:%.*]] = extractelement <8 x i32> [[TMP6]], i64 7
; GENERIC-NEXT:    [[TMP29:%.*]] = sext i32 [[TMP28]] to i64
; GENERIC-NEXT:    [[ARRAYIDX64:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP29]]
; GENERIC-NEXT:    [[TMP30:%.*]] = load i16, i16* [[ARRAYIDX64]], align 2
; GENERIC-NEXT:    [[CONV65:%.*]] = zext i16 [[TMP30]] to i32
; GENERIC-NEXT:    [[ADD66]] = add nsw i32 [[ADD57]], [[CONV65]]
; GENERIC-NEXT:    [[INC]] = add nuw nsw i32 [[I_0103]], 1
; GENERIC-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; GENERIC-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
; KRYO-LABEL: @gather_reduce_8x16_i64(
; KRYO-NEXT:  entry:
; KRYO-NEXT:    [[CMP_99:%.*]] = icmp sgt i32 [[N:%.*]], 0
; KRYO-NEXT:    br i1 [[CMP_99]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_COND_CLEANUP:%.*]]
; KRYO:       for.body.preheader:
; KRYO-NEXT:    br label [[FOR_BODY:%.*]]
; KRYO:       for.cond.cleanup.loopexit:
; KRYO-NEXT:    br label [[FOR_COND_CLEANUP]]
; KRYO:       for.cond.cleanup:
; KRYO-NEXT:    [[SUM_0_LCSSA:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD66:%.*]], [[FOR_COND_CLEANUP_LOOPEXIT:%.*]] ]
; KRYO-NEXT:    ret i32 [[SUM_0_LCSSA]]
; KRYO:       for.body:
; KRYO-NEXT:    [[I_0103:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[SUM_0102:%.*]] = phi i32 [ [[ADD66]], [[FOR_BODY]] ], [ 0, [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[A_ADDR_0101:%.*]] = phi i16* [ [[INCDEC_PTR58:%.*]], [[FOR_BODY]] ], [ [[A:%.*]], [[FOR_BODY_PREHEADER]] ]
; KRYO-NEXT:    [[TMP0:%.*]] = bitcast i16* [[A_ADDR_0101]] to <8 x i16>*
; KRYO-NEXT:    [[TMP1:%.*]] = load <8 x i16>, <8 x i16>* [[TMP0]], align 2
; KRYO-NEXT:    [[TMP2:%.*]] = zext <8 x i16> [[TMP1]] to <8 x i32>
; KRYO-NEXT:    [[TMP3:%.*]] = bitcast i16* [[B:%.*]] to <8 x i16>*
; KRYO-NEXT:    [[TMP4:%.*]] = load <8 x i16>, <8 x i16>* [[TMP3]], align 2
; KRYO-NEXT:    [[TMP5:%.*]] = zext <8 x i16> [[TMP4]] to <8 x i32>
; KRYO-NEXT:    [[TMP6:%.*]] = sub nsw <8 x i32> [[TMP2]], [[TMP5]]
; KRYO-NEXT:    [[TMP7:%.*]] = extractelement <8 x i32> [[TMP6]], i64 0
; KRYO-NEXT:    [[TMP8:%.*]] = sext i32 [[TMP7]] to i64
; KRYO-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i16, i16* [[G:%.*]], i64 [[TMP8]]
; KRYO-NEXT:    [[TMP9:%.*]] = load i16, i16* [[ARRAYIDX]], align 2
; KRYO-NEXT:    [[CONV3:%.*]] = zext i16 [[TMP9]] to i32
; KRYO-NEXT:    [[ADD:%.*]] = add nsw i32 [[SUM_0102]], [[CONV3]]
; KRYO-NEXT:    [[TMP10:%.*]] = extractelement <8 x i32> [[TMP6]], i64 1
; KRYO-NEXT:    [[TMP11:%.*]] = sext i32 [[TMP10]] to i64
; KRYO-NEXT:    [[ARRAYIDX10:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP11]]
; KRYO-NEXT:    [[TMP12:%.*]] = load i16, i16* [[ARRAYIDX10]], align 2
; KRYO-NEXT:    [[CONV11:%.*]] = zext i16 [[TMP12]] to i32
; KRYO-NEXT:    [[ADD12:%.*]] = add nsw i32 [[ADD]], [[CONV11]]
; KRYO-NEXT:    [[TMP13:%.*]] = extractelement <8 x i32> [[TMP6]], i64 2
; KRYO-NEXT:    [[TMP14:%.*]] = sext i32 [[TMP13]] to i64
; KRYO-NEXT:    [[ARRAYIDX19:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP14]]
; KRYO-NEXT:    [[TMP15:%.*]] = load i16, i16* [[ARRAYIDX19]], align 2
; KRYO-NEXT:    [[CONV20:%.*]] = zext i16 [[TMP15]] to i32
; KRYO-NEXT:    [[ADD21:%.*]] = add nsw i32 [[ADD12]], [[CONV20]]
; KRYO-NEXT:    [[TMP16:%.*]] = extractelement <8 x i32> [[TMP6]], i64 3
; KRYO-NEXT:    [[TMP17:%.*]] = sext i32 [[TMP16]] to i64
; KRYO-NEXT:    [[ARRAYIDX28:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP17]]
; KRYO-NEXT:    [[TMP18:%.*]] = load i16, i16* [[ARRAYIDX28]], align 2
; KRYO-NEXT:    [[CONV29:%.*]] = zext i16 [[TMP18]] to i32
; KRYO-NEXT:    [[ADD30:%.*]] = add nsw i32 [[ADD21]], [[CONV29]]
; KRYO-NEXT:    [[TMP19:%.*]] = extractelement <8 x i32> [[TMP6]], i64 4
; KRYO-NEXT:    [[TMP20:%.*]] = sext i32 [[TMP19]] to i64
; KRYO-NEXT:    [[ARRAYIDX37:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP20]]
; KRYO-NEXT:    [[TMP21:%.*]] = load i16, i16* [[ARRAYIDX37]], align 2
; KRYO-NEXT:    [[CONV38:%.*]] = zext i16 [[TMP21]] to i32
; KRYO-NEXT:    [[ADD39:%.*]] = add nsw i32 [[ADD30]], [[CONV38]]
; KRYO-NEXT:    [[TMP22:%.*]] = extractelement <8 x i32> [[TMP6]], i64 5
; KRYO-NEXT:    [[TMP23:%.*]] = sext i32 [[TMP22]] to i64
; KRYO-NEXT:    [[ARRAYIDX46:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP23]]
; KRYO-NEXT:    [[TMP24:%.*]] = load i16, i16* [[ARRAYIDX46]], align 2
; KRYO-NEXT:    [[CONV47:%.*]] = zext i16 [[TMP24]] to i32
; KRYO-NEXT:    [[ADD48:%.*]] = add nsw i32 [[ADD39]], [[CONV47]]
; KRYO-NEXT:    [[TMP25:%.*]] = extractelement <8 x i32> [[TMP6]], i64 6
; KRYO-NEXT:    [[TMP26:%.*]] = sext i32 [[TMP25]] to i64
; KRYO-NEXT:    [[ARRAYIDX55:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP26]]
; KRYO-NEXT:    [[TMP27:%.*]] = load i16, i16* [[ARRAYIDX55]], align 2
; KRYO-NEXT:    [[CONV56:%.*]] = zext i16 [[TMP27]] to i32
; KRYO-NEXT:    [[ADD57:%.*]] = add nsw i32 [[ADD48]], [[CONV56]]
; KRYO-NEXT:    [[INCDEC_PTR58]] = getelementptr inbounds i16, i16* [[A_ADDR_0101]], i64 8
; KRYO-NEXT:    [[TMP28:%.*]] = extractelement <8 x i32> [[TMP6]], i64 7
; KRYO-NEXT:    [[TMP29:%.*]] = sext i32 [[TMP28]] to i64
; KRYO-NEXT:    [[ARRAYIDX64:%.*]] = getelementptr inbounds i16, i16* [[G]], i64 [[TMP29]]
; KRYO-NEXT:    [[TMP30:%.*]] = load i16, i16* [[ARRAYIDX64]], align 2
; KRYO-NEXT:    [[CONV65:%.*]] = zext i16 [[TMP30]] to i32
; KRYO-NEXT:    [[ADD66]] = add nsw i32 [[ADD57]], [[CONV65]]
; KRYO-NEXT:    [[INC]] = add nuw nsw i32 [[I_0103]], 1
; KRYO-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], [[N]]
; KRYO-NEXT:    br i1 [[EXITCOND]], label [[FOR_COND_CLEANUP_LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  %cmp.99 = icmp sgt i32 %n, 0
  br i1 %cmp.99, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:
  br label %for.body

for.cond.cleanup.loopexit:
  br label %for.cond.cleanup

for.cond.cleanup:
  %sum.0.lcssa = phi i32 [ 0, %entry ], [ %add66, %for.cond.cleanup.loopexit ]
  ret i32 %sum.0.lcssa

for.body:
  %i.0103 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %sum.0102 = phi i32 [ %add66, %for.body ], [ 0, %for.body.preheader ]
  %a.addr.0101 = phi i16* [ %incdec.ptr58, %for.body ], [ %a, %for.body.preheader ]
  %incdec.ptr = getelementptr inbounds i16, i16* %a.addr.0101, i64 1
  %0 = load i16, i16* %a.addr.0101, align 2
  %conv = zext i16 %0 to i64
  %incdec.ptr1 = getelementptr inbounds i16, i16* %b, i64 1
  %1 = load i16, i16* %b, align 2
  %conv2 = zext i16 %1 to i64
  %sub = sub nsw i64 %conv, %conv2
  %arrayidx = getelementptr inbounds i16, i16* %g, i64 %sub
  %2 = load i16, i16* %arrayidx, align 2
  %conv3 = zext i16 %2 to i32
  %add = add nsw i32 %conv3, %sum.0102
  %incdec.ptr4 = getelementptr inbounds i16, i16* %a.addr.0101, i64 2
  %3 = load i16, i16* %incdec.ptr, align 2
  %conv5 = zext i16 %3 to i64
  %incdec.ptr6 = getelementptr inbounds i16, i16* %b, i64 2
  %4 = load i16, i16* %incdec.ptr1, align 2
  %conv7 = zext i16 %4 to i64
  %sub8 = sub nsw i64 %conv5, %conv7
  %arrayidx10 = getelementptr inbounds i16, i16* %g, i64 %sub8
  %5 = load i16, i16* %arrayidx10, align 2
  %conv11 = zext i16 %5 to i32
  %add12 = add nsw i32 %add, %conv11
  %incdec.ptr13 = getelementptr inbounds i16, i16* %a.addr.0101, i64 3
  %6 = load i16, i16* %incdec.ptr4, align 2
  %conv14 = zext i16 %6 to i64
  %incdec.ptr15 = getelementptr inbounds i16, i16* %b, i64 3
  %7 = load i16, i16* %incdec.ptr6, align 2
  %conv16 = zext i16 %7 to i64
  %sub17 = sub nsw i64 %conv14, %conv16
  %arrayidx19 = getelementptr inbounds i16, i16* %g, i64 %sub17
  %8 = load i16, i16* %arrayidx19, align 2
  %conv20 = zext i16 %8 to i32
  %add21 = add nsw i32 %add12, %conv20
  %incdec.ptr22 = getelementptr inbounds i16, i16* %a.addr.0101, i64 4
  %9 = load i16, i16* %incdec.ptr13, align 2
  %conv23 = zext i16 %9 to i64
  %incdec.ptr24 = getelementptr inbounds i16, i16* %b, i64 4
  %10 = load i16, i16* %incdec.ptr15, align 2
  %conv25 = zext i16 %10 to i64
  %sub26 = sub nsw i64 %conv23, %conv25
  %arrayidx28 = getelementptr inbounds i16, i16* %g, i64 %sub26
  %11 = load i16, i16* %arrayidx28, align 2
  %conv29 = zext i16 %11 to i32
  %add30 = add nsw i32 %add21, %conv29
  %incdec.ptr31 = getelementptr inbounds i16, i16* %a.addr.0101, i64 5
  %12 = load i16, i16* %incdec.ptr22, align 2
  %conv32 = zext i16 %12 to i64
  %incdec.ptr33 = getelementptr inbounds i16, i16* %b, i64 5
  %13 = load i16, i16* %incdec.ptr24, align 2
  %conv34 = zext i16 %13 to i64
  %sub35 = sub nsw i64 %conv32, %conv34
  %arrayidx37 = getelementptr inbounds i16, i16* %g, i64 %sub35
  %14 = load i16, i16* %arrayidx37, align 2
  %conv38 = zext i16 %14 to i32
  %add39 = add nsw i32 %add30, %conv38
  %incdec.ptr40 = getelementptr inbounds i16, i16* %a.addr.0101, i64 6
  %15 = load i16, i16* %incdec.ptr31, align 2
  %conv41 = zext i16 %15 to i64
  %incdec.ptr42 = getelementptr inbounds i16, i16* %b, i64 6
  %16 = load i16, i16* %incdec.ptr33, align 2
  %conv43 = zext i16 %16 to i64
  %sub44 = sub nsw i64 %conv41, %conv43
  %arrayidx46 = getelementptr inbounds i16, i16* %g, i64 %sub44
  %17 = load i16, i16* %arrayidx46, align 2
  %conv47 = zext i16 %17 to i32
  %add48 = add nsw i32 %add39, %conv47
  %incdec.ptr49 = getelementptr inbounds i16, i16* %a.addr.0101, i64 7
  %18 = load i16, i16* %incdec.ptr40, align 2
  %conv50 = zext i16 %18 to i64
  %incdec.ptr51 = getelementptr inbounds i16, i16* %b, i64 7
  %19 = load i16, i16* %incdec.ptr42, align 2
  %conv52 = zext i16 %19 to i64
  %sub53 = sub nsw i64 %conv50, %conv52
  %arrayidx55 = getelementptr inbounds i16, i16* %g, i64 %sub53
  %20 = load i16, i16* %arrayidx55, align 2
  %conv56 = zext i16 %20 to i32
  %add57 = add nsw i32 %add48, %conv56
  %incdec.ptr58 = getelementptr inbounds i16, i16* %a.addr.0101, i64 8
  %21 = load i16, i16* %incdec.ptr49, align 2
  %conv59 = zext i16 %21 to i64
  %22 = load i16, i16* %incdec.ptr51, align 2
  %conv61 = zext i16 %22 to i64
  %sub62 = sub nsw i64 %conv59, %conv61
  %arrayidx64 = getelementptr inbounds i16, i16* %g, i64 %sub62
  %23 = load i16, i16* %arrayidx64, align 2
  %conv65 = zext i16 %23 to i32
  %add66 = add nsw i32 %add57, %conv65
  %inc = add nuw nsw i32 %i.0103, 1
  %exitcond = icmp eq i32 %inc, %n
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body
}
