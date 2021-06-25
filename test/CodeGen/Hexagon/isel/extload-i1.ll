; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon  < %s | FileCheck %s

@array8 = global [128 x i8] zeroinitializer
@array32 = global [128 x i32] zeroinitializer
@global_gp = global i1 false

; Sign extensions

define i32 @f0(i1* %a0) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+#1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 1
  %v1 = load i1, i1* %v0
  %v2 = sext i1 %v1 to i32
  ret i32 %v2
}

define i32 @f1(i1* %a0, i32 %a1) #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+r1<<#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 %a1
  %v1 = load i1, i1* %v0
  %v2 = sext i1 %v1 to i32
  ret i32 %v2
}

define i32 @f2(i32 %a0) #0 {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+##array8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i8], [128 x i8]* @array8, i32 0, i32 %a0
  %v1 = bitcast i8* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = sext i1 %v2 to i32
  ret i32 %v3
}

define i32 @f3(i32 %a0) #0 {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0<<#2+##array32)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i32], [128 x i32]* @array32, i32 0, i32 %a0
  %v1 = bitcast i32* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = sext i1 %v2 to i32
  ret i32 %v3
}

define i32 @f4() #0 {
; CHECK-LABEL: f4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(gp+#global_gp)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = load i1, i1* @global_gp
  %v1 = sext i1 %v0 to i32
  ret i32 %v1
}

define i32 @f5(i64 %a0, i64 %a1, i64 %a2, i1 signext %a3) #0 {
; CHECK-LABEL: f5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r29+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = sext i1 %a3 to i32
  ret i32 %v0
}

define i64 @f6(i1* %a0) #0 {
; CHECK-LABEL: f6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+#1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 1
  %v1 = load i1, i1* %v0
  %v2 = sext i1 %v1 to i64
  ret i64 %v2
}

define i64 @f7(i1* %a0, i32 %a1) #0 {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+r1<<#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 %a1
  %v1 = load i1, i1* %v0
  %v2 = sext i1 %v1 to i64
  ret i64 %v2
}

define i64 @f8(i32 %a0) #0 {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+##array8)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i8], [128 x i8]* @array8, i32 0, i32 %a0
  %v1 = bitcast i8* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = sext i1 %v2 to i64
  ret i64 %v3
}

define i64 @f9(i32 %a0) #0 {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0<<#2+##array32)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i32], [128 x i32]* @array32, i32 0, i32 %a0
  %v1 = bitcast i32* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = sext i1 %v2 to i64
  ret i64 %v3
}

define i64 @f10() #0 {
; CHECK-LABEL: f10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(gp+#global_gp)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = load i1, i1* @global_gp
  %v1 = sext i1 %v0 to i64
  ret i64 %v1
}

define i64 @f11(i64 %a0, i64 %a1, i64 %a2, i1 signext %a3) #0 {
; CHECK-LABEL: f11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r29+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = sub(#0,r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = asr(r0,#31)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = sext i1 %a3 to i64
  ret i64 %v0
}

; Zero-extensions

define i32 @f12(i1* %a0) #0 {
; CHECK-LABEL: f12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memub(r0+#1)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 1
  %v1 = load i1, i1* %v0
  %v2 = zext i1 %v1 to i32
  ret i32 %v2
}

define i32 @f13(i1* %a0, i32 %a1) #0 {
; CHECK-LABEL: f13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0+r1<<#0)
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 %a1
  %v1 = load i1, i1* %v0
  %v2 = zext i1 %v1 to i32
  ret i32 %v2
}

define i32 @f14(i32 %a0) #0 {
; CHECK-LABEL: f14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0+##array8)
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i8], [128 x i8]* @array8, i32 0, i32 %a0
  %v1 = bitcast i8* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = zext i1 %v2 to i32
  ret i32 %v3
}

define i32 @f15(i32 %a0) #0 {
; CHECK-LABEL: f15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0<<#2+##array32)
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i32], [128 x i32]* @array32, i32 0, i32 %a0
  %v1 = bitcast i32* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = zext i1 %v2 to i32
  ret i32 %v3
}

define i32 @f16() #0 {
; CHECK-LABEL: f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(gp+#global_gp)
; CHECK-NEXT:    }
  %v0 = load i1, i1* @global_gp
  %v1 = zext i1 %v0 to i32
  ret i32 %v1
}

define i32 @f17(i64 %a0, i64 %a1, i64 %a2, i1 zeroext %a3) #0 {
; CHECK-LABEL: f17:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r29+#0)
; CHECK-NEXT:    }
  %v0 = zext i1 %a3 to i32
  ret i32 %v0
}

define i64 @f18(i1* %a0) #0 {
; CHECK-LABEL: f18:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     r0 = memub(r0+#1)
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 1
  %v1 = load i1, i1* %v0
  %v2 = zext i1 %v1 to i64
  ret i64 %v2
}

define i64 @f19(i1* %a0, i32 %a1) #0 {
; CHECK-LABEL: f19:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0+r1<<#0)
; CHECK-NEXT:    }
  %v0 = getelementptr i1, i1* %a0, i32 %a1
  %v1 = load i1, i1* %v0
  %v2 = zext i1 %v1 to i64
  ret i64 %v2
}

define i64 @f20(i32 %a0) #0 {
; CHECK-LABEL: f20:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0+##array8)
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i8], [128 x i8]* @array8, i32 0, i32 %a0
  %v1 = bitcast i8* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = zext i1 %v2 to i64
  ret i64 %v3
}

define i64 @f21(i32 %a0) #0 {
; CHECK-LABEL: f21:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r0<<#2+##array32)
; CHECK-NEXT:    }
  %v0 = getelementptr [128 x i32], [128 x i32]* @array32, i32 0, i32 %a0
  %v1 = bitcast i32* %v0 to i1*
  %v2 = load i1, i1* %v1
  %v3 = zext i1 %v2 to i64
  ret i64 %v3
}

define i64 @f22() #0 {
; CHECK-LABEL: f22:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(gp+#global_gp)
; CHECK-NEXT:    }
  %v0 = load i1, i1* @global_gp
  %v1 = zext i1 %v0 to i64
  ret i64 %v1
}

define i64 @f23(i64 %a0, i64 %a1, i64 %a2, i1 signext %a3) #0 {
; CHECK-LABEL: f23:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #0
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:     r0 = memub(r29+#0)
; CHECK-NEXT:    }
  %v0 = zext i1 %a3 to i64
  ret i64 %v0
}

attributes #0 = { nounwind "target-cpu"="hexagonv66" }
