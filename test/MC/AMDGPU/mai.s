// RUN: llvm-mc -arch=amdgcn -mcpu=gfx908 -show-encoding %s | FileCheck -check-prefix=GFX908 %s

v_accvgpr_read_b32 v2, a0
// GFX908: v_accvgpr_read_b32 v2, a0       ; encoding: [0x02,0x00,0xd8,0xd3,0x00,0x01,0x00,0x08]

v_accvgpr_read_b32 v2, a1
// GFX908: v_accvgpr_read_b32 v2, a1       ; encoding: [0x02,0x00,0xd8,0xd3,0x01,0x01,0x00,0x08]

v_accvgpr_read_b32 v2, a255
// GFX908: v_accvgpr_read_b32 v2, a255     ; encoding: [0x02,0x00,0xd8,0xd3,0xff,0x01,0x00,0x08]

v_accvgpr_read v2, a10
// GFX908: v_accvgpr_read_b32 v2, a10      ; encoding: [0x02,0x00,0xd8,0xd3,0x0a,0x01,0x00,0x08]

v_accvgpr_write_b32 a2, -2.0
// GFX908: v_accvgpr_write_b32 a2, -2.0    ; encoding: [0x02,0x00,0xd9,0xd3,0xf5,0x00,0x00,0x00]

v_accvgpr_write_b32 a2, -2
// GFX908: v_accvgpr_write_b32 a2, -2      ; encoding: [0x02,0x00,0xd9,0xd3,0xc2,0x00,0x00,0x00]

v_accvgpr_write_b32 a2, v1
// GFX908: v_accvgpr_write_b32 a2, v1      ; encoding: [0x02,0x00,0xd9,0xd3,0x01,0x01,0x00,0x00]

v_accvgpr_write a2, v255
// GFX908: v_accvgpr_write_b32 a2, v255    ; encoding: [0x02,0x00,0xd9,0xd3,0xff,0x01,0x00,0x00]

v_mfma_f32_32x32x1f32 a[0:31], v0, v1, a[1:32]
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, v1, a[1:32] ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x1f32 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x1f32 a[0:31], v0, a1, a[1:32]
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, a1, a[1:32] ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x1f32 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x1f32 a[0:31], a0, v1, a[1:32]
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, v1, a[1:32] ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x1f32 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x1f32 a[0:31], a0, a1, a[1:32]
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, a1, a[1:32] ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x1f32 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x1f32 a[0:31], v0, v1, -2.0
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, v1, -2.0 ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x1f32 a[0:31], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x1f32 a[0:31], v0, a1, -2.0
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, a1, -2.0 ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x1f32 a[0:31], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x1f32 a[0:31], a0, v1, -2.0
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, v1, -2.0 ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x1f32 a[0:31], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x1f32 a[0:31], a0, a1, -2.0
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, a1, -2.0 ; encoding: [0x00,0x00,0xc0,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x1f32 a[0:31], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x1f32 a[0:31], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc0,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x1f32 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x1f32 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x1f32 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x1f32 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x1f32 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x1f32 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x1f32 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x1f32 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x1f32 a[0:15], v0, v1, -2.0
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, v1, -2.0 ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x1f32 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x1f32 a[0:15], v0, a1, -2.0
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, a1, -2.0 ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x1f32 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x1f32 a[0:15], a0, v1, -2.0
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, v1, -2.0 ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x1f32 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x1f32 a[0:15], a0, a1, -2.0
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, a1, -2.0 ; encoding: [0x00,0x00,0xc1,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x1f32 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x1f32 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc1,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_4x4x1f32 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_4x4x1f32 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_4x4x1f32 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_4x4x1f32 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_4x4x1f32 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_4x4x1f32 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_4x4x1f32 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_4x4x1f32 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_4x4x1f32 a[0:3], v0, v1, -2.0
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, v1, -2.0 ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_4x4x1f32 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_4x4x1f32 a[0:3], v0, a1, -2.0
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, a1, -2.0 ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_4x4x1f32 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_4x4x1f32 a[0:3], a0, v1, -2.0
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, v1, -2.0 ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_4x4x1f32 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_4x4x1f32 a[0:3], a0, a1, -2.0
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, a1, -2.0 ; encoding: [0x00,0x00,0xc2,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_4x4x1f32 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x1f32 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc2,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_32x32x2f32 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x2f32 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x2f32 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x2f32 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x2f32 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x2f32 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x2f32 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x2f32 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x2f32 a[0:15], v0, v1, -2.0
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, v1, -2.0 ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x2f32 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x2f32 a[0:15], v0, a1, -2.0
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, a1, -2.0 ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x2f32 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x2f32 a[0:15], a0, v1, -2.0
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, v1, -2.0 ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x2f32 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x2f32 a[0:15], a0, a1, -2.0
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, a1, -2.0 ; encoding: [0x00,0x00,0xc4,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x2f32 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2f32 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc4,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x4f32 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x4f32 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x4f32 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x4f32 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x4f32 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x4f32 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x4f32 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x4f32 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x4f32 a[0:3], v0, v1, -2.0
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, v1, -2.0 ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x4f32 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x4f32 a[0:3], v0, a1, -2.0
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, a1, -2.0 ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x4f32 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x4f32 a[0:3], a0, v1, -2.0
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, v1, -2.0 ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x4f32 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x4f32 a[0:3], a0, a1, -2.0
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, a1, -2.0 ; encoding: [0x00,0x00,0xc5,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x4f32 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f32 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc5,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], a[1:32]
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], a[1:32] ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], a[1:32]
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], a[1:32] ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], a[1:32]
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], a[1:32] ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], a[1:32]
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], a[1:32] ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xc8,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4f16 a[0:31], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc8,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], a[1:16]
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], a[1:16] ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], a[1:16]
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], a[1:16] ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], a[1:16]
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], a[1:16] ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], a[1:16]
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], a[1:16] ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xc9,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x4f16 a[0:15], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xc9,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], a[1:4]
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], a[1:4] ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], a[1:4]
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], a[1:4] ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], a[1:4]
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], a[1:4] ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], a[1:4]
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], a[1:4] ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xca,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x4f16 a[0:3], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xca,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], a[1:16]
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], a[1:16] ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], a[1:16]
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], a[1:16] ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], a[1:16]
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], a[1:16] ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], a[1:16]
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], a[1:16] ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xcc,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x8f16 a[0:15], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcc,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], a[1:4]
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], a[1:4] ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], a[1:4]
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], a[1:4] ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], a[1:4]
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], a[1:4] ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], a[1:4]
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], a[1:4] ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], v[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], -2.0
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], -2.0 ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], v[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], -2.0
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], -2.0 ; encoding: [0x00,0x00,0xcd,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x16f16 a[0:3], a[0:1], a[1:2], -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xcd,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_i32_32x32x4i8 a[0:31], v0, v1, a[1:32]
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, v1, a[1:32] ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x06,0x04]

v_mfma_i32_32x32x4i8 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_i32_32x32x4i8 a[0:31], v0, a1, a[1:32]
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, a1, a[1:32] ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x06,0x14]

v_mfma_i32_32x32x4i8 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_i32_32x32x4i8 a[0:31], a0, v1, a[1:32]
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, v1, a[1:32] ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_i32_32x32x4i8 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x06,0xec]

v_mfma_i32_32x32x4i8 a[0:31], a0, a1, a[1:32]
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, a1, a[1:32] ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_i32_32x32x4i8 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_i32_32x32x4i8 a[0:31], v0, v1, 2
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, v1, 2 ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x0a,0x02]

v_mfma_i32_32x32x4i8 a[0:31], v0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x0a,0xe2]

v_mfma_i32_32x32x4i8 a[0:31], v0, a1, 2
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, a1, 2 ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x0a,0x12]

v_mfma_i32_32x32x4i8 a[0:31], v0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], v0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x0a,0xf2]

v_mfma_i32_32x32x4i8 a[0:31], a0, v1, 2
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, v1, 2 ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x0a,0x0a]

v_mfma_i32_32x32x4i8 a[0:31], a0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x0a,0xea]

v_mfma_i32_32x32x4i8 a[0:31], a0, a1, 2
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, a1, 2 ; encoding: [0x00,0x00,0xd0,0xd3,0x00,0x03,0x0a,0x1a]

v_mfma_i32_32x32x4i8 a[0:31], a0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x4i8 a[0:31], a0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd0,0xd3,0x00,0x03,0x0a,0xfa]

v_mfma_i32_16x16x4i8 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x06,0x04]

v_mfma_i32_16x16x4i8 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_i32_16x16x4i8 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x06,0x14]

v_mfma_i32_16x16x4i8 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_i32_16x16x4i8 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_i32_16x16x4i8 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x06,0xec]

v_mfma_i32_16x16x4i8 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_i32_16x16x4i8 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_i32_16x16x4i8 a[0:15], v0, v1, 2
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, v1, 2 ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x0a,0x02]

v_mfma_i32_16x16x4i8 a[0:15], v0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x0a,0xe2]

v_mfma_i32_16x16x4i8 a[0:15], v0, a1, 2
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, a1, 2 ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x0a,0x12]

v_mfma_i32_16x16x4i8 a[0:15], v0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], v0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x0a,0xf2]

v_mfma_i32_16x16x4i8 a[0:15], a0, v1, 2
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, v1, 2 ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x0a,0x0a]

v_mfma_i32_16x16x4i8 a[0:15], a0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x0a,0xea]

v_mfma_i32_16x16x4i8 a[0:15], a0, a1, 2
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, a1, 2 ; encoding: [0x00,0x00,0xd1,0xd3,0x00,0x03,0x0a,0x1a]

v_mfma_i32_16x16x4i8 a[0:15], a0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x4i8 a[0:15], a0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd1,0xd3,0x00,0x03,0x0a,0xfa]

v_mfma_i32_4x4x4i8 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x06,0x04]

v_mfma_i32_4x4x4i8 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_i32_4x4x4i8 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x06,0x14]

v_mfma_i32_4x4x4i8 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_i32_4x4x4i8 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_i32_4x4x4i8 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x06,0xec]

v_mfma_i32_4x4x4i8 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_i32_4x4x4i8 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_i32_4x4x4i8 a[0:3], v0, v1, 2
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, v1, 2 ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x0a,0x02]

v_mfma_i32_4x4x4i8 a[0:3], v0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x0a,0xe2]

v_mfma_i32_4x4x4i8 a[0:3], v0, a1, 2
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, a1, 2 ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x0a,0x12]

v_mfma_i32_4x4x4i8 a[0:3], v0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], v0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x0a,0xf2]

v_mfma_i32_4x4x4i8 a[0:3], a0, v1, 2
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, v1, 2 ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x0a,0x0a]

v_mfma_i32_4x4x4i8 a[0:3], a0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x0a,0xea]

v_mfma_i32_4x4x4i8 a[0:3], a0, a1, 2
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, a1, 2 ; encoding: [0x00,0x00,0xd2,0xd3,0x00,0x03,0x0a,0x1a]

v_mfma_i32_4x4x4i8 a[0:3], a0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_4x4x4i8 a[0:3], a0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd2,0xd3,0x00,0x03,0x0a,0xfa]

v_mfma_i32_32x32x8i8 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x06,0x04]

v_mfma_i32_32x32x8i8 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_i32_32x32x8i8 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x06,0x14]

v_mfma_i32_32x32x8i8 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_i32_32x32x8i8 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_i32_32x32x8i8 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x06,0xec]

v_mfma_i32_32x32x8i8 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_i32_32x32x8i8 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_i32_32x32x8i8 a[0:15], v0, v1, 2
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, v1, 2 ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x0a,0x02]

v_mfma_i32_32x32x8i8 a[0:15], v0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x0a,0xe2]

v_mfma_i32_32x32x8i8 a[0:15], v0, a1, 2
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, a1, 2 ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x0a,0x12]

v_mfma_i32_32x32x8i8 a[0:15], v0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], v0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x0a,0xf2]

v_mfma_i32_32x32x8i8 a[0:15], a0, v1, 2
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, v1, 2 ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x0a,0x0a]

v_mfma_i32_32x32x8i8 a[0:15], a0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x0a,0xea]

v_mfma_i32_32x32x8i8 a[0:15], a0, a1, 2
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, a1, 2 ; encoding: [0x00,0x00,0xd4,0xd3,0x00,0x03,0x0a,0x1a]

v_mfma_i32_32x32x8i8 a[0:15], a0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_32x32x8i8 a[0:15], a0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd4,0xd3,0x00,0x03,0x0a,0xfa]

v_mfma_i32_16x16x16i8 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x06,0x04]

v_mfma_i32_16x16x16i8 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_i32_16x16x16i8 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x06,0x14]

v_mfma_i32_16x16x16i8 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_i32_16x16x16i8 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_i32_16x16x16i8 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x06,0xec]

v_mfma_i32_16x16x16i8 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_i32_16x16x16i8 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_i32_16x16x16i8 a[0:3], v0, v1, 2
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, v1, 2 ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x0a,0x02]

v_mfma_i32_16x16x16i8 a[0:3], v0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x0a,0xe2]

v_mfma_i32_16x16x16i8 a[0:3], v0, a1, 2
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, a1, 2 ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x0a,0x12]

v_mfma_i32_16x16x16i8 a[0:3], v0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], v0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x0a,0xf2]

v_mfma_i32_16x16x16i8 a[0:3], a0, v1, 2
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, v1, 2 ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x0a,0x0a]

v_mfma_i32_16x16x16i8 a[0:3], a0, v1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, v1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x0a,0xea]

v_mfma_i32_16x16x16i8 a[0:3], a0, a1, 2
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, a1, 2 ; encoding: [0x00,0x00,0xd5,0xd3,0x00,0x03,0x0a,0x1a]

v_mfma_i32_16x16x16i8 a[0:3], a0, a1, 2 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_i32_16x16x16i8 a[0:3], a0, a1, 2 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xd5,0xd3,0x00,0x03,0x0a,0xfa]

v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, a[1:32]
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, a[1:32] ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, a[1:32]
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, a[1:32] ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, a[1:32]
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, a[1:32] ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, a[1:32]
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, a[1:32] ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, a[1:32] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, -2.0
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, -2.0 ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, -2.0
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, -2.0 ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, -2.0
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, -2.0 ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, -2.0
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, -2.0 ; encoding: [0x00,0x00,0xe8,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x2bf16 a[0:31], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe8,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, -2.0
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, -2.0 ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, -2.0
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, -2.0 ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, -2.0
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, -2.0 ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, -2.0
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, -2.0 ; encoding: [0x00,0x00,0xe9,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x2bf16 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xe9,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, -2.0
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, -2.0 ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, -2.0
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, -2.0 ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, -2.0
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, -2.0 ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, -2.0
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, -2.0 ; encoding: [0x00,0x00,0xeb,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_4x4x2bf16 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xeb,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, a[1:16]
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, a[1:16] ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, a[1:16]
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, a[1:16] ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, a[1:16]
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, a[1:16] ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, a[1:16]
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, a[1:16] ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, a[1:16] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, -2.0
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, -2.0 ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, -2.0
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, -2.0 ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, -2.0
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, -2.0 ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, -2.0
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, -2.0 ; encoding: [0x00,0x00,0xec,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_32x32x4bf16 a[0:15], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xec,0xd3,0x00,0x03,0xd6,0xfb]

v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, a[1:4]
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, a[1:4] ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0x06,0x04]

v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0x06,0xe4]

v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, a[1:4]
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, a[1:4] ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0x06,0x14]

v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0x06,0xf4]

v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, a[1:4]
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, a[1:4] ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0x06,0x0c]

v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0x06,0xec]

v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, a[1:4]
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, a[1:4] ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0x06,0x1c]

v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, a[1:4] cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0x06,0xfc]

v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, -2.0
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, -2.0 ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0xd6,0x03]

v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0xd6,0xe3]

v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, -2.0
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, -2.0 ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0xd6,0x13]

v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], v0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0xd6,0xf3]

v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, -2.0
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, -2.0 ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0xd6,0x0b]

v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, v1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0xd6,0xeb]

v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, -2.0
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, -2.0 ; encoding: [0x00,0x00,0xed,0xd3,0x00,0x03,0xd6,0x1b]

v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7
// GFX908: v_mfma_f32_16x16x8bf16 a[0:3], a0, a1, -2.0 cbsz:3 abid:2 blgp:7 ; encoding: [0x00,0x13,0xed,0xd3,0x00,0x03,0xd6,0xfb]
