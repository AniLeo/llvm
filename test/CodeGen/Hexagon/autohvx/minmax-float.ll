; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon -mattr=+hvxv69,+hvx-length128b,+hvx-qfloat < %s | FileCheck %s
; RUN: llc -march=hexagon -mattr=+hvxv69,+hvx-length128b,+hvx-ieee-fp < %s | FileCheck %s

; min

define <64 x half> @test_00(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_00:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.hf = vmin(v1.hf,v0.hf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp olt <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v0, <64 x half> %v1
  ret <64 x half> %t1
}

define <64 x half> @test_01(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_01:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v0.hf,v1.hf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v1,v0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ole <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v0, <64 x half> %v1
  ret <64 x half> %t1
}

define <64 x half> @test_02(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_02:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.hf = vmin(v0.hf,v1.hf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ogt <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v1, <64 x half> %v0
  ret <64 x half> %t1
}

define <64 x half> @test_03(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_03:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v1.hf,v0.hf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v0,v1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp oge <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v1, <64 x half> %v0
  ret <64 x half> %t1
}

define <32 x float> @test_10(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.sf = vmin(v1.sf,v0.sf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp olt <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v0, <32 x float> %v1
  ret <32 x float> %t1
}

define <32 x float> @test_11(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v0.sf,v1.sf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v1,v0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ole <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v0, <32 x float> %v1
  ret <32 x float> %t1
}

define <32 x float> @test_12(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.sf = vmin(v0.sf,v1.sf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ogt <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v1, <32 x float> %v0
  ret <32 x float> %t1
}

define <32 x float> @test_13(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v1.sf,v0.sf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v0,v1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp oge <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v1, <32 x float> %v0
  ret <32 x float> %t1
}

; max

define <64 x half> @test_20(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_20:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.hf = vmax(v1.hf,v0.hf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp olt <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v1, <64 x half> %v0
  ret <64 x half> %t1
}

define <64 x half> @test_21(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_21:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v0.hf,v1.hf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v0,v1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ole <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v1, <64 x half> %v0
  ret <64 x half> %t1
}

define <64 x half> @test_22(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_22:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.hf = vmax(v0.hf,v1.hf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ogt <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v0, <64 x half> %v1
  ret <64 x half> %t1
}

define <64 x half> @test_23(<64 x half> %v0, <64 x half> %v1) #0 {
; CHECK-LABEL: test_23:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v1.hf,v0.hf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v1,v0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp oge <64 x half> %v0, %v1
  %t1 = select <64 x i1> %t0, <64 x half> %v0, <64 x half> %v1
  ret <64 x half> %t1
}

define <32 x float> @test_30(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.sf = vmax(v1.sf,v0.sf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp olt <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v1, <32 x float> %v0
  ret <32 x float> %t1
}

define <32 x float> @test_31(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_31:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v0.sf,v1.sf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v0,v1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ole <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v1, <32 x float> %v0
  ret <32 x float> %t1
}

define <32 x float> @test_32(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.sf = vmax(v0.sf,v1.sf)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp ogt <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v0, <32 x float> %v1
  ret <32 x float> %t1
}

define <32 x float> @test_33(<32 x float> %v0, <32 x float> %v1) #0 {
; CHECK-LABEL: test_33:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vcmp.gt(v1.sf,v0.sf)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vmux(q0,v1,v0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %t0 = fcmp oge <32 x float> %v0, %v1
  %t1 = select <32 x i1> %t0, <32 x float> %v0, <32 x float> %v1
  ret <32 x float> %t1
}

attributes #0 = { readnone nounwind "target-cpu"="hexagonv69" }

