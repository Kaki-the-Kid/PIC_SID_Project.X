# $Id: Makefile 382 2014-06-23 17:53:01Z hermitsoft $
AS=64tass
AFLAGS=-C -a
PACKER=exomizer
CBMDISK=c1541
X64=x64
XFLAGS= 
 #-autostartprgmode 1 -autostart-warp
SOURCEDIR=.
BINARYDIR=../application
EXASWMDIR=../demotunes
EXASWIDIR=../instruments
DOCDIR=../manuals
APPNAME1=SID-Wizard
APPVERSION=1.7
APPNAME2=SID-Maker
APPNAME3=SW-$(APPVERSION)-UserManual
DOCNAME1=$(APPNAME1)-$(APPVERSION)-UserManual.pdf
KUSS= > /dev/null

SW-SOURCES=settings.cfg SWM-spec.src include/irq.inc include/startupmenu.inc include/altplayers.inc
SW-SOURCES+=include/displayer1.inc include/player.asm include/playadapter.inc
SW-SOURCES+=include/menu.inc include/packdepack.inc include/commonsubs.inc
SW-SOURCES+=graphics/graphics.inc include/displayer2.inc
SW-SOURCES+=include/keyhandler.inc include/datawriter.inc include/insdelcopy.inc
SW-SOURCES+=graphics/sw-charset.prg graphics/sw-header.prg
SW-SOURCES+=include/midisubs.inc MIDI-C64.asm HerMIDI/HerMIDI-C64.asm
SM-SOURCES=settings.cfg SWM-spec.src include/player.asm include/packdepack.inc
SM-SOURCES+=include/keyhandler.inc include/menu.inc include/altplayers.inc
UM-SOURCES=../manuals/SID-Wizard-$(APPVERSION)-UserManual.txt ../demotunes/sid-exports/flashitback.sid
SWS-SOURCES=graphics/sw-splash-hires.prg
SNG-SOURCES=sng2swm/sng2swm.cpp sng2swm/sng.h sng2swm/swm.h
SW-SOURCE=editor.asm
SM-SOURCE=exporter.asm
UM-SOURCE=usermanual.asm
SWS-SOURCE=$(APPNAME1)-splashed.asm

SW-SPLASH=$(APPNAME1)-$(APPVERSION).prg
SW-EXEC=$(APPNAME1)-nopack.prg
SM-EXEC=$(APPNAME2)-nopack.prg
UM-EXEC=$(APPNAME3)-nopack.prg
SW-PACK=$(APPNAME1)-packed.prg
SM-PACK=$(APPNAME2)-$(APPVERSION).prg
UM-PACK=$(APPNAME3).prg
SW-2SID-SPLASH=$(APPNAME1)-2SID.prg
SW-2SID-EXEC=$(APPNAME1)-2SID-nopack.prg
SM-2SID-EXEC=$(APPNAME2)-2SID-nopack.prg
SW-2SID-PACK=$(APPNAME1)-2SID-packed.prg
SM-2SID-PACK=$(APPNAME2)-2SID.prg
SW-3SID-SPLASH=$(APPNAME1)-3SID.prg
SW-3SID-EXEC=$(APPNAME1)-3SID-nopack.prg
SM-3SID-EXEC=$(APPNAME2)-3SID-nopack.prg
SW-3SID-PACK=$(APPNAME1)-3SID-packed.prg
SM-3SID-PACK=$(APPNAME2)-3SID.prg
SM-SFX-EXEC=$(APPNAME2)-SFX-nopack.prg
SM-SFX-PACK=$(APPNAME2)-SFX.prg
SM-SWP-EXEC=$(APPNAME2)-SWP-nopack.prg
SM-SWP-PACK=$(APPNAME2)-SWP.prg
SWM-CONVERTER=SWMconvert
SNG-CONVERTER=sng2swm

CP?=cp -f
MD=mkdir
ICON=SID-Wizard.png
MENUENTRY=SID-Wizard.desktop
CC=gcc
CPPC=g++
APPDIR=/usr/local/bin
#APPDIR2=/usr/local/apps/$(APPNAME1)
APPDIR3=/opt/$(APPNAME1)
ICONDIR=/usr/share/icons
DESKDIR=/usr/share/applications
SW-ICON=SW-icon-32x32.png

all: $(BINARYDIR)/$(SW-SPLASH) $(BINARYDIR)/$(SM-PACK) $(BINARYDIR)/$(SM-SFX-PACK) $(BINARYDIR)/$(SM-SWP-PACK) $(BINARYDIR)/$(UM-PACK) 2SID 3SID $(BINARYDIR)/$(SWM-CONVERTER) $(BINARYDIR)/$(SNG-CONVERTER) \
     Conversion-Examples $(BINARYDIR)/$(APPNAME1)-$(APPVERSION)-disk.d64 $(BINARYDIR)/$(APPNAME1)-instruments.d64
.PHONY: all clean install editor exporter 2SID 3SID
.INTERMEDIATE: $(BINARYDIR)/$(SW-PACK) $(BINARYDIR)/$(SW-EXEC) $(BINARYDIR)/$(SM-EXEC) $(BINARYDIR)/$(SM-SFX-EXEC) $(BINARYDIR)/$(SM-SWP-EXEC) $(BINARYDIR)/$(UM-EXEC) \
                $(BINARYDIR)/$(SW-2SID-PACK) $(BINARYDIR)/$(SW-2SID-EXEC) $(BINARYDIR)/$(SM-2SID-EXEC) \
                $(BINARYDIR)/$(SW-3SID-PACK) $(BINARYDIR)/$(SW-3SID-EXEC) $(BINARYDIR)/$(SM-3SID-EXEC)
.INTERMEDIATE: editor.prg exporter.prg

#C64 executables
$(BINARYDIR)/$(SW-SPLASH): $(SWS-SOURCE) $(BINARYDIR)/$(SW-PACK) $(SWS-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -o $@ $<
$(BINARYDIR)/$(SW-PACK): $(BINARYDIR)/$(SW-EXEC)
	$(PACKER) sfx sys -q -o $@ $<
$(BINARYDIR)/$(SW-EXEC): $(SW-SOURCE) $(SW-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(SM-PACK): $(BINARYDIR)/$(SM-EXEC)
	$(PACKER) sfx sys -q -o $@ $<
$(BINARYDIR)/$(SM-EXEC): $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SFX_SUPPORT=0 -D SLOWDOWN_SUPP=0 -D SWP_EXPORT=0 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(SM-SFX-PACK): $(BINARYDIR)/$(SM-SFX-EXEC)
	$(PACKER) sfx sys -q -o $@ $<
$(BINARYDIR)/$(SM-SFX-EXEC): $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SFX_SUPPORT=1 -D SLOWDOWN_SUPP=0 -D SWP_EXPORT=0 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(SM-SWP-PACK): $(BINARYDIR)/$(SM-SWP-EXEC)
	$(PACKER) sfx sys -q -o $@ $<
$(BINARYDIR)/$(SM-SWP-EXEC): $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SFX_SUPPORT=1 -D SLOWDOWN_SUPP=1 -D SWP_EXPORT=1 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(UM-PACK): $(BINARYDIR)/$(UM-EXEC)
	$(PACKER) sfx sys -q -o $@ $<
$(BINARYDIR)/$(UM-EXEC): $(UM-SOURCE) $(UM-SOURCES) $
	$(AS) $(AFLAGS) -o $@ $<

#C64 2SID-variant executables
$(BINARYDIR)/$(SW-2SID-SPLASH): $(SWS-SOURCE) $(BINARYDIR)/$(SW-2SID-PACK) $(SWS-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=2 -o $@ $<

$(BINARYDIR)/$(SW-2SID-PACK): $(BINARYDIR)/$(SW-2SID-EXEC)
	$(PACKER) sfx sys -q -o $@ $<

$(BINARYDIR)/$(SW-2SID-EXEC): $(SW-SOURCE) $(SW-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=2 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(SM-2SID-PACK): $(BINARYDIR)/$(SM-2SID-EXEC)
	$(PACKER) sfx sys -q -o $@ $<

$(BINARYDIR)/$(SM-2SID-EXEC): $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=2 -D SFX_SUPPORT=0 -D SLOWDOWN_SUPP=0 -D SWP_EXPORT=0 -D SWversion="'$(APPVERSION)'" -o $@ $<

2SID: $(BINARYDIR)/$(SW-2SID-SPLASH) $(BINARYDIR)/$(SM-2SID-PACK)

#C64 3SID-variant executables
$(BINARYDIR)/$(SW-3SID-SPLASH): $(SWS-SOURCE) $(BINARYDIR)/$(SW-3SID-PACK) $(SWS-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=3 -o $@ $<

$(BINARYDIR)/$(SW-3SID-PACK): $(BINARYDIR)/$(SW-3SID-EXEC)
	$(PACKER) sfx sys -q -o $@ $<

$(BINARYDIR)/$(SW-3SID-EXEC): $(SW-SOURCE) $(SW-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=3 -D SWversion="'$(APPVERSION)'" -o $@ $<

$(BINARYDIR)/$(SM-3SID-PACK): $(BINARYDIR)/$(SM-3SID-EXEC)
	$(PACKER) sfx sys -q -o $@ $<

$(BINARYDIR)/$(SM-3SID-EXEC): $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=3 -D SFX_SUPPORT=0 -D SLOWDOWN_SUPP=0 -D SWP_EXPORT=0 -D SWversion="'$(APPVERSION)'" -o $@ $<

3SID: $(BINARYDIR)/$(SW-3SID-SPLASH) $(BINARYDIR)/$(SM-3SID-PACK)

#SWMconvert
.IGNORE:
$(BINARYDIR)/$(SWM-CONVERTER): $(SWM-CONVERTER).c SWM-spec.src
	$(CC) -w $< -o $@ -lm -s
	wine gcc.exe -w $< -o "$@.exe" -lm -s
.IGNORE = $(NULL)

#sng2swm
.IGNORE:
$(BINARYDIR)/$(SNG-CONVERTER): $(SNG-CONVERTER)/$(SNG-CONVERTER).cpp $(SNG-SOURCES) 
	$(CPPC) $< -o $@ -lm -s
	wine g++.exe $< -s -o "$@.exe" -lm -s
.IGNORE = $(NULL)

#generate XM/MID exports and import example XM/MID/SNG files
.IGNORE:
Conversion-Examples: $(BINARYDIR)/$(SWM-CONVERTER) $(BINARYDIR)/$(SNG-CONVERTER) $(EXASWMDIR)/
	for inputfile in $(EXASWMDIR)/*.swm.prg ; do outputfile=$${inputfile##*/} ; \
         $(BINARYDIR)/$(SWM-CONVERTER) $$inputfile $(EXASWMDIR)/xm-exports/$${outputfile%.*}.xm $(KUSS) ; done ;
	for inputfile in $(EXASWMDIR)/*.swm.prg ; do outputfile=$${inputfile##*/} ; \
         $(BINARYDIR)/$(SWM-CONVERTER) $$inputfile $(EXASWMDIR)/mid-exports/$${outputfile%.*}.mid $(KUSS) ; done ;
	for inputfile in $(EXASWMDIR)/xm-imports/*.xm ; do $(BINARYDIR)/$(SWM-CONVERTER) $$inputfile $${inputfile%.*}.swm.prg $(KUSS) ; done ;
	for inputfile in $(EXASWMDIR)/mid-imports/*.mid ; do $(BINARYDIR)/$(SWM-CONVERTER) $$inputfile $${inputfile%.*}.swm.prg $(KUSS) ; done ;
	for inputfile in $(EXASWMDIR)/sng-imports/*.sng ; do $(BINARYDIR)/$(SNG-CONVERTER) $$inputfile $${inputfile%.*}.swm.prg $(KUSS) ; done ;
	for inputfile in $(EXASWMDIR)/sng-imports/*.sng ; do $(BINARYDIR)/$(SNG-CONVERTER) $$inputfile $${inputfile%.*}.swm $(KUSS) ; done ;
.IGNORE = $(NULL)

#SID-Wizard disk
$(BINARYDIR)/$(APPNAME1)-$(APPVERSION)-disk.d64: $(BINARYDIR)/$(SW-SPLASH) $(BINARYDIR)/$(SM-PACK) $(BINARYDIR)/$(SW-2SID-SPLASH) $(BINARYDIR)/$(SM-2SID-PACK) $(BINARYDIR)/$(UM-PACK) $(EXASWMDIR)/ $(EXASWMDIR)/sng-imports/
	$(CBMDISK) -format "sid-wizard $(APPVERSION),sw" d64 $@
	$(CBMDISK) -attach $@ -write $(BINARYDIR)/$(SW-SPLASH) sid-wizard-$(APPVERSION)
	$(CBMDISK) -attach $@ -write $(BINARYDIR)/$(SM-PACK) sid-maker-$(APPVERSION)
	$(CBMDISK) -attach $@ -write $(BINARYDIR)/$(SW-2SID-SPLASH) sid-wizard-2sid
	$(CBMDISK) -attach $@ -write $(BINARYDIR)/$(SM-2SID-PACK) sid-maker-2sid
	$(CBMDISK) -attach $@ -write $(BINARYDIR)/$(UM-PACK) sw-$(APPVERSION)-manual
	$(CBMDISK) -attach $@ -write ./dummyfile CCCCCCCCCCCCCCCC
	for inputfile in $(EXASWMDIR)/*.swm.prg ; do outputfile=$${inputfile##*/} ; \
         $(CBMDISK) -attach $@ -write $$inputfile $${outputfile%.*} ; done;
	$(CBMDISK) -attach $@ -write ./dummyfile "CCCsng-importCCC"
	for inputfile in $(EXASWMDIR)/sng-imports/*.swm.prg ; do outputfile=$${inputfile##*/} ; \
         $(CBMDISK) -attach $@ -write $$inputfile $${outputfile%.*} ; done;
	$(CBMDISK) -attach $@ -write ./dummyfile "CCCCCstereoCCCCC"
	for inputfile in $(EXASWMDIR)/2SID-tunes/*.sws.prg ; do outputfile=$${inputfile##*/} ; \
         $(CBMDISK) -attach $@ -write $$inputfile $${outputfile%.*} ; done;

#SID-Wizard instrument-disk
$(BINARYDIR)/$(APPNAME1)-instruments.d64: $(EXASWIDIR)/
	$(CBMDISK) -format "sw$(APPVERSION)-instrument,sw" d64 $@
	for inputfile in $(EXASWIDIR)/*.swi ; do outputfile=$${inputfile##*/} ; \
         $(CBMDISK) -attach $(BINARYDIR)/$(APPNAME1)-instruments.d64 -write $$inputfile $${outputfile} $(KUSS) ; done;

#for test builds
editor: editor.prg
	$(X64) $(XFLAGS) $<

editor.prg: $(SW-SOURCE) $(SW-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SWversion="'$(APPVERSION)'" -o $@ $<

exporter: exporter.prg
	$(X64) $(XFLAGS) $<

exporter.prg: $(SM-SOURCE) $(SM-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -D SFX_SUPPORT=1 -D SLOWDOWN_SUPP=1 -D SWP_EXPORT=0 -D SWversion="'$(APPVERSION)'" -o $@ $<

SID-Wizard-splashed: SID-Wizard-splashed.prg
	$(X64) $(XFLAGS) $<

SID-Wizard-splashed.prg: $(SWS-SOURCE) $(SWS-SOURCES)
	$(AS) $(AFLAGS) -D SID_AMOUNT=1 -o $@ $<


clean:
	$(RM) $(BINARYDIR)/$(SW-SPLASH) $(BINARYDIR)/$(SW-2SID-SPLASH) $(BINARYDIR)/$(SW-3SID-SPLASH)
	$(RM) $(BINARYDIR)/$(SW-PACK) $(BINARYDIR)/$(SW-EXEC) $(BINARYDIR)/$(SM-PACK) $(BINARYDIR)/$(UM-PACK) $(BINARYDIR)/$(SM-EXEC) $(BINARYDIR)/$(UM-EXEC)
	$(RM) $(BINARYDIR)/$(SW-2SID-EXEC) $(BINARYDIR)/$(SW-2SID-PACK) $(BINARYDIR)/$(SM-2SID-EXEC) $(BINARYDIR)/$(SM-2SID-PACK)
	$(RM) $(BINARYDIR)/$(SW-3SID-EXEC) $(BINARYDIR)/$(SW-3SID-PACK) $(BINARYDIR)/$(SM-3SID-EXEC) $(BINARYDIR)/$(SM-3SID-PACK)
	$(RM) $(BINARYDIR)/$(SM-SFX-PACK) $(BINARYDIR)/$(SM-SWP-PACK)
	$(RM) $(BINARYDIR)/$(APPNAME1)-$(APPVERSION)-disk.d64 $(BINARYDIR)/$(APPNAME1)-instruments.d64
	$(RM) $(BINARYDIR)/$(SWM-CONVERTER) $(BINARYDIR)/$(SNG-CONVERTER)
	$(RM) $(BINARYDIR)/$(SWM-CONVERTER).exe $(BINARYDIR)/$(SNG-CONVERTER).exe
	$(RM) $(EXASWMDIR)/xm-exports/*.xm $(EXASWMDIR)/mid-exports/*.mid
	$(RM) $(EXASWMDIR)/xm-imports/*.swm.prg $(EXASWMDIR)/xm-imports/*.swm.P00 $(EXASWMDIR)/mid-imports/*.swm.prg $(EXASWMDIR)/mid-imports/*.swm.P00
	$(RM) $(EXASWMDIR)/sng-imports/*.swm.prg $(EXASWMDIR)/sng-imports/*.swm
	$(RM) editor.prg exporter.prg SID-Wizard-splashed.prg


install: 
	$(CP) $(BINARYDIR)/$(SWM-CONVERTER) $(APPDIR)/
	$(CP) $(BINARYDIR)/$(SNG-CONVERTER) $(APPDIR)/
#Create application-entry and folder for SID-Wizard for easy access on Linux
	$(CP) $(APPNAME1).desktop $(DESKDIR)/
	$(CP) ./graphics/$(SW-ICON) $(ICONDIR)/
	$(MD) -p $(APPDIR3)
	$(CP) $(BINARYDIR)/$(SW-SPLASH) $(APPDIR3)/
	$(CP) $(BINARYDIR)/$(SM-PACK) $(APPDIR3)/
	$(CP) $(BINARYDIR)/$(SW-2SID-SPLASH) $(APPDIR3)/
	$(CP) $(BINARYDIR)/$(SM-2SID-PACK) $(APPDIR3)/
	$(CP) $(BINARYDIR)/$(SW-3SID-SPLASH) $(APPDIR3)/
	$(CP) $(BINARYDIR)/$(SM-3SID-PACK) $(APPDIR3)/
	$(CP) $(DOCDIR)/$(DOCNAME1) $(APPDIR3)/
	for filename in $(EXASWIDIR)/*.swi ; do $(CP) $$filename $(APPDIR3)/ ; done;
	for filename in $(EXASWMDIR)/*.swm.prg; do onlyname=$${filename##*/} ; $(CP) $$filename $(APPDIR3)/$${onlyname%.*} ; done;
	for filename in $(EXASWMDIR)/2SID-tunes/*.sws ; do $(CP) $$filename $(APPDIR3)/ ; done;

uninstall:
	$(RM) $(DESKDIR)/$(APPNAME1).desktop $(ICONDIR)/$(SW-ICON)
	$(RM) $(APPDIR)/$(SWM-CONVERTER) $(APPDIR)/$(SNG-CONVERTER) 
	$(RM) $(APPDIR3)/$(SW-SPLASH) $(APPDIR3)/$(SM-PACK)
	$(RM) $(APPDIR3)/$(SW-2SID-SPLASH) $(APPDIR3)/$(SM-2SID-PACK) 
	$(RM) $(APPDIR3)/$(SW-3SID-SPLASH) $(APPDIR3)/$(SM-3SID-PACK) 
	$(RM) $(APPDIR3)/$(DOCNAME1)
#	$(RM) -rf $(APPDIR3)/  #not recommended to delete the whole folder as user can have workfiles there


#========================================================================================================
