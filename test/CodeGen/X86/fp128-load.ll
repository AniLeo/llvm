; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+mmx \
; RUN:     -enable-legalize-types-checking | FileCheck %s

; __float128 myFP128 = 1.0L;  // x86_64-linux-android
@my_fp128 = global fp128 0xL00000000000000003FFF000000000000, align 16

define fp128 @get_fp128() {
; CHECK-LABEL: get_fp128:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movaps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = load fp128, fp128* @my_fp128, align 16
  ret fp128 %0
}

@TestLoadExtend.data = internal unnamed_addr constant [2 x float] [float 0x3FB99999A0000000, float 0x3FC99999A0000000], align 4

define fp128 @TestLoadExtend(fp128 %x, i32 %n) {
; CHECK-LABEL: TestLoadExtend:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movslq %edi, %rax
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    jmp __extendsftf2@PLT # TAILCALL
entry:
  %idxprom = sext i32 %n to i64
  %arrayidx = getelementptr inbounds [2 x float], [2 x float]* @TestLoadExtend.data, i64 0, i64 %idxprom
  %0 = load float, float* %arrayidx, align 4
  %conv = fpext float %0 to fp128
  ret fp128 %conv
}

; CHECK-LABEL:  my_fp128:
; CHECK-NEXT:  .quad   0x0
; CHECK-NEXT:  .quad   0x3fff000000000000
; CHECK-NEXT:  .size   my_fp128, 16
