; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mergeicmps -mtriple=x86_64-unknown-unknown -S | FileCheck %s

%"struct.std::pair" = type { i32, i32 }

; Check that the transformation is avoided when GEP has a use outside of the
; parant block of the load instruction.

define zeroext i32 @opeq1(
; CHECK-LABEL: @opeq1(
; CHECK-NOT:    [[MEMCMP:%.*]] = call i32 @memcmp

  %"struct.std::pair"* nocapture readonly dereferenceable(16) %a,
  %"struct.std::pair"* nocapture readonly dereferenceable(16) %b) local_unnamed_addr #0 {
entry:
  %first.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 1 
  %0 = load i32, i32* %first.i, align 4
  %first1.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 1 
  %1 = load i32, i32* %first1.i, align 4
  %cmp.i = icmp eq i32 %0, %1
  br i1 %cmp.i, label %land.rhs.i, label %opeq1.exit

land.rhs.i:
  %second.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %a, i64 0, i32 0
  %2 = load i32, i32* %second.i, align 4
  %second2.i = getelementptr inbounds %"struct.std::pair", %"struct.std::pair"* %b, i64 0, i32 0
  %3 = load i32, i32* %second2.i, align 4
  %cmp3.i = icmp eq i32 %2, %3
  br label %opeq1.exit

opeq1.exit:
  %4 = phi i1 [ false, %entry ], [ %cmp3.i,  %land.rhs.i]
  %5 = load i32, i32* %first.i, align 4
  %6 = select i1 %4, i32 %5, i32 0
  ret i32 %6
}
