; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

@zeroinit = constant {} zeroinitializer
@undef = constant {} undef

define i32 @crash_on_zeroinit() {
; CHECK-LABEL: @crash_on_zeroinit(
; CHECK:         ret i32 0
;
  %load = load i32, i32* bitcast ({}* @zeroinit to i32*)
  ret i32 %load
}

define i32 @crash_on_undef() {
; CHECK-LABEL: @crash_on_undef(
; CHECK:         ret i32 undef
;
  %load = load i32, i32* bitcast ({}* @undef to i32*)
  ret i32 %load
}

@GV = private constant [8 x i32] [i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49]

define <8 x i32> @partial_load() {
; CHECK-LABEL: @partial_load(
; CHECK:         ret <8 x i32> <i32 0, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48>
  %load = load <8 x i32>, <8 x i32>* bitcast (i32* getelementptr ([8 x i32], [8 x i32]* @GV, i64 0, i64 -1) to <8 x i32>*)
  ret <8 x i32> %load
}

@constvec = internal constant <3 x float> <float 0xBFDA20BC40000000, float 0xBFE6A09EE0000000, float 0x3FE279A760000000>

; This does an out of bounds load from the global constant
define <3 x float> @load_vec3() {
; CHECK-LABEL: @load_vec3(
; CHECK-NEXT:    ret <3 x float> undef
  %1 = load <3 x float>, <3 x float>* getelementptr inbounds (<3 x float>, <3 x float>* @constvec, i64 1)
  ret <3 x float> %1
}
