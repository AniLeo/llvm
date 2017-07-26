; RUN: llvm-mc -triple aarch64-windows -filetype obj -o %t.obj %s
; RUN: llvm-readobj -r %t.obj | FileCheck %s
; RUN: llvm-objdump -d %t.obj | FileCheck %s -check-prefix DISASM

; IMAGE_REL_ARM64_ADDR32
.Linfo_foo:
  .asciz "foo"
  .long foo

; IMAGE_REL_ARM64_ADDR32NB
.long func@IMGREL

; IMAGE_REL_ARM64_ADDR64
.globl struc
struc:
  .quad arr

; IMAGE_REL_ARM64_BRANCH26
b target

; IMAGE_REL_ARM64_PAGEBASE_REL21
adrp x0, foo

; IMAGE_REL_ARM64_PAGEOFFSET_12A
add x0, x0, :lo12:foo

; IMAGE_REL_ARM64_PAGEOFFSET_12L
ldr x0, [x0, :lo12:foo]

; IMAGE_REL_ARM64_PAGEBASE_REL21, even if the symbol offset is known
adrp x0, bar
bar:

; IMAGE_REL_ARM64_SECREL
.secrel32 .Linfo_bar
.Linfo_bar:

; IMAGE_REL_ARM64_SECTION
.secidx func

.align 2
adrp x0, baz + 0x12345
baz:
add x0, x0, :lo12:foo + 0x12345
ldrb w0, [x0, :lo12:foo + 0x12345]
ldr x0, [x0, :lo12:foo + 0x12348]

; CHECK: Format: COFF-ARM64
; CHECK: Arch: aarch64
; CHECK: AddressSize: 64bit
; CHECK: Relocations [
; CHECK:   Section (1) .text {
; CHECK: 0x4 IMAGE_REL_ARM64_ADDR32 foo
; CHECK: 0x8 IMAGE_REL_ARM64_ADDR32NB func
; CHECK: 0xC IMAGE_REL_ARM64_ADDR64 arr
; CHECK: 0x14 IMAGE_REL_ARM64_BRANCH26 target
; CHECK: 0x18 IMAGE_REL_ARM64_PAGEBASE_REL21 foo
; CHECK: 0x1C IMAGE_REL_ARM64_PAGEOFFSET_12A foo
; CHECK: 0x20 IMAGE_REL_ARM64_PAGEOFFSET_12L foo
; CHECK: 0x24 IMAGE_REL_ARM64_PAGEBASE_REL21 bar
; CHECK: 0x28 IMAGE_REL_ARM64_SECREL .text
; CHECK: 0x2C IMAGE_REL_ARM64_SECTION func
; CHECK: 0x30 IMAGE_REL_ARM64_PAGEBASE_REL21 baz
; CHECK: 0x34 IMAGE_REL_ARM64_PAGEOFFSET_12A foo
; CHECK: 0x38 IMAGE_REL_ARM64_PAGEOFFSET_12L foo
; CHECK: 0x3C IMAGE_REL_ARM64_PAGEOFFSET_12L foo
; CHECK:   }
; CHECK: ]

; DISASM: 30:       20 1a 09 b0     adrp    x0, #305418240
; DISASM: 34:       00 14 0d 91     add     x0, x0, #837
; DISASM: 38:       00 14 4d 39     ldrb    w0, [x0, #837]
; DISASM: 3c:       00 a4 41 f9     ldr     x0, [x0, #840]
