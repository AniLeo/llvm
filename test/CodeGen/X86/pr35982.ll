; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+mmx,+3dnowa -post-RA-scheduler=false | FileCheck %s --check-prefixes=CHECK,NOPOST
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+mmx,+3dnowa -post-RA-scheduler=true | FileCheck %s --check-prefixes=CHECK,POST

define float @PR35982_emms(<1 x i64>) nounwind {
; NOPOST-LABEL: PR35982_emms:
; NOPOST:       # %bb.0:
; NOPOST-NEXT:    pushl %ebp
; NOPOST-NEXT:    movl %esp, %ebp
; NOPOST-NEXT:    andl $-8, %esp
; NOPOST-NEXT:    subl $16, %esp
; NOPOST-NEXT:    movl 8(%ebp), %eax
; NOPOST-NEXT:    movl 12(%ebp), %ecx
; NOPOST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; NOPOST-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; NOPOST-NEXT:    movd %mm0, %ecx
; NOPOST-NEXT:    emms
; NOPOST-NEXT:    movl %eax, (%esp)
; NOPOST-NEXT:    fildl (%esp)
; NOPOST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    fiaddl {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movl %ebp, %esp
; NOPOST-NEXT:    popl %ebp
; NOPOST-NEXT:    retl
;
; POST-LABEL: PR35982_emms:
; POST:       # %bb.0:
; POST-NEXT:    pushl %ebp
; POST-NEXT:    movl %esp, %ebp
; POST-NEXT:    andl $-8, %esp
; POST-NEXT:    subl $16, %esp
; POST-NEXT:    movl 8(%ebp), %eax
; POST-NEXT:    movl 12(%ebp), %ecx
; POST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; POST-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; POST-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; POST-NEXT:    emms
; POST-NEXT:    movl %eax, (%esp)
; POST-NEXT:    fildl (%esp)
; POST-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; POST-NEXT:    movd %mm0, %ecx
; POST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; POST-NEXT:    fiaddl {{[0-9]+}}(%esp)
; POST-NEXT:    movl %ebp, %esp
; POST-NEXT:    popl %ebp
; POST-NEXT:    retl
  %2 = bitcast <1 x i64> %0 to <2 x i32>
  %3 = extractelement <2 x i32> %2, i32 0
  %4 = extractelement <1 x i64> %0, i32 0
  %5 = bitcast i64 %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.punpckhdq(x86_mmx %5, x86_mmx %5)
  %7 = bitcast x86_mmx %6 to <2 x i32>
  %8 = extractelement <2 x i32> %7, i32 0
  tail call void @llvm.x86.mmx.emms()
  %9 = sitofp i32 %3 to float
  %10 = sitofp i32 %8 to float
  %11 = fadd float %9, %10
  ret float %11
}

define float @PR35982_femms(<1 x i64>) nounwind {
; NOPOST-LABEL: PR35982_femms:
; NOPOST:       # %bb.0:
; NOPOST-NEXT:    pushl %ebp
; NOPOST-NEXT:    movl %esp, %ebp
; NOPOST-NEXT:    andl $-8, %esp
; NOPOST-NEXT:    subl $16, %esp
; NOPOST-NEXT:    movl 8(%ebp), %eax
; NOPOST-NEXT:    movl 12(%ebp), %ecx
; NOPOST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; NOPOST-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; NOPOST-NEXT:    movd %mm0, %ecx
; NOPOST-NEXT:    femms
; NOPOST-NEXT:    movl %eax, (%esp)
; NOPOST-NEXT:    fildl (%esp)
; NOPOST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; NOPOST-NEXT:    fiaddl {{[0-9]+}}(%esp)
; NOPOST-NEXT:    movl %ebp, %esp
; NOPOST-NEXT:    popl %ebp
; NOPOST-NEXT:    retl
;
; POST-LABEL: PR35982_femms:
; POST:       # %bb.0:
; POST-NEXT:    pushl %ebp
; POST-NEXT:    movl %esp, %ebp
; POST-NEXT:    andl $-8, %esp
; POST-NEXT:    subl $16, %esp
; POST-NEXT:    movl 8(%ebp), %eax
; POST-NEXT:    movl 12(%ebp), %ecx
; POST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; POST-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; POST-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; POST-NEXT:    femms
; POST-NEXT:    movl %eax, (%esp)
; POST-NEXT:    fildl (%esp)
; POST-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; POST-NEXT:    movd %mm0, %ecx
; POST-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; POST-NEXT:    fiaddl {{[0-9]+}}(%esp)
; POST-NEXT:    movl %ebp, %esp
; POST-NEXT:    popl %ebp
; POST-NEXT:    retl
  %2 = bitcast <1 x i64> %0 to <2 x i32>
  %3 = extractelement <2 x i32> %2, i32 0
  %4 = extractelement <1 x i64> %0, i32 0
  %5 = bitcast i64 %4 to x86_mmx
  %6 = tail call x86_mmx @llvm.x86.mmx.punpckhdq(x86_mmx %5, x86_mmx %5)
  %7 = bitcast x86_mmx %6 to <2 x i32>
  %8 = extractelement <2 x i32> %7, i32 0
  tail call void @llvm.x86.mmx.femms()
  %9 = sitofp i32 %3 to float
  %10 = sitofp i32 %8 to float
  %11 = fadd float %9, %10
  ret float %11
}

declare x86_mmx @llvm.x86.mmx.punpckhdq(x86_mmx, x86_mmx)
declare void @llvm.x86.mmx.femms()
declare void @llvm.x86.mmx.emms()
