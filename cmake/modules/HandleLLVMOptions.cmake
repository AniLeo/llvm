# This CMake module is responsible for interpreting the user defined LLVM_
# options and executing the appropriate CMake commands to realize the users'
# selections.

# This is commonly needed so make sure it's defined before we include anything
# else.
string(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)

include(CheckCompilerVersion)
include(HandleLLVMStdlib)
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

if(CMAKE_LINKER MATCHES "lld-link.exe" OR (WIN32 AND LLVM_USE_LINKER STREQUAL "lld"))
  set(LINKER_IS_LLD_LINK TRUE)
else()
  set(LINKER_IS_LLD_LINK FALSE)
endif()

set(LLVM_ENABLE_LTO OFF CACHE STRING "Build LLVM with LTO. May be specified as Thin or Full to use a particular kind of LTO")
string(TOUPPER "${LLVM_ENABLE_LTO}" uppercase_LLVM_ENABLE_LTO)

# Ninja Job Pool support
# The following only works with the Ninja generator in CMake >= 3.0.
set(LLVM_PARALLEL_COMPILE_JOBS "" CACHE STRING
  "Define the maximum number of concurrent compilation jobs.")
if(LLVM_PARALLEL_COMPILE_JOBS)
  if(NOT CMAKE_MAKE_PROGRAM MATCHES "ninja")
    message(WARNING "Job pooling is only available with Ninja generators.")
  else()
    set_property(GLOBAL APPEND PROPERTY JOB_POOLS compile_job_pool=${LLVM_PARALLEL_COMPILE_JOBS})
    set(CMAKE_JOB_POOL_COMPILE compile_job_pool)
  endif()
endif()

set(LLVM_PARALLEL_LINK_JOBS "" CACHE STRING
  "Define the maximum number of concurrent link jobs.")
if(CMAKE_MAKE_PROGRAM MATCHES "ninja")
  if(NOT LLVM_PARALLEL_LINK_JOBS AND uppercase_LLVM_ENABLE_LTO STREQUAL "THIN")
    message(STATUS "ThinLTO provides its own parallel linking - limiting parallel link jobs to 2.")
    set(LLVM_PARALLEL_LINK_JOBS "2")
  endif()
  if(LLVM_PARALLEL_LINK_JOBS)
    set_property(GLOBAL APPEND PROPERTY JOB_POOLS link_job_pool=${LLVM_PARALLEL_LINK_JOBS})
    set(CMAKE_JOB_POOL_LINK link_job_pool)
  endif()
elseif(LLVM_PARALLEL_LINK_JOBS)
  message(WARNING "Job pooling is only available with Ninja generators.")
endif()

if (LINKER_IS_LLD_LINK)
  # Pass /MANIFEST:NO so that CMake doesn't run mt.exe on our binaries.  Adding
  # manifests with mt.exe breaks LLD's symbol tables and takes as much time as
  # the link. See PR24476.
  append("/MANIFEST:NO"
    CMAKE_EXE_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
endif()

if( LLVM_ENABLE_ASSERTIONS )
  # MSVC doesn't like _DEBUG on release builds. See PR 4379.
  if( NOT MSVC )
    add_definitions( -D_DEBUG )
  endif()
  # On non-Debug builds cmake automatically defines NDEBUG, so we
  # explicitly undefine it:
  if( NOT uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG" )
    add_definitions( -UNDEBUG )
    # Also remove /D NDEBUG to avoid MSVC warnings about conflicting defines.
    foreach (flags_var_to_scrub
        CMAKE_CXX_FLAGS_RELEASE
        CMAKE_CXX_FLAGS_RELWITHDEBINFO
        CMAKE_CXX_FLAGS_MINSIZEREL
        CMAKE_C_FLAGS_RELEASE
        CMAKE_C_FLAGS_RELWITHDEBINFO
        CMAKE_C_FLAGS_MINSIZEREL)
      string (REGEX REPLACE "(^| )[/-]D *NDEBUG($| )" " "
        "${flags_var_to_scrub}" "${${flags_var_to_scrub}}")
    endforeach()
  endif()
endif()

if(LLVM_ENABLE_EXPENSIVE_CHECKS)
  add_definitions(-DEXPENSIVE_CHECKS)
  add_definitions(-D_GLIBCXX_DEBUG)
endif()

string(TOUPPER "${LLVM_ABI_BREAKING_CHECKS}" uppercase_LLVM_ABI_BREAKING_CHECKS)

if( uppercase_LLVM_ABI_BREAKING_CHECKS STREQUAL "WITH_ASSERTS" )
  if( LLVM_ENABLE_ASSERTIONS )
    set( LLVM_ENABLE_ABI_BREAKING_CHECKS 1 )
  endif()
elseif( uppercase_LLVM_ABI_BREAKING_CHECKS STREQUAL "FORCE_ON" )
  set( LLVM_ENABLE_ABI_BREAKING_CHECKS 1 )
elseif( uppercase_LLVM_ABI_BREAKING_CHECKS STREQUAL "FORCE_OFF" )
  # We don't need to do anything special to turn off ABI breaking checks.
elseif( NOT DEFINED LLVM_ABI_BREAKING_CHECKS )
  # Treat LLVM_ABI_BREAKING_CHECKS like "FORCE_OFF" when it has not been
  # defined.
else()
  message(FATAL_ERROR "Unknown value for LLVM_ABI_BREAKING_CHECKS: \"${LLVM_ABI_BREAKING_CHECKS}\"!")
endif()

if( LLVM_REVERSE_ITERATION )
  set( LLVM_ENABLE_REVERSE_ITERATION 1 )
endif()

if(WIN32)
  set(LLVM_HAVE_LINK_VERSION_SCRIPT 0)
  if(CYGWIN)
    set(LLVM_ON_WIN32 0)
    set(LLVM_ON_UNIX 1)
  else(CYGWIN)
    set(LLVM_ON_WIN32 1)
    set(LLVM_ON_UNIX 0)
  endif(CYGWIN)
else(WIN32)
  if(UNIX)
    set(LLVM_ON_WIN32 0)
    set(LLVM_ON_UNIX 1)
    if(APPLE OR ${CMAKE_SYSTEM_NAME} MATCHES "AIX")
      set(LLVM_HAVE_LINK_VERSION_SCRIPT 0)
    else()
      set(LLVM_HAVE_LINK_VERSION_SCRIPT 1)
    endif()
  else(UNIX)
    MESSAGE(SEND_ERROR "Unable to determine platform")
  endif(UNIX)
endif(WIN32)

set(EXEEXT ${CMAKE_EXECUTABLE_SUFFIX})
set(LTDL_SHLIB_EXT ${CMAKE_SHARED_LIBRARY_SUFFIX})

# We use *.dylib rather than *.so on darwin.
set(LLVM_PLUGIN_EXT ${CMAKE_SHARED_LIBRARY_SUFFIX})

if(APPLE)
  if(LLVM_ENABLE_LLD AND LLVM_ENABLE_LTO)
    message(FATAL_ERROR "lld does not support LTO on Darwin")
  endif()
  # Darwin-specific linker flags for loadable modules.
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,-flat_namespace -Wl,-undefined -Wl,suppress")
endif()

# Pass -Wl,-z,defs. This makes sure all symbols are defined. Otherwise a DSO
# build might work on ELF but fail on MachO/COFF.
if(NOT (${CMAKE_SYSTEM_NAME} MATCHES "Darwin" OR WIN32 OR CYGWIN OR
        ${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD" OR
        ${CMAKE_SYSTEM_NAME} MATCHES "OpenBSD") AND
   NOT LLVM_USE_SANITIZER)
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-z,defs")
endif()


function(append value)
  foreach(variable ${ARGN})
    set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
  endforeach(variable)
endfunction()

function(append_if condition value)
  if (${condition})
    foreach(variable ${ARGN})
      set(${variable} "${${variable}} ${value}" PARENT_SCOPE)
    endforeach(variable)
  endif()
endfunction()

macro(add_flag_if_supported flag name)
  check_c_compiler_flag("-Werror ${flag}" "C_SUPPORTS_${name}")
  append_if("C_SUPPORTS_${name}" "${flag}" CMAKE_C_FLAGS)
  check_cxx_compiler_flag("-Werror ${flag}" "CXX_SUPPORTS_${name}")
  append_if("CXX_SUPPORTS_${name}" "${flag}" CMAKE_CXX_FLAGS)
endmacro()

function(add_flag_or_print_warning flag name)
  check_c_compiler_flag("-Werror ${flag}" "C_SUPPORTS_${name}")
  check_cxx_compiler_flag("-Werror ${flag}" "CXX_SUPPORTS_${name}")
  if (C_SUPPORTS_${name} AND CXX_SUPPORTS_${name})
    message(STATUS "Building with ${flag}")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${flag}" PARENT_SCOPE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flag}" PARENT_SCOPE)
    set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} ${flag}" PARENT_SCOPE)
  else()
    message(WARNING "${flag} is not supported.")
  endif()
endfunction()

if( LLVM_ENABLE_LLD )
	if ( LLVM_USE_LINKER )
		message(FATAL_ERROR "LLVM_ENABLE_LLD and LLVM_USE_LINKER can't be set at the same time")
	endif()
	set(LLVM_USE_LINKER "lld")
endif()

if( LLVM_USE_LINKER )
  check_cxx_compiler_flag("-fuse-ld=${LLVM_USE_LINKER}" CXX_SUPPORTS_CUSTOM_LINKER)
  if ( NOT CXX_SUPPORTS_CUSTOM_LINKER )
	  message(FATAL_ERROR "Host compiler does not support '-fuse-ld=${LLVM_USE_LINKER}'")
  endif()
  append("-fuse-ld=${LLVM_USE_LINKER}"
    CMAKE_EXE_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
endif()

if( LLVM_ENABLE_PIC )
  if( XCODE )
    # Xcode has -mdynamic-no-pic on by default, which overrides -fPIC. I don't
    # know how to disable this, so just force ENABLE_PIC off for now.
    message(WARNING "-fPIC not supported with Xcode.")
  elseif( WIN32 OR CYGWIN)
    # On Windows all code is PIC. MinGW warns if -fPIC is used.
  else()
    add_flag_or_print_warning("-fPIC" FPIC)
  endif()
endif()

if(NOT WIN32 AND NOT CYGWIN)
  # MinGW warns if -fvisibility-inlines-hidden is used.
  check_cxx_compiler_flag("-fvisibility-inlines-hidden" SUPPORTS_FVISIBILITY_INLINES_HIDDEN_FLAG)
  append_if(SUPPORTS_FVISIBILITY_INLINES_HIDDEN_FLAG "-fvisibility-inlines-hidden" CMAKE_CXX_FLAGS)
endif()

if( CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT WIN32 )
  # TODO: support other platforms and toolchains.
  if( LLVM_BUILD_32_BITS )
    message(STATUS "Building 32 bits executables and libraries.")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m32")
  endif( LLVM_BUILD_32_BITS )
endif( CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT WIN32 )

# If building on a GNU specific 32-bit system, make sure off_t is 64 bits
# so that off_t can stored offset > 2GB
if( CMAKE_SIZEOF_VOID_P EQUAL 4 )
  add_definitions( -D_LARGEFILE_SOURCE )
  add_definitions( -D_FILE_OFFSET_BITS=64 )
endif()

if( XCODE )
  # For Xcode enable several build settings that correspond to
  # many warnings that are on by default in Clang but are
  # not enabled for historical reasons.  For versions of Xcode
  # that do not support these options they will simply
  # be ignored.
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_ABOUT_RETURN_TYPE "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_ABOUT_MISSING_NEWLINE "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_UNUSED_VALUE "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_UNUSED_VARIABLE "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_SIGN_COMPARE "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_UNUSED_FUNCTION "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_HIDDEN_VIRTUAL_FUNCTIONS "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_UNINITIALIZED_AUTOS "YES")
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_WARN_BOOL_CONVERSION "YES")
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_WARN_EMPTY_BODY "YES")
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_WARN_ENUM_CONVERSION "YES")
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_WARN_INT_CONVERSION "YES")
  set(CMAKE_XCODE_ATTRIBUTE_CLANG_WARN_CONSTANT_CONVERSION "YES")
  set(CMAKE_XCODE_ATTRIBUTE_GCC_WARN_NON_VIRTUAL_DESTRUCTOR "YES")
endif()

# On Win32 using MS tools, provide an option to set the number of parallel jobs
# to use.
if( MSVC_IDE )
  set(LLVM_COMPILER_JOBS "0" CACHE STRING
    "Number of parallel compiler jobs. 0 means use all processors. Default is 0.")
  if( NOT LLVM_COMPILER_JOBS STREQUAL "1" )
    if( LLVM_COMPILER_JOBS STREQUAL "0" )
      add_definitions( /MP )
    else()
      message(STATUS "Number of parallel compiler jobs set to " ${LLVM_COMPILER_JOBS})
      add_definitions( /MP${LLVM_COMPILER_JOBS} )
    endif()
  else()
    message(STATUS "Parallel compilation disabled")
  endif()
endif()

# set stack reserved size to ~10MB
if(MSVC)
  # CMake previously automatically set this value for MSVC builds, but the
  # behavior was changed in CMake 2.8.11 (Issue 12437) to use the MSVC default
  # value (1 MB) which is not enough for us in tasks such as parsing recursive
  # C++ templates in Clang.
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /STACK:10000000")
elseif(MINGW) # FIXME: Also cygwin?
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--stack,16777216")

  # Pass -mbig-obj to mingw gas on Win64. COFF has a 2**16 section limit, and
  # on Win64, every COMDAT function creates at least 3 sections: .text, .pdata,
  # and .xdata.
  if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    append("-Wa,-mbig-obj" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif()
endif()

if( MSVC )
  if( CMAKE_CXX_COMPILER_VERSION VERSION_LESS 19.0 )
    # For MSVC 2013, disable iterator null pointer checking in debug mode,
    # especially so std::equal(nullptr, nullptr, nullptr) will not assert.
    add_definitions("-D_DEBUG_POINTER_IMPL=")
  endif()
  
  include(ChooseMSVCCRT)

  if( MSVC11 )
    add_definitions(-D_VARIADIC_MAX=10)
  endif()
  
  # Add definitions that make MSVC much less annoying.
  add_definitions(
    # For some reason MS wants to deprecate a bunch of standard functions...
    -D_CRT_SECURE_NO_DEPRECATE
    -D_CRT_SECURE_NO_WARNINGS
    -D_CRT_NONSTDC_NO_DEPRECATE
    -D_CRT_NONSTDC_NO_WARNINGS
    -D_SCL_SECURE_NO_DEPRECATE
    -D_SCL_SECURE_NO_WARNINGS
    )

  # Tell MSVC to use the Unicode version of the Win32 APIs instead of ANSI.
  add_definitions(
    -DUNICODE
    -D_UNICODE
  )

  if (LLVM_ENABLE_WERROR)
    append("/WX" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif (LLVM_ENABLE_WERROR)

  append("/Zc:inline" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)

  # /Zc:strictStrings is incompatible with VS12's (Visual Studio 2013's)
  # debug mode headers. Instead of only enabling them in VS2013's debug mode,
  # we'll just enable them for Visual Studio 2015 (VS 14, MSVC_VERSION 1900)
  # and up.
  if (NOT (MSVC_VERSION LESS 1900))
    # Disable string literal const->non-const type conversion.
    # "When specified, the compiler requires strict const-qualification
    # conformance for pointers initialized by using string literals."
    append("/Zc:strictStrings" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif(NOT (MSVC_VERSION LESS 1900))

  # "Generate Intrinsic Functions".
  append("/Oi" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)

  # "Enforce type conversion rules".
  append("/Zc:rvalueCast" CMAKE_CXX_FLAGS)

  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT LLVM_ENABLE_LTO)
    # clang-cl and cl by default produce non-deterministic binaries because
    # link.exe /incremental requires a timestamp in the .obj file.  clang-cl
    # has the flag /Brepro to force deterministic binaries. We want to pass that
    # whenever you're building with clang unless you're passing /incremental
    # or using LTO (/Brepro with LTO would result in a warning about the flag
    # being unused, because we're not generating object files).
    # This checks CMAKE_CXX_COMPILER_ID in addition to check_cxx_compiler_flag()
    # because cl.exe does not emit an error on flags it doesn't understand,
    # letting check_cxx_compiler_flag() claim it understands all flags.
    check_cxx_compiler_flag("/Brepro" SUPPORTS_BREPRO)
    if (SUPPORTS_BREPRO)
      # Check if /INCREMENTAL is passed to the linker and complain that it
      # won't work with /Brepro.
      string(TOUPPER "${CMAKE_EXE_LINKER_FLAGS}" upper_exe_flags)
      string(TOUPPER "${CMAKE_MODULE_LINKER_FLAGS}" upper_module_flags)
      string(TOUPPER "${CMAKE_SHARED_LINKER_FLAGS}" upper_shared_flags)

      string(FIND "${upper_exe_flags} ${upper_module_flags} ${upper_shared_flags}"
        "/INCREMENTAL" linker_flag_idx)
      
      if (${linker_flag_idx} GREATER -1)
        message(WARNING "/Brepro not compatible with /INCREMENTAL linking - builds will be non-deterministic")
      else()
        append("/Brepro" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      endif()
    endif()
  endif()

elseif( LLVM_COMPILER_IS_GCC_COMPATIBLE )
  append_if(LLVM_ENABLE_WERROR "-Werror" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  add_flag_if_supported("-Werror=date-time" WERROR_DATE_TIME)
  if (LLVM_ENABLE_CXX1Y)
    check_cxx_compiler_flag("-std=c++1y" CXX_SUPPORTS_CXX1Y)
    append_if(CXX_SUPPORTS_CXX1Y "-std=c++1y" CMAKE_CXX_FLAGS)
  elseif(LLVM_ENABLE_CXX1Z)
    check_cxx_compiler_flag("-std=c++1z" CXX_SUPPORTS_CXX1Z)
    append_if(CXX_SUPPORTS_CXX1Z "-std=c++1z" CMAKE_CXX_FLAGS)
  else()
    check_cxx_compiler_flag("-std=c++11" CXX_SUPPORTS_CXX11)
    if (CXX_SUPPORTS_CXX11)
      if (CYGWIN OR MINGW)
        # MinGW and Cygwin are a bit stricter and lack things like
        # 'strdup', 'stricmp', etc in c++11 mode.
        append("-std=gnu++11" CMAKE_CXX_FLAGS)
      else()
        append("-std=c++11" CMAKE_CXX_FLAGS)
      endif()
    else()
      message(FATAL_ERROR "LLVM requires C++11 support but the '-std=c++11' flag isn't supported.")
    endif()
  endif()
  if (LLVM_ENABLE_MODULES)
    set(OLD_CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
    set(module_flags "-fmodules -fmodules-cache-path=${PROJECT_BINARY_DIR}/module.cache")
    if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
      # On Darwin -fmodules does not imply -fcxx-modules.
      set(module_flags "${module_flags} -fcxx-modules")
    endif()
    if (LLVM_ENABLE_LOCAL_SUBMODULE_VISIBILITY)
      set(module_flags "${module_flags} -Xclang -fmodules-local-submodule-visibility")
    endif()
    if (LLVM_ENABLE_MODULE_DEBUGGING AND
        ((uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG") OR
         (uppercase_CMAKE_BUILD_TYPE STREQUAL "RELWITHDEBINFO")))
      set(module_flags "${module_flags} -gmodules")
    endif()
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${module_flags}")

    # Check that we can build code with modules enabled, and that repeatedly
    # including <cassert> still manages to respect NDEBUG properly.
    CHECK_CXX_SOURCE_COMPILES("#undef NDEBUG
                               #include <cassert>
                               #define NDEBUG
                               #include <cassert>
                               int main() { assert(this code is not compiled); }"
                               CXX_SUPPORTS_MODULES)
    set(CMAKE_REQUIRED_FLAGS ${OLD_CMAKE_REQUIRED_FLAGS})
    if (CXX_SUPPORTS_MODULES)
      append("${module_flags}" CMAKE_CXX_FLAGS)
    else()
      message(FATAL_ERROR "LLVM_ENABLE_MODULES is not supported by this compiler")
    endif()
  endif(LLVM_ENABLE_MODULES)
endif( MSVC )

if (MSVC AND NOT CLANG_CL)
  set(msvc_warning_flags
    # Disabled warnings.
    -wd4141 # Suppress ''modifier' : used more than once' (because of __forceinline combined with inline)
    -wd4146 # Suppress 'unary minus operator applied to unsigned type, result still unsigned'
    -wd4180 # Suppress 'qualifier applied to function type has no meaning; ignored'
    -wd4244 # Suppress ''argument' : conversion from 'type1' to 'type2', possible loss of data'
    -wd4258 # Suppress ''var' : definition from the for loop is ignored; the definition from the enclosing scope is used'
    -wd4267 # Suppress ''var' : conversion from 'size_t' to 'type', possible loss of data'
    -wd4291 # Suppress ''declaration' : no matching operator delete found; memory will not be freed if initialization throws an exception'
    -wd4345 # Suppress 'behavior change: an object of POD type constructed with an initializer of the form () will be default-initialized'
    -wd4351 # Suppress 'new behavior: elements of array 'array' will be default initialized'
    -wd4355 # Suppress ''this' : used in base member initializer list'
    -wd4456 # Suppress 'declaration of 'var' hides local variable'
    -wd4457 # Suppress 'declaration of 'var' hides function parameter'
    -wd4458 # Suppress 'declaration of 'var' hides class member'
    -wd4459 # Suppress 'declaration of 'var' hides global declaration'
    -wd4503 # Suppress ''identifier' : decorated name length exceeded, name was truncated'
    -wd4624 # Suppress ''derived class' : destructor could not be generated because a base class destructor is inaccessible'
    -wd4722 # Suppress 'function' : destructor never returns, potential memory leak
    -wd4800 # Suppress ''type' : forcing value to bool 'true' or 'false' (performance warning)'
    -wd4100 # Suppress 'unreferenced formal parameter'
    -wd4127 # Suppress 'conditional expression is constant'
    -wd4512 # Suppress 'assignment operator could not be generated'
    -wd4505 # Suppress 'unreferenced local function has been removed'
    -wd4610 # Suppress '<class> can never be instantiated'
    -wd4510 # Suppress 'default constructor could not be generated'
    -wd4702 # Suppress 'unreachable code'
    -wd4245 # Suppress 'signed/unsigned mismatch'
    -wd4706 # Suppress 'assignment within conditional expression'
    -wd4310 # Suppress 'cast truncates constant value'
    -wd4701 # Suppress 'potentially uninitialized local variable'
    -wd4703 # Suppress 'potentially uninitialized local pointer variable'
    -wd4389 # Suppress 'signed/unsigned mismatch'
    -wd4611 # Suppress 'interaction between '_setjmp' and C++ object destruction is non-portable'
    -wd4805 # Suppress 'unsafe mix of type <type> and type <type> in operation'
    -wd4204 # Suppress 'nonstandard extension used : non-constant aggregate initializer'
    -wd4577 # Suppress 'noexcept used with no exception handling mode specified; termination on exception is not guaranteed'
    -wd4091 # Suppress 'typedef: ignored on left of '' when no variable is declared'
        # C4592 is disabled because of false positives in Visual Studio 2015
        # Update 1. Re-evaluate the usefulness of this diagnostic with Update 2.
    -wd4592 # Suppress ''var': symbol will be dynamically initialized (implementation limitation)
    -wd4319 # Suppress ''operator' : zero extending 'type' to 'type' of greater size'

    # Ideally, we'd like this warning to be enabled, but MSVC 2013 doesn't
    # support the 'aligned' attribute in the way that clang sources requires (for
    # any code that uses the LLVM_ALIGNAS macro), so this is must be disabled to
    # avoid unwanted alignment warnings.
    # When we switch to requiring a version of MSVC that supports the 'alignas'
    # specifier (MSVC 2015?) this warning can be re-enabled.
    -wd4324 # Suppress 'structure was padded due to __declspec(align())'

    # Promoted warnings.
    -w14062 # Promote 'enumerator in switch of enum is not handled' to level 1 warning.

    # Promoted warnings to errors.
    -we4238 # Promote 'nonstandard extension used : class rvalue used as lvalue' to error.
    )

  # Enable warnings
  if (LLVM_ENABLE_WARNINGS)
    # Put /W4 in front of all the -we flags. cl.exe doesn't care, but for
    # clang-cl having /W4 after the -we flags will re-enable the warnings
    # disabled by -we.
    set(msvc_warning_flags "/W4 ${msvc_warning_flags}")
    # CMake appends /W3 by default, and having /W3 followed by /W4 will result in
    # cl : Command line warning D9025 : overriding '/W3' with '/W4'.  Since this is
    # a command line warning and not a compiler warning, it cannot be suppressed except
    # by fixing the command line.
    string(REGEX REPLACE " /W[0-4]" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    string(REGEX REPLACE " /W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

    if (LLVM_ENABLE_PEDANTIC)
      # No MSVC equivalent available
    endif (LLVM_ENABLE_PEDANTIC)
  endif (LLVM_ENABLE_WARNINGS)

  foreach(flag ${msvc_warning_flags})
    append("${flag}" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endforeach(flag)
endif (MSVC AND NOT CLANG_CL)

if (LLVM_ENABLE_WARNINGS AND (LLVM_COMPILER_IS_GCC_COMPATIBLE OR CLANG_CL))
  append("-Wall -W -Wno-unused-parameter -Wwrite-strings" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  append("-Wcast-qual" CMAKE_CXX_FLAGS)

  # Turn off missing field initializer warnings for gcc to avoid noise from
  # false positives with empty {}. Turn them on otherwise (they're off by
  # default for clang).
  check_cxx_compiler_flag("-Wmissing-field-initializers" CXX_SUPPORTS_MISSING_FIELD_INITIALIZERS_FLAG)
  if (CXX_SUPPORTS_MISSING_FIELD_INITIALIZERS_FLAG)
    if (CMAKE_COMPILER_IS_GNUCXX)
      append("-Wno-missing-field-initializers" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    else()
      append("-Wmissing-field-initializers" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    endif()
  endif()

  if (LLVM_ENABLE_PEDANTIC AND LLVM_COMPILER_IS_GCC_COMPATIBLE)
    append("-pedantic" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    append("-Wno-long-long" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif()

  add_flag_if_supported("-Wcovered-switch-default" COVERED_SWITCH_DEFAULT_FLAG)
  append_if(USE_NO_UNINITIALIZED "-Wno-uninitialized" CMAKE_CXX_FLAGS)
  append_if(USE_NO_MAYBE_UNINITIALIZED "-Wno-maybe-uninitialized" CMAKE_CXX_FLAGS)

  # Check if -Wnon-virtual-dtor warns even though the class is marked final.
  # If it does, don't add it. So it won't be added on clang 3.4 and older.
  # This also catches cases when -Wnon-virtual-dtor isn't supported by
  # the compiler at all.  This flag is not activated for gcc since it will
  # incorrectly identify a protected non-virtual base when there is a friend
  # declaration. Don't activate this in general on Windows as this warning has
  # too many false positives on COM-style classes, which are destroyed with
  # Release() (PR32286).
  if (NOT CMAKE_COMPILER_IS_GNUCXX AND NOT WIN32)
    set(OLD_CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
    set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -std=c++11 -Werror=non-virtual-dtor")
    CHECK_CXX_SOURCE_COMPILES("class base {public: virtual void anchor();protected: ~base();};
                               class derived final : public base { public: ~derived();};
                               int main() { return 0; }"
                              CXX_WONT_WARN_ON_FINAL_NONVIRTUALDTOR)
    set(CMAKE_REQUIRED_FLAGS ${OLD_CMAKE_REQUIRED_FLAGS})
    append_if(CXX_WONT_WARN_ON_FINAL_NONVIRTUALDTOR
              "-Wnon-virtual-dtor" CMAKE_CXX_FLAGS)
  endif()

  # Enable -Wdelete-non-virtual-dtor if available.
  add_flag_if_supported("-Wdelete-non-virtual-dtor" DELETE_NON_VIRTUAL_DTOR_FLAG)

  # Check if -Wcomment is OK with an // comment ending with '\' if the next
  # line is also a // comment.
  set(OLD_CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS})
  set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -Werror -Wcomment")
  CHECK_C_SOURCE_COMPILES("// \\\\\\n//\\nint main() {return 0;}"
                          C_WCOMMENT_ALLOWS_LINE_WRAP)
  set(CMAKE_REQUIRED_FLAGS ${OLD_CMAKE_REQUIRED_FLAGS})
  if (NOT C_WCOMMENT_ALLOWS_LINE_WRAP)
    append("-Wno-comment" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif()

  # Enable -Wstring-conversion to catch misuse of string literals.
  add_flag_if_supported("-Wstring-conversion" STRING_CONVERSION_FLAG)
endif (LLVM_ENABLE_WARNINGS AND (LLVM_COMPILER_IS_GCC_COMPATIBLE OR CLANG_CL))

if (LLVM_COMPILER_IS_GCC_COMPATIBLE AND NOT LLVM_ENABLE_WARNINGS)
  append("-w" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
endif()

macro(append_common_sanitizer_flags)
  if (NOT MSVC)
    # Append -fno-omit-frame-pointer and turn on debug info to get better
    # stack traces.
    add_flag_if_supported("-fno-omit-frame-pointer" FNO_OMIT_FRAME_POINTER)
    if (NOT uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG" AND
        NOT uppercase_CMAKE_BUILD_TYPE STREQUAL "RELWITHDEBINFO")
      add_flag_if_supported("-gline-tables-only" GLINE_TABLES_ONLY)
    endif()
    # Use -O1 even in debug mode, otherwise sanitizers slowdown is too large.
    if (uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG")
      add_flag_if_supported("-O1" O1)
    endif()
  elseif (CLANG_CL)
    # Keep frame pointers around.
    append("/Oy-" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    if (LINKER_IS_LLD_LINK)
      # Use DWARF debug info with LLD.
      append("-gdwarf" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    else()
      # Enable codeview otherwise.
      append("/Z7" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    endif()
    # Always ask the linker to produce symbols with asan.
    append("-debug" CMAKE_EXE_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  endif()
endmacro()

# Turn on sanitizers if necessary.
if(LLVM_USE_SANITIZER)
  if (LLVM_ON_UNIX)
    if (LLVM_USE_SANITIZER STREQUAL "Address")
      append_common_sanitizer_flags()
      append("-fsanitize=address" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    elseif (LLVM_USE_SANITIZER MATCHES "Memory(WithOrigins)?")
      append_common_sanitizer_flags()
      append("-fsanitize=memory" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      if(LLVM_USE_SANITIZER STREQUAL "MemoryWithOrigins")
        append("-fsanitize-memory-track-origins" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      endif()
    elseif (LLVM_USE_SANITIZER STREQUAL "Undefined")
      append_common_sanitizer_flags()
      append("-fsanitize=undefined -fno-sanitize=vptr,function -fno-sanitize-recover=all"
              CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      set(BLACKLIST_FILE "${CMAKE_SOURCE_DIR}/utils/sanitizers/ubsan_blacklist.txt")
      if (EXISTS "${BLACKLIST_FILE}")
        append("-fsanitize-blacklist=${BLACKLIST_FILE}"
	              CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
      endif()
    elseif (LLVM_USE_SANITIZER STREQUAL "Thread")
      append_common_sanitizer_flags()
      append("-fsanitize=thread" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    elseif (LLVM_USE_SANITIZER STREQUAL "Address;Undefined" OR
            LLVM_USE_SANITIZER STREQUAL "Undefined;Address")
      append_common_sanitizer_flags()
      append("-fsanitize=address,undefined -fno-sanitize=vptr,function -fno-sanitize-recover=all"
              CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    else()
      message(FATAL_ERROR "Unsupported value of LLVM_USE_SANITIZER: ${LLVM_USE_SANITIZER}")
    endif()
  elseif(MSVC)
    if (LLVM_USE_SANITIZER STREQUAL "Address")
      append_common_sanitizer_flags()
      append("-fsanitize=address" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    else()
      message(FATAL_ERROR "This sanitizer not yet supported in the MSVC environment: ${LLVM_USE_SANITIZER}")
    endif()
  else()
    message(FATAL_ERROR "LLVM_USE_SANITIZER is not supported on this platform.")
  endif()
  if (LLVM_USE_SANITIZER MATCHES "(Undefined;)?Address(;Undefined)?")
    add_flag_if_supported("-fsanitize-address-use-after-scope"
                          FSANITIZE_USE_AFTER_SCOPE_FLAG)
  endif()
  if (LLVM_USE_SANITIZE_COVERAGE)
    append("-fsanitize-coverage=trace-pc-guard,indirect-calls,trace-cmp" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
  endif()
endif()

# Turn on -gsplit-dwarf if requested
if(LLVM_USE_SPLIT_DWARF)
  add_definitions("-gsplit-dwarf")
endif()

add_definitions( -D__STDC_CONSTANT_MACROS )
add_definitions( -D__STDC_FORMAT_MACROS )
add_definitions( -D__STDC_LIMIT_MACROS )

# clang doesn't print colored diagnostics when invoked from Ninja
if (UNIX AND
    CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND
    CMAKE_GENERATOR STREQUAL "Ninja")
  append("-fcolor-diagnostics" CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
endif()

# lld doesn't print colored diagnostics when invoked from Ninja
if (UNIX AND CMAKE_GENERATOR STREQUAL "Ninja")
  include(CheckLinkerFlag)
  check_linker_flag("-Wl,-color-diagnostics" LINKER_SUPPORTS_COLOR_DIAGNOSTICS)
  append_if(LINKER_SUPPORTS_COLOR_DIAGNOSTICS "-Wl,-color-diagnostics"
    CMAKE_EXE_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
endif()

# Add flags for add_dead_strip().
# FIXME: With MSVS, consider compiling with /Gy and linking with /OPT:REF?
# But MinSizeRel seems to add that automatically, so maybe disable these
# flags instead if LLVM_NO_DEAD_STRIP is set.
if(NOT CYGWIN AND NOT WIN32)
  if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Darwin" AND
     NOT uppercase_CMAKE_BUILD_TYPE STREQUAL "DEBUG")
    check_c_compiler_flag("-Werror -fno-function-sections" C_SUPPORTS_FNO_FUNCTION_SECTIONS)
    if (C_SUPPORTS_FNO_FUNCTION_SECTIONS)
      # Don't add -ffunction-section if it can be disabled with -fno-function-sections.
      # Doing so will break sanitizers.
      add_flag_if_supported("-ffunction-sections" FFUNCTION_SECTIONS)
    endif()
    add_flag_if_supported("-fdata-sections" FDATA_SECTIONS)
  endif()
endif()

if(MSVC)
  # Remove flags here, for exceptions and RTTI.
  # Each target property or source property should be responsible to control
  # them.
  # CL.EXE complains to override flags like "/GR /GR-".
  string(REGEX REPLACE "(^| ) */EH[-cs]+ *( |$)" "\\1 \\2" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REGEX REPLACE "(^| ) */GR-? *( |$)" "\\1 \\2" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endif()

# Provide public options to globally control RTTI and EH
option(LLVM_ENABLE_EH "Enable Exception handling" OFF)
option(LLVM_ENABLE_RTTI "Enable run time type information" OFF)
if(LLVM_ENABLE_EH AND NOT LLVM_ENABLE_RTTI)
  message(FATAL_ERROR "Exception handling requires RTTI. You must set LLVM_ENABLE_RTTI to ON")
endif()

option(LLVM_BUILD_INSTRUMENTED "Build LLVM and tools with PGO instrumentation (experimental)" Off)
mark_as_advanced(LLVM_BUILD_INSTRUMENTED)
append_if(LLVM_BUILD_INSTRUMENTED "-fprofile-instr-generate='${LLVM_PROFILE_FILE_PATTERN}'"
  CMAKE_CXX_FLAGS
  CMAKE_C_FLAGS
  CMAKE_EXE_LINKER_FLAGS
  CMAKE_SHARED_LINKER_FLAGS)

option(LLVM_BUILD_INSTRUMENTED_COVERAGE "Build LLVM and tools with Code Coverage instrumentation (experimental)" Off)
mark_as_advanced(LLVM_BUILD_INSTRUMENTED_COVERAGE)
append_if(LLVM_BUILD_INSTRUMENTED_COVERAGE "-fprofile-instr-generate='${LLVM_PROFILE_FILE_PATTERN}' -fcoverage-mapping"
  CMAKE_CXX_FLAGS
  CMAKE_C_FLAGS
  CMAKE_EXE_LINKER_FLAGS
  CMAKE_SHARED_LINKER_FLAGS)

if(LLVM_ENABLE_LTO AND LLVM_ON_WIN32 AND NOT LINKER_IS_LLD_LINK)
  message(FATAL_ERROR "When compiling for Windows, LLVM_ENABLE_LTO requires using lld as the linker (point CMAKE_LINKER at lld-link.exe)")
endif()
if(uppercase_LLVM_ENABLE_LTO STREQUAL "THIN")
  append("-flto=thin" CMAKE_CXX_FLAGS CMAKE_C_FLAGS)
  if(NOT LINKER_IS_LLD_LINK)
    append("-flto=thin" CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  endif()
  # If the linker supports it, enable the lto cache. This improves initial build
  # time a little since we re-link a lot of the same objects, and significantly
  # improves incremental build time.
  # FIXME: We should move all this logic into the clang driver.
  if(APPLE)
    append("-Wl,-cache_path_lto,${PROJECT_BINARY_DIR}/lto.cache"
           CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  elseif(UNIX AND LLVM_USE_LINKER STREQUAL "lld")
    append("-Wl,--thinlto-cache-dir=${PROJECT_BINARY_DIR}/lto.cache"
           CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  elseif(LLVM_USE_LINKER STREQUAL "gold")
    append("-Wl,--plugin-opt,cache-dir=${PROJECT_BINARY_DIR}/lto.cache"
           CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  endif()
elseif(uppercase_LLVM_ENABLE_LTO STREQUAL "FULL")
  append("-flto=full" CMAKE_CXX_FLAGS CMAKE_C_FLAGS)
  if(NOT LINKER_IS_LLD_LINK)
    append("-flto=full" CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  endif()
elseif(LLVM_ENABLE_LTO)
  append("-flto" CMAKE_CXX_FLAGS CMAKE_C_FLAGS)
  if(NOT LINKER_IS_LLD_LINK)
    append("-flto" CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS)
  endif()
endif()

# This option makes utils/extract_symbols.py be used to determine the list of
# symbols to export from LLVM tools. This is necessary when using MSVC if you
# want to allow plugins, though note that the plugin has to explicitly link
# against (exactly one) tool so we can't unilaterally turn on
# LLVM_ENABLE_PLUGINS when it's enabled.
option(LLVM_EXPORT_SYMBOLS_FOR_PLUGINS "Export symbols from LLVM tools so that plugins can import them" OFF)
if(BUILD_SHARED_LIBS AND LLVM_EXPORT_SYMBOLS_FOR_PLUGINS)
  message(FATAL_ERROR "BUILD_SHARED_LIBS not compatible with LLVM_EXPORT_SYMBOLS_FOR_PLUGINS")
endif()
if(LLVM_LINK_LLVM_DYLIB AND LLVM_EXPORT_SYMBOLS_FOR_PLUGINS)
  message(FATAL_ERROR "LLVM_LINK_LLVM_DYLIB not compatible with LLVM_EXPORT_SYMBOLS_FOR_PLUGINS")
endif()

# Plugin support
# FIXME: Make this configurable.
if(WIN32 OR CYGWIN)
  if(BUILD_SHARED_LIBS)
    set(LLVM_ENABLE_PLUGINS ON)
  else()
    set(LLVM_ENABLE_PLUGINS OFF)
  endif()
else()
  set(LLVM_ENABLE_PLUGINS ON)
endif()

function(get_compile_definitions)
  get_directory_property(top_dir_definitions DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS)
  foreach(definition ${top_dir_definitions})
    if(DEFINED result)
      string(APPEND result " -D${definition}")
    else()
      set(result "-D${definition}")
    endif()
  endforeach()
  set(LLVM_DEFINITIONS "${result}" PARENT_SCOPE)
endfunction()
get_compile_definitions()
