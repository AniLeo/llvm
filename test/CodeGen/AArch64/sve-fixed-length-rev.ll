; RUN: llc -aarch64-sve-vector-bits-min=128  -asm-verbose=0 < %s | FileCheck %s -check-prefix=NO_SVE
; RUN: llc -aarch64-sve-vector-bits-min=256  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_EQ_256
; RUN: llc -aarch64-sve-vector-bits-min=384  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK
; RUN: llc -aarch64-sve-vector-bits-min=512  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=640  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=768  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=896  -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512
; RUN: llc -aarch64-sve-vector-bits-min=1024 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1152 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1280 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1408 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1536 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1664 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1792 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=1920 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024
; RUN: llc -aarch64-sve-vector-bits-min=2048 -asm-verbose=0 < %s | FileCheck %s -check-prefixes=CHECK,VBITS_GE_512,VBITS_GE_1024,VBITS_GE_2048

target triple = "aarch64-unknown-linux-gnu"

; Don't use SVE when its registers are no bigger than NEON.
; NO_SVE-NOT: ptrue

;
; RBIT
;

define <8 x i8> @bitreverse_v8i8(<8 x i8> %op) #0 {
; CHECK-LABEL: bitreverse_v8i8:
; CHECK: ptrue [[PG:p[0-9]+]].b, vl8
; CHECK-NEXT: rbit z0.b, [[PG]]/m, z0.b
; CHECK-NEXT: ret
  %res = call <8 x i8> @llvm.bitreverse.v8i8(<8 x i8> %op)
  ret <8 x i8> %res
}

define <16 x i8> @bitreverse_v16i8(<16 x i8> %op) #0 {
; CHECK-LABEL: bitreverse_v16i8:
; CHECK: ptrue [[PG:p[0-9]+]].b, vl16
; CHECK-NEXT: rbit z0.b, [[PG]]/m, z0.b
; CHECK-NEXT: ret
  %res = call <16 x i8> @llvm.bitreverse.v16i8(<16 x i8> %op)
  ret <16 x i8> %res
}

define void @bitreverse_v32i8(<32 x i8>* %a) #0 {
; CHECK-LABEL: bitreverse_v32i8:
; CHECK: ptrue [[PG:p[0-9]+]].b, vl32
; CHECK-NEXT: ld1b { [[OP:z[0-9]+]].b }, [[PG]]/z, [x0]
; CHECK-NEXT: rbit [[RES:z[0-9]+]].b, [[PG]]/m, [[OP]].b
; CHECK-NEXT: st1b { [[RES]].b }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <32 x i8>, <32 x i8>* %a
  %res = call <32 x i8> @llvm.bitreverse.v32i8(<32 x i8> %op)
  store <32 x i8> %res, <32 x i8>* %a
  ret void
}

define void @bitreverse_v64i8(<64 x i8>* %a) #0 {
; CHECK-LABEL: bitreverse_v64i8:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].b, vl64
; VBITS_GE_512-NEXT: ld1b { [[OP:z[0-9]+]].b }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: rbit [[RES:z[0-9]+]].b, [[PG]]/m, [[OP]].b
; VBITS_GE_512-NEXT: st1b { [[RES]].b }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret
;
; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].b, vl32
; VBITS_EQ_256-DAG: mov w[[A:[0-9]+]], #32
; VBITS_EQ_256-DAG: ld1b { [[OP_LO:z[0-9]+]].b }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1b { [[OP_HI:z[0-9]+]].b }, [[PG]]/z, [x0, x[[A]]]
; VBITS_EQ_256-DAG: rbit [[RES_LO:z[0-9]+]].b, [[PG]]/m, [[OP_LO]].b
; VBITS_EQ_256-DAG: rbit [[RES_HI:z[0-9]+]].b, [[PG]]/m, [[OP_HI]].b
; VBITS_EQ_256-DAG: st1b { [[RES_LO]].b }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1b { [[RES_HI]].b }, [[PG]], [x0, x[[A]]]
; VBITS_EQ_256-NEXT: ret
  %op = load <64 x i8>, <64 x i8>* %a
  %res = call <64 x i8> @llvm.bitreverse.v64i8(<64 x i8> %op)
  store <64 x i8> %res, <64 x i8>* %a
  ret void
}

define void @bitreverse_v128i8(<128 x i8>* %a) #0 {
; CHECK-LABEL: bitreverse_v128i8:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].b, vl128
; VBITS_GE_1024-NEXT: ld1b { [[OP:z[0-9]+]].b }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: rbit [[RES:z[0-9]+]].b, [[PG]]/m, [[OP]].b
; VBITS_GE_1024-NEXT: st1b { [[RES]].b }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <128 x i8>, <128 x i8>* %a
  %res = call <128 x i8> @llvm.bitreverse.v128i8(<128 x i8> %op)
  store <128 x i8> %res, <128 x i8>* %a
  ret void
}

define void @bitreverse_v256i8(<256 x i8>* %a) #0 {
; CHECK-LABEL: bitreverse_v256i8:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].b, vl256
; VBITS_GE_2048-NEXT: ld1b { [[OP:z[0-9]+]].b }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: rbit [[RES:z[0-9]+]].b, [[PG]]/m, [[OP]].b
; VBITS_GE_2048-NEXT: st1b { [[RES]].b }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <256 x i8>, <256 x i8>* %a
  %res = call <256 x i8> @llvm.bitreverse.v256i8(<256 x i8> %op)
  store <256 x i8> %res, <256 x i8>* %a
  ret void
}

define <4 x i16> @bitreverse_v4i16(<4 x i16> %op) #0 {
; CHECK-LABEL: bitreverse_v4i16:
; CHECK: ptrue [[PG:p[0-9]+]].h, vl4
; CHECK-NEXT: rbit z0.h, [[PG]]/m, z0.h
; CHECK-NEXT: ret
  %res = call <4 x i16> @llvm.bitreverse.v4i16(<4 x i16> %op)
  ret <4 x i16> %res
}

define <8 x i16> @bitreverse_v8i16(<8 x i16> %op) #0 {
; CHECK-LABEL: bitreverse_v8i16:
; CHECK: ptrue [[PG:p[0-9]+]].h, vl8
; CHECK-NEXT: rbit z0.h, [[PG]]/m, z0.h
; CHECK-NEXT: ret
  %res = call <8 x i16> @llvm.bitreverse.v8i16(<8 x i16> %op)
  ret <8 x i16> %res
}

define void @bitreverse_v16i16(<16 x i16>* %a) #0 {
; CHECK-LABEL: bitreverse_v16i16:
; CHECK: ptrue [[PG:p[0-9]+]].h, vl16
; CHECK-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; CHECK-NEXT: rbit [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; CHECK-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <16 x i16>, <16 x i16>* %a
  %res = call <16 x i16> @llvm.bitreverse.v16i16(<16 x i16> %op)
  store <16 x i16> %res, <16 x i16>* %a
  ret void
}

define void @bitreverse_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: bitreverse_v32i16:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].h, vl32
; VBITS_GE_512-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: rbit [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_512-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].h, vl16
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1h { [[OP_LO:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1h { [[OP_HI:z[0-9]+]].h }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: rbit [[RES_LO:z[0-9]+]].h, [[PG]]/m, [[OP_LO]].h
; VBITS_EQ_256-DAG: rbit [[RES_HI:z[0-9]+]].h, [[PG]]/m, [[OP_HI]].h
; VBITS_EQ_256-DAG: st1h { [[RES_LO]].h }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1h { [[RES_HI]].h }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <32 x i16>, <32 x i16>* %a
  %res = call <32 x i16> @llvm.bitreverse.v32i16(<32 x i16> %op)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @bitreverse_v64i16(<64 x i16>* %a) #0 {
; CHECK-LABEL: bitreverse_v64i16:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].h, vl64
; VBITS_GE_1024-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: rbit [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_1024-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <64 x i16>, <64 x i16>* %a
  %res = call <64 x i16> @llvm.bitreverse.v64i16(<64 x i16> %op)
  store <64 x i16> %res, <64 x i16>* %a
  ret void
}

define void @bitreverse_v128i16(<128 x i16>* %a) #0 {
; CHECK-LABEL: bitreverse_v128i16:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].h, vl128
; VBITS_GE_2048-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: rbit [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_2048-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <128 x i16>, <128 x i16>* %a
  %res = call <128 x i16> @llvm.bitreverse.v128i16(<128 x i16> %op)
  store <128 x i16> %res, <128 x i16>* %a
  ret void
}

define <2 x i32> @bitreverse_v2i32(<2 x i32> %op) #0 {
; CHECK-LABEL: bitreverse_v2i32:
; CHECK: ptrue [[PG:p[0-9]+]].s, vl2
; CHECK-NEXT: rbit z0.s, [[PG]]/m, z0.s
; CHECK-NEXT: ret
  %res = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %op)
  ret <2 x i32> %res
}

define <4 x i32> @bitreverse_v4i32(<4 x i32> %op) #0 {
; CHECK-LABEL: bitreverse_v4i32:
; CHECK: ptrue [[PG:p[0-9]+]].s, vl4
; CHECK-NEXT: rbit z0.s, [[PG]]/m, z0.s
; CHECK-NEXT: ret
  %res = call <4 x i32> @llvm.bitreverse.v4i32(<4 x i32> %op)
  ret <4 x i32> %res
}

define void @bitreverse_v8i32(<8 x i32>* %a) #0 {
; CHECK-LABEL: bitreverse_v8i32:
; CHECK: ptrue [[PG:p[0-9]+]].s, vl8
; CHECK-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; CHECK-NEXT: rbit [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; CHECK-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <8 x i32>, <8 x i32>* %a
  %res = call <8 x i32> @llvm.bitreverse.v8i32(<8 x i32> %op)
  store <8 x i32> %res, <8 x i32>* %a
  ret void
}

define void @bitreverse_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: bitreverse_v16i32:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].s, vl16
; VBITS_GE_512-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: rbit [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_512-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].s, vl8
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1w { [[OP_LO:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1w { [[OP_HI:z[0-9]+]].s }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: rbit [[RES_LO:z[0-9]+]].s, [[PG]]/m, [[OP_LO]].s
; VBITS_EQ_256-DAG: rbit [[RES_HI:z[0-9]+]].s, [[PG]]/m, [[OP_HI]].s
; VBITS_EQ_256-DAG: st1w { [[RES_LO]].s }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1w { [[RES_HI]].s }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <16 x i32>, <16 x i32>* %a
  %res = call <16 x i32> @llvm.bitreverse.v16i32(<16 x i32> %op)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @bitreverse_v32i32(<32 x i32>* %a) #0 {
; CHECK-LABEL: bitreverse_v32i32:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].s, vl32
; VBITS_GE_1024-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: rbit [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_1024-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <32 x i32>, <32 x i32>* %a
  %res = call <32 x i32> @llvm.bitreverse.v32i32(<32 x i32> %op)
  store <32 x i32> %res, <32 x i32>* %a
  ret void
}

define void @bitreverse_v64i32(<64 x i32>* %a) #0 {
; CHECK-LABEL: bitreverse_v64i32:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].s, vl64
; VBITS_GE_2048-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: rbit [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_2048-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <64 x i32>, <64 x i32>* %a
  %res = call <64 x i32> @llvm.bitreverse.v64i32(<64 x i32> %op)
  store <64 x i32> %res, <64 x i32>* %a
  ret void
}

define <1 x i64> @bitreverse_v1i64(<1 x i64> %op) #0 {
; CHECK-LABEL: bitreverse_v1i64:
; CHECK: ptrue [[PG:p[0-9]+]].d, vl1
; CHECK-NEXT: rbit z0.d, [[PG]]/m, z0.d
; CHECK-NEXT: ret
  %res = call <1 x i64> @llvm.bitreverse.v1i64(<1 x i64> %op)
  ret <1 x i64> %res
}

define <2 x i64> @bitreverse_v2i64(<2 x i64> %op) #0 {
; CHECK-LABEL: bitreverse_v2i64:
; CHECK: ptrue [[PG:p[0-9]+]].d, vl2
; CHECK-NEXT: rbit z0.d, [[PG]]/m, z0.d
; CHECK-NEXT: ret
  %res = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %op)
  ret <2 x i64> %res
}

define void @bitreverse_v4i64(<4 x i64>* %a) #0 {
; CHECK-LABEL: bitreverse_v4i64:
; CHECK: ptrue [[PG:p[0-9]+]].d, vl4
; CHECK-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; CHECK-NEXT: rbit [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; CHECK-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <4 x i64>, <4 x i64>* %a
  %res = call <4 x i64> @llvm.bitreverse.v4i64(<4 x i64> %op)
  store <4 x i64> %res, <4 x i64>* %a
  ret void
}

define void @bitreverse_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: bitreverse_v8i64:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].d, vl8
; VBITS_GE_512-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: rbit [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_512-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].d, vl4
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1d { [[OP_LO:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1d { [[OP_HI:z[0-9]+]].d }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: rbit [[RES_LO:z[0-9]+]].d, [[PG]]/m, [[OP_LO]].d
; VBITS_EQ_256-DAG: rbit [[RES_HI:z[0-9]+]].d, [[PG]]/m, [[OP_HI]].d
; VBITS_EQ_256-DAG: st1d { [[RES_LO]].d }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1d { [[RES_HI]].d }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <8 x i64>, <8 x i64>* %a
  %res = call <8 x i64> @llvm.bitreverse.v8i64(<8 x i64> %op)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

define void @bitreverse_v16i64(<16 x i64>* %a) #0 {
; CHECK-LABEL: bitreverse_v16i64:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].d, vl16
; VBITS_GE_1024-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: rbit [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_1024-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <16 x i64>, <16 x i64>* %a
  %res = call <16 x i64> @llvm.bitreverse.v16i64(<16 x i64> %op)
  store <16 x i64> %res, <16 x i64>* %a
  ret void
}

define void @bitreverse_v32i64(<32 x i64>* %a) #0 {
; CHECK-LABEL: bitreverse_v32i64:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].d, vl32
; VBITS_GE_2048-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: rbit [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_2048-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <32 x i64>, <32 x i64>* %a
  %res = call <32 x i64> @llvm.bitreverse.v32i64(<32 x i64> %op)
  store <32 x i64> %res, <32 x i64>* %a
  ret void
}

;
; REVB
;

; Don't use SVE for 64-bit vectors.
define <4 x i16> @bswap_v4i16(<4 x i16> %op) #0 {
; CHECK-LABEL: bswap_v4i16:
; CHECK: rev16 v0.8b, v0.8b
; CHECK-NEXT: ret
  %res = call <4 x i16> @llvm.bswap.v4i16(<4 x i16> %op)
  ret <4 x i16> %res
}

; Don't use SVE for 128-bit vectors.
define <8 x i16> @bswap_v8i16(<8 x i16> %op) #0 {
; CHECK-LABEL: bswap_v8i16:
; CHECK: rev16 v0.16b, v0.16b
; CHECK-NEXT: ret
  %res = call <8 x i16> @llvm.bswap.v8i16(<8 x i16> %op)
  ret <8 x i16> %res
}

define void @bswap_v16i16(<16 x i16>* %a) #0 {
; CHECK-LABEL: bswap_v16i16:
; CHECK: ptrue [[PG:p[0-9]+]].h, vl16
; CHECK-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; CHECK-NEXT: revb [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; CHECK-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <16 x i16>, <16 x i16>* %a
  %res = call <16 x i16> @llvm.bswap.v16i16(<16 x i16> %op)
  store <16 x i16> %res, <16 x i16>* %a
  ret void
}

define void @bswap_v32i16(<32 x i16>* %a) #0 {
; CHECK-LABEL: bswap_v32i16:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].h, vl32
; VBITS_GE_512-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: revb [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_512-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].h, vl16
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1h { [[OP_LO:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1h { [[OP_HI:z[0-9]+]].h }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: revb [[RES_LO:z[0-9]+]].h, [[PG]]/m, [[OP_LO]].h
; VBITS_EQ_256-DAG: revb [[RES_HI:z[0-9]+]].h, [[PG]]/m, [[OP_HI]].h
; VBITS_EQ_256-DAG: st1h { [[RES_LO]].h }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1h { [[RES_HI]].h }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <32 x i16>, <32 x i16>* %a
  %res = call <32 x i16> @llvm.bswap.v32i16(<32 x i16> %op)
  store <32 x i16> %res, <32 x i16>* %a
  ret void
}

define void @bswap_v64i16(<64 x i16>* %a) #0 {
; CHECK-LABEL: bswap_v64i16:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].h, vl64
; VBITS_GE_1024-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: revb [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_1024-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <64 x i16>, <64 x i16>* %a
  %res = call <64 x i16> @llvm.bswap.v64i16(<64 x i16> %op)
  store <64 x i16> %res, <64 x i16>* %a
  ret void
}

define void @bswap_v128i16(<128 x i16>* %a) #0 {
; CHECK-LABEL: bswap_v128i16:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].h, vl128
; VBITS_GE_2048-NEXT: ld1h { [[OP:z[0-9]+]].h }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: revb [[RES:z[0-9]+]].h, [[PG]]/m, [[OP]].h
; VBITS_GE_2048-NEXT: st1h { [[RES]].h }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <128 x i16>, <128 x i16>* %a
  %res = call <128 x i16> @llvm.bswap.v128i16(<128 x i16> %op)
  store <128 x i16> %res, <128 x i16>* %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <2 x i32> @bswap_v2i32(<2 x i32> %op) #0 {
; CHECK-LABEL: bswap_v2i32:
; CHECK: rev32 v0.8b, v0.8b
; CHECK-NEXT: ret
  %res = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %op)
  ret <2 x i32> %res
}

; Don't use SVE for 128-bit vectors.
define <4 x i32> @bswap_v4i32(<4 x i32> %op) #0 {
; CHECK-LABEL: bswap_v4i32:
; CHECK: rev32 v0.16b, v0.16b
; CHECK-NEXT: ret
  %res = call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %op)
  ret <4 x i32> %res
}

define void @bswap_v8i32(<8 x i32>* %a) #0 {
; CHECK-LABEL: bswap_v8i32:
; CHECK: ptrue [[PG:p[0-9]+]].s, vl8
; CHECK-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; CHECK-NEXT: revb [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; CHECK-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <8 x i32>, <8 x i32>* %a
  %res = call <8 x i32> @llvm.bswap.v8i32(<8 x i32> %op)
  store <8 x i32> %res, <8 x i32>* %a
  ret void
}

define void @bswap_v16i32(<16 x i32>* %a) #0 {
; CHECK-LABEL: bswap_v16i32:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].s, vl16
; VBITS_GE_512-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: revb [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_512-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].s, vl8
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1w { [[OP_LO:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1w { [[OP_HI:z[0-9]+]].s }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: revb [[RES_LO:z[0-9]+]].s, [[PG]]/m, [[OP_LO]].s
; VBITS_EQ_256-DAG: revb [[RES_HI:z[0-9]+]].s, [[PG]]/m, [[OP_HI]].s
; VBITS_EQ_256-DAG: st1w { [[RES_LO]].s }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1w { [[RES_HI]].s }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <16 x i32>, <16 x i32>* %a
  %res = call <16 x i32> @llvm.bswap.v16i32(<16 x i32> %op)
  store <16 x i32> %res, <16 x i32>* %a
  ret void
}

define void @bswap_v32i32(<32 x i32>* %a) #0 {
; CHECK-LABEL: bswap_v32i32:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].s, vl32
; VBITS_GE_1024-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: revb [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_1024-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <32 x i32>, <32 x i32>* %a
  %res = call <32 x i32> @llvm.bswap.v32i32(<32 x i32> %op)
  store <32 x i32> %res, <32 x i32>* %a
  ret void
}

define void @bswap_v64i32(<64 x i32>* %a) #0 {
; CHECK-LABEL: bswap_v64i32:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].s, vl64
; VBITS_GE_2048-NEXT: ld1w { [[OP:z[0-9]+]].s }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: revb [[RES:z[0-9]+]].s, [[PG]]/m, [[OP]].s
; VBITS_GE_2048-NEXT: st1w { [[RES]].s }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <64 x i32>, <64 x i32>* %a
  %res = call <64 x i32> @llvm.bswap.v64i32(<64 x i32> %op)
  store <64 x i32> %res, <64 x i32>* %a
  ret void
}

; Don't use SVE for 64-bit vectors.
define <1 x i64> @bswap_v1i64(<1 x i64> %op) #0 {
; CHECK-LABEL: bswap_v1i64:
; CHECK: rev64 v0.8b, v0.8b
; CHECK-NEXT: ret
  %res = call <1 x i64> @llvm.bswap.v1i64(<1 x i64> %op)
  ret <1 x i64> %res
}

; Don't use SVE for 128-bit vectors.
define <2 x i64> @bswap_v2i64(<2 x i64> %op) #0 {
; CHECK-LABEL: bswap_v2i64:
; CHECK: rev64 v0.16b, v0.16b
; CHECK-NEXT: ret
  %res = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %op)
  ret <2 x i64> %res
}

define void @bswap_v4i64(<4 x i64>* %a) #0 {
; CHECK-LABEL: bswap_v4i64:
; CHECK: ptrue [[PG:p[0-9]+]].d, vl4
; CHECK-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; CHECK-NEXT: revb [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; CHECK-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; CHECK-NEXT: ret
  %op = load <4 x i64>, <4 x i64>* %a
  %res = call <4 x i64> @llvm.bswap.v4i64(<4 x i64> %op)
  store <4 x i64> %res, <4 x i64>* %a
  ret void
}

define void @bswap_v8i64(<8 x i64>* %a) #0 {
; CHECK-LABEL: bswap_v8i64:
; VBITS_GE_512: ptrue [[PG:p[0-9]+]].d, vl8
; VBITS_GE_512-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_512-NEXT: revb [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_512-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_512-NEXT: ret

; Ensure sensible type legalisation.
; VBITS_EQ_256-DAG: ptrue [[PG:p[0-9]+]].d, vl4
; VBITS_EQ_256-DAG: add x[[A_HI:[0-9]+]], x0, #32
; VBITS_EQ_256-DAG: ld1d { [[OP_LO:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_EQ_256-DAG: ld1d { [[OP_HI:z[0-9]+]].d }, [[PG]]/z, [x[[A_HI]]]
; VBITS_EQ_256-DAG: revb [[RES_LO:z[0-9]+]].d, [[PG]]/m, [[OP_LO]].d
; VBITS_EQ_256-DAG: revb [[RES_HI:z[0-9]+]].d, [[PG]]/m, [[OP_HI]].d
; VBITS_EQ_256-DAG: st1d { [[RES_LO]].d }, [[PG]], [x0]
; VBITS_EQ_256-DAG: st1d { [[RES_HI]].d }, [[PG]], [x[[A_HI]]
; VBITS_EQ_256-NEXT: ret
  %op = load <8 x i64>, <8 x i64>* %a
  %res = call <8 x i64> @llvm.bswap.v8i64(<8 x i64> %op)
  store <8 x i64> %res, <8 x i64>* %a
  ret void
}

define void @bswap_v16i64(<16 x i64>* %a) #0 {
; CHECK-LABEL: bswap_v16i64:
; VBITS_GE_1024: ptrue [[PG:p[0-9]+]].d, vl16
; VBITS_GE_1024-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_1024-NEXT: revb [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_1024-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_1024-NEXT: ret
  %op = load <16 x i64>, <16 x i64>* %a
  %res = call <16 x i64> @llvm.bswap.v16i64(<16 x i64> %op)
  store <16 x i64> %res, <16 x i64>* %a
  ret void
}

define void @bswap_v32i64(<32 x i64>* %a) #0 {
; CHECK-LABEL: bswap_v32i64:
; VBITS_GE_2048: ptrue [[PG:p[0-9]+]].d, vl32
; VBITS_GE_2048-NEXT: ld1d { [[OP:z[0-9]+]].d }, [[PG]]/z, [x0]
; VBITS_GE_2048-NEXT: revb [[RES:z[0-9]+]].d, [[PG]]/m, [[OP]].d
; VBITS_GE_2048-NEXT: st1d { [[RES]].d }, [[PG]], [x0]
; VBITS_GE_2048-NEXT: ret
  %op = load <32 x i64>, <32 x i64>* %a
  %res = call <32 x i64> @llvm.bswap.v32i64(<32 x i64> %op)
  store <32 x i64> %res, <32 x i64>* %a
  ret void
}

attributes #0 = { "target-features"="+sve" }

declare <8 x i8> @llvm.bitreverse.v8i8(<8 x i8>)
declare <16 x i8> @llvm.bitreverse.v16i8(<16 x i8>)
declare <32 x i8> @llvm.bitreverse.v32i8(<32 x i8>)
declare <64 x i8> @llvm.bitreverse.v64i8(<64 x i8>)
declare <128 x i8> @llvm.bitreverse.v128i8(<128 x i8>)
declare <256 x i8> @llvm.bitreverse.v256i8(<256 x i8>)
declare <4 x i16> @llvm.bitreverse.v4i16(<4 x i16>)
declare <8 x i16> @llvm.bitreverse.v8i16(<8 x i16>)
declare <16 x i16> @llvm.bitreverse.v16i16(<16 x i16>)
declare <32 x i16> @llvm.bitreverse.v32i16(<32 x i16>)
declare <64 x i16> @llvm.bitreverse.v64i16(<64 x i16>)
declare <128 x i16> @llvm.bitreverse.v128i16(<128 x i16>)
declare <2 x i32> @llvm.bitreverse.v2i32(<2 x i32>)
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>)
declare <8 x i32> @llvm.bitreverse.v8i32(<8 x i32>)
declare <16 x i32> @llvm.bitreverse.v16i32(<16 x i32>)
declare <32 x i32> @llvm.bitreverse.v32i32(<32 x i32>)
declare <64 x i32> @llvm.bitreverse.v64i32(<64 x i32>)
declare <1 x i64> @llvm.bitreverse.v1i64(<1 x i64>)
declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>)
declare <4 x i64> @llvm.bitreverse.v4i64(<4 x i64>)
declare <8 x i64> @llvm.bitreverse.v8i64(<8 x i64>)
declare <16 x i64> @llvm.bitreverse.v16i64(<16 x i64>)
declare <32 x i64> @llvm.bitreverse.v32i64(<32 x i64>)

declare <4 x i16> @llvm.bswap.v4i16(<4 x i16>)
declare <8 x i16> @llvm.bswap.v8i16(<8 x i16>)
declare <16 x i16> @llvm.bswap.v16i16(<16 x i16>)
declare <32 x i16> @llvm.bswap.v32i16(<32 x i16>)
declare <64 x i16> @llvm.bswap.v64i16(<64 x i16>)
declare <128 x i16> @llvm.bswap.v128i16(<128 x i16>)
declare <2 x i32> @llvm.bswap.v2i32(<2 x i32>)
declare <4 x i32> @llvm.bswap.v4i32(<4 x i32>)
declare <8 x i32> @llvm.bswap.v8i32(<8 x i32>)
declare <16 x i32> @llvm.bswap.v16i32(<16 x i32>)
declare <32 x i32> @llvm.bswap.v32i32(<32 x i32>)
declare <64 x i32> @llvm.bswap.v64i32(<64 x i32>)
declare <1 x i64> @llvm.bswap.v1i64(<1 x i64>)
declare <2 x i64> @llvm.bswap.v2i64(<2 x i64>)
declare <4 x i64> @llvm.bswap.v4i64(<4 x i64>)
declare <8 x i64> @llvm.bswap.v8i64(<8 x i64>)
declare <16 x i64> @llvm.bswap.v16i64(<16 x i64>)
declare <32 x i64> @llvm.bswap.v32i64(<32 x i64>)

