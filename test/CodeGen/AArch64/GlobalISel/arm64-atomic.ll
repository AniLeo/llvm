; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-apple-ios -global-isel -global-isel-abort=1 -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK-NOLSE,CHECK-NOLSE-O1
; RUN: llc < %s -mtriple=arm64-apple-ios -global-isel -global-isel-abort=1 -O0 -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK-NOLSE,CHECK-NOLSE-O0
; RUN: llc < %s -mtriple=arm64-apple-ios -global-isel -global-isel-abort=1 -mcpu=apple-a13 -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK-LSE-O1
; RUN: llc < %s -mtriple=arm64-apple-ios -global-isel -global-isel-abort=1 -mcpu=apple-a13 -O0 -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK-LSE-O0

define i32 @val_compare_and_swap(i32* %p, i32 %cmp, i32 %new) #0 {
; CHECK-NOLSE-O1-LABEL: val_compare_and_swap:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB0_1: ; %cmpxchg.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldaxr w8, [x0]
; CHECK-NOLSE-O1-NEXT:    cmp w8, w1
; CHECK-NOLSE-O1-NEXT:    b.ne LBB0_4
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %cmpxchg.trystore
; CHECK-NOLSE-O1-NEXT:    ; in Loop: Header=BB0_1 Depth=1
; CHECK-NOLSE-O1-NEXT:    stxr w9, w2, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w9, LBB0_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.3: ; %cmpxchg.end
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
; CHECK-NOLSE-O1-NEXT:  LBB0_4: ; %cmpxchg.nostore
; CHECK-NOLSE-O1-NEXT:    clrex
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: val_compare_and_swap:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    mov x9, x0
; CHECK-NOLSE-O0-NEXT:  LBB0_1: ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldaxr w0, [x9]
; CHECK-NOLSE-O0-NEXT:    cmp w0, w1
; CHECK-NOLSE-O0-NEXT:    b.ne LBB0_3
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; in Loop: Header=BB0_1 Depth=1
; CHECK-NOLSE-O0-NEXT:    stlxr w8, w2, [x9]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB0_1
; CHECK-NOLSE-O0-NEXT:  LBB0_3:
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: val_compare_and_swap:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    casa w1, w2, [x0]
; CHECK-LSE-O1-NEXT:    mov x0, x1
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: val_compare_and_swap:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov x8, x0
; CHECK-LSE-O0-NEXT:    mov x0, x1
; CHECK-LSE-O0-NEXT:    casa w0, w2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %pair = cmpxchg i32* %p, i32 %cmp, i32 %new acquire acquire
  %val = extractvalue { i32, i1 } %pair, 0
  ret i32 %val
}

define i32 @val_compare_and_swap_from_load(i32* %p, i32 %cmp, i32* %pnew) #0 {
; CHECK-NOLSE-O1-LABEL: val_compare_and_swap_from_load:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    ldr w9, [x2]
; CHECK-NOLSE-O1-NEXT:  LBB1_1: ; %cmpxchg.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldaxr w8, [x0]
; CHECK-NOLSE-O1-NEXT:    cmp w8, w1
; CHECK-NOLSE-O1-NEXT:    b.ne LBB1_4
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %cmpxchg.trystore
; CHECK-NOLSE-O1-NEXT:    ; in Loop: Header=BB1_1 Depth=1
; CHECK-NOLSE-O1-NEXT:    stxr w10, w9, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w10, LBB1_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.3: ; %cmpxchg.end
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
; CHECK-NOLSE-O1-NEXT:  LBB1_4: ; %cmpxchg.nostore
; CHECK-NOLSE-O1-NEXT:    clrex
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: val_compare_and_swap_from_load:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    mov x9, x0
; CHECK-NOLSE-O0-NEXT:    ldr w10, [x2]
; CHECK-NOLSE-O0-NEXT:  LBB1_1: ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldaxr w0, [x9]
; CHECK-NOLSE-O0-NEXT:    cmp w0, w1
; CHECK-NOLSE-O0-NEXT:    b.ne LBB1_3
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; in Loop: Header=BB1_1 Depth=1
; CHECK-NOLSE-O0-NEXT:    stlxr w8, w10, [x9]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB1_1
; CHECK-NOLSE-O0-NEXT:  LBB1_3:
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: val_compare_and_swap_from_load:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldr w8, [x2]
; CHECK-LSE-O1-NEXT:    casa w1, w8, [x0]
; CHECK-LSE-O1-NEXT:    mov x0, x1
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: val_compare_and_swap_from_load:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov x9, x0
; CHECK-LSE-O0-NEXT:    mov x0, x1
; CHECK-LSE-O0-NEXT:    ldr w8, [x2]
; CHECK-LSE-O0-NEXT:    casa w0, w8, [x9]
; CHECK-LSE-O0-NEXT:    ret
  %new = load i32, i32* %pnew
  %pair = cmpxchg i32* %p, i32 %cmp, i32 %new acquire acquire
  %val = extractvalue { i32, i1 } %pair, 0
  ret i32 %val
}

define i32 @val_compare_and_swap_rel(i32* %p, i32 %cmp, i32 %new) #0 {
; CHECK-NOLSE-O1-LABEL: val_compare_and_swap_rel:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB2_1: ; %cmpxchg.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldaxr w8, [x0]
; CHECK-NOLSE-O1-NEXT:    cmp w8, w1
; CHECK-NOLSE-O1-NEXT:    b.ne LBB2_4
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %cmpxchg.trystore
; CHECK-NOLSE-O1-NEXT:    ; in Loop: Header=BB2_1 Depth=1
; CHECK-NOLSE-O1-NEXT:    stlxr w9, w2, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w9, LBB2_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.3: ; %cmpxchg.end
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
; CHECK-NOLSE-O1-NEXT:  LBB2_4: ; %cmpxchg.nostore
; CHECK-NOLSE-O1-NEXT:    clrex
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: val_compare_and_swap_rel:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    mov x9, x0
; CHECK-NOLSE-O0-NEXT:  LBB2_1: ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldaxr w0, [x9]
; CHECK-NOLSE-O0-NEXT:    cmp w0, w1
; CHECK-NOLSE-O0-NEXT:    b.ne LBB2_3
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; in Loop: Header=BB2_1 Depth=1
; CHECK-NOLSE-O0-NEXT:    stlxr w8, w2, [x9]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB2_1
; CHECK-NOLSE-O0-NEXT:  LBB2_3:
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: val_compare_and_swap_rel:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    casal w1, w2, [x0]
; CHECK-LSE-O1-NEXT:    mov x0, x1
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: val_compare_and_swap_rel:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov x8, x0
; CHECK-LSE-O0-NEXT:    mov x0, x1
; CHECK-LSE-O0-NEXT:    casal w0, w2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %pair = cmpxchg i32* %p, i32 %cmp, i32 %new acq_rel monotonic
  %val = extractvalue { i32, i1 } %pair, 0
  ret i32 %val
}

define i64 @val_compare_and_swap_64(i64* %p, i64 %cmp, i64 %new) #0 {
; CHECK-NOLSE-O1-LABEL: val_compare_and_swap_64:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB3_1: ; %cmpxchg.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldxr x8, [x0]
; CHECK-NOLSE-O1-NEXT:    cmp x8, x1
; CHECK-NOLSE-O1-NEXT:    b.ne LBB3_4
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %cmpxchg.trystore
; CHECK-NOLSE-O1-NEXT:    ; in Loop: Header=BB3_1 Depth=1
; CHECK-NOLSE-O1-NEXT:    stxr w9, x2, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w9, LBB3_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.3: ; %cmpxchg.end
; CHECK-NOLSE-O1-NEXT:    mov x0, x8
; CHECK-NOLSE-O1-NEXT:    ret
; CHECK-NOLSE-O1-NEXT:  LBB3_4: ; %cmpxchg.nostore
; CHECK-NOLSE-O1-NEXT:    clrex
; CHECK-NOLSE-O1-NEXT:    mov x0, x8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: val_compare_and_swap_64:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    mov x9, x0
; CHECK-NOLSE-O0-NEXT:  LBB3_1: ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldaxr x0, [x9]
; CHECK-NOLSE-O0-NEXT:    cmp x0, x1
; CHECK-NOLSE-O0-NEXT:    b.ne LBB3_3
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; in Loop: Header=BB3_1 Depth=1
; CHECK-NOLSE-O0-NEXT:    stlxr w8, x2, [x9]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB3_1
; CHECK-NOLSE-O0-NEXT:  LBB3_3:
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: val_compare_and_swap_64:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    cas x1, x2, [x0]
; CHECK-LSE-O1-NEXT:    mov x0, x1
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: val_compare_and_swap_64:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov x8, x0
; CHECK-LSE-O0-NEXT:    mov x0, x1
; CHECK-LSE-O0-NEXT:    cas x0, x2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %pair = cmpxchg i64* %p, i64 %cmp, i64 %new monotonic monotonic
  %val = extractvalue { i64, i1 } %pair, 0
  ret i64 %val
}

define i32 @fetch_and_nand(i32* %p) #0 {
; CHECK-NOLSE-O1-LABEL: fetch_and_nand:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB4_1: ; %atomicrmw.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldxr w8, [x0]
; CHECK-NOLSE-O1-NEXT:    and w9, w8, #0x7
; CHECK-NOLSE-O1-NEXT:    mvn w9, w9
; CHECK-NOLSE-O1-NEXT:    stlxr w10, w9, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w10, LBB4_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: fetch_and_nand:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:  LBB4_1: ; %atomicrmw.start
; CHECK-NOLSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    ldxr w8, [x10]
; CHECK-NOLSE-O0-NEXT:    ; kill: def $x8 killed $w8
; CHECK-NOLSE-O0-NEXT:    ; kill: def $w8 killed $w8 killed $x8
; CHECK-NOLSE-O0-NEXT:    str w8, [sp, #4] ; 4-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:    and w8, w8, #0x7
; CHECK-NOLSE-O0-NEXT:    mvn w9, w8
; CHECK-NOLSE-O0-NEXT:    stlxr w8, w9, [x10]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB4_1
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O0-NEXT:    ldr w0, [sp, #4] ; 4-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: fetch_and_nand:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:  LBB4_1: ; %atomicrmw.start
; CHECK-LSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-LSE-O1-NEXT:    ldxr w8, [x0]
; CHECK-LSE-O1-NEXT:    and w9, w8, #0x7
; CHECK-LSE-O1-NEXT:    mvn w9, w9
; CHECK-LSE-O1-NEXT:    stlxr w10, w9, [x0]
; CHECK-LSE-O1-NEXT:    cbnz w10, LBB4_1
; CHECK-LSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-LSE-O1-NEXT:    mov x0, x8
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: fetch_and_nand:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-LSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-LSE-O0-NEXT:  LBB4_1: ; %atomicrmw.start
; CHECK-LSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-LSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-LSE-O0-NEXT:    ldxr w8, [x10]
; CHECK-LSE-O0-NEXT:    ; kill: def $x8 killed $w8
; CHECK-LSE-O0-NEXT:    ; kill: def $w8 killed $w8 killed $x8
; CHECK-LSE-O0-NEXT:    str w8, [sp, #4] ; 4-byte Folded Spill
; CHECK-LSE-O0-NEXT:    and w8, w8, #0x7
; CHECK-LSE-O0-NEXT:    mvn w9, w8
; CHECK-LSE-O0-NEXT:    stlxr w8, w9, [x10]
; CHECK-LSE-O0-NEXT:    cbnz w8, LBB4_1
; CHECK-LSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-LSE-O0-NEXT:    ldr w0, [sp, #4] ; 4-byte Folded Reload
; CHECK-LSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-LSE-O0-NEXT:    ret
  %val = atomicrmw nand i32* %p, i32 7 release
  ret i32 %val
}

define i64 @fetch_and_nand_64(i64* %p) #0 {
; CHECK-NOLSE-O1-LABEL: fetch_and_nand_64:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB5_1: ; %atomicrmw.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldaxr x8, [x0]
; CHECK-NOLSE-O1-NEXT:    and x9, x8, #0x7
; CHECK-NOLSE-O1-NEXT:    mvn x9, x9
; CHECK-NOLSE-O1-NEXT:    stlxr w10, x9, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w10, LBB5_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O1-NEXT:    mov x0, x8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: fetch_and_nand_64:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:  LBB5_1: ; %atomicrmw.start
; CHECK-NOLSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    ldaxr x8, [x10]
; CHECK-NOLSE-O0-NEXT:    str x8, [sp] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:    and x8, x8, #0x7
; CHECK-NOLSE-O0-NEXT:    mvn x9, x8
; CHECK-NOLSE-O0-NEXT:    stlxr w8, x9, [x10]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB5_1
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O0-NEXT:    ldr x0, [sp] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: fetch_and_nand_64:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:  LBB5_1: ; %atomicrmw.start
; CHECK-LSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-LSE-O1-NEXT:    ldaxr x8, [x0]
; CHECK-LSE-O1-NEXT:    and x9, x8, #0x7
; CHECK-LSE-O1-NEXT:    mvn x9, x9
; CHECK-LSE-O1-NEXT:    stlxr w10, x9, [x0]
; CHECK-LSE-O1-NEXT:    cbnz w10, LBB5_1
; CHECK-LSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-LSE-O1-NEXT:    mov x0, x8
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: fetch_and_nand_64:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-LSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-LSE-O0-NEXT:  LBB5_1: ; %atomicrmw.start
; CHECK-LSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-LSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-LSE-O0-NEXT:    ldaxr x8, [x10]
; CHECK-LSE-O0-NEXT:    str x8, [sp] ; 8-byte Folded Spill
; CHECK-LSE-O0-NEXT:    and x8, x8, #0x7
; CHECK-LSE-O0-NEXT:    mvn x9, x8
; CHECK-LSE-O0-NEXT:    stlxr w8, x9, [x10]
; CHECK-LSE-O0-NEXT:    cbnz w8, LBB5_1
; CHECK-LSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-LSE-O0-NEXT:    ldr x0, [sp] ; 8-byte Folded Reload
; CHECK-LSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-LSE-O0-NEXT:    ret
  %val = atomicrmw nand i64* %p, i64 7 acq_rel
  ret i64 %val
}

define i32 @fetch_and_or(i32* %p) #0 {
; CHECK-NOLSE-O1-LABEL: fetch_and_or:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    mov w9, #5
; CHECK-NOLSE-O1-NEXT:  LBB6_1: ; %atomicrmw.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldaxr w8, [x0]
; CHECK-NOLSE-O1-NEXT:    orr w10, w8, w9
; CHECK-NOLSE-O1-NEXT:    stlxr w11, w10, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w11, LBB6_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O1-NEXT:    mov w0, w8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: fetch_and_or:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:  LBB6_1: ; %atomicrmw.start
; CHECK-NOLSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    ldaxr w8, [x10]
; CHECK-NOLSE-O0-NEXT:    ; kill: def $x8 killed $w8
; CHECK-NOLSE-O0-NEXT:    ; kill: def $w8 killed $w8 killed $x8
; CHECK-NOLSE-O0-NEXT:    str w8, [sp, #4] ; 4-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:    mov w9, #5
; CHECK-NOLSE-O0-NEXT:    orr w9, w8, w9
; CHECK-NOLSE-O0-NEXT:    stlxr w8, w9, [x10]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB6_1
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O0-NEXT:    ldr w0, [sp, #4] ; 4-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: fetch_and_or:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    mov w8, #5
; CHECK-LSE-O1-NEXT:    ldsetal w8, w0, [x0]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: fetch_and_or:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov w8, #5
; CHECK-LSE-O0-NEXT:    ldsetal w8, w0, [x0]
; CHECK-LSE-O0-NEXT:    ret
  %val = atomicrmw or i32* %p, i32 5 seq_cst
  ret i32 %val
}

define i64 @fetch_and_or_64(i64* %p) #0 {
; CHECK-NOLSE-O1-LABEL: fetch_and_or_64:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:  LBB7_1: ; %atomicrmw.start
; CHECK-NOLSE-O1-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O1-NEXT:    ldxr x8, [x0]
; CHECK-NOLSE-O1-NEXT:    orr x9, x8, #0x7
; CHECK-NOLSE-O1-NEXT:    stxr w10, x9, [x0]
; CHECK-NOLSE-O1-NEXT:    cbnz w10, LBB7_1
; CHECK-NOLSE-O1-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O1-NEXT:    mov x0, x8
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: fetch_and_or_64:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    sub sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    str x0, [sp, #8] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:  LBB7_1: ; %atomicrmw.start
; CHECK-NOLSE-O0-NEXT:    ; =>This Inner Loop Header: Depth=1
; CHECK-NOLSE-O0-NEXT:    ldr x10, [sp, #8] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    ldxr x8, [x10]
; CHECK-NOLSE-O0-NEXT:    str x8, [sp] ; 8-byte Folded Spill
; CHECK-NOLSE-O0-NEXT:    orr x9, x8, #0x7
; CHECK-NOLSE-O0-NEXT:    stxr w8, x9, [x10]
; CHECK-NOLSE-O0-NEXT:    cbnz w8, LBB7_1
; CHECK-NOLSE-O0-NEXT:  ; %bb.2: ; %atomicrmw.end
; CHECK-NOLSE-O0-NEXT:    ldr x0, [sp] ; 8-byte Folded Reload
; CHECK-NOLSE-O0-NEXT:    add sp, sp, #16 ; =16
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: fetch_and_or_64:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    mov w8, #7
; CHECK-LSE-O1-NEXT:    ldset x8, x0, [x0]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: fetch_and_or_64:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov w8, #7
; CHECK-LSE-O0-NEXT:    ; kill: def $x8 killed $w8
; CHECK-LSE-O0-NEXT:    ldset x8, x0, [x0]
; CHECK-LSE-O0-NEXT:    ret
  %val = atomicrmw or i64* %p, i64 7 monotonic
  ret i64 %val
}

define void @acquire_fence() #0 {
; CHECK-NOLSE-LABEL: acquire_fence:
; CHECK-NOLSE:       ; %bb.0:
; CHECK-NOLSE-NEXT:    dmb ish
; CHECK-NOLSE-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: acquire_fence:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    dmb ish
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: acquire_fence:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    dmb ish
; CHECK-LSE-O0-NEXT:    ret
   fence acquire
   ret void
}

define void @release_fence() #0 {
; CHECK-NOLSE-LABEL: release_fence:
; CHECK-NOLSE:       ; %bb.0:
; CHECK-NOLSE-NEXT:    dmb ish
; CHECK-NOLSE-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: release_fence:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    dmb ish
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: release_fence:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    dmb ish
; CHECK-LSE-O0-NEXT:    ret
   fence release
   ret void
}

define void @seq_cst_fence() #0 {
; CHECK-NOLSE-LABEL: seq_cst_fence:
; CHECK-NOLSE:       ; %bb.0:
; CHECK-NOLSE-NEXT:    dmb ish
; CHECK-NOLSE-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: seq_cst_fence:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    dmb ish
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: seq_cst_fence:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    dmb ish
; CHECK-LSE-O0-NEXT:    ret
   fence seq_cst
   ret void
}

define i32 @atomic_load(i32* %p) #0 {
; CHECK-NOLSE-LABEL: atomic_load:
; CHECK-NOLSE:       ; %bb.0:
; CHECK-NOLSE-NEXT:    ldar w0, [x0]
; CHECK-NOLSE-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_load:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldar w0, [x0]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_load:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    ldar w0, [x0]
; CHECK-LSE-O0-NEXT:    ret
   %r = load atomic i32, i32* %p seq_cst, align 4
   ret i32 %r
}

define i8 @atomic_load_relaxed_8(i8* %p, i32 %off32) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_load_relaxed_8:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    ldrb w8, [x0, #4095]
; CHECK-NOLSE-O1-NEXT:    ldrb w9, [x0, w1, sxtw]
; CHECK-NOLSE-O1-NEXT:    ldurb w10, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    add x11, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    ldrb w11, [x11]
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w9
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w10
; CHECK-NOLSE-O1-NEXT:    add w0, w8, w11
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_load_relaxed_8:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    ldrb w9, [x0, #4095]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, w1, sxtw
; CHECK-NOLSE-O0-NEXT:    ldrb w8, [x8]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9, uxtb
; CHECK-NOLSE-O0-NEXT:    subs x9, x0, #256 ; =256
; CHECK-NOLSE-O0-NEXT:    ldrb w9, [x9]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9, uxtb
; CHECK-NOLSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    ldrb w9, [x9]
; CHECK-NOLSE-O0-NEXT:    add w0, w8, w9, uxtb
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_load_relaxed_8:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldrb w8, [x0, #4095]
; CHECK-LSE-O1-NEXT:    ldrb w9, [x0, w1, sxtw]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    ldurb w9, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    ldrb w9, [x9]
; CHECK-LSE-O1-NEXT:    add w0, w8, w9
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_load_relaxed_8:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    ldrb w9, [x0, #4095]
; CHECK-LSE-O0-NEXT:    add x8, x0, w1, sxtw
; CHECK-LSE-O0-NEXT:    ldrb w8, [x8]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9, uxtb
; CHECK-LSE-O0-NEXT:    subs x9, x0, #256 ; =256
; CHECK-LSE-O0-NEXT:    ldrb w9, [x9]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9, uxtb
; CHECK-LSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    ldrb w9, [x9]
; CHECK-LSE-O0-NEXT:    add w0, w8, w9, uxtb
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i8, i8* %p, i32 4095
  %val_unsigned = load atomic i8, i8* %ptr_unsigned monotonic, align 1

  %ptr_regoff = getelementptr i8, i8* %p, i32 %off32
  %val_regoff = load atomic i8, i8* %ptr_regoff unordered, align 1
  %tot1 = add i8 %val_unsigned, %val_regoff

  %ptr_unscaled = getelementptr i8, i8* %p, i32 -256
  %val_unscaled = load atomic i8, i8* %ptr_unscaled monotonic, align 1
  %tot2 = add i8 %tot1, %val_unscaled

  %ptr_random = getelementptr i8, i8* %p, i32 1191936 ; 0x123000 (i.e. ADD imm)
  %val_random = load atomic i8, i8* %ptr_random unordered, align 1
  %tot3 = add i8 %tot2, %val_random

  ret i8 %tot3
}

define i16 @atomic_load_relaxed_16(i16* %p, i32 %off32) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_load_relaxed_16:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    ldrh w8, [x0, #8190]
; CHECK-NOLSE-O1-NEXT:    ldrh w9, [x0, w1, sxtw #1]
; CHECK-NOLSE-O1-NEXT:    ldurh w10, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    add x11, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    ldrh w11, [x11]
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w9
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w10
; CHECK-NOLSE-O1-NEXT:    add w0, w8, w11
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_load_relaxed_16:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    ldrh w9, [x0, #8190]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-NOLSE-O0-NEXT:    ldrh w8, [x8]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9, uxth
; CHECK-NOLSE-O0-NEXT:    subs x9, x0, #256 ; =256
; CHECK-NOLSE-O0-NEXT:    ldrh w9, [x9]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9, uxth
; CHECK-NOLSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    ldrh w9, [x9]
; CHECK-NOLSE-O0-NEXT:    add w0, w8, w9, uxth
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_load_relaxed_16:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldrh w8, [x0, #8190]
; CHECK-LSE-O1-NEXT:    ldrh w9, [x0, w1, sxtw #1]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    ldurh w9, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    ldrh w9, [x9]
; CHECK-LSE-O1-NEXT:    add w0, w8, w9
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_load_relaxed_16:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    ldrh w9, [x0, #8190]
; CHECK-LSE-O0-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-LSE-O0-NEXT:    ldrh w8, [x8]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9, uxth
; CHECK-LSE-O0-NEXT:    subs x9, x0, #256 ; =256
; CHECK-LSE-O0-NEXT:    ldrh w9, [x9]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9, uxth
; CHECK-LSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    ldrh w9, [x9]
; CHECK-LSE-O0-NEXT:    add w0, w8, w9, uxth
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i16, i16* %p, i32 4095
  %val_unsigned = load atomic i16, i16* %ptr_unsigned monotonic, align 2

  %ptr_regoff = getelementptr i16, i16* %p, i32 %off32
  %val_regoff = load atomic i16, i16* %ptr_regoff unordered, align 2
  %tot1 = add i16 %val_unsigned, %val_regoff

  %ptr_unscaled = getelementptr i16, i16* %p, i32 -128
  %val_unscaled = load atomic i16, i16* %ptr_unscaled monotonic, align 2
  %tot2 = add i16 %tot1, %val_unscaled

  %ptr_random = getelementptr i16, i16* %p, i32 595968 ; 0x123000/2 (i.e. ADD imm)
  %val_random = load atomic i16, i16* %ptr_random unordered, align 2
  %tot3 = add i16 %tot2, %val_random

  ret i16 %tot3
}

define i32 @atomic_load_relaxed_32(i32* %p, i32 %off32) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_load_relaxed_32:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    ldr w8, [x0, #16380]
; CHECK-NOLSE-O1-NEXT:    ldr w9, [x0, w1, sxtw #2]
; CHECK-NOLSE-O1-NEXT:    ldur w10, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    add x11, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    ldr w11, [x11]
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w9
; CHECK-NOLSE-O1-NEXT:    add w8, w8, w10
; CHECK-NOLSE-O1-NEXT:    add w0, w8, w11
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_load_relaxed_32:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    ldr w8, [x0, #16380]
; CHECK-NOLSE-O0-NEXT:    ldr w9, [x0, w1, sxtw #2]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9
; CHECK-NOLSE-O0-NEXT:    ldur w9, [x0, #-256]
; CHECK-NOLSE-O0-NEXT:    add w8, w8, w9
; CHECK-NOLSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    ldr w9, [x9]
; CHECK-NOLSE-O0-NEXT:    add w0, w8, w9
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_load_relaxed_32:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldr w8, [x0, #16380]
; CHECK-LSE-O1-NEXT:    ldr w9, [x0, w1, sxtw #2]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    ldur w9, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add w8, w8, w9
; CHECK-LSE-O1-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    ldr w9, [x9]
; CHECK-LSE-O1-NEXT:    add w0, w8, w9
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_load_relaxed_32:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    ldr w8, [x0, #16380]
; CHECK-LSE-O0-NEXT:    ldr w9, [x0, w1, sxtw #2]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9
; CHECK-LSE-O0-NEXT:    ldur w9, [x0, #-256]
; CHECK-LSE-O0-NEXT:    add w8, w8, w9
; CHECK-LSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    ldr w9, [x9]
; CHECK-LSE-O0-NEXT:    add w0, w8, w9
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i32, i32* %p, i32 4095
  %val_unsigned = load atomic i32, i32* %ptr_unsigned monotonic, align 4

  %ptr_regoff = getelementptr i32, i32* %p, i32 %off32
  %val_regoff = load atomic i32, i32* %ptr_regoff unordered, align 4
  %tot1 = add i32 %val_unsigned, %val_regoff

  %ptr_unscaled = getelementptr i32, i32* %p, i32 -64
  %val_unscaled = load atomic i32, i32* %ptr_unscaled monotonic, align 4
  %tot2 = add i32 %tot1, %val_unscaled

  %ptr_random = getelementptr i32, i32* %p, i32 297984 ; 0x123000/4 (i.e. ADD imm)
  %val_random = load atomic i32, i32* %ptr_random unordered, align 4
  %tot3 = add i32 %tot2, %val_random

  ret i32 %tot3
}

define i64 @atomic_load_relaxed_64(i64* %p, i32 %off32) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_load_relaxed_64:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    ldr x8, [x0, #32760]
; CHECK-NOLSE-O1-NEXT:    ldr x9, [x0, w1, sxtw #3]
; CHECK-NOLSE-O1-NEXT:    ldur x10, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    add x11, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    ldr x11, [x11]
; CHECK-NOLSE-O1-NEXT:    add x8, x8, x9
; CHECK-NOLSE-O1-NEXT:    add x8, x8, x10
; CHECK-NOLSE-O1-NEXT:    add x0, x8, x11
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_load_relaxed_64:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    ldr x8, [x0, #32760]
; CHECK-NOLSE-O0-NEXT:    ldr x9, [x0, w1, sxtw #3]
; CHECK-NOLSE-O0-NEXT:    add x8, x8, x9
; CHECK-NOLSE-O0-NEXT:    ldur x9, [x0, #-256]
; CHECK-NOLSE-O0-NEXT:    add x8, x8, x9
; CHECK-NOLSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    ldr x9, [x9]
; CHECK-NOLSE-O0-NEXT:    add x0, x8, x9
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_load_relaxed_64:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    ldr x8, [x0, #32760]
; CHECK-LSE-O1-NEXT:    ldr x9, [x0, w1, sxtw #3]
; CHECK-LSE-O1-NEXT:    add x8, x8, x9
; CHECK-LSE-O1-NEXT:    ldur x9, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add x8, x8, x9
; CHECK-LSE-O1-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    ldr x9, [x9]
; CHECK-LSE-O1-NEXT:    add x0, x8, x9
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_load_relaxed_64:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    ldr x8, [x0, #32760]
; CHECK-LSE-O0-NEXT:    ldr x9, [x0, w1, sxtw #3]
; CHECK-LSE-O0-NEXT:    add x8, x8, x9
; CHECK-LSE-O0-NEXT:    ldur x9, [x0, #-256]
; CHECK-LSE-O0-NEXT:    add x8, x8, x9
; CHECK-LSE-O0-NEXT:    add x9, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    ldr x9, [x9]
; CHECK-LSE-O0-NEXT:    add x0, x8, x9
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i64, i64* %p, i32 4095
  %val_unsigned = load atomic i64, i64* %ptr_unsigned monotonic, align 8

  %ptr_regoff = getelementptr i64, i64* %p, i32 %off32
  %val_regoff = load atomic i64, i64* %ptr_regoff unordered, align 8
  %tot1 = add i64 %val_unsigned, %val_regoff

  %ptr_unscaled = getelementptr i64, i64* %p, i32 -32
  %val_unscaled = load atomic i64, i64* %ptr_unscaled monotonic, align 8
  %tot2 = add i64 %tot1, %val_unscaled

  %ptr_random = getelementptr i64, i64* %p, i32 148992 ; 0x123000/8 (i.e. ADD imm)
  %val_random = load atomic i64, i64* %ptr_random unordered, align 8
  %tot3 = add i64 %tot2, %val_random

  ret i64 %tot3
}


define void @atomc_store(i32* %p) #0 {
; CHECK-NOLSE-LABEL: atomc_store:
; CHECK-NOLSE:       ; %bb.0:
; CHECK-NOLSE-NEXT:    mov w8, #4
; CHECK-NOLSE-NEXT:    stlr w8, [x0]
; CHECK-NOLSE-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomc_store:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    mov w8, #4
; CHECK-LSE-O1-NEXT:    stlr w8, [x0]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomc_store:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    mov w8, #4
; CHECK-LSE-O0-NEXT:    stlr w8, [x0]
; CHECK-LSE-O0-NEXT:    ret
   store atomic i32 4, i32* %p seq_cst, align 4
   ret void
}

define void @atomic_store_relaxed_8(i8* %p, i32 %off32, i8 %val) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_store_relaxed_8:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    add x8, x0, w1, sxtw
; CHECK-NOLSE-O1-NEXT:    sub x9, x0, #256 ; =256
; CHECK-NOLSE-O1-NEXT:    add x10, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    strb w2, [x0, #4095]
; CHECK-NOLSE-O1-NEXT:    strb w2, [x8]
; CHECK-NOLSE-O1-NEXT:    strb w2, [x9]
; CHECK-NOLSE-O1-NEXT:    strb w2, [x10]
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_store_relaxed_8:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    strb w2, [x0, #4095]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, w1, sxtw
; CHECK-NOLSE-O0-NEXT:    strb w2, [x8]
; CHECK-NOLSE-O0-NEXT:    subs x8, x0, #256 ; =256
; CHECK-NOLSE-O0-NEXT:    strb w2, [x8]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    strb w2, [x8]
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_store_relaxed_8:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    strb w2, [x0, #4095]
; CHECK-LSE-O1-NEXT:    add x8, x0, w1, sxtw
; CHECK-LSE-O1-NEXT:    strb w2, [x8]
; CHECK-LSE-O1-NEXT:    sub x8, x0, #256 ; =256
; CHECK-LSE-O1-NEXT:    strb w2, [x8]
; CHECK-LSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    strb w2, [x8]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_store_relaxed_8:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    strb w2, [x0, #4095]
; CHECK-LSE-O0-NEXT:    add x8, x0, w1, sxtw
; CHECK-LSE-O0-NEXT:    strb w2, [x8]
; CHECK-LSE-O0-NEXT:    subs x8, x0, #256 ; =256
; CHECK-LSE-O0-NEXT:    strb w2, [x8]
; CHECK-LSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    strb w2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i8, i8* %p, i32 4095
  store atomic i8 %val, i8* %ptr_unsigned monotonic, align 1

  %ptr_regoff = getelementptr i8, i8* %p, i32 %off32
  store atomic i8 %val, i8* %ptr_regoff unordered, align 1

  %ptr_unscaled = getelementptr i8, i8* %p, i32 -256
  store atomic i8 %val, i8* %ptr_unscaled monotonic, align 1

  %ptr_random = getelementptr i8, i8* %p, i32 1191936 ; 0x123000 (i.e. ADD imm)
  store atomic i8 %val, i8* %ptr_random unordered, align 1

  ret void
}

define void @atomic_store_relaxed_16(i16* %p, i32 %off32, i16 %val) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_store_relaxed_16:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-NOLSE-O1-NEXT:    sub x9, x0, #256 ; =256
; CHECK-NOLSE-O1-NEXT:    add x10, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    strh w2, [x0, #8190]
; CHECK-NOLSE-O1-NEXT:    strh w2, [x8]
; CHECK-NOLSE-O1-NEXT:    strh w2, [x9]
; CHECK-NOLSE-O1-NEXT:    strh w2, [x10]
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_store_relaxed_16:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    strh w2, [x0, #8190]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-NOLSE-O0-NEXT:    strh w2, [x8]
; CHECK-NOLSE-O0-NEXT:    subs x8, x0, #256 ; =256
; CHECK-NOLSE-O0-NEXT:    strh w2, [x8]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    strh w2, [x8]
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_store_relaxed_16:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    strh w2, [x0, #8190]
; CHECK-LSE-O1-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-LSE-O1-NEXT:    strh w2, [x8]
; CHECK-LSE-O1-NEXT:    sub x8, x0, #256 ; =256
; CHECK-LSE-O1-NEXT:    strh w2, [x8]
; CHECK-LSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    strh w2, [x8]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_store_relaxed_16:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    strh w2, [x0, #8190]
; CHECK-LSE-O0-NEXT:    add x8, x0, w1, sxtw #1
; CHECK-LSE-O0-NEXT:    strh w2, [x8]
; CHECK-LSE-O0-NEXT:    subs x8, x0, #256 ; =256
; CHECK-LSE-O0-NEXT:    strh w2, [x8]
; CHECK-LSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    strh w2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i16, i16* %p, i32 4095
  store atomic i16 %val, i16* %ptr_unsigned monotonic, align 2

  %ptr_regoff = getelementptr i16, i16* %p, i32 %off32
  store atomic i16 %val, i16* %ptr_regoff unordered, align 2

  %ptr_unscaled = getelementptr i16, i16* %p, i32 -128
  store atomic i16 %val, i16* %ptr_unscaled monotonic, align 2

  %ptr_random = getelementptr i16, i16* %p, i32 595968 ; 0x123000/2 (i.e. ADD imm)
  store atomic i16 %val, i16* %ptr_random unordered, align 2

  ret void
}

define void @atomic_store_relaxed_32(i32* %p, i32 %off32, i32 %val) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_store_relaxed_32:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    str w2, [x0, #16380]
; CHECK-NOLSE-O1-NEXT:    str w2, [x0, w1, sxtw #2]
; CHECK-NOLSE-O1-NEXT:    stur w2, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    str w2, [x8]
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_store_relaxed_32:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    str w2, [x0, #16380]
; CHECK-NOLSE-O0-NEXT:    str w2, [x0, w1, sxtw #2]
; CHECK-NOLSE-O0-NEXT:    stur w2, [x0, #-256]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    str w2, [x8]
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_store_relaxed_32:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    str w2, [x0, #16380]
; CHECK-LSE-O1-NEXT:    str w2, [x0, w1, sxtw #2]
; CHECK-LSE-O1-NEXT:    stur w2, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    str w2, [x8]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_store_relaxed_32:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    str w2, [x0, #16380]
; CHECK-LSE-O0-NEXT:    str w2, [x0, w1, sxtw #2]
; CHECK-LSE-O0-NEXT:    stur w2, [x0, #-256]
; CHECK-LSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    str w2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i32, i32* %p, i32 4095
  store atomic i32 %val, i32* %ptr_unsigned monotonic, align 4

  %ptr_regoff = getelementptr i32, i32* %p, i32 %off32
  store atomic i32 %val, i32* %ptr_regoff unordered, align 4

  %ptr_unscaled = getelementptr i32, i32* %p, i32 -64
  store atomic i32 %val, i32* %ptr_unscaled monotonic, align 4

  %ptr_random = getelementptr i32, i32* %p, i32 297984 ; 0x123000/4 (i.e. ADD imm)
  store atomic i32 %val, i32* %ptr_random unordered, align 4

  ret void
}

define void @atomic_store_relaxed_64(i64* %p, i32 %off32, i64 %val) #0 {
; CHECK-NOLSE-O1-LABEL: atomic_store_relaxed_64:
; CHECK-NOLSE-O1:       ; %bb.0:
; CHECK-NOLSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O1-NEXT:    str x2, [x0, #32760]
; CHECK-NOLSE-O1-NEXT:    str x2, [x0, w1, sxtw #3]
; CHECK-NOLSE-O1-NEXT:    stur x2, [x0, #-256]
; CHECK-NOLSE-O1-NEXT:    str x2, [x8]
; CHECK-NOLSE-O1-NEXT:    ret
;
; CHECK-NOLSE-O0-LABEL: atomic_store_relaxed_64:
; CHECK-NOLSE-O0:       ; %bb.0:
; CHECK-NOLSE-O0-NEXT:    str x2, [x0, #32760]
; CHECK-NOLSE-O0-NEXT:    str x2, [x0, w1, sxtw #3]
; CHECK-NOLSE-O0-NEXT:    stur x2, [x0, #-256]
; CHECK-NOLSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-NOLSE-O0-NEXT:    str x2, [x8]
; CHECK-NOLSE-O0-NEXT:    ret
;
; CHECK-LSE-O1-LABEL: atomic_store_relaxed_64:
; CHECK-LSE-O1:       ; %bb.0:
; CHECK-LSE-O1-NEXT:    str x2, [x0, #32760]
; CHECK-LSE-O1-NEXT:    str x2, [x0, w1, sxtw #3]
; CHECK-LSE-O1-NEXT:    stur x2, [x0, #-256]
; CHECK-LSE-O1-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O1-NEXT:    str x2, [x8]
; CHECK-LSE-O1-NEXT:    ret
;
; CHECK-LSE-O0-LABEL: atomic_store_relaxed_64:
; CHECK-LSE-O0:       ; %bb.0:
; CHECK-LSE-O0-NEXT:    str x2, [x0, #32760]
; CHECK-LSE-O0-NEXT:    str x2, [x0, w1, sxtw #3]
; CHECK-LSE-O0-NEXT:    stur x2, [x0, #-256]
; CHECK-LSE-O0-NEXT:    add x8, x0, #291, lsl #12 ; =1191936
; CHECK-LSE-O0-NEXT:    str x2, [x8]
; CHECK-LSE-O0-NEXT:    ret
  %ptr_unsigned = getelementptr i64, i64* %p, i32 4095
  store atomic i64 %val, i64* %ptr_unsigned monotonic, align 8

  %ptr_regoff = getelementptr i64, i64* %p, i32 %off32
  store atomic i64 %val, i64* %ptr_regoff unordered, align 8

  %ptr_unscaled = getelementptr i64, i64* %p, i32 -32
  store atomic i64 %val, i64* %ptr_unscaled monotonic, align 8

  %ptr_random = getelementptr i64, i64* %p, i32 148992 ; 0x123000/8 (i.e. ADD imm)
  store atomic i64 %val, i64* %ptr_random unordered, align 8

  ret void
}

attributes #0 = { nounwind }
