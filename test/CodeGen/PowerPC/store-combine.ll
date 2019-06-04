; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 -verify-machineinstrs < %s | FileCheck %s -check-prefix=CHECK-PPC64LE
; RUN: llc -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr8 -verify-machineinstrs < %s | FileCheck %s -check-prefix=CHECK-PPC64
; i8* p;
; i32 m;
; p[0] = (m >> 0) & 0xFF;
; p[1] = (m >> 8) & 0xFF;
; p[2] = (m >> 16) & 0xFF;
; p[3] = (m >> 24) & 0xFF;
define void @store_i32_by_i8(i32 signext %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    stb 3, 3(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    stb 3, 3(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i32 %m to i8
  store i8 %conv, i8* %p, align 1
  %0 = lshr i32 %m, 8
  %conv3 = trunc i32 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv11, i8* %arrayidx12, align 1
  ret void
}
; i8* p;
; i32 m;
; p[0] = (m >> 24) & 0xFF;
; p[1] = (m >> 16) & 0xFF;
; p[2] = (m >> 8) & 0xFF;
; p[3] = (m >> 0) & 0xFF;
define void @store_i32_by_i8_bswap(i32 signext %m, i8* %p)  {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 0(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    stb 3, 3(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 24
; CHECK-PPC64-NEXT:    srwi 6, 3, 16
; CHECK-PPC64-NEXT:    stb 5, 0(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 6, 1(4)
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    stb 3, 3(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i32 %m, 24
  %conv = trunc i32 %0 to i8
  store i8 %conv, i8* %p, align 1
  %1 = lshr i32 %m, 16
  %conv3 = trunc i32 %1 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv3, i8* %arrayidx4, align 1
  %2 = lshr i32 %m, 8
  %conv7 = trunc i32 %2 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv7, i8* %arrayidx8, align 1
  %conv11 = trunc i32 %m to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv11, i8* %arrayidx12, align 1
  ret void
}
; i8 *p;
; i64 m;
; p[0] = (m >> 0) & 0xFF;
; p[1] = (m >> 8) & 0xFF;
; p[2] = (m >> 16) & 0xFF;
; p[3] = (m >> 24) & 0xFF;
; p[4] = (m >> 32) & 0xFF;
; p[5] = (m >> 40) & 0xFF;
; p[6] = (m >> 48) & 0xFF;
; p[7] = (m >> 56) & 0xFF;
define void @store_i64_by_i8(i64 %m, i8* %p)  {
; CHECK-PPC64LE-LABEL: store_i64_by_i8:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 48, 16
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64LE-NEXT:    stb 5, 3(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 32, 32
; CHECK-PPC64LE-NEXT:    stb 5, 4(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64LE-NEXT:    stb 5, 5(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64LE-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64LE-NEXT:    stb 5, 6(4)
; CHECK-PPC64LE-NEXT:    stb 3, 7(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i64_by_i8:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64-NEXT:    rldicl 6, 3, 48, 16
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64-NEXT:    stb 6, 2(4)
; CHECK-PPC64-NEXT:    rldicl 6, 3, 32, 32
; CHECK-PPC64-NEXT:    stb 5, 3(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64-NEXT:    stb 6, 4(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    stb 5, 5(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64-NEXT:    stb 5, 6(4)
; CHECK-PPC64-NEXT:    stb 3, 7(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i64 %m to i8
  store i8 %conv, i8* %p, align 1
  %0 = lshr i64 %m, 8
  %conv3 = trunc i64 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i64 %m, 16
  %conv7 = trunc i64 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i64 %m, 24
  %conv11 = trunc i64 %2 to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv11, i8* %arrayidx12, align 1
  %3 = lshr i64 %m, 32
  %conv15 = trunc i64 %3 to i8
  %arrayidx16 = getelementptr inbounds i8, i8* %p, i64 4
  store i8 %conv15, i8* %arrayidx16, align 1
  %4 = lshr i64 %m, 40
  %conv19 = trunc i64 %4 to i8
  %arrayidx20 = getelementptr inbounds i8, i8* %p, i64 5
  store i8 %conv19, i8* %arrayidx20, align 1
  %5 = lshr i64 %m, 48
  %conv23 = trunc i64 %5 to i8
  %arrayidx24 = getelementptr inbounds i8, i8* %p, i64 6
  store i8 %conv23, i8* %arrayidx24, align 1
  %6 = lshr i64 %m, 56
  %conv27 = trunc i64 %6 to i8
  %arrayidx28 = getelementptr inbounds i8, i8* %p, i64 7
  store i8 %conv27, i8* %arrayidx28, align 1
  ret void
}
; i8 *p;
; i64 m;
; p[7] = (m >> 0) & 0xFF;
; p[6] = (m >> 8) & 0xFF;
; p[5] = (m >> 16) & 0xFF;
; p[4] = (m >> 24) & 0xFF;
; p[3] = (m >> 32) & 0xFF;
; p[2] = (m >> 40) & 0xFF;
; p[1] = (m >> 48) & 0xFF;
; p[0] = (m >> 56) & 0xFF;
define void @store_i64_by_i8_bswap(i64 %m, i8* %p)  {
; CHECK-PPC64LE-LABEL: store_i64_by_i8_bswap:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64LE-NEXT:    stb 3, 7(4)
; CHECK-PPC64LE-NEXT:    stb 5, 6(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 48, 16
; CHECK-PPC64LE-NEXT:    stb 5, 5(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64LE-NEXT:    stb 5, 4(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 32, 32
; CHECK-PPC64LE-NEXT:    stb 5, 3(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64LE-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i64_by_i8_bswap:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64-NEXT:    rldicl 6, 3, 48, 16
; CHECK-PPC64-NEXT:    stb 5, 6(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64-NEXT:    stb 6, 5(4)
; CHECK-PPC64-NEXT:    rldicl 6, 3, 32, 32
; CHECK-PPC64-NEXT:    stb 5, 4(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64-NEXT:    stb 6, 3(4)
; CHECK-PPC64-NEXT:    stb 3, 7(4)
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i64 %m to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 7
  store i8 %conv, i8* %arrayidx, align 1
  %0 = lshr i64 %m, 8
  %conv3 = trunc i64 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 6
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i64 %m, 16
  %conv7 = trunc i64 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 5
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i64 %m, 24
  %conv11 = trunc i64 %2 to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 4
  store i8 %conv11, i8* %arrayidx12, align 1
  %3 = lshr i64 %m, 32
  %conv15 = trunc i64 %3 to i8
  %arrayidx16 = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv15, i8* %arrayidx16, align 1
  %4 = lshr i64 %m, 40
  %conv19 = trunc i64 %4 to i8
  %arrayidx20 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv19, i8* %arrayidx20, align 1
  %5 = lshr i64 %m, 48
  %conv23 = trunc i64 %5 to i8
  %arrayidx24 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv23, i8* %arrayidx24, align 1
  %6 = lshr i64 %m, 56
  %conv27 = trunc i64 %6 to i8
  store i8 %conv27, i8* %p, align 1
  ret void
}

; i32 t; i8 *p;
; i64 m = t * 7;
; p[7] = (m >> 0) & 0xFF;
; p[6] = (m >> 8) & 0xFF;
; p[5] = (m >> 16) & 0xFF;
; p[4] = (m >> 24) & 0xFF;
; p[3] = (m >> 32) & 0xFF;
; p[2] = (m >> 40) & 0xFF;
; p[1] = (m >> 48) & 0xFF;
; p[0] = (m >> 56) & 0xFF;
define void @store_i64_by_i8_bswap_uses(i32 signext %t, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i64_by_i8_bswap_uses:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    slwi 5, 3, 3
; CHECK-PPC64LE-NEXT:    subf 3, 3, 5
; CHECK-PPC64LE-NEXT:    extsw 3, 3
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64LE-NEXT:    stb 3, 7(4)
; CHECK-PPC64LE-NEXT:    stb 5, 6(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 48, 16
; CHECK-PPC64LE-NEXT:    stb 5, 5(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64LE-NEXT:    stb 5, 4(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 32, 32
; CHECK-PPC64LE-NEXT:    stb 5, 3(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64LE-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i64_by_i8_bswap_uses:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    slwi 5, 3, 3
; CHECK-PPC64-NEXT:    subf 3, 3, 5
; CHECK-PPC64-NEXT:    extsw 3, 3
; CHECK-PPC64-NEXT:    rldicl 5, 3, 56, 8
; CHECK-PPC64-NEXT:    rldicl 6, 3, 48, 16
; CHECK-PPC64-NEXT:    stb 5, 6(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 40, 24
; CHECK-PPC64-NEXT:    stb 6, 5(4)
; CHECK-PPC64-NEXT:    rldicl 6, 3, 32, 32
; CHECK-PPC64-NEXT:    stb 5, 4(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 24, 40
; CHECK-PPC64-NEXT:    stb 6, 3(4)
; CHECK-PPC64-NEXT:    stb 3, 7(4)
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    rldicl 5, 3, 16, 48
; CHECK-PPC64-NEXT:    rldicl 3, 3, 8, 56
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %mul = mul nsw i32 %t, 7
  %conv = sext i32 %mul to i64
  %conv1 = trunc i32 %mul to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 7
  store i8 %conv1, i8* %arrayidx, align 1
  %0 = lshr i64 %conv, 8
  %conv4 = trunc i64 %0 to i8
  %arrayidx5 = getelementptr inbounds i8, i8* %p, i64 6
  store i8 %conv4, i8* %arrayidx5, align 1
  %1 = lshr i64 %conv, 16
  %conv8 = trunc i64 %1 to i8
  %arrayidx9 = getelementptr inbounds i8, i8* %p, i64 5
  store i8 %conv8, i8* %arrayidx9, align 1
  %2 = lshr i64 %conv, 24
  %conv12 = trunc i64 %2 to i8
  %arrayidx13 = getelementptr inbounds i8, i8* %p, i64 4
  store i8 %conv12, i8* %arrayidx13, align 1
  %shr14 = ashr i64 %conv, 32
  %conv16 = trunc i64 %shr14 to i8
  %arrayidx17 = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv16, i8* %arrayidx17, align 1
  %shr18 = ashr i64 %conv, 40
  %conv20 = trunc i64 %shr18 to i8
  %arrayidx21 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv20, i8* %arrayidx21, align 1
  %shr22 = ashr i64 %conv, 48
  %conv24 = trunc i64 %shr22 to i8
  %arrayidx25 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv24, i8* %arrayidx25, align 1
  %shr26 = ashr i64 %conv, 56
  %conv28 = trunc i64 %shr26 to i8
  store i8 %conv28, i8* %p, align 1
  ret void
; CEHCK-PPC64LE: stdbrx [[REG2]], 0, 4
; CEHCK-PPC64: stdx [[REG2]], 0, 4
}

; One of the stores is volatile
; i8 *p;
; p0 = volatile *p;
; p[3] = (m >> 0) & 0xFF;
; p[2] = (m >> 8) & 0xFF;
; p[1] = (m >> 16) & 0xFF;
; *p0 = (m >> 24) & 0xFF;
define void @store_i32_by_i8_bswap_volatile(i32 signext %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_volatile:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 3, 3(4)
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_volatile:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 3, 3(4)
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i32 %m to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv, i8* %arrayidx, align 1
  %0 = lshr i32 %m, 8
  %conv3 = trunc i32 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  store volatile i8 %conv11, i8* %p, align 1
  ret void
}

; There is a store in between individual stores
; i8* p, q;
; p[3] = (m >> 0) & 0xFF;
; p[2] = (m >> 8) & 0xFF;
; *q = 3;
; p[1] = (m >> 16) & 0xFF;
; p[0] = (m >> 24) & 0xFF;
define void @store_i32_by_i8_bswap_store_in_between(i32 signext %m, i8* %p, i8* %q) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_store_in_between:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 6, 3, 8
; CHECK-PPC64LE-NEXT:    stb 3, 3(4)
; CHECK-PPC64LE-NEXT:    stb 6, 2(4)
; CHECK-PPC64LE-NEXT:    li 6, 3
; CHECK-PPC64LE-NEXT:    stb 6, 0(5)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_store_in_between:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    li 6, 3
; CHECK-PPC64-NEXT:    srwi 7, 3, 8
; CHECK-PPC64-NEXT:    stb 7, 2(4)
; CHECK-PPC64-NEXT:    stb 3, 3(4)
; CHECK-PPC64-NEXT:    stb 6, 0(5)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i32 %m to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv, i8* %arrayidx, align 1
  %0 = lshr i32 %m, 8
  %conv3 = trunc i32 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv3, i8* %arrayidx4, align 1
  store i8 3, i8* %q, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  store i8 %conv11, i8* %p, align 1
  ret void
}

define void @store_i32_by_i8_bswap_unrelated_store(i32 signext %m, i8* %p, i8* %q) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_unrelated_store:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 6, 3, 8
; CHECK-PPC64LE-NEXT:    stb 3, 3(4)
; CHECK-PPC64LE-NEXT:    stb 6, 2(5)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 1(4)
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_unrelated_store:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 6, 3, 8
; CHECK-PPC64-NEXT:    stb 3, 3(4)
; CHECK-PPC64-NEXT:    stb 6, 2(5)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv = trunc i32 %m to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv, i8* %arrayidx, align 1
  %0 = lshr i32 %m, 8
  %conv3 = trunc i32 %0 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %q, i64 2
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  store i8 %conv11, i8* %p, align 1
  ret void
}
; i32 m;
; i8* p;
; p[3] = (m >> 8) & 0xFF;
; p[4] = (m >> 0) & 0xFF;
; p[2] = (m >> 16) & 0xFF;
; p[1] = (m >> 24) & 0xFF;
define void @store_i32_by_i8_bswap_nonzero_offset(i32 signext %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_nonzero_offset:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, 3(4)
; CHECK-PPC64LE-NEXT:    stb 3, 4(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 2(4)
; CHECK-PPC64LE-NEXT:    stb 3, 1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_nonzero_offset:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 3, 4(4)
; CHECK-PPC64-NEXT:    stb 5, 3(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, 2(4)
; CHECK-PPC64-NEXT:    stb 3, 1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i32 %m, 8
  %conv = trunc i32 %0 to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 3
  store i8 %conv, i8* %arrayidx, align 1
  %conv3 = trunc i32 %m to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 4
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 2
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv11, i8* %arrayidx12, align 1
  ret void
}
; i32 m;
; i8* p;
; p[-3] = (m >> 8) & 0xFF;
; p[-4] = (m >> 0) & 0xFF;
; p[-2] = (m >> 16) & 0xFF;
; p[-1] = (m >> 24) & 0xFF;
define void @store_i32_by_i8_neg_offset(i32 signext %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_neg_offset:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, -3(4)
; CHECK-PPC64LE-NEXT:    stb 3, -4(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, -2(4)
; CHECK-PPC64LE-NEXT:    stb 3, -1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_neg_offset:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 3, -4(4)
; CHECK-PPC64-NEXT:    stb 5, -3(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 3, 3, 24
; CHECK-PPC64-NEXT:    stb 5, -2(4)
; CHECK-PPC64-NEXT:    stb 3, -1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i32 %m, 8
  %conv = trunc i32 %0 to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 -3
  store i8 %conv, i8* %arrayidx, align 1
  %conv3 = trunc i32 %m to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 -4
  store i8 %conv3, i8* %arrayidx4, align 1
  %1 = lshr i32 %m, 16
  %conv7 = trunc i32 %1 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 -2
  store i8 %conv7, i8* %arrayidx8, align 1
  %2 = lshr i32 %m, 24
  %conv11 = trunc i32 %2 to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 -1
  store i8 %conv11, i8* %arrayidx12, align 1
  ret void
}
; i32 m;
; i8* p;
; p[-3] = (m >> 16) & 0xFF;
; p[-4] = (m >> 24) & 0xFF;
; p[-2] = (m >> 8) & 0xFF;
; p[-1] = (m >> 0) & 0xFF;
define void @store_i32_by_i8_bswap_neg_offset(i32 signext %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_neg_offset:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    stb 5, -3(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, -4(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, -2(4)
; CHECK-PPC64LE-NEXT:    stb 3, -1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_neg_offset:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    srwi 6, 3, 24
; CHECK-PPC64-NEXT:    stb 5, -3(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 6, -4(4)
; CHECK-PPC64-NEXT:    stb 5, -2(4)
; CHECK-PPC64-NEXT:    stb 3, -1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i32 %m, 16
  %conv = trunc i32 %0 to i8
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 -3
  store i8 %conv, i8* %arrayidx, align 1
  %1 = lshr i32 %m, 24
  %conv3 = trunc i32 %1 to i8
  %arrayidx4 = getelementptr inbounds i8, i8* %p, i64 -4
  store i8 %conv3, i8* %arrayidx4, align 1
  %2 = lshr i32 %m, 8
  %conv7 = trunc i32 %2 to i8
  %arrayidx8 = getelementptr inbounds i8, i8* %p, i64 -2
  store i8 %conv7, i8* %arrayidx8, align 1
  %conv11 = trunc i32 %m to i8
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 -1
  store i8 %conv11, i8* %arrayidx12, align 1
  ret void
}
; i32 m, i;
; i8* p;
; p[i-3] = (m >> 16) & 0xFF;
; p[i-4] = (m >> 24) & 0xFF;
; p[i-2] = (m >> 8) & 0xFF;
; p[i-1] = (m >> 0) & 0xFF;
define void @store_i32_by_i8_bswap_base_index_offset(i32 %m, i32 %i, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_base_index_offset:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    extsw 4, 4
; CHECK-PPC64LE-NEXT:    srwi 6, 3, 16
; CHECK-PPC64LE-NEXT:    add 4, 5, 4
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 24
; CHECK-PPC64LE-NEXT:    stb 6, -3(4)
; CHECK-PPC64LE-NEXT:    stb 5, -4(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, -2(4)
; CHECK-PPC64LE-NEXT:    stb 3, -1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_base_index_offset:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    extsw 4, 4
; CHECK-PPC64-NEXT:    srwi 6, 3, 16
; CHECK-PPC64-NEXT:    add 4, 5, 4
; CHECK-PPC64-NEXT:    srwi 5, 3, 24
; CHECK-PPC64-NEXT:    stb 6, -3(4)
; CHECK-PPC64-NEXT:    srwi 6, 3, 8
; CHECK-PPC64-NEXT:    stb 5, -4(4)
; CHECK-PPC64-NEXT:    stb 6, -2(4)
; CHECK-PPC64-NEXT:    stb 3, -1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i32 %m, 16
  %conv = trunc i32 %0 to i8
  %sub = add nsw i32 %i, -3
  %idxprom = sext i32 %sub to i64
  %arrayidx = getelementptr inbounds i8, i8* %p, i64 %idxprom
  store i8 %conv, i8* %arrayidx, align 1
  %1 = lshr i32 %m, 24
  %conv3 = trunc i32 %1 to i8
  %sub4 = add nsw i32 %i, -4
  %idxprom5 = sext i32 %sub4 to i64
  %arrayidx6 = getelementptr inbounds i8, i8* %p, i64 %idxprom5
  store i8 %conv3, i8* %arrayidx6, align 1
  %2 = lshr i32 %m, 8
  %conv9 = trunc i32 %2 to i8
  %sub10 = add nsw i32 %i, -2
  %idxprom11 = sext i32 %sub10 to i64
  %arrayidx12 = getelementptr inbounds i8, i8* %p, i64 %idxprom11
  store i8 %conv9, i8* %arrayidx12, align 1
  %conv15 = trunc i32 %m to i8
  %sub16 = add nsw i32 %i, -1
  %idxprom17 = sext i32 %sub16 to i64
  %arrayidx18 = getelementptr inbounds i8, i8* %p, i64 %idxprom17
  store i8 %conv15, i8* %arrayidx18, align 1
  ret void
}

; i8* p;
; i32 i, m;
; i8* p0 = p + i;
; i8* p1 = p + i + 1;
; i8* p2 = p + i + 2;
; i8 *p3 = p + i + 3;
; p0[3] = (m >> 24) & 0xFF;
; p1[3] = (m >> 16) & 0xFF;
; p2[3] = (m >> 8) & 0xFF;
; p3[3] = (m >> 0) & 0xFF;
define void @store_i32_by_i8_bswap_complicated(i32 %m, i32 %i, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i32_by_i8_bswap_complicated:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    extsw 4, 4
; CHECK-PPC64LE-NEXT:    add 4, 5, 4
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 24
; CHECK-PPC64LE-NEXT:    stb 5, 3(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 16
; CHECK-PPC64LE-NEXT:    stb 5, 4(4)
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, 5(4)
; CHECK-PPC64LE-NEXT:    stb 3, 6(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i32_by_i8_bswap_complicated:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    extsw 4, 4
; CHECK-PPC64-NEXT:    srwi 6, 3, 24
; CHECK-PPC64-NEXT:    add 4, 5, 4
; CHECK-PPC64-NEXT:    srwi 5, 3, 16
; CHECK-PPC64-NEXT:    stb 6, 3(4)
; CHECK-PPC64-NEXT:    stb 5, 4(4)
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 5, 5(4)
; CHECK-PPC64-NEXT:    stb 3, 6(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %idx.ext = sext i32 %i to i64
  %add.ptr = getelementptr inbounds i8, i8* %p, i64 %idx.ext
  %add.ptr3 = getelementptr inbounds i8, i8* %add.ptr, i64 1
  %add.ptr6 = getelementptr inbounds i8, i8* %add.ptr, i64 2
  %add.ptr9 = getelementptr inbounds i8, i8* %add.ptr, i64 3
  %0 = lshr i32 %m, 24
  %conv = trunc i32 %0 to i8
  store i8 %conv, i8* %add.ptr9, align 1
  %1 = lshr i32 %m, 16
  %conv12 = trunc i32 %1 to i8
  %arrayidx13 = getelementptr inbounds i8, i8* %add.ptr3, i64 3
  store i8 %conv12, i8* %arrayidx13, align 1
  %2 = lshr i32 %m, 8
  %conv16 = trunc i32 %2 to i8
  %arrayidx17 = getelementptr inbounds i8, i8* %add.ptr6, i64 3
  store i8 %conv16, i8* %arrayidx17, align 1
  %conv20 = trunc i32 %m to i8
  %arrayidx21 = getelementptr inbounds i8, i8* %add.ptr9, i64 3
  store i8 %conv20, i8* %arrayidx21, align 1
  ret void
}
; i8* p; i32 m;
; p[0] = (m >> 8) & 0xFF;
; p[1] = (m >> 0) & 0xFF;
define void @store_i16_by_i8_bswap(i16 %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_i16_by_i8_bswap:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    srwi 5, 3, 8
; CHECK-PPC64LE-NEXT:    stb 5, 0(4)
; CHECK-PPC64LE-NEXT:    stb 3, 1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_i16_by_i8_bswap:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 5, 0(4)
; CHECK-PPC64-NEXT:    stb 3, 1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %0 = lshr i16 %m, 8
  %conv1 = trunc i16 %0 to i8
  store i8 %conv1, i8* %p, align 1
  %conv5 = trunc i16 %m to i8
  %arrayidx6 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv5, i8* %arrayidx6, align 1
  ret void
}
; i8* p; i32 m;
; p[0] = (m >> 0) & 0xFF;
; p[1] = (m >> 8) & 0xFF;
define void @store_16_by_i8(i16 %m, i8* %p) {
; CHECK-PPC64LE-LABEL: store_16_by_i8:
; CHECK-PPC64LE:       # %bb.0: # %entry
; CHECK-PPC64LE-NEXT:    stb 3, 0(4)
; CHECK-PPC64LE-NEXT:    srwi 3, 3, 8
; CHECK-PPC64LE-NEXT:    stb 3, 1(4)
; CHECK-PPC64LE-NEXT:    blr
;
; CHECK-PPC64-LABEL: store_16_by_i8:
; CHECK-PPC64:       # %bb.0: # %entry
; CHECK-PPC64-NEXT:    srwi 5, 3, 8
; CHECK-PPC64-NEXT:    stb 3, 0(4)
; CHECK-PPC64-NEXT:    stb 5, 1(4)
; CHECK-PPC64-NEXT:    blr
entry:
  %conv1 = trunc i16 %m to i8
  store i8 %conv1, i8* %p, align 1
  %0 = lshr i16 %m, 8
  %conv5 = trunc i16 %0 to i8
  %arrayidx6 = getelementptr inbounds i8, i8* %p, i64 1
  store i8 %conv5, i8* %arrayidx6, align 1
  ret void
}
