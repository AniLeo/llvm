; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -enable-new-pm=0 -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=20 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=19 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -enable-new-pm=0 -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
;
; Test for multiple potential values
;
; potential-test 1
; bool iszero(int c) { return c == 0; }
; bool potential_test1(bool c) { return iszero(c ? 1 : -1); }

define internal i1 @iszero1(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@iszero1
; IS__CGSCC____-SAME: () [[ATTR0:#.*]] {
; IS__CGSCC____-NEXT:    ret i1 undef
;
  %cmp = icmp eq i32 %c, 0
  ret i1 %cmp
}

define i1 @potential_test1(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test1
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR0:#.*]] {
; IS__TUNIT____-NEXT:    ret i1 false
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test1
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 false
;
  %arg = select i1 %c, i32 -1, i32 1
  %ret = call i1 @iszero1(i32 %arg)
  ret i1 %ret
}


; potential-test 2
;
; potential values of argument of iszero are {1,-1}
; potential value of returned value of iszero is 0
;
; int call_with_two_values(int x) { return iszero(x) + iszero(-x); }
; int potential_test2(int x) { return call_with_two_values(1) + call_with_two_values(-1); }

define internal i32 @iszero2(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@iszero2
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 undef
;
  %cmp = icmp eq i32 %c, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define internal i32 @call_with_two_values(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@call_with_two_values
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 undef
;
  %csret1 = call i32 @iszero2(i32 %c)
  %minusc = sub i32 0, %c
  %csret2 = call i32 @iszero2(i32 %minusc)
  %ret = add i32 %csret1, %csret2
  ret i32 %ret
}

define i32 @potential_test2(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test2
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test2
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 0
;
  %csret1 = call i32 @call_with_two_values(i32 1)
  %csret2 = call i32 @call_with_two_values(i32 -1)
  %ret = add i32 %csret1, %csret2
  ret i32 %ret
}


; potential-test 3
;
; potential values of returned value of f are {0,1}
; potential values of argument of g are {0,1}
; potential value of returned value of g is 1
; then returned value of g can be simplified
;
; int zero_or_one(int c) { return c < 2; }
; int potential_test3() { return zero_or_one(iszero(0))+zero_or_one(iszero(1)); }

define internal i32 @iszero3(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@iszero3
; IS__TUNIT____-SAME: (i32 noundef [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__TUNIT____-NEXT:    [[RET:%.*]] = zext i1 [[CMP]] to i32
; IS__TUNIT____-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@iszero3
; IS__CGSCC____-SAME: (i32 noundef [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__CGSCC____-NEXT:    [[RET:%.*]] = zext i1 [[CMP]] to i32
; IS__CGSCC____-NEXT:    ret i32 [[RET]]
;
  %cmp = icmp eq i32 %c, 0
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define internal i32 @less_than_two(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@less_than_two
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[CMP:%.*]] = icmp slt i32 [[C]], 2
; IS__TUNIT____-NEXT:    [[RET:%.*]] = zext i1 [[CMP]] to i32
; IS__TUNIT____-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@less_than_two
; IS__CGSCC____-SAME: (i32 noundef [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[CMP:%.*]] = icmp slt i32 [[C]], 2
; IS__CGSCC____-NEXT:    [[RET:%.*]] = zext i1 [[CMP]] to i32
; IS__CGSCC____-NEXT:    ret i32 [[RET]]
;
  %cmp = icmp slt i32 %c, 2
  %ret = zext i1 %cmp to i32
  ret i32 %ret
}

define i32 @potential_test3() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test3
; IS__TUNIT_OPM-SAME: () [[ATTR0:#.*]] {
; IS__TUNIT_OPM-NEXT:    [[CMP1:%.*]] = call i32 @iszero3(i32 noundef 0) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[TRUE1:%.*]] = call i32 @less_than_two(i32 [[CMP1]]) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[CMP2:%.*]] = call i32 @iszero3(i32 noundef 1) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[TRUE2:%.*]] = call i32 @less_than_two(i32 [[CMP2]]) [[ATTR0]]
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = add i32 [[TRUE1]], [[TRUE2]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test3
; IS__TUNIT_NPM-SAME: () [[ATTR0:#.*]] {
; IS__TUNIT_NPM-NEXT:    [[CMP1:%.*]] = call i32 @iszero3(i32 noundef 0) [[ATTR0]], [[RNG0:!range !.*]]
; IS__TUNIT_NPM-NEXT:    [[TRUE1:%.*]] = call i32 @less_than_two(i32 [[CMP1]]) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    [[CMP2:%.*]] = call i32 @iszero3(i32 noundef 1) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    [[TRUE2:%.*]] = call i32 @less_than_two(i32 [[CMP2]]) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = add i32 [[TRUE1]], [[TRUE2]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test3
; IS__CGSCC_OPM-SAME: () [[ATTR0:#.*]] {
; IS__CGSCC_OPM-NEXT:    [[CMP1:%.*]] = call noundef i32 @iszero3(i32 noundef 0) [[ATTR2:#.*]]
; IS__CGSCC_OPM-NEXT:    [[TRUE1:%.*]] = call i32 @less_than_two(i32 noundef [[CMP1]]) [[ATTR2]], [[RNG0:!range !.*]]
; IS__CGSCC_OPM-NEXT:    [[CMP2:%.*]] = call noundef i32 @iszero3(i32 noundef 1) [[ATTR2]]
; IS__CGSCC_OPM-NEXT:    [[TRUE2:%.*]] = call i32 @less_than_two(i32 noundef [[CMP2]]) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = add i32 [[TRUE1]], [[TRUE2]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test3
; IS__CGSCC_NPM-SAME: () [[ATTR0:#.*]] {
; IS__CGSCC_NPM-NEXT:    [[CMP1:%.*]] = call noundef i32 @iszero3(i32 noundef 0) [[ATTR1:#.*]], [[RNG0:!range !.*]]
; IS__CGSCC_NPM-NEXT:    [[TRUE1:%.*]] = call i32 @less_than_two(i32 noundef [[CMP1]]) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    [[CMP2:%.*]] = call noundef i32 @iszero3(i32 noundef 1) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    [[TRUE2:%.*]] = call i32 @less_than_two(i32 noundef [[CMP2]]) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = add i32 [[TRUE1]], [[TRUE2]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[RET]]
;
  %cmp1 = call i32 @iszero3(i32 0)
  %true1 = call i32 @less_than_two(i32 %cmp1)
  %cmp2 = call i32 @iszero3(i32 1)
  %true2 = call i32 @less_than_two(i32 %cmp2)
  %ret = add i32 %true1, %true2
  ret i32 %ret
}


; potential-test 4,5
;
; simplified
; int potential_test4(int c) { return return1or3(c) == 2; }
; int potential_test5(int c) { return return1or3(c) == return2or4(c); }
;
; not simplified
; int potential_test6(int c) { return return1or3(c) == 3; }
; int potential_test7(int c) { return return1or3(c) == return3or4(c); }

define i32 @potential_test4(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test4
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test4
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 0
;
  %csret = call i32 @return1or3(i32 %c)
  %false = icmp eq i32 %csret, 2
  %ret = zext i1 %false to i32
  ret i32 %ret
}

define i32 @potential_test5(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test5
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test5
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 0
;
  %csret1 = call i32 @return1or3(i32 %c)
  %csret2 = call i32 @return2or4(i32 %c)
  %false = icmp eq i32 %csret1, %csret2
  %ret = zext i1 %false to i32
  ret i32 %ret
}

define i1 @potential_test6(i32 %c) {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test6
; IS__TUNIT_OPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR0]], [[RNG0:!range !.*]]
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], 3
; IS__TUNIT_OPM-NEXT:    ret i1 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test6
; IS__TUNIT_NPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR0]], [[RNG1:!range !.*]]
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], 3
; IS__TUNIT_NPM-NEXT:    ret i1 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test6
; IS__CGSCC_OPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR2]], [[RNG1:!range !.*]]
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], 3
; IS__CGSCC_OPM-NEXT:    ret i1 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test6
; IS__CGSCC_NPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR1]], [[RNG1:!range !.*]]
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], 3
; IS__CGSCC_NPM-NEXT:    ret i1 [[RET]]
;
  %csret1 = call i32 @return1or3(i32 %c)
  %ret = icmp eq i32 %csret1, 3
  ret i1 %ret
}

define i1 @potential_test7(i32 %c) {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test7
; IS__TUNIT_OPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR0]], [[RNG0]]
; IS__TUNIT_OPM-NEXT:    [[CSRET2:%.*]] = call i32 @return3or4(i32 [[C]]) [[ATTR0]], [[RNG1:!range !.*]]
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], [[CSRET2]]
; IS__TUNIT_OPM-NEXT:    ret i1 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test7
; IS__TUNIT_NPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR0]], [[RNG1]]
; IS__TUNIT_NPM-NEXT:    [[CSRET2:%.*]] = call i32 @return3or4(i32 [[C]]) [[ATTR0]], [[RNG2:!range !.*]]
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], [[CSRET2]]
; IS__TUNIT_NPM-NEXT:    ret i1 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test7
; IS__CGSCC_OPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR2]], [[RNG1]]
; IS__CGSCC_OPM-NEXT:    [[CSRET2:%.*]] = call i32 @return3or4(i32 [[C]]) [[ATTR2]], [[RNG2:!range !.*]]
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], [[CSRET2]]
; IS__CGSCC_OPM-NEXT:    ret i1 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test7
; IS__CGSCC_NPM-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[CSRET1:%.*]] = call i32 @return1or3(i32 [[C]]) [[ATTR1]], [[RNG1]]
; IS__CGSCC_NPM-NEXT:    [[CSRET2:%.*]] = call i32 @return3or4(i32 [[C]]) [[ATTR1]], [[RNG2:!range !.*]]
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = icmp eq i32 [[CSRET1]], [[CSRET2]]
; IS__CGSCC_NPM-NEXT:    ret i1 [[RET]]
;
  %csret1 = call i32 @return1or3(i32 %c)
  %csret2 = call i32 @return3or4(i32 %c)
  %ret = icmp eq i32 %csret1, %csret2
  ret i1 %ret
}

define internal i32 @return1or3(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@return1or3
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__TUNIT____-NEXT:    [[RET:%.*]] = select i1 [[CMP]], i32 1, i32 3
; IS__TUNIT____-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@return1or3
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__CGSCC____-NEXT:    [[RET:%.*]] = select i1 [[CMP]], i32 1, i32 3
; IS__CGSCC____-NEXT:    ret i32 [[RET]]
;
  %cmp = icmp eq i32 %c, 0
  %ret = select i1 %cmp, i32 1, i32 3
  ret i32 %ret
}

define internal i32 @return2or4(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@return2or4
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 undef
;
  %cmp = icmp eq i32 %c, 0
  %ret = select i1 %cmp, i32 2, i32 4
  ret i32 %ret
}

define internal i32 @return3or4(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@return3or4
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__TUNIT____-NEXT:    [[RET:%.*]] = select i1 [[CMP]], i32 3, i32 4
; IS__TUNIT____-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@return3or4
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], 0
; IS__CGSCC____-NEXT:    [[RET:%.*]] = select i1 [[CMP]], i32 3, i32 4
; IS__CGSCC____-NEXT:    ret i32 [[RET]]
;
  %cmp = icmp eq i32 %c, 0
  %ret = select i1 %cmp, i32 3, i32 4
  ret i32 %ret
}

; potential-test 8
;
; propagate argument to callsite argument

define internal i1 @cmp_with_four(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@cmp_with_four
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 undef
;
  %cmp = icmp eq i32 %c, 4
  ret i1 %cmp
}

define internal i1 @wrapper(i32 %c) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@wrapper
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 undef
;
  %ret = call i1 @cmp_with_four(i32 %c)
  ret i1 %ret
}

define i1 @potential_test8() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test8
; IS__TUNIT____-SAME: () [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i1 false
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test8
; IS__CGSCC____-SAME: () [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 false
;
  %res1 = call i1 @wrapper(i32 1)
  %res3 = call i1 @wrapper(i32 3)
  %res5 = call i1 @wrapper(i32 5)
  %res13 = or i1 %res1, %res3
  %res135 =  or i1 %res13, %res5
  ret i1 %res135
}

define i1 @potential_test9() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test9
; IS__TUNIT_OPM-SAME: () [[ATTR1:#.*]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    br label [[COND:%.*]]
; IS__TUNIT_OPM:       cond:
; IS__TUNIT_OPM-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_1:%.*]], [[INC:%.*]] ]
; IS__TUNIT_OPM-NEXT:    [[C_0:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ [[C_1:%.*]], [[INC]] ]
; IS__TUNIT_OPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 10
; IS__TUNIT_OPM-NEXT:    br i1 [[CMP]], label [[BODY:%.*]], label [[END:%.*]]
; IS__TUNIT_OPM:       body:
; IS__TUNIT_OPM-NEXT:    [[C_1]] = mul i32 [[C_0]], -1
; IS__TUNIT_OPM-NEXT:    br label [[INC]]
; IS__TUNIT_OPM:       inc:
; IS__TUNIT_OPM-NEXT:    [[I_1]] = add i32 [[I_0]], 1
; IS__TUNIT_OPM-NEXT:    br label [[COND]]
; IS__TUNIT_OPM:       end:
; IS__TUNIT_OPM-NEXT:    ret i1 false
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test9
; IS__TUNIT_NPM-SAME: () [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    br label [[COND:%.*]]
; IS__TUNIT_NPM:       cond:
; IS__TUNIT_NPM-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_1:%.*]], [[INC:%.*]] ]
; IS__TUNIT_NPM-NEXT:    [[C_0:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ [[C_1:%.*]], [[INC]] ]
; IS__TUNIT_NPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 10
; IS__TUNIT_NPM-NEXT:    br i1 [[CMP]], label [[BODY:%.*]], label [[END:%.*]]
; IS__TUNIT_NPM:       body:
; IS__TUNIT_NPM-NEXT:    [[C_1]] = mul i32 [[C_0]], -1
; IS__TUNIT_NPM-NEXT:    br label [[INC]]
; IS__TUNIT_NPM:       inc:
; IS__TUNIT_NPM-NEXT:    [[I_1]] = add i32 [[I_0]], 1
; IS__TUNIT_NPM-NEXT:    br label [[COND]]
; IS__TUNIT_NPM:       end:
; IS__TUNIT_NPM-NEXT:    ret i1 false
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test9
; IS__CGSCC_OPM-SAME: () [[ATTR1:#.*]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    br label [[COND:%.*]]
; IS__CGSCC_OPM:       cond:
; IS__CGSCC_OPM-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_1:%.*]], [[INC:%.*]] ]
; IS__CGSCC_OPM-NEXT:    [[C_0:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ [[C_1:%.*]], [[INC]] ]
; IS__CGSCC_OPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 10
; IS__CGSCC_OPM-NEXT:    br i1 [[CMP]], label [[BODY:%.*]], label [[END:%.*]]
; IS__CGSCC_OPM:       body:
; IS__CGSCC_OPM-NEXT:    [[C_1]] = mul i32 [[C_0]], -1
; IS__CGSCC_OPM-NEXT:    br label [[INC]]
; IS__CGSCC_OPM:       inc:
; IS__CGSCC_OPM-NEXT:    [[I_1]] = add i32 [[I_0]], 1
; IS__CGSCC_OPM-NEXT:    br label [[COND]]
; IS__CGSCC_OPM:       end:
; IS__CGSCC_OPM-NEXT:    ret i1 false
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test9
; IS__CGSCC_NPM-SAME: () [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    br label [[COND:%.*]]
; IS__CGSCC_NPM:       cond:
; IS__CGSCC_NPM-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I_1:%.*]], [[INC:%.*]] ]
; IS__CGSCC_NPM-NEXT:    [[C_0:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ [[C_1:%.*]], [[INC]] ]
; IS__CGSCC_NPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 10
; IS__CGSCC_NPM-NEXT:    br i1 [[CMP]], label [[BODY:%.*]], label [[END:%.*]]
; IS__CGSCC_NPM:       body:
; IS__CGSCC_NPM-NEXT:    [[C_1]] = mul i32 [[C_0]], -1
; IS__CGSCC_NPM-NEXT:    br label [[INC]]
; IS__CGSCC_NPM:       inc:
; IS__CGSCC_NPM-NEXT:    [[I_1]] = add i32 [[I_0]], 1
; IS__CGSCC_NPM-NEXT:    br label [[COND]]
; IS__CGSCC_NPM:       end:
; IS__CGSCC_NPM-NEXT:    ret i1 false
;
entry:
  br label %cond
cond:
  %i.0 = phi i32 [0, %entry], [%i.1, %inc]
  %c.0 = phi i32 [1, %entry], [%c.1, %inc]
  %cmp = icmp slt i32 %i.0, 10
  br i1 %cmp, label %body, label %end
body:
  %c.1 = mul i32 %c.0, -1
  br label %inc
inc:
  %i.1 = add i32 %i.0, 1
  br label %cond
end:
  %ret = icmp eq i32 %c.0, 0
  ret i1 %ret
}

; Test 10
; FIXME: potential returned values of @may_return_undef is {1, -1}
;        and returned value of @potential_test10 can be simplified to 0(false)

define internal i32 @may_return_undef(i32 %c) {
  switch i32 %c, label %otherwise [i32 1, label %a
  i32 -1, label %b]
a:
  ret i32 1
b:
  ret i32 -1
otherwise:
  ret i32 undef
}

define i1 @potential_test10(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test10
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i1 false
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test10
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 false
;
  %ret = call i32 @may_return_undef(i32 %c)
  %cmp = icmp eq i32 %ret, 0
  ret i1 %cmp
}

define i32 @optimize_undef_1(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@optimize_undef_1
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    ret i32 0
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@optimize_undef_1
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 0
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    ret i32 1
;
  br i1 %c, label %t, label %f
t:
  ret i32 0
f:
  %undef = add i32 undef, 1
  ret i32 %undef
}

define i32 @optimize_undef_2(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@optimize_undef_2
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    ret i32 0
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    ret i32 -1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@optimize_undef_2
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 0
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    ret i32 -1
;
  br i1 %c, label %t, label %f
t:
  ret i32 0
f:
  %undef = sub i32 undef, 1
  ret i32 %undef
}

define i32 @optimize_undef_3(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@optimize_undef_3
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    ret i32 0
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@optimize_undef_3
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 0
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    ret i32 1
;
  br i1 %c, label %t, label %f
t:
  ret i32 0
f:
  %undef = icmp eq i32 undef, 0
  %undef2 = zext i1 %undef to i32
  ret i32 %undef2
}


; FIXME: returned value can be simplified to 0
define i32 @potential_test11(i1 %c) {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test11
; IS__TUNIT_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[ZERO1:%.*]] = call i32 @optimize_undef_1(i1 [[C]]) [[ATTR0]], [[RNG2:!range !.*]]
; IS__TUNIT_OPM-NEXT:    [[ZERO2:%.*]] = call i32 @optimize_undef_2(i1 [[C]]) [[ATTR0]], [[RNG3:!range !.*]]
; IS__TUNIT_OPM-NEXT:    [[ACC1:%.*]] = add i32 [[ZERO1]], [[ZERO2]]
; IS__TUNIT_OPM-NEXT:    [[ACC2:%.*]] = add i32 [[ACC1]], 0
; IS__TUNIT_OPM-NEXT:    ret i32 [[ACC2]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test11
; IS__TUNIT_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[ZERO1:%.*]] = call i32 @optimize_undef_1(i1 [[C]]) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    [[ZERO2:%.*]] = call i32 @optimize_undef_2(i1 [[C]]) [[ATTR0]], [[RNG3:!range !.*]]
; IS__TUNIT_NPM-NEXT:    [[ACC1:%.*]] = add i32 [[ZERO1]], [[ZERO2]]
; IS__TUNIT_NPM-NEXT:    [[ACC2:%.*]] = add i32 [[ACC1]], 0
; IS__TUNIT_NPM-NEXT:    ret i32 [[ACC2]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test11
; IS__CGSCC_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[ZERO1:%.*]] = call i32 @optimize_undef_1(i1 [[C]]) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    [[ZERO2:%.*]] = call i32 @optimize_undef_2(i1 [[C]]) [[ATTR2]], [[RNG3:!range !.*]]
; IS__CGSCC_OPM-NEXT:    [[ZERO3:%.*]] = call i32 @optimize_undef_3(i1 [[C]]) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    [[ACC1:%.*]] = add i32 [[ZERO1]], [[ZERO2]]
; IS__CGSCC_OPM-NEXT:    [[ACC2:%.*]] = add i32 [[ACC1]], [[ZERO3]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ACC2]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test11
; IS__CGSCC_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[ZERO1:%.*]] = call i32 @optimize_undef_1(i1 [[C]]) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    [[ZERO2:%.*]] = call i32 @optimize_undef_2(i1 [[C]]) [[ATTR1]], [[RNG3:!range !.*]]
; IS__CGSCC_NPM-NEXT:    [[ZERO3:%.*]] = call i32 @optimize_undef_3(i1 [[C]]) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    [[ACC1:%.*]] = add i32 [[ZERO1]], [[ZERO2]]
; IS__CGSCC_NPM-NEXT:    [[ACC2:%.*]] = add i32 [[ACC1]], [[ZERO3]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[ACC2]]
;
  %zero1 = call i32 @optimize_undef_1(i1 %c)
  %zero2 = call i32 @optimize_undef_2(i1 %c)
  %zero3 = call i32 @optimize_undef_3(i1 %c)
  %acc1 = add i32 %zero1, %zero2
  %acc2 = add i32 %acc1, %zero3
  ret i32 %acc2
}

define i32 @optimize_poison_1(i1 %c) {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@optimize_poison_1
; IS__TUNIT_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT_OPM:       t:
; IS__TUNIT_OPM-NEXT:    ret i32 0
; IS__TUNIT_OPM:       f:
; IS__TUNIT_OPM-NEXT:    ret i32 -1
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@optimize_poison_1
; IS__TUNIT_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT_NPM:       t:
; IS__TUNIT_NPM-NEXT:    ret i32 0
; IS__TUNIT_NPM:       f:
; IS__TUNIT_NPM-NEXT:    ret i32 undef
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@optimize_poison_1
; IS__CGSCC_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC_OPM:       t:
; IS__CGSCC_OPM-NEXT:    ret i32 0
; IS__CGSCC_OPM:       f:
; IS__CGSCC_OPM-NEXT:    ret i32 -1
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@optimize_poison_1
; IS__CGSCC_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC_NPM:       t:
; IS__CGSCC_NPM-NEXT:    ret i32 0
; IS__CGSCC_NPM:       f:
; IS__CGSCC_NPM-NEXT:    ret i32 undef
;
  br i1 %c, label %t, label %f
t:
  ret i32 0
f:
  %poison = sub nuw i32 0, 1
  ret i32 %poison
}

; FIXME: returned value can be simplified to 0
define i32 @potential_test12(i1 %c) {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test12
; IS__TUNIT_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[ZERO:%.*]] = call noundef i32 @optimize_poison_1(i1 [[C]]) [[ATTR0]], [[RNG3]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[ZERO]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test12
; IS__TUNIT_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    ret i32 0
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test12
; IS__CGSCC_OPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[ZERO:%.*]] = call i32 @optimize_poison_1(i1 [[C]]) [[ATTR2]], [[RNG3]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[ZERO]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test12
; IS__CGSCC_NPM-SAME: (i1 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    ret i32 0
;
  %zero = call i32 @optimize_poison_1(i1 %c)
  ret i32 %zero
}

; Test 13
; Do not simplify %ret in the callee to `%c`.
; The potential value of %c is {0, 1} (undef is merged).
; However, we should not simplify `and i32 %c, 3` to `%c`

define internal i32 @potential_test13_callee(i32 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test13_callee
; IS__TUNIT____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[RET:%.*]] = and i32 [[C]], 3
; IS__TUNIT____-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test13_callee
; IS__CGSCC____-SAME: (i32 [[C:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[RET:%.*]] = and i32 [[C]], 3
; IS__CGSCC____-NEXT:    ret i32 [[RET]]
;
  %ret = and i32 %c, 3
  ret i32 %ret
}

define i32 @potential_test13_caller1() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test13_caller1
; IS__TUNIT_OPM-SAME: () [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 0) [[ATTR0]], [[RNG2]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test13_caller1
; IS__TUNIT_NPM-SAME: () [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 0) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test13_caller1
; IS__CGSCC_OPM-SAME: () [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 0) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test13_caller1
; IS__CGSCC_NPM-SAME: () [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 0) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[RET]]
;
  %ret = call i32 @potential_test13_callee(i32 0)
  ret i32 %ret
}

define i32 @potential_test13_caller2() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test13_caller2
; IS__TUNIT_OPM-SAME: () [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 1) [[ATTR0]], [[RNG2]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test13_caller2
; IS__TUNIT_NPM-SAME: () [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 1) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test13_caller2
; IS__CGSCC_OPM-SAME: () [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 1) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test13_caller2
; IS__CGSCC_NPM-SAME: () [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 noundef 1) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[RET]]
;
  %ret = call i32 @potential_test13_callee(i32 1)
  ret i32 %ret
}

define i32 @potential_test13_caller3() {
; IS__TUNIT_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@potential_test13_caller3
; IS__TUNIT_OPM-SAME: () [[ATTR0]] {
; IS__TUNIT_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 undef) [[ATTR0]], [[RNG2]]
; IS__TUNIT_OPM-NEXT:    ret i32 [[RET]]
;
; IS__TUNIT_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@potential_test13_caller3
; IS__TUNIT_NPM-SAME: () [[ATTR0]] {
; IS__TUNIT_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 undef) [[ATTR0]], [[RNG0]]
; IS__TUNIT_NPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@potential_test13_caller3
; IS__CGSCC_OPM-SAME: () [[ATTR0]] {
; IS__CGSCC_OPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 undef) [[ATTR2]], [[RNG0]]
; IS__CGSCC_OPM-NEXT:    ret i32 [[RET]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@potential_test13_caller3
; IS__CGSCC_NPM-SAME: () [[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    [[RET:%.*]] = call i32 @potential_test13_callee(i32 undef) [[ATTR1]], [[RNG0]]
; IS__CGSCC_NPM-NEXT:    ret i32 [[RET]]
;
  %ret = call i32 @potential_test13_callee(i32 undef)
  ret i32 %ret
}

define i1 @potential_test14(i1 %c0, i1 %c1, i1 %c2, i1 %c3) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test14
; IS__TUNIT____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]], i1 [[C2:%.*]], i1 [[C3:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    [[X0:%.*]] = select i1 [[C0]], i32 0, i32 1
; IS__TUNIT____-NEXT:    [[X1:%.*]] = select i1 [[C1]], i32 [[X0]], i32 undef
; IS__TUNIT____-NEXT:    [[Y2:%.*]] = select i1 [[C2]], i32 0, i32 7
; IS__TUNIT____-NEXT:    [[Z3:%.*]] = select i1 [[C3]], i32 [[X1]], i32 [[Y2]]
; IS__TUNIT____-NEXT:    [[RET:%.*]] = icmp slt i32 [[Z3]], 7
; IS__TUNIT____-NEXT:    ret i1 [[RET]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test14
; IS__CGSCC____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]], i1 [[C2:%.*]], i1 [[C3:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    [[X0:%.*]] = select i1 [[C0]], i32 0, i32 1
; IS__CGSCC____-NEXT:    [[X1:%.*]] = select i1 [[C1]], i32 [[X0]], i32 undef
; IS__CGSCC____-NEXT:    [[Y2:%.*]] = select i1 [[C2]], i32 0, i32 7
; IS__CGSCC____-NEXT:    [[Z3:%.*]] = select i1 [[C3]], i32 [[X1]], i32 [[Y2]]
; IS__CGSCC____-NEXT:    [[RET:%.*]] = icmp slt i32 [[Z3]], 7
; IS__CGSCC____-NEXT:    ret i1 [[RET]]
;
  %x0 = select i1 %c0, i32 0, i32 1
  %x1 = select i1 %c1, i32 %x0, i32 undef
  %y2 = select i1 %c2, i32 0, i32 7
  %z3 = select i1 %c3, i32 %x1, i32 %y2
  %ret = icmp slt i32 %z3, 7
  ret i1 %ret
}

define i1 @potential_test15(i1 %c0, i1 %c1) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test15
; IS__TUNIT____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i1 false
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test15
; IS__CGSCC____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 false
;
  %x0 = select i1 %c0, i32 0, i32 1
  %x1 = select i1 %c1, i32 %x0, i32 undef
  %ret = icmp eq i32 %x1, 7
  ret i1 %ret
}

define i1 @potential_test16(i1 %c0, i1 %c1) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@potential_test16
; IS__TUNIT____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]]) [[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i1 false
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@potential_test16
; IS__CGSCC____-SAME: (i1 [[C0:%.*]], i1 [[C1:%.*]]) [[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i1 false
;
  %x0 = select i1 %c0, i32 0, i32 undef
  %x1 = select i1 %c1, i32 %x0, i32 1
  %ret = icmp eq i32 %x1, 7
  ret i1 %ret
}

; IS__TUNIT_NPM: !0 = !{i32 0, i32 2}
; IS__TUNIT_NPM: !1 = !{i32 1, i32 4}
; IS__TUNIT_NPM: !2 = !{i32 3, i32 5}
; IS__TUNIT_NPM: !3 = !{i32 -1, i32 1}
; IS__TUNIT_NPM-NOT: !4

; IS__TUNIT_OPM: !0 = !{i32 1, i32 4}
; IS__TUNIT_OPM: !1 = !{i32 3, i32 5}
; IS__TUNIT_OPM: !2 = !{i32 0, i32 2}
; IS__TUNIT_OPM: !3 = !{i32 -1, i32 1}
; IS__TUNIT_OPM-NOT: !4
