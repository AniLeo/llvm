; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define void @ld1b(<vscale x 16 x i1> %pg, ptr %ptr, i32 %sliceidx) {
; CHECK-LABEL: ld1b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    ld1b {za0h.b[w12, 15]}, p0/z, [x0]
; CHECK-NEXT:    ld1b {za0v.b[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 15
  call void @llvm.aarch64.sme.ld1b.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1b.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  ret void;
}

define void @ld1b_with_addr_offset(<vscale x 16 x i1> %pg, ptr %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: ld1b_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    mov w13, w2
; CHECK-NEXT:    ld1b {za0h.b[w12, 0]}, p0/z, [x0, x1]
; CHECK-NEXT:    ld1b {za0v.b[w13, 15]}, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 15
  call void @llvm.aarch64.sme.ld1b.horiz(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1b.vert(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 %tileslice)
  ret void;
}

define void @ld1h(<vscale x 16 x i1> %pg, ptr %ptr, i32 %sliceidx) {
; CHECK-LABEL: ld1h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    ld1h {za0h.h[w12, 7]}, p0/z, [x0]
; CHECK-NEXT:    ld1h {za1h.h[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1h {za0v.h[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1h {za1v.h[w12, 7]}, p0/z, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 7
  call void @llvm.aarch64.sme.ld1h.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1h.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1h.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1h.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 %tileslice)
  ret void;
}

define void @ld1h_with_addr_offset(<vscale x 16 x i1> %pg, ptr %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: ld1h_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w2
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    ld1h {za0h.h[w12, 7]}, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ld1h {za1v.h[w13, 0]}, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 7
  call void @llvm.aarch64.sme.ld1h.horiz(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1h.vert(<vscale x 16 x i1> %pg, ptr %base, i64 1, i32 0)
  ret void;
}

define void @ld1w(<vscale x 16 x i1> %pg, ptr %ptr, i32 %sliceidx) {
; CHECK-LABEL: ld1w:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    mov w13, w1
; CHECK-NEXT:    ld1w {za0h.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za1h.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za2h.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za3h.s[w13, 3]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za0v.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za1v.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za2v.s[w13, 3]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za3v.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 3
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 0)
  ret void;
}

define void @ld1w_with_addr_offset(<vscale x 16 x i1> %pg, ptr %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: ld1w_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w2
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    ld1w {za0h.s[w13, 0]}, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT:    ld1w {za3v.s[w12, 3]}, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT:    ret
  %base = getelementptr i32, ptr %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 3
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1> %pg, ptr %base, i64 3, i32 %tileslice)
  ret void;
}

define void @ld1d(<vscale x 16 x i1> %pg, ptr %ptr, i32 %sliceidx) {
; CHECK-LABEL: ld1d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    ld1d {za0h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za1h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za2h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za3h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za4h.d[w12, 1]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za5h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za6h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za7h.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za0v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za1v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za2v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za3v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za4v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za5v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za6v.d[w13, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1d {za7v.d[w12, 1]}, p0/z, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 1
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 4, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 7, i32 %tileslice)
  ret void;
}

define void @ld1d_with_addr_offset(<vscale x 16 x i1> %pg, ptr %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: ld1d_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w2
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    ld1d {za0h.d[w12, 1]}, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT:    ld1d {za7v.d[w13, 0]}, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT:    ret
  %base = getelementptr i64, ptr %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 1
  call void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1> %pg, ptr %base, i64 7, i32 0)
  ret void;
}

define void @ld1q(<vscale x 16 x i1> %pg, ptr %ptr) {
; CHECK-LABEL: ld1q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    ld1q {za0h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za1h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za2h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za3h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za4h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za5h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za6h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za7h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za8h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za9h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za10h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za11h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za12h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za13h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za14h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za15h.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za0v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za1v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za2v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za3v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za4v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za5v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za6v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za7v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za8v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za9v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za10v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za11v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za12v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za13v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za14v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ld1q {za15v.q[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 8, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 9, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 10, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 11, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 12, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 13, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 14, i32 0)
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %ptr, i64 15, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 8, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 9, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 10, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 11, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 12, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 13, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 14, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %ptr, i64 15, i32 0)
  ret void;
}

define void @ld1q_with_addr_offset(<vscale x 16 x i1> %pg, ptr %ptr, i64 %index) {
; CHECK-LABEL: ld1q_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    ld1q {za0h.q[w12, 0]}, p0/z, [x0, x1, lsl #4]
; CHECK-NEXT:    ld1q {za15v.q[w12, 0]}, p0/z, [x0, x1, lsl #4]
; CHECK-NEXT:    ret
  %base = getelementptr i128, ptr %ptr, i64 %index
  call void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1> %pg, ptr %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1> %pg, ptr %base, i64 15, i32 0)
  ret void;
}

define void @ldr(ptr %ptr) {
; CHECK-LABEL: ldr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    ldr za[w12, 0], [x0]
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.ldr(i32 0, ptr %ptr)
  ret void;
}

define void @ldr_with_off_15(ptr %ptr) {
; CHECK-LABEL: ldr_with_off_15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    add x8, x0, #15
; CHECK-NEXT:    ldr za[w12, 0], [x8]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %ptr, i64 15
  call void @llvm.aarch64.sme.ldr(i32 0, ptr %base)
  ret void;
}

define void @ldr_with_off_15mulvl(ptr %ptr) {
; CHECK-LABEL: ldr_with_off_15mulvl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    ldr za[w12, 15], [x0, #15, mul vl]
; CHECK-NEXT:    ret
  %vscale = call i64 @llvm.vscale.i64()
  %mulvl = mul i64 %vscale, 240
  %base = getelementptr i8, ptr %ptr, i64 %mulvl
  call void @llvm.aarch64.sme.ldr(i32 0, ptr %base)
  ret void;
}

define void @ldr_with_off_16mulvl(ptr %ptr) {
; CHECK-LABEL: ldr_with_off_16mulvl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    addvl x8, x0, #16
; CHECK-NEXT:    ldr za[w12, 0], [x8]
; CHECK-NEXT:    ret
  %vscale = call i64 @llvm.vscale.i64()
  %mulvl = mul i64 %vscale, 256
  %base = getelementptr i8, ptr %ptr, i64 %mulvl
  call void @llvm.aarch64.sme.ldr(i32 0, ptr %base)
  ret void;
}

; Ensure that the tile offset is sunk, given that this is likely to be an 'add'
; that's decomposed into a base + offset in ISel.
define void @test_ld1_sink_tile0_offset_operand(<vscale x 16 x i1> %pg, ptr %src, i32 %base, i32 %N) {
; CHECK-LABEL: test_ld1_sink_tile0_offset_operand:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:  .LBB14_1: // %for.body
; CHECK-NEXT:    // =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    ld1w {za0h.s[w12, 0]}, p0/z, [x0]
; CHECK-NEXT:    subs w2, w2, #1
; CHECK-NEXT:    ld1w {za0h.s[w12, 1]}, p0/z, [x0]
; CHECK-NEXT:    ld1w {za0h.s[w12, 2]}, p0/z, [x0]
; CHECK-NEXT:    b.ne .LBB14_1
; CHECK-NEXT:  // %bb.2: // %exit
; CHECK-NEXT:    ret
entry:
  %add1 = add i32 %base, 1
  %add2 = add i32 %base, 2
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %src, i64 0, i32 %base)
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %src, i64 0, i32 %add1)
  call void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1> %pg, ptr %src, i64 0, i32 %add2)
  %inc = add nuw nsw i32 %i, 1
  %exitcond.not = icmp eq i32 %inc, %N
  br i1 %exitcond.not, label %exit, label %for.body

exit:
  ret void
}


declare void @llvm.aarch64.sme.ld1b.horiz(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1h.horiz(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1w.horiz(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1d.horiz(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1q.horiz(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1b.vert(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1h.vert(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1w.vert(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1d.vert(<vscale x 16 x i1>, ptr, i64, i32)
declare void @llvm.aarch64.sme.ld1q.vert(<vscale x 16 x i1>, ptr, i64, i32)

declare void @llvm.aarch64.sme.ldr(i32, ptr)
declare i64 @llvm.vscale.i64()
