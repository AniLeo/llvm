; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s
; This should be a flds, not fldt.
define x86_fp80 @test2() nounwind  {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    flds {{\.LCPI.*}}
; CHECK-NEXT:    retl
entry:
	ret x86_fp80 0xK3FFFC000000000000000
}

