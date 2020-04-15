; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -fix-irreducible -structurizecfg -S | FileCheck %s

; Both B1 and B4 are headers of an irreducible cycle. But in the
; structurized version, B1 dominates B4. The program is structurized
; correctly when the irreducible cycle is fixed.

define void @irreducible(i1 %PredEntry, i1 %PredB1, i1 %PredB2, i1 %PredB3, i1 %PredB4)
; CHECK-LABEL: @irreducible(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PREDB2_INV:%.*]] = xor i1 [[PREDB2:%.*]], true
; CHECK-NEXT:    [[PREDB1_INV:%.*]] = xor i1 [[PREDB1:%.*]], true
; CHECK-NEXT:    br label [[IRR_GUARD:%.*]]
; CHECK:       Flow:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i1 [ [[PREDB4:%.*]], [[B4:%.*]] ], [ false, [[IRR_GUARD]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi i1 [ false, [[B4]] ], [ true, [[IRR_GUARD]] ]
; CHECK-NEXT:    br i1 [[TMP1]], label [[B1:%.*]], label [[FLOW1:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br label [[FLOW1]]
; CHECK:       Flow1:
; CHECK-NEXT:    [[TMP2:%.*]] = phi i1 [ [[PREDB1_INV]], [[B1]] ], [ [[TMP0]], [[FLOW:%.*]] ]
; CHECK-NEXT:    br i1 [[TMP2]], label [[B2:%.*]], label [[FLOW2:%.*]]
; CHECK:       B2:
; CHECK-NEXT:    br i1 [[PREDB2_INV]], label [[B3:%.*]], label [[FLOW3:%.*]]
; CHECK:       Flow2:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i1 [ [[TMP4:%.*]], [[FLOW3]] ], [ true, [[FLOW1]] ]
; CHECK-NEXT:    br i1 [[TMP3]], label [[EXIT:%.*]], label [[IRR_GUARD]]
; CHECK:       B3:
; CHECK-NEXT:    br label [[FLOW3]]
; CHECK:       B4:
; CHECK-NEXT:    br label [[FLOW]]
; CHECK:       Flow3:
; CHECK-NEXT:    [[TMP4]] = phi i1 [ false, [[B3]] ], [ true, [[B2]] ]
; CHECK-NEXT:    br label [[FLOW2]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       irr.guard:
; CHECK-NEXT:    [[GUARD_B1:%.*]] = phi i1 [ [[PREDENTRY:%.*]], [[ENTRY:%.*]] ], [ [[PREDB3:%.*]], [[FLOW2]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[GUARD_B1]], true
; CHECK-NEXT:    br i1 [[TMP5]], label [[B4]], label [[FLOW]]
;
{
entry:
  br i1 %PredEntry, label %B1, label %B4

B1:
  br i1 %PredB1, label %exit, label %B2

B2:
  br i1 %PredB2, label %exit, label %B3

B3:
  br i1 %PredB3, label %B1, label %B4

B4:
  br i1 %PredB4, label %B2, label %exit

exit:
  ret void
}
