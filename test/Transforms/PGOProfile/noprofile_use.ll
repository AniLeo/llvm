; RUN: not opt < %s -pgo-instr-use -pgo-profile-file=%T/notexisting.profdata -S 

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i32 @_Z9single_bbv() {
entry:
  ret i32 0
}
