; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zbp -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32ZBP

declare i32 @llvm.riscv.grev.i32(i32 %a, i32 %b)

define i32 @grev32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: grev32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    grev a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.grev.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

define i32 @grev32_demandedbits(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: grev32_demandedbits:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    grev a0, a0, a1
; RV32ZBP-NEXT:    ret
  %c = and i32 %b, 31
  %tmp = call i32 @llvm.riscv.grev.i32(i32 %a, i32 %b)
  ret i32 %tmp
}

define i32 @grevi32(i32 %a) nounwind {
; RV32ZBP-LABEL: grevi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    grevi a0, a0, 13
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.grev.i32(i32 %a, i32 13)
 ret i32 %tmp
}

declare i32 @llvm.riscv.gorc.i32(i32 %a, i32 %b)

define i32 @gorc32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: gorc32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    gorc a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.gorc.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

define i32 @gorc32_demandedbits(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: gorc32_demandedbits:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    gorc a0, a0, a1
; RV32ZBP-NEXT:    ret
  %c = and i32 %b, 31
  %tmp = call i32 @llvm.riscv.gorc.i32(i32 %a, i32 %b)
  ret i32 %tmp
}

define i32 @gorci32(i32 %a) nounwind {
; RV32ZBP-LABEL: gorci32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    gorci a0, a0, 13
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.gorc.i32(i32 %a, i32 13)
 ret i32 %tmp
}

declare i32 @llvm.riscv.shfl.i32(i32 %a, i32 %b)

define i32 @shfl32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: shfl32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    shfl a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

define i32 @shfl32_demandedbits(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: shfl32_demandedbits:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    shfl a0, a0, a1
; RV32ZBP-NEXT:    ret
  %c = and i32 %b, 15
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 %c)
  ret i32 %tmp
}

define i32 @zipni32(i32 %a) nounwind {
; RV32ZBP-LABEL: zipni32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip.n a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 1)
 ret i32 %tmp
}

define i32 @zip2bi32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip2bi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip2.b a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 2)
 ret i32 %tmp
}

define i32 @zipbi32(i32 %a) nounwind {
; RV32ZBP-LABEL: zipbi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip.b a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 3)
 ret i32 %tmp
}

define i32 @zip4hi32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip4hi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip4.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 4)
 ret i32 %tmp
}

define i32 @zip2hi32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip2hi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip2.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 6)
 ret i32 %tmp
}

define i32 @ziphi32(i32 %a) nounwind {
; RV32ZBP-LABEL: ziphi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 7)
 ret i32 %tmp
}

define i32 @shfli32(i32 %a) nounwind {
; RV32ZBP-LABEL: shfli32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    shfli a0, a0, 13
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 13)
 ret i32 %tmp
}

define i32 @zip4i32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip4i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip4 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 12)
 ret i32 %tmp
}

define i32 @zip2i32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip2i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip2 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 14)
 ret i32 %tmp
}

define i32 @zipi32(i32 %a) nounwind {
; RV32ZBP-LABEL: zipi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 15)
 ret i32 %tmp
}

define i32 @zip8i32(i32 %a) nounwind {
; RV32ZBP-LABEL: zip8i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    zip8 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.shfl.i32(i32 %a, i32 8)
 ret i32 %tmp
}

declare i32 @llvm.riscv.unshfl.i32(i32 %a, i32 %b)

define i32 @unshfl32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: unshfl32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unshfl a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

define i32 @unshfl32_demandedbits(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: unshfl32_demandedbits:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unshfl a0, a0, a1
; RV32ZBP-NEXT:    ret
  %c = and i32 %b, 15
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 %c)
  ret i32 %tmp
}

define i32 @unzipni32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzipni32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip.n a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 1)
 ret i32 %tmp
}

define i32 @unzip2bi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip2bi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip2.b a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 2)
 ret i32 %tmp
}

define i32 @unzipbi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzipbi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip.b a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 3)
 ret i32 %tmp
}

define i32 @unzip4hi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip4hi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip4.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 4)
 ret i32 %tmp
}

define i32 @unzip2hi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip2hi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip2.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 6)
 ret i32 %tmp
}

define i32 @unziphi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unziphi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip.h a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 7)
 ret i32 %tmp
}

define i32 @unshfli32(i32 %a) nounwind {
; RV32ZBP-LABEL: unshfli32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unshfli a0, a0, 13
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 13)
 ret i32 %tmp
}

define i32 @unzip4i32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip4i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip4 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 12)
 ret i32 %tmp
}

define i32 @unzip2i32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip2i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip2 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 14)
 ret i32 %tmp
}

define i32 @unzipi32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzipi32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 15)
 ret i32 %tmp
}

define i32 @unzip8i32(i32 %a) nounwind {
; RV32ZBP-LABEL: unzip8i32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    unzip8 a0, a0
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.unshfl.i32(i32 %a, i32 8)
 ret i32 %tmp
}

declare i32 @llvm.riscv.xperm.n.i32(i32 %a, i32 %b)

define i32 @xpermn32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: xpermn32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    xperm.n a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.xperm.n.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

declare i32 @llvm.riscv.xperm.b.i32(i32 %a, i32 %b)

define i32 @xpermb32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: xpermb32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    xperm.b a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.xperm.b.i32(i32 %a, i32 %b)
 ret i32 %tmp
}

declare i32 @llvm.riscv.xperm.h.i32(i32 %a, i32 %b)

define i32 @xpermh32(i32 %a, i32 %b) nounwind {
; RV32ZBP-LABEL: xpermh32:
; RV32ZBP:       # %bb.0:
; RV32ZBP-NEXT:    xperm.h a0, a0, a1
; RV32ZBP-NEXT:    ret
  %tmp = call i32 @llvm.riscv.xperm.h.i32(i32 %a, i32 %b)
 ret i32 %tmp
}
