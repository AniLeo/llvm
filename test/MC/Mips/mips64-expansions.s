# RUN: llvm-mc %s -triple=mips64el-unknown-linux -show-encoding -mcpu=mips64r2 | FileCheck %s

# Check that signed negative 32-bit immediates are loaded correctly:
  li $10, ~(0x101010)
# CHECK: lui $10, 65519        # encoding: [0xef,0xff,0x0a,0x3c]
# CHECK: ori $10, $10, 61423   # encoding: [0xef,0xef,0x4a,0x35]
# CHECK-NOT: dsll

# Test bne with an immediate as the 2nd operand.
  bne $2, 0x100010001, 1332
# CHECK: addiu $1, $zero, 1         # encoding: [0x01,0x00,0x01,0x24]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: bne  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x14]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  bne $2, 0x1000100010001, 1332
# CHECK: lui  $1, 1                 # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: bne  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x14]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  bne $2, -0x100010001, 1332
# CHECK: addiu $1, $zero, -2        # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535         # encoding: [0xff,0xff,0x21,0x34]
# CHECK: bne  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x14]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  bne $2, -0x1000100010001, 1332
# CHECK: lui  $1, 65534             # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535         # encoding: [0xff,0xff,0x21,0x34]
# CHECK: bne  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x14]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

# Test beq with an immediate as the 2nd operand.
  beq $2, 0x100010001, 1332
# CHECK: addiu $1, $zero, 1         # encoding: [0x01,0x00,0x01,0x24]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: beq  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x10]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  beq $2, 0x1000100010001, 1332
# CHECK: lui  $1, 1                 # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: beq  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x10]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  beq $2, -0x100010001, 1332
# CHECK: addiu $1, $zero, -2        # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535         # encoding: [0xff,0xff,0x21,0x34]
# CHECK: beq  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x10]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

  beq $2, -0x1000100010001, 1332
# CHECK: lui  $1, 65534             # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534         # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535         # encoding: [0xff,0xff,0x21,0x34]
# CHECK: beq  $2, $1, 1332          # encoding: [0x4d,0x01,0x41,0x10]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

# Test one with a symbol in the third operand.
sym:
  bne $2, 0x100010001, sym
# CHECK: addiu $1, $zero, 1         # encoding: [0x01,0x00,0x01,0x24]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16            # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1             # encoding: [0x01,0x00,0x21,0x34]
# CHECK: bne  $2, $1, sym           # encoding: [A,A,0x41,0x14]
# CHECK: nop                        # encoding: [0x00,0x00,0x00,0x00]

# Test ulhu with 64-bit immediate addresses.
  ulhu $8, 0x100010001
# CHECK: addiu $1, $zero, 1    # encoding: [0x01,0x00,0x01,0x24]
# CHECK: ori  $1, $1, 1        # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1        # encoding: [0x01,0x00,0x21,0x34]
# CHECK: lbu  $8, 1($1)        # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu  $1, 0($1)        # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll  $8, $8, 8        # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or   $8, $8, $1       # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, 0x1000100010001
# CHECK: lui  $1, 1            # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori  $1, $1, 1        # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1        # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1        # encoding: [0x01,0x00,0x21,0x34]
# CHECK: lbu  $8, 1($1)        # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu  $1, 0($1)        # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll  $8, $8, 8        # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or   $8, $8, $1       # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, -0x100010001
# CHECK: addiu $1, $zero, -2   # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534    # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535    # encoding: [0xff,0xff,0x21,0x34]
# CHECK: lbu  $8, 1($1)        # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu  $1, 0($1)        # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll  $8, $8, 8        # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or   $8, $8, $1       # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, -0x1000100010001
# CHECK: lui  $1, 65534        # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori  $1, $1, 65534    # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534    # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16       # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535    # encoding: [0xff,0xff,0x21,0x34]
# CHECK: lbu  $8, 1($1)        # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu  $1, 0($1)        # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll  $8, $8, 8        # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or   $8, $8, $1       # encoding: [0x25,0x40,0x01,0x01]

# Test ulhu with source register and 64-bit immediate offset.
  ulhu $8, 0x100010001($9)
# CHECK: addiu $1, $zero, 1    # encoding: [0x01,0x00,0x01,0x24]
# CHECK: ori   $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: daddu $1, $1, $9      # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lbu   $8, 1($1)       # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu   $1, 0($1)       # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll   $8, $8, 8       # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or    $8, $8, $1      # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, 0x1000100010001($9)
# CHECK: lui   $1, 1           # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori   $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: daddu $1, $1, $9      # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lbu   $8, 1($1)       # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu   $1, 0($1)       # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll   $8, $8, 8       # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or    $8, $8, $1      # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, -0x100010001($9)
# CHECK: addiu $1, $zero, -2   # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: daddu $1, $1, $9      # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lbu   $8, 1($1)       # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu   $1, 0($1)       # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll   $8, $8, 8       # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or    $8, $8, $1      # encoding: [0x25,0x40,0x01,0x01]

  ulhu $8, -0x1000100010001($9)
# CHECK: lui   $1, 65534       # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori   $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65535   # encoding: [0xff,0xff,0x21,0x34]
# CHECK: daddu $1, $1, $9      # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lbu   $8, 1($1)       # encoding: [0x01,0x00,0x28,0x90]
# CHECK: lbu   $1, 0($1)       # encoding: [0x00,0x00,0x21,0x90]
# CHECK: sll   $8, $8, 8       # encoding: [0x00,0x42,0x08,0x00]
# CHECK: or    $8, $8, $1      # encoding: [0x25,0x40,0x01,0x01]

# Test ulw with 64-bit immediate addresses.
  ulw $8, 0x100010001
# CHECK: addiu $1, $zero, 1   # encoding: [0x01,0x00,0x01,0x24]
# CHECK: ori  $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: lwl  $8, 3($1)       # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr  $8, 0($1)       # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, 0x1000100010001
# CHECK: lui  $1, 1           # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori  $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 1       # encoding: [0x01,0x00,0x21,0x34]
# CHECK: lwl  $8, 3($1)       # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr  $8, 0($1)       # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, -0x100010001
# CHECK: addiu $1, $zero, -2  # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535   # encoding: [0xff,0xff,0x21,0x34]
# CHECK: lwl  $8, 3($1)       # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr  $8, 0($1)       # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, -0x1000100010001
# CHECK: lui  $1, 65534       # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori  $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65534   # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll $1, $1, 16      # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori  $1, $1, 65535   # encoding: [0xff,0xff,0x21,0x34]
# CHECK: lwl  $8, 3($1)       # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr  $8, 0($1)       # encoding: [0x00,0x00,0x28,0x98]

# Test ulw with source register and 64-bit immediate offset.
  ulw $8, 0x100010001($9)
# CHECK: addiu $1, $zero, 1   # encoding: [0x01,0x00,0x01,0x24]
# CHECK: ori   $1, $1, 1      # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1      # encoding: [0x01,0x00,0x21,0x34]
# CHECK: daddu $1, $1, $9     # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lwl   $8, 3($1)      # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr   $8, 0($1)      # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, 0x1000100010001($9)
# CHECK: lui   $1, 1          # encoding: [0x01,0x00,0x01,0x3c]
# CHECK: ori   $1, $1, 1      # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1      # encoding: [0x01,0x00,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 1      # encoding: [0x01,0x00,0x21,0x34]
# CHECK: daddu $1, $1, $9     # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lwl   $8, 3($1)      # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr   $8, 0($1)      # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, -0x100010001($9)
# CHECK: addiu $1, $zero, -2  # encoding: [0xfe,0xff,0x01,0x24]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65534  # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65535  # encoding: [0xff,0xff,0x21,0x34]
# CHECK: daddu $1, $1, $9     # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lwl   $8, 3($1)      # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr   $8, 0($1)      # encoding: [0x00,0x00,0x28,0x98]

  ulw $8, -0x1000100010001($9)
# CHECK: lui   $1, 65534      # encoding: [0xfe,0xff,0x01,0x3c]
# CHECK: ori   $1, $1, 65534  # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65534  # encoding: [0xfe,0xff,0x21,0x34]
# CHECK: dsll  $1, $1, 16     # encoding: [0x38,0x0c,0x01,0x00]
# CHECK: ori   $1, $1, 65535  # encoding: [0xff,0xff,0x21,0x34]
# CHECK: daddu $1, $1, $9     # encoding: [0x2d,0x08,0x29,0x00]
# CHECK: lwl   $8, 3($1)      # encoding: [0x03,0x00,0x28,0x88]
# CHECK: lwr   $8, 0($1)      # encoding: [0x00,0x00,0x28,0x98]

# Test lb/sb/ld/sd/lld with offsets exceeding 16-bits in size.

    ld  $4, 0x8000
# CHECK:      lui     $4, 1
# CHECK-NEXT: ld      $4, -32768($4)

    ld  $4, 0x20008($3)
# CHECK:      lui     $4, 2
# CHECK-NEXT: addu    $4, $4, $3
# CHECK-NEXT: ld      $4, 8($4)

    ld  $4,0x100010004
# CHECK:      addiu   $4, $zero, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ld      $4, 4($4)

    ld  $4,0x1800180018004
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ld      $4, -32764($4)

    ld  $4,0x1800180018004($3)
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: daddu   $4, $4, $3
# CHECK-NEXT: ld      $4, -32764($4)

    sd  $4, 0x8000
# CHECK:      lui     $1, 1
# CHECK-NEXT: sd      $4, -32768($1)

    sd  $4, 0x20008($3)
# CHECK:      lui     $1, 2
# CHECK-NEXT: addu    $1, $1, $3
# CHECK-NEXT: sd      $4, 8($1)

    sd  $4,0x100010004
# CHECK:      addiu   $1, $zero, 1
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 1
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: sd      $4, 4($1)

    sd  $4,0x1800180018004
# CHECK:      lui     $1, 1
# CHECK-NEXT: ori     $1, $1, 32769
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 32770
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: sd      $4, -32764($1)

    sd  $4,0x1800180018004($3)
# CHECK:      lui     $1, 1
# CHECK-NEXT: ori     $1, $1, 32769
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 32770
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: daddu   $1, $1, $3
# CHECK-NEXT: sd      $4, -32764($1)

    lld $4, 0x8000
# CHECK:      lui     $4, 1
# CHECK-NEXT: lld     $4, -32768($4)

    lld $4, 0x20008($3)
# CHECK:      lui     $4, 2
# CHECK-NEXT: addu    $4, $4, $3
# CHECK-NEXT: lld     $4, 8($4)

    lld $4,0x100010004
# CHECK:      addiu   $4, $zero, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lld     $4, 4($4)

    lld $4,0x1800180018004
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lld     $4, -32764($4)

    lld $4,0x1800180018004($3)
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: daddu   $4, $4, $3
# CHECK-NEXT: lld     $4, -32764($4)

    lb  $4,0x100010004
# CHECK:      addiu   $4, $zero, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lb      $4, 4($4)

    lb  $4,0x1800180018004
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lb      $4, -32764($4)

    lb  $4,0x1800180018004($3)
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: daddu   $4, $4, $3
# CHECK-NEXT: lb      $4, -32764($4)

    sb  $4,0x100010004
# CHECK:      addiu   $1, $zero, 1
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 1
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: sb      $4, 4($1)

    sb  $4,0x1800180018004
# CHECK:      lui     $1, 1
# CHECK-NEXT: ori     $1, $1, 32769
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 32770
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: sb      $4, -32764($1)

    sb  $4,0x1800180018004($3)
# CHECK:      lui     $1, 1
# CHECK-NEXT: ori     $1, $1, 32769
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: ori     $1, $1, 32770
# CHECK-NEXT: dsll    $1, $1, 16
# CHECK-NEXT: daddu   $1, $1, $3
# CHECK-NEXT: sb      $4, -32764($1)

    lh  $4,0x100010004
# CHECK:      addiu   $4, $zero, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lh      $4, 4($4)

    lh  $4,0x1800180018004
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lh      $4, -32764($4)

    lh  $4,0x1800180018004($3)
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: daddu   $4, $4, $3
# CHECK-NEXT: lh      $4, -32764($4)

    lhu $4,0x100010004
# CHECK:      addiu   $4, $zero, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 1
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lhu     $4, 4($4)

    lhu $4,0x1800180018004
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: lhu     $4, -32764($4)

    lhu $4,0x1800180018004($3)
# CHECK:      lui     $4, 1
# CHECK-NEXT: ori     $4, $4, 32769
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: ori     $4, $4, 32770
# CHECK-NEXT: dsll    $4, $4, 16
# CHECK-NEXT: daddu   $4, $4, $3
# CHECK-NEXT: lhu     $4, -32764($4)
