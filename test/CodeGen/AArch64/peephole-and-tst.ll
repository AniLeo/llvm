; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

%struct.anon = type { i32*, i32* }

@ptr_wrapper = common global %struct.anon* null, align 8

define i32 @test_func_i32_two_uses(i32 %in, i32 %bit, i32 %mask) {
; CHECK-LABEL: test_func_i32_two_uses:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adrp x9, :got:ptr_wrapper
; CHECK-NEXT:    mov w8, w0
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ldr x9, [x9, :got_lo12:ptr_wrapper]
; CHECK-NEXT:    ldr x9, [x9]
; CHECK-NEXT:    b .LBB0_3
; CHECK-NEXT:  .LBB0_1: // in Loop: Header=BB0_3 Depth=1
; CHECK-NEXT:    str xzr, [x9, #8]
; CHECK-NEXT:  .LBB0_2: // in Loop: Header=BB0_3 Depth=1
; CHECK-NEXT:    lsl w1, w1, #1
; CHECK-NEXT:    cbz w1, .LBB0_6
; CHECK-NEXT:  .LBB0_3: // %do.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ands w10, w1, w8
; CHECK-NEXT:    and w11, w2, w8
; CHECK-NEXT:    cinc w0, w0, ne
; CHECK-NEXT:    cmp w10, w11
; CHECK-NEXT:    b.eq .LBB0_1
; CHECK-NEXT:  // %bb.4: // %do.body
; CHECK-NEXT:    // in Loop: Header=BB0_3 Depth=1
; CHECK-NEXT:    cbnz w2, .LBB0_1
; CHECK-NEXT:  // %bb.5: // %do.body
; CHECK-NEXT:    // in Loop: Header=BB0_3 Depth=1
; CHECK-NEXT:    cbz w10, .LBB0_2
; CHECK-NEXT:    b .LBB0_1
; CHECK-NEXT:  .LBB0_6: // %do.end
; CHECK-NEXT:    ret
entry:
  %0 = load %struct.anon*, %struct.anon** @ptr_wrapper, align 8
  %result = getelementptr inbounds %struct.anon, %struct.anon* %0, i64 0, i32 1
  %tobool2 = icmp ne i32 %mask, 0
  br label %do.body

do.body:                                          ; preds = %4, %entry
  %bit.addr.0 = phi i32 [ %bit, %entry ], [ %shl, %4 ]
  %retval1.0 = phi i32 [ 0, %entry ], [ %retval1.1, %4 ]
  %and = and i32 %bit.addr.0, %in
  %tobool = icmp eq i32 %and, 0
  %not.tobool = xor i1 %tobool, true
  %inc = zext i1 %not.tobool to i32
  %retval1.1 = add nuw nsw i32 %retval1.0, %inc
  %1 = xor i1 %tobool, true
  %2 = or i1 %tobool2, %1
  %dummy = and i32 %mask, %in
  %use_and = icmp eq i32 %and, %dummy
  %dummy_or = or i1 %use_and, %2
  br i1 %dummy_or, label %3, label %4

3:                                                ; preds = %do.body
  store i32* null, i32** %result, align 8
  br label %4

4:                                                ; preds = %do.body, %3
  %shl = shl i32 %bit.addr.0, 1
  %tobool6 = icmp eq i32 %shl, 0
  br i1 %tobool6, label %do.end, label %do.body

do.end:                                           ; preds = %4
  ret i32 %retval1.1
}

define i32 @test_func_i64_one_use(i64 %in, i64 %bit, i64 %mask) {
; CHECK-LABEL: test_func_i64_one_use:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    adrp x9, :got:ptr_wrapper
; CHECK-NEXT:    mov x8, x0
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ldr x9, [x9, :got_lo12:ptr_wrapper]
; CHECK-NEXT:    ldr x9, [x9]
; CHECK-NEXT:    b .LBB1_2
; CHECK-NEXT:  .LBB1_1: // in Loop: Header=BB1_2 Depth=1
; CHECK-NEXT:    lsl x1, x1, #1
; CHECK-NEXT:    cbz x1, .LBB1_4
; CHECK-NEXT:  .LBB1_2: // %do.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ands x10, x1, x8
; CHECK-NEXT:    orr x10, x2, x10
; CHECK-NEXT:    cinc w0, w0, ne
; CHECK-NEXT:    cbz x10, .LBB1_1
; CHECK-NEXT:  // %bb.3: // in Loop: Header=BB1_2 Depth=1
; CHECK-NEXT:    str xzr, [x9, #8]
; CHECK-NEXT:    b .LBB1_1
; CHECK-NEXT:  .LBB1_4: // %do.end
; CHECK-NEXT:    ret
entry:
  %0 = load %struct.anon*, %struct.anon** @ptr_wrapper, align 8
  %result = getelementptr inbounds %struct.anon, %struct.anon* %0, i64 0, i32 1
  %tobool2 = icmp ne i64 %mask, 0
  br label %do.body

do.body:                                          ; preds = %4, %entry
  %bit.addr.0 = phi i64 [ %bit, %entry ], [ %shl, %4 ]
  %retval1.0 = phi i32 [ 0, %entry ], [ %retval1.1, %4 ]
  %and = and i64 %bit.addr.0, %in
  %tobool = icmp eq i64 %and, 0
  %not.tobool = xor i1 %tobool, true
  %inc = zext i1 %not.tobool to i32
  %retval1.1 = add nuw nsw i32 %retval1.0, %inc
  %1 = xor i1 %tobool, true
  %2 = or i1 %tobool2, %1
  br i1 %2, label %3, label %4

3:                                                ; preds = %do.body
  store i32* null, i32** %result, align 8
  br label %4

4:                                                ; preds = %do.body, %3
  %shl = shl i64 %bit.addr.0, 1
  %tobool6 = icmp eq i64 %shl, 0
  br i1 %tobool6, label %do.end, label %do.body

do.end:                                           ; preds = %4
  ret i32 %retval1.1
}

define i64 @test_and1(i64 %x, i64 %y) {
; CHECK-LABEL: test_and1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ands x8, x0, #0x3
; CHECK-NEXT:    csel x0, x8, x1, eq
; CHECK-NEXT:    ret
  %a = and i64 %x, 3
  %c = icmp eq i64 %a, 0
  %s = select i1 %c, i64 %a, i64 %y
  ret i64 %s
}

define i64 @test_and2(i64 %x, i64 %y) {
; CHECK-LABEL: test_and2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst x0, #0x3
; CHECK-NEXT:    csel x0, x0, x1, eq
; CHECK-NEXT:    ret
  %a = and i64 %x, 3
  %c = icmp eq i64 %a, 0
  %s = select i1 %c, i64 %x, i64 %y
  ret i64 %s
}

define i64 @test_and3(i64 %x, i64 %y) {
; CHECK-LABEL: test_and3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w20, -16
; CHECK-NEXT:    .cfi_offset w30, -32
; CHECK-NEXT:    mov x20, x0
; CHECK-NEXT:    mov x0, xzr
; CHECK-NEXT:    mov x19, x1
; CHECK-NEXT:    bl callee
; CHECK-NEXT:    ands x8, x20, #0x3
; CHECK-NEXT:    csel x0, x8, x19, eq
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %a = and i64 %x, 3
  %b = call i64 @callee(i64 0)
  %c = icmp eq i64 %a, 0
  %s = select i1 %c, i64 %a, i64 %y
  ret i64 %s
}

define i64 @test_and_4(i64 %x, i64 %y) {
; CHECK-LABEL: test_and_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    mov x19, x0
; CHECK-NEXT:    ands x0, x0, #0x3
; CHECK-NEXT:    bl callee
; CHECK-NEXT:    ands x8, x19, #0x3
; CHECK-NEXT:    csel x0, x8, x0, eq
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %a = and i64 %x, 3
  %b = call i64 @callee(i64 %a)
  %c = icmp eq i64 %a, 0
  %s = select i1 %c, i64 %a, i64 %b
  ret i64 %s
}

define i64 @test_add(i64 %x, i64 %y) {
; CHECK-LABEL: test_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    add x19, x0, #3
; CHECK-NEXT:    mov x0, xzr
; CHECK-NEXT:    bl callee
; CHECK-NEXT:    cmp x19, #0
; CHECK-NEXT:    csel x0, x19, x0, eq
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %a = add i64 %x, 3
  %b = call i64 @callee(i64 0)
  %c = icmp eq i64 %a, 0
  %s = select i1 %c, i64 %a, i64 %b
  ret i64 %s
}

declare i64 @callee(i64)
