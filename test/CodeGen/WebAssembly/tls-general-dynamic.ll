; RUN: not llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory 2>&1 | FileCheck %s --check-prefix=ERROR
; RUN: not llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory -fast-isel 2>&1 | FileCheck %s --check-prefix=ERROR
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory --mtriple wasm32-unknown-emscripten | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=+bulk-memory --mtriple wasm32-unknown-emscripten -fast-isel | FileCheck %s --check-prefixes=CHECK,TLS
; RUN: llc < %s -asm-verbose=false -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -mattr=-bulk-memory | FileCheck %s --check-prefixes=CHECK,NO-TLS
target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

; ERROR: LLVM ERROR: only -ftls-model=local-exec is supported for now on non-Emscripten OSes: variable tls

; CHECK-LABEL: address_of_tls:
; CHECK-NEXT: .functype  address_of_tls () -> (i32)
define i32 @address_of_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret i32 ptrtoint(i32* @tls to i32)
}

; CHECK-LABEL: ptr_to_tls:
; CHECK-NEXT: .functype ptr_to_tls () -> (i32)
define i32* @ptr_to_tls() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const tls
  ; NO-TLS-NEXT: return
  ret i32* @tls
}

; CHECK-LABEL: tls_load:
; CHECK-NEXT: .functype tls_load () -> (i32)
define i32 @tls_load() {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.load 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.load tls
  ; NO-TLS-NEXT: return
  %tmp = load i32, i32* @tls, align 4
  ret i32 %tmp
}

; CHECK-LABEL: tls_store:
; CHECK-NEXT: .functype tls_store (i32) -> ()
define void @tls_store(i32 %x) {
  ; TLS-DAG: global.get __tls_base
  ; TLS-DAG: i32.const tls
  ; TLS-NEXT: i32.add
  ; TLS-NEXT: i32.store 0
  ; TLS-NEXT: return

  ; NO-TLS-NEXT: i32.const 0
  ; NO-TLS-NEXT: i32.store tls
  ; NO-TLS-NEXT: return
  store i32 %x, i32* @tls, align 4
  ret void
}

; CHECK-LABEL: tls_size:
; CHECK-NEXT: .functype tls_size () -> (i32)
define i32 @tls_size() {
; CHECK-NEXT: global.get __tls_size
; CHECK-NEXT: return
  %1 = call i32 @llvm.wasm.tls.size.i32()
  ret i32 %1
}

; CHECK: .type tls,@object
; TLS-NEXT: .section .tbss.tls,"",@
; NO-TLS-NEXT: .section .bss.tls,"",@
; CHECK-NEXT: .p2align 2
; CHECK-NEXT: tls:
; CHECK-NEXT: .int32 0
@tls = internal thread_local global i32 0

declare i32 @llvm.wasm.tls.size.i32()
