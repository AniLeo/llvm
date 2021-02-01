# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+experimental-v %s \
# RUN:   --riscv-no-aliases | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:   | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-v %s \
# RUN:   | llvm-objdump -d --mattr=+experimental-v - --riscv-no-aliases \
# RUN:   | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+experimental-v %s \
# RUN:   | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

vse1.v v24, (a0)
# CHECK-INST: vse1.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0xb5,0x00]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c b5 00 <unknown>

vse8.v v24, (a0), v0.t
# CHECK-INST: vse8.v v24, (a0), v0.t
# CHECK-ENCODING: [0x27,0x0c,0x05,0x00]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 05 00 <unknown>

vse8.v v24, (a0)
# CHECK-INST: vse8.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0x05,0x02]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 05 02 <unknown>

vse16.v v24, (a0), v0.t
# CHECK-INST: vse16.v v24, (a0), v0.t
# CHECK-ENCODING: [0x27,0x5c,0x05,0x00]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 05 00 <unknown>

vse16.v v24, (a0)
# CHECK-INST: vse16.v v24, (a0)
# CHECK-ENCODING: [0x27,0x5c,0x05,0x02]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 05 02 <unknown>

vse32.v v24, (a0), v0.t
# CHECK-INST: vse32.v v24, (a0), v0.t
# CHECK-ENCODING: [0x27,0x6c,0x05,0x00]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 05 00 <unknown>

vse32.v v24, (a0)
# CHECK-INST: vse32.v v24, (a0)
# CHECK-ENCODING: [0x27,0x6c,0x05,0x02]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 05 02 <unknown>

vse64.v v24, (a0), v0.t
# CHECK-INST: vse64.v v24, (a0), v0.t
# CHECK-ENCODING: [0x27,0x7c,0x05,0x00]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 05 00 <unknown>

vse64.v v24, (a0)
# CHECK-INST: vse64.v v24, (a0)
# CHECK-ENCODING: [0x27,0x7c,0x05,0x02]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 05 02 <unknown>

vsse8.v v24, (a0), a1, v0.t
# CHECK-INST: vsse8.v v24, (a0), a1, v0.t
# CHECK-ENCODING: [0x27,0x0c,0xb5,0x08]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c b5 08 <unknown>

vsse8.v v24, (a0), a1
# CHECK-INST: vsse8.v v24, (a0), a1
# CHECK-ENCODING: [0x27,0x0c,0xb5,0x0a]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c b5 0a <unknown>

vsse16.v v24, (a0), a1, v0.t
# CHECK-INST: vsse16.v v24, (a0), a1, v0.t
# CHECK-ENCODING: [0x27,0x5c,0xb5,0x08]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c b5 08 <unknown>

vsse16.v v24, (a0), a1
# CHECK-INST: vsse16.v v24, (a0), a1
# CHECK-ENCODING: [0x27,0x5c,0xb5,0x0a]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c b5 0a <unknown>

vsse32.v v24, (a0), a1, v0.t
# CHECK-INST: vsse32.v v24, (a0), a1, v0.t
# CHECK-ENCODING: [0x27,0x6c,0xb5,0x08]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c b5 08 <unknown>

vsse32.v v24, (a0), a1
# CHECK-INST: vsse32.v v24, (a0), a1
# CHECK-ENCODING: [0x27,0x6c,0xb5,0x0a]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c b5 0a <unknown>

vsse64.v v24, (a0), a1, v0.t
# CHECK-INST: vsse64.v v24, (a0), a1, v0.t
# CHECK-ENCODING: [0x27,0x7c,0xb5,0x08]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c b5 08 <unknown>

vsse64.v v24, (a0), a1
# CHECK-INST: vsse64.v v24, (a0), a1
# CHECK-ENCODING: [0x27,0x7c,0xb5,0x0a]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c b5 0a <unknown>

vsuxei8.v v24, (a0), v4, v0.t
# CHECK-INST: vsuxei8.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x0c,0x45,0x04]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 45 04 <unknown>

vsuxei8.v v24, (a0), v4
# CHECK-INST: vsuxei8.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x0c,0x45,0x06]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 45 06 <unknown>

vsuxei16.v v24, (a0), v4, v0.t
# CHECK-INST: vsuxei16.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x5c,0x45,0x04]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 45 04 <unknown>

vsuxei16.v v24, (a0), v4
# CHECK-INST: vsuxei16.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x5c,0x45,0x06]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 45 06 <unknown>

vsuxei32.v v24, (a0), v4, v0.t
# CHECK-INST: vsuxei32.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x6c,0x45,0x04]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 45 04 <unknown>

vsuxei32.v v24, (a0), v4
# CHECK-INST: vsuxei32.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x6c,0x45,0x06]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 45 06 <unknown>

vsuxei64.v v24, (a0), v4, v0.t
# CHECK-INST: vsuxei64.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x7c,0x45,0x04]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 45 04 <unknown>

vsuxei64.v v24, (a0), v4
# CHECK-INST: vsuxei64.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x7c,0x45,0x06]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 45 06 <unknown>

vsoxei8.v v24, (a0), v4, v0.t
# CHECK-INST: vsoxei8.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x0c,0x45,0x0c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 45 0c <unknown>

vsoxei8.v v24, (a0), v4
# CHECK-INST: vsoxei8.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x0c,0x45,0x0e]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 45 0e <unknown>

vsoxei16.v v24, (a0), v4, v0.t
# CHECK-INST: vsoxei16.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x5c,0x45,0x0c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 45 0c <unknown>

vsoxei16.v v24, (a0), v4
# CHECK-INST: vsoxei16.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x5c,0x45,0x0e]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 5c 45 0e <unknown>

vsoxei32.v v24, (a0), v4, v0.t
# CHECK-INST: vsoxei32.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x6c,0x45,0x0c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 45 0c <unknown>

vsoxei32.v v24, (a0), v4
# CHECK-INST: vsoxei32.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x6c,0x45,0x0e]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 6c 45 0e <unknown>

vsoxei64.v v24, (a0), v4, v0.t
# CHECK-INST: vsoxei64.v v24, (a0), v4, v0.t
# CHECK-ENCODING: [0x27,0x7c,0x45,0x0c]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 45 0c <unknown>

vsoxei64.v v24, (a0), v4
# CHECK-INST: vsoxei64.v v24, (a0), v4
# CHECK-ENCODING: [0x27,0x7c,0x45,0x0e]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 7c 45 0e <unknown>

vs1r.v v24, (a0)
# CHECK-INST: vs1r.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0x85,0x22]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 85 22 <unknown>

vs2r.v v24, (a0)
# CHECK-INST: vs2r.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0x85,0x42]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 85 42 <unknown>

vs4r.v v24, (a0)
# CHECK-INST: vs4r.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0x85,0x82]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 85 82 <unknown>

vs8r.v v24, (a0)
# CHECK-INST: vs8r.v v24, (a0)
# CHECK-ENCODING: [0x27,0x0c,0x85,0x02]
# CHECK-ERROR: instruction requires the following: 'V' (Vector Instructions)
# CHECK-UNKNOWN: 27 0c 85 02 <unknown>
