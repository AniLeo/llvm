target datalayout = "e-m:e-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

define i32 @main() #0 {
entry:
  call void @foo()
  ret i32 0
}

declare void @foo()
