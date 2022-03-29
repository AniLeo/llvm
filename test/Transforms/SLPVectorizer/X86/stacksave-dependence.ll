; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-threshold=-999 -S -mtriple=x86_64-unknown-linux-gnu -mcpu=skylake < %s | FileCheck %s

declare i64 @may_inf_loop_ro() nounwind readonly

; Base case without allocas or stacksave
define void @basecase(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @basecase(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8** [[A:%.*]] to <2 x i8*>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i8*>, <2 x i8*>* [[TMP1]], align 8
; CHECK-NEXT:    store i8* null, i8** [[A]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = load i8*, i8** %a
  store i8* zeroinitializer, i8** %a
  %a2 = getelementptr i8*, i8** %a, i32 1
  %v2 = load i8*, i8** %a2

  %add1 = getelementptr i8, i8* %v1, i32 1
  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

; Using two allocas and a buildvector
define void @allocas(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @allocas(
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[V2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i8*> poison, i8* [[V1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i8*> [[TMP1]], i8* [[V2]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i8*> [[TMP3]], i32 0
; CHECK-NEXT:    store i8* [[TMP4]], i8** [[A:%.*]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP5]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = alloca i8
  %add1 = getelementptr i8, i8* %v1, i32 1
  store i8* %add1, i8** %a
  %v2 = alloca i8

  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

; Allocas can not be speculated above a potentially non-returning call
define void @allocas_speculation(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @allocas_speculation(
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[ADD1:%.*]] = getelementptr i8, i8* [[V1]], i32 1
; CHECK-NEXT:    store i8* [[ADD1]], i8** [[A:%.*]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @may_inf_loop_ro()
; CHECK-NEXT:    [[V2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[ADD2:%.*]] = getelementptr i8, i8* [[V2]], i32 1
; CHECK-NEXT:    store i8* [[ADD1]], i8** [[B:%.*]], align 8
; CHECK-NEXT:    [[B2:%.*]] = getelementptr i8*, i8** [[B]], i32 1
; CHECK-NEXT:    store i8* [[ADD2]], i8** [[B2]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = alloca i8
  %add1 = getelementptr i8, i8* %v1, i32 1
  store i8* %add1, i8** %a
  call i64 @may_inf_loop_ro()
  %v2 = alloca i8

  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

; We must be careful not to lift the inalloca alloc above the stacksave here.
; We used to miscompile this example before adding explicit dependency handling
; for stacksave.
define void @stacksave(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stacksave(
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[ADD1:%.*]] = getelementptr i8, i8* [[V1]], i32 1
; CHECK-NEXT:    store i8* [[ADD1]], i8** [[A:%.*]], align 8
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[V2:%.*]] = alloca inalloca i8, align 1
; CHECK-NEXT:    call void @use(i8* inalloca(i8) [[V2]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[ADD2:%.*]] = getelementptr i8, i8* [[V2]], i32 1
; CHECK-NEXT:    store i8* [[ADD1]], i8** [[B:%.*]], align 8
; CHECK-NEXT:    [[B2:%.*]] = getelementptr i8*, i8** [[B]], i32 1
; CHECK-NEXT:    store i8* [[ADD2]], i8** [[B2]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = alloca i8
  %add1 = getelementptr i8, i8* %v1, i32 1
  store i8* %add1, i8** %a

  %stack = call i8* @llvm.stacksave()
  %v2 = alloca inalloca i8
  call void @use(i8* inalloca(i8) %v2) readnone
  call void @llvm.stackrestore(i8* %stack)

  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

define void @stacksave2(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stacksave2(
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[V2:%.*]] = alloca inalloca i8, align 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i8*> poison, i8* [[V1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i8*> [[TMP1]], i8* [[V2]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x i8*> [[TMP3]], i32 0
; CHECK-NEXT:    store i8* [[TMP4]], i8** [[A:%.*]], align 8
; CHECK-NEXT:    call void @use(i8* inalloca(i8) [[V2]]) #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP5]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = alloca i8
  %add1 = getelementptr i8, i8* %v1, i32 1

  %stack = call i8* @llvm.stacksave()
  store i8* %add1, i8** %a
  %v2 = alloca inalloca i8
  call void @use(i8* inalloca(i8) %v2) readonly
  call void @llvm.stackrestore(i8* %stack)

  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

define void @stacksave3(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stacksave3(
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[V2:%.*]] = alloca inalloca i8, align 1
; CHECK-NEXT:    call void @use(i8* inalloca(i8) [[V2]]) #[[ATTR4]]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i8*> poison, i8* [[V1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i8*> [[TMP1]], i8* [[V2]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;

  %stack = call i8* @llvm.stacksave()
  %v1 = alloca i8

  %v2 = alloca inalloca i8
  call void @use(i8* inalloca(i8) %v2) readnone
  call void @llvm.stackrestore(i8* %stack)

  %add1 = getelementptr i8, i8* %v1, i32 1
  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

; Here we have an alloca which needs to stay under the stacksave, but is not
; directly part of the vectorization tree.  Instead, the stacksave is
; encountered during dependency scanning via the memory chain.
define void @stacksave4(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stacksave4(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8** [[A:%.*]] to <2 x i8*>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i8*>, <2 x i8*>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[X:%.*]] = alloca inalloca i8, align 1
; CHECK-NEXT:    call void @use(i8* inalloca(i8) [[X]]) #[[ATTR4]]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = load i8*, i8** %a
  %a2 = getelementptr i8*, i8** %a, i32 1
  %v2 = load i8*, i8** %a2

  %add1 = getelementptr i8, i8* %v1, i32 1
  %add2 = getelementptr i8, i8* %v2, i32 1

  %stack = call i8* @llvm.stacksave()
  %x = alloca inalloca i8
  call void @use(i8* inalloca(i8) %x) readnone
  call void @llvm.stackrestore(i8* %stack)

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

define void @stacksave5(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stacksave5(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8** [[A:%.*]] to <2 x i8*>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x i8*>, <2 x i8*>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[X:%.*]] = alloca inalloca i8, align 1
; CHECK-NEXT:    call void @use(i8* inalloca(i8) [[X]]) #[[ATTR4]]
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;

  %v1 = load i8*, i8** %a
  %a2 = getelementptr i8*, i8** %a, i32 1
  %v2 = load i8*, i8** %a2

  %add1 = getelementptr i8, i8* %v1, i32 1
  %add2 = getelementptr i8, i8* %v2, i32 1

  %stack = call i8* @llvm.stacksave()
  %x = alloca inalloca i8
  call void @use(i8* inalloca(i8) %x) readnone
  call void @llvm.stackrestore(i8* %stack)

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

; Reordering the second alloca above the stackrestore while
; leaving the write to it below would introduce a write-after-free
; bug.
define void @stackrestore1(i8** %a, i8** %b, i8** %c) {
; CHECK-LABEL: @stackrestore1(
; CHECK-NEXT:    [[STACK:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[V1:%.*]] = alloca i8, align 1
; CHECK-NEXT:    store i8 0, i8* [[V1]], align 1
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[STACK]])
; CHECK-NEXT:    [[V2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    store i8 0, i8* [[V2]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x i8*> poison, i8* [[V1]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x i8*> [[TMP1]], i8* [[V2]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i8, <2 x i8*> [[TMP2]], <2 x i32> <i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[B:%.*]] to <2 x i8*>*
; CHECK-NEXT:    store <2 x i8*> [[TMP3]], <2 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;

  %stack = call i8* @llvm.stacksave()
  %v1 = alloca i8
  store i8 0, i8* %v1
  call void @llvm.stackrestore(i8* %stack)
  %v2 = alloca i8
  store i8 0, i8* %v2

  %add1 = getelementptr i8, i8* %v1, i32 1
  %add2 = getelementptr i8, i8* %v2, i32 1

  store i8* %add1, i8** %b
  %b2 = getelementptr i8*, i8** %b, i32 1
  store i8* %add2, i8** %b2
  ret void
}

declare void @use(i8* inalloca(i8))
declare i8* @llvm.stacksave()
declare void @llvm.stackrestore(i8*)

; The next set are reduced from previous regressions.

declare i8* @wibble(i8*)
declare void @quux(i32* inalloca(i32))

define void @ham() #1 {
; CHECK-LABEL: @ham(
; CHECK-NEXT:    [[VAR2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[VAR3:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[VAR12:%.*]] = alloca [12 x i8*], align 8
; CHECK-NEXT:    [[VAR15:%.*]] = call i8* @wibble(i8* [[VAR2]])
; CHECK-NEXT:    [[VAR16:%.*]] = call i8* @wibble(i8* [[VAR3]])
; CHECK-NEXT:    [[VAR32:%.*]] = getelementptr inbounds [12 x i8*], [12 x i8*]* [[VAR12]], i32 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8** [[VAR32]] to <4 x i8*>*
; CHECK-NEXT:    [[VAR36:%.*]] = getelementptr inbounds [12 x i8*], [12 x i8*]* [[VAR12]], i32 0, i32 4
; CHECK-NEXT:    [[VAR4:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[VAR5:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[VAR17:%.*]] = call i8* @wibble(i8* [[VAR4]])
; CHECK-NEXT:    [[VAR23:%.*]] = call i8* @llvm.stacksave()
; CHECK-NEXT:    [[VAR24:%.*]] = alloca inalloca i32, align 4
; CHECK-NEXT:    call void @quux(i32* inalloca(i32) [[VAR24]])
; CHECK-NEXT:    call void @llvm.stackrestore(i8* [[VAR23]])
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8*> poison, i8* [[VAR4]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i8*> [[TMP2]], <4 x i8*> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    store <4 x i8*> [[SHUFFLE]], <4 x i8*>* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <4 x i8*> [[TMP2]], i8* [[VAR5]], i32 1
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <4 x i8*> [[TMP3]], <4 x i8*> poison, <4 x i32> <i32 0, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i8** [[VAR36]] to <4 x i8*>*
; CHECK-NEXT:    store <4 x i8*> [[SHUFFLE1]], <4 x i8*>* [[TMP4]], align 8
; CHECK-NEXT:    ret void
;
  %var2 = alloca i8
  %var3 = alloca i8
  %var4 = alloca i8
  %var5 = alloca i8
  %var12 = alloca [12 x i8*]
  %var15 = call i8* @wibble(i8* %var2)
  %var16 = call i8* @wibble(i8* %var3)
  %var17 = call i8* @wibble(i8* %var4)
  %var23 = call i8* @llvm.stacksave()
  %var24 = alloca inalloca i32
  call void @quux(i32* inalloca(i32) %var24)
  call void @llvm.stackrestore(i8* %var23)
  %var32 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 0
  store i8* %var4, i8** %var32
  %var33 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 1
  store i8* %var4, i8** %var33
  %var34 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 2
  store i8* %var4, i8** %var34
  %var35 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 3
  store i8* %var4, i8** %var35
  %var36 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 4
  store i8* %var4, i8** %var36
  %var37 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 5
  store i8* %var5, i8** %var37
  %var38 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 6
  store i8* %var5, i8** %var38
  %var39 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 7
  store i8* %var5, i8** %var39
  ret void
}

define void @spam() #1 {
; CHECK-LABEL: @spam(
; CHECK-NEXT:    [[VAR12:%.*]] = alloca [12 x i8*], align 8
; CHECK-NEXT:    [[VAR36:%.*]] = getelementptr inbounds [12 x i8*], [12 x i8*]* [[VAR12]], i32 0, i32 4
; CHECK-NEXT:    [[VAR4:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[VAR5:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x i8*> poison, i8* [[VAR4]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i8*> [[TMP1]], i8* [[VAR5]], i32 1
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x i8*> [[TMP2]], <4 x i8*> poison, <4 x i32> <i32 0, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i8** [[VAR36]] to <4 x i8*>*
; CHECK-NEXT:    store <4 x i8*> [[SHUFFLE]], <4 x i8*>* [[TMP3]], align 8
; CHECK-NEXT:    ret void
;
  %var4 = alloca i8
  %var5 = alloca i8
  %var12 = alloca [12 x i8*]
  %var36 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 4
  store i8* %var4, i8** %var36
  %var37 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 5
  store i8* %var5, i8** %var37
  %var38 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 6
  store i8* %var5, i8** %var38
  %var39 = getelementptr inbounds [12 x i8*], [12 x i8*]* %var12, i32 0, i32 7
  store i8* %var5, i8** %var39
  ret void
}

attributes #0 = { nofree nosync nounwind willreturn }
attributes #1 = { "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+sse3,+x87" }
