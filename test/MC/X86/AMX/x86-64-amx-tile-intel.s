// RUN: llvm-mc -triple x86_64-unknown-unknown -x86-asm-syntax=intel -output-asm-variant=1 --show-encoding %s | FileCheck %s

// CHECK: tilerelease
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0xc0]
          tilerelease

// CHECK: tilezero tmm6
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xf0]
          tilezero tmm6

// CHECK: tilezero tmm3
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xd8]
          tilezero tmm3

// CHECK: tilerelease
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0xc0]
          tilerelease

// CHECK: tilezero tmm6
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xf0]
          tilezero tmm6

// CHECK: tilezero tmm3
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xd8]
          tilezero tmm3

// CHECK: ldtilecfg [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x78,0x49,0x84,0xf5,0x00,0x00,0x00,0x10]
          ldtilecfg [rbp + 8*r14 + 268435456]

// CHECK: ldtilecfg [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x78,0x49,0x84,0x80,0x23,0x01,0x00,0x00]
          ldtilecfg [r8 + 4*rax + 291]

// CHECK: ldtilecfg [rip]
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0x05,0x00,0x00,0x00,0x00]
          ldtilecfg [rip]

// CHECK: ldtilecfg [2*rbp - 2048]
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0x04,0x6d,0x00,0xf8,0xff,0xff]
          ldtilecfg [2*rbp - 2048]

// CHECK: sttilecfg [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x79,0x49,0x84,0xf5,0x00,0x00,0x00,0x10]
          sttilecfg [rbp + 8*r14 + 268435456]

// CHECK: sttilecfg [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x79,0x49,0x84,0x80,0x23,0x01,0x00,0x00]
          sttilecfg [r8 + 4*rax + 291]

// CHECK: sttilecfg [rip]
// CHECK: encoding: [0xc4,0xe2,0x79,0x49,0x05,0x00,0x00,0x00,0x00]
          sttilecfg [rip]

// CHECK: sttilecfg [2*rbp - 2048]
// CHECK: encoding: [0xc4,0xe2,0x79,0x49,0x04,0x6d,0x00,0xf8,0xff,0xff]
          sttilecfg [2*rbp - 2048]

// CHECK: tileloadd tmm6, [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x7b,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tileloadd tmm6, [rbp + 8*r14 + 268435456]

// CHECK: tileloadd tmm3, [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x7b,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tileloadd tmm3, [r8 + 4*rax + 291]

// CHECK: tileloadd tmm3, [2*rbp - 32]
// CHECK: encoding: [0xc4,0xe2,0x7b,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tileloadd tmm3, [2*rbp - 32]

// CHECK: tileloadd tmm4, [rbx + 64]
// CHECK: encoding: [0xc4,0xe2,0x7b,0x4b,0x64,0x23,0x40]
          tileloadd tmm4, [rbx + 64]

// CHECK: tileloaddt1 tmm6, [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x79,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tileloaddt1 tmm6, [rbp + 8*r14 + 268435456]

// CHECK: tileloaddt1 tmm3, [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x79,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tileloaddt1 tmm3, [r8 + 4*rax + 291]

// CHECK: tileloaddt1 tmm3, [2*rbp - 32]
// CHECK: encoding: [0xc4,0xe2,0x79,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tileloaddt1 tmm3, [2*rbp - 32]

// CHECK: tileloaddt1     tmm6, [rbp + 16]
// CHECK: encoding: [0xc4,0xe2,0x79,0x4b,0x74,0x25,0x10]
          tileloaddt1     tmm6, [rbp + 16]

// CHECK: tilerelease
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0xc0]
          tilerelease

// CHECK: tilestored [rbp + 8*r14 + 268435456], tmm6
// CHECK: encoding: [0xc4,0xa2,0x7a,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tilestored [rbp + 8*r14 + 268435456], tmm6

// CHECK: tilestored [r8 + 4*rax + 291], tmm3
// CHECK: encoding: [0xc4,0xc2,0x7a,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tilestored [r8 + 4*rax + 291], tmm3

// CHECK: tilestored [2*rbp - 32], tmm3
// CHECK: encoding: [0xc4,0xe2,0x7a,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tilestored [2*rbp - 32], tmm3

// CHECK: tilestored [r8], tmm3
// CHECK: encoding: [0xc4,0xc2,0x7a,0x4b,0x1c,0x20]
          tilestored [r8], tmm3

// CHECK: tilezero tmm6
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xf0]
          tilezero tmm6

// CHECK: tilezero tmm3
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xd8]
          tilezero tmm3

// CHECK: ldtilecfg [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x78,0x49,0x84,0xf5,0x00,0x00,0x00,0x10]
          ldtilecfg [rbp + 8*r14 + 268435456]

// CHECK: ldtilecfg [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x78,0x49,0x84,0x80,0x23,0x01,0x00,0x00]
          ldtilecfg [r8 + 4*rax + 291]

// CHECK: ldtilecfg [rip]
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0x05,0x00,0x00,0x00,0x00]
          ldtilecfg [rip]

// CHECK: ldtilecfg [2*rbp - 2048]
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0x04,0x6d,0x00,0xf8,0xff,0xff]
          ldtilecfg [2*rbp - 2048]

// CHECK: sttilecfg [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x79,0x49,0x84,0xf5,0x00,0x00,0x00,0x10]
          sttilecfg [rbp + 8*r14 + 268435456]

// CHECK: sttilecfg [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x79,0x49,0x84,0x80,0x23,0x01,0x00,0x00]
          sttilecfg [r8 + 4*rax + 291]

// CHECK: sttilecfg [rip]
// CHECK: encoding: [0xc4,0xe2,0x79,0x49,0x05,0x00,0x00,0x00,0x00]
          sttilecfg [rip]

// CHECK: sttilecfg [2*rbp - 2048]
// CHECK: encoding: [0xc4,0xe2,0x79,0x49,0x04,0x6d,0x00,0xf8,0xff,0xff]
          sttilecfg [2*rbp - 2048]

// CHECK: tileloadd tmm6, [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x7b,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tileloadd tmm6, [rbp + 8*r14 + 268435456]

// CHECK: tileloadd tmm3, [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x7b,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tileloadd tmm3, [r8 + 4*rax + 291]

// CHECK: tileloadd tmm3, [2*rbp - 32]
// CHECK: encoding: [0xc4,0xe2,0x7b,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tileloadd tmm3, [2*rbp - 32]

// CHECK: tileloaddt1 tmm6, [rbp + 8*r14 + 268435456]
// CHECK: encoding: [0xc4,0xa2,0x79,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tileloaddt1 tmm6, [rbp + 8*r14 + 268435456]

// CHECK: tileloaddt1 tmm3, [r8 + 4*rax + 291]
// CHECK: encoding: [0xc4,0xc2,0x79,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tileloaddt1 tmm3, [r8 + 4*rax + 291]

// CHECK: tileloaddt1 tmm3, [2*rbp - 32]
// CHECK: encoding: [0xc4,0xe2,0x79,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tileloaddt1 tmm3, [2*rbp - 32]

// CHECK: tilerelease
// CHECK: encoding: [0xc4,0xe2,0x78,0x49,0xc0]
          tilerelease

// CHECK: tilestored [rbp + 8*r14 + 268435456], tmm6
// CHECK: encoding: [0xc4,0xa2,0x7a,0x4b,0xb4,0xf5,0x00,0x00,0x00,0x10]
          tilestored [rbp + 8*r14 + 268435456], tmm6

// CHECK: tilestored [r8 + 4*rax + 291], tmm3
// CHECK: encoding: [0xc4,0xc2,0x7a,0x4b,0x9c,0x80,0x23,0x01,0x00,0x00]
          tilestored [r8 + 4*rax + 291], tmm3

// CHECK: tilestored [2*rbp - 32], tmm3
// CHECK: encoding: [0xc4,0xe2,0x7a,0x4b,0x1c,0x6d,0xe0,0xff,0xff,0xff]
          tilestored [2*rbp - 32], tmm3

// CHECK: tilezero tmm6
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xf0]
          tilezero tmm6

// CHECK: tilezero tmm3
// CHECK: encoding: [0xc4,0xe2,0x7b,0x49,0xd8]
          tilezero tmm3
