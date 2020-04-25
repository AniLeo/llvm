; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @fn2(i32* %P, i1 %C) {
;
; IS__TUNIT____-LABEL: define {{[^@]+}}@fn2
; IS__TUNIT____-SAME: (i32* nocapture nofree [[P:%.*]], i1 [[C:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    br label [[IF_END:%.*]]
; IS__TUNIT____:       for.cond1:
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[IF_END]], label [[EXIT:%.*]]
; IS__TUNIT____:       if.end:
; IS__TUNIT____-NEXT:    [[E_2:%.*]] = phi i32* [ [[P]], [[ENTRY:%.*]] ], [ null, [[FOR_COND1:%.*]] ]
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32, i32* [[E_2]], align 4
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call i32 @fn1(i32 [[TMP0]])
; IS__TUNIT____-NEXT:    store i32 [[CALL]], i32* [[P]], align 1
; IS__TUNIT____-NEXT:    br label [[FOR_COND1]]
; IS__TUNIT____:       exit:
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@fn2
; IS__CGSCC____-SAME: (i32* nocapture nofree nonnull align 4 dereferenceable(4) [[P:%.*]], i1 [[C:%.*]])
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    br label [[IF_END:%.*]]
; IS__CGSCC____:       for.cond1:
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[IF_END]], label [[EXIT:%.*]]
; IS__CGSCC____:       if.end:
; IS__CGSCC____-NEXT:    [[E_2:%.*]] = phi i32* [ [[P]], [[ENTRY:%.*]] ], [ null, [[FOR_COND1:%.*]] ]
; IS__CGSCC____-NEXT:    [[TMP0:%.*]] = load i32, i32* [[E_2]], align 4
; IS__CGSCC____-NEXT:    [[CALL:%.*]] = call i32 @fn1(i32 [[TMP0]])
; IS__CGSCC____-NEXT:    store i32 [[CALL]], i32* [[P]], align 4
; IS__CGSCC____-NEXT:    br label [[FOR_COND1]]
; IS__CGSCC____:       exit:
; IS__CGSCC____-NEXT:    ret void
;
entry:
  br label %if.end

for.cond1:                                        ; preds = %if.end
  br i1 %C, label %if.end, label %exit

if.end:                                           ; preds = %entry, %for.cond1
  %e.2 = phi i32* [ %P, %entry ], [ null, %for.cond1 ]
  %0 = load i32, i32* %e.2, align 4
  %call = call i32 @fn1(i32 %0)
  store i32 %call, i32* %P
  br label %for.cond1
exit:
  ret void
}

define internal i32 @fn1(i32 %p1) {
; CHECK-LABEL: define {{[^@]+}}@fn1
; CHECK-SAME: (i32 returned [[P1:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[P1]], 0
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i32 [[P1]], i32 [[P1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %tobool = icmp ne i32 %p1, 0
  %cond = select i1 %tobool, i32 %p1, i32 %p1
  ret i32 %cond
}

define void @fn_no_null_opt(i32* %P, i1 %C) null_pointer_is_valid {
;
; IS__TUNIT____-LABEL: define {{[^@]+}}@fn_no_null_opt
; IS__TUNIT____-SAME: (i32* nocapture nofree writeonly [[P:%.*]], i1 [[C:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    br label [[IF_END:%.*]]
; IS__TUNIT____:       for.cond1:
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[IF_END]], label [[EXIT:%.*]]
; IS__TUNIT____:       if.end:
; IS__TUNIT____-NEXT:    [[E_2:%.*]] = phi i32* [ undef, [[ENTRY:%.*]] ], [ null, [[FOR_COND1:%.*]] ]
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32, i32* null, align 4
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call i32 @fn0(i32 [[TMP0]])
; IS__TUNIT____-NEXT:    store i32 [[CALL]], i32* [[P]], align 1
; IS__TUNIT____-NEXT:    br label [[FOR_COND1]]
; IS__TUNIT____:       exit:
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@fn_no_null_opt
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree writeonly align 4 dereferenceable_or_null(4) [[P:%.*]], i1 [[C:%.*]])
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    br label [[IF_END:%.*]]
; IS__CGSCC_OPM:       for.cond1:
; IS__CGSCC_OPM-NEXT:    br i1 [[C]], label [[IF_END]], label [[EXIT:%.*]]
; IS__CGSCC_OPM:       if.end:
; IS__CGSCC_OPM-NEXT:    [[E_2:%.*]] = phi i32* [ undef, [[ENTRY:%.*]] ], [ null, [[FOR_COND1:%.*]] ]
; IS__CGSCC_OPM-NEXT:    [[TMP0:%.*]] = load i32, i32* null, align 4
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32 @fn0(i32 [[TMP0]])
; IS__CGSCC_OPM-NEXT:    store i32 [[CALL]], i32* [[P]], align 4
; IS__CGSCC_OPM-NEXT:    br label [[FOR_COND1]]
; IS__CGSCC_OPM:       exit:
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@fn_no_null_opt
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree writeonly align 4 dereferenceable_or_null(4) [[P:%.*]], i1 [[C:%.*]])
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    br label [[IF_END:%.*]]
; IS__CGSCC_NPM:       for.cond1:
; IS__CGSCC_NPM-NEXT:    br i1 [[C]], label [[IF_END]], label [[EXIT:%.*]]
; IS__CGSCC_NPM:       if.end:
; IS__CGSCC_NPM-NEXT:    [[E_2:%.*]] = phi i32* [ undef, [[ENTRY:%.*]] ], [ null, [[FOR_COND1:%.*]] ]
; IS__CGSCC_NPM-NEXT:    [[TMP0:%.*]] = load i32, i32* null, align 536870912
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32 @fn0(i32 [[TMP0]])
; IS__CGSCC_NPM-NEXT:    store i32 [[CALL]], i32* [[P]], align 4
; IS__CGSCC_NPM-NEXT:    br label [[FOR_COND1]]
; IS__CGSCC_NPM:       exit:
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  br label %if.end

for.cond1:                                        ; preds = %if.end
  br i1 %C, label %if.end, label %exit

if.end:                                           ; preds = %entry, %for.cond1
  %e.2 = phi i32* [ undef, %entry ], [ null, %for.cond1 ]
  %0 = load i32, i32* %e.2, align 4
  %call = call i32 @fn0(i32 %0)
  store i32 %call, i32* %P
  br label %for.cond1
exit:
  ret void
}

define internal i32 @fn0(i32 %p1) {
; CHECK-LABEL: define {{[^@]+}}@fn0
; CHECK-SAME: (i32 returned [[P1:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[P1]], 0
; CHECK-NEXT:    [[COND:%.*]] = select i1 [[TOBOOL]], i32 [[P1]], i32 [[P1]]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %tobool = icmp ne i32 %p1, 0
  %cond = select i1 %tobool, i32 %p1, i32 %p1
  ret i32 %cond
}
