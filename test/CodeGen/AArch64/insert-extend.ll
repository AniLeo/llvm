; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64--linux-gnu | FileCheck %s

define <8 x i8> @load4_v4i8_add(float %tmp, <4 x i8> *%a, <4 x i8> *%b) {
; CHECK-LABEL: load4_v4i8_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp s0, s1, [x0]
; CHECK-NEXT:    ldp s2, s3, [x1]
; CHECK-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    ushll v1.8h, v1.8b, #0
; CHECK-NEXT:    ushll v3.8h, v3.8b, #0
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v2.8b
; CHECK-NEXT:    uzp1 v1.8b, v1.8b, v3.8b
; CHECK-NEXT:    add v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %la = load <4 x i8>, <4 x i8> *%a
  %lb = load <4 x i8>, <4 x i8> *%b
  %c = getelementptr <4 x i8>, <4 x i8> *%a, i64 1
  %d = getelementptr <4 x i8>, <4 x i8> *%b, i64 1
  %lc = load <4 x i8>, <4 x i8> *%c
  %ld = load <4 x i8>, <4 x i8> *%d
  %s1 = shufflevector <4 x i8> %la, <4 x i8> %lb, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <4 x i8> %lc, <4 x i8> %ld, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %add = add <8 x i8> %s1, %s2
  ret <8 x i8> %add
}

define <8 x i16> @load4_v4i8_zext_add(float %tmp, <4 x i8> *%a, <4 x i8> *%b) {
; CHECK-LABEL: load4_v4i8_zext_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp s0, s1, [x0]
; CHECK-NEXT:    ldp s2, s3, [x1]
; CHECK-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    ushll v1.8h, v1.8b, #0
; CHECK-NEXT:    ushll v3.8h, v3.8b, #0
; CHECK-NEXT:    uzp1 v0.8b, v0.8b, v2.8b
; CHECK-NEXT:    uzp1 v1.8b, v1.8b, v3.8b
; CHECK-NEXT:    uaddl v0.8h, v0.8b, v1.8b
; CHECK-NEXT:    ret
  %la = load <4 x i8>, <4 x i8> *%a
  %lb = load <4 x i8>, <4 x i8> *%b
  %c = getelementptr <4 x i8>, <4 x i8> *%a, i64 1
  %d = getelementptr <4 x i8>, <4 x i8> *%b, i64 1
  %lc = load <4 x i8>, <4 x i8> *%c
  %ld = load <4 x i8>, <4 x i8> *%d
  %s1 = shufflevector <4 x i8> %la, <4 x i8> %lb, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s2 = shufflevector <4 x i8> %lc, <4 x i8> %ld, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %z1 = zext <8 x i8> %s1 to <8 x i16>
  %z2 = zext <8 x i8> %s2 to <8 x i16>
  %add = add <8 x i16> %z1, %z2
  ret <8 x i16> %add
}

define i32 @large(i8* nocapture noundef readonly %p1, i32 noundef %st1, i8* nocapture noundef readonly %p2, i32 noundef %st2) {
; CHECK-LABEL: large:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    sxtw x8, w1
; CHECK-NEXT:    // kill: def $w3 killed $w3 def $x3
; CHECK-NEXT:    sxtw x9, w3
; CHECK-NEXT:    ldp s0, s1, [x0]
; CHECK-NEXT:    ldp s2, s3, [x2]
; CHECK-NEXT:    add x10, x0, x8
; CHECK-NEXT:    add x11, x2, x9
; CHECK-NEXT:    ushll v4.8h, v0.8b, #0
; CHECK-NEXT:    ushll v0.8h, v3.8b, #0
; CHECK-NEXT:    ldp s5, s3, [x10]
; CHECK-NEXT:    add x10, x10, x8
; CHECK-NEXT:    add x8, x10, x8
; CHECK-NEXT:    ldp s6, s7, [x11]
; CHECK-NEXT:    ldp s16, s17, [x10]
; CHECK-NEXT:    ldp s18, s21, [x8]
; CHECK-NEXT:    add x11, x11, x9
; CHECK-NEXT:    add x9, x11, x9
; CHECK-NEXT:    ushll v5.8h, v5.8b, #0
; CHECK-NEXT:    ushll v16.8h, v16.8b, #0
; CHECK-NEXT:    ushll v18.8h, v18.8b, #0
; CHECK-NEXT:    ldp s19, s20, [x11]
; CHECK-NEXT:    uzp1 v16.8b, v18.8b, v16.8b
; CHECK-NEXT:    uzp1 v4.8b, v5.8b, v4.8b
; CHECK-NEXT:    ldp s18, s5, [x9]
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    ushll v6.8h, v6.8b, #0
; CHECK-NEXT:    ushll v19.8h, v19.8b, #0
; CHECK-NEXT:    ushll v18.8h, v18.8b, #0
; CHECK-NEXT:    uzp1 v2.8b, v6.8b, v2.8b
; CHECK-NEXT:    uzp1 v18.8b, v18.8b, v19.8b
; CHECK-NEXT:    ushll v1.8h, v1.8b, #0
; CHECK-NEXT:    ushll v3.8h, v3.8b, #0
; CHECK-NEXT:    ushll v17.8h, v17.8b, #0
; CHECK-NEXT:    ushll v20.8h, v20.8b, #0
; CHECK-NEXT:    ushll v6.8h, v16.8b, #0
; CHECK-NEXT:    ushll v4.8h, v4.8b, #0
; CHECK-NEXT:    ushll v16.8h, v18.8b, #0
; CHECK-NEXT:    ushll v2.8h, v2.8b, #0
; CHECK-NEXT:    ushll v19.8h, v21.8b, #0
; CHECK-NEXT:    ushll v5.8h, v5.8b, #0
; CHECK-NEXT:    ushll v7.8h, v7.8b, #0
; CHECK-NEXT:    usubl v18.4s, v6.4h, v16.4h
; CHECK-NEXT:    usubl2 v6.4s, v6.8h, v16.8h
; CHECK-NEXT:    usubl v16.4s, v4.4h, v2.4h
; CHECK-NEXT:    usubl2 v2.4s, v4.8h, v2.8h
; CHECK-NEXT:    uzp1 v4.8b, v19.8b, v17.8b
; CHECK-NEXT:    uzp1 v1.8b, v3.8b, v1.8b
; CHECK-NEXT:    uzp1 v3.8b, v5.8b, v20.8b
; CHECK-NEXT:    uzp1 v0.8b, v7.8b, v0.8b
; CHECK-NEXT:    ushll v4.8h, v4.8b, #0
; CHECK-NEXT:    ushll v3.8h, v3.8b, #0
; CHECK-NEXT:    ushll v1.8h, v1.8b, #0
; CHECK-NEXT:    ushll v0.8h, v0.8b, #0
; CHECK-NEXT:    usubl2 v5.4s, v4.8h, v3.8h
; CHECK-NEXT:    usubl v3.4s, v4.4h, v3.4h
; CHECK-NEXT:    usubl2 v4.4s, v1.8h, v0.8h
; CHECK-NEXT:    usubl v0.4s, v1.4h, v0.4h
; CHECK-NEXT:    shl v1.4s, v3.4s, #16
; CHECK-NEXT:    shl v3.4s, v5.4s, #16
; CHECK-NEXT:    shl v4.4s, v4.4s, #16
; CHECK-NEXT:    add v1.4s, v1.4s, v18.4s
; CHECK-NEXT:    shl v0.4s, v0.4s, #16
; CHECK-NEXT:    add v3.4s, v3.4s, v6.4s
; CHECK-NEXT:    add v2.4s, v4.4s, v2.4s
; CHECK-NEXT:    rev64 v4.4s, v3.4s
; CHECK-NEXT:    rev64 v5.4s, v1.4s
; CHECK-NEXT:    add v0.4s, v0.4s, v16.4s
; CHECK-NEXT:    rev64 v6.4s, v2.4s
; CHECK-NEXT:    rev64 v7.4s, v0.4s
; CHECK-NEXT:    add v16.4s, v3.4s, v4.4s
; CHECK-NEXT:    add v17.4s, v1.4s, v5.4s
; CHECK-NEXT:    sub v1.4s, v1.4s, v5.4s
; CHECK-NEXT:    trn2 v5.4s, v16.4s, v17.4s
; CHECK-NEXT:    add v18.4s, v2.4s, v6.4s
; CHECK-NEXT:    add v19.4s, v0.4s, v7.4s
; CHECK-NEXT:    sub v2.4s, v2.4s, v6.4s
; CHECK-NEXT:    sub v0.4s, v0.4s, v7.4s
; CHECK-NEXT:    sub v3.4s, v3.4s, v4.4s
; CHECK-NEXT:    trn2 v4.4s, v19.4s, v18.4s
; CHECK-NEXT:    ext v6.16b, v5.16b, v16.16b, #8
; CHECK-NEXT:    zip1 v7.4s, v0.4s, v2.4s
; CHECK-NEXT:    trn2 v16.4s, v17.4s, v16.4s
; CHECK-NEXT:    ext v4.16b, v19.16b, v4.16b, #8
; CHECK-NEXT:    zip1 v20.4s, v3.4s, v1.4s
; CHECK-NEXT:    ext v7.16b, v0.16b, v7.16b, #8
; CHECK-NEXT:    ext v17.16b, v16.16b, v17.16b, #8
; CHECK-NEXT:    zip2 v18.4s, v19.4s, v18.4s
; CHECK-NEXT:    zip2 v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    mov v0.s[3], v2.s[2]
; CHECK-NEXT:    mov v5.d[1], v4.d[1]
; CHECK-NEXT:    mov v20.d[1], v7.d[1]
; CHECK-NEXT:    mov v17.d[1], v18.d[1]
; CHECK-NEXT:    mov v16.d[1], v4.d[1]
; CHECK-NEXT:    mov v1.d[1], v0.d[1]
; CHECK-NEXT:    mov v6.d[1], v18.d[1]
; CHECK-NEXT:    add v0.4s, v17.4s, v16.4s
; CHECK-NEXT:    add v2.4s, v1.4s, v20.4s
; CHECK-NEXT:    sub v3.4s, v5.4s, v6.4s
; CHECK-NEXT:    sub v1.4s, v20.4s, v1.4s
; CHECK-NEXT:    rev64 v4.4s, v0.4s
; CHECK-NEXT:    rev64 v5.4s, v3.4s
; CHECK-NEXT:    rev64 v6.4s, v1.4s
; CHECK-NEXT:    rev64 v7.4s, v2.4s
; CHECK-NEXT:    add v16.4s, v0.4s, v4.4s
; CHECK-NEXT:    add v17.4s, v3.4s, v5.4s
; CHECK-NEXT:    add v18.4s, v1.4s, v6.4s
; CHECK-NEXT:    add v19.4s, v2.4s, v7.4s
; CHECK-NEXT:    sub v2.4s, v2.4s, v7.4s
; CHECK-NEXT:    sub v1.4s, v1.4s, v6.4s
; CHECK-NEXT:    sub v3.4s, v3.4s, v5.4s
; CHECK-NEXT:    sub v0.4s, v0.4s, v4.4s
; CHECK-NEXT:    ext v4.16b, v2.16b, v19.16b, #12
; CHECK-NEXT:    ext v5.16b, v1.16b, v18.16b, #12
; CHECK-NEXT:    ext v7.16b, v3.16b, v17.16b, #12
; CHECK-NEXT:    rev64 v16.4s, v16.4s
; CHECK-NEXT:    ext v6.16b, v4.16b, v2.16b, #4
; CHECK-NEXT:    ext v17.16b, v4.16b, v4.16b, #8
; CHECK-NEXT:    ext v18.16b, v5.16b, v1.16b, #4
; CHECK-NEXT:    ext v19.16b, v5.16b, v5.16b, #8
; CHECK-NEXT:    ext v20.16b, v7.16b, v3.16b, #4
; CHECK-NEXT:    ext v21.16b, v7.16b, v7.16b, #8
; CHECK-NEXT:    rev64 v7.4s, v7.4s
; CHECK-NEXT:    trn2 v0.4s, v16.4s, v0.4s
; CHECK-NEXT:    rev64 v5.4s, v5.4s
; CHECK-NEXT:    rev64 v4.4s, v4.4s
; CHECK-NEXT:    ext v6.16b, v6.16b, v17.16b, #12
; CHECK-NEXT:    ext v17.16b, v18.16b, v19.16b, #12
; CHECK-NEXT:    ext v18.16b, v20.16b, v21.16b, #12
; CHECK-NEXT:    ext v3.16b, v7.16b, v3.16b, #4
; CHECK-NEXT:    ext v7.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ext v1.16b, v5.16b, v1.16b, #4
; CHECK-NEXT:    ext v2.16b, v4.16b, v2.16b, #4
; CHECK-NEXT:    add v4.4s, v18.4s, v3.4s
; CHECK-NEXT:    add v5.4s, v0.4s, v7.4s
; CHECK-NEXT:    add v16.4s, v17.4s, v1.4s
; CHECK-NEXT:    add v19.4s, v6.4s, v2.4s
; CHECK-NEXT:    sub v3.4s, v18.4s, v3.4s
; CHECK-NEXT:    sub v0.4s, v0.4s, v7.4s
; CHECK-NEXT:    sub v2.4s, v6.4s, v2.4s
; CHECK-NEXT:    sub v1.4s, v17.4s, v1.4s
; CHECK-NEXT:    mov v19.d[1], v2.d[1]
; CHECK-NEXT:    mov v16.d[1], v1.d[1]
; CHECK-NEXT:    mov v4.d[1], v3.d[1]
; CHECK-NEXT:    mov v5.d[1], v0.d[1]
; CHECK-NEXT:    movi v0.8h, #1
; CHECK-NEXT:    movi v7.2d, #0x00ffff0000ffff
; CHECK-NEXT:    ushr v1.4s, v4.4s, #15
; CHECK-NEXT:    ushr v2.4s, v19.4s, #15
; CHECK-NEXT:    ushr v3.4s, v5.4s, #15
; CHECK-NEXT:    ushr v6.4s, v16.4s, #15
; CHECK-NEXT:    and v2.16b, v2.16b, v0.16b
; CHECK-NEXT:    and v6.16b, v6.16b, v0.16b
; CHECK-NEXT:    and v3.16b, v3.16b, v0.16b
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    mul v1.4s, v2.4s, v7.4s
; CHECK-NEXT:    mul v2.4s, v6.4s, v7.4s
; CHECK-NEXT:    mul v0.4s, v0.4s, v7.4s
; CHECK-NEXT:    mul v3.4s, v3.4s, v7.4s
; CHECK-NEXT:    add v6.4s, v1.4s, v19.4s
; CHECK-NEXT:    add v7.4s, v2.4s, v16.4s
; CHECK-NEXT:    add v4.4s, v0.4s, v4.4s
; CHECK-NEXT:    add v5.4s, v3.4s, v5.4s
; CHECK-NEXT:    eor v0.16b, v4.16b, v0.16b
; CHECK-NEXT:    eor v3.16b, v5.16b, v3.16b
; CHECK-NEXT:    eor v2.16b, v7.16b, v2.16b
; CHECK-NEXT:    eor v1.16b, v6.16b, v1.16b
; CHECK-NEXT:    add v1.4s, v1.4s, v2.4s
; CHECK-NEXT:    add v0.4s, v3.4s, v0.4s
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    addv s0, v0.4s
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    lsr w9, w8, #16
; CHECK-NEXT:    add w8, w9, w8, uxth
; CHECK-NEXT:    lsr w0, w8, #1
; CHECK-NEXT:    ret
entry:
  %idx.ext = sext i32 %st1 to i64
  %idx.ext63 = sext i32 %st2 to i64
  %arrayidx3 = getelementptr inbounds i8, i8* %p1, i64 4
  %arrayidx5 = getelementptr inbounds i8, i8* %p2, i64 4
  %0 = bitcast i8* %p1 to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = bitcast i8* %p2 to <4 x i8>*
  %3 = load <4 x i8>, <4 x i8>* %2, align 1
  %4 = bitcast i8* %arrayidx3 to <4 x i8>*
  %5 = load <4 x i8>, <4 x i8>* %4, align 1
  %6 = bitcast i8* %arrayidx5 to <4 x i8>*
  %7 = load <4 x i8>, <4 x i8>* %6, align 1
  %add.ptr = getelementptr inbounds i8, i8* %p1, i64 %idx.ext
  %add.ptr64 = getelementptr inbounds i8, i8* %p2, i64 %idx.ext63
  %arrayidx3.1 = getelementptr inbounds i8, i8* %add.ptr, i64 4
  %arrayidx5.1 = getelementptr inbounds i8, i8* %add.ptr64, i64 4
  %8 = bitcast i8* %add.ptr to <4 x i8>*
  %9 = load <4 x i8>, <4 x i8>* %8, align 1
  %10 = bitcast i8* %add.ptr64 to <4 x i8>*
  %11 = load <4 x i8>, <4 x i8>* %10, align 1
  %12 = bitcast i8* %arrayidx3.1 to <4 x i8>*
  %13 = load <4 x i8>, <4 x i8>* %12, align 1
  %14 = bitcast i8* %arrayidx5.1 to <4 x i8>*
  %15 = load <4 x i8>, <4 x i8>* %14, align 1
  %add.ptr.1 = getelementptr inbounds i8, i8* %add.ptr, i64 %idx.ext
  %add.ptr64.1 = getelementptr inbounds i8, i8* %add.ptr64, i64 %idx.ext63
  %arrayidx3.2 = getelementptr inbounds i8, i8* %add.ptr.1, i64 4
  %arrayidx5.2 = getelementptr inbounds i8, i8* %add.ptr64.1, i64 4
  %16 = bitcast i8* %add.ptr.1 to <4 x i8>*
  %17 = load <4 x i8>, <4 x i8>* %16, align 1
  %18 = bitcast i8* %add.ptr64.1 to <4 x i8>*
  %19 = load <4 x i8>, <4 x i8>* %18, align 1
  %20 = bitcast i8* %arrayidx3.2 to <4 x i8>*
  %21 = load <4 x i8>, <4 x i8>* %20, align 1
  %22 = bitcast i8* %arrayidx5.2 to <4 x i8>*
  %23 = load <4 x i8>, <4 x i8>* %22, align 1
  %add.ptr.2 = getelementptr inbounds i8, i8* %add.ptr.1, i64 %idx.ext
  %add.ptr64.2 = getelementptr inbounds i8, i8* %add.ptr64.1, i64 %idx.ext63
  %arrayidx3.3 = getelementptr inbounds i8, i8* %add.ptr.2, i64 4
  %arrayidx5.3 = getelementptr inbounds i8, i8* %add.ptr64.2, i64 4
  %24 = bitcast i8* %add.ptr.2 to <4 x i8>*
  %25 = load <4 x i8>, <4 x i8>* %24, align 1
  %26 = shufflevector <4 x i8> %25, <4 x i8> %17, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %27 = shufflevector <4 x i8> %9, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %28 = shufflevector <16 x i8> %26, <16 x i8> %27, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 undef, i32 undef, i32 undef, i32 undef>
  %29 = shufflevector <4 x i8> %1, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %30 = shufflevector <16 x i8> %28, <16 x i8> %29, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %31 = zext <16 x i8> %30 to <16 x i32>
  %32 = bitcast i8* %add.ptr64.2 to <4 x i8>*
  %33 = load <4 x i8>, <4 x i8>* %32, align 1
  %34 = shufflevector <4 x i8> %33, <4 x i8> %19, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %35 = shufflevector <4 x i8> %11, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %36 = shufflevector <16 x i8> %34, <16 x i8> %35, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 undef, i32 undef, i32 undef, i32 undef>
  %37 = shufflevector <4 x i8> %3, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %38 = shufflevector <16 x i8> %36, <16 x i8> %37, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %39 = zext <16 x i8> %38 to <16 x i32>
  %40 = sub nsw <16 x i32> %31, %39
  %41 = bitcast i8* %arrayidx3.3 to <4 x i8>*
  %42 = load <4 x i8>, <4 x i8>* %41, align 1
  %43 = shufflevector <4 x i8> %42, <4 x i8> %21, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %44 = shufflevector <4 x i8> %13, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %45 = shufflevector <16 x i8> %43, <16 x i8> %44, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 undef, i32 undef, i32 undef, i32 undef>
  %46 = shufflevector <4 x i8> %5, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %47 = shufflevector <16 x i8> %45, <16 x i8> %46, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %48 = zext <16 x i8> %47 to <16 x i32>
  %49 = bitcast i8* %arrayidx5.3 to <4 x i8>*
  %50 = load <4 x i8>, <4 x i8>* %49, align 1
  %51 = shufflevector <4 x i8> %50, <4 x i8> %23, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %52 = shufflevector <4 x i8> %15, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %53 = shufflevector <16 x i8> %51, <16 x i8> %52, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 16, i32 17, i32 18, i32 19, i32 undef, i32 undef, i32 undef, i32 undef>
  %54 = shufflevector <4 x i8> %7, <4 x i8> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %55 = shufflevector <16 x i8> %53, <16 x i8> %54, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 16, i32 17, i32 18, i32 19>
  %56 = zext <16 x i8> %55 to <16 x i32>
  %57 = sub nsw <16 x i32> %48, %56
  %58 = shl nsw <16 x i32> %57, <i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16>
  %59 = add nsw <16 x i32> %58, %40
  %60 = shufflevector <16 x i32> %59, <16 x i32> undef, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
  %61 = add nsw <16 x i32> %59, %60
  %62 = sub nsw <16 x i32> %59, %60
  %63 = shufflevector <16 x i32> %61, <16 x i32> %62, <16 x i32> <i32 3, i32 7, i32 11, i32 15, i32 22, i32 18, i32 26, i32 30, i32 5, i32 1, i32 9, i32 13, i32 20, i32 16, i32 24, i32 28>
  %64 = shufflevector <16 x i32> %61, <16 x i32> %62, <16 x i32> <i32 1, i32 5, i32 9, i32 13, i32 20, i32 16, i32 24, i32 28, i32 7, i32 3, i32 11, i32 15, i32 22, i32 18, i32 26, i32 30>
  %65 = add nsw <16 x i32> %63, %64
  %66 = sub nsw <16 x i32> %63, %64
  %67 = shufflevector <16 x i32> %65, <16 x i32> %66, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %68 = shufflevector <16 x i32> %65, <16 x i32> %66, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 25, i32 24, i32 27, i32 26, i32 29, i32 28, i32 31, i32 30>
  %69 = add nsw <16 x i32> %67, %68
  %70 = sub nsw <16 x i32> %67, %68
  %71 = shufflevector <16 x i32> %69, <16 x i32> %70, <16 x i32> <i32 0, i32 17, i32 2, i32 19, i32 20, i32 5, i32 6, i32 23, i32 24, i32 9, i32 10, i32 27, i32 28, i32 13, i32 14, i32 31>
  %72 = shufflevector <16 x i32> %69, <16 x i32> %70, <16 x i32> <i32 2, i32 19, i32 0, i32 17, i32 23, i32 6, i32 5, i32 20, i32 27, i32 10, i32 9, i32 24, i32 31, i32 14, i32 13, i32 28>
  %73 = add nsw <16 x i32> %71, %72
  %74 = sub nsw <16 x i32> %71, %72
  %75 = shufflevector <16 x i32> %73, <16 x i32> %74, <16 x i32> <i32 0, i32 1, i32 18, i32 19, i32 4, i32 5, i32 22, i32 23, i32 8, i32 9, i32 26, i32 27, i32 12, i32 13, i32 30, i32 31>
  %76 = lshr <16 x i32> %75, <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  %77 = and <16 x i32> %76, <i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537, i32 65537>
  %78 = mul nuw <16 x i32> %77, <i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535, i32 65535>
  %79 = add <16 x i32> %78, %75
  %80 = xor <16 x i32> %79, %78
  %81 = call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %80)
  %conv118 = and i32 %81, 65535
  %shr = lshr i32 %81, 16
  %add119 = add nuw nsw i32 %conv118, %shr
  %shr120 = lshr i32 %add119, 1
  ret i32 %shr120
}

declare i32 @llvm.vector.reduce.add.v16i32(<16 x i32>)
