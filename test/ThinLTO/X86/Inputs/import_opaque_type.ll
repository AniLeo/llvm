target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.11.0"

%0 = type { i8 }

%a = type { %0 * }

define void @bar(%a *) {
	ret void
}

define void @baz() {
	call void @bar(%a *null)
	ret void
}
