; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

; Prohibit poiter cast for amx.
define dso_local void @test_amx_load_store(<256 x i32>* %src, i8* %dst) {
; CHECK-LABEL: @test_amx_load_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC:%.*]] = load <256 x i32>, <256 x i32>* [[SRC:%.*]], align 64
; CHECK-NEXT:    [[BC:%.*]] = bitcast <256 x i32> [[VEC]] to x86_amx
; CHECK-NEXT:    tail call void @llvm.x86.tilestored64.internal(i16 16, i16 16, i8* [[DST:%.*]], i64 64, x86_amx [[BC]])
; CHECK-NEXT:    ret void
;
entry:
  %vec = load <256 x i32>, <256 x i32>* %src, align 64
  %bc = bitcast <256 x i32> %vec to x86_amx
  tail call void @llvm.x86.tilestored64.internal(i16 16, i16 16, i8* %dst, i64 64, x86_amx %bc)
  ret void
}

; Prohibit poiter cast for amx.
define dso_local void @test_amx_load_store2(<256 x i32>* %dst, i8* %src) {
; CHECK-LABEL: @test_amx_load_store2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AMX:%.*]] = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 16, i16 16, i8* [[SRC:%.*]], i64 64)
; CHECK-NEXT:    [[BC:%.*]] = bitcast x86_amx [[AMX]] to <256 x i32>
; CHECK-NEXT:    store <256 x i32> [[BC]], <256 x i32>* [[DST:%.*]], align 1024
; CHECK-NEXT:    ret void
;
entry:
  %amx = tail call x86_amx @llvm.x86.tileloadd64.internal(i16 16, i16 16, i8* %src, i64 64)
  %bc = bitcast x86_amx %amx to <256 x i32>
  store <256 x i32> %bc, <256 x i32>* %dst
  ret void
}

declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)
