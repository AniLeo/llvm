; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define i8* @ldrwu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_m4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_m4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0], #-4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_508(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0], #508
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_512(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #512
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_m508(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_m508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0], #-508
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrwu32_m512(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwu32_m512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0]
; CHECK-NEXT:    sub.w r0, r0, #512
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}


define i8* @ldrhu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    adds r0, #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhu32_2(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0], #2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhu32_254(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0], #254
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhu32_256(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #256
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}


define i8* @ldrhs32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhs32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhs32_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhs32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0]
; CHECK-NEXT:    adds r0, #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhs32_2(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhs32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0], #2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhs32_254(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhs32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0], #254
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrhs32_256(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhs32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #256
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}


define i8* @ldrhu16_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0], #4
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @ldrhu16_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @ldrhu16_2(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu16_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0], #2
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @ldrhu16_254(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu16_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0], #254
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @ldrhu16_256(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhu16_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #256
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}


define i8* @ldrbu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0], #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbu32_127(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0], #127
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbu32_128(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}


define i8* @ldrbs32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbs32_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q0, [r0], #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbs32_127(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q0, [r0], #127
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}

define i8* @ldrbs32_128(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  ret i8* %z
}


define i8* @ldrbu16_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0], #4
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbu16_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0], #3
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbu16_127(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0], #127
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbu16_128(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}


define i8* @ldrbs16_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s16 q0, [r0], #4
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbs16_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s16 q0, [r0], #3
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbs16_127(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s16 q0, [r0], #127
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}

define i8* @ldrbs16_128(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbs16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s16 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 2
  ret i8* %z
}


define i8* @ldrbu8_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu8_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #4
; CHECK-NEXT:    vstrb.8 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @ldrbu8_3(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu8_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrb.8 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @ldrbu8_127(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu8_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #127
; CHECK-NEXT:    vstrb.8 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @ldrbu8_128(i8* %x, i8* %y) {
; CHECK-LABEL: ldrbu8_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    vstrb.8 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @ldrwf32_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwf32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0], #4
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 4
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 4
  ret i8* %z
}

define i8* @ldrwf16_4(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwf16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r0], #4
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %x to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 2
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 2
  ret i8* %z
}

define i8* @ldrwi32_align1(i8* %x, i8* %y) {
; CHECK-LABEL: ldrwi32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 1
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrhi16_align1(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhi16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 1
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @ldrhi32_align1(i8* %x, i8* %y) {
; CHECK-LABEL: ldrhi32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    ldr r3, [r0, #4]
; CHECK-NEXT:    ldr r2, [r0]
; CHECK-NEXT:    adds r0, #3
; CHECK-NEXT:    strd r2, r3, [sp]
; CHECK-NEXT:    mov r2, sp
; CHECK-NEXT:    vldrh.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 1
  %2 = bitcast i8* %y to <4 x i32>*
  %3 = sext <4 x i16> %1 to <4 x i32>
  store <4 x i32> %3, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @ldrf32_align1(i8* %x, i8* %y) {
; CHECK-LABEL: ldrf32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 1
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 4
  ret i8* %z
}

define i8* @ldrf16_align1(i8* %x, i8* %y) {
; CHECK-LABEL: ldrf16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r0], #3
; CHECK-NEXT:    vstrh.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %x to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 1
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 2
  ret i8* %z
}





define i8* @strw32_4(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_3(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_m4(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_m4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #-4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_508(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0], #508
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_512(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #512
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_m508(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_m508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0], #-508
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}

define i8* @strw32_m512(i8* %y, i8* %x) {
; CHECK-LABEL: strw32_m512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0]
; CHECK-NEXT:    sub.w r0, r0, #512
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 4
  ret i8* %z
}


define i8* @strh32_4(i8* %y, i8* %x) {
; CHECK-LABEL: strh32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = bitcast i8* %y to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh32_3(i8* %y, i8* %x) {
; CHECK-LABEL: strh32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0]
; CHECK-NEXT:    adds r0, #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = bitcast i8* %y to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh32_2(i8* %y, i8* %x) {
; CHECK-LABEL: strh32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0], #2
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 2
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = bitcast i8* %y to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh32_254(i8* %y, i8* %x) {
; CHECK-LABEL: strh32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0], #254
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 254
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = bitcast i8* %y to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh32_256(i8* %y, i8* %x) {
; CHECK-LABEL: strh32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #256
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 256
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 2
  %2 = bitcast i8* %y to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 2
  ret i8* %z
}


define i8* @strh16_4(i8* %y, i8* %x) {
; CHECK-LABEL: strh16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh16_3(i8* %y, i8* %x) {
; CHECK-LABEL: strh16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh16_2(i8* %y, i8* %x) {
; CHECK-LABEL: strh16_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #2
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 2
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh16_254(i8* %y, i8* %x) {
; CHECK-LABEL: strh16_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0], #254
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 254
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}

define i8* @strh16_256(i8* %y, i8* %x) {
; CHECK-LABEL: strh16_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrh.16 q0, [r0]
; CHECK-NEXT:    add.w r0, r0, #256
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 256
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 2
  ret i8* %z
}


define i8* @strb32_4(i8* %y, i8* %x) {
; CHECK-LABEL: strb32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = bitcast i8* %y to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb32_3(i8* %y, i8* %x) {
; CHECK-LABEL: strb32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = bitcast i8* %y to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb32_127(i8* %y, i8* %x) {
; CHECK-LABEL: strb32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0], #127
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = bitcast i8* %y to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb32_128(i8* %y, i8* %x) {
; CHECK-LABEL: strb32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 1
  %2 = bitcast i8* %y to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 1
  ret i8* %z
}


define i8* @strb16_4(i8* %y, i8* %x) {
; CHECK-LABEL: strb16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = bitcast i8* %y to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb16_3(i8* %y, i8* %x) {
; CHECK-LABEL: strb16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = bitcast i8* %y to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb16_127(i8* %y, i8* %x) {
; CHECK-LABEL: strb16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0], #127
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = bitcast i8* %y to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb16_128(i8* %y, i8* %x) {
; CHECK-LABEL: strb16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = bitcast i8* %y to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 1
  ret i8* %z
}


define i8* @strb8_4(i8* %y, i8* %x) {
; CHECK-LABEL: strb8_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb8_3(i8* %y, i8* %x) {
; CHECK-LABEL: strb8_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb8_127(i8* %y, i8* %x) {
; CHECK-LABEL: strb8_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #127
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strb8_128(i8* %y, i8* %x) {
; CHECK-LABEL: strb8_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u8 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0]
; CHECK-NEXT:    adds r0, #128
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 1
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 1
  ret i8* %z
}

define i8* @strf32_4(i8* %y, i8* %x) {
; CHECK-LABEL: strf32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 4
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 4
  ret i8* %z
}

define i8* @strf16_4(i8* %y, i8* %x) {
; CHECK-LABEL: strf16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #4
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 2
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 2
  ret i8* %z
}

define i8* @strwi32_align1(i8* %y, i8* %x) {
; CHECK-LABEL: strwi32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 1
  ret i8* %z
}

define i8* @strhi16_align1(i8* %y, i8* %x) {
; CHECK-LABEL: strhi16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 2
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 1
  ret i8* %z
}

define i8* @strhi32_align1(i8* %y, i8* %x) {
; CHECK-LABEL: strhi32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, #8
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    mov r1, sp
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    ldrd r1, r2, [sp]
; CHECK-NEXT:    str r1, [r0]
; CHECK-NEXT:    str r2, [r0, #4]
; CHECK-NEXT:    adds r0, #3
; CHECK-NEXT:    add sp, #8
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 4
  %2 = bitcast i8* %y to <4 x i16>*
  %3 = trunc <4 x i32> %1 to <4 x i16>
  store <4 x i16> %3, <4 x i16>* %2, align 1
  ret i8* %z
}

define i8* @strf32_align1(i8* %y, i8* %x) {
; CHECK-LABEL: strf32_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 4
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 1
  ret i8* %z
}

define i8* @strf16_align1(i8* %y, i8* %x) {
; CHECK-LABEL: strf16_align1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u16 q0, [r1]
; CHECK-NEXT:    vstrb.8 q0, [r0], #3
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 2
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 1
  ret i8* %z
}
