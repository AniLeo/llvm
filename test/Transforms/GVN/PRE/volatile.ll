; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Tests that check our handling of volatile instructions encountered
; when scanning for dependencies
; RUN: opt -basic-aa -gvn -S < %s | FileCheck %s

; Check that we can bypass a volatile load when searching
; for dependencies of a non-volatile load
define i32 @test1(i32* nocapture %p, i32* nocapture %q) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, i32* [[Q:%.*]]
; CHECK-NEXT:    ret i32 0
;
entry:
  %x = load i32, i32* %p
  load volatile i32, i32* %q
  %y = load i32, i32* %p
  %add = sub i32 %y, %x
  ret i32 %add
}

; We can not value forward if the query instruction is
; volatile, this would be (in effect) removing the volatile load
define i32 @test2(i32* nocapture %p, i32* nocapture %q) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = load volatile i32, i32* [[P]]
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %x = load i32, i32* %p
  %y = load volatile i32, i32* %p
  %add = sub i32 %y, %x
  ret i32 %add
}

; If the query instruction is itself volatile, we *cannot*
; reorder it even if p and q are noalias
define i32 @test3(i32* noalias nocapture %p, i32* noalias nocapture %q) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]]
; CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, i32* [[Q:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = load volatile i32, i32* [[P]]
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %x = load i32, i32* %p
  load volatile i32, i32* %q
  %y = load volatile i32, i32* %p
  %add = sub i32 %y, %x
  ret i32 %add
}

; If an encountered instruction is both volatile and ordered,
; we need to use the strictest ordering of either.  In this
; case, the ordering prevents forwarding.
define i32 @test4(i32* noalias nocapture %p, i32* noalias nocapture %q) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load atomic volatile i32, i32* [[Q:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[Y:%.*]] = load atomic i32, i32* [[P]] seq_cst, align 4
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %x = load i32, i32* %p
  load atomic volatile i32, i32* %q seq_cst, align 4
  %y = load atomic i32, i32* %p seq_cst, align 4
  %add = sub i32 %y, %x
  ret i32 %add
}

; Value forwarding from a volatile load is perfectly legal
define i32 @test5(i32* nocapture %p, i32* nocapture %q) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, i32* [[P:%.*]]
; CHECK-NEXT:    ret i32 0
;
entry:
  %x = load volatile i32, i32* %p
  %y = load i32, i32* %p
  %add = sub i32 %y, %x
  ret i32 %add
}

; Does cross block redundancy elimination work with volatiles?
define i32 @test6(i32* noalias nocapture %p, i32* noalias nocapture %q) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[Y1:%.*]] = load i32, i32* [[P:%.*]]
; CHECK-NEXT:    call void @use(i32 [[Y1]])
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, i32* [[Q:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y1]], [[X]]
; CHECK-NEXT:    [[CND:%.*]] = icmp eq i32 [[ADD]], 0
; CHECK-NEXT:    br i1 [[CND]], label [[EXIT:%.*]], label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  %y1 = load i32, i32* %p
  call void @use(i32 %y1)
  br label %header
header:
  %x = load volatile i32, i32* %q
  %y = load i32, i32* %p
  %add = sub i32 %y, %x
  %cnd = icmp eq i32 %add, 0
  br i1 %cnd, label %exit, label %header
exit:
  ret i32 %add
}

; Does cross block PRE work with volatiles?
define i32 @test7(i1 %c, i32* noalias nocapture %p, i32* noalias nocapture %q) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[ENTRY_HEADER_CRIT_EDGE:%.*]], label [[SKIP:%.*]]
; CHECK:       entry.header_crit_edge:
; CHECK-NEXT:    [[Y_PRE:%.*]] = load i32, i32* [[P:%.*]]
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       skip:
; CHECK-NEXT:    [[Y1:%.*]] = load i32, i32* [[P]]
; CHECK-NEXT:    call void @use(i32 [[Y1]])
; CHECK-NEXT:    br label [[HEADER]]
; CHECK:       header:
; CHECK-NEXT:    [[Y:%.*]] = phi i32 [ [[Y_PRE]], [[ENTRY_HEADER_CRIT_EDGE]] ], [ [[Y]], [[HEADER]] ], [ [[Y1]], [[SKIP]] ]
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, i32* [[Q:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y]], [[X]]
; CHECK-NEXT:    [[CND:%.*]] = icmp eq i32 [[ADD]], 0
; CHECK-NEXT:    br i1 [[CND]], label [[EXIT:%.*]], label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br i1 %c, label %header, label %skip
skip:
  %y1 = load i32, i32* %p
  call void @use(i32 %y1)
  br label %header
header:
  %x = load volatile i32, i32* %q
  %y = load i32, i32* %p
  %add = sub i32 %y, %x
  %cnd = icmp eq i32 %add, 0
  br i1 %cnd, label %exit, label %header
exit:
  ret i32 %add
}

; Another volatile PRE case - two paths through a loop
; load in preheader, one path read only, one not
define i32 @test8(i1 %b, i1 %c, i32* noalias %p, i32* noalias %q) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[Y1:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    call void @use(i32 [[Y1]])
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[Y:%.*]] = phi i32 [ [[Y_PRE:%.*]], [[SKIP_HEADER_CRIT_EDGE:%.*]] ], [ [[Y]], [[HEADER]] ], [ [[Y1]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, i32* [[Q:%.*]], align 4
; CHECK-NEXT:    call void @use(i32 [[Y]])
; CHECK-NEXT:    br i1 [[B:%.*]], label [[SKIP:%.*]], label [[HEADER]]
; CHECK:       skip:
; CHECK-NEXT:    call void @clobber(i32* [[P]], i32* [[Q]])
; CHECK-NEXT:    br i1 [[C:%.*]], label [[SKIP_HEADER_CRIT_EDGE]], label [[EXIT:%.*]]
; CHECK:       skip.header_crit_edge:
; CHECK-NEXT:    [[Y_PRE]] = load i32, i32* [[P]]
; CHECK-NEXT:    br label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    [[ADD:%.*]] = sub i32 [[Y]], [[X]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %y1 = load i32, i32* %p
  call void @use(i32 %y1)
  br label %header
header:
  %x = load volatile i32, i32* %q
  %y = load i32, i32* %p
  call void @use(i32 %y)
  br i1 %b, label %skip, label %header
skip:
  ; escaping the arguments is explicitly required since we marked
  ; them noalias
  call void @clobber(i32* %p, i32* %q)
  br i1 %c, label %header, label %exit
exit:
  %add = sub i32 %y, %x
  ret i32 %add
}

; This test checks that we don't optimize away instructions that are
; simplified by SimplifyInstruction(), but are not trivially dead.

define i32 @test9(i32* %V) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LOAD:%.*]] = call i32 undef()
; CHECK-NEXT:    ret i32 undef
;
entry:
  %load = call i32 undef()
  ret i32 %load
}

declare void @use(i32) readonly
declare void @clobber(i32* %p, i32* %q)

!0 = !{ i32 0, i32 1 }
