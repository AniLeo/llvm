; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

declare void @llvm.lifetime.start.p0i8(i64, i8*)
declare void @llvm.lifetime.end.p0i8(i64, i8*)

declare void @escape(i32*)

declare void @throwing_callee_foo()
declare void @throwing_callee_bar()

declare i32 @__gxx_personality_v0(...)

define void @caller(i1 %c) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[I1:%.*]] = bitcast i32* [[I0]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[I1]])
; CHECK-NEXT:    call void @escape(i32* [[I0]])
; CHECK-NEXT:    [[I2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[I3:%.*]] = bitcast i32* [[I2]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[I3]])
; CHECK-NEXT:    call void @escape(i32* [[I2]])
; CHECK-NEXT:    [[I4:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[I5:%.*]] = bitcast i32* [[I4]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[I5]])
; CHECK-NEXT:    call void @escape(i32* [[I4]])
; CHECK-NEXT:    [[I6:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[I7:%.*]] = bitcast i32* [[I6]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull [[I7]])
; CHECK-NEXT:    call void @escape(i32* [[I6]])
; CHECK-NEXT:    br i1 [[C:%.*]], label [[V0:%.*]], label [[V1:%.*]]
; CHECK:       v0:
; CHECK-NEXT:    call void @throwing_callee_foo()
; CHECK-NEXT:    unreachable
; CHECK:       v1:
; CHECK-NEXT:    call void @throwing_callee_bar()
; CHECK-NEXT:    unreachable
;
entry:
  %i0 = alloca i32
  %i1 = bitcast i32* %i0 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %i1)
  call void @escape(i32* %i0)

  %i2 = alloca i32
  %i3 = bitcast i32* %i2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %i3)
  call void @escape(i32* %i2)

  %i4 = alloca i32
  %i5 = bitcast i32* %i4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %i5)
  call void @escape(i32* %i4)

  %i6 = alloca i32
  %i7 = bitcast i32* %i6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %i7)
  call void @escape(i32* %i6)

  br i1 %c, label %v0, label %v1

v0:
  invoke void @throwing_callee_foo()
  to label %invoke.cont unwind label %lpad.v0

v1:
  invoke void @throwing_callee_bar()
  to label %invoke.cont unwind label %lpad.v1

invoke.cont:
  unreachable

lpad.v0:
  %i8 = landingpad { i8*, i32 } cleanup
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %i1)
  br label %end

lpad.v1:
  %i9 = landingpad { i8*, i32 } cleanup
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %i3)
  br label %end

end:
  %i10 = phi { i8*, i32 } [ %i8, %lpad.v0 ], [ %i9, %lpad.v1 ]
  %i11 = phi i8* [ %i5, %lpad.v0 ], [ %i7, %lpad.v1 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %i11)
  resume { i8*, i32 } %i10
}
