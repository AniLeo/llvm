; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -sroa < %s | FileCheck %s

%st.half = type { half }

; Allow speculateSelectInstLoads to fold load and select
; even if there is an intervening bitcast.
define <2 x i16> @test_load_bitcast_select(i1 %cond1, i1 %cond2) {
; CHECK-LABEL: @test_load_bitcast_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast half 0xHFFFF to i16
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast half 0xH0000 to i16
; CHECK-NEXT:    [[LD1_SROA_SPECULATED:%.*]] = select i1 [[COND1:%.*]], i16 [[TMP0]], i16 [[TMP1]]
; CHECK-NEXT:    [[V1:%.*]] = insertelement <2 x i16> undef, i16 [[LD1_SROA_SPECULATED]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast half 0xHFFFF to i16
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast half 0xH0000 to i16
; CHECK-NEXT:    [[LD2_SROA_SPECULATED:%.*]] = select i1 [[COND2:%.*]], i16 [[TMP2]], i16 [[TMP3]]
; CHECK-NEXT:    [[V2:%.*]] = insertelement <2 x i16> [[V1]], i16 [[LD2_SROA_SPECULATED]], i32 1
; CHECK-NEXT:    ret <2 x i16> [[V2]]
;
entry:
  %true = alloca half, align 2
  %false = alloca half, align 2
  store half 0xHFFFF, half* %true, align 2
  store half 0xH0000, half* %false, align 2
  %false.cast = bitcast half* %false to %st.half*
  %true.cast = bitcast half* %true to %st.half*
  %sel1 = select i1 %cond1, %st.half* %true.cast, %st.half* %false.cast
  %cast1 = bitcast %st.half* %sel1 to i16*
  %ld1 = load i16, i16* %cast1, align 2
  %v1 = insertelement <2 x i16> undef, i16 %ld1, i32 0
  %sel2 = select i1 %cond2, %st.half* %true.cast, %st.half* %false.cast
  %cast2 = bitcast %st.half* %sel2 to i16*
  %ld2 = load i16, i16* %cast2, align 2
  %v2 = insertelement <2 x i16> %v1, i16 %ld2, i32 1
  ret <2 x i16> %v2
}

%st.args = type { i32, i32* }

; A bitcasted load and a direct load of select.
define void @test_multiple_loads_select(i1 %cmp){
; CHECK-LABEL: @test_multiple_loads_select(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* undef to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* undef to i8*
; CHECK-NEXT:    [[ADDR_I8_SROA_SPECULATED:%.*]] = select i1 [[CMP:%.*]], i8* [[TMP0]], i8* [[TMP1]]
; CHECK-NEXT:    call void @foo_i8(i8* [[ADDR_I8_SROA_SPECULATED]])
; CHECK-NEXT:    [[ADDR_I32_SROA_SPECULATED:%.*]] = select i1 [[CMP]], i32* undef, i32* undef
; CHECK-NEXT:    call void @foo_i32(i32* [[ADDR_I32_SROA_SPECULATED]])
; CHECK-NEXT:    ret void
;
entry:
  %args = alloca [2 x %st.args], align 16
  %arr0 = getelementptr inbounds [2 x %st.args], [2 x %st.args]* %args, i64 0, i64 0
  %arr1 = getelementptr inbounds [2 x %st.args], [2 x %st.args]* %args, i64 0, i64 1
  %sel = select i1 %cmp, %st.args* %arr1, %st.args* %arr0
  %addr = getelementptr inbounds %st.args, %st.args* %sel, i64 0, i32 1
  %bcast.i8 = bitcast i32** %addr to i8**
  %addr.i8 = load i8*, i8** %bcast.i8, align 8
  call void @foo_i8(i8* %addr.i8)
  %addr.i32 = load i32*, i32** %addr, align 8
  call void @foo_i32 (i32* %addr.i32)
  ret void
}

declare void @foo_i8(i8*)
declare void @foo_i32(i32*)
