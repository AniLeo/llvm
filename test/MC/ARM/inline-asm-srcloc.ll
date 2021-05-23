; RUN: not llc -filetype=obj 2>&1 -o /dev/null < %s | FileCheck %s

; ModuleID = '/scratch/llvm/master/tools/clang/test/Misc/inline-asm-diags.c'
source_filename = "/scratch/llvm/master/tools/clang/test/Misc/inline-asm-diags.c"
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv7-arm-none-eabi"

; Function Attrs: noinline nounwind
define void @foo2() #0 {
entry:
  call void asm sideeffect " wibble", ""() #1, !srcloc !3
; CHECK: note: !srcloc = 107
  ret void
}

; Function Attrs: noinline nounwind
define void @foo() #0 {
entry:
  call void asm sideeffect " .word -bar", ""() #1, !srcloc !4
; CHECK: note: !srcloc = 181
  call void asm sideeffect " .word -foo", ""() #1, !srcloc !5
; CHECK: note: !srcloc = 257
  ret void
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a8" "target-features"="+dsp,+neon,+strict-align,+vfp3" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 4}
!2 = !{!"clang version 5.0.0 "}
!3 = !{i32 107}
!4 = !{i32 181}
!5 = !{i32 257}
