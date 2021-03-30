%
% This is the third encoder script for
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
% Beware, this script has not been touched for long, and I guess it needs
% some reworking to make it run. I'm using the cubase64 demo as a
% playback engine instead. This was just a playback draft before the
% demo was up and running.
%

format long;
format compact;
clear;


% ToDo:
%sum(SIDVoiceVolume)
%ans =
%        9779
%size(waveformsNormalized)
%ans =
%        9726         300
%max(SIDVoiceVolume)
% They should be equal, otherwise we have bad luck.


load 'whichWaveformsAreChosen.mat' %The order of which waveforms were chosen
load 'waveformStatus.mat' %Which waveform every waveforms resembles most.
load 'SIDVoiceVolume.mat' %Play/noPlay
load 'Formant0FreqencyTD2.mat' %contains pitch in Formant0TimeDomain2
load 'waveformsNormalized.mat'
baseFreq = Formant0TimeDomain2;

% Noteno, 1=110 Hz=A in octave 3
noteNo=(0:60);
twelfthRootOfTwo=2 .^ (1/12); % =1.059463094;
Hz = 55 * ( twelfthRootOfTwo .^ noteNo );

% Now, we have everything to "simulate" playback.
% SIDVoiceVolume tells us when to sound, and when to be quiet.
% Every time SIDVoiceVolume == 1, increase waveformNo
% Use waveformStatus to check which waveform we shall play.
% Increase pointer into SIDVoiceVolume every 8.192ms.
% This will be a bad "sample&hold" of waveforms, no interpolation.
% But I will make a Matlab model of "how bad" this will sound,
% just to get an idea.

Fs=44100;
% We want to detect pitch "approximately" every 8.192ms.
sliceSecondsTarget = 0.008192;
% This is due to using a 64-word buffer for
% playing samples, using a 7812.5Hz sample rate.
% So the audio can be sliced up in 8.192ms slices.
% Input audio is 44100Hz, 16-bit.
% Each slice is:
sliceLength = round(Fs * sliceSecondsTarget) %#ok<NOPTS>
% This is what we really got:
sliceSeconds = sliceLength / Fs %#ok<NOPTS>
% Calculate "how wrong" the speed will be due to rounding
% the sliceLength to an integer number of 16-bit audio samples.
timeSkew = (sliceSecondsTarget - sliceSeconds) / sliceSecondsTarget %#ok<NOPTS>

maxSamplesToRender = 6000000;
audio = zeros(1,maxSamplesToRender);
audioIndex = 1;

nofSlices=length(SIDVoiceVolume)


finished = 0;
sliceNoPrev = 1;
sliceNo = 1;
waveformTableIndex = 1;
waveformIndex = 0;
waveformSize = size(waveformsNormalized);
nofWaveforms = waveformSize(1);
waveformSize = waveformSize(2);
waveformToUseNow = 1;
waveformToUseNextTime = 1;
fromSilence = 0;

while ((finished==0) && (audioIndex < maxSamplesToRender) && (waveformTableIndex < nofWaveforms))
    if (SIDVoiceVolume(sliceNo) == 0)
        audioIndex = audioIndex + sliceLength;
        sliceNo = sliceNo + 1;
        waveformNo = waveformStatus(waveformTableIndex);
        waveformNo = max(1,waveformNo); %Don't let a 0 ruin our day
        waveformToUseNextTime = waveformNo;
        waveformToUseNow = waveformToUseNextTime;
        fromSilence = 1;
    else
        % Check if we come from silence, then restart waveformIndex:
        if (fromSilence == 1)
            fromSilence = 0;
            waveformIndex = 0;
            waveformNo = waveformStatus(waveformTableIndex);
            waveformNo = max(1,waveformNo); %Don't let a 0 ruin our day
            waveformToUseNextTime = waveformNo;
            waveformToUseNow = waveformToUseNextTime;
        end

        pitch = baseFreq(sliceNo);
        waveformIndexSpeed = pitch / Hz(18);
        for (i = 1:sliceLength)
            % render the whole slice
            audio(audioIndex) = waveformsNormalized(waveformToUseNow,floor(waveformIndex) + 1);
            waveformIndex = waveformIndex + waveformIndexSpeed;
            if (waveformIndex >= (waveformSize))
                waveformIndex = waveformIndex - waveformSize;
                waveformToUseNow = waveformToUseNextTime;
            end
            audioIndex = audioIndex + 1;
        end
        sliceNo = sliceNo + 1;
        waveformTableIndex = waveformTableIndex + 1;
        waveformNo = waveformStatus(waveformTableIndex);
        waveformNo = max(1,waveformNo); %Don't let a 0 ruin our day
        waveformToUseNextTime = waveformNo;
    end
    if (sliceNo >= nofSlices)
        finished = 1;
    end
end

% Normalize audio to fit within +1.0 to -1.0
maxA = max(audio);
minA = min(audio);
maxB = max(maxA,-minA);
audio = audio ./ maxB;
wavwrite(audio(1:audioIndex),Fs,16,'tomsDinerSampleHoldPreview.wav');





% When all waveforms are chosen, it's time to try to map _every_ single
% waveform that we have onto a linear combination of two waveforms.
% Maybe this will be with some heavy limitations due to memory
% requirements.
% And also, the number of volume levels will be only a few, probably
% only 25%, 33%, 50%, 66%, 75% and 100%.



% Let's try to create one waveform and modify this.

% The replay routine will have to take care of the pitching.
% And no pitch tables, we need to have "human" qualities of the
% pitch curve, so it needs to be imperfect.

% The mixing routine will blend "the old waveform" with a new one.
% The mixing routine will use pha to store values.
% The mixing routine cannot use pla to get values, since any
% interrupt that occurs will destroy the waveform.

% Or, the waveform could be stored, double buffered, in ZeroPage.


% Replay with no mixing routine:

% IRQ handling                    7
%         STA     SaveAnmi+1      3
%         ...a few clocks sync 0 - 4 of them
%         JMP     ZeroCode        3
%ZeroCode:
%        LDA     #$11             2
%        STA     $D404            4
%        LDA     #9               2
%        STA     $D404            4
%Poi:
%        LDA     $3000            4
%        STA     $D401            4
%        LDA     #1               2
%        STA     $D404            4
%        INC     Poi+1            5
%SaveAnmi:
%        LDA     #$A              2
%        JMP     $DD0C            3
%DD0C:   RTI                      6
%                               =55-59 clocks in all
% We have 126-55 = 67-71 clocks left per sample for the mixing routine
% A badline will take 40 of these. = 27-31 clocks left on a badline

