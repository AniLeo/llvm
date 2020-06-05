# RUN: llvm-mc -triple=ve --show-encoding < %s \
# RUN:     | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: llvm-mc -triple=ve -filetype=obj < %s | llvm-objdump -d - \
# RUN:     | FileCheck %s --check-prefixes=CHECK-INST

# CHECK-INST: cmov.l.at %s11, %s12, 63
# CHECK-ENCODING: encoding: [0x0f,0x00,0x00,0x00,0x8c,0x3f,0x0b,0x3b]
cmov.l %s11, %s12, 63

# CHECK-INST: cmov.w.at %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x8f,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.w.at %s11, %s12, %s13

# CHECK-INST: cmov.d.af %s11, (20)0, %s12
# CHECK-ENCODING: encoding: [0x40,0x00,0x00,0x00,0x54,0x8c,0x0b,0x3b]
cmov.d.af %s11, (20)0, %s12

# CHECK-INST: cmov.s.gt %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xc1,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.gt %s11, (63)1, %s12

# CHECK-INST: cmov.l.lt %s11, %s12, 63
# CHECK-ENCODING: encoding: [0x02,0x00,0x00,0x00,0x8c,0x3f,0x0b,0x3b]
cmov.l.lt %s11, %s12, 63

# CHECK-INST: cmov.w.ne %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x83,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.w.ne %s11, %s12, %s13

# CHECK-INST: cmov.d.eq %s11, (20)0, %s12
# CHECK-ENCODING: encoding: [0x44,0x00,0x00,0x00,0x54,0x8c,0x0b,0x3b]
cmov.d.eq %s11, (20)0, %s12

# CHECK-INST: cmov.s.ge %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xc5,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.ge %s11, (63)1, %s12

# CHECK-INST: cmov.l.le %s11, %s12, 63
# CHECK-ENCODING: encoding: [0x06,0x00,0x00,0x00,0x8c,0x3f,0x0b,0x3b]
cmov.l.le %s11, %s12, 63

# CHECK-INST: cmov.d.num %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x47,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.d.num %s11, %s12, %s13

# CHECK-INST: cmov.s.nan %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xc8,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.nan %s11, (63)1, %s12

# CHECK-INST: cmov.d.gtnan %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x49,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.d.gtnan %s11, %s12, %s13

# CHECK-INST: cmov.s.ltnan %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xca,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.ltnan %s11, (63)1, %s12

# CHECK-INST: cmov.d.nenan %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x4b,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.d.nenan %s11, %s12, %s13

# CHECK-INST: cmov.s.eqnan %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xcc,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.eqnan %s11, (63)1, %s12

# CHECK-INST: cmov.d.genan %s11, %s12, %s13
# CHECK-ENCODING: encoding: [0x4d,0x00,0x00,0x00,0x8c,0x8d,0x0b,0x3b]
cmov.d.genan %s11, %s12, %s13

# CHECK-INST: cmov.s.lenan %s11, (63)1, %s12
# CHECK-ENCODING: encoding: [0xce,0x00,0x00,0x00,0x3f,0x8c,0x0b,0x3b]
cmov.s.lenan %s11, (63)1, %s12
