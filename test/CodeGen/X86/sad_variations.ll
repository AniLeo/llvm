; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f  | FileCheck %s --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX

define i32 @sad8_32bit_icmp_sge(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i32 %stride) local_unnamed_addr #0 {
; SSE2-LABEL: sad8_32bit_icmp_sge:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_32bit_icmp_sge:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    retq

entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp sgt <8 x i32> %4, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %4, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %7, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %7, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %8 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %8
}

define i32 @sad8_32bit_icmp_sgt(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i32 %stride) local_unnamed_addr #1 {
; SSE2-LABEL: sad8_32bit_icmp_sgt:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_32bit_icmp_sgt:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp sgt <8 x i32> %4, zeroinitializer
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %4, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %7, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %7, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %8 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %8
}

define i32 @sad8_32bit_icmp_sle(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i32 %stride) local_unnamed_addr #2 {
; SSE2-LABEL: sad8_32bit_icmp_sle:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_32bit_icmp_sle:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp slt <8 x i32> %4, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %6, <8 x i32> %4
  %rdx.shuf = shufflevector <8 x i32> %7, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %7, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %8 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %8
}

define i32 @sad8_32bit_icmp_slt(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i32 %stride) local_unnamed_addr #3 {
; SSE2-LABEL: sad8_32bit_icmp_slt:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_32bit_icmp_slt:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp slt <8 x i32> %4, zeroinitializer
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %6, <8 x i32> %4
  %rdx.shuf = shufflevector <8 x i32> %7, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %7, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %8 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %8
}

define i64 @sad8_64bit_icmp_sext_slt(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_64bit_icmp_sext_slt:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movq %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_64bit_icmp_sext_slt:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp slt <8 x i32> %4, zeroinitializer
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %6, <8 x i32> %4
  %8 = sext <8 x i32> %7 to <8 x i64>
  %rdx.shuf = shufflevector <8 x i64> %8, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %8
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %9 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %9
}

define i64 @sad8_64bit_icmp_zext_slt(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_64bit_icmp_zext_slt:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movq %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_64bit_icmp_zext_slt:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i32>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i32>
  %4 = sub nsw <8 x i32> %1, %3
  %5 = icmp slt <8 x i32> %4, zeroinitializer
  %6 = sub nsw <8 x i32> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i32> %6, <8 x i32> %4
  %8 = zext <8 x i32> %7 to <8 x i64>
  %rdx.shuf = shufflevector <8 x i64> %8, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %8
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %9 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %9
}

define i64 @sad8_early_64bit_icmp_zext_slt(ptr nocapture readonly %cur, ptr nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_early_64bit_icmp_zext_slt:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movq %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX-LABEL: sad8_early_64bit_icmp_zext_slt:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vpsadbw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovq %xmm0, %rax
; AVX-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = load <8 x i8>, ptr %cur, align 1
  %1 = zext <8 x i8> %0 to <8 x i64>
  %2 = load <8 x i8>, ptr %ref, align 1
  %3 = zext <8 x i8> %2 to <8 x i64>
  %4 = sub nsw <8 x i64> %1, %3
  %5 = icmp slt <8 x i64> %4, zeroinitializer
  %6 = sub nsw <8 x i64> zeroinitializer, %4
  %7 = select <8 x i1> %5, <8 x i64> %6, <8 x i64> %4
  %rdx.shuf = shufflevector <8 x i64> %7, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %7
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %8 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %8
}
