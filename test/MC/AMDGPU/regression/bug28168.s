// RUN: llvm-mc -arch=amdgcn -mcpu=bonaire -show-encoding %s | FileCheck %s --check-prefix=GCN --check-prefix=SICI --check-prefix=CI
// RUN: llvm-mc -arch=amdgcn -mcpu=tonga -show-encoding %s | FileCheck %s --check-prefix=GCN --check-prefix=CIVI --check-prefix=VI

v_mqsad_pk_u16_u8 v[2:3], s[0:1], 1, v[254:255]
// CI: [0x02,0x00,0xe6,0xd2,0x00,0x02,0xf9,0x07]
// VI: [0x02,0x00,0xe6,0xd1,0x00,0x02,0xf9,0x07]

v_qsad_pk_u16_u8 v[2:3], v[0:1], 1, s[0:1]
// CI: [0x02,0x00,0xe4,0xd2,0x00,0x03,0x01,0x00]
// VI: [0x02,0x00,0xe5,0xd1,0x00,0x03,0x01,0x00]
