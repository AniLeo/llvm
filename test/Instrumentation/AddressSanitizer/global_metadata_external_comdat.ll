; RUN: opt < %s -mtriple=x86_64-linux -asan -asan-module -asan-globals-live-support=0 -S | FileCheck %s

$my_var = comdat any

@my_var = global i32 42, align 4, comdat
; CHECK: @my_var = global i32 42, align 4, comdat

; Don't instrument my_var, it is comdat.
; CHECK-NOT: __asan_register_globals
