; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -inline < %s | FileCheck %s
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -passes='cgscc(inline)' < %s | FileCheck %s

define i32 @func_default() #0 {
; CHECK-LABEL: @func_default(
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @func_denormal_fp_math_ieee_ieee() #1 {
; CHECK-LABEL: @func_denormal_fp_math_ieee_ieee(
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @func_denormal_fp_math_flush_flush() #2 {
; CHECK-LABEL: @func_denormal_fp_math_flush_flush(
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @call_func_ieee_ieee_from_flush_flush() #2 {
; CHECK-LABEL: @call_func_ieee_ieee_from_flush_flush(
; CHECK-NEXT:    ret i32 0
;
  %call = call i32 @func_denormal_fp_math_ieee_ieee()
  ret i32 %call
}

define i32 @call_func_flush_flush_from_ieee_ieee() #1 {
; CHECK-LABEL: @call_func_flush_flush_from_ieee_ieee(
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @func_denormal_fp_math_flush_flush()
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = call i32 @func_denormal_fp_math_flush_flush()
  ret i32 %call
}

define i32 @func_denormal_fp_math_flush_ieee() #3 {
; CHECK-LABEL: @func_denormal_fp_math_flush_ieee(
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @func_denormal_fp_math_ieee_flush() #4 {
; CHECK-LABEL: @func_denormal_fp_math_ieee_flush(
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @call_func_flush_ieee_from_ieee_ieee() #1 {
; CHECK-LABEL: @call_func_flush_ieee_from_ieee_ieee(
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @func_denormal_fp_math_flush_ieee()
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = call i32 @func_denormal_fp_math_flush_ieee()
  ret i32 %call
}

define i32 @call_func_ieee_flush_from_ieee_ieee() #1 {
; CHECK-LABEL: @call_func_ieee_flush_from_ieee_ieee(
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @func_denormal_fp_math_ieee_flush()
; CHECK-NEXT:    ret i32 [[CALL]]
;
  %call = call i32 @func_denormal_fp_math_ieee_flush()
  ret i32 %call
}

attributes #0 = { nounwind }
attributes #1 = { nounwind "denormal-fp-math"="ieee,ieee" }
attributes #2 = { nounwind "denormal-fp-math"="preserve-sign,preserve-sign" }
attributes #3 = { nounwind "denormal-fp-math"="preserve-sign,ieee" }
attributes #4 = { nounwind "denormal-fp-math"="ieee,preserve-sign" }
