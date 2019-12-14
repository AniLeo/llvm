; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=1 < %s | FileCheck %s
target triple = "x86_64-pc-windows-msvc"

define internal void @callee(i8*) {
; CHECK-LABEL: define {{[^@]+}}@callee
; CHECK-SAME: (i8* noalias nocapture nofree readnone [[TMP0:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @thunk()
; CHECK-NEXT:    ret void
;
entry:
  call void @thunk()
  ret void
}

define void @test1() personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: define {{[^@]+}}@test1() personality i32 (...)* @__CxxFrameHandler3
; CHECK-NEXT:  entry:
; CHECK-NEXT:    invoke void @thunk()
; CHECK-NEXT:    to label [[OUT:%.*]] unwind label [[CPAD:%.*]]
; CHECK:       out:
; CHECK-NEXT:    ret void
; CHECK:       cpad:
; CHECK-NEXT:    [[PAD:%.*]] = cleanuppad within none []
; CHECK-NEXT:    call void @callee(i8* noalias nofree undef) [ "funclet"(token [[PAD]]) ]
; CHECK-NEXT:    cleanupret from [[PAD]] unwind to caller
;
entry:
  invoke void @thunk()
  to label %out unwind label %cpad

out:
  ret void

cpad:
  %pad = cleanuppad within none []
  call void @callee(i8* null) [ "funclet"(token %pad) ]
  cleanupret from %pad unwind to caller
}


declare void @thunk()

declare i32 @__CxxFrameHandler3(...)
