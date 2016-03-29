; RUN: opt < %s -inline -S | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

define i32 @noattr_callee(i32 %i) {
  ret i32 %i
}

define i32 @sanitize_address_callee(i32 %i) sanitize_address {
  ret i32 %i
}

define i32 @sanitize_thread_callee(i32 %i) sanitize_thread {
  ret i32 %i
}

define i32 @sanitize_memory_callee(i32 %i) sanitize_memory {
  ret i32 %i
}

define i32 @alwaysinline_callee(i32 %i) alwaysinline {
  ret i32 %i
}

define i32 @alwaysinline_sanitize_address_callee(i32 %i) alwaysinline sanitize_address {
  ret i32 %i
}

define i32 @alwaysinline_sanitize_thread_callee(i32 %i) alwaysinline sanitize_thread {
  ret i32 %i
}

define i32 @alwaysinline_sanitize_memory_callee(i32 %i) alwaysinline sanitize_memory {
  ret i32 %i
}


; Check that:
;  * noattr callee is inlined into noattr caller,
;  * sanitize_(address|memory|thread) callee is not inlined into noattr caller,
;  * alwaysinline callee is always inlined no matter what sanitize_* attributes are present.

define i32 @test_no_sanitize_address(i32 %arg) {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_address_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_address_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_no_sanitize_address(
; CHECK-NEXT: @sanitize_address_callee
; CHECK-NEXT: ret i32
}

define i32 @test_no_sanitize_memory(i32 %arg) {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_memory_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_memory_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_no_sanitize_memory(
; CHECK-NEXT: @sanitize_memory_callee
; CHECK-NEXT: ret i32
}

define i32 @test_no_sanitize_thread(i32 %arg) {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_thread_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_thread_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_no_sanitize_thread(
; CHECK-NEXT: @sanitize_thread_callee
; CHECK-NEXT: ret i32
}


; Check that:
;  * noattr callee is not inlined into sanitize_(address|memory|thread) caller,
;  * sanitize_(address|memory|thread) callee is inlined into the caller with the same attribute,
;  * alwaysinline callee is always inlined no matter what sanitize_* attributes are present.

define i32 @test_sanitize_address(i32 %arg) sanitize_address {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_address_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_address_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_sanitize_address(
; CHECK-NEXT: @noattr_callee
; CHECK-NEXT: ret i32
}

define i32 @test_sanitize_memory(i32 %arg) sanitize_memory {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_memory_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_memory_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_sanitize_memory(
; CHECK-NEXT: @noattr_callee
; CHECK-NEXT: ret i32
}

define i32 @test_sanitize_thread(i32 %arg) sanitize_thread {
  %x1 = call i32 @noattr_callee(i32 %arg)
  %x2 = call i32 @sanitize_thread_callee(i32 %x1)
  %x3 = call i32 @alwaysinline_callee(i32 %x2)
  %x4 = call i32 @alwaysinline_sanitize_thread_callee(i32 %x3)
  ret i32 %x4
; CHECK-LABEL: @test_sanitize_thread(
; CHECK-NEXT: @noattr_callee
; CHECK-NEXT: ret i32
}

; Check that a function doesn't get inlined if target-cpu strings don't match
; exactly.
define i32 @test_target_cpu_callee0(i32 %i) "target-cpu"="corei7" {
  ret i32 %i
}

define i32 @test_target_cpu0(i32 %i) "target-cpu"="corei7" {
  %1 = call i32 @test_target_cpu_callee0(i32 %i)
  ret i32 %1
; CHECK-LABEL: @test_target_cpu0(
; CHECK-NOT: @test_target_cpu_callee0
}

define i32 @test_target_cpu_callee1(i32 %i) "target-cpu"="x86-64" {
  ret i32 %i
}

define i32 @test_target_cpu1(i32 %i) "target-cpu"="corei7" {
  %1 = call i32 @test_target_cpu_callee1(i32 %i)
  ret i32 %1
; CHECK-LABEL: @test_target_cpu1(
; CHECK-NEXT: @test_target_cpu_callee1
; CHECK-NEXT: ret i32
}

; Check that a function doesn't get inlined if target-features strings don't
; match exactly.
define i32 @test_target_features_callee0(i32 %i)  "target-features"="+sse4.2" {
  ret i32 %i
}

define i32 @test_target_features0(i32 %i) "target-features"="+sse4.2" {
  %1 = call i32 @test_target_features_callee0(i32 %i)
  ret i32 %1
; CHECK-LABEL: @test_target_features0(
; CHECK-NOT: @test_target_features_callee0
}

define i32 @test_target_features_callee1(i32 %i) "target-features"="+avx2" {
  ret i32 %i
}

define i32 @test_target_features1(i32 %i) "target-features"="+sse4.2" {
  %1 = call i32 @test_target_features_callee1(i32 %i)
  ret i32 %1
; CHECK-LABEL: @test_target_features1(
; CHECK-NEXT: @test_target_features_callee1
; CHECK-NEXT: ret i32
}

define i32 @less-precise-fpmad_callee0(i32 %i) "less-precise-fpmad"="false" {
  ret i32 %i
; CHECK: @less-precise-fpmad_callee0(i32 %i) [[FPMAD_FALSE:#[0-9]+]] {
; CHECK-NEXT: ret i32
}

define i32 @less-precise-fpmad_callee1(i32 %i) "less-precise-fpmad"="true" {
  ret i32 %i
; CHECK: @less-precise-fpmad_callee1(i32 %i) [[FPMAD_TRUE:#[0-9]+]] {
; CHECK-NEXT: ret i32
}

define i32 @test_less-precise-fpmad0(i32 %i) "less-precise-fpmad"="false" {
  %1 = call i32 @less-precise-fpmad_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_less-precise-fpmad0(i32 %i) [[FPMAD_FALSE]] {
; CHECK-NEXT: ret i32
}

define i32 @test_less-precise-fpmad1(i32 %i) "less-precise-fpmad"="false" {
  %1 = call i32 @less-precise-fpmad_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_less-precise-fpmad1(i32 %i) [[FPMAD_FALSE]] {
; CHECK-NEXT: ret i32
}

define i32 @test_less-precise-fpmad2(i32 %i) "less-precise-fpmad"="true" {
  %1 = call i32 @less-precise-fpmad_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_less-precise-fpmad2(i32 %i) [[FPMAD_FALSE]] {
; CHECK-NEXT: ret i32
}

define i32 @test_less-precise-fpmad3(i32 %i) "less-precise-fpmad"="true" {
  %1 = call i32 @less-precise-fpmad_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_less-precise-fpmad3(i32 %i) [[FPMAD_TRUE]] {
; CHECK-NEXT: ret i32
}

define i32 @no-implicit-float_callee0(i32 %i) {
  ret i32 %i
; CHECK: @no-implicit-float_callee0(i32 %i) {
; CHECK-NEXT: ret i32
}

define i32 @no-implicit-float_callee1(i32 %i) noimplicitfloat {
  ret i32 %i
; CHECK: @no-implicit-float_callee1(i32 %i) [[NOIMPLICITFLOAT:#[0-9]+]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-implicit-float0(i32 %i) {
  %1 = call i32 @no-implicit-float_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_no-implicit-float0(i32 %i) {
; CHECK-NEXT: ret i32
}

define i32 @test_no-implicit-float1(i32 %i) {
  %1 = call i32 @no-implicit-float_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_no-implicit-float1(i32 %i) [[NOIMPLICITFLOAT]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-implicit-float2(i32 %i) noimplicitfloat {
  %1 = call i32 @no-implicit-float_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_no-implicit-float2(i32 %i) [[NOIMPLICITFLOAT]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-implicit-float3(i32 %i) noimplicitfloat {
  %1 = call i32 @no-implicit-float_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_no-implicit-float3(i32 %i) [[NOIMPLICITFLOAT]] {
; CHECK-NEXT: ret i32
}

; Check that no-jump-tables flag propagates from inlined callee to caller 

define i32 @no-use-jump-tables_callee0(i32 %i) {
  ret i32 %i
; CHECK: @no-use-jump-tables_callee0(i32 %i) {
; CHECK-NEXT: ret i32
}

define i32 @no-use-jump-tables_callee1(i32 %i) "no-jump-tables"="true" {
  ret i32 %i
; CHECK: @no-use-jump-tables_callee1(i32 %i) [[NOUSEJUMPTABLES:#[0-9]+]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-use-jump-tables0(i32 %i) {
  %1 = call i32 @no-use-jump-tables_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_no-use-jump-tables0(i32 %i) {
; CHECK-NEXT: ret i32
}

define i32 @test_no-use-jump-tables1(i32 %i) {
  %1 = call i32 @no-use-jump-tables_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_no-use-jump-tables1(i32 %i) [[NOUSEJUMPTABLES]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-use-jump-tables2(i32 %i) "no-jump-tables"="true" {
  %1 = call i32 @no-use-jump-tables_callee0(i32 %i)
  ret i32 %1
; CHECK: @test_no-use-jump-tables2(i32 %i) [[NOUSEJUMPTABLES]] {
; CHECK-NEXT: ret i32
}

define i32 @test_no-use-jump-tables3(i32 %i) "no-jump-tables"="true" {
  %1 = call i32 @no-use-jump-tables_callee1(i32 %i)
  ret i32 %1
; CHECK: @test_no-use-jump-tables3(i32 %i) [[NOUSEJUMPTABLES]] {
; CHECK-NEXT: ret i32
}

; CHECK: attributes [[FPMAD_FALSE]] = { "less-precise-fpmad"="false" }
; CHECK: attributes [[FPMAD_TRUE]] = { "less-precise-fpmad"="true" }
; CHECK: attributes [[NOIMPLICITFLOAT]] = { noimplicitfloat }
; CHECK: attributes [[NOUSEJUMPTABLES]] = { "no-jump-tables"="true" }