; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -stop-after=irtranslator -relocation-model=pic -verify-machineinstrs %s -o - | FileCheck %s -check-prefixes=MIPS32_PIC

declare i32 @f(i32 %a, i32 %b);

define i32 @call_global(i32 %a0, i32 %a1, i32 %x, i32 %y) {
  ; MIPS32-LABEL: name: call_global
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2, $a3
  ; MIPS32:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   $a0 = COPY [[COPY2]](s32)
  ; MIPS32:   $a1 = COPY [[COPY3]](s32)
  ; MIPS32:   JAL @f, csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $v0
  ; MIPS32:   [[COPY4:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY4]], [[COPY4]]
  ; MIPS32:   $v0 = COPY [[ADD]](s32)
  ; MIPS32:   RetRA implicit $v0
  ; MIPS32_PIC-LABEL: name: call_global
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $a0, $a1, $a2, $a3, $t9, $v0
  ; MIPS32_PIC:   [[ADDu:%[0-9]+]]:gpr32 = ADDu $v0, $t9
  ; MIPS32_PIC:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32_PIC:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32_PIC:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32_PIC:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32_PIC:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   [[GV:%[0-9]+]]:gpr32(p0) = G_GLOBAL_VALUE target-flags(mips-got-call) @f
  ; MIPS32_PIC:   $a0 = COPY [[COPY2]](s32)
  ; MIPS32_PIC:   $a1 = COPY [[COPY3]](s32)
  ; MIPS32_PIC:   $gp = COPY [[ADDu]]
  ; MIPS32_PIC:   JALRPseudo [[GV]](p0), csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $gp, implicit-def $v0
  ; MIPS32_PIC:   [[COPY4:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32_PIC:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY4]], [[COPY4]]
  ; MIPS32_PIC:   $v0 = COPY [[ADD]](s32)
  ; MIPS32_PIC:   RetRA implicit $v0
entry:
  %z = call i32 @f(i32 %x, i32 %y)
  %doublez = add i32 %z, %z
  ret i32 %doublez
}

define internal i32 @f_with_local_linkage(i32 %x, i32 %y) {
  ; MIPS32-LABEL: name: f_with_local_linkage
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1
  ; MIPS32:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY1]], [[COPY]]
  ; MIPS32:   $v0 = COPY [[ADD]](s32)
  ; MIPS32:   RetRA implicit $v0
  ; MIPS32_PIC-LABEL: name: f_with_local_linkage
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $a0, $a1
  ; MIPS32_PIC:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32_PIC:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32_PIC:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY1]], [[COPY]]
  ; MIPS32_PIC:   $v0 = COPY [[ADD]](s32)
  ; MIPS32_PIC:   RetRA implicit $v0
entry:
  %add = add i32 %y, %x
  ret i32 %add
}

define i32 @call_global_with_local_linkage(i32 %a0, i32 %a1, i32 %x, i32 %y) {
  ; MIPS32-LABEL: name: call_global_with_local_linkage
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2, $a3
  ; MIPS32:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   $a0 = COPY [[COPY2]](s32)
  ; MIPS32:   $a1 = COPY [[COPY3]](s32)
  ; MIPS32:   JAL @f_with_local_linkage, csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $v0
  ; MIPS32:   [[COPY4:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY4]], [[COPY4]]
  ; MIPS32:   $v0 = COPY [[ADD]](s32)
  ; MIPS32:   RetRA implicit $v0
  ; MIPS32_PIC-LABEL: name: call_global_with_local_linkage
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $a0, $a1, $a2, $a3, $t9, $v0
  ; MIPS32_PIC:   [[ADDu:%[0-9]+]]:gpr32 = ADDu $v0, $t9
  ; MIPS32_PIC:   [[COPY:%[0-9]+]]:_(s32) = COPY $a0
  ; MIPS32_PIC:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32_PIC:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32_PIC:   [[COPY3:%[0-9]+]]:_(s32) = COPY $a3
  ; MIPS32_PIC:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   [[GV:%[0-9]+]]:gpr32(p0) = G_GLOBAL_VALUE @f_with_local_linkage
  ; MIPS32_PIC:   $a0 = COPY [[COPY2]](s32)
  ; MIPS32_PIC:   $a1 = COPY [[COPY3]](s32)
  ; MIPS32_PIC:   $gp = COPY [[ADDu]]
  ; MIPS32_PIC:   JALRPseudo [[GV]](p0), csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $gp, implicit-def $v0
  ; MIPS32_PIC:   [[COPY4:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32_PIC:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   [[ADD:%[0-9]+]]:_(s32) = G_ADD [[COPY4]], [[COPY4]]
  ; MIPS32_PIC:   $v0 = COPY [[ADD]](s32)
  ; MIPS32_PIC:   RetRA implicit $v0
entry:
  %z = call i32 @f_with_local_linkage(i32 %x, i32 %y)
  %doublez = add i32 %z, %z
  ret i32 %doublez
}

define i32 @call_reg(i32 (i32, i32)* %f_ptr, i32 %x, i32 %y) {
  ; MIPS32-LABEL: name: call_reg
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2
  ; MIPS32:   [[COPY:%[0-9]+]]:gpr32(p0) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   $a0 = COPY [[COPY1]](s32)
  ; MIPS32:   $a1 = COPY [[COPY2]](s32)
  ; MIPS32:   JALRPseudo [[COPY]](p0), csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $v0
  ; MIPS32:   [[COPY3:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   $v0 = COPY [[COPY3]](s32)
  ; MIPS32:   RetRA implicit $v0
  ; MIPS32_PIC-LABEL: name: call_reg
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $a0, $a1, $a2
  ; MIPS32_PIC:   [[COPY:%[0-9]+]]:gpr32(p0) = COPY $a0
  ; MIPS32_PIC:   [[COPY1:%[0-9]+]]:_(s32) = COPY $a1
  ; MIPS32_PIC:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32_PIC:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   $a0 = COPY [[COPY1]](s32)
  ; MIPS32_PIC:   $a1 = COPY [[COPY2]](s32)
  ; MIPS32_PIC:   JALRPseudo [[COPY]](p0), csr_o32, implicit-def $ra, implicit-def $sp, implicit $a0, implicit $a1, implicit-def $v0
  ; MIPS32_PIC:   [[COPY3:%[0-9]+]]:_(s32) = COPY $v0
  ; MIPS32_PIC:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   $v0 = COPY [[COPY3]](s32)
  ; MIPS32_PIC:   RetRA implicit $v0
entry:
  %call = call i32 %f_ptr(i32 %x, i32 %y)
  ret i32 %call
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i1 immarg)

define void @call_symbol(i8* nocapture readonly %src, i8* nocapture %dest, i32 signext %length) {
  ; MIPS32-LABEL: name: call_symbol
  ; MIPS32: bb.1.entry:
  ; MIPS32:   liveins: $a0, $a1, $a2
  ; MIPS32:   [[COPY:%[0-9]+]]:_(p0) = COPY $a0
  ; MIPS32:   [[COPY1:%[0-9]+]]:_(p0) = COPY $a1
  ; MIPS32:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32:   G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.memcpy), [[COPY1]](p0), [[COPY]](p0), [[COPY2]](s32), 0 :: (store 1 into %ir.dest), (load 1 from %ir.src)
  ; MIPS32:   RetRA
  ; MIPS32_PIC-LABEL: name: call_symbol
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $a0, $a1, $a2
  ; MIPS32_PIC:   [[COPY:%[0-9]+]]:_(p0) = COPY $a0
  ; MIPS32_PIC:   [[COPY1:%[0-9]+]]:_(p0) = COPY $a1
  ; MIPS32_PIC:   [[COPY2:%[0-9]+]]:_(s32) = COPY $a2
  ; MIPS32_PIC:   G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.memcpy), [[COPY1]](p0), [[COPY]](p0), [[COPY2]](s32), 0 :: (store 1 into %ir.dest), (load 1 from %ir.src)
  ; MIPS32_PIC:   RetRA
entry:
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 %dest, i8* align 1 %src, i32 %length, i1 false)
  ret void
}

declare void @f_with_void_ret();

define void @call_f_with_void_ret() {
  ; MIPS32-LABEL: name: call_f_with_void_ret
  ; MIPS32: bb.1.entry:
  ; MIPS32:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   JAL @f_with_void_ret, csr_o32, implicit-def $ra, implicit-def $sp
  ; MIPS32:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32:   RetRA
  ; MIPS32_PIC-LABEL: name: call_f_with_void_ret
  ; MIPS32_PIC: bb.1.entry:
  ; MIPS32_PIC:   liveins: $t9, $v0
  ; MIPS32_PIC:   [[ADDu:%[0-9]+]]:gpr32 = ADDu $v0, $t9
  ; MIPS32_PIC:   ADJCALLSTACKDOWN 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   [[GV:%[0-9]+]]:gpr32(p0) = G_GLOBAL_VALUE target-flags(mips-got-call) @f_with_void_ret
  ; MIPS32_PIC:   $gp = COPY [[ADDu]]
  ; MIPS32_PIC:   JALRPseudo [[GV]](p0), csr_o32, implicit-def $ra, implicit-def $sp, implicit-def $gp
  ; MIPS32_PIC:   ADJCALLSTACKUP 16, 0, implicit-def $sp, implicit $sp
  ; MIPS32_PIC:   RetRA
entry:
  call void @f_with_void_ret()
  ret void
}
