; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O2 -verify-machineinstrs -mcpu=pwr4 -mattr=-altivec -mtriple powerpc-ibm-aix-xcoff < %s | FileCheck --check-prefix=ASM32 %s
; RUN: llc -O2 -mtriple powerpc-ibm-aix-xcoff -stop-after=machine-cp -verify-machineinstrs < %s | FileCheck --check-prefix=32BIT %s

define i32 @int_va_arg(i32 %a, ...) local_unnamed_addr  {
; ASM32-LABEL: int_va_arg:
; ASM32:       # %bb.0: # %entry
; ASM32-NEXT:    addi 11, 1, 28
; ASM32-NEXT:    stw 4, 28(1)
; ASM32-NEXT:    addi 4, 1, 32
; ASM32-NEXT:    stw 6, 36(1)
; ASM32-NEXT:    stw 11, -4(1)
; ASM32-NEXT:    stw 11, -8(1)
; ASM32-NEXT:    stw 4, -4(1)
; ASM32-NEXT:    lwz 6, 28(1)
; ASM32-NEXT:    stw 4, -8(1)
; ASM32-NEXT:    add 3, 6, 3
; ASM32-NEXT:    lwz 4, 28(1)
; ASM32-NEXT:    slwi 4, 4, 1
; ASM32-NEXT:    stw 7, 40(1)
; ASM32-NEXT:    add 3, 3, 4
; ASM32-NEXT:    stw 8, 44(1)
; ASM32-NEXT:    stw 9, 48(1)
; ASM32-NEXT:    stw 10, 52(1)
; ASM32-NEXT:    stw 5, 32(1)
; ASM32-NEXT:    blr
entry:
  %arg1 = alloca i8*, align 4
  %arg2 = alloca i8*, align 4
  %0 = bitcast i8** %arg1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0)
  %1 = bitcast i8** %arg2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.va_start(i8* nonnull %0)
  call void @llvm.va_copy(i8* nonnull %1, i8* nonnull %0)
  %argp.cur = load i8*, i8** %arg1, align 4
  %argp.next = getelementptr inbounds i8, i8* %argp.cur, i32 4
  store i8* %argp.next, i8** %arg1, align 4
  %2 = bitcast i8* %argp.cur to i32*
  %3 = load i32, i32* %2, align 4
  %add = add nsw i32 %3, %a
  %argp.cur2 = load i8*, i8** %arg2, align 4
  %argp.next3 = getelementptr inbounds i8, i8* %argp.cur2, i32 4
  store i8* %argp.next3, i8** %arg2, align 4
  %4 = bitcast i8* %argp.cur2 to i32*
  %5 = load i32, i32* %4, align 4
  %mul = shl i32 %5, 1
  %add4 = add nsw i32 %add, %mul
  call void @llvm.va_end(i8* nonnull %0)
  call void @llvm.va_end(i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0)
  ret i32 %add4
}

; 32BIT-LABEL:   name:            int_va_arg
; 32BIT-LABEL:   liveins:
; 32BIT-DAG:     - { reg: '$r3', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r4', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r5', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r6', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r7', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r8', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r9', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r10', virtual-reg: '' }

; 32BIT-LABEL:   fixedStack:
; 32BIT-DAG:     - { id: 0, type: default, offset: 28, size: 4

; 32BIT-LABEL:   stack:
; 32BIT-DAG:     - { id: 0, name: arg1, type: default, offset: 0, size: 4
; 32BIT-DAG:     - { id: 1, name: arg2, type: default, offset: 0, size: 4

; 32BIT-LABEL:   body:             |
; 32BIT-DAG:     liveins: $r3, $r4, $r5, $r6, $r7, $r8, $r9, $r10
; 32BIT-DAG:     STW killed renamable $r4, 0, %fixed-stack.0 :: (store (s32) into %fixed-stack.0)
; 32BIT-DAG:     STW killed renamable $r5, 4, %fixed-stack.0 :: (store (s32) into %fixed-stack.0 + 4)
; 32BIT-DAG:     STW killed renamable $r6, 8, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r7, 12, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r8, 16, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r9, 20, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r10, 24, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r4, 0, %stack.1.arg2 :: (store (s32) into %ir.arg2)
; 32BIT-DAG:     renamable $r4 = ADDI %fixed-stack.0, 4
; 32BIT-DAG:     STW killed renamable $r11, 0, %stack.1.arg2 :: (store (s32) into %ir.1)
; 32BIT-DAG:     renamable $r11 = ADDI %fixed-stack.0, 0
; 32BIT-DAG:     STW renamable $r11, 0, %stack.0.arg1 :: (store (s32) into %ir.0)
; 32BIT-DAG:     STW renamable $r4, 0, %stack.0.arg1 :: (store (s32) into %ir.arg1)
; 32BIT-DAG:     renamable $r6 = LWZ 0, %fixed-stack.0 :: (load (s32) from %ir.2)
; 32BIT-DAG:     renamable $r4 = LWZ 0, %fixed-stack.0 :: (load (s32) from %ir.4)
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r6, killed renamable $r3
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r4
; 32BIT-DAG:     BLR implicit $lr, implicit $rm, implicit $r3

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

define i32 @int_stack_va_arg(i32 %one, i32 %two, i32 %three, i32 %four, i32 %five, i32 %six, i32 %seven, i32 %eight, ...) local_unnamed_addr {
; ASM32-LABEL: int_stack_va_arg:
; ASM32:       # %bb.0: # %entry
; ASM32-NEXT:    add 3, 4, 3
; ASM32-NEXT:    lwz 4, 56(1)
; ASM32-NEXT:    li 11, 4
; ASM32-NEXT:    add 3, 3, 5
; ASM32-NEXT:    addi 12, 1, 56
; ASM32-NEXT:    add 3, 3, 6
; ASM32-NEXT:    rlwimi 12, 11, 0, 29, 29
; ASM32-NEXT:    stw 12, -4(1)
; ASM32-NEXT:    add 3, 3, 7
; ASM32-NEXT:    add 3, 3, 8
; ASM32-NEXT:    add 3, 3, 9
; ASM32-NEXT:    add 3, 3, 10
; ASM32-NEXT:    add 3, 3, 4
; ASM32-NEXT:    slwi 4, 4, 1
; ASM32-NEXT:    add 3, 3, 4
; ASM32-NEXT:    blr
entry:
  %arg1 = alloca i8*, align 4
  %arg2 = alloca i8*, align 4
  %0 = bitcast i8** %arg1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0)
  %1 = bitcast i8** %arg2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.va_start(i8* nonnull %0)
  call void @llvm.va_copy(i8* nonnull %1, i8* nonnull %0)
  %add = add nsw i32 %two, %one
  %add2 = add nsw i32 %add, %three
  %add3 = add nsw i32 %add2, %four
  %add4 = add nsw i32 %add3, %five
  %add5 = add nsw i32 %add4, %six
  %add6 = add nsw i32 %add5, %seven
  %add7 = add nsw i32 %add6, %eight
  %argp.cur = load i8*, i8** %arg1, align 4
  %argp.next = getelementptr inbounds i8, i8* %argp.cur, i32 4
  store i8* %argp.next, i8** %arg1, align 4
  %2 = bitcast i8* %argp.cur to i32*
  %3 = load i32, i32* %2, align 4
  %add8 = add nsw i32 %add7, %3
  %argp.cur9 = load i8*, i8** %arg2, align 4
  %argp.next10 = getelementptr inbounds i8, i8* %argp.cur9, i32 4
  store i8* %argp.next10, i8** %arg2, align 4
  %4 = bitcast i8* %argp.cur9 to i32*
  %5 = load i32, i32* %4, align 4
  %mul = shl i32 %5, 1
  %add11 = add nsw i32 %add8, %mul
  call void @llvm.va_end(i8* nonnull %0)
  call void @llvm.va_end(i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0)
  ret i32 %add11
}

; 32BIT-LABEL:   name:            int_stack_va_arg
; 32BIT-LABEL:   liveins:
; 32BIT-DAG:     - { reg: '$r3', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r4', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r5', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r6', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r7', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r8', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r9', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r10', virtual-reg: '' }

; 32BIT-LABEL:   fixedStack:
; 32BIT-DAG:     - { id: 0, type: default, offset: 56, size: 4

; 32BIT-LABEL:   stack:
; 32BIT-DAG:     - { id: 0, name: arg1, type: default, offset: 0, size: 4
; 32BIT-DAG:     - { id: 1, name: arg2, type: default, offset: 0, size: 4

; 32BIT-LABEL:   body:             |
; 32BIT-DAG:     liveins: $r3, $r4, $r5, $r6, $r7, $r8, $r9, $r10
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r4
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r5
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r6
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r7
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r8
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r9
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, killed renamable $r10
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r4, killed renamable $r3
; 32BIT-DAG:     renamable $r4 = ADDI %fixed-stack.0, 0
; 32BIT-DAG:     STW killed renamable $r4, 0, %stack.0.arg1 :: (store (s32) into %ir.arg1)
; 32BIT-DAG:     renamable $r3 = nsw ADD4 killed renamable $r3, renamable $r4
; 32BIT-DAG:     renamable $r4 = LWZ 0, %fixed-stack.0 :: (load (s32) from %ir.4, align 8)
; 32BIT-DAG:     renamable $r11 = LI 4
; 32BIT-DAG:     BLR implicit $lr, implicit $rm, implicit $r3

define double @double_va_arg(double %a, ...) local_unnamed_addr  {
; ASM32-LABEL: double_va_arg:
; ASM32:       # %bb.0: # %entry
; ASM32-NEXT:    stw 5, -16(1)
; ASM32-NEXT:    addi 3, 1, 32
; ASM32-NEXT:    stw 6, -12(1)
; ASM32-NEXT:    lfd 0, -16(1)
; ASM32-NEXT:    stw 5, -24(1)
; ASM32-NEXT:    fadd 0, 0, 1
; ASM32-NEXT:    stw 6, -20(1)
; ASM32-NEXT:    lfd 1, -24(1)
; ASM32-NEXT:    fadd 1, 1, 1
; ASM32-NEXT:    stw 7, 40(1)
; ASM32-NEXT:    fadd 1, 0, 1
; ASM32-NEXT:    stw 5, 32(1)
; ASM32-NEXT:    stw 6, 36(1)
; ASM32-NEXT:    stw 8, 44(1)
; ASM32-NEXT:    stw 9, 48(1)
; ASM32-NEXT:    stw 10, 52(1)
; ASM32-NEXT:    stw 3, -4(1)
; ASM32-NEXT:    stw 3, -8(1)
; ASM32-NEXT:    blr
entry:
  %arg1 = alloca i8*, align 4
  %arg2 = alloca i8*, align 4
  %0 = bitcast i8** %arg1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0)
  %1 = bitcast i8** %arg2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.va_start(i8* nonnull %0)
  call void @llvm.va_copy(i8* nonnull %1, i8* nonnull %0)
  %argp.cur = load i8*, i8** %arg1, align 4
  %argp.next = getelementptr inbounds i8, i8* %argp.cur, i32 8
  store i8* %argp.next, i8** %arg1, align 4
  %2 = bitcast i8* %argp.cur to double*
  %3 = load double, double* %2, align 4
  %add = fadd double %3, %a
  %argp.cur2 = load i8*, i8** %arg2, align 4
  %argp.next3 = getelementptr inbounds i8, i8* %argp.cur2, i32 8
  store i8* %argp.next3, i8** %arg2, align 4
  %4 = bitcast i8* %argp.cur2 to double*
  %5 = load double, double* %4, align 4
  %mul = fmul double %5, 2.000000e+00
  %add4 = fadd double %add, %mul
  call void @llvm.va_end(i8* nonnull %0)
  call void @llvm.va_end(i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0)
  ret double %add4
}

; 32BIT-LABEL:   name:            double_va_arg
; 32BIT-LABEL:   liveins:
; 32BIT-DAG:     - { reg: '$f1', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r5', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r6', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r7', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r8', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r9', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$r10', virtual-reg: '' }

; 32BIT-LABEL:   fixedStack:
; 32BIT-DAG:     - { id: 0, type: default, offset: 32, size: 4

; 32BIT-LABEL:   stack:
; 32BIT-DAG:     - { id: 0, name: arg1, type: default, offset: 0, size: 4
; 32BIT-DAG:     - { id: 1, name: arg2, type: default, offset: 0, size: 4

; 32BIT-LABEL:   body:             |
; 32BIT-DAG:     liveins: $f1, $r5, $r6, $r7, $r8, $r9, $r10
; 32BIT-DAG:     renamable $r3 = ADDI %fixed-stack.0, 0
; 32BIT-DAG:     STW renamable $r5, 0, %fixed-stack.0 :: (store (s32) into %fixed-stack.0, align 16)
; 32BIT-DAG:     STW renamable $r6, 4, %fixed-stack.0 :: (store (s32) into %fixed-stack.0 + 4)
; 32BIT-DAG:     STW killed renamable $r7, 8, %fixed-stack.0 :: (store (s32) into %fixed-stack.0 + 8, align 8)
; 32BIT-DAG:     STW killed renamable $r8, 12, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW killed renamable $r9, 16, %fixed-stack.0 :: (store (s32) into %fixed-stack.0 + 16, align 16)
; 32BIT-DAG:     STW killed renamable $r10, 20, %fixed-stack.0 :: (store (s32))
; 32BIT-DAG:     STW renamable $r3, 0, %stack.0.arg1 :: (store (s32) into %ir.0)
; 32BIT-DAG:     STW killed renamable $r3, 0, %stack.1.arg2 :: (store (s32) into %ir.1)
; 32BIT-DAG:     BLR implicit $lr, implicit $rm, implicit $f1

define double @double_stack_va_arg(double %one, double %two, double %three, double %four, double %five, double %six, double %seven, double %eight, double %nine, double %ten, double %eleven, double %twelve, double %thirteen, ...) local_unnamed_addr  {
; ASM32-LABEL: double_stack_va_arg:
; ASM32:       # %bb.0: # %entry
; ASM32-NEXT:    fadd 0, 1, 2
; ASM32-NEXT:    addi 4, 1, 128
; ASM32-NEXT:    lwz 3, 132(1)
; ASM32-NEXT:    fadd 0, 0, 3
; ASM32-NEXT:    stw 4, -4(1)
; ASM32-NEXT:    fadd 0, 0, 4
; ASM32-NEXT:    lwz 4, 128(1)
; ASM32-NEXT:    fadd 0, 0, 5
; ASM32-NEXT:    stw 3, -12(1)
; ASM32-NEXT:    fadd 0, 0, 6
; ASM32-NEXT:    stw 4, -16(1)
; ASM32-NEXT:    fadd 0, 0, 7
; ASM32-NEXT:    lfd 1, -16(1)
; ASM32-NEXT:    fadd 0, 0, 8
; ASM32-NEXT:    stw 3, -20(1)
; ASM32-NEXT:    fadd 0, 0, 9
; ASM32-NEXT:    stw 4, -24(1)
; ASM32-NEXT:    fadd 0, 0, 10
; ASM32-NEXT:    fadd 0, 0, 11
; ASM32-NEXT:    fadd 0, 0, 12
; ASM32-NEXT:    fadd 0, 0, 13
; ASM32-NEXT:    fadd 0, 0, 1
; ASM32-NEXT:    lfd 1, -24(1)
; ASM32-NEXT:    fadd 1, 1, 1
; ASM32-NEXT:    fadd 1, 0, 1
; ASM32-NEXT:    blr
entry:
  %arg1 = alloca i8*, align 4
  %arg2 = alloca i8*, align 4
  %0 = bitcast i8** %arg1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %0)
  %1 = bitcast i8** %arg2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.va_start(i8* nonnull %0)
  call void @llvm.va_copy(i8* nonnull %1, i8* nonnull %0)
  %add = fadd double %one, %two
  %add2 = fadd double %add, %three
  %add3 = fadd double %add2, %four
  %add4 = fadd double %add3, %five
  %add5 = fadd double %add4, %six
  %add6 = fadd double %add5, %seven
  %add7 = fadd double %add6, %eight
  %add8 = fadd double %add7, %nine
  %add9 = fadd double %add8, %ten
  %add10 = fadd double %add9, %eleven
  %add11 = fadd double %add10, %twelve
  %add12 = fadd double %add11, %thirteen
  %2 = bitcast i8** %arg1 to double**
  %argp.cur1 = load double*, double** %2, align 4
  %3 = load double, double* %argp.cur1, align 4
  %add13 = fadd double %add12, %3
  %4 = bitcast i8** %arg2 to double**
  %argp.cur142 = load double*, double** %4, align 4
  %5 = load double, double* %argp.cur142, align 4
  %mul = fmul double %5, 2.000000e+00
  %add16 = fadd double %add13, %mul
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %1)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %0)
  ret double %add16
}

; 32BIT-LABEL:   name:            double_stack_va_arg
; 32BIT-LABEL:   liveins:
; 32BIT-DAG:     - { reg: '$f1', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f2', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f3', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f4', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f5', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f6', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f7', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f8', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f9', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f10', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f11', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f12', virtual-reg: '' }
; 32BIT-DAG:     - { reg: '$f13', virtual-reg: '' }

; 32BIT-LABEL:   fixedStack:
; 32BIT-DAG:     - { id: 0, type: default, offset: 128, size: 4

; 32BIT-LABEL:   stack:
; 32BIT-DAG:     - { id: 0, name: arg1, type: default, offset: 0, size: 4, alignment: 4,
; 32BIT-DAG:     - { id: 1, name: arg2, type: default, offset: 0, size: 4, alignment: 4,
; 32BIT-DAG:     - { id: 2, name: '', type: default, offset: 0, size: 8, alignment: 8,
; 32BIT-DAG:     - { id: 3, name: '', type: default, offset: 0, size: 8, alignment: 8,

; 32BIT-LABEL:   body:             |
; 32BIT-DAG:     liveins: $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13
; 32BIT-DAG:     renamable $r4 = ADDI %fixed-stack.0, 0
; 32BIT-DAG:     STW killed renamable $r4, 0, %stack.0.arg1 :: (store (s32) into %ir.0)
; 32BIT-DAG:     renamable $r4 = LWZ 0, %fixed-stack.0 :: (load (s32) from %ir.argp.cur142, align 16)
; 32BIT-DAG:     renamable $f1 = nofpexcept FADD killed renamable $f0, killed renamable $f1, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f1, killed renamable $f2, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f3, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f4, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f5, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f6, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f7, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f8, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f9, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f10, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f11, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f12, implicit $rm
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f13, implicit $rm
; 32BIT-DAG:     renamable $r3 = LWZ 4, %fixed-stack.0 :: (load (s32) from %ir.argp.cur142 + 4)
; 32BIT-DAG:     STW renamable $r3, 4, %stack.2 :: (store (s32) into %stack.2 + 4)
; 32BIT-DAG:     renamable $f1 = LFD 0, %stack.2 :: (load (s64) from %stack.2)
; 32BIT-DAG:     STW killed renamable $r4, 0, %stack.3 :: (store (s32) into %stack.3, align 8)
; 32BIT-DAG:     STW killed renamable $r3, 4, %stack.3 :: (store (s32) into %stack.3 + 4)
; 32BIT-DAG:     renamable $f2 = LFD 0, %stack.3 :: (load (s64) from %stack.3)
; 32BIT-DAG:     renamable $f0 = nofpexcept FADD killed renamable $f0, killed renamable $f1, implicit $rm
; 32BIT-DAG:     STW renamable $r4, 0, %stack.2 :: (store (s32) into %stack.2, align 8)
; 32BIT-DAG:     renamable $f1 = nofpexcept FADD killed renamable $f2, renamable $f2, implicit $rm
; 32BIT-DAG:     BLR implicit $lr, implicit $rm, implicit $f1
