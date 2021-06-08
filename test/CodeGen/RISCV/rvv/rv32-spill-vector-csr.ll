; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+d -O0 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O0 %s
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v,+d -O2 < %s \
; RUN:    | FileCheck --check-prefix=SPILL-O2 %s

@.str = private unnamed_addr constant [6 x i8] c"hello\00", align 1

define <vscale x 1 x double> @foo(<vscale x 1 x double> %a, <vscale x 1 x double> %b, <vscale x 1 x double> %c, i32 %gvl) nounwind
; SPILL-O0-LABEL: foo:
; SPILL-O0:       # %bb.0:
; SPILL-O0-NEXT:    addi sp, sp, -32
; SPILL-O0-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; SPILL-O0-NEXT:    csrr a1, vlenb
; SPILL-O0-NEXT:    slli a1, a1, 1
; SPILL-O0-NEXT:    sub sp, sp, a1
; SPILL-O0-NEXT:    sw a0, 8(sp) # 4-byte Folded Spill
; SPILL-O0-NEXT:    csrr a1, vlenb
; SPILL-O0-NEXT:    add a1, sp, a1
; SPILL-O0-NEXT:    addi a1, a1, 16
; SPILL-O0-NEXT:    vs1r.v v8, (a1) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; SPILL-O0-NEXT:    vfadd.vv v25, v8, v9
; SPILL-O0-NEXT:    addi a0, sp, 16
; SPILL-O0-NEXT:    vs1r.v v25, (a0) # Unknown-size Folded Spill
; SPILL-O0-NEXT:    lui a0, %hi(.L.str)
; SPILL-O0-NEXT:    addi a0, a0, %lo(.L.str)
; SPILL-O0-NEXT:    call puts@plt
; SPILL-O0-NEXT:    addi a1, sp, 16
; SPILL-O0-NEXT:    vl1r.v v25, (a1) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    csrr a1, vlenb
; SPILL-O0-NEXT:    add a1, sp, a1
; SPILL-O0-NEXT:    addi a1, a1, 16
; SPILL-O0-NEXT:    vl1r.v v8, (a1) # Unknown-size Folded Reload
; SPILL-O0-NEXT:    # kill: def $x11 killed $x10
; SPILL-O0-NEXT:    lw a0, 8(sp) # 4-byte Folded Reload
; SPILL-O0-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; SPILL-O0-NEXT:    vfadd.vv v8, v8, v25
; SPILL-O0-NEXT:    csrr a0, vlenb
; SPILL-O0-NEXT:    slli a0, a0, 1
; SPILL-O0-NEXT:    add sp, sp, a0
; SPILL-O0-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; SPILL-O0-NEXT:    addi sp, sp, 32
; SPILL-O0-NEXT:    ret
;
; SPILL-O2-LABEL: foo:
; SPILL-O2:       # %bb.0:
; SPILL-O2-NEXT:    addi sp, sp, -16
; SPILL-O2-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; SPILL-O2-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; SPILL-O2-NEXT:    csrr a1, vlenb
; SPILL-O2-NEXT:    slli a1, a1, 1
; SPILL-O2-NEXT:    sub sp, sp, a1
; SPILL-O2-NEXT:    mv s0, a0
; SPILL-O2-NEXT:    addi a1, sp, 8
; SPILL-O2-NEXT:    vs1r.v v8, (a1) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; SPILL-O2-NEXT:    vfadd.vv v25, v8, v9
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    add a0, sp, a0
; SPILL-O2-NEXT:    addi a0, a0, 8
; SPILL-O2-NEXT:    vs1r.v v25, (a0) # Unknown-size Folded Spill
; SPILL-O2-NEXT:    lui a0, %hi(.L.str)
; SPILL-O2-NEXT:    addi a0, a0, %lo(.L.str)
; SPILL-O2-NEXT:    call puts@plt
; SPILL-O2-NEXT:    vsetvli zero, s0, e64, m1, ta, mu
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    add a0, sp, a0
; SPILL-O2-NEXT:    addi a0, a0, 8
; SPILL-O2-NEXT:    vl1r.v v25, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    addi a0, sp, 8
; SPILL-O2-NEXT:    vl1r.v v26, (a0) # Unknown-size Folded Reload
; SPILL-O2-NEXT:    vfadd.vv v8, v26, v25
; SPILL-O2-NEXT:    csrr a0, vlenb
; SPILL-O2-NEXT:    slli a0, a0, 1
; SPILL-O2-NEXT:    add sp, sp, a0
; SPILL-O2-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; SPILL-O2-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; SPILL-O2-NEXT:    addi sp, sp, 16
; SPILL-O2-NEXT:    ret
{
   %x = call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i32 %gvl)
   %call = call signext i32 @puts(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0))
   %z = call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %x, i32 %gvl)
   ret <vscale x 1 x double> %z
}

declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(<vscale x 1 x double> %a, <vscale x 1 x double> %b, i32 %gvl)
declare i32 @puts(i8*);
