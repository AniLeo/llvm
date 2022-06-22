; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=CHECK

; fold (sra (load i32), 16)) -> (sextload i16)
define i32 @sra_half(ptr %p) {
; CHECK-LABEL: sra_half:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswl 2(%rdi), %eax
; CHECK-NEXT:    retq
  %load = load i32, ptr %p
  %shift = ashr i32 %load, 16
  ret i32 %shift
}

; Vector version not folded.
define <4 x i32> @sra_half_vec(ptr %p) {
; CHECK-LABEL: sra_half_vec:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa (%rdi), %xmm0
; CHECK-NEXT:    psrad $16, %xmm0
; CHECK-NEXT:    retq
  %load = load <4 x i32>, ptr %p
  %shift = ashr <4 x i32> %load, <i32 16, i32 16, i32 16, i32 16>
  ret <4 x i32> %shift
}

; fold (sra (load i64), 48)) -> (sextload i16)
define i64 @sra_large_shift(ptr %r) {
; CHECK-LABEL: sra_large_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswq 6(%rdi), %rax
; CHECK-NEXT:    retq
  %t0 = load i64, ptr %r
  %conv = ashr i64 %t0, 48
  ret i64 %conv
}

; Negative test, no fold expected.
define i32 @sra_small_shift(ptr %p) {
; CHECK-LABEL: sra_small_shift:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl (%rdi), %eax
; CHECK-NEXT:    sarl $8, %eax
; CHECK-NEXT:    retq
  %load = load i32, ptr %p
  %shift = ashr i32 %load, 8
  ret i32 %shift
}

; This should be folded to a zextload.
define i32 @sra_of_zextload(ptr %p) {
; CHECK-LABEL: sra_of_zextload:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movzbl 1(%rdi), %eax
; CHECK-NEXT:    retq
  %load = load i16, ptr %p
  %zext = zext i16 %load to i32
  %shift = ashr i32 %zext, 8
  ret i32 %shift
}

; fold (sra (sextload i16 to i32), 8) -> (sextload i8)
define i32 @sra_of_sextload(ptr %p) {
; CHECK-LABEL: sra_of_sextload:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsbl 1(%rdi), %eax
; CHECK-NEXT:    retq
  %load = load i16, ptr %p
  %sext = sext i16 %load to i32
  %shift = ashr i32 %sext, 8
  ret i32 %shift
}

; Negative test. If the shift amount is larger than the memory type then
; we're not accessing any of the loaded bytes (only the extended bits). So the
; shift is expected to remain.
define i32 @sra_of_sextload_no_fold(ptr %p) {
; CHECK-LABEL: sra_of_sextload_no_fold:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswl (%rdi), %eax
; CHECK-NEXT:    sarl $16, %eax
; CHECK-NEXT:    retq
  %load = load i16, ptr %p
  %sext = sext i16 %load to i32
  %shift = ashr i32 %sext, 16
  ret i32 %shift
}

; Fold even if SRA has multiple uses.
define i32 @sra_to_sextload_multiple_sra_uses(ptr %p) {
; CHECK-LABEL: sra_to_sextload_multiple_sra_uses:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movswl 2(%rdi), %ecx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    xorl $6, %eax
; CHECK-NEXT:    orl %ecx, %eax
; CHECK-NEXT:    retq
  %load = load i32, ptr %p
  %shift = ashr i32 %load, 16
  %use1 = xor i32 %shift, 6
  %use2 = or i32 %shift, %use1
  ret i32 %use2
}
