; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -march=amdgcn -loop-reduce -S < %s | FileCheck %s
; REQUIRES: asserts

; Test that LSR does not attempt to extend a pointer type to an integer type,
; which causes a SCEV analysis assertion.

target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-G1-ni:7"

target triple = "amdgcn-amd-amdhsa"

@gVar = external hidden local_unnamed_addr addrspace(3) global [1024 x double], align 16

define amdgpu_kernel void @scaledregtest() local_unnamed_addr {
; CHECK-LABEL: @scaledregtest(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       loopexit:
; CHECK-NEXT:    br label [[FOR_BODY_1:%.*]]
; CHECK:       for.body.1:
; CHECK-NEXT:    [[LSR_IV5:%.*]] = phi i8* addrspace(5)* [ [[SCEVGEP6:%.*]], [[FOR_BODY_1]] ], [ [[SCEVGEP11:%.*]], [[LOOPEXIT:%.*]] ]
; CHECK-NEXT:    [[LSR_IV1:%.*]] = phi i8** [ [[SCEVGEP2:%.*]], [[FOR_BODY_1]] ], [ [[SCEVGEP13:%.*]], [[LOOPEXIT]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = load i8*, i8* addrspace(5)* [[LSR_IV5]], align 8
; CHECK-NEXT:    store i8* [[TMP0]], i8** [[LSR_IV1]], align 8
; CHECK-NEXT:    [[SCEVGEP2]] = getelementptr i8*, i8** [[LSR_IV1]], i64 1
; CHECK-NEXT:    [[SCEVGEP6]] = getelementptr i8*, i8* addrspace(5)* [[LSR_IV5]], i32 1
; CHECK-NEXT:    br label [[FOR_BODY_1]]
; CHECK:       for.body:
; CHECK-NEXT:    [[LSR_IV12:%.*]] = phi i8** [ [[SCEVGEP13]], [[FOR_BODY]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LSR_IV10:%.*]] = phi i8* addrspace(5)* [ [[SCEVGEP11]], [[FOR_BODY]] ], [ null, [[ENTRY]] ]
; CHECK-NEXT:    [[SCEVGEP11]] = getelementptr i8*, i8* addrspace(5)* [[LSR_IV10]], i32 8
; CHECK-NEXT:    [[SCEVGEP13]] = getelementptr i8*, i8** [[LSR_IV12]], i64 8
; CHECK-NEXT:    br i1 false, label [[LOOPEXIT]], label [[FOR_BODY]]
;
entry:
  br label %for.body

loopexit:
  %conv = zext i32 %inc to i64
  br label %for.body.1

for.body.1:
  %conv.1 = phi i64 [ %conv.2, %for.body.1 ], [ %conv, %loopexit ]
  %I.1 = phi i32 [ %inc.1, %for.body.1 ], [ %inc, %loopexit ]
  %idxprom = trunc i64 %conv.1 to i32
  %arrayidx = getelementptr inbounds i8*, i8* addrspace(5)* null, i32 %idxprom
  %0 = load i8*, i8* addrspace(5)* %arrayidx, align 8
  %arrayidx.1 = getelementptr inbounds i8*, i8** null, i64 %conv.1
  store i8* %0, i8** %arrayidx.1, align 8
  %inc.1 = add nuw nsw i32 %I.1, 1
  %conv.2 = zext i32 %inc.1 to i64
  br label %for.body.1

for.body:
  %I = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %inc = add nuw nsw i32 %I, 8
  br i1 false, label %loopexit, label %for.body
}

define protected amdgpu_kernel void @baseregtest(i32 %n, i32 %lda) local_unnamed_addr {
; CHECK-LABEL: @baseregtest(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call i32 @foo()
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr [1024 x double], [1024 x double] addrspace(3)* @gVar, i32 0, i32 [[TMP0]]
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = bitcast double addrspace(3)* [[SCEVGEP]] to [1024 x double] addrspace(3)*
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[N:%.*]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP0]] to i64
; CHECK-NEXT:    [[SCEVGEP5:%.*]] = getelementptr double, double addrspace(1)* null, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext i32 [[LDA:%.*]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = shl nsw i64 [[TMP3]], 3
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[LSR_IV6:%.*]] = phi double addrspace(1)* [ [[TMP7:%.*]], [[FOR_BODY]] ], [ [[SCEVGEP5]], [[IF_END]] ]
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi [1024 x double] addrspace(3)* [ [[TMP6:%.*]], [[FOR_BODY]] ], [ [[SCEVGEP1]], [[IF_END]] ]
; CHECK-NEXT:    [[LSR_IV2:%.*]] = bitcast [1024 x double] addrspace(3)* [[LSR_IV]] to i1 addrspace(3)*
; CHECK-NEXT:    [[LSR_IV4:%.*]] = bitcast [1024 x double] addrspace(3)* [[LSR_IV]] to double addrspace(3)*
; CHECK-NEXT:    [[LSR_IV67:%.*]] = bitcast double addrspace(1)* [[LSR_IV6]] to i1 addrspace(1)*
; CHECK-NEXT:    [[TMP5:%.*]] = load double, double addrspace(1)* [[LSR_IV6]], align 8
; CHECK-NEXT:    store double [[TMP5]], double addrspace(3)* [[LSR_IV4]], align 8
; CHECK-NEXT:    [[SCEVGEP3:%.*]] = getelementptr i1, i1 addrspace(3)* [[LSR_IV2]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP6]] = bitcast i1 addrspace(3)* [[SCEVGEP3]] to [1024 x double] addrspace(3)*
; CHECK-NEXT:    [[SCEVGEP8:%.*]] = getelementptr i1, i1 addrspace(1)* [[LSR_IV67]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP7]] = bitcast i1 addrspace(1)* [[SCEVGEP8]] to double addrspace(1)*
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %exit, label %if.end

if.end:
  %0 = tail call i32 @foo()
  br label %for.body

for.body:
  %i = phi i32 [ %inc, %for.body ], [ 0, %if.end ]
  %mul1 = mul nsw i32 %i, %lda
  %add1 = add nsw i32 %mul1, %0
  %idxprom = sext i32 %add1 to i64
  %arrayidx = getelementptr inbounds double, double addrspace(1)* null, i64 %idxprom
  %1 = load double, double addrspace(1)* %arrayidx, align 8
  %mul2 = mul nsw i32 %i, %n
  %add2 = add nsw i32 %mul2, %0
  %arrayidx9110 = getelementptr inbounds [1024 x double], [1024 x double] addrspace(3)* @gVar, i32 0, i32 %add2
  store double %1, double addrspace(3)* %arrayidx9110, align 8
  %inc = add nuw nsw i32 %i, 1
  br label %for.body

exit:
  ret void
}

declare i32 @foo()
