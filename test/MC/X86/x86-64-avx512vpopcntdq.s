// RUN: llvm-mc -triple x86_64-unknown-unknown -mattr=+avx512vpopcntdq --show-encoding %s | FileCheck %s

// CHECK: vpopcntq   %zmm25, %zmm20  
// CHECK: encoding: [0x62,0x82,0xfd,0x48,0x55,0xe1]
          vpopcntq   %zmm25, %zmm20  

// CHECK: vpopcntq   %zmm25, %zmm20 {%k6} 
// CHECK: encoding: [0x62,0x82,0xfd,0x4e,0x55,0xe1]
          vpopcntq   %zmm25, %zmm20 {%k6} 

// CHECK: vpopcntq   %zmm25, %zmm20 {%k6} {z} 
// CHECK: encoding: [0x62,0x82,0xfd,0xce,0x55,0xe1]
          vpopcntq   %zmm25, %zmm20 {%k6} {z} 

// CHECK: vpopcntq   (%rcx), %zmm20  
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x21]
          vpopcntq   (%rcx), %zmm20  

// CHECK: vpopcntq   291(%rax,%r14,8), %zmm20 
// CHECK: encoding: [0x62,0xa2,0xfd,0x48,0x55,0xa4,0xf0,0x23,0x01,0x00,0x00]
          vpopcntq   291(%rax,%r14,8), %zmm20 

// CHECK: vpopcntq   (%rcx){1to8}, %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x21]
          vpopcntq   (%rcx){1to8}, %zmm20 

// CHECK: vpopcntq   4064(%rdx), %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0xa2,0xe0,0x0f,0x00,0x00]
          vpopcntq   4064(%rdx), %zmm20 

// CHECK: vpopcntq   4096(%rdx), %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x62,0x40]
          vpopcntq   4096(%rdx), %zmm20 

// CHECK: vpopcntq   -4096(%rdx), %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x62,0xc0]
          vpopcntq   -4096(%rdx), %zmm20 

// CHECK: vpopcntq   -4128(%rdx), %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0xa2,0xe0,0xef,0xff,0xff]
          vpopcntq   -4128(%rdx), %zmm20 

// CHECK: vpopcntq   1016(%rdx){1to8}, %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x62,0x7f]
          vpopcntq   1016(%rdx){1to8}, %zmm20 

// CHECK: vpopcntq   1024(%rdx){1to8}, %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0xa2,0x00,0x04,0x00,0x00]
          vpopcntq   1024(%rdx){1to8}, %zmm20 

// CHECK: vpopcntq   -1024(%rdx){1to8}, %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x62,0x80]
          vpopcntq   -1024(%rdx){1to8}, %zmm20 

// CHECK: vpopcntq   -1032(%rdx){1to8}, %zmm20 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0xa2,0xf8,0xfb,0xff,0xff]
          vpopcntq   -1032(%rdx){1to8}, %zmm20 

// CHECK: vpopcntq   %zmm21, %zmm17  
// CHECK: encoding: [0x62,0xa2,0xfd,0x48,0x55,0xcd]
          vpopcntq   %zmm21, %zmm17  

// CHECK: vpopcntq   %zmm21, %zmm17 {%k6} 
// CHECK: encoding: [0x62,0xa2,0xfd,0x4e,0x55,0xcd]
          vpopcntq   %zmm21, %zmm17 {%k6} 

// CHECK: vpopcntq   %zmm21, %zmm17 {%k6} {z} 
// CHECK: encoding: [0x62,0xa2,0xfd,0xce,0x55,0xcd]
          vpopcntq   %zmm21, %zmm17 {%k6} {z} 

// CHECK: vpopcntq   (%rcx), %zmm17  
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x09]
          vpopcntq   (%rcx), %zmm17  

// CHECK: vpopcntq   4660(%rax,%r14,8), %zmm17 
// CHECK: encoding: [0x62,0xa2,0xfd,0x48,0x55,0x8c,0xf0,0x34,0x12,0x00,0x00]
          vpopcntq   4660(%rax,%r14,8), %zmm17 

// CHECK: vpopcntq   (%rcx){1to8}, %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x09]
          vpopcntq   (%rcx){1to8}, %zmm17 

// CHECK: vpopcntq   4064(%rdx), %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x8a,0xe0,0x0f,0x00,0x00]
          vpopcntq   4064(%rdx), %zmm17 

// CHECK: vpopcntq   4096(%rdx), %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x4a,0x40]
          vpopcntq   4096(%rdx), %zmm17 

// CHECK: vpopcntq   -4096(%rdx), %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x4a,0xc0]
          vpopcntq   -4096(%rdx), %zmm17 

// CHECK: vpopcntq   -4128(%rdx), %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x48,0x55,0x8a,0xe0,0xef,0xff,0xff]
          vpopcntq   -4128(%rdx), %zmm17 

// CHECK: vpopcntq   1016(%rdx){1to8}, %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x4a,0x7f]
          vpopcntq   1016(%rdx){1to8}, %zmm17 

// CHECK: vpopcntq   1024(%rdx){1to8}, %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x8a,0x00,0x04,0x00,0x00]
          vpopcntq   1024(%rdx){1to8}, %zmm17 

// CHECK: vpopcntq   -1024(%rdx){1to8}, %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x4a,0x80]
          vpopcntq   -1024(%rdx){1to8}, %zmm17 

// CHECK: vpopcntq   -1032(%rdx){1to8}, %zmm17 
// CHECK: encoding: [0x62,0xe2,0xfd,0x58,0x55,0x8a,0xf8,0xfb,0xff,0xff]
          vpopcntq   -1032(%rdx){1to8}, %zmm17 

// CHECK: vpopcntd   %zmm19, %zmm25  
// CHECK: encoding: [0x62,0x22,0x7d,0x48,0x55,0xcb]
          vpopcntd   %zmm19, %zmm25  

// CHECK: vpopcntd   %zmm19, %zmm25 {%k4} 
// CHECK: encoding: [0x62,0x22,0x7d,0x4c,0x55,0xcb]
          vpopcntd   %zmm19, %zmm25 {%k4} 

// CHECK: vpopcntd   %zmm19, %zmm25 {%k4} {z} 
// CHECK: encoding: [0x62,0x22,0x7d,0xcc,0x55,0xcb]
          vpopcntd   %zmm19, %zmm25 {%k4} {z} 

// CHECK: vpopcntd   (%rcx), %zmm25  
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x09]
          vpopcntd   (%rcx), %zmm25  

// CHECK: vpopcntd   291(%rax,%r14,8), %zmm25 
// CHECK: encoding: [0x62,0x22,0x7d,0x48,0x55,0x8c,0xf0,0x23,0x01,0x00,0x00]
          vpopcntd   291(%rax,%r14,8), %zmm25 

// CHECK: vpopcntd   (%rcx){1to16}, %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x09]
          vpopcntd   (%rcx){1to16}, %zmm25

// CHECK: vpopcntd   4064(%rdx), %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x8a,0xe0,0x0f,0x00,0x00]
          vpopcntd   4064(%rdx), %zmm25 

// CHECK: vpopcntd   4096(%rdx), %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x4a,0x40]
          vpopcntd   4096(%rdx), %zmm25 

// CHECK: vpopcntd   -4096(%rdx), %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x4a,0xc0]
          vpopcntd   -4096(%rdx), %zmm25 

// CHECK: vpopcntd   -4128(%rdx), %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x8a,0xe0,0xef,0xff,0xff]
          vpopcntd   -4128(%rdx), %zmm25 

// CHECK: vpopcntd   508(%rdx){1to16}, %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x4a,0x7f]
          vpopcntd   508(%rdx){1to16}, %zmm25 

// CHECK: vpopcntd   512(%rdx){1to16}, %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x8a,0x00,0x02,0x00,0x00]
          vpopcntd   512(%rdx){1to16}, %zmm25 

// CHECK: vpopcntd   -512(%rdx){1to16}, %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x4a,0x80]
          vpopcntd   -512(%rdx){1to16}, %zmm25 

// CHECK: vpopcntd   -516(%rdx){1to16}, %zmm25 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x8a,0xfc,0xfd,0xff,0xff]
          vpopcntd   -516(%rdx){1to16}, %zmm25 

// CHECK: vpopcntd   %zmm21, %zmm26  
// CHECK: encoding: [0x62,0x22,0x7d,0x48,0x55,0xd5]
          vpopcntd   %zmm21, %zmm26  

// CHECK: vpopcntd   %zmm21, %zmm26 {%k4} 
// CHECK: encoding: [0x62,0x22,0x7d,0x4c,0x55,0xd5]
          vpopcntd   %zmm21, %zmm26 {%k4} 

// CHECK: vpopcntd   %zmm21, %zmm26 {%k4} {z} 
// CHECK: encoding: [0x62,0x22,0x7d,0xcc,0x55,0xd5]
          vpopcntd   %zmm21, %zmm26 {%k4} {z} 

// CHECK: vpopcntd   (%rcx), %zmm26  
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x11]
          vpopcntd   (%rcx), %zmm26  

// CHECK: vpopcntd   4660(%rax,%r14,8), %zmm26 
// CHECK: encoding: [0x62,0x22,0x7d,0x48,0x55,0x94,0xf0,0x34,0x12,0x00,0x00]
          vpopcntd   4660(%rax,%r14,8), %zmm26 

// CHECK: vpopcntd   (%rcx){1to16}, %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x11]
          vpopcntd   (%rcx){1to16}, %zmm26 

// CHECK: vpopcntd   4064(%rdx), %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x92,0xe0,0x0f,0x00,0x00]
          vpopcntd   4064(%rdx), %zmm26 

// CHECK: vpopcntd   4096(%rdx), %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x52,0x40]
          vpopcntd   4096(%rdx), %zmm26 

// CHECK: vpopcntd   -4096(%rdx), %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x52,0xc0]
          vpopcntd   -4096(%rdx), %zmm26 

// CHECK: vpopcntd   -4128(%rdx), %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x48,0x55,0x92,0xe0,0xef,0xff,0xff]
          vpopcntd   -4128(%rdx), %zmm26 

// CHECK: vpopcntd   508(%rdx){1to16}, %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x52,0x7f]
          vpopcntd   508(%rdx){1to16}, %zmm26 

// CHECK: vpopcntd   512(%rdx){1to16}, %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x92,0x00,0x02,0x00,0x00]
          vpopcntd   512(%rdx){1to16}, %zmm26 

// CHECK: vpopcntd   -512(%rdx){1to16}, %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x52,0x80]
          vpopcntd   -512(%rdx){1to16}, %zmm26 

// CHECK: vpopcntd   -516(%rdx){1to16}, %zmm26 
// CHECK: encoding: [0x62,0x62,0x7d,0x58,0x55,0x92,0xfc,0xfd,0xff,0xff]
          vpopcntd   -516(%rdx){1to16}, %zmm26 
