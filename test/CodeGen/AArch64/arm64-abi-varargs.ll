; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-apple-ios7.0.0 -mcpu=cyclone -enable-misched=false | FileCheck %s

; rdar://13625505
; Here we have 9 fixed integer arguments the 9th argument in on stack, the
; varargs start right after at 8-byte alignment.
define void @fn9(i32* %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, i32 %a8, i32 %a9, ...) nounwind noinline ssp {
; CHECK-LABEL: fn9:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #64 ; =64
; CHECK-NEXT:    ldr w8, [sp, #64]
; CHECK-NEXT:    stp w2, w1, [sp, #52]
; CHECK-NEXT:    stp w4, w3, [sp, #44]
; CHECK-NEXT:    stp w6, w5, [sp, #36]
; CHECK-NEXT:    str w7, [sp, #32]
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    ldr w9, [sp, #72]
; CHECK-NEXT:    ldr w8, [sp, #80]
; CHECK-NEXT:    stp w8, w9, [sp, #16]
; CHECK-NEXT:    add x8, sp, #72 ; =72
; CHECK-NEXT:    add x8, x8, #24 ; =24
; CHECK-NEXT:    str x8, [sp, #24]
; CHECK-NEXT:    ldr w8, [sp, #88]
; CHECK-NEXT:    str w8, [sp, #12]
; CHECK-NEXT:    add sp, sp, #64 ; =64
; CHECK-NEXT:    ret
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %args = alloca i8*, align 8
  %a10 = alloca i32, align 4
  %a11 = alloca i32, align 4
  %a12 = alloca i32, align 4
  store i32 %a2, i32* %2, align 4
  store i32 %a3, i32* %3, align 4
  store i32 %a4, i32* %4, align 4
  store i32 %a5, i32* %5, align 4
  store i32 %a6, i32* %6, align 4
  store i32 %a7, i32* %7, align 4
  store i32 %a8, i32* %8, align 4
  store i32 %a9, i32* %9, align 4
  store i32 %a9, i32* %a1
  %10 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %10)
  %11 = va_arg i8** %args, i32
  store i32 %11, i32* %a10, align 4
  %12 = va_arg i8** %args, i32
  store i32 %12, i32* %a11, align 4
  %13 = va_arg i8** %args, i32
  store i32 %13, i32* %a12, align 4
  ret void
}

declare void @llvm.va_start(i8*) nounwind

define i32 @main() nounwind ssp {
; CHECK-LABEL: main:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #96 ; =96
; CHECK-NEXT:    stp x29, x30, [sp, #80] ; 16-byte Folded Spill
; CHECK-NEXT:    mov w9, #1
; CHECK-NEXT:    mov w8, #2
; CHECK-NEXT:    stp w8, w9, [sp, #72]
; CHECK-NEXT:    mov w9, #3
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    stp w8, w9, [sp, #64]
; CHECK-NEXT:    mov w9, #5
; CHECK-NEXT:    mov w8, #6
; CHECK-NEXT:    stp w8, w9, [sp, #56]
; CHECK-NEXT:    mov w9, #7
; CHECK-NEXT:    mov w8, #8
; CHECK-NEXT:    stp w8, w9, [sp, #48]
; CHECK-NEXT:    mov w8, #9
; CHECK-NEXT:    mov w9, #10
; CHECK-NEXT:    stp w9, w8, [sp, #40]
; CHECK-NEXT:    mov w10, #11
; CHECK-NEXT:    mov w11, #12
; CHECK-NEXT:    stp w11, w10, [sp, #32]
; CHECK-NEXT:    stp x10, x11, [sp, #16]
; CHECK-NEXT:    str x9, [sp, #8]
; CHECK-NEXT:    str w8, [sp]
; CHECK-NEXT:    add x0, sp, #76 ; =76
; CHECK-NEXT:    mov w1, #2
; CHECK-NEXT:    mov w2, #3
; CHECK-NEXT:    mov w3, #4
; CHECK-NEXT:    mov w4, #5
; CHECK-NEXT:    mov w5, #6
; CHECK-NEXT:    mov w6, #7
; CHECK-NEXT:    mov w7, #8
; CHECK-NEXT:    bl _fn9
; CHECK-NEXT:    mov w0, #0
; CHECK-NEXT:    ldp x29, x30, [sp, #80] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #96 ; =96
; CHECK-NEXT:    ret
  %a1 = alloca i32, align 4
  %a2 = alloca i32, align 4
  %a3 = alloca i32, align 4
  %a4 = alloca i32, align 4
  %a5 = alloca i32, align 4
  %a6 = alloca i32, align 4
  %a7 = alloca i32, align 4
  %a8 = alloca i32, align 4
  %a9 = alloca i32, align 4
  %a10 = alloca i32, align 4
  %a11 = alloca i32, align 4
  %a12 = alloca i32, align 4
  store i32 1, i32* %a1, align 4
  store i32 2, i32* %a2, align 4
  store i32 3, i32* %a3, align 4
  store i32 4, i32* %a4, align 4
  store i32 5, i32* %a5, align 4
  store i32 6, i32* %a6, align 4
  store i32 7, i32* %a7, align 4
  store i32 8, i32* %a8, align 4
  store i32 9, i32* %a9, align 4
  store i32 10, i32* %a10, align 4
  store i32 11, i32* %a11, align 4
  store i32 12, i32* %a12, align 4
  %1 = load i32, i32* %a1, align 4
  %2 = load i32, i32* %a2, align 4
  %3 = load i32, i32* %a3, align 4
  %4 = load i32, i32* %a4, align 4
  %5 = load i32, i32* %a5, align 4
  %6 = load i32, i32* %a6, align 4
  %7 = load i32, i32* %a7, align 4
  %8 = load i32, i32* %a8, align 4
  %9 = load i32, i32* %a9, align 4
  %10 = load i32, i32* %a10, align 4
  %11 = load i32, i32* %a11, align 4
  %12 = load i32, i32* %a12, align 4
  call void (i32*, i32, i32, i32, i32, i32, i32, i32, i32, ...) @fn9(i32* %a1, i32 %2, i32 %3, i32 %4, i32 %5, i32 %6, i32 %7, i32 %8, i32 %9, i32 %10, i32 %11, i32 %12)
  ret i32 0
}

;rdar://13668483
@.str = private unnamed_addr constant [4 x i8] c"fmt\00", align 1
define void @foo(i8* %fmt, ...) nounwind {
; CHECK-LABEL: foo:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #48 ; =48
; CHECK-NEXT:    ldr w8, [sp, #48]
; CHECK-NEXT:    str w8, [sp, #28]
; CHECK-NEXT:    add x8, sp, #48 ; =48
; CHECK-NEXT:    add x8, x8, #23 ; =23
; CHECK-NEXT:    and x8, x8, #0xfffffffffffffff0
; CHECK-NEXT:    add x9, x8, #16 ; =16
; CHECK-NEXT:    stp x9, x0, [sp, #32]
; CHECK-NEXT:    ldr q0, [x8]
; CHECK-NEXT:    str q0, [sp], #48
; CHECK-NEXT:    ret
entry:
  %fmt.addr = alloca i8*, align 8
  %args = alloca i8*, align 8
  %vc = alloca i32, align 4
  %vv = alloca <4 x i32>, align 16
  store i8* %fmt, i8** %fmt.addr, align 8
  %args1 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %args1)
  %0 = va_arg i8** %args, i32
  store i32 %0, i32* %vc, align 4
  %1 = va_arg i8** %args, <4 x i32>
  store <4 x i32> %1, <4 x i32>* %vv, align 16
  ret void
}

define void @bar(i32 %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: bar:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #80 ; =80
; CHECK-NEXT:    stp x29, x30, [sp, #64] ; 16-byte Folded Spill
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    str w0, [sp, #60]
; CHECK-NEXT:    stp q0, q0, [sp, #16]
; CHECK-NEXT:    str x0, [sp]
; CHECK-NEXT:  Lloh0:
; CHECK-NEXT:    adrp x0, l_.str@PAGE
; CHECK-NEXT:  Lloh1:
; CHECK-NEXT:    add x0, x0, l_.str@PAGEOFF
; CHECK-NEXT:    bl _foo
; CHECK-NEXT:    ldp x29, x30, [sp, #64] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #80 ; =80
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpAdd Lloh0, Lloh1
entry:
  %x.addr = alloca i32, align 4
  %y.addr = alloca <4 x i32>, align 16
  store i32 %x, i32* %x.addr, align 4
  store <4 x i32> %y, <4 x i32>* %y.addr, align 16
  %0 = load i32, i32* %x.addr, align 4
  %1 = load <4 x i32>, <4 x i32>* %y.addr, align 16
  call void (i8*, ...) @foo(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %0, <4 x i32> %1)
  ret void
}

; rdar://13668927
; When passing 16-byte aligned small structs as vararg, make sure the caller
; side is 16-byte aligned on stack.
%struct.s41 = type { i32, i16, i32, i16 }
define void @foo2(i8* %fmt, ...) nounwind {
; CHECK-LABEL: foo2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #48 ; =48
; CHECK-NEXT:    ldr w8, [sp, #48]
; CHECK-NEXT:    str w8, [sp, #28]
; CHECK-NEXT:    add x8, sp, #48 ; =48
; CHECK-NEXT:    add x8, x8, #23 ; =23
; CHECK-NEXT:    and x8, x8, #0xfffffffffffffff0
; CHECK-NEXT:    add x9, x8, #16 ; =16
; CHECK-NEXT:    stp x9, x0, [sp, #32]
; CHECK-NEXT:    ldr q0, [x8]
; CHECK-NEXT:    str q0, [sp], #48
; CHECK-NEXT:    ret
entry:
  %fmt.addr = alloca i8*, align 8
  %args = alloca i8*, align 8
  %vc = alloca i32, align 4
  %vs = alloca %struct.s41, align 16
  store i8* %fmt, i8** %fmt.addr, align 8
  %args1 = bitcast i8** %args to i8*
  call void @llvm.va_start(i8* %args1)
  %0 = va_arg i8** %args, i32
  store i32 %0, i32* %vc, align 4
  %ap.cur = load i8*, i8** %args
  %1 = getelementptr i8, i8* %ap.cur, i32 15
  %2 = ptrtoint i8* %1 to i64
  %3 = and i64 %2, -16
  %ap.align = inttoptr i64 %3 to i8*
  %ap.next = getelementptr i8, i8* %ap.align, i32 16
  store i8* %ap.next, i8** %args
  %4 = bitcast i8* %ap.align to %struct.s41*
  %5 = bitcast %struct.s41* %vs to i8*
  %6 = bitcast %struct.s41* %4 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %5, i8* align 16 %6, i64 16, i1 false)
  ret void
}
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind

define void @bar2(i32 %x, i128 %s41.coerce) nounwind {
; CHECK-LABEL: bar2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub sp, sp, #80 ; =80
; CHECK-NEXT:    stp x29, x30, [sp, #64] ; 16-byte Folded Spill
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    str w0, [sp, #60]
; CHECK-NEXT:    stp x1, x2, [sp, #32]
; CHECK-NEXT:    stp x1, x2, [sp, #16]
; CHECK-NEXT:    str x0, [sp]
; CHECK-NEXT:  Lloh2:
; CHECK-NEXT:    adrp x0, l_.str@PAGE
; CHECK-NEXT:  Lloh3:
; CHECK-NEXT:    add x0, x0, l_.str@PAGEOFF
; CHECK-NEXT:    bl _foo2
; CHECK-NEXT:    ldp x29, x30, [sp, #64] ; 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #80 ; =80
; CHECK-NEXT:    ret
; CHECK-NEXT:    .loh AdrpAdd Lloh2, Lloh3
entry:
  %x.addr = alloca i32, align 4
  %s41 = alloca %struct.s41, align 16
  store i32 %x, i32* %x.addr, align 4
  %0 = bitcast %struct.s41* %s41 to i128*
  store i128 %s41.coerce, i128* %0, align 1
  %1 = load i32, i32* %x.addr, align 4
  %2 = bitcast %struct.s41* %s41 to i128*
  %3 = load i128, i128* %2, align 1
  call void (i8*, ...) @foo2(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %1, i128 %3)
  ret void
}
