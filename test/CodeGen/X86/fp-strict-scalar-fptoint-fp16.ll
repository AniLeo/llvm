; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512fp16 -mattr=+avx512vl -O3 | FileCheck %s --check-prefixes=X64

declare i1  @llvm.experimental.constrained.fptosi.i1.f16(half, metadata)
declare i8  @llvm.experimental.constrained.fptosi.i8.f16(half, metadata)
declare i16 @llvm.experimental.constrained.fptosi.i16.f16(half, metadata)
declare i32 @llvm.experimental.constrained.fptosi.i32.f16(half, metadata)
declare i64 @llvm.experimental.constrained.fptosi.i64.f16(half, metadata)
declare i1  @llvm.experimental.constrained.fptoui.i1.f16(half, metadata)
declare i8  @llvm.experimental.constrained.fptoui.i8.f16(half, metadata)
declare i16 @llvm.experimental.constrained.fptoui.i16.f16(half, metadata)
declare i32 @llvm.experimental.constrained.fptoui.i32.f16(half, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f16(half, metadata)

define i1 @fptosi_f16toi1(half %x) #0 {
; X86-LABEL: fptosi_f16toi1:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi1:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i1 @llvm.experimental.constrained.fptosi.i1.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i1 %result
}

define i8 @fptosi_f16toi8(half %x) #0 {
; X86-LABEL: fptosi_f16toi8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i8 @llvm.experimental.constrained.fptosi.i8.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i8 %result
}

define i16 @fptosi_f16toi16(half %x) #0 {
; X86-LABEL: fptosi_f16toi16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %result = call i16 @llvm.experimental.constrained.fptosi.i16.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i16 %result
}

define i32 @fptosi_f16toi32(half %x) #0 {
; X86-LABEL: fptosi_f16toi32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    retq
  %result = call i32 @llvm.experimental.constrained.fptosi.i32.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @fptosi_f16toi64(half %x) #0 {
; X86-LABEL: fptosi_f16toi64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2qq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: fptosi_f16toi64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %rax
; X64-NEXT:    retq
  %result = call i64 @llvm.experimental.constrained.fptosi.i64.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

define i1 @fptoui_f16toi1(half %x) #0 {
; X86-LABEL: fptoui_f16toi1:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi1:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i1 @llvm.experimental.constrained.fptoui.i1.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i1 %result
}

define i8 @fptoui_f16toi8(half %x) #0 {
; X86-LABEL: fptoui_f16toi8:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi8:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %result = call i8 @llvm.experimental.constrained.fptoui.i8.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i8 %result
}

define i16 @fptoui_f16toi16(half %x) #0 {
; X86-LABEL: fptoui_f16toi16:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2si {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi16:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2si %xmm0, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %result = call i16 @llvm.experimental.constrained.fptoui.i16.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i16 %result
}

define i32 @fptoui_f16toi32(half %x) #0 {
; X86-LABEL: fptoui_f16toi32:
; X86:       # %bb.0:
; X86-NEXT:    vcvttsh2usi {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi32:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %eax
; X64-NEXT:    retq
  %result = call i32 @llvm.experimental.constrained.fptoui.i32.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i32 %result
}

define i64 @fptoui_f16toi64(half %x) #0 {
; X86-LABEL: fptoui_f16toi64:
; X86:       # %bb.0:
; X86-NEXT:    vmovsh {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    vcvttph2uqq %xmm0, %xmm0
; X86-NEXT:    vmovd %xmm0, %eax
; X86-NEXT:    vpextrd $1, %xmm0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: fptoui_f16toi64:
; X64:       # %bb.0:
; X64-NEXT:    vcvttsh2usi %xmm0, %rax
; X64-NEXT:    retq
  %result = call i64 @llvm.experimental.constrained.fptoui.i64.f16(half %x,
                                               metadata !"fpexcept.strict") #0
  ret i64 %result
}

attributes #0 = { strictfp }
