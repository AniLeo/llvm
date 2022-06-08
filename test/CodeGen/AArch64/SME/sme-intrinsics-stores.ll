; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme -verify-machineinstrs < %s | FileCheck %s

define void @st1b(<vscale x 16 x i1> %pg, i8* %ptr, i32 %sliceidx) {
; CHECK-LABEL: st1b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    st1b {za0h.b[w12, 15]}, p0, [x0]
; CHECK-NEXT:    st1b {za0v.b[w13, 0]}, p0, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 15
  call void @llvm.aarch64.sme.st1b.horiz(<vscale x 16 x i1> %pg, i8* %ptr, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.st1b.vert(<vscale x 16 x i1> %pg, i8* %ptr, i64 0, i32 0)
  ret void;
}

define void @st1b_with_addr_offset(<vscale x 16 x i1> %pg, i8* %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: st1b_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    mov w13, w2
; CHECK-NEXT:    st1b {za0h.b[w12, 0]}, p0, [x0, x1]
; CHECK-NEXT:    st1b {za0v.b[w13, 15]}, p0, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, i8* %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 15
  call void @llvm.aarch64.sme.st1b.horiz(<vscale x 16 x i1> %pg, i8* %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1b.vert(<vscale x 16 x i1> %pg, i8* %base, i64 0, i32 %tileslice)
  ret void;
}

define void @st1h(<vscale x 16 x i1> %pg, i16* %ptr, i32 %sliceidx) {
; CHECK-LABEL: st1h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    st1h {za0h.h[w12, 7]}, p0, [x0]
; CHECK-NEXT:    st1h {za1h.h[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1h {za0v.h[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1h {za1v.h[w12, 7]}, p0, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 7
  call void @llvm.aarch64.sme.st1h.horiz(<vscale x 16 x i1> %pg, i16* %ptr, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.st1h.horiz(<vscale x 16 x i1> %pg, i16* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1h.vert(<vscale x 16 x i1> %pg, i16* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1h.vert(<vscale x 16 x i1> %pg, i16* %ptr, i64 1, i32 %tileslice)
  ret void;
}

define void @st1h_with_addr_offset(<vscale x 16 x i1> %pg, i16* %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: st1h_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w2
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    st1h {za0h.h[w12, 7]}, p0, [x0, x1, lsl #1]
; CHECK-NEXT:    st1h {za1v.h[w13, 0]}, p0, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, i16* %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 7
  call void @llvm.aarch64.sme.st1h.horiz(<vscale x 16 x i1> %pg, i16* %base, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.st1h.vert(<vscale x 16 x i1> %pg, i16* %base, i64 1, i32 0)
  ret void;
}

define void @st1w(<vscale x 16 x i1> %pg, i32* %ptr, i32 %sliceidx) {
; CHECK-LABEL: st1w:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    st1w {za0h.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1w {za1h.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1w {za2h.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1w {za3h.s[w12, 3]}, p0, [x0]
; CHECK-NEXT:    st1w {za0v.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1w {za1v.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1w {za2v.s[w12, 3]}, p0, [x0]
; CHECK-NEXT:    st1w {za3v.s[w13, 0]}, p0, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 3
  call void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1> %pg, i32* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1> %pg, i32* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1> %pg, i32* %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1> %pg, i32* %ptr, i64 3, i32 %tileslice)
  call void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1> %pg, i32* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1> %pg, i32* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1> %pg, i32* %ptr, i64 2, i32 %tileslice)
  call void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1> %pg, i32* %ptr, i64 3, i32 0)
  ret void;
}

define void @st1w_with_addr_offset(<vscale x 16 x i1> %pg, i32* %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: st1w_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    mov w13, w2
; CHECK-NEXT:    st1w {za0h.s[w12, 0]}, p0, [x0, x1, lsl #2]
; CHECK-NEXT:    st1w {za3v.s[w13, 3]}, p0, [x0, x1, lsl #2]
; CHECK-NEXT:    ret
  %base = getelementptr i32, i32* %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 3
  call void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1> %pg, i32* %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1> %pg, i32* %base, i64 3, i32 %tileslice)
  ret void;
}

define void @st1d(<vscale x 16 x i1> %pg, i64* %ptr, i32 %sliceidx) {
; CHECK-LABEL: st1d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    mov w12, w1
; CHECK-NEXT:    st1d {za0h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za1h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za2h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za3h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za4h.d[w12, 1]}, p0, [x0]
; CHECK-NEXT:    st1d {za5h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za6h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za7h.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za0v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za1v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za2v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za3v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za4v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za5v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za6v.d[w13, 0]}, p0, [x0]
; CHECK-NEXT:    st1d {za7v.d[w12, 1]}, p0, [x0]
; CHECK-NEXT:    ret
  %tileslice = add i32 %sliceidx, 1
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 4, i32 %tileslice)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %ptr, i64 7, i32 %tileslice)
  ret void;
}

define void @st1d_with_addr_offset(<vscale x 16 x i1> %pg, i64* %ptr, i64 %index, i32 %sliceidx) {
; CHECK-LABEL: st1d_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, w2
; CHECK-NEXT:    mov w13, wzr
; CHECK-NEXT:    st1d {za0h.d[w12, 1]}, p0, [x0, x1, lsl #3]
; CHECK-NEXT:    st1d {za7v.d[w13, 0]}, p0, [x0, x1, lsl #3]
; CHECK-NEXT:    ret
  %base = getelementptr i64, i64* %ptr, i64 %index
  %tileslice = add i32 %sliceidx, 1
  call void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1> %pg, i64* %base, i64 0, i32 %tileslice)
  call void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1> %pg, i64* %base, i64 7, i32 0)
  ret void;
}

define void @st1q(<vscale x 16 x i1> %pg, i128* %ptr) {
; CHECK-LABEL: st1q:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    st1q {za0h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za1h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za2h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za3h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za4h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za5h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za6h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za7h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za8h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za9h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za10h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za11h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za12h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za13h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za14h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za15h.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za0v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za1v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za2v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za3v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za4v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za5v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za6v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za7v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za8v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za9v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za10v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za11v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za12v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za13v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za14v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    st1q {za15v.q[w12, 0]}, p0, [x0]
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 8, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 9, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 10, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 11, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 12, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 13, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 14, i32 0)
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %ptr, i64 15, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 1, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 2, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 3, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 4, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 5, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 6, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 7, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 8, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 9, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 10, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 11, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 12, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 13, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 14, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %ptr, i64 15, i32 0)
  ret void;
}

define void @st1q_with_addr_offset(<vscale x 16 x i1> %pg, i128* %ptr, i64 %index) {
; CHECK-LABEL: st1q_with_addr_offset:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    st1q {za0h.q[w12, 0]}, p0, [x0, x1, lsl #4]
; CHECK-NEXT:    st1q {za15v.q[w12, 0]}, p0, [x0, x1, lsl #4]
; CHECK-NEXT:    ret
  %base = getelementptr i128, i128* %ptr, i64 %index
  call void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1> %pg, i128* %base, i64 0, i32 0)
  call void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1> %pg, i128* %base, i64 15, i32 0)
  ret void;
}

define void @str(i8* %ptr) {
; CHECK-LABEL: str:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    str za[w12, 0], [x0]
; CHECK-NEXT:    ret
  call void @llvm.aarch64.sme.str(i32 0, i8* %ptr)
  ret void;
}

define void @str_with_off_15(i8* %ptr) {
; CHECK-LABEL: str_with_off_15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    add x8, x0, #15
; CHECK-NEXT:    str za[w12, 0], [x8]
; CHECK-NEXT:    ret
  %base = getelementptr i8, i8* %ptr, i64 15
  call void @llvm.aarch64.sme.str(i32 0, i8* %base)
  ret void;
}

define void @str_with_off_15mulvl(i8* %ptr) {
; CHECK-LABEL: str_with_off_15mulvl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    str za[w12, 0], [x0, #15, mul vl]
; CHECK-NEXT:    ret
  %vscale = call i64 @llvm.vscale.i64()
  %mulvl = mul i64 %vscale, 240
  %base = getelementptr i8, i8* %ptr, i64 %mulvl
  call void @llvm.aarch64.sme.str(i32 0, i8* %base)
  ret void;
}

define void @str_with_off_16mulvl(i8* %ptr) {
; CHECK-LABEL: str_with_off_16mulvl:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w12, wzr
; CHECK-NEXT:    addvl x8, x0, #16
; CHECK-NEXT:    str za[w12, 0], [x8]
; CHECK-NEXT:    ret
  %vscale = call i64 @llvm.vscale.i64()
  %mulvl = mul i64 %vscale, 256
  %base = getelementptr i8, i8* %ptr, i64 %mulvl
  call void @llvm.aarch64.sme.str(i32 0, i8* %base)
  ret void;
}

declare void @llvm.aarch64.sme.st1b.horiz(<vscale x 16 x i1>, i8*, i64, i32)
declare void @llvm.aarch64.sme.st1h.horiz(<vscale x 16 x i1>, i16*, i64, i32)
declare void @llvm.aarch64.sme.st1w.horiz(<vscale x 16 x i1>, i32*, i64, i32)
declare void @llvm.aarch64.sme.st1d.horiz(<vscale x 16 x i1>, i64*, i64, i32)
declare void @llvm.aarch64.sme.st1q.horiz(<vscale x 16 x i1>, i128*, i64, i32)
declare void @llvm.aarch64.sme.st1b.vert(<vscale x 16 x i1>, i8*, i64, i32)
declare void @llvm.aarch64.sme.st1h.vert(<vscale x 16 x i1>, i16*, i64, i32)
declare void @llvm.aarch64.sme.st1w.vert(<vscale x 16 x i1>, i32*, i64, i32)
declare void @llvm.aarch64.sme.st1d.vert(<vscale x 16 x i1>, i64*, i64, i32)
declare void @llvm.aarch64.sme.st1q.vert(<vscale x 16 x i1>, i128*, i64, i32)

declare void @llvm.aarch64.sme.str(i32, i8*)
declare i64 @llvm.vscale.i64()
