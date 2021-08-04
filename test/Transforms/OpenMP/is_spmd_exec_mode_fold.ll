; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s
target triple = "nvptx64"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@is_spmd_exec_mode = weak constant i8 0
@will_be_spmd_exec_mode = weak constant i8 1
@non_spmd_exec_mode = weak constant i8 1
@will_not_be_spmd_exec_mode = weak constant i8 1
@G = external global i8
@llvm.compiler.used = appending global [4 x i8*] [i8* @is_spmd_exec_mode, i8* @will_be_spmd_exec_mode, i8* @non_spmd_exec_mode, i8* @will_not_be_spmd_exec_mode ], section "llvm.metadata"

;.
; CHECK: @[[IS_SPMD_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 0
; CHECK: @[[WILL_BE_SPMD_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 2
; CHECK: @[[NON_SPMD_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[WILL_NOT_BE_SPMD_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = external global i8
; CHECK: @[[LLVM_COMPILER_USED:[a-zA-Z0-9_$"\\.-]+]] = appending global [4 x i8*] [i8* @is_spmd_exec_mode, i8* @will_be_spmd_exec_mode, i8* @non_spmd_exec_mode, i8* @will_not_be_spmd_exec_mode], section "llvm.metadata"
;.
define weak void @is_spmd() {
; CHECK-LABEL: define {{[^@]+}}@is_spmd() {
; CHECK-NEXT:    [[I:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 true, i1 false, i1 false)
; CHECK-NEXT:    call void @is_spmd_helper1()
; CHECK-NEXT:    call void @is_spmd_helper2()
; CHECK-NEXT:    call void @is_mixed_helper()
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* null, i1 true, i1 false)
; CHECK-NEXT:    ret void
;
  %i = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 true, i1 false, i1 false)
  call void @is_spmd_helper1()
  call void @is_spmd_helper2()
  call void @is_mixed_helper()
  call void @__kmpc_target_deinit(%struct.ident_t* null, i1 true, i1 false)
  ret void
}

define weak void @will_be_spmd() {
; CHECK-LABEL: define {{[^@]+}}@will_be_spmd() {
; CHECK-NEXT:    [[I:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 true, i1 false, i1 false)
; CHECK-NEXT:    call void @is_spmd_helper2()
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* null, i1 true, i1 false)
; CHECK-NEXT:    ret void
;
  %i = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 false, i1 false, i1 false)
  call void @is_spmd_helper2()
  call void @__kmpc_target_deinit(%struct.ident_t* null, i1 false, i1 false)
  ret void
}

define weak void @non_spmd() {
; CHECK-LABEL: define {{[^@]+}}@non_spmd() {
; CHECK-NEXT:    [[I:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 false, i1 false, i1 false)
; CHECK-NEXT:    call void @is_generic_helper1()
; CHECK-NEXT:    call void @is_generic_helper2()
; CHECK-NEXT:    call void @is_mixed_helper()
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* null, i1 false, i1 false)
; CHECK-NEXT:    ret void
;
  %i = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 false, i1 false, i1 false)
  call void @is_generic_helper1()
  call void @is_generic_helper2()
  call void @is_mixed_helper()
  call void @__kmpc_target_deinit(%struct.ident_t* null, i1 false, i1 false)
  ret void
}

define weak void @will_not_be_spmd() {
; CHECK-LABEL: define {{[^@]+}}@will_not_be_spmd() {
; CHECK-NEXT:    [[I:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 false, i1 false, i1 false)
; CHECK-NEXT:    call void @is_generic_helper1()
; CHECK-NEXT:    call void @is_generic_helper2()
; CHECK-NEXT:    call void @is_mixed_helper()
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* null, i1 false, i1 false)
; CHECK-NEXT:    ret void
;
  %i = call i32 @__kmpc_target_init(%struct.ident_t* null, i1 false, i1 false, i1 false)
  call void @is_generic_helper1()
  call void @is_generic_helper2()
  call void @is_mixed_helper()
  call void @__kmpc_target_deinit(%struct.ident_t* null, i1 false, i1 false)
  ret void
}

define internal void @is_spmd_helper1() {
; CHECK-LABEL: define {{[^@]+}}@is_spmd_helper1() {
; CHECK-NEXT:    store i8 1, i8* @G, align 1
; CHECK-NEXT:    ret void
;
  %isSPMD = call i8 @__kmpc_is_spmd_exec_mode()
  store i8 %isSPMD, i8* @G
  ret void
}

define internal void @is_spmd_helper2() {
; CHECK-LABEL: define {{[^@]+}}@is_spmd_helper2() {
; CHECK-NEXT:    br label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       f:
; CHECK-NEXT:    ret void
;
  %isSPMD = call i8 @__kmpc_is_spmd_exec_mode()
  %c = icmp eq i8 %isSPMD, 0
  br i1 %c, label %t, label %f
t:
  call void @spmd_compatible()
  ret void
f:
  ret void
}

define internal void @is_generic_helper1() {
; CHECK-LABEL: define {{[^@]+}}@is_generic_helper1() {
; CHECK-NEXT:    store i8 0, i8* @G, align 1
; CHECK-NEXT:    ret void
;
  %isSPMD = call i8 @__kmpc_is_spmd_exec_mode()
  store i8 %isSPMD, i8* @G
  ret void
}

define internal void @is_generic_helper2() {
; CHECK-LABEL: define {{[^@]+}}@is_generic_helper2() {
; CHECK-NEXT:    br label [[T:%.*]]
; CHECK:       t:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    ret void
; CHECK:       f:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    ret void
;
  %isSPMD = call i8 @__kmpc_is_spmd_exec_mode()
  %c = icmp eq i8 %isSPMD, 0
  br i1 %c, label %t, label %f
t:
  call void @foo()
  ret void
f:
  call void @bar()
  ret void
}

define internal void @is_mixed_helper() {
; CHECK-LABEL: define {{[^@]+}}@is_mixed_helper() {
; CHECK-NEXT:    [[ISSPMD:%.*]] = call i8 @__kmpc_is_spmd_exec_mode()
; CHECK-NEXT:    store i8 [[ISSPMD]], i8* @G, align 1
; CHECK-NEXT:    ret void
;
  %isSPMD = call i8 @__kmpc_is_spmd_exec_mode()
  store i8 %isSPMD, i8* @G
  ret void
}

declare void @spmd_compatible() "llvm.assume"="ompx_spmd_amenable"
declare i8 @__kmpc_is_spmd_exec_mode()
declare i32 @__kmpc_target_init(%struct.ident_t*, i1 zeroext, i1 zeroext, i1 zeroext) #1
declare void @__kmpc_target_deinit(%struct.ident_t* nocapture readnone, i1 zeroext, i1 zeroext) #1
declare void @foo()
declare void @bar()

!llvm.module.flags = !{!0, !1}
!nvvm.annotations = !{!2, !3, !4, !5}

!0 = !{i32 7, !"openmp", i32 50}
!1 = !{i32 7, !"openmp-device", i32 50}
!2 = !{void ()* @is_spmd, !"kernel", i32 1}
!3 = !{void ()* @will_be_spmd, !"kernel", i32 1}
!4 = !{void ()* @non_spmd, !"kernel", i32 1}
!5 = !{void ()* @will_not_be_spmd, !"kernel", i32 1}
;.
; CHECK: attributes #[[ATTR0:[0-9]+]] = { "llvm.assume"="ompx_spmd_amenable" }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META1:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META2:![0-9]+]] = !{void ()* @is_spmd, !"kernel", i32 1}
; CHECK: [[META3:![0-9]+]] = !{void ()* @will_be_spmd, !"kernel", i32 1}
; CHECK: [[META4:![0-9]+]] = !{void ()* @non_spmd, !"kernel", i32 1}
; CHECK: [[META5:![0-9]+]] = !{void ()* @will_not_be_spmd, !"kernel", i32 1}
;.
