; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -passes='print<cost-model>' 2>&1 -disable-output | FileCheck %s --check-prefixes=ALL,X64
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -passes='print<cost-model>' 2>&1 -disable-output -mattr=+movbe | FileCheck %s --check-prefixes=ALL,X64
; RUN: opt < %s -mtriple=i686-unknown-linux-gnu -passes='print<cost-model>' 2>&1 -disable-output | FileCheck %s --check-prefixes=ALL,X86
; RUN: opt < %s -mtriple=i686-unknown-linux-gnu -passes='print<cost-model>' 2>&1 -disable-output -mattr=+movbe | FileCheck %s --check-prefixes=ALL,X86

declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)
declare i128 @llvm.bswap.i128(i128)

; Verify the cost of scalar bswap instructions.

define i16 @var_bswap_i16(i16 %a) {
; ALL-LABEL: 'var_bswap_i16'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call i16 @llvm.bswap.i16(i16 %a)
; ALL-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i16 %bswap
;
  %bswap = call i16 @llvm.bswap.i16(i16 %a)
  ret i16 %bswap
}

define i32 @var_bswap_i32(i32 %a) {
; ALL-LABEL: 'var_bswap_i32'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call i32 @llvm.bswap.i32(i32 %a)
; ALL-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %bswap
;
  %bswap = call i32 @llvm.bswap.i32(i32 %a)
  ret i32 %bswap
}

define i64 @var_bswap_i64(i64 %a) {
; X64-LABEL: 'var_bswap_i64'
; X64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bswap = call i64 @llvm.bswap.i64(i64 %a)
; X64-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i64 %bswap
;
; X86-LABEL: 'var_bswap_i64'
; X86-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call i64 @llvm.bswap.i64(i64 %a)
; X86-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i64 %bswap
;
  %bswap = call i64 @llvm.bswap.i64(i64 %a)
  ret i64 %bswap
}

define i128 @var_bswap_i128(i128 %a) {
; X64-LABEL: 'var_bswap_i128'
; X64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %bswap = call i128 @llvm.bswap.i128(i128 %a)
; X64-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i128 %bswap
;
; X86-LABEL: 'var_bswap_i128'
; X86-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %bswap = call i128 @llvm.bswap.i128(i128 %a)
; X86-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i128 %bswap
;
  %bswap = call i128 @llvm.bswap.i128(i128 %a)
  ret i128 %bswap
}
