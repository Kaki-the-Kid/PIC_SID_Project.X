/**
 * PICSID - SID/MOS8580 emulator v0.1 (C) 2020 Kaki
 * 
 * 
 */ 

#include "../../mcc_generated_files/mcc.h"
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>

#ifndef SID_PIC_H
    #include "sid_pic.h"
#endif

/*
 * Starts SIDcog in a single cog
 * 
 * Returns a pointer to the first SID register in hub memory
 * on success; otherwise returns 0.
 * - right - The pin to output the right channel to. 0 = Not used
 * - left - The pin to output the left channel to. 0 = Not used
 */

uint32_t startSID(uint16_t right, uint16_t left) {

  uint32_t arg1 = 0x18000000 | left;
  uint32_t arg2 = 0x18000000 | right;
  
  uint32_t r1 = ((1<<right) | (1<<left)) & !1;
  //uint32_t sampleRate = clkfreq / trunc(C64_CLOCK_FREQ/32.0);
  //uint32_t combTableAddr = combinedWaveforms;
  
  
  //cog = cognew(@SIDEMU, @ch1_frequencyLo) + 1;

  //if (cog)
    //return @ch1_frequencyLo;
  //else
    return 0;
}

/*
 * Stops SIDcog
 */
void stop(void) {
    //if (cog) {
    //    cogstop(cog~ -1);
    //    cog = 0;
    //   }
}

// Sets a single SID register to a value
// - reg - The SID register to set.
// - val - The value to set the register to.

void setSIDRegister(uint8_t reg, uint8_t val) {
  //byte[@ch1_frequencyLo + (reg + (reg/7))] = val;
}
  
// Update all 25 SID registers
// source - A pointer to an array containing 25 bytes to update
//          the 25 SID registers with.

void updateRegisters(uint8_t source) {
  //bytemove(@ch1_frequencyLo, source, 7);
  //bytemove(@ch1_frequencyLo + 8 , source + 7 , 7);
  //bytemove(@ch1_frequencyLo + 16, source + 14, 7);
  //bytemove(@ch1_frequencyLo + 24, source + 21, 4);
}

/******************************************************************
 * // Reset all 25 SID registers    *
 ******************************************************************/

void resetRegisters(void) {
    for(uint8_t i=0; i<=25; i++) {
        //ch1_frequencyLo[i] = 0;
    }
}


/******************************************************************
 * Sets the main volume             *
 ******************************************************************
 * @param: volumeValue - A value betwen 0 and 15.       *
 ******************************************************************/

void setVolume(uint8_t volumeValue) {
  //byte[@Volume] = (byte[@Volume]&$F0) | (volumeValue&$0F);
}

/******************************************************************
 * Plays a tone in a SID channel.             *
 ******************************************************************
 * @param channel:  The SID channel to use. (0 - 2)     *
 * @param freq:     The 16 bit frequency value use. (0 - 65535)   *
 *    (The SID can output tone frequencies from 0 - 3.9 kHz)      *
 * @param waveform: The waveform combination to use.    *
 *    e.g. sid.play(x, x, sid#SQUARE | sid#SAW, x, x, x, x)       *
 * @param attack:   The attack value. (0 - 15)          *
 * @param decay:    The decay value. (0 - 15)           *
 * @param sustain:  The sustain value. (0 - 15)         *
 * @param release   The release value. (0 - 15)         *
 ******************************************************************
 * When calling this method, the envelope generator enters the    *
 * "attack - decay - sustain" phase. Don't forget to call         *
 * "noteOff" before using it so the envelope is in release phase  *
 ******************************************************************/

void play(uint8_t channel, short freq, short waveform, uint8_t attack, uint8_t decay, uint8_t sustain, uint8_t release) { // | offs
    uint8_t offs = channel<<3;
    //word[@ch1_frequencyLo + offs] = freq;
    //byte[@ch1_attackDecay + offs] = (decay&$F) | ((attack&$F)<<4);
    //byte[@ch1_sustainRelease + offs] = (release&$F) | ((sustain&$F)<<4);
    //byte[@ch1_controlRegister + offs] = (byte[@ch1_controlRegister + offs]&$0F) | waveform | 1;
}

/******************************************************************
 * Plays a tone in a SID channel    *
 ******************************************************************
 * @param channel:  The SID channel to use. (0 - 2)     *
 * @param freq:     The 16 bit frequency value use. (0 - 65535)   *
 *    (The SID can output tone frequencies from 0 - 3.9 kHz)      *
 ******************************************************************
 * Don't forget to set the envelope values for the channel        *
 * before using this method.        *
 * - Make sure you have set the waveform for the channel before   *
 *   using this method.             *
 * - When calling this method, the envelope generator enters the  *
 *   "attack - decay - sustain" phase. Don//t forget to call      *
 *   "noteOff" before calling this method to set the envelope to  *
 *   release phase.       *
 ******************************************************************/

void noteOn(uint8_t channel, uint16_t freq) { // | offs
  uint8_t offs = channel<<3;
  //byte[@ch1_controlRegister + offs] = (byte[@ch1_controlRegister+offs]&$FE) | 1;
  //word[@ch1_frequencyLo + offs] = freq;
}
  
/******************************************************************
 * Sets the envelope generator of a channel to release phase      *
 ******************************************************************
 * @param channel:   The SID channel to use. (0 - 2)    *
 ******************************************************************/

void noteOff(uint8_t channel) {
  //byte[@ch1_controlRegister + (channel<<3)] &= 0xFE;
}

/******************************************************************
 * Sets the frequency of a SID channel        *
 ******************************************************************
 * @param channel:   The SID channel to use. (0 - 2)    *
 * @param freq:      The 16 bit frequency value. (0 - 65535)      *
 *    (The SID can output tone frequencies from 0 - 3.9 kHz)      *
 ******************************************************************/

void setFreq(uint8_t channel, short freq) {
  //word[@ch1_frequencyLo + (channel<<3)] = freq;
}

/******************************************************************
 * Sets the waveform of a SID channel         *
 ******************************************************************
 * @param channel:    The SID channel to use. (0 - 2)             *
 * @param waveform:   The waveform combination to use.            *
 *    e.g. sid.setWaveform(x, sid#SQUARE | sid#SAW)     *
 ******************************************************************/

void setWaveform(uint8_t channel, uint16_t waveform) { //| offs  
    //offs = channel<<3;
    //byte[@ch1_controlRegister+offs] = (byte[@ch1_controlRegister + offs]&$0F) | waveform;
}
      
/******************************************************************
 * Sets the pulse width of a SID channel      *
 ******************************************************************
 * @param channel:    The SID channel to use. (0 - 2)             *
 * @param pulseWidth: The 12 bit pulse width value to use.        *
 *          (0 - 4095)    * 
 *    e.g. sid.setWaveform(x, sid#SQUARE | sid#SAW)     *
 ******************************************************************
 * The pulse width value affects square waves ONLY.     *
 ******************************************************************/

void setPulseWidth(uint8_t channel, uint16_t pulseWidth) {
    //word[@ch1_pulseWidthLo + (channel<<3)] = pulseWidth;
}
     
/******************************************************************
 * Sets the envelope values of a SID channel            *
 ******************************************************************
 * @param channel:  The SID channel to use. (0 - 2)     *
 * @param attack:   The attack value. (0 - 15)          *
 * @param decay:    The decay value. (0 - 15)           *
 * @param sustain:  The sustain value. (0 - 15)         *
 * @param release:  The release value. (0 - 15)         *
 ******************************************************************/

void setADSR(uint8_t channel, uint8_t attack, uint8_t decay, uint8_t sustain, uint8_t release) {
    //| offs
    uint8_t offs = channel<<3;
    //ch1_attackDecay[offs] = ((decay&$F) | ((attack&$F)<<4));
    //byte[@ch1_sustainRelease + offs] = (release&$F) | ((sustain&$F)<<4);
}

/******************************************************************
 * Sets the resonance value of the filter     *
 ******************************************************************
 * @param resonanceValue: The resonance value to use. (0 - 15)    *
 ******************************************************************/

void setResonance(uint8_t resonanceValue) {
   //byte[@Filter3] = (byte[@Filter3]&$0F) | (resonanceValue<<4);
}
  
/******************************************************************
 * Sets the cutoff frequency of the filter    *
 ******************************************************************
 * @param cutoffValue: The 12 bit cutoff frequency value to use.  *
 ******************************************************************/

void setCutoff(uint16_t cutoffValue) {
    //byte[@Filter1] = cutoffValue&$07;
    //byte[@Filter2] = (cutoffValue&$07F8)>>3;
}

/******************************************************************
 * Enable/Disable filtering on channels       *
 ******************************************************************
 * @param ch1: Enable/Disable filter on channel 1. (True/False)   *
 * @param ch2: Enable/Disable filter on channel 2. (True/False)   *
 * @param ch3: Enable/Disable filter on channel 3. (True/False)   *
 ******************************************************************/

void setFilterMask(bool ch1, bool ch2, bool ch3) {
    //byte[@Filter3] = (byte[@Filter3]&$F0) | (ch1&1) | (ch2&2) | (ch3&4);
}

/******************************************************************
 * Enable/Disable filter types      *
 ******************************************************************
 * @param lp: Enable/Disable lowpass filter. (True/False)         *
 * @param bp: Enable/Disable bandpass filter. (True/False)        *
 * @param hp: Enable/Disable highpass filter. (True/False)        *
 ******************************************************************/

void setFilterType(bool lp, bool bp, bool hp) {
    //byte[@volume] = (byte[@volume]&$0F) | (lp&16) | (bp&32) | (hp&64);
}

/******************************************************************
 * Enable/Disable ring modulation on channels           *
 ******************************************************************
 * @param ch1: Enable/Disable ring modulation on ch 1.(True/False)*
 * @param ch2: Enable/Disable ring modulation on ch 2.(True/False)*
 * @param ch3: Enable/Disable ring modulation on ch 3.(True/False)*
 ******************************************************************
 * Channel 3 modulates channel 1    *
 * Channel 1 modulates channel 2    *
 * Channel 2 modulates channel 3    *
 ******************************************************************/

void enableRingmod(bool ch1, bool ch2, bool ch3) {
    //byte[@ch1_controlRegister] = (byte[@ch1_controlRegister]&$FB) | (ch1&4);
    //byte[@ch2_controlRegister] = (byte[@ch2_controlRegister]&$FB) | (ch2&4);
    //byte[@ch3_controlRegister] = (byte[@ch3_controlRegister]&$FB) | (ch3&4);
}

/******************************************************************
 * Enable/Disable oscillator synchronization on channels          *
 ******************************************************************
 * @param ch1: Enable/Disable synchronization on ch 1.(True/False)*
 * @param ch2: Enable/Disable synchronization on ch 2.(True/False)*
 * @param ch3: Enable/Disable synchronization on ch 3.(True/False)*
 ******************************************************************
 * - Channel 3 synchronizes channel 1         *
 * - Channel 1 synchronizes channel 2         *
 * - Channel 2 synchronizes channel 3         *
 ******************************************************************/

void enableSynchronization(bool ch1, bool ch2, bool ch3) {
    //byte[@ch1_controlRegister] = (byte[@ch1_controlRegister]&$FD) | (ch1&2);
    //byte[@ch2_controlRegister] = (byte[@ch2_controlRegister]&$FD) | (ch2&2);
    //byte[@ch3_controlRegister] = (byte[@ch3_controlRegister]&$FD) | (ch3&2);
}


//#include "SIDsimul.s"