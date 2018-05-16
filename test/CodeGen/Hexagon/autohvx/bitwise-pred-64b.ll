; RUN: llc -march=hexagon < %s | FileCheck %s

; CHECK-LABEL: t00
; CHECK: and(q{{[0-3]}},q{{[0-3]}})
define <64 x i8> @t00(<64 x i8> %a0, <64 x i8> %a1,
                      <64 x i8> %a2, <64 x i8> %a3) #0 {
  %q0 = icmp eq <64 x i8> %a0, %a1
  %q1 = icmp eq <64 x i8> %a2, %a3
  %q2 = and <64 x i1> %q0, %q1
  %v0 = zext <64 x i1> %q2 to <64 x i8>
  ret <64 x i8> %v0
}

; CHECK-LABEL: t01
; CHECK: or(q{{[0-3]}},q{{[0-3]}})
define <64 x i8> @t01(<64 x i8> %a0, <64 x i8> %a1,
                      <64 x i8> %a2, <64 x i8> %a3) #0 {
  %q0 = icmp eq <64 x i8> %a0, %a1
  %q1 = icmp eq <64 x i8> %a2, %a3
  %q2 = or <64 x i1> %q0, %q1
  %v0 = zext <64 x i1> %q2 to <64 x i8>
  ret <64 x i8> %v0
}

; CHECK-LABEL: t02
; CHECK: xor(q{{[0-3]}},q{{[0-3]}})
define <64 x i8> @t02(<64 x i8> %a0, <64 x i8> %a1,
                      <64 x i8> %a2, <64 x i8> %a3) #0 {
  %q0 = icmp eq <64 x i8> %a0, %a1
  %q1 = icmp eq <64 x i8> %a2, %a3
  %q2 = xor <64 x i1> %q0, %q1
  %v0 = zext <64 x i1> %q2 to <64 x i8>
  ret <64 x i8> %v0
}

; CHECK-LABEL: t10
; CHECK: and(q{{[0-3]}},q{{[0-3]}})
define <32 x i16> @t10(<32 x i16> %a0, <32 x i16> %a1,
                       <32 x i16> %a2, <32 x i16> %a3) #0 {
  %q0 = icmp eq <32 x i16> %a0, %a1
  %q1 = icmp eq <32 x i16> %a2, %a3
  %q2 = and <32 x i1> %q0, %q1
  %v0 = zext <32 x i1> %q2 to <32 x i16>
  ret <32 x i16> %v0
}

; CHECK-LABEL: t11
; CHECK: or(q{{[0-3]}},q{{[0-3]}})
define <32 x i16> @t11(<32 x i16> %a0, <32 x i16> %a1,
                       <32 x i16> %a2, <32 x i16> %a3) #0 {
  %q0 = icmp eq <32 x i16> %a0, %a1
  %q1 = icmp eq <32 x i16> %a2, %a3
  %q2 = or <32 x i1> %q0, %q1
  %v0 = zext <32 x i1> %q2 to <32 x i16>
  ret <32 x i16> %v0
}

; CHECK-LABEL: t12
; CHECK: xor(q{{[0-3]}},q{{[0-3]}})
define <32 x i16> @t12(<32 x i16> %a0, <32 x i16> %a1,
                       <32 x i16> %a2, <32 x i16> %a3) #0 {
  %q0 = icmp eq <32 x i16> %a0, %a1
  %q1 = icmp eq <32 x i16> %a2, %a3
  %q2 = xor <32 x i1> %q0, %q1
  %v0 = zext <32 x i1> %q2 to <32 x i16>
  ret <32 x i16> %v0
}

; CHECK-LABEL: t20
; CHECK: and(q{{[0-3]}},q{{[0-3]}})
define <16 x i32> @t20(<16 x i32> %a0, <16 x i32> %a1,
                       <16 x i32> %a2, <16 x i32> %a3) #0 {
  %q0 = icmp eq <16 x i32> %a0, %a1
  %q1 = icmp eq <16 x i32> %a2, %a3
  %q2 = and <16 x i1> %q0, %q1
  %v0 = zext <16 x i1> %q2 to <16 x i32>
  ret <16 x i32> %v0
}

; CHECK-LABEL: t21
; CHECK: or(q{{[0-3]}},q{{[0-3]}})
define <16 x i32> @t21(<16 x i32> %a0, <16 x i32> %a1,
                       <16 x i32> %a2, <16 x i32> %a3) #0 {
  %q0 = icmp eq <16 x i32> %a0, %a1
  %q1 = icmp eq <16 x i32> %a2, %a3
  %q2 = or <16 x i1> %q0, %q1
  %v0 = zext <16 x i1> %q2 to <16 x i32>
  ret <16 x i32> %v0
}

; CHECK-LABEL: t22
; CHECK: xor(q{{[0-3]}},q{{[0-3]}})
define <16 x i32> @t22(<16 x i32> %a0, <16 x i32> %a1,
                       <16 x i32> %a2, <16 x i32> %a3) #0 {
  %q0 = icmp eq <16 x i32> %a0, %a1
  %q1 = icmp eq <16 x i32> %a2, %a3
  %q2 = xor <16 x i1> %q0, %q1
  %v0 = zext <16 x i1> %q2 to <16 x i32>
  ret <16 x i32> %v0
}

attributes #0 = { nounwind readnone "target-cpu"="hexagonv60" "target-features"="+hvx,+hvx-length64b" }
