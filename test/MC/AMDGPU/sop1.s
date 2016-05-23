// RUN: llvm-mc -arch=amdgcn -show-encoding %s | FileCheck --check-prefix=GCN --check-prefix=SICI %s
// RUN: llvm-mc -arch=amdgcn -mcpu=SI -show-encoding %s | FileCheck --check-prefix=GCN --check-prefix=SICI %s
// RUN: not llvm-mc -arch=amdgcn -mcpu=fiji -show-encoding %s 2>&1 | FileCheck --check-prefix=GCN --check-prefix=VI %s
// RUN: not llvm-mc -arch=amdgcn -mcpu=fiji -show-encoding %s 2>&1 | FileCheck --check-prefix=NOVI %s

s_mov_b32 s1, s2
// SICI: s_mov_b32 s1, s2 ; encoding: [0x02,0x03,0x81,0xbe]
// VI:   s_mov_b32 s1, s2 ; encoding: [0x02,0x00,0x81,0xbe]

s_mov_b32 s1, 1
// SICI: s_mov_b32 s1, 1 ; encoding: [0x81,0x03,0x81,0xbe]
// VI:   s_mov_b32 s1, 1 ; encoding: [0x81,0x00,0x81,0xbe]

s_mov_b32 s1, 100
// SICI: s_mov_b32 s1, 0x64 ; encoding: [0xff,0x03,0x81,0xbe,0x64,0x00,0x00,0x00]
// VI:   s_mov_b32 s1, 0x64 ; encoding: [0xff,0x00,0x81,0xbe,0x64,0x00,0x00,0x00]

// Literal constant sign bit
s_mov_b32 s1, 0x80000000
// SICI: s_mov_b32 s1, 0x80000000 ; encoding: [0xff,0x03,0x81,0xbe,0x00,0x00,0x00,0x80]
// VI:   s_mov_b32 s1, 0x80000000 ; encoding: [0xff,0x00,0x81,0xbe,0x00,0x00,0x00,0x80]

// Negative 32-bit constant
s_mov_b32 s0, 0xfe5163ab
// SICI: s_mov_b32 s0, 0xfe5163ab ; encoding: [0xff,0x03,0x80,0xbe,0xab,0x63,0x51,0xfe]
// VI:   s_mov_b32 s0, 0xfe5163ab ; encoding: [0xff,0x00,0x80,0xbe,0xab,0x63,0x51,0xfe]

s_mov_b64 s[2:3], s[4:5]
// SICI: s_mov_b64 s[2:3], s[4:5] ; encoding: [0x04,0x04,0x82,0xbe]
// VI:   s_mov_b64 s[2:3], s[4:5] ; encoding: [0x04,0x01,0x82,0xbe]

s_mov_b64 s[2:3], 0xffffffffffffffff
// SICI: s_mov_b64 s[2:3], -1 ; encoding: [0xc1,0x04,0x82,0xbe]
// VI:   s_mov_b64 s[2:3], -1 ; encoding: [0xc1,0x01,0x82,0xbe]

s_mov_b64 s[2:3], 0xffffffff
// SICI: s_mov_b64 s[2:3], 0xffffffff ; encoding: [0xff,0x04,0x82,0xbe,0xff,0xff,0xff,0xff]
// VI:   s_mov_b64 s[2:3], 0xffffffff ; encoding: [0xff,0x01,0x82,0xbe,0xff,0xff,0xff,0xff]

s_mov_b64 s[0:1], 0x80000000
// SICI: s_mov_b64 s[0:1], 0x80000000 ; encoding: [0xff,0x04,0x80,0xbe,0x00,0x00,0x00,0x80]
// VI:   s_mov_b64 s[0:1], 0x80000000 ; encoding: [0xff,0x01,0x80,0xbe,0x00,0x00,0x00,0x80]

s_mov_b64 s[102:103], -1
// SICI: s_mov_b64 s[102:103], -1 ; encoding: [0xc1,0x04,0xe6,0xbe]
// NOVI: error: not a valid operand

s_cmov_b32 s1, 200
// SICI: s_cmov_b32 s1, 0xc8 ; encoding: [0xff,0x05,0x81,0xbe,0xc8,0x00,0x00,0x00]
// VI:   s_cmov_b32 s1, 0xc8 ; encoding: [0xff,0x02,0x81,0xbe,0xc8,0x00,0x00,0x00]

s_cmov_b32 s1, 1.0
// SICI: s_cmov_b32 s1, 1.0 ; encoding: [0xf2,0x05,0x81,0xbe]
// VI:   s_cmov_b32 s1, 1.0 ; encoding: [0xf2,0x02,0x81,0xbe]

s_cmov_b32 s1, s2
// SICI: s_cmov_b32 s1, s2 ; encoding: [0x02,0x05,0x81,0xbe]
// VI:   s_cmov_b32 s1, s2 ; encoding: [0x02,0x02,0x81,0xbe]

//s_cmov_b64 s[2:3], 1.0
//GCN-FIXME: s_cmov_b64 s[2:3], 1.0 ; encoding: [0xf2,0x05,0x82,0xb3]

s_cmov_b64 s[2:3], s[4:5]
// SICI: s_cmov_b64 s[2:3], s[4:5] ; encoding: [0x04,0x06,0x82,0xbe]
// VI:   s_cmov_b64 s[2:3], s[4:5] ; encoding: [0x04,0x03,0x82,0xbe]

s_not_b32 s1, s2
// SICI: s_not_b32 s1, s2 ; encoding: [0x02,0x07,0x81,0xbe]
// VI:   s_not_b32 s1, s2 ; encoding: [0x02,0x04,0x81,0xbe]

s_not_b64 s[2:3], s[4:5]
// SICI: s_not_b64 s[2:3], s[4:5] ; encoding: [0x04,0x08,0x82,0xbe]
// VI:   s_not_b64 s[2:3], s[4:5] ; encoding: [0x04,0x05,0x82,0xbe]

s_wqm_b32 s1, s2
// SICI: s_wqm_b32 s1, s2 ; encoding: [0x02,0x09,0x81,0xbe]
// VI:   s_wqm_b32 s1, s2 ; encoding: [0x02,0x06,0x81,0xbe]

s_wqm_b64 s[2:3], s[4:5]
// SICI: s_wqm_b64 s[2:3], s[4:5] ; encoding: [0x04,0x0a,0x82,0xbe]
// VI:   s_wqm_b64 s[2:3], s[4:5] ; encoding: [0x04,0x07,0x82,0xbe]

s_brev_b32 s1, s2
// SICI: s_brev_b32 s1, s2 ; encoding: [0x02,0x0b,0x81,0xbe]
// VI:   s_brev_b32 s1, s2 ; encoding: [0x02,0x08,0x81,0xbe]

s_brev_b64 s[2:3], s[4:5]
// SICI: s_brev_b64 s[2:3], s[4:5] ; encoding: [0x04,0x0c,0x82,0xbe]
// VI:   s_brev_b64 s[2:3], s[4:5] ; encoding: [0x04,0x09,0x82,0xbe]

s_bcnt0_i32_b32 s1, s2
// SICI: s_bcnt0_i32_b32 s1, s2 ; encoding: [0x02,0x0d,0x81,0xbe]
// VI:   s_bcnt0_i32_b32 s1, s2 ; encoding: [0x02,0x0a,0x81,0xbe]

s_bcnt0_i32_b64 s1, s[2:3]
// SICI: s_bcnt0_i32_b64 s1, s[2:3] ; encoding: [0x02,0x0e,0x81,0xbe]
// VI:   s_bcnt0_i32_b64 s1, s[2:3] ; encoding: [0x02,0x0b,0x81,0xbe]

s_bcnt1_i32_b32 s1, s2
// SICI: s_bcnt1_i32_b32 s1, s2 ; encoding: [0x02,0x0f,0x81,0xbe]
// VI:   s_bcnt1_i32_b32 s1, s2 ; encoding: [0x02,0x0c,0x81,0xbe]

s_bcnt1_i32_b64 s1, s[2:3]
// SICI: s_bcnt1_i32_b64 s1, s[2:3] ; encoding: [0x02,0x10,0x81,0xbe]
// VI:   s_bcnt1_i32_b64 s1, s[2:3] ; encoding: [0x02,0x0d,0x81,0xbe]

s_ff0_i32_b32 s1, s2
// SICI: s_ff0_i32_b32 s1, s2 ; encoding: [0x02,0x11,0x81,0xbe]
// VI:   s_ff0_i32_b32 s1, s2 ; encoding: [0x02,0x0e,0x81,0xbe]

s_ff0_i32_b64 s1, s[2:3]
// SICI: s_ff0_i32_b64 s1, s[2:3] ; encoding: [0x02,0x12,0x81,0xbe]
// VI:   s_ff0_i32_b64 s1, s[2:3] ; encoding: [0x02,0x0f,0x81,0xbe]

s_ff1_i32_b32 s1, s2
// SICI: s_ff1_i32_b32 s1, s2 ; encoding: [0x02,0x13,0x81,0xbe]
// VI:   s_ff1_i32_b32 s1, s2 ; encoding: [0x02,0x10,0x81,0xbe]

s_ff1_i32_b64 s1, s[2:3]
// SICI: s_ff1_i32_b64 s1, s[2:3] ; encoding: [0x02,0x14,0x81,0xbe]
// VI:   s_ff1_i32_b64 s1, s[2:3] ; encoding: [0x02,0x11,0x81,0xbe]

s_flbit_i32_b32 s1, s2
// SICI: s_flbit_i32_b32 s1, s2 ; encoding: [0x02,0x15,0x81,0xbe]
// VI:   s_flbit_i32_b32 s1, s2 ; encoding: [0x02,0x12,0x81,0xbe]

s_flbit_i32_b64 s1, s[2:3]
// SICI: s_flbit_i32_b64 s1, s[2:3] ; encoding: [0x02,0x16,0x81,0xbe]
// VI:   s_flbit_i32_b64 s1, s[2:3] ; encoding: [0x02,0x13,0x81,0xbe]

s_flbit_i32 s1, s2
// SICI: s_flbit_i32 s1, s2 ; encoding: [0x02,0x17,0x81,0xbe]
// VI:   s_flbit_i32 s1, s2 ; encoding: [0x02,0x14,0x81,0xbe]

s_flbit_i32_i64 s1, s[2:3]
// SICI: s_flbit_i32_i64 s1, s[2:3] ; encoding: [0x02,0x18,0x81,0xbe]
// VI:   s_flbit_i32_i64 s1, s[2:3] ; encoding: [0x02,0x15,0x81,0xbe]

s_sext_i32_i8 s1, s2
// SICI: s_sext_i32_i8 s1, s2 ; encoding: [0x02,0x19,0x81,0xbe]
// VI:   s_sext_i32_i8 s1, s2 ; encoding: [0x02,0x16,0x81,0xbe]

s_sext_i32_i16 s1, s2
// SICI: s_sext_i32_i16 s1, s2 ; encoding: [0x02,0x1a,0x81,0xbe]
// VI:   s_sext_i32_i16 s1, s2 ; encoding: [0x02,0x17,0x81,0xbe]

s_bitset0_b32 s1, s2
// SICI: s_bitset0_b32 s1, s2 ; encoding: [0x02,0x1b,0x81,0xbe]
// VI:   s_bitset0_b32 s1, s2 ; encoding: [0x02,0x18,0x81,0xbe]

s_bitset0_b64 s[2:3], s4
// SICI: s_bitset0_b64 s[2:3], s4 ; encoding: [0x04,0x1c,0x82,0xbe]
// VI:   s_bitset0_b64 s[2:3], s4 ; encoding: [0x04,0x19,0x82,0xbe]

s_bitset1_b32 s1, s2
// SICI: s_bitset1_b32 s1, s2 ; encoding: [0x02,0x1d,0x81,0xbe]
// VI:   s_bitset1_b32 s1, s2 ; encoding: [0x02,0x1a,0x81,0xbe]

s_bitset1_b64 s[2:3], s4
// SICI: s_bitset1_b64 s[2:3], s4 ; encoding: [0x04,0x1e,0x82,0xbe]
// VI:   s_bitset1_b64 s[2:3], s4 ; encoding: [0x04,0x1b,0x82,0xbe]

s_getpc_b64 s[2:3]
// SICI: s_getpc_b64 s[2:3] ; encoding: [0x00,0x1f,0x82,0xbe]
// VI:   s_getpc_b64 s[2:3] ; encoding: [0x00,0x1c,0x82,0xbe]

s_setpc_b64 s[4:5]
// SICI: s_setpc_b64 s[4:5] ; encoding: [0x04,0x20,0x80,0xbe]
// VI:   s_setpc_b64 s[4:5] ; encoding: [0x04,0x1d,0x80,0xbe]

s_swappc_b64 s[2:3], s[4:5]
// SICI: s_swappc_b64 s[2:3], s[4:5] ; encoding: [0x04,0x21,0x82,0xbe]
// VI:   s_swappc_b64 s[2:3], s[4:5] ; encoding: [0x04,0x1e,0x82,0xbe]

s_rfe_b64 s[4:5]
// SICI: s_rfe_b64 s[4:5] ; encoding: [0x04,0x22,0x80,0xbe]
// VI:   s_rfe_b64 s[4:5] ; encoding: [0x04,0x1f,0x80,0xbe]

s_and_saveexec_b64 s[2:3], s[4:5]
// SICI: s_and_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x24,0x82,0xbe]
// VI:   s_and_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x20,0x82,0xbe]

s_or_saveexec_b64 s[2:3], s[4:5]
// SICI: s_or_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x25,0x82,0xbe]
// VI:   s_or_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x21,0x82,0xbe]

s_xor_saveexec_b64 s[2:3], s[4:5]
// SICI: s_xor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x26,0x82,0xbe]
// VI:   s_xor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x22,0x82,0xbe]

s_andn2_saveexec_b64 s[2:3], s[4:5]
// SICI: s_andn2_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x27,0x82,0xbe]
// VI:   s_andn2_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x23,0x82,0xbe]

s_orn2_saveexec_b64 s[2:3], s[4:5]
// SICI: s_orn2_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x28,0x82,0xbe]
// VI:   s_orn2_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x24,0x82,0xbe]

s_nand_saveexec_b64 s[2:3], s[4:5]
// SICI: s_nand_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x29,0x82,0xbe]
// VI:   s_nand_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x25,0x82,0xbe]

s_nor_saveexec_b64 s[2:3], s[4:5]
// SICI: s_nor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2a,0x82,0xbe]
// VI:   s_nor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x26,0x82,0xbe]

s_xnor_saveexec_b64 s[2:3], s[4:5]
// SICI: s_xnor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2b,0x82,0xbe]
// VI:   s_xnor_saveexec_b64 s[2:3], s[4:5] ; encoding: [0x04,0x27,0x82,0xbe]

s_quadmask_b32 s1, s2
// SICI: s_quadmask_b32 s1, s2 ; encoding: [0x02,0x2c,0x81,0xbe]
// VI:   s_quadmask_b32 s1, s2 ; encoding: [0x02,0x28,0x81,0xbe]

s_quadmask_b64 s[2:3], s[4:5]
// SICI: s_quadmask_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2d,0x82,0xbe]
// VI:   s_quadmask_b64 s[2:3], s[4:5] ; encoding: [0x04,0x29,0x82,0xbe]

s_movrels_b32 s1, s2
// SICI: s_movrels_b32 s1, s2 ; encoding: [0x02,0x2e,0x81,0xbe]
// VI:   s_movrels_b32 s1, s2 ; encoding: [0x02,0x2a,0x81,0xbe]

s_movrels_b64 s[2:3], s[4:5]
// SICI: s_movrels_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2f,0x82,0xbe]
// VI:   s_movrels_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2b,0x82,0xbe]

s_movreld_b32 s1, s2
// SICI: s_movreld_b32 s1, s2 ; encoding: [0x02,0x30,0x81,0xbe]
// VI:   s_movreld_b32 s1, s2 ; encoding: [0x02,0x2c,0x81,0xbe]

s_movreld_b64 s[2:3], s[4:5]
// SICI: s_movreld_b64 s[2:3], s[4:5] ; encoding: [0x04,0x31,0x82,0xbe]
// VI:   s_movreld_b64 s[2:3], s[4:5] ; encoding: [0x04,0x2d,0x82,0xbe]

s_cbranch_join s[4:5]
// SICI: s_cbranch_join s[4:5] ; encoding: [0x04,0x32,0x80,0xbe]
// VI:   s_cbranch_join s[4:5] ; encoding: [0x04,0x2e,0x80,0xbe]

s_abs_i32 s1, s2
// SICI: s_abs_i32 s1, s2 ; encoding: [0x02,0x34,0x81,0xbe]
// VI:   s_abs_i32 s1, s2 ; encoding: [0x02,0x30,0x81,0xbe]

s_mov_fed_b32 s1, s2
// SICI: s_mov_fed_b32 s1, s2 ; encoding: [0x02,0x35,0x81,0xbe]
