; RUN: opt < %s -dfsan -dfsan-track-origins=1 -dfsan-fast-8-labels -S | FileCheck %s --check-prefixes=CHECK,CHECK8,COMBINE_LOAD_PTR
; RUN: opt < %s -dfsan -dfsan-track-origins=1 -dfsan-fast-8-labels -dfsan-combine-pointer-labels-on-load=false -S | FileCheck %s --check-prefixes=CHECK,CHECK8
; RUN: opt < %s -dfsan -dfsan-track-origins=1 -dfsan-fast-16-labels -S | FileCheck %s --check-prefixes=CHECK,CHECK16,COMBINE_LOAD_PTR
; RUN: opt < %s -dfsan -dfsan-track-origins=1 -dfsan-fast-16-labels -dfsan-combine-pointer-labels-on-load=false -S | FileCheck %s --check-prefixes=CHECK,CHECK16
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK: @__dfsan_shadow_width_bits = weak_odr constant i32 [[#SBITS:]]
; CHECK: @__dfsan_shadow_width_bytes = weak_odr constant i32 [[#SBYTES:]]

define {} @load0({}* %p) {
  ; CHECK-LABEL: @"dfs$load0"
  ; CHECK-NEXT: %a = load {}, {}* %p, align 1
  ; CHECK-NEXT: store {} zeroinitializer, {}* bitcast ([100 x i64]* @__dfsan_retval_tls to {}*), align [[ALIGN:2]]
  ; CHECK-NEXT: store i32 0, i32* @__dfsan_retval_origin_tls, align 4
  ; CHECK-NEXT: ret {} %a

  %a = load {}, {}* %p
  ret {} %a
}

define i16 @load_non_escaped_alloca() {
  ; CHECK-LABEL: @"dfs$load_non_escaped_alloca"
  ; CHECK-NEXT: %[[#S_ALLOCA:]] = alloca i[[#SBITS]], align [[#SBYTES]]
  ; CHECK-NEXT: %_dfsa = alloca i32, align 4
  ; CHECK:      %[[#SHADOW:]] = load i[[#SBITS]], i[[#SBITS]]* %[[#S_ALLOCA]], align [[#SBYTES]]
  ; CHECK-NEXT: %[[#ORIGIN:]] = load i32, i32* %_dfsa, align 4
  ; CHECK-NEXT: %a = load i16, i16* %p, align 2
  ; CHECK-NEXT: store i[[#SBITS]] %[[#SHADOW]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT: store i32 %[[#ORIGIN]], i32* @__dfsan_retval_origin_tls, align 4
  
  %p = alloca i16
  %a = load i16, i16* %p
  ret i16 %a
}

define i16* @load_escaped_alloca() {
  ; CHECK-LABEL:  @"dfs$load_escaped_alloca"
  ; CHECK:        %[[#INTP:]] = ptrtoint i16* %p to i64
  ; CHECK-NEXT:   %[[#SHADOW_ADDR:]] = and i64 %[[#INTP]], [[#%.10d,MASK:]]
  ; CHECK16-NEXT: %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:   %[[#SHADOW_PTR0:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:   %[[#ORIGIN_OFFSET:]] = add i64 %[[#INTP+1]], [[#%.10d,ORIGIN_MASK:]]
  ; CHECK-NEXT:   %[[#ORIGIN_ADDR:]] = and i64 %[[#ORIGIN_OFFSET]], -4
  ; CHECK-NEXT:   %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:   {{%.*}} = load i32, i32* %[[#ORIGIN_PTR]], align 4
  ; CHECK-NEXT:   %[[#SHADOW_PTR1:]] = getelementptr i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR0]], i64 1
  ; CHECK-NEXT:   %[[#SHADOW:]]  = load i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR0]], align [[#SBYTES]]
  ; CHECK-NEXT:   %[[#SHADOW+1]] = load i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR1]], align [[#SBYTES]]
  ; CHECK-NEXT:   {{%.*}} = or i[[#SBITS]] %[[#SHADOW]], %[[#SHADOW+1]]
  ; CHECK-NEXT:   %a = load i16, i16* %p, align 2
  ; CHECK-NEXT:   store i[[#SBITS]] 0, i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:   store i32 0, i32* @__dfsan_retval_origin_tls, align 4
  
  %p = alloca i16
  %a = load i16, i16* %p
  ret i16* %p
}

@X = constant i1 1
define i1 @load_global() {
  ; CHECK-LABEL: @"dfs$load_global"
  ; CHECK: %a = load i1, i1* @X, align 1
  ; CHECK-NEXT: store i[[#SBITS]] 0, i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT: store i32 0, i32* @__dfsan_retval_origin_tls, align 4

  %a = load i1, i1* @X
  ret i1 %a
}

define i1 @load1(i1* %p) {
  ; CHECK-LABEL:             @"dfs$load1"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK-NEXT:            %[[#INTP:]] = ptrtoint i1* %p to i64
  ; CHECK-NEXT:            %[[#SHADOW_ADDR:]] = and i64 %[[#INTP]], [[#MASK]]
  ; CHECK16-NEXT:          %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:            %[[#SHADOW_PTR:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:            %[[#ORIGIN_OFFSET:]] = add i64 %[[#INTP+1]], [[#ORIGIN_MASK]]
  ; CHECK-NEXT:            %[[#ORIGIN_ADDR:]] = and i64 %[[#ORIGIN_OFFSET]], -4
  ; CHECK-NEXT:            %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:            %[[#AO:]] = load i32, i32* %[[#ORIGIN_PTR]], align 4
  ; CHECK-NEXT:            %[[#AS:]] = load i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR]], align [[#SBYTES]]

  ; COMBINE_LOAD_PTR-NEXT: %[[#AS:]] = or i[[#SBITS]] %[[#AS]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#AO:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#AO]]

  ; CHECK-NEXT:            %a = load i1, i1* %p, align 1
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#AS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#AO]], i32* @__dfsan_retval_origin_tls, align 4

  %a = load i1, i1* %p
  ret i1 %a
}

define i16 @load16(i1 %i, i16* %p) {
  ; CHECK-LABEL: @"dfs$load16"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 1), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* inttoptr (i64 add (i64 ptrtoint ([100 x i64]* @__dfsan_arg_tls to i64), i64 2) to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK-NEXT:            %[[#INTP:]] = ptrtoint i16* %p to i64
  ; CHECK-NEXT:            %[[#SHADOW_ADDR:]] = and i64 %[[#INTP]], [[#MASK]]
  ; CHECK16-NEXT:          %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:            %[[#SHADOW_PTR0:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:            %[[#ORIGIN_OFFSET:]] = add i64 %[[#INTP+1]], [[#ORIGIN_MASK]]
  ; CHECK-NEXT:            %[[#ORIGIN_ADDR:]] = and i64 %[[#ORIGIN_OFFSET]], -4
  ; CHECK-NEXT:            %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:            %[[#AO:]] = load i32, i32* %[[#ORIGIN_PTR]], align 4
  ; CHECK-NEXT:            %[[#SHADOW_PTR1:]] = getelementptr i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR0]], i64 1
  ; CHECK-NEXT:            %[[#SHADOW:]]  = load i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR0]], align [[#SBYTES]]
  ; CHECK-NEXT:            %[[#SHADOW+1]] = load i[[#SBITS]], i[[#SBITS]]* %[[#SHADOW_PTR1]], align [[#SBYTES]]
  ; CHECK-NEXT:            %[[#AS:]] = or i[[#SBITS]] %[[#SHADOW]], %[[#SHADOW+1]]

  ; COMBINE_LOAD_PTR-NEXT: %[[#AS:]] = or i[[#SBITS]] %[[#AS]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#AO:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#AO]]

  ; CHECK-NEXT:            %a = load i16, i16* %p, align 2
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#AS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#AO]], i32* @__dfsan_retval_origin_tls, align 4

  %a = load i16, i16* %p
  ret i16 %a
}

define i32 @load32(i32* %p) {
  ; CHECK-LABEL: @"dfs$load32"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK:                 %[[#INTP:]] = ptrtoint i32* %p to i64
  ; CHECK-NEXT:            %[[#SHADOW_ADDR:INTP+1]] = and i64 %[[#INTP]], [[#MASK]]
  ; CHECK16-NEXT:          %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:            %[[#SHADOW_PTR:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:            %[[#ORIGIN_ADDR:]] = add i64 %[[#INTP+1]], [[#ORIGIN_MASK]]
  ; CHECK-NEXT:            %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:            %[[#AO:]] = load i32, i32* %[[#ORIGIN_PTR]], align 4
  ; CHECK-NEXT:            %[[#WIDE_SHADOW_PTR:]] = bitcast i[[#SBITS]]* %[[#SHADOW_PTR]] to i[[#WSBITS:mul(SBITS,4)]]*
  ; CHECK-NEXT:            %[[#WIDE_SHADOW:]] = load i[[#WSBITS]], i[[#WSBITS]]* %[[#WIDE_SHADOW_PTR]], align [[#SBYTES]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW+1]] = lshr i[[#WSBITS]] %[[#WIDE_SHADOW]], [[#mul(SBITS,2)]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW+2]] = or i[[#WSBITS]] %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW+1]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW+3]] = lshr i[[#WSBITS]] %[[#WIDE_SHADOW+2]], [[#SBITS]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW+4]] = or i[[#WSBITS]] %[[#WIDE_SHADOW+2]], %[[#WIDE_SHADOW+3]]
  ; CHECK-NEXT:            %[[#SHADOW:]] = trunc i[[#WSBITS]] %[[#WIDE_SHADOW+4]] to i[[#SBITS]]

  ; COMBINE_LOAD_PTR-NEXT: %[[#SHADOW:]] = or i[[#SBITS]] %[[#SHADOW]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#AO:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#AO]]

  ; CHECK-NEXT:            %a = load i32, i32* %p, align 4
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#SHADOW]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#AO]], i32* @__dfsan_retval_origin_tls, align 4

  %a = load i32, i32* %p
  ret i32 %a
}

define i64 @load64(i64* %p) {
  ; CHECK-LABEL: @"dfs$load64"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK:                 %[[#INTP:]] = ptrtoint i64* %p to i64
  ; CHECK-NEXT:            %[[#SHADOW_ADDR:INTP+1]] = and i64 %[[#INTP]], [[#MASK]]
  ; CHECK16-NEXT:          %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:            %[[#SHADOW_PTR:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:            %[[#ORIGIN_ADDR:]] = add i64 %[[#INTP+1]], [[#ORIGIN_MASK]]
  ; CHECK-NEXT:            %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:            %[[#ORIGIN:]] = load i32, i32* %[[#ORIGIN_PTR]], align 8
  ; CHECK-NEXT:            %[[#WIDE_SHADOW_PTR:]] = bitcast i[[#SBITS]]* %[[#SHADOW_PTR]] to i64*
  ; CHECK-NEXT:            %[[#WIDE_SHADOW:]] = load i64, i64* %[[#WIDE_SHADOW_PTR]], align [[#SBYTES]]

  ; COMM: On fast16, the 2x64 shadow bits need to be ORed first.
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_PTR2:]] = getelementptr i64, i64* %[[#WIDE_SHADOW_PTR]], i64 1
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW2:]] = load i64, i64* %[[#WIDE_SHADOW_PTR2]], align [[#SBYTES]]
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW2]]
  ; CHECK16-NEXT:          %[[#ORIGIN_PTR2:]] = getelementptr i32, i32* %[[#ORIGIN_PTR]], i64 1
  ; CHECK16-NEXT:          %[[#ORIGIN2:]] = load i32, i32* %[[#ORIGIN_PTR2]], align 8
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 32
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 16
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK16-NEXT:          %[[#SHADOW:]] = trunc i64 %[[#WIDE_SHADOW]] to i[[#SBITS]]
  ; CHECK16-NEXT:          %[[#SHADOW_NZ:]] = icmp ne i64 %[[#WIDE_SHADOW2]], 0
  ; CHECK16-NEXT:          %[[#ORIGIN:]] = select i1 %[[#SHADOW_NZ]], i32 %[[#ORIGIN2]], i32 %[[#ORIGIN]]

  ; COMM: On fast8, no need to OR the wide shadow but one more shift is needed.
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 32
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 16
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 8
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#SHADOW:]] = trunc i64 %[[#WIDE_SHADOW]] to i[[#SBITS]]

  ; COMBINE_LOAD_PTR-NEXT: %[[#SHADOW:]] = or i[[#SBITS]] %[[#SHADOW]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#ORIGIN:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#ORIGIN]]

  ; CHECK-NEXT:            %a = load i64, i64* %p, align 8
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#SHADOW]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#ORIGIN]], i32* @__dfsan_retval_origin_tls, align 4
  
  %a = load i64, i64* %p
  ret i64 %a
}

define i64 @load64_align2(i64* %p) {
  ; CHECK-LABEL: @"dfs$load64_align2"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK-NEXT:            %[[#INTP:]] = bitcast i64* %p to i8*
  ; CHECK-NEXT:            %[[#LABEL_ORIGIN:]] = call zeroext i64 @__dfsan_load_label_and_origin(i8* %[[#INTP]], i64 8)
  ; CHECK-NEXT:            %[[#LABEL_ORIGIN+1]] = lshr i64 %[[#LABEL_ORIGIN]], 32
  ; CHECK-NEXT:            %[[#LABEL:]] = trunc i64 %[[#LABEL_ORIGIN+1]] to i[[#SBITS]]
  ; CHECK-NEXT:            %[[#ORIGIN:]] = trunc i64 %[[#LABEL_ORIGIN]] to i32

  ; COMBINE_LOAD_PTR-NEXT: %[[#LABEL:]] = or i[[#SBITS]] %[[#LABEL]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#ORIGIN:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#ORIGIN]]

  ; CHECK-NEXT:            %a = load i64, i64* %p, align 2
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#LABEL]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#ORIGIN]], i32* @__dfsan_retval_origin_tls, align 4

  %a = load i64, i64* %p, align 2
  ret i64 %a
}

define i128 @load128(i128* %p) {
  ; CHECK-LABEL: @"dfs$load128"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK:                 %[[#INTP:]] = ptrtoint i128* %p to i64
  ; CHECK-NEXT:            %[[#SHADOW_ADDR:INTP+1]] = and i64 %[[#INTP]], [[#MASK]]
  ; CHECK16-NEXT:          %[[#SHADOW_ADDR:]] = mul i64 %[[#SHADOW_ADDR]], 2
  ; CHECK-NEXT:            %[[#SHADOW_PTR:]] = inttoptr i64 %[[#SHADOW_ADDR]] to i[[#SBITS]]*
  ; CHECK-NEXT:            %[[#ORIGIN_ADDR:]] = add i64 %[[#INTP+1]], [[#ORIGIN_MASK]]
  ; CHECK-NEXT:            %[[#ORIGIN_PTR:]] = inttoptr i64 %[[#ORIGIN_ADDR]] to i32*
  ; CHECK-NEXT:            %[[#ORIGIN:]] = load i32, i32* %[[#ORIGIN_PTR]], align 8
  ; CHECK-NEXT:            %[[#WIDE_SHADOW_PTR:]] = bitcast i[[#SBITS]]* %[[#SHADOW_PTR]] to i64*
  ; CHECK-NEXT:            %[[#WIDE_SHADOW:]] = load i64, i64* %[[#WIDE_SHADOW_PTR]], align [[#SBYTES]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW_PTR2:]] = getelementptr i64, i64* %[[#WIDE_SHADOW_PTR]], i64 1
  ; CHECK-NEXT:            %[[#WIDE_SHADOW2:]] = load i64, i64* %[[#WIDE_SHADOW_PTR2]], align [[#SBYTES]]
  ; CHECK-NEXT:            %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW2]]
  ; CHECK-NEXT:            %[[#ORIGIN_PTR2:]] = getelementptr i32, i32* %[[#ORIGIN_PTR]], i64 1
  ; CHECK-NEXT:            %[[#ORIGIN2:]] = load i32, i32* %[[#ORIGIN_PTR2]], align 8

  ; COMM: On fast16, we need to OR 4x64bits for the wide shadow, before ORing its bytes.
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_PTR3:]] = getelementptr i64, i64* %[[#WIDE_SHADOW_PTR2]], i64 1
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW3:]] = load i64, i64* %[[#WIDE_SHADOW_PTR3]], align [[#SBYTES]]
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW3]]
  ; CHECK16-NEXT:          %[[#ORIGIN_PTR3:]] = getelementptr i32, i32* %[[#ORIGIN_PTR2]], i64 1
  ; CHECK16-NEXT:          %[[#ORIGIN3:]] = load i32, i32* %[[#ORIGIN_PTR3]], align 8
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_PTR4:]] = getelementptr i64, i64* %[[#WIDE_SHADOW_PTR3]], i64 1
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW4:]] = load i64, i64* %[[#WIDE_SHADOW_PTR4]], align [[#SBYTES]]
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW4]]
  ; CHECK16-NEXT:          %[[#ORIGIN_PTR4:]] = getelementptr i32, i32* %[[#ORIGIN_PTR3]], i64 1
  ; CHECK16-NEXT:          %[[#ORIGIN4:]] = load i32, i32* %[[#ORIGIN_PTR4]], align 8
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 32
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 16
  ; CHECK16-NEXT:          %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK16-NEXT:          %[[#SHADOW:]] = trunc i64 %[[#WIDE_SHADOW]] to i[[#SBITS]]
  ; CHECK16-NEXT:          %[[#SHADOW2_NZ:]] = icmp ne i64 %[[#WIDE_SHADOW2]], 0
  ; CHECK16-NEXT:          %[[#ORIGIN:]] = select i1 %[[#SHADOW2_NZ]], i32 %[[#ORIGIN2]], i32 %[[#ORIGIN]]
  ; CHECK16-NEXT:          %[[#SHADOW3_NZ:]] = icmp ne i64 %[[#WIDE_SHADOW3]], 0
  ; CHECK16-NEXT:          %[[#ORIGIN:]] = select i1 %[[#SHADOW3_NZ]], i32 %[[#ORIGIN3]], i32 %[[#ORIGIN]]
  ; CHECK16-NEXT:          %[[#SHADOW4_NZ:]] = icmp ne i64 %[[#WIDE_SHADOW4]], 0
  ; CHECK16-NEXT:          %[[#ORIGIN:]] = select i1 %[[#SHADOW4_NZ]], i32 %[[#ORIGIN4]], i32 %[[#ORIGIN]]
  
  ; COMM: On fast8, we need to OR 2x64bits for the wide shadow, before ORing its bytes (one more shift).
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 32
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 16
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW_SHIFTED:]] = lshr i64 %[[#WIDE_SHADOW]], 8
  ; CHECK8-NEXT:           %[[#WIDE_SHADOW:]] = or i64 %[[#WIDE_SHADOW]], %[[#WIDE_SHADOW_SHIFTED]]
  ; CHECK8-NEXT:           %[[#SHADOW:]] = trunc i64 %[[#WIDE_SHADOW]] to i[[#SBITS]]
  ; CHECK8-NEXT:           %[[#SHADOW2_NZ:]] = icmp ne i64 %[[#WIDE_SHADOW2]], 0
  ; CHECK8-NEXT:           %[[#ORIGIN:]] = select i1 %[[#SHADOW2_NZ]], i32 %[[#ORIGIN2]], i32 %[[#ORIGIN]]

  ; COMBINE_LOAD_PTR-NEXT: %[[#SHADOW:]] = or i[[#SBITS]] %[[#SHADOW]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#ORIGIN:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#ORIGIN]]

  ; CHECK-NEXT:            %a = load i128, i128* %p, align 8
  ; CHECK-NEXT:            store i[[#SBITS]] %[[#SHADOW]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT:            store i32 %[[#ORIGIN]], i32* @__dfsan_retval_origin_tls, align 4
  
  %a = load i128, i128* %p
  ret i128 %a
}

define i17 @load17(i17* %p) {
  ; CHECK-LABEL: @"dfs$load17"

  ; COMBINE_LOAD_PTR-NEXT: %[[#PO:]] = load i32, i32* getelementptr inbounds ([200 x i32], [200 x i32]* @__dfsan_arg_origin_tls, i64 0, i64 0), align 4
  ; COMBINE_LOAD_PTR-NEXT: %[[#PS:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN]]

  ; CHECK-NEXT: %[[#INTP:]] = bitcast i17* %p to i8*
  ; CHECK-NEXT: %[[#LABEL_ORIGIN:]] = call zeroext i64 @__dfsan_load_label_and_origin(i8* %[[#INTP]], i64 3)
  ; CHECK-NEXT: %[[#LABEL_ORIGIN_H32:]] = lshr i64 %[[#LABEL_ORIGIN]], 32
  ; CHECK-NEXT: %[[#LABEL:]] = trunc i64 %[[#LABEL_ORIGIN_H32]] to i[[#SBITS]]
  ; CHECK-NEXT: %[[#ORIGIN:]] = trunc i64 %[[#LABEL_ORIGIN]] to i32

  ; COMBINE_LOAD_PTR-NEXT: %[[#LABEL:]] = or i[[#SBITS]] %[[#LABEL]], %[[#PS]]
  ; COMBINE_LOAD_PTR-NEXT: %[[#NZ:]] = icmp ne i[[#SBITS]] %[[#PS]], 0
  ; COMBINE_LOAD_PTR-NEXT: %[[#ORIGIN:]] = select i1 %[[#NZ]], i32 %[[#PO]], i32 %[[#ORIGIN]]

  ; CHECK-NEXT: %a = load i17, i17* %p, align 4
  ; CHECK-NEXT: store i[[#SBITS]] %[[#LABEL]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK-NEXT: store i32 %[[#ORIGIN]], i32* @__dfsan_retval_origin_tls, align 4

  %a = load i17, i17* %p, align 4
  ret i17 %a
}
