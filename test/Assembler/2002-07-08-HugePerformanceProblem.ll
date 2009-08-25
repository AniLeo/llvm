; This file takes about 48 __MINUTES__ to assemble using as.  This is WAY too
; long.  The type resolution code needs to be sped up a lot.
; RUN: llvm-as %s -o /dev/null
	%ALL_INTERSECTIONS_METHOD = type i32 (%OBJECT*, %RAY*, %ISTACK*)*
	%BBOX = type { %BBOX_VECT, %BBOX_VECT }
	%BBOX_TREE = type { i16, i16, %BBOX, %BBOX_TREE** }
	%BBOX_VECT = type [3 x float]
	%BLEND_MAP = type { i16, i16, i16, i32, %BLEND_MAP_ENTRY* }
	%BLEND_MAP_ENTRY = type { float, i8, { %COLOUR, %PIGMENT*, %TNORMAL*, %TEXTURE*, %UV_VECT } }
	%CAMERA = type { %VECTOR, %VECTOR, %VECTOR, %VECTOR, %VECTOR, %VECTOR, double, double, i32, double, double, i32, double, %TNORMAL* }
	%COLOUR = type [5 x float]
	%COPY_METHOD = type i8* (%OBJECT*)*
	%COUNTER = type { i32, i32 }
	%DENSITY_FILE = type { i32, %DENSITY_FILE_DATA* }
	%DENSITY_FILE_DATA = type { i32, i8*, i32, i32, i32, i8*** }
	%DESTROY_METHOD = type void (%OBJECT*)*
	%FILE = type { i32, i8*, i8*, i8, i8, i32, i32, i32 }
	%FILE_HANDLE = type { i8*, i32, i32, i32, i32, i8*, %FILE*, i32, i32 (%FILE_HANDLE*, i8*, i32*, i32*, i32, i32)*, void (%FILE_HANDLE*, %COLOUR*, i32)*, i32 (%FILE_HANDLE*, %COLOUR*, i32*)*, void (%IMAGE*, i8*)*, void (%FILE_HANDLE*)* }
	%FINISH = type { float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, %BBOX_VECT, %BBOX_VECT }
	%FOG = type { i32, double, double, double, %COLOUR, %VECTOR, %TURB*, float, %FOG* }
	%FRAME = type { %CAMERA*, i32, i32, i32, %LIGHT_SOURCE*, %OBJECT*, double, double, %COLOUR, %COLOUR, %COLOUR, %IMEDIA*, %FOG*, %RAINBOW*, %SKYSPHERE* }
	%FRAMESEQ = type { i32, double, i32, i32, double, i32, i32, double, i32, double, i32, double, i32, i32 }
	%IMAGE = type { i32, i32, i32, i32, i32, i16, i16, %VECTOR, float, float, i32, i32, i16, %IMAGE_COLOUR*, { %IMAGE_LINE*, i8** } }
	%IMAGE_COLOUR = type { i16, i16, i16, i16, i16 }
	%IMAGE_LINE = type { i8*, i8*, i8*, i8* }
	%IMEDIA = type { i32, i32, i32, i32, i32, double, double, i32, i32, i32, i32, %COLOUR, %COLOUR, %COLOUR, %COLOUR, double, double, double, double*, %PIGMENT*, %IMEDIA* }
	%INSIDE_METHOD = type i32 (double*, %OBJECT*)*
	%INTERIOR = type { i32, i32, float, float, float, float, float, %IMEDIA* }
	%INTERSECTION = type { double, %VECTOR, %VECTOR, %OBJECT*, i32, i32, double, double, i8* }
	%INVERT_METHOD = type void (%OBJECT*)*
	%ISTACK = type { %ISTACK*, %INTERSECTION*, i32 }
	%LIGHT_SOURCE = type { %METHODS*, i32, %OBJECT*, %TEXTURE*, %INTERIOR*, %OBJECT*, %OBJECT*, %BBOX, i32, %OBJECT*, %COLOUR, %VECTOR, %VECTOR, %VECTOR, %VECTOR, %VECTOR, double, double, double, double, double, %LIGHT_SOURCE*, i8, i8, i8, i8, i32, i32, i32, i32, i32, %COLOUR**, %OBJECT*, [6 x %PROJECT_TREE_NODE*] }
	%MATRIX = type [4 x %VECTOR_4D]
	%METHODS = type { %ALL_INTERSECTIONS_METHOD, %INSIDE_METHOD, %NORMAL_METHOD, %COPY_METHOD, %ROTATE_METHOD, %ROTATE_METHOD, %ROTATE_METHOD, %TRANSFORM_METHOD, %DESTROY_METHOD, %DESTROY_METHOD }
	%NORMAL_METHOD = type void (double*, %OBJECT*, %INTERSECTION*)*
	%OBJECT = type { %METHODS*, i32, %OBJECT*, %TEXTURE*, %INTERIOR*, %OBJECT*, %OBJECT*, %BBOX, i32 }
	%Opts = type { i32, i32, i8, i8, i8, i32, [150 x i8], [150 x i8], [150 x i8], [150 x i8], [150 x i8], double, double, i32, i32, double, double, i32, [25 x i8*], i32, i32, i32, double, double, i32, i32, double, double, double, i32, i32, i32, i32, i32, %FRAMESEQ, double, i32, double, double, double, double, double, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [150 x i8], %SHELLDATA*, [150 x i8], i32, i32 }
	%PIGMENT = type { i16, i16, i16, i32, float, float, float, %WARP*, %TPATTERN*, %BLEND_MAP*, { %DENSITY_FILE*, %IMAGE*, %VECTOR, float, i16, i16, i16, { float, %VECTOR }, %complex.float }, %COLOUR }
	%PRIORITY_QUEUE = type { i32, i32, %QELEM* }
	%PROJECT = type { i32, i32, i32, i32 }
	%PROJECT_QUEUE = type { i32, i32, %PROJECT_TREE_NODE** }
	%PROJECT_TREE_NODE = type { i16, %BBOX_TREE*, %PROJECT, i16, %PROJECT_TREE_NODE** }
	%QELEM = type { double, %BBOX_TREE* }
	%RAINBOW = type { double, double, double, double, double, double, double, %VECTOR, %VECTOR, %VECTOR, %PIGMENT*, %RAINBOW* }
	%RAY = type { %VECTOR, %VECTOR, i32, [100 x %INTERIOR*] }
	%RAYINFO = type { %VECTOR, %VECTOR, %VECTORI, %VECTORI }
	%RGB = type [3 x float]
	%ROTATE_METHOD = type void (%OBJECT*, double*, %TRANSFORM*)*
	%SCALE_METHOD = type void (%OBJECT*, double*, %TRANSFORM*)*
	%SHELLDATA = type { i32, i32, [250 x i8] }
	%SKYSPHERE = type { i32, %PIGMENT**, %TRANSFORM* }
	%SNGL_VECT = type [3 x float]
	%TEXTURE = type { i16, i16, i16, i32, float, float, float, %WARP*, %TPATTERN*, %BLEND_MAP*, { %DENSITY_FILE*, %IMAGE*, %VECTOR, float, i16, i16, i16, { float, %VECTOR }, %complex.float }, %TEXTURE*, %PIGMENT*, %TNORMAL*, %FINISH*, %TEXTURE*, i32 }
	%TNORMAL = type { i16, i16, i16, i32, float, float, float, %WARP*, %TPATTERN*, %BLEND_MAP*, { %DENSITY_FILE*, %IMAGE*, %VECTOR, float, i16, i16, i16, { float, %VECTOR }, %complex.float }, float }
	%TPATTERN = type { i16, i16, i16, i32, float, float, float, %WARP*, %TPATTERN*, %BLEND_MAP*, { %DENSITY_FILE*, %IMAGE*, %VECTOR, float, i16, i16, i16, { float, %VECTOR }, %complex.float } }
	%TRANSFORM = type { %MATRIX, %MATRIX }
	%TRANSFORM_METHOD = type void (%OBJECT*, %TRANSFORM*)*
	%TRANSLATE_METHOD = type void (%OBJECT*, double*, %TRANSFORM*)*
	%TURB = type { i16, %WARP*, %VECTOR, i32, float, float }
	%UV_VECT = type [2 x double]
	%VECTOR = type [3 x double]
	%VECTORI = type [3 x i32]
	%VECTOR_4D = type [4 x double]
	%WARP = type { i16, %WARP* }
	%__FILE = type { i32, i8*, i8*, i8, i8, i32, i32, i32 }
	%_h_val = type { [2 x i32], double }
	%complex.float = type { float, float }
