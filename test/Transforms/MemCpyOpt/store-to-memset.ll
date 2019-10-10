; RUN: opt < %s -memcpyopt -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

define i8* @foo(i8* returned %0, i32 %1, i64 %2) {
entry:
  %3 = getelementptr inbounds i8, i8* %0, i64 %2
  %4 = getelementptr inbounds i8, i8* %3, i64 -32
  %vv = trunc i32 %1 to i8
  store i8 %vv, i8* %4, align 1
  %5 = getelementptr inbounds i8, i8* %4, i64 1
  store i8 %vv, i8* %5, align 1
  %6= getelementptr inbounds i8, i8* %4, i64 2
  store i8 %vv, i8* %6, align 1
  %7= getelementptr inbounds i8, i8* %4, i64 3
  store i8 %vv, i8* %7, align 1
  %8= getelementptr inbounds i8, i8* %4, i64 4
  store i8 %vv, i8* %8, align 1
  %9= getelementptr inbounds i8, i8* %4, i64 5
  store i8 %vv, i8* %9, align 1
  %10= getelementptr inbounds i8, i8* %4, i64 6
  store i8 %vv, i8* %10, align 1
  %11= getelementptr inbounds i8, i8* %4, i64 7
  store i8 %vv, i8* %11, align 1
  %12= getelementptr inbounds i8, i8* %4, i64 8
  store i8 %vv, i8* %12, align 1
  %13= getelementptr inbounds i8, i8* %4, i64 9
  store i8 %vv, i8* %13, align 1
  %14= getelementptr inbounds i8, i8* %4, i64 10
  store i8 %vv, i8* %14, align 1
  %15= getelementptr inbounds i8, i8* %4, i64 11
  store i8 %vv, i8* %15, align 1
  %16= getelementptr inbounds i8, i8* %4, i64 12
  store i8 %vv, i8* %16, align 1
  %17= getelementptr inbounds i8, i8* %4, i64 13
  store i8 %vv, i8* %17, align 1
  %18= getelementptr inbounds i8, i8* %4, i64 14
  store i8 %vv, i8* %18, align 1
  %19= getelementptr inbounds i8, i8* %4, i64 15
  store i8 %vv, i8* %19, align 1
  %20= getelementptr inbounds i8, i8* %4, i64 16
  store i8 %vv, i8* %20, align 1
  %21= getelementptr inbounds i8, i8* %20, i64 1
  store i8 %vv, i8* %21, align 1
  %22= getelementptr inbounds i8, i8* %20, i64 2
  store i8 %vv, i8* %22, align 1
  %23= getelementptr inbounds i8, i8* %20, i64 3
  store i8 %vv, i8* %23, align 1
  %24= getelementptr inbounds i8, i8* %20, i64 4
  store i8 %vv, i8* %24, align 1
  %25= getelementptr inbounds i8, i8* %20, i64 5
  store i8 %vv, i8* %25, align 1
  %26= getelementptr inbounds i8, i8* %20, i64 6
  store i8 %vv, i8* %26, align 1
  %27= getelementptr inbounds i8, i8* %20, i64 7
  store i8 %vv, i8* %27, align 1
  %28= getelementptr inbounds i8, i8* %20, i64 8
  store i8 %vv, i8* %28, align 1
  %29= getelementptr inbounds i8, i8* %20, i64 9
  store i8 %vv, i8* %29, align 1
  %30= getelementptr inbounds i8, i8* %20, i64 10
  store i8 %vv, i8* %30, align 1
  %31 = getelementptr inbounds i8, i8* %20, i64 11
  store i8 %vv, i8* %31, align 1
  %32 = getelementptr inbounds i8, i8* %20, i64 12
  store i8 %vv, i8* %32, align 1
  %33 = getelementptr inbounds i8, i8* %20, i64 13
  store i8 %vv, i8* %33, align 1
  %34 = getelementptr inbounds i8, i8* %20, i64 14
  store i8 %vv, i8* %34, align 1
  %35 = getelementptr inbounds i8, i8* %20, i64 15
  store i8 %vv, i8* %35, align 1
  ret i8* %0
; CHECK-LABEL: @foo
; CHECK: call void @llvm.memset.p0i8.i64(i8* align 1 %4, i8 %vv, i64 32, i1 false)
}

