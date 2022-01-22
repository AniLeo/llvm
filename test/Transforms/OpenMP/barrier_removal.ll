; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt < %s -S -openmp-opt-cgscc        | FileCheck %s
; RUN: opt < %s -S -passes=openmp-opt-cgscc | FileCheck %s

declare void @useI32(i32)
declare void @unknown()
declare void @aligned_barrier() "llvm.assume"="ompx_aligned_barrier"
declare void @llvm.nvvm.barrier0()
declare i32 @llvm.nvvm.barrier0.and(i32)
declare i32 @llvm.nvvm.barrier0.or(i32)
declare i32 @llvm.nvvm.barrier0.popc(i32)
declare void @llvm.amdgcn.s.barrier()

;.
; CHECK: @[[GC1:[a-zA-Z0-9_$"\\.-]+]] = constant i32 42
; CHECK: @[[GC2:[a-zA-Z0-9_$"\\.-]+]] = addrspace(4) global i32 0
; CHECK: @[[GPTR4:[a-zA-Z0-9_$"\\.-]+]] = addrspace(4) global i32 addrspace(4)* null
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = global i32 42
; CHECK: @[[GS:[a-zA-Z0-9_$"\\.-]+]] = addrspace(3) global i32 0
; CHECK: @[[GPTR:[a-zA-Z0-9_$"\\.-]+]] = global i32* null
; CHECK: @[[PG1:[a-zA-Z0-9_$"\\.-]+]] = thread_local global i32 42
; CHECK: @[[PG2:[a-zA-Z0-9_$"\\.-]+]] = addrspace(5) global i32 0
; CHECK: @[[GPTR5:[a-zA-Z0-9_$"\\.-]+]] = global i32 addrspace(5)* null
; CHECK: @[[G1:[a-zA-Z0-9_$"\\.-]+]] = global i32 42
; CHECK: @[[G2:[a-zA-Z0-9_$"\\.-]+]] = addrspace(1) global i32 0
;.
define void @pos_empty_1() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_1() {
; CHECK-NEXT:    ret void
;
  call void @unknown() "llvm.assume"="ompx_aligned_barrier"
  ret void
}
define void @pos_empty_2() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_2() {
; CHECK-NEXT:    ret void
;
  call void @aligned_barrier()
  ret void
}
define void @pos_empty_3() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_3() {
; CHECK-NEXT:    ret void
;
  call void @llvm.nvvm.barrier0()
  ret void
}
define void @pos_empty_4() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_4() {
; CHECK-NEXT:    ret void
;
  call i32 @llvm.nvvm.barrier0.and(i32 0)
  ret void
}
define void @pos_empty_5() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_5() {
; CHECK-NEXT:    ret void
;
  call i32 @llvm.nvvm.barrier0.or(i32 0)
  ret void
}
define void @pos_empty_6() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_6() {
; CHECK-NEXT:    ret void
;
  call i32 @llvm.nvvm.barrier0.popc(i32 0)
  ret void
}
define void @pos_empty_7() {
; CHECK-LABEL: define {{[^@]+}}@pos_empty_7() {
; CHECK-NEXT:    ret void
;
  call void @llvm.amdgcn.s.barrier()
  ret void
}
define void @neg_empty_1() {
; CHECK-LABEL: define {{[^@]+}}@neg_empty_1() {
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    ret void
;
  call void @unknown()
  ret void
}
define void @neg_empty_2() {
; CHECK-LABEL: define {{[^@]+}}@neg_empty_2() {
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    ret void
;
  call void @aligned_barrier()
  ret void
}

@GC1 = constant i32 42
@GC2 = addrspace(4) global i32 0
@GPtr4 = addrspace(4) global i32 addrspace(4)* null
define void @pos_constant_loads() {
; CHECK-LABEL: define {{[^@]+}}@pos_constant_loads() {
; CHECK-NEXT:    [[ARG:%.*]] = load i32 addrspace(4)*, i32 addrspace(4)** addrspacecast (i32 addrspace(4)* addrspace(4)* @GPtr4 to i32 addrspace(4)**), align 8
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @GC1, align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* addrspacecast (i32 addrspace(4)* @GC2 to i32*), align 4
; CHECK-NEXT:    [[ARGC:%.*]] = addrspacecast i32 addrspace(4)* [[ARG]] to i32*
; CHECK-NEXT:    [[C:%.*]] = load i32, i32* [[ARGC]], align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[D:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = add i32 [[D]], [[C]]
; CHECK-NEXT:    call void @useI32(i32 [[E]])
; CHECK-NEXT:    ret void
;
  %GPtr4c = addrspacecast i32 addrspace(4)*addrspace(4)* @GPtr4 to i32 addrspace(4)**
  %arg = load i32 addrspace(4)*, i32 addrspace(4)** %GPtr4c
  %a = load i32, i32* @GC1
  call void @aligned_barrier()
  %GC2c = addrspacecast i32 addrspace(4)* @GC2 to i32*
  %b = load i32, i32* %GC2c
  call void @aligned_barrier()
  %argc = addrspacecast i32 addrspace(4)* %arg to i32*
  %c = load i32, i32* %argc
  call void @aligned_barrier()
  %d = add i32 %a, %b
  %e = add i32 %d, %c
  call void @useI32(i32 %e)
  ret void
}
@G = global i32 42
@GS = addrspace(3) global i32 0
@GPtr = global i32* null
; TODO: We could remove some of the barriers due to the lack of write effects.
define void @neg_loads() {
; CHECK-LABEL: define {{[^@]+}}@neg_loads() {
; CHECK-NEXT:    [[ARG:%.*]] = load i32*, i32** @GPtr, align 8
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @G, align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* addrspacecast (i32 addrspace(3)* @GS to i32*), align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[C:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[D:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[E:%.*]] = add i32 [[D]], [[C]]
; CHECK-NEXT:    call void @useI32(i32 [[E]])
; CHECK-NEXT:    ret void
;
  %arg = load i32*, i32** @GPtr
  %a = load i32, i32* @G
  call void @aligned_barrier()
  %GSc = addrspacecast i32 addrspace(3)* @GS to i32*
  %b = load i32, i32* %GSc
  call void @aligned_barrier()
  %c = load i32, i32* %arg
  call void @aligned_barrier()
  %d = add i32 %a, %b
  %e = add i32 %d, %c
  call void @useI32(i32 %e)
  ret void
}
@PG1 = thread_local global i32 42
@PG2 = addrspace(5) global i32 0
@GPtr5 = global i32 addrspace(5)* null
define void @pos_priv_mem() {
; CHECK-LABEL: define {{[^@]+}}@pos_priv_mem() {
; CHECK-NEXT:    [[ARG:%.*]] = load i32 addrspace(5)*, i32 addrspace(5)** @GPtr5, align 8
; CHECK-NEXT:    [[LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @PG1, align 4
; CHECK-NEXT:    store i32 [[A]], i32* [[LOC]], align 4
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* addrspacecast (i32 addrspace(5)* @PG2 to i32*), align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[ARGC:%.*]] = addrspacecast i32 addrspace(5)* [[ARG]] to i32*
; CHECK-NEXT:    store i32 [[B]], i32* [[ARGC]], align 4
; CHECK-NEXT:    store i32 [[A]], i32* @PG1, align 4
; CHECK-NEXT:    ret void
;
  %arg = load i32 addrspace(5)*, i32 addrspace(5)** @GPtr5
  %loc = alloca i32
  %a = load i32, i32* @PG1
  call void @aligned_barrier()
  store i32 %a, i32* %loc
  %PG2c = addrspacecast i32 addrspace(5)* @PG2 to i32*
  %b = load i32, i32* %PG2c
  call void @aligned_barrier()
  %argc = addrspacecast i32 addrspace(5)* %arg to i32*
  store i32 %b, i32* %argc
  call void @aligned_barrier()
  %v = load i32, i32* %loc
  store i32 %v, i32* @PG1
  call void @aligned_barrier()
  ret void
}
@G1 = global i32 42
@G2 = addrspace(1) global i32 0
define void @neg_mem() {
; CHECK-LABEL: define {{[^@]+}}@neg_mem() {
; CHECK-NEXT:    [[ARG:%.*]] = load i32*, i32** @GPtr, align 8
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* @G1, align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    store i32 [[A]], i32* [[ARG]], align 4
; CHECK-NEXT:    call void @aligned_barrier()
; CHECK-NEXT:    [[B:%.*]] = load i32, i32* addrspacecast (i32 addrspace(1)* @G2 to i32*), align 4
; CHECK-NEXT:    store i32 [[B]], i32* @G1, align 4
; CHECK-NEXT:    ret void
;
  %arg = load i32*, i32** @GPtr
  %a = load i32, i32* @G1
  call void @aligned_barrier()
  store i32 %a, i32* %arg
  call void @aligned_barrier()
  %G2c = addrspacecast i32 addrspace(1)* @G2 to i32*
  %b = load i32, i32* %G2c
  store i32 %b, i32* @G1
  call void @aligned_barrier()
  ret void
}

define void @pos_multiple() {
; CHECK-LABEL: define {{[^@]+}}@pos_multiple() {
; CHECK-NEXT:    ret void
;
  call void @llvm.nvvm.barrier0()
  call void @aligned_barrier()
  call void @aligned_barrier()
  call void @llvm.amdgcn.s.barrier()
  call void @aligned_barrier()
  call void @llvm.nvvm.barrier0()
  call void @aligned_barrier()
  call void @aligned_barrier()
  ret void
}

!llvm.module.flags = !{!12,!13}
!nvvm.annotations = !{!0,!1,!2,!3,!4,!5,!6,!7,!8,!9,!10,!11}

!0 = !{void ()* @pos_empty_1, !"kernel", i32 1}
!1 = !{void ()* @pos_empty_2, !"kernel", i32 1}
!2 = !{void ()* @pos_empty_3, !"kernel", i32 1}
!3 = !{void ()* @pos_empty_4, !"kernel", i32 1}
!4 = !{void ()* @pos_empty_5, !"kernel", i32 1}
!5 = !{void ()* @pos_empty_6, !"kernel", i32 1}
!6 = !{void ()* @pos_empty_7, !"kernel", i32 1}
!7 = !{void ()* @pos_constant_loads, !"kernel", i32 1}
!8 = !{void ()* @neg_loads, !"kernel", i32 1}
!9 = !{void ()* @pos_priv_mem, !"kernel", i32 1}
!10 = !{void ()* @neg_mem, !"kernel", i32 1}
!11 = !{void ()* @pos_multiple, !"kernel", i32 1}
!12 = !{i32 7, !"openmp", i32 50}
!13 = !{i32 7, !"openmp-device", i32 50}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { "llvm.assume"="ompx_aligned_barrier" }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { convergent nounwind }
; CHECK: attributes #[[ATTR2:[0-9]+]] = { convergent nounwind willreturn }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META1:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META2:![0-9]+]] = !{void ()* @pos_empty_1, !"kernel", i32 1}
; CHECK: [[META3:![0-9]+]] = !{void ()* @pos_empty_2, !"kernel", i32 1}
; CHECK: [[META4:![0-9]+]] = !{void ()* @pos_empty_3, !"kernel", i32 1}
; CHECK: [[META5:![0-9]+]] = !{void ()* @pos_empty_4, !"kernel", i32 1}
; CHECK: [[META6:![0-9]+]] = !{void ()* @pos_empty_5, !"kernel", i32 1}
; CHECK: [[META7:![0-9]+]] = !{void ()* @pos_empty_6, !"kernel", i32 1}
; CHECK: [[META8:![0-9]+]] = !{void ()* @pos_empty_7, !"kernel", i32 1}
; CHECK: [[META9:![0-9]+]] = !{void ()* @pos_constant_loads, !"kernel", i32 1}
; CHECK: [[META10:![0-9]+]] = !{void ()* @neg_loads, !"kernel", i32 1}
; CHECK: [[META11:![0-9]+]] = !{void ()* @pos_priv_mem, !"kernel", i32 1}
; CHECK: [[META12:![0-9]+]] = !{void ()* @neg_mem, !"kernel", i32 1}
; CHECK: [[META13:![0-9]+]] = !{void ()* @pos_multiple, !"kernel", i32 1}
;.
