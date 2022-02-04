; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple aarch64-- -start-after codegenprepare -o - %s | FileCheck %s

; REQUIRES: asserts

; This used to hit an assertion like this:
;
; llc: ../lib/CodeGen/SelectionDAG/SelectionDAG.cpp:1087: bool llvm::SelectionDAG::RemoveNodeFromCSEMaps(llvm::SDNode*): Assertion `N->getOpcode() != ISD::DELETED_NODE && "DELETED_NODE in CSEMap!"' failed.
; Stack dump:
; 0.      Program arguments: llc -mtriple aarch64 -o - reduced.ll -start-after codegenprepare
; 1.      Running pass 'Function Pass Manager' on module 'reduced.ll'.
; 2.      Running pass 'AArch64 Instruction Selection' on function '@g'
;  #0 0x00000000031615b8 llvm::sys::PrintStackTrace(llvm::raw_ostream&, int)
;  #1 0x000000000315effe SignalHandler(int) Signals.cpp:0:0
;  #2 0x00007f2c746b2630 __restore_rt sigaction.c:0:0
;  #3 0x00007f2c7200f387 raise (/lib64/libc.so.6+0x36387)
;  #4 0x00007f2c72010a78 abort (/lib64/libc.so.6+0x37a78)
;  #5 0x00007f2c720081a6 __assert_fail_base (/lib64/libc.so.6+0x2f1a6)
;  #6 0x00007f2c72008252 (/lib64/libc.so.6+0x2f252)
;  #7 0x0000000002f06de9 llvm::SelectionDAG::RemoveNodeFromCSEMaps(llvm::SDNode*)
;  #8 0x0000000002f0f0b4 llvm::SelectionDAG::ReplaceAllUsesOfValuesWith(llvm::SDValue const*, llvm::SDValue const*, unsigned int)
;  #9 0x0000000002dc8a4f (anonymous namespace)::DAGCombiner::scalarizeExtractedVectorLoad(llvm::SDNode*, llvm::EVT, llvm::SDValue, llvm::LoadSDNode*) DAGCombiner.cpp:0:0
; #10 0x0000000002de1a8e (anonymous namespace)::DAGCombiner::visitEXTRACT_VECTOR_ELT(llvm::SDNode*) DAGCombiner.cpp:0:0
; #11 0x0000000002e12f41 (anonymous namespace)::DAGCombiner::visit(llvm::SDNode*) DAGCombiner.cpp:0:0
; #12 0x0000000002e14fe5 (anonymous namespace)::DAGCombiner::combine(llvm::SDNode*) DAGCombiner.cpp:0:0

define i64 @g({ i64, i64 }* %p) {
; CHECK-LABEL: g:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0, #8]
; CHECK-NEXT:    add x9, x8, x8
; CHECK-NEXT:    add x8, x9, x8
; CHECK-NEXT:    sub x0, x8, x8
; CHECK-NEXT:    ret
  %vecp = bitcast { i64, i64 }* %p to <2 x i64>*
  %vec = load <2 x i64>, <2 x i64>* %vecp, align 1
  %elt = extractelement <2 x i64> %vec, i32 1
  %scalarp = getelementptr inbounds { i64, i64 }, { i64, i64 }* %p, i32 0, i32 1
  %scalar = load i64, i64* %scalarp, align 1
  %add.i62 = add i64 %elt, %scalar
  %add.i66 = add i64 %add.i62, %elt
  %add.i72 = add i64 %scalar, %scalar
  %add.i76 = add i64 %add.i72, %elt
  %add.i80 = add i64 %add.i76, 0
  %sub.i82 = sub i64 %add.i66, %add.i80
  ret i64 %sub.i82
}
