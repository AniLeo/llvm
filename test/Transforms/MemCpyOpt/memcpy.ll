; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -memcpyopt -dse -S -enable-memcpyopt-memoryssa=0 | FileCheck %s
; RUN: opt < %s -basic-aa -memcpyopt -dse -S -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i686-apple-darwin9"

%0 = type { x86_fp80, x86_fp80 }
%1 = type { i32, i32 }

define void @test1(%0* sret(%0)  %agg.result, x86_fp80 %z.0, x86_fp80 %z.1) nounwind  {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP2:%.*]] = alloca [[TMP0:%.*]], align 16
; CHECK-NEXT:    [[MEMTMP:%.*]] = alloca [[TMP0]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = fsub x86_fp80 0xK80000000000000000000, [[Z_1:%.*]]
; CHECK-NEXT:    call void @ccoshl(%0* sret(%0) [[TMP2]], x86_fp80 [[TMP5]], x86_fp80 [[Z_0:%.*]]) [[ATTR0:#.*]]
; CHECK-NEXT:    [[TMP219:%.*]] = bitcast %0* [[TMP2]] to i8*
; CHECK-NEXT:    [[MEMTMP20:%.*]] = bitcast %0* [[MEMTMP]] to i8*
; CHECK-NEXT:    [[AGG_RESULT21:%.*]] = bitcast %0* [[AGG_RESULT:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 [[AGG_RESULT21]], i8* align 16 [[TMP219]], i32 32, i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %tmp2 = alloca %0
  %memtmp = alloca %0, align 16
  %tmp5 = fsub x86_fp80 0xK80000000000000000000, %z.1
  call void @ccoshl(%0* sret(%0) %memtmp, x86_fp80 %tmp5, x86_fp80 %z.0) nounwind
  %tmp219 = bitcast %0* %tmp2 to i8*
  %memtmp20 = bitcast %0* %memtmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %tmp219, i8* align 16 %memtmp20, i32 32, i1 false)
  %agg.result21 = bitcast %0* %agg.result to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %agg.result21, i8* align 16 %tmp219, i32 32, i1 false)
  ret void

; Check that one of the memcpy's are removed.
;; FIXME: PR 8643 We should be able to eliminate the last memcpy here.

}

declare void @ccoshl(%0* nocapture sret(%0), x86_fp80, x86_fp80) nounwind


; The intermediate alloca and one of the memcpy's should be eliminated, the
; other should be related with a memmove.
define void @test2(i8* %P, i8* %Q) nounwind  {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i32(i8* align 16 [[Q:%.*]], i8* align 16 [[P:%.*]], i32 32, i1 false)
; CHECK-NEXT:    ret void
;
  %memtmp = alloca %0, align 16
  %R = bitcast %0* %memtmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %R, i8* align 16 %P, i32 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %Q, i8* align 16 %R, i32 32, i1 false)
  ret void

}

; The intermediate alloca and one of the memcpy's should be eliminated, the
; other should be related with a memcpy.
define void @test2_memcpy(i8* noalias %P, i8* noalias %Q) nounwind  {
; CHECK-LABEL: @test2_memcpy(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 [[Q:%.*]], i8* align 16 [[P:%.*]], i32 32, i1 false)
; CHECK-NEXT:    ret void
;
  %memtmp = alloca %0, align 16
  %R = bitcast %0* %memtmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %R, i8* align 16 %P, i32 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %Q, i8* align 16 %R, i32 32, i1 false)
  ret void

}




@x = external global %0

define void @test3(%0* noalias sret(%0) %agg.result) nounwind  {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[X_0:%.*]] = alloca [[TMP0:%.*]], align 16
; CHECK-NEXT:    [[X_01:%.*]] = bitcast %0* [[X_0]] to i8*
; CHECK-NEXT:    [[AGG_RESULT1:%.*]] = bitcast %0* [[AGG_RESULT:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 [[AGG_RESULT1]], i8* align 16 bitcast (%0* @x to i8*), i32 32, i1 false)
; CHECK-NEXT:    [[AGG_RESULT2:%.*]] = bitcast %0* [[AGG_RESULT]] to i8*
; CHECK-NEXT:    ret void
;
  %x.0 = alloca %0
  %x.01 = bitcast %0* %x.0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %x.01, i8* align 16 bitcast (%0* @x to i8*), i32 32, i1 false)
  %agg.result2 = bitcast %0* %agg.result to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %agg.result2, i8* align 16 %x.01, i32 32, i1 false)
  ret void
}


; PR8644
define void @test4(i8 *%P) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    call void @test4a(i8* byval(i8) align 1 [[P:%.*]])
; CHECK-NEXT:    ret void
;
  %A = alloca %1
  %a = bitcast %1* %A to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %a, i8* align 4 %P, i64 8, i1 false)
  call void @test4a(i8* align 1 byval(i8) %a)
  ret void
}

; Make sure we don't remove the memcpy if the source address space doesn't match the byval argument
define void @test4_addrspace(i8 addrspace(1)* %P) {
; CHECK-LABEL: @test4_addrspace(
; CHECK-NEXT:    [[A1:%.*]] = alloca [[TMP1:%.*]], align 8
; CHECK-NEXT:    [[A2:%.*]] = bitcast %1* [[A1]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 4 [[A2]], i8 addrspace(1)* align 4 [[P:%.*]], i64 8, i1 false)
; CHECK-NEXT:    call void @test4a(i8* byval(i8) align 1 [[A2]])
; CHECK-NEXT:    ret void
;
  %a1 = alloca %1
  %a2 = bitcast %1* %a1 to i8*
  call void @llvm.memcpy.p0i8.p1i8.i64(i8* align 4 %a2, i8 addrspace(1)* align 4 %P, i64 8, i1 false)
  call void @test4a(i8* align 1 byval(i8) %a2)
  ret void
}

define void @test4_write_between(i8 *%P) {
; CHECK-LABEL: @test4_write_between(
; CHECK-NEXT:    [[A1:%.*]] = alloca [[TMP1:%.*]], align 8
; CHECK-NEXT:    [[A2:%.*]] = bitcast %1* [[A1]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[A2]], i8* align 4 [[P:%.*]], i64 8, i1 false)
; CHECK-NEXT:    store i8 0, i8* [[A2]], align 1
; CHECK-NEXT:    call void @test4a(i8* byval(i8) align 1 [[A2]])
; CHECK-NEXT:    ret void
;
  %a1 = alloca %1
  %a2 = bitcast %1* %a1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %a2, i8* align 4 %P, i64 8, i1 false)
  store i8 0, i8* %a2
  call void @test4a(i8* align 1 byval(i8) %a2)
  ret void
}

define i8 @test4_read_between(i8 *%P) {
; CHECK-LABEL: @test4_read_between(
; CHECK-NEXT:    [[A1:%.*]] = alloca [[TMP1:%.*]], align 8
; CHECK-NEXT:    [[A2:%.*]] = bitcast %1* [[A1]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[A2]], i8* align 4 [[P:%.*]], i64 8, i1 false)
; CHECK-NEXT:    [[X:%.*]] = load i8, i8* [[A2]], align 1
; CHECK-NEXT:    call void @test4a(i8* byval(i8) align 1 [[A2]])
; CHECK-NEXT:    ret i8 [[X]]
;
  %a1 = alloca %1
  %a2 = bitcast %1* %a1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %a2, i8* align 4 %P, i64 8, i1 false)
  %x = load i8, i8* %a2
  call void @test4a(i8* align 1 byval(i8) %a2)
  ret i8 %x
}

define void @test4_non_local(i8 *%P, i1 %c) {
; CHECK-LABEL: @test4_non_local(
; CHECK-NEXT:    [[A1:%.*]] = alloca [[TMP1:%.*]], align 8
; CHECK-NEXT:    [[A2:%.*]] = bitcast %1* [[A1]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[A2]], i8* align 4 [[P:%.*]], i64 8, i1 false)
; CHECK-NEXT:    br i1 [[C:%.*]], label [[CALL:%.*]], label [[EXIT:%.*]]
; CHECK:       call:
; CHECK-NEXT:    call void @test4a(i8* byval(i8) align 1 [[A2]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  %a1 = alloca %1
  %a2 = bitcast %1* %a1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %a2, i8* align 4 %P, i64 8, i1 false)
  br i1 %c, label %call, label %exit

call:
  call void @test4a(i8* align 1 byval(i8) %a2)
  br label %exit

exit:
  ret void
}

declare void @test4a(i8* align 1 byval(i8))
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.p0i8.p1i8.i64(i8* nocapture, i8 addrspace(1)* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.p1i8.p1i8.i64(i8 addrspace(1)* nocapture, i8 addrspace(1)* nocapture, i64, i1) nounwind

%struct.S = type { i128, [4 x i8]}

@sS = external global %struct.S, align 16

declare void @test5a(%struct.S* align 16 byval(%struct.S)) nounwind ssp


; rdar://8713376 - This memcpy can't be eliminated.
define i32 @test5(i32 %x) nounwind ssp {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[Y:%.*]] = alloca [[STRUCT_S:%.*]], align 16
; CHECK-NEXT:    [[TMP:%.*]] = bitcast %struct.S* [[Y]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 [[TMP]], i8* align 16 bitcast (%struct.S* @sS to i8*), i64 32, i1 false)
; CHECK-NEXT:    [[A:%.*]] = getelementptr [[STRUCT_S]], %struct.S* [[Y]], i64 0, i32 1, i64 0
; CHECK-NEXT:    store i8 4, i8* [[A]], align 1
; CHECK-NEXT:    call void @test5a(%struct.S* byval(%struct.S) align 16 [[Y]])
; CHECK-NEXT:    ret i32 0
;
entry:
  %y = alloca %struct.S, align 16
  %tmp = bitcast %struct.S* %y to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %tmp, i8* align 16 bitcast (%struct.S* @sS to i8*), i64 32, i1 false)
  %a = getelementptr %struct.S, %struct.S* %y, i64 0, i32 1, i64 0
  store i8 4, i8* %a
  call void @test5a(%struct.S* align 16 byval(%struct.S) %y)
  ret i32 0
}

;; Noop memcpy should be zapped.
define void @test6(i8 *%P) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %P, i8* align 4 %P, i64 8, i1 false)
  ret void
}


; PR9794 - Should forward memcpy into byval argument even though the memcpy
; isn't itself 8 byte aligned.
%struct.p = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }

define i32 @test7(%struct.p* nocapture align 8 byval(%struct.p) %q) nounwind ssp {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @g(%struct.p* byval(%struct.p) align 8 [[Q:%.*]]) [[ATTR0]]
; CHECK-NEXT:    ret i32 [[CALL]]
;
entry:
  %agg.tmp = alloca %struct.p, align 4
  %tmp = bitcast %struct.p* %agg.tmp to i8*
  %tmp1 = bitcast %struct.p* %q to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %tmp, i8* align 4 %tmp1, i64 48, i1 false)
  %call = call i32 @g(%struct.p* align 8 byval(%struct.p) %agg.tmp) nounwind
  ret i32 %call
}

declare i32 @g(%struct.p* align 8 byval(%struct.p))

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind

; PR11142 - When looking for a memcpy-memcpy dependency, don't get stuck on
; instructions between the memcpy's that only affect the destination pointer.
@test8.str = internal constant [7 x i8] c"ABCDEF\00"

define void @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    ret void
;
  %A = tail call i8* @malloc(i32 10)
  %B = getelementptr inbounds i8, i8* %A, i64 2
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %B, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @test8.str, i64 0, i64 0), i32 7, i1 false)
  %C = tail call i8* @malloc(i32 10)
  %D = getelementptr inbounds i8, i8* %C, i64 2
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %D, i8* %B, i32 7, i1 false)
  ret void
}

declare noalias i8* @malloc(i32)

; rdar://11341081
%struct.big = type { [50 x i32] }

define void @test9_addrspacecast() nounwind ssp uwtable {
; CHECK-LABEL: @test9_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = alloca [[STRUCT_BIG:%.*]], align 4
; CHECK-NEXT:    [[TMP:%.*]] = alloca [[STRUCT_BIG]], align 4
; CHECK-NEXT:    call void @f1(%struct.big* sret(%struct.big) [[B]])
; CHECK-NEXT:    [[TMP0:%.*]] = addrspacecast %struct.big* [[B]] to i8 addrspace(1)*
; CHECK-NEXT:    [[TMP1:%.*]] = addrspacecast %struct.big* [[TMP]] to i8 addrspace(1)*
; CHECK-NEXT:    call void @f2(%struct.big* [[B]])
; CHECK-NEXT:    ret void
;
entry:
  %b = alloca %struct.big, align 4
  %tmp = alloca %struct.big, align 4
  call void @f1(%struct.big* sret(%struct.big) %tmp)
  %0 = addrspacecast %struct.big* %b to i8 addrspace(1)*
  %1 = addrspacecast %struct.big* %tmp to i8 addrspace(1)*
  call void @llvm.memcpy.p1i8.p1i8.i64(i8 addrspace(1)* align 4 %0, i8 addrspace(1)* align 4 %1, i64 200, i1 false)
  call void @f2(%struct.big* %b)
  ret void
}

define void @test9() nounwind ssp uwtable {
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = alloca [[STRUCT_BIG:%.*]], align 4
; CHECK-NEXT:    [[TMP:%.*]] = alloca [[STRUCT_BIG]], align 4
; CHECK-NEXT:    call void @f1(%struct.big* sret(%struct.big) [[B]])
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.big* [[B]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast %struct.big* [[TMP]] to i8*
; CHECK-NEXT:    call void @f2(%struct.big* [[B]])
; CHECK-NEXT:    ret void
;
entry:
  %b = alloca %struct.big, align 4
  %tmp = alloca %struct.big, align 4
  call void @f1(%struct.big* sret(%struct.big) %tmp)
  %0 = bitcast %struct.big* %b to i8*
  %1 = bitcast %struct.big* %tmp to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %0, i8* align 4 %1, i64 200, i1 false)
  call void @f2(%struct.big* %b)
  ret void
}

; rdar://14073661.
; Test10 triggered assertion when the compiler try to get the size of the
; opaque type of *x, where the x is the formal argument with attribute 'sret'.

%opaque = type opaque
declare void @foo(i32* noalias nocapture)

define void @test10(%opaque* noalias nocapture sret(%opaque) %x, i32 %y) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 [[Y:%.*]], i32* [[A]], align 4
; CHECK-NEXT:    call void @foo(i32* noalias nocapture [[A]])
; CHECK-NEXT:    [[C:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    [[D:%.*]] = bitcast %opaque* [[X:%.*]] to i32*
; CHECK-NEXT:    store i32 [[C]], i32* [[D]], align 4
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  store i32 %y, i32* %a
  call void @foo(i32* noalias nocapture %a)
  %c = load i32, i32* %a
  %d = bitcast %opaque* %x to i32*
  store i32 %c, i32* %d
  ret void
}

; don't create new addressspacecasts when we don't know they're safe for the target
define void @test11([20 x i32] addrspace(1)* nocapture dereferenceable(80) %P) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = bitcast [20 x i32] addrspace(1)* [[P:%.*]] to i8 addrspace(1)*
; CHECK-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* align 4 [[B]], i8 0, i64 80, i1 false)
; CHECK-NEXT:    ret void
;
  %A = alloca [20 x i32], align 4
  %a = bitcast [20 x i32]* %A to i8*
  %b = bitcast [20 x i32] addrspace(1)* %P to i8 addrspace(1)*
  call void @llvm.memset.p0i8.i64(i8* align 4 %a, i8 0, i64 80, i1 false)
  call void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* align 4 %b, i8* align 4 %a, i64 80, i1 false)
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memcpy.p1i8.p0i8.i64(i8 addrspace(1)* nocapture, i8* nocapture, i64, i1) nounwind

declare void @f1(%struct.big* nocapture sret(%struct.big))
declare void @f2(%struct.big*)

; CHECK: attributes [[ATTR0]] = { nounwind }
; CHECK: attributes #1 = { argmemonly nofree nosync nounwind willreturn }
; CHECK: attributes #2 = { nounwind ssp }
; CHECK: attributes #3 = { nounwind ssp uwtable }
; CHECK: attributes #4 = { argmemonly nofree nosync nounwind willreturn writeonly }
