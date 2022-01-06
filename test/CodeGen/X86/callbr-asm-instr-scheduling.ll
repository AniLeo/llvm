; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -verify-machineinstrs -mcpu=znver2 -O2 -frame-pointer=none < %s | FileCheck %s

; Make sure that instructions aren't scheduled after the "callbr". In the
; example below, we don't want the "shrxq" through "leaq" instructions to be
; moved after the "callbr".

%struct.cpuinfo_x86 = type { i8, i8, i8, i8, i32, [3 x i32], i8, i8, i8, i8, i32, i32, %union.anon.83, [16 x i8], [64 x i8], i32, i32, i32, i32, i32, i32, i64, i16, i16, i16, i16, i16, i16, i16, i16, i16, i16, i16, i32, i8, i8 }
%union.anon.83 = type { i64, [72 x i8] }
%struct.pgd_t = type { i64 }
%struct.p4d_t = type { i64 }
%struct.pud_t = type { i64 }

@boot_cpu_data = external dso_local global %struct.cpuinfo_x86, align 8
@page_offset_base = external dso_local local_unnamed_addr global i64, align 8
@pgdir_shift = external dso_local local_unnamed_addr global i32, align 4
@__force_order = external dso_local global i64, align 8
@ptrs_per_p4d = external dso_local local_unnamed_addr global i32, align 4

define i64 @early_ioremap_pmd(i64 %addr) {
; CHECK-LABEL: early_ioremap_pmd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    #APP
; CHECK-NEXT:    movq %cr3, %rax
; CHECK-EMPTY:
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    movabsq $9223372036854771712, %rdx # imm = 0x7FFFFFFFFFFFF000
; CHECK-NEXT:    andq %rax, %rdx
; CHECK-NEXT:    movb pgdir_shift(%rip), %al
; CHECK-NEXT:    movq page_offset_base(%rip), %rcx
; CHECK-NEXT:    shrxq %rax, %rdi, %rax
; CHECK-NEXT:    addq %rcx, %rdx
; CHECK-NEXT:    andl $511, %eax # imm = 0x1FF
; CHECK-NEXT:    leaq (%rdx,%rax,8), %rax
; CHECK-NEXT:    #APP
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    jmp .Ltmp3
; CHECK-NEXT:  .Ltmp4:
; CHECK-NEXT:    .zero (-(((.Ltmp5-.Ltmp6)-(.Ltmp4-.Ltmp2))>0))*((.Ltmp5-.Ltmp6)-(.Ltmp4-.Ltmp2)),144
; CHECK-NEXT:  .Ltmp7:
entry:
  %0 = tail call i64 asm sideeffect "mov %cr3,$0\0A\09", "=r,=*m,~{dirflag},~{fpsr},~{flags}"(i64* elementtype(i64) nonnull @__force_order)
  %and.i = and i64 %0, 9223372036854771712
  %1 = load i64, i64* @page_offset_base, align 8
  %add = add i64 %and.i, %1
  %2 = inttoptr i64 %add to %struct.pgd_t*
  %3 = load i32, i32* @pgdir_shift, align 4
  %sh_prom = zext i32 %3 to i64
  %shr = lshr i64 %addr, %sh_prom
  %and = and i64 %shr, 511
  %arrayidx = getelementptr %struct.pgd_t, %struct.pgd_t* %2, i64 %and
  callbr void asm sideeffect "1: jmp 6f\0A2:\0A.skip -(((5f-4f) - (2b-1b)) > 0) * ((5f-4f) - (2b-1b)),0x90\0A3:\0A.section .altinstructions,\22a\22\0A .long 1b - .\0A .long 4f - .\0A .word ${1:P}\0A .byte 3b - 1b\0A .byte 5f - 4f\0A .byte 3b - 2b\0A.previous\0A.section .altinstr_replacement,\22ax\22\0A4: jmp ${5:l}\0A5:\0A.previous\0A.section .altinstructions,\22a\22\0A .long 1b - .\0A .long 0\0A .word ${0:P}\0A .byte 3b - 1b\0A .byte 0\0A .byte 0\0A.previous\0A.section .altinstr_aux,\22ax\22\0A6:\0A testb $2,$3\0A jnz ${4:l}\0A jmp ${5:l}\0A.previous\0A", "i,i,i,*m,X,X,~{dirflag},~{fpsr},~{flags}"(i16 528, i32 117, i32 1, i8* elementtype(i8) getelementptr inbounds (%struct.cpuinfo_x86, %struct.cpuinfo_x86* @boot_cpu_data, i64 0, i32 12, i32 1, i64 58), i8* blockaddress(@early_ioremap_pmd, %if.end.i), i8* blockaddress(@early_ioremap_pmd, %if.then.i))
          to label %_static_cpu_has.exit.thread.i [label %if.end.i, label %if.then.i]

_static_cpu_has.exit.thread.i:                    ; preds = %entry
  br label %if.end.i

if.then.i:                                        ; preds = %entry
  %4 = bitcast %struct.pgd_t* %arrayidx to %struct.p4d_t*
  br label %p4d_offset.exit

if.end.i:                                         ; preds = %_static_cpu_has.exit.thread.i, %entry
  %coerce.dive.i = getelementptr inbounds %struct.pgd_t, %struct.pgd_t* %arrayidx, i64 0, i32 0
  %5 = load i64, i64* %coerce.dive.i, align 8
  %6 = inttoptr i64 %5 to %struct.p4d_t*
  %7 = load i32, i32* @ptrs_per_p4d, align 4
  %sub.i.i = add i32 %7, 33554431
  %8 = and i32 %sub.i.i, 33554431
  %and.i1.i = zext i32 %8 to i64
  %add.ptr.i = getelementptr %struct.p4d_t, %struct.p4d_t* %6, i64 %and.i1.i
  br label %p4d_offset.exit

p4d_offset.exit:                                  ; preds = %if.end.i, %if.then.i
  %retval.0.i = phi %struct.p4d_t* [ %add.ptr.i, %if.end.i ], [ %4, %if.then.i ]
  %coerce.dive.i12 = getelementptr inbounds %struct.p4d_t, %struct.p4d_t* %retval.0.i, i64 0, i32 0
  %9 = load i64, i64* %coerce.dive.i12, align 8
  %and.i.i13 = and i64 %9, 4503599627366400
  %add.i.i14 = add i64 %and.i.i13, %1
  %10 = inttoptr i64 %add.i.i14 to %struct.pud_t*
  %coerce.dive.i16 = getelementptr %struct.pud_t, %struct.pud_t* %10, i64 511, i32 0
  %11 = load i64, i64* %coerce.dive.i16, align 8
  %tobool.i.i.i = icmp slt i64 %11, 0
  %..i.i.i = select i1 %tobool.i.i.i, i64 4503598553628672, i64 4503599627366400
  ret i64 %..i.i.i
}
