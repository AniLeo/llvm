; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64-apple-ios -o - %s | FileCheck %s

define <16 x i32> @no_existing_zext(<16 x i8> %a, <16 x i32> %op) {
; CHECK-LABEL: no_existing_zext:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.16b v5, #10
; CHECK-NEXT:    cmhi.16b v0, v0, v5
; CHECK-NEXT:    sshll.8h v5, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    sshll.4s v6, v5, #0
; CHECK-NEXT:    sshll.4s v7, v0, #0
; CHECK-NEXT:    sshll2.4s v0, v0, #0
; CHECK-NEXT:    sshll2.4s v5, v5, #0
; CHECK-NEXT:    and.16b v4, v4, v0
; CHECK-NEXT:    and.16b v5, v2, v5
; CHECK-NEXT:    and.16b v2, v3, v7
; CHECK-NEXT:    and.16b v0, v1, v6
; CHECK-NEXT:    mov.16b v1, v5
; CHECK-NEXT:    mov.16b v3, v4
; CHECK-NEXT:    ret
entry:
  %cmp = icmp ugt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %op, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define <16 x i32> @second_compare_operand_not_splat(<16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: second_compare_operand_not_splat:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    ushll.8h v2, v0, #0
; CHECK-NEXT:    ushll2.8h v3, v0, #0
; CHECK-NEXT:    cmgt.16b v0, v0, v1
; CHECK-NEXT:    ushll.4s v4, v2, #0
; CHECK-NEXT:    ushll.4s v5, v3, #0
; CHECK-NEXT:    ushll2.4s v1, v2, #0
; CHECK-NEXT:    ushll2.4s v2, v3, #0
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    sshll.4s v6, v3, #0
; CHECK-NEXT:    sshll.4s v7, v0, #0
; CHECK-NEXT:    sshll2.4s v0, v0, #0
; CHECK-NEXT:    sshll2.4s v16, v3, #0
; CHECK-NEXT:    and.16b v3, v2, v0
; CHECK-NEXT:    and.16b v1, v1, v16
; CHECK-NEXT:    and.16b v2, v5, v7
; CHECK-NEXT:    and.16b v0, v4, v6
; CHECK-NEXT:    ret
entry:
  %ext = zext <16 x i8> %a to <16 x i32>
  %cmp = icmp sgt <16 x i8> %a, %b
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define <16 x i32> @same_zext_used_in_cmp_signed_pred_and_select(<16 x i8> %a) {
; CHECK-LABEL: same_zext_used_in_cmp_signed_pred_and_select:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.16b v1, #10
; CHECK-NEXT:    ushll.8h v2, v0, #0
; CHECK-NEXT:    ushll2.8h v3, v0, #0
; CHECK-NEXT:    ushll.4s v4, v2, #0
; CHECK-NEXT:    cmgt.16b v0, v0, v1
; CHECK-NEXT:    ushll.4s v5, v3, #0
; CHECK-NEXT:    ushll2.4s v1, v3, #0
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    ushll2.4s v2, v2, #0
; CHECK-NEXT:    sshll.4s v6, v3, #0
; CHECK-NEXT:    sshll.4s v7, v0, #0
; CHECK-NEXT:    sshll2.4s v0, v0, #0
; CHECK-NEXT:    sshll2.4s v16, v3, #0
; CHECK-NEXT:    and.16b v3, v1, v0
; CHECK-NEXT:    and.16b v1, v2, v16
; CHECK-NEXT:    and.16b v2, v5, v7
; CHECK-NEXT:    and.16b v0, v4, v6
; CHECK-NEXT:    ret
entry:
  %ext = zext <16 x i8> %a to <16 x i32>
  %cmp = icmp sgt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define <16 x i32> @same_zext_used_in_cmp_unsigned_pred_and_select(<16 x i8> %a) {
; CHECK-LABEL: same_zext_used_in_cmp_unsigned_pred_and_select:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.16b v1, #10
; CHECK-NEXT:    ushll.8h v2, v0, #0
; CHECK-NEXT:    ushll2.8h v3, v0, #0
; CHECK-NEXT:    ushll.4s v4, v2, #0
; CHECK-NEXT:    cmhi.16b v0, v0, v1
; CHECK-NEXT:    ushll.4s v5, v3, #0
; CHECK-NEXT:    ushll2.4s v1, v3, #0
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    ushll2.4s v2, v2, #0
; CHECK-NEXT:    sshll.4s v6, v3, #0
; CHECK-NEXT:    sshll.4s v7, v0, #0
; CHECK-NEXT:    sshll2.4s v0, v0, #0
; CHECK-NEXT:    sshll2.4s v16, v3, #0
; CHECK-NEXT:    and.16b v3, v1, v0
; CHECK-NEXT:    and.16b v1, v2, v16
; CHECK-NEXT:    and.16b v2, v5, v7
; CHECK-NEXT:    and.16b v0, v4, v6
; CHECK-NEXT:    ret
entry:
  %ext = zext <16 x i8> %a to <16 x i32>
  %cmp = icmp ugt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

; A variation of @same_zext_used_in_cmp_unsigned_pred_and_select, with with
; multiple users of the compare.
define <16 x i32> @same_zext_used_in_cmp_unsigned_pred_and_select_other_use(<16 x i8> %a, <16 x i64> %v, <16 x i64>* %ptr) {
; CHECK-LABEL: same_zext_used_in_cmp_unsigned_pred_and_select_other_use:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov.16b v16, v2
; CHECK-NEXT:    movi.16b v2, #10
; CHECK-NEXT:    ushll.8h v18, v0, #0
; CHECK-NEXT:    ushll2.8h v20, v0, #0
; CHECK-NEXT:    mov.16b v17, v1
; CHECK-NEXT:    ldr q1, [sp]
; CHECK-NEXT:    cmhi.16b v0, v0, v2
; CHECK-NEXT:    ushll.4s v19, v18, #0
; CHECK-NEXT:    sshll2.8h v21, v0, #0
; CHECK-NEXT:    sshll.8h v0, v0, #0
; CHECK-NEXT:    sshll2.4s v22, v21, #0
; CHECK-NEXT:    sshll.4s v21, v21, #0
; CHECK-NEXT:    sshll2.2d v23, v22, #0
; CHECK-NEXT:    sshll.2d v24, v22, #0
; CHECK-NEXT:    sshll2.4s v25, v0, #0
; CHECK-NEXT:    sshll2.2d v26, v21, #0
; CHECK-NEXT:    sshll.2d v28, v21, #0
; CHECK-NEXT:    sshll2.2d v27, v25, #0
; CHECK-NEXT:    sshll.4s v0, v0, #0
; CHECK-NEXT:    and.16b v1, v1, v23
; CHECK-NEXT:    and.16b v7, v7, v24
; CHECK-NEXT:    sshll.2d v29, v25, #0
; CHECK-NEXT:    stp q7, q1, [x0, #96]
; CHECK-NEXT:    and.16b v1, v6, v26
; CHECK-NEXT:    and.16b v5, v5, v28
; CHECK-NEXT:    ushll.4s v2, v20, #0
; CHECK-NEXT:    stp q5, q1, [x0, #64]
; CHECK-NEXT:    ushll2.4s v18, v18, #0
; CHECK-NEXT:    ushll2.4s v20, v20, #0
; CHECK-NEXT:    and.16b v1, v4, v27
; CHECK-NEXT:    sshll2.2d v4, v0, #0
; CHECK-NEXT:    sshll.2d v5, v0, #0
; CHECK-NEXT:    and.16b v3, v3, v29
; CHECK-NEXT:    stp q3, q1, [x0, #32]
; CHECK-NEXT:    and.16b v3, v20, v22
; CHECK-NEXT:    and.16b v1, v18, v25
; CHECK-NEXT:    and.16b v2, v2, v21
; CHECK-NEXT:    and.16b v0, v19, v0
; CHECK-NEXT:    and.16b v4, v16, v4
; CHECK-NEXT:    and.16b v5, v17, v5
; CHECK-NEXT:    stp q5, q4, [x0]
; CHECK-NEXT:    ret
entry:
  %ext = zext <16 x i8> %a to <16 x i32>
  %cmp = icmp ugt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  %sel.2 = select <16 x i1> %cmp, <16 x i64> %v, <16 x i64> zeroinitializer
  store <16 x i64> %sel.2, <16 x i64>* %ptr
  ret <16 x i32> %sel
}

define <16 x i32> @same_sext_used_in_cmp_signed_pred_and_select(<16 x i8> %a) {
; CHECK-LABEL: same_sext_used_in_cmp_signed_pred_and_select:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.16b v1, #10
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v2, v0, #0
; CHECK-NEXT:    cmgt.16b v0, v0, v1
; CHECK-NEXT:    ext.16b v1, v3, v3, #8
; CHECK-NEXT:    sshll.8h v5, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    ext.16b v4, v2, v2, #8
; CHECK-NEXT:    ext.16b v6, v5, v5, #8
; CHECK-NEXT:    ext.16b v7, v0, v0, #8
; CHECK-NEXT:    and.8b v0, v2, v0
; CHECK-NEXT:    sshll.4s v2, v0, #0
; CHECK-NEXT:    and.8b v0, v3, v5
; CHECK-NEXT:    and.8b v1, v1, v6
; CHECK-NEXT:    and.8b v3, v4, v7
; CHECK-NEXT:    sshll.4s v0, v0, #0
; CHECK-NEXT:    sshll.4s v1, v1, #0
; CHECK-NEXT:    sshll.4s v3, v3, #0
; CHECK-NEXT:    ret
entry:
  %ext = sext <16 x i8> %a to <16 x i32>
  %cmp = icmp sgt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define <16 x i32> @same_sext_used_in_cmp_unsigned_pred_and_select(<16 x i8> %a) {
; CHECK-LABEL: same_sext_used_in_cmp_unsigned_pred_and_select:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.16b v1, #10
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v2, v0, #0
; CHECK-NEXT:    cmhi.16b v0, v0, v1
; CHECK-NEXT:    ext.16b v1, v3, v3, #8
; CHECK-NEXT:    sshll.8h v5, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    ext.16b v4, v2, v2, #8
; CHECK-NEXT:    ext.16b v6, v5, v5, #8
; CHECK-NEXT:    ext.16b v7, v0, v0, #8
; CHECK-NEXT:    and.8b v0, v2, v0
; CHECK-NEXT:    sshll.4s v2, v0, #0
; CHECK-NEXT:    and.8b v0, v3, v5
; CHECK-NEXT:    and.8b v1, v1, v6
; CHECK-NEXT:    and.8b v3, v4, v7
; CHECK-NEXT:    sshll.4s v0, v0, #0
; CHECK-NEXT:    sshll.4s v1, v1, #0
; CHECK-NEXT:    sshll.4s v3, v3, #0
; CHECK-NEXT:    ret
entry:
  %ext = sext <16 x i8> %a to <16 x i32>
  %cmp = icmp ugt <16 x i8> %a, <i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10, i8 10>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define <16 x i32> @same_zext_used_in_cmp_signed_pred_and_select_can_convert_to_unsigned_pred(<16 x i8> %a) {
; CHECK-LABEL: same_zext_used_in_cmp_signed_pred_and_select_can_convert_to_unsigned_pred:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.2d v1, #0xffffffffffffffff
; CHECK-NEXT:    ushll.8h v2, v0, #0
; CHECK-NEXT:    ushll2.8h v3, v0, #0
; CHECK-NEXT:    ushll.4s v4, v2, #0
; CHECK-NEXT:    cmgt.16b v0, v0, v1
; CHECK-NEXT:    ushll.4s v5, v3, #0
; CHECK-NEXT:    ushll2.4s v1, v3, #0
; CHECK-NEXT:    sshll.8h v3, v0, #0
; CHECK-NEXT:    sshll2.8h v0, v0, #0
; CHECK-NEXT:    ushll2.4s v2, v2, #0
; CHECK-NEXT:    sshll.4s v6, v3, #0
; CHECK-NEXT:    sshll.4s v7, v0, #0
; CHECK-NEXT:    sshll2.4s v0, v0, #0
; CHECK-NEXT:    sshll2.4s v16, v3, #0
; CHECK-NEXT:    and.16b v3, v1, v0
; CHECK-NEXT:    and.16b v1, v2, v16
; CHECK-NEXT:    and.16b v2, v5, v7
; CHECK-NEXT:    and.16b v0, v4, v6
; CHECK-NEXT:    ret
entry:
  %ext = zext <16 x i8> %a to <16 x i32>
  %cmp = icmp sgt <16 x i8> %a,  <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  ret <16 x i32> %sel
}

define void @extension_in_loop_v16i8_to_v16i32(i8* %src, i32* %dst) {
; CHECK-LABEL: extension_in_loop_v16i8_to_v16i32:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    movi.2d v0, #0xffffffffffffffff
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:  LBB8_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr q1, [x0, x8]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    cmp x8, #128
; CHECK-NEXT:    cmgt.16b v2, v1, v0
; CHECK-NEXT:    ushll2.8h v3, v1, #0
; CHECK-NEXT:    sshll2.8h v4, v2, #0
; CHECK-NEXT:    ushll2.4s v5, v3, #0
; CHECK-NEXT:    ushll.4s v3, v3, #0
; CHECK-NEXT:    sshll2.4s v6, v4, #0
; CHECK-NEXT:    sshll.4s v4, v4, #0
; CHECK-NEXT:    ushll.8h v1, v1, #0
; CHECK-NEXT:    sshll.8h v2, v2, #0
; CHECK-NEXT:    and.16b v5, v5, v6
; CHECK-NEXT:    and.16b v3, v3, v4
; CHECK-NEXT:    stp q3, q5, [x1, #32]
; CHECK-NEXT:    sshll2.4s v4, v2, #0
; CHECK-NEXT:    sshll.4s v2, v2, #0
; CHECK-NEXT:    ushll2.4s v3, v1, #0
; CHECK-NEXT:    ushll.4s v1, v1, #0
; CHECK-NEXT:    and.16b v3, v3, v4
; CHECK-NEXT:    and.16b v1, v1, v2
; CHECK-NEXT:    stp q1, q3, [x1], #64
; CHECK-NEXT:    b.ne LBB8_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %src.gep = getelementptr i8, i8* %src, i64 %iv
  %src.gep.cast = bitcast i8* %src.gep to <16 x i8>*
  %load = load <16 x i8>, <16 x i8>* %src.gep.cast
  %cmp = icmp sgt <16 x i8> %load,  <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %ext = zext <16 x i8> %load to <16 x i32>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  %dst.gep = getelementptr i32, i32* %dst, i64 %iv
  %dst.gep.cast = bitcast i32* %dst.gep to <16 x i32>*
  store <16 x i32> %sel, <16 x i32>* %dst.gep.cast
  %iv.next = add nuw i64 %iv, 16
  %ec = icmp eq i64 %iv.next, 128
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}

define void @extension_in_loop_as_shuffle_v16i8_to_v16i32(i8* %src, i32* %dst) {
; CHECK-LABEL: extension_in_loop_as_shuffle_v16i8_to_v16i32:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh0:
; CHECK-NEXT:    adrp x9, lCPI9_0@PAGE
; CHECK-NEXT:  Lloh1:
; CHECK-NEXT:    adrp x10, lCPI9_1@PAGE
; CHECK-NEXT:  Lloh2:
; CHECK-NEXT:    adrp x11, lCPI9_2@PAGE
; CHECK-NEXT:  Lloh3:
; CHECK-NEXT:    adrp x12, lCPI9_3@PAGE
; CHECK-NEXT:    movi.2d v1, #0xffffffffffffffff
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    movi.2d v3, #0000000000000000
; CHECK-NEXT:  Lloh4:
; CHECK-NEXT:    ldr q0, [x9, lCPI9_0@PAGEOFF]
; CHECK-NEXT:  Lloh5:
; CHECK-NEXT:    ldr q2, [x10, lCPI9_1@PAGEOFF]
; CHECK-NEXT:  Lloh6:
; CHECK-NEXT:    ldr q5, [x11, lCPI9_2@PAGEOFF]
; CHECK-NEXT:  Lloh7:
; CHECK-NEXT:    ldr q6, [x12, lCPI9_3@PAGEOFF]
; CHECK-NEXT:  LBB9_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr q4, [x0, x8]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    cmp x8, #128
; CHECK-NEXT:    cmgt.16b v7, v4, v1
; CHECK-NEXT:    tbl.16b v16, { v3, v4 }, v0
; CHECK-NEXT:    tbl.16b v17, { v3, v4 }, v2
; CHECK-NEXT:    sshll2.8h v20, v7, #0
; CHECK-NEXT:    tbl.16b v18, { v3, v4 }, v5
; CHECK-NEXT:    sshll2.4s v21, v20, #0
; CHECK-NEXT:    sshll.4s v20, v20, #0
; CHECK-NEXT:    tbl.16b v19, { v3, v4 }, v6
; CHECK-NEXT:    sshll.8h v7, v7, #0
; CHECK-NEXT:    and.16b v16, v16, v21
; CHECK-NEXT:    and.16b v17, v17, v20
; CHECK-NEXT:    stp q17, q16, [x1, #32]
; CHECK-NEXT:    sshll2.4s v16, v7, #0
; CHECK-NEXT:    sshll.4s v7, v7, #0
; CHECK-NEXT:    and.16b v16, v18, v16
; CHECK-NEXT:    and.16b v7, v19, v7
; CHECK-NEXT:    stp q7, q16, [x1], #64
; CHECK-NEXT:    b.ne LBB9_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh3, Lloh7
; CHECK-NEXT:    .loh AdrpLdr Lloh2, Lloh6
; CHECK-NEXT:    .loh AdrpLdr Lloh1, Lloh5
; CHECK-NEXT:    .loh AdrpLdr Lloh0, Lloh4
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %src.gep = getelementptr i8, i8* %src, i64 %iv
  %src.gep.cast = bitcast i8* %src.gep to <16 x i8>*
  %load = load <16 x i8>, <16 x i8>* %src.gep.cast
  %cmp = icmp sgt <16 x i8> %load,  <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %ext.shuf = shufflevector <16 x i8> %load, <16 x i8> zeroinitializer, <64 x i32> <i32 16, i32 16, i32 16, i32 0, i32 16, i32 16, i32 16, i32 1, i32 16, i32 16, i32 16, i32 2, i32 16, i32 16, i32 16, i32 3, i32 16, i32 16, i32 16, i32 4, i32 16, i32 16, i32 16, i32 5, i32 16, i32 16, i32 16, i32 6, i32 16, i32 16, i32 16, i32 7, i32 16, i32 16, i32 16, i32 8, i32 16, i32 16, i32 16, i32 9, i32 16, i32 16, i32 16, i32 10, i32 16, i32 16, i32 16, i32 11, i32 16, i32 16, i32 16, i32 12, i32 16, i32 16, i32 16, i32 13, i32 16, i32 16, i32 16, i32 14, i32 16, i32 16, i32 16, i32 15>
  %ext = bitcast <64 x i8> %ext.shuf to <16 x i32>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  %dst.gep = getelementptr i32, i32* %dst, i64 %iv
  %dst.gep.cast = bitcast i32* %dst.gep to <16 x i32>*
  store <16 x i32> %sel, <16 x i32>* %dst.gep.cast
  %iv.next = add nuw i64 %iv, 16
  %ec = icmp eq i64 %iv.next, 128
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}

define void @shuffle_in_loop_is_no_extend_v16i8_to_v16i32(i8* %src, i32* %dst) {
; CHECK-LABEL: shuffle_in_loop_is_no_extend_v16i8_to_v16i32:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:  Lloh8:
; CHECK-NEXT:    adrp x9, lCPI10_0@PAGE
; CHECK-NEXT:  Lloh9:
; CHECK-NEXT:    adrp x10, lCPI10_1@PAGE
; CHECK-NEXT:  Lloh10:
; CHECK-NEXT:    adrp x11, lCPI10_2@PAGE
; CHECK-NEXT:  Lloh11:
; CHECK-NEXT:    adrp x12, lCPI10_3@PAGE
; CHECK-NEXT:    movi.2d v2, #0000000000000000
; CHECK-NEXT:    mov x8, xzr
; CHECK-NEXT:    movi.2d v5, #0xffffffffffffffff
; CHECK-NEXT:  Lloh12:
; CHECK-NEXT:    ldr q0, [x9, lCPI10_0@PAGEOFF]
; CHECK-NEXT:  Lloh13:
; CHECK-NEXT:    ldr q4, [x10, lCPI10_1@PAGEOFF]
; CHECK-NEXT:  Lloh14:
; CHECK-NEXT:    ldr q6, [x11, lCPI10_2@PAGEOFF]
; CHECK-NEXT:  Lloh15:
; CHECK-NEXT:    ldr q7, [x12, lCPI10_3@PAGEOFF]
; CHECK-NEXT:  LBB10_1: ; %loop
; CHECK-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldr q1, [x0, x8]
; CHECK-NEXT:    add x8, x8, #16
; CHECK-NEXT:    cmp x8, #128
; CHECK-NEXT:    cmgt.16b v16, v1, v5
; CHECK-NEXT:    mov.16b v3, v1
; CHECK-NEXT:    sshll2.8h v17, v16, #0
; CHECK-NEXT:    tbl.16b v18, { v2, v3 }, v0
; CHECK-NEXT:    tbl.16b v19, { v2, v3 }, v4
; CHECK-NEXT:    sshll.8h v16, v16, #0
; CHECK-NEXT:    tbl.16b v20, { v2, v3 }, v6
; CHECK-NEXT:    tbl.16b v21, { v1, v2 }, v7
; CHECK-NEXT:    sshll2.4s v22, v17, #0
; CHECK-NEXT:    sshll.4s v17, v17, #0
; CHECK-NEXT:    sshll2.4s v23, v16, #0
; CHECK-NEXT:    sshll.4s v16, v16, #0
; CHECK-NEXT:    and.16b v18, v18, v22
; CHECK-NEXT:    and.16b v17, v19, v17
; CHECK-NEXT:    stp q17, q18, [x1, #32]
; CHECK-NEXT:    and.16b v17, v20, v23
; CHECK-NEXT:    and.16b v16, v21, v16
; CHECK-NEXT:    stp q16, q17, [x1], #64
; CHECK-NEXT:    b.ne LBB10_1
; CHECK-NEXT:  ; %bb.2: ; %exit
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpLdr Lloh11, Lloh15
; CHECK-NEXT:    .loh AdrpLdr Lloh10, Lloh14
; CHECK-NEXT:    .loh AdrpLdr Lloh9, Lloh13
; CHECK-NEXT:    .loh AdrpLdr Lloh8, Lloh12
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %src.gep = getelementptr i8, i8* %src, i64 %iv
  %src.gep.cast = bitcast i8* %src.gep to <16 x i8>*
  %load = load <16 x i8>, <16 x i8>* %src.gep.cast
  %cmp = icmp sgt <16 x i8> %load,  <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %ext.shuf = shufflevector <16 x i8> %load, <16 x i8> zeroinitializer, <64 x i32> <i32 1, i32 16, i32 16, i32 0, i32 16, i32 16, i32 16, i32 1, i32 16, i32 16, i32 16, i32 2, i32 16, i32 16, i32 16, i32 3, i32 16, i32 16, i32 16, i32 4, i32 16, i32 16, i32 16, i32 5, i32 16, i32 16, i32 16, i32 6, i32 16, i32 16, i32 16, i32 7, i32 16, i32 16, i32 16, i32 8, i32 16, i32 16, i32 16, i32 9, i32 16, i32 16, i32 16, i32 10, i32 16, i32 16, i32 16, i32 11, i32 16, i32 16, i32 16, i32 12, i32 16, i32 16, i32 16, i32 13, i32 16, i32 16, i32 16, i32 14, i32 16, i32 16, i32 16, i32 15>
  %ext = bitcast <64 x i8> %ext.shuf to <16 x i32>
  %sel = select <16 x i1> %cmp, <16 x i32> %ext, <16 x i32> zeroinitializer
  %dst.gep = getelementptr i32, i32* %dst, i64 %iv
  %dst.gep.cast = bitcast i32* %dst.gep to <16 x i32>*
  store <16 x i32> %sel, <16 x i32>* %dst.gep.cast
  %iv.next = add nuw i64 %iv, 16
  %ec = icmp eq i64 %iv.next, 128
  br i1 %ec, label %exit, label %loop

exit:
  ret void
}
