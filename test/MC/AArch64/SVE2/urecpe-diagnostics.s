// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve2  2>&1 < %s| FileCheck %s

// ------------------------------------------------------------------------- //
// Invalid predicate

urecpe z0.s, p0/z, z1.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid operand for instruction
// CHECK-NEXT: urecpe z0.s, p0/z, z1.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

urecpe z0.s, p8/m, z1.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: urecpe z0.s, p8/m, z1.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// ------------------------------------------------------------------------- //
// Invalid element width

urecpe z0.b, p7/m, z1.b
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: urecpe z0.b, p7/m, z1.b
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

urecpe z0.h, p7/m, z1.h
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: urecpe z0.h, p7/m, z1.h
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

urecpe z0.d, p7/m, z1.d
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: urecpe z0.d, p7/m, z1.d
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
