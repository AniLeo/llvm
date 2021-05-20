; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -O0 -global-isel -stop-after=irtranslator -o - %s | FileCheck %s

; Tests vectors of i1 types can appropriately extended first before return handles it.
define <4 x i1> @ret_v4i1(<4 x i1> *%v) {
  ; CHECK-LABEL: name: ret_v4i1
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $x0
  ; CHECK:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK:   [[LOAD:%[0-9]+]]:_(<4 x s1>) = G_LOAD [[COPY]](p0) :: (load (<4 x s1>) from %ir.v, align 4)
  ; CHECK:   [[ANYEXT:%[0-9]+]]:_(<4 x s16>) = G_ANYEXT [[LOAD]](<4 x s1>)
  ; CHECK:   $d0 = COPY [[ANYEXT]](<4 x s16>)
  ; CHECK:   RET_ReallyLR implicit $d0
  %v2 = load <4 x i1>, <4 x i1> *%v
  ret <4 x i1> %v2
}
