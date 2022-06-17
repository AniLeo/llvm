; RUN: opt < %s -passes=sroa -S | FileCheck %s

target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

define i8 @test1() {
; We fully promote these to the i24 load or store size, resulting in just masks
; and other operations that instcombine will fold, but no alloca. Note this is
; the same as test12 in basictest.ll, but here we assert big-endian byte
; ordering.
;
; CHECK-LABEL: @test1(

entry:
  %a = alloca [3 x i8]
  %b = alloca [3 x i8]
; CHECK-NOT: alloca

  store i8 0, ptr %a
  %a1ptr = getelementptr [3 x i8], ptr %a, i64 0, i32 1
  store i8 0, ptr %a1ptr
  %a2ptr = getelementptr [3 x i8], ptr %a, i64 0, i32 2
  store i8 0, ptr %a2ptr
  %ai = load i24, ptr %a
; CHECK-NOT: store
; CHECK-NOT: load
; CHECK:      %[[ext2:.*]] = zext i8 0 to i24
; CHECK-NEXT: %[[mask2:.*]] = and i24 undef, -256
; CHECK-NEXT: %[[insert2:.*]] = or i24 %[[mask2]], %[[ext2]]
; CHECK-NEXT: %[[ext1:.*]] = zext i8 0 to i24
; CHECK-NEXT: %[[shift1:.*]] = shl i24 %[[ext1]], 8
; CHECK-NEXT: %[[mask1:.*]] = and i24 %[[insert2]], -65281
; CHECK-NEXT: %[[insert1:.*]] = or i24 %[[mask1]], %[[shift1]]
; CHECK-NEXT: %[[ext0:.*]] = zext i8 0 to i24
; CHECK-NEXT: %[[shift0:.*]] = shl i24 %[[ext0]], 16
; CHECK-NEXT: %[[mask0:.*]] = and i24 %[[insert1]], 65535
; CHECK-NEXT: %[[insert0:.*]] = or i24 %[[mask0]], %[[shift0]]

  store i24 %ai, ptr %b
  %b0 = load i8, ptr %b
  %b1ptr = getelementptr [3 x i8], ptr %b, i64 0, i32 1
  %b1 = load i8, ptr %b1ptr
  %b2ptr = getelementptr [3 x i8], ptr %b, i64 0, i32 2
  %b2 = load i8, ptr %b2ptr
; CHECK-NOT: store
; CHECK-NOT: load
; CHECK:      %[[shift0:.*]] = lshr i24 %[[insert0]], 16
; CHECK-NEXT: %[[trunc0:.*]] = trunc i24 %[[shift0]] to i8
; CHECK-NEXT: %[[shift1:.*]] = lshr i24 %[[insert0]], 8
; CHECK-NEXT: %[[trunc1:.*]] = trunc i24 %[[shift1]] to i8
; CHECK-NEXT: %[[trunc2:.*]] = trunc i24 %[[insert0]] to i8

  %bsum0 = add i8 %b0, %b1
  %bsum1 = add i8 %bsum0, %b2
  ret i8 %bsum1
; CHECK:      %[[sum0:.*]] = add i8 %[[trunc0]], %[[trunc1]]
; CHECK-NEXT: %[[sum1:.*]] = add i8 %[[sum0]], %[[trunc2]]
; CHECK-NEXT: ret i8 %[[sum1]]
}

define i64 @test2() {
; Test for various mixed sizes of integer loads and stores all getting
; promoted.
;
; CHECK-LABEL: @test2(

entry:
  %a = alloca [7 x i8]
; CHECK-NOT: alloca

  %a1ptr = getelementptr [7 x i8], ptr %a, i64 0, i32 1
  %a2ptr = getelementptr [7 x i8], ptr %a, i64 0, i32 2
  %a3ptr = getelementptr [7 x i8], ptr %a, i64 0, i32 3

; CHECK-NOT: store
; CHECK-NOT: load

  store i16 1, ptr %a

  store i8 1, ptr %a2ptr

  store i24 1, ptr %a3ptr

  store i40 1, ptr %a2ptr

; the alloca is splitted into multiple slices
; Here, i8 1 is for %a[6]
; CHECK: %[[ext1:.*]] = zext i8 1 to i40
; CHECK-NEXT: %[[mask1:.*]] = and i40 undef, -256
; CHECK-NEXT: %[[insert1:.*]] = or i40 %[[mask1]], %[[ext1]]

; Here, i24 0 is for %a[3] to %a[5]
; CHECK-NEXT: %[[ext2:.*]] = zext i24 0 to i40
; CHECK-NEXT: %[[shift2:.*]] = shl i40 %[[ext2]], 8
; CHECK-NEXT: %[[mask2:.*]] = and i40 %[[insert1]], -4294967041
; CHECK-NEXT: %[[insert2:.*]] = or i40 %[[mask2]], %[[shift2]]

; Here, i8 0 is for %a[2]
; CHECK-NEXT: %[[ext3:.*]] = zext i8 0 to i40
; CHECK-NEXT: %[[shift3:.*]] = shl i40 %[[ext3]], 32
; CHECK-NEXT: %[[mask3:.*]] = and i40 %[[insert2]], 4294967295
; CHECK-NEXT: %[[insert3:.*]] = or i40 %[[mask3]], %[[shift3]]

; CHECK-NEXT: %[[ext4:.*]] = zext i40 %[[insert3]] to i56
; CHECK-NEXT: %[[mask4:.*]] = and i56 undef, -1099511627776
; CHECK-NEXT: %[[insert4:.*]] = or i56 %[[mask4]], %[[ext4]]

; CHECK-NOT: store
; CHECK-NOT: load

  %ai = load i56, ptr %a
  %ret = zext i56 %ai to i64
  ret i64 %ret
; Here, i16 1 is for %a[0] to %a[1]
; CHECK-NEXT: %[[ext5:.*]] = zext i16 1 to i56
; CHECK-NEXT: %[[shift5:.*]] = shl i56 %[[ext5]], 40
; CHECK-NEXT: %[[mask5:.*]] = and i56 %[[insert4]], 1099511627775
; CHECK-NEXT: %[[insert5:.*]] = or i56 %[[mask5]], %[[shift5]]
; CHECK-NEXT: %[[ret:.*]] = zext i56 %[[insert5]] to i64
; CHECK-NEXT: ret i64 %[[ret]]
}

define i64 @PR14132(i1 %flag) {
; CHECK-LABEL: @PR14132(
; Here we form a PHI-node by promoting the pointer alloca first, and then in
; order to promote the other two allocas, we speculate the load of the
; now-phi-node-pointer. In doing so we end up loading a 64-bit value from an i8
; alloca. While this is a bit dubious, we were asserting on trying to
; rewrite it. The trick is that the code using the value may carefully take
; steps to only use the not-undef bits, and so we need to at least loosely
; support this. This test is particularly interesting because how we handle
; a load of an i64 from an i8 alloca is dependent on endianness.
entry:
  %a = alloca i64, align 8
  %b = alloca i8, align 8
  %ptr = alloca ptr, align 8
; CHECK-NOT: alloca

  store i64 0, ptr %a
  store i8 1, ptr %b
  store ptr %a, ptr %ptr
  br i1 %flag, label %if.then, label %if.end

if.then:
  store ptr %b, ptr %ptr
  br label %if.end
; CHECK-NOT: store
; CHECK: %[[ext:.*]] = zext i8 1 to i64
; CHECK: %[[shift:.*]] = shl i64 %[[ext]], 56

if.end:
  %tmp = load ptr, ptr %ptr
  %result = load i64, ptr %tmp
; CHECK-NOT: load
; CHECK: %[[result:.*]] = phi i64 [ %[[shift]], %if.then ], [ 0, %entry ]

  ret i64 %result
; CHECK-NEXT: ret i64 %[[result]]
}

declare void @f(i64 %x, i32 %y)

define void @test3() {
; CHECK-LABEL: @test3(
;
; This is a test that specifically exercises the big-endian lowering because it
; ends up splitting a 64-bit integer into two smaller integers and has a number
; of tricky aspects (the i24 type) that make that hard. Historically, SROA
; would miscompile this by either dropping a most significant byte or least
; significant byte due to shrinking the [4,8) slice to an i24, or by failing to
; move the bytes around correctly.
;
; The magical number 34494054408 is used because it has bits set in various
; bytes so that it is clear if those bytes fail to be propagated.
;
; If you're debugging this, rather than using the direct magical numbers, run
; the IR through '-sroa -instcombine'. With '-instcombine' these will be
; constant folded, and if the i64 doesn't round-trip correctly, you've found
; a bug!
;
entry:
  %a = alloca { i32, i24 }, align 4
; CHECK-NOT: alloca

  store i64 34494054408, ptr %a
  %tmp1 = load i64, ptr %a, align 4
  %tmp3 = load i32, ptr %a, align 4
; CHECK: %[[HI_EXT:.*]] = zext i32 134316040 to i64
; CHECK: %[[HI_INPUT:.*]] = and i64 undef, -4294967296
; CHECK: %[[HI_MERGE:.*]] = or i64 %[[HI_INPUT]], %[[HI_EXT]]
; CHECK: %[[LO_EXT:.*]] = zext i32 8 to i64
; CHECK: %[[LO_SHL:.*]] = shl i64 %[[LO_EXT]], 32
; CHECK: %[[LO_INPUT:.*]] = and i64 %[[HI_MERGE]], 4294967295
; CHECK: %[[LO_MERGE:.*]] = or i64 %[[LO_INPUT]], %[[LO_SHL]]

  call void @f(i64 %tmp1, i32 %tmp3)
; CHECK: call void @f(i64 %[[LO_MERGE]], i32 8)
  ret void
; CHECK: ret void
}

define void @test4() {
; CHECK-LABEL: @test4
;
; Much like @test3, this is specifically testing big-endian management of data.
; Also similarly, it uses constants with particular bits set to help track
; whether values are corrupted, and can be easily evaluated by running through
; -instcombine to see that the i64 round-trips.
;
entry:
  %a = alloca { i32, i24 }, align 4
  %a2 = alloca i64, align 4
; CHECK-NOT: alloca

  store i64 34494054408, ptr %a2
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %a, ptr align 4 %a2, i64 8, i1 false)
; CHECK: %[[LO_SHR:.*]] = lshr i64 34494054408, 32
; CHECK: %[[LO_START:.*]] = trunc i64 %[[LO_SHR]] to i32
; CHECK: %[[HI_START:.*]] = trunc i64 34494054408 to i32

  %tmp3 = load i64, ptr %a, align 4
  %tmp5 = load i32, ptr %a, align 4
; CHECK: %[[HI_EXT:.*]] = zext i32 %[[HI_START]] to i64
; CHECK: %[[HI_INPUT:.*]] = and i64 undef, -4294967296
; CHECK: %[[HI_MERGE:.*]] = or i64 %[[HI_INPUT]], %[[HI_EXT]]
; CHECK: %[[LO_EXT:.*]] = zext i32 %[[LO_START]] to i64
; CHECK: %[[LO_SHL:.*]] = shl i64 %[[LO_EXT]], 32
; CHECK: %[[LO_INPUT:.*]] = and i64 %[[HI_MERGE]], 4294967295
; CHECK: %[[LO_MERGE:.*]] = or i64 %[[LO_INPUT]], %[[LO_SHL]]

  call void @f(i64 %tmp3, i32 %tmp5)
; CHECK: call void @f(i64 %[[LO_MERGE]], i32 %[[LO_START]])
  ret void
; CHECK: ret void
}

declare void @llvm.memcpy.p0.p0.i64(ptr, ptr, i64, i1)
