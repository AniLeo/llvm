; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal -attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR36543

; Don't promote arguments of musttail callee

%T = type { i32, i32, i32, i32 }

define internal i32 @test(%T* %p) {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]])
; CHECK-NEXT:    [[A_GEP:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 3
; CHECK-NEXT:    [[B_GEP:%.*]] = getelementptr [[T]], %T* [[P]], i64 0, i32 2
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[A_GEP]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[B_GEP]], align 4
; CHECK-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[V]]
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  ret i32 %v
}

define i32 @caller(%T* %p) {
; CHECK-LABEL: define {{[^@]+}}@caller
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]])
; CHECK-NEXT:    [[V:%.*]] = musttail call i32 @test(%T* nocapture nofree readonly [[P]])
; CHECK-NEXT:    ret i32 [[V]]
;
  %v = musttail call i32 @test(%T* %p)
  ret i32 %v
}

; Don't promote arguments of musttail caller

define i32 @foo(%T* %p, i32 %v) {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (%T* nocapture nofree readnone [[P:%.*]], i32 [[V:%.*]])
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define internal i32 @test2(%T* %p, i32 %p2) {
; IS__CGSCC____-LABEL: define {{[^@]+}}@test2
; IS__CGSCC____-SAME: (%T* nocapture nofree readonly [[P:%.*]], i32 [[P2:%.*]])
; IS__CGSCC____-NEXT:    [[A_GEP:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 3
; IS__CGSCC____-NEXT:    [[B_GEP:%.*]] = getelementptr [[T]], %T* [[P]], i64 0, i32 2
; IS__CGSCC____-NEXT:    [[A:%.*]] = load i32, i32* [[A_GEP]], align 4
; IS__CGSCC____-NEXT:    [[B:%.*]] = load i32, i32* [[B_GEP]], align 4
; IS__CGSCC____-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; IS__CGSCC____-NEXT:    [[CA:%.*]] = musttail call i32 @foo(%T* undef, i32 [[V]])
; IS__CGSCC____-NEXT:    ret i32 [[CA]]
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  %ca = musttail call i32 @foo(%T* undef, i32 %v)
  ret i32 %ca
}

define i32 @caller2(%T* %g) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller2
; IS__TUNIT____-SAME: (%T* nocapture nofree readnone [[G:%.*]])
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller2
; IS__CGSCC____-SAME: (%T* nocapture nofree readonly [[G:%.*]])
; IS__CGSCC____-NEXT:    [[V:%.*]] = call i32 @test2(%T* nocapture nofree readonly [[G]], i32 0)
; IS__CGSCC____-NEXT:    ret i32 [[V]]
;
  %v = call i32 @test2(%T* %g, i32 0)
  ret i32 %v
}

; In the version above we can remove the call to foo completely.
; In the version below we keep the call and verify the return value
; is kept as well.

define i32 @bar(%T* %p, i32 %v) {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (%T* nocapture nofree nonnull writeonly dereferenceable(4) [[P:%.*]], i32 [[V:%.*]])
; CHECK-NEXT:    [[I32PTR:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 0
; CHECK-NEXT:    store i32 [[V]], i32* [[I32PTR]], align 4
; CHECK-NEXT:    ret i32 0
;
  %i32ptr = getelementptr %T, %T* %p, i64 0, i32 0
  store i32 %v, i32* %i32ptr
  ret i32 0
}

define internal i32 @test2b(%T* %p, i32 %p2) {
; CHECK-LABEL: define {{[^@]+}}@test2b
; CHECK-SAME: (%T* nocapture nofree readonly [[P:%.*]], i32 [[P2:%.*]])
; CHECK-NEXT:    [[A_GEP:%.*]] = getelementptr [[T:%.*]], %T* [[P]], i64 0, i32 3
; CHECK-NEXT:    [[B_GEP:%.*]] = getelementptr [[T]], %T* [[P]], i64 0, i32 2
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[A_GEP]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* [[B_GEP]], align 4
; CHECK-NEXT:    [[V:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[CA:%.*]] = musttail call i32 @bar(%T* undef, i32 [[V]])
; CHECK-NEXT:    ret i32 [[CA]]
;
  %a.gep = getelementptr %T, %T* %p, i64 0, i32 3
  %b.gep = getelementptr %T, %T* %p, i64 0, i32 2
  %a = load i32, i32* %a.gep
  %b = load i32, i32* %b.gep
  %v = add i32 %a, %b
  %ca = musttail call i32 @bar(%T* undef, i32 %v)
  ret i32 %ca
}

define i32 @caller2b(%T* %g) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller2b
; IS__TUNIT____-SAME: (%T* nocapture nofree readonly [[G:%.*]])
; IS__TUNIT____-NEXT:    [[V:%.*]] = call i32 @test2b(%T* nocapture nofree readonly [[G]], i32 undef)
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller2b
; IS__CGSCC____-SAME: (%T* nocapture nofree readonly [[G:%.*]])
; IS__CGSCC____-NEXT:    [[V:%.*]] = call i32 @test2b(%T* nocapture nofree readonly [[G]], i32 0)
; IS__CGSCC____-NEXT:    ret i32 [[V]]
;
  %v = call i32 @test2b(%T* %g, i32 0)
  ret i32 %v
}
