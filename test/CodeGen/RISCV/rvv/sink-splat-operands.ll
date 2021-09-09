; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+experimental-v \
; RUN:     -riscv-v-vector-bits-min=128 | FileCheck %s

define void @sink_splat_mul(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_mul:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB0_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vmul.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB0_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = mul <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_add(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_add:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB1_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vadd.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB1_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = add <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_sub(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_sub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB2_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vadd.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB2_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = add <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_rsub(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_rsub:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB3_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsub.vv v26, v25, v26
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB3_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = sub <4 x i32> %broadcast.splat, %wide.load
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_mul_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_mul_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB4_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB4_5
; CHECK-NEXT:  .LBB4_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB4_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vmul.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB4_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB4_7
; CHECK-NEXT:  .LBB4_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB4_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    mulw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB4_6
; CHECK-NEXT:  .LBB4_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = mul <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %mul = mul i32 %11, %x
  store i32 %mul, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_add_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_add_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB5_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB5_5
; CHECK-NEXT:  .LBB5_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB5_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vadd.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB5_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB5_7
; CHECK-NEXT:  .LBB5_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB5_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    addw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB5_6
; CHECK-NEXT:  .LBB5_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = add <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %add = add i32 %11, %x
  store i32 %add, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_sub_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_sub_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB6_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB6_5
; CHECK-NEXT:  .LBB6_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB6_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vsub.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB6_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB6_7
; CHECK-NEXT:  .LBB6_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB6_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    addw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB6_6
; CHECK-NEXT:  .LBB6_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = sub <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %add = add i32 %11, %x
  store i32 %add, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_rsub_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_rsub_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB7_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB7_5
; CHECK-NEXT:  .LBB7_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB7_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vsub.vv v28, v26, v28
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB7_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB7_7
; CHECK-NEXT:  .LBB7_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB7_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    addw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB7_6
; CHECK-NEXT:  .LBB7_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = sub <vscale x 4 x i32> %broadcast.splat, %wide.load
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %add = add i32 %11, %x
  store i32 %add, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_shl(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_shl:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB8_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsll.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB8_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = shl <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_lshr(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_lshr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB9_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsrl.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB9_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = lshr <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_ashr(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_ashr:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.x v25, a1
; CHECK-NEXT:    addi a1, zero, 1024
; CHECK-NEXT:  .LBB10_1: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vle32.v v26, (a0)
; CHECK-NEXT:    vsra.vv v26, v26, v25
; CHECK-NEXT:    vse32.v v26, (a0)
; CHECK-NEXT:    addi a1, a1, -4
; CHECK-NEXT:    addi a0, a0, 16
; CHECK-NEXT:    bnez a1, .LBB10_1
; CHECK-NEXT:  # %bb.2: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i64 [ 0, %entry ], [ %index.next, %vector.body ]
  %0 = getelementptr inbounds i32, i32* %a, i64 %index
  %1 = bitcast i32* %0 to <4 x i32>*
  %wide.load = load <4 x i32>, <4 x i32>* %1, align 4
  %2 = ashr <4 x i32> %wide.load, %broadcast.splat
  %3 = bitcast i32* %0 to <4 x i32>*
  store <4 x i32> %2, <4 x i32>* %3, align 4
  %index.next = add nuw i64 %index, 4
  %4 = icmp eq i64 %index.next, 1024
  br i1 %4, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body
  ret void
}

define void @sink_splat_shl_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_shl_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB11_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB11_5
; CHECK-NEXT:  .LBB11_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB11_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vsll.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB11_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB11_7
; CHECK-NEXT:  .LBB11_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB11_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    sllw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB11_6
; CHECK-NEXT:  .LBB11_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = shl <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %shl = shl i32 %11, %x
  store i32 %shl, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_lshr_scalable(i32* nocapture %a, i32 signext %x) {
; CHECK-LABEL: sink_splat_lshr_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a5, vlenb
; CHECK-NEXT:    srli a7, a5, 1
; CHECK-NEXT:    addi a3, zero, 1024
; CHECK-NEXT:    bgeu a3, a7, .LBB12_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a3, zero
; CHECK-NEXT:    j .LBB12_5
; CHECK-NEXT:  .LBB12_2: # %vector.ph
; CHECK-NEXT:    mv a4, zero
; CHECK-NEXT:    remu a6, a3, a7
; CHECK-NEXT:    sub a3, a3, a6
; CHECK-NEXT:    vsetvli a2, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.x v26, a1
; CHECK-NEXT:    slli a5, a5, 1
; CHECK-NEXT:    mv a2, a0
; CHECK-NEXT:  .LBB12_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a2)
; CHECK-NEXT:    vsrl.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a2)
; CHECK-NEXT:    add a4, a4, a7
; CHECK-NEXT:    add a2, a2, a5
; CHECK-NEXT:    bne a4, a3, .LBB12_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB12_7
; CHECK-NEXT:  .LBB12_5: # %for.body.preheader
; CHECK-NEXT:    addi a2, a3, -1024
; CHECK-NEXT:    slli a3, a3, 2
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:  .LBB12_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a3, 0(a0)
; CHECK-NEXT:    mv a4, a2
; CHECK-NEXT:    srlw a2, a3, a1
; CHECK-NEXT:    sw a2, 0(a0)
; CHECK-NEXT:    addi a2, a4, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a2, a4, .LBB12_6
; CHECK-NEXT:  .LBB12_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %x, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = lshr <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %lshr = lshr i32 %11, %x
  store i32 %lshr, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define void @sink_splat_ashr_scalable(i32* nocapture %a) {
; CHECK-LABEL: sink_splat_ashr_scalable:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csrr a4, vlenb
; CHECK-NEXT:    srli a1, a4, 1
; CHECK-NEXT:    addi a2, zero, 1024
; CHECK-NEXT:    bgeu a2, a1, .LBB13_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a2, zero
; CHECK-NEXT:    j .LBB13_5
; CHECK-NEXT:  .LBB13_2: # %vector.ph
; CHECK-NEXT:    mv a5, zero
; CHECK-NEXT:    remu a6, a2, a1
; CHECK-NEXT:    sub a2, a2, a6
; CHECK-NEXT:    vsetvli a3, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmv.v.i v26, 2
; CHECK-NEXT:    slli a4, a4, 1
; CHECK-NEXT:    mv a3, a0
; CHECK-NEXT:  .LBB13_3: # %vector.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vl2re32.v v28, (a3)
; CHECK-NEXT:    vsra.vv v28, v28, v26
; CHECK-NEXT:    vs2r.v v28, (a3)
; CHECK-NEXT:    add a5, a5, a1
; CHECK-NEXT:    add a3, a3, a4
; CHECK-NEXT:    bne a5, a2, .LBB13_3
; CHECK-NEXT:  # %bb.4: # %middle.block
; CHECK-NEXT:    beqz a6, .LBB13_7
; CHECK-NEXT:  .LBB13_5: # %for.body.preheader
; CHECK-NEXT:    addi a1, a2, -1024
; CHECK-NEXT:    slli a2, a2, 2
; CHECK-NEXT:    add a0, a0, a2
; CHECK-NEXT:  .LBB13_6: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lw a2, 0(a0)
; CHECK-NEXT:    mv a3, a1
; CHECK-NEXT:    srli a1, a2, 2
; CHECK-NEXT:    sw a1, 0(a0)
; CHECK-NEXT:    addi a1, a3, 1
; CHECK-NEXT:    addi a0, a0, 4
; CHECK-NEXT:    bgeu a1, a3, .LBB13_6
; CHECK-NEXT:  .LBB13_7: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = call i64 @llvm.vscale.i64()
  %1 = shl i64 %0, 2
  %min.iters.check = icmp ugt i64 %1, 1024
  br i1 %min.iters.check, label %for.body.preheader, label %vector.ph

vector.ph:                                        ; preds = %entry
  %2 = call i64 @llvm.vscale.i64()
  %3 = shl i64 %2, 2
  %n.mod.vf = urem i64 1024, %3
  %n.vec = sub nsw i64 1024, %n.mod.vf
  %broadcast.splatinsert = insertelement <vscale x 4 x i32> poison, i32 2, i32 0
  %broadcast.splat = shufflevector <vscale x 4 x i32> %broadcast.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  %4 = call i64 @llvm.vscale.i64()
  %5 = shl i64 %4, 2
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr inbounds i32, i32* %a, i64 %index
  %7 = bitcast i32* %6 to <vscale x 4 x i32>*
  %wide.load = load <vscale x 4 x i32>, <vscale x 4 x i32>* %7, align 4
  %8 = ashr <vscale x 4 x i32> %wide.load, %broadcast.splat
  %9 = bitcast i32* %6 to <vscale x 4 x i32>*
  store <vscale x 4 x i32> %8, <vscale x 4 x i32>* %9, align 4
  %index.next = add nuw i64 %index, %5
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.mod.vf, 0
  br i1 %cmp.n, label %for.cond.cleanup, label %for.body.preheader

for.body.preheader:                               ; preds = %entry, %middle.block
  %indvars.iv.ph = phi i64 [ 0, %entry ], [ %n.vec, %middle.block ]
  br label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %middle.block
  ret void

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ %indvars.iv.ph, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %a, i64 %indvars.iv
  %11 = load i32, i32* %arrayidx, align 4
  %ashr = ashr i32 %11, 2
  store i32 %ashr, i32* %arrayidx, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %cmp.not = icmp eq i64 %indvars.iv.next, 1024
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

declare i64 @llvm.vscale.i64()
