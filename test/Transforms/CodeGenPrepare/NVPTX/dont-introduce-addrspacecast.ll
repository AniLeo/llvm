; RUN: opt -S -codegenprepare < %s | FileCheck %s

target datalayout = "e-i64:64-v16:16-v32:32-n16:32:64"
target triple = "nvptx64-nvidia-cuda"


; ptrtoint/inttoptr combinations can introduce semantically-meaningful address space casts
; which we can't sink into an addrspacecast

; CHECK-LABEL: @test
define void @test(i8* %input_ptr) {
  ; CHECK-LABEL: l1:
  ; CHECK-NOT: addrspacecast
  %intptr = ptrtoint i8* %input_ptr to i64
  %ptr = inttoptr i64 %intptr to i32 addrspace(3)*

  br label %l1
l1:

  store atomic i32 1, i32 addrspace(3)* %ptr unordered, align 4
  ret void
}


; we still should be able to look through multiple sequences of inttoptr/ptrtoint

; CHECK-LABEL: @test2
define void @test2(i8* %input_ptr) {
  ; CHECK-LABEL: l2:
  ; CHECK: bitcast
  ; CHECK-NEXT: store
  %intptr = ptrtoint i8* %input_ptr to i64
  %ptr = inttoptr i64 %intptr to i32 addrspace(3)*

  %intptr2 = ptrtoint i32 addrspace(3)* %ptr to i64
  %ptr2 = inttoptr i64 %intptr2 to i32*

  br label %l2
l2:

  store atomic i32 1, i32* %ptr2 unordered, align 4
  ret void
}
