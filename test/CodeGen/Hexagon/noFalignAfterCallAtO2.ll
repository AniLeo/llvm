; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon -O2 < %s | FileCheck %s

; Check that we don't generate .falign directives after function calls at O2.
; We need more than one basic block for this test because MachineBlockPlacement
; will not run on single basic block functions.

declare i32 @f0()

; We don't want faligns after the calls to foo.

define i32 @f1(i32 %a0) #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0.new) r0 = add(r0,#5)
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:     if (!p0.new) jumpr:nt r31
; CHECK-NEXT:    }
; CHECK-NEXT:  .LBB0_1: // %b1
; CHECK-NEXT:    {
; CHECK-NEXT:     call f0
; CHECK-NEXT:     memd(r29+#-16) = r17:16
; CHECK-NEXT:     allocframe(#8)
; CHECK-NEXT:    } // 8-byte Folded Spill
; CHECK-NEXT:    {
; CHECK-NEXT:     call f0
; CHECK-NEXT:     r16 = r0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = add(r16,r0)
; CHECK-NEXT:     r17:16 = memd(r29+#0)
; CHECK-NEXT:     dealloc_return
; CHECK-NEXT:    } // 8-byte Folded Reload
b0:
  %v0 = icmp eq i32 %a0, 0
  br i1 %v0, label %b1, label %b2

b1:                                               ; preds = %b0
  %v1 = call i32 @f0()
  %v2 = call i32 @f0()
  %v3 = add i32 %v1, %v2
  ret i32 %v3

b2:                                               ; preds = %b0
  %v4 = add i32 %a0, 5
  ret i32 %v4
}

attributes #0 = { nounwind }
