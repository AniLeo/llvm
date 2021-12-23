; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -debugify-and-strip-all-safe -O3 < %s | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n32:64"
target triple = "arm64-unknown-unknown"

define i32 @foo1(i32 %b, i32 %c) nounwind readnone ssp {
; CHECK-LABEL: foo1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w1, #0
; CHECK-NEXT:    add w8, w1, w0
; CHECK-NEXT:    cinc w0, w8, ne
; CHECK-NEXT:    ret
entry:
  %not.tobool = icmp ne i32 %c, 0
  %add = zext i1 %not.tobool to i32
  %b.add = add i32 %c, %b
  %add1 = add i32 %b.add, %add
  ret i32 %add1
}

define i32 @foo2(i32 %b, i32 %c) nounwind readnone ssp {
; CHECK-LABEL: foo2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w1, #0
; CHECK-NEXT:    cneg w8, w0, ne
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
entry:
  %mul = sub i32 0, %b
  %tobool = icmp eq i32 %c, 0
  %b.mul = select i1 %tobool, i32 %b, i32 %mul
  %add = add nsw i32 %b.mul, %c
  ret i32 %add
}

define i32 @foo3(i32 %b, i32 %c) nounwind readnone ssp {
; CHECK-LABEL: foo3:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w1, #0
; CHECK-NEXT:    cinv w8, w0, ne
; CHECK-NEXT:    add w0, w8, w1
; CHECK-NEXT:    ret
entry:
  %not.tobool = icmp ne i32 %c, 0
  %xor = sext i1 %not.tobool to i32
  %b.xor = xor i32 %xor, %b
  %add = add nsw i32 %b.xor, %c
  ret i32 %add
}

; rdar://11632325
define i32@foo4(i32 %a) nounwind ssp {
; CHECK-LABEL: foo4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cneg w0, w0, mi
; CHECK-NEXT:    ret
  %cmp = icmp sgt i32 %a, -1
  %neg = sub nsw i32 0, %a
  %cond = select i1 %cmp, i32 %a, i32 %neg
  ret i32 %cond
}

define i32@foo5(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: foo5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    subs w8, w0, w1
; CHECK-NEXT:    cneg w0, w8, mi
; CHECK-NEXT:    ret
entry:
  %sub = sub nsw i32 %a, %b
  %cmp = icmp sgt i32 %sub, -1
  %sub3 = sub nsw i32 0, %sub
  %cond = select i1 %cmp, i32 %sub, i32 %sub3
  ret i32 %cond
}

; make sure we can handle branch instruction in optimizeCompare.
define i32@foo6(i32 %a, i32 %b) nounwind ssp {
; CHECK-LABEL: foo6:
; CHECK:       // %bb.0: // %common.ret
; CHECK-NEXT:    sub w8, w0, w1
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    csinc w0, w8, wzr, le
; CHECK-NEXT:    ret
  %sub = sub nsw i32 %a, %b
  %cmp = icmp sgt i32 %sub, 0
  br i1 %cmp, label %l.if, label %l.else

l.if:
  ret i32 1

l.else:
  ret i32 %sub
}

; If CPSR is used multiple times and V flag is used, we don't remove cmp.
define i32 @foo7(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: foo7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    subs w8, w0, w1
; CHECK-NEXT:    cneg w9, w8, mi
; CHECK-NEXT:    cmn w8, #1
; CHECK-NEXT:    csel w10, w9, w0, lt
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    csel w0, w10, w9, ge
; CHECK-NEXT:    ret
entry:
  %sub = sub nsw i32 %a, %b
  %cmp = icmp sgt i32 %sub, -1
  %sub3 = sub nsw i32 0, %sub
  %cond = select i1 %cmp, i32 %sub, i32 %sub3
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %cmp2 = icmp slt i32 %sub, -1
  %sel = select i1 %cmp2, i32 %cond, i32 %a
  ret i32 %sel

if.else:
  ret i32 %cond
}

define i32 @foo8(i32 %v, i32 %a, i32 %b) nounwind readnone ssp {
; CHECK-LABEL: foo8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csinv w0, w1, w2, ne
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i32 %v, 0
  %neg = xor i32 -1, %b
  %cond = select i1 %tobool, i32 %neg, i32 %a
  ret i32 %cond
}

define i32 @foo9(i32 %v) nounwind readnone optsize ssp {
; CHECK-LABEL: foo9:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cinv w0, w8, eq
; CHECK-NEXT:    ret
entry:
  %tobool = icmp ne i32 %v, 0
  %cond = select i1 %tobool, i32 4, i32 -5
  ret i32 %cond
}

define i64 @foo10(i64 %v) nounwind readnone optsize ssp {
; CHECK-LABEL: foo10:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    cmp x0, #0
; CHECK-NEXT:    cinv x0, x8, eq
; CHECK-NEXT:    ret
entry:
  %tobool = icmp ne i64 %v, 0
  %cond = select i1 %tobool, i64 4, i64 -5
  ret i64 %cond
}

define i32 @foo11(i32 %v) nounwind readnone optsize ssp {
; CHECK-LABEL: foo11:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cneg w0, w8, eq
; CHECK-NEXT:    ret
entry:
  %tobool = icmp ne i32 %v, 0
  %cond = select i1 %tobool, i32 4, i32 -4
  ret i32 %cond
}

define i64 @foo12(i64 %v) nounwind readnone optsize ssp {
; CHECK-LABEL: foo12:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    cmp x0, #0
; CHECK-NEXT:    cneg x0, x8, eq
; CHECK-NEXT:    ret
entry:
  %tobool = icmp ne i64 %v, 0
  %cond = select i1 %tobool, i64 4, i64 -4
  ret i64 %cond
}

define i32 @foo13(i32 %v, i32 %a, i32 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo13:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    csneg w0, w1, w2, ne
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i32 %v, 0
  %sub = sub i32 0, %b
  %cond = select i1 %tobool, i32 %sub, i32 %a
  ret i32 %cond
}

define i64 @foo14(i64 %v, i64 %a, i64 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo14:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp x0, #0
; CHECK-NEXT:    csneg x0, x1, x2, ne
; CHECK-NEXT:    ret
entry:
  %tobool = icmp eq i64 %v, 0
  %sub = sub i64 0, %b
  %cond = select i1 %tobool, i64 %sub, i64 %a
  ret i64 %cond
}

define i32 @foo15(i32 %a, i32 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo15:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cinc w0, w8, gt
; CHECK-NEXT:    ret
entry:
  %cmp = icmp sgt i32 %a, %b
  %. = select i1 %cmp, i32 2, i32 1
  ret i32 %.
}

define i32 @foo16(i32 %a, i32 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp w0, w1
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cinc w0, w8, le
; CHECK-NEXT:    ret
entry:
  %cmp = icmp sgt i32 %a, %b
  %. = select i1 %cmp, i32 1, i32 2
  ret i32 %.
}

define i64 @foo17(i64 %a, i64 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo17:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp x0, x1
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cinc x0, x8, gt
; CHECK-NEXT:    ret
entry:
  %cmp = icmp sgt i64 %a, %b
  %. = select i1 %cmp, i64 2, i64 1
  ret i64 %.
}

define i64 @foo18(i64 %a, i64 %b) nounwind readnone optsize ssp {
; CHECK-LABEL: foo18:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp x0, x1
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    cinc x0, x8, le
; CHECK-NEXT:    ret
entry:
  %cmp = icmp sgt i64 %a, %b
  %. = select i1 %cmp, i64 1, i64 2
  ret i64 %.
}

define i64 @foo19(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: foo19:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    cmp x0, x1
; CHECK-NEXT:    cinc x0, x2, lo
; CHECK-NEXT:    ret
entry:
  %cmp = icmp ult i64 %a, %b
  %inc = zext i1 %cmp to i64
  %inc.c = add i64 %inc, %c
  ret i64 %inc.c
}

define i32 @foo20(i32 %x) {
; CHECK-LABEL: foo20:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    cmp w0, #5
; CHECK-NEXT:    csinc w0, w8, wzr, eq
; CHECK-NEXT:    ret
  %cmp = icmp eq i32 %x, 5
  %res = select i1 %cmp, i32 6, i32 1
  ret i32 %res
}

define i64 @foo21(i64 %x) {
; CHECK-LABEL: foo21:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    cmp x0, #5
; CHECK-NEXT:    csinc x0, x8, xzr, eq
; CHECK-NEXT:    ret
  %cmp = icmp eq i64 %x, 5
  %res = select i1 %cmp, i64 6, i64 1
  ret i64 %res
}

define i32 @foo22(i32 %x) {
; CHECK-LABEL: foo22:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    cmp w0, #5
; CHECK-NEXT:    csinc w0, w8, wzr, ne
; CHECK-NEXT:    ret
  %cmp = icmp eq i32 %x, 5
  %res = select i1 %cmp, i32 1, i32 6
  ret i32 %res
}

define i64 @foo23(i64 %x) {
; CHECK-LABEL: foo23:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    cmp x0, #5
; CHECK-NEXT:    csinc x0, x8, xzr, ne
; CHECK-NEXT:    ret
  %cmp = icmp eq i64 %x, 5
  %res = select i1 %cmp, i64 1, i64 6
  ret i64 %res
}

define i16 @foo24(i8* nocapture readonly %A, i8* nocapture readonly %B) {
; CHECK-LABEL: foo24:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldrb w8, [x1]
; CHECK-NEXT:    ldrb w9, [x0]
; CHECK-NEXT:    cmp w8, #33
; CHECK-NEXT:    cset w8, hi
; CHECK-NEXT:    cmp w9, #3
; CHECK-NEXT:    cinc w0, w8, hi
; CHECK-NEXT:    ret
entry:
  %0 = load i8, i8* %A, align 1
  %cmp = icmp ugt i8 %0, 3
  %conv1 = zext i1 %cmp to i16
  %1 = load i8, i8* %B, align 1
  %cmp4 = icmp ugt i8 %1, 33
  %conv5 = zext i1 %cmp4 to i16
  %add = add nuw nsw i16 %conv5, %conv1
  ret i16 %add
}

define i64 @foo25(i64* nocapture readonly %A, i64* nocapture readonly %B) {
; CHECK-LABEL: foo25:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ldr x8, [x1]
; CHECK-NEXT:    ldr x9, [x0]
; CHECK-NEXT:    cmp x8, #33
; CHECK-NEXT:    cset w8, hi
; CHECK-NEXT:    cmp x9, #3
; CHECK-NEXT:    cinc x0, x8, hi
; CHECK-NEXT:    ret
entry:
  %0 = load i64, i64* %A, align 1
  %cmp = icmp ugt i64 %0, 3
  %conv1 = zext i1 %cmp to i64
  %1 = load i64, i64* %B, align 1
  %cmp4 = icmp ugt i64 %1, 33
  %conv5 = zext i1 %cmp4 to i64
  %add = add nuw nsw i64 %conv5, %conv1
  ret i64 %add
}

