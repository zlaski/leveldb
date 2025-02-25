@echo off
cd /d "%~dp0"

rmdir /s /q msvc >nul 2>&1
mkdir msvc
cd msvc
cmake -G "Visual Studio 17" -A Win32 --log-level=VERBOSE ..
cd ..
if not errorlevel 1 (
    echo Run 'start msvc\leveldb.sln'
)
