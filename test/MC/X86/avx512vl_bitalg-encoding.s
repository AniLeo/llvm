// RUN: llvm-mc -triple x86_64-unknown-unknown -mcpu=knl -mattr=+avx512vl,+avx512bitalg --show-encoding < %s | FileCheck %s

// CHECK: vpopcntb %xmm23, %xmm21
// CHECK: encoding: [0x62,0xa2,0x7d,0x08,0x54,0xef]
          vpopcntb %xmm23, %xmm21

// CHECK: vpopcntw %xmm23, %xmm21
// CHECK: encoding: [0x62,0xa2,0xfd,0x08,0x54,0xef]
          vpopcntw %xmm23, %xmm21

// CHECK: vpopcntb %xmm3, %xmm1 {%k2}
// CHECK: encoding: [0x62,0xf2,0x7d,0x0a,0x54,0xcb]
          vpopcntb %xmm3, %xmm1 {%k2}

// CHECK: vpopcntw %xmm3, %xmm1 {%k2}
// CHECK: encoding: [0x62,0xf2,0xfd,0x0a,0x54,0xcb]
          vpopcntw %xmm3, %xmm1 {%k2}

// CHECK: vpopcntb  (%rcx), %xmm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x08,0x54,0x09]
          vpopcntb  (%rcx), %xmm1

// CHECK: vpopcntb  -64(%rsp), %xmm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x08,0x54,0x4c,0x24,0xfc]
          vpopcntb  -64(%rsp), %xmm1

// CHECK: vpopcntb  64(%rsp), %xmm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x08,0x54,0x4c,0x24,0x04]
          vpopcntb  64(%rsp), %xmm1

// CHECK: vpopcntb  268435456(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x08,0x54,0x8c,0xf1,0x00,0x00,0x00,0x10]
          vpopcntb  268435456(%rcx,%r14,8), %xmm1

// CHECK: vpopcntb  -536870912(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x08,0x54,0x8c,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntb  -536870912(%rcx,%r14,8), %xmm1

// CHECK: vpopcntb  -536870910(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x08,0x54,0x8c,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntb  -536870910(%rcx,%r14,8), %xmm1

// CHECK: vpopcntw  (%rcx), %xmm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x08,0x54,0x09]
          vpopcntw  (%rcx), %xmm1

// CHECK: vpopcntw  -64(%rsp), %xmm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x08,0x54,0x4c,0x24,0xfc]
          vpopcntw  -64(%rsp), %xmm1

// CHECK: vpopcntw  64(%rsp), %xmm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x08,0x54,0x4c,0x24,0x04]
          vpopcntw  64(%rsp), %xmm1

// CHECK: vpopcntw  268435456(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x08,0x54,0x8c,0xf1,0x00,0x00,0x00,0x10]
          vpopcntw  268435456(%rcx,%r14,8), %xmm1

// CHECK: vpopcntw  -536870912(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x08,0x54,0x8c,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntw  -536870912(%rcx,%r14,8), %xmm1

// CHECK: vpopcntw  -536870910(%rcx,%r14,8), %xmm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x08,0x54,0x8c,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntw  -536870910(%rcx,%r14,8), %xmm1

// CHECK: vpopcntb  (%rcx), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x0a,0x54,0x29]
          vpopcntb  (%rcx), %xmm21 {%k2}

// CHECK: vpopcntb  -64(%rsp), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x0a,0x54,0x6c,0x24,0xfc]
          vpopcntb  -64(%rsp), %xmm21 {%k2}

// CHECK: vpopcntb  64(%rsp), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x0a,0x54,0x6c,0x24,0x04]
          vpopcntb  64(%rsp), %xmm21 {%k2}

// CHECK: vpopcntb  268435456(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x0a,0x54,0xac,0xf1,0x00,0x00,0x00,0x10]
          vpopcntb  268435456(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntb  -536870912(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x0a,0x54,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntb  -536870912(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntb  -536870910(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x0a,0x54,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntb  -536870910(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntw  (%rcx), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x0a,0x54,0x29]
          vpopcntw  (%rcx), %xmm21 {%k2}

// CHECK: vpopcntw  -64(%rsp), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x0a,0x54,0x6c,0x24,0xfc]
          vpopcntw  -64(%rsp), %xmm21 {%k2}

// CHECK: vpopcntw  64(%rsp), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x0a,0x54,0x6c,0x24,0x04]
          vpopcntw  64(%rsp), %xmm21 {%k2}

// CHECK: vpopcntw  268435456(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x0a,0x54,0xac,0xf1,0x00,0x00,0x00,0x10]
          vpopcntw  268435456(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntw  -536870912(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x0a,0x54,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntw  -536870912(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntw  -536870910(%rcx,%r14,8), %xmm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x0a,0x54,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntw  -536870910(%rcx,%r14,8), %xmm21 {%k2}

// CHECK: vpopcntb %ymm23, %ymm21
// CHECK: encoding: [0x62,0xa2,0x7d,0x28,0x54,0xef]
          vpopcntb %ymm23, %ymm21

// CHECK: vpopcntw %ymm23, %ymm21
// CHECK: encoding: [0x62,0xa2,0xfd,0x28,0x54,0xef]
          vpopcntw %ymm23, %ymm21

// CHECK: vpopcntb %ymm3, %ymm1 {%k2}
// CHECK: encoding: [0x62,0xf2,0x7d,0x2a,0x54,0xcb]
          vpopcntb %ymm3, %ymm1 {%k2}

// CHECK: vpopcntw %ymm3, %ymm1 {%k2}
// CHECK: encoding: [0x62,0xf2,0xfd,0x2a,0x54,0xcb]
          vpopcntw %ymm3, %ymm1 {%k2}

// CHECK: vpopcntb  (%rcx), %ymm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x28,0x54,0x09]
          vpopcntb  (%rcx), %ymm1

// CHECK: vpopcntb  -128(%rsp), %ymm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x28,0x54,0x4c,0x24,0xfc]
          vpopcntb  -128(%rsp), %ymm1

// CHECK: vpopcntb  128(%rsp), %ymm1
// CHECK: encoding: [0x62,0xf2,0x7d,0x28,0x54,0x4c,0x24,0x04]
          vpopcntb  128(%rsp), %ymm1

// CHECK: vpopcntb  268435456(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x28,0x54,0x8c,0xf1,0x00,0x00,0x00,0x10]
          vpopcntb  268435456(%rcx,%r14,8), %ymm1

// CHECK: vpopcntb  -536870912(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x28,0x54,0x8c,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntb  -536870912(%rcx,%r14,8), %ymm1

// CHECK: vpopcntb  -536870910(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0x7d,0x28,0x54,0x8c,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntb  -536870910(%rcx,%r14,8), %ymm1

// CHECK: vpopcntw  (%rcx), %ymm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x28,0x54,0x09]
          vpopcntw  (%rcx), %ymm1

// CHECK: vpopcntw  -128(%rsp), %ymm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x28,0x54,0x4c,0x24,0xfc]
          vpopcntw  -128(%rsp), %ymm1

// CHECK: vpopcntw  128(%rsp), %ymm1
// CHECK: encoding: [0x62,0xf2,0xfd,0x28,0x54,0x4c,0x24,0x04]
          vpopcntw  128(%rsp), %ymm1

// CHECK: vpopcntw  268435456(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x28,0x54,0x8c,0xf1,0x00,0x00,0x00,0x10]
          vpopcntw  268435456(%rcx,%r14,8), %ymm1

// CHECK: vpopcntw  -536870912(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x28,0x54,0x8c,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntw  -536870912(%rcx,%r14,8), %ymm1

// CHECK: vpopcntw  -536870910(%rcx,%r14,8), %ymm1
// CHECK: encoding: [0x62,0xb2,0xfd,0x28,0x54,0x8c,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntw  -536870910(%rcx,%r14,8), %ymm1

// CHECK: vpopcntb  (%rcx), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x2a,0x54,0x29]
          vpopcntb  (%rcx), %ymm21 {%k2}

// CHECK: vpopcntb  -128(%rsp), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x2a,0x54,0x6c,0x24,0xfc]
          vpopcntb  -128(%rsp), %ymm21 {%k2}

// CHECK: vpopcntb  128(%rsp), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0x7d,0x2a,0x54,0x6c,0x24,0x04]
          vpopcntb  128(%rsp), %ymm21 {%k2}

// CHECK: vpopcntb  268435456(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x2a,0x54,0xac,0xf1,0x00,0x00,0x00,0x10]
          vpopcntb  268435456(%rcx,%r14,8), %ymm21 {%k2}

// CHECK: vpopcntb  -536870912(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x2a,0x54,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntb  -536870912(%rcx,%r14,8), %ymm21 {%k2}

// CHECK: vpopcntb  -536870910(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0x7d,0x2a,0x54,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntb  -536870910(%rcx,%r14,8), %ymm21 {%k2}

// CHECK: vpopcntw  (%rcx), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x2a,0x54,0x29]
          vpopcntw  (%rcx), %ymm21 {%k2}

// CHECK: vpopcntw  -128(%rsp), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x2a,0x54,0x6c,0x24,0xfc]
          vpopcntw  -128(%rsp), %ymm21 {%k2}

// CHECK: vpopcntw  128(%rsp), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xe2,0xfd,0x2a,0x54,0x6c,0x24,0x04]
          vpopcntw  128(%rsp), %ymm21 {%k2}

// CHECK: vpopcntw  268435456(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x2a,0x54,0xac,0xf1,0x00,0x00,0x00,0x10]
          vpopcntw  268435456(%rcx,%r14,8), %ymm21 {%k2}

// CHECK: vpopcntw  -536870912(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x2a,0x54,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vpopcntw  -536870912(%rcx,%r14,8), %ymm21 {%k2}

// CHECK: vpopcntw  -536870910(%rcx,%r14,8), %ymm21 {%k2}
// CHECK: encoding: [0x62,0xa2,0xfd,0x2a,0x54,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vpopcntw  -536870910(%rcx,%r14,8), %ymm21 {%k2}

