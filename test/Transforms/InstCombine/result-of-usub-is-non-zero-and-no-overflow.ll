; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Here we subtract two values, check that subtraction did not overflow AND
; that the result is non-zero. This can be simplified just to a comparison
; between the base and offset.

declare void @use8(i8)
declare void @use64(i64)
declare void @use1(i1)

declare {i8, i1} @llvm.usub.with.overflow(i8, i8)
declare void @useagg({i8, i1})

declare void @llvm.assume(i1)

; There is a number of base patterns..

define i1 @t0_noncanonical_ignoreme(i8 %base, i8 %offset) {
; CHECK-LABEL: @t0_noncanonical_ignoreme(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t0_noncanonical_ignoreme_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t0_noncanonical_ignoreme_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}

define i1 @t1(i8 %base, i8 %offset) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp uge i8 %base, %offset
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t1_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t1_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp uge i8 %base, %offset
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}
define i1 @t1_strict(i8 %base, i8 %offset) {
; CHECK-LABEL: @t1_strict(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ugt i8 %base, %offset ; same is valid for strict predicate
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t1_strict_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t1_strict_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ugt i8 %base, %offset ; same is valid for strict predicate
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}

define i1 @t2(i8 %base, i8 %offset) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = xor i1 [[UNDERFLOW]], true
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %no_underflow = xor i1 %underflow, -1
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t2_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t2_logical(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = xor i1 [[UNDERFLOW]], true
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %no_underflow = xor i1 %underflow, -1
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}

; Commutativity

define i1 @t3_commutability0(i8 %base, i8 %offset) {
; CHECK-LABEL: @t3_commutability0(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %offset, %base ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t3_commutability0_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t3_commutability0_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %offset, %base ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}
define i1 @t4_commutability1(i8 %base, i8 %offset) {
; CHECK-LABEL: @t4_commutability1(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp uge i8 %base, %offset
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %no_underflow, %not_null ; swapped
  ret i1 %r
}

define i1 @t4_commutability1_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t4_commutability1_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp uge i8 %base, %offset
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %no_underflow, i1 %not_null, i1 false ; swapped
  ret i1 %r
}
define i1 @t5_commutability2(i8 %base, i8 %offset) {
; CHECK-LABEL: @t5_commutability2(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %offset, %base ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %no_underflow, %not_null ; swapped
  ret i1 %r
}

define i1 @t5_commutability2_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t5_commutability2_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %no_underflow = icmp ule i8 %offset, %base ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %no_underflow, i1 %not_null, i1 false ; swapped
  ret i1 %r
}

define i1 @t6_commutability(i8 %base, i8 %offset) {
; CHECK-LABEL: @t6_commutability(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = xor i1 [[UNDERFLOW]], true
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %no_underflow = xor i1 %underflow, -1
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  %r = and i1 %no_underflow, %not_null ; swapped
  ret i1 %r
}

define i1 @t6_commutability_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t6_commutability_logical(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = xor i1 [[UNDERFLOW]], true
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %no_underflow = xor i1 %underflow, -1
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i8 %adjusted, 0
  %r = select i1 %no_underflow, i1 %not_null, i1 false ; swapped
  ret i1 %r
}

; What if we were checking the opposite question, that we either got null,
; or overflow happened?

define i1 @t7(i8 %base, i8 %offset) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ult i8 %base, %offset
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = or i1 %null, %underflow
  ret i1 %r
}

define i1 @t7_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t7_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ult i8 %base, %offset
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = select i1 %null, i1 true, i1 %underflow
  ret i1 %r
}
define i1 @t7_nonstrict(i8 %base, i8 %offset) {
; CHECK-LABEL: @t7_nonstrict(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    ret i1 [[UNDERFLOW]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ule i8 %base, %offset ; same is valid for non-strict predicate
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = or i1 %null, %underflow
  ret i1 %r
}

define i1 @t7_nonstrict_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t7_nonstrict_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    ret i1 [[UNDERFLOW]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ule i8 %base, %offset ; same is valid for non-strict predicate
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = select i1 %null, i1 true, i1 %underflow
  ret i1 %r
}

define i1 @t8(i8 %base, i8 %offset) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = or i1 [[NULL]], [[UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  %r = or i1 %null, %underflow
  ret i1 %r
}

define i1 @t8_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t8_logical(
; CHECK-NEXT:    [[AGG:%.*]] = call { i8, i1 } @llvm.usub.with.overflow.i8(i8 [[BASE:%.*]], i8 [[OFFSET:%.*]])
; CHECK-NEXT:    call void @useagg({ i8, i1 } [[AGG]])
; CHECK-NEXT:    [[ADJUSTED:%.*]] = extractvalue { i8, i1 } [[AGG]], 0
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = extractvalue { i8, i1 } [[AGG]], 1
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = or i1 [[NULL]], [[UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %agg = call {i8, i1} @llvm.usub.with.overflow(i8 %base, i8 %offset)
  call void @useagg({i8, i1} %agg)
  %adjusted = extractvalue {i8, i1} %agg, 0
  call void @use8(i8 %adjusted)
  %underflow = extractvalue {i8, i1} %agg, 1
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  %r = select i1 %null, i1 true, i1 %underflow
  ret i1 %r
}

; And these patterns also have commutative variants

define i1 @t9_commutative(i8 %base, i8 %offset) {
; CHECK-LABEL: @t9_commutative(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ult i8 %base, %adjusted ; swapped
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = or i1 %null, %underflow
  ret i1 %r
}

define i1 @t9_commutative_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @t9_commutative_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[UNDERFLOW:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[UNDERFLOW]])
; CHECK-NEXT:    [[NULL:%.*]] = icmp eq i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %underflow = icmp ult i8 %base, %adjusted ; swapped
  call void @use1(i1 %underflow)
  %null = icmp eq i8 %adjusted, 0
  call void @use1(i1 %null)
  %r = select i1 %null, i1 true, i1 %underflow
  ret i1 %r
}

;-------------------------------------------------------------------------------

define i1 @t10(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t10(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ult i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t10_logical(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t10_logical(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ult i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}
define i1 @t11_commutative(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t11_commutative(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ugt i64 %base, %adjusted ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t11_commutative_logical(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t11_commutative_logical(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ugt i64 %base, %adjusted ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}

define i1 @t12(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t12(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp eq i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp uge i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp eq i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = or i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t12_logical(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t12_logical(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp eq i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp uge i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp eq i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 true, i1 %no_underflow
  ret i1 %r
}
define i1 @t13(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t13(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp eq i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ule i64 %base, %adjusted ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp eq i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = or i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t13_logical(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t13_logical(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp eq i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i64 [[OFFSET]], [[BASE]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ule i64 %base, %adjusted ; swapped
  call void @use1(i1 %no_underflow)
  %not_null = icmp eq i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 true, i1 %no_underflow
  ret i1 %r
}

define i1 @t14_bad(i64 %base, i64 %offset) {
; CHECK-LABEL: @t14_bad(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ult i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ult i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t14_bad_logical(i64 %base, i64 %offset) {
; CHECK-LABEL: @t14_bad_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use64(i64 [[ADJUSTED]])
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ult i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    call void @use1(i1 [[NO_UNDERFLOW]])
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    call void @use1(i1 [[NOT_NULL]])
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %adjusted = sub i64 %base, %offset
  call void @use64(i64 %adjusted)
  %no_underflow = icmp ult i64 %adjusted, %base
  call void @use1(i1 %no_underflow)
  %not_null = icmp ne i64 %adjusted, 0
  call void @use1(i1 %not_null)
  %r = select i1 %not_null, i1 %no_underflow, i1 false
  ret i1 %r
}

define i1 @base_ult_offset(i8 %base, i8 %offset) {
; CHECK-LABEL: @base_ult_offset(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %not_null = icmp ne i8 %adjusted, 0
  %no_underflow = icmp ule i8 %base, %offset
  %r = and i1 %no_underflow, %not_null
  ret i1 %r
}

define i1 @base_ult_offset_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @base_ult_offset_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %not_null = icmp ne i8 %adjusted, 0
  %no_underflow = icmp ule i8 %base, %offset
  %r = select i1 %no_underflow, i1 %not_null, i1 false
  ret i1 %r
}
define i1 @base_uge_offset(i8 %base, i8 %offset) {
; CHECK-LABEL: @base_uge_offset(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %not_null = icmp eq i8 %adjusted, 0
  %no_underflow = icmp ugt i8 %base, %offset
  %r = or i1 %no_underflow, %not_null
  ret i1 %r
}

define i1 @base_uge_offset_logical(i8 %base, i8 %offset) {
; CHECK-LABEL: @base_uge_offset_logical(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i8 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[ADJUSTED]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[BASE]], [[OFFSET]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %adjusted = sub i8 %base, %offset
  call void @use8(i8 %adjusted)
  %not_null = icmp eq i8 %adjusted, 0
  %no_underflow = icmp ugt i8 %base, %offset
  %r = select i1 %no_underflow, i1 true, i1 %not_null
  ret i1 %r
}
