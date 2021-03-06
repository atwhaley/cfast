@echo off

set outfile=%temp%\outfile.txt
set countfile=%temp%\countfile.txt

set curdir=%CD%
cd ..\..
set svnroot=%CD%
cd %curdir%

call :is_file_installed svn
if %has_svn% == 0 (
  echo command line svn is not installed
  echo cfastbot setup aborted
  exit /b 1
)

:: create a clean cfast repository (used only by cfastbot)

if NOT exist %userprofile%\cfastclean (
  cd %userprofile%
  echo Initializing %userprofile%\cfastclean.
  echo Initializing the cfastclean repository.
  svn co http://cfast.googlecode.com/svn/trunk/cfast/trunk cfastclean
)

:: create a clean FDS repository (used only by cfastbot)

if NOT exist %userprofile%\FDS-SMVclean (
  cd %userprofile%
  echo Initializing %userprofile%\FDS-SMVclean.
  echo Initializing the FDS-SMVclean repository.
  svn co http://fds-smv.googlecode.com/svn/trunk/FDS/trunk FDS-SMVclean
)

:: create directory where cfastbot is run

if NOT exist %userprofile%\cfastbot (
  cd %userprofile%
  echo Initializing %userprofile%\cfastbot.
  svn co http://cfast.googlecode.com/svn/trunk/cfast/trunk/Utilities/cfastbot cfastbot
)

:: is Intel Fortran installed

call "%svnroot%\scripts\setup_intel_compilers.bat" 1> Nul 2>&1
call :is_file_installed ifort
if "%has_ifort%" == "0" (
  echo Intel Fortran is not installed.
  echo Need to install Intel Fortran before running cfastbot.
)

:: is Intel C installed

call :is_file_installed icl
if "%has_icl%" == "0" (
  echo Intel C/C++ is not installed.
  echo Need to install Intel C/C++ before running cfastbot.
)

echo cfastbot setup complete
goto :eof

:: -------------------------------------------------------------
:is_file_installed
:: -------------------------------------------------------------

  set program=%1
  set arg=has_%program%
  %program%  1> %outfile% 2>&1
  type %outfile% | find /i /c "not recognized" > %countfile%
  set /p nothave=<%countfile%
  if %nothave% == 0 (
    set %arg%=1
    exit /b 1
  )
  set %arg%=0
  exit /b 0

:eof


