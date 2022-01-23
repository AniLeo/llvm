; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S < %s | FileCheck %s

%struct.Counters = type { i64, i64, i64, [8 x i8] }

@m = global i64 3, align 8
@counters = global %struct.Counters zeroinitializer, align 16

define i32 @align_both_equal() local_unnamed_addr {
; CHECK-LABEL: @align_both_equal(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS:%.*]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 1, i64 1>
; CHECK-NEXT:    store <2 x i64> [[TMP1]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* @m, align 8
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[TMP2]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[AND]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 2, i64 2>
; CHECK-NEXT:    [[SPEC_SELECT1:%.*]] = select i1 [[TOBOOL]], <2 x i64> [[TMP1]], <2 x i64> [[TMP3]]
; CHECK-NEXT:    [[AND4:%.*]] = and i64 [[TMP2]], 2
; CHECK-NEXT:    [[TOBOOL5:%.*]] = icmp eq i64 [[AND4]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <2 x i64> [[SPEC_SELECT1]], <i64 1, i64 1>
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL5]], <2 x i64> [[SPEC_SELECT1]], <2 x i64> [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[TOBOOL]], true
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TOBOOL5]], true
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CHECK:       8:
; CHECK-NEXT:    store <2 x i64> [[SPEC_SELECT]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    br label [[TMP9]]
; CHECK:       9:
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %1 = add nsw <2 x i64> %0, <i64 1, i64 1>
  store <2 x i64> %1, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %2 = load i64, i64* @m, align 8
  %and = and i64 %2, 1
  %tobool = icmp eq i64 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %3 = add nsw <2 x i64> %0, <i64 2, i64 2>
  store <2 x i64> %3, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %4 = phi <2 x i64> [ %1, %entry ], [ %3, %if.then ]
  %and4 = and i64 %2, 2
  %tobool5 = icmp eq i64 %and4, 0
  br i1 %tobool5, label %if.end9, label %if.then6

if.then6:                                         ; preds = %if.end
  %5 = add nsw <2 x i64> %4, <i64 1, i64 1>
  store <2 x i64> %5, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  br label %if.end9

if.end9:                                          ; preds = %if.end, %if.then6
  ret i32 0
}

define i32 @align_not_equal() local_unnamed_addr {
; CHECK-LABEL: @align_not_equal(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS:%.*]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 1, i64 1>
; CHECK-NEXT:    store <2 x i64> [[TMP1]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* @m, align 8
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[TMP2]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[AND]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 2, i64 2>
; CHECK-NEXT:    [[SPEC_SELECT1:%.*]] = select i1 [[TOBOOL]], <2 x i64> [[TMP1]], <2 x i64> [[TMP3]]
; CHECK-NEXT:    [[AND4:%.*]] = and i64 [[TMP2]], 2
; CHECK-NEXT:    [[TOBOOL5:%.*]] = icmp eq i64 [[AND4]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <2 x i64> [[SPEC_SELECT1]], <i64 1, i64 1>
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL5]], <2 x i64> [[SPEC_SELECT1]], <2 x i64> [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[TOBOOL]], true
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TOBOOL5]], true
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CHECK:       8:
; CHECK-NEXT:    store <2 x i64> [[SPEC_SELECT]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    br label [[TMP9]]
; CHECK:       9:
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %1 = add nsw <2 x i64> %0, <i64 1, i64 1>
  store <2 x i64> %1, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %2 = load i64, i64* @m, align 8
  %and = and i64 %2, 1
  %tobool = icmp eq i64 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %3 = add nsw <2 x i64> %0, <i64 2, i64 2>
  store <2 x i64> %3, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 16
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %4 = phi <2 x i64> [ %1, %entry ], [ %3, %if.then ]
  %and4 = and i64 %2, 2
  %tobool5 = icmp eq i64 %and4, 0
  br i1 %tobool5, label %if.end9, label %if.then6

if.then6:                                         ; preds = %if.end
  %5 = add nsw <2 x i64> %4, <i64 1, i64 1>
  store <2 x i64> %5, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  br label %if.end9

if.end9:                                          ; preds = %if.end, %if.then6
  ret i32 0
}

define i32 @align_single_zero() local_unnamed_addr {
; CHECK-LABEL: @align_single_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS:%.*]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 1, i64 1>
; CHECK-NEXT:    store <2 x i64> [[TMP1]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* @m, align 8
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[TMP2]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[AND]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 2, i64 2>
; CHECK-NEXT:    [[SPEC_SELECT1:%.*]] = select i1 [[TOBOOL]], <2 x i64> [[TMP1]], <2 x i64> [[TMP3]]
; CHECK-NEXT:    [[AND4:%.*]] = and i64 [[TMP2]], 2
; CHECK-NEXT:    [[TOBOOL5:%.*]] = icmp eq i64 [[AND4]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <2 x i64> [[SPEC_SELECT1]], <i64 1, i64 1>
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL5]], <2 x i64> [[SPEC_SELECT1]], <2 x i64> [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[TOBOOL]], true
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TOBOOL5]], true
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CHECK:       8:
; CHECK-NEXT:    store <2 x i64> [[SPEC_SELECT]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    br label [[TMP9]]
; CHECK:       9:
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %1 = add nsw <2 x i64> %0, <i64 1, i64 1>
  store <2 x i64> %1, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %2 = load i64, i64* @m, align 8
  %and = and i64 %2, 1
  %tobool = icmp eq i64 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %3 = add nsw <2 x i64> %0, <i64 2, i64 2>
  store <2 x i64> %3, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*)
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %4 = phi <2 x i64> [ %1, %entry ], [ %3, %if.then ]
  %and4 = and i64 %2, 2
  %tobool5 = icmp eq i64 %and4, 0
  br i1 %tobool5, label %if.end9, label %if.then6

if.then6:                                         ; preds = %if.end
  %5 = add nsw <2 x i64> %4, <i64 1, i64 1>
  store <2 x i64> %5, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  br label %if.end9

if.end9:                                          ; preds = %if.end, %if.then6
  ret i32 0
}

define i32 @align_single_zero_second_greater_default() local_unnamed_addr {
; CHECK-LABEL: @align_single_zero_second_greater_default(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS:%.*]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 1, i64 1>
; CHECK-NEXT:    store <2 x i64> [[TMP1]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* @m, align 8
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[TMP2]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[AND]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 2, i64 2>
; CHECK-NEXT:    [[SPEC_SELECT1:%.*]] = select i1 [[TOBOOL]], <2 x i64> [[TMP1]], <2 x i64> [[TMP3]]
; CHECK-NEXT:    [[AND4:%.*]] = and i64 [[TMP2]], 2
; CHECK-NEXT:    [[TOBOOL5:%.*]] = icmp eq i64 [[AND4]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <2 x i64> [[SPEC_SELECT1]], <i64 1, i64 1>
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL5]], <2 x i64> [[SPEC_SELECT1]], <2 x i64> [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[TOBOOL]], true
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TOBOOL5]], true
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CHECK:       8:
; CHECK-NEXT:    store <2 x i64> [[SPEC_SELECT]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 16
; CHECK-NEXT:    br label [[TMP9]]
; CHECK:       9:
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %1 = add nsw <2 x i64> %0, <i64 1, i64 1>
  store <2 x i64> %1, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %2 = load i64, i64* @m, align 8
  %and = and i64 %2, 1
  %tobool = icmp eq i64 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %3 = add nsw <2 x i64> %0, <i64 2, i64 2>
  store <2 x i64> %3, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 32
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %4 = phi <2 x i64> [ %1, %entry ], [ %3, %if.then ]
  %and4 = and i64 %2, 2
  %tobool5 = icmp eq i64 %and4, 0
  br i1 %tobool5, label %if.end9, label %if.then6

if.then6:                                         ; preds = %if.end
  %5 = add nsw <2 x i64> %4, <i64 1, i64 1>
  store <2 x i64> %5, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*)
  br label %if.end9

if.end9:                                          ; preds = %if.end, %if.then6
  ret i32 0
}

define i32 @align_both_zero() local_unnamed_addr {
; CHECK-LABEL: @align_both_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS:%.*]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 1, i64 1>
; CHECK-NEXT:    store <2 x i64> [[TMP1]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, i64* @m, align 8
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[TMP2]], 1
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[AND]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nsw <2 x i64> [[TMP0]], <i64 2, i64 2>
; CHECK-NEXT:    [[SPEC_SELECT1:%.*]] = select i1 [[TOBOOL]], <2 x i64> [[TMP1]], <2 x i64> [[TMP3]]
; CHECK-NEXT:    [[AND4:%.*]] = and i64 [[TMP2]], 2
; CHECK-NEXT:    [[TOBOOL5:%.*]] = icmp eq i64 [[AND4]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <2 x i64> [[SPEC_SELECT1]], <i64 1, i64 1>
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[TOBOOL5]], <2 x i64> [[SPEC_SELECT1]], <2 x i64> [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[TOBOOL]], true
; CHECK-NEXT:    [[TMP6:%.*]] = xor i1 [[TOBOOL5]], true
; CHECK-NEXT:    [[TMP7:%.*]] = or i1 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[TMP8:%.*]], label [[TMP9:%.*]]
; CHECK:       8:
; CHECK-NEXT:    store <2 x i64> [[SPEC_SELECT]], <2 x i64>* bitcast (i64* getelementptr inbounds ([[STRUCT_COUNTERS]], %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 16
; CHECK-NEXT:    br label [[TMP9]]
; CHECK:       9:
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load <2 x i64>, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %1 = add nsw <2 x i64> %0, <i64 1, i64 1>
  store <2 x i64> %1, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*), align 8
  %2 = load i64, i64* @m, align 8
  %and = and i64 %2, 1
  %tobool = icmp eq i64 %and, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %3 = add nsw <2 x i64> %0, <i64 2, i64 2>
  store <2 x i64> %3, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*)
  br label %if.end

if.end:                                           ; preds = %entry, %if.then
  %4 = phi <2 x i64> [ %1, %entry ], [ %3, %if.then ]
  %and4 = and i64 %2, 2
  %tobool5 = icmp eq i64 %and4, 0
  br i1 %tobool5, label %if.end9, label %if.then6

if.then6:                                         ; preds = %if.end
  %5 = add nsw <2 x i64> %4, <i64 1, i64 1>
  store <2 x i64> %5, <2 x i64>* bitcast (i64* getelementptr inbounds (%struct.Counters, %struct.Counters* @counters, i64 0, i32 1) to <2 x i64>*)
  br label %if.end9

if.end9:                                          ; preds = %if.end, %if.then6
  ret i32 0
}
