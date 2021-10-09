; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-apple-darwin -aarch64-enable-collect-loh=false < %s  | FileCheck %s

@board = common global [400 x i8] zeroinitializer, align 1
@next_string = common global i32 0, align 4
@string_number = common global [400 x i32] zeroinitializer, align 4

; Function Attrs: nounwind ssp
define void @new_position(i32 %pos) {
; CHECK-LABEL: new_position:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    adrp x9, _board@GOTPAGE
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sxtw x8, w0
; CHECK-NEXT:    ldr x9, [x9, _board@GOTPAGEOFF]
; CHECK-NEXT:    ldrb w9, [x9, x8]
; CHECK-NEXT:    sub w9, w9, #1
; CHECK-NEXT:    cmp w9, #1
; CHECK-NEXT:    b.hi LBB0_2
; CHECK-NEXT:  ; %bb.1: ; %if.then
; CHECK-NEXT:    adrp x9, _next_string@GOTPAGE
; CHECK-NEXT:    adrp x10, _string_number@GOTPAGE
; CHECK-NEXT:    ldr x9, [x9, _next_string@GOTPAGEOFF]
; CHECK-NEXT:    ldr w9, [x9]
; CHECK-NEXT:    ldr x10, [x10, _string_number@GOTPAGEOFF]
; CHECK-NEXT:    str w9, [x10, x8, lsl #2]
; CHECK-NEXT:  LBB0_2: ; %if.end
; CHECK-NEXT:    ret
entry:
  %idxprom = sext i32 %pos to i64
  %arrayidx = getelementptr inbounds [400 x i8], [400 x i8]* @board, i64 0, i64 %idxprom
  %tmp = load i8, i8* %arrayidx, align 1
  %.off = add i8 %tmp, -1
  %switch = icmp ult i8 %.off, 2
  br i1 %switch, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %tmp1 = load i32, i32* @next_string, align 4
  %arrayidx8 = getelementptr inbounds [400 x i32], [400 x i32]* @string_number, i64 0, i64 %idxprom
  store i32 %tmp1, i32* %arrayidx8, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define zeroext i1 @test8_0(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_0:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    add w8, w0, #74
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    cmp w8, #236
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 74
  %1 = icmp ult i8 %0, -20
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_1(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub w8, w0, #10
; CHECK-NEXT:    cmp w8, #89
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 246
  %1 = icmp uge i8 %0, 90
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_2(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #208
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 227
  %1 = icmp ne i8 %0, 179
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_3(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #209
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 201
  %1 = icmp eq i8 %0, 154
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_4(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #39
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, -79
  %1 = icmp ne i8 %0, -40
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_5(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_5:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub w8, w0, #123
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    cmp w8, #150
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 133
  %1 = icmp uge i8 %0, -105
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_6(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_6:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub w8, w0, #58
; CHECK-NEXT:    cmp w8, #154
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, -58
  %1 = icmp uge i8 %0, 155
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test8_7(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_7:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub w8, w0, #31
; CHECK-NEXT:    cmp w8, #124
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 225
  %1 = icmp ult i8 %0, 124
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}



define zeroext i1 @test8_8(i8 zeroext %x)  align 2 {
; CHECK-LABEL: test8_8:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    cmp w0, #66
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i8 %x, 190
  %1 = icmp uge i8 %0, 1
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_0(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_0:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #5086
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, -46989
  %1 = icmp ne i16 %0, -41903
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_2(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #16882
; CHECK-NEXT:    mov w9, #40700
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    cmp w9, w8, uxth
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, 16882
  %1 = icmp ule i16 %0, -24837
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_3(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #53200
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, 29283
  %1 = icmp ne i16 %0, 16947
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_4(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #29985
; CHECK-NEXT:    mov w9, #15676
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    cmp w9, w8, uxth
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, -35551
  %1 = icmp uge i16 %0, 15677
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_5(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_5:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #23282
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, -25214
  %1 = icmp ne i16 %0, -1932
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_6(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_6:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #-32194
; CHECK-NEXT:    mov w9, #24320
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    cmp w8, w9
; CHECK-NEXT:    cset w0, hi
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, -32194
  %1 = icmp uge i16 %0, -41215
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_7(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_7:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #9272
; CHECK-NEXT:    mov w9, #22619
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    cmp w9, w8, uxth
; CHECK-NEXT:    cset w0, lo
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, 9272
  %1 = icmp uge i16 %0, -42916
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

define zeroext i1 @test16_8(i16 zeroext %x)  align 2 {
; CHECK-LABEL: test16_8:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    mov w8, #4919
; CHECK-NEXT:    cmp w0, w8
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
entry:
  %0 = add i16 %x, -63749
  %1 = icmp ne i16 %0, 6706
  br i1 %1, label %ret_true, label %ret_false
ret_false:
  ret i1 false
ret_true:
  ret i1 true
}

