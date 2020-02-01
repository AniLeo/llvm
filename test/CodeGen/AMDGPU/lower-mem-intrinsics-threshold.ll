; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -amdgpu-lower-intrinsics -amdgpu-mem-intrinsic-expand-size=8 %s | FileCheck -check-prefix=OPT8 %s
; RUN: opt -S -amdgpu-lower-intrinsics -amdgpu-mem-intrinsic-expand-size=4 %s | FileCheck -check-prefix=OPT4 %s
; RUN: opt -S -amdgpu-lower-intrinsics -amdgpu-mem-intrinsic-expand-size=0 %s | FileCheck -check-prefix=OPT0 %s
; RUN: opt -S -amdgpu-lower-intrinsics -amdgpu-mem-intrinsic-expand-size=-1 %s | FileCheck -check-prefix=OPT_NEG %s

; Test the -amdgpu-mem-intrinsic-expand-size flag works.

; Make sure we can always eliminate the intrinsic, even at 0.
define amdgpu_kernel void @memset_size_0(i8 addrspace(1)* %dst, i8 %val) {
; OPT8-LABEL: @memset_size_0(
; OPT8-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 0, i1 false)
; OPT8-NEXT:    ret void
;
; OPT4-LABEL: @memset_size_0(
; OPT4-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 0, i1 false)
; OPT4-NEXT:    ret void
;
; OPT0-LABEL: @memset_size_0(
; OPT0-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 0, i1 false)
; OPT0-NEXT:    ret void
;
; OPT_NEG-LABEL: @memset_size_0(
; OPT_NEG-NEXT:    br i1 true, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT_NEG:       loadstoreloop:
; OPT_NEG-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT_NEG-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT_NEG-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT_NEG-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT_NEG-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 0
; OPT_NEG-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT_NEG:       split:
; OPT_NEG-NEXT:    ret void
;
  call void @llvm.memset.p1i8.i64(i8 addrspace(1)* %dst, i8 %val, i64 0, i1 false)
  ret void
}

define amdgpu_kernel void @memset_size_4(i8 addrspace(1)* %dst, i8 %val) {
; OPT8-LABEL: @memset_size_4(
; OPT8-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 4, i1 false)
; OPT8-NEXT:    ret void
;
; OPT4-LABEL: @memset_size_4(
; OPT4-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 4, i1 false)
; OPT4-NEXT:    ret void
;
; OPT0-LABEL: @memset_size_4(
; OPT0-NEXT:    br i1 false, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT0:       loadstoreloop:
; OPT0-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT0-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT0-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT0-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT0-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 4
; OPT0-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT0:       split:
; OPT0-NEXT:    ret void
;
; OPT_NEG-LABEL: @memset_size_4(
; OPT_NEG-NEXT:    br i1 false, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT_NEG:       loadstoreloop:
; OPT_NEG-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT_NEG-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT_NEG-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT_NEG-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT_NEG-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 4
; OPT_NEG-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT_NEG:       split:
; OPT_NEG-NEXT:    ret void
;
  call void @llvm.memset.p1i8.i64(i8 addrspace(1)* %dst, i8 %val, i64 4, i1 false)
  ret void
}

define amdgpu_kernel void @memset_size_8(i8 addrspace(1)* %dst, i8 %val) {
; OPT8-LABEL: @memset_size_8(
; OPT8-NEXT:    call void @llvm.memset.p1i8.i64(i8 addrspace(1)* [[DST:%.*]], i8 [[VAL:%.*]], i64 8, i1 false)
; OPT8-NEXT:    ret void
;
; OPT4-LABEL: @memset_size_8(
; OPT4-NEXT:    br i1 false, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT4:       loadstoreloop:
; OPT4-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT4-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT4-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT4-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT4-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 8
; OPT4-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT4:       split:
; OPT4-NEXT:    ret void
;
; OPT0-LABEL: @memset_size_8(
; OPT0-NEXT:    br i1 false, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT0:       loadstoreloop:
; OPT0-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT0-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT0-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT0-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT0-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 8
; OPT0-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT0:       split:
; OPT0-NEXT:    ret void
;
; OPT_NEG-LABEL: @memset_size_8(
; OPT_NEG-NEXT:    br i1 false, label [[SPLIT:%.*]], label [[LOADSTORELOOP:%.*]]
; OPT_NEG:       loadstoreloop:
; OPT_NEG-NEXT:    [[TMP1:%.*]] = phi i64 [ 0, [[TMP0:%.*]] ], [ [[TMP3:%.*]], [[LOADSTORELOOP]] ]
; OPT_NEG-NEXT:    [[TMP2:%.*]] = getelementptr inbounds i8, i8 addrspace(1)* [[DST:%.*]], i64 [[TMP1]]
; OPT_NEG-NEXT:    store i8 [[VAL:%.*]], i8 addrspace(1)* [[TMP2]]
; OPT_NEG-NEXT:    [[TMP3]] = add i64 [[TMP1]], 1
; OPT_NEG-NEXT:    [[TMP4:%.*]] = icmp ult i64 [[TMP3]], 8
; OPT_NEG-NEXT:    br i1 [[TMP4]], label [[LOADSTORELOOP]], label [[SPLIT]]
; OPT_NEG:       split:
; OPT_NEG-NEXT:    ret void
;
  call void @llvm.memset.p1i8.i64(i8 addrspace(1)* %dst, i8 %val, i64 8, i1 false)
  ret void
}

declare void @llvm.memset.p1i8.i64(i8 addrspace(1)* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nounwind willreturn writeonly }
