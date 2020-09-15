; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -march=amdgcn -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

; FIXME: we should disable sdwa peephole because dead-code elimination, that
; runs after peephole, ruins this test (different register numbers)

; Spill all SGPRs so multiple VGPRs are required for spilling all of them.

; Ideally we only need 2 VGPRs for all spilling. The VGPRs are
; allocated per-frame index, so it's possible to get up with more.
define amdgpu_kernel void @spill_sgprs_to_multiple_vgprs(i32 addrspace(1)* %out, i32 %in) #0 {
; GCN-LABEL: spill_sgprs_to_multiple_vgprs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[12:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[20:27]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[36:43]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[44:51]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[52:59]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[60:67]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[68:75]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[76:83]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[84:91]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 0
; GCN-NEXT:    v_writelane_b32 v0, s5, 1
; GCN-NEXT:    v_writelane_b32 v0, s6, 2
; GCN-NEXT:    v_writelane_b32 v0, s7, 3
; GCN-NEXT:    v_writelane_b32 v0, s8, 4
; GCN-NEXT:    v_writelane_b32 v0, s9, 5
; GCN-NEXT:    v_writelane_b32 v0, s10, 6
; GCN-NEXT:    v_writelane_b32 v0, s11, 7
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 8
; GCN-NEXT:    v_writelane_b32 v0, s5, 9
; GCN-NEXT:    v_writelane_b32 v0, s6, 10
; GCN-NEXT:    v_writelane_b32 v0, s7, 11
; GCN-NEXT:    v_writelane_b32 v0, s8, 12
; GCN-NEXT:    v_writelane_b32 v0, s9, 13
; GCN-NEXT:    v_writelane_b32 v0, s10, 14
; GCN-NEXT:    v_writelane_b32 v0, s11, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 16
; GCN-NEXT:    v_writelane_b32 v0, s5, 17
; GCN-NEXT:    v_writelane_b32 v0, s6, 18
; GCN-NEXT:    v_writelane_b32 v0, s7, 19
; GCN-NEXT:    v_writelane_b32 v0, s8, 20
; GCN-NEXT:    v_writelane_b32 v0, s9, 21
; GCN-NEXT:    v_writelane_b32 v0, s10, 22
; GCN-NEXT:    v_writelane_b32 v0, s11, 23
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 24
; GCN-NEXT:    v_writelane_b32 v0, s5, 25
; GCN-NEXT:    v_writelane_b32 v0, s6, 26
; GCN-NEXT:    v_writelane_b32 v0, s7, 27
; GCN-NEXT:    v_writelane_b32 v0, s8, 28
; GCN-NEXT:    v_writelane_b32 v0, s9, 29
; GCN-NEXT:    v_writelane_b32 v0, s10, 30
; GCN-NEXT:    v_writelane_b32 v0, s11, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 32
; GCN-NEXT:    v_writelane_b32 v0, s5, 33
; GCN-NEXT:    v_writelane_b32 v0, s6, 34
; GCN-NEXT:    v_writelane_b32 v0, s7, 35
; GCN-NEXT:    v_writelane_b32 v0, s8, 36
; GCN-NEXT:    v_writelane_b32 v0, s9, 37
; GCN-NEXT:    v_writelane_b32 v0, s10, 38
; GCN-NEXT:    v_writelane_b32 v0, s11, 39
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 40
; GCN-NEXT:    v_writelane_b32 v0, s5, 41
; GCN-NEXT:    v_writelane_b32 v0, s6, 42
; GCN-NEXT:    v_writelane_b32 v0, s7, 43
; GCN-NEXT:    v_writelane_b32 v0, s8, 44
; GCN-NEXT:    v_writelane_b32 v0, s9, 45
; GCN-NEXT:    v_writelane_b32 v0, s10, 46
; GCN-NEXT:    v_writelane_b32 v0, s11, 47
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 48
; GCN-NEXT:    v_writelane_b32 v0, s5, 49
; GCN-NEXT:    v_writelane_b32 v0, s6, 50
; GCN-NEXT:    v_writelane_b32 v0, s7, 51
; GCN-NEXT:    v_writelane_b32 v0, s8, 52
; GCN-NEXT:    v_writelane_b32 v0, s9, 53
; GCN-NEXT:    v_writelane_b32 v0, s10, 54
; GCN-NEXT:    v_writelane_b32 v0, s11, 55
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:11]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_mov_b32 s3, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s2, s3
; GCN-NEXT:    v_writelane_b32 v0, s12, 56
; GCN-NEXT:    v_writelane_b32 v0, s13, 57
; GCN-NEXT:    v_writelane_b32 v0, s14, 58
; GCN-NEXT:    v_writelane_b32 v0, s15, 59
; GCN-NEXT:    v_writelane_b32 v0, s16, 60
; GCN-NEXT:    v_writelane_b32 v0, s17, 61
; GCN-NEXT:    v_writelane_b32 v0, s18, 62
; GCN-NEXT:    v_writelane_b32 v0, s19, 63
; GCN-NEXT:    v_writelane_b32 v1, s20, 0
; GCN-NEXT:    v_writelane_b32 v1, s21, 1
; GCN-NEXT:    v_writelane_b32 v1, s22, 2
; GCN-NEXT:    v_writelane_b32 v1, s23, 3
; GCN-NEXT:    v_writelane_b32 v1, s24, 4
; GCN-NEXT:    v_writelane_b32 v1, s25, 5
; GCN-NEXT:    v_writelane_b32 v1, s26, 6
; GCN-NEXT:    v_writelane_b32 v1, s27, 7
; GCN-NEXT:    v_writelane_b32 v1, s36, 8
; GCN-NEXT:    v_writelane_b32 v1, s37, 9
; GCN-NEXT:    v_writelane_b32 v1, s38, 10
; GCN-NEXT:    v_writelane_b32 v1, s39, 11
; GCN-NEXT:    v_writelane_b32 v1, s40, 12
; GCN-NEXT:    v_writelane_b32 v1, s41, 13
; GCN-NEXT:    v_writelane_b32 v1, s42, 14
; GCN-NEXT:    v_writelane_b32 v1, s43, 15
; GCN-NEXT:    v_writelane_b32 v1, s44, 16
; GCN-NEXT:    v_writelane_b32 v1, s45, 17
; GCN-NEXT:    v_writelane_b32 v1, s46, 18
; GCN-NEXT:    v_writelane_b32 v1, s47, 19
; GCN-NEXT:    v_writelane_b32 v1, s48, 20
; GCN-NEXT:    v_writelane_b32 v1, s49, 21
; GCN-NEXT:    v_writelane_b32 v1, s50, 22
; GCN-NEXT:    v_writelane_b32 v1, s51, 23
; GCN-NEXT:    v_writelane_b32 v1, s52, 24
; GCN-NEXT:    v_writelane_b32 v1, s53, 25
; GCN-NEXT:    v_writelane_b32 v1, s54, 26
; GCN-NEXT:    v_writelane_b32 v1, s55, 27
; GCN-NEXT:    v_writelane_b32 v1, s56, 28
; GCN-NEXT:    v_writelane_b32 v1, s57, 29
; GCN-NEXT:    v_writelane_b32 v1, s58, 30
; GCN-NEXT:    v_writelane_b32 v1, s59, 31
; GCN-NEXT:    v_writelane_b32 v1, s60, 32
; GCN-NEXT:    v_writelane_b32 v1, s61, 33
; GCN-NEXT:    v_writelane_b32 v1, s62, 34
; GCN-NEXT:    v_writelane_b32 v1, s63, 35
; GCN-NEXT:    v_writelane_b32 v1, s64, 36
; GCN-NEXT:    v_writelane_b32 v1, s65, 37
; GCN-NEXT:    v_writelane_b32 v1, s66, 38
; GCN-NEXT:    v_writelane_b32 v1, s67, 39
; GCN-NEXT:    v_writelane_b32 v1, s68, 40
; GCN-NEXT:    v_writelane_b32 v1, s69, 41
; GCN-NEXT:    v_writelane_b32 v1, s70, 42
; GCN-NEXT:    v_writelane_b32 v1, s71, 43
; GCN-NEXT:    v_writelane_b32 v1, s72, 44
; GCN-NEXT:    v_writelane_b32 v1, s73, 45
; GCN-NEXT:    v_writelane_b32 v1, s74, 46
; GCN-NEXT:    v_writelane_b32 v1, s75, 47
; GCN-NEXT:    v_writelane_b32 v1, s76, 48
; GCN-NEXT:    v_writelane_b32 v1, s77, 49
; GCN-NEXT:    v_writelane_b32 v1, s78, 50
; GCN-NEXT:    v_writelane_b32 v1, s79, 51
; GCN-NEXT:    v_writelane_b32 v1, s80, 52
; GCN-NEXT:    v_writelane_b32 v1, s81, 53
; GCN-NEXT:    v_writelane_b32 v1, s82, 54
; GCN-NEXT:    v_writelane_b32 v1, s83, 55
; GCN-NEXT:    v_writelane_b32 v1, s84, 56
; GCN-NEXT:    v_writelane_b32 v1, s85, 57
; GCN-NEXT:    v_writelane_b32 v1, s86, 58
; GCN-NEXT:    v_writelane_b32 v1, s87, 59
; GCN-NEXT:    v_writelane_b32 v1, s88, 60
; GCN-NEXT:    v_writelane_b32 v1, s89, 61
; GCN-NEXT:    v_writelane_b32 v1, s90, 62
; GCN-NEXT:    v_writelane_b32 v1, s91, 63
; GCN-NEXT:    v_writelane_b32 v2, s4, 0
; GCN-NEXT:    v_writelane_b32 v2, s5, 1
; GCN-NEXT:    v_writelane_b32 v2, s6, 2
; GCN-NEXT:    v_writelane_b32 v2, s7, 3
; GCN-NEXT:    v_writelane_b32 v2, s8, 4
; GCN-NEXT:    v_writelane_b32 v2, s9, 5
; GCN-NEXT:    v_writelane_b32 v2, s10, 6
; GCN-NEXT:    v_writelane_b32 v2, s11, 7
; GCN-NEXT:    s_cbranch_scc1 BB0_2
; GCN-NEXT:  ; %bb.1: ; %bb0
; GCN-NEXT:    v_readlane_b32 s0, v0, 0
; GCN-NEXT:    v_readlane_b32 s1, v0, 1
; GCN-NEXT:    v_readlane_b32 s2, v0, 2
; GCN-NEXT:    v_readlane_b32 s3, v0, 3
; GCN-NEXT:    v_readlane_b32 s4, v0, 4
; GCN-NEXT:    v_readlane_b32 s5, v0, 5
; GCN-NEXT:    v_readlane_b32 s6, v0, 6
; GCN-NEXT:    v_readlane_b32 s7, v0, 7
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 56
; GCN-NEXT:    v_readlane_b32 s1, v0, 57
; GCN-NEXT:    v_readlane_b32 s2, v0, 58
; GCN-NEXT:    v_readlane_b32 s3, v0, 59
; GCN-NEXT:    v_readlane_b32 s4, v0, 60
; GCN-NEXT:    v_readlane_b32 s5, v0, 61
; GCN-NEXT:    v_readlane_b32 s6, v0, 62
; GCN-NEXT:    v_readlane_b32 s7, v0, 63
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 0
; GCN-NEXT:    v_readlane_b32 s1, v1, 1
; GCN-NEXT:    v_readlane_b32 s2, v1, 2
; GCN-NEXT:    v_readlane_b32 s3, v1, 3
; GCN-NEXT:    v_readlane_b32 s4, v1, 4
; GCN-NEXT:    v_readlane_b32 s5, v1, 5
; GCN-NEXT:    v_readlane_b32 s6, v1, 6
; GCN-NEXT:    v_readlane_b32 s7, v1, 7
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 8
; GCN-NEXT:    v_readlane_b32 s1, v1, 9
; GCN-NEXT:    v_readlane_b32 s2, v1, 10
; GCN-NEXT:    v_readlane_b32 s3, v1, 11
; GCN-NEXT:    v_readlane_b32 s4, v1, 12
; GCN-NEXT:    v_readlane_b32 s5, v1, 13
; GCN-NEXT:    v_readlane_b32 s6, v1, 14
; GCN-NEXT:    v_readlane_b32 s7, v1, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 16
; GCN-NEXT:    v_readlane_b32 s1, v1, 17
; GCN-NEXT:    v_readlane_b32 s2, v1, 18
; GCN-NEXT:    v_readlane_b32 s3, v1, 19
; GCN-NEXT:    v_readlane_b32 s4, v1, 20
; GCN-NEXT:    v_readlane_b32 s5, v1, 21
; GCN-NEXT:    v_readlane_b32 s6, v1, 22
; GCN-NEXT:    v_readlane_b32 s7, v1, 23
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 24
; GCN-NEXT:    v_readlane_b32 s1, v1, 25
; GCN-NEXT:    v_readlane_b32 s2, v1, 26
; GCN-NEXT:    v_readlane_b32 s3, v1, 27
; GCN-NEXT:    v_readlane_b32 s4, v1, 28
; GCN-NEXT:    v_readlane_b32 s5, v1, 29
; GCN-NEXT:    v_readlane_b32 s6, v1, 30
; GCN-NEXT:    v_readlane_b32 s7, v1, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 32
; GCN-NEXT:    v_readlane_b32 s1, v1, 33
; GCN-NEXT:    v_readlane_b32 s2, v1, 34
; GCN-NEXT:    v_readlane_b32 s3, v1, 35
; GCN-NEXT:    v_readlane_b32 s4, v1, 36
; GCN-NEXT:    v_readlane_b32 s5, v1, 37
; GCN-NEXT:    v_readlane_b32 s6, v1, 38
; GCN-NEXT:    v_readlane_b32 s7, v1, 39
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 40
; GCN-NEXT:    v_readlane_b32 s1, v1, 41
; GCN-NEXT:    v_readlane_b32 s2, v1, 42
; GCN-NEXT:    v_readlane_b32 s3, v1, 43
; GCN-NEXT:    v_readlane_b32 s4, v1, 44
; GCN-NEXT:    v_readlane_b32 s5, v1, 45
; GCN-NEXT:    v_readlane_b32 s6, v1, 46
; GCN-NEXT:    v_readlane_b32 s7, v1, 47
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 48
; GCN-NEXT:    v_readlane_b32 s1, v1, 49
; GCN-NEXT:    v_readlane_b32 s2, v1, 50
; GCN-NEXT:    v_readlane_b32 s3, v1, 51
; GCN-NEXT:    v_readlane_b32 s4, v1, 52
; GCN-NEXT:    v_readlane_b32 s5, v1, 53
; GCN-NEXT:    v_readlane_b32 s6, v1, 54
; GCN-NEXT:    v_readlane_b32 s7, v1, 55
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v1, 56
; GCN-NEXT:    v_readlane_b32 s1, v1, 57
; GCN-NEXT:    v_readlane_b32 s2, v1, 58
; GCN-NEXT:    v_readlane_b32 s3, v1, 59
; GCN-NEXT:    v_readlane_b32 s4, v1, 60
; GCN-NEXT:    v_readlane_b32 s5, v1, 61
; GCN-NEXT:    v_readlane_b32 s6, v1, 62
; GCN-NEXT:    v_readlane_b32 s7, v1, 63
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 8
; GCN-NEXT:    v_readlane_b32 s1, v0, 9
; GCN-NEXT:    v_readlane_b32 s2, v0, 10
; GCN-NEXT:    v_readlane_b32 s3, v0, 11
; GCN-NEXT:    v_readlane_b32 s4, v0, 12
; GCN-NEXT:    v_readlane_b32 s5, v0, 13
; GCN-NEXT:    v_readlane_b32 s6, v0, 14
; GCN-NEXT:    v_readlane_b32 s7, v0, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 16
; GCN-NEXT:    v_readlane_b32 s1, v0, 17
; GCN-NEXT:    v_readlane_b32 s2, v0, 18
; GCN-NEXT:    v_readlane_b32 s3, v0, 19
; GCN-NEXT:    v_readlane_b32 s4, v0, 20
; GCN-NEXT:    v_readlane_b32 s5, v0, 21
; GCN-NEXT:    v_readlane_b32 s6, v0, 22
; GCN-NEXT:    v_readlane_b32 s7, v0, 23
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 24
; GCN-NEXT:    v_readlane_b32 s1, v0, 25
; GCN-NEXT:    v_readlane_b32 s2, v0, 26
; GCN-NEXT:    v_readlane_b32 s3, v0, 27
; GCN-NEXT:    v_readlane_b32 s4, v0, 28
; GCN-NEXT:    v_readlane_b32 s5, v0, 29
; GCN-NEXT:    v_readlane_b32 s6, v0, 30
; GCN-NEXT:    v_readlane_b32 s7, v0, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 32
; GCN-NEXT:    v_readlane_b32 s1, v0, 33
; GCN-NEXT:    v_readlane_b32 s2, v0, 34
; GCN-NEXT:    v_readlane_b32 s3, v0, 35
; GCN-NEXT:    v_readlane_b32 s4, v0, 36
; GCN-NEXT:    v_readlane_b32 s5, v0, 37
; GCN-NEXT:    v_readlane_b32 s6, v0, 38
; GCN-NEXT:    v_readlane_b32 s7, v0, 39
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 40
; GCN-NEXT:    v_readlane_b32 s1, v0, 41
; GCN-NEXT:    v_readlane_b32 s2, v0, 42
; GCN-NEXT:    v_readlane_b32 s3, v0, 43
; GCN-NEXT:    v_readlane_b32 s4, v0, 44
; GCN-NEXT:    v_readlane_b32 s5, v0, 45
; GCN-NEXT:    v_readlane_b32 s6, v0, 46
; GCN-NEXT:    v_readlane_b32 s7, v0, 47
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 48
; GCN-NEXT:    v_readlane_b32 s1, v0, 49
; GCN-NEXT:    v_readlane_b32 s2, v0, 50
; GCN-NEXT:    v_readlane_b32 s3, v0, 51
; GCN-NEXT:    v_readlane_b32 s4, v0, 52
; GCN-NEXT:    v_readlane_b32 s5, v0, 53
; GCN-NEXT:    v_readlane_b32 s6, v0, 54
; GCN-NEXT:    v_readlane_b32 s7, v0, 55
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v2, 0
; GCN-NEXT:    v_readlane_b32 s1, v2, 1
; GCN-NEXT:    v_readlane_b32 s2, v2, 2
; GCN-NEXT:    v_readlane_b32 s3, v2, 3
; GCN-NEXT:    v_readlane_b32 s4, v2, 4
; GCN-NEXT:    v_readlane_b32 s5, v2, 5
; GCN-NEXT:    v_readlane_b32 s6, v2, 6
; GCN-NEXT:    v_readlane_b32 s7, v2, 7
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:7]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:  BB0_2: ; %ret
; GCN-NEXT:    s_endpgm
  %wide.sgpr0 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr1 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr2 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr3 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr4 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr5 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr6 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr7 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr8 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr9 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr10 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr11 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr12 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr13 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr14 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr15 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr16 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %cmp = icmp eq i32 %in, 0
  br i1 %cmp, label %bb0, label %ret

bb0:
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr0) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr1) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr2) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr3) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr4) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr5) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr6) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr7) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr8) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr9) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr10) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr11) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr12) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr13) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr14) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr15) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr16) #0
  br label %ret

ret:
  ret void
}

; Some of the lanes of an SGPR spill are in one VGPR and some forced
; into the next available VGPR.
define amdgpu_kernel void @split_sgpr_spill_2_vgprs(i32 addrspace(1)* %out, i32 %in) #1 {
; GCN-LABEL: split_sgpr_spill_2_vgprs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[36:51]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 0
; GCN-NEXT:    v_writelane_b32 v0, s5, 1
; GCN-NEXT:    v_writelane_b32 v0, s6, 2
; GCN-NEXT:    v_writelane_b32 v0, s7, 3
; GCN-NEXT:    v_writelane_b32 v0, s8, 4
; GCN-NEXT:    v_writelane_b32 v0, s9, 5
; GCN-NEXT:    v_writelane_b32 v0, s10, 6
; GCN-NEXT:    v_writelane_b32 v0, s11, 7
; GCN-NEXT:    v_writelane_b32 v0, s12, 8
; GCN-NEXT:    v_writelane_b32 v0, s13, 9
; GCN-NEXT:    v_writelane_b32 v0, s14, 10
; GCN-NEXT:    v_writelane_b32 v0, s15, 11
; GCN-NEXT:    v_writelane_b32 v0, s16, 12
; GCN-NEXT:    v_writelane_b32 v0, s17, 13
; GCN-NEXT:    v_writelane_b32 v0, s18, 14
; GCN-NEXT:    v_writelane_b32 v0, s19, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v0, s4, 16
; GCN-NEXT:    v_writelane_b32 v0, s5, 17
; GCN-NEXT:    v_writelane_b32 v0, s6, 18
; GCN-NEXT:    v_writelane_b32 v0, s7, 19
; GCN-NEXT:    v_writelane_b32 v0, s8, 20
; GCN-NEXT:    v_writelane_b32 v0, s9, 21
; GCN-NEXT:    v_writelane_b32 v0, s10, 22
; GCN-NEXT:    v_writelane_b32 v0, s11, 23
; GCN-NEXT:    v_writelane_b32 v0, s12, 24
; GCN-NEXT:    v_writelane_b32 v0, s13, 25
; GCN-NEXT:    v_writelane_b32 v0, s14, 26
; GCN-NEXT:    v_writelane_b32 v0, s15, 27
; GCN-NEXT:    v_writelane_b32 v0, s16, 28
; GCN-NEXT:    v_writelane_b32 v0, s17, 29
; GCN-NEXT:    v_writelane_b32 v0, s18, 30
; GCN-NEXT:    v_writelane_b32 v0, s19, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[20:27]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[0:1]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_mov_b32 s3, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s2, s3
; GCN-NEXT:    v_writelane_b32 v0, s36, 32
; GCN-NEXT:    v_writelane_b32 v0, s37, 33
; GCN-NEXT:    v_writelane_b32 v0, s38, 34
; GCN-NEXT:    v_writelane_b32 v0, s39, 35
; GCN-NEXT:    v_writelane_b32 v0, s40, 36
; GCN-NEXT:    v_writelane_b32 v0, s41, 37
; GCN-NEXT:    v_writelane_b32 v0, s42, 38
; GCN-NEXT:    v_writelane_b32 v0, s43, 39
; GCN-NEXT:    v_writelane_b32 v0, s44, 40
; GCN-NEXT:    v_writelane_b32 v0, s45, 41
; GCN-NEXT:    v_writelane_b32 v0, s46, 42
; GCN-NEXT:    v_writelane_b32 v0, s47, 43
; GCN-NEXT:    v_writelane_b32 v0, s48, 44
; GCN-NEXT:    v_writelane_b32 v0, s49, 45
; GCN-NEXT:    v_writelane_b32 v0, s50, 46
; GCN-NEXT:    v_writelane_b32 v0, s51, 47
; GCN-NEXT:    v_writelane_b32 v0, s4, 48
; GCN-NEXT:    v_writelane_b32 v0, s5, 49
; GCN-NEXT:    v_writelane_b32 v0, s6, 50
; GCN-NEXT:    v_writelane_b32 v0, s7, 51
; GCN-NEXT:    v_writelane_b32 v0, s8, 52
; GCN-NEXT:    v_writelane_b32 v0, s9, 53
; GCN-NEXT:    v_writelane_b32 v0, s10, 54
; GCN-NEXT:    v_writelane_b32 v0, s11, 55
; GCN-NEXT:    v_writelane_b32 v0, s12, 56
; GCN-NEXT:    v_writelane_b32 v0, s13, 57
; GCN-NEXT:    v_writelane_b32 v0, s14, 58
; GCN-NEXT:    v_writelane_b32 v0, s15, 59
; GCN-NEXT:    v_writelane_b32 v0, s16, 60
; GCN-NEXT:    v_writelane_b32 v0, s17, 61
; GCN-NEXT:    v_writelane_b32 v0, s18, 62
; GCN-NEXT:    v_writelane_b32 v0, s19, 63
; GCN-NEXT:    v_writelane_b32 v1, s20, 0
; GCN-NEXT:    v_writelane_b32 v1, s21, 1
; GCN-NEXT:    v_writelane_b32 v1, s22, 2
; GCN-NEXT:    v_writelane_b32 v1, s23, 3
; GCN-NEXT:    v_writelane_b32 v1, s24, 4
; GCN-NEXT:    v_writelane_b32 v1, s25, 5
; GCN-NEXT:    v_writelane_b32 v1, s26, 6
; GCN-NEXT:    v_writelane_b32 v1, s27, 7
; GCN-NEXT:    v_writelane_b32 v1, s0, 8
; GCN-NEXT:    v_writelane_b32 v1, s1, 9
; GCN-NEXT:    s_cbranch_scc1 BB1_2
; GCN-NEXT:  ; %bb.1: ; %bb0
; GCN-NEXT:    v_readlane_b32 s0, v0, 0
; GCN-NEXT:    v_readlane_b32 s1, v0, 1
; GCN-NEXT:    v_readlane_b32 s2, v0, 2
; GCN-NEXT:    v_readlane_b32 s3, v0, 3
; GCN-NEXT:    v_readlane_b32 s4, v0, 4
; GCN-NEXT:    v_readlane_b32 s5, v0, 5
; GCN-NEXT:    v_readlane_b32 s6, v0, 6
; GCN-NEXT:    v_readlane_b32 s7, v0, 7
; GCN-NEXT:    v_readlane_b32 s8, v0, 8
; GCN-NEXT:    v_readlane_b32 s9, v0, 9
; GCN-NEXT:    v_readlane_b32 s10, v0, 10
; GCN-NEXT:    v_readlane_b32 s11, v0, 11
; GCN-NEXT:    v_readlane_b32 s12, v0, 12
; GCN-NEXT:    v_readlane_b32 s13, v0, 13
; GCN-NEXT:    v_readlane_b32 s14, v0, 14
; GCN-NEXT:    v_readlane_b32 s15, v0, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 32
; GCN-NEXT:    v_readlane_b32 s1, v0, 33
; GCN-NEXT:    v_readlane_b32 s2, v0, 34
; GCN-NEXT:    v_readlane_b32 s3, v0, 35
; GCN-NEXT:    v_readlane_b32 s4, v0, 36
; GCN-NEXT:    v_readlane_b32 s5, v0, 37
; GCN-NEXT:    v_readlane_b32 s6, v0, 38
; GCN-NEXT:    v_readlane_b32 s7, v0, 39
; GCN-NEXT:    v_readlane_b32 s8, v0, 40
; GCN-NEXT:    v_readlane_b32 s9, v0, 41
; GCN-NEXT:    v_readlane_b32 s10, v0, 42
; GCN-NEXT:    v_readlane_b32 s11, v0, 43
; GCN-NEXT:    v_readlane_b32 s12, v0, 44
; GCN-NEXT:    v_readlane_b32 s13, v0, 45
; GCN-NEXT:    v_readlane_b32 s14, v0, 46
; GCN-NEXT:    v_readlane_b32 s15, v0, 47
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 16
; GCN-NEXT:    v_readlane_b32 s1, v0, 17
; GCN-NEXT:    v_readlane_b32 s2, v0, 18
; GCN-NEXT:    v_readlane_b32 s3, v0, 19
; GCN-NEXT:    v_readlane_b32 s4, v0, 20
; GCN-NEXT:    v_readlane_b32 s5, v0, 21
; GCN-NEXT:    v_readlane_b32 s6, v0, 22
; GCN-NEXT:    v_readlane_b32 s7, v0, 23
; GCN-NEXT:    v_readlane_b32 s8, v0, 24
; GCN-NEXT:    v_readlane_b32 s9, v0, 25
; GCN-NEXT:    v_readlane_b32 s10, v0, 26
; GCN-NEXT:    v_readlane_b32 s11, v0, 27
; GCN-NEXT:    v_readlane_b32 s12, v0, 28
; GCN-NEXT:    v_readlane_b32 s13, v0, 29
; GCN-NEXT:    v_readlane_b32 s14, v0, 30
; GCN-NEXT:    v_readlane_b32 s15, v0, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s16, v1, 0
; GCN-NEXT:    v_readlane_b32 s17, v1, 1
; GCN-NEXT:    v_readlane_b32 s18, v1, 2
; GCN-NEXT:    v_readlane_b32 s19, v1, 3
; GCN-NEXT:    v_readlane_b32 s20, v1, 4
; GCN-NEXT:    v_readlane_b32 s21, v1, 5
; GCN-NEXT:    v_readlane_b32 s22, v1, 6
; GCN-NEXT:    v_readlane_b32 s23, v1, 7
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[16:23]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s24, v1, 8
; GCN-NEXT:    v_readlane_b32 s25, v1, 9
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[24:25]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v0, 48
; GCN-NEXT:    v_readlane_b32 s1, v0, 49
; GCN-NEXT:    v_readlane_b32 s2, v0, 50
; GCN-NEXT:    v_readlane_b32 s3, v0, 51
; GCN-NEXT:    v_readlane_b32 s4, v0, 52
; GCN-NEXT:    v_readlane_b32 s5, v0, 53
; GCN-NEXT:    v_readlane_b32 s6, v0, 54
; GCN-NEXT:    v_readlane_b32 s7, v0, 55
; GCN-NEXT:    v_readlane_b32 s8, v0, 56
; GCN-NEXT:    v_readlane_b32 s9, v0, 57
; GCN-NEXT:    v_readlane_b32 s10, v0, 58
; GCN-NEXT:    v_readlane_b32 s11, v0, 59
; GCN-NEXT:    v_readlane_b32 s12, v0, 60
; GCN-NEXT:    v_readlane_b32 s13, v0, 61
; GCN-NEXT:    v_readlane_b32 s14, v0, 62
; GCN-NEXT:    v_readlane_b32 s15, v0, 63
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:  BB1_2: ; %ret
; GCN-NEXT:    s_endpgm
  %wide.sgpr0 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr1 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr2 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr5 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr3 = call <8 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr4 = call <2 x i32> asm sideeffect "; def $0", "=s" () #0

  %cmp = icmp eq i32 %in, 0
  br i1 %cmp, label %bb0, label %ret

bb0:
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr0) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr1) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr2) #0
  call void asm sideeffect "; use $0", "s"(<8 x i32> %wide.sgpr3) #0
  call void asm sideeffect "; use $0", "s"(<2 x i32> %wide.sgpr4) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr5) #0
  br label %ret

ret:
  ret void
}

; The first 64 SGPR spills can go to a VGPR, but there isn't a second
; so some spills must be to memory. The last 16 element spill runs out
; of lanes at the 15th element.
define amdgpu_kernel void @no_vgprs_last_sgpr_spill(i32 addrspace(1)* %out, i32 %in) #1 {
; GCN-LABEL: no_vgprs_last_sgpr_spill:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s20, SCRATCH_RSRC_DWORD0
; GCN-NEXT:    s_mov_b32 s21, SCRATCH_RSRC_DWORD1
; GCN-NEXT:    s_mov_b32 s22, -1
; GCN-NEXT:    s_mov_b32 s23, 0xe8f000
; GCN-NEXT:    s_add_u32 s20, s20, s3
; GCN-NEXT:    s_addc_u32 s21, s21, 0
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xb
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[36:51]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v31, s4, 0
; GCN-NEXT:    v_writelane_b32 v31, s5, 1
; GCN-NEXT:    v_writelane_b32 v31, s6, 2
; GCN-NEXT:    v_writelane_b32 v31, s7, 3
; GCN-NEXT:    v_writelane_b32 v31, s8, 4
; GCN-NEXT:    v_writelane_b32 v31, s9, 5
; GCN-NEXT:    v_writelane_b32 v31, s10, 6
; GCN-NEXT:    v_writelane_b32 v31, s11, 7
; GCN-NEXT:    v_writelane_b32 v31, s12, 8
; GCN-NEXT:    v_writelane_b32 v31, s13, 9
; GCN-NEXT:    v_writelane_b32 v31, s14, 10
; GCN-NEXT:    v_writelane_b32 v31, s15, 11
; GCN-NEXT:    v_writelane_b32 v31, s16, 12
; GCN-NEXT:    v_writelane_b32 v31, s17, 13
; GCN-NEXT:    v_writelane_b32 v31, s18, 14
; GCN-NEXT:    v_writelane_b32 v31, s19, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_writelane_b32 v31, s4, 16
; GCN-NEXT:    v_writelane_b32 v31, s5, 17
; GCN-NEXT:    v_writelane_b32 v31, s6, 18
; GCN-NEXT:    v_writelane_b32 v31, s7, 19
; GCN-NEXT:    v_writelane_b32 v31, s8, 20
; GCN-NEXT:    v_writelane_b32 v31, s9, 21
; GCN-NEXT:    v_writelane_b32 v31, s10, 22
; GCN-NEXT:    v_writelane_b32 v31, s11, 23
; GCN-NEXT:    v_writelane_b32 v31, s12, 24
; GCN-NEXT:    v_writelane_b32 v31, s13, 25
; GCN-NEXT:    v_writelane_b32 v31, s14, 26
; GCN-NEXT:    v_writelane_b32 v31, s15, 27
; GCN-NEXT:    v_writelane_b32 v31, s16, 28
; GCN-NEXT:    v_writelane_b32 v31, s17, 29
; GCN-NEXT:    v_writelane_b32 v31, s18, 30
; GCN-NEXT:    v_writelane_b32 v31, s19, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[4:19]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; def s[0:1]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_mov_b32 s3, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s2, s3
; GCN-NEXT:    v_writelane_b32 v31, s36, 32
; GCN-NEXT:    v_writelane_b32 v31, s37, 33
; GCN-NEXT:    v_writelane_b32 v31, s38, 34
; GCN-NEXT:    v_writelane_b32 v31, s39, 35
; GCN-NEXT:    v_writelane_b32 v31, s40, 36
; GCN-NEXT:    v_writelane_b32 v31, s41, 37
; GCN-NEXT:    v_writelane_b32 v31, s42, 38
; GCN-NEXT:    v_writelane_b32 v31, s43, 39
; GCN-NEXT:    v_writelane_b32 v31, s44, 40
; GCN-NEXT:    v_writelane_b32 v31, s45, 41
; GCN-NEXT:    v_writelane_b32 v31, s46, 42
; GCN-NEXT:    v_writelane_b32 v31, s47, 43
; GCN-NEXT:    v_writelane_b32 v31, s48, 44
; GCN-NEXT:    v_writelane_b32 v31, s49, 45
; GCN-NEXT:    v_writelane_b32 v31, s50, 46
; GCN-NEXT:    v_writelane_b32 v31, s51, 47
; GCN-NEXT:    v_writelane_b32 v31, s4, 48
; GCN-NEXT:    v_writelane_b32 v31, s5, 49
; GCN-NEXT:    v_writelane_b32 v31, s6, 50
; GCN-NEXT:    v_writelane_b32 v31, s7, 51
; GCN-NEXT:    v_writelane_b32 v31, s8, 52
; GCN-NEXT:    v_writelane_b32 v31, s9, 53
; GCN-NEXT:    v_writelane_b32 v31, s10, 54
; GCN-NEXT:    v_writelane_b32 v31, s11, 55
; GCN-NEXT:    v_writelane_b32 v31, s12, 56
; GCN-NEXT:    v_writelane_b32 v31, s13, 57
; GCN-NEXT:    v_writelane_b32 v31, s14, 58
; GCN-NEXT:    v_writelane_b32 v31, s15, 59
; GCN-NEXT:    v_writelane_b32 v31, s16, 60
; GCN-NEXT:    v_writelane_b32 v31, s17, 61
; GCN-NEXT:    v_writelane_b32 v31, s18, 62
; GCN-NEXT:    v_writelane_b32 v31, s19, 63
; GCN-NEXT:    buffer_store_dword v0, off, s[20:23], 0
; GCN-NEXT:    v_writelane_b32 v0, s0, 0
; GCN-NEXT:    v_writelane_b32 v0, s1, 1
; GCN-NEXT:    s_mov_b64 s[0:1], exec
; GCN-NEXT:    s_mov_b64 exec, 3
; GCN-NEXT:    buffer_store_dword v0, off, s[20:23], 0 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    s_mov_b64 exec, s[0:1]
; GCN-NEXT:    buffer_load_dword v0, off, s[20:23], 0
; GCN-NEXT:    s_cbranch_scc1 BB2_2
; GCN-NEXT:  ; %bb.1: ; %bb0
; GCN-NEXT:    v_readlane_b32 s0, v31, 0
; GCN-NEXT:    v_readlane_b32 s1, v31, 1
; GCN-NEXT:    v_readlane_b32 s2, v31, 2
; GCN-NEXT:    v_readlane_b32 s3, v31, 3
; GCN-NEXT:    v_readlane_b32 s4, v31, 4
; GCN-NEXT:    v_readlane_b32 s5, v31, 5
; GCN-NEXT:    v_readlane_b32 s6, v31, 6
; GCN-NEXT:    v_readlane_b32 s7, v31, 7
; GCN-NEXT:    v_readlane_b32 s8, v31, 8
; GCN-NEXT:    v_readlane_b32 s9, v31, 9
; GCN-NEXT:    v_readlane_b32 s10, v31, 10
; GCN-NEXT:    v_readlane_b32 s11, v31, 11
; GCN-NEXT:    v_readlane_b32 s12, v31, 12
; GCN-NEXT:    v_readlane_b32 s13, v31, 13
; GCN-NEXT:    v_readlane_b32 s14, v31, 14
; GCN-NEXT:    v_readlane_b32 s15, v31, 15
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v31, 32
; GCN-NEXT:    v_readlane_b32 s1, v31, 33
; GCN-NEXT:    v_readlane_b32 s2, v31, 34
; GCN-NEXT:    v_readlane_b32 s3, v31, 35
; GCN-NEXT:    v_readlane_b32 s4, v31, 36
; GCN-NEXT:    v_readlane_b32 s5, v31, 37
; GCN-NEXT:    v_readlane_b32 s6, v31, 38
; GCN-NEXT:    v_readlane_b32 s7, v31, 39
; GCN-NEXT:    v_readlane_b32 s8, v31, 40
; GCN-NEXT:    v_readlane_b32 s9, v31, 41
; GCN-NEXT:    v_readlane_b32 s10, v31, 42
; GCN-NEXT:    v_readlane_b32 s11, v31, 43
; GCN-NEXT:    v_readlane_b32 s12, v31, 44
; GCN-NEXT:    v_readlane_b32 s13, v31, 45
; GCN-NEXT:    v_readlane_b32 s14, v31, 46
; GCN-NEXT:    v_readlane_b32 s15, v31, 47
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v31, 16
; GCN-NEXT:    v_readlane_b32 s1, v31, 17
; GCN-NEXT:    v_readlane_b32 s2, v31, 18
; GCN-NEXT:    v_readlane_b32 s3, v31, 19
; GCN-NEXT:    v_readlane_b32 s4, v31, 20
; GCN-NEXT:    v_readlane_b32 s5, v31, 21
; GCN-NEXT:    v_readlane_b32 s6, v31, 22
; GCN-NEXT:    v_readlane_b32 s7, v31, 23
; GCN-NEXT:    v_readlane_b32 s8, v31, 24
; GCN-NEXT:    v_readlane_b32 s9, v31, 25
; GCN-NEXT:    v_readlane_b32 s10, v31, 26
; GCN-NEXT:    v_readlane_b32 s11, v31, 27
; GCN-NEXT:    v_readlane_b32 s12, v31, 28
; GCN-NEXT:    v_readlane_b32 s13, v31, 29
; GCN-NEXT:    v_readlane_b32 s14, v31, 30
; GCN-NEXT:    v_readlane_b32 s15, v31, 31
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    v_readlane_b32 s0, v31, 48
; GCN-NEXT:    v_readlane_b32 s1, v31, 49
; GCN-NEXT:    v_readlane_b32 s2, v31, 50
; GCN-NEXT:    v_readlane_b32 s3, v31, 51
; GCN-NEXT:    v_readlane_b32 s4, v31, 52
; GCN-NEXT:    v_readlane_b32 s5, v31, 53
; GCN-NEXT:    v_readlane_b32 s6, v31, 54
; GCN-NEXT:    v_readlane_b32 s7, v31, 55
; GCN-NEXT:    v_readlane_b32 s8, v31, 56
; GCN-NEXT:    v_readlane_b32 s9, v31, 57
; GCN-NEXT:    v_readlane_b32 s10, v31, 58
; GCN-NEXT:    v_readlane_b32 s11, v31, 59
; GCN-NEXT:    v_readlane_b32 s12, v31, 60
; GCN-NEXT:    v_readlane_b32 s13, v31, 61
; GCN-NEXT:    v_readlane_b32 s14, v31, 62
; GCN-NEXT:    v_readlane_b32 s15, v31, 63
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[0:15]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    s_mov_b64 s[16:17], exec
; GCN-NEXT:    s_mov_b64 exec, 3
; GCN-NEXT:    buffer_load_dword v0, off, s[20:23], 0 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b64 exec, s[16:17]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_readlane_b32 s16, v0, 0
; GCN-NEXT:    v_readlane_b32 s17, v0, 1
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ; use s[16:17]
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:  BB2_2: ; %ret
; GCN-NEXT:    s_endpgm
  call void asm sideeffect "", "~{v[0:7]}" () #0
  call void asm sideeffect "", "~{v[8:15]}" () #0
  call void asm sideeffect "", "~{v[16:23]}" () #0
  call void asm sideeffect "", "~{v[24:27]}"() #0
  call void asm sideeffect "", "~{v[28:29]}"() #0
  call void asm sideeffect "", "~{v30}"() #0

  %wide.sgpr0 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr1 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr2 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr3 = call <16 x i32> asm sideeffect "; def $0", "=s" () #0
  %wide.sgpr4 = call <2 x i32> asm sideeffect "; def $0", "=s" () #0
  %cmp = icmp eq i32 %in, 0
  br i1 %cmp, label %bb0, label %ret

bb0:
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr0) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr1) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr2) #0
  call void asm sideeffect "; use $0", "s"(<16 x i32> %wide.sgpr3) #0
  call void asm sideeffect "; use $0", "s"(<2 x i32> %wide.sgpr4) #0
  br label %ret

ret:
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind "amdgpu-waves-per-eu"="8,8" }
