; RUN: opt -memcpyopt -S -o - < %s | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.14.0"

%my_struct = type { i8, i32 }

; Function Attrs: inaccessiblemem_or_argmemonly
declare noalias i8* @my_malloc(%my_struct*) #0

define void @my_func(%my_struct* %0) {
entry:
; CHECK: entry:
  %1 = load %my_struct, %my_struct* %0
  %2 = call i8* @my_malloc(%my_struct* %0)
  %3 = bitcast i8* %2 to %my_struct*
  store %my_struct %1, %my_struct* %3
; CHECK-NOT: call void @llvm.memcpy.{{.*}}.{{.*}}.{{.*}}
  ret void
}

attributes #0 = { inaccessiblemem_or_argmemonly }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 14]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"Apple LLVM version 10.0.1 (clang-1001.0.46.4)"}
