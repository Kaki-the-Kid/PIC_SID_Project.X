;
; cubase64 demo
;
;by Pex 'Mahoney' Tufvesson, October 2010.
;Released at X'2010.
;
;If you want to encode another song, please look through
;the encoder folder first. The data from the song is
;in the files named SID*.s in this (the decoder) folder.
;
;There are make files, not very complete ones, but they
;do the trick for me.
;
;The whole thing, decoder and demo, is included in the
;files main.s and wrapper.s
;
;on Linux:  rename makefile_linux to makefile, then make run
;on Win32:  rename makefile_win   to makefile, then nmake.exe run
;
;The resulting Commodore 64 executable is in the file
;cubase64.prg
;
;Sorry for not making the source code easy to follow.
;And, the coding is a mess, which it has to be to be able to
;do the things it does.
;But, I never said it would be easy! ;)
;
;
; Good luck...! You'll need it! :-D
;
;
;Have a noise night!
;
;/ Pex 'Mahoney' Tufvesson
;http://mahoney.c64.org
;http://www.livet.se/visa
;



;Cubase64

;This is the complete effects chain:
;Time Stretch. 20-200%. (Coded as 0x000-0x1ff)
;Vocoder. Pitch 0-100%. (Coded as 0x00-0xff)
;Autotune. On / Off. Speed or strength.
;Sub bass synthesizer. Level+waveform.
;Eq. Lowpass, highpass, bandpass. Resonance. Cutoff frequency.
;Tube Distortion. 0 - 100%
;Echo: Delay 0-31ms. Feedback. Input gain.
;Grungelizer: 8, 7, 6, 5, 4, 3, 2, 1 bit resolution
;Compressor. Add 0-15 to mainVolume, clamp at 15. "Gain"
;Dithering. Type 1, Type 2 or off.
;Master Gain. 0dB - -40dB.
;Spectrum Analyzer


                            


;### Known issues
;
; This is a list of all things that should/could be fixed.
; Some are easy, some are impossible!

;* Make subbass "not" click when turning it off.
;    I'm using the test bit for turning it on. Half the problem solved.
;    could use decay, but probably not, since it will be difficult to retrigger the attack without
;    audible bad stuff.
;* Add message "switching to manual mode" when starting to use joystick before we have reached the greetings
;    or just jump to the greetings when joystick is used for the first time,
;    unless we're already at the greetings, that is.
;* Grungelizer/tube distortion bug:
;    will fail if we manage to move joystick down directly after
;    joystick right/left that will change the setting. The setting won't be applied.
;* Encoder:
;    Low pass filter individual waveforms regarding to their "max pitch".
;    A waveform always played att 100% speed can have a 3.9kHz cutoff.
;    A waveform sometimes played att 200% speed needs a 1.9kHz cutoff.
;* Change the song into some other song.
;* When having recalculated the volume table
;    (when changing grungelizer or tube distortion settings)
;    There is a little blue flicker in the upper/lower border,
;    since we temporarily are _not_ removing the border.
;* Using the tape for streaming music? (Which is "kind of stupid" imho)
;    IRQ tape loading uses these distances:
;    0 - 446 cycles.
;    1 - 668 cycles.
;    Timer - 576 cycles.
;    Every raster line is 63 cycles, so a 1 takes ~11 raster lines to transfer.
;    This equals a transfer rate of 313/11 = 28 bits per frame.
;    This is 3.5 bytes per frame, which is too little.
;    Turbo tape uses these values:
;     0 - 216 cycles.
;    1 - 326 cycles.
;    This is 61 bits/frame, which is 7.6 bytes per frame. This could work.
;    We need a seriously well-timed routine for grabbing these.
;    We could poll the $dc0d register every 2nd raster line and do something useful with it, I guess.
;    There is _no_ way of stalling the incoming data, so it must adhere to a brainless
;    format where no jitter or encoding will change the information rate.
;    Bit 4 in $dc0d is the cassette read bit.
;    It will probably be too complicated to decode this bit during the synchronized SID-replay routine.
;* Disk streaming, approx 3kB/s with loader
;    This is 60 bytes per frame, and this is well more than we need.
;    Could try to do streaming, this would free up ~26kB of unneeded stale data.
;    One byte takes ~90 cycles to grab.
;    10 bytes = 900 cycles.
;    This is probably not doable, since it takes too much cpu-time (15 raster lines).
;* Timeshift
;    We could "beautify" really slow playback rates by doing better
;    volume table/fade in/out counters.
;    Idea: Make wave selection and volume setting only "half rate" as default.
;          This would make 50% speed the default, and 100% would equal 200%.
;          This will also make the encoded song use less memory.
;          Or, could use different rate for volume encoding, noise encoding
;          and waveform selection.
;* Vocoder
;    Play the desired note on the keyboard.
;    Can do a little pitch bend between the notes that we play with, with selectable
;    bend speed.
;    Problem: Keyboard scanning takes a lot of clock cycles when reading all of the keyboard.
;* Autotune
;    adapt the autotuneTable to only include notes that are actually used in the song.
;* Echo
;    for a longer delay than 33ms:
;    Could be rendered like "polyphonic vocoder", with 4 separate echoes, with a little
;    delay in control data. Would require pitch tables to be used, though.
;* Synchronization
;    Could start using "constant rate" for waveform selection encoding.
;    This would make the "polyphonic vocoder" easier to code.
;    To faciliate transitions without clicks, the render loop would
;    grab new values from the IRQ when available.
;    IRQ will write new values into a temporary area, and the render loop
;    will grab them when they are changed.
;    IRQ will need to produce new values twice every frame.
;    This would make way for also playing SID sounds in sync with the samples.
;    The IRQ could also completely shut off the NMI when there is silence.
;* Pitch shift
;    Will need another adc #shift_value    bcc  do_nothing  dex/inx   do_nothing:
;    inside the main rendering loop. And, this will introduce mirrored frequencies in the
;    baseband at 3900Hz when pitch gets too high.
;    Or, be lazy and just pitch shift "up until max pitch" and
;    "down to 0 pitch" (needs another renderloop for playing samples slower than 100%.
;    Probably, choose the latter approach. This will change the timing
;    of the song, could probably compensate for that when pitch values get "clipped".
;* Polyphonic vocoder
;    Use worse sound, but have pitch tables and a number of independent voices.
;    Pitch tables takes a lot of memory, but we'll only need 16 of them.
;    This will need a completely different synchronization/buffer strategy.
;    And, the volume tables needs to be changes... well, there should actually
;    not be used any volume tables at all in this mode.
;* Reverse audio
;    Difficult, due to the forward encoding of pitch values.



;Ideas for songs that could be used instead of Tom's Diner:
;* Tom's Diner / Suzanne Vega
;Uses these notes:
;% D   Hz(18)  146.8323839587038 Hz   up to  D   Hz(30) 293.6647679174077 Hz    
;* Careless Whisper a cappella/ George Michael
;* Enjoy the silence a cappella / Depeche Mode
;* Sexual a cappella / Amber
;   The chorus has more than one voice at a time.

;If we should use a SID song to match any of these, this probably fits all of them
;with little or no modification:
;   TaskIII







; Funny macro to translate ISO8859-1 ASCII to C64 screen codes:

.macro _SCREEN arg1
  .if (arg1<'A')
    .byte 0+arg1
  .elseif (arg1<('Z'+1))
    .byte (arg1-$20)
  .elseif (arg1<'a')
    .byte 0+arg1
  .elseif (arg1<('z'+1))
    .byte (arg1-$60)
  .else
    .byte 0+arg1
  .endif
.endmacro

.macro SCREEN Arg
  .repeat .strlen(Arg), i

  .if (.strat(Arg,i)<'A')
          .byte 0+.strat(Arg,i)
  .else
    .if (.strat(Arg,i)<('Z'+1))
          .byte (.strat(Arg,i)-$00)
    .else
    .if (.strat(Arg,i)<'a')
          .byte 0+.strat(Arg,i)
    .else
      .if (.strat(Arg,i)<('z'+1))
          .byte (.strat(Arg,i)-$60)
      .else
          .byte 0+.strat(Arg,i)
      .endif
    .endif
    .endif
  .endif
  .endrepeat
.endmacro 


;This is the complete effects chain, all settings:

;Time Stretch. 20-200%. (Coded as 0x000-0x0ff)
setTimeStretch = $02

;Vocoder. Pitch 0-100%. (Coded as 0x00-0xff)
setVocoderPitch = $03; 0x00 = off

;Autotune. 0x00 = off, 0x01-0xff = Speed, 0xff means maximum effect 
setAutotuneStrength = $04

;Sub bass synthesizer. 0x00=off, 0x10 - 0xff = level.
setSubBass = $05; 

;Eq. Lowpass, highpass, bandpass. Resonance. Cutoff frequency.
setEqType = $06; 0x00=off, 0x10=lowpass, 0x20=bandpass, 0x40=highpass
setEqReso = $07; 0x00=off, 0x01-0x0f = resonance
setEqFreq = $08; 0x00=lowest, 0xff = highest

;Tube Distortion. 0 - 100%
setTubeDist = $09; 0x00=off, 0x01=on

;Echo: Delay 0-31ms. Feedback. Input gain.
setEchoDelay = $0a; 0x00=1 sample, 0xf0 = 240 samples
setEchoFeedback = $0b; 0x00 = echo Off, 0x01-0xff feedback
setEchoInputGain = $0c; 0x00 = no sound, 0x01-0xff Input level

;Grungelizer: 8, 7, 6, 5, 4, 3, 2, 1 bit resolution
setGrunge = $0d; 0x00=Grungelizer off, 1=7-bit, 2=6-bit, 3=5-bit, 4=4-bit, 5=3-bit, 6=2-bit 7=1-bit

;Compressor. Add 0-15 to mainVolume, clamp at 15. "Gain"
setCompLevel = $0e; 0x00 = compressor off, 0x01-0xff compressor Gain

;Dithering. Type 1, Type 2 or off.
setDither = $0f; 0x00 = off, 0x01 = type 1 (continuous), 0x02 = type 2 (silent when incoming sound is silent)

;Master Gain. 0dB - -40dB.
setMasterGain = $10; 0x00 = -inf dB, 0x01 - 0x0f = volume. 0x0f is the maximum.

;Spectrum Analyzer
;ToDo...

guiLastRow = $11
guiThisRow = $12 ;Which setting we're changing right now
guiCou = $13
setCompLevelLow = $14; A 4-times shifted version of setCompLevel
storyPoi = $15; a 2-byte pointer
currentJoy = $17; what the "demo-mode" of the demo uses to simulate joystick movement
autotuneAddAmount = $18; setAutotuneStrength / 16
autotuneSubAmount = $19; -setAutotuneStrength / 16

timeshiftSpeed = $1d
                        ;If timeshiftSpeed=0x00 and timeShiftFaster_nSlower = 1, this is "normal speed"
                        ;0x000 = no speed at all, static sound
                        ;0x080 = 50% speed
                        ;0x100 = 100% speed
                        ;0x180 = 150% speed
                        ;0x1ff = 199% speed
timeshiftFaster_nSlower = $1e
thisWave3 = $20
thisWave2 = $21
ticksToTrig = $27
SaveA = $28
SaveX = $29
SaveY = $2a
interpolValue = $2b
thisWave = $2d
nextWave = $2e
countLSB = $2f
thisVolume = $31
spriteWait = $32
oldWave = $33  ;For noise playing
ticksToWait = $34
SIDenc3SpeedPoi = $35 ;Two-byte pointer
currentSpeed = $37
doingHighNybble = $38
nofWaveRepeats = $39
SIDencWavePoi = $3a ;Two-byte pointer
noisePoi = $3c; Two-byte pointer
ZeroCodeDest = $40;

;---------------------------------------------------------------------------
  .org $0256         ;Two bytes earlier to make room for loading address.
  .word $0258        ;Loading address
;  sei         ;done already in the pucrunch depack routine
;  lda #$35    ;-"-
;  sta $01
  ldx #$ff
  txs
  lda #$80   ;Fill the sound buffer with silence
  ldx #$c0
moreZeros:
  pha
  dex
  bne moreZeros
  jsr storyInit
  lda #$00
  sta $d020
  sta $d021
  ldx #00
  lda #$00
clrCol: 
  sta $d828,x
  sta $d900,x
  sta $da00,x
  sta $db00,x
  dex
  bne clrCol
  ldx #$27
  lda #$e
clrCol2:  
  sta $d800,x
  dex
  bpl clrCol2
  lda #$f8    ;Screen at $fc00, charset at $e000-
  sta $d018
  lda $DD00
  and #%11111100
;  ora #%00000000 ;choose $c000-$ffff bank3
  sta $DD00

  lda #$c8
  sta $d016
;Initialize Joystick scanning:
  lda #$00
  sta $dc02  ;Make joystick A pins inputs

;;Initialize Keyboard scanning:
;	lda #$0
;	sta $dd03	; port b ddr (input)
;	lda #$ff
;	sta $dd02	; port a ddr (output)

;guiInit
  ldx #0
  stx guiLastRow
  stx guiThisRow ;Which setting we're changing right now
  ldx #$1
  stx guiCou

;nmiInit
  ldx #ZeroCodeEnd-ZeroCode+1
moveMore:
  lda ZeroCode-1,x
  sta ZeroCodeDest-1,x
  dex
  bne moveMore
  ldx #$18
  lda #0
clrLoop:
  sta $d400,X
  dex
  bpl clrLoop
  lda #$4f ;High pass filter
  sta $d418
  lda #$f0 ;Max sustain level
  sta $d406

;playNoiseInit
  lda #$22
  sta $d413 ;SID voice3 attack speed = 2, decay speed = 2
            ;This is to make sure that we don't trigger
            ;the ADSR-bug. Otherwise, if we want to change
            ;attack/decay/release speed, make sure to
            ;change "the one that isn't used":
            ;   change attack/decay speed when bit0 in $d404 is = 0.
            ;   change release speed when bit0 in $d404 = 1
  lda #230  ;Max frequency of noise clocking, could be changed if we
  sta $d40e ;want to use the -15dB notch-filter-like dip that is present
  sta $d40f ;in the passband. freq $ffff -> notch at 10kHz.
  ldx #255  ;something else for voice 2, this is the "dithering noise"
  stx $d407
  stx $d408
  stx thisWave2 ;Silent waveforms
  stx thisWave3
  inx
  stx oldWave
  lda #$10
  sta $d40d ;Sustain level for voice 2, "dithering noise"
  lda #1    ;Trig ADS-cycle for dithering noise, to ensure that we get to the
            ;sustain level directly
  sta $d40b
  lda #$06   ;No resonance, filter on voice 2+3
  sta $d417
;  lda #$4f   ;High pass filter, max volume
;  sta $d418
  lda #$a0   ;$b0Cutoff
  sta $d415
  sta $d416
  
  jsr makeVolumeTable
;$D018 = %xxxx100x -> charmem is at $2000
;$D018 = %1111xxxx -> screenmem is at $3c00 = $fc00
  ;uppermost bit in color mem turns on multicolor
  
;Set default values:
  lda #$80
  sta setTimeStretch
  lda #0
  sta setVocoderPitch  ; 0x00 = off
  sta setAutotuneStrength
  sta autotuneAddAmount
  sta setSubBass ;0x00=off, 0x10 - 0xff = volu0x00=off, 0x10=lowpass, 0x20=bandpass, 0x40=highpass
  sta setEqType ; 0x00=off, 0x10=lowpass, 0x20=bandpass, 0x40=highpass
  sta setEqReso ; 0x00=off, 0x01-0x0f = resonance
  sta setEqFreq ; 0x00=lowest, 0xff = highest
  sta setTubeDist ; 0x00=off, 0x01=on
  sta setEchoFeedback ; 0x00 = echo Off, 0x01-0xff feedback
  sta setGrunge ; 0x00=Grungelizer off, 1=7-bit, 2=6-bit, 3=5-bit, 4=4-bit, 5=3-bit, 6=2-bit 7=1-bit
  sta setCompLevel ; 0x00 = compressor off, 0x01-0xff compressor Gain
  sta setCompLevelLow ; 0x00 = compressor off, 0x01-0x0f compressor Gain
  ldx #$ff
  stx setEchoDelay ; 0x00=1 sample, 0xf0 = 240 samples
  stx setEchoInputGain ; 0x00 = no sound, 0x01-0xff Input level
  stx setMasterGain ; 0x00 = -inf dB, 0x01 - 0x0f = volume. 0x0f is the maximum.
  ldx #$00
  stx setDither ; 0x00 = off, 0x10 = type 1 (continuous), 0x20 = type 2 (silent when incoming sound is silent)

  
  lda #0
  sta timeshiftFaster_nSlower
  lda #$ff
  sta timeshiftSpeed

  jsr restartSong
  jsr nmiStart
  jmp letsGo

; ---------------------------------------------------------------------------
;This piece of code is moved into ZeroPage to make
;execution faster.

;Replay routine _with_ pitch playing a 51 byte long waveform located
;at $8000-$b300. One byte at every page. There are 256 waveforms.
;No more, no less.
;  Waveform 0 will have its bytes at $b300 (byte no# 0)
;                                    $b200 (byte no# 1)
;                                    $b100 (byte no# 2)
;                                    $8000 (byte no#51)
;  Waveform 1 will have its bytes at $b301 (byte no# 0)
;Waveform 255 will have its bytes at $b3ff (byte no# 0)

; This means that we have a total of 256*51/7812.5 = 1.671168 seconds
; of sample memory. This playroutine is capable of playing "lossless audio"
; for 1.67 seconds.
; Could extract "breathing" as a short sample, for instance.

; Pitching can be done from 100% speed
; up to 1.0 + 50/51 * 255/256 = 197.7% speed. (Not 200% since we don't do extra skip when wrapping to another
; waveform). nextSpeed:   0 = 100%
;                       255 = 197.7%

;By changing 2 bytes in the ZeroCode (DEC Poi+2  -> inc Poi+2), we could use memory
;$e000-$ffff for waveforms as well, but these waveforms will only be
;32 bytes long. They could be used for "no pitch samples", which would
;give us another 32*256 / 7812.5 = 1.05 seconds of waveform memory.
; But, this needs really good timing for switching the direction
; of pointers. OR - we'll implement a second replayroutine for these
; alone.

; We could save a couple of clock cycles by "double buffering" the
; replay routine. Then, the upcoming values for speed, waveform, and
; "next kind of sound" could be written well in advance into the unused replay
; routine.

ZeroCodeStart:
ZeroCode:
NMI_R1:
  lda #$11   ;output current value
  sta $d404
;  sta $d021  ;visualize it on screen
  lda #8     ;test bit = reset oscillator counter
  sta $d404
;  sta $d021  ;visualize it on screen
Poi_R1:
  lda $01ff
  sta $d401  ;set increment speed for next value            
;  sta $d021  ;visualize it on screen
  lda #1     ;start counting
  sta $d404
;  sta $d021  ;visualize it on screen
;  sta $d000  ;For making a waveform motion in a sprite
  ;dec     Poi_R1+1-ZeroCodeStart+ZeroCodeDest
  .byte $C6    ;DEC ZP
  .byte Poi_R1+1-ZeroCodeStart+ZeroCodeDest
SaveAnmi_R1:
  lda #0
  jmp $dd0c  ;Synchronous Serial I/O Data Buffer - will "read" DD0D
                  ;Which will clear pending NMI IRQ.
                  ;LDA $dd0d takes 4 cycles
                  ;JMP $dd0c takes 3 cycles

; The any+any loop:
zeroNextX:
  ldy #$32
zeroRenderLoop:
zeroPoi_RL1:
  ldx $8000,y                ;4 clocks, 5 if crossing page
zeroVolPoi_RL1:
  lda volumeTable+$0f00,x         ;4
;  clc                       ;2
zeroPoi_RL2:
  ldx $8000,y                ;4 clocks, 5 if crossing page
zeroVolPoi_RL2:
  adc volumeTable+$0f00,x         ;4 clocks, 5 if crossing page
  pha                        ;3 clocks
;Now check if we should skip 1 or 2 bytes:
zeroCountLSB:
  lda #0                    ;2 clocks
;Ideally, we should have a sec here. But hey - it doesn't really
;         matter that much, does it? ;)
;  sec                        ;2 clocks
zeroSpeedLSB_RL:
  sbc #0                     ;2 clocks
;  sta zeroCountLSB+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroCountLSB+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  bcs zeroNoY                    ;2 if not taken, 3 if taken, 4 if taken into antother page
  dey                        ;2
zeroNoY:
  dey                        ;2
  bpl zeroRenderLoop             ;2 if not taken, 3 if taken, 4 if taken into another page
  tya
  clc
  adc #waveLength
;  sta zeroNextX+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroNextX+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  jmp nextOnePlease


;
;; The echo loop:
zeroEchoNextX:
  ldy #$32
zeroEchoRenderLoop:
;Divide old sound by 2:
;  lda $0180
;  lsr          ;since $80 is the middle value, dividing it by 2 makes it in the range $00-$80

;Old sound * some other ratio:
  ldx $0180
zeroEchoFeedbackRatio:
  lda $c900,x         ;4
  
zeroEchoPoi_RL1:
  ldx $8000,y                ;4 clocks, 5 if crossing page
zeroEchoVolPoi_RL1:
  adc volumeTable+$0f00,x         ;4
;  adc #$40     ;Make $80 the "mean value"
  pha                        ;3 clocks
;  dec zeroEchoRenderLoop+1-ZeroCodeStart+ZeroCodeDest
  .byte $C6    ;DEC ZP
  .byte zeroEchoRenderLoop+1-ZeroCodeStart+ZeroCodeDest
;Now check if we should skip 1 or 2 bytes:
zeroEchoCountLSB:
  lda #0                    ;2 clocks
;Ideally, we should have a sec here. But hey - it doesn't really
;         matter that much, does it? ;)
;  sec                        ;2 clocks
zeroEchoSpeedLSB_RL:
  sbc #0                     ;2 clocks
;  sta zeroEchoCountLSB+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoCountLSB+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  bcs zeroEchoNoY                    ;2 if not taken, 3 if taken, 4 if taken into antother page
  dey                        ;2
zeroEchoNoY:
  dey                        ;2
  bpl zeroEchoRenderLoop             ;2 if not taken, 3 if taken, 4 if taken into another page
  tya
  clc
  adc #waveLength
;  sta zeroEchoNextX+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoNextX+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  jmp nextOnePlease

ZeroCodeEnd:



  .RES $0400-*,$00



  SCREEN "   cubase64 by pex mahoney tufvesson    "
;  SCREEN "                                        "
;  SCREEN "                                        "
;  SCREEN " the 6502 cpu was born in mid 70'ies,   "
;  SCREEN " - and so was i. there is probably no   "
;  SCREEN " logical reason for me being around     "
;  SCREEN " still teaching old computers how to do "
;  SCREEN " perform all the cool new tricks that   "
;  SCREEN " the world around us come up with.      "
;  SCREEN " but i do enjoy it, and somehow, so do  "
;  SCREEN " you since you're actually reading this "
;  SCREEN " short note somehow.                    "
;  SCREEN "                                        "
;  SCREEN "   life is wonderful, so take a deep    "
;  SCREEN "    breath, be amazed. or appalled.     "
;  SCREEN "                                        "
;  SCREEN "  whatever. if you manage to read this  "
;  SCREEN "   your're a fast reader. if you some   "
;  SCREEN "    day find yourself wondering how     "
;  SCREEN "     this all works, please take a      "
;  SCREEN "         look at the webpage            "
;  SCREEN "                                        "
;  SCREEN "        http://mahoney.c64.org          "
;  SCREEN "                                        "
;  SCREEN " there is an explanation for everything "



;-----------------------------
  .RES $0800-*,$20
;  .org $0800
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1        ;Zero page write
  jmp ZeroCodeDest    ;Waste no cycles
  nop ;waste 3 bytes to make this code appear at $0808:
  nop
  nop



newVolumeTable:
  lda setTubeDist ;if $00-$0f = normal volume, $10-$1f=50% normal+50% tube, $20-$2f=100% tube
  and #$30
  beq normalVolume
  cmp #$10
  bne notHalfHalf
  jmp fakeTubeVolumeTable
notHalfHalf:
  jmp doTubeVolume
normalVolume:  
makeVolumeTable:

;* Speedup calculation of linear volume tables.
;   instead of 16-bit multiplications, do a linear interpolation between desired values.
;   Improve speed when recalculating grunge and tube
;   Grungelizer to "lower bit depth" could just read-modify-write the table, but we
;   don't need to optimize this any further, it is good enough.
fakeVolumeTable:
  lda #$c0
  sta fakeAddr+2
fakeOuterLoop:
  lda fakeAddr+2
  and #$0f
  tay
;This is the start value to use:
  lda fakeStarts,y
  sec
  sbc #$40
  sta startValue+1
;This is the speed to use:
  lda fakeSpeeds,y
  sta fakeSpeed+1
;This is the phase to start with:
  lda #0
  ldy #0
startValue:
  ldx #0
fakeLoop:
  tay
  txa
grungelizerAnd:  ;Set to
                 ;0xff = 8-bit, 0xfe = 7-bit, 0xfc = 6-bit, 0xf8 = 5-bit, 0xf0 = 4-bit, 0xe0 = 3-bit, 0xc0 = 2-bit, 0x80 = 1-bit
  and #$ff
  clc
  adc #$40
fakeAddr:
  sta $8000
  tya
  clc
fakeSpeed:
  adc #$0
  bcc noInc
  inx
noInc:
  inc fakeAddr+1
  bne fakeLoop
  inc fakeAddr+2
  lda fakeAddr+2
  cmp #$d0
  bne fakeOuterLoop
  rts

fakeStarts:
  .byte $39,$31,$2a,$22,$1b,$13,$0c,$04,$fd,$f5,$ee,$e6,$df,$d7,$d0,$c8
;fakeEnds:
;  .byte $47,$4e,$56,$5d,$65,$6c,$74,$7b,$83,$8a,$92,$99,$a1,$a8,$b0,$b7
fakeSpeeds:
  .byte $47-$39+1
  .byte $4e-$31+1
  .byte $56-$2a+1
  .byte $5d-$22+1
  .byte $65-$1b+1
  .byte $6c-$13+1
  .byte $74-$0c+1
  .byte $7b-$04+1
  .byte $83-$fd+1
  .byte $8a-$f5+1
  .byte $92-$ee+1
  .byte $99-$e6+1
  .byte $a1-$df+1
  .byte $a8-$d7+1
  .byte $b0-$d0+1
  .byte $b7-$c8+1

fakeTubeVolumeTable:
;This loop will make a volume table that is "half linear volume" + "half tube distortion table"
;With grungelizing.

;Cannot remove upper and lower borders while doing
;this calculation.
;Need to dismantle nmi before we disable $d000 registers
;Could write 8 different "non-handshaking" nmi's.
;Hopefully, they will tell the timers to go silent
;Or just disable timer nmi connection.
  lda #$40  ;RTI
  sta $0404 ;This is an "unused" memorylocation which is "almost" like $dc04.
            ;By just changing the MSB of the NMI, we eliminate the
            ;risk of triggering an NMI while trying to change both
            ;LSB and MSB of the NMI vector.
;  lda #4
;  sta $fffa  ;NMI
  lda #$04    ;is $dc normally
  sta $fffb  ;NMI
;Now it's safe to turn $d000-$dfff registers off and
;get access to the RAM below, which happens to contain
;a pre-calculated tube distortion table.
  lda #$34
  sta $01

  lda #$c0
  sta fakeTubeAddr+2
  lda #$d0
  sta fakeTubeAddr2+2
fakeTubeOuterLoop:
  lda fakeTubeAddr+2
  and #$0f
  tay
;This is the start value to use:
  lda fakeStarts,y
  sec
  sbc #$40
  sta startTubeValue+1
;This is the speed to use:
  lda fakeSpeeds,y
  sta fakeTubeSpeed+1
;This is the phase to start with:
  lda #0
  ldy #0
startTubeValue:
  ldx #0
fakeTubeLoop:
  tay
fakeTubeAddr2:
  lda $d000
;asr:
  cmp #$80
  ror
  sta tubeAdd+1
  txa
;asr:
  cmp #$80
  ror
  clc
tubeAdd:
  adc #$0
  and grungelizerAnd+1
  clc
  adc #$40
fakeTubeAddr:
  sta $c000
  tya
  clc
fakeTubeSpeed:
  adc #$0
  bcc noTubeInc
  inx
noTubeInc:
  inc fakeTubeAddr2+1
  inc fakeTubeAddr+1
  bne fakeTubeLoop
  inc fakeTubeAddr2+2
  inc fakeTubeAddr+2
  lda fakeTubeAddr+2
  cmp #$d0
  bne fakeTubeOuterLoop
  lda #$35
  sta $01
;Now it's time to enable NMIs again:
  lda #$dc    ;was pointing to $0404 during calculations,
              ;now we set it back to $dc04
  sta $fffb  ;NMI
  lda $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
             ;Synchronous Serial I/O Data Buffer
             ;A read will clear pending NMI IRQ.
             ;Since NMI is edge triggered, this
             ;will make sure that new nmi IRQs can happen.
  rts





;
;;This is the original way of making a volume table.
;;It is slow and uses 8-bit multiplications.
;
;
;;  lda #<volumeTable
;;  sta ampDest+1
;  lda #>volumeTable
;  sta ampDest+2
;  lda #$0f
;  sta moreAmp+1
;makeVolumeTable:
;; Yes, I know this is slow and could be done faster.
;; But, it doesn't matter, does it? :-D
;;  lda #$11
;;  sta moreAmp+1 ;Desired volume
;  lda #$80
;  ldx moreAmp+1
;  jsr MULT8
;  sta ZeroRef
;  ldy #0
;moreAmp:
;  ldx #$0f   ;The desired volume for volume table #0
;  tya
;  jsr MULT8
;  lda PROD+1
;  sec
;  sbc ZeroRef
;grungelizerAnd:  ;Set to
;                 ;0xff = 8-bit, 0xfe = 7-bit, 0xfc = 6-bit, 0xf8 = 5-bit, 0xf0 = 4-bit, 0xe0 = 3-bit, 0xc0 = 2-bit, 0x80 = 1-bit
;  and #$ff
;  clc
;  adc #$40
;ampDest:
;  sta volumeTable,y
;  iny
;  bne moreAmp
;  lda moreAmp+1
;  clc
;  adc #$0f      ;The desired volume increase for next table
;  sta moreAmp+1
;  lda ampDest+2
;  clc
;  adc #1
;  sta ampDest+2
;  cmp #>volumeTable+16
;  bne makeVolumeTable
;  rts
;
;ZeroRef: .byte 0
;PROD: .byte 0,0
;MPR: .byte 0
;MPD: .byte 0,0
;;-------------------------------------------------------
;; MULTIPLY ROUTINE 8x8=>16 unsigned
;; Accumulator*X -> [PRODL,PRODH] (low,hi) 16 bit result
;MULT8:
;  sta MPR
;  stx MPD
;  clc
;  lda #0
;  sta MPD+1
;  sta PROD
;  sta PROD+1
;
;  ldx #8
;LOOPMUL:
;  lsr MPR
;  bcc NOADD
;  clc
;  lda PROD
;  adc MPD
;  sta PROD
;  lda PROD+1
;  adc MPD+1
;  sta PROD+1
;NOADD:
;  asl MPD
;  rol MPD+1
;  dex
;  bne LOOPMUL
;  rts

  .RES $0900-*,$00
;  .org $0900
; sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  .byte $8d        ;STA 16-bit addr, Waste 1 cycle
  .byte SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  .byte 0
  jmp ZeroCodeDest
  nop ;waste 2 bytes to make this code appear at $0908:
  nop

IRQ:
  sta SaveA
;  inc $d020
  lda #$1b
  sta $d011
  lda #<IRQ2
  sta $FFFE  ;IRQ low
;Slightly dangerous optimization: $ffff is already correct
;  lda #>IRQ2
;  sta $FFFF  ;IRQ high
  lda #$f8    ;Could be something between $f2 and $fa
  sta $d012
;  lda #82
;  sta $d001
  sty SaveY
  stx SaveX
;  jsr scanKeyboard
  jsr storyIrq
  jsr guiDo
  ldx SaveX
  ldy SaveY
  lda SaveA
  inc $d019 ;ack IRQ
  rti

IRQ2:
  sta SaveA
  inc $d019 ;ack IRQ
;  dec $d020
  lda #$13      ;Make sure that DEN (bit4) is 0 during raster line $30 - if we want to only display sprite0
  sta $d011
  lda #<IRQ
  sta $FFFE  ;IRQ low
;Slightly dangerous optimization: $ffff is already correct
;  lda #>IRQ
;  sta $FFFF  ;IRQ high
  lda #11 ;=49
  sta $d012
;  lda #40
;  sta $d001
  lda SaveA
  rti


;Keyboard table from http://codebase64.org/doku.php?id=base:reading_the_keyboard
;+----+----------------------+-------------------------------------------------------------------------------------------------------+
;|    |                      |                                Peek from $dc01 (code in paranthesis):                                 |
;|row:| $dc00:               +------------+------------+------------+------------+------------+------------+------------+------------+
;|    |                      |   BIT 7    |   BIT 6    |   BIT 5    |   BIT 4    |   BIT 3    |   BIT 2    |   BIT 1    |   BIT 0    |
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
;|1.  | #%11111110 (254/$fe) | DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
;|2.  | #%11111101 (253/$fd) |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
;|3.  | #%11111011 (251/$fb) |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
;|4.  | #%11110111 (247/$f7) |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
;|5.  | #%11101111 (239/$ef) |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
;|6.  | #%11011111 (223/$df) |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
;|7.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
;|8.  | #%01111111 (127/$7f) | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
;+----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+

;Would like to map a keyboard like this:
;Note - Key - Row - pitch
; D      x     3     0  
; D#     d     3     21  - Not used in the song
; E      c     3     43 
; F      v     4     64 
; F#     g     4     86 
; G      b     4     107 - Not used in the song
; G#     h     4     128
; A      n     5     149
; A#     j     5     171 - Not used in the song
; B      m     5     192
; C      ,     6     213 - Not used in the song
; C#     l     6     235
; D      .     6     255

;The perfect pitch positions are given by the formula
;NoteNumber (0 - 12) * $100 / 12 = NoteNumber * 21.333
;% The notes of Tom's Diner are:
;% I  am sit-ting in the mor-ning at  the Di-ner on   the cor-ner
;% F# G# A   C#   F# G#  A   C#   F#  C#  B   A  B    A   B   A
;% I  am wai-ting at the coun-ter for the man to pour the cof-fe
;
;% and he fills it only halfway and before I even argue
;% F#  F  E     C# C#   C#  B   A   F# D   C# C# B D C#
;% He is looking at the window at somebody coming in
;% A  B  C#  D   A  B   C#  D   A D   D C# C#  B  C#


;	lda #%11111101
;	sta $dc00
;	lda $dc01
;	and #%10000000
;	beq shifted	;left shift pressed
;
;	lda #%10111111
;	sta $dc00
;	lda $dc01
;	and #%00010000
;	beq shifted	;right shift pressed

;
;noKeyPressed:
;  lda #0
;  sta keyPressed+1
;  rts
;;Not allowed to use register X in routine below:
;scanKeyboard:
;	lda #$00
;	sta $dc00	; port a
;	lda $dc01       ; port b
;	cmp #$ff
;	beq noKeyPressed
;;Below here, put all key presses that are continuous:	
;	lda #%11111101
;	sta $dc00
;	lda $dc01
;	and #%10000000
;	bne noLeftShift
;;left shift pressed
;  lda timeshiftFaster_nSlower
;  bne above100
;  lda timeshiftSpeed
;  cmp #$30
;  beq tooSlow
;  dec timeshiftSpeed
;  rts  
;above100:
;  dec timeshiftSpeed
;  bne noExtra
;  ;Skip $100, since I'm lazy
;  dec timeshiftSpeed
;  dec timeshiftFaster_nSlower
;noExtra:
;tooSlow:
;  rts
;noLeftShift:
;	lda #%10111111
;	sta $dc00
;	lda $dc01
;	and #%00010000
;	bne noRightShift
;;right shift pressed
;  
;  lda timeshiftFaster_nSlower
;  beq below100
;  lda timeshiftSpeed
;  cmp #$ff
;  beq tooFast
;  inc timeshiftSpeed
;  rts
;below100:
;  inc timeshiftSpeed
;  bne noExtra2
;  inc timeshiftFaster_nSlower
;noExtra2:
;tooFast:
;  rts
;  
;  inc timeshiftSpeed
;  rts
;noRightShift:
;	
;keyPressed:
;  lda #0
;  bne waitingForKeyRelease
;  inc keyPressed+1
;;Below this, put all key presses that are one-shot, triggered only once.
;	lda #%01111111
;	sta $dc00
;	lda $dc01
;	and #%00010000
;	bne noSpace
;  ldy playMode
;  iny
;  cpy #4
;  bne notLastPlaymode
;  ldy #0
;notLastPlaymode:
;  sty playMode
;waitingForKeyRelease:
;  rts
;  
;noSpace:
;  rts
;
  .RES $0a00-*,$00
;  .org $0a00
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  nop                     ;Waste 2 cycles
  jmp ZeroCodeDest
  nop ;waste 2 bytes to make this code appear at $0a08:
  nop


syncIt:
  jsr syncCPUtoScreenOhYes
  lda #4
  sta $fffa  ;NMI
  lda #$dc
  sta $fffb  ;NMI
  lda #$7d
  sta $dd04  ;Timer A: Low-Byte
  ldx #$0f
loopIt:
  dex
  bne loopIt
  ldx #$11
  stx $dd0e  ;CIA Control Register A
  bne inTheMiddle+1
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
inTheMiddle:
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$c9
  cmp #$24 ;  $24 $ea is a "BIT $EA" opcode
  nop

;Beware, the branch above must reside in the same page as the destination, otherwise the timing
;will be one clock cycle off, and bad things(TM) will happen.

  lda SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1  ;Magically written number from TimerB
  cmp #$11
  bne wasteACycle
wasteACycle:
  stx $dc0f  ;CIA Control Register B
  lda $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
  lda #$81
  sta $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
  lda #<IRQ
  sta $fffe  ;IRQ low
  lda #>IRQ
  sta $ffff  ;IRQ high
  lda #1
  sta $d01a  ;IRQ Mask Register: 1 = Interrupt Enabled
  lda #$80
  sta $d012  ;Read Raster / Write Raster Value for Compare IRQ
  lda #$1b
  sta $d011  ;VIC Control Register
  cli
nothingToDo:
  rts


  .RES $0b00-*,$00
;  .org $0b00
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  bit $ff             ;Waste 3 cycles
  jmp ZeroCodeDest
  nop ;waste a byte to make this code appear at $0b08:

guiDo:
  ldy guiCou
  bmi guiDemoMode
  lda #$e
guiOldPoi:
  sta $d800,y  ;dim the old one
  lda #1
guiNewPoi:
  sta $d800,y  ;Light the new one
  iny
  cpy #$27
  bne noEndd
  ldy #$80
noEndd:
  sty guiCou
noMovement:  
  rts

guiDemoMode:
  lda $dc00
  and $dc01
  and #$0f
  cmp #$0f
  beq noActiveJoy
  ldy #0
  sty joyEnabled+1  
  ldy #$ff
  sty currentJoy
noActiveJoy:
  and currentJoy
guiCurrentJmp:
  jmp chgTitle

chgTitle:
  and #$0f
  cmp #$0f
  beq noMovement
;Change from title into timestretch setting:
  lda #1
  sta guiCou
  lda #<($d800+(1*40))
  sta guiOldPoi+1
  lda #>($d800+(1*40))
  sta guiOldPoi+2
  lda #<($d800+(3*40))
  sta guiNewPoi+1
  lda #>($d800+(3*40))
  sta guiNewPoi+2
  lda #<chgTimestretch
  sta guiCurrentJmp+1
  lda #>chgTimestretch
  sta guiCurrentJmp+2
  rts


chgTimestretch:
  lsr
;  bcs noUp
;Do nothing, since we're on the top setting anyway...
;  rts
;noUp:
  lsr
  bcs noDown
;Change from timestretch into vocoder setting:
  lda #1
  sta guiCou
  lda #<($d800+(3*40))
  sta guiOldPoi+1
  lda #>($d800+(3*40))
  sta guiOldPoi+2
  lda #<($d800+(4*40))
  sta guiNewPoi+1
  lda #>($d800+(4*40))
  sta guiNewPoi+2
  lda #<chgVocoder
  sta guiCurrentJmp+1
  lda #>chgVocoder
  sta guiCurrentJmp+2
  rts
noDown:
  lsr
  bcs noLeft
  lda setTimeStretch
;  cmp #24
  beq nol
  sec
  sbc #1
  sta setTimeStretch
  tax

  asl
  sta timeshiftSpeed
  rol
  and #1
  sta timeshiftFaster_nSlower

  lda #$48
oldl:
  ldy #7
  sta screen1+(3*40)+21,y
  ldy theLsrTable,x
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(3*40)+21,y
  sty oldl+1
  sty oldr+1
  rts
  
  
nol:  
  rts
noLeft:
  lsr
  bcs noRight
  ldx setTimeStretch
  inx
  beq nor
  stx setTimeStretch
  txa
  
  asl
  sta timeshiftSpeed
  rol
  and #1
  sta timeshiftFaster_nSlower
  
  lda #$48
oldr:
  ldy #7
  sta screen1+(3*40)+21,y
  ldy theLsrTable,x
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(3*40)+21,y
  sty oldr+1
  sty oldl+1
nor:
;  rts
noRight:
  rts


    



  .RES $0c00-*,$00
;  .org $0c00
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  nop                    ;Waste 4 cycles
  nop
  jmp ZeroCodeDest
  nop ;waste a byte to make this code appear at $0c08:

chgVocoder:
  lsr
  bcs noUp2
;Change from vocoder into timestretch setting:
  lda #1
  sta guiCou
  lda #<($d800+(4*40))
  sta guiOldPoi+1
  lda #>($d800+(4*40))
  sta guiOldPoi+2
  lda #<($d800+(3*40))
  sta guiNewPoi+1
  lda #>($d800+(3*40))
  sta guiNewPoi+2
  lda #<chgTimestretch
  sta guiCurrentJmp+1
  lda #>chgTimestretch
  sta guiCurrentJmp+2
  rts
noUp2:
  lsr
  bcs noDown2
;Change from vocoder into autotune setting:
  lda #1
  sta guiCou
  lda #<($d800+(4*40))
  sta guiOldPoi+1
  lda #>($d800+(4*40))
  sta guiOldPoi+2
  lda #<($d800+(5*40))
  sta guiNewPoi+1
  lda #>($d800+(5*40))
  sta guiNewPoi+2
  lda #<chgAutotune
  sta guiCurrentJmp+1
  lda #>chgAutotune
  sta guiCurrentJmp+2
  rts
noDown2:
  lsr
  bcs noLeft2
  ldx setVocoderPitch
  beq noll2
  dex
  bne nor2
;VocoderPitch has become zero = no Vocoder. We need to set the timeshift according to setTimeStretch:
  lda setTimeStretch
  asl
  sta timeshiftSpeed
  rol
  and #1
  sta timeshiftFaster_nSlower
nor2:
  stx setVocoderPitch
  lda #$48
oldl2:
  ldy #0
  sta screen1+(4*40)+21,y
  ldy theLsrTable,x
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(4*40)+21,y
  sty oldl2+1
noll2:  
  rts
noLeft2:
  lsr
  bcs noRight2
  ldx setVocoderPitch
  inx
  bne nor2
noRight2:
  rts



chgAutotune:
  lsr
  bcs noUp3
;Change from autotune into vocoder setting:
  lda #1
  sta guiCou
  lda #<($d800+(5*40))
  sta guiOldPoi+1
  lda #>($d800+(5*40))
  sta guiOldPoi+2
  lda #<($d800+(4*40))
  sta guiNewPoi+1
  lda #>($d800+(4*40))
  sta guiNewPoi+2
  lda #<chgVocoder
  sta guiCurrentJmp+1
  lda #>chgVocoder
  sta guiCurrentJmp+2
  rts
noUp3:
  lsr
  bcs noDown3
;Change from autotune into sub setting:
  lda #1
  sta guiCou
  lda #<($d800+(5*40))
  sta guiOldPoi+1
  lda #>($d800+(5*40))
  sta guiOldPoi+2
  lda #<($d800+(6*40))
  sta guiNewPoi+1
  lda #>($d800+(6*40))
  sta guiNewPoi+2
  lda #<chgSub
  sta guiCurrentJmp+1
  lda #>chgSub
  sta guiCurrentJmp+2
  rts







  .RES $0d00-*,$00
;  .org $0d00
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  nop                    ;Waste 5 cycles
  bit $ff
  jmp ZeroCodeDest

noDown3:
  lsr
  bcs noLeft3
  ldx setAutotuneStrength
  beq noll3
  dex
nol3:
nor3:
  stx setAutotuneStrength
  lda #$48
oldl3:
  ldy #0
  sta screen1+(5*40)+21,y
  ldy theLsrTable,x
  sty autotuneAddAmount     ;setAutotuneStrength / 16
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(5*40)+21,y
  sty oldl3+1
  tya
  eor #$ff
  clc
  adc #1
  sta autotuneSubAmount     ;setAutotuneStrength / 16
noll3:
  rts
noLeft3:
  lsr
  bcs noRight3
  ldx setAutotuneStrength
  inx
  bne nor3
noRight3:
  rts



chgSub:
  lsr
  bcs noUp4
;Change from sub into autotune setting:
  lda #1
  sta guiCou
  lda #<($d800+(6*40))
  sta guiOldPoi+1
  lda #>($d800+(6*40))
  sta guiOldPoi+2
  lda #<($d800+(5*40))
  sta guiNewPoi+1
  lda #>($d800+(5*40))
  sta guiNewPoi+2
  lda #<chgAutotune
  sta guiCurrentJmp+1
  lda #>chgAutotune
  sta guiCurrentJmp+2
  rts
noUp4:
  lsr
  bcs noDown4
;Change from sub into eqpass setting:
  lda #1
  sta guiCou
  lda #<($d800+(6*40))
  sta guiOldPoi+1
  lda #>($d800+(6*40))
  sta guiOldPoi+2
  lda #<($d800+(8*40))
  sta guiNewPoi+1
  lda #>($d800+(8*40))
  sta guiNewPoi+2
  lda #<chgEqtype
  sta guiCurrentJmp+1
  lda #>chgEqtype
  sta guiCurrentJmp+2
  rts
noDown4:
  lsr
  bcs noLeft4
  ldx setSubBass
  beq noll4
  dex
nor4:
prSubBass:
  stx setSubBass
  lda #$48
oldl4:
  ldy #0
  sta screen1+(6*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(6*40)+21,y
  sty oldl4+1


oldLevel4:
  cpy #0
  beq noNeedToChangeLevel
  lda #0    ;Trig ADS-cycle for dithering noise, to ensure that we get to the
            ;sustain level directly
  sta $d40b
  sty oldLevel4+1
  lda setSubBass
  and #$f0
  sta $d40d ;Sustain level for voice 2, "dithering noise"
  lda #1    ;Trig ADS-cycle for dithering noise, to ensure that we get to the
            ;sustain level directly
  sta $d40b
  jmp setSIDfilterRegisters
noNeedToChangeLevel:




noll4:
  rts
noLeft4:
  lsr
  bcs noRight4
  ldx setSubBass
  inx
  cpx #$10
  bne noNeedToSilenceDither
;When coming here, we need to shut off dithering, since
;sub bass uses the same SID voice

;And, we need to remove filter on this voice
  jsr nor4
  lda #$11
  sta subBassWaveformOn+1
  lda #$1
  sta subBassWaveformOff+1
  ldx #0
  jmp prDither
noNeedToSilenceDither:
  cpx #0
  bne nor4
noRight4:
  rts



  .RES $0e00-*,$00
;  .org $0e00
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1
  nop                   ;Waste 6 cycles
  nop
  nop
  jmp ZeroCodeDest

;----------------------------------

; Now it's time to run-length encode these.
; Encode them as:
; SIDwave:
; Byte even: number of repeats
; Byte odd:  value


interpolSpeeds:
  .byte 255/1  ;nofSame=1
  .byte 256/2  ;nofSame=2
  .byte 256/3  ;nofSame=3
  .byte 256/4  ;nofSame=4
  .byte 256/5  ;nofSame=5
  .byte 256/6  ;nofSame=6
  .byte 256/7  ;nofSame=7
  .byte 256/8  ;nofSame=8
  .byte 256/9  ;nofSame=9
  .byte 256/10 ;nofSame=10
  .byte 256/11 ;nofSame=11
  .byte 256/12 ;nofSame=12
  .byte 256/13 ;nofSame=13
  .byte 256/14 ;nofSame=14
  .byte 256/15 ;nofSame=15
  .byte 256/16 ;nofSame=16


setSIDfilterRegisters:
;If filter=off:
;  resonance=0
;  cutoff=a0a0
;  filter=highpass
;  if subbass on: filter on channel 3 only
;  else: filter on channel 2+3
;else
;  resonance=setEqReso
;  cutoff=setEqCutoff
;  filter=setEqType
;  filter on all channels

  lda setEqType
  and #$70
  beq filterIsOffA
;filterIsOnA:
;  resonance=setEqReso
;  cutoff=setEqCutoff
;  filter=setEqType


  ;Now determine if we should filter voice 2 or not (dithering/subBass)
  ;Dither shall have filter enabled, subBass shall not
;  ldy #$05
;  lda setSubBass
;  and #$f0
;  beq subNotEnabledA
;  ldy #$07
;subNotEnabledA:
;  sty whichChannels5A+1
  lda setEqReso
  and #$f0
;whichChannels5A:
  ora #$07
  sta $d417
  ldy setEqFreq
  sty $d416
  lda setEqType
  and #$70
  ldx setMasterGain
  ora theLsrTable,x
  sta $d418
  rts

filterIsOffA:
;  resonance=0
;  cutoff=a0a0
;  filter=highpass
;  if subbass on: filter on channel 3 only
;  else: filter on channel 2+3
  ;Now determine if we should filter voice 2 or not (dithering/subBass)
  ;Dither shall have filter enabled, subBass shall not
  ldy #$06
  lda setSubBass
  and #$f0
  beq subIsDisabledA
  ldy #$04
subIsDisabledA:
  sty $d417
  ;Set cutoff for dithering:
  lda #$a0   ;Cutoff
;  sta $d415 ;No need to set LSB
  sta $d416
  lda #$40  ;High pass filter, used for dithering
  ldy setMasterGain
  ora theLsrTable,y
  sta $d418
  rts


restartSong:
;initNoise
  lda #<encodedNoise
  sta noisePoi
  lda #>encodedNoise
  sta noisePoi+1
  lda #3
  sta ticksToWait
  lda #128
  sta ticksToTrig
;initWave - init counter for decoding SIDencWave
  lda #0
  sta nofWaveRepeats
  lda #<SIDencWave
  sta SIDencWavePoi
  lda #>SIDencWave
  sta SIDencWavePoi+1
  lda #$ff
  sta thisWave
  sta nextWave
  lda #$10
  sta interpolValue
;initSpeed - init counter for decoding SIDenc3Speed
  lda #1
  sta doingHighNybble
  lda #<SIDenc3Speed
  sta SIDenc3SpeedPoi
  lda #>SIDenc3Speed
  sta SIDenc3SpeedPoi+1
  lda SIDenc3Speed
  sta currentSpeed
  rts

;-------------------------------------

nmiStart:
  lda #0     ;No Sprites
  sta $d015  ;Sprite display Enable: 1 = Enable
  lda #$7F   ;Set NMI mask to 0 for all NMIs
  sta $dc0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
  lda $dc0d  ;Clear all pending NMI flags
  lda #$40   ;Store an "RTI" opcode in $DD0C so we can
             ;jump to $DD0C and trigger a "read" of byte $DD0D
             ;"for free". Doing an rti will make a read of
             ;$DD0D, but ignore the value read.
             ;Reading $DD0D will clear any pending NMI IRQs.
  sta $dd0c  ;Synchronous Serial I/O Data Buffer
  lda #$4C   ;The "JMP" opcode
  sta $dc04  ;Timer A: Low-Byte
  lda #0     ;The LOW-byte of where the NMI will jump to
  sta $dc05  ;Timer A: High-Byte
  lda #$10   ;Force load Timer A, system02clk, continuous, stop
  sta $dc0e  ;CIA Control Register A
  lda #$3E   ;62 ticks   = The HIGH-byte of where the NMI will jump to
  sta $dc06  ;Timer B: Low-Byte
  lda #0
  sta $dc07  ;Timer B: High-Byte
  lda #0
  sta $dd05  ;Timer A: High-Byte
  lda #$11   ;Force load Timer A, continuous, start
  sta $dd0e  ;CIA Control Register A
  jsr syncCPUtoScreenOhYes
  lda #<FirstNMI
  sta $fffa       ;NMI low-byte
  lda #>FirstNMI
  sta $fffb       ;NMI high-byte
  lda #$10
  sta $dd04  ;Timer A: Low-Byte
  lda #$11   ;Force load Timer B, continuous, start
  sta $dc0f  ;CIA Control Register B
  sta $dd0e  ;CIA Control Register A

  lda $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
  lda #$81
  sta $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  nop
  jmp syncIt


syncCPUtoScreenOhYes:
  php
  sei
  lda #$ff
simpleWaitLoop:
  cmp $d012
  bne simpleWaitLoop
  ldy $d012
  iny
  ldx #$0a
simpleWaitLoop2:
  dex
  bne simpleWaitLoop2
  ldx #$20
anotherOnePlis:
  jsr justAnRts
  jsr justAnRts
  jsr justAnRts
  nop
  inc $d013
  dec $d013
  cpy $d012
  beq wasteALittle
wasteALittle:
  iny
  dex
  bne anotherOnePlis
  plp
justAnRts:
  rts

FirstNMI:
  pha
  lda #$7f  ;Clear NMI mask
  sta $dd0d ;CIA Interrupt Control Register (Read NMls/Write Mask)
  lda $dd0d ;Ack all NMI IRQs
  lda $dc06 ;Timer B: Low-Byte
  sta SaveAnmi_R1-ZeroCodeStart+ZeroCodeDest+1   ;Magically change accumulator with value in TimerB
  pla
  rti



;-----------------------------------

checkIfRestart:
;Restart when NoisePoi = $b99c
  lda noisePoi
  cmp #<(encodedNoiseEnd-9)
  bne justRts
  lda noisePoi+1
  cmp #>(encodedNoiseEnd-9)
  bne justRts
  jmp restartSong
justRts:
  rts

;ToDo: d416 as well...
playNoise:
  dec ticksToTrig
  bne noTrigg
  lda oldWave
  cmp #$80
  bne noTrigg
  lda #$01
  sta $d412
  sta oldWave
noTrigg:  
  dec ticksToWait
  bne checkIfRestart
where:
  beq off  ;We're starting with off...
on:
  lda #$81  ;Yes, it's time for noise!
  sta $d412
  sta oldWave
  ldy #0
  lda (noisePoi),y
  sta ticksToWait   ;How long will this noise be?
  bne notQuit
                 ;We're all done, let's go home
  lda #96        ;=rts
  sta playNoise  ;self modify start of playNoise routine.
notQuit:
  inc noisePoi
  bne noWrr
  inc noisePoi+1
noWrr:
  lda #off-where-2  ;next time, let "where:" jump to off
  sta where+1
doRts:
  rts
off:
  lda oldWave
  cmp #$81
  bne noSilen
  lda #$80  ;shut up!
  sta $d412
  sta oldWave
noSilen:  
  ldy #0
  lda (noisePoi),y
  sta ticksToWait    ;How long will this silence be?
  tax
  lda #4
  sta ticksToTrig
  inc noisePoi
  bne noWrr2
  inc noisePoi+1
noWrr2:
  lda (noisePoi),y
  sta $d414   ;Set sustain level for next noise
  inc noisePoi
  bne noWrr3
  inc noisePoi+1
noWrr3:
  txa         ;If ticksToWait = 0, don't make any sound
  beq dooRts
  lda #on-where-2  ;next time, let "where:" jump to on
  sta where+1
dooRts:
  rts


;-----------------------------

; SIDspeed:
; If SIDwave=255, skip it. (set to 255 directly)
; SIDencSpeed could be reasonably cheap encoded by encoding
; "differences" from -7 to +7 with one nybble.
; If nybble = -8 = 8, then grab next byte (may be split in 
; two separate nybbles), and put that into Speed value.
; First byte is the start speed.


idleColor:
  lda #0
  sta $d020
  tsx
;  clc
;Now choose "how far ahead" we should be when calculating the next
;values. This also determines how many stack values we want to be able
;to use in our mainLoop/IRQs.
;  adc #$90  ;$60 is ok, $10 is ok, $02 is notOk, $f0 is notOk
Ever:
;  cpx Poi_R1+1-ZeroCodeStart+ZeroCodeDest   ;This assembles into a non-zero page decrement. Need to hard code it to make it proper.
  .byte $e4        ;CPX ZP
  .byte Poi_R1+1-ZeroCodeStart+ZeroCodeDest
  bpl Ever  ;Nothing to do here, we're 128-255 bytes "off"
  lda #$6
  sta $d020
  jmp doNextOneDirectly

letsGo:
; Always have 128 bytes "buffer" in the stack for playing

nextOnePlease:
  tsx
;  cpx Poi_R1+1-ZeroCodeStart+ZeroCodeDest   ;This assembles into a non-zero page decrement. Need to hard code it to make it proper.
  .byte $e4        ;CPX ZP
  .byte Poi_R1+1-ZeroCodeStart+ZeroCodeDest
  bpl idleColor   ;2 clocks, 3 if taken, 4 if into another page

doNextOneDirectly:
;Ok, we need to fill the stack with a maximum of ~$70 bytes data.
;We can take our time, there's plenty of clocks before they are needed!
; We cannot, however, use subroutines inside the renderLoop.
; The stack pointer needs to be clean! But, who would do that anyway?

  lda timeshiftFaster_nSlower
  beq doSlower
doFaster:
  lda #0
  adc timeshiftSpeed
  sta doFaster+1
  bcs doSomethingF
  jsr incrementControlData
  jmp doNothing
doSomethingF:
  jsr incrementControlData
  jsr incrementControlData
  jmp doNothing  
  
  

doSlower:
  lda #0
  adc timeshiftSpeed
  sta doSlower+1
  bcs doSomething
  jmp doNothing
doSomething:
  jsr incrementControlData
  jmp doNothing  
  
incrementControlData:  
  jsr playNoise
  
;  jsr playNoise2  ;Save some clock cycles by inlining this function:
;playNoise2:
subBassWaveformOff:
  ldx #$1
  ldy thisWave3
;  lda thisWave3
;  cmp #$ff
  iny
  beq yepSilent
;Only trigger the test bit if we have a new sub bass sound.
;We will come here every time the sub bass is on, even if it was on before  
  
;  lda #$09
subBassWaveformOn:
  ldx #$81
;  sta $d40b   ;Briefly trigger test bit of oscillator, to make sure that sub bass doesn't make a click sound.
              ;The clicking would come if the oscillator has "max output" at the same time as we enable
              ;the waveform output. The test bit will ensure that the wave output is zero at
              ;trig time.
              ;This does not do anything bad for dithering noise, so there's no need to "not" use it
              ;when having dither noise enabled.
yepSilent:
  stx $d40b
  lda thisWave2
  sta thisWave3
  lda thisWave
  sta thisWave2

;Inlined this function:
getNextWave:    
  dec nofWaveRepeats
  bpl dontChangeWave
  ldy #0
  lda (SIDencWavePoi),y
  tax
;  lsr
;  lsr
;  lsr
;  lsr
  lda theLsrTable,x  ;4 clocks instead of the 8 above...
  
;Here, add the compressor volume  
;The original volume is in the upper 4 bits of acc
;setCompLevelLow is a value between 0x00 and 0x0f
  clc
  adc setCompLevelLow
  cmp #$0f
  bcc noClamp
  lda #$0f  
noClamp:
  
  sta thisVolume
  txa
  and #$0f
  sta nofWaveRepeats
  tax
  lda interpolSpeeds,x
  sta interpolSpeed+1

  inc SIDencWavePoi
  bne noWrWa
  inc SIDencWavePoi+1
noWrWa:
  lda (SIDencWavePoi),y
  sta thisWave
  inc SIDencWavePoi
  bne noWrWa2
  inc SIDencWavePoi+1
noWrWa2:
;  lda (SIDencWavePoi),y ;Time to look ahead - what's up doc?
;  lsr
;  lsr
;  lsr
;  lsr
;  sta nextVolume ;This is currently not used. Would be nice for interpolating volume level as well.
  iny
  lda (SIDencWavePoi),y
  sta nextWave
  jmp contAfterGetNextWave
dontChangeWave:

  lda interpolValue
  clc
interpolSpeed:
  adc #0
  sta interpolValue
;  rts

contAfterGetNextWave:  


;  jsr getNextSpeed
getNextSpeed:      ;inlined this fuction to save CPU cycles
  lda thisWave
  cmp #$ff
  bne noSilence
;  lda #$ff          ;it is #$ff already...
  sta currentSpeed
  jmp contAfterGetNextSpeed

noSilence:
  ldy #0
  lda doingHighNybble
  beq doLow
  lda (SIDenc3SpeedPoi),y
;  lsr
;  lsr
;  lsr
;  lsr
  tax
  lda theLsrTable,x  ;6 clocks instead of the 8 above...
  cmp #$8
  beq grabNext2Nybbles
  bcs doSub
  clc
  adc currentSpeed
  sta currentSpeed
  sty doingHighNybble ;Next time, grab the low nybble
  jmp contAfterGetNextSpeed

doSub:
  ora #$f0
  clc
  adc currentSpeed
  sta currentSpeed
  sty doingHighNybble ;Next time, grab the low nybble
  jmp contAfterGetNextSpeed

grabNext2Nybbles:
  lda (SIDenc3SpeedPoi),y
  asl
  asl
  asl
  asl
  sta currentSpeed
  inc SIDenc3SpeedPoi
  bne noWam
  inc SIDenc3SpeedPoi+1
noWam:
  lda (SIDenc3SpeedPoi),y
;  lsr
;  lsr
;  lsr
;  lsr
  tax
  lda theLsrTable,x  ;6 clocks instead of the 8 above...
  ora currentSpeed
  sta currentSpeed
  sty doingHighNybble ;Next time, grab the low nybble
  jmp contAfterGetNextSpeed

doLow:
  lda (SIDenc3SpeedPoi),y
  and #$f
  cmp #$8
  beq grabNext2Nybbles2
  bcs doSub2
  clc
  adc currentSpeed
  sta currentSpeed
  inc SIDenc3SpeedPoi
  bne noWam3
  inc SIDenc3SpeedPoi+1
noWam3:
  inc doingHighNybble ;Next time, grab the high nybble
  jmp contAfterGetNextSpeed

doSub2:
  ora #$f0
  clc
  adc currentSpeed
  sta currentSpeed
  inc SIDenc3SpeedPoi
  bne noWam5
  inc SIDenc3SpeedPoi+1
noWam5:
  inc doingHighNybble ;Next time, grab the high nybble
  jmp contAfterGetNextSpeed

grabNext2Nybbles2:
  inc SIDenc3SpeedPoi
  bne noWam2
  inc SIDenc3SpeedPoi+1
noWam2:
  lda (SIDenc3SpeedPoi),y
  sta currentSpeed
  inc SIDenc3SpeedPoi
  bne noWam4
  inc SIDenc3SpeedPoi+1
noWam4:
  inc doingHighNybble ;Next time, grab the high nybble
;  jmp contAfterGetNextSpeed






contAfterGetNextSpeed:
  ldx setVocoderPitch
  beq notVocoderMode
;This is vocoder mode  
  
;set timeshiftSpeed + timeshiftFaster_nSlower
;to make tempo fixed.
; If vocoderPitch - currentSpeed = 0x100 then tempo should be 0x200
; If vocoderPitch = currentSpeed, then tempo should be 0x100
; If vocoderPitch - currentSpeed = -0x100 then tempo should be 0x080

; If currentSpeed - vocoderPitch = -0x0ff then tempo should be 0x1ff
; If vocoderPitch = currentSpeed, then tempo should be 0x100
; If currentSpeed - vocoderPitch = 0x0ff then tempo should be 0x080

;accumulator contains currentSpeed

  sec
  sbc setVocoderPitch
;If the C flag is 0, then currentSpeed < vocoderPitch (unsigned) and BCC will branch
;If the C flag is 1, then currentSpeed >= vocoderPitch (unsigned) and BCS will branch
  
  bcc VPaboveCS
below:
;Here vocoderPitch is less or equal to currentSpeed.
;The accumulator is = currentSpeed - vocoderSpeed, which is always 8-bit positive unsigned >= 0
;a = 0x0ff -> 0x1ff
;a = 0x000 -> 0x100
  ldx #1
  stx timeshiftFaster_nSlower
  sta timeshiftSpeed
  jmp continuu
VPaboveCS:
;Here vocoderPitch is larger than currentSpeed.
;The accumulator is = currentSpeed - vocoderSpeed, which is always negative 8-bit "unsigned but negative", <= -1
;-0xff = 0x00 -> 0x080
;-0x00 = 0xff -> 0x0ff
  ldx #0
  stx timeshiftFaster_nSlower
  lsr
  eor #$80
  sta timeshiftSpeed
continuu:

;Here, adjust timeshiftSpeed according to setTimestretch.
;      add 2*setTimestretch to timeshiftFaster_nSlower*256 + timeshiftSpeed
;      Clamp it to 0x1ff and 0x000
;Should probably multiply
  lda setTimeStretch
  sec
  sbc #$80
  asl
  sta set88+1
  lda #0
  rol
  beq noMinus
  lda #$ff  ;zero extend the msb
noMinus:
  sta set89+1
  lda timeshiftSpeed
  clc
set88:
  adc #0
  sta timeshiftSpeed
  lda timeshiftFaster_nSlower
set89:
  adc #0
  cmp #$ff
  bne noClampZero
  lda #0
  sta timeshiftSpeed
  sta timeshiftFaster_nSlower
  jmp contVocoder
noClampZero:  
  cmp #$2
  bne noClampMax
  ldx #$ff
  stx timeshiftSpeed
  lda #$1
noClampMax:
  sta timeshiftFaster_nSlower
  

contVocoder:
  lda setVocoderPitch
notVocoderMode:
  ldx autotuneAddAmount
  beq noAutotune

;accumulator is the desired pitch.
;A "full autotune" is done with
;  tax
;  lda autotuneTable,x
;This value should be "blended" with the original value somehow.
;The difference of these values can be $08 for low frequencies
;and up to $0e for high frequencies.

;One solution would be to "adjust" a wrong frequency towards the
;right one with a certain amount, and clamp it if it passes the
;correct frequency. This would require no multiplications.

;This would be implemented as
  tax
  sec
  sbc autotuneTable,x   ;A <- (A) - M - ~C    = suggested_pitch - perfect_pitch
;Here, the accumulator holds "how off" we are.
;This correction value should be limited to the autotune strength
;  beq coo
  bmi itsNeg
itsPos:
  cmp autotuneAddAmount
  bcc noClampHere
  lda autotuneAddAmount
noClampHere:  
  jmp coo
itsNeg:
  cmp autotuneSubAmount
  bcs noClampHereEither
  lda autotuneSubAmount
noClampHereEither:
coo:  
  stx dou+1
  clc
dou:
  sbc #0
  eor #$ff
  


noAutotune:
normalMode:
;  sta zeroSpeedLSB_RL+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroSpeedLSB_RL+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
;  sta zeroEchoSpeedLSB_RL+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoSpeedLSB_RL+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
;Now, check if the SubBass needs to be calculated as well...
  ldx setSubBass
  beq noSubBass
  tax
;Make a table with sensible freq-values for SubBass:  
  lda SIDfreqL,x
  sta $d407
  lda SIDfreqH,x
  sta $d408
  rts
noSubBass:
  ldx #$ff
  stx $d407
  stx $d408
  rts

echoPlay:
  ldx thisWave
  lda SIDwaveformPoiTableMSB,x
;  sta zeroEchoPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  lda SIDwaveformPoiTableLSB,x
;  sta zeroEchoPoi_RL1+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoPoi_RL1+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)

;Set the volume for RL2 (thisWave)
;Adjust it according to thisVolume
  lda thisVolume
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
  sta gugg5+2
  sta gugg52+2
echoInputGain:
  ldx #128     ;Which volume to use for thisWave
gugg5:
  lda volumeTable,x
  sec
gugg52:
  sbc volumeTable 
  tax
  lda theLsrTable,x
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
;  sta zeroEchoVolPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoVolPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  tsx
  txa
  clc
echoDelayLength:
  adc #$f6
;  sta zeroEchoRenderLoop+1
  .byte $85    ;STA ZP
  .byte zeroEchoRenderLoop+1-ZeroCodeStart+ZeroCodeDest
  jmp zeroEchoNextX-ZeroCodeStart+ZeroCodeDest








  
doNothing:
  lda setEchoFeedback
  bne echoPlay
  lda thisWave
  cmp #$ff
  bne notOnlyInsertSilence
  sta currentSpeed    ;it's $ff already
  lda #$80
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  pha
  jmp nextOnePlease

notOnlyInsertSilence:
;  lda #0

;Interpol values:
;bit7: 1=use prevWave, 0=use nextWave
;bit4: 1=use maxVol for thisWave
;bit3-0: Volume to use for thisWave. 15-value = volume for other wave
;Now modify the replay routine with the above in mind.

  ldx thisWave
  lda SIDwaveformPoiTableMSB,x
;  sta zeroPoi_RL2+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroPoi_RL2+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  lda SIDwaveformPoiTableLSB,x
;  sta zeroPoi_RL2+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroPoi_RL2+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  ldx nextWave
;Insert into RL1 of RenderLoop
  lda SIDwaveformPoiTableMSB,x
;  sta zeroPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  lda SIDwaveformPoiTableLSB,x
;  sta zeroPoi_RL1+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroPoi_RL1+1-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)

;Set the volume for RL2 (thisWave)
;Adjust it according to thisVolume
  lda thisVolume
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
  sta gugg+2
  sta gugg2+2
  ldx interpolValue  ;when 255, RL2 should have max volume
gugg:
  lda volumeTable,x
  sec
gugg2:
  sbc volumeTable 
  tax
  lda theLsrTable,x
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
;  sta zeroVolPoi_RL2+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroVolPoi_RL2+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  
;Set the volume for RL1 (thisWave)
;Adjust it according to thisVolume
  lda thisVolume
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
  sta gugge+2
  sta gugge2+2
  lda interpolValue  ;when 255, RL2 should have max volume
  eor #$ff
  tax
gugge:
  lda volumeTable,x
  sec
gugge2:
  sbc volumeTable 
  tax
  lda theLsrTable,x
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
;  sta zeroVolPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroVolPoi_RL1+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  jmp zeroNextX-ZeroCodeStart+ZeroCodeDest



;The code below is moved into zero page, which will save 1 clock cycle per iteration compared
;to having it in memory above. 1 clock cycle is more than you think! ;)

;; The any+any loop:
;nextX:
;  ldx #$32
;RenderLoop:
;Poi_RL1:
;  ldy $8000,x                ;4 clocks, 5 if crossing page
;volPoi_RL1:
;  lda volumeTable+$0f00,y         ;4
;;  clc                       ;2
;Poi_RL2:
;  ldy $8000,x                ;4 clocks, 5 if crossing page
;volPoi_RL2:
;  adc volumeTable+$0f00,y         ;4 clocks, 5 if crossing page
;  pha                        ;3 clocks
;;Now check if we should skip 1 or 2 bytes:
;  lda countLSB               ;3 clocks (ZP)
;;Ideally, we should have a sec here. But hey - it doesn't really
;;         matter that much, does it? ;)
;;  sec                        ;2 clocks
;speedLSB_RL:
;  sbc #0                     ;2 clocks
;  sta countLSB               ;3 clocks (ZP)
;  bcs noX                    ;2 if not taken, 3 if taken, 4 if taken into antother page
;  dex                        ;2
;noX:
;  dex                        ;2
;  bpl RenderLoop             ;2 if not taken, 3 if taken, 4 if taken into another page
;  txa
;  clc
;  adc #waveLength
;  sta nextX+1
;  jmp nextOnePlease
;
;; This is a total of ~42 clocks per sample. This is good enough!
;; Can crossfade with these levels:
;; 0/16 + 16/16 (by self modifying the first adc in the loop to an lda instead, and doing an adc #$00 afterwards)
;; 1/16 + 15/16 (volumeTable #0 + #14)
;; 2/16 + 14/16              #1 + #13
;; 3/16 + 13/16              #2 + #12
;; 4/16 + 12/16              #3 + #11
;; 5/16 + 11/16              #4 + #10
;; 6/16 + 10/16              #5 + #9
;; 7/16 +  9/16              #6 + #8
;; 8/16 +  8/16              #7 + #7
;; Amplitude of waveforms = +-127
;; Waveforms need to be sequential, one waveform from $8033 downto $8000. Last sample at $8000



; Old renderLoop where waveforms were interleaved in memory,
; and read backwards
;RenderLoop:
;Poi_RL:
;  ldx $b4ff            ;4
;volPoi_RL:
;  lda volumeTable,x    ;4
;  pha                  ;3
;;Now check if we should increment and skip a byte:
;countLSB_RL:
;  lda #0               ;2
;;Ideally, we should have a sec here. But hey - it doesn't really
;;         matter that much, does it? ;)
;  sec                  ;2
;speedLSB_RL:
;  sbc #0               ;2
;  sta countLSB_RL+1    ;4
;  lda Poi_RL+2         ;4
;  sbc #1               ;2
;  sta Poi_RL+2         ;4
;  bmi RenderLoop       ;3
;
;;nof cycles = 34 cycles per sample
;
;wrap_R1:
;  lda Poi_RL+2
;  clc
;  adc #53
;  sta Poi_RL+2
;  jmp nextOnePlease

  

;------------------------------



;; Other versions of the RenderLoop:
;; The 33%+66% loop:
;nextX:
;  ldx #53
;RenderLoop:
;Poi_RL:
;  lda $b400,x                ;4 clocks, 5 if crossing page
;  lsr                        ;2
;;  clc                        ;2
;  adc $b434,x                ;4 clocks, 5 if crossing page
;  tay                        ;2 clocks
;  lda volumeTable,y          ;4 clocks, 5 if crossing page
;  pha                        ;3 clocks
;;Now check if we should skip 1 or 2 bytes:
;  lda countLSB               ;3 clocks (ZP)
;;Ideally, we should have a sec here. But hey - it doesn't really
;;         matter that much, does it? ;)
;;  sec                        ;2 clocks
;speedLSB_RL:
;  sbc #0                     ;2 clocks
;  sta countLSB               ;3 clocks (ZP)
;  bcc noX                    ;2 if not taken, 3 if taken, 4 if taken into antother page
;  dex                        ;2
;noX:
;  dex                        ;2
;  bpl RenderLoop             ;2 if not taken, 3 if taken, 4 if taken into another page
;  txa
;  clc
;  adc #53
;  sta nextX+1
;
;; This is a total of ~36 clocks per sample. This is good enough.
;; Need to have the amplitude of the waveforms < 2/3 * 255 = 170
;; Signed, this is from -84 to +84. 84*1.5 = 126
;; The volumeTables can add a little distortion without trouble.




;; Other versions of the RenderLoop:
;; The any+any loop:
;nextX:
;  ldx #53
;RenderLoop:
;Poi_RL:
;  ldy $b400,x                ;4 clocks, 5 if crossing page
;  lda volumeTableA,y         ;4
;;  clc                       ;2
;  ldy $b434,x                ;4 clocks, 5 if crossing page
;  adc volumeTableB,y         ;4 clocks, 5 if crossing page
;  adc #$80                   ;2 clocks
;  tay                        ;2 clocks
;  lda volumeTableTotal,y     ;4 clocks, 5 if crossing page
;  pha                        ;3 clocks
;;Now check if we should skip 1 or 2 bytes:
;  lda countLSB               ;3 clocks (ZP)
;;Ideally, we should have a sec here. But hey - it doesn't really
;;         matter that much, does it? ;)
;;  sec                        ;2 clocks
;speedLSB_RL:
;  sbc #0                     ;2 clocks
;  sta countLSB               ;3 clocks (ZP)
;  bcc noX                    ;2 if not taken, 3 if taken, 4 if taken into antother page
;  dex                        ;2
;noX:
;  dex                        ;2
;  bpl RenderLoop             ;2 if not taken, 3 if taken, 4 if taken into another page
;  txa
;  clc
;  adc #53
;  sta nextX+1
;
;; This is a total of ~42 clocks per sample. This is good enough!
;; Can crossfade with these levels:
;; 0/16 + 16/16 (by self modifying the first adc in the loop to an lda instead.)
;; 1/16 + 15/16 (volumeTable #0 + #14)
;; 2/16 + 14/16              #1 + #13
;; 3/16 + 13/16              #2 + #12
;; 4/16 + 12/16              #3 + #11
;; 5/16 + 11/16              #4 + #10
;; 6/16 + 10/16              #5 + #9
;; 7/16 +  9/16              #6 + #8
;; 8/16 +  8/16              #7 + #7
;; Amplitude of waveforms = +-127
;; Waveforms need to be sequential, one waveform from $8033 downto $8000. Last sample at $8000


;We need a table of where waveforms are located in memory. This will
;occupy 512 bytes of memory.

;If waveforms are longer than 51 bytes, they _will_ eat up 2 additional clock cycles
;when read, since some of them will cross pages.





chgEqtype:
  lsr
  bcs noUp5
;Change from eqpass into sub setting:
  lda #1
  sta guiCou
  lda #<($d800+(8*40))
  sta guiOldPoi+1
  lda #>($d800+(8*40))
  sta guiOldPoi+2
  lda #<($d800+(6*40))
  sta guiNewPoi+1
  lda #>($d800+(6*40))
  sta guiNewPoi+2
  lda #<chgSub
  sta guiCurrentJmp+1
  lda #>chgSub
  sta guiCurrentJmp+2
  rts
noUp5:
  lsr
  bcs noDown5
;Change from eqpass into eqreso setting:
  lda #1
  sta guiCou
  lda #<($d800+(8*40))
  sta guiOldPoi+1
  lda #>($d800+(8*40))
  sta guiOldPoi+2
  lda #<($d800+(9*40))
  sta guiNewPoi+1
  lda #>($d800+(9*40))
  sta guiNewPoi+2
  lda #<chgEqreso
  sta guiCurrentJmp+1
  lda #>chgEqreso
  sta guiCurrentJmp+2
  rts
noDown5:
  lsr
  bcs noLeft5
;0x10=low, 0x20=band, 0x40=high
  ldx setEqType
  beq noll5
  dex
  cpx #$0f
  bne notSwitchedOff  

;At this point, the filter was switched completely off.
;We need to do some magic...  
;no, skip the magic and do the chicken thing...
  
notSwitchedOff:

prEqType:
  stx setEqType

  lda theLsrTable,x
  ldy #$20
  lsr
  bcc bit4
  ldy #$4c
bit4:
  sty screen1+(8*40)+21
  ldy #$20
  lsr
  bcc bit5
  ldy #$4c
bit5:
  sty screen1+(8*40)+26
  ldy #$20
  lsr
  bcc bit6
  ldy #$4c
bit6:
  sty screen1+(8*40)+32
  jsr setSIDfilterRegisters
noll5:
  rts
noLeft5:
  lsr
  bcs noRight5
  ldx setEqType
  inx
  bmi doNothingNow
  jmp prEqType
noRight5:
doNothingNow:
  rts



chgEqreso:
  lsr
  bcs noUp6
;Change from eqreso into eqpass setting:
  lda #1
  sta guiCou
  lda #<($d800+(9*40))
  sta guiOldPoi+1
  lda #>($d800+(9*40))
  sta guiOldPoi+2
  lda #<($d800+(8*40))
  sta guiNewPoi+1
  lda #>($d800+(8*40))
  sta guiNewPoi+2
  lda #<chgEqtype
  sta guiCurrentJmp+1
  lda #>chgEqtype
  sta guiCurrentJmp+2
  rts
noUp6:
  lsr
  bcs noDown6
;Change from eqreso into eqcut setting:
  lda #1
  sta guiCou
  lda #<($d800+(9*40))
  sta guiOldPoi+1
  lda #>($d800+(9*40))
  sta guiOldPoi+2
  lda #<($d800+(10*40))
  sta guiNewPoi+1
  lda #>($d800+(10*40))
  sta guiNewPoi+2
  lda #<chgEqfreq
  sta guiCurrentJmp+1
  lda #>chgEqfreq
  sta guiCurrentJmp+2
  rts
noDown6:
  lsr
  bcs noLeft6
  ldx setEqReso
  beq noll6
  dex
nor6:
  stx setEqReso
  lda #$48
oldl6:
  ldy #0
  sta screen1+(9*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(9*40)+21,y
  sty oldl6+1
setD417:
  jsr setSIDfilterRegisters
noll6:
  rts
noLeft6:
  lsr
  bcs noRight6
  ldx setEqReso
  inx
  bne nor6
noRight6:
  rts




chgEqfreq:
  lsr
  bcs noUp7
;Change from eqcut into eqreso setting:
  lda #1
  sta guiCou
  lda #<($d800+(10*40))
  sta guiOldPoi+1
  lda #>($d800+(10*40))
  sta guiOldPoi+2
  lda #<($d800+(9*40))
  sta guiNewPoi+1
  lda #>($d800+(9*40))
  sta guiNewPoi+2
  lda #<chgEqreso
  sta guiCurrentJmp+1
  lda #>chgEqreso
  sta guiCurrentJmp+2
  rts
noUp7:
  lsr
  bcs noDown7
;Change from eqcut into echodel setting:
  lda #1
  sta guiCou
  lda #<($d800+(10*40))
  sta guiOldPoi+1
  lda #>($d800+(10*40))
  sta guiOldPoi+2
  lda #<($d800+(12*40))
  sta guiNewPoi+1
  lda #>($d800+(12*40))
  sta guiNewPoi+2
  lda #<chgEchodel
  sta guiCurrentJmp+1
  lda #>chgEchodel
  sta guiCurrentJmp+2
  rts
noDown7:
  lsr
  bcs noLeft7

  ldx setEqFreq
  beq noll7
  dex
nol7:
nor7:
  stx setEqFreq
  lda #$48
oldl7:
  ldy #0
  sta screen1+(10*40)+21,y
  ldy theLsrTable,x
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(10*40)+21,y
  sty oldl7+1
  jsr setSIDfilterRegisters
noll7:
  rts
noLeft7:
  lsr
  bcs noRight7
  ldx setEqFreq
  inx
  bne nor7
noRight7:
  rts



chgEchodel:
  lsr
  bcs noUp8
;Change from echodel into eqcut setting:
  lda #1
  sta guiCou
  lda #<($d800+(12*40))
  sta guiOldPoi+1
  lda #>($d800+(12*40))
  sta guiOldPoi+2
  lda #<($d800+(10*40))
  sta guiNewPoi+1
  lda #>($d800+(10*40))
  sta guiNewPoi+2
  lda #<chgEqfreq
  sta guiCurrentJmp+1
  lda #>chgEqfreq
  sta guiCurrentJmp+2
  rts
noUp8:
  lsr
  bcs noDown8
;Change from echodel into echoinp setting:
  lda #1
  sta guiCou
  lda #<($d800+(12*40))
  sta guiOldPoi+1
  lda #>($d800+(12*40))
  sta guiOldPoi+2
  lda #<($d800+(13*40))
  sta guiNewPoi+1
  lda #>($d800+(13*40))
  sta guiNewPoi+2
  lda #<chgEchoinp
  sta guiCurrentJmp+1
  lda #>chgEchoinp
  sta guiCurrentJmp+2
  rts
noDown8:
  lsr
  bcs noLeft8
  ldx setEchoDelay
  beq noll8
  dex
nol8:
nor8:
  stx setEchoDelay
  lda #$48
oldl8:
  ldy #0
  sta screen1+(12*40)+21,y
  ldy theLsrTable,x
  txa
  and #$0f
  lsr
  ora #$40
  sta screen1+(12*40)+21,y
  sty oldl8+1
;  ldx setEchoDelay    ;Commented out since it's loaded already...
  cpx #$f4       ;Not allowed to be larger than 0xf4
  bcc noClamp8
  ldx #$f4
noClamp8:
  cpx #3
  bcs noClamp82  ;Not allowed to be lower than 0x03
  ldx #3
noClamp82:
  stx echoDelayLength+1
noll8:
  rts
noLeft8:
  lsr
  bcs noRight8
  ldx setEchoDelay
  inx
  bne nor8
noRight8:
  rts


chgEchoinp:
  lsr
  bcs noUp9
;Change from echoinp into echodel setting:
  lda #1
  sta guiCou
  lda #<($d800+(13*40))
  sta guiOldPoi+1
  lda #>($d800+(13*40))
  sta guiOldPoi+2
  lda #<($d800+(12*40))
  sta guiNewPoi+1
  lda #>($d800+(12*40))
  sta guiNewPoi+2
  lda #<chgEchodel
  sta guiCurrentJmp+1
  lda #>chgEchodel
  sta guiCurrentJmp+2
  rts
noUp9:
  lsr
  bcs noDown9
;Change from echoinp into echofeed setting:
  lda #1
  sta guiCou
  lda #<($d800+(13*40))
  sta guiOldPoi+1
  lda #>($d800+(13*40))
  sta guiOldPoi+2
  lda #<($d800+(14*40))
  sta guiNewPoi+1
  lda #>($d800+(14*40))
  sta guiNewPoi+2
  lda #<chgEchofeed
  sta guiCurrentJmp+1
  lda #>chgEchofeed
  sta guiCurrentJmp+2
  rts
noDown9:
  lsr
  bcs noLeft9
  ldx setEchoInputGain
  beq noll9
  dex
nor9:
  stx setEchoInputGain
  lda #$48
oldl9:
  ldy #0
  sta screen1+(13*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(13*40)+21,y
  sty oldl9+1
;  ldx setEchoInputGain
  stx echoInputGain+1
noll9:
  rts
noLeft9:
  lsr
  bcs noRight9
  ldx setEchoInputGain
  inx
  bne nor9
noRight9:
  rts




chgEchofeed:
  lsr
  bcs noUpA
;Change from echofeed into echoinp setting:
  lda #1
  sta guiCou
  lda #<($d800+(14*40))
  sta guiOldPoi+1
  lda #>($d800+(14*40))
  sta guiOldPoi+2
  lda #<($d800+(13*40))
  sta guiNewPoi+1
  lda #>($d800+(13*40))
  sta guiNewPoi+2
  lda #<chgEchoinp
  sta guiCurrentJmp+1
  lda #>chgEchoinp
  sta guiCurrentJmp+2
  rts
noUpA:
  lsr
  bcs noDownA
;Change from echofeed into tube setting:
  lda #1
  sta guiCou
  lda #<($d800+(14*40))
  sta guiOldPoi+1
  lda #>($d800+(14*40))
  sta guiOldPoi+2
  lda #<($d800+(16*40))
  sta guiNewPoi+1
  lda #>($d800+(16*40))
  sta guiNewPoi+2
  lda #<chgTube
  sta guiCurrentJmp+1
  lda #>chgTube
  sta guiCurrentJmp+2
  rts
noDownA:
  lsr
  bcs noLeftA
  ldx setEchoFeedback
  beq nollA
  dex
norA:
  stx setEchoFeedback
  lda #$48
oldlA:
  ldy #0
  sta screen1+(14*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(14*40)+21,y
  sty oldlA+1
;  ldx setEchoFeedback  ;Commented out since it's loaded already
;  ldy theLsrTable,x    ;Done already
  tya
  ora #>volumeTable  ;ok as long as volumetable starts on even 4kB address
;  sta zeroEchoFeedbackRatio+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
  .byte $85    ;STA ZP
  .byte zeroEchoFeedbackRatio+2-ZeroCodeStart+ZeroCodeDest            ;3 clocks (ZP)
nollA:
  rts
noLeftA:
  lsr
  bcs noRightA
  ldx setEchoFeedback
  inx
  bne norA
noRightA:
  rts




chgTube:
  lsr
  bcs noUpB
;Change from tube into echofeed setting:
  lda #1
  sta guiCou
  lda #<($d800+(16*40))
  sta guiOldPoi+1
  lda #>($d800+(16*40))
  sta guiOldPoi+2
  lda #<($d800+(14*40))
  sta guiNewPoi+1
  lda #>($d800+(14*40))
  sta guiNewPoi+2
  lda #<chgEchofeed
  sta guiCurrentJmp+1
  lda #>chgEchofeed
  sta guiCurrentJmp+2
  rts
noUpB:
  lsr
  bcs noDownB
;Change from tube into grunge setting:
  lda #1
  sta guiCou
  lda #<($d800+(16*40))
  sta guiOldPoi+1
  lda #>($d800+(16*40))
  sta guiOldPoi+2
  lda #<($d800+(17*40))
  sta guiNewPoi+1
  lda #>($d800+(17*40))
  sta guiNewPoi+2
  lda #<chgGrunge
  sta guiCurrentJmp+1
  lda #>chgGrunge
  sta guiCurrentJmp+2
  rts
noDownB:
  lsr
  bcs noLeftB
  ldx setTubeDist
  beq nollB
  dex
prTube:
  stx setTubeDist
  lda theLsrTable,x
  tax
  lda #$20
  ldy #$4c
  dex
  bpl noTube0
  sty screen1+(16*40)+21
  sta screen1+(16*40)+26
  sta screen1+(16*40)+31
  rts
noTube0:
  dex
  bpl noTube1
  sta screen1+(16*40)+21
  sty screen1+(16*40)+26
  sta screen1+(16*40)+31
  rts
noTube1:
  sta screen1+(16*40)+21
  sta screen1+(16*40)+26
  sty screen1+(16*40)+31
nollB:
  rts
noLeftB:
  lsr
  bcs noRightB
  ldx setTubeDist
  inx
  cpx #$2f
  bne prTube
  rts
noRightB:
  ;No movement, let's check if we should calc new tube table:
  ldx setTubeDist
  lda theLsrTable,x
lastTubeDist:
  cmp #0
  beq noNewTube
  sta lastTubeDist+1

;;Print a "wait" on the screen...
;  lda #$17 ;w
;  sta screen1+(16*40)+37
;  lda #$01 ;a
;  sta screen1+(16*40)+38
;  lda #$09 ;i
;  sta screen1+(16*40)+39
;  lda #$14 ;t
;  sta screen1+(16*40)+40

;Time to calculate a new grunged table:
  lda #$0
  sta $d418
  sta $d020
  jsr newVolumeTable  ;This takes a looooong time... and disables the other IRQs as well...
;Time to reset the master gain $d418
  jsr setSIDfilterRegisters

;Erase the wait message
;  lda #$20
;  sta screen1+(16*40)+37
;  sta screen1+(16*40)+38
;  sta screen1+(16*40)+39
;  sta screen1+(16*40)+40

noNewTube:
  rts




chgGrunge:
  lsr
  bcs noUpC
;Change from grunge into tube setting:
  lda #1
  sta guiCou
  lda #<($d800+(17*40))
  sta guiOldPoi+1
  lda #>($d800+(17*40))
  sta guiOldPoi+2
  lda #<($d800+(16*40))
  sta guiNewPoi+1
  lda #>($d800+(16*40))
  sta guiNewPoi+2
  lda #<chgTube
  sta guiCurrentJmp+1
  lda #>chgTube
  sta guiCurrentJmp+2
  rts
noUpC:
  lsr
  bcs noDownC
;Change from grunge into comp setting:
  lda #1
  sta guiCou
  lda #<($d800+(17*40))
  sta guiOldPoi+1
  lda #>($d800+(17*40))
  sta guiOldPoi+2
  lda #<($d800+(18*40))
  sta guiNewPoi+1
  lda #>($d800+(18*40))
  sta guiNewPoi+2
  lda #<chgComp
  sta guiCurrentJmp+1
  lda #>chgComp
  sta guiCurrentJmp+2
  rts
noDownC:
  lsr
  bcs noLeftC
  ldx setGrunge
  beq nollC
  dex
prGrunge:
  stx setGrunge
  lda #$38
  sec
  sbc theLsrTable,x
  sta screen1+(17*40)+22
  ldy theLsrTable,x
  lda theGrungeAndTable,y
  sta grungelizerAnd+1
nollC:
  rts
noLeftC:
  lsr
  bcs noRightC
  ldx setGrunge
  inx
  bpl prGrunge
noRightC:
;Check if grunge parameter has changed since lase setting.
  ldx setGrunge
  lda theLsrTable,x
lastGrunge:
  cmp #0
  beq noNewGrunge
  sta lastGrunge+1

;;Print a "wait" on the screen...
;  lda #$17 ;w
;  sta screen1+(17*40)+30
;  lda #$01 ;a
;  sta screen1+(17*40)+31
;  lda #$09 ;i
;  sta screen1+(17*40)+32
;  lda #$14 ;t
;  sta screen1+(17*40)+33

;Time to calculate a new grunged table:
  lda #$0
  sta $d418
  sta $d020
  jsr newVolumeTable  ;This takes a looooong time... and disables the other IRQs as well...
;Time to reset the master gain $d418
  jsr setSIDfilterRegisters

;Erase the wait message
;  lda #$20
;  sta screen1+(17*40)+30
;  sta screen1+(17*40)+31
;  sta screen1+(17*40)+32
;  sta screen1+(17*40)+33
  
noNewGrunge:  
  rts

theGrungeAndTable:
  .byte $ff,$fe,$fc,$f8,$f0,$e0,$c0,$80

chgComp:
  lsr
  bcs noUpD
;Change from comp into grunge setting:
  lda #1
  sta guiCou
  lda #<($d800+(18*40))
  sta guiOldPoi+1
  lda #>($d800+(18*40))
  sta guiOldPoi+2
  lda #<($d800+(17*40))
  sta guiNewPoi+1
  lda #>($d800+(17*40))
  sta guiNewPoi+2
  lda #<chgGrunge
  sta guiCurrentJmp+1
  lda #>chgGrunge
  sta guiCurrentJmp+2
  rts
noUpD:
  lsr
  bcs noDownD
;Change from comp into dither setting:
  lda #1
  sta guiCou
  lda #<($d800+(18*40))
  sta guiOldPoi+1
  lda #>($d800+(18*40))
  sta guiOldPoi+2
  lda #<($d800+(19*40))
  sta guiNewPoi+1
  lda #>($d800+(19*40))
  sta guiNewPoi+2
  lda #<chgDither
  sta guiCurrentJmp+1
  lda #>chgDither
  sta guiCurrentJmp+2
  rts
noDownD:
  lsr
  bcs noLeftD
  ldx setCompLevel
  beq nollD
  dex
norD:
  stx setCompLevel
  lda theLsrTable,x
  sta setCompLevelLow
  lda #$48
oldlD:
  ldy #0
  sta screen1+(18*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(18*40)+21,y
  sty oldlD+1
nollD:
  rts
noLeftD:
  lsr
  bcs noRightD
  ldx setCompLevel
  inx
  bne norD
noRightD:
  rts




chgDither:
  lsr
  bcs noUpE
;Change from dither into comp setting:
  lda #1
  sta guiCou
  lda #<($d800+(19*40))
  sta guiOldPoi+1
  lda #>($d800+(19*40))
  sta guiOldPoi+2
  lda #<($d800+(18*40))
  sta guiNewPoi+1
  lda #>($d800+(18*40))
  sta guiNewPoi+2
  lda #<chgComp
  sta guiCurrentJmp+1
  lda #>chgComp
  sta guiCurrentJmp+2
  rts
noUpE:
  lsr
  bcs noDownE
;Change from dither into gain setting:
  lda #1
  sta guiCou
  lda #<($d800+(19*40))
  sta guiOldPoi+1
  lda #>($d800+(19*40))
  sta guiOldPoi+2
  lda #<($d800+(20*40))
  sta guiNewPoi+1
  lda #>($d800+(20*40))
  sta guiNewPoi+2
  lda #<chgGain
  sta guiCurrentJmp+1
  lda #>chgGain
  sta guiCurrentJmp+2
  rts
noDownE:
  lsr
  bcs noLeftE
  ldx setDither
  beq nollE
  dex

;Dither Off is silent.
;Dither Type 1 is continuous.
;Dither Type 2 is program dependent.
  cpx #$0f
  bne notType0
  ldy #$1
  sty subBassWaveformOff+1
  sty subBassWaveformOn+1
  jmp prDither
notType0:
  cpx #$1f
  bne notType1
  ldy #$81
  sty subBassWaveformOff+1
  sty subBassWaveformOn+1
notType1:

prDither:
  stx setDither
  lda #$20
  ldy theLsrTable,x
  bne noDitherOff
  ldx #$4c
  stx screen1+(19*40)+21
  sta screen1+(19*40)+26
  sta screen1+(19*40)+29
  jmp setSIDfilterRegisters
noDitherOff:
  dey
  bne noDither1
  ldx #$4c
  sta screen1+(19*40)+21
  stx screen1+(19*40)+26
  sta screen1+(19*40)+29
  rts
noDither1:
  ldx #$4c
  sta screen1+(19*40)+21
  sta screen1+(19*40)+26
  stx screen1+(19*40)+29
nollE:
  rts
noLeftE:
  lsr
  bcs noRightE
  ldx setDither
  inx
  cpx #$10
  bne noNeedToSilenceSub
;When we come here, we need to silence the subbass, since it uses the same
;SID voice as dithering.  
  jsr prDither
  lda #$81
  sta subBassWaveformOff+1
  sta subBassWaveformOn+1
  lda #0    ;Trig ADS-cycle for dithering noise, to ensure that we get to the
            ;sustain level directly
  sta $d40b
  lda #$10
  sta $d40d ;Sustain level for voice 2, "dithering noise"
  lda #1    ;Trig ADS-cycle for dithering noise, to ensure that we get to the
            ;sustain level directly
  sta $d40b
  ldx #0
  jmp prSubBass
noNeedToSilenceSub:
  cpx #$20
  bne notType2
  lda #$1
  sta subBassWaveformOff+1
notType2:
  cpx #$2f
  bne prDither
noRightE:
  rts



chgGain:
  lsr
  bcs noUpF
;Change from gain into dither setting:
  lda #1
  sta guiCou
  lda #<($d800+(20*40))
  sta guiOldPoi+1
  lda #>($d800+(20*40))
  sta guiOldPoi+2
  lda #<($d800+(19*40))
  sta guiNewPoi+1
  lda #>($d800+(19*40))
  sta guiNewPoi+2
  lda #<chgDither
  sta guiCurrentJmp+1
  lda #>chgDither
  sta guiCurrentJmp+2
  rts
noUpF:
  lsr
;  bcs noDownF
;;Nothing to change to, we're at the last setting
;  rts
;noDownF:
  lsr
  bcs noLeftF
  ldx setMasterGain
  beq nollF
  dex
norF:
  stx setMasterGain
  lda #$48
oldlF:
  ldy #0
  sta screen1+(20*40)+21,y
  lda #$49
  ldy theLsrTable,x
  sta screen1+(20*40)+21,y
  sty oldlF+1
  jsr setSIDfilterRegisters
nollF:
  rts
noLeftF:
  lsr
  bcs noRightF
  ldx setMasterGain
  inx
  bne norF
noRightF:
  rts

;-----------------------------------

doTubeVolume:
;Cannot remove upper and lower borders while doing
;this calculation.
;Need to dismantle nmi before we disable $d000 registers
;Could write 8 different "non-handshaking" nmi's.
;Hopefully, they will tell the timers to go silent
;Or just disable timer nmi connection.
  lda #$40  ;RTI
  sta $0404 ;This is an "unused" memorylocation which is "almost" like $dc04.
            ;By just changing the MSB of the NMI, we eliminate the
            ;risk of triggering an NMI while trying to change both
            ;LSB and MSB of the NMI vector.
;  lda #4
;  sta $fffa  ;NMI
  lda #$04    ;is $dc normally
  sta $fffb  ;NMI
;Now it's safe to turn $d000-$dfff registers off and
;get access to the RAM below, which happens to contain
;a pre-calculated tube distortion table.
  lda #$34
  sta $01
  ldx #$0
movMore:
  lda $d000,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c000,x
  lda $d100,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c100,x
  lda $d200,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c200,x
  lda $d300,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c300,x
  lda $d400,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c400,x
  lda $d500,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c500,x
  lda $d600,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c600,x
  lda $d700,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c700,x
  lda $d800,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c800,x
  lda $d900,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $c900,x
  lda $da00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $ca00,x
  lda $db00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $cb00,x
  lda $dc00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $cc00,x
  lda $dd00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $cd00,x
  lda $de00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $ce00,x
  lda $df00,x
  and grungelizerAnd+1
  clc
  adc #$40
  sta $cf00,x
  inx
  beq donee
  jmp movMore  
donee:  
  lda #$35
  sta $01
;Now it's time to enable NMIs again:
  lda #$dc    ;was pointing to $0404 during calculations,
              ;now we set it back to $dc04
  sta $fffb  ;NMI
  lda $dd0d  ;CIA Interrupt Control Register (Read NMls/Write Mask)
             ;Synchronous Serial I/O Data Buffer
             ;A read will clear pending NMI IRQ.
             ;Since NMI is edge triggered, this
             ;will make sure that new nmi IRQs can happen.
  rts

;-----------------------------------

SIDenc3Speed:
  .include "SIDenc3Speed.s"
SIDenc3SpeedEnd:

SIDencWave:
  .include "SIDencWave.s"
SIDencWaveEnd:

encodedNoise:
  .include "SIDencodedNoise.s"   ;Approximately 1000 bytes
encodedNoiseEnd:


;Free memory space?



  .RES $8c00-*,$00
SIDwaveforms:
  .include "SIDwaveforms.s"
SIDwaveformsEnd:


;Free memory $bf33-$bfff. Could trim away the last waveform, if I wanted to...


  .RES $c000-*,$00
volumeTable:
;Free space from d000-dfff, but cannot use it since we don't have time
;to switch out the VIC/SID bank


;For reference, the calculated volume tables:
;These are done with the original "makeVolumeTable" method.
;Now, we fake them with "fakeVolumeTable" method, which is faster
;so we don't have to include them into the binary.
;
;;Volume table #0
;  .byte $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39
;  .byte $39,$39,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a,$3a
;  .byte $3a,$3a,$3a,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b
;  .byte $3b,$3b,$3b,$3b,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c,$3c
;  .byte $3c,$3c,$3c,$3c,$3c,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d
;  .byte $3d,$3d,$3d,$3d,$3d,$3d,$3e,$3e,$3e,$3e,$3e,$3e,$3e,$3e,$3e,$3e
;  .byte $3e,$3e,$3e,$3e,$3e,$3e,$3e,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
;  .byte $3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$40,$40,$40,$40,$40,$40,$40,$40
;  .byte $40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$41,$41,$41,$41,$41,$41
;  .byte $41,$41,$41,$41,$41,$41,$41,$41,$41,$41,$42,$42,$42,$42,$42,$42
;  .byte $42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$42,$43,$43,$43,$43,$43
;  .byte $43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$44,$44,$44,$44
;  .byte $44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$45,$45,$45
;  .byte $45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$45,$46,$46
;  .byte $46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$47
;  .byte $47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47,$47
;
;;Volume table #1
;  .byte $31,$31,$31,$31,$31,$31,$31,$31,$31,$32,$32,$32,$32,$32,$32,$32
;  .byte $32,$32,$33,$33,$33,$33,$33,$33,$33,$33,$34,$34,$34,$34,$34,$34
;  .byte $34,$34,$34,$35,$35,$35,$35,$35,$35,$35,$35,$36,$36,$36,$36,$36
;  .byte $36,$36,$36,$36,$37,$37,$37,$37,$37,$37,$37,$37,$38,$38,$38,$38
;  .byte $38,$38,$38,$38,$38,$39,$39,$39,$39,$39,$39,$39,$39,$3a,$3a,$3a
;  .byte $3a,$3a,$3a,$3a,$3a,$3a,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3b,$3c,$3c
;  .byte $3c,$3c,$3c,$3c,$3c,$3c,$3c,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3e
;  .byte $3e,$3e,$3e,$3e,$3e,$3e,$3e,$3e,$3f,$3f,$3f,$3f,$3f,$3f,$3f,$3f
;  .byte $40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$41,$41,$41,$41,$41,$41
;  .byte $41,$41,$42,$42,$42,$42,$42,$42,$42,$42,$43,$43,$43,$43,$43,$43
;  .byte $43,$43,$43,$44,$44,$44,$44,$44,$44,$44,$44,$45,$45,$45,$45,$45
;  .byte $45,$45,$45,$45,$46,$46,$46,$46,$46,$46,$46,$46,$47,$47,$47,$47
;  .byte $47,$47,$47,$47,$47,$48,$48,$48,$48,$48,$48,$48,$48,$49,$49,$49
;  .byte $49,$49,$49,$49,$49,$49,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4a,$4b,$4b
;  .byte $4b,$4b,$4b,$4b,$4b,$4b,$4b,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4c,$4d
;  .byte $4d,$4d,$4d,$4d,$4d,$4d,$4d,$4d,$4e,$4e,$4e,$4e,$4e,$4e,$4e,$4e
;
;;Volume table #2
;  .byte $2a,$2a,$2a,$2a,$2a,$2a,$2b,$2b,$2b,$2b,$2b,$2b,$2c,$2c,$2c,$2c
;  .byte $2c,$2c,$2d,$2d,$2d,$2d,$2d,$2e,$2e,$2e,$2e,$2e,$2e,$2f,$2f,$2f
;  .byte $2f,$2f,$2f,$30,$30,$30,$30,$30,$31,$31,$31,$31,$31,$31,$32,$32
;  .byte $32,$32,$32,$32,$33,$33,$33,$33,$33,$34,$34,$34,$34,$34,$34,$35
;  .byte $35,$35,$35,$35,$35,$36,$36,$36,$36,$36,$37,$37,$37,$37,$37,$37
;  .byte $38,$38,$38,$38,$38,$38,$39,$39,$39,$39,$39,$39,$3a,$3a,$3a,$3a
;  .byte $3a,$3b,$3b,$3b,$3b,$3b,$3b,$3c,$3c,$3c,$3c,$3c,$3c,$3d,$3d,$3d
;  .byte $3d,$3d,$3e,$3e,$3e,$3e,$3e,$3e,$3f,$3f,$3f,$3f,$3f,$3f,$40,$40
;  .byte $40,$40,$40,$41,$41,$41,$41,$41,$41,$42,$42,$42,$42,$42,$42,$43
;  .byte $43,$43,$43,$43,$44,$44,$44,$44,$44,$44,$45,$45,$45,$45,$45,$45
;  .byte $46,$46,$46,$46,$46,$47,$47,$47,$47,$47,$47,$48,$48,$48,$48,$48
;  .byte $48,$49,$49,$49,$49,$49,$49,$4a,$4a,$4a,$4a,$4a,$4b,$4b,$4b,$4b
;  .byte $4b,$4b,$4c,$4c,$4c,$4c,$4c,$4c,$4d,$4d,$4d,$4d,$4d,$4e,$4e,$4e
;  .byte $4e,$4e,$4e,$4f,$4f,$4f,$4f,$4f,$4f,$50,$50,$50,$50,$50,$51,$51
;  .byte $51,$51,$51,$51,$52,$52,$52,$52,$52,$52,$53,$53,$53,$53,$53,$54
;  .byte $54,$54,$54,$54,$54,$55,$55,$55,$55,$55,$55,$56,$56,$56,$56,$56
;
;;Volume table #3
;  .byte $22,$22,$22,$22,$22,$23,$23,$23,$23,$24,$24,$24,$24,$25,$25,$25
;  .byte $25,$25,$26,$26,$26,$26,$27,$27,$27,$27,$28,$28,$28,$28,$29,$29
;  .byte $29,$29,$29,$2a,$2a,$2a,$2a,$2b,$2b,$2b,$2b,$2c,$2c,$2c,$2c,$2d
;  .byte $2d,$2d,$2d,$2d,$2e,$2e,$2e,$2e,$2f,$2f,$2f,$2f,$30,$30,$30,$30
;  .byte $31,$31,$31,$31,$31,$32,$32,$32,$32,$33,$33,$33,$33,$34,$34,$34
;  .byte $34,$34,$35,$35,$35,$35,$36,$36,$36,$36,$37,$37,$37,$37,$38,$38
;  .byte $38,$38,$38,$39,$39,$39,$39,$3a,$3a,$3a,$3a,$3b,$3b,$3b,$3b,$3c
;  .byte $3c,$3c,$3c,$3c,$3d,$3d,$3d,$3d,$3e,$3e,$3e,$3e,$3f,$3f,$3f,$3f
;  .byte $40,$40,$40,$40,$40,$41,$41,$41,$41,$42,$42,$42,$42,$43,$43,$43
;  .byte $43,$43,$44,$44,$44,$44,$45,$45,$45,$45,$46,$46,$46,$46,$47,$47
;  .byte $47,$47,$47,$48,$48,$48,$48,$49,$49,$49,$49,$4a,$4a,$4a,$4a,$4b
;  .byte $4b,$4b,$4b,$4b,$4c,$4c,$4c,$4c,$4d,$4d,$4d,$4d,$4e,$4e,$4e,$4e
;  .byte $4f,$4f,$4f,$4f,$4f,$50,$50,$50,$50,$51,$51,$51,$51,$52,$52,$52
;  .byte $52,$52,$53,$53,$53,$53,$54,$54,$54,$54,$55,$55,$55,$55,$56,$56
;  .byte $56,$56,$56,$57,$57,$57,$57,$58,$58,$58,$58,$59,$59,$59,$59,$5a
;  .byte $5a,$5a,$5a,$5a,$5b,$5b,$5b,$5b,$5c,$5c,$5c,$5c,$5d,$5d,$5d,$5d
;
;;Volume table #4
;  .byte $1b,$1b,$1b,$1b,$1c,$1c,$1c,$1d,$1d,$1d,$1d,$1e,$1e,$1e,$1f,$1f
;  .byte $1f,$1f,$20,$20,$20,$21,$21,$21,$22,$22,$22,$22,$23,$23,$23,$24
;  .byte $24,$24,$24,$25,$25,$25,$26,$26,$26,$27,$27,$27,$27,$28,$28,$28
;  .byte $29,$29,$29,$29,$2a,$2a,$2a,$2b,$2b,$2b,$2b,$2c,$2c,$2c,$2d,$2d
;  .byte $2d,$2e,$2e,$2e,$2e,$2f,$2f,$2f,$30,$30,$30,$30,$31,$31,$31,$32
;  .byte $32,$32,$33,$33,$33,$33,$34,$34,$34,$35,$35,$35,$35,$36,$36,$36
;  .byte $37,$37,$37,$38,$38,$38,$38,$39,$39,$39,$3a,$3a,$3a,$3a,$3b,$3b
;  .byte $3b,$3c,$3c,$3c,$3c,$3d,$3d,$3d,$3e,$3e,$3e,$3f,$3f,$3f,$3f,$40
;  .byte $40,$40,$41,$41,$41,$41,$42,$42,$42,$43,$43,$43,$44,$44,$44,$44
;  .byte $45,$45,$45,$46,$46,$46,$46,$47,$47,$47,$48,$48,$48,$48,$49,$49
;  .byte $49,$4a,$4a,$4a,$4b,$4b,$4b,$4b,$4c,$4c,$4c,$4d,$4d,$4d,$4d,$4e
;  .byte $4e,$4e,$4f,$4f,$4f,$50,$50,$50,$50,$51,$51,$51,$52,$52,$52,$52
;  .byte $53,$53,$53,$54,$54,$54,$55,$55,$55,$55,$56,$56,$56,$57,$57,$57
;  .byte $57,$58,$58,$58,$59,$59,$59,$59,$5a,$5a,$5a,$5b,$5b,$5b,$5c,$5c
;  .byte $5c,$5c,$5d,$5d,$5d,$5e,$5e,$5e,$5e,$5f,$5f,$5f,$60,$60,$60,$61
;  .byte $61,$61,$61,$62,$62,$62,$63,$63,$63,$63,$64,$64,$64,$65,$65,$65
;
;;Volume table #5
;  .byte $13,$13,$13,$14,$14,$14,$15,$15,$15,$16,$16,$16,$17,$17,$17,$18
;  .byte $18,$18,$19,$19,$1a,$1a,$1a,$1b,$1b,$1b,$1c,$1c,$1c,$1d,$1d,$1d
;  .byte $1e,$1e,$1e,$1f,$1f,$20,$20,$20,$21,$21,$21,$22,$22,$22,$23,$23
;  .byte $23,$24,$24,$24,$25,$25,$25,$26,$26,$27,$27,$27,$28,$28,$28,$29
;  .byte $29,$29,$2a,$2a,$2a,$2b,$2b,$2b,$2c,$2c,$2d,$2d,$2d,$2e,$2e,$2e
;  .byte $2f,$2f,$2f,$30,$30,$30,$31,$31,$31,$32,$32,$32,$33,$33,$34,$34
;  .byte $34,$35,$35,$35,$36,$36,$36,$37,$37,$37,$38,$38,$38,$39,$39,$3a
;  .byte $3a,$3a,$3b,$3b,$3b,$3c,$3c,$3c,$3d,$3d,$3d,$3e,$3e,$3e,$3f,$3f
;  .byte $40,$40,$40,$41,$41,$41,$42,$42,$42,$43,$43,$43,$44,$44,$44,$45
;  .byte $45,$45,$46,$46,$47,$47,$47,$48,$48,$48,$49,$49,$49,$4a,$4a,$4a
;  .byte $4b,$4b,$4b,$4c,$4c,$4d,$4d,$4d,$4e,$4e,$4e,$4f,$4f,$4f,$50,$50
;  .byte $50,$51,$51,$51,$52,$52,$52,$53,$53,$54,$54,$54,$55,$55,$55,$56
;  .byte $56,$56,$57,$57,$57,$58,$58,$58,$59,$59,$5a,$5a,$5a,$5b,$5b,$5b
;  .byte $5c,$5c,$5c,$5d,$5d,$5d,$5e,$5e,$5e,$5f,$5f,$5f,$60,$60,$61,$61
;  .byte $61,$62,$62,$62,$63,$63,$63,$64,$64,$64,$65,$65,$65,$66,$66,$67
;  .byte $67,$67,$68,$68,$68,$69,$69,$69,$6a,$6a,$6a,$6b,$6b,$6b,$6c,$6c
;
;;Volume table #6
;  .byte $0c,$0c,$0c,$0d,$0d,$0e,$0e,$0e,$0f,$0f,$10,$10,$10,$11,$11,$12
;  .byte $12,$12,$13,$13,$14,$14,$15,$15,$15,$16,$16,$17,$17,$17,$18,$18
;  .byte $19,$19,$19,$1a,$1a,$1b,$1b,$1b,$1c,$1c,$1d,$1d,$1e,$1e,$1e,$1f
;  .byte $1f,$20,$20,$20,$21,$21,$22,$22,$22,$23,$23,$24,$24,$25,$25,$25
;  .byte $26,$26,$27,$27,$27,$28,$28,$29,$29,$29,$2a,$2a,$2b,$2b,$2b,$2c
;  .byte $2c,$2d,$2d,$2e,$2e,$2e,$2f,$2f,$30,$30,$30,$31,$31,$32,$32,$32
;  .byte $33,$33,$34,$34,$35,$35,$35,$36,$36,$37,$37,$37,$38,$38,$39,$39
;  .byte $39,$3a,$3a,$3b,$3b,$3b,$3c,$3c,$3d,$3d,$3e,$3e,$3e,$3f,$3f,$40
;  .byte $40,$40,$41,$41,$42,$42,$42,$43,$43,$44,$44,$45,$45,$45,$46,$46
;  .byte $47,$47,$47,$48,$48,$49,$49,$49,$4a,$4a,$4b,$4b,$4b,$4c,$4c,$4d
;  .byte $4d,$4e,$4e,$4e,$4f,$4f,$50,$50,$50,$51,$51,$52,$52,$52,$53,$53
;  .byte $54,$54,$55,$55,$55,$56,$56,$57,$57,$57,$58,$58,$59,$59,$59,$5a
;  .byte $5a,$5b,$5b,$5b,$5c,$5c,$5d,$5d,$5e,$5e,$5e,$5f,$5f,$60,$60,$60
;  .byte $61,$61,$62,$62,$62,$63,$63,$64,$64,$65,$65,$65,$66,$66,$67,$67
;  .byte $67,$68,$68,$69,$69,$69,$6a,$6a,$6b,$6b,$6b,$6c,$6c,$6d,$6d,$6e
;  .byte $6e,$6e,$6f,$6f,$70,$70,$70,$71,$71,$72,$72,$72,$73,$73,$74,$74
;
;;Volume table #7
;  .byte $04,$04,$04,$05,$05,$06,$06,$07,$07,$08,$08,$09,$09,$0a,$0a,$0b
;  .byte $0b,$0b,$0c,$0c,$0d,$0d,$0e,$0e,$0f,$0f,$10,$10,$11,$11,$12,$12
;  .byte $13,$13,$13,$14,$14,$15,$15,$16,$16,$17,$17,$18,$18,$19,$19,$1a
;  .byte $1a,$1a,$1b,$1b,$1c,$1c,$1d,$1d,$1e,$1e,$1f,$1f,$20,$20,$21,$21
;  .byte $22,$22,$22,$23,$23,$24,$24,$25,$25,$26,$26,$27,$27,$28,$28,$29
;  .byte $29,$29,$2a,$2a,$2b,$2b,$2c,$2c,$2d,$2d,$2e,$2e,$2f,$2f,$30,$30
;  .byte $31,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$36,$37,$37,$38
;  .byte $38,$38,$39,$39,$3a,$3a,$3b,$3b,$3c,$3c,$3d,$3d,$3e,$3e,$3f,$3f
;  .byte $40,$40,$40,$41,$41,$42,$42,$43,$43,$44,$44,$45,$45,$46,$46,$47
;  .byte $47,$47,$48,$48,$49,$49,$4a,$4a,$4b,$4b,$4c,$4c,$4d,$4d,$4e,$4e
;  .byte $4f,$4f,$4f,$50,$50,$51,$51,$52,$52,$53,$53,$54,$54,$55,$55,$56
;  .byte $56,$56,$57,$57,$58,$58,$59,$59,$5a,$5a,$5b,$5b,$5c,$5c,$5d,$5d
;  .byte $5e,$5e,$5e,$5f,$5f,$60,$60,$61,$61,$62,$62,$63,$63,$64,$64,$65
;  .byte $65,$65,$66,$66,$67,$67,$68,$68,$69,$69,$6a,$6a,$6b,$6b,$6c,$6c
;  .byte $6d,$6d,$6d,$6e,$6e,$6f,$6f,$70,$70,$71,$71,$72,$72,$73,$73,$74
;  .byte $74,$74,$75,$75,$76,$76,$77,$77,$78,$78,$79,$79,$7a,$7a,$7b,$7b
;
;;Volume table #8
;  .byte $fd,$fd,$fe,$fe,$ff,$ff,$00,$00,$01,$01,$02,$02,$03,$03,$04,$04
;  .byte $05,$05,$06,$07,$07,$08,$08,$09,$09,$0a,$0a,$0b,$0b,$0c,$0c,$0d
;  .byte $0d,$0e,$0e,$0f,$0f,$10,$11,$11,$12,$12,$13,$13,$14,$14,$15,$15
;  .byte $16,$16,$17,$17,$18,$18,$19,$1a,$1a,$1b,$1b,$1c,$1c,$1d,$1d,$1e
;  .byte $1e,$1f,$1f,$20,$20,$21,$21,$22,$22,$23,$24,$24,$25,$25,$26,$26
;  .byte $27,$27,$28,$28,$29,$29,$2a,$2a,$2b,$2b,$2c,$2c,$2d,$2e,$2e,$2f
;  .byte $2f,$30,$30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$35,$36,$37,$37
;  .byte $38,$38,$39,$39,$3a,$3a,$3b,$3b,$3c,$3c,$3d,$3d,$3e,$3e,$3f,$3f
;  .byte $40,$41,$41,$42,$42,$43,$43,$44,$44,$45,$45,$46,$46,$47,$47,$48
;  .byte $48,$49,$49,$4a,$4b,$4b,$4c,$4c,$4d,$4d,$4e,$4e,$4f,$4f,$50,$50
;  .byte $51,$51,$52,$52,$53,$54,$54,$55,$55,$56,$56,$57,$57,$58,$58,$59
;  .byte $59,$5a,$5a,$5b,$5b,$5c,$5c,$5d,$5e,$5e,$5f,$5f,$60,$60,$61,$61
;  .byte $62,$62,$63,$63,$64,$64,$65,$65,$66,$66,$67,$68,$68,$69,$69,$6a
;  .byte $6a,$6b,$6b,$6c,$6c,$6d,$6d,$6e,$6e,$6f,$6f,$70,$71,$71,$72,$72
;  .byte $73,$73,$74,$74,$75,$75,$76,$76,$77,$77,$78,$78,$79,$79,$7a,$7b
;  .byte $7b,$7c,$7c,$7d,$7d,$7e,$7e,$7f,$7f,$80,$80,$81,$81,$82,$82,$83
;
;;Volume table #9
;  .byte $f5,$f5,$f6,$f6,$f7,$f7,$f8,$f9,$f9,$fa,$fa,$fb,$fc,$fc,$fd,$fd
;  .byte $fe,$fe,$ff,$00,$00,$01,$01,$02,$03,$03,$04,$04,$05,$05,$06,$07
;  .byte $07,$08,$08,$09,$0a,$0a,$0b,$0b,$0c,$0d,$0d,$0e,$0e,$0f,$0f,$10
;  .byte $11,$11,$12,$12,$13,$14,$14,$15,$15,$16,$16,$17,$18,$18,$19,$19
;  .byte $1a,$1b,$1b,$1c,$1c,$1d,$1e,$1e,$1f,$1f,$20,$20,$21,$22,$22,$23
;  .byte $23,$24,$25,$25,$26,$26,$27,$27,$28,$29,$29,$2a,$2a,$2b,$2c,$2c
;  .byte $2d,$2d,$2e,$2f,$2f,$30,$30,$31,$31,$32,$33,$33,$34,$34,$35,$36
;  .byte $36,$37,$37,$38,$38,$39,$3a,$3a,$3b,$3b,$3c,$3d,$3d,$3e,$3e,$3f
;  .byte $40,$40,$41,$41,$42,$42,$43,$44,$44,$45,$45,$46,$47,$47,$48,$48
;  .byte $49,$49,$4a,$4b,$4b,$4c,$4c,$4d,$4e,$4e,$4f,$4f,$50,$50,$51,$52
;  .byte $52,$53,$53,$54,$55,$55,$56,$56,$57,$58,$58,$59,$59,$5a,$5a,$5b
;  .byte $5c,$5c,$5d,$5d,$5e,$5f,$5f,$60,$60,$61,$61,$62,$63,$63,$64,$64
;  .byte $65,$66,$66,$67,$67,$68,$69,$69,$6a,$6a,$6b,$6b,$6c,$6d,$6d,$6e
;  .byte $6e,$6f,$70,$70,$71,$71,$72,$72,$73,$74,$74,$75,$75,$76,$77,$77
;  .byte $78,$78,$79,$7a,$7a,$7b,$7b,$7c,$7c,$7d,$7e,$7e,$7f,$7f,$80,$81
;  .byte $81,$82,$82,$83,$83,$84,$85,$85,$86,$86,$87,$88,$88,$89,$89,$8a
;
;;Volume table #a
;  .byte $ee,$ee,$ef,$ef,$f0,$f1,$f1,$f2,$f3,$f3,$f4,$f5,$f5,$f6,$f7,$f7
;  .byte $f8,$f8,$f9,$fa,$fa,$fb,$fc,$fc,$fd,$fe,$fe,$ff,$00,$00,$01,$01
;  .byte $02,$03,$03,$04,$05,$05,$06,$07,$07,$08,$09,$09,$0a,$0b,$0b,$0c
;  .byte $0c,$0d,$0e,$0e,$0f,$10,$10,$11,$12,$12,$13,$14,$14,$15,$15,$16
;  .byte $17,$17,$18,$19,$19,$1a,$1b,$1b,$1c,$1d,$1d,$1e,$1e,$1f,$20,$20
;  .byte $21,$22,$22,$23,$24,$24,$25,$26,$26,$27,$28,$28,$29,$29,$2a,$2b
;  .byte $2b,$2c,$2d,$2d,$2e,$2f,$2f,$30,$31,$31,$32,$32,$33,$34,$34,$35
;  .byte $36,$36,$37,$38,$38,$39,$3a,$3a,$3b,$3b,$3c,$3d,$3d,$3e,$3f,$3f
;  .byte $40,$41,$41,$42,$43,$43,$44,$45,$45,$46,$46,$47,$48,$48,$49,$4a
;  .byte $4a,$4b,$4c,$4c,$4d,$4e,$4e,$4f,$4f,$50,$51,$51,$52,$53,$53,$54
;  .byte $55,$55,$56,$57,$57,$58,$58,$59,$5a,$5a,$5b,$5c,$5c,$5d,$5e,$5e
;  .byte $5f,$60,$60,$61,$62,$62,$63,$63,$64,$65,$65,$66,$67,$67,$68,$69
;  .byte $69,$6a,$6b,$6b,$6c,$6c,$6d,$6e,$6e,$6f,$70,$70,$71,$72,$72,$73
;  .byte $74,$74,$75,$75,$76,$77,$77,$78,$79,$79,$7a,$7b,$7b,$7c,$7d,$7d
;  .byte $7e,$7f,$7f,$80,$80,$81,$82,$82,$83,$84,$84,$85,$86,$86,$87,$88
;  .byte $88,$89,$89,$8a,$8b,$8b,$8c,$8d,$8d,$8e,$8f,$8f,$90,$91,$91,$92
;
;;Volume table #b
;  .byte $e6,$e6,$e7,$e8,$e8,$e9,$ea,$ea,$eb,$ec,$ed,$ed,$ee,$ef,$ef,$f0
;  .byte $f1,$f1,$f2,$f3,$f4,$f4,$f5,$f6,$f6,$f7,$f8,$f8,$f9,$fa,$fb,$fb
;  .byte $fc,$fd,$fd,$fe,$ff,$00,$00,$01,$02,$02,$03,$04,$04,$05,$06,$07
;  .byte $07,$08,$09,$09,$0a,$0b,$0b,$0c,$0d,$0e,$0e,$0f,$10,$10,$11,$12
;  .byte $13,$13,$14,$15,$15,$16,$17,$17,$18,$19,$1a,$1a,$1b,$1c,$1c,$1d
;  .byte $1e,$1e,$1f,$20,$21,$21,$22,$23,$23,$24,$25,$25,$26,$27,$28,$28
;  .byte $29,$2a,$2a,$2b,$2c,$2d,$2d,$2e,$2f,$2f,$30,$31,$31,$32,$33,$34
;  .byte $34,$35,$36,$36,$37,$38,$38,$39,$3a,$3b,$3b,$3c,$3d,$3d,$3e,$3f
;  .byte $40,$40,$41,$42,$42,$43,$44,$44,$45,$46,$47,$47,$48,$49,$49,$4a
;  .byte $4b,$4b,$4c,$4d,$4e,$4e,$4f,$50,$50,$51,$52,$52,$53,$54,$55,$55
;  .byte $56,$57,$57,$58,$59,$5a,$5a,$5b,$5c,$5c,$5d,$5e,$5e,$5f,$60,$61
;  .byte $61,$62,$63,$63,$64,$65,$65,$66,$67,$68,$68,$69,$6a,$6a,$6b,$6c
;  .byte $6d,$6d,$6e,$6f,$6f,$70,$71,$71,$72,$73,$74,$74,$75,$76,$76,$77
;  .byte $78,$78,$79,$7a,$7b,$7b,$7c,$7d,$7d,$7e,$7f,$7f,$80,$81,$82,$82
;  .byte $83,$84,$84,$85,$86,$87,$87,$88,$89,$89,$8a,$8b,$8b,$8c,$8d,$8e
;  .byte $8e,$8f,$90,$90,$91,$92,$92,$93,$94,$95,$95,$96,$97,$97,$98,$99
;
;;Volume table #c
;  .byte $df,$df,$e0,$e1,$e2,$e2,$e3,$e4,$e5,$e5,$e6,$e7,$e8,$e8,$e9,$ea
;  .byte $eb,$eb,$ec,$ed,$ee,$ee,$ef,$f0,$f1,$f2,$f2,$f3,$f4,$f5,$f5,$f6
;  .byte $f7,$f8,$f8,$f9,$fa,$fb,$fb,$fc,$fd,$fe,$fe,$ff,$00,$01,$02,$02
;  .byte $03,$04,$05,$05,$06,$07,$08,$08,$09,$0a,$0b,$0b,$0c,$0d,$0e,$0e
;  .byte $0f,$10,$11,$12,$12,$13,$14,$15,$15,$16,$17,$18,$18,$19,$1a,$1b
;  .byte $1b,$1c,$1d,$1e,$1e,$1f,$20,$21,$22,$22,$23,$24,$25,$25,$26,$27
;  .byte $28,$28,$29,$2a,$2b,$2b,$2c,$2d,$2e,$2e,$2f,$30,$31,$32,$32,$33
;  .byte $34,$35,$35,$36,$37,$38,$38,$39,$3a,$3b,$3b,$3c,$3d,$3e,$3e,$3f
;  .byte $40,$41,$42,$42,$43,$44,$45,$45,$46,$47,$48,$48,$49,$4a,$4b,$4b
;  .byte $4c,$4d,$4e,$4e,$4f,$50,$51,$52,$52,$53,$54,$55,$55,$56,$57,$58
;  .byte $58,$59,$5a,$5b,$5b,$5c,$5d,$5e,$5e,$5f,$60,$61,$62,$62,$63,$64
;  .byte $65,$65,$66,$67,$68,$68,$69,$6a,$6b,$6b,$6c,$6d,$6e,$6e,$6f,$70
;  .byte $71,$72,$72,$73,$74,$75,$75,$76,$77,$78,$78,$79,$7a,$7b,$7b,$7c
;  .byte $7d,$7e,$7e,$7f,$80,$81,$82,$82,$83,$84,$85,$85,$86,$87,$88,$88
;  .byte $89,$8a,$8b,$8b,$8c,$8d,$8e,$8e,$8f,$90,$91,$92,$92,$93,$94,$95
;  .byte $95,$96,$97,$98,$98,$99,$9a,$9b,$9b,$9c,$9d,$9e,$9e,$9f,$a0,$a1
;
;;Volume table #d
;  .byte $d7,$d7,$d8,$d9,$da,$db,$db,$dc,$dd,$de,$df,$e0,$e0,$e1,$e2,$e3
;  .byte $e4,$e4,$e5,$e6,$e7,$e8,$e9,$e9,$ea,$eb,$ec,$ed,$ed,$ee,$ef,$f0
;  .byte $f1,$f2,$f2,$f3,$f4,$f5,$f6,$f6,$f7,$f8,$f9,$fa,$fb,$fb,$fc,$fd
;  .byte $fe,$ff,$00,$00,$01,$02,$03,$04,$04,$05,$06,$07,$08,$09,$09,$0a
;  .byte $0b,$0c,$0d,$0d,$0e,$0f,$10,$11,$12,$12,$13,$14,$15,$16,$16,$17
;  .byte $18,$19,$1a,$1b,$1b,$1c,$1d,$1e,$1f,$20,$20,$21,$22,$23,$24,$24
;  .byte $25,$26,$27,$28,$29,$29,$2a,$2b,$2c,$2d,$2d,$2e,$2f,$30,$31,$32
;  .byte $32,$33,$34,$35,$36,$36,$37,$38,$39,$3a,$3b,$3b,$3c,$3d,$3e,$3f
;  .byte $40,$40,$41,$42,$43,$44,$44,$45,$46,$47,$48,$49,$49,$4a,$4b,$4c
;  .byte $4d,$4d,$4e,$4f,$50,$51,$52,$52,$53,$54,$55,$56,$56,$57,$58,$59
;  .byte $5a,$5b,$5b,$5c,$5d,$5e,$5f,$5f,$60,$61,$62,$63,$64,$64,$65,$66
;  .byte $67,$68,$69,$69,$6a,$6b,$6c,$6d,$6d,$6e,$6f,$70,$71,$72,$72,$73
;  .byte $74,$75,$76,$76,$77,$78,$79,$7a,$7b,$7b,$7c,$7d,$7e,$7f,$7f,$80
;  .byte $81,$82,$83,$84,$84,$85,$86,$87,$88,$89,$89,$8a,$8b,$8c,$8d,$8d
;  .byte $8e,$8f,$90,$91,$92,$92,$93,$94,$95,$96,$96,$97,$98,$99,$9a,$9b
;  .byte $9b,$9c,$9d,$9e,$9f,$9f,$a0,$a1,$a2,$a3,$a4,$a4,$a5,$a6,$a7,$a8
;
;;Volume table #e
;  .byte $d0,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d7,$d8,$d9,$da,$db,$dc,$dd
;  .byte $de,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e5,$e6,$e7,$e8,$e9,$ea,$eb
;  .byte $ec,$ed,$ed,$ee,$ef,$f0,$f1,$f2,$f3,$f4,$f4,$f5,$f6,$f7,$f8,$f9
;  .byte $fa,$fb,$fb,$fc,$fd,$fe,$ff,$00,$01,$02,$02,$03,$04,$05,$06,$07
;  .byte $08,$09,$0a,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$11,$12,$13,$14,$15
;  .byte $16,$17,$18,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$1f,$20,$21,$22,$23
;  .byte $24,$25,$26,$27,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2e,$2f,$30,$31
;  .byte $32,$33,$34,$35,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3c,$3d,$3e,$3f
;  .byte $40,$41,$42,$43,$44,$44,$45,$46,$47,$48,$49,$4a,$4b,$4b,$4c,$4d
;  .byte $4e,$4f,$50,$51,$52,$52,$53,$54,$55,$56,$57,$58,$59,$59,$5a,$5b
;  .byte $5c,$5d,$5e,$5f,$60,$61,$61,$62,$63,$64,$65,$66,$67,$68,$68,$69
;  .byte $6a,$6b,$6c,$6d,$6e,$6f,$6f,$70,$71,$72,$73,$74,$75,$76,$76,$77
;  .byte $78,$79,$7a,$7b,$7c,$7d,$7e,$7e,$7f,$80,$81,$82,$83,$84,$85,$85
;  .byte $86,$87,$88,$89,$8a,$8b,$8c,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$93
;  .byte $94,$95,$96,$97,$98,$99,$9a,$9b,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2
;  .byte $a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0
;
;;Volume table #f
;  .byte $c8,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6
;  .byte $d7,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5
;  .byte $e6,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f1,$f2,$f3,$f4
;  .byte $f5,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$00,$01,$02,$03
;  .byte $04,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12
;  .byte $13,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21
;  .byte $22,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30
;  .byte $31,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
;  .byte $40,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e
;  .byte $4f,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d
;  .byte $5e,$5e,$5f,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c
;  .byte $6d,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b
;  .byte $7c,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a
;  .byte $8b,$8b,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99
;  .byte $9a,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8
;  .byte $a9,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7



  .RES $d000-*,$00
  .include "tube_distortion_table.s"

  .RES $e000-*,$00
;  .incbin     "2x2_charset"   ;A complete charset is $0800 long.
;Characters A-Z nicked from the game "Trailblaizer" by S Southern. Thanks :)
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x00
  .byte $78,$cc,$cc,$fc,$ce,$ce,$ce,$00 ; A 0x01
  .byte $f8,$cc,$cc,$fc,$ce,$ce,$fc,$00 ; B 0x02
  .byte $78,$cc,$c0,$c0,$c0,$c6,$7c,$00 ; C 0x03
  .byte $f8,$dc,$cc,$cc,$ce,$ce,$fc,$00 ; D 0x04
  .byte $fc,$c4,$c0,$fc,$c0,$c6,$fe,$00 ; E 0x05
  .byte $fc,$c4,$c0,$fc,$c0,$c0,$c0,$00 ; F 0x06
  .byte $78,$cc,$c0,$de,$c6,$c6,$7c,$00 ; G 0x07
  .byte $cc,$cc,$cc,$fc,$ce,$ce,$ce,$00 ; H 0x08
  .byte $fc,$30,$30,$30,$38,$38,$fe,$00 ; I 0x09
  .byte $3e,$0c,$0c,$0c,$ce,$ce,$7c,$00 ; J 0x0a
  .byte $cc,$cc,$d8,$fc,$ee,$ce,$ce,$00 ; K 0x0b
  .byte $c0,$c0,$c0,$c0,$c0,$c6,$fe,$00 ; L 0x0c
  .byte $ec,$fc,$fc,$de,$d6,$c6,$c6,$00 ; M 0x0d
  .byte $cc,$ec,$ec,$fc,$de,$de,$ce,$00 ; N 0x0e
  .byte $78,$cc,$cc,$cc,$ce,$ce,$7c,$00 ; O 0x0f
  .byte $f8,$cc,$cc,$f8,$c0,$c0,$c0,$00 ; P 0x10
  .byte $78,$cc,$cc,$cc,$cc,$ce,$7a,$00 ; Q 0x11
  .byte $fc,$c8,$dc,$fc,$ce,$ce,$ce,$00 ; R 0x12
  .byte $78,$ec,$e0,$78,$1e,$ce,$7c,$00 ; S 0x13
  .byte $fc,$30,$30,$30,$38,$38,$38,$00 ; T 0x14
  .byte $cc,$cc,$cc,$cc,$ce,$ce,$7c,$00 ; U 0x15
  .byte $cc,$cc,$cc,$68,$6c,$3c,$38,$00 ; V 0x16
  .byte $cc,$cc,$c6,$d6,$d6,$fe,$6c,$00 ; W 0x17
  .byte $cc,$ec,$38,$70,$de,$ce,$ce,$00 ; X 0x18
  .byte $cc,$cc,$78,$30,$38,$38,$38,$00 ; Y 0x19
  .byte $fc,$cc,$18,$30,$60,$c6,$fe,$00 ; Z 0x1a
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x1b
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x1c
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x1d
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x1e
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ;   0x1f
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x20
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ; ! 0x21
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ; " 0x22
  .byte $07,$0c,$0c,$0c,$0c,$0c,$0c,$0c ; # 0x23  The upper part of a {
;A hand drawn $
;00010000
;11111110
;11010000
;11111110
;00010110
;11111110
;00010000
;00000000
  .byte $10,$fe,$d0,$fe,$16,$fe,$10,$00 ; $ 0x24
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$07 ; % 0x25  The lower part of a {
  .byte $0c,$18,$30,$e0,$30,$18,$0c,$0c ; & 0x26 The middle part of a {
  .byte $18,$30,$00,$00,$00,$00,$00,$00 ; ´ 0x27
  .byte $bb,$6c,$cc,$cc,$ce,$ce,$7c,$00 ; ( 0x28 but I use it as an Ö
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ; ) 0x29
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x2a
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x2b
  .byte $00,$00,$00,$00,$00,$18,$30,$00 ; , 0x2c
  .byte $00,$00,$00,$78,$00,$00,$00,$00 ; - 0x2d
  .byte $00,$00,$00,$00,$00,$30,$30,$00 ; . 0x2e
  .byte $06,$0c,$18,$30,$60,$e0,$e0,$00 ; / 0x2f

;Characters 0-9 nicked from the game "Trailblaizer" by S Southern. Thanks :)
  .byte $fc,$cc,$cc,$cc,$ce,$ce,$fe,$00 ; 0 0x30
  .byte $30,$70,$30,$30,$38,$38,$38,$00 ; 1 0x31
  .byte $fc,$cc,$0c,$fc,$c0,$c6,$fe,$00 ; 2 0x32
  .byte $fc,$cc,$0c,$3c,$0e,$ce,$fe,$00 ; 3 0x33
  .byte $c0,$c0,$d8,$fc,$18,$1c,$1c,$00 ; 4 0x34
  .byte $fc,$cc,$c0,$fc,$0e,$ce,$fe,$00 ; 5 0x35
  .byte $fc,$cc,$c0,$fc,$ce,$ce,$fe,$00 ; 6 0x36
  .byte $fc,$0c,$0c,$18,$1c,$1c,$1c,$00 ; 7 0x37
  .byte $fc,$cc,$cc,$fc,$ce,$ce,$fe,$00 ; 8 0x38
  .byte $fc,$cc,$cc,$fc,$0e,$ce,$fe,$00 ; 9 0x39
  .byte $00,$30,$30,$00,$30,$30,$00,$00 ; : 0x3a
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x3b
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x3c
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x3d
  .byte $00,$00,$00,$00,$00,$00,$00,$00 ;   0x3e
  .byte $78,$ec,$0c,$38,$00,$30,$30,$00 ; ? 0x3f
  .byte $80,$80,$80,$ff,$80,$80,$80,$00 ; @ 0x40
  .byte $40,$40,$40,$ff,$40,$40,$40,$00 ; A 0x41
  .byte $20,$20,$20,$ff,$20,$20,$20,$00 ; B 0x42
  .byte $10,$10,$10,$ff,$10,$10,$10,$00 ; C 0x43
  .byte $08,$08,$08,$ff,$08,$08,$08,$00 ; D 0x44
  .byte $04,$04,$04,$ff,$04,$04,$04,$00 ; E 0x45
  .byte $02,$02,$02,$ff,$02,$02,$02,$00 ; F 0x46
  .byte $01,$01,$01,$ff,$01,$01,$01,$00 ; G 0x47
  .byte $00,$00,$00,$ff,$00,$00,$00,$00 ; H 0x48
  .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$00 ; I 0x49
  .byte $01,$01,$01,$01,$01,$01,$01,$00 ; J 0x4a
  .byte $80,$80,$80,$80,$80,$80,$80,$00 ; K 0x4b
  .byte $fe,$fe,$fe,$fe,$fe,$fe,$fe,$00 ; L 0x4c


  
  .RES $e800-*,$ff
  
  .include "SIDwaveformPoiTable.s"
  
theLsrTable:
  .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
  .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
  .byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
  .byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
  .byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
  .byte $07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07,$07
  .byte $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
  .byte $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
  .byte $0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0a
  .byte $0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b,$0b
  .byte $0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c,$0c
  .byte $0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d,$0d
  .byte $0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$0e
  .byte $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f

SIDfreqL:
;  .word $00/256*7812.5/51*16777216/985248.333333333+7812.5/51*16777216/985248.333333333

;* Check sensible pitch table for sub bass.
;  Fout = (Fn * Fclk/16777216) Hz
;  Where Fn is the 16-bit number in the Frequency registers and Fclk is the system clock applied to the Ø2 input (pin 6). For a standard 1.0 Mhz clock, the frequency is given by:
;  Fout = (Fn * 0.0596) Hz
;  The VIC-II was manufactured with 5 micrometer NMOS technology[1] and was clocked at either 17.73447 MHz (PAL)
;  Clock speed: 0.985 MHz (PAL)
;  0.985248333333333 MHz
;  Fout = Fn * 985248.333333333 / 16777216 Hz
;  Index in our table: (256 * note_no^(1/12)) - 256
;  %The note values used through the whole song are:
;  % Note Name   Hz              nofSamples@7812.5Hz
;  % D    146.8323839587038 Hz   53.206927445904853, simplified as 51 samples
;  % E    164.8137784564350 Hz   47.401983457742659
;  % F    174.6141157165020 Hz   44.741514555925860
;  % F#   184.9972113558173 Hz   42.230366299812502
;  % G#   207.6523487899727 Hz   37.622979203099938
;  % A    220 Hz                 35.511363636363598
;  % B    246.9416506280622 Hz   31.637028343051789
;  % C#   277.1826309768723 Hz   28.185387996594418
;  % D    293.6647679174077 Hz   26.603463722952405
;  Formula for calculating:
;  pitch value (pv=0) should equal something playing at
;  pv=  0: (256 + pv)/256 * 7812.5 / 51 Hz =  153.186274509804 Hz
;  pv=255: (256 + pv)/256 * 7812.5 / 51 Hz =  305.774165134804 Hz
;   SIDfreq = Fout * 16777216 / 985248.333333333
;   SIDfreq = (1 + pv / 256) * 7812.5 / 51 * 16777216 / 985248.333333333
;   SIDfreq = 7812.5 / 51 * 16777216 / 985248.333333333 + pv / 256 * 7812.5 / 51 * 16777216 / 985248.333333333
;Now, sub bass uses 36.5 - 73 Hz. 

;Table generated with BlitzCalc, and the following formula:
;pv:=0
;SIDfreq := round(0.25*(7812.5 / 51 * 16777216 / 985248.333333333 + pv / 256 * 7812.5 / 51 * 16777216 / 985248.333333333))
;pv:=pv+1
;SIDfreq := round(0.25*(7812.5 / 51 * 16777216 / 985248.333333333 + pv / 256 * 7812.5 / 51 * 16777216 / 985248.333333333))

  .byte <652  
  .byte <655  
  .byte <657  
  .byte <660  
  .byte <662  
  .byte <665  
  .byte <667  
  .byte <670  
  .byte <673  
  .byte <675  
  .byte <678  
  .byte <680  
  .byte <683  
  .byte <685  
  .byte <688  
  .byte <690  
  .byte <693  
  .byte <695  
  .byte <698  
  .byte <701  
  .byte <703  
  .byte <706  
  .byte <708  
  .byte <711  
  .byte <713  
  .byte <716  
  .byte <718  
  .byte <721  
  .byte <723  
  .byte <726  
  .byte <729  
  .byte <731  
  .byte <734  
  .byte <736  
  .byte <739  
  .byte <741  
  .byte <744  
  .byte <746  
  .byte <749  
  .byte <751  
  .byte <754  
  .byte <757  
  .byte <759  
  .byte <762  
  .byte <764  
  .byte <767  
  .byte <769  
  .byte <772  
  .byte <774  
  .byte <777  
  .byte <779  
  .byte <782  
  .byte <785  
  .byte <787  
  .byte <790  
  .byte <792  
  .byte <795  
  .byte <797  
  .byte <800  
  .byte <802  
  .byte <805  
  .byte <808  
  .byte <810  
  .byte <813  
  .byte <815  
  .byte <818  
  .byte <820  
  .byte <823  
  .byte <825  
  .byte <828  
  .byte <830  
  .byte <833  
  .byte <836  
  .byte <838  
  .byte <841  
  .byte <843  
  .byte <846  
  .byte <848  
  .byte <851  
  .byte <853  
  .byte <856  
  .byte <858  
  .byte <861  
  .byte <864  
  .byte <866  
  .byte <869  
  .byte <871  
  .byte <874  
  .byte <876  
  .byte <879  
  .byte <881  
  .byte <884  
  .byte <886  
  .byte <889  
  .byte <892  
  .byte <894  
  .byte <897  
  .byte <899  
  .byte <902  
  .byte <904  
  .byte <907  
  .byte <909  
  .byte <912  
  .byte <915  
  .byte <917  
  .byte <920  
  .byte <922  
  .byte <925  
  .byte <927  
  .byte <930  
  .byte <932  
  .byte <935  
  .byte <937  
  .byte <940  
  .byte <943  
  .byte <945  
  .byte <948  
  .byte <950  
  .byte <953  
  .byte <955  
  .byte <958  
  .byte <960  
  .byte <963  
  .byte <965  
  .byte <968  
  .byte <971  
  .byte <973  
  .byte <976  
  .byte <978  
  .byte <981  
  .byte <983  
  .byte <986  
  .byte <988  
  .byte <991  
  .byte <993  
  .byte <996  
  .byte <999  
  .byte <1001 
  .byte <1004 
  .byte <1006 
  .byte <1009 
  .byte <1011 
  .byte <1014 
  .byte <1016 
  .byte <1019 
  .byte <1022 
  .byte <1024 
  .byte <1027 
  .byte <1029 
  .byte <1032 
  .byte <1034 
  .byte <1037 
  .byte <1039 
  .byte <1042 
  .byte <1044 
  .byte <1047 
  .byte <1050 
  .byte <1052 
  .byte <1055 
  .byte <1057 
  .byte <1060 
  .byte <1062 
  .byte <1065 
  .byte <1067 
  .byte <1070 
  .byte <1072 
  .byte <1075 
  .byte <1078 
  .byte <1080 
  .byte <1083 
  .byte <1085 
  .byte <1088 
  .byte <1090 
  .byte <1093 
  .byte <1095 
  .byte <1098 
  .byte <1100 
  .byte <1103 
  .byte <1106 
  .byte <1108 
  .byte <1111 
  .byte <1113 
  .byte <1116 
  .byte <1118 
  .byte <1121 
  .byte <1123 
  .byte <1126 
  .byte <1128 
  .byte <1131 
  .byte <1134 
  .byte <1136 
  .byte <1139 
  .byte <1141 
  .byte <1144 
  .byte <1146 
  .byte <1149 
  .byte <1151 
  .byte <1154 
  .byte <1157 
  .byte <1159 
  .byte <1162 
  .byte <1164 
  .byte <1167 
  .byte <1169 
  .byte <1172 
  .byte <1174 
  .byte <1177 
  .byte <1179 
  .byte <1182 
  .byte <1185 
  .byte <1187 
  .byte <1190 
  .byte <1192 
  .byte <1195 
  .byte <1197 
  .byte <1200 
  .byte <1202 
  .byte <1205 
  .byte <1207 
  .byte <1210 
  .byte <1213 
  .byte <1215 
  .byte <1218 
  .byte <1220 
  .byte <1223 
  .byte <1225 
  .byte <1228 
  .byte <1230 
  .byte <1233 
  .byte <1235 
  .byte <1238 
  .byte <1241 
  .byte <1243 
  .byte <1246 
  .byte <1248 
  .byte <1251 
  .byte <1253 
  .byte <1256 
  .byte <1258 
  .byte <1261 
  .byte <1264 
  .byte <1266 
  .byte <1269 
  .byte <1271 
  .byte <1274 
  .byte <1276 
  .byte <1279 
  .byte <1281 
  .byte <1284 
  .byte <1286 
  .byte <1289 
  .byte <1292 
  .byte <1294 
  .byte <1297 
  .byte <1299 
  .byte <1302 



SIDfreqH:
;  .byte >$00 / 256 * 7812.5 / 51 * 16777216 / 985248.333333333 + 7812.5 / 51 * 16777216 / 985248.333333333
  .byte >652  
  .byte >655  
  .byte >657  
  .byte >660  
  .byte >662  
  .byte >665  
  .byte >667  
  .byte >670  
  .byte >673  
  .byte >675  
  .byte >678  
  .byte >680  
  .byte >683  
  .byte >685  
  .byte >688  
  .byte >690  
  .byte >693  
  .byte >695  
  .byte >698  
  .byte >701  
  .byte >703  
  .byte >706  
  .byte >708  
  .byte >711  
  .byte >713  
  .byte >716  
  .byte >718  
  .byte >721  
  .byte >723  
  .byte >726  
  .byte >729  
  .byte >731  
  .byte >734  
  .byte >736  
  .byte >739  
  .byte >741  
  .byte >744  
  .byte >746  
  .byte >749  
  .byte >751  
  .byte >754  
  .byte >757  
  .byte >759  
  .byte >762  
  .byte >764  
  .byte >767  
  .byte >769  
  .byte >772  
  .byte >774  
  .byte >777  
  .byte >779  
  .byte >782  
  .byte >785  
  .byte >787  
  .byte >790  
  .byte >792  
  .byte >795  
  .byte >797  
  .byte >800  
  .byte >802  
  .byte >805  
  .byte >808  
  .byte >810  
  .byte >813  
  .byte >815  
  .byte >818  
  .byte >820  
  .byte >823  
  .byte >825  
  .byte >828  
  .byte >830  
  .byte >833  
  .byte >836  
  .byte >838  
  .byte >841  
  .byte >843  
  .byte >846  
  .byte >848  
  .byte >851  
  .byte >853  
  .byte >856  
  .byte >858  
  .byte >861  
  .byte >864  
  .byte >866  
  .byte >869  
  .byte >871  
  .byte >874  
  .byte >876  
  .byte >879  
  .byte >881  
  .byte >884  
  .byte >886  
  .byte >889  
  .byte >892  
  .byte >894  
  .byte >897  
  .byte >899  
  .byte >902  
  .byte >904  
  .byte >907  
  .byte >909  
  .byte >912  
  .byte >915  
  .byte >917  
  .byte >920  
  .byte >922  
  .byte >925  
  .byte >927  
  .byte >930  
  .byte >932  
  .byte >935  
  .byte >937  
  .byte >940  
  .byte >943  
  .byte >945  
  .byte >948  
  .byte >950  
  .byte >953  
  .byte >955  
  .byte >958  
  .byte >960  
  .byte >963  
  .byte >965  
  .byte >968  
  .byte >971  
  .byte >973  
  .byte >976  
  .byte >978  
  .byte >981  
  .byte >983  
  .byte >986  
  .byte >988  
  .byte >991  
  .byte >993  
  .byte >996  
  .byte >999  
  .byte >1001 
  .byte >1004 
  .byte >1006 
  .byte >1009 
  .byte >1011 
  .byte >1014 
  .byte >1016 
  .byte >1019 
  .byte >1022 
  .byte >1024 
  .byte >1027 
  .byte >1029 
  .byte >1032 
  .byte >1034 
  .byte >1037 
  .byte >1039 
  .byte >1042 
  .byte >1044 
  .byte >1047 
  .byte >1050 
  .byte >1052 
  .byte >1055 
  .byte >1057 
  .byte >1060 
  .byte >1062 
  .byte >1065 
  .byte >1067 
  .byte >1070 
  .byte >1072 
  .byte >1075 
  .byte >1078 
  .byte >1080 
  .byte >1083 
  .byte >1085 
  .byte >1088 
  .byte >1090 
  .byte >1093 
  .byte >1095 
  .byte >1098 
  .byte >1100 
  .byte >1103 
  .byte >1106 
  .byte >1108 
  .byte >1111 
  .byte >1113 
  .byte >1116 
  .byte >1118 
  .byte >1121 
  .byte >1123 
  .byte >1126 
  .byte >1128 
  .byte >1131 
  .byte >1134 
  .byte >1136 
  .byte >1139 
  .byte >1141 
  .byte >1144 
  .byte >1146 
  .byte >1149 
  .byte >1151 
  .byte >1154 
  .byte >1157 
  .byte >1159 
  .byte >1162 
  .byte >1164 
  .byte >1167 
  .byte >1169 
  .byte >1172 
  .byte >1174 
  .byte >1177 
  .byte >1179 
  .byte >1182 
  .byte >1185 
  .byte >1187 
  .byte >1190 
  .byte >1192 
  .byte >1195 
  .byte >1197 
  .byte >1200 
  .byte >1202 
  .byte >1205 
  .byte >1207 
  .byte >1210 
  .byte >1213 
  .byte >1215 
  .byte >1218 
  .byte >1220 
  .byte >1223 
  .byte >1225 
  .byte >1228 
  .byte >1230 
  .byte >1233 
  .byte >1235 
  .byte >1238 
  .byte >1241 
  .byte >1243 
  .byte >1246 
  .byte >1248 
  .byte >1251 
  .byte >1253 
  .byte >1256 
  .byte >1258 
  .byte >1261 
  .byte >1264 
  .byte >1266 
  .byte >1269 
  .byte >1271 
  .byte >1274 
  .byte >1276 
  .byte >1279 
  .byte >1281 
  .byte >1284 
  .byte >1286 
  .byte >1289 
  .byte >1292 
  .byte >1294 
  .byte >1297 
  .byte >1299 
  .byte >1302 




  
;Let's make an autotune table.
;Incoming speeds will be mapped to the "perfect speed"
;The perfect speeds are:
; $00 = lower D
; $100 (which we round to $ff) = upper D
;...and 11 notes inbetween.
;The perfect pitch positions are given by the formula
;################### Wrong one: NoteNumber (0 - 12) * $100 / 12 = NoteNumber * 21.333
;(256 * note_no^(1/12)) - 256

;The thresholds are given by the formula:
;a0:=round((256 * 2^(0/12)) - 256)
;a1:=round((256 * 2^(1/12)) - 256)
;a2:=round((256 * 2^(2/12)) - 256)
;a3:=round((256 * 2^(3/12)) - 256)
;a4:=round((256 * 2^(4/12)) - 256)
;a5:=round((256 * 2^(5/12)) - 256)
;a6:=round((256 * 2^(6/12)) - 256)
;a7:=round((256 * 2^(7/12)) - 256)
;a8:=round((256 * 2^(8/12)) - 256)
;a9:=round((256 * 2^(9/12)) - 256)
;a10:=round((256 * 2^(10/12)) - 256)
;a11:=round((256 * 2^(11/12)) - 256)
;a12:=round((256 * 2^(12/12)) - 256)
;
;(a0+a1)/2
;(a1+a2)/2
;(a2+a3)/2
;(a3+a4)/2
;(a4+a5)/2
;(a5+a6)/2
;(a6+a7)/2
;(a7+a8)/2
;(a8+a9)/2
;(a9+a10)/2
;(a10+a11)/2
;(a11+a12)/2

;7.5
;23
;39.5
;57.5
;76.5
;96
;117
;139
;162.5
;187.5
;213.5
;241.5

;Note - Key - Row - pitch
; D      x     3    0                  0  
; D#     d     3   15.222552155981     21  - Not used in the song
; E      c     3   31.350284367199     43 
; F      v     4   48.437021440696     64 
; F#     g     4   66.539788773087     86 
; G      b     4   85.719002667528     107 - Not used in the song
; G#     h     4   106.038671967514    128
; A      n     5   127.56661168043     149
; A#     j     5   150.374669303859    171 - Not used in the song
; B      m     5   174.538964609902    192
; C      ,     6   200.140143687854    213 - Not used in the song
; C#     l     6   227.263648093028    235
; D      .     6   256                 255

;% The notes of Tom's Diner are:
;% I  am sit-ting in the mor-ning at  the Di-ner on   the cor-ner
;% F# G# A   C#   F# G#  A   C#   F#  C#  B   A  B    A   B   A
;% I  am wai-ting at the coun-ter for the man to pour the cof-fe
;
;% and he fills it only halfway and before I even argue
;% F#  F  E     C# C#   C#  B   A   F# D   C# C# B D C#
;% He is looking at the window at somebody coming in
;% A  B  C#  D   A  B   C#  D   A D   D C# C#  B  C#

autotuneTable:
  .RES  8,0   ; D                             
  .RES 15,15  ; D# - Not used in the song     
  .RES 17,31  ; E                             
  .RES 18,48  ; F                             
  .RES 19,67  ; F#                          
  .RES 19,86  ; G  - Not used in the song   
  .RES 21,106 ; G#                          
  .RES 22,128 ; A                           
  .RES 24,150 ; A# - Not used in the song   
  .RES 25,175 ; B                           
  .RES 26,200 ; C  - Not used in the song  
  .RES 28,227 ; C#                         
  .RES 15,255 ; D                           




;End of 256-byte-aligned tables







storyInit:
  lda #<story
  sta storyPoi
  lda #>story
  sta storyPoi+1
  lda #$ff
  sta currentJoy
  rts

storyRestartNow:
  lda #<storyRestart
  sta storyPoi
  lda #>storyRestart
  sta storyPoi+1
  rts  
  
storyIrq:
joyRepeat:
  ldx #0
  beq noJoyNow
  dex
  stx joyRepeat+1
  rts
noJoyNow:
  lda #$ff
  sta currentJoy
erase:
  ldx #0
  beq noErase
  lda #$20
  sta screen1+(23*40),x
  sta screen1+(24*40),x
  dex
  stx erase+1
  rts
noErase:
  ldy #0
  lda (storyPoi),y
  beq storyRestartNow
  bpl storyNoSpecial
  inc storyPoi
  bne noWre3
  inc storyPoi+1
noWre3:
  cmp #$ff
  bne noJoy
  lda (storyPoi),y
  sta joyRepeat+1
  inc storyPoi
  bne noWre6
  inc storyPoi+1
noWre6:
joyEnabled:
  lda #1
  beq joyDisabled    
  lda (storyPoi),y
  sta currentJoy
joyDisabled:
  inc storyPoi
  bne noWre7
  inc storyPoi+1
noWre7:
  rts
noJoy:
  cmp #$fe
  bne noErase2
  lda #$27
  sta erase+1
  rts
noErase2:
  and #$7f
  clc
  adc #<(23*40)
  sta storyDstPoi+1
  sta storyColPoi+1
  rts
storyNoSpecial:
  inc storyPoi
  bne noWre4
  inc storyPoi+1
noWre4:
storyDstPoi:
  sta screen1+(23*40)
  lda #1
storyColPoi:
  sta $d800+(23*40)
  
  inc storyDstPoi+1
;  bne noWre
;  inc storyDstPoi+2
;noWre:
  inc storyColPoi+1
;  bne noWre2
;  inc storyColPoi+2
;noWre2:
  rts



story:
;Wait a little:
  .byte $ff,$a0,$ff

  .byte $81
  SCREEN "cubase was never done for commodore 64"
  .byte $ff,$40,$ff
  .byte $a9
  SCREEN "it can't do audio, they said"

  .byte $ff,$60,$ff

  .byte $fe
  .byte $a9
  SCREEN "they were wrong"

;Wait a little:
  .byte $ff,$40,$ff


;Even though you choose your own path
;no need to walk alone

  .byte $ff,$26,$fd
  .byte $ff,$20,$ff

  .byte $fe
  .byte $81
  SCREEN "20 years ago, jarre paid $30000"
  .byte $a9
  SCREEN "for on-the-fly time stretch"

;  .byte $ff,$20,$ff

  .byte $ff,$30,$ff
  .byte $ff,$60,$f7
  .byte $ff,$20,$ff
  .byte $ff,$b0,$fb
  .byte $ff,$20,$ff
  .byte $ff,$50,$f7
  .byte $ff,$10,$ff

  .byte $fe
  .byte $81
  SCREEN "and kraftwerk had to"
  .byte $a9
  SCREEN "build their own vocoders"

  .byte $ff,$20,$ff
  .byte $ff,$26,$fd
  .byte $ff,$30,$ff
  .byte $ff,$40,$f7
  .byte $ff,$50,$ff
  .byte $ff,$3e,$f7
  .byte $ff,$60,$ff
  .byte $ff,$88,$fb


  .byte $fe
  .byte $81
  SCREEN "15 years ago, cher got the first"
  .byte $a9
  SCREEN "autotuned hit, i belive"

;  .byte $ff,$10,$ff
  .byte $ff,$26,$fd
;  .byte $ff,$30,$ff
  .byte $ff,$fe,$f7
  .byte $ff,$30,$ff
  .byte $ff,$ff,$fb

  .byte $fe
  .byte $81
  SCREEN "10 years ago, prodigy and klf"
  .byte $a9
  SCREEN "used sub bass to the extreme"

  .byte $ff,$10,$ff
  .byte $ff,$26,$fd
  .byte $ff,$fe,$f7
;No wait with highest subbass
;  .byte $ff,$10,$ff
  .byte $ff,$ff,$fb

  .byte $fe
  .byte $81
  SCREEN "acid, trance and ambient music"
  .byte $a9
  SCREEN "needed a sweeping equalizer"

  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
;Raise cutoff just a little, so that the low-pass filter passes thru a little sound
  .byte $ff,$03,$f7
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Set low pass enabled
  .byte $ff,$12,$f7
  .byte $ff,$26,$fd
;Set resonance higher
;On second though, no... leave it low...
;  .byte $ff,$21,$f7
  .byte $ff,$26,$fd
;Sweep cutoff
  .byte $ff,$fe,$f7
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Set filter off
  .byte $ff,$12,$fb
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd


  .byte $fe
  .byte $81
  SCREEN "not even beatles would cope"
  .byte $a9
  SCREEN "without the echo effect"

  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fe
;Decrease input gain  
  .byte $ff,$a8,$fb
  .byte $ff,$26,$fd 
;Increase feedback
  .byte $ff,$d8,$f7
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Decrease echo delay
  .byte $ff,$ff,$fb
  .byte $ff,$ff,$f7
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
;Shut off feedback
  .byte $ff,$f0,$fb



  .byte $fe
  .byte $81
  SCREEN "today, you pay $30000"
  .byte $a9
  SCREEN "for a decent tube amplifier"

;Turn tube distortion to the high setting:
  .byte $ff,$30,$ff
  .byte $ff,$26,$fd
  .byte $ff,$28,$f7
  .byte $ff,$80,$ff
  .byte $ff,$30,$fb


  .byte $fe
  .byte $81
  SCREEN "but you want a nastier sound"

  .byte $ff,$30,$ff
  .byte $ff,$26,$fd
  .byte $ff,$52,$f7
  .byte $ff,$80,$ff
  .byte $ff,$60,$fb

  .byte $fe
  .byte $81
  SCREEN "with a car on the great ocean road"
  .byte $a9
  SCREEN "the radio station use a fat compressor"

  .byte $ff,$30,$ff
  .byte $ff,$26,$fd
  .byte $ff,$fe,$f7
  .byte $ff,$40,$ff
  .byte $ff,$ff,$fb

  .byte $fe
  .byte $81
  SCREEN "while dithering is essential to make"
  .byte $a9
  SCREEN "audio recordings for audiophiles"

  .byte $ff,$30,$ff
  .byte $ff,$26,$fd
;Turn on dithering
  .byte $ff,$42,$f7
  .byte $ff,$40,$ff
  .byte $ff,$44,$fb

  .byte $fe
  .byte $81
  SCREEN "and you also need a volume level"

  .byte $ff,$30,$ff
  .byte $ff,$26,$fd
  .byte $ff,$d9,$fb
  .byte $ff,$e0,$f7

  .byte $fe
  .byte $81
  SCREEN "cubase was never done for commodore 64"
  .byte $ff,$40,$ff
  .byte $a9
  SCREEN "it can't do audio, they said"

  .byte $ff,$a0,$ff

  .byte $fe
  .byte $81
  SCREEN "you need 32-bit, 2000mhz, 1gb at least"
  .byte $ff,$30,$ff
  .byte $a9
  SCREEN "what if..."
  .byte $ff,$30,$ff
  SCREEN "8-bit, 1mhz, 64kb is enough?"

  .byte $ff,$a0,$ff

  .byte $fe
  .byte $81
  SCREEN "imagine c64 could do all of this"
  .byte $ff,$20,$ff
  .byte $a9
  SCREEN "in real time,"
  .byte $ff,$20,$ff
  SCREEN " simultaneously..."

;code for turning "everything" on.

;  .byte $ff,$a0,$ff
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Increase compressor a little
  .byte $ff,$48,$f7
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Turn on tube
  .byte $ff,$18,$f7
;And wait a little so it actually gets changed.
  .byte $ff,$06,$ff
  .byte $ff,$26,$fe
;Turn on echo
  .byte $ff,$f8,$f7
  .byte $ff,$26,$fe

;No need to decrease input gain, it's low already
  .byte $ff,$20,$fb
  .byte $ff,$26,$fe

  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
  .byte $ff,$26,$fe
;Turn on low pass filter
  .byte $ff,$18,$f7

  .byte $ff,$26,$fe
;Turn on sub bass
  .byte $ff,$38,$f7
  .byte $ff,$26,$fe
;Turn on autotune
  .byte $ff,$18,$f7
  .byte $ff,$26,$fe
;Don't turn on vocoder - it's boooring in the long run!
;  .byte $ff,$a8,$f7
  .byte $ff,$26,$fe
;Timestretch a little slower
  .byte $ff,$28,$fb

  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
  .byte $ff,$26,$fd
;Sweep the cutoff down
  .byte $ff,$e8,$fb


storyRestart:
  .byte $fe
  .byte $81
  SCREEN "grab your joystick, any port"
  .byte $a9
  SCREEN "and have a noise night!"

  .byte $ff,$a0,$ff
  
  .byte $fe
  .byte $81
  SCREEN "greetings to"
  .byte $a9
  SCREEN "lft - i love your stuff"
;         123456789012345678901234567890123456789
  .byte $ff,$a0,$ff

  .byte $81
  SCREEN "ziphoid - radio man yuppedihooo!      "
  .byte $a9
  SCREEN "blaizer - i want your cinema room     "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "jackasser - thanks for the ride       "
  .byte $a9
  SCREEN "fnord - sharing is caring             "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "firefox - revenue from a handle? haha!"
  .byte $a9
  SCREEN "slaygon - thanks for slayradio        "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "scenesat radio - keep it up guys      "
  .byte $a9
  SCREEN "kaktus - gurkorna med sin globala f..."
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "gluemaster - vi vill ha mer glass     "
  .byte $a9
  SCREEN "makke - good luck with life           "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "soundemon - thanks for the inspiration"
  .byte $a9
  SCREEN "thcm - this couldn't be without you   "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "mixer - love the vicious sid          "
  .byte $a9
  SCREEN "melina tufvesson - my wife, i love you"
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "reyn ouwehand - i love your music     "
  .byte $a9
  SCREEN "rob hubbard - you are my hero         "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "lman - thanks for remix64.com         "
  .byte $a9
  SCREEN "erwik - good luck with your synth     "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "dhs - thanks for the pizza            "
  .byte $a9
  SCREEN "linus walleij - for being a great guy "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "marcel donne - love your music        "
  .byte $a9
  SCREEN "triad - trianglar e fina              "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "fairlight - beware of zombies         "
  .byte $a9
  SCREEN "plush - nice demos                    "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "instinct - nice demos                 "
  .byte $a9
  SCREEN "ht - nice demos                       "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "maniacs of noise - nice music         "
  .byte $a9
  SCREEN "hvsc - what a gorgeous collection     "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "sir garbagetruck - what a nice beard! "
  .byte $a9
  SCREEN "crest - nice demos                    "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "oxyron - i'm inspired                 "
  .byte $a9
  SCREEN "onslaught - love it                   "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "jan harries - you have the force, jan "
  .byte $a9
  SCREEN "booze design - love your demos        "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "oswald - cool stuff                   "
  .byte $a9
  SCREEN "dafunk - remixer of the year, we are  "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "krill - fabulous coding skills        "
  .byte $a9
  SCREEN "erik persson - where's the karate game"
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "pernod - thanks for the company       "
  .byte $a9
  SCREEN "iopop - you too                       "
  .byte $ff,$20,$ff
  .byte $81
  SCREEN "puterman - riding a car is soo much eh"
  .byte $a9
  SCREEN "hollowman - with right company its ok "

  .byte $ff,$20,$ff
  .byte $81
  SCREEN "pasi ojala - pucrunch is a lovely tool"
  .byte $a9
  SCREEN "danko - there's nobody out there      "
  .byte $ff,$a0,$ff

  .byte $fe

  .byte $81
  SCREEN "you never fail"
  .byte $ff,$20,$ff
  SCREEN " to impress me"
  .byte $ff,$20,$ff
  .byte $a9
  SCREEN "and inspire me"

  .byte $ff,$a0,$ff




  .byte $fe
  .byte $81
  SCREEN "download the source code at"
  .byte $a9
  SCREEN "http://mahoney.c64.org"

  .byte $ff,$a0,$ff

  .byte $fe
  .byte $81
  SCREEN "visa r(ster - commodore 64 music"
  .byte $a9
  SCREEN "a cappella http://www.livet.se/visa"

  .byte $ff,$a0,$ff
  .byte $fe

  .byte $fe
  .byte $81
  SCREEN "the end, this text will now wrap."
  .byte $a9
  SCREEN "          have a noise night! / pex"

  .byte $ff,$a0,$ff
  .byte $fe
  
  .byte 0
  



  .RES $fc00-*,$00
screen1:
  SCREEN "   cubase64 by pex mahoney tufvesson    "
  SCREEN "                                        "
  SCREEN "                                        "
  SCREEN "         timestretchJHHHHHHHGHHHHHHHHK  "
  SCREEN "       vocoder pitchJ@HHHHHHHHHHHHHHHK  "
  SCREEN "      autotune speedJ@HHHHHHHHHHHHHHHK  "
  SCREEN "      sub bass levelJIHHHHHHHHHHHHHHHK  "
  SCREEN "                                        "
  SCREEN "          #pass type  low  band  high   "
  SCREEN " equalizer&resonanceJIHHHHHHHHHHHHHHHK  "
  SCREEN "          %   cutoffJ@HHHHHHHHHHHHHHHK  "
  SCREEN "                                        "
  SCREEN "         #     delayJHHHHHHHHHHHHHHHGK  "
  SCREEN "     echo&input gainJHHHHHHHHHHHHHHHIK  "
  SCREEN "         %  feedbackJIHHHHHHHHHHHHHHHK  "
  SCREEN "                                        "
  SCREEN "     tube distortion Loff  low  high    "
  SCREEN "         grungelizer  8-bit             "
  SCREEN "    compressor levelJIHHHHHHHHHHHHHHHK  "
  SCREEN "         dither type Loff  1  2         "
  SCREEN "         master gainJHHHHHHHHHHHHHHHIK  "
  SCREEN "                                        "
  SCREEN "                                        "
  SCREEN "                                        "
  SCREEN "                                        "



;The "Mother of the MP3"
;
;An article in the now defunct magazine Business 2.0 revealed that "Tom's Diner" was also
;used by Karlheinz Brandenburg to develop the audio compression scheme known as MP3 at what
;is now the Fraunhofer Society. He recalled:
;
    ;I was ready to fine-tune my compression algorithm...somewhere down the corridor, a
    ;radio was playing "Tom's Diner". I was electrified. I knew it would be nearly
    ;impossible to compress this warm a cappella voice.[4]
;
;Brandenburg adopted the song for testing purposes, listening to it again and again each
;time he refined the scheme, making sure it did not adversely affect the subtlety of Vega's
;voice. While it is an exaggeration to say that the MP3 compression format is specifically
;tuned to play the song "Tom's Diner" (an assortment of critically analyzed material was
;involved in the design of the codec over many years), among some audio engineers this
;anecdote has earned Vega the informal title "The Mother of the MP3".




;Tom's Diner by Suzanne Vega, lyrics:
;I am sitting
;In the morning
;At the diner
;On the corner
;
;I am waiting
;At the counter
;For the man
;To pour the coffee
;
;And he fills it
;Only halfway
;And before
;I even argue
;
;He is looking
;Out the window
;At somebody
;Coming in
;
;"It is always
;Nice to see you"
;Says the man
;Behind the counter
;
;To the woman
;Who has come in
;She is shaking
;Her umbrella
;
;And I look
;The other way
;As they are kissing
;Their hellos
;
;I'm pretending
;Not to see them
;Instead
;I pour the milk
;
;I open
;Up the paper
;There's a story
;Of an actor
;
;Who had died
;While he was drinking
;It was no one
;I had heard of
;
;And I'm turning
;To the horoscope
;And looking
;For the funnies
;
;When I'm feeling
;Someone watching me
;And so
;I raise my head
;
;There's a woman
;On the outside
;Looking inside
;Does she see me?
;
;No she does not
;Really see me
;Cause she sees
;Her own reflection
;
;And I'm trying
;Not to notice
;That she's hitching
;Up her skirt
;
;And while she's
;Straightening her stockings
;Her hair
;Has gotten wet
;
;Oh, this rain
;It will continue
;Through the morning
;As I'm listening
;
;To the bells
;Of the cathedral
;I am thinking
;Of your voice...
;
;And of the midnight picnic
;Once upon a time
;Before the rain began...
;
;I finish up my coffee
;It's time to catch the train
;







;SID voice 1 is tricked into playing 8-bit sample output at 7812.5 Hz.
;SID voice 2 is used for low-amplitude noise dithering OR sub bass sound.
;SID voice 3 is used for consonant sound, plosive sounds like "s f k p t", 3-15 kHz.


;Memory budget:
;Code $0258-$0e00         =   3kB
;Which pitch              =  12kB
;Which waveform to play   =  14kB
;Waveforms                =  13kB
;A font                   =   2kB
;Two screens              =   2kB
;Unusable mem $d000-$dfff =   4kB
;Volume tables            =   4kB
;Encoded noise            = 0.5kB
;                          _____
;                          54.5kB





