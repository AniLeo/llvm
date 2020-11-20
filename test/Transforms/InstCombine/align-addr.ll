; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "E-p:64:64:64-p1:32:32:32-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

; Instcombine should be able to prove vector alignment in the
; presence of a few mild address computation tricks.

define void @test0(i8* %b, i64 %n, i64 %u, i64 %y) nounwind  {
; CHECK-LABEL: @test0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = ptrtoint i8* [[B:%.*]] to i64
; CHECK-NEXT:    [[D:%.*]] = and i64 [[C]], -16
; CHECK-NEXT:    [[E:%.*]] = inttoptr i64 [[D]] to double*
; CHECK-NEXT:    [[V:%.*]] = shl i64 [[U:%.*]], 1
; CHECK-NEXT:    [[Z:%.*]] = and i64 [[Y:%.*]], -2
; CHECK-NEXT:    [[T1421:%.*]] = icmp eq i64 [[N:%.*]], 0
; CHECK-NEXT:    br i1 [[T1421]], label [[RETURN:%.*]], label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[INDVAR_NEXT:%.*]], [[BB]] ], [ 20, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[J:%.*]] = mul i64 [[I]], [[V]]
; CHECK-NEXT:    [[H:%.*]] = add i64 [[J]], [[Z]]
; CHECK-NEXT:    [[T8:%.*]] = getelementptr double, double* [[E]], i64 [[H]]
; CHECK-NEXT:    [[P:%.*]] = bitcast double* [[T8]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> zeroinitializer, <2 x double>* [[P]], align 16
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[I]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[RETURN]], label [[BB]]
; CHECK:       return:
; CHECK-NEXT:    ret void
;
entry:
  %c = ptrtoint i8* %b to i64
  %d = and i64 %c, -16
  %e = inttoptr i64 %d to double*
  %v = mul i64 %u, 2
  %z = and i64 %y, -2
  %t1421 = icmp eq i64 %n, 0
  br i1 %t1421, label %return, label %bb

bb:
  %i = phi i64 [ %indvar.next, %bb ], [ 20, %entry ]
  %j = mul i64 %i, %v
  %h = add i64 %j, %z
  %t8 = getelementptr double, double* %e, i64 %h
  %p = bitcast double* %t8 to <2 x double>*
  store <2 x double><double 0.0, double 0.0>, <2 x double>* %p, align 8
  %indvar.next = add i64 %i, 1
  %exitcond = icmp eq i64 %indvar.next, %n
  br i1 %exitcond, label %return, label %bb

return:
  ret void
}

; When we see a unaligned load from an insufficiently aligned global or
; alloca, increase the alignment of the load, turning it into an aligned load.

@GLOBAL = internal global [4 x i32] zeroinitializer

define <16 x i8> @test1(<2 x i64> %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load <16 x i8>, <16 x i8>* bitcast ([4 x i32]* @GLOBAL to <16 x i8>*), align 16
; CHECK-NEXT:    ret <16 x i8> [[TMP]]
;
entry:
  %tmp = load <16 x i8>, <16 x i8>* bitcast ([4 x i32]* @GLOBAL to <16 x i8>*), align 1
  ret <16 x i8> %tmp
}

@GLOBAL_as1 = internal addrspace(1) global [4 x i32] zeroinitializer

define <16 x i8> @test1_as1(<2 x i64> %x) {
; CHECK-LABEL: @test1_as1(
; CHECK-NEXT:    [[TMP:%.*]] = load <16 x i8>, <16 x i8> addrspace(1)* bitcast ([4 x i32] addrspace(1)* @GLOBAL_as1 to <16 x i8> addrspace(1)*), align 16
; CHECK-NEXT:    ret <16 x i8> [[TMP]]
;
  %tmp = load <16 x i8>, <16 x i8> addrspace(1)* bitcast ([4 x i32] addrspace(1)* @GLOBAL_as1 to <16 x i8> addrspace(1)*), align 1
  ret <16 x i8> %tmp
}

@GLOBAL_as1_gep = internal addrspace(1) global [8 x i32] zeroinitializer

define <16 x i8> @test1_as1_gep(<2 x i64> %x) {
; CHECK-LABEL: @test1_as1_gep(
; CHECK-NEXT:    [[TMP:%.*]] = load <16 x i8>, <16 x i8> addrspace(1)* bitcast (i32 addrspace(1)* getelementptr inbounds ([8 x i32], [8 x i32] addrspace(1)* @GLOBAL_as1_gep, i32 0, i32 4) to <16 x i8> addrspace(1)*), align 16
; CHECK-NEXT:    ret <16 x i8> [[TMP]]
;
  %tmp = load <16 x i8>, <16 x i8> addrspace(1)* bitcast (i32 addrspace(1)* getelementptr ([8 x i32], [8 x i32] addrspace(1)* @GLOBAL_as1_gep, i16 0, i16 4) to <16 x i8> addrspace(1)*), align 1
  ret <16 x i8> %tmp
}


; When a load or store lacks an explicit alignment, add one.

define double @test2(double* %p, double %n) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T:%.*]] = load double, double* [[P:%.*]], align 8
; CHECK-NEXT:    store double [[N:%.*]], double* [[P]], align 8
; CHECK-NEXT:    ret double [[T]]
;
  %t = load double, double* %p
  store double %n, double* %p
  ret double %t
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind

declare void @use(i8*)

%struct.s = type { i32, i32, i32, i32 }

define void @test3(%struct.s* sret(%struct.s) %a4) {
; Check that the alignment is bumped up the alignment of the sret type.
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[A4_CAST:%.*]] = bitcast %struct.s* [[A4:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(16) [[A4_CAST]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    call void @use(i8* [[A4_CAST]])
; CHECK-NEXT:    ret void
;
  %a4.cast = bitcast %struct.s* %a4 to i8*
  call void @llvm.memset.p0i8.i64(i8* %a4.cast, i8 0, i64 16, i1 false)
  call void @use(i8* %a4.cast)
  ret void
}
