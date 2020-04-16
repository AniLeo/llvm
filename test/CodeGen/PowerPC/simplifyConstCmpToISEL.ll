; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=powerpc64le-unknown-unknown -mcpu=pwr8 \
; RUN:   -ppc-convert-rr-to-ri -verify-machineinstrs | FileCheck %s
define void @test(i32 zeroext %parts) {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmplwi 3, 1
; CHECK-NEXT:    bnelr+ 0
; CHECK-NEXT:  # %bb.1: # %test2.exit.us.unr-lcssa
; CHECK-NEXT:    ld 3, 0(3)
; CHECK-NEXT:    std 3, 0(3)
entry:
  br label %cond.end.i

cond.end.i:                                       ; preds = %entry
  %cmp18.i = icmp eq i32 %parts, 1
  br i1 %cmp18.i, label %while.body.lr.ph.i.us.preheader, label %test3.exit.split

while.body.lr.ph.i.us.preheader:                  ; preds = %cond.end.i
  %0 = icmp eq i32 %parts, 1
  br label %for.body.i62.us.preheader

for.body.i62.us.preheader:                        ; preds = %while.body.lr.ph.i.us.preheader
  br i1 %0, label %test2.exit.us.unr-lcssa, label %for.body.i62.us.preheader.new

for.body.i62.us.preheader.new:                    ; preds = %for.body.i62.us.preheader
  br label %for.body.i62.us

for.body.i62.us:                                  ; preds = %if.end.i.us.1, %for.body.i62.us.preheader.new
  %niter = phi i64 [ undef, %for.body.i62.us.preheader.new ], [ %niter.nsub.1, %if.end.i.us.1 ]
  %cmp8.i.us.1 = icmp uge i64 undef, 0
  br label %if.end.i.us.1

test2.exit.us.unr-lcssa: ; preds = %if.end.i.us.1, %for.body.i62.us.preheader
  %c.addr.036.i.us.unr = phi i64 [ 0, %for.body.i62.us.preheader ], [ %c.addr.1.i.us.1, %if.end.i.us.1 ]
  %1 = load i64, i64* undef, align 8
  %tobool.i61.us.epil = icmp eq i64 %c.addr.036.i.us.unr, 0
  %add.neg.i.us.epil.pn = select i1 %tobool.i61.us.epil, i64 %1, i64 0
  %storemerge269 = sub i64 %add.neg.i.us.epil.pn, 0
  store i64 %storemerge269, i64* undef, align 8
  unreachable

test3.exit.split:             ; preds = %cond.end.i
  ret void

if.end.i.us.1:                                    ; preds = %for.body.i62.us
  %c.addr.1.i.us.1 = zext i1 %cmp8.i.us.1 to i64
  %niter.nsub.1 = add i64 %niter, -2
  %niter.ncmp.1 = icmp eq i64 %niter.nsub.1, 0
  br i1 %niter.ncmp.1, label %test2.exit.us.unr-lcssa, label %for.body.i62.us
}
