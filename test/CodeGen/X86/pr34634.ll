; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@a = common local_unnamed_addr global [1 x [10 x i32]] zeroinitializer, align 16
@c = common local_unnamed_addr global i32 0, align 4
@b = common local_unnamed_addr global [1 x [7 x i32]] zeroinitializer, align 16

; Function Attrs: norecurse nounwind uwtable
define void @fn1() local_unnamed_addr #0 {
; CHECK-LABEL: fn1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movslq {{.*}}(%rip), %rax
; CHECK-NEXT:    leaq (%rax,%rax,4), %rcx
; CHECK-NEXT:    leaq (,%rax,4), %rdx
; CHECK-NEXT:    movl a(%rdx,%rcx,8), %ecx
; CHECK-NEXT:    leaq (%rax,%rax,8), %rdx
; CHECK-NEXT:    leaq (%rdx,%rdx,2), %rdx
; CHECK-NEXT:    addq %rax, %rdx
; CHECK-NEXT:    movl %ecx, b(%rdx,%rax,4)
; CHECK-NEXT:    retq
entry:
  %0 = load i32, i32* @c, align 4, !tbaa !2
  %idxprom = sext i32 %0 to i64
  %arrayidx2 = getelementptr inbounds [1 x [10 x i32]], [1 x [10 x i32]]* @a, i64 0, i64 %idxprom, i64 %idxprom
  %1 = load i32, i32* %arrayidx2, align 4, !tbaa !2
  %arrayidx6 = getelementptr inbounds [1 x [7 x i32]], [1 x [7 x i32]]* @b, i64 0, i64 %idxprom, i64 %idxprom
  store i32 %1, i32* %arrayidx6, align 4, !tbaa !2
  ret void
}

; Function Attrs: norecurse nounwind uwtable
define i32 @main() local_unnamed_addr #0 {
; CHECK-LABEL: main:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movslq {{.*}}(%rip), %rax
; CHECK-NEXT:    leaq (%rax,%rax,4), %rcx
; CHECK-NEXT:    leaq (,%rax,4), %rdx
; CHECK-NEXT:    movl a(%rdx,%rcx,8), %ecx
; CHECK-NEXT:    leaq (%rax,%rax,8), %rdx
; CHECK-NEXT:    leaq (%rdx,%rdx,2), %rdx
; CHECK-NEXT:    addq %rax, %rdx
; CHECK-NEXT:    movl %ecx, b(%rdx,%rax,4)
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retq
entry:
  %0 = load i32, i32* @c, align 4, !tbaa !2
  %idxprom.i = sext i32 %0 to i64
  %arrayidx2.i = getelementptr inbounds [1 x [10 x i32]], [1 x [10 x i32]]* @a, i64 0, i64 %idxprom.i, i64 %idxprom.i
  %1 = load i32, i32* %arrayidx2.i, align 4, !tbaa !2
  %arrayidx6.i = getelementptr inbounds [1 x [7 x i32]], [1 x [7 x i32]]* @b, i64 0, i64 %idxprom.i, i64 %idxprom.i
  store i32 %1, i32* %arrayidx6.i, align 4, !tbaa !2
  ret i32 0
}

attributes #0 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
