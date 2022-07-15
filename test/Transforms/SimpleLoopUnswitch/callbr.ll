; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='simple-loop-unswitch<nontrivial>' %s -S | FileCheck %s

declare i1 @foo()

define i32 @mem_cgroup_node_nr_lru_pages(i1 %tree) {
; CHECK-LABEL: @mem_cgroup_node_nr_lru_pages(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[TREE:%.*]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[FOR_COND_US:%.*]]
; CHECK:       for.cond.us:
; CHECK-NEXT:    br label [[IF_END8_US:%.*]]
; CHECK:       if.end8.us:
; CHECK-NEXT:    br label [[FOR_COND_US]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br label [[IF_ELSE:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    callbr void asm sideeffect ".pushsection __jump_table, \22aw\22 \0A\09.popsection \0A\09", "!i,~{dirflag},~{fpsr},~{flags}"()
; CHECK-NEXT:    to label [[IF_END8:%.*]] [label %for.cond5.preheader]
; CHECK:       for.cond5.preheader:
; CHECK-NEXT:    br label [[FOR_COND5:%.*]]
; CHECK:       for.cond5:
; CHECK-NEXT:    [[CALL6:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CALL6]], label [[IF_END8_LOOPEXIT:%.*]], label [[FOR_COND5]]
; CHECK:       if.end8.loopexit:
; CHECK-NEXT:    br label [[IF_END8]]
; CHECK:       if.end8:
; CHECK-NEXT:    br label [[FOR_COND]]
;
entry:
  br label %for.cond

for.cond:                                         ; preds = %if.end8, %entry
  br i1 %tree, label %if.end8, label %if.else

if.else:                                          ; preds = %for.cond
  callbr void asm sideeffect ".pushsection __jump_table,  \22aw\22 \0A\09.popsection \0A\09", "!i,~{dirflag},~{fpsr},~{flags}"()
  to label %if.end8 [label %for.cond5]

for.cond5:                                        ; preds = %if.else, %for.cond5
  %call6 = call i1 @foo()
  br i1 %call6, label %if.end8.loopexit, label %for.cond5

if.end8.loopexit:                                 ; preds = %for.cond5
  br label %if.end8

if.end8:                                          ; preds = %if.end8.loopexit, %if.else, %for.cond
  br label %for.cond
}

