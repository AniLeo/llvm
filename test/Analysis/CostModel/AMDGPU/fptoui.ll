; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx1010 < %s | FileCheck -check-prefixes=ALL,FAST %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a < %s | FileCheck -check-prefixes=ALL,FAST %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefixes=ALL,FAST %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck -check-prefixes=ALL,SLOW %s

; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx1010 < %s | FileCheck -check-prefixes=ALL-SIZE,FAST-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a < %s | FileCheck -check-prefixes=ALL-SIZE,FAST-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefixes=ALL-SIZE,FAST-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck -check-prefixes=ALL-SIZE,SLOW-SIZE %s
; END.

define i32 @fptoui_double_i64(i32 %arg) {
; ALL-LABEL: 'fptoui_double_i64'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = fptoui double undef to i64
; ALL-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I64 = fptoui <2 x double> undef to <2 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I64 = fptoui <4 x double> undef to <4 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I64 = fptoui <8 x double> undef to <8 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; ALL-SIZE-LABEL: 'fptoui_double_i64'
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = fptoui double undef to i64
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I64 = fptoui <2 x double> undef to <2 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I64 = fptoui <4 x double> undef to <4 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I64 = fptoui <8 x double> undef to <8 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I64 = fptoui double undef to i64
  %V2I64 = fptoui <2 x double> undef to <2 x i64>
  %V4I64 = fptoui <4 x double> undef to <4 x i64>
  %V8I64 = fptoui <8 x double> undef to <8 x i64>
  ret i32 undef
}

define i32 @fptoui_double_i32(i32 %arg) {
; ALL-LABEL: 'fptoui_double_i32'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = fptoui double undef to i32
; ALL-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I32 = fptoui <2 x double> undef to <2 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I32 = fptoui <4 x double> undef to <4 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I32 = fptoui <8 x double> undef to <8 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; ALL-SIZE-LABEL: 'fptoui_double_i32'
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = fptoui double undef to i32
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I32 = fptoui <2 x double> undef to <2 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I32 = fptoui <4 x double> undef to <4 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I32 = fptoui <8 x double> undef to <8 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I32 = fptoui double undef to i32
  %V2I32 = fptoui <2 x double> undef to <2 x i32>
  %V4I32 = fptoui <4 x double> undef to <4 x i32>
  %V8I32 = fptoui <8 x double> undef to <8 x i32>
  ret i32 undef
}

define i32 @fptoui_double_i16(i32 %arg) {
; FAST-LABEL: 'fptoui_double_i16'
; FAST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui double undef to i16
; FAST-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = fptoui <2 x double> undef to <2 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4I16 = fptoui <4 x double> undef to <4 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8I16 = fptoui <8 x double> undef to <8 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; SLOW-LABEL: 'fptoui_double_i16'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui double undef to i16
; SLOW-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I16 = fptoui <2 x double> undef to <2 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I16 = fptoui <4 x double> undef to <4 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I16 = fptoui <8 x double> undef to <8 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; FAST-SIZE-LABEL: 'fptoui_double_i16'
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui double undef to i16
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = fptoui <2 x double> undef to <2 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4I16 = fptoui <4 x double> undef to <4 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8I16 = fptoui <8 x double> undef to <8 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; SLOW-SIZE-LABEL: 'fptoui_double_i16'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui double undef to i16
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I16 = fptoui <2 x double> undef to <2 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I16 = fptoui <4 x double> undef to <4 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I16 = fptoui <8 x double> undef to <8 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I16 = fptoui double undef to i16
  %V2I16 = fptoui <2 x double> undef to <2 x i16>
  %V4I16 = fptoui <4 x double> undef to <4 x i16>
  %V8I16 = fptoui <8 x double> undef to <8 x i16>
  ret i32 undef
}

define i32 @fptoui_double_i8(i32 %arg) {
; FAST-LABEL: 'fptoui_double_i8'
; FAST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui double undef to i8
; FAST-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V2I8 = fptoui <2 x double> undef to <2 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V4I8 = fptoui <4 x double> undef to <4 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V8I8 = fptoui <8 x double> undef to <8 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; SLOW-LABEL: 'fptoui_double_i8'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui double undef to i8
; SLOW-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I8 = fptoui <2 x double> undef to <2 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = fptoui <4 x double> undef to <4 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I8 = fptoui <8 x double> undef to <8 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; FAST-SIZE-LABEL: 'fptoui_double_i8'
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui double undef to i8
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V2I8 = fptoui <2 x double> undef to <2 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V4I8 = fptoui <4 x double> undef to <4 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V8I8 = fptoui <8 x double> undef to <8 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; SLOW-SIZE-LABEL: 'fptoui_double_i8'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui double undef to i8
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I8 = fptoui <2 x double> undef to <2 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = fptoui <4 x double> undef to <4 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I8 = fptoui <8 x double> undef to <8 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I8 = fptoui double undef to i8
  %V2I8 = fptoui <2 x double> undef to <2 x i8>
  %V4I8 = fptoui <4 x double> undef to <4 x i8>
  %V8I8 = fptoui <8 x double> undef to <8 x i8>
  ret i32 undef
}

define i32 @fptoui_float_i64(i32 %arg) {
; ALL-LABEL: 'fptoui_float_i64'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = fptoui float undef to i64
; ALL-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I64 = fptoui <2 x float> undef to <2 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I64 = fptoui <4 x float> undef to <4 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I64 = fptoui <8 x float> undef to <8 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I64 = fptoui <16 x float> undef to <16 x i64>
; ALL-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; ALL-SIZE-LABEL: 'fptoui_float_i64'
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I64 = fptoui float undef to i64
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I64 = fptoui <2 x float> undef to <2 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I64 = fptoui <4 x float> undef to <4 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I64 = fptoui <8 x float> undef to <8 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I64 = fptoui <16 x float> undef to <16 x i64>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I64 = fptoui float undef to i64
  %V2I64 = fptoui <2 x float> undef to <2 x i64>
  %V4I64 = fptoui <4 x float> undef to <4 x i64>
  %V8I64 = fptoui <8 x float> undef to <8 x i64>
  %V16I64 = fptoui <16 x float> undef to <16 x i64>
  ret i32 undef
}

define i32 @fptoui_float_i32(i32 %arg) {
; ALL-LABEL: 'fptoui_float_i32'
; ALL-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = fptoui float undef to i32
; ALL-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I32 = fptoui <2 x float> undef to <2 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I32 = fptoui <4 x float> undef to <4 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I32 = fptoui <8 x float> undef to <8 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I32 = fptoui <16 x float> undef to <16 x i32>
; ALL-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; ALL-SIZE-LABEL: 'fptoui_float_i32'
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I32 = fptoui float undef to i32
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I32 = fptoui <2 x float> undef to <2 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I32 = fptoui <4 x float> undef to <4 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I32 = fptoui <8 x float> undef to <8 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I32 = fptoui <16 x float> undef to <16 x i32>
; ALL-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I32 = fptoui float undef to i32
  %V2I32 = fptoui <2 x float> undef to <2 x i32>
  %V4I32 = fptoui <4 x float> undef to <4 x i32>
  %V8I32 = fptoui <8 x float> undef to <8 x i32>
  %V16I32 = fptoui <16 x float> undef to <16 x i32>
  ret i32 undef
}

define i32 @fptoui_float_i16(i32 %arg) {
; FAST-LABEL: 'fptoui_float_i16'
; FAST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui float undef to i16
; FAST-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = fptoui <2 x float> undef to <2 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4I16 = fptoui <4 x float> undef to <4 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8I16 = fptoui <8 x float> undef to <8 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 44 for instruction: %V16I16 = fptoui <16 x float> undef to <16 x i16>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; SLOW-LABEL: 'fptoui_float_i16'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui float undef to i16
; SLOW-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I16 = fptoui <2 x float> undef to <2 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I16 = fptoui <4 x float> undef to <4 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I16 = fptoui <8 x float> undef to <8 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I16 = fptoui <16 x float> undef to <16 x i16>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; FAST-SIZE-LABEL: 'fptoui_float_i16'
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui float undef to i16
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V2I16 = fptoui <2 x float> undef to <2 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %V4I16 = fptoui <4 x float> undef to <4 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %V8I16 = fptoui <8 x float> undef to <8 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 44 for instruction: %V16I16 = fptoui <16 x float> undef to <16 x i16>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; SLOW-SIZE-LABEL: 'fptoui_float_i16'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I16 = fptoui float undef to i16
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I16 = fptoui <2 x float> undef to <2 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I16 = fptoui <4 x float> undef to <4 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I16 = fptoui <8 x float> undef to <8 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I16 = fptoui <16 x float> undef to <16 x i16>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I16 = fptoui float undef to i16
  %V2I16 = fptoui <2 x float> undef to <2 x i16>
  %V4I16 = fptoui <4 x float> undef to <4 x i16>
  %V8I16 = fptoui <8 x float> undef to <8 x i16>
  %V16I16 = fptoui <16 x float> undef to <16 x i16>
  ret i32 undef
}

define i32 @fptoui_float_i8(i32 %arg) {
; FAST-LABEL: 'fptoui_float_i8'
; FAST-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui float undef to i8
; FAST-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V2I8 = fptoui <2 x float> undef to <2 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V4I8 = fptoui <4 x float> undef to <4 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V8I8 = fptoui <8 x float> undef to <8 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %V16I8 = fptoui <16 x float> undef to <16 x i8>
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; SLOW-LABEL: 'fptoui_float_i8'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui float undef to i8
; SLOW-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I8 = fptoui <2 x float> undef to <2 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = fptoui <4 x float> undef to <4 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I8 = fptoui <8 x float> undef to <8 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I8 = fptoui <16 x float> undef to <16 x i8>
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret i32 undef
;
; FAST-SIZE-LABEL: 'fptoui_float_i8'
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui float undef to i8
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %V2I8 = fptoui <2 x float> undef to <2 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %V4I8 = fptoui <4 x float> undef to <4 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %V8I8 = fptoui <8 x float> undef to <8 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %V16I8 = fptoui <16 x float> undef to <16 x i8>
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
; SLOW-SIZE-LABEL: 'fptoui_float_i8'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %I8 = fptoui float undef to i8
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V2I8 = fptoui <2 x float> undef to <2 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V4I8 = fptoui <4 x float> undef to <4 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %V8I8 = fptoui <8 x float> undef to <8 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %V16I8 = fptoui <16 x float> undef to <16 x i8>
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %I8 = fptoui float undef to i8
  %V2I8 = fptoui <2 x float> undef to <2 x i8>
  %V4I8 = fptoui <4 x float> undef to <4 x i8>
  %V8I8 = fptoui <8 x float> undef to <8 x i8>
  %V16I8 = fptoui <16 x float> undef to <16 x i8>
  ret i32 undef
}
