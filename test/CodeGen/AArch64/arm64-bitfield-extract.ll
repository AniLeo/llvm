; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -codegenprepare -mtriple=arm64-apple=ios -S -o - %s | FileCheck --check-prefix=OPT %s
; RUN: llc < %s -mtriple=arm64-eabi | FileCheck --check-prefix=LLC %s

%struct.X = type { i8, i8, [2 x i8] }
%struct.Y = type { i32, i8 }
%struct.Z = type { i8, i8, [2 x i8], i16 }
%struct.A = type { i64, i8 }

define void @foo(%struct.X* nocapture %x, %struct.Y* nocapture %y) nounwind optsize ssp {
; LLC-LABEL: foo:
; LLC:       // %bb.0:
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    ubfx w8, w8, #3, #1
; LLC-NEXT:    strb w8, [x1, #4]
; LLC-NEXT:    ret
; OPT-LABEL: @foo(
; OPT-NEXT:    [[TMP:%.*]] = bitcast %struct.X* [[X:%.*]] to i32*
; OPT-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TMP]], align 4
; OPT-NEXT:    [[B:%.*]] = getelementptr inbounds [[STRUCT_Y:%.*]], %struct.Y* [[Y:%.*]], i64 0, i32 1
; OPT-NEXT:    [[BF_CLEAR:%.*]] = lshr i32 [[TMP1]], 3
; OPT-NEXT:    [[BF_CLEAR_LOBIT:%.*]] = and i32 [[BF_CLEAR]], 1
; OPT-NEXT:    [[FROMBOOL:%.*]] = trunc i32 [[BF_CLEAR_LOBIT]] to i8
; OPT-NEXT:    store i8 [[FROMBOOL]], i8* [[B]], align 1
; OPT-NEXT:    ret void
  %tmp = bitcast %struct.X* %x to i32*
  %tmp1 = load i32, i32* %tmp, align 4
  %b = getelementptr inbounds %struct.Y, %struct.Y* %y, i64 0, i32 1
  %bf.clear = lshr i32 %tmp1, 3
  %bf.clear.lobit = and i32 %bf.clear, 1
  %frombool = trunc i32 %bf.clear.lobit to i8
  store i8 %frombool, i8* %b, align 1
  ret void
}

define i32 @baz(i64 %cav1.coerce) nounwind {
; LLC-LABEL: baz:
; LLC:       // %bb.0:
; LLC-NEXT:    sbfx w0, w0, #0, #4
; LLC-NEXT:    ret
; OPT-LABEL: @baz(
; OPT-NEXT:    [[TMP:%.*]] = trunc i64 [[CAV1_COERCE:%.*]] to i32
; OPT-NEXT:    [[TMP1:%.*]] = shl i32 [[TMP]], 28
; OPT-NEXT:    [[BF_VAL_SEXT:%.*]] = ashr exact i32 [[TMP1]], 28
; OPT-NEXT:    ret i32 [[BF_VAL_SEXT]]
  %tmp = trunc i64 %cav1.coerce to i32
  %tmp1 = shl i32 %tmp, 28
  %bf.val.sext = ashr exact i32 %tmp1, 28
  ret i32 %bf.val.sext
}

define i32 @bar(i64 %cav1.coerce) nounwind {
; LLC-LABEL: bar:
; LLC:       // %bb.0:
; LLC-NEXT:    sbfx w0, w0, #4, #6
; LLC-NEXT:    ret
; OPT-LABEL: @bar(
; OPT-NEXT:    [[TMP:%.*]] = trunc i64 [[CAV1_COERCE:%.*]] to i32
; OPT-NEXT:    [[CAV1_SROA_0_1_INSERT:%.*]] = shl i32 [[TMP]], 22
; OPT-NEXT:    [[TMP1:%.*]] = ashr i32 [[CAV1_SROA_0_1_INSERT]], 26
; OPT-NEXT:    ret i32 [[TMP1]]
  %tmp = trunc i64 %cav1.coerce to i32
  %cav1.sroa.0.1.insert = shl i32 %tmp, 22
  %tmp1 = ashr i32 %cav1.sroa.0.1.insert, 26
  ret i32 %tmp1
}

define void @fct1(%struct.Z* nocapture %x, %struct.A* nocapture %y) nounwind optsize ssp {
; LLC-LABEL: fct1:
; LLC:       // %bb.0:
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    ubfx x8, x8, #3, #1
; LLC-NEXT:    str x8, [x1]
; LLC-NEXT:    ret
; OPT-LABEL: @fct1(
; OPT-NEXT:    [[TMP:%.*]] = bitcast %struct.Z* [[X:%.*]] to i64*
; OPT-NEXT:    [[TMP1:%.*]] = load i64, i64* [[TMP]], align 4
; OPT-NEXT:    [[B1:%.*]] = bitcast %struct.A* [[Y:%.*]] to i64*
; OPT-NEXT:    [[BF_CLEAR:%.*]] = lshr i64 [[TMP1]], 3
; OPT-NEXT:    [[BF_CLEAR_LOBIT:%.*]] = and i64 [[BF_CLEAR]], 1
; OPT-NEXT:    store i64 [[BF_CLEAR_LOBIT]], i64* [[B1]], align 8
; OPT-NEXT:    ret void
  %tmp = bitcast %struct.Z* %x to i64*
  %tmp1 = load i64, i64* %tmp, align 4
  %b = getelementptr inbounds %struct.A, %struct.A* %y, i64 0, i32 0
  %bf.clear = lshr i64 %tmp1, 3
  %bf.clear.lobit = and i64 %bf.clear, 1
  store i64 %bf.clear.lobit, i64* %b, align 8
  ret void
}

define i64 @fct2(i64 %cav1.coerce) nounwind {
; LLC-LABEL: fct2:
; LLC:       // %bb.0:
; LLC-NEXT:    sbfx x0, x0, #0, #36
; LLC-NEXT:    ret
; OPT-LABEL: @fct2(
; OPT-NEXT:    [[TMP:%.*]] = shl i64 [[CAV1_COERCE:%.*]], 28
; OPT-NEXT:    [[BF_VAL_SEXT:%.*]] = ashr exact i64 [[TMP]], 28
; OPT-NEXT:    ret i64 [[BF_VAL_SEXT]]
  %tmp = shl i64 %cav1.coerce, 28
  %bf.val.sext = ashr exact i64 %tmp, 28
  ret i64 %bf.val.sext
}

define i64 @fct3(i64 %cav1.coerce) nounwind {
; LLC-LABEL: fct3:
; LLC:       // %bb.0:
; LLC-NEXT:    sbfx x0, x0, #4, #38
; LLC-NEXT:    ret
; OPT-LABEL: @fct3(
; OPT-NEXT:    [[CAV1_SROA_0_1_INSERT:%.*]] = shl i64 [[CAV1_COERCE:%.*]], 22
; OPT-NEXT:    [[TMP1:%.*]] = ashr i64 [[CAV1_SROA_0_1_INSERT]], 26
; OPT-NEXT:    ret i64 [[TMP1]]
  %cav1.sroa.0.1.insert = shl i64 %cav1.coerce, 22
  %tmp1 = ashr i64 %cav1.sroa.0.1.insert, 26
  ret i64 %tmp1
}

define void @fct4(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct4:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #16, #24
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct4(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -16777216
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 16777215
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    store i64 [[OR]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -16777216
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 16777215
  %or = or i64 %and, %and1
  store i64 %or, i64* %y, align 8
  ret void
}

define void @fct5(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct5:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct5(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    store i32 [[OR]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  store i32 %or, i32* %y, align 8
  ret void
}

; Check if we can still catch bfm instruction when we drop some low bits
define void @fct6(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct6:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    lsr w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct6(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHR1:%.*]] = lshr i32 [[OR]], 2
; OPT-NEXT:    store i32 [[SHR1]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %shr1 = lshr i32 %or, 2
  store i32 %shr1, i32* %y, align 8
  ret void
}


; Check if we can still catch bfm instruction when we drop some high bits
define void @fct7(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct7:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    lsl w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct7(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i32 [[OR]], 2
; OPT-NEXT:    store i32 [[SHL]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsl is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %shl = shl i32 %or, 2
  store i32 %shl, i32* %y, align 8
  ret void
}


; Check if we can still catch bfm instruction when we drop some low bits
; (i64 version)
define void @fct8(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct8:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    lsr x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct8(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHR1:%.*]] = lshr i64 [[OR]], 2
; OPT-NEXT:    store i64 [[SHR1]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -8
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %shr1 = lshr i64 %or, 2
  store i64 %shr1, i64* %y, align 8
  ret void
}


; Check if we can still catch bfm instruction when we drop some high bits
; (i64 version)
define void @fct9(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct9:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    lsl x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct9(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i64 [[OR]], 2
; OPT-NEXT:    store i64 [[SHL]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -8
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %shl = shl i64 %or, 2
  store i64 %shl, i64* %y, align 8
  ret void
}

; Check if we can catch bfm instruction when lsb is 0 (i.e., no lshr)
; (i32 version)
define void @fct10(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct10:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #0, #3
; LLC-NEXT:    lsl w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct10(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[X:%.*]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i32 [[OR]], 2
; OPT-NEXT:    store i32 [[SHL]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsl is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %and1 = and i32 %x, 7
  %or = or i32 %and, %and1
  %shl = shl i32 %or, 2
  store i32 %shl, i32* %y, align 8
  ret void
}

; Check if we can catch bfm instruction when lsb is 0 (i.e., no lshr)
; (i64 version)
define void @fct11(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct11:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #0, #3
; LLC-NEXT:    lsl x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct11(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -8
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[X:%.*]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i64 [[OR]], 2
; OPT-NEXT:    store i64 [[SHL]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsl is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -8
  %and1 = and i64 %x, 7
  %or = or i64 %and, %and1
  %shl = shl i64 %or, 2
  store i64 %shl, i64* %y, align 8
  ret void
}

define zeroext i1 @fct12bis(i32 %tmp2) unnamed_addr nounwind ssp align 2 {
; LLC-LABEL: fct12bis:
; LLC:       // %bb.0:
; LLC-NEXT:    ubfx w0, w0, #11, #1
; LLC-NEXT:    ret
; OPT-LABEL: @fct12bis(
; OPT-NEXT:    [[AND_I_I:%.*]] = and i32 [[TMP2:%.*]], 2048
; OPT-NEXT:    [[TOBOOL_I_I:%.*]] = icmp ne i32 [[AND_I_I]], 0
; OPT-NEXT:    ret i1 [[TOBOOL_I_I]]
  %and.i.i = and i32 %tmp2, 2048
  %tobool.i.i = icmp ne i32 %and.i.i, 0
  ret i1 %tobool.i.i
}

; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits
define void @fct12(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct12:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    ubfx w8, w8, #2, #28
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct12(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i32 [[OR]], 2
; OPT-NEXT:    [[SHR2:%.*]] = lshr i32 [[SHL]], 4
; OPT-NEXT:    store i32 [[SHR2]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %shl = shl i32 %or, 2
  %shr2 = lshr i32 %shl, 4
  store i32 %shr2, i32* %y, align 8
  ret void
}
define void @fct12_mask(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct12_mask:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    and w8, w8, #0x3ffffff8
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    lsr w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct12_mask(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[LSHR:%.*]] = lshr i32 [[OR]], 2
; OPT-NEXT:    [[MASK:%.*]] = and i32 [[LSHR]], 268435455
; OPT-NEXT:    store i32 [[MASK]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -8
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %lshr = lshr i32 %or, 2
  %mask = and i32 %lshr, 268435455
  store i32 %mask, i32* %y, align 8
  ret void
}

; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits
; (i64 version)
define void @fct13(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct13:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    ubfx x8, x8, #2, #60
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct13(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i64 [[OR]], 2
; OPT-NEXT:    [[SHR2:%.*]] = lshr i64 [[SHL]], 4
; OPT-NEXT:    store i64 [[SHR2]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -8
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %shl = shl i64 %or, 2
  %shr2 = lshr i64 %shl, 4
  store i64 %shr2, i64* %y, align 8
  ret void
}
define void @fct13_mask(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct13_mask:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    and x8, x8, #0x3ffffffffffffff8
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    lsr x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct13_mask(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -8
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[LSHR:%.*]] = lshr i64 [[OR]], 2
; OPT-NEXT:    [[MASK:%.*]] = and i64 [[LSHR]], 1152921504606846975
; OPT-NEXT:    store i64 [[MASK]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -8
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %lshr = lshr i64 %or, 2
  %mask = and i64 %lshr, 1152921504606846975
  store i64 %mask, i64* %y, align 8
  ret void
}


; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits
define void @fct14(i32* nocapture %y, i32 %x, i32 %x1) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct14:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    bfxil w8, w1, #16, #8
; LLC-NEXT:    lsr w8, w8, #4
; LLC-NEXT:    bfxil w8, w2, #5, #3
; LLC-NEXT:    lsl w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct14(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], -256
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 255
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = lshr i32 [[OR]], 4
; OPT-NEXT:    [[AND2:%.*]] = and i32 [[SHL]], -8
; OPT-NEXT:    [[SHR1:%.*]] = lshr i32 [[X1:%.*]], 5
; OPT-NEXT:    [[AND3:%.*]] = and i32 [[SHR1]], 7
; OPT-NEXT:    [[OR1:%.*]] = or i32 [[AND2]], [[AND3]]
; OPT-NEXT:    [[SHL1:%.*]] = shl i32 [[OR1]], 2
; OPT-NEXT:    store i32 [[SHL1]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
; lsl is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, -256
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 255
  %or = or i32 %and, %and1
  %shl = lshr i32 %or, 4
  %and2 = and i32 %shl, -8
  %shr1 = lshr i32 %x1, 5
  %and3 = and i32 %shr1, 7
  %or1 = or i32 %and2, %and3
  %shl1 = shl i32 %or1, 2
  store i32 %shl1, i32* %y, align 8
  ret void
}

; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits
; (i64 version)
define void @fct15(i64* nocapture %y, i64 %x, i64 %x1) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct15:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    bfxil x8, x1, #16, #8
; LLC-NEXT:    lsr x8, x8, #4
; LLC-NEXT:    bfxil x8, x2, #5, #3
; LLC-NEXT:    lsl x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct15(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], -256
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 255
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = lshr i64 [[OR]], 4
; OPT-NEXT:    [[AND2:%.*]] = and i64 [[SHL]], -8
; OPT-NEXT:    [[SHR1:%.*]] = lshr i64 [[X1:%.*]], 5
; OPT-NEXT:    [[AND3:%.*]] = and i64 [[SHR1]], 7
; OPT-NEXT:    [[OR1:%.*]] = or i64 [[AND2]], [[AND3]]
; OPT-NEXT:    [[SHL1:%.*]] = shl i64 [[OR1]], 2
; OPT-NEXT:    store i64 [[SHL1]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; lsr is an alias of ubfm
; lsl is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, -256
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 255
  %or = or i64 %and, %and1
  %shl = lshr i64 %or, 4
  %and2 = and i64 %shl, -8
  %shr1 = lshr i64 %x1, 5
  %and3 = and i64 %shr1, 7
  %or1 = or i64 %and2, %and3
  %shl1 = shl i64 %or1, 2
  store i64 %shl1, i64* %y, align 8
  ret void
}

; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits and a masking operation has to be kept
define void @fct16(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct16:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    mov w9, #33120
; LLC-NEXT:    movk w9, #26, lsl #16
; LLC-NEXT:    and w8, w8, w9
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    ubfx w8, w8, #2, #28
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct16(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], 1737056
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i32 [[OR]], 2
; OPT-NEXT:    [[SHR2:%.*]] = lshr i32 [[SHL]], 4
; OPT-NEXT:    store i32 [[SHR2]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; Create the constant
; Do the masking
; lsr is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, 1737056
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %shl = shl i32 %or, 2
  %shr2 = lshr i32 %shl, 4
  store i32 %shr2, i32* %y, align 8
  ret void
}
define void @fct16_mask(i32* nocapture %y, i32 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct16_mask:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr w8, [x0]
; LLC-NEXT:    mov w9, #33120
; LLC-NEXT:    movk w9, #26, lsl #16
; LLC-NEXT:    and w8, w8, w9
; LLC-NEXT:    bfxil w8, w1, #16, #3
; LLC-NEXT:    lsr w8, w8, #2
; LLC-NEXT:    str w8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct16_mask(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i32, i32* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i32 [[TMP0]], 1737056
; OPT-NEXT:    [[SHR:%.*]] = lshr i32 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i32 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i32 [[AND]], [[AND1]]
; OPT-NEXT:    [[LSHR:%.*]] = lshr i32 [[OR]], 2
; OPT-NEXT:    [[MASK:%.*]] = and i32 [[LSHR]], 268435455
; OPT-NEXT:    store i32 [[MASK]], i32* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; Create the constant
; Do the masking
; lsr is an alias of ubfm
  %0 = load i32, i32* %y, align 8
  %and = and i32 %0, 1737056
  %shr = lshr i32 %x, 16
  %and1 = and i32 %shr, 7
  %or = or i32 %and, %and1
  %lshr = lshr i32 %or, 2
  %mask = and i32 %lshr, 268435455
  store i32 %mask, i32* %y, align 8
  ret void
}


; Check if we can still catch bfm instruction when we drop some high bits
; and some low bits and a masking operation has to be kept
; (i64 version)
define void @fct17(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct17:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    mov w9, #33120
; LLC-NEXT:    movk w9, #26, lsl #16
; LLC-NEXT:    and x8, x8, x9
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    ubfx x8, x8, #2, #60
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct17(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], 1737056
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[SHL:%.*]] = shl i64 [[OR]], 2
; OPT-NEXT:    [[SHR2:%.*]] = lshr i64 [[SHL]], 4
; OPT-NEXT:    store i64 [[SHR2]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; Create the constant
; Do the masking
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, 1737056
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %shl = shl i64 %or, 2
  %shr2 = lshr i64 %shl, 4
  store i64 %shr2, i64* %y, align 8
  ret void
}
define void @fct17_mask(i64* nocapture %y, i64 %x) nounwind optsize inlinehint ssp {
; LLC-LABEL: fct17_mask:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ldr x8, [x0]
; LLC-NEXT:    mov w9, #33120
; LLC-NEXT:    movk w9, #26, lsl #16
; LLC-NEXT:    and x8, x8, x9
; LLC-NEXT:    bfxil x8, x1, #16, #3
; LLC-NEXT:    lsr x8, x8, #2
; LLC-NEXT:    str x8, [x0]
; LLC-NEXT:    ret
; OPT-LABEL: @fct17_mask(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[Y:%.*]], align 8
; OPT-NEXT:    [[AND:%.*]] = and i64 [[TMP0]], 1737056
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 16
; OPT-NEXT:    [[AND1:%.*]] = and i64 [[SHR]], 7
; OPT-NEXT:    [[OR:%.*]] = or i64 [[AND]], [[AND1]]
; OPT-NEXT:    [[LSHR:%.*]] = lshr i64 [[OR]], 2
; OPT-NEXT:    [[MASK:%.*]] = and i64 [[LSHR]], 1152921504606846975
; OPT-NEXT:    store i64 [[MASK]], i64* [[Y]], align 8
; OPT-NEXT:    ret void
entry:
; Create the constant
; Do the masking
; lsr is an alias of ubfm
  %0 = load i64, i64* %y, align 8
  %and = and i64 %0, 1737056
  %shr = lshr i64 %x, 16
  %and1 = and i64 %shr, 7
  %or = or i64 %and, %and1
  %lshr = lshr i64 %or, 2
  %mask = and i64 %lshr, 1152921504606846975
  store i64 %mask, i64* %y, align 8
  ret void
}

define i64 @fct18(i32 %xor72) nounwind ssp {
; LLC-LABEL: fct18:
; LLC:       // %bb.0:
; LLC-NEXT:    // kill: def $w0 killed $w0 def $x0
; LLC-NEXT:    ubfx x0, x0, #9, #8
; LLC-NEXT:    ret
; OPT-LABEL: @fct18(
; OPT-NEXT:    [[SHR81:%.*]] = lshr i32 [[XOR72:%.*]], 9
; OPT-NEXT:    [[CONV82:%.*]] = zext i32 [[SHR81]] to i64
; OPT-NEXT:    [[RESULT:%.*]] = and i64 [[CONV82]], 255
; OPT-NEXT:    ret i64 [[RESULT]]
  %shr81 = lshr i32 %xor72, 9
  %conv82 = zext i32 %shr81 to i64
  %result = and i64 %conv82, 255
  ret i64 %result
}

; Using the access to the global array to keep the instruction and control flow.
@first_ones = external dso_local global [65536 x i8]

; Function Attrs: nounwind readonly ssp
define i32 @fct19(i64 %arg1) nounwind readonly ssp  {
; LLC-LABEL: fct19:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    lsr x8, x0, #48
; LLC-NEXT:    cbz x8, .LBB26_2
; LLC-NEXT:  // %bb.1: // %if.then
; LLC-NEXT:    adrp x9, first_ones
; LLC-NEXT:    add x9, x9, :lo12:first_ones
; LLC-NEXT:    ldrb w0, [x9, x8]
; LLC-NEXT:    ret
; LLC-NEXT:  .LBB26_2: // %if.end
; LLC-NEXT:    ubfx x8, x0, #32, #16
; LLC-NEXT:    cbz w8, .LBB26_4
; LLC-NEXT:  // %bb.3: // %if.then7
; LLC-NEXT:    adrp x9, first_ones
; LLC-NEXT:    add x9, x9, :lo12:first_ones
; LLC-NEXT:    ldrb w8, [x9, x8]
; LLC-NEXT:    add w0, w8, #16
; LLC-NEXT:    ret
; LLC-NEXT:  .LBB26_4: // %if.end13
; LLC-NEXT:    ubfx x8, x0, #16, #16
; LLC-NEXT:    cbz w8, .LBB26_6
; LLC-NEXT:  // %bb.5: // %if.then17
; LLC-NEXT:    adrp x9, first_ones
; LLC-NEXT:    add x9, x9, :lo12:first_ones
; LLC-NEXT:    ldrb w8, [x9, x8]
; LLC-NEXT:    add w0, w8, #32
; LLC-NEXT:    ret
; LLC-NEXT:  .LBB26_6:
; LLC-NEXT:    mov w0, #64
; LLC-NEXT:    ret
; OPT-LABEL: @fct19(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[X_SROA_1_0_EXTRACT_SHIFT:%.*]] = lshr i64 [[ARG1:%.*]], 16
; OPT-NEXT:    [[X_SROA_1_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[X_SROA_1_0_EXTRACT_SHIFT]] to i16
; OPT-NEXT:    [[X_SROA_5_0_EXTRACT_SHIFT:%.*]] = lshr i64 [[ARG1]], 48
; OPT-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[X_SROA_5_0_EXTRACT_SHIFT]], 0
; OPT-NEXT:    br i1 [[TOBOOL]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; OPT:       if.then:
; OPT-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 [[X_SROA_5_0_EXTRACT_SHIFT]]
; OPT-NEXT:    [[TMP0:%.*]] = load i8, i8* [[ARRAYIDX3]], align 1
; OPT-NEXT:    [[CONV:%.*]] = zext i8 [[TMP0]] to i32
; OPT-NEXT:    br label [[RETURN:%.*]]
; OPT:       if.end:
; OPT-NEXT:    [[TMP1:%.*]] = lshr i64 [[ARG1]], 32
; OPT-NEXT:    [[X_SROA_3_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[TMP1]] to i16
; OPT-NEXT:    [[TOBOOL6:%.*]] = icmp eq i16 [[X_SROA_3_0_EXTRACT_TRUNC]], 0
; OPT-NEXT:    br i1 [[TOBOOL6]], label [[IF_END13:%.*]], label [[IF_THEN7:%.*]]
; OPT:       if.then7:
; OPT-NEXT:    [[TMP2:%.*]] = lshr i64 [[ARG1]], 32
; OPT-NEXT:    [[IDXPROM10:%.*]] = and i64 [[TMP2]], 65535
; OPT-NEXT:    [[ARRAYIDX11:%.*]] = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 [[IDXPROM10]]
; OPT-NEXT:    [[TMP3:%.*]] = load i8, i8* [[ARRAYIDX11]], align 1
; OPT-NEXT:    [[CONV12:%.*]] = zext i8 [[TMP3]] to i32
; OPT-NEXT:    [[ADD:%.*]] = add nsw i32 [[CONV12]], 16
; OPT-NEXT:    br label [[RETURN]]
; OPT:       if.end13:
; OPT-NEXT:    [[TMP4:%.*]] = lshr i64 [[ARG1]], 16
; OPT-NEXT:    [[TMP5:%.*]] = trunc i64 [[TMP4]] to i16
; OPT-NEXT:    [[TOBOOL16:%.*]] = icmp eq i16 [[TMP5]], 0
; OPT-NEXT:    br i1 [[TOBOOL16]], label [[RETURN]], label [[IF_THEN17:%.*]]
; OPT:       if.then17:
; OPT-NEXT:    [[TMP6:%.*]] = lshr i64 [[ARG1]], 16
; OPT-NEXT:    [[IDXPROM20:%.*]] = and i64 [[TMP6]], 65535
; OPT-NEXT:    [[ARRAYIDX21:%.*]] = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 [[IDXPROM20]]
; OPT-NEXT:    [[TMP7:%.*]] = load i8, i8* [[ARRAYIDX21]], align 1
; OPT-NEXT:    [[CONV22:%.*]] = zext i8 [[TMP7]] to i32
; OPT-NEXT:    [[ADD23:%.*]] = add nsw i32 [[CONV22]], 32
; OPT-NEXT:    br label [[RETURN]]
; OPT:       return:
; OPT-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[CONV]], [[IF_THEN]] ], [ [[ADD]], [[IF_THEN7]] ], [ [[ADD23]], [[IF_THEN17]] ], [ 64, [[IF_END13]] ]
; OPT-NEXT:    ret i32 [[RETVAL_0]]
entry:
  %x.sroa.1.0.extract.shift = lshr i64 %arg1, 16
  %x.sroa.1.0.extract.trunc = trunc i64 %x.sroa.1.0.extract.shift to i16
  %x.sroa.3.0.extract.shift = lshr i64 %arg1, 32
  %x.sroa.5.0.extract.shift = lshr i64 %arg1, 48
  %tobool = icmp eq i64 %x.sroa.5.0.extract.shift, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %arrayidx3 = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 %x.sroa.5.0.extract.shift
  %0 = load i8, i8* %arrayidx3, align 1
  %conv = zext i8 %0 to i32
  br label %return

if.end:                                           ; preds = %entry
  %x.sroa.3.0.extract.trunc = trunc i64 %x.sroa.3.0.extract.shift to i16
  %tobool6 = icmp eq i16 %x.sroa.3.0.extract.trunc, 0
  br i1 %tobool6, label %if.end13, label %if.then7

if.then7:                                         ; preds = %if.end
; "and" should be combined to "ubfm" while "ubfm" should be removed by cse.
; So neither of them should be in the assemble code.
  %idxprom10 = and i64 %x.sroa.3.0.extract.shift, 65535
  %arrayidx11 = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 %idxprom10
  %1 = load i8, i8* %arrayidx11, align 1
  %conv12 = zext i8 %1 to i32
  %add = add nsw i32 %conv12, 16
  br label %return

if.end13:                                         ; preds = %if.end
  %tobool16 = icmp eq i16 %x.sroa.1.0.extract.trunc, 0
  br i1 %tobool16, label %return, label %if.then17

if.then17:                                        ; preds = %if.end13
; "and" should be combined to "ubfm" while "ubfm" should be removed by cse.
; So neither of them should be in the assemble code.
  %idxprom20 = and i64 %x.sroa.1.0.extract.shift, 65535
  %arrayidx21 = getelementptr inbounds [65536 x i8], [65536 x i8]* @first_ones, i64 0, i64 %idxprom20
  %2 = load i8, i8* %arrayidx21, align 1
  %conv22 = zext i8 %2 to i32
  %add23 = add nsw i32 %conv22, 32
  br label %return

return:                                           ; preds = %if.end13, %if.then17, %if.then7, %if.then
  %retval.0 = phi i32 [ %conv, %if.then ], [ %add, %if.then7 ], [ %add23, %if.then17 ], [ 64, %if.end13 ]
  ret i32 %retval.0
}

; Make sure we do not assert if the immediate in and is bigger than i64.
; PR19503.
define i80 @fct20(i128 %a, i128 %b) {
; LLC-LABEL: fct20:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    mov x12, #11776
; LLC-NEXT:    extr x9, x1, x0, #18
; LLC-NEXT:    movk x12, #25856, lsl #16
; LLC-NEXT:    lsr x8, x1, #18
; LLC-NEXT:    movk x12, #11077, lsl #32
; LLC-NEXT:    orr x10, x2, x3
; LLC-NEXT:    mov w11, #26220
; LLC-NEXT:    movk x12, #45, lsl #48
; LLC-NEXT:    and x11, x8, x11
; LLC-NEXT:    and x12, x9, x12
; LLC-NEXT:    cmp x10, #0
; LLC-NEXT:    csel x0, x12, x9, eq
; LLC-NEXT:    csel x1, x11, x8, eq
; LLC-NEXT:    ret
; OPT-LABEL: @fct20(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[SHR:%.*]] = lshr i128 [[A:%.*]], 18
; OPT-NEXT:    [[CONV:%.*]] = trunc i128 [[SHR]] to i80
; OPT-NEXT:    [[TOBOOL:%.*]] = icmp eq i128 [[B:%.*]], 0
; OPT-NEXT:    br i1 [[TOBOOL]], label [[THEN:%.*]], label [[END:%.*]]
; OPT:       then:
; OPT-NEXT:    [[AND:%.*]] = and i128 [[SHR]], 483673642326615442599424
; OPT-NEXT:    [[CONV2:%.*]] = trunc i128 [[AND]] to i80
; OPT-NEXT:    br label [[END]]
; OPT:       end:
; OPT-NEXT:    [[CONV3:%.*]] = phi i80 [ [[CONV]], [[ENTRY:%.*]] ], [ [[CONV2]], [[THEN]] ]
; OPT-NEXT:    ret i80 [[CONV3]]
entry:
  %shr = lshr i128 %a, 18
  %conv = trunc i128 %shr to i80
  %tobool = icmp eq i128 %b, 0
  br i1 %tobool, label %then, label %end
then:
  %and = and i128 %shr, 483673642326615442599424
  %conv2 = trunc i128 %and to i80
  br label %end
end:
  %conv3 = phi i80 [%conv, %entry], [%conv2, %then]
  ret i80 %conv3
}

; Check if we can still catch UBFX when "AND" is used by SHL.
@arr = external dso_local global [8 x [64 x i64]]
define i64 @fct21(i64 %x) {
; LLC-LABEL: fct21:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    ubfx x8, x0, #4, #4
; LLC-NEXT:    adrp x9, arr
; LLC-NEXT:    add x9, x9, :lo12:arr
; LLC-NEXT:    ldr x0, [x9, x8, lsl #3]
; LLC-NEXT:    ret
; OPT-LABEL: @fct21(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[SHR:%.*]] = lshr i64 [[X:%.*]], 4
; OPT-NEXT:    [[AND:%.*]] = and i64 [[SHR]], 15
; OPT-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [8 x [64 x i64]], [8 x [64 x i64]]* @arr, i64 0, i64 0, i64 [[AND]]
; OPT-NEXT:    [[TMP0:%.*]] = load i64, i64* [[ARRAYIDX]], align 8
; OPT-NEXT:    ret i64 [[TMP0]]
entry:
  %shr = lshr i64 %x, 4
  %and = and i64 %shr, 15
  %arrayidx = getelementptr inbounds [8 x [64 x i64]], [8 x [64 x i64]]* @arr, i64 0, i64 0, i64 %and
  %0 = load i64, i64* %arrayidx, align 8
  ret i64 %0
}

define i16 @test_ignored_rightbits(i32 %dst, i32 %in) {
; LLC-LABEL: test_ignored_rightbits:
; LLC:       // %bb.0:
; LLC-NEXT:    and w0, w0, #0x7
; LLC-NEXT:    bfi w0, w1, #3, #4
; LLC-NEXT:    bfi w0, w0, #8, #7
; LLC-NEXT:    ret
; OPT-LABEL: @test_ignored_rightbits(
; OPT-NEXT:    [[POSITIONED_FIELD:%.*]] = shl i32 [[IN:%.*]], 3
; OPT-NEXT:    [[POSITIONED_MASKED_FIELD:%.*]] = and i32 [[POSITIONED_FIELD]], 120
; OPT-NEXT:    [[MASKED_DST:%.*]] = and i32 [[DST:%.*]], 7
; OPT-NEXT:    [[INSERTION:%.*]] = or i32 [[MASKED_DST]], [[POSITIONED_MASKED_FIELD]]
; OPT-NEXT:    [[SHL16:%.*]] = shl i32 [[INSERTION]], 8
; OPT-NEXT:    [[OR18:%.*]] = or i32 [[SHL16]], [[INSERTION]]
; OPT-NEXT:    [[CONV19:%.*]] = trunc i32 [[OR18]] to i16
; OPT-NEXT:    ret i16 [[CONV19]]
  %positioned_field = shl i32 %in, 3
  %positioned_masked_field = and i32 %positioned_field, 120
  %masked_dst = and i32 %dst, 7
  %insertion = or i32 %masked_dst, %positioned_masked_field

  %shl16 = shl i32 %insertion, 8
  %or18 = or i32 %shl16, %insertion
  %conv19 = trunc i32 %or18 to i16

  ret i16 %conv19
}

; The following test excercises the case where we have a BFI
; instruction with the same input in both operands. We need to
; track the useful bits through both operands.
define void @sameOperandBFI(i64 %src, i64 %src2, i16 *%ptr) {
; LLC-LABEL: sameOperandBFI:
; LLC:       // %bb.0: // %entry
; LLC-NEXT:    cbnz wzr, .LBB30_2
; LLC-NEXT:  // %bb.1: // %if.else
; LLC-NEXT:    lsr x8, x0, #47
; LLC-NEXT:    and w9, w1, #0x3
; LLC-NEXT:    bfi w9, w8, #2, #2
; LLC-NEXT:    bfi w9, w9, #4, #4
; LLC-NEXT:    strh w9, [x2]
; LLC-NEXT:  .LBB30_2: // %end
; LLC-NEXT:    ret
; OPT-LABEL: @sameOperandBFI(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[SHR47:%.*]] = lshr i64 [[SRC:%.*]], 47
; OPT-NEXT:    [[SRC2_TRUNC:%.*]] = trunc i64 [[SRC2:%.*]] to i32
; OPT-NEXT:    br i1 undef, label [[END:%.*]], label [[IF_ELSE:%.*]]
; OPT:       if.else:
; OPT-NEXT:    [[AND3:%.*]] = and i32 [[SRC2_TRUNC]], 3
; OPT-NEXT:    [[SHL2:%.*]] = shl nuw nsw i64 [[SHR47]], 2
; OPT-NEXT:    [[SHL2_TRUNC:%.*]] = trunc i64 [[SHL2]] to i32
; OPT-NEXT:    [[AND12:%.*]] = and i32 [[SHL2_TRUNC]], 12
; OPT-NEXT:    [[BFISOURCE:%.*]] = or i32 [[AND3]], [[AND12]]
; OPT-NEXT:    [[BFIRHS:%.*]] = shl nuw nsw i32 [[BFISOURCE]], 4
; OPT-NEXT:    [[BFI:%.*]] = or i32 [[BFIRHS]], [[BFISOURCE]]
; OPT-NEXT:    [[BFITRUNC:%.*]] = trunc i32 [[BFI]] to i16
; OPT-NEXT:    store i16 [[BFITRUNC]], i16* [[PTR:%.*]], align 4
; OPT-NEXT:    br label [[END]]
; OPT:       end:
; OPT-NEXT:    ret void
entry:
  %shr47 = lshr i64 %src, 47
  %src2.trunc = trunc i64 %src2 to i32
  br i1 undef, label %end, label %if.else

if.else:
  %and3 = and i32 %src2.trunc, 3
  %shl2 = shl nuw nsw i64 %shr47, 2
  %shl2.trunc = trunc i64 %shl2 to i32
  %and12 = and i32 %shl2.trunc, 12
  %BFISource = or i32 %and3, %and12         ; ...00000ABCD
  %BFIRHS = shl nuw nsw i32 %BFISource, 4   ; ...0ABCD0000
  %BFI = or i32 %BFIRHS, %BFISource         ; ...0ABCDABCD
  %BFItrunc = trunc i32 %BFI to i16
  store i16 %BFItrunc, i16* %ptr, align 4
  br label %end

end:
  ret void
}
