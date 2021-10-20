; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='default<O3>' %s -o - | FileCheck %s
define void @test_builtin_ppc_compare_and_swaplp(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: @test_builtin_ppc_compare_and_swaplp(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i64, align 8
; CHECK-NEXT:    store i64 [[A:%.*]], i64* [[A_ADDR]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = cmpxchg weak volatile i64* [[A_ADDR]], i64 [[B:%.*]], i64 [[C:%.*]] monotonic monotonic, align 8
; CHECK-NEXT:    ret void
;
entry:
  %a.addr = alloca i64, align 8
  %b.addr = alloca i64, align 8
  %c.addr = alloca i64, align 8
  store i64 %a, i64* %a.addr, align 8
  store i64 %b, i64* %b.addr, align 8
  store i64 %c, i64* %c.addr, align 8
  %0 = load i64, i64* %c.addr, align 8
  %1 = load i64, i64* %b.addr, align 8
  %2 = cmpxchg weak volatile i64* %a.addr, i64 %1, i64 %0 monotonic monotonic, align 8
  %3 = extractvalue { i64, i1 } %2, 0
  %4 = extractvalue { i64, i1 } %2, 1
  store i64 %3, i64* %b.addr, align 8
  ret void
}

define dso_local void @test_builtin_ppc_compare_and_swaplp_loop(i64* %a) {
; CHECK-LABEL: @test_builtin_ppc_compare_and_swaplp_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i64 bitcast (i64 (...)* @bar to i64 ()*)()
; CHECK-NEXT:    br label [[DO_BODY:%.*]]
; CHECK:       do.body:
; CHECK-NEXT:    [[X_0:%.*]] = phi i64 [ [[CALL]], [[ENTRY:%.*]] ], [ [[TMP1:%.*]], [[DO_BODY]] ]
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[X_0]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = cmpxchg weak volatile i64* [[A:%.*]], i64 [[X_0]], i64 [[ADD]] monotonic monotonic, align 8
; CHECK-NEXT:    [[TMP1]] = extractvalue { i64, i1 } [[TMP0]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { i64, i1 } [[TMP0]], 1
; CHECK-NEXT:    br i1 [[TMP2]], label [[DO_BODY]], label [[DO_END:%.*]]
; CHECK:       do.end:
; CHECK-NEXT:    ret void
;
entry:
  %a.addr = alloca i64*, align 8
  %x = alloca i64, align 8
  store i64* %a, i64** %a.addr, align 8
  %call = call i64 bitcast (i64 (...)* @bar to i64 ()*)()
  store i64 %call, i64* %x, align 8
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  br label %do.cond

do.cond:                                          ; preds = %do.body
  %0 = load i64*, i64** %a.addr, align 8
  %1 = load i64, i64* %x, align 8
  %add = add nsw i64 %1, 1
  %2 = load i64*, i64** %a.addr, align 8
  %3 = load i64, i64* %x, align 8
  %4 = cmpxchg weak volatile i64* %2, i64 %3, i64 %add monotonic monotonic, align 8
  %5 = extractvalue { i64, i1 } %4, 0
  %6 = extractvalue { i64, i1 } %4, 1
  store i64 %5, i64* %x, align 8
  %tobool = icmp ne i1 %6, false
  br i1 %tobool, label %do.body, label %do.end

do.end:                                           ; preds = %do.cond
  ret void
}

declare i64 @bar(...)
