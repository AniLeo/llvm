; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

define i32 @leaf() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@leaf
; IS__TUNIT____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@leaf
; IS__CGSCC____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:    ret i32 1
;
  ret i32 1
}

define i32 @self_rec() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@self_rec
; IS__TUNIT____-SAME: () #[[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 4
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@self_rec
; IS__CGSCC____-SAME: () #[[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 4
;
  %a = call i32 @self_rec()
  ret i32 4
}

define i32 @indirect_rec() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@indirect_rec
; IS__TUNIT____-SAME: () #[[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 undef
;
; IS__CGSCC_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@indirect_rec
; IS__CGSCC_OPM-SAME: () #[[ATTR1:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    ret i32 undef
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@indirect_rec
; IS__CGSCC_NPM-SAME: () #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    ret i32 undef
;
  %a = call i32 @indirect_rec2()
  ret i32 %a
}
define i32 @indirect_rec2() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@indirect_rec2
; IS__TUNIT____-SAME: () #[[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 undef
;
; IS__CGSCC_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@indirect_rec2
; IS__CGSCC_OPM-SAME: () #[[ATTR1]] {
; IS__CGSCC_OPM-NEXT:    ret i32 undef
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@indirect_rec2
; IS__CGSCC_NPM-SAME: () #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:    ret i32 undef
;
  %a = call i32 @indirect_rec()
  ret i32 %a
}

define i32 @extern() {
; NOT_CGSCC_OPM: Function Attrs: nosync readnone
; NOT_CGSCC_OPM-LABEL: define {{[^@]+}}@extern
; NOT_CGSCC_OPM-SAME: () #[[ATTR1:[0-9]+]] {
; NOT_CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @k()
; NOT_CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@extern
; IS__CGSCC_OPM-SAME: () #[[ATTR2:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @k()
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
  %a = call i32 @k()
  ret i32 %a
}

; CHECK: Function Attrs
; CHECK-NEXT: declare i32 @k()
declare i32 @k() readnone

define void @intrinsic(i8* %dest, i8* %src, i32 %len) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@intrinsic
; IS__TUNIT____-SAME: (i8* nocapture nofree writeonly [[DEST:%.*]], i8* nocapture nofree readonly [[SRC:%.*]], i32 [[LEN:%.*]]) #[[ATTR3:[0-9]+]] {
; IS__TUNIT____-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture nofree writeonly [[DEST]], i8* noalias nocapture nofree readonly [[SRC]], i32 [[LEN]], i1 noundef false) #[[ATTR8:[0-9]+]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@intrinsic
; IS__CGSCC_OPM-SAME: (i8* nocapture nofree writeonly [[DEST:%.*]], i8* nocapture nofree readonly [[SRC:%.*]], i32 [[LEN:%.*]]) #[[ATTR4:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture nofree writeonly [[DEST]], i8* noalias nocapture nofree readonly [[SRC]], i32 [[LEN]], i1 noundef false) #[[ATTR8:[0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree nosync nounwind willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@intrinsic
; IS__CGSCC_NPM-SAME: (i8* nocapture nofree writeonly [[DEST:%.*]], i8* nocapture nofree readonly [[SRC:%.*]], i32 [[LEN:%.*]]) #[[ATTR3:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noalias nocapture nofree writeonly [[DEST]], i8* noalias nocapture nofree readonly [[SRC]], i32 [[LEN]], i1 noundef false) #[[ATTR7:[0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret void
;
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dest, i8* %src, i32 %len, i1 false)
  ret void
}

; CHECK: Function Attrs
; CHECK-NEXT: declare void @llvm.memcpy.p0i8.p0i8.i32
declare void @llvm.memcpy.p0i8.p0i8.i32(i8*, i8*, i32, i1)

define internal i32 @called_by_norecurse() {
; IS__TUNIT____: Function Attrs: nosync readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@called_by_norecurse
; IS__TUNIT____-SAME: () #[[ATTR1]] {
; IS__TUNIT____-NEXT:    [[A:%.*]] = call i32 @k()
; IS__TUNIT____-NEXT:    ret i32 undef
;
; IS__CGSCC_OPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@called_by_norecurse
; IS__CGSCC_OPM-SAME: () #[[ATTR6:[0-9]+]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @k()
; IS__CGSCC_OPM-NEXT:    ret i32 undef
;
; IS__CGSCC_NPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@called_by_norecurse
; IS__CGSCC_NPM-SAME: () #[[ATTR5:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = call i32 @k()
; IS__CGSCC_NPM-NEXT:    ret i32 undef
;
  %a = call i32 @k()
  ret i32 %a
}
define void @m() norecurse {
; IS__TUNIT____: Function Attrs: norecurse nosync readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@m
; IS__TUNIT____-SAME: () #[[ATTR5:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse() #[[ATTR1]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@m
; IS__CGSCC_OPM-SAME: () #[[ATTR6]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse()
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@m
; IS__CGSCC_NPM-SAME: () #[[ATTR5]] {
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse()
; IS__CGSCC_NPM-NEXT:    ret void
;
  %a = call i32 @called_by_norecurse()
  ret void
}

define internal i32 @called_by_norecurse_indirectly() {
; NOT_CGSCC_OPM: Function Attrs: nosync readnone
; NOT_CGSCC_OPM-LABEL: define {{[^@]+}}@called_by_norecurse_indirectly
; NOT_CGSCC_OPM-SAME: () #[[ATTR1]] {
; NOT_CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @k()
; NOT_CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@called_by_norecurse_indirectly
; IS__CGSCC_OPM-SAME: () #[[ATTR2]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @k()
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
  %a = call i32 @k()
  ret i32 %a
}
define internal i32 @o() {
; IS__TUNIT____: Function Attrs: nosync readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@o
; IS__TUNIT____-SAME: () #[[ATTR1]] {
; IS__TUNIT____-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse_indirectly() #[[ATTR1]]
; IS__TUNIT____-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@o
; IS__CGSCC_OPM-SAME: () #[[ATTR6]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse_indirectly()
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_NPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@o
; IS__CGSCC_NPM-SAME: () #[[ATTR5]] {
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = call i32 @called_by_norecurse_indirectly()
; IS__CGSCC_NPM-NEXT:    ret i32 [[A]]
;
  %a = call i32 @called_by_norecurse_indirectly()
  ret i32 %a
}
define i32 @p() norecurse {
; IS__TUNIT____: Function Attrs: norecurse nosync readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@p
; IS__TUNIT____-SAME: () #[[ATTR5]] {
; IS__TUNIT____-NEXT:    [[A:%.*]] = call i32 @o() #[[ATTR1]]
; IS__TUNIT____-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_OPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@p
; IS__CGSCC_OPM-SAME: () #[[ATTR6]] {
; IS__CGSCC_OPM-NEXT:    [[A:%.*]] = call i32 @o()
; IS__CGSCC_OPM-NEXT:    ret i32 [[A]]
;
; IS__CGSCC_NPM: Function Attrs: norecurse nosync readnone
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@p
; IS__CGSCC_NPM-SAME: () #[[ATTR5]] {
; IS__CGSCC_NPM-NEXT:    [[A:%.*]] = call i32 @o()
; IS__CGSCC_NPM-NEXT:    ret i32 [[A]]
;
  %a = call i32 @o()
  ret i32 %a
}

define void @f(i32 %x)  {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@f
; IS__TUNIT____-SAME: (i32 [[X:%.*]]) #[[ATTR0]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[X_ADDR:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    store i32 [[X]], i32* [[X_ADDR]], align 4
; IS__TUNIT____-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[X]], 0
; IS__TUNIT____-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__TUNIT____:       if.then:
; IS__TUNIT____-NEXT:    br label [[IF_END]]
; IS__TUNIT____:       if.end:
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_OPM-SAME: (i32 [[X:%.*]]) #[[ATTR1]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    [[X_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_OPM-NEXT:    store i32 [[X]], i32* [[X_ADDR]], align 4
; IS__CGSCC_OPM-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[X]], 0
; IS__CGSCC_OPM-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__CGSCC_OPM:       if.then:
; IS__CGSCC_OPM-NEXT:    br label [[IF_END]]
; IS__CGSCC_OPM:       if.end:
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@f
; IS__CGSCC_NPM-SAME: (i32 [[X:%.*]]) #[[ATTR0]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    [[X_ADDR:%.*]] = alloca i32, align 4
; IS__CGSCC_NPM-NEXT:    [[TOBOOL:%.*]] = icmp ne i32 [[X]], 0
; IS__CGSCC_NPM-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__CGSCC_NPM:       if.then:
; IS__CGSCC_NPM-NEXT:    br label [[IF_END]]
; IS__CGSCC_NPM:       if.end:
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  %x.addr = alloca i32, align 4
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32, i32* %x.addr, align 4
  %tobool = icmp ne i32 %0, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:
  call void @g() norecurse
  br label %if.end

if.end:
  ret void
}

define void @g() norecurse {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@g
; IS__TUNIT____-SAME: () #[[ATTR6:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@g
; IS__CGSCC____-SAME: () #[[ATTR0]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret void
;
entry:
  call void @f(i32 0)
  ret void
}

define linkonce_odr i32 @leaf_redefinable() {
; CHECK-LABEL: define {{[^@]+}}@leaf_redefinable() {
; CHECK-NEXT:    ret i32 1
;
  ret i32 1
}

; Call through a function pointer
define i32 @eval_func1(i32 (i32)* , i32) local_unnamed_addr {
; CHECK-LABEL: define {{[^@]+}}@eval_func1
; CHECK-SAME: (i32 (i32)* nocapture nofree noundef nonnull [[TMP0:%.*]], i32 [[TMP1:%.*]]) local_unnamed_addr {
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i32 [[TMP0]](i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %3 = tail call i32 %0(i32 %1) #2
  ret i32 %3
}

define i32 @eval_func2(i32 (i32)* , i32) local_unnamed_addr null_pointer_is_valid{
; NOT_CGSCC_NPM: Function Attrs: null_pointer_is_valid
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@eval_func2
; NOT_CGSCC_NPM-SAME: (i32 (i32)* nocapture nofree noundef [[TMP0:%.*]], i32 [[TMP1:%.*]]) local_unnamed_addr #[[ATTR7:[0-9]+]] {
; NOT_CGSCC_NPM-NEXT:    [[TMP3:%.*]] = tail call i32 [[TMP0]](i32 [[TMP1]])
; NOT_CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
; IS__CGSCC_NPM: Function Attrs: null_pointer_is_valid
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@eval_func2
; IS__CGSCC_NPM-SAME: (i32 (i32)* nocapture nofree noundef [[TMP0:%.*]], i32 [[TMP1:%.*]]) local_unnamed_addr #[[ATTR6:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    [[TMP3:%.*]] = tail call i32 [[TMP0]](i32 [[TMP1]])
; IS__CGSCC_NPM-NEXT:    ret i32 [[TMP3]]
;
  %3 = tail call i32 %0(i32 %1) #2
  ret i32 %3
}

; Call an unknown function in a dead block.
declare void @unknown()
define i32 @call_unknown_in_dead_block() local_unnamed_addr {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@call_unknown_in_dead_block
; IS__TUNIT____-SAME: () local_unnamed_addr #[[ATTR0]] {
; IS__TUNIT____-NEXT:    ret i32 0
; IS__TUNIT____:       Dead:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@call_unknown_in_dead_block
; IS__CGSCC____-SAME: () local_unnamed_addr #[[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32 0
; IS__CGSCC____:       Dead:
; IS__CGSCC____-NEXT:    unreachable
;
  ret i32 0
Dead:
  tail call void @unknown()
  ret i32 1
}

;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nosync readnone }
; IS__TUNIT____: attributes #[[ATTR2:[0-9]+]] = { readnone }
; IS__TUNIT____: attributes #[[ATTR3]] = { argmemonly nofree nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR4:[0-9]+]] = { argmemonly nofree nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR5]] = { norecurse nosync readnone }
; IS__TUNIT____: attributes #[[ATTR6]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR7]] = { null_pointer_is_valid }
; IS__TUNIT____: attributes #[[ATTR8]] = { willreturn }
;.
; IS__CGSCC_OPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR2]] = { nosync readnone }
; IS__CGSCC_OPM: attributes #[[ATTR3:[0-9]+]] = { readnone }
; IS__CGSCC_OPM: attributes #[[ATTR4]] = { argmemonly nofree nosync nounwind willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR5:[0-9]+]] = { argmemonly nofree nounwind willreturn }
; IS__CGSCC_OPM: attributes #[[ATTR6]] = { norecurse nosync readnone }
; IS__CGSCC_OPM: attributes #[[ATTR7]] = { null_pointer_is_valid }
; IS__CGSCC_OPM: attributes #[[ATTR8]] = { willreturn }
;.
; IS__CGSCC_NPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR1]] = { nosync readnone }
; IS__CGSCC_NPM: attributes #[[ATTR2:[0-9]+]] = { readnone }
; IS__CGSCC_NPM: attributes #[[ATTR3]] = { argmemonly nofree nosync nounwind willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR4:[0-9]+]] = { argmemonly nofree nounwind willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR5]] = { norecurse nosync readnone }
; IS__CGSCC_NPM: attributes #[[ATTR6]] = { null_pointer_is_valid }
; IS__CGSCC_NPM: attributes #[[ATTR7]] = { willreturn }
;.
