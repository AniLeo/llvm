; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

define linkonce_odr dso_local void @foo(<256 x i32>* %arrayidx16, <256 x i32>* %arrayidx29, <256 x i32>* %arrayidx35) local_unnamed_addr {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND9:%.*]]
; CHECK:       for.cond9:
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY14:%.*]], label [[EXIT:%.*]]
; CHECK:       for.body14:
; CHECK-NEXT:    [[T5:%.*]] = load <256 x i32>, <256 x i32>* [[ARRAYIDX16:%.*]], align 64
; CHECK-NEXT:    br label [[FOR_COND18:%.*]]
; CHECK:       for.cond18:
; CHECK-NEXT:    [[SUB_C_SROA_0_0:%.*]] = phi <256 x i32> [ [[T5]], [[FOR_BODY14]] ], [ [[T12:%.*]], [[FOR_BODY24:%.*]] ]
; CHECK-NEXT:    br i1 undef, label [[FOR_BODY24]], label [[FOR_COND_CLEANUP23:%.*]]
; CHECK:       for.cond.cleanup23:
; CHECK-NEXT:    store <256 x i32> [[SUB_C_SROA_0_0]], <256 x i32>* [[ARRAYIDX16]], align 64
; CHECK-NEXT:    br label [[FOR_COND9]]
; CHECK:       for.body24:
; CHECK-NEXT:    [[T6:%.*]] = load <256 x i32>, <256 x i32>* [[ARRAYIDX29:%.*]], align 64
; CHECK-NEXT:    [[T7:%.*]] = load <256 x i32>, <256 x i32>* [[ARRAYIDX35:%.*]], align 64
; CHECK-NEXT:    [[T8:%.*]] = bitcast <256 x i32> [[SUB_C_SROA_0_0]] to x86_amx
; CHECK-NEXT:    [[T9:%.*]] = bitcast <256 x i32> [[T6]] to x86_amx
; CHECK-NEXT:    [[T10:%.*]] = bitcast <256 x i32> [[T7]] to x86_amx
; CHECK-NEXT:    [[T11:%.*]] = call x86_amx @llvm.x86.tdpbssd.internal(i16 1, i16 4, i16 4, x86_amx [[T8]], x86_amx [[T9]], x86_amx [[T10]])
; CHECK-NEXT:    [[T12]] = bitcast x86_amx [[T11]] to <256 x i32>
; CHECK-NEXT:    br label [[FOR_COND18]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond9
for.cond9:                                        ; preds = %for.cond, %for.cond.cleanup23
  br i1 undef, label %for.body14, label %exit

for.body14:
  %t5 = load <256 x i32>, <256 x i32>* %arrayidx16, align 64
  br label %for.cond18

for.cond18:                                       ; preds = %for.body24, %for.body14
  %sub_c.sroa.0.0 = phi <256 x i32> [ %t5, %for.body14 ], [ %t12, %for.body24 ]
  br i1 undef, label %for.body24, label %for.cond.cleanup23

for.cond.cleanup23:                               ; preds = %for.cond18
  store <256 x i32> %sub_c.sroa.0.0, <256 x i32>* %arrayidx16, align 64
  br label %for.cond9

for.body24:                                       ; preds = %for.cond18
  %t6 = load <256 x i32>, <256 x i32>* %arrayidx29, align 64
  %t7 = load <256 x i32>, <256 x i32>* %arrayidx35, align 64
  %t8 = bitcast <256 x i32> %sub_c.sroa.0.0 to x86_amx
  %t9 = bitcast <256 x i32> %t6 to x86_amx
  %t10 = bitcast <256 x i32> %t7 to x86_amx
  %t11 = call x86_amx @llvm.x86.tdpbssd.internal(i16 1, i16 4, i16 4, x86_amx %t8, x86_amx %t9, x86_amx %t10) #12
  %t12 = bitcast x86_amx %t11 to <256 x i32>
  br label %for.cond18

exit:
  ret void
}

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)
