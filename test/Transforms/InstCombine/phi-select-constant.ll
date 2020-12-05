; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instcombine | FileCheck %s
@A = extern_weak global i32, align 4
@B = extern_weak global i32, align 4

define i32 @foo(i1 %which) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[USE2:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ select (i1 icmp eq (i32* @A, i32* @B), i32 2, i32 1), [[DELAY]] ]
; CHECK-NEXT:    ret i32 [[USE2]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %use2 = phi i1 [ false, %entry ], [ icmp eq (i32* @A, i32* @B), %delay ]
  %value = select i1 %use2, i32 2, i32 1
  ret i32 %value
}


; test folding of select into phi for vectors.
define <4 x i64> @vec1(i1 %which) {
; CHECK-LABEL: @vec1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi <4 x i64> [ zeroinitializer, [[ENTRY:%.*]] ], [ <i64 0, i64 0, i64 126, i64 127>, [[DELAY]] ]
; CHECK-NEXT:    ret <4 x i64> [[PHINODE]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %phinode =  phi <4 x i1> [ <i1 true, i1 true, i1 true, i1 true>, %entry ], [ <i1 true, i1 true, i1 false, i1 false>, %delay ]
  %sel = select <4 x i1> %phinode, <4 x i64> zeroinitializer, <4 x i64> <i64 124, i64 125, i64 126, i64 127>
  ret <4 x i64> %sel
}

define <4 x i64> @vec2(i1 %which) {
; CHECK-LABEL: @vec2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi <4 x i64> [ <i64 124, i64 125, i64 126, i64 127>, [[ENTRY:%.*]] ], [ <i64 0, i64 125, i64 0, i64 127>, [[DELAY]] ]
; CHECK-NEXT:    ret <4 x i64> [[PHINODE]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %phinode =  phi <4 x i1> [ <i1 false, i1 false, i1 false, i1 false>, %entry ], [ <i1 true, i1 false, i1 true, i1 false>, %delay ]
  %sel = select <4 x i1> %phinode, <4 x i64> zeroinitializer, <4 x i64> <i64 124, i64 125, i64 126, i64 127>
  ret <4 x i64> %sel
}

; Test PR33364
; Insert the generated select into the same block as the incoming phi value.
; phi has constant vectors along with a single non-constant vector as operands.
define <2 x i8> @vec3(i1 %cond1, i1 %cond2, <2 x i1> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @vec3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PHI_SEL1:%.*]] = shufflevector <2 x i8> [[Z:%.*]], <2 x i8> [[Y:%.*]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    br i1 [[COND1:%.*]], label [[IF1:%.*]], label [[ELSE:%.*]]
; CHECK:       if1:
; CHECK-NEXT:    [[PHI_SEL2:%.*]] = shufflevector <2 x i8> [[Y]], <2 x i8> [[Z]], <2 x i32> <i32 0, i32 3>
; CHECK-NEXT:    br i1 [[COND2:%.*]], label [[IF2:%.*]], label [[ELSE]]
; CHECK:       if2:
; CHECK-NEXT:    [[PHI_SEL:%.*]] = select <2 x i1> [[X:%.*]], <2 x i8> [[Y]], <2 x i8> [[Z]]
; CHECK-NEXT:    br label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    [[PHI:%.*]] = phi <2 x i8> [ [[PHI_SEL]], [[IF2]] ], [ [[PHI_SEL1]], [[ENTRY:%.*]] ], [ [[PHI_SEL2]], [[IF1]] ]
; CHECK-NEXT:    ret <2 x i8> [[PHI]]
;
entry:
  br i1 %cond1, label %if1, label %else

if1:
  br i1 %cond2, label %if2, label %else

if2:
  br label %else

else:
  %phi = phi <2 x i1> [ %x, %if2 ], [ <i1 0, i1 1>, %entry ], [ <i1 1, i1 0>, %if1 ]
  %sel = select <2 x i1> %phi, <2 x i8> %y, <2 x i8> %z
  ret <2 x i8> %sel
}

; Don't crash on unreachable IR.

define void @PR48369(i32 %a, i32* %p) {
; CHECK-LABEL: @PR48369(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PHI_CMP:%.*]] = icmp sgt i32 [[A:%.*]], 0
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[CMP:%.*]] = phi i1 [ [[PHI_CMP]], [[DEADBB:%.*]] ], [ true, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[SHL:%.*]] = select i1 [[CMP]], i32 256, i32 0
; CHECK-NEXT:    store i32 [[SHL]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       deadbb:
; CHECK-NEXT:    br label [[BB1]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %phi.cmp = icmp sgt i32 %a, 0
  br label %bb1

bb1:
  %cmp = phi i1 [ %phi.cmp, %deadbb ], [ true, %entry ]
  %shl = select i1 %cmp, i32 256, i32 0
  store i32 %shl, i32* %p
  br label %end

deadbb:
  br label %bb1

end:
  ret void
}
