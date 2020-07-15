; RUN: opt -passes=attributor-cgscc -disable-output -attributor-print-dep < %s 2>&1 | FileCheck %s --check-prefixes=GRAPH
; RUN: opt -passes=attributor-cgscc -disable-output -attributor-dump-dep-graph -attributor-depgraph-dot-filename-prefix=%t < %s 2>/dev/null
; RUN: FileCheck %s -input-file=%t_0.dot --check-prefix=DOT

; Test 0
;
; test copied from the attributor introduction video: checkAndAdvance(), and the C code is:
; int *checkAndAdvance(int * __attribute__((aligned(16))) p) {
;   if (*p == 0)
;     return checkAndAdvance(p + 4);
;   return p;
; }
;
define i32* @checkAndAdvance(i32* align 16 %0) {
  %2 = load i32, i32* %0, align 4
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = getelementptr inbounds i32, i32* %0, i64 4
  %6 = call i32* @checkAndAdvance(i32* %5)
  br label %8

7:                                                ; preds = %1
  br label %8

8:                                                ; preds = %7, %4
  %.0 = phi i32* [ %6, %4 ], [ %0, %7 ]
  ret i32* %.0
}

;
; Check for graph
;

; GRAPH: [AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}
; GRAPH:  updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}
; GRAPH:  updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}

; GRAPH: [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}
; GRAPH:  updates [AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]}
; GRAPH:  updates [AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}

; GRAPH: [AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} 
; GRAPH:  updates [AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}

; GRAPH: [AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}
; GRAPH:  updates [AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}

; GRAPH: [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}
; GRAPH:  updates [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}

; GRAPH: [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]}

; GRAPH: [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}
; GRAPH:  updates [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}

; GRAPH: [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]}
; GRAPH:  updates [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]}

; GRAPH: [AANonNull] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]}
; GRAPH:  updates [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]}

; GRAPH: [AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]}
; GRAPH:  updates [AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]}

; GRAPH: [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]}

; GRAPH: [AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]}
; GRAPH:  updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}

; GRAPH: [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}
; GRAPH:  updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}

; GRAPH: [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]}
; GRAPH:  updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]}

; GRAPH: [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]}
; GRAPH:  updates [AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]}
; GRAPH:  updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]}

; GRAPH: [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state readonly
; GRAPH:  updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument

; GRAPH: [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH:  updates [AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state memory:argument

; GRAPH: [AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state memory:argument
; GRAPH:  updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument

;
; Check for .dot file
;

; DOT-DAG: Node[[Node6:0x[a-z0-9]+]] [shape=record,label="{[AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node34:0x[a-z0-9]+]] [shape=record,label="{[AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node39:0x[a-z0-9]+]] [shape=record,label="{[AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node7:0x[a-z0-9]+]] [shape=record,label="{[AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node61:0x[a-z0-9]+]] [shape=record,label="{[AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node13:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node36:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node62:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node16:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node35:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node40:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node17:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node63:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node22:0x[a-z0-9]+]] [shape=record,label="{[AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn_ret:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node65:0x[a-z0-9]+]] [shape=record,label="{[AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node23:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn_ret:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node67:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node43:0x[a-z0-9]+]] [shape=record,label="{[AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node45:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node46:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node38:0x[a-z0-9]+]] [shape=record,label="{[AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node55:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position \{flt: [@-1]\}
; DOT-DAG: Node[[Node31:0x[a-x0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}

; DOT-DAG: Node[[Node6]] -> Node[[Node34]]
; DOT-DAG: Node[[Node6]] -> Node[[Node39]]
; DOT-DAG: Node[[Node7]] -> Node[[Node61]]
; DOT-DAG: Node[[Node13]] -> Node[[Node36]]
; DOT-DAG: Node[[Node13]] -> Node[[Node62]]
; DOT-DAG: Node[[Node16]] -> Node[[Node34]]
; DOT-DAG: Node[[Node16]] -> Node[[Node35]]
; DOT-DAG: Node[[Node16]] -> Node[[Node40]]
; DOT-DAG: Node[[Node17]] -> Node[[Node63]]
; DOT-DAG: Node[[Node22]] -> Node[[Node65]]
; DOT-DAG: Node[[Node23]] -> Node[[Node67]]
; DOT-DAG: Node[[Node34]] -> Node[[Node43]]
; DOT-DAG: Node[[Node35]] -> Node[[Node45]]
; DOT-DAG: Node[[Node36]] -> Node[[Node46]]
; DOT-DAG: Node[[Node39]] -> Node[[Node38]]
; DOT-DAG: Node[[Node39]] -> Node[[Node6]]
; DOT-DAG: Node[[Node40]] -> Node[[Node38]]
; DOT-DAG: Node[[Node40]] -> Node[[Node16]]
; DOT-DAG: Node[[Node43]] -> Node[[Node34]]
; DOT-DAG: Node[[Node45]] -> Node[[Node17]]
; DOT-DAG: Node[[Node55]] -> Node[[Node55]]
; DOT-DAG: Node[[Node55]] -> Node[[Node31]]
; DOT-DAG: Node[[Node55]] -> Node[[Node23]]
; DOT-DAG: Node[[Node61]] -> Node[[Node7]]
; DOT-DAG: Node[[Node62]] -> Node[[Node13]]
; DOT-DAG: Node[[Node63]] -> Node[[Node17]]
; DOT-DAG: Node[[Node65]] -> Node[[Node22]]
; DOT-DAG: Node[[Node67]] -> Node[[Node23]]