; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE2
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+sse4.1 | FileCheck %s --check-prefixes=CHECK,SSE41

define void @zext_v4i8_to_v4i64(<4 x i8>* %a) {
; SSE2-LABEL: 'zext_v4i8_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = zext <4 x i8> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v4i8_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <4 x i8> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = zext <4 x i8> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}

define void @sext_v4i8_to_v4i64(<4 x i8>* %a) {
; SSE2-LABEL: 'sext_v4i8_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %2 = sext <4 x i8> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i8_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <4 x i8> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = sext <4 x i8> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}

define void @zext_v4i16_to_v4i64(<4 x i16>* %a) {
; SSE2-LABEL: 'zext_v4i16_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = zext <4 x i16> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v4i16_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <4 x i16> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i16>, <4 x i16>* %a
  %2 = zext <4 x i16> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}

define void @sext_v4i16_to_v4i64(<4 x i16>* %a) {
; SSE2-LABEL: 'sext_v4i16_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %2 = sext <4 x i16> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i16_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <4 x i16> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i16>, <4 x i16>* %a
  %2 = sext <4 x i16> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}


define void @zext_v4i32_to_v4i64(<4 x i32>* %a) {
; SSE2-LABEL: 'zext_v4i32_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = zext <4 x i32> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v4i32_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <4 x i32> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i32>, <4 x i32>* %a
  %2 = zext <4 x i32> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}

define void @sext_v4i32_to_v4i64(<4 x i32>* %a) {
; SSE2-LABEL: 'sext_v4i32_to_v4i64'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %2 = sext <4 x i32> %1 to <4 x i64>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i32_to_v4i64'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <4 x i32> %1 to <4 x i64>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i64> %2, <4 x i64>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i32>, <4 x i32>* %a
  %2 = sext <4 x i32> %1 to <4 x i64>
  store <4 x i64> %2, <4 x i64>* undef, align 4
  ret void
}

define void @zext_v16i16_to_v16i32(<16 x i16>* %a) {
; SSE2-LABEL: 'zext_v16i16_to_v16i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <16 x i16>, <16 x i16>* %a, align 32
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %2 = zext <16 x i16> %1 to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v16i16_to_v16i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <16 x i16>, <16 x i16>* %a, align 32
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = zext <16 x i16> %1 to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i16>, <16 x i16>* %a
  %2 = zext <16 x i16> %1 to <16 x i32>
  store <16 x i32> %2, <16 x i32>* undef, align 4
  ret void
}

define void @sext_v16i16_to_v16i32(<16 x i16>* %a) {
; SSE2-LABEL: 'sext_v16i16_to_v16i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <16 x i16>, <16 x i16>* %a, align 32
; SSE2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %2 = sext <16 x i16> %1 to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v16i16_to_v16i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <16 x i16>, <16 x i16>* %a, align 32
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = sext <16 x i16> %1 to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i16>, <16 x i16>* %a
  %2 = sext <16 x i16> %1 to <16 x i32>
  store <16 x i32> %2, <16 x i32>* undef, align 4
  ret void
}

define void @zext_v8i16_to_v8i32(<8 x i16>* %a) {
; SSE2-LABEL: 'zext_v8i16_to_v8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = zext <8 x i16> %1 to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v8i16_to_v8i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <8 x i16> %1 to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i16>, <8 x i16>* %a
  %2 = zext <8 x i16> %1 to <8 x i32>
  store <8 x i32> %2, <8 x i32>* undef, align 4
  ret void
}

define void @sext_v8i16_to_v8i32(<8 x i16>* %a) {
; SSE2-LABEL: 'sext_v8i16_to_v8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = sext <8 x i16> %1 to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v8i16_to_v8i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <8 x i16> %1 to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i16>, <8 x i16>* %a
  %2 = sext <8 x i16> %1 to <8 x i32>
  store <8 x i32> %2, <8 x i32>* undef, align 4
  ret void
}

define void @zext_v4i16_to_v4i32(<4 x i16>* %a) {
; CHECK-LABEL: 'zext_v4i16_to_v4i32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = zext <4 x i16> %1 to <4 x i32>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i16>, <4 x i16>* %a
  %2 = zext <4 x i16> %1 to <4 x i32>
  store <4 x i32> %2, <4 x i32>* undef, align 4
  ret void
}

define void @sext_v4i16_to_v4i32(<4 x i16>* %a) {
; SSE2-LABEL: 'sext_v4i16_to_v4i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <4 x i16> %1 to <4 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i16_to_v4i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = sext <4 x i16> %1 to <4 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i16>, <4 x i16>* %a
  %2 = sext <4 x i16> %1 to <4 x i32>
  store <4 x i32> %2, <4 x i32>* undef, align 4
  ret void
}

define void @zext_v16i8_to_v16i32(<16 x i8>* %a) {
; SSE2-LABEL: 'zext_v16i8_to_v16i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 9 for instruction: %2 = zext <16 x i8> %1 to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v16i8_to_v16i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = zext <16 x i8> %1 to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i8>, <16 x i8>* %a
  %2 = zext <16 x i8> %1 to <16 x i32>
  store <16 x i32> %2, <16 x i32>* undef, align 4
  ret void
}

define void @sext_v16i8_to_v16i32(<16 x i8>* %a) {
; SSE2-LABEL: 'sext_v16i8_to_v16i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %2 = sext <16 x i8> %1 to <16 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v16i8_to_v16i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = sext <16 x i8> %1 to <16 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <16 x i32> %2, <16 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i8>, <16 x i8>* %a
  %2 = sext <16 x i8> %1 to <16 x i32>
  store <16 x i32> %2, <16 x i32>* undef, align 4
  ret void
}

define void @zext_v8i8_to_v8i32(<8 x i8>* %a) {
; SSE2-LABEL: 'zext_v8i8_to_v8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %2 = zext <8 x i8> %1 to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v8i8_to_v8i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <8 x i8> %1 to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i8>, <8 x i8>* %a
  %2 = zext <8 x i8> %1 to <8 x i32>
  store <8 x i32> %2, <8 x i32>* undef, align 4
  ret void
}

define void @sext_v8i8_to_v8i32(<8 x i8>* %a) {
; SSE2-LABEL: 'sext_v8i8_to_v8i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %2 = sext <8 x i8> %1 to <8 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v8i8_to_v8i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <8 x i8> %1 to <8 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i32> %2, <8 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i8>, <8 x i8>* %a
  %2 = sext <8 x i8> %1 to <8 x i32>
  store <8 x i32> %2, <8 x i32>* undef, align 4
  ret void
}

define void @zext_v4i8_to_v4i32(<4 x i8>* %a) {
; SSE2-LABEL: 'zext_v4i8_to_v4i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <4 x i8> %1 to <4 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v4i8_to_v4i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = zext <4 x i8> %1 to <4 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = zext <4 x i8> %1 to <4 x i32>
  store <4 x i32> %2, <4 x i32>* undef, align 4
  ret void
}

define void @sext_v4i8_to_v4i32(<4 x i8>* %a) {
; SSE2-LABEL: 'sext_v4i8_to_v4i32'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = sext <4 x i8> %1 to <4 x i32>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i8_to_v4i32'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = sext <4 x i8> %1 to <4 x i32>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> %2, <4 x i32>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = sext <4 x i8> %1 to <4 x i32>
  store <4 x i32> %2, <4 x i32>* undef, align 4
  ret void
}

define void @zext_v16i8_to_v16i16(<16 x i8>* %a) {
; SSE2-LABEL: 'zext_v16i8_to_v16i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = zext <16 x i8> %1 to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'zext_v16i8_to_v16i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = zext <16 x i8> %1 to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i8>, <16 x i8>* %a
  %2 = zext <16 x i8> %1 to <16 x i16>
  store <16 x i16> %2, <16 x i16>* undef, align 4
  ret void
}

define void @sext_v16i8_to_v16i16(<16 x i8>* %a) {
; SSE2-LABEL: 'sext_v16i8_to_v16i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = sext <16 x i8> %1 to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v16i8_to_v16i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <16 x i8>, <16 x i8>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <16 x i8> %1 to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i8>, <16 x i8>* %a
  %2 = sext <16 x i8> %1 to <16 x i16>
  store <16 x i16> %2, <16 x i16>* undef, align 4
  ret void
}

define void @zext_v8i8_to_v8i16(<8 x i8>* %a) {
; CHECK-LABEL: 'zext_v8i8_to_v8i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = zext <8 x i8> %1 to <8 x i16>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> %2, <8 x i16>* undef, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i8>, <8 x i8>* %a
  %2 = zext <8 x i8> %1 to <8 x i16>
  store <8 x i16> %2, <8 x i16>* undef, align 4
  ret void
}

define void @sext_v8i8_to_v8i16(<8 x i8>* %a) {
; SSE2-LABEL: 'sext_v8i8_to_v8i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <8 x i8> %1 to <8 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> %2, <8 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v8i8_to_v8i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i8>, <8 x i8>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = sext <8 x i8> %1 to <8 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> %2, <8 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i8>, <8 x i8>* %a
  %2 = sext <8 x i8> %1 to <8 x i16>
  store <8 x i16> %2, <8 x i16>* undef, align 4
  ret void
}

define void @zext_v4i8_to_v4i16(<4 x i8>* %a) {
; CHECK-LABEL: 'zext_v4i8_to_v4i16'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = zext <4 x i8> %1 to <4 x i16>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %2, <4 x i16>* undef, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = zext <4 x i8> %1 to <4 x i16>
  store <4 x i16> %2, <4 x i16>* undef, align 4
  ret void
}

define void @sext_v4i8_to_v4i16(<4 x i8>* %a) {
; SSE2-LABEL: 'sext_v4i8_to_v4i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %2 = sext <4 x i8> %1 to <4 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %2, <4 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'sext_v4i8_to_v4i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i8>, <4 x i8>* %a, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = sext <4 x i8> %1 to <4 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %2, <4 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i8>, <4 x i8>* %a
  %2 = sext <4 x i8> %1 to <4 x i16>
  store <4 x i16> %2, <4 x i16>* undef, align 4
  ret void
}

define void @truncate_v16i32_to_v16i16(<16 x i32>* %a) {
; SSE2-LABEL: 'truncate_v16i32_to_v16i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %1 = load <16 x i32>, <16 x i32>* %a, align 64
; SSE2-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %2 = trunc <16 x i32> %1 to <16 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v16i32_to_v16i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %1 = load <16 x i32>, <16 x i32>* %a, align 64
; SSE41-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %2 = trunc <16 x i32> %1 to <16 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i16> %2, <16 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i32>, <16 x i32>* %a
  %2 = trunc <16 x i32> %1 to <16 x i16>
  store <16 x i16> %2, <16 x i16>* undef, align 4
  ret void
}

define void @truncate_v8i32_to_v8i16(<8 x i32>* %a) {
; SSE2-LABEL: 'truncate_v8i32_to_v8i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <8 x i32>, <8 x i32>* %a, align 32
; SSE2-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %2 = trunc <8 x i32> %1 to <8 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> %2, <8 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v8i32_to_v8i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <8 x i32>, <8 x i32>* %a, align 32
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = trunc <8 x i32> %1 to <8 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> %2, <8 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i32>, <8 x i32>* %a
  %2 = trunc <8 x i32> %1 to <8 x i16>
  store <8 x i16> %2, <8 x i16>* undef, align 4
  ret void
}

define void @truncate_v4i32_to_v4i16(<4 x i32>* %a) {
; SSE2-LABEL: 'truncate_v4i32_to_v4i16'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = trunc <4 x i32> %1 to <4 x i16>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %2, <4 x i16>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v4i32_to_v4i16'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = trunc <4 x i32> %1 to <4 x i16>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i16> %2, <4 x i16>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i32>, <4 x i32>* %a
  %2 = trunc <4 x i32> %1 to <4 x i16>
  store <4 x i16> %2, <4 x i16>* undef, align 4
  ret void
}

define void @truncate_v16i32_to_v16i8(<16 x i32>* %a) {
; CHECK-LABEL: 'truncate_v16i32_to_v16i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %1 = load <16 x i32>, <16 x i32>* %a, align 64
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %2 = trunc <16 x i32> %1 to <16 x i8>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <16 x i8> %2, <16 x i8>* undef, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i32>, <16 x i32>* %a
  %2 = trunc <16 x i32> %1 to <16 x i8>
  store <16 x i8> %2, <16 x i8>* undef, align 4
  ret void
}

define void @truncate_v8i32_to_v8i8(<8 x i32>* %a) {
; SSE2-LABEL: 'truncate_v8i32_to_v8i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <8 x i32>, <8 x i32>* %a, align 32
; SSE2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %2 = trunc <8 x i32> %1 to <8 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i8> %2, <8 x i8>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v8i32_to_v8i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <8 x i32>, <8 x i32>* %a, align 32
; SSE41-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = trunc <8 x i32> %1 to <8 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i8> %2, <8 x i8>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i32>, <8 x i32>* %a
  %2 = trunc <8 x i32> %1 to <8 x i8>
  store <8 x i8> %2, <8 x i8>* undef, align 4
  ret void
}

define void @truncate_v4i32_to_v4i8(<4 x i32>* %a) {
; SSE2-LABEL: 'truncate_v4i32_to_v4i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = trunc <4 x i32> %1 to <4 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i8> %2, <4 x i8>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v4i32_to_v4i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i32>, <4 x i32>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = trunc <4 x i32> %1 to <4 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i8> %2, <4 x i8>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i32>, <4 x i32>* %a
  %2 = trunc <4 x i32> %1 to <4 x i8>
  store <4 x i8> %2, <4 x i8>* undef, align 4
  ret void
}

define void @truncate_v16i16_to_v16i8(<16 x i16>* %a) {
; CHECK-LABEL: 'truncate_v16i16_to_v16i8'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = load <16 x i16>, <16 x i16>* %a, align 32
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %2 = trunc <16 x i16> %1 to <16 x i8>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <16 x i8> %2, <16 x i8>* undef, align 4
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <16 x i16>, <16 x i16>* %a
  %2 = trunc <16 x i16> %1 to <16 x i8>
  store <16 x i8> %2, <16 x i8>* undef, align 4
  ret void
}

define void @truncate_v8i16_to_v8i8(<8 x i16>* %a) {
; SSE2-LABEL: 'truncate_v8i16_to_v8i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = trunc <8 x i16> %1 to <8 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i8> %2, <8 x i8>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v8i16_to_v8i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <8 x i16>, <8 x i16>* %a, align 16
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = trunc <8 x i16> %1 to <8 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i8> %2, <8 x i8>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <8 x i16>, <8 x i16>* %a
  %2 = trunc <8 x i16> %1 to <8 x i8>
  store <8 x i8> %2, <8 x i8>* undef, align 4
  ret void
}

define void @truncate_v4i16_to_v4i8(<4 x i16>* %a) {
; SSE2-LABEL: 'truncate_v4i16_to_v4i8'
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE2-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %2 = trunc <4 x i16> %1 to <4 x i8>
; SSE2-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i8> %2, <4 x i8>* undef, align 4
; SSE2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; SSE41-LABEL: 'truncate_v4i16_to_v4i8'
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load <4 x i16>, <4 x i16>* %a, align 8
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = trunc <4 x i16> %1 to <4 x i8>
; SSE41-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i8> %2, <4 x i8>* undef, align 4
; SSE41-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %1 = load <4 x i16>, <4 x i16>* %a
  %2 = trunc <4 x i16> %1 to <4 x i8>
  store <4 x i8> %2, <4 x i8>* undef, align 4
  ret void
}
