; RUN: llvm-as < %s | llvm-dis > %t.orig
; RUN: llvm-as < %s | llvm-c-test --echo > %t.echo
; RUN: diff -w %t.orig %t.echo

%S = type { i64, %S* }

define { i64, %S* } @unpackrepack(%S %s) {
  %1 = extractvalue %S %s, 0
  %2 = extractvalue %S %s, 1
  %3 = insertvalue { i64, %S* } undef, %S* %2, 1
  %4 = insertvalue { i64, %S* } %3, i64 %1, 0
  ret { i64, %S* } %4
}

declare void @decl()

; TODO: label and metadata types
define void @types() {
  %1 = alloca half
  %2 = alloca float
  %3 = alloca double
  %4 = alloca x86_fp80
  %5 = alloca fp128
  %6 = alloca ppc_fp128
  %7 = alloca i7
  %8 = alloca void (i1)*
  %9 = alloca [3 x i22]
  %10 = alloca i328 addrspace(5)*
  %11 = alloca <5 x i23*>
  %12 = alloca x86_mmx
  ret void
}

define i32 @iops(i32 %a, i32 %b) {
  %1 = add i32 %a, %b
  %2 = mul i32 %a, %1
  %3 = sub i32 %2, %1
  %4 = udiv i32 %3, %b
  %5 = sdiv i32 %2, %4
  %6 = urem i32 %3, %5
  %7 = srem i32 %2, %6
  %8 = shl i32 %1, %b
  %9 = lshr i32 %a, %7
  %10 = ashr i32 %b, %8
  %11 = and i32 %9, %10
  %12 = or i32 %2, %11
  %13 = xor i32 %12, %4
  ret i32 %13
}

define i32 @call() {
  %1 = call i32 @iops(i32 23, i32 19)
  ret i32 %1
}

define i32 @cond(i32 %a, i32 %b) {
  br label %br
unreachable:
  unreachable
br:
  %1 = icmp eq i32 %a, %b
  br i1 %1, label %next0, label %unreachable
next0:
  %2 = icmp ne i32 %a, %b
  br i1 %2, label %next1, label %unreachable
next1:
  %3 = icmp ugt i32 %a, %b
  br i1 %3, label %next2, label %unreachable
next2:
  %4 = icmp uge i32 %a, %b
  br i1 %4, label %next3, label %unreachable
next3:
  %5 = icmp ult i32 %a, %b
  br i1 %5, label %next4, label %unreachable
next4:
  %6 = icmp ule i32 %a, %b
  br i1 %6, label %next5, label %unreachable
next5:
  %7 = icmp sgt i32 %a, %b
  br i1 %7, label %next6, label %unreachable
next6:
  %8 = icmp sge i32 %a, %b
  br i1 %8, label %next7, label %unreachable
next7:
  %9 = icmp slt i32 %a, %b
  br i1 %9, label %next8, label %unreachable
next8:
  %10 = icmp sle i32 %a, %b
  br i1 %10, label %next9, label %unreachable
next9:
  ret i32 0
}
