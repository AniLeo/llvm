; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc -mtriple=x86_64-apple-darwin -mcpu=skx < %s | FileCheck %s

define i32 @combineTESTM_AND_1(<8 x i64> %a, <8 x i64> %b) {
; CHECK-LABEL: combineTESTM_AND_1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovb %k0, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %and.i = and <8 x i64> %b, %a
  %test.i = tail call i8 @llvm.x86.avx512.ptestm.q.512(<8 x i64> %and.i, <8 x i64> %and.i, i8 -1)
  %conv = zext i8 %test.i to i32
  ret i32 %conv
}

define i32 @combineTESTM_AND_2(<8 x i64> %a, <8 x i64> %b , i8 %mask) {
; CHECK-LABEL: combineTESTM_AND_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq %zmm0, %zmm1, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    andb %dil, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %and.i = and <8 x i64> %b, %a
  %test.i = tail call i8 @llvm.x86.avx512.ptestm.q.512(<8 x i64> %and.i, <8 x i64> %and.i, i8 %mask)
  %conv = zext i8 %test.i to i32
  ret i32 %conv
}

define i32 @combineTESTM_AND_mask_3(<8 x i64> %a, <8 x i64>* %bptr , i8 %mask) {
; CHECK-LABEL: combineTESTM_AND_mask_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq (%rdi), %zmm0, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %b = load <8 x i64>, <8 x i64>* %bptr
  %and.i = and <8 x i64> %a, %b
  %test.i = tail call i8 @llvm.x86.avx512.ptestm.q.512(<8 x i64> %and.i, <8 x i64> %and.i, i8 %mask)
  %conv = zext i8 %test.i to i32
  ret i32 %conv
}

define i32 @combineTESTM_AND_mask_4(<8 x i64> %a, <8 x i64>* %bptr , i8 %mask) {
; CHECK-LABEL: combineTESTM_AND_mask_4:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vptestmq (%rdi), %zmm0, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %b = load <8 x i64>, <8 x i64>* %bptr
  %and.i = and <8 x i64> %b, %a
  %test.i = tail call i8 @llvm.x86.avx512.ptestm.q.512(<8 x i64> %and.i, <8 x i64> %and.i, i8 %mask)
  %conv = zext i8 %test.i to i32
  ret i32 %conv
}

declare i8 @llvm.x86.avx512.ptestm.q.512(<8 x i64>, <8 x i64>, i8)
