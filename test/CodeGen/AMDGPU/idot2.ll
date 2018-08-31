; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn -mcpu=gfx700 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX7 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx803 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX8 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-NODL %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx906 -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX9-DL %s

; add(mul(S0.x, S1.y),
;     add (mul (S0.y, S1.y), S3)) -> v_dot2_{I|U}32_{I|U}16(S1, S2, S3)

define amdgpu_kernel void @udot2(<2 x i16> addrspace(1)* %src1,
                                 <2 x i16> addrspace(1)* %src2,
                                 i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

; TODO: Support this pattern
;      add(S3,
;          add (mul (S0.y, S1.y), mul (S0.y, S1.y))) -> v_dot2_{I|U}32_{I|U}16(S1, S2, S3)
define amdgpu_kernel void @udot2_MulMul(<2 x i16> addrspace(1)* %src1,
                                        <2 x i16> addrspace(1)* %src2,
                                        i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3
  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %mul1
  %add6 = add i32 %add, %s3
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2(<2 x i16> addrspace(1)* %src1,
                                 <2 x i16> addrspace(1)* %src2,
                                 i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = sext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = sext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = sext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2_MixedTypedMul(<2 x i16> addrspace(1)* %src1,
                                               <2 x i16> addrspace(1)* %src2,
                                               i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = sext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_alt_AddOperands(<2 x i16> addrspace(1)* %src1,
                                                 <2 x i16> addrspace(1)* %src2,
                                                 i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %s3, %mul2
  %add6 = add i32 %mul1, %add
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2_MixedExt(<2 x i16> addrspace(1)* %src1,
                                          <2 x i16> addrspace(1)* %src2,
                                          i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = sext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = sext i16 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @notudot2_SameVec(<2 x i16> addrspace(1)* %src1,
                                            <2 x i16> addrspace(1)* %src2,
                                            i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_v4i16(<4 x i16> addrspace(1)* %src1,
                                       <4 x i16> addrspace(1)* %src2,
                                       i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <4 x i16>, <4 x i16> addrspace(1)* %src1
  %vec2 = load <4 x i16>, <4 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <4 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <4 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <4 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <4 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_v4i16_Hi(<4 x i16> addrspace(1)* %src1,
                                          <4 x i16> addrspace(1)* %src2,
                                          i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <4 x i16>, <4 x i16> addrspace(1)* %src1
  %vec2 = load <4 x i16>, <4 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <4 x i16> %vec1, i64 2
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <4 x i16> %vec2, i64 2
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <4 x i16> %vec1, i64 3
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <4 x i16> %vec2, i64 3
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @notudot2_v4i16_Even(<4 x i16> addrspace(1)* %src1,
                                               <4 x i16> addrspace(1)* %src2,
                                               i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <4 x i16>, <4 x i16> addrspace(1)* %src1
  %vec2 = load <4 x i16>, <4 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <4 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <4 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <4 x i16> %vec1, i64 2
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <4 x i16> %vec2, i64 2
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @notudot2_v4i16_Middle(<4 x i16> addrspace(1)* %src1,
                                                 <4 x i16> addrspace(1)* %src2,
                                                 i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <4 x i16>, <4 x i16> addrspace(1)* %src1
  %vec2 = load <4 x i16>, <4 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <4 x i16> %vec1, i64 1
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <4 x i16> %vec2, i64 1
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <4 x i16> %vec1, i64 2
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <4 x i16> %vec2, i64 2
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @notudot2_DiffIndex(<2 x i16> addrspace(1)* %src1,
                                              <2 x i16> addrspace(1)* %src2,
                                              i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 1
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 0
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_MultipleUses_add1(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add1 = add i32 %mul2, %s3
  %add2 = add i32 %add1, %mul1

  %res = add i32 %add2, %add1
  store i32 %res, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2_MultipleUses_add1(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = sext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = sext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = sext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add1 = add i32 %mul2, %s3
  %add2 = add i32 %add1, %mul1

  %res = add i32 %add2, %add1
  store i32 %res, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_MultipleUses_mul1(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add0 = add i32 %mul1, %s3

  %add1 = add i32 %mul2, %add0
  %add2 = add i32 %add1, %mul1

  store i32 %add2, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2_MultipleUses_mul1(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = sext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = sext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = sext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add0 = add i32 %mul1, %s3

  %add1 = add i32 %mul2, %add0
  %add2 = add i32 %add1, %mul1

  store i32 %add2, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_MultipleUses_mul2(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = zext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = zext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = zext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = zext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add0 = add i32 %mul2, %s3

  %add1 = add i32 %mul2, %add0
  %add2 = add i32 %add1, %mul1

  store i32 %add2, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @idot2_MultipleUses_mul2(<2 x i16> addrspace(1)* %src1,
                                                   <2 x i16> addrspace(1)* %src2,
                                                   i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %vec2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i16> %vec1, i64 0
  %conv = sext i16 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i16> %vec2, i64 0
  %conv2 = sext i16 %s2.elt1 to i32
  %mul1 = mul i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i16> %vec1, i64 1
  %conv3 = sext i16 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i16> %vec2, i64 1
  %conv4 = sext i16 %s2.elt2 to i32
  %mul2 = mul i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add0 = add i32 %mul2, %s3

  %add1 = add i32 %mul2, %add0
  %add2 = add i32 %add1, %mul1

  store i32 %add2, i32 addrspace(1)* %dst, align 4
  ret void
}

define amdgpu_kernel void @udot2_acc16(<2 x i16> addrspace(1)* %src1,
                                       <2 x i16> addrspace(1)* %src2,
                                       i16 addrspace(1)* nocapture %dst) {
entry:
  %v1 = load <2 x i16>, <2 x i16> addrspace(1)* %src1
  %v2 = load <2 x i16>, <2 x i16> addrspace(1)* %src2

  %v1e1 = extractelement <2 x i16> %v1, i64 0
  %v2e1 = extractelement <2 x i16> %v2, i64 0
  %mul1 = mul i16 %v1e1, %v2e1

  %v1e2 = extractelement <2 x i16> %v1, i64 1
  %v2e2 = extractelement <2 x i16> %v2, i64 1
  %mul2 = mul i16 %v1e2, %v2e2

  %s2 = load i16, i16 addrspace(1)* %dst, align 2
  %add1 = add i16 %mul2, %s2
  %add2 = add i16 %add1, %mul1
  store i16 %add2, i16 addrspace(1)* %dst, align 2
  ret void
}

define amdgpu_kernel void @notsdot2_sext8(<2 x i8> addrspace(1)* %src1,
                                          <2 x i8> addrspace(1)* %src2,
                                          i32 addrspace(1)* nocapture %dst) {
entry:
  %vec1 = load <2 x i8>, <2 x i8> addrspace(1)* %src1
  %vec2 = load <2 x i8>, <2 x i8> addrspace(1)* %src2

  %s1.elt1 = extractelement <2 x i8> %vec1, i64 0
  %conv = sext i8 %s1.elt1 to i32
  %s2.elt1 = extractelement <2 x i8> %vec2, i64 0
  %conv2 = sext i8 %s2.elt1 to i32
  %mul1 = mul nuw i32 %conv2, %conv

  %s1.elt2 = extractelement <2 x i8> %vec1, i64 1
  %conv3 = sext i8 %s1.elt2 to i32
  %s2.elt2 = extractelement <2 x i8> %vec2, i64 1
  %conv4 = sext i8 %s2.elt2 to i32
  %mul2 = mul nuw i32 %conv4, %conv3

  %s3 = load i32, i32 addrspace(1)* %dst, align 4
  %add = add i32 %mul2, %s3
  %add6 = add i32 %add, %mul1
  store i32 %add6, i32 addrspace(1)* %dst, align 4
  ret void
}
