; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck %s --check-prefix=CHECK-THROUGHPUT
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -cost-kind=code-size -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck %s --check-prefix=CHECK-SIZE
; END.

; Logical and/or - select's cost must be equivalent to that of binop

define amdgpu_kernel void @op() {
; CHECK-THROUGHPUT-LABEL: 'op'
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select i1 undef, i1 undef, i1 false
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and i1 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select i1 undef, i1 true, i1 undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or i1 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; CHECK-SIZE-LABEL: 'op'
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select i1 undef, i1 undef, i1 false
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and i1 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select i1 undef, i1 true, i1 undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or i1 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %sand = select i1 undef, i1 undef, i1 false
  %band = and i1 undef, undef
  %sor = select i1 undef, i1 true, i1 undef
  %bor = or i1 undef, undef

  ret void
}

define void @vecop() {
; CHECK-THROUGHPUT-LABEL: 'vecop'
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2sand = select <2 x i1> undef, <2 x i1> undef, <2 x i1> zeroinitializer
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2band = and <2 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2sor = select <2 x i1> undef, <2 x i1> <i1 true, i1 true>, <2 x i1> undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2bor = or <2 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> zeroinitializer
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4band = and <4 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4bor = or <4 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; CHECK-SIZE-LABEL: 'vecop'
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2sand = select <2 x i1> undef, <2 x i1> undef, <2 x i1> zeroinitializer
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2band = and <2 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2sor = select <2 x i1> undef, <2 x i1> <i1 true, i1 true>, <2 x i1> undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2bor = or <2 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> zeroinitializer
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4band = and <4 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4bor = or <4 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v2sand = select <2 x i1> undef, <2 x i1> undef, <2 x i1> <i1 false, i1 false>
  %v2band = and <2 x i1> undef, undef
  %v2sor = select <2 x i1> undef, <2 x i1> <i1 true, i1 true>, <2 x i1> undef
  %v2bor = or <2 x i1> undef, undef
  %v4sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> <i1 false, i1 false, i1 false, i1 false>
  %v4band = and <4 x i1> undef, undef
  %v4sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
  %v4bor = or <4 x i1> undef, undef

  ret void
}
