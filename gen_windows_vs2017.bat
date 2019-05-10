if [%BUILD_NUMBER%] == [] (
	echo Local Build
) else (
	echo Jenkins Build %BUILD_NUMBER%
)

set build=Release
if "%~1"=="Debug" set build=Debug

mkdir build_windows
cd build_windows
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

cmake -D CMAKE_VERBOSE_MAKEFILE:BOOL=OFF -D SM_HOME="D:/BL_source/SM" -D THIRD_PARTY="D:/BL_source/third_party" -G "Visual Studio 15 2017 Win64" %* ..
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

cd ..
