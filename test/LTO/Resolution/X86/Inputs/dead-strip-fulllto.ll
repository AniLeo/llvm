target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @live1() {
  call void @live2()
  ret void
}

declare void @live2()

define void @dead1() {
  call void @dead2()
  ret void
}

declare void @dead2()
