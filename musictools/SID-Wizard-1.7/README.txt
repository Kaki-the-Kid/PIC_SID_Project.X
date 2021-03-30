;===============================================================================
;--- SID-WIZARD --- A native C64 music editor (tracker) tool
;-------------------------------------------------------------------------------
;2014 Hermit Software (Mihaly Horvath) - with much help from Soci of Singular Crew
;-------------------------------------------------------------------------------

The complete User Manual can be found in 'manuals' folder. The most recent version is
'SID-Wizard-1.7-UserManual.pdf'. It's in size A5, you can print it on A4 papers
with 2sided booklet-printing mode to save paper. (It might come handy later.)

The latest Japanese translation is found here:
http://csdb.dk/release/?id=126819

Also, don't forget to check out WitchMaster's perfect book inside 'manuals' folder.

You can find all executables in 'application' directory, including a d64 with all.
If there's no binary or you want to re-compile all the .prg and .d64 files,
here are the fastest options:


A. Assemble/compile/install in linux: 
----------------------------------------------
 0.Prerequisites:
  -64tass V1.51 R624 (minimum) in system-directory* to compile .asm and .inc source files
  -exomizer packer in system-directory* to compress the compiled binaries
  -c1541 in system-directory* to create .d64 diskimages via program and examples
   (it is part of VICE, while x64 is the emulator executable but not necessary)
  *system directory /usr/local/bin might be a good option for Linux
  -gcc, g++, make (should be in the system-path, part of 'build-essential' .deb package)
  -(Wine and MinGW or Dev-Cpp with wine-paths set to generate Win. binaries too)

 1. Go to command-line (bash), and step into this directory 
    containing this README.txt

 2. Type 'sh compile.sh' and sources will be compiled into 'application' directory.
    (And the SWMconvert executable will be copied to system directory too.)
    (Note: compile.sh uses 'make' the 'Makefile' present in 'sources' directory)

B. Assemble/compile/install in Windows:
--------------------------------------
 0.Prerequisities: 
  -The same as for Unix, but of course the .exe versions of the mentioned 
   applications: 64tass.exe (1.51 rev.624), exomizer.exe, c1541.exe 
   (*any directory is good if it's 'PATH'-ed in 'environment variables' section)
   an option could be 'C:\Windows'
  -gcc (should be in the system-path, or in a 'PATH-ed' directory - *:see help below)

 1. Go to command-line (cmd.exe), and step into this directory 
    (containing this README.txt)

 2. Type 'compile.bat' , and all sources will be compiled to 'application' directory.
    (And the SWMconvert.exe will be copied to system directory as well.)

C. Assemble/compile with 'make' directly:
----------------------------------------
 There is also a 'Makefile' present in the 'sources' directory...
 Possibly this won't be needed, but in case you need 'make' way of compiling,
 go to the 'sources' directory in shell, and simply type 'make' to create the 
 binaries into 'application' directory (one level upper in file-tree).
 
 -'make clean' : will purge all the binary/tune files created by 'make'.)
 
 -'make install' : the SWMconvert & sng2swm executables will be copied to /usr/local/bin
  system-resource directory to be executable from anywhere later.
  Also a copy of SID-Wizard, SID-Maker and example tunes & instruments will be
  copied to an '/opt/SID-Wizard' directory, and a desktop/menu entry file
  '/usr/applications/SID-Wizard.desktop' and icon will be created to point to SID-Wizard.
  (Of course 'x64' of VICE-emulator is a prerequisite for this to work.)
 
 -'make uninstall' : typing this in commandline will delete the executable & desktop 
  files that were copied to system-folders by 'make install'. (Instruments & tunes remain)
 
 *To re-compile only 2SID version of SID-Wizard, type 'make 2SID' in command prompt.

;-------------------------------------------------------------------------------
;*** help: To set WINE's PATH environment variable for 'gcc.exe' you should type
;'wine regedit' and append 'HKEY_CURRENT_USER/Environment' with the path like this:
;name: "PATH"  value: "C:\Dev-Cpp\bin"  (or "C:\MingGW\bin"), without double quotes
;
;Graphic-tools: sw-header was painted with SPRedit (.ols format) 
;               sw-splash was finalized in HermIRES (.hbm format)
;
;-------------------------------------------------------------------------------
;The PIC assembler source for the MIDI interface should be compiled separately.
;I used 'gpasm' for Linux, the syntax might be compatible with 'mpasm' as well.
;To design the little HerMIDI PCB I used gEDA's PCB Designer...
;-------------------------------------------------------------------------------
; 2014 Hermit Software Hungary
;===============================================================================
