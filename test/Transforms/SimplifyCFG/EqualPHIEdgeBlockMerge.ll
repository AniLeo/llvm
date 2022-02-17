; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test merging of blocks with phi nodes.
;
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -switch-range-to-icmp -S | FileCheck %s
;

; ModuleID = '<stdin>'
declare i1 @foo()

declare i1 @bar(i32)

define i32 @test(i1 %a) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  Q:
; CHECK-NEXT:    [[R:%.*]] = add i32 2, 1
; CHECK-NEXT:    ret i32 [[R]]
;
Q:
  br i1 %a, label %N, label %M
N:              ; preds = %Q
  br label %M
M:              ; preds = %N, %Q
  ; It's ok to merge N and M because the incoming values for W are the
  ; same for both cases...
  %W = phi i32 [ 2, %N ], [ 2, %Q ]               ; <i32> [#uses=1]
  %R = add i32 %W, 1              ; <i32> [#uses=1]
  ret i32 %R
}

; Test merging of blocks with phi nodes where at least one incoming value
; in the successor is undef.
define i8 @testundef(i32 %u) {
; CHECK-LABEL: @testundef(
; CHECK-NEXT:  R:
; CHECK-NEXT:    [[U_OFF:%.*]] = add i32 [[U:%.*]], -1
; CHECK-NEXT:    [[SWITCH:%.*]] = icmp ult i32 [[U_OFF]], 2
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[SWITCH]], i8 1, i8 0
; CHECK-NEXT:    ret i8 [[SPEC_SELECT]]
;
R:
  switch i32 %u, label %U [
  i32 0, label %S
  i32 1, label %T
  i32 2, label %T
  ]

S:                                            ; preds = %R
  br label %U

T:                                           ; preds = %R, %R
  br label %U

U:                                        ; preds = %T, %S, %R
  ; We should be able to merge either the S or T block into U by rewriting
  ; R's incoming value with the incoming value of that predecessor since
  ; R's incoming value is undef and both of those predecessors are simple
  ; unconditional branches.
  %val.0 = phi i8 [ undef, %R ], [ 1, %T ], [ 0, %S ]
  ret i8 %val.0
}

; Test merging of blocks with phi nodes where at least one incoming value
; in the successor is undef.
define i8 @testundef2(i32 %u, i32* %A) {
; CHECK-LABEL: @testundef2(
; CHECK-NEXT:  V:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[U:%.*]], 3
; CHECK-NEXT:    br i1 [[COND]], label [[Z:%.*]], label [[U:%.*]]
; CHECK:       Z:
; CHECK-NEXT:    store i32 0, i32* [[A:%.*]], align 4
; CHECK-NEXT:    br label [[U]]
; CHECK:       U:
; CHECK-NEXT:    ret i8 1
;
V:
  switch i32 %u, label %U [
  i32 0, label %W
  i32 1, label %X
  i32 2, label %X
  i32 3, label %Z
  ]

W:                                            ; preds = %V
  br label %U

Z:
  store i32 0, i32* %A, align 4
  br label %X

X:                                           ; preds = %V, %V, %Z
  br label %U

U:                                        ; preds = %X, %W, %V
  ; We should be able to merge either the W or X block into U by rewriting
  ; V's incoming value with the incoming value of that predecessor since
  ; V's incoming value is undef and both of those predecessors are simple
  ; unconditional branches. Note that X has predecessors beyond
  ; the direct predecessors of U.
  %val.0 = phi i8 [ undef, %V ], [ 1, %X ], [ 1, %W ]
  ret i8 %val.0
}

define i8 @testmergesome(i32 %u, i32* %A) {
; CHECK-LABEL: @testmergesome(
; CHECK-NEXT:  V:
; CHECK-NEXT:    switch i32 [[U:%.*]], label [[Y:%.*]] [
; CHECK-NEXT:    i32 0, label [[W:%.*]]
; CHECK-NEXT:    i32 3, label [[Z:%.*]]
; CHECK-NEXT:    ]
; CHECK:       W:
; CHECK-NEXT:    store i32 1, i32* [[A:%.*]], align 4
; CHECK-NEXT:    br label [[Y]]
; CHECK:       Z:
; CHECK-NEXT:    store i32 0, i32* [[A]], align 4
; CHECK-NEXT:    br label [[Y]]
; CHECK:       Y:
; CHECK-NEXT:    [[VAL_0:%.*]] = phi i8 [ 2, [[W]] ], [ 1, [[Z]] ], [ 1, [[V:%.*]] ]
; CHECK-NEXT:    ret i8 [[VAL_0]]
;
V:
  switch i32 %u, label %Y [
  i32 0, label %W
  i32 1, label %X
  i32 2, label %X
  i32 3, label %Z
  ]

W:                                            ; preds = %V
  store i32 1, i32* %A, align 4
  br label %Y

Z:
  store i32 0, i32* %A, align 4
  br label %X

X:                                           ; preds = %V, %Z
  br label %Y

Y:                                        ; preds = %X, %W, %V
  ; After merging X into Y, we should have 5 predecessors
  ; and thus 5 incoming values to the phi.
  %val.0 = phi i8 [ 1, %V ], [ 1, %X ], [ 2, %W ]
  ret i8 %val.0
}


define i8 @testmergesome2(i32 %u, i32* %A) {
; CHECK-LABEL: @testmergesome2(
; CHECK-NEXT:  V:
; CHECK-NEXT:    switch i32 [[U:%.*]], label [[W:%.*]] [
; CHECK-NEXT:    i32 4, label [[Y:%.*]]
; CHECK-NEXT:    i32 1, label [[Y]]
; CHECK-NEXT:    i32 2, label [[Y]]
; CHECK-NEXT:    ]
; CHECK:       W:
; CHECK-NEXT:    store i32 1, i32* [[A:%.*]], align 4
; CHECK-NEXT:    br label [[Y]]
; CHECK:       Y:
; CHECK-NEXT:    [[VAL_0:%.*]] = phi i8 [ 1, [[V:%.*]] ], [ 2, [[W]] ], [ 1, [[V]] ], [ 1, [[V]] ]
; CHECK-NEXT:    ret i8 [[VAL_0]]
;
V:
  switch i32 %u, label %W [
  i32 0, label %W
  i32 1, label %Y
  i32 2, label %X
  i32 4, label %Y
  ]

W:                                            ; preds = %V
  store i32 1, i32* %A, align 4
  br label %Y

X:                                           ; preds = %V, %Z
  br label %Y

Y:                                        ; preds = %X, %W, %V
  ; Ensure that we deal with both undef inputs for V when we merge in X.
  %val.0 = phi i8 [ undef, %V ], [ 1, %X ], [ 2, %W ], [ undef, %V ]
  ret i8 %val.0
}

; This function can't be merged
define void @a() {
; CHECK-LABEL: @a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB_NOMERGE:%.*]]
; CHECK:       BB.nomerge:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 0, [[COMMON:%.*]] ]
; CHECK-NEXT:    br label [[SUCC:%.*]]
; CHECK:       Succ:
; CHECK-NEXT:    [[B:%.*]] = phi i32 [ [[A]], [[BB_NOMERGE]] ], [ 2, [[COMMON]] ]
; CHECK-NEXT:    [[CONDE:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CONDE]], label [[COMMON]], label [[EXIT:%.*]]
; CHECK:       Common:
; CHECK-NEXT:    [[COND:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[COND]], label [[BB_NOMERGE]], label [[SUCC]]
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %BB.nomerge

BB.nomerge:		; preds = %Common, %entry
  ; This phi has a conflicting value (0) with below phi (2), so blocks
  ; can't be merged.
  %a = phi i32 [ 1, %entry ], [ 0, %Common ]		; <i32> [#uses=1]
  br label %Succ

Succ:		; preds = %Common, %BB.nomerge
  %b = phi i32 [ %a, %BB.nomerge ], [ 2, %Common ]		; <i32> [#uses=0]
  %conde = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %conde, label %Common, label %Exit

Common:		; preds = %Succ
  %cond = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %cond, label %BB.nomerge, label %Succ

Exit:		; preds = %Succ
  ret void
}

; This function can't be merged
define void @b() {
; CHECK-LABEL: @b(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB_NOMERGE:%.*]]
; CHECK:       BB.nomerge:
; CHECK-NEXT:    br label [[SUCC:%.*]]
; CHECK:       Succ:
; CHECK-NEXT:    [[B:%.*]] = phi i32 [ 1, [[BB_NOMERGE]] ], [ 2, [[COMMON:%.*]] ]
; CHECK-NEXT:    [[CONDE:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CONDE]], label [[COMMON]], label [[EXIT:%.*]]
; CHECK:       Common:
; CHECK-NEXT:    [[COND:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[COND]], label [[BB_NOMERGE]], label [[SUCC]]
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %BB.nomerge

BB.nomerge:		; preds = %Common, %entry
  br label %Succ

Succ:		; preds = %Common, %BB.nomerge
  ; This phi has confliction values for Common and (through BB) Common,
  ; blocks can't be merged
  %b = phi i32 [ 1, %BB.nomerge ], [ 2, %Common ]		; <i32> [#uses=0]
  %conde = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %conde, label %Common, label %Exit

Common:		; preds = %Succ
  %cond = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %cond, label %BB.nomerge, label %Succ

Exit:		; preds = %Succ
  ret void
}

; This function can't be merged (for keeping canonical loop structures)
define void @c() {
; CHECK-LABEL: @c(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB_NOMERGE:%.*]]
; CHECK:       BB.nomerge:
; CHECK-NEXT:    br label [[SUCC:%.*]]
; CHECK:       Succ:
; CHECK-NEXT:    [[B:%.*]] = phi i32 [ 1, [[BB_NOMERGE]] ], [ 1, [[COMMON:%.*]] ], [ 2, [[PRE_EXIT:%.*]] ]
; CHECK-NEXT:    [[CONDE:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CONDE]], label [[COMMON]], label [[PRE_EXIT]]
; CHECK:       Common:
; CHECK-NEXT:    [[COND:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[COND]], label [[BB_NOMERGE]], label [[SUCC]]
; CHECK:       Pre-Exit:
; CHECK-NEXT:    [[COND2:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[COND2]], label [[SUCC]], label [[EXIT:%.*]]
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %BB.nomerge

BB.nomerge:		; preds = %Common, %entry
  br label %Succ

Succ:		; preds = %Common, %BB.tomerge, %Pre-Exit
  ; This phi has identical values for Common and (through BB) Common,
  ; blocks can't be merged
  %b = phi i32 [ 1, %BB.nomerge ], [ 1, %Common ], [ 2, %Pre-Exit ]
  %conde = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %conde, label %Common, label %Pre-Exit

Common:		; preds = %Succ
  %cond = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %cond, label %BB.nomerge, label %Succ

Pre-Exit:       ; preds = %Succ
  ; This adds a backedge, so the %b phi node gets a third branch and is
  ; not completely trivial
  %cond2 = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %cond2, label %Succ, label %Exit

Exit:		; preds = %Pre-Exit
  ret void
}

; This function can't be merged (for keeping canonical loop structures)
define void @d() {
; CHECK-LABEL: @d(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB_NOMERGE:%.*]]
; CHECK:       BB.nomerge:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 0, [[COMMON:%.*]] ]
; CHECK-NEXT:    br label [[SUCC:%.*]]
; CHECK:       Succ:
; CHECK-NEXT:    [[B:%.*]] = phi i32 [ [[A]], [[BB_NOMERGE]] ], [ 0, [[COMMON]] ]
; CHECK-NEXT:    [[CONDE:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CONDE]], label [[COMMON]], label [[EXIT:%.*]]
; CHECK:       Common:
; CHECK-NEXT:    [[COND:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[COND]], label [[BB_NOMERGE]], label [[SUCC]]
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %BB.nomerge

BB.nomerge:		; preds = %Common, %entry
  ; This phi has a matching value (0) with below phi (0), so blocks
  ; can be merged.
  %a = phi i32 [ 1, %entry ], [ 0, %Common ]		; <i32> [#uses=1]
  br label %Succ

Succ:		; preds = %Common, %BB.tomerge
  %b = phi i32 [ %a, %BB.nomerge ], [ 0, %Common ]		; <i32> [#uses=0]
  %conde = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %conde, label %Common, label %Exit

Common:		; preds = %Succ
  %cond = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %cond, label %BB.nomerge, label %Succ

Exit:		; preds = %Succ
  ret void
}

; This function can be merged
define void @e() {
; CHECK-LABEL: @e(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[SUCC:%.*]]
; CHECK:       Succ:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 0, [[USE:%.*]] ]
; CHECK-NEXT:    [[CONDE:%.*]] = call i1 @foo()
; CHECK-NEXT:    br i1 [[CONDE]], label [[USE]], label [[EXIT:%.*]]
; CHECK:       Use:
; CHECK-NEXT:    [[COND:%.*]] = call i1 @bar(i32 [[A]])
; CHECK-NEXT:    br i1 [[COND]], label [[SUCC]], label [[EXIT]]
; CHECK:       Exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %Succ

Succ:		; preds = %Use, %entry
  ; This phi is used somewhere else than Succ, but this should not prevent
  ; merging this block
  %a = phi i32 [ 1, %entry ], [ 0, %Use ]		; <i32> [#uses=1]
  br label %BB.tomerge

BB.tomerge:		; preds = %Succ
  %conde = call i1 @foo( )		; <i1> [#uses=1]
  br i1 %conde, label %Use, label %Exit

Use:		; preds = %Succ
  %cond = call i1 @bar( i32 %a )		; <i1> [#uses=1]
  br i1 %cond, label %Succ, label %Exit

Exit:		; preds = %Use, %Succ
  ret void
}
