// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s


// ------------------------------------------------------------------------- //
// Invalid element widths.

punpklo p0.b, p0.b
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid predicate register
// CHECK-NEXT: punpklo p0.b, p0.b
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

punpklo p0.s, p0.h
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid predicate register
// CHECK-NEXT: punpklo p0.s, p0.h
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
