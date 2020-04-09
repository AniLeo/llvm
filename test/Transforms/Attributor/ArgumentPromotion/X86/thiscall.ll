; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; In PR41658, argpromotion put an inalloca in a position that per the
; calling convention is passed in a register. This test verifies that
; we don't do that anymore. It also verifies that the combination of
; globalopt and argpromotion is able to optimize the call safely.
;
; RUN: opt -S -argpromotion %s | FileCheck %s --check-prefix=ARGPROMOTION
; RUN: opt -S -globalopt -argpromotion %s | FileCheck %s --check-prefix=GLOBALOPT_ARGPROMOTION

target datalayout = "e-m:x-p:32:32-i64:64-f80:32-n8:16:32-a:0:32-S32"
target triple = "i386-pc-windows-msvc19.11.0"

%struct.a = type { i8 }

define internal x86_thiscallcc void @internalfun(%struct.a* %this, <{ %struct.a }>* inalloca) {
; ARGPROMOTION-LABEL: define {{[^@]+}}@internalfun
; ARGPROMOTION-SAME: (%struct.a* [[THIS:%.*]], <{ [[STRUCT_A:%.*]] }>* inalloca [[TMP0:%.*]])
; ARGPROMOTION-NEXT:  entry:
; ARGPROMOTION-NEXT:    [[A:%.*]] = getelementptr inbounds <{ [[STRUCT_A]] }>, <{ [[STRUCT_A]] }>* [[TMP0]], i32 0, i32 0
; ARGPROMOTION-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_A]] }>, align 4
; ARGPROMOTION-NEXT:    [[TMP1:%.*]] = getelementptr inbounds <{ [[STRUCT_A]] }>, <{ [[STRUCT_A]] }>* [[ARGMEM]], i32 0, i32 0
; ARGPROMOTION-NEXT:    [[CALL:%.*]] = call x86_thiscallcc %struct.a* @copy_ctor(%struct.a* [[TMP1]], %struct.a* dereferenceable(1) [[A]])
; ARGPROMOTION-NEXT:    call void @ext(<{ [[STRUCT_A]] }>* inalloca [[ARGMEM]])
; ARGPROMOTION-NEXT:    ret void
;
; GLOBALOPT_ARGPROMOTION-LABEL: define {{[^@]+}}@internalfun
; GLOBALOPT_ARGPROMOTION-SAME: (<{ [[STRUCT_A:%.*]] }>* [[TMP0:%.*]]) unnamed_addr
; GLOBALOPT_ARGPROMOTION-NEXT:  entry:
; GLOBALOPT_ARGPROMOTION-NEXT:    [[A:%.*]] = getelementptr inbounds <{ [[STRUCT_A]] }>, <{ [[STRUCT_A]] }>* [[TMP0]], i32 0, i32 0
; GLOBALOPT_ARGPROMOTION-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_A]] }>, align 4
; GLOBALOPT_ARGPROMOTION-NEXT:    [[TMP1:%.*]] = getelementptr inbounds <{ [[STRUCT_A]] }>, <{ [[STRUCT_A]] }>* [[ARGMEM]], i32 0, i32 0
; GLOBALOPT_ARGPROMOTION-NEXT:    [[CALL:%.*]] = call x86_thiscallcc %struct.a* @copy_ctor(%struct.a* [[TMP1]], %struct.a* dereferenceable(1) [[A]])
; GLOBALOPT_ARGPROMOTION-NEXT:    call void @ext(<{ [[STRUCT_A]] }>* inalloca [[ARGMEM]])
; GLOBALOPT_ARGPROMOTION-NEXT:    ret void
;
entry:
  %a = getelementptr inbounds <{ %struct.a }>, <{ %struct.a }>* %0, i32 0, i32 0
  %argmem = alloca inalloca <{ %struct.a }>, align 4
  %1 = getelementptr inbounds <{ %struct.a }>, <{ %struct.a }>* %argmem, i32 0, i32 0
  %call = call x86_thiscallcc %struct.a* @copy_ctor(%struct.a* %1, %struct.a* dereferenceable(1) %a)
  call void @ext(<{ %struct.a }>* inalloca %argmem)
  ret void
}

; This is here to ensure @internalfun is live.
define void @exportedfun(%struct.a* %a) {
; ARGPROMOTION-LABEL: define {{[^@]+}}@exportedfun
; ARGPROMOTION-SAME: (%struct.a* [[A:%.*]])
; ARGPROMOTION-NEXT:    [[INALLOCA_SAVE:%.*]] = tail call i8* @llvm.stacksave()
; ARGPROMOTION-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_A:%.*]] }>, align 4
; ARGPROMOTION-NEXT:    call x86_thiscallcc void @internalfun(%struct.a* [[A]], <{ [[STRUCT_A]] }>* inalloca [[ARGMEM]])
; ARGPROMOTION-NEXT:    call void @llvm.stackrestore(i8* [[INALLOCA_SAVE]])
; ARGPROMOTION-NEXT:    ret void
;
; GLOBALOPT_ARGPROMOTION-LABEL: define {{[^@]+}}@exportedfun
; GLOBALOPT_ARGPROMOTION-SAME: (%struct.a* [[A:%.*]]) local_unnamed_addr
; GLOBALOPT_ARGPROMOTION-NEXT:    [[INALLOCA_SAVE:%.*]] = tail call i8* @llvm.stacksave()
; GLOBALOPT_ARGPROMOTION-NEXT:    [[ARGMEM:%.*]] = alloca inalloca <{ [[STRUCT_A:%.*]] }>, align 4
; GLOBALOPT_ARGPROMOTION-NEXT:    call fastcc void @internalfun(<{ [[STRUCT_A]] }>* [[ARGMEM]])
; GLOBALOPT_ARGPROMOTION-NEXT:    call void @llvm.stackrestore(i8* [[INALLOCA_SAVE]])
; GLOBALOPT_ARGPROMOTION-NEXT:    ret void
;
  %inalloca.save = tail call i8* @llvm.stacksave()
  %argmem = alloca inalloca <{ %struct.a }>, align 4
  call x86_thiscallcc void @internalfun(%struct.a* %a, <{ %struct.a }>* inalloca %argmem)
  call void @llvm.stackrestore(i8* %inalloca.save)
  ret void
}

declare x86_thiscallcc %struct.a* @copy_ctor(%struct.a* returned, %struct.a* dereferenceable(1))
declare void @ext(<{ %struct.a }>* inalloca)
declare i8* @llvm.stacksave()
declare void @llvm.stackrestore(i8*)
