// RUN: not llvm-mc -triple x86_64-pc-linux-gnu %s -o - 2>&1 | FileCheck %s

// CHECK: error: symbol is not in a section: foo

        .quad foo
        .section .shf_metadata,"ao",@progbits,foo
