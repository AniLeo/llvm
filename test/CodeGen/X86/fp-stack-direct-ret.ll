; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s --check-prefix=ALL
; RUN: llc < %s -mtriple=i686-- -mcpu=yonah | FileCheck %s --check-prefix=ALL

declare double @foo()

define double @bar() {
; ALL-LABEL: bar:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    jmp foo # TAILCALL
entry:
	%tmp5 = tail call double @foo()
	ret double %tmp5
}

