; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 -mattr=+ls64 -verify-machineinstrs -o - %s | FileCheck %s

%struct.foo = type { [8 x i64] }

define void @load(%struct.foo* %output, i8* %addr) {
; CHECK-LABEL: load:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    //APP
; CHECK-NEXT:    ld64b x2, [x1]
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    stp x8, x9, [x0, #48]
; CHECK-NEXT:    stp x6, x7, [x0, #32]
; CHECK-NEXT:    stp x4, x5, [x0, #16]
; CHECK-NEXT:    stp x2, x3, [x0]
; CHECK-NEXT:    ret
entry:
  %val = call i512 asm sideeffect "ld64b $0,[$1]", "=r,r,~{memory}"(i8* %addr)
  %outcast = bitcast %struct.foo* %output to i512*
  store i512 %val, i512* %outcast, align 8
  ret void
}

define void @store(%struct.foo* %input, i8* %addr) {
; CHECK-LABEL: store:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldp x8, x9, [x0, #48]
; CHECK-NEXT:    ldp x6, x7, [x0, #32]
; CHECK-NEXT:    ldp x4, x5, [x0, #16]
; CHECK-NEXT:    ldp x2, x3, [x0]
; CHECK-NEXT:    //APP
; CHECK-NEXT:    st64b x2, [x1]
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    ret
entry:
  %incast = bitcast %struct.foo* %input to i512*
  %val = load i512, i512* %incast, align 8
  call void asm sideeffect "st64b $0,[$1]", "r,r,~{memory}"(i512 %val, i8* %addr)
  ret void
}

define void @store2(i32* %in, i8* %addr) {
; CHECK-LABEL: store2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #64
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    ldpsw x2, x3, [x0]
; CHECK-NEXT:    ldrsw x4, [x0, #16]
; CHECK-NEXT:    ldrsw x5, [x0, #64]
; CHECK-NEXT:    ldrsw x6, [x0, #100]
; CHECK-NEXT:    ldrsw x7, [x0, #144]
; CHECK-NEXT:    ldrsw x8, [x0, #196]
; CHECK-NEXT:    ldrsw x9, [x0, #256]
; CHECK-NEXT:    //APP
; CHECK-NEXT:    st64b x2, [x1]
; CHECK-NEXT:    //NO_APP
; CHECK-NEXT:    add sp, sp, #64
; CHECK-NEXT:    ret
entry:
  %0 = load i32, i32* %in, align 4
  %conv = sext i32 %0 to i64
  %arrayidx1 = getelementptr inbounds i32, i32* %in, i64 1
  %1 = load i32, i32* %arrayidx1, align 4
  %conv2 = sext i32 %1 to i64
  %arrayidx4 = getelementptr inbounds i32, i32* %in, i64 4
  %2 = load i32, i32* %arrayidx4, align 4
  %conv5 = sext i32 %2 to i64
  %arrayidx7 = getelementptr inbounds i32, i32* %in, i64 16
  %3 = load i32, i32* %arrayidx7, align 4
  %conv8 = sext i32 %3 to i64
  %arrayidx10 = getelementptr inbounds i32, i32* %in, i64 25
  %4 = load i32, i32* %arrayidx10, align 4
  %conv11 = sext i32 %4 to i64
  %arrayidx13 = getelementptr inbounds i32, i32* %in, i64 36
  %5 = load i32, i32* %arrayidx13, align 4
  %conv14 = sext i32 %5 to i64
  %arrayidx16 = getelementptr inbounds i32, i32* %in, i64 49
  %6 = load i32, i32* %arrayidx16, align 4
  %conv17 = sext i32 %6 to i64
  %arrayidx19 = getelementptr inbounds i32, i32* %in, i64 64
  %7 = load i32, i32* %arrayidx19, align 4
  %conv20 = sext i32 %7 to i64
  %s.sroa.10.0.insert.ext = zext i64 %conv20 to i512
  %s.sroa.10.0.insert.shift = shl nuw i512 %s.sroa.10.0.insert.ext, 448
  %s.sroa.9.0.insert.ext = zext i64 %conv17 to i512
  %s.sroa.9.0.insert.shift = shl nuw nsw i512 %s.sroa.9.0.insert.ext, 384
  %s.sroa.9.0.insert.insert = or i512 %s.sroa.10.0.insert.shift, %s.sroa.9.0.insert.shift
  %s.sroa.8.0.insert.ext = zext i64 %conv14 to i512
  %s.sroa.8.0.insert.shift = shl nuw nsw i512 %s.sroa.8.0.insert.ext, 320
  %s.sroa.8.0.insert.insert = or i512 %s.sroa.9.0.insert.insert, %s.sroa.8.0.insert.shift
  %s.sroa.7.0.insert.ext = zext i64 %conv11 to i512
  %s.sroa.7.0.insert.shift = shl nuw nsw i512 %s.sroa.7.0.insert.ext, 256
  %s.sroa.7.0.insert.insert = or i512 %s.sroa.8.0.insert.insert, %s.sroa.7.0.insert.shift
  %s.sroa.6.0.insert.ext = zext i64 %conv8 to i512
  %s.sroa.6.0.insert.shift = shl nuw nsw i512 %s.sroa.6.0.insert.ext, 192
  %s.sroa.6.0.insert.insert = or i512 %s.sroa.7.0.insert.insert, %s.sroa.6.0.insert.shift
  %s.sroa.5.0.insert.ext = zext i64 %conv5 to i512
  %s.sroa.5.0.insert.shift = shl nuw nsw i512 %s.sroa.5.0.insert.ext, 128
  %s.sroa.4.0.insert.ext = zext i64 %conv2 to i512
  %s.sroa.4.0.insert.shift = shl nuw nsw i512 %s.sroa.4.0.insert.ext, 64
  %s.sroa.4.0.insert.mask = or i512 %s.sroa.6.0.insert.insert, %s.sroa.5.0.insert.shift
  %s.sroa.0.0.insert.ext = zext i64 %conv to i512
  %s.sroa.0.0.insert.mask = or i512 %s.sroa.4.0.insert.mask, %s.sroa.4.0.insert.shift
  %s.sroa.0.0.insert.insert = or i512 %s.sroa.0.0.insert.mask, %s.sroa.0.0.insert.ext
  call void asm sideeffect "st64b $0,[$1]", "r,r,~{memory}"(i512 %s.sroa.0.0.insert.insert, i8* %addr)
  ret void
}
