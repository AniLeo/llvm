; RUN: llvm-as < %s | opt -passes=globalopt -disable-output
; NOTE: This needs to run through 'llvm-as' first to reproduce the error!
; PR15440

%union.U5.0.6.12 = type { i32 }
%struct.S0.1.7.13 = type { i8, i8, i8, i8, i16, [2 x i8] }
%struct.S1.2.8.14 = type { i32, i16, i8, i8 }

@.str = external unnamed_addr constant [2 x i8], align 1
@g_25 = external global i8, align 1
@g_71 = internal global %struct.S0.1.7.13 { i8 1, i8 -93, i8 58, i8 -1, i16 -5, [2 x i8] undef }, align 4
@g_114 = external global i8, align 1
@g_30 = external global { i32, i8, i32, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }, align 4
@g_271 = internal global [7 x [6 x [5 x i8*]]] [[6 x [5 x i8*]] [[5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* null], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* null, i8* null], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)]], [6 x [5 x i8*]] [[5 x i8*] [i8* @g_25, i8* null, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* @g_25, i8* @g_114, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25], [5 x i8*] [i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25, i8* @g_25, i8* @g_25], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)]], [6 x [5 x i8*]] [[5 x i8*] [i8* null, i8* @g_25, i8* @g_25, i8* @g_25, i8* null], [5 x i8*] [i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* null, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* null, i8* @g_25], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* null], [5 x i8*] [i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)]], [6 x [5 x i8*]] [[5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* null, i8* @g_25], [5 x i8*] [i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25], [5 x i8*] [i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* @g_114, i8* @g_25, i8* @g_25, i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)]], [6 x [5 x i8*]] [[5 x i8*] [i8* @g_25, i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_114], [5 x i8*] [i8* @g_25, i8* null, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* null], [5 x i8*] [i8* @g_114, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* @g_25]], [6 x [5 x i8*]] [[5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* @g_114, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0)], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25]], [6 x [5 x i8*]] [[5 x i8*] [i8* @g_25, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* null], [5 x i8*] [i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* @g_25, i8* @g_25, i8* @g_114], [5 x i8*] [i8* null, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_25, i8* null, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_114, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* @g_114, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1)], [5 x i8*] [i8* @g_25, i8* @g_25, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25], [5 x i8*] [i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25, i8* @g_25, i8* getelementptr (i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), i64 1), i8* @g_25]]], align 4

define i32 @func() {
  %tmp = load i8, i8* getelementptr inbounds (%struct.S0.1.7.13, %struct.S0.1.7.13* @g_71, i32 0, i32 0), align 1
  ret i32 0
}
