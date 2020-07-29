; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; TODO: The old pass manager cgscc run is disabled as it causes a crash on windows which is under investigation: http://lab.llvm.org:8011/builders/llvm-clang-x86_64-expensive-checks-win/builds/23151
; opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.u = type { x86_fp80 }
%struct.s = type { double, i16, i8, [5 x i8] }

@b = internal global %struct.s { double 3.14, i16 9439, i8 25, [5 x i8] undef }, align 16

%struct.Foo = type { i32, i64 }
@a = internal global %struct.Foo { i32 1, i64 2 }, align 8

define void @run() {
; NOT_CGSCC_NPM: Function Attrs: nofree noreturn nosync nounwind readnone
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@run()
; NOT_CGSCC_NPM-NEXT:  entry:
; NOT_CGSCC_NPM-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@run()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    unreachable
;
entry:
  tail call i8 @UseLongDoubleUnsafely(%union.u* byval align 16 bitcast (%struct.s* @b to %union.u*))
  tail call x86_fp80 @UseLongDoubleSafely(%union.u* byval align 16 bitcast (%struct.s* @b to %union.u*))
  call i64 @AccessPaddingOfStruct(%struct.Foo* @a)
  call i64 @CaptureAStruct(%struct.Foo* @a)
  ret void
}

define internal i8 @UseLongDoubleUnsafely(%union.u* byval align 16 %arg) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@UseLongDoubleUnsafely()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret i8 undef
;
entry:
  %bitcast = bitcast %union.u* %arg to %struct.s*
  %gep = getelementptr inbounds %struct.s, %struct.s* %bitcast, i64 0, i32 2
  %result = load i8, i8* %gep
  ret i8 %result
}

define internal x86_fp80 @UseLongDoubleSafely(%union.u* byval align 16 %arg) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@UseLongDoubleSafely()
; IS__CGSCC____-NEXT:    ret x86_fp80 undef
;
  %gep = getelementptr inbounds %union.u, %union.u* %arg, i64 0, i32 0
  %fp80 = load x86_fp80, x86_fp80* %gep
  ret x86_fp80 %fp80
}

define internal i64 @AccessPaddingOfStruct(%struct.Foo* byval %a) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@AccessPaddingOfStruct()
; IS__CGSCC____-NEXT:    ret i64 undef
;
  %p = bitcast %struct.Foo* %a to i64*
  %v = load i64, i64* %p
  ret i64 %v
}

define internal i64 @CaptureAStruct(%struct.Foo* byval %a) {
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@CaptureAStruct
; IS__CGSCC_OPM-SAME: (%struct.Foo* noalias nofree byval [[A:%.*]])
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[A_PTR:%.*]] = alloca %struct.Foo*
; IS__CGSCC_OPM-NEXT:    br label [[LOOP:%.*]]
; IS__CGSCC_OPM:       loop:
; IS__CGSCC_OPM-NEXT:    [[PHI:%.*]] = phi %struct.Foo* [ null, [[ENTRY:%.*]] ], [ [[GEP:%.*]], [[LOOP]] ]
; IS__CGSCC_OPM-NEXT:    [[TMP0:%.*]] = phi %struct.Foo* [ [[A]], [[ENTRY]] ], [ [[TMP0]], [[LOOP]] ]
; IS__CGSCC_OPM-NEXT:    store %struct.Foo* [[PHI]], %struct.Foo** [[A_PTR]], align 8
; IS__CGSCC_OPM-NEXT:    [[GEP]] = getelementptr [[STRUCT_FOO:%.*]], %struct.Foo* [[A]], i64 0
; IS__CGSCC_OPM-NEXT:    br label [[LOOP]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse noreturn nosync nounwind readnone
; IS__CGSCC____-LABEL: define {{[^@]+}}@CaptureAStruct
; IS__CGSCC____-SAME: (i32 [[TMP0:%.*]], i64 [[TMP1:%.*]])
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[A_PRIV:%.*]] = alloca [[STRUCT_FOO:%.*]], align 8
; IS__CGSCC____-NEXT:    [[A_PRIV_CAST:%.*]] = bitcast %struct.Foo* [[A_PRIV]] to i32*
; IS__CGSCC____-NEXT:    store i32 [[TMP0]], i32* [[A_PRIV_CAST]], align 4
; IS__CGSCC____-NEXT:    [[A_PRIV_0_1:%.*]] = getelementptr [[STRUCT_FOO]], %struct.Foo* [[A_PRIV]], i32 0, i32 1
; IS__CGSCC____-NEXT:    store i64 [[TMP1]], i64* [[A_PRIV_0_1]], align 8
; IS__CGSCC____-NEXT:    [[A_PTR:%.*]] = alloca %struct.Foo*, align 8
; IS__CGSCC____-NEXT:    br label [[LOOP:%.*]]
; IS__CGSCC____:       loop:
; IS__CGSCC____-NEXT:    [[PHI:%.*]] = phi %struct.Foo* [ null, [[ENTRY:%.*]] ], [ [[GEP:%.*]], [[LOOP]] ]
; IS__CGSCC____-NEXT:    [[TMP2:%.*]] = phi %struct.Foo* [ [[A_PRIV]], [[ENTRY]] ], [ [[TMP2]], [[LOOP]] ]
; IS__CGSCC____-NEXT:    store %struct.Foo* [[PHI]], %struct.Foo** [[A_PTR]], align 8
; IS__CGSCC____-NEXT:    [[GEP]] = getelementptr [[STRUCT_FOO]], %struct.Foo* [[A_PRIV]], i64 0
; IS__CGSCC____-NEXT:    br label [[LOOP]]
;
entry:
  %a_ptr = alloca %struct.Foo*
  br label %loop

loop:
  %phi = phi %struct.Foo* [ null, %entry ], [ %gep, %loop ]
  %0   = phi %struct.Foo* [ %a, %entry ],   [ %0, %loop ]
  store %struct.Foo* %phi, %struct.Foo** %a_ptr
  %gep = getelementptr %struct.Foo, %struct.Foo* %a, i64 0
  br label %loop
}
