; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; Don't promote paramaters of/arguments to naked functions

@g = common global i32 0, align 4

define i32 @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar()
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo(i32* nonnull align 4 dereferenceable(4) @g)
; CHECK-NEXT:    ret i32 [[CALL]]
;
entry:
  %call = call i32 @foo(i32* @g)
  ret i32 %call
}

define internal i32 @foo(i32*) #0 {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32* [[TMP0:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void asm sideeffect "ldr r0, [r0] \0Abx lr \0A", ""()
; CHECK-NEXT:    unreachable
;
entry:
  %retval = alloca i32, align 4
  call void asm sideeffect "ldr r0, [r0] \0Abx lr        \0A", ""()
  unreachable
}


attributes #0 = { naked }
