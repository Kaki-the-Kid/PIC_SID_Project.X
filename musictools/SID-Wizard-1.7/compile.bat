rem ------- SID-Wizard compilation script --------

@ECHO OFF

set AS=64tass.exe
set AFLAGS=-C -a
set PACKER=exomizer.exe
set CBMDISK=c1541.exe
set SOURCEDIR=.\sources
set BINARYDIR=..\application
set EXASWMDIR=..\demotunes
set EXASWIDIR=..\instruments
set APPVERSION=1.7
set APPNAME1=SID-Wizard
set APPNAME2=SID-Maker
set APPNAME3=SW-%APPVERSION%-UserManual

set SW-SOURCE=editor.asm
set SM-SOURCE=exporter.asm
set UM-SOURCE=usermanual.asm
set SW-SPLASH-SOURCE=%APPNAME1%-splashed.asm

set SW-SPLASH=%APPNAME1%-%APPVERSION%.prg
set NOPACKTAIL=nopack.prg
set PACKEDTAIL=packed.prg
set SW-EXEC=%APPNAME1%-%NOPACKTAIL%
set SM-EXEC=%APPNAME2%-%NOPACKTAIL%
set SM-SFX-EXEC=%APPNAME2%-SFX-%NOPACKTAIL%
set UM-EXEC=%APPNAME3%-%NOPACKTAIL%
set SW-PACK=%APPNAME1%-%PACKEDTAIL%
set SM-PACK=%APPNAME2%-%APPVERSION%.prg
set SM-SFX-PACK=%APPNAME2%-SFX.prg
set UM-PACK=%APPNAME3%.prg
set SW-2SID-SPLASH=%APPNAME1%-2SID.prg
set SW-2SID-EXEC=%APPNAME1%-2SID-%NOPACKTAIL%
set SM-2SID-EXEC=%APPNAME2%-2SID-%NOPACKTAIL%
set SW-2SID-PACK=%APPNAME1%-2SID-%PACKEDTAIL%
set SM-2SID-PACK=%APPNAME2%-2SID.prg

set SWM-CONVERTER=SWMconvert
set SNG-CONVERTER=sng2swm

set CCOMPILER=gcc.exe
set CPPCOMPILER=g++.exe
set RM=del
set APPDIR=C:\Windows

@ECHO ON

cd %SOURCEDIR%

rem -------- normal version -------------
%AS% %AFLAGS% -D SID_AMOUNT=1 -D SWversion="'%APPVERSION%'" -o %BINARYDIR%\%SW-EXEC% %SW-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%SW-PACK% %BINARYDIR%\%SW-EXEC% 
%AS% %AFLAGS% -D SID_AMOUNT=1 -o %BINARYDIR%\%SW-SPLASH% %SW-SPLASH-SOURCE%

%AS% %AFLAGS% -D SID_AMOUNT=1 -D SFX_SUPPORT=0 -D SWversion="'%APPVERSION%'" -o %BINARYDIR%\%SM-EXEC% %SM-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%SM-PACK% %BINARYDIR%\%SM-EXEC% 

%AS% %AFLAGS% -D SID_AMOUNT=1 -D SFX_SUPPORT=1 -D SWversion="'%APPVERSION%'" -o %BINARYDIR%\%SM-SFX-EXEC% %SM-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%SM-SFX-PACK% %BINARYDIR%\%SM-SFX-EXEC% 

%AS% %AFLAGS% -o %BINARYDIR%\%UM-EXEC% %UM-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%UM-PACK% %BINARYDIR%\%UM-EXEC% 

rem -------- 2SID version
%AS% %AFLAGS% -D SID_AMOUNT=2 -D SWversion="'%APPVERSION%'" -o %BINARYDIR%\%SW-2SID-EXEC% %SW-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%SW-2SID-PACK% %BINARYDIR%\%SW-2SID-EXEC% 
%AS% %AFLAGS% -D SID_AMOUNT=2 -o %BINARYDIR%\%SW-2SID-SPLASH% %SW-SPLASH-SOURCE%

%AS% %AFLAGS% -D SID_AMOUNT=2 -D SFX_SUPPORT=0 -D SWversion="'%APPVERSION%'" -o %BINARYDIR%\%SM-2SID-EXEC% %SM-SOURCE%
%PACKER% sfx sys -q -o %BINARYDIR%\%SM-2SID-PACK% %BINARYDIR%\%SM-2SID-EXEC% 

rem -------- clean intermediate binaries ---------------------------
%RM% %BINARYDIR%\*%NOPACKTAIL%
%RM% %BINARYDIR%\*%PACKEDTAIL%


rem -------- compile SWM-converter and copy to system-dir. ---------------------------------
cd %SOURCEDIR%
%CCOMPILER% -m32 -w %SWM-CONVERTER%.c -o %BINARYDIR%\%SWM-CONVERTER%.exe -lm
COPY %BINARYDIR%\%SWM-CONVERTER%.exe %APPDIR% /Y

rem -------- compile sng (Goattracker) music converter (importer) and copy to system-dir. ---------
%CPPCOMPILER% -m32 -s %SNG-CONVERTER%\%SNG-CONVERTER%.cpp -o %BINARYDIR%\%SNG-CONVERTER%.exe -lm
COPY %BINARYDIR%\%SNG-CONVERTER%.exe %APPDIR% /Y

rem ---- generate XM/MID exports and import example XM/MID/SNG files -----
@ECHO OFF
for %%i in (%EXASWMDIR%\*.swm.prg) do ( %SWM-CONVERTER% %EXASWMDIR%\%%i %EXASWMDIR%\xm-exports\%%~ni.xm > nul )
for %%i in (%EXASWMDIR%\*.swm.prg) do ( %SWM-CONVERTER% %EXASWMDIR%\%%i %EXASWMDIR%\mid-exports\%%~ni.mid > nul )
for %%i in (%EXASWMDIR%\xm-imports\*.xm) do ( %SWM-CONVERTER% %EXASWMDIR%\xm-imports\%%i %EXASWMDIR%\xm-imports\%%~ni.swm.prg > nul )
for %%i in (%EXASWMDIR%\mid-imports\*.mid) do ( %SWM-CONVERTER% %EXASWMDIR%\mid-imports\%%i %EXASWMDIR%\mid-imports\%%~ni.swm.prg > nul )
for %%i in (%EXASWMDIR%\sng-imports\*.sng) do ( %SNG-CONVERTER% %EXASWMDIR%\sng-imports\%%i %EXASWMDIR%\sng-imports\%%~ni.swm.prg > nul )
for %%i in (%EXASWMDIR%\sng-imports\*.sng) do ( %SNG-CONVERTER% %EXASWMDIR%\sng-imports\%%i %EXASWMDIR%\sng-imports\%%~ni.swm > nul )
@ECHO ON

rem -------- assemble SID-Wizard Disk -----------------------------------
%CBMDISK% -format "sid-wizard disk,sw" d64 %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 > nul

%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %BINARYDIR%\%SW-SPLASH% sid-wizard-%APPVERSION% > nul
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %BINARYDIR%\%SM-PACK% sid-maker-%APPVERSION% > nul
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %BINARYDIR%\%SW-2SID-SPLASH% sid-wizard-2sid > nul
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %BINARYDIR%\%SM-2SID-PACK% sid-maker-2sid > nul
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %BINARYDIR%\%UM-PACK% sw-%APPVERSION%-manual > nul

%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write dummyfile "CCCCCCCCCCCCCCCC" > nul

@ECHO OFF
for %%i in (%EXASWMDIR%\*.swm.prg) do (
 %CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %EXASWMDIR%\%%i %%~ni > nul
)
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write dummyfile "CCCsng-importCCC" > nul
for %%i in (%EXASWMDIR%\sng-imports\*.swm.prg) do (
 %CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %EXASWMDIR%\sng-imports\%%i %%~ni > nul
)
%CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write dummyfile "CCCCCstereoCCCCC" > nul
for %%i in (%EXASWMDIR%\2SID-tunes\*.sws.prg) do (
 %CBMDISK% -attach %BINARYDIR%\%APPNAME1%-%APPVERSION%-disk.d64 -write %EXASWMDIR%\2SID-tunes\%%i %%~ni > nul
)
@ECHO ON

rem ------- assemble SID-Wizard instrument Disk ------------------------
%CBMDISK% -format "swiz.instruments,sw" d64 %BINARYDIR%\%APPNAME1%-instruments.d64 > nul

@ECHO OFF
for %%i in (%EXASWIDIR%\*.swi) do (
 %CBMDISK% -attach %BINARYDIR%\%APPNAME1%-instruments.d64 -write %EXASWIDIR%\%%i %%i > nul
)
@ECHO ON

cd ..
