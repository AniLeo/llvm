; RUN: llc < %s -asm-verbose=false | FileCheck %s

; Test that basic conversion operations assemble as expected.

target datalayout = "e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; CHECK-LABEL: $i32_wrap_i64
; CHECK-NEXT: (param i64) (result i32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i32_wrap @0))
; CHECK-NEXT: (return @1)
define i32 @i32_wrap_i64(i64 %x) {
  %a = trunc i64 %x to i32
  ret i32 %a
}

; CHECK-LABEL: $i64_extend_s_i32
; CHECK-NEXT: (param i32) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_extend_s @0))
; CHECK-NEXT: (return @1)
define i64 @i64_extend_s_i32(i32 %x) {
  %a = sext i32 %x to i64
  ret i64 %a
}

; CHECK-LABEL: $i64_extend_u_i32
; CHECK-NEXT: (param i32) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_extend_u @0))
; CHECK-NEXT: (return @1)
define i64 @i64_extend_u_i32(i32 %x) {
  %a = zext i32 %x to i64
  ret i64 %a
}

; CHECK-LABEL: $i32_trunc_s_f32
; CHECK-NEXT: (param f32) (result i32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i32_trunc_s @0))
; CHECK-NEXT: (return @1)
define i32 @i32_trunc_s_f32(float %x) {
  %a = fptosi float %x to i32
  ret i32 %a
}

; CHECK-LABEL: $i32_trunc_u_f32
; CHECK-NEXT: (param f32) (result i32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i32_trunc_u @0))
; CHECK-NEXT: (return @1)
define i32 @i32_trunc_u_f32(float %x) {
  %a = fptoui float %x to i32
  ret i32 %a
}

; CHECK-LABEL: $i32_trunc_s_f64
; CHECK-NEXT: (param f64) (result i32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i32_trunc_s @0))
; CHECK-NEXT: (return @1)
define i32 @i32_trunc_s_f64(double %x) {
  %a = fptosi double %x to i32
  ret i32 %a
}

; CHECK-LABEL: $i32_trunc_u_f64
; CHECK-NEXT: (param f64) (result i32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i32_trunc_u @0))
; CHECK-NEXT: (return @1)
define i32 @i32_trunc_u_f64(double %x) {
  %a = fptoui double %x to i32
  ret i32 %a
}

; CHECK-LABEL: $i64_trunc_s_f32
; CHECK-NEXT: (param f32) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_trunc_s @0))
; CHECK-NEXT: (return @1)
define i64 @i64_trunc_s_f32(float %x) {
  %a = fptosi float %x to i64
  ret i64 %a
}

; CHECK-LABEL: $i64_trunc_u_f32
; CHECK-NEXT: (param f32) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_trunc_u @0))
; CHECK-NEXT: (return @1)
define i64 @i64_trunc_u_f32(float %x) {
  %a = fptoui float %x to i64
  ret i64 %a
}

; CHECK-LABEL: $i64_trunc_s_f64
; CHECK-NEXT: (param f64) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_trunc_s @0))
; CHECK-NEXT: (return @1)
define i64 @i64_trunc_s_f64(double %x) {
  %a = fptosi double %x to i64
  ret i64 %a
}

; CHECK-LABEL: $i64_trunc_u_f64
; CHECK-NEXT: (param f64) (result i64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (i64_trunc_u @0))
; CHECK-NEXT: (return @1)
define i64 @i64_trunc_u_f64(double %x) {
  %a = fptoui double %x to i64
  ret i64 %a
}

; CHECK-LABEL: $f32_convert_s_i32
; CHECK-NEXT: (param i32) (result f32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f32_convert_s @0))
; CHECK-NEXT: (return @1)
define float @f32_convert_s_i32(i32 %x) {
  %a = sitofp i32 %x to float
  ret float %a
}

; CHECK-LABEL: $f32_convert_u_i32
; CHECK-NEXT: (param i32) (result f32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f32_convert_u @0))
; CHECK-NEXT: (return @1)
define float @f32_convert_u_i32(i32 %x) {
  %a = uitofp i32 %x to float
  ret float %a
}

; CHECK-LABEL: $f64_convert_s_i32
; CHECK-NEXT: (param i32) (result f64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f64_convert_s @0))
; CHECK-NEXT: (return @1)
define double @f64_convert_s_i32(i32 %x) {
  %a = sitofp i32 %x to double
  ret double %a
}

; CHECK-LABEL: $f64_convert_u_i32
; CHECK-NEXT: (param i32) (result f64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f64_convert_u @0))
; CHECK-NEXT: (return @1)
define double @f64_convert_u_i32(i32 %x) {
  %a = uitofp i32 %x to double
  ret double %a
}

; CHECK-LABEL: $f32_convert_s_i64
; CHECK-NEXT: (param i64) (result f32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f32_convert_s @0))
; CHECK-NEXT: (return @1)
define float @f32_convert_s_i64(i64 %x) {
  %a = sitofp i64 %x to float
  ret float %a
}

; CHECK-LABEL: $f32_convert_u_i64
; CHECK-NEXT: (param i64) (result f32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f32_convert_u @0))
; CHECK-NEXT: (return @1)
define float @f32_convert_u_i64(i64 %x) {
  %a = uitofp i64 %x to float
  ret float %a
}

; CHECK-LABEL: $f64_convert_s_i64
; CHECK-NEXT: (param i64) (result f64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f64_convert_s @0))
; CHECK-NEXT: (return @1)
define double @f64_convert_s_i64(i64 %x) {
  %a = sitofp i64 %x to double
  ret double %a
}

; CHECK-LABEL: $f64_convert_u_i64
; CHECK-NEXT: (param i64) (result f64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f64_convert_u @0))
; CHECK-NEXT: (return @1)
define double @f64_convert_u_i64(i64 %x) {
  %a = uitofp i64 %x to double
  ret double %a
}

; CHECK-LABEL: $f64_promote_f32
; CHECK-NEXT: (param f32) (result f64)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f64_promote @0))
; CHECK-NEXT: (return @1)
define double @f64_promote_f32(float %x) {
  %a = fpext float %x to double
  ret double %a
}

; CHECK-LABEL: $f32_demote_f64
; CHECK-NEXT: (param f64) (result f32)
; CHECK-NEXT: (set_local @0 (argument 0))
; CHECK-NEXT: (set_local @1 (f32_demote @0))
; CHECK-NEXT: (return @1)
define float @f32_demote_f64(double %x) {
  %a = fptrunc double %x to float
  ret float %a
}
