target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-grtev4-linux-gnu"

@linkonceodrunnamedconst = linkonce_odr unnamed_addr constant i32 0
@linkonceodrunnamed = linkonce_odr unnamed_addr global i32 0
@linkonceodrlocalunnamedconst = linkonce_odr local_unnamed_addr constant i32 0
@linkonceodrlocalunnamed = linkonce_odr local_unnamed_addr global i32 0
@odrunnamed = weak_odr unnamed_addr constant i32 0
