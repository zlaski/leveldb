@echo off
cd /d "%~dp0"

pskill -t devenv

if not exist snappy (
    git submodule update --init
)

pushd snappy

if not exist third_party (
    git submodule update --init
)

echo.
echo ========================== snappy
echo.

if exist msvc (
    echo To rebuild, delete the %CD%\msvc directory
)

if not exist msvc (
    mkdir msvc
    pushd msvc
    cmake -G "Visual Studio 17" -A Win32 --log-level=VERBOSE ..
    msbuild snappy.sln  /p:Configuration=Debug
    popd
)
popd
if errorlevel 1 goto :eof

echo.
echo ========================== zstd
echo.

pushd zstd

if exist msvc (
    echo To rebuild, delete the %CD%\msvc directory
)

if not exist msvc (
    mkdir msvc
    pushd msvc
    cmake -G "Visual Studio 17" -A Win32 --log-level=VERBOSE ..\build\cmake
    msbuild zstd.sln  /p:Configuration=Debug
    popd
)    
popd
if errorlevel 1 goto :eof

echo.
echo ========================== leveldb
echo.

if exist msvc (
    echo To rebuild, delete the %CD%\msvc directory
)

if not exist msvc (
    set "MAKE_FLAGS=/I..\snappy /I..\snappy\msvc /I..\zstd\lib /DHAVE_SNAPPY /DHAVE_ZSTD" 
    rem  /link ..\snappy\msvc\Debug\snappy.lib ..\zstd\msvc\lib\Debug\zstd_static.lib
    mkdir msvc
    pushd msvc
    cmake -G "Visual Studio 17" -A Win32 -DCMAKE_C_FLAGS="%MAKE_FLAGS%" -DCMAKE_CXX_FLAGS="%MAKE_FLAGS%" ..
    msbuild leveldb.sln  /p:Configuration=Debug
    popd
)
if errorlevel 1 goto :eof

echo.
echo.
echo Run 'start msvc\leveldb.sln'
echo.
