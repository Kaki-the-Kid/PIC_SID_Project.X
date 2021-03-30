%
% This is the 6th encoder script for
%
%   cubase64 by Pex 'Mahoney' Tufvesson, October 2010
%
% Run it using Matlab, you'll probably need a couple of toolboxes
% and a lot of patience.
% After running all matlab scripts, you'll find a number of
% files named "SID*.s".
% Copy these into the demo folder.
%
% Want to know more?  http://mahoney.c64.org
% Want to hear C64 a cappella?  Visa Röster at http://www.livet.se/visa
% Want a happy life? Do something _not_ requiring electricity! :-D
%

format long;
format compact;
clear;

% Takes the extracted parameters of "Tom's Diner" and encodes them into ready-to-use binary data for Commodore 64.

debugging = 1;
load SIDnoiseParameters.mat  % contains sidNoiseVolume



nofSlices = length(sidNoiseVolume)

if debugging==1
    % Everything above minNoiseLevel shall be considered as Noise
    figure(5);
    clf;
    x=1:nofSlices;
    plot(x,sidNoiseVolume);
    hold on;
    plot(x,sidNoiseVolume,'r.');
    title('SID Noise level per slice');
    xlabel('sliceNo');
    ylabel('d406');
    axis([0 nofSlices -1 16]);

    % Everything above minNoiseLevel shall be considered as Noise
    figure(6);
    clf;
    plot(x,sidCutoffFreq);
    title('SID high pass filter cutoff freq per slice');
    xlabel('sliceNo');
    ylabel('cutoffFreq');
    axis([0 nofSlices -100 10300]);
end


% Need to compress the data, to make sure that it
% fits into very little memory, and that the
% uncompressing of data would require almost _no_
% computations.

%$d416 $d417 $d418
%   0   $01    $4f: All pass filter
%  32   $01    $4f: High pass -3dB@1kHz
%  64   $01    $4f: High pass -3dB@2kHz
%  128  $01    $4f: High pass -3dB@6kHz
%  192  $01    $4f: High pass -3dB@8kHz
%  255  $01    $4f: High pass -3dB@10kHz
%
%  64   $81    $4f: High pass -3dB@2kHz, with +10dB@3kHz
% 128   $81    $4f: High pass -3dB@6kHz, with +7dB@7kHz

SIDd416 = zeros(1,nofSlices);
SIDd416 = floor(sidCutoffFreq / 10000 * 255);
SIDd416 = max(SIDd416,0);
SIDd416 = min(SIDd416,255);

% Everything above minNoiseLevel shall be considered as Noise
figure(7);
clf;
plot(x,sidCutoffFreq);
title('SID high pass filter cutoff freq per slice');
xlabel('sliceNo');
ylabel('$d416');
axis([0 nofSlices -10 265]);





%$D405  54277	
%Voice #1 Attack and Decay length. Bits:
%Bits #0-#3: Decay length. Values:
%0000, 0: 6 ms.
%0001, 1: 24 ms.
%0010, 2: 48 ms.
%0011, 3: 72 ms.
%0100, 4: 114 ms.
%0101, 5: 168 ms.
%0110, 6: 204 ms.
%0111, 7: 240 ms.
%1000, 8: 300 ms.
%1001, 9: 750 ms.
%1010, 10: 1.5 s.
%1011, 11: 2.4 s.
%1100, 12: 3 s.
%1101, 13: 9 s.
%1110, 14: 15 s.
%1111, 15: 24 s.
%Bits #4-#7: Attack length. Values:
%0000, 0: 2 ms.
%0001, 1: 8 ms.
%0010, 2: 16 ms.
%0011, 3: 24 ms.
%0100, 4: 38 ms.
%0101, 5: 56 ms.
%0110, 6: 68 ms.
%0111, 7: 80 ms.
%1000, 8: 100 ms.
%1001, 9: 250 ms.
%1010, 10: 500 ms.
%1011, 11: 800 ms.
%1100, 12: 1 s.
%1101, 13: 3 s.
%1110, 14: 5 s.
%1111, 15: 8 s.
%Write-only.
%$D406
%54278	
%Voice #1 Sustain volume and Release length. Bits:
%Bits #0-#3: Release length. Values:
%0000, 0: 6 ms.
%0001, 1: 24 ms.
%0010, 2: 48 ms.
%0011, 3: 72 ms.
%0100, 4: 114 ms.
%0101, 5: 168 ms.
%0110, 6: 204 ms.
%0111, 7: 240 ms.
%1000, 8: 300 ms.
%1001, 9: 750 ms.
%1010, 10: 1.5 s.
%1011, 11: 2.4 s.
%1100, 12: 3 s.
%1101, 13: 9 s.
%1110, 14: 15 s.
%1111, 15: 24 s.
%Bits #4-#7: Sustain volume.
%Write-only.




% Use a clock freqency of 985248Hz for PAL C64


%// The audio output stage in a Commodore 64 consists of two STC networks,
%// a low-pass filter with 3-dB frequency 16kHz followed by a high-pass
%// filter with 3-dB frequency 16Hz (the latter provided an audio equipment
%// input impedance of 1kOhm). 


%reg16 EnvelopeGenerator::rate_counter_period[] = {
%      9,  //   2ms*1.0MHz/256 =     7.81
%     32,  //   8ms*1.0MHz/256 =    31.25
%     63,  //  16ms*1.0MHz/256 =    62.50
%     95,  //  24ms*1.0MHz/256 =    93.75
%    149,  //  38ms*1.0MHz/256 =   148.44
%    220,  //  56ms*1.0MHz/256 =   218.75
%    267,  //  68ms*1.0MHz/256 =   265.63
%    313,  //  80ms*1.0MHz/256 =   312.50
%    392,  // 100ms*1.0MHz/256 =   390.63
%    977,  // 250ms*1.0MHz/256 =   976.56
%   1954,  // 500ms*1.0MHz/256 =  1953.13
%   3126,  // 800ms*1.0MHz/256 =  3125.00
%   3907,  //   1 s*1.0MHz/256 =  3906.25
%  11720,  //   3 s*1.0MHz/256 = 11718.75
%  19532,  //   5 s*1.0MHz/256 = 19531.25
%  31251   //   8 s*1.0MHz/256 = 31250.00
%};
 

%// From the sustain levels it follows that both the low and high 4 bits of the
%// envelope counter are compared to the 4-bit sustain value.
%// This has been verified by sampling ENV3. 

% The ADSR bug can be triggered when Attack-rate/decay-rate or
% release rate is changed to a "faster" value than before.
% To avoid this, never change these values.
% Or, do a 33ms "pause" with ADSR all set to "0" - before starting another
% ADSR cycle.

% These pauses would require two separate noise voices.
% One could be in "reset" state while the other one is sounding.

% Solution: Always keep attack/sustain/release rate at 0


sliceNo = 1;
encIndex = 1;
enc = zeros(1,40000); %Just a guess. A really bad one as well.

while sliceNo < nofSlices,
    %First, skip through all zeroes:

    ticksToWait = 1;
    %Silence must be at least 9 slices, to make room for attack/decay
    while (((sidNoiseVolume(sliceNo) < 0.75) && (ticksToWait < 256) && (sliceNo < nofSlices-1)) || (ticksToWait <= 8)),
        sliceNo = sliceNo + 1;
        ticksToWait = ticksToWait + 1;
    end
    sliceNo = sliceNo + 1;
    startSlice = sliceNo;

    % Then count how long the noise should be:
    ticksToSound = 1;
    while (((sliceNo < nofSlices-4) && (sidNoiseVolume(sliceNo) + sidNoiseVolume(sliceNo+1) + sidNoiseVolume(sliceNo+2) + sidNoiseVolume(sliceNo+3)) > 0.9) && (ticksToSound < 255)),
        sliceNo = sliceNo + 1;
        ticksToSound = ticksToSound + 1;
    end
    sliceNo = sliceNo + 1;
    endSlice = sliceNo;

    len = startSlice-endSlice
    %ToDo: characterize the noise from startSlice to endSlice.
    %Extract cutoff freq + filter type
    
    %Now, we need to make an "average noise level" of all the
    %slices that should be sounding. Make a constant amplitude of the noise
    volume = sum(sidNoiseVolume(startSlice:endSlice-1))/(endSlice-startSlice)
    volume = ceil(volume);
    volume = max(1,volume);
    volume = min(16,volume);
    if (ticksToWait == 256)
        volume = 0;
        ticksToWait = 0;
        enc(encIndex) = ticksToWait;
        encIndex = encIndex + 1;
        enc(encIndex) = volume * 16;
        encIndex = encIndex + 1;
        sliceNo = sliceNo - 1;
    else
        enc(encIndex) = ticksToWait;
        encIndex = encIndex + 1;
        enc(encIndex) = volume * 16;
        encIndex = encIndex + 1;
        enc(encIndex) = ticksToSound;
        encIndex = encIndex + 1;
    end

    
end

enc = enc(1:encIndex);
enc(encIndex-3) = 0;
enc(encIndex-2) = 0;
enc(encIndex-1) = 0; %End of everything marker (ticksToSound = 0)


% Dump the encoded data into a file

fid = fopen('SIDencodedNoise.s','w');
fprintf(fid,'; encoded Noise generated by cubase64_6encodeNoise.m\n');
fprintf(fid,'; this table contains %d values\n',encIndex);
fprintf(fid,'; Generated on the %s\n',date);
fprintf(fid,'; Pex Mahoney Tufvesson, 2010\n');
fprintf(fid,'\n');
for i=1:encIndex-1,
    fprintf(fid,'  .byte %d\n',enc(i));
end
fprintf(fid,'; End of generated data\n');
fprintf(fid,'\n');
fclose(fid);



% Time to visualize the encoded Noise:

noiseOutput = zeros(1,nofSlices);
noiseIndex = 1;
encIndexEnd = encIndex;
encIndex = 1;
while encIndex < encIndexEnd,
    ticksToWait = enc(encIndex);
    encIndex = encIndex + 1;
    nextVol = enc(encIndex);
    encIndex = encIndex + 1;
    if ticksToWait == 0
        ticksToWait = 256;
    end
    noiseOutput(noiseIndex:noiseIndex+ticksToWait-1) = 0;
    noiseIndex = noiseIndex + ticksToWait;
    
    if (ticksToWait ~= 256)
        ticksToSound = enc(encIndex);
        encIndex = encIndex + 1;
        noiseOutput(noiseIndex:noiseIndex+ticksToSound-1) = nextVol;
        noiseIndex = noiseIndex + ticksToSound;
    end
end

figure(11);
clf;
plot(noiseOutput);
title('noiseOutput after encoding');
hold on;
plot(noiseOutput,'r.');



%sound(y(1:previewSamples),44100,16);




%  dec ticksToWait
%  bne nothing
%where:
%  beq on/off
%on:
%  lda #$81  ;Yes, it's time for noise!
%  sta $d404
%  ldy #0
%  lda (noisePoi),y
%  sta ticksToWait   ;How long will this noise be?
%  inc noisePoi+1
%  bne noWrr
%  inc NoisePoi
%  lda #off
%  sta where+1
%  rts
%off:
%  lda #$80  ;shut up!
%  sta $d404
%  ldy #0
%  lda (noisePoi),y
%  sta ticksToWait    ;How long will this silence be?
%  bne notQuit
%  lda #1
%  sta finished   ;We're all done, let's go home
%notQuit:
%  inc noisePoi+1
%  bne noWrr2
%  inc NoisePoi
%noWrr2:
%noWrr:
%  lda (noisePoi),y
%  sta $d406   ;Set sustain level for next noise
%  inc noisePoi+1
%  bne noWrr3
%  inc NoisePoi
%noWrr3:
%  lda #on
%  sta where+1
%  rts


