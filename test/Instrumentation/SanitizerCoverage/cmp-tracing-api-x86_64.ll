; Test -sanitizer-coverage-trace-compares=1 API declarations on x86_64
; RUN: opt < %s -sancov -sanitizer-coverage-level=1 -sanitizer-coverage-trace-compares=1  -S | FileCheck %s
; RUN: opt < %s -passes='module(sancov-module),function(sancov-func)' -sanitizer-coverage-level=1 -sanitizer-coverage-trace-compares=1  -S | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"
define i32 @foo() #0 {
entry:
  ret i32 0
}

; CHECK-DAG: declare void @__sanitizer_cov_trace_pc_indir(i64)
; CHECK-DAG: declare void @__sanitizer_cov_trace_cmp1(i8 zeroext, i8 zeroext)
; CHECK-DAG: declare void @__sanitizer_cov_trace_cmp2(i16 zeroext, i16 zeroext)
; CHECK-DAG: declare void @__sanitizer_cov_trace_cmp4(i32 zeroext, i32 zeroext)
; CHECK-DAG: declare void @__sanitizer_cov_trace_cmp8(i64, i64)
; CHECK-DAG: declare void @__sanitizer_cov_trace_div4(i32 zeroext)
; CHECK-DAG: declare void @__sanitizer_cov_trace_div8(i64)
; CHECK-DAG: declare void @__sanitizer_cov_trace_gep(i64)
; CHECK-DAG: declare void @__sanitizer_cov_trace_switch(i64, i64*)
; CHECK-DAG: declare void @__sanitizer_cov_trace_pc()
; CHECK-DAG: declare void @__sanitizer_cov_trace_pc_guard(i32*)
; CHECK-DAG: declare void @__sanitizer_cov_trace_pc_guard_init(i32*, i32*)
; CHECK-NOT: declare
