; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s | FileCheck %s

; The complex floating value will be returned by a single register for LP64 ABI.
; The test case check that the real part returned by __addsf3 will be
; cleared upper bits by shifts to avoid corrupting the imaginary part.

define i64 @complex_float_add(i64 %a.coerce, i64 %b.coerce) nounwind {
; CHECK-LABEL: complex_float_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -32
; CHECK-NEXT:    sd ra, 24(sp)
; CHECK-NEXT:    sd s0, 16(sp)
; CHECK-NEXT:    sd s1, 8(sp)
; CHECK-NEXT:    sd s2, 0(sp)
; CHECK-NEXT:    mv s0, a1
; CHECK-NEXT:    mv s1, a0
; CHECK-NEXT:    call __addsf3
; CHECK-NEXT:    mv s2, a0
; CHECK-NEXT:    srli a0, s1, 32
; CHECK-NEXT:    srli a1, s0, 32
; CHECK-NEXT:    call __addsf3
; CHECK-NEXT:    slli a1, s2, 32
; CHECK-NEXT:    srli a1, a1, 32
; CHECK-NEXT:    slli a0, a0, 32
; CHECK-NEXT:    or a0, a0, a1
; CHECK-NEXT:    ld s2, 0(sp)
; CHECK-NEXT:    ld s1, 8(sp)
; CHECK-NEXT:    ld s0, 16(sp)
; CHECK-NEXT:    ld ra, 24(sp)
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
entry:
  %a.sroa.0.0.extract.trunc = trunc i64 %a.coerce to i32
  %0 = bitcast i32 %a.sroa.0.0.extract.trunc to float
  %a.sroa.2.0.extract.shift = lshr i64 %a.coerce, 32
  %a.sroa.2.0.extract.trunc = trunc i64 %a.sroa.2.0.extract.shift to i32
  %1 = bitcast i32 %a.sroa.2.0.extract.trunc to float
  %b.sroa.0.0.extract.trunc = trunc i64 %b.coerce to i32
  %2 = bitcast i32 %b.sroa.0.0.extract.trunc to float
  %b.sroa.2.0.extract.shift = lshr i64 %b.coerce, 32
  %b.sroa.2.0.extract.trunc = trunc i64 %b.sroa.2.0.extract.shift to i32
  %3 = bitcast i32 %b.sroa.2.0.extract.trunc to float
  %add.r = fadd float %0, %2
  %add.i = fadd float %1, %3
  %4 = bitcast float %add.r to i32
  %5 = bitcast float %add.i to i32
  %retval.sroa.2.0.insert.ext = zext i32 %5 to i64
  %retval.sroa.2.0.insert.shift = shl nuw i64 %retval.sroa.2.0.insert.ext, 32
  %retval.sroa.0.0.insert.ext = zext i32 %4 to i64
  %retval.sroa.0.0.insert.insert = or i64 %retval.sroa.2.0.insert.shift, %retval.sroa.0.0.insert.ext
  ret i64 %retval.sroa.0.0.insert.insert
}
