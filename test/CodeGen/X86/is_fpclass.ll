; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-linux | FileCheck %s -check-prefix=CHECK-32
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s -check-prefix=CHECK-64

define i1 @isnan_f(float %x) {
; CHECK-32-LABEL: isnan_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    ucomiss %xmm0, %xmm0
; CHECK-64-NEXT:    setp %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 3)  ; "nan"
  ret i1 %0
}

define i1 @isnot_nan_f(float %x) {
; CHECK-32-LABEL: isnot_nan_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setnp %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnot_nan_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    ucomiss %xmm0, %xmm0
; CHECK-64-NEXT:    setnp %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 1020)  ; 0x3fc = "zero|subnormal|normal|inf"
  ret i1 %0
}

define i1 @issignaling_f(float %x) {
; CHECK-32-LABEL: issignaling_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2143289344, %eax # imm = 0x7FC00000
; CHECK-32-NEXT:    setl %cl
; CHECK-32-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: issignaling_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2143289344, %eax # imm = 0x7FC00000
; CHECK-64-NEXT:    setl %cl
; CHECK-64-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-64-NEXT:    setge %al
; CHECK-64-NEXT:    andb %cl, %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 1)  ; "snan"
  ret i1 %0
}

define i1 @isquiet_f(float %x) {
; CHECK-32-LABEL: isquiet_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2143289344, %eax # imm = 0x7FC00000
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isquiet_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2143289344, %eax # imm = 0x7FC00000
; CHECK-64-NEXT:    setge %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 2)  ; "qnan"
  ret i1 %0
}

define i1 @isinf_f(float %x) {
; CHECK-32-LABEL: isinf_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isinf_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 516)  ; 0x204 = "inf"
  ret i1 %0
}

define i1 @is_plus_inf_f(float %x) {
; CHECK-32-LABEL: is_plus_inf_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    cmpl $2139095040, {{[0-9]+}}(%esp) # imm = 0x7F800000
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_plus_inf_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 512)  ; 0x200 = "+inf"
  ret i1 %0
}

define i1 @is_minus_inf_f(float %x) {
; CHECK-32-LABEL: is_minus_inf_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    cmpl $-8388608, {{[0-9]+}}(%esp) # imm = 0xFF800000
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_minus_inf_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    cmpl $-8388608, %eax # imm = 0xFF800000
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 4)  ; "-inf"
  ret i1 %0
}

define i1 @isfinite_f(float %x) {
; CHECK-32-LABEL: isfinite_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isfinite_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    setl %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 504)  ; 0x1f8 = "finite"
  ret i1 %0
}

define i1 @is_plus_finite_f(float %x) {
; CHECK-32-LABEL: is_plus_finite_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    cmpl $2139095040, {{[0-9]+}}(%esp) # imm = 0x7F800000
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_plus_finite_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 448)  ; 0x1c0 = "+finite"
  ret i1 %0
}

define i1 @is_minus_finite_f(float %x) {
; CHECK-32-LABEL: is_minus_finite_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    testl %eax, %eax
; CHECK-32-NEXT:    sets %cl
; CHECK-32-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_minus_finite_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    testl %eax, %eax
; CHECK-64-NEXT:    sets %cl
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    setl %al
; CHECK-64-NEXT:    andb %cl, %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 56)  ; 0x38 = "-finite"
  ret i1 %0
}

define i1 @isnormal_f(float %x) {
; CHECK-32-LABEL: isnormal_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    addl $-8388608, %eax # imm = 0xFF800000
; CHECK-32-NEXT:    cmpl $2130706432, %eax # imm = 0x7F000000
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnormal_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    addl $-8388608, %eax # imm = 0xFF800000
; CHECK-64-NEXT:    cmpl $2130706432, %eax # imm = 0x7F000000
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 264)  ; 0x108 = "normal"
  ret i1 %0
}

define i1 @is_plus_normal_f(float %x) {
; CHECK-32-LABEL: is_plus_normal_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    testl %eax, %eax
; CHECK-32-NEXT:    setns %cl
; CHECK-32-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    addl $-8388608, %eax # imm = 0xFF800000
; CHECK-32-NEXT:    cmpl $2130706432, %eax # imm = 0x7F000000
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_plus_normal_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    testl %eax, %eax
; CHECK-64-NEXT:    setns %cl
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    addl $-8388608, %eax # imm = 0xFF800000
; CHECK-64-NEXT:    cmpl $2130706432, %eax # imm = 0x7F000000
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    andb %cl, %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 256)  ; 0x100 = "+normal"
  ret i1 %0
}

define i1 @issubnormal_f(float %x) {
; CHECK-32-LABEL: issubnormal_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    decl %eax
; CHECK-32-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: issubnormal_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    decl %eax
; CHECK-64-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 144)  ; 0x90 = "subnormal"
  ret i1 %0
}

define i1 @is_plus_subnormal_f(float %x) {
; CHECK-32-LABEL: is_plus_subnormal_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    decl %eax
; CHECK-32-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_plus_subnormal_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    decl %eax
; CHECK-64-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 128)  ; 0x80 = "+subnormal"
  ret i1 %0
}

define i1 @is_minus_subnormal_f(float %x) {
; CHECK-32-LABEL: is_minus_subnormal_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    testl %eax, %eax
; CHECK-32-NEXT:    sets %cl
; CHECK-32-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    decl %eax
; CHECK-32-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_minus_subnormal_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    testl %eax, %eax
; CHECK-64-NEXT:    sets %cl
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    decl %eax
; CHECK-64-NEXT:    cmpl $8388607, %eax # imm = 0x7FFFFF
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    andb %cl, %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 16)  ; 0x10 = "-subnormal"
  ret i1 %0
}

define i1 @iszero_f(float %x) {
; CHECK-32-LABEL: iszero_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fldz
; CHECK-32-NEXT:    fucompp
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setnp %cl
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: iszero_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    xorps %xmm1, %xmm1
; CHECK-64-NEXT:    cmpeqss %xmm0, %xmm1
; CHECK-64-NEXT:    movd %xmm1, %eax
; CHECK-64-NEXT:    andl $1, %eax
; CHECK-64-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 96)  ; 0x60 = "zero"
  ret i1 %0
}

define i1 @is_plus_zero_f(float %x) {
; CHECK-32-LABEL: is_plus_zero_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_plus_zero_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    testl %eax, %eax
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 64)  ; 0x40 = "+zero"
  ret i1 %0
}

define i1 @is_minus_zero_f(float %x) {
; CHECK-32-LABEL: is_minus_zero_f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    cmpl $-2147483648, {{[0-9]+}}(%esp) # imm = 0x80000000
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: is_minus_zero_f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    cmpl $-2147483648, %eax # imm = 0x80000000
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 32)  ; 0x20 = "-zero"
  ret i1 %0
}



define i1 @isnan_f_strictfp(float %x) strictfp {
; CHECK-32-LABEL: isnan_f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-64-NEXT:    setge %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 3)  ; "nan"
  ret i1 %0
}

define i1 @isfinite_f_strictfp(float %x) strictfp {
; CHECK-32-LABEL: isfinite_f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isfinite_f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095040, %eax # imm = 0x7F800000
; CHECK-64-NEXT:    setl %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 504)  ; 0x1f8 = "finite"
  ret i1 %0
}

define i1 @iszero_f_strictfp(float %x) strictfp {
; CHECK-32-LABEL: iszero_f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    testl $2147483647, {{[0-9]+}}(%esp) # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: iszero_f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    testl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f32(float %x, i32 96)  ; 0x60 = "zero"
  ret i1 %0
}


define i1 @isnan_d(double %x) {
; CHECK-32-LABEL: isnan_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    fldl {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    ucomisd %xmm0, %xmm0
; CHECK-64-NEXT:    setp %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 3)  ; "nan"
  ret i1 %0
}

define i1 @isinf_d(double %x) {
; CHECK-32-LABEL: isinf_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    xorl $2146435072, %eax # imm = 0x7FF00000
; CHECK-32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isinf_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $9218868437227405312, %rax # imm = 0x7FF0000000000000
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 516)  ; 0x204 = "inf"
  ret i1 %0
}

define i1 @isfinite_d(double %x) {
; CHECK-32-LABEL: isfinite_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2146435072, %eax # imm = 0x7FF00000
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isfinite_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $9218868437227405312, %rax # imm = 0x7FF0000000000000
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setl %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 504)  ; 0x1f8 = "finite"
  ret i1 %0
}

define i1 @isnormal_d(double %x) {
; CHECK-32-LABEL: isnormal_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    addl $-1048576, %eax # imm = 0xFFF00000
; CHECK-32-NEXT:    shrl $21, %eax
; CHECK-32-NEXT:    cmpl $1023, %eax # imm = 0x3FF
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnormal_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $-4503599627370496, %rax # imm = 0xFFF0000000000000
; CHECK-64-NEXT:    addq %rcx, %rax
; CHECK-64-NEXT:    shrq $53, %rax
; CHECK-64-NEXT:    cmpl $1023, %eax # imm = 0x3FF
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 264)  ; 0x108 = "normal"
  ret i1 %0
}

define i1 @issubnormal_d(double %x) {
; CHECK-32-LABEL: issubnormal_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    movl $2147483647, %ecx # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    addl $-1, %eax
; CHECK-32-NEXT:    adcl $-1, %ecx
; CHECK-32-NEXT:    cmpl $-1, %eax
; CHECK-32-NEXT:    sbbl $1048575, %ecx # imm = 0xFFFFF
; CHECK-32-NEXT:    setb %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: issubnormal_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    decq %rcx
; CHECK-64-NEXT:    movabsq $4503599627370495, %rax # imm = 0xFFFFFFFFFFFFF
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setb %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 144)  ; 0x90 = "subnormal"
  ret i1 %0
}

define i1 @iszero_d(double %x) {
; CHECK-32-LABEL: iszero_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    fldl {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fldz
; CHECK-32-NEXT:    fucompp
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setnp %cl
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: iszero_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    xorpd %xmm1, %xmm1
; CHECK-64-NEXT:    cmpeqsd %xmm0, %xmm1
; CHECK-64-NEXT:    movq %xmm1, %rax
; CHECK-64-NEXT:    andl $1, %eax
; CHECK-64-NEXT:    # kill: def $al killed $al killed $rax
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 96)  ; 0x60 = "zero"
  ret i1 %0
}

define i1 @issignaling_d(double %x) {
; CHECK-32-LABEL: issignaling_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    xorl %ecx, %ecx
; CHECK-32-NEXT:    cmpl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    movl $2146435072, %ecx # imm = 0x7FF00000
; CHECK-32-NEXT:    sbbl %eax, %ecx
; CHECK-32-NEXT:    setl %cl
; CHECK-32-NEXT:    cmpl $2146959360, %eax # imm = 0x7FF80000
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    andb %cl, %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: issignaling_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $9221120237041090560, %rax # imm = 0x7FF8000000000000
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setl %dl
; CHECK-64-NEXT:    movabsq $9218868437227405312, %rax # imm = 0x7FF0000000000000
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setg %al
; CHECK-64-NEXT:    andb %dl, %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 1)  ; "snan"
  ret i1 %0
}

define i1 @isquiet_d(double %x) {
; CHECK-32-LABEL: isquiet_d:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2146959360, %eax # imm = 0x7FF80000
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isquiet_d:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $9221120237041090559, %rax # imm = 0x7FF7FFFFFFFFFFFF
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setg %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 2)  ; "qnan"
  ret i1 %0
}

define i1 @isnan_d_strictfp(double %x) strictfp {
; CHECK-32-LABEL: isnan_d_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    xorl %ecx, %ecx
; CHECK-32-NEXT:    cmpl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    movl $2146435072, %ecx # imm = 0x7FF00000
; CHECK-32-NEXT:    sbbl %eax, %ecx
; CHECK-32-NEXT:    setl %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_d_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    movabsq $9223372036854775807, %rcx # imm = 0x7FFFFFFFFFFFFFFF
; CHECK-64-NEXT:    andq %rax, %rcx
; CHECK-64-NEXT:    movabsq $9218868437227405312, %rax # imm = 0x7FF0000000000000
; CHECK-64-NEXT:    cmpq %rax, %rcx
; CHECK-64-NEXT:    setg %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 3)  ; "nan"
  ret i1 %0
}

define i1 @iszero_d_strictfp(double %x) strictfp {
; CHECK-32-LABEL: iszero_d_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    sete %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: iszero_d_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movq %xmm0, %rax
; CHECK-64-NEXT:    shlq $1, %rax
; CHECK-64-NEXT:    testq %rax, %rax
; CHECK-64-NEXT:    sete %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call i1 @llvm.is.fpclass.f64(double %x, i32 96)  ; 0x60 = "zero"
  ret i1 %0
}



define <1 x i1> @isnan_v1f(<1 x float> %x) {
; CHECK-32-LABEL: isnan_v1f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_v1f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    ucomiss %xmm0, %xmm0
; CHECK-64-NEXT:    setp %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <1 x i1> @llvm.is.fpclass.v1f32(<1 x float> %x, i32 3)  ; "nan"
  ret <1 x i1> %0
}

define <1 x i1> @isnan_v1f_strictfp(<1 x float> %x) strictfp {
; CHECK-32-LABEL: isnan_v1f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_v1f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    movd %xmm0, %eax
; CHECK-64-NEXT:    andl $2147483647, %eax # imm = 0x7FFFFFFF
; CHECK-64-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-64-NEXT:    setge %al
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <1 x i1> @llvm.is.fpclass.v1f32(<1 x float> %x, i32 3)  ; "nan"
  ret <1 x i1> %0
}

define <2 x i1> @isnan_v2f(<2 x float> %x) {
; CHECK-32-LABEL: isnan_v2f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %cl
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %dl
; CHECK-32-NEXT:    movl %ecx, %eax
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_v2f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    cmpunordps %xmm0, %xmm0
; CHECK-64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <2 x i1> @llvm.is.fpclass.v2f32(<2 x float> %x, i32 3)  ; "nan"
  ret <2 x i1> %0
}


define <2 x i1> @isnot_nan_v2f(<2 x float> %x) {
; CHECK-32-LABEL: isnot_nan_v2f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setnp %cl
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setnp %dl
; CHECK-32-NEXT:    movl %ecx, %eax
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnot_nan_v2f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    cmpordps %xmm0, %xmm0
; CHECK-64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <2 x i1> @llvm.is.fpclass.v2f32(<2 x float> %x, i32 1020)  ; 0x3fc = "zero|subnormal|normal|inf"
  ret <2 x i1> %0
}

define <2 x i1> @isnan_v2f_strictfp(<2 x float> %x) strictfp {
; CHECK-32-LABEL: isnan_v2f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl $2147483647, %ecx # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    andl %ecx, %eax
; CHECK-32-NEXT:    cmpl $2139095041, %eax # imm = 0x7F800001
; CHECK-32-NEXT:    setge %al
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    cmpl $2139095041, %ecx # imm = 0x7F800001
; CHECK-32-NEXT:    setge %dl
; CHECK-32-NEXT:    retl
;
; CHECK-64-LABEL: isnan_v2f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,1,1,3]
; CHECK-64-NEXT:    andps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-64-NEXT:    pcmpgtd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <2 x i1> @llvm.is.fpclass.v2f32(<2 x float> %x, i32 3)  ; "nan"
  ret <2 x i1> %0
}

define <4 x i1> @isnan_v4f(<4 x float> %x) {
; CHECK-32-LABEL: isnan_v4f:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    flds {{[0-9]+}}(%esp)
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %dh
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %dl
; CHECK-32-NEXT:    addb %dl, %dl
; CHECK-32-NEXT:    orb %dh, %dl
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %dh
; CHECK-32-NEXT:    fucomp %st(0)
; CHECK-32-NEXT:    fnstsw %ax
; CHECK-32-NEXT:    # kill: def $ah killed $ah killed $ax
; CHECK-32-NEXT:    sahf
; CHECK-32-NEXT:    setp %al
; CHECK-32-NEXT:    addb %al, %al
; CHECK-32-NEXT:    orb %dh, %al
; CHECK-32-NEXT:    shlb $2, %al
; CHECK-32-NEXT:    orb %dl, %al
; CHECK-32-NEXT:    movb %al, (%ecx)
; CHECK-32-NEXT:    movl %ecx, %eax
; CHECK-32-NEXT:    retl $4
;
; CHECK-64-LABEL: isnan_v4f:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    cmpunordps %xmm0, %xmm0
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <4 x i1> @llvm.is.fpclass.v4f32(<4 x float> %x, i32 3)  ; "nan"
  ret <4 x i1> %0
}

define <4 x i1> @isnan_v4f_strictfp(<4 x float> %x) strictfp {
; CHECK-32-LABEL: isnan_v4f_strictfp:
; CHECK-32:       # %bb.0: # %entry
; CHECK-32-NEXT:    pushl %esi
; CHECK-32-NEXT:    .cfi_def_cfa_offset 8
; CHECK-32-NEXT:    .cfi_offset %esi, -8
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-32-NEXT:    movl $2147483647, %ecx # imm = 0x7FFFFFFF
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-32-NEXT:    andl %ecx, %edx
; CHECK-32-NEXT:    cmpl $2139095041, %edx # imm = 0x7F800001
; CHECK-32-NEXT:    setge %dh
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-32-NEXT:    andl %ecx, %esi
; CHECK-32-NEXT:    cmpl $2139095041, %esi # imm = 0x7F800001
; CHECK-32-NEXT:    setge %dl
; CHECK-32-NEXT:    addb %dl, %dl
; CHECK-32-NEXT:    orb %dh, %dl
; CHECK-32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-32-NEXT:    andl %ecx, %esi
; CHECK-32-NEXT:    cmpl $2139095041, %esi # imm = 0x7F800001
; CHECK-32-NEXT:    setge %dh
; CHECK-32-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; CHECK-32-NEXT:    cmpl $2139095041, %ecx # imm = 0x7F800001
; CHECK-32-NEXT:    setge %cl
; CHECK-32-NEXT:    addb %cl, %cl
; CHECK-32-NEXT:    orb %dh, %cl
; CHECK-32-NEXT:    shlb $2, %cl
; CHECK-32-NEXT:    orb %dl, %cl
; CHECK-32-NEXT:    movb %cl, (%eax)
; CHECK-32-NEXT:    popl %esi
; CHECK-32-NEXT:    .cfi_def_cfa_offset 4
; CHECK-32-NEXT:    retl $4
;
; CHECK-64-LABEL: isnan_v4f_strictfp:
; CHECK-64:       # %bb.0: # %entry
; CHECK-64-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-64-NEXT:    pcmpgtd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-64-NEXT:    retq
entry:
  %0 = tail call <4 x i1> @llvm.is.fpclass.v4f32(<4 x float> %x, i32 3)  ; "nan"
  ret <4 x i1> %0
}


declare i1 @llvm.is.fpclass.f32(float, i32)
declare i1 @llvm.is.fpclass.f64(double, i32)
declare <1 x i1> @llvm.is.fpclass.v1f32(<1 x float>, i32)
declare <2 x i1> @llvm.is.fpclass.v2f32(<2 x float>, i32)
declare <4 x i1> @llvm.is.fpclass.v4f32(<4 x float>, i32)
