# RUN: llvm-mc %s -triple=mips-unknown-linux -show-encoding -mcpu=mips32r6 -mattr=micromips -mattr=+dsp | FileCheck %s

  .set noat
  addu.qb $3, $4, $5           # CHECK: addu.qb $3, $4, $5      # encoding: [0x00,0xa4,0x18,0xcd]
  dpaq_s.w.ph $ac1, $5, $3     # CHECK: dpaq_s.w.ph $ac1, $5, $3   # encoding: [0x00,0x65,0x42,0xbc]
  dpaq_sa.l.w $ac2, $4, $3     # CHECK: dpaq_sa.l.w $ac2, $4, $3   # encoding: [0x00,0x64,0x92,0xbc]
  dpau.h.qbl $ac1, $3, $4      # CHECK: dpau.h.qbl $ac1, $3, $4    # encoding: [0x00,0x83,0x60,0xbc]
  dpau.h.qbr $ac2, $20, $21    # CHECK: dpau.h.qbr $ac2, $20, $21  # encoding: [0x02,0xb4,0xb0,0xbc]
  absq_s.ph $3, $4             # CHECK: absq_s.ph $3, $4        # encoding: [0x00,0x64,0x11,0x3c]
  absq_s.w $3, $4              # CHECK: absq_s.w $3, $4         # encoding: [0x00,0x64,0x21,0x3c]
  insv $3, $4                  # CHECK: insv $3, $4             # encoding: [0x00,0x64,0x41,0x3c]
  madd $ac1, $6, $7            # CHECK: madd $ac1, $6, $7       # encoding: [0x00,0xe6,0x4a,0xbc]
  maddu $ac0, $8, $9           # CHECK: maddu $ac0, $8, $9      # encoding: [0x01,0x28,0x1a,0xbc]
  msub $ac3, $10, $11          # CHECK: msub $ac3, $10, $11     # encoding: [0x01,0x6a,0xea,0xbc]
  msubu $ac2, $12, $13         # CHECK: msubu $ac2, $12, $13    # encoding: [0x01,0xac,0xba,0xbc]
  mult $ac3, $2, $3            # CHECK: mult $ac3, $2, $3       # encoding: [0x00,0x62,0xcc,0xbc]
  multu $ac2, $4, $5           # CHECK: multu $ac2, $4, $5      # encoding: [0x00,0xa4,0x9c,0xbc]
