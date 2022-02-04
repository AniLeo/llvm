; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

target datalayout = "e-m:o-p:40:64:64:32-i64:64-f80:128-n8:16:32:64-S128"
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
@.str = private unnamed_addr constant [5 x i8] c"file\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c"w\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"str\00", align 1

; Check fwrite is generated with arguments of ptr size, not index size
define internal void @fputs_test_custom_dl() {
; CHECK-LABEL: @fputs_test_custom_dl(
; CHECK-NEXT:    [[TMP1:%.*]] = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i32 0, i32 0))
;
  %call = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.1, i64 0, i64 0))
  %call1 = call i32 @fputs(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), %struct._IO_FILE* %call)
  ret void
}

declare %struct._IO_FILE* @fopen(i8*, i8*)
declare i32 @fputs(i8* nocapture readonly, %struct._IO_FILE* nocapture)
