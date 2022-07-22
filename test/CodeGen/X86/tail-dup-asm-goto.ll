; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=x86_64-linux -stop-after=early-tailduplication < %s | FileCheck %s

; Ensure that we don't duplicate a block with an "INLINEASM_BR" instruction
; during code gen.
declare dso_local void @foo()

define ptr @test1(ptr %arg1, ptr %arg2) {
  ; CHECK-LABEL: name: test1
  ; CHECK: bb.0.bb:
  ; CHECK-NEXT:   successors: %bb.1(0x50000000), %bb.2(0x30000000)
  ; CHECK-NEXT:   liveins: $rdi, $rsi
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:gr64 = COPY $rsi
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:gr64 = COPY $rdi
  ; CHECK-NEXT:   [[MOV64rm:%[0-9]+]]:gr64 = MOV64rm [[COPY1]], 1, $noreg, 0, $noreg :: (load (s64) from %ir.arg1)
  ; CHECK-NEXT:   [[SUB64rr:%[0-9]+]]:gr64 = SUB64rr [[MOV64rm]], [[COPY]], implicit-def $eflags
  ; CHECK-NEXT:   JCC_1 %bb.2, 4, implicit $eflags
  ; CHECK-NEXT:   JMP_1 %bb.1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.1.bb100:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   MOV64mi32 [[COPY1]], 1, $noreg, 0, $noreg, 0 :: (store (s64) into %ir.arg1)
  ; CHECK-NEXT:   JMP_1 %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.bb106:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   ADJCALLSTACKDOWN64 0, 0, 0, implicit-def dead $rsp, implicit-def dead $eflags, implicit-def dead $ssp, implicit $rsp, implicit $ssp
  ; CHECK-NEXT:   CALL64pcrel32 @foo, csr_64, implicit $rsp, implicit $ssp, implicit-def $rsp, implicit-def $ssp
  ; CHECK-NEXT:   ADJCALLSTACKUP64 0, 0, implicit-def dead $rsp, implicit-def dead $eflags, implicit-def dead $ssp, implicit $rsp, implicit $ssp
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.bb110:
  ; CHECK-NEXT:   successors: %bb.5(0x80000000), %bb.4(0x00000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[PHI:%[0-9]+]]:gr64 = PHI [[COPY]], %bb.2, [[MOV64rm]], %bb.1
  ; CHECK-NEXT:   INLINEASM_BR &"#$0 $1 $2", 9 /* sideeffect mayload attdialect */, 13 /* imm */, 42, 13 /* imm */, 0, 13 /* imm */, blockaddress(@test1, %ir-block.bb17.i.i.i), 12 /* clobber */, implicit-def early-clobber $df, 12 /* clobber */, implicit-def early-clobber $fpsw, 12 /* clobber */, implicit-def early-clobber $eflags
  ; CHECK-NEXT:   JMP_1 %bb.5
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.4.bb17.i.i.i (address-taken, inlineasm-br-indirect-target):
  ; CHECK-NEXT:   successors: %bb.5(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.5.kmem_cache_has_cpu_partial.exit:
  ; CHECK-NEXT:   $rax = COPY [[PHI]]
  ; CHECK-NEXT:   RET 0, $rax
bb:
  %i28.i = load ptr, ptr %arg1, align 8
  %if = icmp ne ptr %i28.i, %arg2
  br i1 %if, label %bb100, label %bb106

bb100:                                            ; preds = %bb
  store ptr null, ptr %arg1, align 8
  br label %bb110

bb106:                                            ; preds = %bb
  call void @foo()
  br label %bb110

bb110:                                            ; preds = %bb106, %bb100
  %i10.1 = phi ptr [ %arg2, %bb106 ], [ %i28.i, %bb100 ]
  callbr void asm sideeffect "#$0 $1 $2", "i,i,!i,~{dirflag},~{fpsr},~{flags}"(i32 42, i1 false)
          to label %kmem_cache_has_cpu_partial.exit [label %bb17.i.i.i]

bb17.i.i.i:                                       ; preds = %bb110
  br label %kmem_cache_has_cpu_partial.exit

kmem_cache_has_cpu_partial.exit:                  ; preds = %bb110
  ret ptr %i10.1
}
