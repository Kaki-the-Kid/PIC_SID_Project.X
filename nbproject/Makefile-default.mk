#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=lib/display_i2c_lib/display_i2c_lib.c lib/i2c_lib/i2c_lib.c lib/midi_lib/midi_mapper.c lib/music_lib/music.c lib/sid_lib/sid_pic.c music/hex/mg/melody.asm music/hex/mg/mg.asm music/hex/mg/mg.c music/hex/chipchip.c music/hex/happy.c musictools/happybirthday/happy.c musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c musictools/SID-Wizard-1.7/sources/SWMconvert.c mcc_generated_files/device_config.c mcc_generated_files/mcc.c mcc_generated_files/pin_manager.c mcc_generated_files/tmr2.c mcc_generated_files/interrupt_manager.c mcc_generated_files/eusart1.c mcc_generated_files/tmr4.c mcc_generated_files/tmr6.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 ${OBJECTDIR}/lib/music_lib/music.p1 ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 ${OBJECTDIR}/music/hex/mg/melody.o ${OBJECTDIR}/music/hex/mg/mg.o ${OBJECTDIR}/music/hex/mg/mg.p1 ${OBJECTDIR}/music/hex/chipchip.p1 ${OBJECTDIR}/music/hex/happy.p1 ${OBJECTDIR}/musictools/happybirthday/happy.p1 ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 ${OBJECTDIR}/mcc_generated_files/device_config.p1 ${OBJECTDIR}/mcc_generated_files/mcc.p1 ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 ${OBJECTDIR}/mcc_generated_files/tmr2.p1 ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 ${OBJECTDIR}/mcc_generated_files/eusart1.p1 ${OBJECTDIR}/mcc_generated_files/tmr4.p1 ${OBJECTDIR}/mcc_generated_files/tmr6.p1 ${OBJECTDIR}/main.p1
POSSIBLE_DEPFILES=${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d ${OBJECTDIR}/lib/music_lib/music.p1.d ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d ${OBJECTDIR}/music/hex/mg/melody.o.d ${OBJECTDIR}/music/hex/mg/mg.o.d ${OBJECTDIR}/music/hex/mg/mg.p1.d ${OBJECTDIR}/music/hex/chipchip.p1.d ${OBJECTDIR}/music/hex/happy.p1.d ${OBJECTDIR}/musictools/happybirthday/happy.p1.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d ${OBJECTDIR}/mcc_generated_files/device_config.p1.d ${OBJECTDIR}/mcc_generated_files/mcc.p1.d ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d ${OBJECTDIR}/main.p1.d

# Object Files
OBJECTFILES=${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 ${OBJECTDIR}/lib/music_lib/music.p1 ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 ${OBJECTDIR}/music/hex/mg/melody.o ${OBJECTDIR}/music/hex/mg/mg.o ${OBJECTDIR}/music/hex/mg/mg.p1 ${OBJECTDIR}/music/hex/chipchip.p1 ${OBJECTDIR}/music/hex/happy.p1 ${OBJECTDIR}/musictools/happybirthday/happy.p1 ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 ${OBJECTDIR}/mcc_generated_files/device_config.p1 ${OBJECTDIR}/mcc_generated_files/mcc.p1 ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 ${OBJECTDIR}/mcc_generated_files/tmr2.p1 ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 ${OBJECTDIR}/mcc_generated_files/eusart1.p1 ${OBJECTDIR}/mcc_generated_files/tmr4.p1 ${OBJECTDIR}/mcc_generated_files/tmr6.p1 ${OBJECTDIR}/main.p1

# Source Files
SOURCEFILES=lib/display_i2c_lib/display_i2c_lib.c lib/i2c_lib/i2c_lib.c lib/midi_lib/midi_mapper.c lib/music_lib/music.c lib/sid_lib/sid_pic.c music/hex/mg/melody.asm music/hex/mg/mg.asm music/hex/mg/mg.c music/hex/chipchip.c music/hex/happy.c musictools/happybirthday/happy.c musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c musictools/SID-Wizard-1.7/sources/SWMconvert.c mcc_generated_files/device_config.c mcc_generated_files/mcc.c mcc_generated_files/pin_manager.c mcc_generated_files/tmr2.c mcc_generated_files/interrupt_manager.c mcc_generated_files/eusart1.c mcc_generated_files/tmr4.c mcc_generated_files/tmr6.c main.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=18F26K22
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1: lib/display_i2c_lib/display_i2c_lib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/display_i2c_lib" 
	@${RM} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d 
	@${RM} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 lib/display_i2c_lib/display_i2c_lib.c 
	@-${MV} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.d ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1: lib/i2c_lib/i2c_lib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/i2c_lib" 
	@${RM} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d 
	@${RM} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 lib/i2c_lib/i2c_lib.c 
	@-${MV} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.d ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/midi_lib/midi_mapper.p1: lib/midi_lib/midi_mapper.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/midi_lib" 
	@${RM} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d 
	@${RM} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 lib/midi_lib/midi_mapper.c 
	@-${MV} ${OBJECTDIR}/lib/midi_lib/midi_mapper.d ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/music_lib/music.p1: lib/music_lib/music.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/music_lib" 
	@${RM} ${OBJECTDIR}/lib/music_lib/music.p1.d 
	@${RM} ${OBJECTDIR}/lib/music_lib/music.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/music_lib/music.p1 lib/music_lib/music.c 
	@-${MV} ${OBJECTDIR}/lib/music_lib/music.d ${OBJECTDIR}/lib/music_lib/music.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/music_lib/music.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/sid_lib/sid_pic.p1: lib/sid_lib/sid_pic.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/sid_lib" 
	@${RM} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d 
	@${RM} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 lib/sid_lib/sid_pic.c 
	@-${MV} ${OBJECTDIR}/lib/sid_lib/sid_pic.d ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/mg/mg.p1: music/hex/mg/mg.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/mg/mg.p1 music/hex/mg/mg.c 
	@-${MV} ${OBJECTDIR}/music/hex/mg/mg.d ${OBJECTDIR}/music/hex/mg/mg.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/mg.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/chipchip.p1: music/hex/chipchip.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex" 
	@${RM} ${OBJECTDIR}/music/hex/chipchip.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/chipchip.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/chipchip.p1 music/hex/chipchip.c 
	@-${MV} ${OBJECTDIR}/music/hex/chipchip.d ${OBJECTDIR}/music/hex/chipchip.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/chipchip.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/happy.p1: music/hex/happy.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex" 
	@${RM} ${OBJECTDIR}/music/hex/happy.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/happy.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/happy.p1 music/hex/happy.c 
	@-${MV} ${OBJECTDIR}/music/hex/happy.d ${OBJECTDIR}/music/hex/happy.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/happy.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/happybirthday/happy.p1: musictools/happybirthday/happy.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/happybirthday" 
	@${RM} ${OBJECTDIR}/musictools/happybirthday/happy.p1.d 
	@${RM} ${OBJECTDIR}/musictools/happybirthday/happy.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/happybirthday/happy.p1 musictools/happybirthday/happy.c 
	@-${MV} ${OBJECTDIR}/musictools/happybirthday/happy.d ${OBJECTDIR}/musictools/happybirthday/happy.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/happybirthday/happy.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1: musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver" 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c 
	@-${MV} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1: musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver" 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c 
	@-${MV} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1: musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst" 
	@${RM} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d 
	@${RM} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c 
	@-${MV} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.d ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1: musictools/SID-Wizard-1.7/sources/SWMconvert.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/SID-Wizard-1.7/sources" 
	@${RM} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d 
	@${RM} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 musictools/SID-Wizard-1.7/sources/SWMconvert.c 
	@-${MV} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.d ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/device_config.p1: mcc_generated_files/device_config.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/device_config.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/device_config.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/device_config.p1 mcc_generated_files/device_config.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/device_config.d ${OBJECTDIR}/mcc_generated_files/device_config.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/device_config.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/mcc.p1: mcc_generated_files/mcc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/mcc.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/mcc.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/mcc.p1 mcc_generated_files/mcc.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/mcc.d ${OBJECTDIR}/mcc_generated_files/mcc.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/mcc.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/pin_manager.p1: mcc_generated_files/pin_manager.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 mcc_generated_files/pin_manager.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/pin_manager.d ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr2.p1: mcc_generated_files/tmr2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr2.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr2.p1 mcc_generated_files/tmr2.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr2.d ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1: mcc_generated_files/interrupt_manager.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 mcc_generated_files/interrupt_manager.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.d ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/eusart1.p1: mcc_generated_files/eusart1.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/eusart1.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/eusart1.p1 mcc_generated_files/eusart1.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/eusart1.d ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr4.p1: mcc_generated_files/tmr4.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr4.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr4.p1 mcc_generated_files/tmr4.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr4.d ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr6.p1: mcc_generated_files/tmr6.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr6.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr6.p1 mcc_generated_files/tmr6.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr6.d ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/main.p1: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.p1.d 
	@${RM} ${OBJECTDIR}/main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/main.p1 main.c 
	@-${MV} ${OBJECTDIR}/main.d ${OBJECTDIR}/main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1: lib/display_i2c_lib/display_i2c_lib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/display_i2c_lib" 
	@${RM} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d 
	@${RM} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1 lib/display_i2c_lib/display_i2c_lib.c 
	@-${MV} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.d ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/display_i2c_lib/display_i2c_lib.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1: lib/i2c_lib/i2c_lib.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/i2c_lib" 
	@${RM} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d 
	@${RM} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1 lib/i2c_lib/i2c_lib.c 
	@-${MV} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.d ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/i2c_lib/i2c_lib.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/midi_lib/midi_mapper.p1: lib/midi_lib/midi_mapper.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/midi_lib" 
	@${RM} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d 
	@${RM} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1 lib/midi_lib/midi_mapper.c 
	@-${MV} ${OBJECTDIR}/lib/midi_lib/midi_mapper.d ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/midi_lib/midi_mapper.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/music_lib/music.p1: lib/music_lib/music.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/music_lib" 
	@${RM} ${OBJECTDIR}/lib/music_lib/music.p1.d 
	@${RM} ${OBJECTDIR}/lib/music_lib/music.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/music_lib/music.p1 lib/music_lib/music.c 
	@-${MV} ${OBJECTDIR}/lib/music_lib/music.d ${OBJECTDIR}/lib/music_lib/music.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/music_lib/music.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/lib/sid_lib/sid_pic.p1: lib/sid_lib/sid_pic.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/lib/sid_lib" 
	@${RM} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d 
	@${RM} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/lib/sid_lib/sid_pic.p1 lib/sid_lib/sid_pic.c 
	@-${MV} ${OBJECTDIR}/lib/sid_lib/sid_pic.d ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/lib/sid_lib/sid_pic.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/mg/mg.p1: music/hex/mg/mg.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/mg/mg.p1 music/hex/mg/mg.c 
	@-${MV} ${OBJECTDIR}/music/hex/mg/mg.d ${OBJECTDIR}/music/hex/mg/mg.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/mg.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/chipchip.p1: music/hex/chipchip.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex" 
	@${RM} ${OBJECTDIR}/music/hex/chipchip.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/chipchip.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/chipchip.p1 music/hex/chipchip.c 
	@-${MV} ${OBJECTDIR}/music/hex/chipchip.d ${OBJECTDIR}/music/hex/chipchip.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/chipchip.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/happy.p1: music/hex/happy.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex" 
	@${RM} ${OBJECTDIR}/music/hex/happy.p1.d 
	@${RM} ${OBJECTDIR}/music/hex/happy.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/music/hex/happy.p1 music/hex/happy.c 
	@-${MV} ${OBJECTDIR}/music/hex/happy.d ${OBJECTDIR}/music/hex/happy.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/happy.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/happybirthday/happy.p1: musictools/happybirthday/happy.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/happybirthday" 
	@${RM} ${OBJECTDIR}/musictools/happybirthday/happy.p1.d 
	@${RM} ${OBJECTDIR}/musictools/happybirthday/happy.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/happybirthday/happy.p1 musictools/happybirthday/happy.c 
	@-${MV} ${OBJECTDIR}/musictools/happybirthday/happy.d ${OBJECTDIR}/musictools/happybirthday/happy.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/happybirthday/happy.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1: musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver" 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1 musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.c 
	@-${MV} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1: musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver" 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d 
	@${RM} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1 musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.c 
	@-${MV} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.d ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/libsidplayfp-2.0.1/src/builders/exsid-builder/driver/exSID_ftdiwrap.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1: musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst" 
	@${RM} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d 
	@${RM} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1 musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.c 
	@-${MV} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.d ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/MidiPlayer5/BASS_VST_src/source/bass_vst/sjhash.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1: musictools/SID-Wizard-1.7/sources/SWMconvert.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/musictools/SID-Wizard-1.7/sources" 
	@${RM} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d 
	@${RM} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1 musictools/SID-Wizard-1.7/sources/SWMconvert.c 
	@-${MV} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.d ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/musictools/SID-Wizard-1.7/sources/SWMconvert.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/device_config.p1: mcc_generated_files/device_config.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/device_config.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/device_config.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/device_config.p1 mcc_generated_files/device_config.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/device_config.d ${OBJECTDIR}/mcc_generated_files/device_config.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/device_config.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/mcc.p1: mcc_generated_files/mcc.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/mcc.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/mcc.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/mcc.p1 mcc_generated_files/mcc.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/mcc.d ${OBJECTDIR}/mcc_generated_files/mcc.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/mcc.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/pin_manager.p1: mcc_generated_files/pin_manager.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/pin_manager.p1 mcc_generated_files/pin_manager.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/pin_manager.d ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/pin_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr2.p1: mcc_generated_files/tmr2.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr2.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr2.p1 mcc_generated_files/tmr2.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr2.d ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr2.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1: mcc_generated_files/interrupt_manager.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1 mcc_generated_files/interrupt_manager.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.d ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/interrupt_manager.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/eusart1.p1: mcc_generated_files/eusart1.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/eusart1.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/eusart1.p1 mcc_generated_files/eusart1.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/eusart1.d ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/eusart1.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr4.p1: mcc_generated_files/tmr4.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr4.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr4.p1 mcc_generated_files/tmr4.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr4.d ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr4.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/mcc_generated_files/tmr6.p1: mcc_generated_files/tmr6.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/mcc_generated_files" 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d 
	@${RM} ${OBJECTDIR}/mcc_generated_files/tmr6.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/mcc_generated_files/tmr6.p1 mcc_generated_files/tmr6.c 
	@-${MV} ${OBJECTDIR}/mcc_generated_files/tmr6.d ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/mcc_generated_files/tmr6.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/main.p1: main.c  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.p1.d 
	@${RM} ${OBJECTDIR}/main.p1 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits $(COMPARISON_BUILD)  -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     -o ${OBJECTDIR}/main.p1 main.c 
	@-${MV} ${OBJECTDIR}/main.d ${OBJECTDIR}/main.p1.d 
	@${FIXDEPS} ${OBJECTDIR}/main.p1.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/music/hex/mg/melody.o: music/hex/mg/melody.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/melody.o.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/melody.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto   -o ${OBJECTDIR}/music/hex/mg/melody.o  music/hex/mg/melody.asm 
	@-${MV} ${OBJECTDIR}/music/hex/mg/melody.d ${OBJECTDIR}/music/hex/mg/melody.o.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/melody.o.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/mg/mg.o: music/hex/mg/mg.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.o.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -D__DEBUG=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto   -o ${OBJECTDIR}/music/hex/mg/mg.o  music/hex/mg/mg.asm 
	@-${MV} ${OBJECTDIR}/music/hex/mg/mg.d ${OBJECTDIR}/music/hex/mg/mg.o.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/mg.o.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
else
${OBJECTDIR}/music/hex/mg/melody.o: music/hex/mg/melody.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/melody.o.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/melody.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto   -o ${OBJECTDIR}/music/hex/mg/melody.o  music/hex/mg/melody.asm 
	@-${MV} ${OBJECTDIR}/music/hex/mg/melody.d ${OBJECTDIR}/music/hex/mg/melody.o.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/melody.o.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
${OBJECTDIR}/music/hex/mg/mg.o: music/hex/mg/mg.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}/music/hex/mg" 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.o.d 
	@${RM} ${OBJECTDIR}/music/hex/mg/mg.o 
	${MP_CC} -c $(MP_EXTRA_AS_PRE) -mcpu=$(MP_PROCESSOR_OPTION)  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -DXPRJ_default=$(CND_CONF)  -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto   -o ${OBJECTDIR}/music/hex/mg/mg.o  music/hex/mg/mg.asm 
	@-${MV} ${OBJECTDIR}/music/hex/mg/mg.d ${OBJECTDIR}/music/hex/mg/mg.o.d 
	@${FIXDEPS} ${OBJECTDIR}/music/hex/mg/mg.o.d $(SILENT) -rsi ${MP_CC_DIR}../  
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto        $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	@${RM} dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.hex 
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1  -fno-short-double -fno-short-float -memi=wordwrite -O0 -fasmfile -maddrqual=ignore -xassembler-with-cpp -mwarn=-3 -Wa,-a -msummary=-psect,-class,+mem,-hex,-file  -ginhx032 -Wl,--data-init -mno-keep-startup -mno-download -mdefault-config-bits -std=c99 -gdwarf-3 -mstack=compiled:auto:auto:auto     $(COMPARISON_BUILD) -Wl,--memorysummary,dist/${CND_CONF}/${IMAGE_TYPE}/memoryfile.xml -o dist/${CND_CONF}/${IMAGE_TYPE}/PIC_SID_Project.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}     
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif