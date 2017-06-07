; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O2 \
; RUN:   -ppc-asm-full-reg-names -mcpu=pwr8 < %s | FileCheck %s \
; RUN:  --implicit-check-not cmpw --implicit-check-not cmpd --implicit-check-not cmpl

; Function Attrs: nounwind
define signext i32 @logic_ne_32(i32 signext %a, i32 signext %b, i32 signext %c) {
; CHECK-LABEL: logic_ne_32:
; CHECK:    xor r7, r3, r4
; CHECK-NEXT:    li r6, 55
; CHECK-NEXT:    xor r5, r5, r6
; CHECK-NEXT:    or r7, r7, r4
; CHECK-NEXT:    cntlzw r5, r5
; CHECK-NEXT:    cntlzw r6, r7
; CHECK-NEXT:    srwi r6, r6, 5
; CHECK-NEXT:    srwi r5, r5, 5
; CHECK-NEXT:    or. r5, r6, r5
; CHECK-NEXT:    bc 4, 1
entry:
  %tobool = icmp eq i32 %a, %b
  %tobool1 = icmp eq i32 %b, 0
  %or.cond = and i1 %tobool, %tobool1
  %tobool3 = icmp eq i32 %c, 55
  %or.cond5 = or i1 %or.cond, %tobool3
  br i1 %or.cond5, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call signext i32 @foo(i32 signext %a) #2
  br label %return

if.end:                                           ; preds = %entry
  %call4 = tail call signext i32 @bar(i32 signext %b) #2
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ %call4, %if.end ], [ %call, %if.then ]
  ret i32 %retval.0
}

define void @neg_truncate_i32_eq(i32 *%ptr) {
; CHECK-LABEL: neg_truncate_i32_eq:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    lwz r3, 0(r3)
; CHECK-NEXT:    rldicl. r3, r3, 0, 63
; CHECK-NEXT:    bclr 12, 2, 0
; CHECK-NEXT:  # BB#1: # %if.end29.thread136
; CHECK-NEXT:  .LBB1_2: # %if.end29
entry:
  %0 = load i32, i32* %ptr, align 4
  %rem17127 = and i32 %0, 1
  %cmp18 = icmp eq i32 %rem17127, 0
  br label %if.else

if.else:                                          ; preds = %entry
  br i1 %cmp18, label %if.end29, label %if.end29.thread136

if.end29.thread136:                               ; preds = %if.else
  unreachable

if.end29:                                         ; preds = %if.else
  ret void

}

; Function Attrs: nounwind
define i64 @logic_eq_64(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: logic_eq_64:
; CHECK:    xor r7, r3, r4
; CHECK-NEXT:    li r6, 55
; CHECK-NEXT:    xor r5, r5, r6
; CHECK-NEXT:    or r7, r7, r4
; CHECK-NEXT:    cntlzd r6, r7
; CHECK-NEXT:    cntlzd r5, r5
; CHECK-NEXT:    rldicl r6, r6, 58, 63
; CHECK-NEXT:    rldicl r5, r5, 58, 63
; CHECK-NEXT:    or. r5, r6, r5
; CHECK-NEXT:    bc 4, 1
entry:
  %tobool = icmp eq i64 %a, %b
  %tobool1 = icmp eq i64 %b, 0
  %or.cond = and i1 %tobool, %tobool1
  %tobool3 = icmp eq i64 %c, 55
  %or.cond5 = or i1 %or.cond, %tobool3
  br i1 %or.cond5, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i64 @foo64(i64 %a) #2
  br label %return

if.end:                                           ; preds = %entry
  %call4 = tail call i64 @bar64(i64 %b) #2
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i64 [ %call4, %if.end ], [ %call, %if.then ]
  ret i64 %retval.0
}

define void @neg_truncate_i64_eq(i64 *%ptr) {
; CHECK-LABEL: neg_truncate_i64_eq:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    rldicl. r3, r3, 0, 63
; CHECK-NEXT:    bclr 12, 2, 0
; CHECK-NEXT:  # BB#1: # %if.end29.thread136
; CHECK-NEXT:  .LBB3_2: # %if.end29
entry:
  %0 = load i64, i64* %ptr, align 4
  %rem17127 = and i64 %0, 1
  %cmp18 = icmp eq i64 %rem17127, 0
  br label %if.else

if.else:                                          ; preds = %entry
  br i1 %cmp18, label %if.end29, label %if.end29.thread136

if.end29.thread136:                               ; preds = %if.else
  unreachable

if.end29:                                         ; preds = %if.else
  ret void

}

; Function Attrs: nounwind
define i64 @logic_ne_64(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: logic_ne_64:
; CHECK:    xor r7, r3, r4
; CHECK-NEXT:    li r6, 55
; CHECK-NEXT:    addic r8, r7, -1
; CHECK-NEXT:    xor r5, r5, r6
; CHECK-NEXT:    subfe r7, r8, r7
; CHECK-NEXT:    cntlzd r5, r5
; CHECK-NEXT:    addic r12, r4, -1
; CHECK-NEXT:    rldicl r5, r5, 58, 63
; CHECK-NEXT:    subfe r6, r12, r4
; CHECK-NEXT:    and r6, r7, r6
; CHECK-NEXT:    or. r5, r6, r5
; CHECK-NEXT:    bc 4, 1
entry:
  %tobool = icmp ne i64 %a, %b
  %tobool1 = icmp ne i64 %b, 0
  %or.cond = and i1 %tobool, %tobool1
  %tobool3 = icmp eq i64 %c, 55
  %or.cond5 = or i1 %or.cond, %tobool3
  br i1 %or.cond5, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i64 @foo64(i64 %a) #2
  br label %return

if.end:                                           ; preds = %entry
  %call4 = tail call i64 @bar64(i64 %b) #2
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i64 [ %call4, %if.end ], [ %call, %if.then ]
  ret i64 %retval.0
}

define void @neg_truncate_i64_ne(i64 *%ptr) {
; CHECK-LABEL: neg_truncate_i64_ne:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    ld r3, 0(r3)
; CHECK-NEXT:    andi. r3, r3, 1
; CHECK-NEXT:    bclr 12, 1, 0
; CHECK-NEXT:  # BB#1: # %if.end29.thread136
; CHECK-NEXT:  .LBB5_2: # %if.end29
entry:
  %0 = load i64, i64* %ptr, align 4
  %rem17127 = and i64 %0, 1
  %cmp18 = icmp ne i64 %rem17127, 0
  br label %if.else

if.else:                                          ; preds = %entry
  br i1 %cmp18, label %if.end29, label %if.end29.thread136

if.end29.thread136:                               ; preds = %if.else
  unreachable

if.end29:                                         ; preds = %if.else
  ret void

}

declare signext i32 @foo(i32 signext)
declare signext i32 @bar(i32 signext)
declare i64 @foo64(i64)
declare i64 @bar64(i64)
