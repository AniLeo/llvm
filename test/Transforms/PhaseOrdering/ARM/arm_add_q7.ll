; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes='default<O3>' -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv8.1m.main-arm-none-eabi"

; This should, after inlining and simplification, be a single tail predicated
; 16x vector loop handling llvm.sadd.sat.  __SSAT is inlined and so is DCE'd.

; Function Attrs: nounwind
define dso_local void @arm_add_q7(i8* %pSrcA, i8* %pSrcB, i8* noalias %pDst, i32 %blockSize) #0 {
; CHECK-LABEL: @arm_add_q7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_NOT3:%.*]] = icmp eq i32 [[BLOCKSIZE:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT3]], label [[WHILE_END:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[BLOCKSIZE]], 15
; CHECK-NEXT:    [[N_VEC:%.*]] = and i32 [[N_RND_UP]], -16
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[NEXT_GEP:%.*]] = getelementptr i8, i8* [[PSRCA:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP14:%.*]] = getelementptr i8, i8* [[PDST:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[NEXT_GEP15:%.*]] = getelementptr i8, i8* [[PSRCB:%.*]], i32 [[INDEX]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <16 x i1> @llvm.get.active.lane.mask.v16i1.i32(i32 [[INDEX]], i32 [[BLOCKSIZE]])
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[NEXT_GEP]] to <16 x i8>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* [[TMP0]], i32 1, <16 x i1> [[ACTIVE_LANE_MASK]], <16 x i8> poison)
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[NEXT_GEP15]] to <16 x i8>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD18:%.*]] = call <16 x i8> @llvm.masked.load.v16i8.p0v16i8(<16 x i8>* [[TMP1]], i32 1, <16 x i1> [[ACTIVE_LANE_MASK]], <16 x i8> poison)
; CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.sadd.sat.v16i8(<16 x i8> [[WIDE_MASKED_LOAD]], <16 x i8> [[WIDE_MASKED_LOAD18]])
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8* [[NEXT_GEP14]] to <16 x i8>*
; CHECK-NEXT:    call void @llvm.masked.store.v16i8.p0v16i8(<16 x i8> [[TMP2]], <16 x i8>* [[TMP3]], i32 1, <16 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 16
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP4]], label [[WHILE_END]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       while.end:
; CHECK-NEXT:    ret void
;
entry:
  %pSrcA.addr = alloca i8*, align 4
  %pSrcB.addr = alloca i8*, align 4
  %pDst.addr = alloca i8*, align 4
  %blockSize.addr = alloca i32, align 4
  %blkCnt = alloca i32, align 4
  store i8* %pSrcA, i8** %pSrcA.addr, align 4
  store i8* %pSrcB, i8** %pSrcB.addr, align 4
  store i8* %pDst, i8** %pDst.addr, align 4
  store i32 %blockSize, i32* %blockSize.addr, align 4
  %0 = bitcast i32* %blkCnt to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %0)
  %1 = load i32, i32* %blockSize.addr, align 4
  store i32 %1, i32* %blkCnt, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %2 = load i32, i32* %blkCnt, align 4
  %cmp = icmp ugt i32 %2, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load i8*, i8** %pSrcA.addr, align 4
  %incdec.ptr = getelementptr inbounds i8, i8* %3, i32 1
  store i8* %incdec.ptr, i8** %pSrcA.addr, align 4
  %4 = load i8, i8* %3, align 1
  %conv = sext i8 %4 to i16
  %conv1 = sext i16 %conv to i32
  %5 = load i8*, i8** %pSrcB.addr, align 4
  %incdec.ptr2 = getelementptr inbounds i8, i8* %5, i32 1
  store i8* %incdec.ptr2, i8** %pSrcB.addr, align 4
  %6 = load i8, i8* %5, align 1
  %conv3 = sext i8 %6 to i32
  %add = add nsw i32 %conv1, %conv3
  %call = call i32 @__SSAT(i32 %add, i32 8)
  %conv4 = trunc i32 %call to i8
  %7 = load i8*, i8** %pDst.addr, align 4
  %incdec.ptr5 = getelementptr inbounds i8, i8* %7, i32 1
  store i8* %incdec.ptr5, i8** %pDst.addr, align 4
  store i8 %conv4, i8* %7, align 1
  %8 = load i32, i32* %blkCnt, align 4
  %dec = add i32 %8, -1
  store i32 %dec, i32* %blkCnt, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %9 = bitcast i32* %blkCnt to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %9)
  ret void
}

define internal i32 @__SSAT(i32 %val, i32 %sat) #1 {
entry:
  %retval = alloca i32, align 4
  %val.addr = alloca i32, align 4
  %sat.addr = alloca i32, align 4
  %max = alloca i32, align 4
  %min = alloca i32, align 4
  %cleanup.dest.slot = alloca i32, align 4
  store i32 %val, i32* %val.addr, align 4
  store i32 %sat, i32* %sat.addr, align 4
  %0 = load i32, i32* %sat.addr, align 4
  %cmp = icmp uge i32 %0, 1
  br i1 %cmp, label %land.lhs.true, label %if.end10

land.lhs.true:                                    ; preds = %entry
  %1 = load i32, i32* %sat.addr, align 4
  %cmp1 = icmp ule i32 %1, 32
  br i1 %cmp1, label %if.then, label %if.end10

if.then:                                          ; preds = %land.lhs.true
  %2 = bitcast i32* %max to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %2)
  %3 = load i32, i32* %sat.addr, align 4
  %sub = sub i32 %3, 1
  %shl = shl i32 1, %sub
  %sub2 = sub i32 %shl, 1
  store i32 %sub2, i32* %max, align 4
  %4 = bitcast i32* %min to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %4)
  %5 = load i32, i32* %max, align 4
  %sub3 = sub nsw i32 -1, %5
  store i32 %sub3, i32* %min, align 4
  %6 = load i32, i32* %val.addr, align 4
  %7 = load i32, i32* %max, align 4
  %cmp4 = icmp sgt i32 %6, %7
  br i1 %cmp4, label %if.then5, label %if.else

if.then5:                                         ; preds = %if.then
  %8 = load i32, i32* %max, align 4
  store i32 %8, i32* %retval, align 4
  store i32 1, i32* %cleanup.dest.slot, align 4
  br label %cleanup

if.else:                                          ; preds = %if.then
  %9 = load i32, i32* %val.addr, align 4
  %10 = load i32, i32* %min, align 4
  %cmp6 = icmp slt i32 %9, %10
  br i1 %cmp6, label %if.then7, label %if.end

if.then7:                                         ; preds = %if.else
  %11 = load i32, i32* %min, align 4
  store i32 %11, i32* %retval, align 4
  store i32 1, i32* %cleanup.dest.slot, align 4
  br label %cleanup

if.end:                                           ; preds = %if.else
  br label %if.end8

if.end8:                                          ; preds = %if.end
  store i32 0, i32* %cleanup.dest.slot, align 4
  br label %cleanup

cleanup:                                          ; preds = %if.end8, %if.then7, %if.then5
  %12 = bitcast i32* %min to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12)
  %13 = bitcast i32* %max to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13)
  %cleanup.dest = load i32, i32* %cleanup.dest.slot, align 4
  switch i32 %cleanup.dest, label %unreachable [
  i32 0, label %cleanup.cont
  i32 1, label %return
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %if.end10

if.end10:                                         ; preds = %cleanup.cont, %land.lhs.true, %entry
  %14 = load i32, i32* %val.addr, align 4
  store i32 %14, i32* %retval, align 4
  br label %return

return:                                           ; preds = %if.end10, %cleanup
  %15 = load i32, i32* %retval, align 4
  ret i32 %15

unreachable:                                      ; preds = %cleanup
  unreachable
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m55" "target-features"="+armv8.1-m.main,+dsp,+fp-armv8d16,+fp-armv8d16sp,+fp16,+fp64,+fullfp16,+hwdiv,+lob,+mve,+mve.fp,+ras,+strict-align,+thumb-mode,+vfp2,+vfp2sp,+vfp3d16,+vfp3d16sp,+vfp4d16,+vfp4d16sp,-aes,-bf16,-cdecp0,-cdecp1,-cdecp2,-cdecp3,-cdecp4,-cdecp5,-cdecp6,-cdecp7,-crc,-crypto,-d32,-dotprod,-fp-armv8,-fp-armv8sp,-fp16fml,-hwdiv-arm,-i8mm,-neon,-sb,-sha2,-vfp3,-vfp3sp,-vfp4,-vfp4sp" "unsafe-fp-math"="true" }
attributes #1 = { alwaysinline nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m55" "target-features"="+armv8.1-m.main,+dsp,+fp-armv8d16,+fp-armv8d16sp,+fp16,+fp64,+fullfp16,+hwdiv,+lob,+mve,+mve.fp,+ras,+strict-align,+thumb-mode,+vfp2,+vfp2sp,+vfp3d16,+vfp3d16sp,+vfp4d16,+vfp4d16sp,-aes,-bf16,-cdecp0,-cdecp1,-cdecp2,-cdecp3,-cdecp4,-cdecp5,-cdecp6,-cdecp7,-crc,-crypto,-d32,-dotprod,-fp-armv8,-fp-armv8sp,-fp16fml,-hwdiv-arm,-i8mm,-neon,-sb,-sha2,-vfp3,-vfp3sp,-vfp4,-vfp4sp" "unsafe-fp-math"="true" }
