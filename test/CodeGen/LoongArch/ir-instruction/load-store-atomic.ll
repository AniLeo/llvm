; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

define i8 @load_acquire_i8(ptr %ptr) {
; LA32-LABEL: load_acquire_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.b $a0, $a0, 0
; LA32-NEXT:    dbar 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: load_acquire_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.b $a0, $a0, 0
; LA64-NEXT:    dbar 0
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load atomic i8, ptr %ptr acquire, align 1
  ret i8 %val
}

define i16 @load_acquire_i16(ptr %ptr) {
; LA32-LABEL: load_acquire_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.h $a0, $a0, 0
; LA32-NEXT:    dbar 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: load_acquire_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.h $a0, $a0, 0
; LA64-NEXT:    dbar 0
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load atomic i16, ptr %ptr acquire, align 2
  ret i16 %val
}

define i32 @load_acquire_i32(ptr %ptr) {
; LA32-LABEL: load_acquire_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    ld.w $a0, $a0, 0
; LA32-NEXT:    dbar 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: load_acquire_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.w $a0, $a0, 0
; LA64-NEXT:    dbar 0
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load atomic i32, ptr %ptr acquire, align 4
  ret i32 %val
}

define i64 @load_acquire_i64(ptr %ptr) {
; LA32-LABEL: load_acquire_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    .cfi_def_cfa_offset 16
; LA32-NEXT:    st.w $ra, $sp, 12 # 4-byte Folded Spill
; LA32-NEXT:    .cfi_offset 1, -4
; LA32-NEXT:    ori $a1, $zero, 2
; LA32-NEXT:    bl __atomic_load_8
; LA32-NEXT:    ld.w $ra, $sp, 12 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: load_acquire_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    ld.d $a0, $a0, 0
; LA64-NEXT:    dbar 0
; LA64-NEXT:    jirl $zero, $ra, 0
  %val = load atomic i64, ptr %ptr acquire, align 8
  ret i64 %val
}

define void @store_release_i8(ptr %ptr, i8 signext %v) {
; LA32-LABEL: store_release_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    dbar 0
; LA32-NEXT:    st.b $a0, $a1, 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: store_release_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    dbar 0
; LA64-NEXT:    st.b $a0, $a1, 0
; LA64-NEXT:    jirl $zero, $ra, 0
  store atomic i8 %v, ptr %ptr release, align 1
  ret void
}

define void @store_release_i16(ptr %ptr, i16 signext %v) {
; LA32-LABEL: store_release_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    dbar 0
; LA32-NEXT:    st.h $a0, $a1, 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: store_release_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    dbar 0
; LA64-NEXT:    st.h $a0, $a1, 0
; LA64-NEXT:    jirl $zero, $ra, 0
  store atomic i16 %v, ptr %ptr release, align 2
  ret void
}

define void @store_release_i32(ptr %ptr, i32 signext %v) {
; LA32-LABEL: store_release_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    dbar 0
; LA32-NEXT:    st.w $a0, $a1, 0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: store_release_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    dbar 0
; LA64-NEXT:    st.w $a0, $a1, 0
; LA64-NEXT:    jirl $zero, $ra, 0
  store atomic i32 %v, ptr %ptr release, align 4
  ret void
}

define void @store_release_i64(ptr %ptr, i64 %v) {
; LA32-LABEL: store_release_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -16
; LA32-NEXT:    .cfi_def_cfa_offset 16
; LA32-NEXT:    st.w $ra, $sp, 12 # 4-byte Folded Spill
; LA32-NEXT:    .cfi_offset 1, -4
; LA32-NEXT:    ori $a3, $zero, 3
; LA32-NEXT:    bl __atomic_store_8
; LA32-NEXT:    ld.w $ra, $sp, 12 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 16
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: store_release_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    dbar 0
; LA64-NEXT:    st.d $a0, $a1, 0
; LA64-NEXT:    jirl $zero, $ra, 0
  store atomic i64 %v, ptr %ptr release, align 8
  ret void
}
