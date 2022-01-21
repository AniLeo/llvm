; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+v,+f -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s

define void @foo(i32* nocapture noundef %p1) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi sp, sp, -192
; CHECK-NEXT:    .cfi_def_cfa_offset 192
; CHECK-NEXT:    sd ra, 184(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s0, 176(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s1, 168(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s2, 160(sp) # 8-byte Folded Spill
; CHECK-NEXT:    .cfi_offset ra, -8
; CHECK-NEXT:    .cfi_offset s0, -16
; CHECK-NEXT:    .cfi_offset s1, -24
; CHECK-NEXT:    .cfi_offset s2, -32
; CHECK-NEXT:    addi s0, sp, 192
; CHECK-NEXT:    .cfi_def_cfa s0, 0
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 1
; CHECK-NEXT:    sub sp, sp, a1
; CHECK-NEXT:    andi sp, sp, -64
; CHECK-NEXT:    mv s1, sp
; CHECK-NEXT:    mv s2, a0
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    addi a0, s1, 160
; CHECK-NEXT:    vs2r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    addi t0, s1, 64
; CHECK-NEXT:    li a0, 1
; CHECK-NEXT:    li a1, 2
; CHECK-NEXT:    li a2, 3
; CHECK-NEXT:    li a3, 4
; CHECK-NEXT:    li a4, 5
; CHECK-NEXT:    li a5, 6
; CHECK-NEXT:    li a6, 7
; CHECK-NEXT:    li a7, 8
; CHECK-NEXT:    sd t0, 0(sp)
; CHECK-NEXT:    call bar@plt
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v8, (s2)
; CHECK-NEXT:    addi a0, s1, 160
; CHECK-NEXT:    vl2re8.v v10, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vfadd.vv v8, v10, v8
; CHECK-NEXT:    vse32.v v8, (s2)
; CHECK-NEXT:    addi sp, s0, -192
; CHECK-NEXT:    ld ra, 184(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s0, 176(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s1, 168(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s2, 160(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 192
; CHECK-NEXT:    ret
entry:
  %vla = alloca [10 x i32], align 64
  %0 = bitcast [10 x i32]* %vla to i8*
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %0)
  %1 = bitcast i32* %p1 to <8 x float>*
  %2 = load <8 x float>, <8 x float>* %1, align 32
  %arraydecay = getelementptr inbounds [10 x i32], [10 x i32]* %vla, i64 0, i64 0
  call void @bar(i32 noundef signext 1, i32 noundef signext 2, i32 noundef signext 3, i32 noundef signext 4, i32 noundef signext 5, i32 noundef signext 6, i32 noundef signext 7, i32 noundef signext 8, i32* noundef nonnull %arraydecay)
  %3 = load <8 x float>, <8 x float>* %1, align 32
  %add = fadd <8 x float> %2, %3
  store <8 x float> %add, <8 x float>* %1, align 32
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %0)
  ret void
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

declare void @bar(i32 noundef signext, i32 noundef signext, i32 noundef signext, i32 noundef signext, i32 noundef signext, i32 noundef signext, i32 noundef signext, i32 noundef signext, i32* noundef)

declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
