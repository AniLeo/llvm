# RUN: llvm-mc -arch=hexagon -mcpu=hexagonv67t  -filetype=obj %s | llvm-objdump --mcpu=hexagonv67t  -d - | FileCheck --implicit-check-not='{' %s



// Warning: This file is auto generated by mktest.py.  Do not edit!
// Created at Wed Aug 22 11:17:37 2018
// Created using:
//  Arch: v67t, commit: 324e85a78e99759c3643d207f9d9b42bbfaf00f6

//  A7_clip
//  Rd32=clip(Rs32,#u5)
    r0=clip(r0,#0)
# CHECK: 88c0c0a0 { r0 = clip(r0,#0) }

//  A7_croundd_ri
//  Rdd32=cround(Rss32,#u6)
    r1:0=cround(r1:0,#0)
# CHECK-NEXT: 8ce0c040 { r1:0 = cround(r1:0,#0) }

//  A7_croundd_rr
//  Rdd32=cround(Rss32,Rt32)
    r1:0=cround(r1:0,r0)
# CHECK-NEXT: c6c0c040 { r1:0 = cround(r1:0,r0) }

//  A7_vclip
//  Rdd32=vclip(Rss32,#u5)
    r1:0=vclip(r1:0,#0)
# CHECK-NEXT: 88c0c0c0 { r1:0 = vclip(r1:0,#0) }

//  M7_dcmpyiw
//  Rdd32=cmpyiw(Rss32,Rtt32)
    r1:0=cmpyiw(r1:0,r1:0)
# CHECK-NEXT: e860c040 { r1:0 = cmpyiw(r1:0,r1:0) }

//  M7_dcmpyiw_acc
//  Rxx32+=cmpyiw(Rss32,Rtt32)
    r1:0+=cmpyiw(r1:0,r1:0)
# CHECK-NEXT: ea60c040 { r1:0 += cmpyiw(r1:0,r1:0) }

//  M7_dcmpyiwc
//  Rdd32=cmpyiw(Rss32,Rtt32*)
    r1:0=cmpyiw(r1:0,r1:0*)
# CHECK-NEXT: e8e0c040 { r1:0 = cmpyiw(r1:0,r1:0*) }

//  M7_dcmpyiwc_acc
//  Rxx32+=cmpyiw(Rss32,Rtt32*)
    r1:0+=cmpyiw(r1:0,r1:0*)
# CHECK-NEXT: ea40c0c0 { r1:0 += cmpyiw(r1:0,r1:0*) }

//  M7_dcmpyrw
//  Rdd32=cmpyrw(Rss32,Rtt32)
    r1:0=cmpyrw(r1:0,r1:0)
# CHECK-NEXT: e880c040 { r1:0 = cmpyrw(r1:0,r1:0) }

//  M7_dcmpyrw_acc
//  Rxx32+=cmpyrw(Rss32,Rtt32)
    r1:0+=cmpyrw(r1:0,r1:0)
# CHECK-NEXT: ea80c040 { r1:0 += cmpyrw(r1:0,r1:0) }

//  M7_dcmpyrwc
//  Rdd32=cmpyrw(Rss32,Rtt32*)
    r1:0=cmpyrw(r1:0,r1:0*)
# CHECK-NEXT: e8c0c040 { r1:0 = cmpyrw(r1:0,r1:0*) }

//  M7_dcmpyrwc_acc
//  Rxx32+=cmpyrw(Rss32,Rtt32*)
    r1:0+=cmpyrw(r1:0,r1:0*)
# CHECK-NEXT: eac0c040 { r1:0 += cmpyrw(r1:0,r1:0*) }

//  M7_wcmpyiw
//  Rd32=cmpyiw(Rss32,Rtt32):<<1:sat
    r0=cmpyiw(r1:0,r1:0):<<1:sat
# CHECK-NEXT: e920c000 { r0 = cmpyiw(r1:0,r1:0):<<1:sat }

//  M7_wcmpyiw_rnd
//  Rd32=cmpyiw(Rss32,Rtt32):<<1:rnd:sat
    r0=cmpyiw(r1:0,r1:0):<<1:rnd:sat
# CHECK-NEXT: e9a0c000 { r0 = cmpyiw(r1:0,r1:0):<<1:rnd:sat }

//  M7_wcmpyiwc
//  Rd32=cmpyiw(Rss32,Rtt32*):<<1:sat
    r0=cmpyiw(r1:0,r1:0*):<<1:sat
# CHECK-NEXT: e900c080 { r0 = cmpyiw(r1:0,r1:0*):<<1:sat }

//  M7_wcmpyiwc_rnd
//  Rd32=cmpyiw(Rss32,Rtt32*):<<1:rnd:sat
    r0=cmpyiw(r1:0,r1:0*):<<1:rnd:sat
# CHECK-NEXT: e980c080 { r0 = cmpyiw(r1:0,r1:0*):<<1:rnd:sat }

//  M7_wcmpyrw
//  Rd32=cmpyrw(Rss32,Rtt32):<<1:sat
    r0=cmpyrw(r1:0,r1:0):<<1:sat
# CHECK-NEXT: e940c000 { r0 = cmpyrw(r1:0,r1:0):<<1:sat }

//  M7_wcmpyrw_rnd
//  Rd32=cmpyrw(Rss32,Rtt32):<<1:rnd:sat
    r0=cmpyrw(r1:0,r1:0):<<1:rnd:sat
# CHECK-NEXT: e9c0c000 { r0 = cmpyrw(r1:0,r1:0):<<1:rnd:sat }

//  M7_wcmpyrwc
//  Rd32=cmpyrw(Rss32,Rtt32*):<<1:sat
    r0=cmpyrw(r1:0,r1:0*):<<1:sat
# CHECK-NEXT: e960c000 { r0 = cmpyrw(r1:0,r1:0*):<<1:sat }

//  M7_wcmpyrwc_rnd
//  Rd32=cmpyrw(Rss32,Rtt32*):<<1:rnd:sat
    r0=cmpyrw(r1:0,r1:0*):<<1:rnd:sat
# CHECK-NEXT: e9e0c000 { r0 = cmpyrw(r1:0,r1:0*):<<1:rnd:sat }
