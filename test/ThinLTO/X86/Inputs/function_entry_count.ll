target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare void @h();

define void @g() {
  call void @h();
  ret void
}
