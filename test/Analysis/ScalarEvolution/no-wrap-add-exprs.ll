; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -S -analyze -enable-new-pm=0 -scalar-evolution < %s | FileCheck %s
; RUN: opt -S -disable-output "-passes=print<scalar-evolution>" < %s 2>&1 | FileCheck %s

!0 = !{i8 0, i8 127}

define void @f0(i8* %len_addr) {
; CHECK-LABEL: 'f0'
; CHECK-NEXT:  Classifying expressions for: @f0
; CHECK-NEXT:    %len = load i8, i8* %len_addr, align 1, !range !0
; CHECK-NEXT:    --> %len U: [0,127) S: [0,127)
; CHECK-NEXT:    %len_norange = load i8, i8* %len_addr, align 1
; CHECK-NEXT:    --> %len_norange U: full-set S: full-set
; CHECK-NEXT:    %t0 = add i8 %len, 1
; CHECK-NEXT:    --> (1 + %len)<nuw><nsw> U: [1,-128) S: [1,-128)
; CHECK-NEXT:    %t1 = add i8 %len, 2
; CHECK-NEXT:    --> (2 + %len)<nuw> U: [2,-127) S: [2,-127)
; CHECK-NEXT:    %t2 = sub i8 %len, 1
; CHECK-NEXT:    --> (-1 + %len)<nsw> U: [-1,126) S: [-1,126)
; CHECK-NEXT:    %t3 = sub i8 %len, 2
; CHECK-NEXT:    --> (-2 + %len)<nsw> U: [-2,125) S: [-2,125)
; CHECK-NEXT:    %q0 = add i8 %len_norange, 1
; CHECK-NEXT:    --> (1 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q1 = add i8 %len_norange, 2
; CHECK-NEXT:    --> (2 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q2 = sub i8 %len_norange, 1
; CHECK-NEXT:    --> (-1 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q3 = sub i8 %len_norange, 2
; CHECK-NEXT:    --> (-2 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @f0
;
  entry:
  %len = load i8, i8* %len_addr, !range !0
  %len_norange = load i8, i8* %len_addr

  %t0 = add i8 %len, 1
  %t1 = add i8 %len, 2

  %t2 = sub i8 %len, 1
  %t3 = sub i8 %len, 2

  %q0 = add i8 %len_norange, 1
  %q1 = add i8 %len_norange, 2

  %q2 = sub i8 %len_norange, 1
  %q3 = sub i8 %len_norange, 2

  ret void
}

define void @f1(i8* %len_addr) {
; CHECK-LABEL: 'f1'
; CHECK-NEXT:  Classifying expressions for: @f1
; CHECK-NEXT:    %len = load i8, i8* %len_addr, align 1, !range !0
; CHECK-NEXT:    --> %len U: [0,127) S: [0,127)
; CHECK-NEXT:    %len_norange = load i8, i8* %len_addr, align 1
; CHECK-NEXT:    --> %len_norange U: full-set S: full-set
; CHECK-NEXT:    %t0 = add i8 %len, -1
; CHECK-NEXT:    --> (-1 + %len)<nsw> U: [-1,126) S: [-1,126)
; CHECK-NEXT:    %t1 = add i8 %len, -2
; CHECK-NEXT:    --> (-2 + %len)<nsw> U: [-2,125) S: [-2,125)
; CHECK-NEXT:    %t0.sext = sext i8 %t0 to i16
; CHECK-NEXT:    --> (-1 + (zext i8 %len to i16))<nsw> U: [-1,126) S: [-1,126)
; CHECK-NEXT:    %t1.sext = sext i8 %t1 to i16
; CHECK-NEXT:    --> (-2 + (zext i8 %len to i16))<nsw> U: [-2,125) S: [-2,125)
; CHECK-NEXT:    %q0 = add i8 %len_norange, 1
; CHECK-NEXT:    --> (1 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q1 = add i8 %len_norange, 2
; CHECK-NEXT:    --> (2 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q0.sext = sext i8 %q0 to i16
; CHECK-NEXT:    --> (sext i8 (1 + %len_norange) to i16) U: [-128,128) S: [-128,128)
; CHECK-NEXT:    %q1.sext = sext i8 %q1 to i16
; CHECK-NEXT:    --> (sext i8 (2 + %len_norange) to i16) U: [-128,128) S: [-128,128)
; CHECK-NEXT:  Determining loop execution counts for: @f1
;
  entry:
  %len = load i8, i8* %len_addr, !range !0
  %len_norange = load i8, i8* %len_addr

  %t0 = add i8 %len, -1
  %t1 = add i8 %len, -2

  %t0.sext = sext i8 %t0 to i16
  %t1.sext = sext i8 %t1 to i16

  %q0 = add i8 %len_norange, 1
  %q1 = add i8 %len_norange, 2

  %q0.sext = sext i8 %q0 to i16
  %q1.sext = sext i8 %q1 to i16

  ret void
}

define void @f2(i8* %len_addr) {
; CHECK-LABEL: 'f2'
; CHECK-NEXT:  Classifying expressions for: @f2
; CHECK-NEXT:    %len = load i8, i8* %len_addr, align 1, !range !0
; CHECK-NEXT:    --> %len U: [0,127) S: [0,127)
; CHECK-NEXT:    %len_norange = load i8, i8* %len_addr, align 1
; CHECK-NEXT:    --> %len_norange U: full-set S: full-set
; CHECK-NEXT:    %t0 = add i8 %len, 1
; CHECK-NEXT:    --> (1 + %len)<nuw><nsw> U: [1,-128) S: [1,-128)
; CHECK-NEXT:    %t1 = add i8 %len, 2
; CHECK-NEXT:    --> (2 + %len)<nuw> U: [2,-127) S: [2,-127)
; CHECK-NEXT:    %t0.zext = zext i8 %t0 to i16
; CHECK-NEXT:    --> (1 + (zext i8 %len to i16))<nuw><nsw> U: [1,128) S: [1,128)
; CHECK-NEXT:    %t1.zext = zext i8 %t1 to i16
; CHECK-NEXT:    --> (2 + (zext i8 %len to i16))<nuw><nsw> U: [2,129) S: [2,129)
; CHECK-NEXT:    %q0 = add i8 %len_norange, 1
; CHECK-NEXT:    --> (1 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q1 = add i8 %len_norange, 2
; CHECK-NEXT:    --> (2 + %len_norange) U: full-set S: full-set
; CHECK-NEXT:    %q0.zext = zext i8 %q0 to i16
; CHECK-NEXT:    --> (zext i8 (1 + %len_norange) to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:    %q1.zext = zext i8 %q1 to i16
; CHECK-NEXT:    --> (zext i8 (2 + %len_norange) to i16) U: [0,256) S: [0,256)
; CHECK-NEXT:  Determining loop execution counts for: @f2
;
  entry:
  %len = load i8, i8* %len_addr, !range !0
  %len_norange = load i8, i8* %len_addr

  %t0 = add i8 %len, 1
  %t1 = add i8 %len, 2

  %t0.zext = zext i8 %t0 to i16
  %t1.zext = zext i8 %t1 to i16

  %q0 = add i8 %len_norange, 1
  %q1 = add i8 %len_norange, 2
  %q0.zext = zext i8 %q0 to i16
  %q1.zext = zext i8 %q1 to i16


  ret void
}

@z_addr = external global [16 x i8], align 4
@z_addr_noalign = external global [16 x i8]

%union = type { [10 x [4 x float]] }
@tmp_addr = external unnamed_addr global { %union, [2000 x i8] }

define void @f3(i8* %x_addr, i8* %y_addr, i32* %tmp_addr) {
; CHECK-LABEL: 'f3'
; CHECK-NEXT:  Classifying expressions for: @f3
; CHECK-NEXT:    %x = load i8, i8* %x_addr, align 1
; CHECK-NEXT:    --> %x U: full-set S: full-set
; CHECK-NEXT:    %t0 = mul i8 %x, 4
; CHECK-NEXT:    --> (4 * %x) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %t1 = add i8 %t0, 5
; CHECK-NEXT:    --> (5 + (4 * %x)) U: [5,2) S: [-123,-126)
; CHECK-NEXT:    %t1.zext = zext i8 %t1 to i16
; CHECK-NEXT:    --> (1 + (zext i8 (4 + (4 * %x)) to i16))<nuw><nsw> U: [1,254) S: [1,257)
; CHECK-NEXT:    %q0 = mul i8 %x, 4
; CHECK-NEXT:    --> (4 * %x) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %q1 = add i8 %q0, 7
; CHECK-NEXT:    --> (7 + (4 * %x)) U: [7,4) S: [-121,-124)
; CHECK-NEXT:    %q1.zext = zext i8 %q1 to i16
; CHECK-NEXT:    --> (3 + (zext i8 (4 + (4 * %x)) to i16))<nuw><nsw> U: [3,256) S: [3,259)
; CHECK-NEXT:    %p0 = mul i8 %x, 4
; CHECK-NEXT:    --> (4 * %x) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %p1 = add i8 %p0, 8
; CHECK-NEXT:    --> (8 + (4 * %x)) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %p1.zext = zext i8 %p1 to i16
; CHECK-NEXT:    --> (zext i8 (8 + (4 * %x)) to i16) U: [0,253) S: [0,256)
; CHECK-NEXT:    %r0 = mul i8 %x, 4
; CHECK-NEXT:    --> (4 * %x) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %r1 = add i8 %r0, -2
; CHECK-NEXT:    --> (-2 + (4 * %x)) U: [0,-1) S: [-128,127)
; CHECK-NEXT:    %r1.zext = zext i8 %r1 to i16
; CHECK-NEXT:    --> (2 + (zext i8 (-4 + (4 * %x)) to i16))<nuw><nsw> U: [2,255) S: [2,258)
; CHECK-NEXT:    %y = load i8, i8* %y_addr, align 1
; CHECK-NEXT:    --> %y U: full-set S: full-set
; CHECK-NEXT:    %s0 = mul i8 %x, 32
; CHECK-NEXT:    --> (32 * %x) U: [0,-31) S: [-128,97)
; CHECK-NEXT:    %s1 = mul i8 %y, 36
; CHECK-NEXT:    --> (36 * %y) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %s2 = add i8 %s0, %s1
; CHECK-NEXT:    --> ((32 * %x) + (36 * %y)) U: [0,-3) S: [-128,125)
; CHECK-NEXT:    %s3 = add i8 %s2, 5
; CHECK-NEXT:    --> (5 + (32 * %x) + (36 * %y)) U: full-set S: full-set
; CHECK-NEXT:    %s3.zext = zext i8 %s3 to i16
; CHECK-NEXT:    --> (1 + (zext i8 (4 + (32 * %x) + (36 * %y)) to i16))<nuw><nsw> U: [1,254) S: [1,257)
; CHECK-NEXT:    %ptr = bitcast [16 x i8]* @z_addr to i8*
; CHECK-NEXT:    --> @z_addr U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %int0 = ptrtoint i8* %ptr to i32
; CHECK-NEXT:    --> (trunc i64 (ptrtoint [16 x i8]* @z_addr to i64) to i32) U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:    %int5 = add i32 %int0, 5
; CHECK-NEXT:    --> (5 + (trunc i64 (ptrtoint [16 x i8]* @z_addr to i64) to i32)) U: [5,2) S: [-2147483643,-2147483646)
; CHECK-NEXT:    %int.zext = zext i32 %int5 to i64
; CHECK-NEXT:    --> (1 + (zext i32 (4 + (trunc i64 (ptrtoint [16 x i8]* @z_addr to i64) to i32)) to i64))<nuw><nsw> U: [1,4294967294) S: [1,4294967297)
; CHECK-NEXT:    %ptr_noalign = bitcast [16 x i8]* @z_addr_noalign to i8*
; CHECK-NEXT:    --> @z_addr_noalign U: full-set S: full-set
; CHECK-NEXT:    %int0_na = ptrtoint i8* %ptr_noalign to i32
; CHECK-NEXT:    --> (trunc i64 (ptrtoint [16 x i8]* @z_addr_noalign to i64) to i32) U: full-set S: full-set
; CHECK-NEXT:    %int5_na = add i32 %int0_na, 5
; CHECK-NEXT:    --> (5 + (trunc i64 (ptrtoint [16 x i8]* @z_addr_noalign to i64) to i32)) U: full-set S: full-set
; CHECK-NEXT:    %int.zext_na = zext i32 %int5_na to i64
; CHECK-NEXT:    --> (zext i32 (5 + (trunc i64 (ptrtoint [16 x i8]* @z_addr_noalign to i64) to i32)) to i64) U: [0,4294967296) S: [0,4294967296)
; CHECK-NEXT:    %tmp = load i32, i32* %tmp_addr, align 4
; CHECK-NEXT:    --> %tmp U: full-set S: full-set
; CHECK-NEXT:    %mul = and i32 %tmp, -4
; CHECK-NEXT:    --> (4 * (%tmp /u 4))<nuw> U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:    %add4 = add i32 %mul, 4
; CHECK-NEXT:    --> (4 + (4 * (%tmp /u 4))<nuw>) U: [0,-3) S: [-2147483648,2147483645)
; CHECK-NEXT:    %add4.zext = zext i32 %add4 to i64
; CHECK-NEXT:    --> (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64) U: [0,4294967293) S: [0,4294967296)
; CHECK-NEXT:    %sunkaddr3 = mul i64 %add4.zext, 4
; CHECK-NEXT:    --> (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> U: [0,17179869169) S: [0,17179869181)
; CHECK-NEXT:    %sunkaddr4 = getelementptr inbounds i8, i8* bitcast ({ %union, [2000 x i8] }* @tmp_addr to i8*), i64 %sunkaddr3
; CHECK-NEXT:    --> ((4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr)<nsw> U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %sunkaddr5 = getelementptr inbounds i8, i8* %sunkaddr4, i64 4096
; CHECK-NEXT:    --> (4096 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %addr4.cast = bitcast i8* %sunkaddr5 to i32*
; CHECK-NEXT:    --> (4096 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %addr4.incr = getelementptr i32, i32* %addr4.cast, i64 1
; CHECK-NEXT:    --> (4100 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %add5 = add i32 %mul, 5
; CHECK-NEXT:    --> (5 + (4 * (%tmp /u 4))<nuw>) U: [5,2) S: [-2147483643,-2147483646)
; CHECK-NEXT:    %add5.zext = zext i32 %add5 to i64
; CHECK-NEXT:    --> (1 + (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> U: [1,4294967294) S: [1,4294967297)
; CHECK-NEXT:    %sunkaddr0 = mul i64 %add5.zext, 4
; CHECK-NEXT:    --> (4 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw>)<nuw><nsw> U: [4,17179869173) S: [4,17179869185)
; CHECK-NEXT:    %sunkaddr1 = getelementptr inbounds i8, i8* bitcast ({ %union, [2000 x i8] }* @tmp_addr to i8*), i64 %sunkaddr0
; CHECK-NEXT:    --> (4 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %sunkaddr2 = getelementptr inbounds i8, i8* %sunkaddr1, i64 4096
; CHECK-NEXT:    --> (4100 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:    %addr5.cast = bitcast i8* %sunkaddr2 to i32*
; CHECK-NEXT:    --> (4100 + (4 * (zext i32 (4 + (4 * (%tmp /u 4))<nuw>) to i64))<nuw><nsw> + @tmp_addr) U: [0,-3) S: [-9223372036854775808,9223372036854775805)
; CHECK-NEXT:  Determining loop execution counts for: @f3
;
  entry:
  %x = load i8, i8* %x_addr
  %t0 = mul i8 %x, 4
  %t1 = add i8 %t0, 5
  %t1.zext = zext i8 %t1 to i16

  %q0 = mul i8 %x, 4
  %q1 = add i8 %q0, 7
  %q1.zext = zext i8 %q1 to i16

  %p0 = mul i8 %x, 4
  %p1 = add i8 %p0, 8
  %p1.zext = zext i8 %p1 to i16

  %r0 = mul i8 %x, 4
  %r1 = add i8 %r0, 254
  %r1.zext = zext i8 %r1 to i16

  %y = load i8, i8* %y_addr
  %s0 = mul i8 %x, 32
  %s1 = mul i8 %y, 36
  %s2 = add i8 %s0, %s1
  %s3 = add i8 %s2, 5
  %s3.zext = zext i8 %s3 to i16

  %ptr = bitcast [16 x i8]* @z_addr to i8*
  %int0 = ptrtoint i8* %ptr to i32
  %int5 = add i32 %int0, 5
  %int.zext = zext i32 %int5 to i64

  %ptr_noalign = bitcast [16 x i8]* @z_addr_noalign to i8*
  %int0_na = ptrtoint i8* %ptr_noalign to i32
  %int5_na = add i32 %int0_na, 5
  %int.zext_na = zext i32 %int5_na to i64

  %tmp = load i32, i32* %tmp_addr
  %mul = and i32 %tmp, -4
  %add4 = add i32 %mul, 4
  %add4.zext = zext i32 %add4 to i64
  %sunkaddr3 = mul i64 %add4.zext, 4
  %sunkaddr4 = getelementptr inbounds i8, i8* bitcast ({ %union, [2000 x i8] }* @tmp_addr to i8*), i64 %sunkaddr3
  %sunkaddr5 = getelementptr inbounds i8, i8* %sunkaddr4, i64 4096
  %addr4.cast = bitcast i8* %sunkaddr5 to i32*
  %addr4.incr = getelementptr i32, i32* %addr4.cast, i64 1

  %add5 = add i32 %mul, 5
  %add5.zext = zext i32 %add5 to i64
  %sunkaddr0 = mul i64 %add5.zext, 4
  %sunkaddr1 = getelementptr inbounds i8, i8* bitcast ({ %union, [2000 x i8] }* @tmp_addr to i8*), i64 %sunkaddr0
  %sunkaddr2 = getelementptr inbounds i8, i8* %sunkaddr1, i64 4096
  %addr5.cast = bitcast i8* %sunkaddr2 to i32*

  ret void
}
