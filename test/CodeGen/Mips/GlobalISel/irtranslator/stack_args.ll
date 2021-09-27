; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32

declare i32 @f(i32, i32, i32, i32, i32)

define  i32 @g(i32  %x1, i32 %x2, i32 %x3, i32 %x4, i32 %x5){
  ; MIPS32-LABEL: name: g
  ; MIPS32: bb.1.entry:
  ; MIPS32-NEXT:   liveins: $a0, $a1, $a2, $a3
  ; MIPS32-NEXT: {{  $}}
  ; MIPS32-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32-NEXT:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %fixed-stack.0
  ; MIPS32-NEXT:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[FRAME_INDEX]](p0) :: (load (s32) from %fixed-stack.0, align 8)
  ; MIPS32-NEXT:   ADJCALLSTACKDOWN 24, 0, implicit-def $sp, implicit $sp
  ; MIPS32-NEXT:   $a0 = COPY [[COPY]](s32)
  ; MIPS32-NEXT:   $a1 = COPY [[COPY1]](s32)
  ; MIPS32-NEXT:   $a2 = COPY [[COPY2]](s32)
  ; MIPS32-NEXT:   $a3 = COPY [[COPY3]](s32)
  ; MIPS32-NEXT:   [[COPY4:%[0-9]+]]:_(p0) = COPY $sp
  ; MIPS32-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; MIPS32-NEXT:   [[PTR_ADD:%[0-9]+]]:_(p0) = G_PTR_ADD [[COPY4]], [[C]](s32)
  ; MIPS32-NEXT:   G_STORE [[LOAD]](s32), [[PTR_ADD]](p0) :: (store (s32) into stack + 16, align 8)
  ; MIPS32-NEXT:   JAL @f, csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit $a2, implicit $a3, implicit-def $v0
  ; MIPS32-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32-NEXT:   ADJCALLSTACKUP 24, 0, implicit-def $sp, implicit $sp
  ; MIPS32-NEXT:   $v0 = COPY [[COPY5]](s32)
  ; MIPS32-NEXT:   RetRA implicit $v0
entry:
  %call = call i32 @f(i32 %x1, i32 %x2, i32 %x3, i32 %x4, i32 %x5)
  ret i32 %call
}
