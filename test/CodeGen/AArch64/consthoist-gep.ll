; RUN: llc -mtriple=aarch64-none-unknown-linuxeabi -consthoist-gep %s -o - | FileCheck %s
; RUN: llc -mtriple=aarch64-none-unknown-linuxeabi -consthoist-gep -force-opaque-pointers %s -o - | FileCheck %s

; CHECK-NOT: adrp    x10, global+332
; CHECK-NOT: add     x10, x10, :lo12:global+332
; CHECK: adrp    x10, global+528
; CHECK-NEXT: add     x10, x10, :lo12:global+528

%struct.blam = type { %struct.bar, %struct.bar.0, %struct.wobble, %struct.wombat, i8, i16, %struct.snork.2, %struct.foo, %struct.snork.3, %struct.wobble.4, %struct.quux, [9 x i16], %struct.spam, %struct.zot }
%struct.bar = type { i8, i8, %struct.snork }
%struct.snork = type { i16, i8, i8 }
%struct.bar.0 = type { i8, i8, i16, i8, i8, %struct.barney }
%struct.barney = type { i8, i8, i8, i8 }
%struct.wobble = type { i8, i8, %struct.eggs, %struct.bar.1 }
%struct.eggs = type { i8, i8, i8 }
%struct.bar.1 = type { i8, i8, i8, i8 }
%struct.wombat = type { i8, i8, i16, i32, i32, i32, i32 }
%struct.snork.2 = type { i8, i8, i8 }
%struct.foo = type { [12 x i32], [12 x i32], [4 x i32], i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.snork.3 = type { i16, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i16 }
%struct.wobble.4 = type { i32, i32, i32, i32, i32, i32, i16, i16, i8, i8, i16, i32, i32, i16, i8, i8 }
%struct.quux = type { i32, %struct.foo.5, i8, i8, i8, i8, i32, %struct.snork.6, %struct.foo.7, [16 x i8], i16, i16, i8, i8, i8, i8, i32, i32, i32 }
%struct.foo.5 = type { i16, i8, i8 }
%struct.snork.6 = type { i16, i8, i8 }
%struct.foo.7 = type { i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8, i8 }
%struct.spam = type { i8, i8 }
%struct.zot = type { [5 x i32], [3 x i32], [6 x i32], [3 x i32], [2 x i32], [4 x i32], [3 x i32], [2 x i32], [4 x i32], [5 x i32], [3 x i32], [6 x i32], [1 x i32], i32, i32, i32, i32, i32, i32 }

@global = external dso_local local_unnamed_addr global %struct.blam, align 4

; Function Attrs: norecurse nounwind optsize ssp
define dso_local void @blam() local_unnamed_addr #0 {
bb:
  %tmp = load i8, i8* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 7, i32 9), align 2, !tbaa !3
  %tmp1 = and i8 %tmp, 1
  %tmp2 = icmp eq i8 %tmp1, 0
  br i1 %tmp2, label %bb3, label %bb19

bb3:                                              ; preds = %bb
  %tmp4 = load volatile i32, i32* inttoptr (i32 805874688 to i32*), align 1024, !tbaa !23
  store i32 %tmp4, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 0, i32 0), align 4, !tbaa !23
  %tmp5 = load volatile i32, i32* inttoptr (i32 805874692 to i32*), align 4, !tbaa !23
  %tmp6 = and i32 %tmp5, 65535
  store i32 %tmp6, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 0, i32 1), align 4, !tbaa !23
  %tmp7 = load volatile i32, i32* inttoptr (i32 805874696 to i32*), align 8, !tbaa !23
  %tmp8 = and i32 %tmp7, 522133279
  store i32 %tmp8, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 0, i32 2), align 4, !tbaa !23
  %tmp9 = load volatile i32, i32* inttoptr (i32 805874700 to i32*), align 4, !tbaa !23
  %tmp10 = and i32 %tmp9, 522133279
  store i32 %tmp10, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 0, i32 3), align 4, !tbaa !23
  %tmp11 = load volatile i32, i32* inttoptr (i32 805874860 to i32*), align 4, !tbaa !23
  %tmp12 = and i32 %tmp11, 16777215
  store i32 %tmp12, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 15), align 4, !tbaa !24
  %tmp13 = load volatile i32, i32* inttoptr (i32 805874864 to i32*), align 16, !tbaa !23
  %tmp14 = and i32 %tmp13, 16777215
  store i32 %tmp14, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 16), align 4, !tbaa !25
  %tmp15 = load volatile i32, i32* inttoptr (i32 805874868 to i32*), align 4, !tbaa !23
  %tmp16 = and i32 %tmp15, 16777215
  store i32 %tmp16, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 17), align 4, !tbaa !26
  %tmp17 = load volatile i32, i32* inttoptr (i32 805874872 to i32*), align 8, !tbaa !23
  %tmp18 = and i32 %tmp17, 16777215
  store i32 %tmp18, i32* getelementptr inbounds (%struct.blam, %struct.blam* @global, i32 0, i32 13, i32 18), align 4, !tbaa !27
  br label %bb19

bb19:                                             ; preds = %bb3, %bb
  ret void
}

attributes #0 = { norecurse nounwind optsize ssp "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"min_enum_size", i32 1}
!2 = !{!"Snapdragon LLVM ARM Compiler 8.0.0 (based on LLVM 8.0.0)"}
!3 = !{!4, !6, i64 174}
!4 = !{!"", !5, i64 0, !10, i64 6, !12, i64 16, !14, i64 28, !6, i64 48, !9, i64 50, !13, i64 52, !16, i64 56, !17, i64 176, !18, i64 196, !19, i64 240, !6, i64 312, !21, i64 330, !22, i64 332}
!5 = !{!"", !6, i64 0, !6, i64 1, !8, i64 2}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"", !9, i64 0, !6, i64 2, !6, i64 3}
!9 = !{!"short", !6, i64 0}
!10 = !{!"", !6, i64 0, !6, i64 1, !9, i64 2, !6, i64 4, !6, i64 5, !11, i64 6}
!11 = !{!"", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3}
!12 = !{!"", !6, i64 0, !6, i64 1, !13, i64 2, !11, i64 5}
!13 = !{!"", !6, i64 0, !6, i64 1, !6, i64 2}
!14 = !{!"", !6, i64 0, !6, i64 1, !9, i64 2, !15, i64 4, !15, i64 8, !15, i64 12, !15, i64 16}
!15 = !{!"long", !6, i64 0}
!16 = !{!"", !6, i64 0, !6, i64 48, !6, i64 96, !6, i64 112, !6, i64 113, !6, i64 114, !6, i64 115, !6, i64 116, !6, i64 117, !6, i64 118, !6, i64 119}
!17 = !{!"", !9, i64 0, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15, !9, i64 16}
!18 = !{!"", !15, i64 0, !15, i64 4, !15, i64 8, !15, i64 12, !15, i64 16, !15, i64 20, !9, i64 24, !9, i64 26, !6, i64 28, !6, i64 29, !9, i64 30, !15, i64 32, !15, i64 36, !9, i64 40, !6, i64 42, !6, i64 43}
!19 = !{!"", !15, i64 0, !8, i64 4, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !15, i64 12, !8, i64 16, !20, i64 20, !6, i64 36, !9, i64 52, !9, i64 54, !6, i64 56, !6, i64 57, !6, i64 58, !6, i64 59, !15, i64 60, !15, i64 64, !15, i64 68}
!20 = !{!"", !6, i64 0, !6, i64 1, !6, i64 2, !6, i64 3, !6, i64 4, !6, i64 5, !6, i64 6, !6, i64 7, !6, i64 8, !6, i64 9, !6, i64 10, !6, i64 11, !6, i64 12, !6, i64 13, !6, i64 14, !6, i64 15}
!21 = !{!"", !6, i64 0, !6, i64 1}
!22 = !{!"", !6, i64 0, !6, i64 20, !6, i64 32, !6, i64 56, !6, i64 68, !6, i64 76, !6, i64 92, !6, i64 104, !6, i64 112, !6, i64 128, !6, i64 148, !6, i64 160, !6, i64 184, !15, i64 188, !15, i64 192, !15, i64 196, !15, i64 200, !15, i64 204, !15, i64 208}
!23 = !{!15, !15, i64 0}
!24 = !{!4, !15, i64 528}
!25 = !{!4, !15, i64 532}
!26 = !{!4, !15, i64 536}
!27 = !{!4, !15, i64 540}
