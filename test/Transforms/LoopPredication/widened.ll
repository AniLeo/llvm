; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-predication -loop-predication-enable-iv-truncation=true < %s 2>&1 | FileCheck %s
; RUN: opt -S -passes='require<scalar-evolution>,loop-mssa(loop-predication)' -verify-memoryssa < %s 2>&1 | FileCheck %s
declare void @llvm.experimental.guard(i1, ...)

declare i32 @length(i8*)

declare i16 @short_length(i8*)
; Consider range check of type i16 and i32, while IV is of type i64
; We can loop predicate this because the IV range is within i16 and within i32.
define i64 @iv_wider_type_rc_two_narrow_types(i32 %offA, i16 %offB, i8* %arrA, i8* %arrB) {
; CHECK-LABEL: @iv_wider_type_rc_two_narrow_types(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LENGTHA:%.*]] = call i32 @length(i8* [[ARRA:%.*]])
; CHECK-NEXT:    [[LENGTHB:%.*]] = call i16 @short_length(i8* [[ARRB:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = sub i16 [[LENGTHB]], [[OFFB:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i16 16, [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i16 [[OFFB]], [[LENGTHB]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i1 [[TMP2]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = sub i32 [[LENGTHA]], [[OFFA:%.*]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ule i32 16, [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ult i32 [[OFFA]], [[LENGTHA]]
; CHECK-NEXT:    [[TMP7:%.*]] = and i1 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = and i1 [[TMP3]], [[TMP7]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_TRUNC_32:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[IV_TRUNC_16:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    [[INDEXA:%.*]] = add i32 [[IV_TRUNC_32]], [[OFFA]]
; CHECK-NEXT:    [[INDEXB:%.*]] = add i16 [[IV_TRUNC_16]], [[OFFB]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP8]], i32 9) [ "deopt"() ]
; CHECK-NEXT:    [[INDEXA_EXT:%.*]] = zext i32 [[INDEXA]] to i64
; CHECK-NEXT:    [[ADDRA:%.*]] = getelementptr inbounds i8, i8* [[ARRA]], i64 [[INDEXA_EXT]]
; CHECK-NEXT:    [[ELTA:%.*]] = load i8, i8* [[ADDRA]]
; CHECK-NEXT:    [[INDEXB_EXT:%.*]] = zext i16 [[INDEXB]] to i64
; CHECK-NEXT:    [[ADDRB:%.*]] = getelementptr inbounds i8, i8* [[ARRB]], i64 [[INDEXB_EXT]]
; CHECK-NEXT:    store i8 [[ELTA]], i8* [[ADDRB]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[LATCH_CHECK:%.*]] = icmp ult i64 [[IV_NEXT]], 16
; CHECK-NEXT:    br i1 [[LATCH_CHECK]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i64 [ [[IV]], [[LOOP]] ]
; CHECK-NEXT:    ret i64 [[IV_LCSSA]]
;
entry:
  %lengthA = call i32 @length(i8* %arrA)
  %lengthB = call i16 @short_length(i8* %arrB)
  br label %loop

loop:
  %iv = phi i64 [0, %entry ], [ %iv.next, %loop ]
  %iv.trunc.32 = trunc i64 %iv to i32
  %iv.trunc.16 = trunc i64 %iv to i16
  %indexA = add i32 %iv.trunc.32, %offA
  %indexB = add i16 %iv.trunc.16, %offB
  %rcA = icmp ult i32 %indexA, %lengthA
  %rcB = icmp ult i16 %indexB, %lengthB
  %wide.chk = and i1 %rcA, %rcB
  call void (i1, ...) @llvm.experimental.guard(i1 %wide.chk, i32 9) [ "deopt"() ]
  %indexA.ext = zext i32 %indexA to i64
  %addrA = getelementptr inbounds i8, i8* %arrA, i64 %indexA.ext
  %eltA = load i8, i8* %addrA
  %indexB.ext = zext i16 %indexB to i64
  %addrB = getelementptr inbounds i8, i8* %arrB, i64 %indexB.ext
  store i8 %eltA, i8* %addrB
  %iv.next = add nuw nsw i64 %iv, 1
  %latch.check = icmp ult i64 %iv.next, 16
  br i1 %latch.check, label %loop, label %exit

exit:
  ret i64 %iv
}


; Consider an IV of type long and an array access into int array.
; IV is of type i64 while the range check operands are of type i32 and i64.
define i64 @iv_rc_different_types(i32 %offA, i32 %offB, i8* %arrA, i8* %arrB, i64 %max)
; CHECK-LABEL: @iv_rc_different_types(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LENGTHA:%.*]] = call i32 @length(i8* [[ARRA:%.*]])
; CHECK-NEXT:    [[LENGTHB:%.*]] = call i32 @length(i8* [[ARRB:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[LENGTHB]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], [[OFFB:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule i32 15, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i32 [[OFFB]], [[LENGTHB]]
; CHECK-NEXT:    [[TMP4:%.*]] = and i1 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[MAX:%.*]], -1
; CHECK-NEXT:    [[TMP6:%.*]] = icmp ule i64 15, [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp ult i64 0, [[MAX]]
; CHECK-NEXT:    [[TMP8:%.*]] = and i1 [[TMP7]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = add i32 [[LENGTHA]], -1
; CHECK-NEXT:    [[TMP10:%.*]] = sub i32 [[TMP9]], [[OFFA:%.*]]
; CHECK-NEXT:    [[TMP11:%.*]] = icmp ule i32 15, [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = icmp ult i32 [[OFFA]], [[LENGTHA]]
; CHECK-NEXT:    [[TMP13:%.*]] = and i1 [[TMP12]], [[TMP11]]
; CHECK-NEXT:    [[TMP14:%.*]] = and i1 [[TMP4]], [[TMP8]]
; CHECK-NEXT:    [[TMP15:%.*]] = and i1 [[TMP14]], [[TMP13]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_TRUNC:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[INDEXA:%.*]] = add i32 [[IV_TRUNC]], [[OFFA]]
; CHECK-NEXT:    [[INDEXB:%.*]] = add i32 [[IV_TRUNC]], [[OFFB]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[TMP15]], i32 9) [ "deopt"() ]
; CHECK-NEXT:    [[INDEXA_EXT:%.*]] = zext i32 [[INDEXA]] to i64
; CHECK-NEXT:    [[ADDRA:%.*]] = getelementptr inbounds i8, i8* [[ARRA]], i64 [[INDEXA_EXT]]
; CHECK-NEXT:    [[ELTA:%.*]] = load i8, i8* [[ADDRA]]
; CHECK-NEXT:    [[INDEXB_EXT:%.*]] = zext i32 [[INDEXB]] to i64
; CHECK-NEXT:    [[ADDRB:%.*]] = getelementptr inbounds i8, i8* [[ARRB]], i64 [[INDEXB_EXT]]
; CHECK-NEXT:    [[ELTB:%.*]] = load i8, i8* [[ADDRB]]
; CHECK-NEXT:    [[RESULT:%.*]] = xor i8 [[ELTA]], [[ELTB]]
; CHECK-NEXT:    store i8 [[RESULT]], i8* [[ADDRA]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[LATCH_CHECK:%.*]] = icmp ult i64 [[IV]], 15
; CHECK-NEXT:    br i1 [[LATCH_CHECK]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i64 [ [[IV]], [[LOOP]] ]
; CHECK-NEXT:    ret i64 [[IV_LCSSA]]
;
{
entry:
  %lengthA = call i32 @length(i8* %arrA)
  %lengthB = call i32 @length(i8* %arrB)
  br label %loop

loop:
  %iv = phi i64 [0, %entry ], [ %iv.next, %loop ]
  %iv.trunc = trunc i64 %iv to i32
  %indexA = add i32 %iv.trunc, %offA
  %indexB = add i32 %iv.trunc, %offB
  %rcA = icmp ult i32 %indexA, %lengthA
  %rcIV = icmp ult i64 %iv, %max
  %wide.chk = and i1 %rcA, %rcIV
  %rcB = icmp ult i32 %indexB, %lengthB
  %wide.chk.final = and i1 %wide.chk, %rcB
  call void (i1, ...) @llvm.experimental.guard(i1 %wide.chk.final, i32 9) [ "deopt"() ]
  %indexA.ext = zext i32 %indexA to i64
  %addrA = getelementptr inbounds i8, i8* %arrA, i64 %indexA.ext
  %eltA = load i8, i8* %addrA
  %indexB.ext = zext i32 %indexB to i64
  %addrB = getelementptr inbounds i8, i8* %arrB, i64 %indexB.ext
  %eltB = load i8, i8* %addrB
  %result = xor i8 %eltA, %eltB
  store i8 %result, i8* %addrA
  %iv.next = add nuw nsw i64 %iv, 1
  %latch.check = icmp ult i64 %iv, 15
  br i1 %latch.check, label %loop, label %exit

exit:
  ret i64 %iv
}

; cannot narrow the IV to the range type, because we lose information.
; for (i64 i= 5; i>= 2; i++)
; this loop wraps around after reaching 2^64.
define i64 @iv_rc_different_type(i32 %offA, i8* %arrA) {
; CHECK-LABEL: @iv_rc_different_type(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LENGTHA:%.*]] = call i32 @length(i8* [[ARRA:%.*]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 5, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_TRUNC_32:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[INDEXA:%.*]] = add i32 [[IV_TRUNC_32]], [[OFFA:%.*]]
; CHECK-NEXT:    [[RCA:%.*]] = icmp ult i32 [[INDEXA]], [[LENGTHA]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[RCA]], i32 9) [ "deopt"() ]
; CHECK-NEXT:    [[INDEXA_EXT:%.*]] = zext i32 [[INDEXA]] to i64
; CHECK-NEXT:    [[ADDRA:%.*]] = getelementptr inbounds i8, i8* [[ARRA]], i64 [[INDEXA_EXT]]
; CHECK-NEXT:    [[ELTA:%.*]] = load i8, i8* [[ADDRA]]
; CHECK-NEXT:    [[RES:%.*]] = add i8 [[ELTA]], 2
; CHECK-NEXT:    store i8 [[ELTA]], i8* [[ADDRA]]
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-NEXT:    [[LATCH_CHECK:%.*]] = icmp sge i64 [[IV_NEXT]], 2
; CHECK-NEXT:    br i1 [[LATCH_CHECK]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[IV_LCSSA:%.*]] = phi i64 [ [[IV]], [[LOOP]] ]
; CHECK-NEXT:    ret i64 [[IV_LCSSA]]
;
entry:
  %lengthA = call i32 @length(i8* %arrA)
  br label %loop

loop:
  %iv = phi i64 [ 5, %entry ], [ %iv.next, %loop ]
  %iv.trunc.32 = trunc i64 %iv to i32
  %indexA = add i32 %iv.trunc.32, %offA
  %rcA = icmp ult i32 %indexA, %lengthA
  call void (i1, ...) @llvm.experimental.guard(i1 %rcA, i32 9) [ "deopt"() ]
  %indexA.ext = zext i32 %indexA to i64
  %addrA = getelementptr inbounds i8, i8* %arrA, i64 %indexA.ext
  %eltA = load i8, i8* %addrA
  %res = add i8 %eltA, 2
  store i8 %eltA, i8* %addrA
  %iv.next = add i64 %iv, 1
  %latch.check = icmp sge i64 %iv.next, 2
  br i1 %latch.check, label %loop, label %exit

exit:
  ret i64 %iv
}
