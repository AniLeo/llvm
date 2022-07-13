; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 --mattr=+d < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 --mattr=+d < %s | FileCheck %s --check-prefix=LA64

define float @convert_double_to_float(double %a) nounwind {
; LA32-LABEL: convert_double_to_float:
; LA32:       # %bb.0:
; LA32-NEXT:    fcvt.s.d $fa0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_double_to_float:
; LA64:       # %bb.0:
; LA64-NEXT:    fcvt.s.d $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = fptrunc double %a to float
  ret float %1
}

define double @convert_float_to_double(float %a) nounwind {
; LA32-LABEL: convert_float_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    fcvt.d.s $fa0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_float_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    fcvt.d.s $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = fpext float %a to double
  ret double %1
}

define double @convert_i8_to_double(i8 signext %a) nounwind {
; LA32-LABEL: convert_i8_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    movgr2fr.w $fa0, $a0
; LA32-NEXT:    ffint.d.w $fa0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_i8_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    movgr2fr.w $fa0, $a0
; LA64-NEXT:    ffint.d.w $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = sitofp i8 %a to double
  ret double %1
}

define double @convert_i16_to_double(i16 signext %a) nounwind {
; LA32-LABEL: convert_i16_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    movgr2fr.w $fa0, $a0
; LA32-NEXT:    ffint.d.w $fa0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_i16_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    movgr2fr.w $fa0, $a0
; LA64-NEXT:    ffint.d.w $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = sitofp i16 %a to double
  ret double %1
}

define double @convert_i32_to_double(i32 %a) nounwind {
; LA32-LABEL: convert_i32_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    movgr2fr.w $fa0, $a0
; LA32-NEXT:    ffint.d.w $fa0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_i32_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    movgr2fr.w $fa0, $a0
; LA64-NEXT:    ffint.d.w $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = sitofp i32 %a to double
  ret double %1
}

define double @convert_i64_to_double(i64 %a) nounwind {
; LA32-LABEL: convert_i64_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    st.w $ra, $sp, 12 # 4-byte Folded Spill
; LA32-NEXT:    bl __floatdidf
; LA32-NEXT:    ld.w $ra, $sp, 12 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_i64_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    movgr2fr.d $fa0, $a0
; LA64-NEXT:    ffint.d.l $fa0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = sitofp i64 %a to double
  ret double %1
}

define i32 @convert_double_to_i32(double %a) nounwind {
; LA32-LABEL: convert_double_to_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    ftintrz.w.d $fa0, $fa0
; LA32-NEXT:    movfr2gr.s $a0, $fa0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_double_to_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    ftintrz.w.d $fa0, $fa0
; LA64-NEXT:    movfr2gr.s $a0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = fptosi double %a to i32
  ret i32 %1
}

define i64 @convert_double_to_i64(double %a) nounwind {
; LA32-LABEL: convert_double_to_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    st.w $ra, $sp, 12 # 4-byte Folded Spill
; LA32-NEXT:    bl __fixdfdi
; LA32-NEXT:    ld.w $ra, $sp, 12 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: convert_double_to_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    ftintrz.l.d $fa0, $fa0
; LA64-NEXT:    movfr2gr.d $a0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = fptosi double %a to i64
  ret i64 %1
}

define i64 @bitcast_double_to_i64(double %a) nounwind {
; LA32-LABEL: bitcast_double_to_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    fst.d $fa0, $sp, 8
; LA32-NEXT:    addi.w $a0, $sp, 8
; LA32-NEXT:    ori $a0, $a0, 4
; LA32-NEXT:    ld.w $a1, $a0, 0
; LA32-NEXT:    ld.w $a0, $sp, 8
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: bitcast_double_to_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    movfr2gr.d $a0, $fa0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = bitcast double %a to i64
  ret i64 %1
}

define double @bitcast_i64_to_double(i64 %a) nounwind {
; LA32-LABEL: bitcast_i64_to_double:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    addi.w $a2, $sp, 8
; LA32-NEXT:    ori $a2, $a2, 4
; LA32-NEXT:    st.w $a1, $a2, 0
; LA32-NEXT:    st.w $a0, $sp, 8
; LA32-NEXT:    fld.d $fa0, $sp, 8
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: bitcast_i64_to_double:
; LA64:       # %bb.0:
; LA64-NEXT:    movgr2fr.d $fa0, $a0
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = bitcast i64 %a to double
  ret double %1
}
