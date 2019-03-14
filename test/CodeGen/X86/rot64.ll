; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mcpu=corei7 | FileCheck %s --check-prefix=ALL --check-prefix=X64
; RUN: llc < %s -mtriple=x86_64-- -mcpu=corei7-avx | FileCheck %s --check-prefix=ALL --check-prefix=SHLD
; RUN: llc < %s -mtriple=x86_64-- -mcpu=core-avx2 | FileCheck %s --check-prefix=ALL --check-prefix=BMI2

define i64 @foo(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: foo:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdx, %rcx
; ALL-NEXT:    movq %rdi, %rax
; ALL-NEXT:    # kill: def $cl killed $cl killed $rcx
; ALL-NEXT:    rolq %cl, %rax
; ALL-NEXT:    retq
entry:
	%0 = shl i64 %x, %z
	%1 = sub i64 64, %z
	%2 = lshr i64 %x, %1
	%3 = or i64 %2, %0
	ret i64 %3
}

define i64 @bar(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: bar:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdx, %rcx
; ALL-NEXT:    movq %rsi, %rax
; ALL-NEXT:    # kill: def $cl killed $cl killed $rcx
; ALL-NEXT:    shldq %cl, %rdi, %rax
; ALL-NEXT:    retq
entry:
	%0 = shl i64 %y, %z
	%1 = sub i64 64, %z
	%2 = lshr i64 %x, %1
	%3 = or i64 %2, %0
	ret i64 %3
}

define i64 @un(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: un:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdx, %rcx
; ALL-NEXT:    movq %rdi, %rax
; ALL-NEXT:    # kill: def $cl killed $cl killed $rcx
; ALL-NEXT:    rorq %cl, %rax
; ALL-NEXT:    retq
entry:
	%0 = lshr i64 %x, %z
	%1 = sub i64 64, %z
	%2 = shl i64 %x, %1
	%3 = or i64 %2, %0
	ret i64 %3
}

define i64 @bu(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: bu:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdx, %rcx
; ALL-NEXT:    movq %rsi, %rax
; ALL-NEXT:    # kill: def $cl killed $cl killed $rcx
; ALL-NEXT:    shrdq %cl, %rdi, %rax
; ALL-NEXT:    retq
entry:
	%0 = lshr i64 %y, %z
	%1 = sub i64 64, %z
	%2 = shl i64 %x, %1
	%3 = or i64 %2, %0
	ret i64 %3
}

define i64 @xfoo(i64 %x, i64 %y, i64 %z) nounwind readnone {
; X64-LABEL: xfoo:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rolq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: xfoo:
; SHLD:       # %bb.0: # %entry
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shldq $7, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: xfoo:
; BMI2:       # %bb.0: # %entry
; BMI2-NEXT:    rorxq $57, %rdi, %rax
; BMI2-NEXT:    retq
entry:
	%0 = lshr i64 %x, 57
	%1 = shl i64 %x, 7
	%2 = or i64 %0, %1
	ret i64 %2
}

define i64 @xfoop(i64* %p) nounwind readnone {
; X64-LABEL: xfoop:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    rolq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: xfoop:
; SHLD:       # %bb.0: # %entry
; SHLD-NEXT:    movq (%rdi), %rax
; SHLD-NEXT:    shldq $7, %rax, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: xfoop:
; BMI2:       # %bb.0: # %entry
; BMI2-NEXT:    rorxq $57, (%rdi), %rax
; BMI2-NEXT:    retq
entry:
	%x = load i64, i64* %p
	%a = lshr i64 %x, 57
	%b = shl i64 %x, 7
	%c = or i64 %a, %b
	ret i64 %c
}

define i64 @xbar(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: xbar:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdi, %rax
; ALL-NEXT:    shrdq $57, %rsi, %rax
; ALL-NEXT:    retq
entry:
	%0 = shl i64 %y, 7
	%1 = lshr i64 %x, 57
	%2 = or i64 %0, %1
	ret i64 %2
}

define i64 @xun(i64 %x, i64 %y, i64 %z) nounwind readnone {
; X64-LABEL: xun:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rolq $57, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: xun:
; SHLD:       # %bb.0: # %entry
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shldq $57, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: xun:
; BMI2:       # %bb.0: # %entry
; BMI2-NEXT:    rorxq $7, %rdi, %rax
; BMI2-NEXT:    retq
entry:
	%0 = lshr i64 %x, 7
	%1 = shl i64 %x, 57
	%2 = or i64 %0, %1
	ret i64 %2
}

define i64 @xunp(i64* %p) nounwind readnone {
; X64-LABEL: xunp:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    rolq $57, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: xunp:
; SHLD:       # %bb.0: # %entry
; SHLD-NEXT:    movq (%rdi), %rax
; SHLD-NEXT:    shldq $57, %rax, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: xunp:
; BMI2:       # %bb.0: # %entry
; BMI2-NEXT:    rorxq $7, (%rdi), %rax
; BMI2-NEXT:    retq
entry:
	%x = load i64, i64* %p
	%a = lshr i64 %x, 7
	%b = shl i64 %x, 57
	%c = or i64 %a, %b
	ret i64 %c
}

define i64 @xbu(i64 %x, i64 %y, i64 %z) nounwind readnone {
; ALL-LABEL: xbu:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq %rdi, %rax
; ALL-NEXT:    shldq $57, %rsi, %rax
; ALL-NEXT:    retq
entry:
	%0 = lshr i64 %y, 7
	%1 = shl i64 %x, 57
	%2 = or i64 %0, %1
	ret i64 %2
}

define i64 @fshl(i64 %x) nounwind {
; X64-LABEL: fshl:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rolq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshl:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shldq $7, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshl:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $57, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 7)
  ret i64 %f
}
declare i64 @llvm.fshl.i64(i64, i64, i64)

define i64 @fshl1(i64 %x) nounwind {
; X64-LABEL: fshl1:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rolq %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshl1:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shldq $1, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshl1:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $63, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 1)
  ret i64 %f
}

define i64 @fshl63(i64 %x) nounwind {
; X64-LABEL: fshl63:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rorq %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshl63:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shldq $63, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshl63:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $1, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 63)
  ret i64 %f
}

define i64 @fshl_load(i64* %p) nounwind {
; X64-LABEL: fshl_load:
; X64:       # %bb.0:
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    rolq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshl_load:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq (%rdi), %rax
; SHLD-NEXT:    shldq $7, %rax, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshl_load:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $57, (%rdi), %rax
; BMI2-NEXT:    retq
  %x = load i64, i64* %p
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 7)
  ret i64 %f
}

define i64 @fshr(i64 %x) nounwind {
; X64-LABEL: fshr:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rorq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshr:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shrdq $7, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshr:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $7, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 7)
  ret i64 %f
}
declare i64 @llvm.fshr.i64(i64, i64, i64)

define i64 @fshr1(i64 %x) nounwind {
; X64-LABEL: fshr1:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rorq $1, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshr1:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shrdq $1, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshr1:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $1, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 1)
  ret i64 %f
}

define i64 @fshr63(i64 %x) nounwind {
; X64-LABEL: fshr63:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    rolq %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshr63:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq %rdi, %rax
; SHLD-NEXT:    shrdq $63, %rdi, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshr63:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $63, %rdi, %rax
; BMI2-NEXT:    retq
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 63)
  ret i64 %f
}

define i64 @fshr_load(i64* %p) nounwind {
; X64-LABEL: fshr_load:
; X64:       # %bb.0:
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    rorq $7, %rax
; X64-NEXT:    retq
;
; SHLD-LABEL: fshr_load:
; SHLD:       # %bb.0:
; SHLD-NEXT:    movq (%rdi), %rax
; SHLD-NEXT:    shrdq $7, %rax, %rax
; SHLD-NEXT:    retq
;
; BMI2-LABEL: fshr_load:
; BMI2:       # %bb.0:
; BMI2-NEXT:    rorxq $7, (%rdi), %rax
; BMI2-NEXT:    retq
  %x = load i64, i64* %p
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 7)
  ret i64 %f
}
