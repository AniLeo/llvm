; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -enable-load-pre -enable-pre -gvn -S < %s | FileCheck %s
; RUN:  opt -aa-pipeline=basic-aa -enable-load-pre -enable-pre -passes=gvn -S < %s | FileCheck %s

declare void @side_effect()
declare i1 @side_effect_cond()

declare i32 @personality_function()

; TODO: We can PRE the load away from the hot path.
define i32 @test_load_on_cold_path(i32* %p) {
; CHECK-LABEL: @test_load_on_cold_path(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  call void @side_effect()
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; PRE here is meaningless, so we should not do it.
define i32 @test_load_on_both_paths(i32* %p) {
; CHECK-LABEL: @test_load_on_both_paths(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  call void @side_effect()
  br label %backedge

cold_path:
  call void @side_effect()
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}


; We could PRE here, but it doesn't seem very profitable.
define i32 @test_load_on_backedge(i32* %p) {
; CHECK-LABEL: @test_load_on_backedge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  call void @side_effect()
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; TODO: We can PRE via splitting of the critical edge in the cold path.
define i32 @test_load_on_exiting_cold_path_01(i32* %p) {
; CHECK-LABEL: @test_load_on_exiting_cold_path_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    [[SIDE_COND:%.*]] = call i1 @side_effect_cond()
; CHECK-NEXT:    br i1 [[SIDE_COND]], label [[BACKEDGE]], label [[COLD_EXIT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       cold_exit:
; CHECK-NEXT:    ret i32 -1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  %side_cond = call i1 @side_effect_cond()
  br i1 %side_cond, label %backedge, label %cold_exit

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x

cold_exit:
  ret i32 -1
}

; TODO: We can PRE via splitting of the critical edge in the cold path.
define i32 @test_load_on_exiting_cold_path_02(i32* %p) gc "statepoint-example" personality i32 ()* @personality_function {
; CHECK-LABEL: @test_load_on_exiting_cold_path_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    invoke void @side_effect()
; CHECK-NEXT:    to label [[BACKEDGE]] unwind label [[COLD_EXIT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       cold_exit:
; CHECK-NEXT:    [[LANDING_PAD:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    ret i32 -1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  invoke void @side_effect() to label %backedge unwind label %cold_exit

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x

cold_exit:
  %landing_pad = landingpad token
  cleanup
  ret i32 -1
}

; Make sure we do not insert load into both cold path & backedge.
define i32 @test_load_on_cold_path_and_backedge(i32* %p) {
; CHECK-LABEL: @test_load_on_cold_path_and_backedge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  call void @side_effect()
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  call void @side_effect()
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; TODO: We can PRE the load away from the hot path. Make sure we only insert 1 load.
define i32 @test_load_multi_block_cold_path(i32* %p) {
; CHECK-LABEL: @test_load_multi_block_cold_path(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH_1:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path.1:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path.1

hot_path:
  br label %backedge

cold_path.1:
  call void @side_effect()
  br label %cold_path.2

cold_path.2:
  call void @side_effect()
  br label %cold_path.3

cold_path.3:
  call void @side_effect()
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  call void @side_effect()
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; TODO: We can PRE via splitting of the critical edge in the cold path. Make sure we only insert 1 load.
define i32 @test_load_on_multi_exiting_cold_path(i32* %p) {
; CHECK-LABEL: @test_load_on_multi_exiting_cold_path(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH_1:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path.1:
; CHECK-NEXT:    [[SIDE_COND_1:%.*]] = call i1 @side_effect_cond()
; CHECK-NEXT:    br i1 [[SIDE_COND_1]], label [[COLD_PATH_2:%.*]], label [[COLD_EXIT:%.*]]
; CHECK:       cold_path.2:
; CHECK-NEXT:    [[SIDE_COND_2:%.*]] = call i1 @side_effect_cond()
; CHECK-NEXT:    br i1 [[SIDE_COND_2]], label [[COLD_PATH_3:%.*]], label [[COLD_EXIT]]
; CHECK:       cold_path.3:
; CHECK-NEXT:    [[SIDE_COND_3:%.*]] = call i1 @side_effect_cond()
; CHECK-NEXT:    br i1 [[SIDE_COND_3]], label [[BACKEDGE]], label [[COLD_EXIT]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       cold_exit:
; CHECK-NEXT:    ret i32 -1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path.1

hot_path:
  br label %backedge

cold_path.1:
  %side_cond.1 = call i1 @side_effect_cond()
  br i1 %side_cond.1, label %cold_path.2, label %cold_exit

cold_path.2:
  %side_cond.2 = call i1 @side_effect_cond()
  br i1 %side_cond.2, label %cold_path.3, label %cold_exit

cold_path.3:
  %side_cond.3 = call i1 @side_effect_cond()
  br i1 %side_cond.3, label %backedge, label %cold_exit

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x

cold_exit:
  ret i32 -1
}

; TODO: PRE via splittinga backedge in the cold loop. Make sure we don't insert a load into an inner loop.
define i32 @test_inner_loop(i32* %p) {
; CHECK-LABEL: @test_inner_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    br label [[INNER_LOOP:%.*]]
; CHECK:       inner_loop:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br i1 undef, label [[INNER_LOOP]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  br label %inner_loop

inner_loop:
  call void @side_effect()
  br i1 undef, label %inner_loop, label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; TODO: We can PRE here, but profitablility depends on frequency of cold blocks. Conservatively, we should not do it unless there is a reason.
define i32 @test_multiple_cold_paths(i32* %p) {
; CHECK-LABEL: @test_multiple_cold_paths(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND_1:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[HOT_PATH_1:%.*]], label [[COLD_PATH_1:%.*]]
; CHECK:       hot_path.1:
; CHECK-NEXT:    br label [[DOM_1:%.*]]
; CHECK:       cold_path.1:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[DOM_1]]
; CHECK:       dom.1:
; CHECK-NEXT:    [[COND_2:%.*]] = icmp ne i32 [[X]], 1
; CHECK-NEXT:    br i1 [[COND_2]], label [[HOT_PATH_2:%.*]], label [[COLD_PATH_2:%.*]]
; CHECK:       hot_path.2:
; CHECK-NEXT:    br label [[DOM_2:%.*]]
; CHECK:       cold_path.2:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[DOM_2]]
; CHECK:       dom.2:
; CHECK-NEXT:    [[COND_3:%.*]] = icmp ne i32 [[X]], 2
; CHECK-NEXT:    br i1 [[COND_3]], label [[HOT_PATH_3:%.*]], label [[COLD_PATH_3:%.*]]
; CHECK:       hot_path.3:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path.3:
; CHECK-NEXT:    call void @side_effect()
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond.1 = icmp ne i32 %x, 0
  br i1 %cond.1, label %hot_path.1, label %cold_path.1

hot_path.1:
  br label %dom.1

cold_path.1:
  call void @side_effect()
  br label %dom.1

dom.1:
  %cond.2 = icmp ne i32 %x, 1
  br i1 %cond.2, label %hot_path.2, label %cold_path.2

hot_path.2:
  br label %dom.2

cold_path.2:
  call void @side_effect()
  br label %dom.2

dom.2:
  %cond.3 = icmp ne i32 %x, 2
  br i1 %cond.3, label %hot_path.3, label %cold_path.3

hot_path.3:
  br label %backedge

cold_path.3:
  call void @side_effect()
  br label %backedge

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x
}

; TODO: We can PRE via split of critical edge.
define i32 @test_side_exit_after_merge(i32* %p) {
; CHECK-LABEL: @test_side_exit_after_merge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[X]], 0
; CHECK-NEXT:    br i1 [[COND]], label [[HOT_PATH:%.*]], label [[COLD_PATH:%.*]]
; CHECK:       hot_path:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       cold_path:
; CHECK-NEXT:    [[COND_1:%.*]] = icmp ne i32 [[IV]], 1
; CHECK-NEXT:    br i1 [[COND_1]], label [[DO_CALL:%.*]], label [[SIDE_EXITING:%.*]]
; CHECK:       do_call:
; CHECK-NEXT:    [[SIDE_COND:%.*]] = call i1 @side_effect_cond()
; CHECK-NEXT:    br label [[SIDE_EXITING]]
; CHECK:       side_exiting:
; CHECK-NEXT:    [[SIDE_COND_PHI:%.*]] = phi i1 [ [[SIDE_COND]], [[DO_CALL]] ], [ true, [[COLD_PATH]] ]
; CHECK-NEXT:    br i1 [[SIDE_COND_PHI]], label [[BACKEDGE]], label [[COLD_EXIT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], [[X]]
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], 1000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       cold_exit:
; CHECK-NEXT:    ret i32 -1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %hot_path, label %cold_path

hot_path:
  br label %backedge

cold_path:
  %cond.1 = icmp ne i32 %iv, 1
  br i1 %cond.1, label %do_call, label %side_exiting

do_call:
  %side_cond = call i1 @side_effect_cond()
  br label %side_exiting

side_exiting:
  %side_cond_phi = phi i1 [%side_cond, %do_call], [true, %cold_path]
  br i1 %side_cond_phi, label %backedge, label %cold_exit

backedge:
  %iv.next = add i32 %iv, %x
  %loop.cond = icmp ult i32 %iv.next, 1000
  br i1 %loop.cond, label %loop, label %exit

exit:
  ret i32 %x

cold_exit:
  ret i32 -1
}
