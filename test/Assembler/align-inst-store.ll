; RUN: not llvm-as %s -o /dev/null 2>/dev/null

define void @foo(i1* %p) {
  store i1 false, i1* %p, align 8589934592
  ret void
}
