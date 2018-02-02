// RUN: llvm-mc -triple x86_64-unknown-unknown --show-encoding < %s  | FileCheck %s

// CHECK: vaesenc %zmm3, %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdc,0xeb]
          vaesenc %zmm3, %zmm2, %zmm21

// CHECK: vaesenclast %zmm3, %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdd,0xeb]
          vaesenclast %zmm3, %zmm2, %zmm21

// CHECK: vaesdec %zmm3, %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xde,0xeb]
          vaesdec %zmm3, %zmm2, %zmm21

// CHECK: vaesdeclast %zmm3, %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdf,0xeb]
          vaesdeclast %zmm3, %zmm2, %zmm21

// CHECK: vaesenc  (%rcx), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdc,0x29]
          vaesenc  (%rcx), %zmm2, %zmm21

// CHECK: vaesenc  -256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdc,0x6c,0x24,0xfc]
          vaesenc  -256(%rsp), %zmm2, %zmm21

// CHECK: vaesenc  256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdc,0x6c,0x24,0x04]
          vaesenc  256(%rsp), %zmm2, %zmm21

// CHECK: vaesenc  268435456(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdc,0xac,0xf1,0x00,0x00,0x00,0x10]
          vaesenc  268435456(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesenc  -536870912(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdc,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vaesenc  -536870912(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesenc  -536870910(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdc,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vaesenc  -536870910(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesenclast  (%rcx), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdd,0x29]
          vaesenclast  (%rcx), %zmm2, %zmm21

// CHECK: vaesenclast  -256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdd,0x6c,0x24,0xfc]
          vaesenclast  -256(%rsp), %zmm2, %zmm21

// CHECK: vaesenclast  256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdd,0x6c,0x24,0x04]
          vaesenclast  256(%rsp), %zmm2, %zmm21

// CHECK: vaesenclast  268435456(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdd,0xac,0xf1,0x00,0x00,0x00,0x10]
          vaesenclast  268435456(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesenclast  -536870912(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdd,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vaesenclast  -536870912(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesenclast  -536870910(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdd,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vaesenclast  -536870910(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdec  (%rcx), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xde,0x29]
          vaesdec  (%rcx), %zmm2, %zmm21

// CHECK: vaesdec  -256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xde,0x6c,0x24,0xfc]
          vaesdec  -256(%rsp), %zmm2, %zmm21

// CHECK: vaesdec  256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xde,0x6c,0x24,0x04]
          vaesdec  256(%rsp), %zmm2, %zmm21

// CHECK: vaesdec  268435456(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xde,0xac,0xf1,0x00,0x00,0x00,0x10]
          vaesdec  268435456(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdec  -536870912(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xde,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vaesdec  -536870912(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdec  -536870910(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xde,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vaesdec  -536870910(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdeclast  (%rcx), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdf,0x29]
          vaesdeclast  (%rcx), %zmm2, %zmm21

// CHECK: vaesdeclast  -256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdf,0x6c,0x24,0xfc]
          vaesdeclast  -256(%rsp), %zmm2, %zmm21

// CHECK: vaesdeclast  256(%rsp), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xe2,0x6d,0x48,0xdf,0x6c,0x24,0x04]
          vaesdeclast  256(%rsp), %zmm2, %zmm21

// CHECK: vaesdeclast  268435456(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdf,0xac,0xf1,0x00,0x00,0x00,0x10]
          vaesdeclast  268435456(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdeclast  -536870912(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdf,0xac,0xf1,0x00,0x00,0x00,0xe0]
          vaesdeclast  -536870912(%rcx,%r14,8), %zmm2, %zmm21

// CHECK: vaesdeclast  -536870910(%rcx,%r14,8), %zmm2, %zmm21
// CHECK: encoding: [0x62,0xa2,0x6d,0x48,0xdf,0xac,0xf1,0x02,0x00,0x00,0xe0]
          vaesdeclast  -536870910(%rcx,%r14,8), %zmm2, %zmm21

