; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+mmx \
; RUN:     -enable-legalize-types-checking \
; RUN:     -disable-strictnode-mutation | FileCheck %s
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+mmx \
; RUN:     -enable-legalize-types-checking \
; RUN:     -disable-strictnode-mutation | FileCheck %s

; Check all soft floating point library function calls.

define fp128 @add(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __addtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %add = call fp128 @llvm.experimental.constrained.fadd.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %add
}

define fp128 @sub(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __subtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %sub = call fp128 @llvm.experimental.constrained.fsub.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sub
}

define fp128 @mul(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __multf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %mul = call fp128 @llvm.experimental.constrained.fmul.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %mul
}

define fp128 @div(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: div:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __divtf3
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %div = call fp128 @llvm.experimental.constrained.fdiv.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %div
}

define fp128 @fma(fp128 %x, fp128 %y, fp128 %z) nounwind strictfp {
; CHECK-LABEL: fma:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmal
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %fma = call fp128 @llvm.experimental.constrained.fma.f128(fp128 %x, fp128 %y,  fp128 %z, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %fma
}

define fp128 @frem(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: frem:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmodl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %div = call fp128 @llvm.experimental.constrained.frem.f128(fp128 %x, fp128 %y,  metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %div
}

define fp128 @ceil(fp128 %x) nounwind strictfp {
; CHECK-LABEL: ceil:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq ceill
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %ceil = call fp128 @llvm.experimental.constrained.ceil.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %ceil
}

define fp128 @cos(fp128 %x) nounwind strictfp {
; CHECK-LABEL: cos:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq cosl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %cos = call fp128 @llvm.experimental.constrained.cos.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %cos
}

define fp128 @exp(fp128 %x) nounwind strictfp {
; CHECK-LABEL: exp:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq expl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %exp = call fp128 @llvm.experimental.constrained.exp.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %exp
}

define fp128 @exp2(fp128 %x) nounwind strictfp {
; CHECK-LABEL: exp2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq exp2l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %exp2 = call fp128 @llvm.experimental.constrained.exp2.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %exp2
}

define fp128 @floor(fp128 %x) nounwind strictfp {
; CHECK-LABEL: floor:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq floorl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %floor = call fp128 @llvm.experimental.constrained.floor.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %floor
}

define fp128 @log(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq logl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %log = call fp128 @llvm.experimental.constrained.log.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log
}

define fp128 @log10(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq log10l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %log10 = call fp128 @llvm.experimental.constrained.log10.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log10
}

define fp128 @log2(fp128 %x) nounwind strictfp {
; CHECK-LABEL: log2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq log2l
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %log2 = call fp128 @llvm.experimental.constrained.log2.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %log2
}

define fp128 @maxnum(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: maxnum:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fmaxl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %maxnum = call fp128 @llvm.experimental.constrained.maxnum.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %maxnum
}

define fp128 @minnum(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: minnum:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq fminl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %minnum = call fp128 @llvm.experimental.constrained.minnum.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %minnum
}

define fp128 @nearbyint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: nearbyint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq nearbyintl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %nearbyint = call fp128 @llvm.experimental.constrained.nearbyint.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %nearbyint
}

define fp128 @pow(fp128 %x, fp128 %y) nounwind strictfp {
; CHECK-LABEL: pow:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq powl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %pow = call fp128 @llvm.experimental.constrained.pow.f128(fp128 %x, fp128 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %pow
}

define fp128 @powi(fp128 %x, i32 %y) nounwind strictfp {
; CHECK-LABEL: powi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq __powitf2
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %powi = call fp128 @llvm.experimental.constrained.powi.f128(fp128 %x, i32 %y, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %powi
}

define fp128 @rint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: rint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq rintl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %rint = call fp128 @llvm.experimental.constrained.rint.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %rint
}

define fp128 @round(fp128 %x) nounwind strictfp {
; CHECK-LABEL: round:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq roundl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %round = call fp128 @llvm.experimental.constrained.round.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %round
}

define fp128 @sin(fp128 %x) nounwind strictfp {
; CHECK-LABEL: sin:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq sinl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %sin = call fp128 @llvm.experimental.constrained.sin.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sin
}

define fp128 @sqrt(fp128 %x) nounwind strictfp {
; CHECK-LABEL: sqrt:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq sqrtl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %sqrt = call fp128 @llvm.experimental.constrained.sqrt.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %sqrt
}

define fp128 @trunc(fp128 %x) nounwind strictfp {
; CHECK-LABEL: trunc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq truncl
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %trunc = call fp128 @llvm.experimental.constrained.trunc.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret fp128 %trunc
}

define i32 @lrint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: lrint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq lrintl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %rint = call i32 @llvm.experimental.constrained.lrint.i32.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret i32 %rint
}

define i64 @llrint(fp128 %x) nounwind strictfp {
; CHECK-LABEL: llrint:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq llrintl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %rint = call i64 @llvm.experimental.constrained.llrint.i64.f128(fp128 %x, metadata !"round.dynamic", metadata !"fpexcept.strict") #0
  ret i64 %rint
}

define i32 @lround(fp128 %x) nounwind strictfp {
; CHECK-LABEL: lround:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq lroundl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %round = call i32 @llvm.experimental.constrained.lround.i32.f128(fp128 %x, metadata !"fpexcept.strict") #0
  ret i32 %round
}

define i64 @llround(fp128 %x) nounwind strictfp {
; CHECK-LABEL: llround:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    callq llroundl
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
entry:
  %round = call i64 @llvm.experimental.constrained.llround.i64.f128(fp128 %x, metadata !"fpexcept.strict") #0
  ret i64 %round
}

attributes #0 = { strictfp }

declare fp128 @llvm.experimental.constrained.fadd.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fsub.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fmul.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fdiv.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fma.f128(fp128, fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.frem.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.ceil.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.cos.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.exp.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.exp2.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.floor.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log10.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.log2.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.maxnum.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.minnum.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.nearbyint.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.pow.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.powi.f128(fp128, i32, metadata, metadata)
declare fp128 @llvm.experimental.constrained.rint.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.round.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sin.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sqrt.f128(fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.trunc.f128(fp128, metadata, metadata)
declare i32 @llvm.experimental.constrained.lrint.i32.f128(fp128, metadata, metadata)
declare i64 @llvm.experimental.constrained.llrint.i64.f128(fp128, metadata, metadata)
declare i32 @llvm.experimental.constrained.lround.i32.f128(fp128, metadata)
declare i64 @llvm.experimental.constrained.llround.i64.f128(fp128, metadata)
