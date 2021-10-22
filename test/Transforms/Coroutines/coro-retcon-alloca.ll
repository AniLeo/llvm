; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -enable-coroutines -passes='default<O2>' -S | FileCheck %s

target datalayout = "p:64:64:64"

declare {i8*, i8*, i32} @prototype_f(i8*, i1)
define {i8*, i8*, i32} @f(i8* %buffer, i32 %n) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  coro.return:
; CHECK-NEXT:    [[N_VAL_SPILL_ADDR:%.*]] = getelementptr inbounds i8, i8* [[BUFFER:%.*]], i64 8
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[N_VAL_SPILL_ADDR]] to i32*
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[TMP0]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i8* @allocate(i32 [[N]])
; CHECK-NEXT:    [[DOTSPILL_ADDR:%.*]] = bitcast i8* [[BUFFER]] to i8**
; CHECK-NEXT:    store i8* [[TMP1]], i8** [[DOTSPILL_ADDR]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { i8*, i8*, i32 } { i8* bitcast ({ i8*, i8*, i32 } (i8*, i1)* @f.resume.0 to i8*), i8* undef, i32 undef }, i8* [[TMP1]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue { i8*, i8*, i32 } [[TMP2]], i32 [[N]], 2
; CHECK-NEXT:    ret { i8*, i8*, i32 } [[TMP3]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i8*, i32} (i8*, i1)* @prototype_f to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br label %loop

loop:
  %n.val = phi i32 [ %n, %entry ], [ %inc, %resume ]
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %n.val, i32 8)
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  %unwind = call i1 (...) @llvm.coro.suspend.retcon.i1(i8* %ptr, i32 %n.val)
  call void @llvm.coro.alloca.free(token %alloca)
  br i1 %unwind, label %cleanup, label %resume

resume:
  %inc = add i32 %n.val, 1
  br label %loop

cleanup:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}



declare {i8*, i32} @prototype_g(i8*, i1)
define {i8*, i32} @g(i8* %buffer, i32 %n) {
; CHECK-LABEL: @g(
; CHECK-NEXT:  coro.return:
; CHECK-NEXT:    [[N_VAL_SPILL_ADDR:%.*]] = bitcast i8* [[BUFFER:%.*]] to i32*
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[N_VAL_SPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[N]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = alloca i8, i64 [[TMP0]], align 8
; CHECK-NEXT:    tail call void @use(i8* nonnull [[TMP1]])
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { i8*, i32 } { i8* bitcast ({ i8*, i32 } (i8*, i1)* @g.resume.0 to i8*), i32 undef }, i32 [[N]], 1
; CHECK-NEXT:    ret { i8*, i32 } [[TMP2]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i32} (i8*, i1)* @prototype_g to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br label %loop

loop:
  %n.val = phi i32 [ %n, %entry ], [ %inc, %resume ]
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %n.val, i32 8)
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  call void @use(i8* %ptr)
  call void @llvm.coro.alloca.free(token %alloca)
  %unwind = call i1 (...) @llvm.coro.suspend.retcon.i1(i32 %n.val)
  br i1 %unwind, label %cleanup, label %resume

resume:
  %inc = add i32 %n.val, 1
  br label %loop

cleanup:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}



declare {i8*, i32} @prototype_h(i8*, i1)
define {i8*, i32} @h(i8* %buffer, i32 %n) {
; CHECK-LABEL: @h(
; CHECK-NEXT:  coro.return:
; CHECK-NEXT:    [[N_SPILL_ADDR:%.*]] = bitcast i8* [[BUFFER:%.*]] to i32*
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[N_SPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertvalue { i8*, i32 } { i8* bitcast ({ i8*, i32 } (i8*, i1)* @h.resume.0 to i8*), i32 undef }, i32 [[N]], 1
; CHECK-NEXT:    ret { i8*, i32 } [[TMP0]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i32} (i8*, i1)* @prototype_h to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br label %loop

loop:
  %n.val = phi i32 [ %n, %entry ], [ %inc, %resume ]
  %unwind = call i1 (...) @llvm.coro.suspend.retcon.i1(i32 %n.val)
  br i1 %unwind, label %cleanup, label %resume

resume:
  %inc = add i32 %n.val, 1
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %inc, i32 8)
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  call void @use(i8* %ptr)
  call void @llvm.coro.alloca.free(token %alloca)
  br label %loop

cleanup:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}



declare {i8*, i32} @prototype_i(i8*)
define {i8*, i32} @i(i8* %buffer, i32 %n) {
; CHECK-LABEL: @i(
; CHECK-NEXT:  coro.return:
; CHECK-NEXT:    [[N_VAL_SPILL_ADDR:%.*]] = bitcast i8* [[BUFFER:%.*]] to i32*
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[N_VAL_SPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertvalue { i8*, i32 } { i8* bitcast ({ i8*, i32 } (i8*)* @i.resume.0 to i8*), i32 undef }, i32 [[N]], 1
; CHECK-NEXT:    ret { i8*, i32 } [[TMP0]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i32} (i8*)* @prototype_i to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br label %loop

loop:
  %n.val = phi i32 [ %n, %entry ], [ %k, %loop2 ]
  call void (...) @llvm.coro.suspend.retcon.isVoid(i32 %n.val)
  %inc = add i32 %n.val, 1
  br label %loop2

loop2:
  %k = phi i32 [ %inc, %loop ], [ %k2, %loop2 ]
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %k, i32 8)
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  call void @use(i8* %ptr)
  call void @llvm.coro.alloca.free(token %alloca)
  %k2 = lshr i32 %k, 1
  %cmp = icmp ugt i32 %k, 128
  br i1 %cmp, label %loop2, label %loop
}



declare {i8*, i32} @prototype_j(i8*)
define {i8*, i32} @j(i8* %buffer, i32 %n) {
; CHECK-LABEL: @j(
; CHECK-NEXT:  coro.return:
; CHECK-NEXT:    [[N_VAL_SPILL_ADDR:%.*]] = bitcast i8* [[BUFFER:%.*]] to i32*
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[N_VAL_SPILL_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = insertvalue { i8*, i32 } { i8* bitcast ({ i8*, i32 } (i8*)* @j.resume.0 to i8*), i32 undef }, i32 [[N]], 1
; CHECK-NEXT:    ret { i8*, i32 } [[TMP0]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i32} (i8*)* @prototype_j to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br label %forward

back:
  ; We should encounter this 'get' before we encounter the 'alloc'.
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  call void @use(i8* %ptr)
  call void @llvm.coro.alloca.free(token %alloca)
  %k = add i32 %n.val, 1
  %cmp = icmp ugt i32 %k, 128
  br i1 %cmp, label %forward, label %end

forward:
  %n.val = phi i32 [ %n, %entry ], [ %k, %back ]
  call void (...) @llvm.coro.suspend.retcon.isVoid(i32 %n.val)
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %n.val, i32 8)
  %inc = add i32 %n.val, 1
  br label %back

end:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}

declare i32 @getSize()
define {i8*, i32} @k(i8* %buffer, i32 %n, i1 %cond) {
; CHECK-LABEL: @k(
; CHECK-NEXT:  PostSpill:
; CHECK-NEXT:    [[SIZE:%.*]] = tail call i32 @getSize()
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[ALLOCA_BLOCK:%.*]], label [[CORO_RETURN:%.*]]
; CHECK:       coro.return:
; CHECK-NEXT:    [[TMP0:%.*]] = insertvalue { i8*, i32 } { i8* bitcast ({ i8*, i32 } (i8*, i1)* @k.resume.0 to i8*), i32 undef }, i32 [[N:%.*]], 1
; CHECK-NEXT:    ret { i8*, i32 } [[TMP0]]
; CHECK:       alloca_block:
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[SIZE]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = alloca i8, i64 [[TMP1]], align 8
; CHECK-NEXT:    tail call void @use(i8* nonnull [[TMP2]])
; CHECK-NEXT:    br label [[CORO_RETURN]]
;
entry:
  %id = call token @llvm.coro.id.retcon(i32 1024, i32 8, i8* %buffer, i8* bitcast ({i8*, i32} (i8*, i1)* @prototype_g to i8*), i8* bitcast (i8* (i32)* @allocate to i8*), i8* bitcast (void (i8*)* @deallocate to i8*))
  %hdl = call i8* @llvm.coro.begin(token %id, i8* null)
  br i1 %cond, label %alloca_block, label %non_alloca_block

suspend:
  %unwind = call i1 (...) @llvm.coro.suspend.retcon.i1(i32 %n)
  br i1 %unwind, label %cleanup, label %resume

resume:
  br label %cleanup

alloca_block:
  %size = call i32 @getSize()
  ; This will get lowered to a dynamic alloca.
  ; Make sure code that runs after that lowering does not hoist the dynamic
  ; alloca into the entry block of the resume function.
  %alloca = call token @llvm.coro.alloca.alloc.i32(i32 %size, i32 8)
  %ptr = call i8* @llvm.coro.alloca.get(token %alloca)
  call void @use(i8* %ptr)
  call void @llvm.coro.alloca.free(token %alloca)
  br label %suspend

non_alloca_block:
  %ignore = call i32 @getSize()
  br label %suspend

cleanup:
  call i1 @llvm.coro.end(i8* %hdl, i1 0)
  unreachable
}

declare token @llvm.coro.id.retcon(i32, i32, i8*, i8*, i8*, i8*)
declare i8* @llvm.coro.begin(token, i8*)
declare i1 @llvm.coro.suspend.retcon.i1(...)
declare void @llvm.coro.suspend.retcon.isVoid(...)
declare i1 @llvm.coro.end(i8*, i1)
declare i8* @llvm.coro.prepare.retcon(i8*)
declare token @llvm.coro.alloca.alloc.i32(i32, i32)
declare i8* @llvm.coro.alloca.get(token)
declare void @llvm.coro.alloca.free(token)

declare noalias i8* @allocate(i32 %size)
declare void @deallocate(i8* %ptr)

declare void @print(i32)
declare void @use(i8*)
