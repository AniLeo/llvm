; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=arm -type-promotion -verify -disable-type-promotion=false -S %s -o - | FileCheck %s

; Check that the arguments are extended but then nothing else is.
; This also ensures that the pass can handle loops.
define void @phi_feeding_phi_args(i8 %a, i8 %b) {
; CHECK-LABEL: @phi_feeding_phi_args(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ugt i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[PREHEADER:%.*]], label [[EMPTY:%.*]]
; CHECK:       empty:
; CHECK-NEXT:    br label [[PREHEADER]]
; CHECK:       preheader:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i32 [ [[TMP0]], [[ENTRY:%.*]] ], [ [[TMP1]], [[EMPTY]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ [[TMP3]], [[PREHEADER]] ], [ [[INC2:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[VAL]], 254
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[INC:%.*]] = sub nuw i32 [[VAL]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.else:
; CHECK-NEXT:    [[INC1:%.*]] = shl nuw i32 [[VAL]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC2]] = phi i32 [ [[INC]], [[IF_THEN]] ], [ [[INC1]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[INC2]], 255
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %0 = icmp ugt i8 %a, %b
  br i1 %0, label %preheader, label %empty

empty:
  br label %preheader

preheader:
  %1 = phi i8 [ %a, %entry ], [ %b, %empty ]
  br label %loop

loop:
  %val = phi i8 [ %1, %preheader ], [ %inc2, %if.end ]
  %cmp = icmp ult i8 %val, 254
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %inc = sub nuw i8 %val, 2
  br label %if.end

if.else:
  %inc1 = shl nuw i8 %val, 1
  br label %if.end

if.end:
  %inc2 = phi i8 [ %inc, %if.then], [ %inc1, %if.else ]
  %cmp1 = icmp eq i8 %inc2, 255
  br i1 %cmp1, label %exit, label %loop

exit:
  ret void
}

; Same as above, but as the args are zeroext, we shouldn't see any uxts.
define void @phi_feeding_phi_zeroext_args(i8 zeroext %a, i8 zeroext %b) {
; CHECK-LABEL: @phi_feeding_phi_zeroext_args(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = zext i8 [[B:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ugt i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[PREHEADER:%.*]], label [[EMPTY:%.*]]
; CHECK:       empty:
; CHECK-NEXT:    br label [[PREHEADER]]
; CHECK:       preheader:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i32 [ [[TMP0]], [[ENTRY:%.*]] ], [ [[TMP1]], [[EMPTY]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ [[TMP3]], [[PREHEADER]] ], [ [[INC2:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[VAL]], 254
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[INC:%.*]] = sub nuw i32 [[VAL]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.else:
; CHECK-NEXT:    [[INC1:%.*]] = shl nuw i32 [[VAL]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC2]] = phi i32 [ [[INC]], [[IF_THEN]] ], [ [[INC1]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[INC2]], 255
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %0 = icmp ugt i8 %a, %b
  br i1 %0, label %preheader, label %empty

empty:
  br label %preheader

preheader:
  %1 = phi i8 [ %a, %entry ], [ %b, %empty ]
  br label %loop

loop:
  %val = phi i8 [ %1, %preheader ], [ %inc2, %if.end ]
  %cmp = icmp ult i8 %val, 254
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %inc = sub nuw i8 %val, 2
  br label %if.end

if.else:
  %inc1 = shl nuw i8 %val, 1
  br label %if.end

if.end:
  %inc2 = phi i8 [ %inc, %if.then], [ %inc1, %if.else ]
  %cmp1 = icmp eq i8 %inc2, 255
  br i1 %cmp1, label %exit, label %loop

exit:
  ret void
}

; Just check that phis also work with i16s.
define void @phi_i16() {
; CHECK-LABEL: @phi_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC2:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[VAL]], 128
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[INC:%.*]] = add nuw i32 [[VAL]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.else:
; CHECK-NEXT:    [[INC1:%.*]] = add nuw i32 [[VAL]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC2]] = phi i32 [ [[INC]], [[IF_THEN]] ], [ [[INC1]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[INC2]], 253
; CHECK-NEXT:    br i1 [[CMP1]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %val = phi i16 [ 0, %entry ], [ %inc2, %if.end ]
  %cmp = icmp ult i16 %val, 128
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %inc = add nuw i16 %val, 2
  br label %if.end

if.else:
  %inc1 = add nuw i16 %val, 1
  br label %if.end

if.end:
  %inc2 = phi i16 [ %inc, %if.then], [ %inc1, %if.else ]
  %cmp1 = icmp ult i16 %inc2, 253
  br i1 %cmp1, label %loop, label %exit

exit:
  ret void
}

define i8 @ret_i8() {
; CHECK-LABEL: @ret_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC2:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[VAL]], 128
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[INC:%.*]] = add nuw i32 [[VAL]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.else:
; CHECK-NEXT:    [[INC1:%.*]] = add nuw i32 [[VAL]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC2]] = phi i32 [ [[INC]], [[IF_THEN]] ], [ [[INC1]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[INC2]], 253
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i32 [[INC2]] to i8
; CHECK-NEXT:    ret i8 [[TMP0]]
;
entry:
  br label %loop

loop:
  %val = phi i8 [ 0, %entry ], [ %inc2, %if.end ]
  %cmp = icmp ult i8 %val, 128
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %inc = add nuw i8 %val, 2
  br label %if.end

if.else:
  %inc1 = add nuw i8 %val, 1
  br label %if.end

if.end:
  %inc2 = phi i8 [ %inc, %if.then], [ %inc1, %if.else ]
  %cmp1 = icmp ult i8 %inc2, 253
  br i1 %cmp1, label %exit, label %loop

exit:
  ret i8 %inc2
}

define i16 @phi_multiple_undefs(i16 zeroext %arg) {
; CHECK-LABEL: @phi_multiple_undefs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[VAL:%.*]] = phi i32 [ undef, [[ENTRY:%.*]] ], [ [[INC2:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[VAL]], 128
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[INC:%.*]] = add nuw i32 [[VAL]], 2
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.else:
; CHECK-NEXT:    [[INC1:%.*]] = add nuw i32 [[VAL]], 1
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC2]] = phi i32 [ [[INC]], [[IF_THEN]] ], [ [[INC1]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[UNRELATED:%.*]] = phi i16 [ undef, [[IF_THEN]] ], [ [[ARG:%.*]], [[IF_ELSE]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[INC2]], 253
; CHECK-NEXT:    br i1 [[CMP1]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i16 [[UNRELATED]]
;
entry:
  br label %loop

loop:
  %val = phi i16 [ undef, %entry ], [ %inc2, %if.end ]
  %cmp = icmp ult i16 %val, 128
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %inc = add nuw i16 %val, 2
  br label %if.end

if.else:
  %inc1 = add nuw i16 %val, 1
  br label %if.end

if.end:
  %inc2 = phi i16 [ %inc, %if.then], [ %inc1, %if.else ]
  %unrelated = phi i16 [ undef, %if.then ], [ %arg, %if.else ]
  %cmp1 = icmp ult i16 %inc2, 253
  br i1 %cmp1, label %loop, label %exit

exit:
  ret i16 %unrelated
}

define i16 @promote_arg_return(i16 zeroext %arg1, i16 zeroext %arg2, i8* %res) {
; CHECK-LABEL: @promote_arg_return(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[ARG1:%.*]] to i32
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[ARG2:%.*]] to i32
; CHECK-NEXT:    [[ADD:%.*]] = add nuw i32 [[TMP1]], 15
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[ADD]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[MUL]], [[TMP2]]
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i8
; CHECK-NEXT:    store i8 [[CONV]], i8* [[RES:%.*]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[TMP3]]
;
  %add = add nuw i16 %arg1, 15
  %mul = mul nuw nsw i16 %add, 3
  %cmp = icmp ult i16 %mul, %arg2
  %conv = zext i1 %cmp to i8
  store i8 %conv, i8* %res
  ret i16 %arg1
}

define i16 @signext_bitcast_phi_select(i16 signext %start, i16* %in) {
; CHECK-LABEL: @signext_bitcast_phi_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[START:%.*]] to i32
; CHECK-NEXT:    [[CONST:%.*]] = bitcast i16 -1 to i16
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IDX:%.*]] = phi i32 [ [[SELECT:%.*]], [[IF_ELSE:%.*]] ], [ [[TMP0]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = trunc i32 [[IDX]] to i16
; CHECK-NEXT:    [[CMP_I:%.*]] = icmp sgt i16 [[TMP1]], [[CONST]]
; CHECK-NEXT:    br i1 [[CMP_I]], label [[EXIT:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[IDX_NEXT:%.*]] = getelementptr i16, i16* [[IN:%.*]], i32 [[IDX]]
; CHECK-NEXT:    [[LD:%.*]] = load i16, i16* [[IDX_NEXT]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[LD]] to i32
; CHECK-NEXT:    [[CMP1_I:%.*]] = icmp eq i32 [[TMP2]], [[IDX]]
; CHECK-NEXT:    br i1 [[CMP1_I]], label [[EXIT]], label [[IF_ELSE]]
; CHECK:       if.else:
; CHECK-NEXT:    [[LOBIT:%.*]] = lshr i32 [[IDX]], 15
; CHECK-NEXT:    [[LOBIT_NOT:%.*]] = xor i32 [[LOBIT]], 1
; CHECK-NEXT:    [[SELECT]] = add nuw i32 [[LOBIT_NOT]], [[IDX]]
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[TMP2]], [[IF_THEN]] ], [ 0, [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = trunc i32 [[RES]] to i16
; CHECK-NEXT:    ret i16 [[TMP3]]
;
entry:
  %const = bitcast i16 -1 to i16
  br label %for.body

for.body:
  %idx = phi i16 [ %select, %if.else ], [ %start, %entry ]
  %cmp.i = icmp sgt i16 %idx, %const
  br i1 %cmp.i, label %exit, label %if.then

if.then:
  %idx.next = getelementptr i16, i16* %in, i16 %idx
  %ld = load i16, i16* %idx.next, align 2
  %cmp1.i = icmp eq i16 %ld, %idx
  br i1 %cmp1.i, label %exit, label %if.else

if.else:
  %lobit = lshr i16 %idx, 15
  %lobit.not = xor i16 %lobit, 1
  %select = add nuw i16 %lobit.not, %idx
  br label %for.body

exit:
  %res = phi i16 [ %ld, %if.then ], [ 0, %for.body ]
  ret i16 %res
}
