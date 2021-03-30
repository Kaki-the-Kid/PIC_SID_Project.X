
 Cubase64 by Pex 'Mahoney' Tufvesson
Released at X'2010 in the Netherlands, October 2010.


It is true, the Commodore 64 can do audio effects!


The Cubase64 demo uses all the tricks in the book,
in order to achieve the best sound quality possible:

 * The sound buffer is calculated in the stack, and it wraps
 * Jitter free sample playback, by using NMI IRQ vector pointing to $dd04
 * 8-bit sample output by using SID test bit for resetting oscillators
 * saving clock cycles by JMP $dd0c when exiting an NMI
 * Pitch tables? Good for module playback, but worthless for human voices
 * Phase-aligned wavetables with extracted formants
 * Full 8-bit interpolation between formants with 16 different volume ratios
 * 16 volume levels for resulting audio output
 * self-modifying code, of course
 * critical code run in Zero Page
 * Echo with 0-33ms echo delay, feedback gain and input gain
 * Time stretch, 0-200% speed without changing the pitch
 * Vocoder with 51 frequency bands
 * Auto Tune with speed setting
 * Sub bass synthesizer
 * Equalizer with three different filter types, resonanse and cutoff settings
 * Tube Distortion emulation
 * Grungelizer, selecting 8-bit down to 1-bit output resolution
 * Audio compressor
 * Dithering noise, to make quantization smoother
 * Master gain
 * ...while only ~15 assembly instructions per sample available
 * ...and still cpu-time left for a gui!

The encoder uses some seriously advanced signal processing as well:

 * sub-sample pitch detection
 * auto-tuning into constant-pitch audio
 * formant extraction, sub-sample phase-alignment and normalization
 * formant cross correlation and selection
 * consonant detection and extraction
 * run-length encoding of data with _minimal_ unpacking overhead
 * requires 1.5GB of RAM and 500MB of hard drive space


ps. If you want to try this on a Commodore 64 emulator, please use
a proper SID emulation mode. Use the "reSID-FP" with a 6581 chip.
For instance, with Vice 2.1 (www.viceteam.org), start it with:
x64 -sidengine 7 -soundrate 44100 -soundsync 2 cubase64.prg


If you want to know more, grab the Cubase64 White Paper from
my homepage at http://mahoney.c64.org
It's all there, explained.


Have a noise night!

/ Pex 'Mahoney' Tufvesson
http://mahoney.c64.org
http://www.livet.se/visa
