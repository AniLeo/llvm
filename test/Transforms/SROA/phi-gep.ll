; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -sroa < %s | FileCheck %s

%pair = type { i32, i32 }

define i32 @test_sroa_phi_gep(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_SROA_PHI_SROA_SPECULATED:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 2, [[IF_THEN]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_PHI_SROA_SPECULATED]]
;
entry:
  %a = alloca %pair, align 4
  %b = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  %gep_b = getelementptr inbounds %pair, %pair* %b, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  store i32 2, i32* %gep_b, align 4
  br i1 %cond, label %if.then, label %end

if.then:
  br label %end

end:
  %phi = phi %pair* [ %a, %entry], [ %b, %if.then ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

define i32 @test_sroa_phi_gep_non_inbound(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep_non_inbound(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_SROA_PHI_SROA_SPECULATED:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 2, [[IF_THEN]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_PHI_SROA_SPECULATED]]
;
entry:
  %a = alloca %pair, align 4
  %b = alloca %pair, align 4
  %gep_a = getelementptr %pair, %pair* %a, i32 0, i32 1
  %gep_b = getelementptr %pair, %pair* %b, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  store i32 2, i32* %gep_b, align 4
  br i1 %cond, label %if.then, label %end

if.then:
  br label %end

end:
  %phi = phi %pair* [ %a, %entry], [ %b, %if.then ]
  %gep = getelementptr %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

define i32 @test_sroa_phi_gep_undef(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [[PAIR:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi %pair* [ [[A]], [[ENTRY:%.*]] ], [ undef, [[IF_THEN]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[PHI]], i32 0, i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  br i1 %cond, label %if.then, label %end

if.then:
  br label %end

end:
  %phi = phi %pair* [ %a, %entry], [ undef, %if.then ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

@g = global %pair zeroinitializer, align 4

define i32 @test_sroa_phi_gep_global(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep_global(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [[PAIR:%.*]], align 4
; CHECK-NEXT:    [[GEP_A:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[A]], i32 0, i32 1
; CHECK-NEXT:    store i32 1, i32* [[GEP_A]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi %pair* [ [[A]], [[ENTRY:%.*]] ], [ @g, [[IF_THEN]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[PHI]], i32 0, i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  br i1 %cond, label %if.then, label %end

if.then:
  br label %end

end:
  %phi = phi %pair* [ %a, %entry], [ @g, %if.then ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

define i32 @test_sroa_phi_gep_arg_phi_inspt(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep_arg_phi_inspt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[FOR:%.*]], label [[END:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PHI_INSPT:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[I]] = add i32 [[PHI_INSPT]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[I]], 10
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[FOR]], label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_SROA_PHI_SROA_SPECULATED:%.*]] = phi i32 [ 1, [[ENTRY]] ], [ 2, [[FOR]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_PHI_SROA_SPECULATED]]
;
entry:
  %a = alloca %pair, align 4
  %b = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  %gep_b = getelementptr inbounds %pair, %pair* %b, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  store i32 2, i32* %gep_b, align 4
  br i1 %cond, label %for, label %end

for:
  %phi_inspt = phi i32 [ 0, %entry ], [ %i, %for ]
  %i = add i32 %phi_inspt, 1
  %loop.cond = icmp ult i32 %i, 10
  br i1 %loop.cond, label %for, label %end

end:
  %phi = phi %pair* [ %a, %entry], [ %b, %for ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

define i32 @test_sroa_phi_gep_phi_inspt(i1 %cond) {
; CHECK-LABEL: @test_sroa_phi_gep_phi_inspt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [[PAIR:%.*]], align 4
; CHECK-NEXT:    [[B:%.*]] = alloca [[PAIR]], align 4
; CHECK-NEXT:    [[GEP_A:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[A]], i32 0, i32 1
; CHECK-NEXT:    [[GEP_B:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[B]], i32 0, i32 1
; CHECK-NEXT:    store i32 1, i32* [[GEP_A]], align 4
; CHECK-NEXT:    store i32 2, i32* [[GEP_B]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[FOR:%.*]], label [[END:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PHI_IN:%.*]] = phi %pair* [ null, [[ENTRY:%.*]] ], [ [[B]], [[FOR]] ]
; CHECK-NEXT:    [[PHI_INSPT:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[I:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[I]] = add i32 [[PHI_INSPT]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[I]], 10
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[FOR]], label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi %pair* [ [[A]], [[ENTRY]] ], [ [[PHI_IN]], [[FOR]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[PHI]], i32 0, i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  %b = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  %gep_b = getelementptr inbounds %pair, %pair* %b, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  store i32 2, i32* %gep_b, align 4
  br i1 %cond, label %for, label %end

for:
  %phi_in = phi %pair * [ null, %entry ], [ %b, %for ]
  %phi_inspt = phi i32 [ 0, %entry ], [ %i, %for ]
  %i = add i32 %phi_inspt, 1
  %loop.cond = icmp ult i32 %i, 10
  br i1 %loop.cond, label %for, label %end

end:
  %phi = phi %pair* [ %a, %entry], [ %phi_in, %for ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

define i32 @test_sroa_gep_phi_gep(i1 %cond) {
; CHECK-LABEL: @test_sroa_gep_phi_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_SROA_0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[FOR:%.*]], label [[END:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PHI_I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[A_SROA_0]], [[ENTRY]] ], [ [[GEP_FOR:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[I]] = add i32 [[PHI_I]], 1
; CHECK-NEXT:    [[GEP_FOR]] = getelementptr inbounds i32, i32* [[PHI]], i32 0
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[I]], 10
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[FOR]], label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_END:%.*]] = phi i32* [ [[A_SROA_0]], [[ENTRY]] ], [ [[PHI]], [[FOR]] ]
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[PHI_END]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  br i1 %cond, label %for, label %end

for:
  %phi_i = phi i32 [ 0, %entry ], [ %i, %for ]
  %phi = phi i32* [ %gep_a, %entry], [ %gep_for, %for ]
  %i = add i32 %phi_i, 1
  %gep_for = getelementptr inbounds i32, i32* %phi, i32 0
  %loop.cond = icmp ult i32 %i, 10
  br i1 %loop.cond, label %for, label %end

end:
  %phi_end = phi i32* [ %gep_a, %entry], [ %phi, %for ]
  %load = load i32, i32* %phi_end, align 4
  ret i32 %load
}

define i32 @test_sroa_gep_cast_phi_gep(i1 %cond) {
; CHECK-LABEL: @test_sroa_gep_cast_phi_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_SROA_0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A_SROA_0_0_GEP_A_1_SROA_CAST:%.*]] = bitcast i32* [[A_SROA_0]] to float*
; CHECK-NEXT:    [[A_SROA_0_0_GEP_A_1_SROA_CAST2:%.*]] = bitcast i32* [[A_SROA_0]] to float*
; CHECK-NEXT:    [[A_SROA_0_0_GEP_SROA_CAST:%.*]] = bitcast i32* [[A_SROA_0]] to float*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[FOR:%.*]], label [[END:%.*]]
; CHECK:       for:
; CHECK-NEXT:    [[PHI_I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[PHI:%.*]] = phi float* [ [[A_SROA_0_0_GEP_A_1_SROA_CAST]], [[ENTRY]] ], [ [[GEP_FOR_2:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[PHI_SROA_PHI:%.*]] = phi float* [ [[A_SROA_0_0_GEP_SROA_CAST]], [[ENTRY]] ], [ [[GEP_FOR_2_SROA_GEP:%.*]], [[FOR]] ]
; CHECK-NEXT:    [[I]] = add i32 [[PHI_I]], 1
; CHECK-NEXT:    [[GEP_FOR_1:%.*]] = bitcast float* [[PHI_SROA_PHI]] to i32*
; CHECK-NEXT:    [[GEP_FOR_2]] = bitcast i32* [[GEP_FOR_1]] to float*
; CHECK-NEXT:    [[GEP_FOR_2_SROA_GEP]] = getelementptr inbounds float, float* [[GEP_FOR_2]], i32 0
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[I]], 10
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[FOR]], label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_END:%.*]] = phi float* [ [[A_SROA_0_0_GEP_A_1_SROA_CAST2]], [[ENTRY]] ], [ [[PHI]], [[FOR]] ]
; CHECK-NEXT:    [[PHI_END_1:%.*]] = bitcast float* [[PHI_END]] to i32*
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[PHI_END_1]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  %gep_a.1 = bitcast i32* %gep_a to float*
  br i1 %cond, label %for, label %end

for:
  %phi_i = phi i32 [ 0, %entry ], [ %i, %for ]
  %phi = phi float* [ %gep_a.1, %entry], [ %gep_for.2, %for ]
  %i = add i32 %phi_i, 1
  %gep_for = getelementptr inbounds float, float* %phi, i32 0
  %gep_for.1 = bitcast float* %gep_for to i32*
  %gep_for.2 = bitcast i32* %gep_for.1 to float*
  %loop.cond = icmp ult i32 %i, 10
  br i1 %loop.cond, label %for, label %end

end:
  %phi_end = phi float* [ %gep_a.1, %entry], [ %phi, %for ]
  %phi_end.1 = bitcast float* %phi_end to i32*
  %load = load i32, i32* %phi_end.1, align 4
  ret i32 %load
}

define i32 @test_sroa_invoke_phi_gep(i1 %cond) personality i32 (...)* @__gxx_personality_v0 {
; CHECK-LABEL: @test_sroa_invoke_phi_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [[PAIR:%.*]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[CALL:%.*]], label [[END:%.*]]
; CHECK:       call:
; CHECK-NEXT:    [[B:%.*]] = invoke %pair* @foo()
; CHECK-NEXT:    to label [[END]] unwind label [[INVOKE_CATCH:%.*]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi %pair* [ [[A]], [[ENTRY:%.*]] ], [ [[B]], [[CALL]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[PHI]], i32 0, i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
; CHECK:       invoke_catch:
; CHECK-NEXT:    [[RES:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    catch i8* null
; CHECK-NEXT:    ret i32 0
;
entry:
  %a = alloca %pair, align 4
  br i1 %cond, label %call, label %end

call:
  %b = invoke %pair* @foo()
  to label %end unwind label %invoke_catch

end:
  %phi = phi %pair* [ %a, %entry], [ %b, %call ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 0, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load

invoke_catch:
  %res = landingpad { i8*, i32 }
  catch i8* null
  ret i32 0
}

define i32 @test_sroa_phi_gep_nonconst_idx(i1 %cond, i32 %idx) {
; CHECK-LABEL: @test_sroa_phi_gep_nonconst_idx(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [[PAIR:%.*]], align 4
; CHECK-NEXT:    [[B:%.*]] = alloca [[PAIR]], align 4
; CHECK-NEXT:    [[GEP_A:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[A]], i32 0, i32 1
; CHECK-NEXT:    [[GEP_B:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[B]], i32 0, i32 1
; CHECK-NEXT:    store i32 1, i32* [[GEP_A]], align 4
; CHECK-NEXT:    store i32 2, i32* [[GEP_B]], align 4
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[IF_THEN:%.*]], label [[END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi %pair* [ [[A]], [[ENTRY:%.*]] ], [ [[B]], [[IF_THEN]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds [[PAIR]], %pair* [[PHI]], i32 [[IDX:%.*]], i32 1
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    ret i32 [[LOAD]]
;
entry:
  %a = alloca %pair, align 4
  %b = alloca %pair, align 4
  %gep_a = getelementptr inbounds %pair, %pair* %a, i32 0, i32 1
  %gep_b = getelementptr inbounds %pair, %pair* %b, i32 0, i32 1
  store i32 1, i32* %gep_a, align 4
  store i32 2, i32* %gep_b, align 4
  br i1 %cond, label %if.then, label %end

if.then:
  br label %end

end:
  %phi = phi %pair* [ %a, %entry], [ %b, %if.then ]
  %gep = getelementptr inbounds %pair, %pair* %phi, i32 %idx, i32 1
  %load = load i32, i32* %gep, align 4
  ret i32 %load
}

declare %pair* @foo()

declare i32 @__gxx_personality_v0(...)
