; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -argpromotion -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s
; RUN: opt -S -passes=argpromotion -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s

; Test to check that we do not promote arguments when the
; type size is greater than 128 bits.

define internal fastcc void @print_acc(<512 x i1>* nocapture readonly %a) nounwind {
; CHECK-LABEL: @print_acc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <512 x i1>, <512 x i1>* [[A:%.*]], align 64
; CHECK-NEXT:    [[TMP1:%.*]] = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1> [[TMP0]])
; CHECK-NEXT:    [[TMP2:%.*]] = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } [[TMP1]], 0
; CHECK-NEXT:    ret void
;
entry:
  %0 = load <512 x i1>, <512 x i1>* %a, align 64
  %1 = tail call { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1> %0)
  %2 = extractvalue { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } %1, 0
  ret void
}

declare { <16 x i8>, <16 x i8>, <16 x i8>, <16 x i8> } @llvm.ppc.mma.disassemble.acc(<512 x i1>) nounwind

define dso_local void @test(<512 x i1>* nocapture %a, <16 x i8> %ac) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call <512 x i1> @llvm.ppc.mma.xvf32ger(<16 x i8> [[AC:%.*]], <16 x i8> [[AC]])
; CHECK-NEXT:    store <512 x i1> [[TMP0]], <512 x i1>* [[A:%.*]], align 64
; CHECK-NEXT:    tail call fastcc void @print_acc(<512 x i1>* nonnull [[A]])
; CHECK-NEXT:    ret void
;
entry:
  %0 = tail call <512 x i1> @llvm.ppc.mma.xvf32ger(<16 x i8> %ac, <16 x i8> %ac)
  store <512 x i1> %0, <512 x i1>* %a, align 64
  tail call fastcc void @print_acc(<512 x i1>* nonnull %a)
  ret void
}

declare <512 x i1> @llvm.ppc.mma.xvf32ger(<16 x i8>, <16 x i8>) nounwind

@.str = private unnamed_addr constant [11 x i8] c"Vector: { \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%d, \00", align 1
@.str.2 = private unnamed_addr constant [6 x i8] c"%d }\0A\00", align 1

define internal fastcc void @printWideVec(<16 x i32> %ptr.val) nounwind {
; CHECK-LABEL: @printWideVec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0))
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <16 x i32> [[PTR_VAL:%.*]], i32 0
; CHECK-NEXT:    [[CALL1:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT]])
; CHECK-NEXT:    [[VECEXT_1:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 1
; CHECK-NEXT:    [[CALL1_1:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_1]])
; CHECK-NEXT:    [[VECEXT_2:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 2
; CHECK-NEXT:    [[CALL1_2:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_2]])
; CHECK-NEXT:    [[VECEXT_3:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 3
; CHECK-NEXT:    [[CALL1_3:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_3]])
; CHECK-NEXT:    [[VECEXT_4:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 4
; CHECK-NEXT:    [[CALL1_4:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_4]])
; CHECK-NEXT:    [[VECEXT_5:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 5
; CHECK-NEXT:    [[CALL1_5:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_5]])
; CHECK-NEXT:    [[VECEXT_6:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 6
; CHECK-NEXT:    [[CALL1_6:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext [[VECEXT_6]])
; CHECK-NEXT:    [[VECEXT2:%.*]] = extractelement <16 x i32> [[PTR_VAL]], i32 7
; CHECK-NEXT:    [[CALL3:%.*]] = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0), i32 signext [[VECEXT2]])
; CHECK-NEXT:    ret void
;
entry:
  %call = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0))
  %vecext = extractelement <16 x i32> %ptr.val, i32 0
  %call1 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext)
  %vecext.1 = extractelement <16 x i32> %ptr.val, i32 1
  %call1.1 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.1)
  %vecext.2 = extractelement <16 x i32> %ptr.val, i32 2
  %call1.2 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.2)
  %vecext.3 = extractelement <16 x i32> %ptr.val, i32 3
  %call1.3 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.3)
  %vecext.4 = extractelement <16 x i32> %ptr.val, i32 4
  %call1.4 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.4)
  %vecext.5 = extractelement <16 x i32> %ptr.val, i32 5
  %call1.5 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.5)
  %vecext.6 = extractelement <16 x i32> %ptr.val, i32 6
  %call1.6 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 signext %vecext.6)
  %vecext2 = extractelement <16 x i32> %ptr.val, i32 7
  %call3 = tail call signext i32 (i8*, ...) @printf(i8* nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0), i32 signext %vecext2)
  ret void
}

declare noundef signext i32 @printf(i8* nocapture noundef readonly, ...) nounwind

define dso_local void @test1(<4 x i32> %a, <4 x i32> %b) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <4 x i32> [[A:%.*]], <4 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i32> [[TMP0]], <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[VECINIT22:%.*]] = shufflevector <16 x i32> [[TMP2]], <16 x i32> [[TMP1]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    tail call fastcc void @printWideVec(<16 x i32> [[VECINIT22]])
; CHECK-NEXT:    ret void
;
entry:
  %0 = shufflevector <4 x i32> %a, <4 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %1 = shufflevector <4 x i32> %b, <4 x i32> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = shufflevector <16 x i32> %0, <16 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %vecinit22 = shufflevector <16 x i32> %2, <16 x i32> %1, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 16, i32 17, i32 18, i32 19, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  tail call fastcc void @printWideVec(<16 x i32> %vecinit22)
  ret void
}
