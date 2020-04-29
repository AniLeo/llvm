; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -cost-model -analyze -cost-kind=code-size  -mtriple=thumbv8m.base   | FileCheck %s --check-prefix=CHECK-T1-SIZE
; RUN: opt < %s -cost-model -analyze -cost-kind=code-size  -mtriple=thumbv8m.main   | FileCheck %s --check-prefix=CHECK-T2-SIZE
; RUN: opt < %s -cost-model -analyze -cost-kind=latency    -mtriple=thumbv8m.base   | FileCheck %s --check-prefix=CHECK-T1-LATENCY
; RUN: opt < %s -cost-model -analyze -cost-kind=latency    -mtriple=thumbv8m.main   | FileCheck %s --check-prefix=CHECK-T2-LATENCY
; RUN: opt < %s -cost-model -analyze -cost-kind=throughput -mtriple=thumbv8m.base   | FileCheck %s --check-prefix=CHECK-T1-THROUGHPUT
; RUN: opt < %s -cost-model -analyze -cost-kind=throughput -mtriple=thumbv8m.main   | FileCheck %s --check-prefix=CHECK-T2-THROUGHPUT

define i32 @const_costs() {
; CHECK-T1-SIZE-LABEL: 'const_costs'
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T1-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 1
;
; CHECK-T2-SIZE-LABEL: 'const_costs'
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T2-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 1
;
; CHECK-T1-LATENCY-LABEL: 'const_costs'
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T1-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 1
;
; CHECK-T2-LATENCY-LABEL: 'const_costs'
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T2-LATENCY-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 1
;
; CHECK-T1-THROUGHPUT-LABEL: 'const_costs'
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T1-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 1
;
; CHECK-T2-THROUGHPUT-LABEL: 'const_costs'
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_1 = add i32 undef, 1
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %add_32767 = add i32 undef, 32767
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_1 = sub i32 undef, 1
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sub_32768 = sub i32 undef, 32768
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_2 = mul i32 undef, 2
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_3 = mul i32 undef, 3
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %mul_27 = mul i32 undef, 27
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_255 = and i32 undef, 255
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_65535 = and i32 undef, 65535
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %and_1 = and i32 undef, 1
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_1 = xor i32 undef, 1
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %xor_7 = xor i32 undef, 7
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_1 = getelementptr i32, i32* undef, i32 1
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %gep_16 = getelementptr i32, i32* undef, i32 16
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_1_0 = select i1 undef, i32 1, i32 0
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %select_7_255 = select i1 undef, i32 7, i32 255
; CHECK-T2-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 1
;
  %add_1 = add i32 undef, 1
  %add_32767 = add i32 undef, 32767
  %sub_1 = sub i32 undef, 1
  %sub_32768 = sub i32 undef, 32768
  %mul_2 = mul i32 undef, 2
  %mul_3 = mul i32 undef, 3
  %mul_27  = mul i32 undef, 27
  %and_255 = and i32 undef, 255
  %and_65535  = and i32 undef, 65535
  %and_1 = and i32 undef, 1
  %xor_1 = xor i32 undef, 1
  %xor_7 = xor i32 undef, 7
  %gep_1 = getelementptr i32, i32* undef, i32 1
  %gep_16 = getelementptr i32, i32* undef, i32 16
  %select_1_0 = select i1 undef, i32 1, i32 0
  %select_7_255 = select i1 undef, i32 7, i32 255
  ret i32 1
}

