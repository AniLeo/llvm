; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --arm-memtransfer-tploop=allow -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve --verify-machineinstrs %s -o - | FileCheck %s

; Check that WLSTP loop is not generated for alignment < 4
; void test1(char* dest, char* src, int n){
;    memcpy(dest, src, n);
; }

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i32, i1 immarg) #1
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i1 immarg)

define void @test1(i8* noalias nocapture %X, i8* noalias nocapture readonly %Y, i32 %n){
; CHECK-LABEL: test1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bl __aeabi_memcpy
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %X, i8* align 1 %Y, i32 %n, i1 false)
  ret void
}


; Check that WLSTP loop is generated for alignment >= 4
; void test2(int* restrict X, int* restrict Y, int n){
;     memcpy(X, Y, n);
; }

define void @test2(i32* noalias %X, i32* noalias readonly %Y, i32 %n){
; CHECK-LABEL: test2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB1_2
; CHECK-NEXT:  .LBB1_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB1_1
; CHECK-NEXT:  .LBB1_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 %n, i1 false)
  ret void
}


; Checks that transform handles some arithmetic on the input arguments.
; void test3(int* restrict X, int* restrict Y, int n)
; {
;     memcpy(X+2, Y+3, (n*2)+10);
; }

define void @test3(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) {
; CHECK-LABEL: test3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r3, #10
; CHECK-NEXT:    add.w r2, r3, r2, lsl #1
; CHECK-NEXT:    adds r1, #12
; CHECK-NEXT:    adds r0, #8
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB2_2
; CHECK-NEXT:  .LBB2_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB2_1
; CHECK-NEXT:  .LBB2_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %add.ptr = getelementptr inbounds i32, i32* %X, i32 2
  %0 = bitcast i32* %add.ptr to i8*
  %add.ptr1 = getelementptr inbounds i32, i32* %Y, i32 3
  %1 = bitcast i32* %add.ptr1 to i8*
  %mul = shl nsw i32 %n, 1
  %add = add nsw i32 %mul, 10
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull align 4 %0, i8* nonnull align 4 %1, i32 %add, i1 false)
  ret void
}


; Checks that transform handles for loops that are implicitly converted to mempcy
; void test4(int* restrict X, int* restrict Y, int n){
;     for(int i = 0; i < n; ++i){
;         X[i] = Y[i];
;     }
; }

define void @test4(i32* noalias %X, i32* noalias readonly %Y, i32 %n) {
; CHECK-LABEL: test4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB3_1: @ %for.body.preheader
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB3_3
; CHECK-NEXT:  .LBB3_2: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB3_2
; CHECK-NEXT:  .LBB3_3: @ %for.body.preheader
; CHECK-NEXT:    pop.w {r7, lr}
; CHECK-NEXT:    bx lr
entry:
  %cmp6 = icmp sgt i32 %n, 0
  br i1 %cmp6, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  %X.bits = bitcast i32* %X to i8*
  %Y.bits = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %X.bits, i8* align 4 %Y.bits, i32 %n, i1 false)
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body.preheader, %entry
  ret void
}

; Checks that transform can handle > i32 size inputs
define void @test5(i8* noalias %X, i8* noalias %Y, i64 %n){
; CHECK-LABEL: test5:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB4_2
; CHECK-NEXT:  .LBB4_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB4_1
; CHECK-NEXT:  .LBB4_2:
; CHECK-NEXT:    pop {r7, pc}
    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %X, i8* align 4 %Y, i64 %n, i1 false)
    ret void
}

; Checks the transform is applied for constant size inputs below a certain threshold (128 in this case)
define void @test6(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) {
; CHECK-LABEL: test6:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #127
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB5_2
; CHECK-NEXT:  .LBB5_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB5_1
; CHECK-NEXT:  .LBB5_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 4 dereferenceable(127) %0, i8* noundef nonnull align 4 dereferenceable(127) %1, i32 127, i1 false)
  ret void
}

; Checks the transform is NOT applied for constant size inputs above a certain threshold (128 in this case)
define void @test7(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) {
; CHECK-LABEL: test7:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r2, #128
; CHECK-NEXT:    bl __aeabi_memcpy4
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 128, i1 false)
  ret void
}

; Checks the transform is NOT applied for constant size inputs below a certain threshold (64 in this case)
define void @test8(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    ldm.w r1!, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    stm.w r0!, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    ldm.w r1!, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    stm.w r0!, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    ldm.w r1, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    stm.w r0, {r2, r3, r4, r12, lr}
; CHECK-NEXT:    pop {r4, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 60, i1 false)
  ret void
}

; Checks the transform is NOT applied (regardless of alignment) when optimizations are disabled
define void @test9(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) #0 {
; CHECK-LABEL: test9:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bl __aeabi_memcpy4
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 %n, i1 false)
  ret void
}

; Checks the transform is NOT applied (regardless of alignment) when optimization for size is on (-Os or -Oz)
define void @test10(i32* noalias nocapture %X, i32* noalias nocapture readonly %Y, i32 %n) #1 {
; CHECK-LABEL: test10:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    bl __aeabi_memcpy4
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  %1 = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 %n, i1 false)
  ret void
}

define void @test11(i8* nocapture %x, i8* nocapture %y, i32 %n) {
; CHECK-LABEL: test11:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, lr}
; CHECK-NEXT:    push {r4, lr}
; CHECK-NEXT:    cmp.w r2, #-1
; CHECK-NEXT:    it gt
; CHECK-NEXT:    popgt {r4, pc}
; CHECK-NEXT:  .LBB10_1: @ %prehead
; CHECK-NEXT:    add.w r3, r2, #15
; CHECK-NEXT:    mov r12, r1
; CHECK-NEXT:    mov r4, r0
; CHECK-NEXT:    lsr.w lr, r3, #4
; CHECK-NEXT:    mov r3, r2
; CHECK-NEXT:    subs.w lr, lr, #0
; CHECK-NEXT:    beq .LBB10_3
; CHECK-NEXT:  .LBB10_2: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.8 r3
; CHECK-NEXT:    subs r3, #16
; CHECK-NEXT:    vpstt
; CHECK-NEXT:    vldrbt.u8 q0, [r12], #16
; CHECK-NEXT:    vstrbt.8 q0, [r4], #16
; CHECK-NEXT:    subs.w lr, lr, #1
; CHECK-NEXT:    bne .LBB10_2
; CHECK-NEXT:    b .LBB10_3
; CHECK-NEXT:  .LBB10_3: @ %for.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ldrb r3, [r0], #1
; CHECK-NEXT:    subs r2, #2
; CHECK-NEXT:    strb r3, [r1], #1
; CHECK-NEXT:    bne .LBB10_3
; CHECK-NEXT:  @ %bb.4: @ %for.cond.cleanup
; CHECK-NEXT:    pop {r4, pc}
entry:
  %cmp6 = icmp slt i32 %n, 0
  br i1 %cmp6, label %prehead, label %for.cond.cleanup

prehead:                                          ; preds = %entry
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %x, i8* align 4 %y, i32 %n, i1 false)
  br label %for.body

for.body:                                         ; preds = %for.body, %prehead
  %i.09 = phi i32 [ %inc, %for.body ], [ 0, %prehead ]
  %x.addr.08 = phi i8* [ %add.ptr, %for.body ], [ %x, %prehead ]
  %y.addr.07 = phi i8* [ %add.ptr1, %for.body ], [ %y, %prehead ]
  %add.ptr = getelementptr inbounds i8, i8* %x.addr.08, i32 1
  %add.ptr1 = getelementptr inbounds i8, i8* %y.addr.07, i32 1
  %l = load i8, i8* %x.addr.08, align 1
  store i8 %l, i8* %y.addr.07, align 1
  %inc = add nuw nsw i32 %i.09, 2
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %entry
  ret void
}

; Check that WLSTP loop is generated for simplest case of align = 1
define void @test12(i8* %X, i8 zeroext %c, i32 %n) {
; CHECK-LABEL: test12:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vdup.8 q0, r1
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB11_2
; CHECK-NEXT:  .LBB11_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB11_1
; CHECK-NEXT:  .LBB11_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  call void @llvm.memset.p0i8.i32(i8* align 1 %X, i8 %c, i32 %n, i1 false)
  ret void
}


; Check that WLSTP loop is generated for alignment >= 4
define void @test13(i32* %X, i8 zeroext %c, i32 %n) {
; CHECK-LABEL: test13:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vdup.8 q0, r1
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB12_2
; CHECK-NEXT:  .LBB12_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB12_1
; CHECK-NEXT:  .LBB12_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  call void @llvm.memset.p0i8.i32(i8* align 4 %0, i8 %c, i32 %n, i1 false)
  ret void
}

define void @twoloops(i32* %X, i32 %n, i32 %m) {
; CHECK-LABEL: twoloops:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    mov r3, r0
; CHECK-NEXT:    mov r1, r2
; CHECK-NEXT:    wlstp.8 lr, r1, .LBB13_2
; CHECK-NEXT:  .LBB13_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r3], #16
; CHECK-NEXT:    letp lr, .LBB13_1
; CHECK-NEXT:  .LBB13_2: @ %entry
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB13_4
; CHECK-NEXT:  .LBB13_3: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB13_3
; CHECK-NEXT:  .LBB13_4: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  call void @llvm.memset.p0i8.i32(i8* align 4 %0, i8 0, i32 %m, i1 false)
  call void @llvm.memset.p0i8.i32(i8* align 4 %0, i8 0, i32 %m, i1 false)
  ret void
}


; Checks that transform correctly handles input with some arithmetic on input arguments.
; void test14(int* X, char c, int n)
; {
;     memset(X+2, c, (n*2)+10);
; }

define void @test14(i32* %X, i8 zeroext %c, i32 %n) {
; CHECK-LABEL: test14:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    movs r3, #10
; CHECK-NEXT:    add.w r2, r3, r2, lsl #1
; CHECK-NEXT:    vdup.8 q0, r1
; CHECK-NEXT:    adds r0, #8
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB14_2
; CHECK-NEXT:  .LBB14_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB14_1
; CHECK-NEXT:  .LBB14_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %add.ptr = getelementptr inbounds i32, i32* %X, i32 2
  %0 = bitcast i32* %add.ptr to i8*
  %mul = shl nsw i32 %n, 1
  %add = add nsw i32 %mul, 10
  call void @llvm.memset.p0i8.i32(i8* nonnull align 4 %0, i8 %c, i32 %add, i1 false)
  ret void
}




; Checks that transform handles for-loops (that get implicitly converted to memset)
; void test15(int* X, char Y, int n){
;     for(int i = 0; i < n; ++i){
;         X[i] = c;
;     }
; }

define void @test15(i8* nocapture %X, i8 zeroext %c, i32 %n) {
; CHECK-LABEL: test15:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r2, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB15_1: @ %for.body.preheader
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vdup.8 q0, r1
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB15_3
; CHECK-NEXT:  .LBB15_2: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB15_2
; CHECK-NEXT:  .LBB15_3: @ %for.body.preheader
; CHECK-NEXT:    pop.w {r7, lr}
; CHECK-NEXT:    bx lr
entry:
  %cmp4 = icmp sgt i32 %n, 0
  br i1 %cmp4, label %for.body.preheader, label %for.cond.cleanup

for.body.preheader:                               ; preds = %entry
  call void @llvm.memset.p0i8.i32(i8* align 4 %X, i8 %c, i32 %n, i1 false)
  br label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body.preheader, %entry
  ret void
}

; Checks that transform handles case with 0 as src value. No difference is expected.
define void @test16(i32* %X, i8 zeroext %c, i32 %n) {
; CHECK-LABEL: test16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB16_2
; CHECK-NEXT:  .LBB16_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB16_1
; CHECK-NEXT:  .LBB16_2: @ %entry
; CHECK-NEXT:    pop {r7, pc}
entry:
  %0 = bitcast i32* %X to i8*
  call void @llvm.memset.p0i8.i32(i8* align 4 %0, i8 0, i32 %n, i1 false)
  ret void
}

define void @csprlive(i32* noalias %X, i32* noalias readonly %Y, i32 %n) {
; CHECK-LABEL: csprlive:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r7, lr}
; CHECK-NEXT:    push {r7, lr}
; CHECK-NEXT:    wlstp.8 lr, r2, .LBB17_2
; CHECK-NEXT:  .LBB17_1: @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r1], #16
; CHECK-NEXT:    vstrb.8 q0, [r0], #16
; CHECK-NEXT:    letp lr, .LBB17_1
; CHECK-NEXT:  .LBB17_2: @ %entry
; CHECK-NEXT:    bl other
; CHECK-NEXT:    pop {r7, pc}
entry:
  %cmp6 = icmp sgt i32 %n, 0
  %X.bits = bitcast i32* %X to i8*
  %Y.bits = bitcast i32* %Y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %X.bits, i8* align 4 %Y.bits, i32 %n, i1 false)
  br i1 %cmp6, label %if, label %else

if:
  call void @other()
  br label %cleanup

else:
  call void @other()
  br label %cleanup

cleanup:
  ret void
}

declare void @other()

attributes #0 = { noinline  optnone }
attributes #1 = { optsize }
