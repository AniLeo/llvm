; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mcpu=core-avx2 < %s -O3 -S                                        | FileCheck -check-prefixes=ALL,OLDPM %s
; RUN: opt -mcpu=core-avx2 < %s -passes='default<O3>' -aa-pipeline=default -S | FileCheck -check-prefixes=ALL,NEWPM %s

; Not only should we be able to make the loop countable,
; %whatever.next recurrence should be rewritten, making loop dead.

target triple = "x86_64--"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @cttz(i32 %n, i32* %p1) {
; ALL-LABEL: @cttz(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[TMP0:%.*]] = shl i32 [[N:%.*]], 1
; ALL-NEXT:    [[TMP1:%.*]] = call i32 @llvm.cttz.i32(i32 [[TMP0]], i1 false), [[RNG0:!range !.*]]
; ALL-NEXT:    [[TMP2:%.*]] = sub nuw nsw i32 33, [[TMP1]]
; ALL-NEXT:    [[TMP3:%.*]] = sub nuw nsw i32 33, [[TMP1]]
; ALL-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ugt i32 [[TMP1]], 25
; ALL-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[WHILE_COND_PREHEADER:%.*]], label [[VECTOR_PH:%.*]]
; ALL:       vector.ph:
; ALL-NEXT:    [[N_VEC:%.*]] = and i32 [[TMP3]], -8
; ALL-NEXT:    [[IND_END:%.*]] = sub nsw i32 [[TMP2]], [[N_VEC]]
; ALL-NEXT:    [[TMP4:%.*]] = add nsw i32 [[N_VEC]], -8
; ALL-NEXT:    [[TMP5:%.*]] = lshr exact i32 [[TMP4]], 3
; ALL-NEXT:    [[TMP6:%.*]] = add nuw nsw i32 [[TMP5]], 1
; ALL-NEXT:    [[XTRAITER:%.*]] = and i32 [[TMP6]], 7
; ALL-NEXT:    [[TMP7:%.*]] = icmp ult i32 [[TMP4]], 56
; ALL-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK_UNR_LCSSA:%.*]], label [[VECTOR_PH_NEW:%.*]]
; ALL:       vector.ph.new:
; ALL-NEXT:    [[UNROLL_ITER:%.*]] = and i32 [[TMP6]], 1073741816
; ALL-NEXT:    br label [[VECTOR_BODY:%.*]]
; ALL:       vector.body:
; ALL-NEXT:    [[VEC_PHI:%.*]] = phi <8 x i32> [ <i32 42, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, [[VECTOR_PH_NEW]] ], [ [[TMP8:%.*]], [[VECTOR_BODY]] ]
; ALL-NEXT:    [[NITER:%.*]] = phi i32 [ [[UNROLL_ITER]], [[VECTOR_PH_NEW]] ], [ [[NITER_NSUB_7:%.*]], [[VECTOR_BODY]] ]
; ALL-NEXT:    [[TMP8]] = add <8 x i32> [[VEC_PHI]], <i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
; ALL-NEXT:    [[NITER_NSUB_7]] = add i32 [[NITER]], -8
; ALL-NEXT:    [[NITER_NCMP_7:%.*]] = icmp eq i32 [[NITER_NSUB_7]], 0
; ALL-NEXT:    br i1 [[NITER_NCMP_7]], label [[MIDDLE_BLOCK_UNR_LCSSA]], label [[VECTOR_BODY]], [[LOOP1:!llvm.loop !.*]]
; ALL:       middle.block.unr-lcssa:
; ALL-NEXT:    [[DOTLCSSA_PH:%.*]] = phi <8 x i32> [ undef, [[VECTOR_PH]] ], [ [[TMP8]], [[VECTOR_BODY]] ]
; ALL-NEXT:    [[VEC_PHI_UNR:%.*]] = phi <8 x i32> [ <i32 42, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, [[VECTOR_PH]] ], [ [[TMP8]], [[VECTOR_BODY]] ]
; ALL-NEXT:    [[LCMP_MOD_NOT:%.*]] = icmp eq i32 [[XTRAITER]], 0
; ALL-NEXT:    br i1 [[LCMP_MOD_NOT]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY_EPIL:%.*]]
; ALL:       vector.body.epil:
; ALL-NEXT:    [[VEC_PHI_EPIL:%.*]] = phi <8 x i32> [ [[TMP9:%.*]], [[VECTOR_BODY_EPIL]] ], [ [[VEC_PHI_UNR]], [[MIDDLE_BLOCK_UNR_LCSSA]] ]
; ALL-NEXT:    [[EPIL_ITER:%.*]] = phi i32 [ [[EPIL_ITER_SUB:%.*]], [[VECTOR_BODY_EPIL]] ], [ [[XTRAITER]], [[MIDDLE_BLOCK_UNR_LCSSA]] ]
; ALL-NEXT:    [[TMP9]] = add <8 x i32> [[VEC_PHI_EPIL]], <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
; ALL-NEXT:    [[EPIL_ITER_SUB]] = add i32 [[EPIL_ITER]], -1
; ALL-NEXT:    [[EPIL_ITER_CMP_NOT:%.*]] = icmp eq i32 [[EPIL_ITER_SUB]], 0
; ALL-NEXT:    br i1 [[EPIL_ITER_CMP_NOT]], label [[MIDDLE_BLOCK]], label [[VECTOR_BODY_EPIL]], [[LOOP3:!llvm.loop !.*]]
; ALL:       middle.block:
; ALL-NEXT:    [[DOTLCSSA:%.*]] = phi <8 x i32> [ [[DOTLCSSA_PH]], [[MIDDLE_BLOCK_UNR_LCSSA]] ], [ [[TMP9]], [[VECTOR_BODY_EPIL]] ]
; ALL-NEXT:    [[TMP10:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> [[DOTLCSSA]])
; ALL-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP3]], [[N_VEC]]
; ALL-NEXT:    br i1 [[CMP_N]], label [[WHILE_END:%.*]], label [[WHILE_COND_PREHEADER]]
; ALL:       while.cond.preheader:
; ALL-NEXT:    [[TCPHI_PH:%.*]] = phi i32 [ [[TMP2]], [[ENTRY:%.*]] ], [ [[IND_END]], [[MIDDLE_BLOCK]] ]
; ALL-NEXT:    [[WHATEVER_PH:%.*]] = phi i32 [ 42, [[ENTRY]] ], [ [[TMP10]], [[MIDDLE_BLOCK]] ]
; ALL-NEXT:    br label [[WHILE_COND:%.*]]
; ALL:       while.cond:
; ALL-NEXT:    [[TCPHI:%.*]] = phi i32 [ [[TCDEC:%.*]], [[WHILE_COND]] ], [ [[TCPHI_PH]], [[WHILE_COND_PREHEADER]] ]
; ALL-NEXT:    [[WHATEVER:%.*]] = phi i32 [ [[WHATEVER_NEXT:%.*]], [[WHILE_COND]] ], [ [[WHATEVER_PH]], [[WHILE_COND_PREHEADER]] ]
; ALL-NEXT:    [[TCDEC]] = add nsw i32 [[TCPHI]], -1
; ALL-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TCDEC]], 0
; ALL-NEXT:    [[WHATEVER_NEXT]] = add nuw nsw i32 [[WHATEVER]], 1
; ALL-NEXT:    br i1 [[TOBOOL]], label [[WHILE_END]], label [[WHILE_COND]], [[LOOP5:!llvm.loop !.*]]
; ALL:       while.end:
; ALL-NEXT:    [[WHATEVER_NEXT_LCSSA:%.*]] = phi i32 [ [[TMP10]], [[MIDDLE_BLOCK]] ], [ [[WHATEVER_NEXT]], [[WHILE_COND]] ]
; ALL-NEXT:    [[TMP11:%.*]] = sub nuw nsw i32 32, [[TMP1]]
; ALL-NEXT:    store i32 [[WHATEVER_NEXT_LCSSA]], i32* [[P1:%.*]], align 4
; ALL-NEXT:    ret i32 [[TMP11]]
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %entry
  %n.addr.0 = phi i32 [ %n, %entry ], [ %shl, %while.cond ]
  %whatever = phi i32 [ 42, %entry ], [ %whatever.next, %while.cond ]
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %while.cond ]
  %shl = shl i32 %n.addr.0, 1
  %tobool = icmp eq i32 %shl, 0
  %inc = add nsw i32 %i.0, 1
  %whatever.next = add i32 %whatever, 1
  br i1 %tobool, label %while.end, label %while.cond

while.end:                                        ; preds = %while.cond
  store i32 %whatever.next, i32* %p1
  ret i32 %i.0
}
