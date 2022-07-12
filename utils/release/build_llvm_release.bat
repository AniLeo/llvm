@echo off
setlocal enabledelayedexpansion

if "%1"=="" goto usage
goto begin

:usage
echo Script for building the LLVM installer on Windows,
echo used for the releases at https://github.com/llvm/llvm-project/releases
echo.
echo Usage: build_llvm_release.bat ^<version^>
echo.
echo Example: build_llvm_release.bat 14.0.4
echo.
exit /b

:begin

REM Note:
REM   7zip versions 21.x and higher will try to extract the symlinks in
REM   llvm's git archive, which requires running as administrator.

REM Check 7-zip version and/or administrator permissions.
for /f "delims=" %%i in ('7z.exe ^| findstr /r "2[1-9].[0-9][0-9]"') do set version=%%i
if not "%version%"=="" (
  REM Unique temporary filename to use by the 'mklink' command.
  set "link_name=%temp%\%username%_%random%_%random%.tmp"

  REM As the 'mklink' requires elevated permissions, the symbolic link
  REM creation will fail if the script is not running as administrator.
  mklink /d "!link_name!" . 1>nul 2>nul
  if errorlevel 1 (
    echo.
    echo Script requires administrator permissions, or a 7-zip version 20.x or older.
    echo Current version is "%version%"
    exit /b
  ) else (
    REM Remove the temporary symbolic link.
    rd "!link_name!"
  )
)

REM Prerequisites:
REM
REM   Visual Studio 2019, CMake, Ninja, GNUWin32, SWIG, Python 3,
REM   NSIS with the strlen_8192 patch,
REM   Visual Studio 2019 SDK and Nuget (for the clang-format plugin),
REM   Perl (for the OpenMP run-time).
REM
REM
REM   For LLDB, SWIG version <= 3.0.8 needs to be used to work around
REM   https://github.com/swig/swig/issues/769


REM You need to modify the paths below:
set vsdevcmd=C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\Common7\Tools\VsDevCmd.bat

set python32_dir=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310-32
set python64_dir=C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python310

set revision=llvmorg-%1
set package_version=%1
set build_dir=llvm_package_%package_version%

echo Revision: %revision%
echo Package version: %package_version%
echo Build dir: %build_dir%
echo.
pause

mkdir %build_dir%
cd %build_dir%

echo Checking out %revision%
curl -L https://github.com/llvm/llvm-project/archive/%revision%.zip -o src.zip || exit /b
7z x src.zip || exit /b
mv llvm-project-* llvm-project || exit /b

REM Setting CMAKE_CL_SHOWINCLUDES_PREFIX to work around PR27226.
set cmake_flags=^
  -DCMAKE_BUILD_TYPE=Release ^
  -DLLVM_ENABLE_ASSERTIONS=OFF ^
  -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON ^
  -DLLVM_BUILD_LLVM_C_DYLIB=ON ^
  -DCMAKE_INSTALL_UCRT_LIBRARIES=ON ^
  -DPython3_FIND_REGISTRY=NEVER ^
  -DPACKAGE_VERSION=%package_version% ^
  -DLLDB_RELOCATABLE_PYTHON=1 ^
  -DLLDB_EMBED_PYTHON_HOME=OFF ^
  -DLLDB_TEST_COMPILER=%cd%\build32_stage0\bin\clang.exe ^
  -DCMAKE_CL_SHOWINCLUDES_PREFIX="Note: including file: " ^
  -DLLVM_ENABLE_LIBXML2=FORCE_ON ^
  -DLLDB_ENABLE_LIBXML2=OFF ^
  -DCMAKE_C_FLAGS="-DLIBXML_STATIC" ^
  -DCMAKE_CXX_FLAGS="-DLIBXML_STATIC" ^
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;compiler-rt;lldb;openmp"

REM TODO: Run the "check-all" tests.

set OLDPATH=%PATH%

curl -O https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.9.12/libxml2-v2.9.12.tar.gz || exit /b
tar zxf libxml2-v2.9.12.tar.gz

set "VSCMD_START_DIR=%CD%"
call "%vsdevcmd%" -arch=x86
set PATH=%python32_dir%;%PATH%
set CC=
set CXX=
mkdir build32_stage0
cd build32_stage0

mkdir libxmlbuild
cd libxmlbuild
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install -DBUILD_SHARED_LIBS=OFF -DLIBXML2_WITH_C14N=OFF -DLIBXML2_WITH_CATALOG=OFF -DLIBXML2_WITH_DEBUG=OFF -DLIBXML2_WITH_DOCB=OFF -DLIBXML2_WITH_FTP=OFF -DLIBXML2_WITH_HTML=OFF -DLIBXML2_WITH_HTTP=OFF -DLIBXML2_WITH_ICONV=OFF -DLIBXML2_WITH_ICU=OFF -DLIBXML2_WITH_ISO8859X=OFF -DLIBXML2_WITH_LEGACY=OFF -DLIBXML2_WITH_LZMA=OFF -DLIBXML2_WITH_MEM_DEBUG=OFF -DLIBXML2_WITH_MODULES=OFF -DLIBXML2_WITH_OUTPUT=ON -DLIBXML2_WITH_PATTERN=OFF -DLIBXML2_WITH_PROGRAMS=OFF -DLIBXML2_WITH_PUSH=OFF -DLIBXML2_WITH_PYTHON=OFF -DLIBXML2_WITH_READER=OFF -DLIBXML2_WITH_REGEXPS=OFF -DLIBXML2_WITH_RUN_DEBUG=OFF -DLIBXML2_WITH_SAX1=OFF -DLIBXML2_WITH_SCHEMAS=OFF -DLIBXML2_WITH_SCHEMATRON=OFF -DLIBXML2_WITH_TESTS=OFF -DLIBXML2_WITH_THREADS=ON -DLIBXML2_WITH_THREAD_ALLOC=OFF -DLIBXML2_WITH_TREE=ON -DLIBXML2_WITH_VALID=OFF -DLIBXML2_WITH_WRITER=OFF -DLIBXML2_WITH_XINCLUDE=OFF -DLIBXML2_WITH_XPATH=OFF -DLIBXML2_WITH_XPTR=OFF -DLIBXML2_WITH_ZLIB=OFF ../../libxml2-v2.9.12 || exit /b
ninja install || exit /b
set libxmldir=%cd%\install
set "libxmldir=%libxmldir:\=/%"
cd ..

cmake -GNinja %cmake_flags% -DPYTHON_HOME=%python32_dir% -DPython3_ROOT_DIR=%python32_dir% -DLIBXML2_INCLUDE_DIR=%libxmldir%/include/libxml2 -DLIBXML2_LIBRARIES=%libxmldir%/lib/libxml2s.lib ..\llvm-project\llvm || exit /b

ninja || ninja || ninja || exit /b
REM ninja check-llvm || ninja check-llvm || ninja check-llvm || exit /b
REM ninja check-clang || ninja check-clang || ninja check-clang || exit /b
ninja check-lld || ninja check-lld || ninja check-lld || exit /b
ninja check-sanitizer || ninja check-sanitizer || ninja check-sanitizer || exit /b
REM ninja check-clang-tools || ninja check-clang-tools || ninja check-clang-tools || exit /b
cd..

mkdir build32
cd build32
set CC=..\build32_stage0\bin\clang-cl
set CXX=..\build32_stage0\bin\clang-cl
cmake -GNinja %cmake_flags% -DPYTHON_HOME=%python32_dir% -DPython3_ROOT_DIR=%python32_dir% -DLIBXML2_INCLUDE_DIR=%libxmldir%/include/libxml2 -DLIBXML2_LIBRARIES=%libxmldir%/lib/libxml2s.lib ..\llvm-project\llvm || exit /b
ninja || ninja || ninja || exit /b
REM ninja check-llvm || ninja check-llvm || ninja check-llvm || exit /b
REM ninja check-clang || ninja check-clang || ninja check-clang || exit /b
ninja check-lld || ninja check-lld || ninja check-lld || exit /b
ninja check-sanitizer || ninja check-sanitizer || ninja check-sanitizer || exit /b
REM ninja check-clang-tools || ninja check-clang-tools || ninja check-clang-tools || exit /b
ninja package || exit /b
cd ..

set "VSCMD_START_DIR=%CD%"
set PATH=%OLDPATH%
call "%vsdevcmd%" -arch=amd64
set PATH=%python64_dir%;%PATH%
set CC=
set CXX=
mkdir build64_stage0
cd build64_stage0

mkdir libxmlbuild
cd libxmlbuild
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=install -DBUILD_SHARED_LIBS=OFF -DLIBXML2_WITH_C14N=OFF -DLIBXML2_WITH_CATALOG=OFF -DLIBXML2_WITH_DEBUG=OFF -DLIBXML2_WITH_DOCB=OFF -DLIBXML2_WITH_FTP=OFF -DLIBXML2_WITH_HTML=OFF -DLIBXML2_WITH_HTTP=OFF -DLIBXML2_WITH_ICONV=OFF -DLIBXML2_WITH_ICU=OFF -DLIBXML2_WITH_ISO8859X=OFF -DLIBXML2_WITH_LEGACY=OFF -DLIBXML2_WITH_LZMA=OFF -DLIBXML2_WITH_MEM_DEBUG=OFF -DLIBXML2_WITH_MODULES=OFF -DLIBXML2_WITH_OUTPUT=ON -DLIBXML2_WITH_PATTERN=OFF -DLIBXML2_WITH_PROGRAMS=OFF -DLIBXML2_WITH_PUSH=OFF -DLIBXML2_WITH_PYTHON=OFF -DLIBXML2_WITH_READER=OFF -DLIBXML2_WITH_REGEXPS=OFF -DLIBXML2_WITH_RUN_DEBUG=OFF -DLIBXML2_WITH_SAX1=OFF -DLIBXML2_WITH_SCHEMAS=OFF -DLIBXML2_WITH_SCHEMATRON=OFF -DLIBXML2_WITH_TESTS=OFF -DLIBXML2_WITH_THREADS=ON -DLIBXML2_WITH_THREAD_ALLOC=OFF -DLIBXML2_WITH_TREE=ON -DLIBXML2_WITH_VALID=OFF -DLIBXML2_WITH_WRITER=OFF -DLIBXML2_WITH_XINCLUDE=OFF -DLIBXML2_WITH_XPATH=OFF -DLIBXML2_WITH_XPTR=OFF -DLIBXML2_WITH_ZLIB=OFF ../../libxml2-v2.9.12 || exit /b
ninja install || exit /b
set libxmldir=%cd%\install
set "libxmldir=%libxmldir:\=/%"
cd ..

cmake -GNinja %cmake_flags% -DPYTHON_HOME=%python64_dir% -DPython3_ROOT_DIR=%python64_dir% -DLIBXML2_INCLUDE_DIR=%libxmldir%/include/libxml2 -DLIBXML2_LIBRARIES=%libxmldir%/lib/libxml2s.lib ..\llvm-project\llvm || exit /b
ninja || ninja || ninja || exit /b
ninja check-llvm || ninja check-llvm || ninja check-llvm || exit /b
ninja check-clang || ninja check-clang || ninja check-clang || exit /b
ninja check-lld || ninja check-lld || ninja check-lld || exit /b
ninja check-sanitizer || ninja check-sanitizer || ninja check-sanitizer || exit /b
ninja check-clang-tools || ninja check-clang-tools || ninja check-clang-tools || exit /b
ninja check-clangd || ninja check-clangd || ninja check-clangd || exit /b
cd..

mkdir build64
cd build64
set CC=..\build64_stage0\bin\clang-cl
set CXX=..\build64_stage0\bin\clang-cl
cmake -GNinja %cmake_flags% -DPYTHON_HOME=%python64_dir% -DPython3_ROOT_DIR=%python64_dir% -DLIBXML2_INCLUDE_DIR=%libxmldir%/include/libxml2 -DLIBXML2_LIBRARIES=%libxmldir%/lib/libxml2s.lib ..\llvm-project\llvm || exit /b
ninja || ninja || ninja || exit /b
ninja check-llvm || ninja check-llvm || ninja check-llvm || exit /b
ninja check-clang || ninja check-clang || ninja check-clang || exit /b
ninja check-lld || ninja check-lld || ninja check-lld || exit /b
ninja check-sanitizer || ninja check-sanitizer || ninja check-sanitizer || exit /b
ninja check-clang-tools || ninja check-clang-tools || ninja check-clang-tools || exit /b
ninja check-clangd || ninja check-clangd || ninja check-clangd || exit /b
ninja package || exit /b
cd ..
