; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32


define i32 @ptr_arg_in_regs(i32* %p) {
  ; MIPS32-LABEL: name: ptr_arg_in_regs
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0
  ; MIPS32:   [[COPY:%[0-9]+]]:_(p0) = COPY $a0
  ; MIPS32:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[COPY]](p0) :: (load 4 from %ir.p)
  ; MIPS32:   $v0 = COPY [[LOAD]](s32)
  ; MIPS32:   RetRA implicit $v0
entry:
  %0 = load i32, i32* %p
  ret i32 %0
}

define i32 @ptr_arg_on_stack(i32 %x1, i32 %x2, i32 %x3, i32 %x4, i32* %p) {
  ; MIPS32-LABEL: name: ptr_arg_on_stack
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2, $a3
  ; MIPS32:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %fixed-stack.0
  ; MIPS32:   [[LOAD:%[0-9]+]]:_(p0) = G_LOAD [[FRAME_INDEX]](p0) :: (load 4 from %fixed-stack.0, align 8)
  ; MIPS32:   [[LOAD1:%[0-9]+]]:_(s32) = G_LOAD [[LOAD]](p0) :: (load 4 from %ir.p)
  ; MIPS32:   $v0 = COPY [[LOAD1]](s32)
  ; MIPS32:   RetRA implicit $v0
entry:
  %0 = load i32, i32* %p
  ret i32 %0
}

define i8* @ret_ptr(i8* %p) {
  ; MIPS32-LABEL: name: ret_ptr
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0
  ; MIPS32:   [[COPY:%[0-9]+]]:_(p0) = COPY $a0
  ; MIPS32:   $v0 = COPY [[COPY]](p0)
  ; MIPS32:   RetRA implicit $v0
entry:
  ret i8* %p
}
