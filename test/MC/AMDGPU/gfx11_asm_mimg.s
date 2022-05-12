; RUN: llvm-mc -arch=amdgcn -mcpu=gfx1100 -show-encoding %s | FileCheck --check-prefixes=GFX11 %s

image_load v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm
; GFX11: image_load v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm ; encoding: [0x80,0x0f,0x00,0xf0,0x00,0x00,0x00,0x00]

image_load v[1:4], [v2, v3], s[4:11] dmask:0xf dim:SQ_RSRC_IMG_2D unorm
; GFX11: image_load v[1:4], [v2, v3], s[4:11] dmask:0xf dim:SQ_RSRC_IMG_2D unorm ; encoding: [0x85,0x0f,0x00,0xf0,0x02,0x01,0x01,0x00,0x03,0x00,0x00,0x00]

image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_3D unorm
; GFX11: image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_3D unorm ; encoding: [0x89,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x06,0x00,0x00]

image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_CUBE unorm
; GFX11: image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_CUBE unorm ; encoding: [0x8d,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x06,0x00,0x00]

image_load v[0:3], [v4, v5], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_1D_ARRAY unorm
; GFX11: image_load v[0:3], [v4, v5], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_1D_ARRAY unorm ; encoding: [0x91,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x00,0x00,0x00]

image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_ARRAY unorm
; GFX11: image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_ARRAY unorm ; encoding: [0x95,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x06,0x00,0x00]

image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA unorm
; GFX11: image_load v[0:3], [v4, v5, v6], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA unorm ; encoding: [0x99,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x06,0x00,0x00]

image_load v[0:3], [v4, v5, v6, v7], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm
; GFX11: image_load v[0:3], [v4, v5, v6, v7], s[8:15] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm ; encoding: [0x9d,0x0f,0x00,0xf0,0x04,0x00,0x02,0x00,0x05,0x06,0x07,0x00]

image_load v[0:1], v0, s[0:7] dmask:0x9 dim:1D
; GFX11: image_load v[0:1], v0, s[0:7] dmask:0x9 dim:SQ_RSRC_IMG_1D ; encoding: [0x00,0x09,0x00,0xf0,0x00,0x00,0x00,0x00]

image_load v0, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D dlc
; GFX11: image_load v0, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D dlc ; encoding: [0x00,0x21,0x00,0xf0,0x00,0x00,0x00,0x00]

image_load v255, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_load v255, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x00,0xf0,0x00,0xff,0x00,0x00]

image_load v0, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D slc
; GFX11: image_load v0, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D slc ; encoding: [0x00,0x11,0x00,0xf0,0x00,0x00,0x00,0x00]

image_load v0, v255, s[0:7] dmask:0x6 dim:SQ_RSRC_IMG_1D d16
; GFX11: image_load v0, v255, s[0:7] dmask:0x6 dim:SQ_RSRC_IMG_1D d16 ; encoding: [0x00,0x06,0x02,0xf0,0xff,0x00,0x00,0x00]

// FIXME: This test is incorrect because r128 assumes a 128-bit SRSRC.
image_load v0, v255, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D r128
; GFX11: image_load v0, v255, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D r128 ; encoding: [0x00,0x81,0x00,0xf0,0xff,0x00,0x00,0x00]

image_load v0, v[2:3], s[0:7] dmask:0x1 dim:2D
; GFX11: image_load v0, v[2:3], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D ; encoding: [0x04,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:4], s[0:7] dmask:0x1 dim:3D
; GFX11: image_load v0, v[2:4], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x08,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:4], s[0:7] dmask:0x1 dim:CUBE
; GFX11: image_load v0, v[2:4], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0c,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:3], s[0:7] dmask:0x1 dim:1D_ARRAY
; GFX11: image_load v0, v[2:3], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x10,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:4], s[0:7] dmask:0x1 dim:2D_ARRAY
; GFX11: image_load v0, v[2:4], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY ; encoding: [0x14,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:4], s[0:7] dmask:0x1 dim:2D_MSAA
; GFX11: image_load v0, v[2:4], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA ; encoding: [0x18,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load v0, v[2:5], s[0:7] dmask:0x1 dim:2D_MSAA_ARRAY
; GFX11: image_load v0, v[2:5], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY ; encoding: [0x1c,0x01,0x00,0xf0,0x02,0x00,0x00,0x00]

image_load_mip v[252:255], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX11: image_load_mip v[252:255], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D ; encoding: [0x00,0x0f,0x04,0xf0,0x00,0xfc,0x00,0x00]

image_load_mip v[253:255], [v255, v254], s[0:7] dmask:0xe dim:SQ_RSRC_IMG_1D
; GFX11: image_load_mip v[253:255], [v255, v254], s[0:7] dmask:0xe dim:SQ_RSRC_IMG_1D ; encoding: [0x01,0x0e,0x04,0xf0,0xff,0xfd,0x00,0x00,0xfe,0x00,0x00,0x00]

image_load_mip v[254:255], [v254, v255, v253], s[0:7] dmask:0xc dim:SQ_RSRC_IMG_2D
; GFX11: image_load_mip v[254:255], [v254, v255, v253], s[0:7] dmask:0xc dim:SQ_RSRC_IMG_2D ; encoding: [0x05,0x0c,0x04,0xf0,0xfe,0xfe,0x00,0x00,0xff,0xfd,0x00,0x00]

image_load_mip v255, [v254, v255, v253, v252], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_3D
; GFX11: image_load_mip v255, [v254, v255, v253, v252], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x08,0x04,0xf0,0xfe,0xff,0x00,0x00,0xff,0xfd,0xfc,0x00]

image_load_mip v255, [v254, v255, v253, v252], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_CUBE
; GFX11: image_load_mip v255, [v254, v255, v253, v252], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0d,0x08,0x04,0xf0,0xfe,0xff,0x00,0x00,0xff,0xfd,0xfc,0x00]

image_load_mip v255, [v254, v255, v253], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_load_mip v255, [v254, v255, v253], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x08,0x04,0xf0,0xfe,0xff,0x00,0x00,0xff,0xfd,0x00,0x00]

image_load_mip v255, [v254, v255, v253, v255], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX11: image_load_mip v255, [v254, v255, v253, v255], s[0:7] dmask:0x8 dim:SQ_RSRC_IMG_2D_ARRAY ; encoding: [0x15,0x08,0x04,0xf0,0xfe,0xff,0x00,0x00,0xff,0xfd,0xff,0x00]

image_store v[0:3], [v254, v255, v253, v255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY
; GFX11: image_store v[0:3], [v254, v255, v253, v255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY ; encoding: [0x1d,0x0f,0x18,0xf0,0xfe,0x00,0x18,0x00,0xff,0xfd,0xff,0x00]

image_store v[0:3], v[254:255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX11: image_store v[0:3], v[254:255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D ; encoding: [0x04,0x0f,0x18,0xf0,0xfe,0x00,0x18,0x00]

image_store_mip v[0:3], v[253:255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX11: image_store_mip v[0:3], v[253:255], s[96:103] dmask:0xf dim:SQ_RSRC_IMG_2D ; encoding: [0x04,0x0f,0x1c,0xf0,0xfd,0x00,0x18,0x00]

image_get_resinfo v[4:7], v32, s[96:103] dmask:0xf dim:SQ_RSRC_IMG_3D
; GFX11: image_get_resinfo v[4:7], v32, s[96:103] dmask:0xf dim:SQ_RSRC_IMG_3D ; encoding: [0x08,0x0f,0x5c,0xf0,0x20,0x04,0x18,0x00]

image_atomic_swap v4, v[32:34], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_3D glc
; GFX11: image_atomic_swap v4, v[32:34], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_3D glc ; encoding: [0x08,0x41,0x28,0xf0,0x20,0x04,0x18,0x00]

image_atomic_cmpswap v[4:5], [v32, v1, v2], s[96:103] dmask:0x3 dim:SQ_RSRC_IMG_3D glc
; GFX11: image_atomic_cmpswap v[4:5], [v32, v1, v2], s[96:103] dmask:0x3 dim:SQ_RSRC_IMG_3D glc ; encoding: [0x09,0x43,0x2c,0xf0,0x20,0x04,0x18,0x00,0x01,0x02,0x00,0x00]

image_atomic_add v[4:5], [v32, v1, v2], s[96:103] dmask:0x3 dim:SQ_RSRC_IMG_CUBE glc
; GFX11: image_atomic_add v[4:5], [v32, v1, v2], s[96:103] dmask:0x3 dim:SQ_RSRC_IMG_CUBE glc ; encoding: [0x0d,0x43,0x30,0xf0,0x20,0x04,0x18,0x00,0x01,0x02,0x00,0x00]

image_atomic_sub v4, [v32, v1], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D_ARRAY glc
; GFX11: image_atomic_sub v4, [v32, v1], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D_ARRAY glc ; encoding: [0x11,0x41,0x34,0xf0,0x20,0x04,0x18,0x00,0x01,0x00,0x00,0x00]

image_atomic_smin v4, [v32, v1, v2], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY glc
; GFX11: image_atomic_smin v4, [v32, v1, v2], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY glc ; encoding: [0x15,0x41,0x38,0xf0,0x20,0x04,0x18,0x00,0x01,0x02,0x00,0x00]

image_atomic_umin v4, [v32, v1, v2], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA glc
; GFX11: image_atomic_umin v4, [v32, v1, v2], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA glc ; encoding: [0x19,0x41,0x3c,0xf0,0x20,0x04,0x18,0x00,0x01,0x02,0x00,0x00]

image_atomic_smax v4, [v32, v1, v2, v3], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY glc
; GFX11: image_atomic_smax v4, [v32, v1, v2, v3], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY glc ; encoding: [0x1d,0x41,0x40,0xf0,0x20,0x04,0x18,0x00,0x01,0x02,0x03,0x00]

image_atomic_umax v4, [v32, v1], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D glc
; GFX11: image_atomic_umax v4, [v32, v1], s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_2D glc ; encoding: [0x05,0x41,0x44,0xf0,0x20,0x04,0x18,0x00,0x01,0x00,0x00,0x00]

image_atomic_and v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_atomic_and v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x48,0xf0,0x20,0x04,0x18,0x00]

image_atomic_or v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_atomic_or v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x4c,0xf0,0x20,0x04,0x18,0x00]

image_atomic_xor v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_atomic_xor v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x50,0xf0,0x20,0x04,0x18,0x00]

image_atomic_inc v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_atomic_inc v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x54,0xf0,0x20,0x04,0x18,0x00]

image_atomic_dec v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc
; GFX11: image_atomic_dec v4, v32, s[96:103] dmask:0x1 dim:SQ_RSRC_IMG_1D glc ; encoding: [0x00,0x41,0x58,0xf0,0x20,0x04,0x18,0x00]

image_sample v[64:66], v32, s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D
; GFX11: image_sample v[64:66], v32, s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D ; encoding: [0x00,0x07,0x6c,0xf0,0x20,0x40,0x01,0x64]

image_sample_cl v[64:66], [v32, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D
; GFX11: image_sample_cl v[64:66], [v32, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D ; encoding: [0x01,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x00,0x00,0x00]

image_sample_cl v[64:66], [v32, v16, v15], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D
; GFX11: image_sample_cl v[64:66], [v32, v16, v15], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D ; encoding: [0x05,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x0f,0x00,0x00]

image_sample_cl v[64:66], [v32, v16, v15, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_cl v[64:66], [v32, v16, v15, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x0f,0x14,0x00]

image_sample_cl v[64:66], [v32, v16, v15, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE
; GFX11: image_sample_cl v[64:66], [v32, v16, v15, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0d,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x0f,0x14,0x00]

image_sample_cl v[64:66], [v32, v16, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_cl v[64:66], [v32, v16, v20], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x14,0x00,0x00]

image_sample_cl v[64:66], [v32, v16, v20, v21], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX11: image_sample_cl v[64:66], [v32, v16, v20, v21], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D_ARRAY ; encoding: [0x15,0x07,0x00,0xf1,0x20,0x40,0x01,0x64,0x10,0x14,0x15,0x00]

image_sample_d v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D
; GFX11: image_sample_d v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D ; encoding: [0x01,0x07,0x70,0xf0,0x20,0x40,0x01,0x64,0x10,0x08,0x00,0x00]

image_sample_d v[64:66], v[32:39], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D
; GFX11: image_sample_d v[64:66], v[32:39], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_2D ; encoding: [0x04,0x07,0x70,0xf0,0x20,0x40,0x01,0x64]

image_sample_d v[64:66], v[32:47], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_d v[64:66], v[32:47], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x08,0x07,0x70,0xf0,0x20,0x40,0x01,0x64]

image_sample_d v[64:66], [v32, v16, v8, v4], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_d v[64:66], [v32, v16, v8, v4], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x70,0xf0,0x20,0x40,0x01,0x64,0x10,0x08,0x04,0x00]

image_sample_l v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_l v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x74,0xf0,0x20,0x40,0x01,0x64,0x10,0x08,0x00,0x00]

image_sample_b v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_b v[64:66], [v32, v16, v8], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x78,0xf0,0x20,0x40,0x01,0x64,0x10,0x08,0x00,0x00]

image_sample_b_cl v[64:66], [v32, v16, v8, v4], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_b_cl v[64:66], [v32, v16, v8, v4], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x08,0xf1,0x20,0x40,0x01,0x64,0x10,0x08,0x04,0x00]

image_sample_lz v[64:66], [v32, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_sample_lz v[64:66], [v32, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x07,0x7c,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x00,0x00]

image_sample_c v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE
; GFX11: image_sample_c v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0d,0x07,0x80,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x00]

image_sample_c_cl v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE
; GFX11: image_sample_c_cl v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0d,0x07,0x0c,0xf1,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_c_l v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_c_l v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x88,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_c_b v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_c_b v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x8c,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_c_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_c_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0xa8,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_c_lz v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_c_lz v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x90,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x00]

image_sample_o v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_o v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x94,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x00]

image_sample_cl_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_cl_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x18,0xf1,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_b_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_b_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0xa0,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_l_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_l_o v[64:66], [v32, v16, v0, v2, v1], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0x9c,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x01]

image_sample_lz_o v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D
; GFX11: image_sample_lz_o v[64:66], [v32, v16, v0, v2], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x07,0xa4,0xf0,0x20,0x40,0x01,0x64,0x10,0x00,0x02,0x00]

image_sample_c_lz_o v[64:66], [v32, v0, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D
; GFX11: image_sample_c_lz_o v[64:66], [v32, v0, v16], s[4:11], s[100:103] dmask:0x7 dim:SQ_RSRC_IMG_1D ; encoding: [0x01,0x07,0xb8,0xf0,0x20,0x40,0x01,0x64,0x00,0x10,0x00,0x00]

image_gather4 v[64:67], v32, s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_1D
; GFX11: image_gather4 v[64:67], v32, s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_1D ; encoding: [0x00,0x01,0xbc,0xf0,0x20,0x40,0x01,0x64]

image_gather4_cl v[64:67], v[32:35], s[4:11], s[100:103] dmask:0x2 dim:SQ_RSRC_IMG_CUBE
; GFX11: image_gather4_cl v[64:67], v[32:35], s[4:11], s[100:103] dmask:0x2 dim:SQ_RSRC_IMG_CUBE ; encoding: [0x0c,0x02,0x80,0xf1,0x20,0x40,0x01,0x64]

image_gather4_l v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x4 dim:SQ_RSRC_IMG_1D_ARRAY
; GFX11: image_gather4_l v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x4 dim:SQ_RSRC_IMG_1D_ARRAY ; encoding: [0x11,0x04,0xc0,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x00,0x00]

image_gather4_b v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x8 dim:SQ_RSRC_IMG_2D
; GFX11: image_gather4_b v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x8 dim:SQ_RSRC_IMG_2D ; encoding: [0x05,0x08,0xc4,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x00,0x00]

image_gather4_b_cl v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX11: image_gather4_b_cl v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY ; encoding: [0x15,0x01,0x84,0xf1,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x06]

image_gather4_lz v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_lz v[64:67], [v32, v0, v4], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xc8,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x00,0x00]

image_gather4_c v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xcc,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x00]

image_gather4_c_cl v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c_cl v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0x88,0xf1,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x06]

image_gather4_c_l v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c_l v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0x8c,0xf1,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x06]

image_gather4_c_b v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c_b v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0x90,0xf1,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x06]

image_gather4_c_lz v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c_lz v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xd0,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x00]

image_gather4_o v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_o v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xd4,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x00]

image_gather4_lz_o v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_lz_o v[64:67], [v32, v0, v4, v5], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xd8,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x00]

image_gather4_c_lz_o v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D
; GFX11: image_gather4_c_lz_o v[64:67], [v32, v0, v4, v5, v6], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_3D ; encoding: [0x09,0x01,0xdc,0xf0,0x20,0x40,0x01,0x64,0x00,0x04,0x05,0x06]

image_get_lod v64, v[32:33], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX11: image_get_lod v64, v[32:33], s[4:11], s[100:103] dmask:0x1 dim:SQ_RSRC_IMG_2D ; encoding: [0x04,0x01,0xe0,0xf0,0x20,0x40,0x01,0x64]

image_get_lod v[64:65], [v32, v0, v16], s[4:11], s[100:103] dmask:0x3 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX11: image_get_lod v[64:65], [v32, v0, v16], s[4:11], s[100:103] dmask:0x3 dim:SQ_RSRC_IMG_2D_ARRAY ; encoding: [0x15,0x03,0xe0,0xf0,0x20,0x40,0x01,0x64,0x00,0x10,0x00,0x00]

image_msaa_load v[1:4], v[5:7], s[8:15] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA
; GFX11: image_msaa_load v[1:4], v[5:7], s[8:15] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA ; encoding: [0x18,0x01,0x60,0xf0,0x05,0x01,0x02,0x00]

image_msaa_load v[1:4], v[5:7], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA glc
; GFX11: image_msaa_load v[1:4], v[5:7], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA glc ; encoding: [0x18,0x42,0x60,0xf0,0x05,0x01,0x02,0x00]

image_msaa_load v[1:2], v[1:3], s[8:15] dmask:0x4 dim:SQ_RSRC_IMG_2D_MSAA d16
; GFX11: image_msaa_load v[1:2], v[1:3], s[8:15] dmask:0x4 dim:SQ_RSRC_IMG_2D_MSAA d16 ; encoding: [0x18,0x04,0x62,0xf0,0x01,0x01,0x02,0x00]

image_msaa_load v[1:4], v[5:8], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY
; GFX11: image_msaa_load v[1:4], v[5:8], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY ; encoding: [0x1c,0x02,0x60,0xf0,0x05,0x01,0x02,0x00]

image_msaa_load v[1:2], v[5:8], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY d16
; GFX11: image_msaa_load v[1:2], v[5:8], s[8:15] dmask:0x2 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY d16 ; encoding: [0x1c,0x02,0x62,0xf0,0x05,0x01,0x02,0x00]

image_msaa_load v[10:13], [v204, v11, v14, v19], s[40:47] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY
; GFX11: image_msaa_load v[10:13], [v204, v11, v14, v19], s[40:47] dmask:0x1 dim:SQ_RSRC_IMG_2D_MSAA_ARRAY ; encoding: [0x1d,0x01,0x60,0xf0,0xcc,0x0a,0x0a,0x00,0x0b,0x0e,0x13,0x00]

image_bvh_intersect_ray v[4:7], v[9:24], s[4:7]
; GFX11: image_bvh_intersect_ray v[4:7], v[9:24], s[4:7] ; encoding: [0x80,0x8f,0x64,0xf0,0x09,0x04,0x01,0x00]

image_bvh_intersect_ray v[4:7], v[9:16], s[4:7] a16
; GFX11: image_bvh_intersect_ray v[4:7], v[9:16], s[4:7] a16 ; encoding: [0x80,0x8f,0x65,0xf0,0x09,0x04,0x01,0x00]

image_bvh64_intersect_ray v[4:7], v[9:24], s[4:7]
; GFX11: image_bvh64_intersect_ray v[4:7], v[9:24], s[4:7] ; encoding: [0x80,0x8f,0x68,0xf0,0x09,0x04,0x01,0x00]

image_bvh64_intersect_ray v[4:7], v[9:24], s[4:7] a16
; GFX11: image_bvh64_intersect_ray v[4:7], v[9:24], s[4:7] a16 ; encoding: [0x80,0x8f,0x69,0xf0,0x09,0x04,0x01,0x00]

image_bvh_intersect_ray v[39:42], [v50, v46, v[20:22], v[40:42], v[47:49]], s[12:15]
; GFX11: image_bvh_intersect_ray v[39:42], [v50, v46, v[20:22], v[40:42], v[47:49]], s[12:15] ; encoding: [0x81,0x8f,0x64,0xf0,0x32,0x27,0x03,0x00,0x2e,0x14,0x28,0x2f]

image_bvh_intersect_ray v[39:42], [v50, v46, v[20:22], v[40:42]], s[12:15] a16
; GFX11: image_bvh_intersect_ray v[39:42], [v50, v46, v[20:22], v[40:42]], s[12:15] a16 ; encoding: [0x81,0x8f,0x65,0xf0,0x32,0x27,0x03,0x00,0x2e,0x14,0x28,0x00]

image_bvh64_intersect_ray v[39:42], [v[50:51], v46, v[20:22], v[40:42], v[47:49]], s[12:15]
; GFX11: image_bvh64_intersect_ray v[39:42], [v[50:51], v46, v[20:22], v[40:42], v[47:49]], s[12:15] ; encoding: [0x81,0x8f,0x68,0xf0,0x32,0x27,0x03,0x00,0x2e,0x14,0x28,0x2f]

image_bvh64_intersect_ray v[39:42], [v[50:51], v46, v[20:22], v[40:42]], s[12:15] a16
; GFX11: image_bvh64_intersect_ray v[39:42], [v[50:51], v46, v[20:22], v[40:42]], s[12:15] a16 ; encoding: [0x81,0x8f,0x69,0xf0,0x32,0x27,0x03,0x00,0x2e,0x14,0x28,0x00]
