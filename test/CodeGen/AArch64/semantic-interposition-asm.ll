; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -relocation-model=pic < %s | FileCheck %s

;; Test that we use the local alias for dso_local globals in inline assembly.

@gv0 = dso_local global i32 0
@gv1 = dso_preemptable global i32 1

define i32 @load() nounwind {
; CHECK-LABEL: load:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    //APP
; CHECK-NEXT:    adrp x0, .Lgv0$local
; CHECK-NEXT:    ldr w0, [x0, :lo12:.Lgv0$local]
; CHECK-NEXT:    adrp x8, gv1
; CHECK-NEXT:    ldr w8, [x8, :lo12:gv1]
; CHECK-NEXT:    add x0, x8, x0
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 asm "adrp $0, $1\0Aldr ${0:w}, [$0, :lo12:$1]\0Aadrp x8, $2\0Aldr w8, [x8, :lo12:$2]\0Aadd $0,x8,$0", "=r,S,S,~{x8}"(i32* nonnull @gv0, i32* nonnull @gv1)
  %conv = trunc i64 %0 to i32
  ret i32 %conv
}
