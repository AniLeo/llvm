; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

%struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362 = type { i8, %struct.b.1.5.9.13.37.69.73.89.93.97.105.121.361, i24, i24 }
%struct.b.1.5.9.13.37.69.73.89.93.97.105.121.361 = type { %struct.a.0.4.8.12.36.68.72.88.92.96.104.120.360, %struct.a.0.4.8.12.36.68.72.88.92.96.104.120.360, i8 }
%struct.a.0.4.8.12.36.68.72.88.92.96.104.120.360 = type <{ i8, i16 }>
%struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363 = type <{ %struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362, %struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362, i8, i8 }>

@var_46 = external dso_local local_unnamed_addr global i8, align 1
@var_44 = external dso_local local_unnamed_addr global i8, align 1
@var_163 = external dso_local local_unnamed_addr global i8, align 1
@struct_obj_12 = external dso_local local_unnamed_addr global %struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362, align 2
@struct_obj_3 = external dso_local local_unnamed_addr global %struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363, align 2
@struct_obj_8 = external dso_local local_unnamed_addr global %struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363, align 2
@var_49 = external dso_local local_unnamed_addr constant i8, align 1

; Function Attrs: norecurse nounwind uwtable
define void @_Z1av() local_unnamed_addr #0 {
; CHECK-LABEL: _Z1av:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl struct_obj_3+8(%rip), %eax
; CHECK-NEXT:    movzbl var_46(%rip), %ecx
; CHECK-NEXT:    movzbl var_49(%rip), %edx
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    addl %eax, %eax
; CHECK-NEXT:    subl %ecx, %eax
; CHECK-NEXT:    subl %edx, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movw %ax, struct_obj_12+5(%rip)
; CHECK-NEXT:    movb $0, var_163(%rip)
; CHECK-NEXT:    retq
entry:
  %bf.load = load i32, i32* bitcast (i24* getelementptr inbounds (%struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363, %struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363* @struct_obj_3, i64 0, i32 0, i32 2) to i32*), align 2
  %tmp = load i8, i8* @var_46, align 1
  %conv1 = sext i8 %tmp to i32
  %tmp1 = load i8, i8* @var_49, align 1
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = shl i32 %bf.load, 1
  %factor = and i32 %tmp3, 2
  %sub = sub nsw i32 %factor, %conv1
  %sub8 = sub nsw i32 %sub, %tmp2
  %add = add nsw i32 %sub8, 0
  %tmp4 = load i8, i8* @var_44, align 1
  %tmp5 = zext i8 %tmp4 to i32
  %xor = xor i32 %add, 255
  %xor20 = xor i32 %xor, 0
  %neg = xor i32 %xor20, 0
  %or = or i32 0, %neg
  %or55 = or i32 %or, 0
  %conv56 = trunc i32 %or55 to i16
  %bf.value = and i16 %conv56, 255
  %bf.set = or i16 %bf.value, 0
  store i16 %bf.set, i16* getelementptr inbounds (%struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362, %struct.c.2.6.10.14.38.70.74.90.94.98.106.122.362* @struct_obj_12, i64 0, i32 1, i32 1, i32 1), align 1
  %lnot = icmp eq i8 undef, 0
  %bf.load65 = load i32, i32* bitcast (i24* getelementptr inbounds (%struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363, %struct.d.3.7.11.15.39.71.75.91.95.99.107.123.363* @struct_obj_8, i64 0, i32 0, i32 2) to i32*), align 2
  %tmp6 = and i32 %bf.load65, 1
  %tmp7 = select i1 %lnot, i32 undef, i32 0
  %mul69 = and i32 %tmp6, %tmp7
  %tmp8 = sub nsw i32 0, %mul69
  %mul75 = and i32 %tmp5, %tmp8
  %tmp9 = and i32 %bf.load, 1
  %tmp10 = sub nsw i32 0, %mul75
  %mul80 = and i32 %tmp9, %tmp10
  %factor109 = shl nuw nsw i32 %tmp9, 1
  %sub86 = sub nsw i32 %factor109, %conv1
  %sub94 = sub nsw i32 %sub86, %tmp2
  %tmp11 = sub nsw i32 0, %mul80
  %mul95 = and i32 %sub94, %tmp11
  %tobool96 = icmp ne i32 %mul95, 0
  %frombool = zext i1 %tobool96 to i8
  store i8 %frombool, i8* @var_163, align 1
  ret void
}

attributes #0 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
