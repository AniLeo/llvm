; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -verify-machineinstrs -o - %s | FileCheck %s

%struct_type = type { [10000 x i32], i32, i32 }

define void @test1(%struct_type** %s, i32 %n) {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr x9, [x0]
; CHECK-NEXT:    mov w10, #40000
; CHECK-NEXT:    mov w8, wzr
; CHECK-NEXT:    add x9, x9, x10
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.ge .LBB0_2
; CHECK-NEXT:  .LBB0_1: // %while_body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add w10, w8, #1
; CHECK-NEXT:    stp w10, w8, [x9]
; CHECK-NEXT:    mov w8, w10
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.lt .LBB0_1
; CHECK-NEXT:  .LBB0_2: // %while_end
; CHECK-NEXT:    ret
entry:
  %struct = load %struct_type*, %struct_type** %s
  br label %while_cond

while_cond:
  %phi = phi i32 [ 0, %entry ], [ %i, %while_body ]
  %gep0 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 1
  %gep1 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 2
  %cmp = icmp slt i32 %phi, %n
  br i1 %cmp, label %while_body, label %while_end

while_body:
  %i = add i32 %phi, 1
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  br label %while_cond

while_end:
  ret void
}

define void @test2(%struct_type* %struct, i32 %n) {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cbz x0, .LBB1_3
; CHECK-NEXT:  // %bb.1: // %while_cond.preheader
; CHECK-NEXT:    mov w9, #40000
; CHECK-NEXT:    mov w8, wzr
; CHECK-NEXT:    add x9, x0, x9
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.ge .LBB1_3
; CHECK-NEXT:  .LBB1_2: // %while_body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add w10, w8, #1
; CHECK-NEXT:    stp w10, w8, [x9]
; CHECK-NEXT:    mov w8, w10
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.lt .LBB1_2
; CHECK-NEXT:  .LBB1_3: // %while_end
; CHECK-NEXT:    ret
entry:
  %cmp = icmp eq %struct_type* %struct, null
  br i1 %cmp, label %while_end, label %while_cond

while_cond:
  %phi = phi i32 [ 0, %entry ], [ %i, %while_body ]
  %gep0 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 1
  %gep1 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 2
  %cmp1 = icmp slt i32 %phi, %n
  br i1 %cmp1, label %while_body, label %while_end

while_body:
  %i = add i32 %phi, 1
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  br label %while_cond

while_end:
  ret void
}

define void @test3(%struct_type* %s1, %struct_type* %s2, i1 %cond, i32 %n) {
; CHECK-LABEL: test3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    tst w2, #0x1
; CHECK-NEXT:    csel x9, x1, x0, ne
; CHECK-NEXT:    cbz x9, .LBB2_3
; CHECK-NEXT:  // %bb.1: // %while_cond.preheader
; CHECK-NEXT:    mov w10, #40000
; CHECK-NEXT:    mov w8, wzr
; CHECK-NEXT:    add x9, x9, x10
; CHECK-NEXT:    cmp w8, w3
; CHECK-NEXT:    b.ge .LBB2_3
; CHECK-NEXT:  .LBB2_2: // %while_body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add w10, w8, #1
; CHECK-NEXT:    stp w10, w8, [x9]
; CHECK-NEXT:    mov w8, w10
; CHECK-NEXT:    cmp w8, w3
; CHECK-NEXT:    b.lt .LBB2_2
; CHECK-NEXT:  .LBB2_3: // %while_end
; CHECK-NEXT:    ret
entry:
  br i1 %cond, label %if_true, label %if_end

if_true:
  br label %if_end

if_end:
  %struct = phi %struct_type* [ %s1, %entry ], [ %s2, %if_true ]
  %cmp = icmp eq %struct_type* %struct, null
  br i1 %cmp, label %while_end, label %while_cond

while_cond:
  %phi = phi i32 [ 0, %if_end ], [ %i, %while_body ]
  %gep0 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 1
  %gep1 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 2
  %cmp1 = icmp slt i32 %phi, %n
  br i1 %cmp1, label %while_body, label %while_end

while_body:
  %i = add i32 %phi, 1
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  br label %while_cond

while_end:
  ret void
}

declare %struct_type* @foo()
declare void @foo2()

define void @test4(i32 %n) personality i32 (...)* @__FrameHandler {
; CHECK-LABEL: test4:
; CHECK:       .Lfunc_begin0:
; CHECK-NEXT:    .cfi_startproc
; CHECK-NEXT:    .cfi_personality 0, __FrameHandler
; CHECK-NEXT:    .cfi_lsda 0, .Lexception0
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    stp x30, x21, [sp, #-32]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w20, -16
; CHECK-NEXT:    .cfi_offset w21, -24
; CHECK-NEXT:    .cfi_offset w30, -32
; CHECK-NEXT:    mov w19, w0
; CHECK-NEXT:    mov w20, wzr
; CHECK-NEXT:    mov w21, #40000
; CHECK-NEXT:  .LBB3_1: // %while_cond
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    bl foo
; CHECK-NEXT:  .Ltmp1:
; CHECK-NEXT:  // %bb.2: // %while_cond_x.split
; CHECK-NEXT:    // in Loop: Header=BB3_1 Depth=1
; CHECK-NEXT:    add x8, x0, x21
; CHECK-NEXT:    cmp w20, w19
; CHECK-NEXT:    str wzr, [x8]
; CHECK-NEXT:    b.ge .LBB3_4
; CHECK-NEXT:  // %bb.3: // %while_body
; CHECK-NEXT:    // in Loop: Header=BB3_1 Depth=1
; CHECK-NEXT:    add w9, w20, #1
; CHECK-NEXT:    stp w9, w20, [x8]
; CHECK-NEXT:    mov w20, w9
; CHECK-NEXT:    b .LBB3_1
; CHECK-NEXT:  .LBB3_4: // %while_end
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldp x30, x21, [sp], #32 // 16-byte Folded Reload
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB3_5: // %cleanup
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    mov x19, x0
; CHECK-NEXT:    bl foo2
; CHECK-NEXT:    mov x0, x19
; CHECK-NEXT:    bl _Unwind_Resume
entry:
  br label %while_cond

while_cond:
  %phi = phi i32 [ 0, %entry ], [ %i, %while_body ]
  %struct = invoke %struct_type* @foo() to label %while_cond_x unwind label %cleanup

while_cond_x:
  %gep0 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 1
  %gep1 = getelementptr %struct_type, %struct_type* %struct, i64 0, i32 2
  store i32 0, i32* %gep0
  %cmp = icmp slt i32 %phi, %n
  br i1 %cmp, label %while_body, label %while_end

while_body:
  %i = add i32 %phi, 1
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  br label %while_cond

while_end:
  ret void

cleanup:
  %x10 = landingpad { i8*, i32 }
          cleanup
  call void @foo2()
  resume { i8*, i32 } %x10
}

declare i32 @__FrameHandler(...)

define void @test5([65536 x i32]** %s, i32 %n) {
; CHECK-LABEL: test5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr x9, [x0]
; CHECK-NEXT:    mov w8, wzr
; CHECK-NEXT:    add x9, x9, #19, lsl #12 // =77824
; CHECK-NEXT:    add x9, x9, #2176
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.ge .LBB4_2
; CHECK-NEXT:  .LBB4_1: // %while_body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    add w10, w8, #1
; CHECK-NEXT:    stp w10, w8, [x9]
; CHECK-NEXT:    mov w8, w10
; CHECK-NEXT:    cmp w8, w1
; CHECK-NEXT:    b.lt .LBB4_1
; CHECK-NEXT:  .LBB4_2: // %while_end
; CHECK-NEXT:    ret
entry:
  %struct = load [65536 x i32]*, [65536 x i32]** %s
  br label %while_cond

while_cond:
  %phi = phi i32 [ 0, %entry ], [ %i, %while_body ]
  %gep0 = getelementptr [65536 x i32], [65536 x i32]* %struct, i64 0, i32 20000
  %gep1 = getelementptr [65536 x i32], [65536 x i32]* %struct, i64 0, i32 20001
  %cmp = icmp slt i32 %phi, %n
  br i1 %cmp, label %while_body, label %while_end

while_body:
  %i = add i32 %phi, 1
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  br label %while_cond

while_end:
  ret void
}

declare i8* @llvm.strip.invariant.group.p0i8(i8*)

define void @test_invariant_group(i32) {
; CHECK-LABEL: test_invariant_group:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cbz wzr, .LBB5_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    cbz w0, .LBB5_3
; CHECK-NEXT:  .LBB5_2:
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB5_3:
; CHECK-NEXT:    cbnz wzr, .LBB5_2
; CHECK-NEXT:  // %bb.4:
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    str x8, [x8]
; CHECK-NEXT:    ret
  br i1 undef, label %8, label %7

; <label>:2:                                      ; preds = %8, %2
  br i1 undef, label %2, label %7

; <label>:3:                                      ; preds = %8
  %4 = getelementptr inbounds i8, i8* %9, i32 40000
  %5 = bitcast i8* %4 to i64*
  br i1 undef, label %7, label %6

; <label>:6:                                      ; preds = %3
  store i64 1, i64* %5, align 8
  br label %7

; <label>:7:                                      ; preds = %6, %3, %2, %1
  ret void

; <label>:8:                                      ; preds = %1
  %9 = call i8* @llvm.strip.invariant.group.p0i8(i8* nonnull undef)
  %10 = icmp eq i32 %0, 0
  br i1 %10, label %3, label %2
}

