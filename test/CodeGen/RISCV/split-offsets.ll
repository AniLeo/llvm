; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; Check that memory accesses to array elements with large offsets have those
; offsets split into a base offset, plus a smaller offset that is folded into
; the memory operation. We should also only compute that base offset once,
; since it can be shared for all memory operations in this test.
define void @test1([65536 x i32]** %sp, [65536 x i32]* %t, i32 %n) {
; RV32I-LABEL: test1:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    lui a2, 20
; RV32I-NEXT:    add a1, a1, a2
; RV32I-NEXT:    add a0, a0, a2
; RV32I-NEXT:    li a2, 2
; RV32I-NEXT:    sw a2, -1920(a0)
; RV32I-NEXT:    li a3, 1
; RV32I-NEXT:    sw a3, -1916(a0)
; RV32I-NEXT:    sw a3, -1920(a1)
; RV32I-NEXT:    sw a2, -1916(a1)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test1:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    ld a0, 0(a0)
; RV64I-NEXT:    lui a2, 20
; RV64I-NEXT:    add a1, a1, a2
; RV64I-NEXT:    add a0, a0, a2
; RV64I-NEXT:    li a2, 2
; RV64I-NEXT:    sw a2, -1920(a0)
; RV64I-NEXT:    li a3, 1
; RV64I-NEXT:    sw a3, -1916(a0)
; RV64I-NEXT:    sw a3, -1920(a1)
; RV64I-NEXT:    sw a2, -1916(a1)
; RV64I-NEXT:    ret
entry:
  %s = load [65536 x i32]*, [65536 x i32]** %sp
  %gep0 = getelementptr [65536 x i32], [65536 x i32]* %s, i64 0, i32 20000
  %gep1 = getelementptr [65536 x i32], [65536 x i32]* %s, i64 0, i32 20001
  %gep2 = getelementptr [65536 x i32], [65536 x i32]* %t, i64 0, i32 20000
  %gep3 = getelementptr [65536 x i32], [65536 x i32]* %t, i64 0, i32 20001
  store i32 2, i32* %gep0
  store i32 1, i32* %gep1
  store i32 1, i32* %gep2
  store i32 2, i32* %gep3
  ret void
}

; Ditto. Check it when the GEPs are not in the entry block.
define void @test2([65536 x i32]** %sp, [65536 x i32]* %t, i32 %n) {
; RV32I-LABEL: test2:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    li a3, 0
; RV32I-NEXT:    lw a4, 0(a0)
; RV32I-NEXT:    lui a0, 20
; RV32I-NEXT:    addi a5, a0, -1920
; RV32I-NEXT:    add a0, a1, a5
; RV32I-NEXT:    add a1, a4, a5
; RV32I-NEXT:    bge a3, a2, .LBB1_2
; RV32I-NEXT:  .LBB1_1: # %while_body
; RV32I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV32I-NEXT:    addi a4, a3, 1
; RV32I-NEXT:    sw a4, 0(a1)
; RV32I-NEXT:    sw a3, 4(a1)
; RV32I-NEXT:    sw a4, 0(a0)
; RV32I-NEXT:    sw a3, 4(a0)
; RV32I-NEXT:    mv a3, a4
; RV32I-NEXT:    blt a3, a2, .LBB1_1
; RV32I-NEXT:  .LBB1_2: # %while_end
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test2:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    li a3, 0
; RV64I-NEXT:    ld a4, 0(a0)
; RV64I-NEXT:    lui a0, 20
; RV64I-NEXT:    addiw a5, a0, -1920
; RV64I-NEXT:    add a0, a1, a5
; RV64I-NEXT:    add a1, a4, a5
; RV64I-NEXT:    sext.w a2, a2
; RV64I-NEXT:    bge a3, a2, .LBB1_2
; RV64I-NEXT:  .LBB1_1: # %while_body
; RV64I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64I-NEXT:    addiw a4, a3, 1
; RV64I-NEXT:    sw a4, 0(a1)
; RV64I-NEXT:    sw a3, 4(a1)
; RV64I-NEXT:    sw a4, 0(a0)
; RV64I-NEXT:    sw a3, 4(a0)
; RV64I-NEXT:    mv a3, a4
; RV64I-NEXT:    blt a3, a2, .LBB1_1
; RV64I-NEXT:  .LBB1_2: # %while_end
; RV64I-NEXT:    ret
entry:
  %s = load [65536 x i32]*, [65536 x i32]** %sp
  br label %while_cond
while_cond:
  %phi = phi i32 [ 0, %entry ], [ %i, %while_body ]
  %gep0 = getelementptr [65536 x i32], [65536 x i32]* %s, i64 0, i32 20000
  %gep1 = getelementptr [65536 x i32], [65536 x i32]* %s, i64 0, i32 20001
  %gep2 = getelementptr [65536 x i32], [65536 x i32]* %t, i64 0, i32 20000
  %gep3 = getelementptr [65536 x i32], [65536 x i32]* %t, i64 0, i32 20001
  %cmp = icmp slt i32 %phi, %n
  br i1 %cmp, label %while_body, label %while_end
while_body:
  %i = add i32 %phi, 1
  %j = add i32 %phi, 2
  store i32 %i, i32* %gep0
  store i32 %phi, i32* %gep1
  store i32 %i, i32* %gep2
  store i32 %phi, i32* %gep3
  br label %while_cond
while_end:
  ret void
}

; GEPs have been manually split so the base GEP does not get used by any memory
; instructions. Make sure we use an offset and common base for each of the
; stores.
define void @test3([65536 x i32]* %t) {
; RV32I-LABEL: test3:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    lui a1, 20
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    li a1, 2
; RV32I-NEXT:    sw a1, -1916(a0)
; RV32I-NEXT:    li a1, 3
; RV32I-NEXT:    sw a1, -1912(a0)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test3:
; RV64I:       # %bb.0: # %entry
; RV64I-NEXT:    lui a1, 20
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    li a1, 2
; RV64I-NEXT:    sw a1, -1916(a0)
; RV64I-NEXT:    li a1, 3
; RV64I-NEXT:    sw a1, -1912(a0)
; RV64I-NEXT:    ret
entry:
  %0 = bitcast [65536 x i32]* %t to i8*
  %splitgep = getelementptr i8, i8* %0, i64 80000
  %1 = getelementptr i8, i8* %splitgep, i64 4
  %2 = bitcast i8* %1 to i32*
  %3 = getelementptr i8, i8* %splitgep, i64 8
  %4 = bitcast i8* %3 to i32*
  store i32 2, i32* %2, align 4
  store i32 3, i32* %4, align 4
  ret void
}
