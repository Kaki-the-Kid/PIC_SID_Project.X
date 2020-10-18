/* 
 * File:   sid_pic.h
 * Author: krs
 *
 * Created on February 14, 2020, 3:36 PM
 */

#ifndef SID_PIC_H
#define	SID_PIC_H

// Prototypes
uint32_t startSID(uint16_t, uint16_t);


// Generel setting for Oscilators
#define PAL      = 985248.0
#define NTSC     = 1022727.0
#define MAXF     = 1031000.0

// Bitsettings for waveform
#define TRIANGLE = 0x10
#define SAW      = 0x20
#define SQUARE   = 0x40
#define NOISE    = 0x80

#define C64_CLOCK_FREQ      PAL
#define RESONANCE_OFFSET    6
#define RESONANCE_FACTOR    5
#define CUTOFF_LIMIT        1100
#define LP_MAX_CUTOFF       11
#define BP_MAX_CUTOFF       10
#define FILTER_OFFSET       12
#define START_LOG_LEVEL     0x5d5d5d5d
#define DECAY_DIVIDE_REF    0x6C6C6C6C
// ENV_CAL_FACTOR        = (MaxUint32 / SIDcogSampleFreq) / (1 / SidADSR_1secRomValue)
// ENV_CAL_FACTOR        = (4294967295 / 30789 ) / (1 / 3907) = 545014038,181330
#define ENV_CAL_FACTOR      545014038.181330
#define NOISE_ADD           0b1010_1010_101<<23
#define NOISE_TAP           0b100001 << 8





#define SID     (*(struct __sid*)0xD400)

/* Define a structure with the sid register offsets */
struct __sid_voice {
    unsigned            freq;           /* Frequency */
    unsigned            pw;             /* Pulse width */
    unsigned char       ctrl;           /* Control register */
    unsigned char       ad;             /* Attack/decay */
    unsigned char       sr;             /* Sustain/release */
};
struct __sid {
    struct __sid_voice  v1;             /* Voice 1 */
    struct __sid_voice  v2;             /* Voice 2 */
    struct __sid_voice  v3;             /* Voice 3 */
    unsigned            flt_freq;       /* Filter frequency */
    unsigned char       flt_ctrl;       /* Filter control register */
    unsigned char       amp;            /* Amplitude */
    unsigned char       ad1;            /* A/D converter 1 */
    unsigned char       ad2;            /* A/D converter 2 */
    unsigned char       noise;          /* Noise generator */
    unsigned char       read3;          /* Value of voice 3 */
};



/*
 * The SID 6581 (U7) of the C64 is connected to the bus by registers $D400-$D7FF
 * The following is a defining the registers for a more friendly calling
 * The SID also handles paddles and extern sound, whish is not handled here.
 * 
 * Besides databus D0-D7 and Address bus: A0-A15
 * Following signals are present:
 * R/W, /NMI, /IRQ, /RES, BA, AEC, CLK0, SP, CNT
 */

/* 
 * D400-D7FF 54272-55295 MOS 6581 SOUND INTERFACE DEVICE (SID)
 */

// Voice 1
#define     Voice1freqLo            D400 // 54272 Voice 1: Frequency Control - Low-Byte
#define     Voice1freqHi            D401 // 54273 Voice 1: Frequency Control - High-Byte

// Fn  = round( Fout/.06097 )   // Frequency output
// Fhi = INT(Fn/256)            // High frequency location (Fhi)
// Flo = Fn-(256*Fhi)           // Low frequency location (Flo) should be

#define     Voice1PulseWidthLo      D402 // 54274 Voice 1: Pulse Waveform Width - Low-Byte
#define     Voice1PulseWidthHi      D403 // 54275 7-4 Unused, 3-0 Voice 1: Pulse Waveform Width - High-Nybble

#define     Voice1Control           D404 // 54276 Voice 1: Control Register

//#define Voice1Control Voice1Control
extern volatile unsigned char           Voice1Control            __at(0xD404);
#ifndef _LIB_BUILD
asm("Voice1Control equ D404h");
#endif
// bitfield definitions
typedef union {
    struct {
        unsigned Voice1Control          :8;
    };
    struct {
        unsigned RandomNoise            :1; // 7 Select Random Noise Waveform, 1 = On
        unsigned PulseWave              :1; // 6 Select Pulse Waveform, 1 = On
        unsigned Sawtooth               :1; // 5 Select Sawtooth Waveform, 1 = On
        unsigned Triangle               :1; // 4 Select Triangle Waveform, 1 = On
        
        unsigned Testbit                :1; // 3 Test Bit: 1 = Disable Oscillator 1
        unsigned RingMod                :1; // 2 Ring Modulate Osc. 1 with Osc. 3 Output, 1 = On
        unsigned SyncMod                :1; // 1 Synchronize Osc. 1 with Osc. 3 Frequency, 1 = On
        unsigned Gate                   :1; // 0 Gate Bit: 1 = Start Att/Dec/Sus, 0 = Start Release
    };
} Voice1Control_bits_t;
extern volatile Voice1Control_bits_t Voice1Control_bits __at(0xD404);
// bitfield macros
#define _VOICE1CONTROL_LENGTH                   0x8
#define _VOICE1CONTROL_MASK                     0xFF
#define _VOICE1CONTROL_WAVEFORM_RANDOM          0x1
#define _VOICE1CONTROL_WAVEFORM_RANDOM_MASK     0x80
#define _VOICE1CONTROL_WAVEFORM_PULSEWAVE       0x1
#define _VOICE1CONTROL_WAVEFORM_PULSEWAVE_MASK  0x40
#define _VOICE1CONTROL_WAVEFORM_SAWTOOTH        0x1
#define _VOICE1CONTROL_WAVEFORM_SAWTOOTH_MASK   0x20
#define _VOICE1CONTROL_WAVEFORM_TRIANGLE        0x1
#define _VOICE1CONTROL_WAVEFORM_TRIANGLE_MASK   0x10


//D405 54277 Envelope Generator 1: Attack / Decay Cycle Control
//7-4 Select Attack Cycle Duration: 0-15
//3-0 Select Decay Cycle Duration: 0-15

//D406 54278 Envelope Generator 1: Sustain / Release Cycle Control
//7-4 Select Sustain Cycle Duration: 0-15
//3-0 Select Release Cycle Duration: 0-15

// Voice 2
#define Voice2freqLo        0xD407 // 54279 Voice 2: Frequency Control - Low-Byte
#define Voice2freqHi        0xD408 // 54280 Voice 2: Frequency Control - High-Byte

#define Voice2PulseWidthLo  0xD409 // 54281 Voice 2: Pulse Waveform Width - Low-Byte
#define Voice2PulseWidthHi  0xD40A // 54282 7-4 Unused 3-0 Voice 2: Pulse Waveform Width - High-Nybble

#define Voice2Control       0xD40B // 54283 Voice 2: Control Register
//7 Select Random Noise Waveform, 1 = On
//6 Select Pulse Waveform, 1 = On
//5 Select Sawtooth Waveform, 1 = On
//4 Select Triangle Waveform, 1 = On
//3 Test Bit: 1 = Disable Oscillator 1
//2 Ring Modulate Osc. 2 with Osc. 1 Output, 1 = On
//1 Synchronize Osc. 2 with Osc. 1 Frequency, 1 = On
//0 Gate Bit: 1 = Start Att/Dec/Sus, 0 = Start Release
        
//D40C 54284 Envelope Generator 2: Attack / Decay Cycle Control
//7-4 Select Attack Cycle Duration: O-15
//3-0 Select Decay Cycle Duration: 0-15
//D40D 54285 Envelope Generator 2: Sustain / Release Cycle Control
//7-4 Select Sustain Cycle Duration: O-15
//3-0 Select Release Cycle Duration: O-15

// Voice 3
#define Voice3freqLo        0xD40E // 54286 Voice 3: Frequency Control - Low-Byte
#define Voice3freqHi        0xD40F // 54287 Voice 3: Frequency Control - High-Byte

#define Voice3PulseWidthLo  0xD410 // 54288 Voice 3: Pulse Waveform Width - Low-Byte
#define Voice3PulseWidthHi  0xD411 // 54289 7-4 Unused, 3-0 Voice 3: Pulse Waveform Width - High-Nybble

#define Voice3Control       0xD412 // 54290 Voice 3: Control Register
//7 Select Random Noise Waveform, 1 = On
//6 Select Pulse Waveform, 1 = On
//5 Select Sawtooth Waveform, 1 = On
//4 Select Triangle Waveform, 1 = On
//3 Test Bit: 1 = Disable Oscillator 1
//2 Ring Modulate Osc. 3 with Osc. 2 Output, 1 = On
//1 Synchronize Osc. 3 with Osc. 2 Frequency, 1 = On
//0 Gate Bit: 1 = Start Att/Dec/Sus, 0 = Start Release

//D413 54291 Envelope Generator 3: Attac/Decay Cycle Control
//7-4 Select Attack Cycle Duration: 0-15
//3-0 Select Decay Cycle Duration: 0-15

//D414 54285 Envelope Generator 3: Sustain / Release Cycle Control
//7-4 Select Sustain Cycle Duration: 0-15
//3-0 Select Release Cycle Duration: 0-15

//D415 54293 Filter Cutoff Frequency: Low-Nybble (Bits 2-0)
//D416 54294 Filter Cutoff Frequency: High-Byte

//D417 54295 Filter Resonance Control / Voice Input Control
//7-4 Select Filter Resonance: 0-15
//3 Filter External Input: 1 = Yes, 0 = No
//2 Filter Voice 3 Output: 1 = Yes, 0 = No
//Filter Voice 2 Output: 1 = Yes, 0 = No
//0 Filter Voice 1 Output: 1 = Yes, 0 = No
//D418 54296 Select Filter Mode and Volume
//7 Cut-Off Voice 3 Output: 1 = Off, 0 = On
//6 Select Filter High-Pass Mode: 1 = On
//5 Select Filter Band-Pass Mode: 1 = On
//4 Select Filter Low-Pass Mode: 1 = On
//3-0 Select Output Volume: 0-15
//D419 54297 Analog/Digital Converter: Game Paddle 1 (0-255)
//D41A 54298 Analog/Digital Converter Game Paddle 2 (0-255)

//D41B 54299 Oscillator 3 Random Number Generator
//D41C 54230 Envelope Generator 3 Output


/******************************************************************
 * Notes Duration shorthands from C64 
 ******************************************************************
 * Values corresponding to the original SID                       *
 ******************************************************************/


#define note1_16        0x0080     //128
#define note1_8         0x0100     //256    
#define note1_8dotted   0x0180     //384    
#define note1_4         0x0200     //512    
#define note1_4_1_16    0x0280     //640    
#define note1_4dotted   0x0300     //768    
#define note1_2         0x0400     //1024    
#define note1_2_1_16    0x0480     //1152    
#define note1_2__1_8    0x0500     //1280    
#define note1_2dotted   0x0600     //1536    
#define note1_1         0x0800     //2048    

/*
 * The note number from the note table is added to the duration above.
  Then each note can be entered using only one number which is decoded by
  your program. This is only one method of coding note values. You may be
  able to come up with one with which you are more comfortable. The formula
  used here for encoding a note is as follows:

    1) The duration (number of 1/16ths of a measure) is multiplied by 8.
    2) The result of step 1 is added to the octave you've chosen (0-7).
    3) The result of step 2 is then multiplied by 16.
    4) Add your note choice (0-11) to the result of the operation in step
       3.

  In other words:

  ((((D*8)+O)*16)+N)

  Where D = duration, O = octave, and N = note
    A silence is obtained by using the negative of the duration number
  (number of 1/16ths of a measure * 128).
 */


/* 
 * Waveform characteristics
 */

/* 
 * Sine wave
 *
 *      +               +
 *    +   +           +   +
 *   /     \         /     \
 * ./.......\......./.......\.
 *           \     /
 *            +   +
 *              +
 *
 */


/*
 * Sawtooth waveform
 * 
 *      +       +       +
 *     /|      /|      /|
 *    / |     / |     / |
 *   /  |    /  |    /  |
 * ./...|.../...|.../...|.....
 *      |  /    |  /    |  /
 *      | /     | /     | /
 *      |/      |/      |/
 *      +       +       +
 */



/*
 * Triangular waveform
 * 
 *      +               +     
 *     / \             / \    
 *    /   \           /   \   
 *   /     \         /     \  
 * ./.......\......./.......\.
 *           \     /          
 *            \   /           
 *             \ /            
 *              +                                              
 *                                    
 */

/*
 * Variable pulse wave
 * 
 *     +----+  +----+  +----+  |
 *     |    |  |    |  |    |  | 
 *     |    |  |    |  |    |  | 
 *     |    |  |    |  |    |  | 
 *    .|....|..|....|..|....|..|. 
 *     |    |  |    |  |    |  | 
 *     |    |  |    |  |    |  | 
 *     |    |  |    |  |    |  | 
 *     |    +--+    +--+    +--+ 
 *              <--> 
 *           PULSE WIDTH
 * Length of the pulse cycle by defining the proportion of the wave which will be high
 * 
 * 
 *
 *
 * Register 2 is the low byte of the pulse width 
 * (Lpw = 0 through 255). 
 * Register 3 is the high 4 bits (Hpw = 0 through 15).
 * Together these registers specify a 12-bit number for your pulse width,
 * which you can determine by using the following formula:
 *                   PWn = Hpw*256 + Lpw
 * The pulse width is determined by the following equation:
 *                   PWout = (PWn/40.95) %
 * 
 * When PWn has a value of 2048, it will give you a square wave. 
 * That means that register 2 (Lpw) = 0 and register 3 (Hpw) = 8.
 */


/*
 * The last waveform available to you is white noise (shown here).
 *
 *                                   .   .       .
 *                          .     . .          .   .
 *                           .  .     .       .
 *                         ...........................
 *                             . . .        .
 *                                      .  . .  .
 *                            .                   . .
 * 
 */



/*
 * Envelope Generator
 * 
 * The volume of a musical tone changes from the moment you first hear it,
 * all the way through until it dies out and you can't hear it anymore. When
 * a note is first struck, it rises from zero volume to its peak volume. The
 * rate at which this happens is called the ATTACK. Then, it fails from the
 * peak to some middle-ranged volume. The rate at which the fall of the note
 * occurs is called the DECAY. The mid-ranged volume itself is called the
 * SUSTAIN level. And finally, when the note stops playing, it fails from
 * the SUSTAIN level to zero volume. The rate at which it fails is called
 * the RELEASE. Here is a sketch of the four phases of a note:
 *
 *                              +
 *                             /|\
 *                            / | \
 *                           /  |  \
 *         SUSTAIN LEVEL . ./. .|. .+--------+
 *                         /    |   |        |\
 *                        /     |   |        | \
 *                       /      |   |        |  \
 *                       |      |   |        |   |
 *                       |   A  | D |    S   | R |
 *
 * The parameters ATTACK/DECAY/SUSTAIN/RELEASE and collectively called ADSR
 * 
 */

/*
 * Here are the meanings of the values for ATTACK, DECAY, and RELEASE:
 *
 *  +-----+------------------------+--------------------------------+
 *  |VALUE|ATTACK RATE (TIME/CYCLE)| DECAY/RELEASE RATE (TIME/CYCLE)|
 *  +-----+------------------------+--------------------------------+
 *  |  0  |           2 ms         |               6 ms             |
 *  |  1  |           8 ms         |              24 ms             |
 *  |  2  |          16 ms         |              48 ms             |
 *  |  3  |          24 ms         |              72 ms             |
 *  |  4  |          38 ms         |             114 ms             |
 *  |  5  |          56 ms         |             168 ms             |
 *  |  6  |          68 ms         |             204 ms             |
 *  |  7  |          80 ms         |             240 ms             |
 *  |  8  |         100 ms         |             300 ms             |
 *  |  9  |         250 ms         |             750 ms             |
 *  | 10  |         500 ms         |             1.5 s              |
 *  | 11  |         800 ms         |             2.4 s              |
 *  | 12  |           1 s          |               3 s              |
 *  | 13  |           3 s          |               9 s              |
 *  | 14  |           5 s          |              15 s              |
 *  | 15  |           8 s          |              24 s              |
 *  +-----+------------------------+--------------------------------+
 *
 */




/*
 * Listing of different instruments
 * 
 */

// Violin, A=5; D=8; S=5; R=9
// $D405 = 0x58
// $D406 = 0x59

// Xylophone, A=0; D=9; S=O; R=9
// $D40S = 0x09
// $D406 = 0x09
// $D404 = 0x11
// $D404 = 0x10

// Piano type sound with square waveform, A=0;D=9;S=0;R=0
// $D403 = 8
// $DF02 = 0
// $D405 = 9
// $DF06 = 0
// $D404 = 65
// $D404 = 64

// Synth 1, A=9;D=O; S=15;R=3
// $DF05 = 90
// $D406 = F3

/* 
 * FILTERING
 * 
 * The harmonic content of a waveform can be changed by using a filter.
 * The SID chip is equipped with three types of filtering. They can be used
 * separately or in combination with one another. Let's go back to the
 * sample program you've been using to play with a simple example that uses
 * a filter. There are several filter controls to set.
 * You add line 15 in the program to set the cutoff frequency of the
 * filter. The cutoff frequency is the reference point for the filter. You
 * SET the high and low frequency cutoff points in registers 21 and 22. To
 * turn ON the filter for voice 1, POKE register 23.
 * Next change line 30 to show that a high-pass filter will be used (see
 * the SID register map).
 * 
 * Try RUNning the program now. Notice the lower tones have had their
  volume cut down. It makes the overall quality of the note sound tinny.
  This is because you are using a high-pass filter which attenuates (cuts
  down the level of) frequencies below the specified cutoff frequency.
    There are three types of filters in your Commodore computer's SID chip.
  We have been using the high-pass filter. It will pass all the frequencies
  at or above the cutoff, while attenuating the frequencies below the
  cutoff.

                             |
                      AMOUNT |      +-----
                      PASSED |     /
                             |    /
                             |   /
                             +------|-------
                                FREQUENCY

  200   PROGRAMMING SOUND AND MUSIC
~


    The SID chip also has a low-pass filter. As its name implies, this
  filter will pass the frequencies below cutoff and attenuate those above.


                             |
                      AMOUNT | -----+
                      PASSED |       \
                             |        \
                             |         \
                             +------|-------
                                FREQUENCY


    Finally, the chip is equipped with a bandpass filter, which passes a
  narrow band of frequencies around the cutoff, and attenuates all others.


                             |
                      AMOUNT |      +
                      PASSED |     / \
                             |    /   \
                             |   /     \
                             +------|-------
                                FREQUENCY



    The high- and low-pass filters can be combined to form a notch reject
  filter which passes frequencies away from the cutoff while attenuating
  at the cutoff frequency.


                             |
                      AMOUNT | --+     +---
                      PASSED |    \   /
                             |     \ /
                             |      +
                             +------|-------
                                FREQUENCY




                                          PROGRAMMING SOUND AND MUSIC   201
~


    Register 24 determines which type filter you want to use. This is in
  addition to register 24's function as the overall volume control. Bit 6
  controls the high-pass filter (0 = off, 1 = on), bit 5 is the bandpass
  filter, and bit 4 is the low-pass filter. The low 3 bits of the cutoff
  frequency are determined by register 21 (Lcf) (Lcf = 0 through 7). While
  the 8 bits of the high cutoff frequency are determined by register 22
  (Hcf) (Hcf = 0 through 255).
    Through careful use of filtering, you can change the harmonic structure
  of any waveform to get just the sound you want. In addition, changing the
  filtering of a sound as it goes through the ADSR phases of its life can
  produce interesting effects.
 */


/*
 * ADVANCED TECHNIQUES
 *
 * The SID chip's parameters can be changed dynamically during a note or
 *  sound to create many interesting and fun effects. In order to make this
 *  easy to do, digitized outputs from oscillator three and envelope
 *  generator three are available for you in registers 27 and 28, respec-
 *  tively.
 *  The output of oscillator 3 (register 27) is directly related to the
 *  waveform selected. If you choose the sawtooth waveform of oscillator 3,
 *  this register will present a series of numbers incremented (increased
 *  step by step) from 0 to 255 at a rate determined by the frequency of
 *  oscillator 3. If you choose the triangle waveform, the output will incre-
 *  ment from 0 up to 255, then decrement (decrease step by step) back down
 *  to 0. If you choose the pulse wave, the output will jump back-and-forth
 *  between 0 and 255. Finally, choosing the noise waveform will give you a
 *  series of random numbers. When oscillator 3 is used for modulation, you
 *  usually do NOT want to hear its output. Setting bit 7 of register 24
 *  turns the audio output of voice 3 off. Register 27 always reflects the
 *  changing output of the oscillator and is not affected in any way by the
 *  envelope (ADSR) generator.
 * 
 * Register 25 gives you access to the output of the envelope generator
 *  of oscillator 3. It functions in much the same fashion that the output of
 *  oscillator 3 does. The oscillator must be turned on to produce any output
 *  from this register.
 *    Vibrato (a rapid variation in frequency) can be achieved by adding the
 *  output of oscillator 3 to the frequency of another oscillator. Example
 *  Program 6 illustrates this idea.
 */





/******************************************************************
 * MUSIC NOTE VALUES                                              *
 ******************************************************************
 * This appendix contains a complete list of Note#, actual note,  *
 * and the values to be POKED into the HI FREQ and LOW FREQ       *
 * registers of the sound chip to produce the indicated note.     *
 ******************************************************************/

//+-----------------------------+-----------------------------------------+
//|        MUSICAL NOTE         |             OSCILLATOR FREQ             |
//+-------------+---------------+-------------+-------------+-------------+
//|     NOTE    |    OCTAVE     |   DECIMAL   |      HI     |     LOW     |
//+-------------+---------------+-------------+-------------+-------------+

#define SIDNoteC0      |     268     |       1     |      12     |
#define SIDNoteCs0     |     284     |       1     |      28     |
#define SIDNoteD0      |     301     |       1     |      45     |
#define SIDNoteDs0     |     318     |       1     |      62     |
#define SIDNoteE0      |     337     |       1     |      81     |
#define SIDNoteF0      |     358     |       1     |     102     |
#define SIDNoteFs0     |     379     |       1     |     123     |
#define SIDNoteG0      |     401     |       1     |     145     |
#define SIDNoteGs0     |     425     |       1     |     169     |
#define SIDNoteA0      |     451     |       1     |     195     |
#define SIDNoteAs0     |     477     |       1     |     221     |
#define SIDNoteB0      |     506     |       1     |     250     |
#define SIDNoteC1      |     536     |       2     |      24     |
#define SIDNoteCs1     |     568     |       2     |      56     |
#define SIDNoteD1      |     602     |       2     |      90     |
#define SIDNoteDs1     |     637     |       2     |     125     |
#define SIDNoteE1      |     675     |       2     |     163     |
#define SIDNoteF1      |     716     |       2     |     204     |
#define SIDNoteFs1     |     758     |       2     |     246     |
#define SIDNoteG1      |     803     |       3     |      35     |
#define SIDNoteGs1     |     851     |       3     |      83     |
#define SIDNoteA1      |     902     |       3     |     134     |
#define SIDNoteAs1     |     955     |       3     |     187     |
#define SIDNoteB1      |    1012     |       3     |     244     |
#define SIDNoteC2      |    1072     |       4     |      48     |
#define SIDNoteCs2     |     1136    |       4     |     112     |
#define SIDNoteD2      |     1204    |       4     |     180     |
#define SIDNoteDs2     |     1275    |       4     |     251     |
#define SIDNoteE2      |     1351    |       5     |      71     |
#define SIDNoteF2      |     1432    |       5     |     152     |
#define SIDNoteFs2     |     1517    |       5     |     237     |
#define SIDNoteG2      |     1607    |       6     |      71     |
#define SIDNoteGs2     |     1703    |       6     |     167     |
#define SIDNoteA2      |     1804    |       7     |      12     |
#define SIDNoteAs2     |     1911    |       7     |     119     |
#define SIDNoteB2      |     2025    |       7     |     233     |
#define SIDNoteC3      |     2145    |       8     |      97     |
#define SIDNoteCs3     |     2273    |       8     |     225     |
#define SIDNoteD3      |     2408    |       9     |     104     |
#define SIDNoteDs3     |     2551    |       9     |     247     |
#define SIDNoteE3      |     2703    |      10     |     143     |
#define SIDNoteF3      |     2864    |      11     |      48     |
#define SIDNoteFs3     |     3034    |      11     |     218     |
#define SIDNoteG3      |     3215    |      12     |     143     |
#define SIDNoteGs3     |     3406    |      13     |      78     |
#define SIDNoteA3      |     3608    |      14     |      24     |
#define SIDNoteAs3     |     3823    |      14     |     239     |
#define SIDNoteB3      |     4050    |      15     |     210     |
#define SIDNoteC4      |     4291    |      16     |     195     |
#define SIDNoteCs4     |     4547    |      17     |     195     |
#define SIDNoteD4      |     4817    |      18     |     209     |
#define SIDNoteDs4     |     5103    |      19     |     239     |
#define SIDNoteE4      |     5407    |      21     |      31     |
#define SIDNoteF4      |     5728    |      22     |      96     |
#define SIDNoteFs4     |     6069    |      23     |     181     |
#define SIDNoteG4      |     6430    |      25     |      30     |
#define SIDNoteGs4     |     6812    |      26     |     156     |
#define SIDNoteA4      |     7217    |      28     |      49     |
#define SIDNoteAs4     |     7647    |      29     |     223     |
#define SIDNoteB4      |     8101    |      31     |     165     |
#define SIDNoteC5      |     8583    |      33     |     135     |
#define SIDNoteCs5     |     9094    |      35     |     134     |
#define SIDNoteD5      |     9634    |      37     |     162     |
#define SIDNoteDs5     |    10207    |      39     |     223     |
#define SIDNoteE5      |    10814    |      42     |      62     |
#define SIDNoteF5      |    11457    |      44     |     193     |
#define SIDNoteFs5     |    12139    |      47     |     107     |
#define SIDNoteG5      |    12860    |      50     |      60     |
#define SIDNoteGs5     |    13625    |      53     |      57     |
#define SIDNoteA5      |    14435    |      56     |      99     |
#define SIDNoteAs5     |    15294    |      59     |     190     |
#define SIDNoteB5      |    16203    |      63     |      75     |
#define SIDNoteC6      |    17167    |      67     |      15     |
#define SIDNoteCs6     |    18188    |      71     |      12     |
#define SIDNoteD6      |    19269    |      75     |      69     |
#define SIDNoteDs6     |    20415    |      79     |     191     |
#define SIDNoteE6      |    21629    |      84     |     125     |
#define SIDNoteF6      |    22915    |      89     |     131     |
#define SIDNoteFs6     |    24278    |      94     |     214     |
#define SIDNoteG6      |    25721    |     100     |     121     |
#define SIDNoteGs6     |    27251    |     106     |     115     |
#define SIDNoteA6      |    28871    |     112     |     199     |
#define SIDNoteAs6     |    30588    |     119     |     124     |
#define SIDNoteB6      |    32407    |     126     |     151     |
#define SIDNoteC7      |    34334    |     134     |      30     |
#define SIDNoteCs7     |    36376    |     142     |      24     |
#define SIDNoteD7      |    38539    |     150     |     139     |
#define SIDNoteDs7     |    40830    |     159     |     126     |
#define SIDNoteE7      |    43258    |     168     |     250     |
#define SIDNoteF7      |    45830    |     179     |       6     |
#define SIDNoteFs7     |    48556    |     189     |     172     |
#define SIDNoteG7      |    51443    |     200     |     243     |
#define SIDNoteGs7     |    54502    |     212     |     230     |
#define SIDNoteA7      |    57743    |     225     |     143     |
#define SIDNoteAs7     |    61176    |     238     |     248     |
#define SIDNoteB7      |    64814    |     253     |      46     |


#endif	/* SID_PIC_H */

