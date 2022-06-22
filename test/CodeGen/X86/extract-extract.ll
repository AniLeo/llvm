; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s
; PR4699

; Handle this extractvalue-of-extractvalue case without getting in
; trouble with CSE in DAGCombine.

        %cc = type { %crd }
        %cr = type { i32 }
        %crd = type { i64, ptr }
        %pp = type { %cc }

define fastcc void @foo(ptr nocapture byval(%pp) %p_arg) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    retl
entry:
        %tmp2 = getelementptr %pp, ptr %p_arg, i64 0, i32 0         ; <ptr> [#uses=
        %tmp3 = load %cc, ptr %tmp2         ; <%cc> [#uses=1]
        %tmp34 = extractvalue %cc %tmp3, 0              ; <%crd> [#uses=1]
        %tmp345 = extractvalue %crd %tmp34, 0           ; <i64> [#uses=1]
        %.ptr.i = load ptr, ptr undef              ; <ptr> [#uses=0]
        %tmp15.i = shl i64 %tmp345, 3           ; <i64> [#uses=0]
        store ptr undef, ptr undef
        ret void
}


