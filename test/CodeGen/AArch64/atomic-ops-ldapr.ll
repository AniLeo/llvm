; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+ldapr -fast-isel=0 -global-isel=false -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=aarch64-none-linux-gnu -mattr=+ldapr -fast-isel=1 -global-isel=false -verify-machineinstrs < %s | FileCheck %s --check-prefix=FAST-ISEL

define i8 @test_load_8_acq(i8* %addr) {
; CHECK-LABEL: test_load_8_acq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldaprb w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_8_acq:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldaprb w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i8, i8* %addr acquire, align 1
  ret i8 %val
}

define i8 @test_load_8_csc(i8* %addr) {
; CHECK-LABEL: test_load_8_csc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldarb w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_8_csc:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldarb w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i8, i8* %addr seq_cst, align 1
  ret i8 %val
}

define i16 @test_load_16_acq(i16* %addr) {
; CHECK-LABEL: test_load_16_acq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldaprh w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_16_acq:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldaprh w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i16, i16* %addr acquire, align 2
  ret i16 %val
}

define i16 @test_load_16_csc(i16* %addr) {
; CHECK-LABEL: test_load_16_csc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldarh w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_16_csc:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldarh w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i16, i16* %addr seq_cst, align 2
  ret i16 %val
}

define i32 @test_load_32_acq(i32* %addr) {
; CHECK-LABEL: test_load_32_acq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldapr w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_32_acq:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldapr w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i32, i32* %addr acquire, align 4
  ret i32 %val
}

define i32 @test_load_32_csc(i32* %addr) {
; CHECK-LABEL: test_load_32_csc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldar w0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_32_csc:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldar w0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i32, i32* %addr seq_cst, align 4
  ret i32 %val
}

define i64 @test_load_64_acq(i64* %addr) {
; CHECK-LABEL: test_load_64_acq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldapr x0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_64_acq:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldapr x0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i64, i64* %addr acquire, align 8
  ret i64 %val
}

define i64 @test_load_64_csc(i64* %addr) {
; CHECK-LABEL: test_load_64_csc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldar x0, [x0]
; CHECK-NEXT:    ret
;
; FAST-ISEL-LABEL: test_load_64_csc:
; FAST-ISEL:       // %bb.0:
; FAST-ISEL-NEXT:    ldar x0, [x0]
; FAST-ISEL-NEXT:    ret
  %val = load atomic i64, i64* %addr seq_cst, align 8
  ret i64 %val
}
