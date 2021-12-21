; RUN: llc -mcpu=core2 -mtriple=i686-pc-win32 -O0 < %s | FileCheck --check-prefix=X86 %s
; RUN: llc -mcpu=core2 -mtriple=i686-pc-win32 -o - -O0 < %s | llvm-mc -triple=i686-pc-win32 -filetype=obj | llvm-readobj -S --sr --codeview --section-symbols - | FileCheck --check-prefix=OBJ32 %s
; RUN: llc -mcpu=core2 -mtriple=x86_64-pc-win32 -O0 < %s | FileCheck --check-prefix=X64 %s
; RUN: llc -mcpu=core2 -mtriple=x86_64-pc-win32 -o - -O0 < %s | llvm-mc -triple=x86_64-pc-win32 -filetype=obj | llvm-readobj -S --sr --codeview --section-symbols - | FileCheck --check-prefix=OBJ64 %s

; This LL file was generated by running clang on the following code:
; D:\source.c:
;  1 void z(void);
;  2
;  3 void x(void) {
;  4   z();
;  5 }
;  6
;  7 void y(void) {
;  8   z();
;  9 }
; 10
; 11 void f(void) {
; 12   x();
; 13   y();
; 14   z();
; 15 }


; X86-LABEL: _x:
; X86:      # %bb.
; X86:      .cv_file 1 "D:\\source.c"
; X86:      .cv_loc 0 1 4 42 # source.c:4:42
; X86:      calll   _z
; X86:      .cv_loc 0 1 5 43 # source.c:5:43
; X86:      ret
; X86:      [[END_OF_X:.?Lfunc_end.*]]:
;
; X86-LABEL: _y:
; X86:      # %bb.
; X86:      .cv_loc 1 1 8 52 # source.c:8:52
; X86:      calll   _z
; X86:      .cv_loc 1 1 9 53 # source.c:9:53
; X86:      ret
; X86:      [[END_OF_Y:.?Lfunc_end.*]]:
;
; X86-LABEL: _f:
; X86:      # %bb.
; X86:      .cv_loc 2 1 12 62 # source.c:12:62
; X86:      calll   _x
; X86:      .cv_loc 2 1 13 63 # source.c:13:63
; X86:      calll   _y
; X86:      .cv_loc 2 1 14 72 # source.c:14:72
; X86:      calll   _z
; X86:      .cv_loc 2 1 15 73 # source.c:15:73
; X86:      ret
; X86:      [[END_OF_F:.?Lfunc_end.*]]:
;
; X86-LABEL: .section        .debug$S,"dr"
; X86-NEXT: .p2align 2
; X86-NEXT: .long   4
; X86-NEXT: .long   241
; X86-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; Compiler information record
; X86-NEXT: [[COMPILE_START]]:
; X86-NEXT: .short [[C1_END:.*]]-[[C1_START:.*]] #
; X86:      [[COMPILE_END]]:
; X86-NEXT: .p2align 2
; X86-NEXT: .cv_fpo_data _x
; Symbol subsection for x
; X86-NEXT: .long   241
; X86-NEXT: .long [[F1_END:.*]]-[[F1_START:.*]] #
; X86-NEXT: [[F1_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4422
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long [[END_OF_X]]-_x
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   4098
; X86-NEXT: .secrel32 _x
; X86-NEXT: .secidx _x
; X86-NEXT: .byte   0
; X86-NEXT: .asciz "x"
; X86-NEXT: .p2align 2
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X86-NEXT: [[FPROC_BEG]]:
; X86-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X86-NEXT: .long   0                       # FrameSize
; X86-NEXT: .long   0                       # Padding
; X86-NEXT: .long   0                       # Offset of padding
; X86-NEXT: .long   0                       # Bytes of callee saved registers
; X86-NEXT: .long   0                       # Exception handler offset
; X86-NEXT: .short  0                       # Exception handler section
; X86-NEXT: .long   0                       # Flags (defines frame register)
; X86-NEXT: .p2align 2
; X86-NEXT: [[FPROC_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[F1_END]]:
; X86-NEXT: .p2align 2
; Line table subsection for x
; X86: .cv_linetable 0, _x, [[END_OF_X]]
; Symbol subsection for y
; X86-NEXT: .cv_fpo_data _y
; X86-NEXT: .long   241
; X86-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; X86-NEXT: [[COMPILE_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4423
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long [[END_OF_Y]]-_y
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   4099
; X86-NEXT: .secrel32 _y
; X86-NEXT: .secidx _y
; X86-NEXT: .byte   0
; X86-NEXT: .asciz "y"
; X86-NEXT: .p2align 2
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X86-NEXT: [[FPROC_BEG]]:
; X86-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X86-NEXT: .long   0                       # FrameSize
; X86-NEXT: .long   0                       # Padding
; X86-NEXT: .long   0                       # Offset of padding
; X86-NEXT: .long   0                       # Bytes of callee saved registers
; X86-NEXT: .long   0                       # Exception handler offset
; X86-NEXT: .short  0                       # Exception handler section
; X86-NEXT: .long   0                       # Flags (defines frame register)
; X86-NEXT: .p2align 2
; X86-NEXT: [[FPROC_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[COMPILE_END]]:
; X86-NEXT: .p2align 2
; Line table subsection for y
; X86: .cv_linetable 1, _y, [[END_OF_Y]]
; Symbol subsection for f
; X86-NEXT: .cv_fpo_data _f
; X86-NEXT: .long   241
; X86-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; X86-NEXT: [[COMPILE_START]]:
; X86-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X86-NEXT: [[PROC_SEGMENT_START]]:
; X86-NEXT: .short  4423
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long [[END_OF_F]]-_f
; X86-NEXT: .long   0
; X86-NEXT: .long   0
; X86-NEXT: .long   4100
; X86-NEXT: .secrel32 _f
; X86-NEXT: .secidx _f
; X86-NEXT: .byte   0
; X86-NEXT: .asciz "f"
; X86-NEXT: .p2align 2
; X86-NEXT: [[PROC_SEGMENT_END]]:
; X86-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X86-NEXT: [[FPROC_BEG]]:
; X86-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X86-NEXT: .long   0                       # FrameSize
; X86-NEXT: .long   0                       # Padding
; X86-NEXT: .long   0                       # Offset of padding
; X86-NEXT: .long   0                       # Bytes of callee saved registers
; X86-NEXT: .long   0                       # Exception handler offset
; X86-NEXT: .short  0                       # Exception handler section
; X86-NEXT: .long   0                       # Flags (defines frame register)
; X86-NEXT: .p2align 2
; X86-NEXT: [[FPROC_END]]:
; X86-NEXT: .short  2
; X86-NEXT: .short  4431
; X86-NEXT: [[COMPILE_END]]:
; X86-NEXT: .p2align 2
; Line table subsection for f
; X86: .cv_linetable 2, _f, [[END_OF_F]]
; X86: .cv_filechecksums
; X86: .cv_stringtable

; OBJ32:    Section {
; OBJ32:      Name: .debug$S (2E 64 65 62 75 67 24 53)
; OBJ32:      Characteristics [ (0x42300040)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ32: 	Compile3Sym
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: FrameData (0xF5)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ32:        {{.*}}Proc{{.*}}Sym {
; OBJ32:          Kind: S_LPROC32_ID (0x1146)
; OBJ32:          CodeSize: 0x6
; OBJ32:          DisplayName: x
; OBJ32:          LinkageName: _x
; OBJ32:        }
; OBJ32:        ProcEnd {
; OBJ32:        }
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Lines (0xF2)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: FrameData (0xF5)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ32:        {{.*}}Proc{{.*}}Sym {
; OBJ32:          Kind: S_GPROC32_ID (0x1147)
; OBJ32:          CodeSize: 0x6
; OBJ32:          DisplayName: y
; OBJ32:          LinkageName: _y
; OBJ32:        }
; OBJ32:        ProcEnd {
; OBJ32:        }
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Lines (0xF2)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: FrameData (0xF5)
; OBJ32:      ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ32:        {{.*}}Proc{{.*}}Sym {
; OBJ32:          Kind: S_GPROC32_ID (0x1147)
; OBJ32:          CodeSize: 0x10
; OBJ32:          DisplayName: f
; OBJ32:          LinkageName: _f
; OBJ32:        }
; OBJ32:        ProcEnd {
; OBJ32:        }
; OBJ32-NEXT: ]
; OBJ32:      Subsection [
; OBJ32-NEXT:   SubSectionType: Lines (0xF2)
; OBJ32:      ]
; OBJ32:      FunctionLineTable [
; OBJ32-NEXT:   Name: _x
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x6
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0 [
; OBJ32-NEXT:       LineNumberStart: 4
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 42
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:     +0x5 [
; OBJ32-NEXT:       LineNumberStart: 5
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 43
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]
; OBJ32-NEXT: FunctionLineTable [
; OBJ32-NEXT:   LinkageName: _y
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x6
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0 [
; OBJ32-NEXT:       LineNumberStart: 8
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 52
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:     +0x5 [
; OBJ32-NEXT:       LineNumberStart: 9
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 53
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]
; OBJ32-NEXT: FunctionLineTable [
; OBJ32-NEXT:   LinkageName: _f
; OBJ32-NEXT:   Flags: 0x1
; OBJ32-NEXT:   CodeSize: 0x10
; OBJ32-NEXT:   FilenameSegment [
; OBJ32-NEXT:     Filename: D:\source.c
; OBJ32-NEXT:     +0x0 [
; OBJ32-NEXT:       LineNumberStart: 12
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 62
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:     +0x5 [
; OBJ32-NEXT:       LineNumberStart: 13
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 63
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:     +0xA [
; OBJ32-NEXT:       LineNumberStart: 14
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 72
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:     +0xF [
; OBJ32-NEXT:       LineNumberStart: 15
; OBJ32-NEXT:       LineNumberEndDelta: 0
; OBJ32-NEXT:       IsStatement: No
; OBJ32-NEXT:       ColStart: 73
; OBJ32-NEXT:       ColEnd: 0
; OBJ32-NEXT:     ]
; OBJ32-NEXT:   ]
; OBJ32-NEXT: ]


; X64-LABEL: x:
; X64-NEXT: .L{{.*}}:
; X64:      .cv_file 1 "D:\\source.c"
; X64:      .cv_loc 0 1 3 0 # source.c:3:0
; X64:      # %bb.
; X64:      subq    $40, %rsp
; X64:      .cv_loc 0 1 4 42 # source.c:4:42
; X64-NEXT: callq   z
; X64:      .cv_loc 0 1 5 43 # source.c:5:43
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64:      [[END_OF_X:.?Lfunc_end.*]]:
;
; X64-LABEL: y:
; X64-NEXT: .L{{.*}}:
; X64:      .cv_loc 1 1 7 0 # source.c:7:0
; X64:      # %bb.
; X64:      subq    $40, %rsp
; X64:      .cv_loc 1 1 8 52 # source.c:8:52
; X64-NEXT: callq   z
; X64:      .cv_loc 1 1 9 53 # source.c:9:53
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64:      [[END_OF_Y:.?Lfunc_end.*]]:
;
; X64-LABEL: f:
; X64-NEXT: .L{{.*}}:
; X64:      .cv_loc 2 1 11 0 # source.c:11:0
; X64:      # %bb.
; X64:      subq    $40, %rsp
; X64:      .cv_loc 2 1 12 62 # source.c:12:62
; X64-NEXT: callq   x
; X64:      .cv_loc 2 1 13 63 # source.c:13:63
; X64:      callq   y
; X64:      .cv_loc 2 1 14 72 # source.c:14:72
; X64:      callq   z
; X64:      .cv_loc 2 1 15 73 # source.c:15:73
; X64:      addq    $40, %rsp
; X64-NEXT: ret
; X64:      [[END_OF_F:.?Lfunc_end.*]]:
;

; X64-LABEL: .section        .debug$S,"dr"
; X64-NEXT: .p2align 2
; X64-NEXT: .long   4
; X64-NEXT: .long   241
; X64-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; Compiler information record
; X64-NEXT: [[COMPILE_START]]:
; X64-NEXT: .short [[C1_END:.*]]-[[C1_START:.*]] #
; X64:      [[COMPILE_END]]:
; X64-NEXT: .p2align 2
; Symbol subsection for x
; X64-NEXT: .long   241
; X64-NEXT: .long  [[F1_END:.*]]-[[F1_START:.*]] #
; X64-NEXT: [[F1_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4422
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long [[END_OF_X]]-x
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   4098
; X64-NEXT: .secrel32 x
; X64-NEXT: .secidx x
; X64-NEXT: .byte   0
; X64-NEXT: .asciz "x"
; X64-NEXT: .p2align 2
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X64-NEXT: [[FPROC_BEG]]:
; X64-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X64-NEXT: .long   40                       # FrameSize
; X64-NEXT: .long   0                       # Padding
; X64-NEXT: .long   0                       # Offset of padding
; X64-NEXT: .long   0                       # Bytes of callee saved registers
; X64-NEXT: .long   0                       # Exception handler offset
; X64-NEXT: .short  0                       # Exception handler section
; X64-NEXT: .long   81920                       # Flags (defines frame register)
; X64-NEXT: .p2align 2
; X64-NEXT: [[FPROC_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[F1_END]]:
; X64-NEXT: .p2align 2
; Line table subsection for x
; X64: .cv_linetable 0, x, [[END_OF_X]]
; Symbol subsection for y
; X64-NEXT: .long   241
; X64-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; X64-NEXT: [[COMPILE_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4423
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long [[END_OF_Y]]-y
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   4099
; X64-NEXT: .secrel32 y
; X64-NEXT: .secidx y
; X64-NEXT: .byte   0
; X64-NEXT: .asciz "y"
; X64-NEXT: .p2align 2
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X64-NEXT: [[FPROC_BEG]]:
; X64-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X64-NEXT: .long   40                       # FrameSize
; X64-NEXT: .long   0                       # Padding
; X64-NEXT: .long   0                       # Offset of padding
; X64-NEXT: .long   0                       # Bytes of callee saved registers
; X64-NEXT: .long   0                       # Exception handler offset
; X64-NEXT: .short  0                       # Exception handler section
; X64-NEXT: .long   81920                       # Flags (defines frame register)
; X64-NEXT: .p2align 2
; X64-NEXT: [[FPROC_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[COMPILE_END]]:
; X64-NEXT: .p2align 2
; Line table subsection for y
; X64: .cv_linetable 1, y, [[END_OF_Y]]
; Symbol subsection for f
; X64-NEXT: .long   241
; X64-NEXT: .long [[COMPILE_END:.*]]-[[COMPILE_START:.*]] #
; X64:      [[COMPILE_START]]:
; X64-NEXT: .short [[PROC_SEGMENT_END:.*]]-[[PROC_SEGMENT_START:.*]] #
; X64-NEXT: [[PROC_SEGMENT_START]]:
; X64-NEXT: .short  4423
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long [[END_OF_F]]-f
; X64-NEXT: .long   0
; X64-NEXT: .long   0
; X64-NEXT: .long   4100
; X64-NEXT: .secrel32 f
; X64-NEXT: .secidx f
; X64-NEXT: .byte   0
; X64-NEXT: .asciz "f"
; X64-NEXT: .p2align 2
; X64-NEXT: [[PROC_SEGMENT_END]]:
; X64-NEXT: .short  [[FPROC_END:[^ ]*]]-[[FPROC_BEG:[^ ]*]]           # Record length
; X64-NEXT: [[FPROC_BEG]]:
; X64-NEXT: .short  4114                    # Record kind: S_FRAMEPROC
; X64-NEXT: .long   40                       # FrameSize
; X64-NEXT: .long   0                       # Padding
; X64-NEXT: .long   0                       # Offset of padding
; X64-NEXT: .long   0                       # Bytes of callee saved registers
; X64-NEXT: .long   0                       # Exception handler offset
; X64-NEXT: .short  0                       # Exception handler section
; X64-NEXT: .long   81920                       # Flags (defines frame register)
; X64-NEXT: .p2align 2
; X64-NEXT: [[FPROC_END]]:
; X64-NEXT: .short  2
; X64-NEXT: .short  4431
; X64-NEXT: [[COMPILE_END]]:
; X64-NEXT: .p2align 2
; Line table subsection for f
; X64: .cv_linetable 2, f, [[END_OF_F]]
; File index to string table offset subsection
; X64: .cv_filechecksums
; String table
; X64: .cv_stringtable

; OBJ64:    Section {
; OBJ64:      Name: .debug$S (2E 64 65 62 75 67 24 53)
; OBJ64:      Characteristics [ (0x42300040)
; OBJ64:      ]
; OBJ64:      Relocations [
; OBJ64-NEXT:   0x70 IMAGE_REL_AMD64_SECREL x
; OBJ64-NEXT:   0x74 IMAGE_REL_AMD64_SECTION x
; OBJ64-NEXT:   0xA8 IMAGE_REL_AMD64_SECREL x
; OBJ64-NEXT:   0xAC IMAGE_REL_AMD64_SECTION x
; OBJ64-NEXT:   0x10C IMAGE_REL_AMD64_SECREL y
; OBJ64-NEXT:   0x110 IMAGE_REL_AMD64_SECTION y
; OBJ64-NEXT:   0x144 IMAGE_REL_AMD64_SECREL y
; OBJ64-NEXT:   0x148 IMAGE_REL_AMD64_SECTION y
; OBJ64-NEXT:   0x1A8 IMAGE_REL_AMD64_SECREL f
; OBJ64-NEXT:   0x1AC IMAGE_REL_AMD64_SECTION f
; OBJ64-NEXT:   0x1E0 IMAGE_REL_AMD64_SECREL f
; OBJ64-NEXT:   0x1E4 IMAGE_REL_AMD64_SECTION f
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ64:        {{.*}}Proc{{.*}}Sym {
; OBJ64:          Kind: S_LPROC32_ID (0x1146)
; OBJ64:          CodeSize: 0xE
; OBJ64:          DisplayName: x
; OBJ64:          LinkageName: x
; OBJ64:        }
; OBJ64:        ProcEnd {
; OBJ64:        }
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Lines (0xF2)
; OBJ64:      ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ64:        {{.*}}Proc{{.*}}Sym {
; OBJ64:          Kind: S_GPROC32_ID (0x1147)
; OBJ64:          CodeSize: 0xE
; OBJ64:          DisplayName: y
; OBJ64:          LinkageName: y
; OBJ64:        }
; OBJ64:        ProcEnd {
; OBJ64:        }
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Lines (0xF2)
; OBJ64:      ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Symbols (0xF1)
; OBJ64:        {{.*}}Proc{{.*}}Sym {
; OBJ64:          Kind: S_GPROC32_ID (0x1147)
; OBJ64:          CodeSize: 0x18
; OBJ64:          DisplayName: f
; OBJ64:          LinkageName: f
; OBJ64:        }
; OBJ64:        ProcEnd {
; OBJ64:        }
; OBJ64-NEXT: ]
; OBJ64:      Subsection [
; OBJ64-NEXT:   SubSectionType: Lines (0xF2)
; OBJ64:      ]
; OBJ64:      FunctionLineTable [
; OBJ64-NEXT:   LinkageName: x
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0xE
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0 [
; OBJ64-NEXT:       LineNumberStart: 3
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 0
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x4 [
; OBJ64-NEXT:       LineNumberStart: 4
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 42
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x9 [
; OBJ64-NEXT:       LineNumberStart: 5
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 43
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]
; OBJ64-NEXT: FunctionLineTable [
; OBJ64-NEXT:   LinkageName: y
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0xE
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0 [
; OBJ64-NEXT:       LineNumberStart: 7
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 0
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x4 [
; OBJ64-NEXT:       LineNumberStart: 8
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 52
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x9 [
; OBJ64-NEXT:       LineNumberStart: 9
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 53
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]
; OBJ64-NEXT: FunctionLineTable [
; OBJ64-NEXT:   LinkageName: f
; OBJ64-NEXT:   Flags: 0x1
; OBJ64-NEXT:   CodeSize: 0x18
; OBJ64-NEXT:   FilenameSegment [
; OBJ64-NEXT:     Filename: D:\source.c
; OBJ64-NEXT:     +0x0 [
; OBJ64-NEXT:       LineNumberStart: 11
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 0
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x4 [
; OBJ64-NEXT:       LineNumberStart: 12
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 62
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x9 [
; OBJ64-NEXT:       LineNumberStart: 13
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 63
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0xE [
; OBJ64-NEXT:       LineNumberStart: 14
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 72
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:     +0x13 [
; OBJ64-NEXT:       LineNumberStart: 15
; OBJ64-NEXT:       LineNumberEndDelta: 0
; OBJ64-NEXT:       IsStatement: No
; OBJ64-NEXT:       ColStart: 73
; OBJ64-NEXT:       ColEnd: 0
; OBJ64-NEXT:     ]
; OBJ64-NEXT:   ]
; OBJ64-NEXT: ]

; Function Attrs: nounwind
define internal void @x() #0 !dbg !4 {
entry:
  call void @z(), !dbg !14
  ret void, !dbg !15
}

declare void @z() #1

; Function Attrs: nounwind
define void @y() #0 !dbg !9 {
entry:
  call void @z(), !dbg !16
  ret void, !dbg !17
}

; Function Attrs: nounwind
define void @f() #0 !dbg !10 {
entry:
  call void @x(), !dbg !18
  call void @y(), !dbg !19
  call void @z(), !dbg !20
  ret void, !dbg !21
}

attributes #0 = { nounwind "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-realign-stack" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.5 ", isOptimized: false, emissionKind: FullDebug, file: !1, enums: !2, retainedTypes: !2, globals: !2, imports: !2)
!1 = !DIFile(filename: "<unknown>", directory: "D:\5C")
!2 = !{}
!4 = distinct !DISubprogram(name: "x", line: 3, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 3, file: !5, scope: !6, type: !7, retainedNodes: !2)
!5 = !DIFile(filename: "source.c", directory: "D:\5C")
!6 = !DIFile(filename: "source.c", directory: "D:C")
!7 = !DISubroutineType(types: !8)
!8 = !{null}
!9 = distinct !DISubprogram(name: "y", line: 7, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 7, file: !5, scope: !6, type: !7, retainedNodes: !2)
!10 = distinct !DISubprogram(name: "f", line: 11, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !0, scopeLine: 11, file: !5, scope: !6, type: !7, retainedNodes: !2)
!11 = !{i32 2, !"CodeView", i32 1}
!12 = !{i32 1, !"Debug Info Version", i32 3}
!13 = !{!"clang version 3.5 "}
!14 = !DILocation(line: 4, column: 42, scope: !4)
!15 = !DILocation(line: 5, column: 43, scope: !4)
!16 = !DILocation(line: 8, column: 52, scope: !9)
!17 = !DILocation(line: 9, column: 53, scope: !9)
!18 = !DILocation(line: 12, column: 62, scope: !10)
!19 = !DILocation(line: 13, column: 63, scope: !10)
!20 = !DILocation(line: 14, column: 72, scope: !10)
!21 = !DILocation(line: 15, column: 73, scope: !10)
