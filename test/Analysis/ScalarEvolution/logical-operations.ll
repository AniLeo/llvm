; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes='print<scalar-evolution>' < %s -disable-output 2>&1 | FileCheck %s

@constant = dso_local global i8 0, align 4
@another_constant = dso_local global i8 0, align 4

define i1 @binary_or.i1(i1 %x, i1 %y) {
; CHECK-LABEL: 'binary_or.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_or.i1
; CHECK-NEXT:    %r = or i1 %x, %y
; CHECK-NEXT:    --> (%x umax %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_or.i1
;
  %r = or i1 %x, %y
  ret i1 %r
}

define i2 @binary_or.i2(i2 %x, i2 %y) {
; CHECK-LABEL: 'binary_or.i2'
; CHECK-NEXT:  Classifying expressions for: @binary_or.i2
; CHECK-NEXT:    %r = or i2 %x, %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_or.i2
;
  %r = or i2 %x, %y
  ret i2 %r
}

define i1 @binary_or.4ops.i1(i1 %x, i1 %y, i1 %z, i1 %a) {
; CHECK-LABEL: 'binary_or.4ops.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_or.4ops.i1
; CHECK-NEXT:    %t0 = or i1 %x, %y
; CHECK-NEXT:    --> (%x umax %y) U: full-set S: full-set
; CHECK-NEXT:    %t1 = or i1 %z, %a
; CHECK-NEXT:    --> (%z umax %a) U: full-set S: full-set
; CHECK-NEXT:    %r = or i1 %t0, %t1
; CHECK-NEXT:    --> (%x umax %y umax %z umax %a) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_or.4ops.i1
;
  %t0 = or i1 %x, %y
  %t1 = or i1 %z, %a
  %r = or i1 %t0, %t1
  ret i1 %r
}

define i1 @binary_and.i1(i1 %x, i1 %y) {
; CHECK-LABEL: 'binary_and.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_and.i1
; CHECK-NEXT:    %r = and i1 %x, %y
; CHECK-NEXT:    --> (%x umin %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_and.i1
;
  %r = and i1 %x, %y
  ret i1 %r
}

define i2 @binary_and.i2(i2 %x, i2 %y) {
; CHECK-LABEL: 'binary_and.i2'
; CHECK-NEXT:  Classifying expressions for: @binary_and.i2
; CHECK-NEXT:    %r = and i2 %x, %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_and.i2
;
  %r = and i2 %x, %y
  ret i2 %r
}

define i1 @binary_and.4ops.i1(i1 %x, i1 %y, i1 %z, i1 %a) {
; CHECK-LABEL: 'binary_and.4ops.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_and.4ops.i1
; CHECK-NEXT:    %t0 = and i1 %x, %y
; CHECK-NEXT:    --> (%x umin %y) U: full-set S: full-set
; CHECK-NEXT:    %t1 = and i1 %z, %a
; CHECK-NEXT:    --> (%z umin %a) U: full-set S: full-set
; CHECK-NEXT:    %r = and i1 %t0, %t1
; CHECK-NEXT:    --> (%x umin %y umin %z umin %a) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_and.4ops.i1
;
  %t0 = and i1 %x, %y
  %t1 = and i1 %z, %a
  %r = and i1 %t0, %t1
  ret i1 %r
}

define i1 @binary_xor.i1(i1 %x, i1 %y) {
; CHECK-LABEL: 'binary_xor.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_xor.i1
; CHECK-NEXT:    %r = xor i1 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_xor.i1
;
  %r = xor i1 %x, %y
  ret i1 %r
}

define i2 @binary_xor.i2(i2 %x, i2 %y) {
; CHECK-LABEL: 'binary_xor.i2'
; CHECK-NEXT:  Classifying expressions for: @binary_xor.i2
; CHECK-NEXT:    %r = xor i2 %x, %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_xor.i2
;
  %r = xor i2 %x, %y
  ret i2 %r
}

define i1 @binary_xor.4ops.i1(i1 %x, i1 %y, i1 %z, i1 %a) {
; CHECK-LABEL: 'binary_xor.4ops.i1'
; CHECK-NEXT:  Classifying expressions for: @binary_xor.4ops.i1
; CHECK-NEXT:    %t0 = xor i1 %x, %y
; CHECK-NEXT:    --> (%x + %y) U: full-set S: full-set
; CHECK-NEXT:    %t1 = xor i1 %z, %a
; CHECK-NEXT:    --> (%z + %a) U: full-set S: full-set
; CHECK-NEXT:    %r = xor i1 %t0, %t1
; CHECK-NEXT:    --> (%x + %y + %z + %a) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @binary_xor.4ops.i1
;
  %t0 = xor i1 %x, %y
  %t1 = xor i1 %z, %a
  %r = xor i1 %t0, %t1
  ret i1 %r
}

define i1 @logical_or(i1 %x, i1 %y) {
; CHECK-LABEL: 'logical_or'
; CHECK-NEXT:  Classifying expressions for: @logical_or
; CHECK-NEXT:    %r = select i1 %x, i1 true, i1 %y
; CHECK-NEXT:    --> (true + ((true + %x) umin_seq (true + %y))) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @logical_or
;
  %r = select i1 %x, i1 true, i1 %y
  ret i1 %r
}

define i1 @logical_and(i1 %x, i1 %y) {
; CHECK-LABEL: 'logical_and'
; CHECK-NEXT:  Classifying expressions for: @logical_and
; CHECK-NEXT:    %r = select i1 %x, i1 %y, i1 false
; CHECK-NEXT:    --> (%x umin_seq %y) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @logical_and
;
  %r = select i1 %x, i1 %y, i1 false
  ret i1 %r
}

define i1 @select_x_or_false(i1 %c, i1 %x) {
; CHECK-LABEL: 'select_x_or_false'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_false
; CHECK-NEXT:    %r = select i1 %c, i1 %x, i1 false
; CHECK-NEXT:    --> (%c umin_seq %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_false
;
  %r = select i1 %c, i1 %x, i1 false
  ret i1 %r
}

define i1 @select_false_or_x(i1 %c, i1 %x) {
; CHECK-LABEL: 'select_false_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_false_or_x
; CHECK-NEXT:    %r = select i1 %c, i1 false, i1 %x
; CHECK-NEXT:    --> ((true + %c) umin_seq %x) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_false_or_x
;
  %r = select i1 %c, i1 false, i1 %x
  ret i1 %r
}

define i1 @select_x_or_true(i1 %c, i1 %x) {
; CHECK-LABEL: 'select_x_or_true'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_true
; CHECK-NEXT:    %r = select i1 %c, i1 %x, i1 true
; CHECK-NEXT:    --> (true + (%c umin_seq (true + %x))) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_true
;
  %r = select i1 %c, i1 %x, i1 true
  ret i1 %r
}

define i1 @select_true_or_x(i1 %c, i1 %x) {
; CHECK-LABEL: 'select_true_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_true_or_x
; CHECK-NEXT:    %r = select i1 %c, i1 true, i1 %x
; CHECK-NEXT:    --> (true + ((true + %c) umin_seq (true + %x))) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_true_or_x
;
  %r = select i1 %c, i1 true, i1 %x
  ret i1 %r
}

define i32 @select_x_or_zero(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_zero'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_zero
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 0
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_zero
;
  %r = select i1 %c, i32 %x, i32 0
  ret i32 %r
}

define i32 @select_zero_or_x(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_zero_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_zero_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 0, i32 %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_zero_or_x
;
  %r = select i1 %c, i32 0, i32 %x
  ret i32 %r
}

define i32 @select_x_or_allones(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_allones'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_allones
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 -1
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_allones
;
  %r = select i1 %c, i32 %x, i32 -1
  ret i32 %r
}

define i32 @select_allones_or_x(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_allones_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_allones_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 -1, i32 %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_allones_or_x
;
  %r = select i1 %c, i32 -1, i32 %x
  ret i32 %r
}

define i32 @select_x_or_intmax(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_intmax'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_intmax
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 2147483647
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_intmax
;
  %r = select i1 %c, i32 %x, i32 2147483647
  ret i32 %r
}

define i32 @select_intmax_or_x(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_intmax_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_intmax_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 2147483647, i32 %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_intmax_or_x
;
  %r = select i1 %c, i32 2147483647, i32 %x
  ret i32 %r
}

define i32 @select_x_or_intmin(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_intmin'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_intmin
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 -2147483648
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_intmin
;
  %r = select i1 %c, i32 %x, i32 -2147483648
  ret i32 %r
}

define i32 @select_intmin_or_x(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_intmin_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_intmin_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 -2147483648, i32 %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_intmin_or_x
;
  %r = select i1 %c, i32 -2147483648, i32 %x
  ret i32 %r
}

define i32 @select_x_or_constant(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_constant'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_constant
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 42
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_constant
;
  %r = select i1 %c, i32 %x, i32 42
  ret i32 %r
}

define i32 @select_constant_or_x(i1 %c, i32 %y) {
; CHECK-LABEL: 'select_constant_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_constant_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 42, i32 %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_constant_or_x
;
  %r = select i1 %c, i32 42, i32 %y
  ret i32 %r
}

define i32 @select_between_constants(i1 %c, i32 %y) {
; CHECK-LABEL: 'select_between_constants'
; CHECK-NEXT:  Classifying expressions for: @select_between_constants
; CHECK-NEXT:    %r = select i1 %c, i32 42, i32 24
; CHECK-NEXT:    --> %r U: [8,59) S: [8,59)
; CHECK-NEXT:  Determining loop execution counts for: @select_between_constants
;
  %r = select i1 %c, i32 42, i32 24
  ret i32 %r
}

define i32 @select_x_or_y(i1 %c, i32 %x, i32 %y) {
; CHECK-LABEL: 'select_x_or_y'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_y
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_y
;
  %r = select i1 %c, i32 %x, i32 %y
  ret i32 %r
}

define i32 @select_x_or_y__noundef(i1 %c, i32 noundef %x, i32 noundef %y) {
; CHECK-LABEL: 'select_x_or_y__noundef'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_y__noundef
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 %y
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_y__noundef
;
  %r = select i1 %c, i32 %x, i32 %y
  ret i32 %r
}

define i32 @select_x_or_constantexpr(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_constantexpr'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_constantexpr
; CHECK-NEXT:    %r = select i1 %c, i32 %x, i32 ptrtoint (i8* @constant to i32)
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_constantexpr
;
  %r = select i1 %c, i32 %x, i32 ptrtoint (i8* @constant to i32)
  ret i32 %r
}

define i32 @select_constantexpr_or_x(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_constantexpr_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_constantexpr_or_x
; CHECK-NEXT:    %r = select i1 %c, i32 ptrtoint (i8* @constant to i32), i32 %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_constantexpr_or_x
;
  %r = select i1 %c, i32 ptrtoint (i8* @constant to i32), i32 %x
  ret i32 %r
}

define i8* @select_x_or_nullptr(i1 %c, i8* %x) {
; CHECK-LABEL: 'select_x_or_nullptr'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_nullptr
; CHECK-NEXT:    %r = select i1 %c, i8* %x, i8* null
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_nullptr
;
  %r = select i1 %c, i8* %x, i8* null
  ret i8* %r
}

define i8* @select_null_or_x(i1 %c, i8* %x) {
; CHECK-LABEL: 'select_null_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_null_or_x
; CHECK-NEXT:    %r = select i1 %c, i8* null, i8* %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_null_or_x
;
  %r = select i1 %c, i8* null, i8* %x
  ret i8* %r
}

define i8* @select_x_or_constantptr(i1 %c, i8* %x) {
; CHECK-LABEL: 'select_x_or_constantptr'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_constantptr
; CHECK-NEXT:    %r = select i1 %c, i8* %x, i8* @constant
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_constantptr
;
  %r = select i1 %c, i8* %x, i8* @constant
  ret i8* %r
}

define i8* @select_constantptr_or_x(i1 %c, i8* %x) {
; CHECK-LABEL: 'select_constantptr_or_x'
; CHECK-NEXT:  Classifying expressions for: @select_constantptr_or_x
; CHECK-NEXT:    %r = select i1 %c, i8* @constant, i8* %x
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_constantptr_or_x
;
  %r = select i1 %c, i8* @constant, i8* %x
  ret i8* %r
}

define i8* @select_between_constantptrs(i1 %c, i8* %x) {
; CHECK-LABEL: 'select_between_constantptrs'
; CHECK-NEXT:  Classifying expressions for: @select_between_constantptrs
; CHECK-NEXT:    %r = select i1 %c, i8* @constant, i8* @another_constant
; CHECK-NEXT:    --> %r U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:  Determining loop execution counts for: @select_between_constantptrs
;
  %r = select i1 %c, i8* @constant, i8* @another_constant
  ret i8* %r
}

define i8* @tautological_select() {
; CHECK-LABEL: 'tautological_select'
; CHECK-NEXT:  Classifying expressions for: @tautological_select
; CHECK-NEXT:    %r = getelementptr i8, i8* @constant, i32 0
; CHECK-NEXT:    --> @constant U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:  Determining loop execution counts for: @tautological_select
;
  %r = getelementptr i8, i8* select (i1 true, i8* @constant, i8* @another_constant), i32 0
  ret i8* %r
}

define i8* @tautological_select_like_phi(i32 %tc) {
; CHECK-LABEL: 'tautological_select_like_phi'
; CHECK-NEXT:  Classifying expressions for: @tautological_select_like_phi
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.next, %latch ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: [0,101) S: [0,101) Exits: 100 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %r = phi i8* [ @constant, %truebb ], [ @another_constant, %falsebb ]
; CHECK-NEXT:    --> %r U: [0,-3) S: [-9223372036854775808,9223372036854775805) Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %iv.next = add i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: [1,102) S: [1,102) Exits: 101 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @tautological_select_like_phi
; CHECK-NEXT:  Loop %loop: backedge-taken count is 100
; CHECK-NEXT:  Loop %loop: max backedge-taken count is 100
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is 100
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 101
;
entry:
  br label %loop

loop:
  %iv = phi i32[ 0, %entry ], [ %iv.next, %latch ]
  br i1 true, label %truebb, label %falsebb

truebb:
  br label %latch

falsebb:
  br label %latch

latch:
  %r = phi i8* [ @constant, %truebb], [ @another_constant, %falsebb]
  %iv.next = add i32 %iv, 1
  %done = icmp eq i32 %iv, 100
  br i1 %done, label %end, label %loop

end:
  ret i8* %r
}

define i32 @umin_seq_x_y(i32 %x, i32 %y) {
; CHECK-LABEL: 'umin_seq_x_y'
; CHECK-NEXT:  Classifying expressions for: @umin_seq_x_y
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %y, i32 %x)
; CHECK-NEXT:    --> (%x umin %y) U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %x.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @umin_seq_x_y
;
  %umin = call i32 @llvm.umin(i32 %y, i32 %x)
  %x.is.zero = icmp eq i32 %x, 0
  %r = select i1 %x.is.zero, i32 0, i32 %umin
  ret i32 %r
}

define i32 @umin_seq_y_x(i32 %x, i32 %y) {
; CHECK-LABEL: 'umin_seq_y_x'
; CHECK-NEXT:  Classifying expressions for: @umin_seq_y_x
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %x, i32 %y)
; CHECK-NEXT:    --> (%x umin %y) U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %x.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @umin_seq_y_x
;
  %umin = call i32 @llvm.umin(i32 %x, i32 %y)
  %x.is.zero = icmp eq i32 %y, 0
  %r = select i1 %x.is.zero, i32 0, i32 %umin
  ret i32 %r
}

define i32 @umin_seq_x_y_z(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: 'umin_seq_x_y_z'
; CHECK-NEXT:  Classifying expressions for: @umin_seq_x_y_z
; CHECK-NEXT:    %umin0 = call i32 @llvm.umin.i32(i32 %z, i32 %x)
; CHECK-NEXT:    --> (%x umin %z) U: full-set S: full-set
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %umin0, i32 %y)
; CHECK-NEXT:    --> (%x umin %y umin %z) U: full-set S: full-set
; CHECK-NEXT:    %r0 = select i1 %y.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r0 U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %x.is.zero, i32 0, i32 %r0
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @umin_seq_x_y_z
;
  %umin0 = call i32 @llvm.umin(i32 %z, i32 %x)
  %umin = call i32 @llvm.umin(i32 %umin0, i32 %y)
  %x.is.zero = icmp eq i32 %x, 0
  %y.is.zero = icmp eq i32 %y, 0
  %r0 = select i1 %y.is.zero, i32 0, i32 %umin
  %r = select i1 %x.is.zero, i32 0, i32 %r0
  ret i32 %r
}

define i32 @select_x_or_zero_expanded(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_zero_expanded'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_zero_expanded
; CHECK-NEXT:    %c.splat = sext i1 %c to i32
; CHECK-NEXT:    --> (sext i1 %c to i32) U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c.splat, i32 %x)
; CHECK-NEXT:    --> ((sext i1 %c to i32) umin %x) U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %v0.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_zero_expanded
;
  %c.splat = sext i1 %c to i32
  %umin = call i32 @llvm.umin(i32 %c.splat, i32 %x)
  %v0.is.zero = icmp eq i32 %c.splat, 0
  %r = select i1 %v0.is.zero, i32 0, i32 %umin
  ret i32 %r
}

define i32 @select_zero_or_x_expanded(i1 %c, i32 %y) {
; CHECK-LABEL: 'select_zero_or_x_expanded'
; CHECK-NEXT:  Classifying expressions for: @select_zero_or_x_expanded
; CHECK-NEXT:    %c.splat = sext i1 %c to i32
; CHECK-NEXT:    --> (sext i1 %c to i32) U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %c.splat.not = xor i32 %c.splat, -1
; CHECK-NEXT:    --> (-1 + (-1 * (sext i1 %c to i32))<nsw>)<nsw> U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c.splat.not, i32 %y)
; CHECK-NEXT:    --> ((-1 + (-1 * (sext i1 %c to i32))<nsw>)<nsw> umin %y) U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %v0.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_zero_or_x_expanded
;
  %c.splat = sext i1 %c to i32
  %c.splat.not = xor i32 %c.splat, -1
  %umin = call i32 @llvm.umin(i32 %c.splat.not, i32 %y)
  %v0.is.zero = icmp eq i32 %c.splat.not, 0
  %r = select i1 %v0.is.zero, i32 0, i32 %umin
  ret i32 %r
}
define i32 @select_zero_or_x_expanded2(i1 %c, i32 %y) {
; CHECK-LABEL: 'select_zero_or_x_expanded2'
; CHECK-NEXT:  Classifying expressions for: @select_zero_or_x_expanded2
; CHECK-NEXT:    %c.not = xor i1 %c, true
; CHECK-NEXT:    --> (true + %c) U: full-set S: full-set
; CHECK-NEXT:    %c.not.splat = sext i1 %c.not to i32
; CHECK-NEXT:    --> (sext i1 (true + %c) to i32) U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c.not.splat, i32 %y)
; CHECK-NEXT:    --> ((sext i1 (true + %c) to i32) umin %y) U: full-set S: full-set
; CHECK-NEXT:    %r = select i1 %v0.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_zero_or_x_expanded2
;
  %c.not = xor i1 %c, -1
  %c.not.splat = sext i1 %c.not to i32
  %umin = call i32 @llvm.umin(i32 %c.not.splat, i32 %y)
  %v0.is.zero = icmp eq i32 %c.not.splat, 0
  %r = select i1 %v0.is.zero, i32 0, i32 %umin
  ret i32 %r
}

define i32 @select_x_or_constant_expanded(i1 %c, i32 %x) {
; CHECK-LABEL: 'select_x_or_constant_expanded'
; CHECK-NEXT:  Classifying expressions for: @select_x_or_constant_expanded
; CHECK-NEXT:    %c.splat = sext i1 %c to i32
; CHECK-NEXT:    --> (sext i1 %c to i32) U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %x.off = sub i32 %x, 42
; CHECK-NEXT:    --> (-42 + %x) U: full-set S: full-set
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c.splat, i32 %x.off)
; CHECK-NEXT:    --> ((sext i1 %c to i32) umin (-42 + %x)) U: full-set S: full-set
; CHECK-NEXT:    %r.off = select i1 %v0.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r.off U: full-set S: full-set
; CHECK-NEXT:    %r = add i32 %r.off, 42
; CHECK-NEXT:    --> (42 + %r.off) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_x_or_constant_expanded
;
  %c.splat = sext i1 %c to i32
  %x.off = sub i32 %x, 42
  %umin = call i32 @llvm.umin(i32 %c.splat, i32 %x.off)
  %v0.is.zero = icmp eq i32 %c.splat, 0
  %r.off = select i1 %v0.is.zero, i32 0, i32 %umin
  %r = add i32 %r.off, 42
  ret i32 %r
}

define i32 @select_constant_or_y_expanded(i1 %c, i32 %y) {
; CHECK-LABEL: 'select_constant_or_y_expanded'
; CHECK-NEXT:  Classifying expressions for: @select_constant_or_y_expanded
; CHECK-NEXT:    %c.splat = sext i1 %c to i32
; CHECK-NEXT:    --> (sext i1 %c to i32) U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %c.splat.not = xor i32 %c.splat, -1
; CHECK-NEXT:    --> (-1 + (-1 * (sext i1 %c to i32))<nsw>)<nsw> U: [-1,1) S: [-1,1)
; CHECK-NEXT:    %y.off = sub i32 %y, 42
; CHECK-NEXT:    --> (-42 + %y) U: full-set S: full-set
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c.splat.not, i32 %y.off)
; CHECK-NEXT:    --> ((-42 + %y) umin (-1 + (-1 * (sext i1 %c to i32))<nsw>)<nsw>) U: full-set S: full-set
; CHECK-NEXT:    %r.off = select i1 %v0.is.zero, i32 0, i32 %umin
; CHECK-NEXT:    --> %r.off U: full-set S: full-set
; CHECK-NEXT:    %r = add i32 %r.off, 42
; CHECK-NEXT:    --> (42 + %r.off) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @select_constant_or_y_expanded
;
  %c.splat = sext i1 %c to i32
  %c.splat.not = xor i32 %c.splat, -1
  %y.off = sub i32 %y, 42
  %umin = call i32 @llvm.umin(i32 %c.splat.not, i32 %y.off)
  %v0.is.zero = icmp eq i32 %c.splat.not, 0
  %r.off = select i1 %v0.is.zero, i32 0, i32 %umin
  %r = add i32 %r.off, 42
  ret i32 %r
}

declare i32 @llvm.umin(i32, i32)
