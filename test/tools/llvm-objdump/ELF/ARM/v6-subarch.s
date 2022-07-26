@ RUN: llvm-mc < %s -triple armv6-elf -filetype=obj | llvm-objdump -d - | FileCheck %s

.arch armv6

umaal:
umaal r0, r1, r2, r3

@ CHECK-LABEL:umaal
@ CHECK: e0410392    umaal r0, r1, r2, r3
