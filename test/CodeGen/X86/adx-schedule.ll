; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+adx | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=broadwell | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE --check-prefix=SKL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skx     | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl     | FileCheck %s --check-prefix=CHECK --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1  | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define void @test_adcx(i32 %a0, i32* %a1, i64 %a2, i64* %a3) optsize {
; GENERIC-LABEL: test_adcx:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    adcxl %edi, %edi # sched: [1:0.33]
; GENERIC-NEXT:    adcxq %rdx, %rdx # sched: [1:0.33]
; GENERIC-NEXT:    adcxl (%rsi), %edi # sched: [6:0.50]
; GENERIC-NEXT:    adcxq (%rcx), %rdx # sched: [6:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BROADWELL-LABEL: test_adcx:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    adcxl %edi, %edi # sched: [1:0.50]
; BROADWELL-NEXT:    adcxq %rdx, %rdx # sched: [1:0.50]
; BROADWELL-NEXT:    adcxl (%rsi), %edi # sched: [6:0.50]
; BROADWELL-NEXT:    adcxq (%rcx), %rdx # sched: [6:0.50]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_adcx:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    adcxl %edi, %edi # sched: [1:0.50]
; SKYLAKE-NEXT:    adcxq %rdx, %rdx # sched: [1:0.50]
; SKYLAKE-NEXT:    adcxl (%rsi), %edi # sched: [6:0.50]
; SKYLAKE-NEXT:    adcxq (%rcx), %rdx # sched: [6:0.50]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_adcx:
; KNL:       # %bb.0:
; KNL-NEXT:    #APP
; KNL-NEXT:    adcxl %edi, %edi # sched: [1:0.25]
; KNL-NEXT:    adcxq %rdx, %rdx # sched: [1:0.25]
; KNL-NEXT:    adcxl (%rsi), %edi # sched: [6:0.50]
; KNL-NEXT:    adcxq (%rcx), %rdx # sched: [6:0.50]
; KNL-NEXT:    #NO_APP
; KNL-NEXT:    retq # sched: [7:1.00]
;
; ZNVER1-LABEL: test_adcx:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    adcxl %edi, %edi # sched: [1:0.25]
; ZNVER1-NEXT:    adcxq %rdx, %rdx # sched: [1:0.25]
; ZNVER1-NEXT:    adcxl (%rsi), %edi # sched: [5:0.50]
; ZNVER1-NEXT:    adcxq (%rcx), %rdx # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  tail call void asm "adcx $0, $0 \0A\09 adcx $2, $2 \0A\09 adcx $1, $0 \0A\09 adcx $3, $2", "r,*m,r,*m"(i32 %a0, i32* %a1, i64 %a2, i64* %a3) nounwind
  ret void
}
define void @test_adox(i32 %a0, i32* %a1, i64 %a2, i64* %a3) optsize {
; GENERIC-LABEL: test_adox:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    #APP
; GENERIC-NEXT:    adoxl %edi, %edi # sched: [1:0.33]
; GENERIC-NEXT:    adoxq %rdx, %rdx # sched: [1:0.33]
; GENERIC-NEXT:    adoxl (%rsi), %edi # sched: [6:0.50]
; GENERIC-NEXT:    adoxq (%rcx), %rdx # sched: [6:0.50]
; GENERIC-NEXT:    #NO_APP
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; BROADWELL-LABEL: test_adox:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    #APP
; BROADWELL-NEXT:    adoxl %edi, %edi # sched: [1:0.50]
; BROADWELL-NEXT:    adoxq %rdx, %rdx # sched: [1:0.50]
; BROADWELL-NEXT:    adoxl (%rsi), %edi # sched: [6:0.50]
; BROADWELL-NEXT:    adoxq (%rcx), %rdx # sched: [6:0.50]
; BROADWELL-NEXT:    #NO_APP
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_adox:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    #APP
; SKYLAKE-NEXT:    adoxl %edi, %edi # sched: [1:0.50]
; SKYLAKE-NEXT:    adoxq %rdx, %rdx # sched: [1:0.50]
; SKYLAKE-NEXT:    adoxl (%rsi), %edi # sched: [6:0.50]
; SKYLAKE-NEXT:    adoxq (%rcx), %rdx # sched: [6:0.50]
; SKYLAKE-NEXT:    #NO_APP
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; KNL-LABEL: test_adox:
; KNL:       # %bb.0:
; KNL-NEXT:    #APP
; KNL-NEXT:    adoxl %edi, %edi # sched: [1:0.25]
; KNL-NEXT:    adoxq %rdx, %rdx # sched: [1:0.25]
; KNL-NEXT:    adoxl (%rsi), %edi # sched: [6:0.50]
; KNL-NEXT:    adoxq (%rcx), %rdx # sched: [6:0.50]
; KNL-NEXT:    #NO_APP
; KNL-NEXT:    retq # sched: [7:1.00]
;
; ZNVER1-LABEL: test_adox:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    #APP
; ZNVER1-NEXT:    adoxl %edi, %edi # sched: [1:0.25]
; ZNVER1-NEXT:    adoxq %rdx, %rdx # sched: [1:0.25]
; ZNVER1-NEXT:    adoxl (%rsi), %edi # sched: [5:0.50]
; ZNVER1-NEXT:    adoxq (%rcx), %rdx # sched: [5:0.50]
; ZNVER1-NEXT:    #NO_APP
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  tail call void asm "adox $0, $0 \0A\09 adox $2, $2 \0A\09 adox $1, $0 \0A\09 adox $3, $2", "r,*m,r,*m"(i32 %a0, i32* %a1, i64 %a2, i64* %a3) nounwind
  ret void
}
