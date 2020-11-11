; Checks if widening instructions works for SVE

; RUN: opt  -cost-model -analyze -mtriple=aarch64--linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; If this check fails please read test/CodeGen/AArch64/README for instructions on how to resolve it.
; WARN-NOT: warning

define <vscale x 4 x i32> @widening(<vscale x 16 x i8> %in, <vscale x 4 x i16> %in2) {

; CHECK-LABEL: 'widening':
; CHECK: Cost Model: Found an estimated cost of {{[0-9]+}} for instruction:   %in.bc = bitcast <vscale x 16 x i8> %in to <vscale x 4 x i32>
; CHECK-NEXT: Cost Model: Found an estimated cost of {{[0-9]+}} for instruction:   %in2.ext = zext <vscale x 4 x i16> %in2 to <vscale x 4 x i32>
; CHECK-NEXT: Cost Model: Found an estimated cost of {{[0-9]+}} for instruction:   %in.add = add <vscale x 4 x i32> %in.bc, %in2.ext
; CHECK-NEXT: Cost Model: Found an estimated cost of {{[0-9]+}} for instruction:   ret <vscale x 4 x i32> %in.add

  %in.bc = bitcast <vscale x 16 x i8> %in to <vscale x 4 x i32>
  %in2.ext = zext <vscale x 4 x i16> %in2 to <vscale x 4 x i32>
  %in.add = add <vscale x 4 x i32> %in.bc, %in2.ext
  ret <vscale x 4 x i32> %in.add
}
