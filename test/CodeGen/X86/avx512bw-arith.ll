; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s

define <64 x i8> @vpaddb512_test(<64 x i8> %i, <64 x i8> %j) nounwind readnone {
; CHECK-LABEL: vpaddb512_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddb %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = add <64 x i8> %i, %j
  ret <64 x i8> %x
}

define <64 x i8> @vpaddb512_fold_test(<64 x i8> %i, ptr %j) nounwind {
; CHECK-LABEL: vpaddb512_fold_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddb (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %tmp = load <64 x i8>, ptr %j, align 4
  %x = add <64 x i8> %i, %tmp
  ret <64 x i8> %x
}

define <32 x i16> @vpaddw512_test(<32 x i16> %i, <32 x i16> %j) nounwind readnone {
; CHECK-LABEL: vpaddw512_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = add <32 x i16> %i, %j
  ret <32 x i16> %x
}

define <32 x i16> @vpaddw512_fold_test(<32 x i16> %i, ptr %j) nounwind {
; CHECK-LABEL: vpaddw512_fold_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpaddw (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %tmp = load <32 x i16>, ptr %j, align 4
  %x = add <32 x i16> %i, %tmp
  ret <32 x i16> %x
}

define <32 x i16> @vpaddw512_mask_test(<32 x i16> %i, <32 x i16> %j, <32 x i16> %mask1) nounwind readnone {
; CHECK-LABEL: vpaddw512_mask_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vptestmw %zmm2, %zmm2, %k1
; CHECK-NEXT:    vpaddw %zmm1, %zmm0, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %x = add <32 x i16> %i, %j
  %r = select <32 x i1> %mask, <32 x i16> %x, <32 x i16> %i
  ret <32 x i16> %r
}

define <32 x i16> @vpaddw512_maskz_test(<32 x i16> %i, <32 x i16> %j, <32 x i16> %mask1) nounwind readnone {
; CHECK-LABEL: vpaddw512_maskz_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vptestmw %zmm2, %zmm2, %k1
; CHECK-NEXT:    vpaddw %zmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %x = add <32 x i16> %i, %j
  %r = select <32 x i1> %mask, <32 x i16> %x, <32 x i16> zeroinitializer
  ret <32 x i16> %r
}

define <32 x i16> @vpaddw512_mask_fold_test(<32 x i16> %i, ptr %j.ptr, <32 x i16> %mask1) nounwind readnone {
; CHECK-LABEL: vpaddw512_mask_fold_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vptestmw %zmm1, %zmm1, %k1
; CHECK-NEXT:    vpaddw (%rdi), %zmm0, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %j = load <32 x i16>, ptr %j.ptr
  %x = add <32 x i16> %i, %j
  %r = select <32 x i1> %mask, <32 x i16> %x, <32 x i16> %i
  ret <32 x i16> %r
}

define <32 x i16> @vpaddw512_maskz_fold_test(<32 x i16> %i, ptr %j.ptr, <32 x i16> %mask1) nounwind readnone {
; CHECK-LABEL: vpaddw512_maskz_fold_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vptestmw %zmm1, %zmm1, %k1
; CHECK-NEXT:    vpaddw (%rdi), %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = icmp ne <32 x i16> %mask1, zeroinitializer
  %j = load <32 x i16>, ptr %j.ptr
  %x = add <32 x i16> %i, %j
  %r = select <32 x i1> %mask, <32 x i16> %x, <32 x i16> zeroinitializer
  ret <32 x i16> %r
}

define <64 x i8> @vpsubb512_test(<64 x i8> %i, <64 x i8> %j) nounwind readnone {
; CHECK-LABEL: vpsubb512_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsubb %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = sub <64 x i8> %i, %j
  ret <64 x i8> %x
}

define <32 x i16> @vpsubw512_test(<32 x i16> %i, <32 x i16> %j) nounwind readnone {
; CHECK-LABEL: vpsubw512_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpsubw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = sub <32 x i16> %i, %j
  ret <32 x i16> %x
}

define <32 x i16> @vpmullw512_test(<32 x i16> %i, <32 x i16> %j) {
; CHECK-LABEL: vpmullw512_test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmullw %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = mul <32 x i16> %i, %j
  ret <32 x i16> %x
}

