; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=amdgcn-amd-amdhsa -S -structurizecfg %s | FileCheck %s

; StructurizeCFG::orderNodes used an arbitrary and nonsensical sorting
; function which broke the basic backedge identification algorithm. It
; would use RPO order, but then do a weird partial sort by the loop
; depth assuming blocks are sorted by loop. However a block can appear
; in between blocks of a loop that is not part of a loop, breaking the
; assumption of the sort.
;
; The collectInfos must be done in RPO order. The actual
; structurization order I think is less important, but unless the loop
; headers are identified in RPO order, it finds the wrong set of back
; edges.

define amdgpu_kernel void @loop_backedge_misidentified(i32 addrspace(1)* %arg0) #0 {
; CHECK-LABEL: @loop_backedge_misidentified(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load volatile <2 x i32>, <2 x i32> addrspace(1)* undef, align 16
; CHECK-NEXT:    [[LOAD1:%.*]] = load volatile <2 x float>, <2 x float> addrspace(1)* undef
; CHECK-NEXT:    [[TID:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i32, i32 addrspace(1)* [[ARG0:%.*]], i32 [[TID]]
; CHECK-NEXT:    [[I_INITIAL:%.*]] = load volatile i32, i32 addrspace(1)* [[GEP]], align 4
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       LOOP.HEADER:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[I_INITIAL]], [[ENTRY:%.*]] ], [ [[TMP10:%.*]], [[FLOW4:%.*]] ]
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x100b
; CHECK-NEXT:    [[TMP12:%.*]] = zext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* null, i64 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = load <4 x i32>, <4 x i32> addrspace(1)* [[TMP13]], align 16
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i32> [[TMP14]], i64 0
; CHECK-NEXT:    [[TMP16:%.*]] = and i32 [[TMP15]], 65535
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i32 [[TMP16]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[TMP17]], true
; CHECK-NEXT:    br i1 [[TMP0]], label [[BB62:%.*]], label [[FLOW:%.*]]
; CHECK:       Flow2:
; CHECK-NEXT:    br label [[FLOW]]
; CHECK:       bb18:
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i32> [[TMP]], i64 0
; CHECK-NEXT:    [[TMP22:%.*]] = lshr i32 [[TMP19]], 16
; CHECK-NEXT:    [[TMP24:%.*]] = urem i32 [[TMP22]], 52
; CHECK-NEXT:    [[TMP25:%.*]] = mul nuw nsw i32 [[TMP24]], 52
; CHECK-NEXT:    br label [[INNER_LOOP:%.*]]
; CHECK:       Flow3:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[TMP59:%.*]], [[INNER_LOOP_BREAK:%.*]] ], [ [[TMP7:%.*]], [[FLOW]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi i1 [ true, [[INNER_LOOP_BREAK]] ], [ [[TMP8:%.*]], [[FLOW]] ]
; CHECK-NEXT:    br i1 [[TMP2]], label [[END_ELSE_BLOCK:%.*]], label [[FLOW4]]
; CHECK:       INNER_LOOP:
; CHECK-NEXT:    [[INNER_LOOP_J:%.*]] = phi i32 [ [[INNER_LOOP_J_INC:%.*]], [[INNER_LOOP]] ], [ [[TMP25]], [[BB18:%.*]] ]
; CHECK-NEXT:    call void asm sideeffect "
; CHECK-NEXT:    [[INNER_LOOP_J_INC]] = add nsw i32 [[INNER_LOOP_J]], 1
; CHECK-NEXT:    [[INNER_LOOP_CMP:%.*]] = icmp eq i32 [[INNER_LOOP_J]], 0
; CHECK-NEXT:    br i1 [[INNER_LOOP_CMP]], label [[INNER_LOOP_BREAK]], label [[INNER_LOOP]]
; CHECK:       INNER_LOOP_BREAK:
; CHECK-NEXT:    [[TMP59]] = extractelement <4 x i32> [[TMP14]], i64 2
; CHECK-NEXT:    call void asm sideeffect "s_nop 23 ", "~{memory}"() #0
; CHECK-NEXT:    br label [[FLOW3:%.*]]
; CHECK:       bb62:
; CHECK-NEXT:    [[LOAD13:%.*]] = icmp ult i32 [[TMP16]], 271
; CHECK-NEXT:    [[TMP3:%.*]] = xor i1 [[LOAD13]], true
; CHECK-NEXT:    br i1 [[TMP3]], label [[INCREMENT_I:%.*]], label [[FLOW1:%.*]]
; CHECK:       Flow1:
; CHECK-NEXT:    [[TMP4:%.*]] = phi i32 [ [[INC_I:%.*]], [[INCREMENT_I]] ], [ undef, [[BB62]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = phi i1 [ true, [[INCREMENT_I]] ], [ false, [[BB62]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = phi i1 [ false, [[INCREMENT_I]] ], [ true, [[BB62]] ]
; CHECK-NEXT:    br i1 [[TMP6]], label [[BB64:%.*]], label [[FLOW2:%.*]]
; CHECK:       bb64:
; CHECK-NEXT:    call void asm sideeffect "s_nop 42", "~{memory}"() #0
; CHECK-NEXT:    br label [[FLOW2]]
; CHECK:       Flow:
; CHECK-NEXT:    [[TMP7]] = phi i32 [ [[TMP4]], [[FLOW2]] ], [ undef, [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[TMP8]] = phi i1 [ [[TMP5]], [[FLOW2]] ], [ false, [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = phi i1 [ false, [[FLOW2]] ], [ true, [[LOOP_HEADER]] ]
; CHECK-NEXT:    br i1 [[TMP9]], label [[BB18]], label [[FLOW3]]
; CHECK:       INCREMENT_I:
; CHECK-NEXT:    [[INC_I]] = add i32 [[I]], 1
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x1336
; CHECK-NEXT:    br label [[FLOW1]]
; CHECK:       END_ELSE_BLOCK:
; CHECK-NEXT:    [[I_FINAL:%.*]] = phi i32 [ [[TMP1]], [[FLOW3]] ]
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x1337
; CHECK-NEXT:    [[CMP_END_ELSE_BLOCK:%.*]] = icmp eq i32 [[I_FINAL]], -1
; CHECK-NEXT:    br label [[FLOW4]]
; CHECK:       Flow4:
; CHECK-NEXT:    [[TMP10]] = phi i32 [ [[I_FINAL]], [[END_ELSE_BLOCK]] ], [ undef, [[FLOW3]] ]
; CHECK-NEXT:    [[TMP11:%.*]] = phi i1 [ [[CMP_END_ELSE_BLOCK]], [[END_ELSE_BLOCK]] ], [ true, [[FLOW3]] ]
; CHECK-NEXT:    br i1 [[TMP11]], label [[RETURN:%.*]], label [[LOOP_HEADER]]
; CHECK:       RETURN:
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x99
; CHECK-NEXT:    store volatile <2 x float> [[LOAD1]], <2 x float> addrspace(1)* undef, align 8
; CHECK-NEXT:    ret void
;
entry:
  %tmp = load volatile <2 x i32>, <2 x i32> addrspace(1)* undef, align 16
  %load1 = load volatile <2 x float>, <2 x float> addrspace(1)* undef
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr inbounds i32, i32 addrspace(1)* %arg0, i32 %tid
  %i.initial = load volatile i32, i32 addrspace(1)* %gep, align 4
  br label %LOOP.HEADER

LOOP.HEADER:
  %i = phi i32 [ %i.final, %END_ELSE_BLOCK ], [ %i.initial, %entry ]
  call void asm sideeffect "s_nop 0x100b ; loop $0 ", "r,~{memory}"(i32 %i) #0
  %tmp12 = zext i32 %i to i64
  %tmp13 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* null, i64 %tmp12
  %tmp14 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp13, align 16
  %tmp15 = extractelement <4 x i32> %tmp14, i64 0
  %tmp16 = and i32 %tmp15, 65535
  %tmp17 = icmp eq i32 %tmp16, 1
  br i1 %tmp17, label %bb18, label %bb62

bb18:
  %tmp19 = extractelement <2 x i32> %tmp, i64 0
  %tmp22 = lshr i32 %tmp19, 16
  %tmp24 = urem i32 %tmp22, 52
  %tmp25 = mul nuw nsw i32 %tmp24, 52
  br label %INNER_LOOP

INNER_LOOP:
  %inner.loop.j = phi i32 [ %tmp25, %bb18 ], [ %inner.loop.j.inc, %INNER_LOOP ]
  call void asm sideeffect "; inner loop body", ""() #0
  %inner.loop.j.inc = add nsw i32 %inner.loop.j, 1
  %inner.loop.cmp = icmp eq i32 %inner.loop.j, 0
  br i1 %inner.loop.cmp, label %INNER_LOOP_BREAK, label %INNER_LOOP

INNER_LOOP_BREAK:
  %tmp59 = extractelement <4 x i32> %tmp14, i64 2
  call void asm sideeffect "s_nop 23 ", "~{memory}"() #0
  br label %END_ELSE_BLOCK

bb62:
  %load13 = icmp ult i32 %tmp16, 271
  br i1 %load13, label %bb64, label %INCREMENT_I

bb64:
  call void asm sideeffect "s_nop 42", "~{memory}"() #0
  br label %RETURN

INCREMENT_I:
  %inc.i = add i32 %i, 1
  call void asm sideeffect "s_nop 0x1336 ; increment $0", "v,~{memory}"(i32 %inc.i) #0
  br label %END_ELSE_BLOCK

END_ELSE_BLOCK:
  %i.final = phi i32 [ %tmp59, %INNER_LOOP_BREAK ], [ %inc.i, %INCREMENT_I ]
  call void asm sideeffect "s_nop 0x1337 ; end else block $0", "v,~{memory}"(i32 %i.final) #0
  %cmp.end.else.block = icmp eq i32 %i.final, -1
  br i1 %cmp.end.else.block, label %RETURN, label %LOOP.HEADER

RETURN:
  call void asm sideeffect "s_nop 0x99 ; ClosureEval return", "~{memory}"() #0
  store volatile <2 x float> %load1, <2 x float> addrspace(1)* undef, align 8
  ret void
}

; The same function, except break to return block goes directly to the
; return, which managed to hide the bug.
define amdgpu_kernel void @loop_backedge_misidentified_alt(i32 addrspace(1)* %arg0) #0 {
; CHECK-LABEL: @loop_backedge_misidentified_alt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load volatile <2 x i32>, <2 x i32> addrspace(1)* undef, align 16
; CHECK-NEXT:    [[LOAD1:%.*]] = load volatile <2 x float>, <2 x float> addrspace(1)* undef
; CHECK-NEXT:    [[TID:%.*]] = call i32 @llvm.amdgcn.workitem.id.x()
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i32, i32 addrspace(1)* [[ARG0:%.*]], i32 [[TID]]
; CHECK-NEXT:    [[I_INITIAL:%.*]] = load volatile i32, i32 addrspace(1)* [[GEP]], align 4
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       LOOP.HEADER:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[I_INITIAL]], [[ENTRY:%.*]] ], [ [[TMP9:%.*]], [[FLOW3:%.*]] ]
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x100b
; CHECK-NEXT:    [[TMP12:%.*]] = zext i32 [[I]] to i64
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* null, i64 [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = load <4 x i32>, <4 x i32> addrspace(1)* [[TMP13]], align 16
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x i32> [[TMP14]], i64 0
; CHECK-NEXT:    [[TMP16:%.*]] = and i32 [[TMP15]], 65535
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq i32 [[TMP16]], 1
; CHECK-NEXT:    [[TMP0:%.*]] = xor i1 [[TMP17]], true
; CHECK-NEXT:    br i1 [[TMP0]], label [[BB62:%.*]], label [[FLOW:%.*]]
; CHECK:       Flow1:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i32 [ [[INC_I:%.*]], [[INCREMENT_I:%.*]] ], [ undef, [[BB62]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = phi i1 [ true, [[INCREMENT_I]] ], [ false, [[BB62]] ]
; CHECK-NEXT:    br label [[FLOW]]
; CHECK:       bb18:
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i32> [[TMP]], i64 0
; CHECK-NEXT:    [[TMP22:%.*]] = lshr i32 [[TMP19]], 16
; CHECK-NEXT:    [[TMP24:%.*]] = urem i32 [[TMP22]], 52
; CHECK-NEXT:    [[TMP25:%.*]] = mul nuw nsw i32 [[TMP24]], 52
; CHECK-NEXT:    br label [[INNER_LOOP:%.*]]
; CHECK:       Flow2:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i32 [ [[TMP59:%.*]], [[INNER_LOOP_BREAK:%.*]] ], [ [[TMP6:%.*]], [[FLOW]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = phi i1 [ true, [[INNER_LOOP_BREAK]] ], [ [[TMP7:%.*]], [[FLOW]] ]
; CHECK-NEXT:    br i1 [[TMP4]], label [[END_ELSE_BLOCK:%.*]], label [[FLOW3]]
; CHECK:       INNER_LOOP:
; CHECK-NEXT:    [[INNER_LOOP_J:%.*]] = phi i32 [ [[INNER_LOOP_J_INC:%.*]], [[INNER_LOOP]] ], [ [[TMP25]], [[BB18:%.*]] ]
; CHECK-NEXT:    call void asm sideeffect "
; CHECK-NEXT:    [[INNER_LOOP_J_INC]] = add nsw i32 [[INNER_LOOP_J]], 1
; CHECK-NEXT:    [[INNER_LOOP_CMP:%.*]] = icmp eq i32 [[INNER_LOOP_J]], 0
; CHECK-NEXT:    br i1 [[INNER_LOOP_CMP]], label [[INNER_LOOP_BREAK]], label [[INNER_LOOP]]
; CHECK:       INNER_LOOP_BREAK:
; CHECK-NEXT:    [[TMP59]] = extractelement <4 x i32> [[TMP14]], i64 2
; CHECK-NEXT:    call void asm sideeffect "s_nop 23 ", "~{memory}"() #0
; CHECK-NEXT:    br label [[FLOW2:%.*]]
; CHECK:       bb62:
; CHECK-NEXT:    [[LOAD13:%.*]] = icmp ult i32 [[TMP16]], 271
; CHECK-NEXT:    [[TMP5:%.*]] = xor i1 [[LOAD13]], true
; CHECK-NEXT:    br i1 [[TMP5]], label [[INCREMENT_I]], label [[FLOW1:%.*]]
; CHECK:       bb64:
; CHECK-NEXT:    call void asm sideeffect "s_nop 42", "~{memory}"() #0
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       Flow:
; CHECK-NEXT:    [[TMP6]] = phi i32 [ [[TMP1]], [[FLOW1]] ], [ undef, [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[TMP7]] = phi i1 [ [[TMP2]], [[FLOW1]] ], [ false, [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = phi i1 [ false, [[FLOW1]] ], [ true, [[LOOP_HEADER]] ]
; CHECK-NEXT:    br i1 [[TMP8]], label [[BB18]], label [[FLOW2]]
; CHECK:       INCREMENT_I:
; CHECK-NEXT:    [[INC_I]] = add i32 [[I]], 1
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x1336
; CHECK-NEXT:    br label [[FLOW1]]
; CHECK:       END_ELSE_BLOCK:
; CHECK-NEXT:    [[I_FINAL:%.*]] = phi i32 [ [[TMP3]], [[FLOW2]] ]
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x1337
; CHECK-NEXT:    [[CMP_END_ELSE_BLOCK:%.*]] = icmp eq i32 [[I_FINAL]], -1
; CHECK-NEXT:    br label [[FLOW3]]
; CHECK:       Flow3:
; CHECK-NEXT:    [[TMP9]] = phi i32 [ [[I_FINAL]], [[END_ELSE_BLOCK]] ], [ undef, [[FLOW2]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = phi i1 [ [[CMP_END_ELSE_BLOCK]], [[END_ELSE_BLOCK]] ], [ true, [[FLOW2]] ]
; CHECK-NEXT:    br i1 [[TMP10]], label [[RETURN]], label [[LOOP_HEADER]]
; CHECK:       RETURN:
; CHECK-NEXT:    call void asm sideeffect "s_nop 0x99
; CHECK-NEXT:    store volatile <2 x float> [[LOAD1]], <2 x float> addrspace(1)* undef, align 8
; CHECK-NEXT:    ret void
;
entry:
  %tmp = load volatile <2 x i32>, <2 x i32> addrspace(1)* undef, align 16
  %load1 = load volatile <2 x float>, <2 x float> addrspace(1)* undef
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr inbounds i32, i32 addrspace(1)* %arg0, i32 %tid
  %i.initial = load volatile i32, i32 addrspace(1)* %gep, align 4
  br label %LOOP.HEADER

LOOP.HEADER:
  %i = phi i32 [ %i.final, %END_ELSE_BLOCK ], [ %i.initial, %entry ]
  call void asm sideeffect "s_nop 0x100b ; loop $0 ", "r,~{memory}"(i32 %i) #0
  %tmp12 = zext i32 %i to i64
  %tmp13 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* null, i64 %tmp12
  %tmp14 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp13, align 16
  %tmp15 = extractelement <4 x i32> %tmp14, i64 0
  %tmp16 = and i32 %tmp15, 65535
  %tmp17 = icmp eq i32 %tmp16, 1
  br i1 %tmp17, label %bb18, label %bb62

bb18:
  %tmp19 = extractelement <2 x i32> %tmp, i64 0
  %tmp22 = lshr i32 %tmp19, 16
  %tmp24 = urem i32 %tmp22, 52
  %tmp25 = mul nuw nsw i32 %tmp24, 52
  br label %INNER_LOOP

INNER_LOOP:
  %inner.loop.j = phi i32 [ %tmp25, %bb18 ], [ %inner.loop.j.inc, %INNER_LOOP ]
  call void asm sideeffect "; inner loop body", ""() #0
  %inner.loop.j.inc = add nsw i32 %inner.loop.j, 1
  %inner.loop.cmp = icmp eq i32 %inner.loop.j, 0
  br i1 %inner.loop.cmp, label %INNER_LOOP_BREAK, label %INNER_LOOP

INNER_LOOP_BREAK:
  %tmp59 = extractelement <4 x i32> %tmp14, i64 2
  call void asm sideeffect "s_nop 23 ", "~{memory}"() #0
  br label %END_ELSE_BLOCK

bb62:
  %load13 = icmp ult i32 %tmp16, 271
  ;br i1 %load13, label %bb64, label %INCREMENT_I
  ; branching directly to the return avoids the bug
  br i1 %load13, label %RETURN, label %INCREMENT_I


bb64:
  call void asm sideeffect "s_nop 42", "~{memory}"() #0
  br label %RETURN

INCREMENT_I:
  %inc.i = add i32 %i, 1
  call void asm sideeffect "s_nop 0x1336 ; increment $0", "v,~{memory}"(i32 %inc.i) #0
  br label %END_ELSE_BLOCK

END_ELSE_BLOCK:
  %i.final = phi i32 [ %tmp59, %INNER_LOOP_BREAK ], [ %inc.i, %INCREMENT_I ]
  call void asm sideeffect "s_nop 0x1337 ; end else block $0", "v,~{memory}"(i32 %i.final) #0
  %cmp.end.else.block = icmp eq i32 %i.final, -1
  br i1 %cmp.end.else.block, label %RETURN, label %LOOP.HEADER

RETURN:
  call void asm sideeffect "s_nop 0x99 ; ClosureEval return", "~{memory}"() #0
  store volatile <2 x float> %load1, <2 x float> addrspace(1)* undef, align 8
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

attributes #0 = { convergent nounwind }
attributes #1 = { convergent nounwind readnone }
