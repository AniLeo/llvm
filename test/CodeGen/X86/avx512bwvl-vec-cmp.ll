; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx | FileCheck %s

define <32 x i8> @test256_1(<32 x i8> %x, <32 x i8> %y) nounwind {
; CHECK-LABEL: test256_1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqb %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpblendmb %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp eq <32 x i8> %x, %y
  %max = select <32 x i1> %mask, <32 x i8> %x, <32 x i8> %y
  ret <32 x i8> %max
}

define <32 x i8> @test256_2(<32 x i8> %x, <32 x i8> %y, <32 x i8> %x1) nounwind {
; CHECK-LABEL: test256_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtb %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpblendmb %ymm0, %ymm2, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp sgt <32 x i8> %x, %y
  %max = select <32 x i1> %mask, <32 x i8> %x, <32 x i8> %x1
  ret <32 x i8> %max
}

define <16 x i16> @test256_3(<16 x i16> %x, <16 x i16> %y, <16 x i16> %x1) nounwind {
; CHECK-LABEL: test256_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnltw %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpblendmw %ymm2, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp sge <16 x i16> %x, %y
  %max = select <16 x i1> %mask, <16 x i16> %x1, <16 x i16> %y
  ret <16 x i16> %max
}

define <32 x i8> @test256_4(<32 x i8> %x, <32 x i8> %y, <32 x i8> %x1) nounwind {
; CHECK-LABEL: test256_4:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnleub %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpblendmb %ymm0, %ymm2, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ugt <32 x i8> %x, %y
  %max = select <32 x i1> %mask, <32 x i8> %x, <32 x i8> %x1
  ret <32 x i8> %max
}

define <16 x i16> @test256_5(<16 x i16> %x, <16 x i16> %x1, ptr %yp) nounwind {
; CHECK-LABEL: test256_5:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqw (%rdi), %ymm0, %k1
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i16>, ptr %yp, align 4
  %mask = icmp eq <16 x i16> %x, %y
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %x1
  ret <16 x i16> %max
}

define <16 x i16> @test256_6(<16 x i16> %x, <16 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test256_6:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtw (%rdi), %ymm0, %k1
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i16>, ptr %y.ptr, align 4
  %mask = icmp sgt <16 x i16> %x, %y
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %x1
  ret <16 x i16> %max
}

define <16 x i16> @test256_7(<16 x i16> %x, <16 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test256_7:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmplew (%rdi), %ymm0, %k1
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i16>, ptr %y.ptr, align 4
  %mask = icmp sle <16 x i16> %x, %y
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %x1
  ret <16 x i16> %max
}

define <16 x i16> @test256_8(<16 x i16> %x, <16 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test256_8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleuw (%rdi), %ymm0, %k1
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <16 x i16>, ptr %y.ptr, align 4
  %mask = icmp ule <16 x i16> %x, %y
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %x1
  ret <16 x i16> %max
}

define <16 x i16> @test256_9(<16 x i16> %x, <16 x i16> %y, <16 x i16> %x1, <16 x i16> %y1) nounwind {
; CHECK-LABEL: test256_9:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqw %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpcmpeqw %ymm3, %ymm2, %k1 {%k1}
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp eq <16 x i16> %x1, %y1
  %mask0 = icmp eq <16 x i16> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %y
  ret <16 x i16> %max
}

define <32 x i8> @test256_10(<32 x i8> %x, <32 x i8> %y, <32 x i8> %x1, <32 x i8> %y1) nounwind {
; CHECK-LABEL: test256_10:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleb %ymm1, %ymm0, %k1
; CHECK-NEXT:    vpcmpnltb %ymm3, %ymm2, %k1 {%k1}
; CHECK-NEXT:    vpblendmb %ymm0, %ymm2, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <32 x i8> %x1, %y1
  %mask0 = icmp sle <32 x i8> %x, %y
  %mask = select <32 x i1> %mask0, <32 x i1> %mask1, <32 x i1> zeroinitializer
  %max = select <32 x i1> %mask, <32 x i8> %x, <32 x i8> %x1
  ret <32 x i8> %max
}

define <32 x i8> @test256_11(<32 x i8> %x, ptr %y.ptr, <32 x i8> %x1, <32 x i8> %y1) nounwind {
; CHECK-LABEL: test256_11:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtb %ymm2, %ymm1, %k1
; CHECK-NEXT:    vpcmpgtb (%rdi), %ymm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmb %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sgt <32 x i8> %x1, %y1
  %y = load <32 x i8>, ptr %y.ptr, align 4
  %mask0 = icmp sgt <32 x i8> %x, %y
  %mask = select <32 x i1> %mask0, <32 x i1> %mask1, <32 x i1> zeroinitializer
  %max = select <32 x i1> %mask, <32 x i8> %x, <32 x i8> %x1
  ret <32 x i8> %max
}

define <16 x i16> @test256_12(<16 x i16> %x, ptr %y.ptr, <16 x i16> %x1, <16 x i16> %y1) nounwind {
; CHECK-LABEL: test256_12:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnltw %ymm2, %ymm1, %k1
; CHECK-NEXT:    vpcmpleuw (%rdi), %ymm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmw %ymm0, %ymm1, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <16 x i16> %x1, %y1
  %y = load <16 x i16>, ptr %y.ptr, align 4
  %mask0 = icmp ule <16 x i16> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i16> %x, <16 x i16> %x1
  ret <16 x i16> %max
}

define <16 x i8> @test128_1(<16 x i8> %x, <16 x i8> %y) nounwind {
; CHECK-LABEL: test128_1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqb %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpblendmb %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp eq <16 x i8> %x, %y
  %max = select <16 x i1> %mask, <16 x i8> %x, <16 x i8> %y
  ret <16 x i8> %max
}

define <16 x i8> @test128_2(<16 x i8> %x, <16 x i8> %y, <16 x i8> %x1) nounwind {
; CHECK-LABEL: test128_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtb %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpblendmb %xmm0, %xmm2, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp sgt <16 x i8> %x, %y
  %max = select <16 x i1> %mask, <16 x i8> %x, <16 x i8> %x1
  ret <16 x i8> %max
}

define <8 x i16> @test128_3(<8 x i16> %x, <8 x i16> %y, <8 x i16> %x1) nounwind {
; CHECK-LABEL: test128_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnltw %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpblendmw %xmm2, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp sge <8 x i16> %x, %y
  %max = select <8 x i1> %mask, <8 x i16> %x1, <8 x i16> %y
  ret <8 x i16> %max
}

define <16 x i8> @test128_4(<16 x i8> %x, <16 x i8> %y, <16 x i8> %x1) nounwind {
; CHECK-LABEL: test128_4:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnleub %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpblendmb %xmm0, %xmm2, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = icmp ugt <16 x i8> %x, %y
  %max = select <16 x i1> %mask, <16 x i8> %x, <16 x i8> %x1
  ret <16 x i8> %max
}

define <8 x i16> @test128_5(<8 x i16> %x, <8 x i16> %x1, ptr %yp) nounwind {
; CHECK-LABEL: test128_5:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqw (%rdi), %xmm0, %k1
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <8 x i16>, ptr %yp, align 4
  %mask = icmp eq <8 x i16> %x, %y
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %x1
  ret <8 x i16> %max
}

define <8 x i16> @test128_6(<8 x i16> %x, <8 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test128_6:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtw (%rdi), %xmm0, %k1
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <8 x i16>, ptr %y.ptr, align 4
  %mask = icmp sgt <8 x i16> %x, %y
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %x1
  ret <8 x i16> %max
}

define <8 x i16> @test128_7(<8 x i16> %x, <8 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test128_7:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmplew (%rdi), %xmm0, %k1
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <8 x i16>, ptr %y.ptr, align 4
  %mask = icmp sle <8 x i16> %x, %y
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %x1
  ret <8 x i16> %max
}

define <8 x i16> @test128_8(<8 x i16> %x, <8 x i16> %x1, ptr %y.ptr) nounwind {
; CHECK-LABEL: test128_8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleuw (%rdi), %xmm0, %k1
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %y = load <8 x i16>, ptr %y.ptr, align 4
  %mask = icmp ule <8 x i16> %x, %y
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %x1
  ret <8 x i16> %max
}

define <8 x i16> @test128_9(<8 x i16> %x, <8 x i16> %y, <8 x i16> %x1, <8 x i16> %y1) nounwind {
; CHECK-LABEL: test128_9:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpeqw %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpcmpeqw %xmm3, %xmm2, %k1 {%k1}
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp eq <8 x i16> %x1, %y1
  %mask0 = icmp eq <8 x i16> %x, %y
  %mask = select <8 x i1> %mask0, <8 x i1> %mask1, <8 x i1> zeroinitializer
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %y
  ret <8 x i16> %max
}

define <16 x i8> @test128_10(<16 x i8> %x, <16 x i8> %y, <16 x i8> %x1, <16 x i8> %y1) nounwind {
; CHECK-LABEL: test128_10:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpleb %xmm1, %xmm0, %k1
; CHECK-NEXT:    vpcmpnltb %xmm3, %xmm2, %k1 {%k1}
; CHECK-NEXT:    vpblendmb %xmm0, %xmm2, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <16 x i8> %x1, %y1
  %mask0 = icmp sle <16 x i8> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i8> %x, <16 x i8> %x1
  ret <16 x i8> %max
}

define <16 x i8> @test128_11(<16 x i8> %x, ptr %y.ptr, <16 x i8> %x1, <16 x i8> %y1) nounwind {
; CHECK-LABEL: test128_11:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpgtb %xmm2, %xmm1, %k1
; CHECK-NEXT:    vpcmpgtb (%rdi), %xmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmb %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sgt <16 x i8> %x1, %y1
  %y = load <16 x i8>, ptr %y.ptr, align 4
  %mask0 = icmp sgt <16 x i8> %x, %y
  %mask = select <16 x i1> %mask0, <16 x i1> %mask1, <16 x i1> zeroinitializer
  %max = select <16 x i1> %mask, <16 x i8> %x, <16 x i8> %x1
  ret <16 x i8> %max
}

define <8 x i16> @test128_12(<8 x i16> %x, ptr %y.ptr, <8 x i16> %x1, <8 x i16> %y1) nounwind {
; CHECK-LABEL: test128_12:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpcmpnltw %xmm2, %xmm1, %k1
; CHECK-NEXT:    vpcmpleuw (%rdi), %xmm0, %k1 {%k1}
; CHECK-NEXT:    vpblendmw %xmm0, %xmm1, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %mask1 = icmp sge <8 x i16> %x1, %y1
  %y = load <8 x i16>, ptr %y.ptr, align 4
  %mask0 = icmp ule <8 x i16> %x, %y
  %mask = select <8 x i1> %mask0, <8 x i1> %mask1, <8 x i1> zeroinitializer
  %max = select <8 x i1> %mask, <8 x i16> %x, <8 x i16> %x1
  ret <8 x i16> %max
}
