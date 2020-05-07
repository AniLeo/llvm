; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR 32917

@b = common local_unnamed_addr global i32 0, align 4
@a = common local_unnamed_addr global i32 0, align 4

define i32 @fn2() local_unnamed_addr {
; IS__TUNIT____-LABEL: define {{[^@]+}}@fn2() local_unnamed_addr
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = load i32, i32* @b, align 4
; IS__TUNIT____-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; IS__TUNIT____-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[TMP2]] to i32*
; IS__TUNIT____-NEXT:    call fastcc void @fn1(i32* nocapture nofree readonly align 4 [[TMP3]])
; IS__TUNIT____-NEXT:    ret i32 undef
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@fn2() local_unnamed_addr
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = load i32, i32* @b, align 4
; IS__CGSCC____-NEXT:    [[TMP2:%.*]] = sext i32 [[TMP1]] to i64
; IS__CGSCC____-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[TMP2]] to i32*
; IS__CGSCC____-NEXT:    call fastcc void @fn1(i32* nocapture nofree nonnull readonly align 4 [[TMP3]])
; IS__CGSCC____-NEXT:    ret i32 undef
;
  %1 = load i32, i32* @b, align 4
  %2 = sext i32 %1 to i64
  %3 = inttoptr i64 %2 to i32*
  call fastcc void @fn1(i32* %3)
  ret i32 undef
}

define internal fastcc void @fn1(i32* nocapture readonly) unnamed_addr {
; CHECK-LABEL: define {{[^@]+}}@fn1
; CHECK-SAME: (i32* nocapture nofree nonnull readonly align 4 [[TMP0:%.*]]) unnamed_addr
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 -1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    store i32 [[TMP3]], i32* @a, align 4
; CHECK-NEXT:    ret void
;
  %2 = getelementptr inbounds i32, i32* %0, i64 -1
  %3 = load i32, i32* %2, align 4
  store i32 %3, i32* @a, align 4
  ret void
}
