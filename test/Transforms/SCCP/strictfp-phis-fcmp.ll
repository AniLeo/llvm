; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sccp -S | FileCheck %s

define i1 @float.1.defaultenv(i1 %cmp) #0 {
; CHECK-LABEL: @float.1.defaultenv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.ignore") #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.ignore") #0

  ret i1 %c
}

define i1 @float.1.maytrap(i1 %cmp) #0 {
; CHECK-LABEL: @float.1.maytrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.maytrap") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.maytrap") #0

  ret i1 %c
}

define i1 @float.1.strict(i1 %cmp) #0 {
; CHECK-LABEL: @float.1.strict(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.strict") #0

  ret i1 %c
}

define i1 @float.2.defaultenv(i1 %cmp) #0 {
; CHECK-LABEL: @float.2.defaultenv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ 2.000000e+00, [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 2.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.ignore") #0
  ret i1 %c
}

define i1 @float.2.maytrap(i1 %cmp) #0 {
; CHECK-LABEL: @float.2.maytrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ 2.000000e+00, [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.maytrap") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 2.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.maytrap") #0
  ret i1 %c
}

define i1 @float.2.strict(i1 %cmp) #0 {
; CHECK-LABEL: @float.2.strict(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ 2.000000e+00, [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 2.0, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.strict") #0
  ret i1 %c
}

define i1 @float.3.defaultenv(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.3.defaultenv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ [[F:%.*]], [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ %f, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.ignore") #0
  ret i1 %c
}

define i1 @float.3.maytrap(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.3.maytrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ [[F:%.*]], [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.maytrap") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ %f, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.maytrap") #0
  ret i1 %c
}

define i1 @float.3.strict(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.3.strict(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[P:%.*]] = phi float [ 1.000000e+00, [[ENTRY:%.*]] ], [ [[F:%.*]], [[IF_TRUE]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float [[P]], float 1.000000e+00, metadata !"ueq", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ %f, %if.true]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"ueq", metadata !"fpexcept.strict") #0
  ret i1 %c
}

define i1 @float.4_unreachable.defaultenv(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.4_unreachable.defaultenv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       dead:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"une", metadata !"fpexcept.ignore") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

dead:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true], [ %f, %dead ]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"une", metadata !"fpexcept.ignore") #0
  ret i1 %c
}

define i1 @float.4_unreachable.maytrap(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.4_unreachable.maytrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       dead:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"une", metadata !"fpexcept.maytrap") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

dead:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true], [ %f, %dead ]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"une", metadata !"fpexcept.maytrap") #0
  ret i1 %c
}

; FIXME: It's a shame we can't eliminate this fcmp here:
define i1 @float.4_unreachable.strict(float %f, i1 %cmp) #0 {
; CHECK-LABEL: @float.4_unreachable.strict(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_TRUE:%.*]], label [[END:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END]]
; CHECK:       dead:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[C:%.*]] = call i1 @llvm.experimental.constrained.fcmp.f32(float 1.000000e+00, float 1.000000e+00, metadata !"une", metadata !"fpexcept.strict") #[[ATTR0]]
; CHECK-NEXT:    ret i1 [[C]]
;

entry:
  br i1 %cmp, label %if.true, label %end

if.true:
  br label %end

dead:
  br label %end

end:
  %p = phi float [ 1.0, %entry ], [ 1.0, %if.true], [ %f, %dead ]
  %c = call i1 @llvm.experimental.constrained.fcmp.i1.f32(float %p, float 1.0, metadata !"une", metadata !"fpexcept.strict") #0
  ret i1 %c
}

attributes #0 = { strictfp }

declare i1 @llvm.experimental.constrained.fcmp.i1.f32(float, float, metadata, metadata)

