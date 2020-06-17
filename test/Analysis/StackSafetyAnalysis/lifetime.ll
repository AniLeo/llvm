; RUN: opt -passes='print<stack-lifetime>' -disable-output %s 2>&1 | FileCheck %s

define void @f() {
; CHECK-LABEL: define void @f()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  %z0 = bitcast i32* %z to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <z>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x z>

  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <z>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <y z>

  call void @capture32(i32* %y)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <z>

  call void @capture32(i32* %z)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @no_markers() {
; CHECK-LABEL: define void @no_markers()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <y>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x y>

  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <y>

  call void @capture32(i32* %y)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <y>
}

define void @g() {
; CHECK-LABEL: define void @g()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i64, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  %z0 = bitcast i64* %z to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <x y>

  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <y>

  call void @capture32(i32* %y)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <z>

  call void @capture64(i64* %z)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @h() {
; CHECK-LABEL: define void @h()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 16
  %z = alloca i64, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  %z0 = bitcast i64* %z to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <x y>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <x y z>

  call void @capture32(i32* %x)
  call void @capture32(i32* %y)
  call void @capture64(i64* %z)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <y z>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <z>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %z0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @i(i1 zeroext %a, i1 zeroext %b) {
; CHECK-LABEL: define void @i(i1 zeroext %a, i1 zeroext %b)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x1 = alloca i64, align 8
  %x2 = alloca i64, align 8
  %y = alloca i64, align 8
  %y1 = alloca i64, align 8
  %y2 = alloca i64, align 8
  %z = alloca i64, align 8
  %z1 = alloca i64, align 8
  %z2 = alloca i64, align 8
  %0 = bitcast i64* %x1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <x1>

  %1 = bitcast i64* %x2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <x1 x2>

  call void @capture64(i64* nonnull %x1)
  call void @capture64(i64* nonnull %x2)
  br i1 %a, label %if.then, label %if.else4
; CHECK: br i1 %a, label %if.then, label %if.else4
; CHECK-NEXT: Alive: <x1 x2>

if.then:                                          ; preds = %entry
; CHECK: if.then:
; CHECK-NEXT: Alive: <x1 x2>
  %2 = bitcast i64* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
; CHECK-NEXT: Alive: <x1 x2 y>

  call void @capture64(i64* nonnull %y)
  br i1 %b, label %if.then3, label %if.else
; CHECK: br i1 %b, label %if.then3, label %if.else
; CHECK-NEXT: Alive: <x1 x2 y>

if.then3:                                         ; preds = %if.then
; CHECK: if.then3:
; CHECK-NEXT: Alive: <x1 x2 y>
  %3 = bitcast i64* %y1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %3)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %3)
; CHECK-NEXT: Alive: <x1 x2 y y1>

  call void @capture64(i64* nonnull %y1)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %3)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %3)
; CHECK-NEXT: Alive: <x1 x2 y>

  br label %if.end
; CHECK: br label %if.end
; CHECK-NEXT: Alive: <x1 x2 y>

if.else:                                          ; preds = %if.then
; CHECK: if.else:
; CHECK-NEXT: Alive: <x1 x2 y>
  %4 = bitcast i64* %y2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %4)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %4)
; CHECK-NEXT: Alive: <x1 x2 y y2>

  call void @capture64(i64* nonnull %y2)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %4)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %4)
; CHECK-NEXT: Alive: <x1 x2 y>

  br label %if.end
; CHECK: br label %if.end
; CHECK-NEXT: Alive: <x1 x2 y>

if.end:                                           ; preds = %if.else, %if.then3
; CHECK: if.end:
; CHECK-NEXT: Alive: <x1 x2 y>
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %2)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %2)
; CHECK-NEXT: Alive: <x1 x2>

  br label %if.end9
; CHECK: br label %if.end9
; CHECK-NEXT: Alive: <x1 x2>

if.else4:                                         ; preds = %entry
; CHECK: if.else4:
; CHECK-NEXT: Alive: <x1 x2>
  %5 = bitcast i64* %z to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %5)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %5)
; CHECK-NEXT: Alive: <x1 x2 z>

  call void @capture64(i64* nonnull %z)
  br i1 %b, label %if.then6, label %if.else7
; CHECK: br i1 %b, label %if.then6, label %if.else7
; CHECK-NEXT: Alive: <x1 x2 z>

if.then6:                                         ; preds = %if.else4
; CHECK: if.then6:
; CHECK-NEXT: Alive: <x1 x2 z>
  %6 = bitcast i64* %z1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %6)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %6)
; CHECK-NEXT: Alive: <x1 x2 z z1>

  call void @capture64(i64* nonnull %z1)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %6)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %6)
; CHECK-NEXT: Alive: <x1 x2 z>

  br label %if.end8
; CHECK: br label %if.end8
; CHECK-NEXT: Alive: <x1 x2 z>

if.else7:                                         ; preds = %if.else4
; CHECK: if.else7:
; CHECK-NEXT: Alive: <x1 x2 z>
  %7 = bitcast i64* %z2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %7)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %7)
; CHECK-NEXT: Alive: <x1 x2 z z2>

  call void @capture64(i64* nonnull %z2)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %7)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %7)
; CHECK-NEXT: Alive: <x1 x2 z>

  br label %if.end8
; CHECK: br label %if.end8
; CHECK-NEXT: Alive: <x1 x2 z>

if.end8:                                          ; preds = %if.else7, %if.then6
; CHECK: if.end8:
; CHECK-NEXT: Alive: <x1 x2 z>
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %5)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %5)
; CHECK-NEXT: Alive: <x1 x2>

  br label %if.end9
; CHECK: br label %if.end9
; CHECK-NEXT: Alive: <x1 x2>

if.end9:                                          ; preds = %if.end8, %if.end
; CHECK: if.end9:
; CHECK-NEXT: Alive: <x1 x2>
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <x1>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @no_merge1(i1 %d) {
; CHECK-LABEL: define void @no_merge1(i1 %d)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @capture32(i32* %x)
  br i1 %d, label %bb2, label %bb3
; CHECK: br i1 %d, label %bb2, label %bb3
; CHECK-NEXT: Alive: <x>

bb2:                                              ; preds = %entry
; CHECK: bb2:
; CHECK-NEXT: Alive: <x>
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <x y>

  call void @capture32(i32* %y)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <x>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>

bb3:                                              ; preds = %entry
; CHECK: bb3:
; CHECK-NEXT: Alive: <x>
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @merge1(i1 %d) {
; CHECK-LABEL: define void @merge1(i1 %d)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <>

  br i1 %d, label %bb2, label %bb3
; CHECK: br i1 %d, label %bb2, label %bb3
; CHECK-NEXT: Alive: <>

bb2:                                              ; preds = %entry
; CHECK: bb2:
; CHECK-NEXT: Alive: <>
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <y>

  call void @capture32(i32* %y)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>

bb3:                                              ; preds = %entry
; CHECK: bb3:
; CHECK-NEXT: Alive: <>
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @merge2_noend(i1 %d) {
; CHECK-LABEL: define void @merge2_noend(i1 %d)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <>

  br i1 %d, label %bb2, label %bb3
; CHECK: br i1 %d, label %bb2, label %bb3
; CHECK-NEXT: Alive: <>

bb2:                                              ; preds = %entry
; CHECK: bb2:
; CHECK-NEXT: Alive: <>
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <y>

  call void @capture32(i32* %y)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <y>

bb3:                                              ; preds = %entry
; CHECK: bb3:
; CHECK-NEXT: Alive: <>
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @merge3_noend(i1 %d) {
; CHECK-LABEL: define void @merge3_noend(i1 %d)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  call void @capture32(i32* %x)
  br i1 %d, label %bb2, label %bb3
; CHECK: br i1 %d, label %bb2, label %bb3
; CHECK-NEXT: Alive: <x>

bb2:                                              ; preds = %entry
; CHECK: bb2:
; CHECK-NEXT: Alive: <x>
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <y>

  call void @capture32(i32* %y)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <y>

bb3:                                              ; preds = %entry
; CHECK: bb3:
; CHECK-NEXT: Alive: <x>
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <x>
}

define void @nomerge4_nostart(i1 %d) {
; CHECK-LABEL: define void @nomerge4_nostart(i1 %d)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <x>
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %x0 = bitcast i32* %x to i8*
  %y0 = bitcast i32* %y to i8*
  call void @capture32(i32* %x)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %x0)
; CHECK-NEXT: Alive: <x>

  br i1 %d, label %bb2, label %bb3
; CHECK: br i1 %d, label %bb2, label %bb3
; CHECK-NEXT: Alive: <x>

bb2:                                              ; preds = %entry
; CHECK: bb2:
; CHECK-NEXT: Alive: <x>
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %y0)
; CHECK-NEXT: Alive: <x y>

  call void @capture32(i32* %y)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <x y>

bb3:                                              ; preds = %entry
; CHECK: bb3:
; CHECK-NEXT: Alive: <x>
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <x>
}

define void @array_merge() {
; CHECK-LABEL: define void @array_merge()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %A.i1 = alloca [100 x i32], align 4
  %B.i2 = alloca [100 x i32], align 4
  %A.i = alloca [100 x i32], align 4
  %B.i = alloca [100 x i32], align 4
  %0 = bitcast [100 x i32]* %A.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <A.i>

  %1 = bitcast [100 x i32]* %B.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <A.i B.i>

  call void @capture100x32([100 x i32]* %A.i)
  call void @capture100x32([100 x i32]* %B.i)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <B.i>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <>

  %2 = bitcast [100 x i32]* %A.i1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
; CHECK-NEXT: Alive: <A.i1>

  %3 = bitcast [100 x i32]* %B.i2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %3)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %3)
; CHECK-NEXT: Alive: <A.i1 B.i2>

  call void @capture100x32([100 x i32]* %A.i1)
  call void @capture100x32([100 x i32]* %B.i2)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %2)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %2)
; CHECK-NEXT: Alive: <B.i2>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %3)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %3)
; CHECK-NEXT: Alive: <>

  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <>
}

define void @myCall_pr15707() {
; CHECK-LABEL: define void @myCall_pr15707()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %buf1 = alloca i8, i32 100000, align 16
  %buf2 = alloca i8, i32 100000, align 16
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf1)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf1)
; CHECK-NEXT: Alive: <buf1>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %buf1)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %buf1)
; CHECK-NEXT: Alive: <>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf1)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf1)
; CHECK-NEXT: Alive: <buf1>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf2)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %buf2)
; CHECK-NEXT: Alive: <buf1 buf2>

  call void @capture8(i8* %buf1)
  call void @capture8(i8* %buf2)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <buf1 buf2>
}

define void @bad_range() {
; CHECK-LABEL: define void @bad_range()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <A.i1 B.i2>
  %A.i1 = alloca [100 x i32], align 4
  %B.i2 = alloca [100 x i32], align 4
  %A.i = alloca [100 x i32], align 4
  %B.i = alloca [100 x i32], align 4
  %0 = bitcast [100 x i32]* %A.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <A.i A.i1 B.i2>

  %1 = bitcast [100 x i32]* %B.i to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <A.i A.i1 B.i B.i2>

  call void @capture100x32([100 x i32]* %A.i)
  call void @capture100x32([100 x i32]* %B.i)
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %0)
; CHECK-NEXT: Alive: <A.i1 B.i B.i2>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %1)
; CHECK-NEXT: Alive: <A.i1 B.i2>

  br label %block2
; CHECK: br label %block2
; CHECK-NEXT: Alive: <A.i1 B.i2>

block2:                                           ; preds = %entry
; CHECK: block2:
; CHECK-NEXT: Alive: <A.i1 B.i2>
  call void @capture100x32([100 x i32]* %A.i)
  call void @capture100x32([100 x i32]* %B.i)
  ret void
; CHECK: ret void
; CHECK-NEXT: Alive: <A.i1 B.i2>
}

%struct.Klass = type { i32, i32 }

define i32 @shady_range(i32 %argc, i8** nocapture %argv) {
; CHECK-LABEL: define i32 @shady_range(i32 %argc, i8** nocapture %argv)
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %a.i = alloca [4 x %struct.Klass], align 16
  %b.i = alloca [4 x %struct.Klass], align 16
  %a8 = bitcast [4 x %struct.Klass]* %a.i to i8*
  %b8 = bitcast [4 x %struct.Klass]* %b.i to i8*
  %z2 = getelementptr inbounds [4 x %struct.Klass], [4 x %struct.Klass]* %a.i, i64 0, i64 0, i32 0
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %a8)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %a8)
; CHECK-NEXT: Alive: <a.i>

  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %b8)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 -1, i8* %b8)
; CHECK-NEXT: Alive: <a.i b.i>

  call void @capture8(i8* %a8)
  call void @capture8(i8* %b8)
  %z3 = load i32, i32* %z2, align 16
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %a8)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %a8)
; CHECK-NEXT: Alive: <b.i>

  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %b8)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 -1, i8* %b8)
; CHECK-NEXT: Alive: <>

  ret i32 %z3
; CHECK: ret i32 %z3
; CHECK-NEXT: Alive: <>
}

define void @end_loop() {
; CHECK-LABEL: define void @end_loop()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i8, align 4
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK-NEXT: Alive: <x>

  br label %l2
; CHECK: br label %l2
; CHECK-NEXT: Alive: <x>

l2:                                               ; preds = %l2, %entry
; CHECK: l2:
; CHECK-NEXT: Alive: <x>
  call void @capture8(i8* %x)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %x)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 4, i8* %x)
; CHECK-NEXT: Alive: <>

  br label %l2
; CHECK: br label %l2
; CHECK-NEXT: Alive: <>
}

define void @start_loop() {
; CHECK-LABEL: define void @start_loop()
entry:
; CHECK: entry:
; CHECK-NEXT: Alive: <>
  %x = alloca i8, align 4
  %y = alloca i8, align 4
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK-NEXT: Alive: <x>

  br label %l2
; CHECK: br label %l2
; CHECK-NEXT: Alive: <x>

l2:                                               ; preds = %l2, %entry
; CHECK: l2:
; CHECK-NEXT: Alive: <x>
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %y)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 4, i8* %y)
; CHECK-NEXT: Alive: <x y>

  call void @capture8(i8* %y)
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %y)
; CHECK: call void @llvm.lifetime.end.p0i8(i64 4, i8* %y)
; CHECK-NEXT: Alive: <x>

  call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK: call void @llvm.lifetime.start.p0i8(i64 4, i8* %x)
; CHECK-NEXT: Alive: <x>

  call void @capture8(i8* %x)
  br label %l2
; CHECK: br label %l2
; CHECK-NEXT: Alive: <x>
}

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture)
declare void @capture8(i8*)
declare void @capture32(i32*)
declare void @capture64(i64*)
declare void @capture100x32([100 x i32]*)
