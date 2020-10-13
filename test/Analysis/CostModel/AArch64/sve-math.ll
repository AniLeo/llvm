; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -mtriple=aarch64-- -mattr=+sve -cost-model -analyze -cost-kind=throughput < %s | FileCheck %s --check-prefix=THRU
; RUN: opt -mtriple=aarch64-- -mattr=+sve -cost-model -analyze -cost-kind=latency < %s | FileCheck %s --check-prefix=LATE
; RUN: opt -mtriple=aarch64- --mattr=+sve -cost-model -analyze -cost-kind=code-size < %s | FileCheck %s --check-prefix=SIZE
; RUN: opt -mtriple=aarch64-- -mattr=+sve -cost-model -analyze -cost-kind=size-latency < %s | FileCheck %s --check-prefix=SIZE_LATE

declare <vscale x 2 x double> @llvm.sqrt.v2f64(<vscale x 2 x double>)

define <vscale x 2 x double> @fadd_v2f64(<vscale x 2 x double> %a, <vscale x 2 x double> %b) {
; THRU-LABEL: 'fadd_v2f64'
; THRU-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %r = fadd <vscale x 2 x double> %a, %b
; THRU-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <vscale x 2 x double> %r
;
; LATE-LABEL: 'fadd_v2f64'
; LATE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %r = fadd <vscale x 2 x double> %a, %b
; LATE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret <vscale x 2 x double> %r
;
; SIZE-LABEL: 'fadd_v2f64'
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = fadd <vscale x 2 x double> %a, %b
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret <vscale x 2 x double> %r
;
; SIZE_LATE-LABEL: 'fadd_v2f64'
; SIZE_LATE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %r = fadd <vscale x 2 x double> %a, %b
; SIZE_LATE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret <vscale x 2 x double> %r
;
  %r = fadd <vscale x 2 x double> %a, %b
  ret <vscale x 2 x double> %r
}
