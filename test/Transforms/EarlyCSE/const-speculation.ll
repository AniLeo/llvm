; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -early-cse -earlycse-debug-hash -S %s | FileCheck %s

%mystruct = type { i32 }

; @var is global so that *every* GEP argument is Constant.
@var = external global %mystruct

; Control flow is to make the dominance tree consider the final icmp before it
; gets to simplify the purely constant one (%tst). Since that icmp uses the
; select that gets considered next. Finally the select simplification looks at
; the %tst icmp and we don't want it to speculate about what happens if "i32 0"
; is actually "i32 1", broken universes are automatic UB.
;
; In this case doing the speculation would create an invalid GEP(@var, 0, 1) and
; crash.

define i1 @test_constant_speculation() {
; CHECK-LABEL: @test_constant_speculation(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[END:%.*]], label [[SELECT:%.*]]
; CHECK:       select:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32* [ null, [[ENTRY:%.*]] ], [ getelementptr inbounds ([[MYSTRUCT:%.*]], %mystruct* @var, i64 0, i32 0), [[SELECT]] ]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32* [[TMP]], null
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  br i1 undef, label %end, label %select

select:

  %tst = icmp eq i32 1, 0
  %elt = getelementptr %mystruct, %mystruct* @var, i64 0, i32 0
  %sel = select i1 %tst, i32* null, i32* %elt
  br label %end

end:
  %tmp = phi i32* [null, %entry], [%sel, %select]
  %res = icmp eq i32* %tmp, null
  ret i1 %res
}
