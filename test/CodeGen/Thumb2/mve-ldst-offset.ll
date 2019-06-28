; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve %s -o - | FileCheck %s

define i8* @post_ldrwu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_m4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_m4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #-4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -4
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_508(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #508
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 508
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_512(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #512
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 512
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_m508(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_m508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    sub.w r2, r0, #508
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -508
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwu32_m512(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwu32_m512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    sub.w r2, r0, #512
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 -512
  %0 = bitcast i8* %z to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %x
}


define i8* @post_ldrhu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrh.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhu32_2(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #2
; CHECK-NEXT:    vldrh.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhu32_254(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #254
; CHECK-NEXT:    vldrh.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhu32_256(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #256
; CHECK-NEXT:    vldrh.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = zext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrhs32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhs32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.s32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhs32_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhs32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrh.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhs32_2(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhs32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #2
; CHECK-NEXT:    vldrh.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhs32_254(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhs32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #254
; CHECK-NEXT:    vldrh.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrhs32_256(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhs32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #256
; CHECK-NEXT:    vldrh.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %z to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = sext <4 x i16> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrhu16_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrhu16_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrhu16_2(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu16_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #2
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 2
  %0 = bitcast i8* %z to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrhu16_254(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu16_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #254
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 254
  %0 = bitcast i8* %z to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrhu16_256(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrhu16_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #256
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 256
  %0 = bitcast i8* %z to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %x
}


define i8* @post_ldrbu32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu32_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrb.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu32_127(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #127
; CHECK-NEXT:    vldrb.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu32_128(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #128
; CHECK-NEXT:    vldrb.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = zext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrbs32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs32_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrb.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs32_127(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #127
; CHECK-NEXT:    vldrb.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs32_128(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #128
; CHECK-NEXT:    vldrb.s32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %z to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = sext <4 x i8> %1 to <4 x i32>
  %3 = bitcast i8* %y to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrbu16_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu16_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrb.u16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu16_127(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #127
; CHECK-NEXT:    vldrb.u16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbu16_128(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #128
; CHECK-NEXT:    vldrb.u16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = zext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrbs16_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.s16 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs16_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrb.s16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs16_127(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #127
; CHECK-NEXT:    vldrb.s16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}

define i8* @post_ldrbs16_128(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbs16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #128
; CHECK-NEXT:    vldrb.s16 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %z to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = sext <8 x i8> %1 to <8 x i16>
  %3 = bitcast i8* %y to <8 x i16>*
  store <8 x i16> %2, <8 x i16>* %3, align 8
  ret i8* %x
}


define i8* @post_ldrbu8_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu8_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrbu8_3(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu8_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    adds r2, r0, #3
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 3
  %0 = bitcast i8* %z to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrbu8_127(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu8_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add.w r2, r0, #127
; CHECK-NEXT:    vldrw.u32 q0, [r2]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 127
  %0 = bitcast i8* %z to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrbu8_128(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrbu8_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #128]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 128
  %0 = bitcast i8* %z to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %y to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwf32_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwf32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 8
  %2 = bitcast i8* %y to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 8
  ret i8* %x
}

define i8* @post_ldrwf16_4(i8* %x, i8* %y) {
; CHECK-LABEL: post_ldrwf16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r0, #4]
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %x, i32 4
  %0 = bitcast i8* %z to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 8
  %2 = bitcast i8* %y to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 8
  ret i8* %x
}





define i8* @post_strw32_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_m4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_m4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #-4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -4
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_508(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #508
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_512(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #512
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_m508(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_m508:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    sub.w r1, r0, #508
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -508
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}

define i8* @post_strw32_m512(i8* %y, i8* %x) {
; CHECK-LABEL: post_strw32_m512:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    sub.w r1, r0, #512
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 -512
  %0 = bitcast i8* %x to <4 x i32>*
  %1 = load <4 x i32>, <4 x i32>* %0, align 8
  %2 = bitcast i8* %z to <4 x i32>*
  store <4 x i32> %1, <4 x i32>* %2, align 8
  ret i8* %y
}


define i8* @post_strh32_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    vstrh.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = bitcast i8* %z to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh32_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = bitcast i8* %z to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh32_2(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh32_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #2
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 2
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = bitcast i8* %z to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh32_254(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh32_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #254
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 254
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = bitcast i8* %z to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh32_256(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh32_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrh.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #256
; CHECK-NEXT:    vstrh.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 256
  %0 = bitcast i8* %x to <4 x i16>*
  %1 = load <4 x i16>, <4 x i16>* %0, align 8
  %2 = bitcast i8* %z to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %2, align 8
  ret i8* %y
}


define i8* @post_strh16_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %z to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh16_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %z to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh16_2(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh16_2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #2
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 2
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %z to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh16_254(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh16_254:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #254
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 254
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %z to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %y
}

define i8* @post_strh16_256(i8* %y, i8* %x) {
; CHECK-LABEL: post_strh16_256:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #256
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 256
  %0 = bitcast i8* %x to <8 x i16>*
  %1 = load <8 x i16>, <8 x i16>* %0, align 8
  %2 = bitcast i8* %z to <8 x i16>*
  store <8 x i16> %1, <8 x i16>* %2, align 8
  ret i8* %y
}


define i8* @post_strb32_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    vstrb.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = bitcast i8* %z to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb32_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb32_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrb.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = bitcast i8* %z to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb32_127(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb32_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #127
; CHECK-NEXT:    vstrb.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = bitcast i8* %z to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb32_128(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb32_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #128
; CHECK-NEXT:    vstrb.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <4 x i8>*
  %1 = load <4 x i8>, <4 x i8>* %0, align 8
  %2 = bitcast i8* %z to <4 x i8>*
  store <4 x i8> %1, <4 x i8>* %2, align 8
  ret i8* %y
}


define i8* @post_strb16_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    vstrb.16 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = bitcast i8* %z to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb16_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb16_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrb.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = bitcast i8* %z to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb16_127(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb16_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #127
; CHECK-NEXT:    vstrb.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = bitcast i8* %z to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb16_128(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb16_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrb.u16 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #128
; CHECK-NEXT:    vstrb.16 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 8
  %2 = bitcast i8* %z to <8 x i8>*
  store <8 x i8> %1, <8 x i8>* %2, align 8
  ret i8* %y
}


define i8* @post_strb8_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb8_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %z to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb8_3(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb8_3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    adds r1, r0, #3
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 3
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %z to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb8_127(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb8_127:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    add.w r1, r0, #127
; CHECK-NEXT:    vstrw.32 q0, [r1]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 127
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %z to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strb8_128(i8* %y, i8* %x) {
; CHECK-LABEL: post_strb8_128:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #128]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 128
  %0 = bitcast i8* %x to <16 x i8>*
  %1 = load <16 x i8>, <16 x i8>* %0, align 8
  %2 = bitcast i8* %z to <16 x i8>*
  store <16 x i8> %1, <16 x i8>* %2, align 8
  ret i8* %y
}

define i8* @post_strf32_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strf32_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <4 x float>*
  %1 = load <4 x float>, <4 x float>* %0, align 8
  %2 = bitcast i8* %z to <4 x float>*
  store <4 x float> %1, <4 x float>* %2, align 8
  ret i8* %y
}

define i8* @post_strf16_4(i8* %y, i8* %x) {
; CHECK-LABEL: post_strf16_4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vldrw.u32 q0, [r1]
; CHECK-NEXT:    vstrw.32 q0, [r0, #4]
; CHECK-NEXT:    bx lr
entry:
  %z = getelementptr inbounds i8, i8* %y, i32 4
  %0 = bitcast i8* %x to <8 x half>*
  %1 = load <8 x half>, <8 x half>* %0, align 8
  %2 = bitcast i8* %z to <8 x half>*
  store <8 x half> %1, <8 x half>* %2, align 8
  ret i8* %y
}
