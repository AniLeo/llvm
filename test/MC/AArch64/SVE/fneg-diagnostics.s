// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s

// ------------------------------------------------------------------------- //
// Invalid predicate

fneg    z31.h, p8/m, z31.h
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid restricted predicate register, expected p0..p7 (without element suffix)
// CHECK-NEXT: fneg    z31.h, p8/m, z31.h
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:


// ------------------------------------------------------------------------- //
// Invalid element width

fneg    z31.b, p7/m, z31.b
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: fneg    z31.b, p7/m, z31.b
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

fneg    z31.h, p7/m, z31.s
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid element width
// CHECK-NEXT: fneg    z31.h, p7/m, z31.s
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
