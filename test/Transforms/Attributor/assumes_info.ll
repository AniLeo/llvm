; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define dso_local void @entry(i1 %cond) #0 {
; CHECK-LABEL: define {{[^@]+}}@entry
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @foo(i1 [[COND]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @qux() #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  call void @foo(i1 %cond)
  call void @bar()
  call void @qux() #1
  ret void
}

define internal void @foo(i1 %cond) #1 {
; IS__TUNIT____-LABEL: define {{[^@]+}}@foo
; IS__TUNIT____-SAME: (i1 [[COND:%.*]]) #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    call void @baz(i1 [[COND]])
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo
; IS__CGSCC____-SAME: (i1 [[COND:%.*]]) #[[ATTR1]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    call void @baz(i1 [[COND]]) #[[ATTR1]]
; IS__CGSCC____-NEXT:    ret void
;
entry:
  call void @baz(i1 %cond)
  ret void
}

define internal void @bar() #2 {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @baz(i1 noundef false) #[[ATTR2]]
; CHECK-NEXT:    ret void
;
entry:
  call void @baz(i1 0)
  ret void
}

define internal void @baz(i1 %Cond) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@baz
; IS__TUNIT____-SAME: (i1 [[COND:%.*]]) #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TOBOOL:%.*]] = icmp ne i1 [[COND]], false
; IS__TUNIT____-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__TUNIT____:       if.then:
; IS__TUNIT____-NEXT:    call void @baz(i1 noundef false)
; IS__TUNIT____-NEXT:    br label [[IF_END]]
; IS__TUNIT____:       if.end:
; IS__TUNIT____-NEXT:    call void @qux()
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@baz
; IS__CGSCC____-SAME: (i1 [[COND:%.*]]) #[[ATTR3:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TOBOOL:%.*]] = icmp ne i1 [[COND]], false
; IS__CGSCC____-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__CGSCC____:       if.then:
; IS__CGSCC____-NEXT:    call void @baz(i1 noundef false)
; IS__CGSCC____-NEXT:    br label [[IF_END]]
; IS__CGSCC____:       if.end:
; IS__CGSCC____-NEXT:    call void @qux() #[[ATTR3]]
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %tobool = icmp ne i1 %Cond, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:
  call void @baz(i1 0)
  br label %if.end

if.end:
  call void @qux()
  ret void
}

define internal void @qux() {
; IS__TUNIT____-LABEL: define {{[^@]+}}@qux
; IS__TUNIT____-SAME: () #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    call void @call()
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@qux() {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    call void @call()
; IS__CGSCC____-NEXT:    ret void
;
entry:
  call void @call()
  ret void
}

declare void @call() #3

attributes #0 = { "llvm.assume"="A" }
attributes #1 = { "llvm.assume"="B" }
attributes #2 = { "llvm.assume"="B,C" }
attributes #3 = { "llvm.assume"="B,C,A" }
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { "llvm.assume"="A" }
; IS__TUNIT____: attributes #[[ATTR1]] = { "llvm.assume"="B,A" }
; IS__TUNIT____: attributes #[[ATTR2]] = { "llvm.assume"="B,C,A" }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { "llvm.assume"="A" }
; IS__CGSCC____: attributes #[[ATTR1]] = { "llvm.assume"="B,A" }
; IS__CGSCC____: attributes #[[ATTR2]] = { "llvm.assume"="B,C,A" }
; IS__CGSCC____: attributes #[[ATTR3]] = { "llvm.assume"="B" }
;.
