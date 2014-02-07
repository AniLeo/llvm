! RUN: llvm-mc %s -arch=sparc   -show-encoding | FileCheck %s
! RUN: llvm-mc %s -arch=sparcv9 -show-encoding | FileCheck %s

        ! CHECK: add %g0, %g0, %g0    ! encoding: [0x80,0x00,0x00,0x00]
        add %g0, %g0, %g0
        ! CHECK: add %g1, %g2, %g3    ! encoding: [0x86,0x00,0x40,0x02]
        add %g1, %g2, %g3
        ! CHECK: add %o0, %o1, %l0    ! encoding: [0xa0,0x02,0x00,0x09]
        add %r8, %r9, %l0
        ! CHECK: add %o0, 10,  %l0    ! encoding: [0xa0,0x02,0x20,0x0a]
        add %o0, 10, %l0

        ! CHECK: addcc %g1, %g2, %g3  ! encoding: [0x86,0x80,0x40,0x02]
        addcc %g1, %g2, %g3

        ! CHECK: addxcc %g1, %g2, %g3 ! encoding: [0x86,0xc0,0x40,0x02]
        addxcc %g1, %g2, %g3

        ! CHECK: udiv %g1, %g2, %g3   ! encoding: [0x86,0x70,0x40,0x02]
        udiv %g1, %g2, %g3

        ! CHECK: sdiv %g1, %g2, %g3   ! encoding: [0x86,0x78,0x40,0x02]
        sdiv %g1, %g2, %g3

        ! CHECK: and %g1, %g2, %g3    ! encoding: [0x86,0x08,0x40,0x02]
        and %g1, %g2, %g3
        ! CHECK: andn %g1, %g2, %g3   ! encoding: [0x86,0x28,0x40,0x02]
        andn %g1, %g2, %g3
        ! CHECK: or %g1, %g2, %g3     ! encoding: [0x86,0x10,0x40,0x02]
        or  %g1, %g2, %g3
        ! CHECK: orn %g1, %g2, %g3    ! encoding: [0x86,0x30,0x40,0x02]
        orn %g1, %g2, %g3
        ! CHECK: xor %g1, %g2, %g3    ! encoding: [0x86,0x18,0x40,0x02]
        xor %g1, %g2, %g3
        ! CHECK: xnor %g1, %g2, %g3   ! encoding: [0x86,0x38,0x40,0x02]
        xnor %g1, %g2, %g3

        ! CHECK: umul %g1, %g2, %g3   ! encoding: [0x86,0x50,0x40,0x02]
        umul %g1, %g2, %g3

        ! CHECK: smul %g1, %g2, %g3   ! encoding: [0x86,0x58,0x40,0x02]
        smul %g1, %g2, %g3

        ! CHECK: nop                  ! encoding: [0x01,0x00,0x00,0x00]
        nop

        ! CHECK: sethi 10, %l0        ! encoding: [0x21,0x00,0x00,0x0a]
        sethi 10, %l0

        ! CHECK: sll %g1, %g2, %g3    ! encoding: [0x87,0x28,0x40,0x02]
        sll %g1, %g2, %g3
        ! CHECK: sll %g1, 31, %g3     ! encoding: [0x87,0x28,0x60,0x1f]
        sll %g1, 31, %g3

        ! CHECK: srl %g1, %g2, %g3    ! encoding: [0x87,0x30,0x40,0x02]
        srl %g1, %g2, %g3
        ! CHECK: srl %g1, 31, %g3     ! encoding: [0x87,0x30,0x60,0x1f]
        srl %g1, 31, %g3

        ! CHECK: sra %g1, %g2, %g3    ! encoding: [0x87,0x38,0x40,0x02]
        sra %g1, %g2, %g3
        ! CHECK: sra %g1, 31, %g3     ! encoding: [0x87,0x38,0x60,0x1f]
        sra %g1, 31, %g3

        ! CHECK: sub %g1, %g2, %g3    ! encoding: [0x86,0x20,0x40,0x02]
        sub %g1, %g2, %g3
        ! CHECK: subcc %g1, %g2, %g3  ! encoding: [0x86,0xa0,0x40,0x02]
        subcc %g1, %g2, %g3

        ! CHECK: subxcc %g1, %g2, %g3 ! encoding: [0x86,0xe0,0x40,0x02]
        subxcc %g1, %g2, %g3

        ! CHECK: or %g0, %g1, %g3     ! encoding: [0x86,0x10,0x00,0x01]
        mov %g1, %g3

        ! CHECK: or %g0, 255, %g3     ! encoding: [0x86,0x10,0x20,0xff]
        mov 0xff, %g3
