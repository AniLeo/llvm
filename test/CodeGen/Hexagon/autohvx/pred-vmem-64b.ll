; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

declare <16 x i32> @llvm.hexagon.V6.vL32b.pred.ai(i1, <16 x i32>*, i32)
declare <16 x i32> @llvm.hexagon.V6.vL32b.npred.ai(i1, <16 x i32>*, i32)
declare <16 x i32> @llvm.hexagon.V6.vL32b.nt.pred.ai(i1, <16 x i32>*, i32)
declare <16 x i32> @llvm.hexagon.V6.vL32b.nt.npred.ai(i1, <16 x i32>*, i32)

declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.pred.pi(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.npred.pi(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.pred.pi(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.npred.pi(i1, <16 x i32>*, i32)

declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.pred.ppu(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.npred.ppu(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.pred.ppu(i1, <16 x i32>*, i32)
declare { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.npred.ppu(i1, <16 x i32>*, i32)

declare void @llvm.hexagon.V6.vS32b.pred.ai(i1, <16 x i32>*, i32, <16 x i32>)
declare void @llvm.hexagon.V6.vS32b.npred.ai(i1, <16 x i32>*, i32, <16 x i32>)
declare void @llvm.hexagon.V6.vS32Ub.pred.ai(i1, <16 x i32>*, i32, <16 x i32>)
declare void @llvm.hexagon.V6.vS32Ub.npred.ai(i1, <16 x i32>*, i32, <16 x i32>)
declare void @llvm.hexagon.V6.vS32b.nt.pred.ai(i1, <16 x i32>*, i32, <16 x i32>)
declare void @llvm.hexagon.V6.vS32b.nt.npred.ai(i1, <16 x i32>*, i32, <16 x i32>)

declare <16 x i32>* @llvm.hexagon.V6.vS32b.pred.pi(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.npred.pi(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32Ub.pred.pi(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32Ub.npred.pi(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.nt.pred.pi(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.nt.npred.pi(i1, <16 x i32>*, i32, <16 x i32>)

declare <16 x i32>* @llvm.hexagon.V6.vS32b.pred.ppu(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.npred.ppu(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32Ub.pred.ppu(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32Ub.npred.ppu(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.nt.pred.ppu(i1, <16 x i32>*, i32, <16 x i32>)
declare <16 x i32>* @llvm.hexagon.V6.vS32b.nt.npred.ppu(i1, <16 x i32>*, i32, <16 x i32>)


define <16 x i32> @f0(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r1+#3)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32> @llvm.hexagon.V6.vL32b.pred.ai(i1 %v0, <16 x i32>* %a1, i32 192)
  ret <16 x i32> %v1
}

define <16 x i32> @f1(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r1+#3)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32> @llvm.hexagon.V6.vL32b.npred.ai(i1 %v0, <16 x i32>* %a1, i32 192)
  ret <16 x i32> %v1
}

define <16 x i32> @f2(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r1+#3):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32> @llvm.hexagon.V6.vL32b.nt.pred.ai(i1 %v0, <16 x i32>* %a1, i32 192)
  ret <16 x i32> %v1
}

define <16 x i32> @f3(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r1+#3):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32> @llvm.hexagon.V6.vL32b.nt.npred.ai(i1 %v0, <16 x i32>* %a1, i32 192)
  ret <16 x i32> %v1
}

define <16 x i32>* @f4(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f4:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r0++#3)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.pred.pi(i1 %v0, <16 x i32>* %a1, i32 192)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f5(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f5:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r0++#3)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.npred.pi(i1 %v0, <16 x i32>* %a1, i32 192)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f6(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f6:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r0++#3):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.pred.pi(i1 %v0, <16 x i32>* %a1, i32 192)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f7(i32 %a0, <16 x i32>* %a1) #0 {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r0++#3):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.npred.pi(i1 %v0, <16 x i32>* %a1, i32 192)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f8(i32 %a0, <16 x i32>* %a1, i32 %a2) #0 {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r0++m0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.pred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f9(i32 %a0, <16 x i32>* %a1, i32 %a2) #0 {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r0++m0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.npred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f10(i32 %a0, <16 x i32>* %a1, i32 %a2) #0 {
; CHECK-LABEL: f10:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) v0 = vmem(r0++m0):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.pred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define <16 x i32>* @f11(i32 %a0, <16 x i32>* %a1, i32 %a2) #0 {
; CHECK-LABEL: f11:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) v0 = vmem(r0++m0):nt
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call { <16 x i32>, <16 x i32>* } @llvm.hexagon.V6.vL32b.nt.npred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2)
  %v2 = extractvalue { <16 x i32>, <16 x i32>* } %v1, 1
  ret <16 x i32>* %v2
}

define void @f12(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f12:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r1+#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32b.pred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define void @f13(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f13:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r1+#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32b.npred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define void @f14(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f14:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmemu(r1+#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32Ub.pred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define void @f15(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f15:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmemu(r1+#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32Ub.npred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define void @f16(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f16:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r1+#-3):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32b.nt.pred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define void @f17(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f17:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r1+#-3):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  call void @llvm.hexagon.V6.vS32b.nt.npred.ai(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret void
}

define <16 x i32>* @f18(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f18:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r0++#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.pred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f19(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f19:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r0++#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.npred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f20(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f20:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmemu(r0++#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32Ub.pred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f21(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f21:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmemu(r0++#-3) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32Ub.npred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f22(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f22:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r0++#-3):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.nt.pred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f23(i32 %a0, <16 x i32>* %a1, <16 x i32> %a2) #0 {
; CHECK-LABEL: f23:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r0++#-3):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.nt.npred.pi(i1 %v0, <16 x i32>* %a1, i32 -192, <16 x i32> %a2)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f24(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f24:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r0++m0) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.pred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f25(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f25:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r0++m0) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.npred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f26(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f26:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmemu(r0++m0) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32Ub.pred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f27(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f27:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmemu(r0++m0) = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32Ub.npred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f28(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f28:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (p0) vmem(r0++m0):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.nt.pred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

define <16 x i32>* @f29(i32 %a0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3) #0 {
; CHECK-LABEL: f29:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     p0 = cmp.eq(r0,#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = r1
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     m0 = r2
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     if (!p0) vmem(r0++m0):nt = v0
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = icmp eq i32 %a0, 0
  %v1 = call <16 x i32>* @llvm.hexagon.V6.vS32b.nt.npred.ppu(i1 %v0, <16 x i32>* %a1, i32 %a2, <16 x i32> %a3)
  ret <16 x i32>* %v1
}

attributes #0 = { nounwind "target-cpu"="hexagonv66" "target-features"="+hvxv66,+hvx-length64b,-packets" }
