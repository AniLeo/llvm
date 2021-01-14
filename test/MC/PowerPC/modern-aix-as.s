# RUN: llvm-mc -triple powerpc64-unknown-unknown -mattr=+modern-aix-as --show-encoding %s | FileCheck -check-prefix=CHECK-BE %s
# RUN: llvm-mc -triple powerpc64le-unknown-unknown -mattr=+modern-aix-as --show-encoding %s | FileCheck -check-prefix=CHECK-LE %s
# RUN: llvm-mc -triple powerpc64le-unknown-unknown -mattr=-modern-aix-as --show-encoding %s | FileCheck -check-prefix=CHECK-LE %s
# RUN: not llvm-mc -triple powerpc64le-unknown-unknown -mattr=+aix --show-encoding %s 2>&1 | FileCheck -check-prefix=CHECK-OLD %s
##TODO: Replace above with following when implement createXCOFFAsmParser
# UN: llvm-mc -triple powerpc-aix-ibm-xcoff -mattr=+modern-aix-as --show-encoding %s 2>&1 | FileCheck -check-prefix=CHECK-BE %s
# UN: not llvm-mc -triple powerpc-aix-ibm-xcoff --show-encoding %s 2>&1 | FileCheck -check-prefix=CHECK-OLD %s

# CHECK-BE: mtudscr 2                       # encoding: [0x7c,0x43,0x03,0xa6]
# CHECK-LE: mtudscr 2                       # encoding: [0xa6,0x03,0x43,0x7c]
# CHECK-OLD: instruction use requires an option to be enabled
            mtudscr 2
# CHECK-BE: mfudscr 2                       # encoding: [0x7c,0x43,0x02,0xa6]
# CHECK-LE: mfudscr 2                       # encoding: [0xa6,0x02,0x43,0x7c]
            mfudscr 2

