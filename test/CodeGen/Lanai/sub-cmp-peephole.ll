; RUN: llc < %s -mtriple=lanai | FileCheck %s

define i32 @f(i32 inreg %a, i32 inreg %b) nounwind ssp {
entry:
; CHECK-LABEL: f:
; CHECK: sub.f %r6, %r7, [[IN:%.*]]
; CHECK: sel.gt [[IN]], %r0, %rv
  %cmp = icmp sgt i32 %a, %b
  %sub = sub nsw i32 %a, %b
  %sub. = select i1 %cmp, i32 %sub, i32 0
  ret i32 %sub.
}

define i32 @g(i32 inreg %a, i32 inreg %b) nounwind ssp {
entry:
; CHECK-LABEL: g:
; CHECK: sub.f %r7, %r6, [[IN:%.*]]
; CHECK: sel.lt [[IN]], %r0, %rv
  %cmp = icmp slt i32 %a, %b
  %sub = sub nsw i32 %b, %a
  %sub. = select i1 %cmp, i32 %sub, i32 0
  ret i32 %sub.
}

define i32 @h(i32 inreg %a, i32 inreg %b) nounwind ssp {
entry:
; CHECK-LABEL: h:
; CHECK: sub.f %r6, 0x3, [[IN:%.*]]
; CHECK: sel.gt [[IN]], %r7, %rv
  %cmp = icmp sgt i32 %a, 3
  %sub = sub nsw i32 %a, 3
  %sub. = select i1 %cmp, i32 %sub, i32 %b
  ret i32 %sub.
}

define i32 @i(i32 inreg %a, i32 inreg %b) nounwind readnone ssp {
entry:
; CHECK-LABEL: i:
; CHECK: sub.f %r7, %r6, [[IN:%.*]]
; CHECK: sel.ult [[IN]], %r0, %rv
  %cmp = icmp ult i32 %a, %b
  %sub = sub i32 %b, %a
  %sub. = select i1 %cmp, i32 %sub, i32 0
  ret i32 %sub.
}
; If SR is live-out, we can't remove cmp if there exists a swapped sub.
define i32 @j(i32 inreg %a, i32 inreg %b) nounwind {
entry:
; CHECK-LABEL: j:
; CHECK: sub.f %r7, %r6, %r0
; CHECK: sub %r6, %r7, %rv
  %cmp = icmp eq i32 %b, %a
  %sub = sub nsw i32 %a, %b
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %cmp2 = icmp sgt i32 %b, %a
  %sel = select i1 %cmp2, i32 %sub, i32 %a
  ret i32 %sel

if.else:
  ret i32 %sub
}

declare void @abort()
declare void @exit(i32)
@t = common global i32 0

; If the comparison uses the C bit (signed overflow/underflow), we can't
; omit the comparison.
define i32 @cmp_ult0(i32 inreg %a, i32 inreg %b, i32 inreg %x, i32 inreg %y) {
entry:
; CHECK-LABEL: cmp_ult0
; CHECK: sub {{.*}}, 0x11, [[IN:%.*]]
; CHECK: sub.f [[IN]], 0x0, %r0
  %load = load i32, i32* @t, align 4
  %sub = sub i32 %load, 17
  %cmp = icmp ult i32 %sub, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:
  call void @abort()
  unreachable

if.else:
  call void @exit(i32 0)
  unreachable
}

; Same for the V bit.
; TODO: add test that exercises V bit individually (VC/VS).
define i32 @cmp_gt0(i32 inreg %a, i32 inreg %b, i32 inreg %x, i32 inreg %y) {
entry:
; CHECK-LABEL: cmp_gt0
; CHECK: sub {{.*}}, 0x11, [[IN:%.*]]
; CHECK: sub.f [[IN]], 0x1, %r0
  %load = load i32, i32* @t, align 4
  %sub = sub i32 %load, 17
  %cmp = icmp sgt i32 %sub, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:
  call void @abort()
  unreachable

if.else:
  call void @exit(i32 0)
  unreachable
}
