// RUN: not llvm-mc -triple=aarch64 -show-encoding -mattr=+sve  2>&1 < %s| FileCheck %s

// --------------------------------------------------------------------------//
// Invalid operand (.b)

ldff1sb z27.b, p7/z, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: invalid operand
// CHECK-NEXT: ldff1sb z27.b, p7/z, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

// --------------------------------------------------------------------------//
// restricted predicate has range [0, 7].

ldff1sb z9.h, p8/z, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: ldff1sb z9.h, p8/z, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ldff1sb z12.s, p8/z, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: ldff1sb z12.s, p8/z, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ldff1sb z4.d, p8/z, [x0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: restricted predicate has range [0, 7].
// CHECK-NEXT: ldff1sb z4.d, p8/z, [x0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

// --------------------------------------------------------------------------//
// Invalid scalar + scalar addressing modes

ldff1sb z0.h, p0/z, [x0, sp]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: register must be x0..x30 or xzr, without shift
// CHECK-NEXT: ldff1sb z0.h, p0/z, [x0, sp]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ldff1sb z0.h, p0/z, [x0, x0, lsl #1]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: register must be x0..x30 or xzr, without shift
// CHECK-NEXT: ldff1sb z0.h, p0/z, [x0, x0, lsl #1]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ldff1sb z0.h, p0/z, [x0, w0]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: register must be x0..x30 or xzr, without shift
// CHECK-NEXT: ldff1sb z0.h, p0/z, [x0, w0]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:

ldff1sb z0.h, p0/z, [x0, w0, uxtw]
// CHECK: [[@LINE-1]]:{{[0-9]+}}: error: register must be x0..x30 or xzr, without shift
// CHECK-NEXT: ldff1sb z0.h, p0/z, [x0, w0, uxtw]
// CHECK-NOT: [[@LINE-1]]:{{[0-9]+}}:
