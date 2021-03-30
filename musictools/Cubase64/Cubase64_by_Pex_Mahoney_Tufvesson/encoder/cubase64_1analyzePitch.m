%
% This is the first encoder script for
%
%   cubase64 by Pex 'Mahoney' Tufvesson, October 2010
%
% Run it using Matlab, you'll probably need a couple of toolboxes
% and a lot of patience. And you'll need 4GB of RAM, preferably on a 64-bit machine.
% Matlab requires continuous memory for its variables, so your 32-bit machine
% will get its virtual memory fragmented. I warned you.
%
% After running all Matlab scripts, you'll find a number of
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

% Takes the complete "Tom's Diner" and extracts the pitch/formants in it. Needs no "global" knowledge of the audio file, can therefore be applied to small parts of the audio file.

% "Shortcuts" if you need to modify this script and run it faster:
% (set to = 1) below...

loadFormantFile = 0;
loadRmsFile = 0;
loadX2File = 0;
loadConstantAudioFile = 0;
debugging = 1;

% Noteno, 1=55 Hz=A in octave 2
noteNo=(0:60);
twelfthRootOfTwo=2 .^ (1/12); % =1.059463094;
Hz = 55 * ( twelfthRootOfTwo .^ noteNo );

[originalAudio,Fs,bits]=wavread('Suzanne_Vega_-_Toms_Diner_mono');

%Fs = 44100;
%bits=16;
%t = 0:(1/Fs):2;            % 4 secs @ 44.1kHz sample rate
%originalAudio = chirp(t,100,2,800)';     % Start = 100Hz, 
                          %   cross 800Hz at t=10 sec
%spectrogram(y,256,250,256,1E3,'yaxis') 


% When debugging, only use a fragment of the sound
%if (debugging==1)
%    previewLength = 6; % in Seconds
%    offset = 14; % in Seconds
%    offsetSamples = offset * Fs;
%    previewSamples = floor((previewLength*Fs) / sliceLength) * sliceLength;
%    originalAudio = originalAudio((offsetSamples+1):(previewSamples+offsetSamples));
%end;


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
originalAudioLength = length(originalAudio) %#ok<NOPTS>
nofSlices = floor(originalAudioLength / sliceLength) %#ok<NOPTS>

%Now determine which overlap we want when doing FFT calculations.
%(and all other slice calculations as well)
%Making a slice double length is probably a good idea.
overlap = 2.0;
fftLength = ceil(overlap * sliceLength) %#ok<NOPTS>

%Time to choose a windowing function for calculations:
fftWindow=hanning(fftLength);


%t=1:originalAudioLength;


% Need to do calculations incrementally, since memory requirements
% may get out of hand if doing all at once.
% Must avoid doing global calculations like max(all) or mean(all)



% Could use a filter with a bandpass filter with stopband defined from 0 to 120Hz
% and passband defined from 140 Hz to 330 Hz.
% Specify a passband ripple of 5%
% ...but to make things faster, we'll "only" do a low pass filter
% which passes all frequencies below 330 Hz, and stops all frequencies
% above 370Hz. Ripple 0.1. This is an "easier" filter that doesn't
% require as many bins/as high order as the bandpass version.
% ..and the original audio is a cappella already, so it should be pretty
% quiet below 120Hz anyway!

% This is the filter, if we decide to use it:
fsamp = Fs;
%fcuts = [120 140 330 370];
%mags = [0 1 0];
%devs = [0.1 0.1 0.1];
fcuts = [330 370];
mags = [1 0];
devs = [0.1 0.1];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
figure(1);
freqz(hh);


% Now reserve memory for all the different pitch detection methods:
Formant0LPC = zeros(1,nofSlices);
Formant0Cepstrum = zeros(1,nofSlices);
Formant0Cepstrum2 = zeros(1,nofSlices);
Formant0TimeDomain = zeros(1,nofSlices);
Formant0TimeDomain2 = zeros(1,nofSlices);
Formant0LPCdirect = zeros(1,nofSlices);


if loadFormantFile == 1
    % We have a file with the data, no need to calculate it again:
    % This is to speed things up if we already have run this part.
    load 'Formant0FreqencyTD2.mat'  % Contains Formant0TimeDomain2
else

    for sliceNo=1:nofSlices-2,
        sliceNo %#ok<NOPTS>
        sliceMiddleIndex = round((sliceNo + overlap/2) * sliceLength + 1) %#ok<NOPTS>
        sliceStartIndex = ceil(sliceMiddleIndex - (sliceLength/2)) %#ok<NOPTS>
        sliceEndIndex = floor(sliceMiddleIndex + (sliceLength/2)) %#ok<NOPTS>
        sliceStartIndexOverlap = ceil(sliceMiddleIndex - (fftLength/2)) %#ok<NOPTS>
        sliceEndIndexOverlap = floor(sliceMiddleIndex + (fftLength/2) - 1) %#ok<NOPTS>

        
        
        %The time domain way of getting base frequency:
        %This code plots the autocorrelation function for a section of audio signal:
        fs = Fs*8;
        ms2=floor(fs/310);                 % maximum speech Fx
        ms20=floor(fs/120);                 % minimum speech Fx
%        x = originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+(fftLength/2)))';
%        x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength))))';
        x = (detrend(originalAudio(sliceStartIndexOverlap:sliceEndIndexOverlap))).*fftWindow;
        x = resample(x,8,1); % Use 8x oversampling
%        x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)))).*W;
%        extraMargin = size(hh);
%        extraMargin=extraMargin(2);
%        x = filter(hh,1,[x']);        
        if debugging==2
            % plot waveform
            lenx = size(x);
            lenx = lenx(2);
            t=(0:lenx-1)/fs;        % times of sampling instants
            subplot(2,1,1);
            plot(t,x);
            legend('Waveform');
            xlabel('Time (s)');
            ylabel('Amplitude');
        end
        % calculate autocorrelation
        r=xcorr(x,ms20,'coeff');   
        if debugging==2
            % plot autocorrelation
            d=(-ms20:ms20)/fs;          % times of delays
            subplot(2,1,2);
            plot(d,r);
            legend('Autocorrelation');
            xlabel('Delay (s)');
            ylabel('Correlation coeff.');
        end
        %You can see that the autocorrelation function peaks at zero delay and at delays corresponding to ?? 1 period,  ?? 2 periods, etc.  We can estimate the fundamental frequency by looking for a peak in the delay interval corresponding to the normal pitch range in speech, say 2ms(=500Hz) and 20ms (=50Hz).  For example:
        % just look at region corresponding to positive delays
        r=r(ms20+1:2*ms20+1);
        [rmax,tx]=max(r(ms2:ms20));
%        fprintf('rmax=%g Fx=%gHz\n',rmax,fs/(ms2+tx-1));
        frequency = fs/(ms2+tx-1);
        Formant0TimeDomain2(sliceNo)=frequency;        
        

%ToDo: fix the pitch detection algorithms that we don't use anymore
%      to use sliceStartIndex/etc instead of "hardcoded" indices.
       
        
%         % Pitch detection - using LPC to find the best IIR filter from
%         % a section of speech signal and then plotting the filter's frequency 
%         % response.
%         x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)))).*W;
%         %[x,fs]=wavread('six.wav',[24120 25930]);
% 
%         % resample to 10,000Hz (optional)
%         %x=resample(x,10000,fs);
%         %fs=10000;
% 
%     % Now, bandpass filter the slice:
%     %    extraMargin=1700;
%     %    x = filtfilt(hh,1,[zeros(1,extraMargin) x' zeros(1,extraMargin)]);
%         extraMargin = size(hh);
%         extraMargin=extraMargin(2);
%         x = filter(hh,1,[x' zeros(1,extraMargin)]);
%         if debugging==2
%             % plot waveform
%             figure(2);
%             len=size(x);
%             len=len(2);
%             t=(0:len-1)/Fs;        % times of sampling instants
%             subplot(2,1,1);
%             plot(t,x);
%             legend('Waveform');
%             xlabel('Time (s)');
%             ylabel('Amplitude');
%         end
% 
%         %
%         % get Linear prediction filter
%         %ncoeff=2+Fs/1000;           % rule of thumb for formant estimation
%         ncoeff=10;           % rule of thumb for formant estimation
%         a=lpc(x,ncoeff);
% 
%         if debugging==2
%             % plot frequency response
%             [h,f]=freqz(1,a,512,Fs);
%             subplot(2,1,2);
%             plot(f,20*log10(abs(h)+eps));
%             legend('LP Filter');
%             xlabel('Frequency (Hz)');
%             ylabel('Gain (dB)');
%         end
% 
% % This is one way of getting the root frequency:        
%         %To find the formant frequencies from the filter, we need to find the locations of the resonances that make up the filter.  This involves treating the filter coefficients as a polynomial and solving for the roots of the polynomial.  Details are outside the scope of this course (see readings).  Here is the code to find estimated formant frequencies from the LP filter:
%         % find frequencies by root-solving
%         r=roots(a);                  % find roots of polynomial a
%         r=r(imag(r)>0.01);           % only look for roots >0Hz up to fs/2
%         ffreq=sort(atan2(imag(r),real(r))*Fs/(2*pi));
%         % convert to Hz and sort
%         len = size(ffreq);
%         len = len(1);
%     %    for i=1:len
%     %        fprintf('Formant %d Frequency %.1f\n',i,ffreq(i));
%     %    end
%     %    ffreq(1)
%         frequency=ffreq(1);
%         if frequency < 120
%             frequency = frequency * 2;
%         end
%         if frequency < 120
%             frequency = frequency * 2;
%         end
%         if frequency > 320
%             frequency = frequency / 2;
%         end
%         Formant0LPC(sliceNo+1)=frequency;
        

        
        
        
        
        

% %The Cepstrum2 way of getting F0:
%         fs = Fs;
%         
% %        N = length(x);
% %         y = fft(x, N);
%         x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)))).*W;
%         extraMargin = size(hh);
%         extraMargin=extraMargin(2);
%         x = filter(hh,1,[x' zeros(1,extraMargin)]);        
%         yf = fft(x);
%         % Cepstrum is IDFT (or DFT) of log spectrum
%         c = ifft(log(abs(yf)+eps));         
%   %      [c,ym] = rceps(x); % returns both the real cepstrum y and a minimum phase reconstructed version ym of the input sequence.
%         %rceps is an M-file implementation of algorithm 7.2 in [2], that is,        
%         %y = real(ifft(log(abs(fft(x)))));
%         %Appropriate windowing in the cepstral domain forms the reconstructed minimum phase signal:        
%         %w = [1;2*ones(n/2-1,1);ones(1-rem(n,2),1);zeros(n/2-1,1)];
%         %ym = real(ifft(exp(fft(w.*y))));        
%         %function [f0] = spPitchCepstrum(c, fs)
%         % search for maximum  between 2ms (=500Hz) and 20ms (=50Hz)
%         ms2=floor(fs/350); % 2ms
%         ms20=floor(fs/100); % 20ms
%         [maxi,idx]=max(abs(c(ms2:ms20)));
%         f0 = fs/(ms2+idx-1);
%         Formant0Cepstrum2(sliceNo+1)=f0;
 
 
 
% %The Cepstrum way of getting F0:
%         fs=Fs;
%         % get a section of vowel
%         ms1=floor(Fs/350);                 % maximum speech Fx at 1000Hz
%         ms20=floor(Fs/100);                  % minimum speech Fx at 50Hz
% 
%         % do fourier transform of windowed signal
%         x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)))).*W;
%         Y=fft(x);
%         lenY = size(Y);
%         lenY=lenY(2);
%         if debugging==2
%             % plot spectrum of bottom 5000Hz
%             hz5000=5000*lenY/fs;
%             f=(0:hz5000)*fs/lenY;
%             subplot(3,1,2);
%             lenf = size(f);
%             lenf = lenf(2);
%             plot(f,20*log10(abs(Y(1:lenf))+eps));
%             legend('Spectrum');
%             xlabel('Frequency (Hz)');
%             ylabel('Magnitude (dB)');
%         end
%         %
%         % cepstrum is DFT of log spectrum
%         C=fft(log(abs(Y)+eps));
%         if debugging==2
%             % plot between 1ms (=1000Hz) and 20ms (=50Hz)
%             q=(ms1:ms20)/fs;
%             subplot(3,1,3);
%             plot(q,abs(C(ms1:ms20)));
%             legend('Cepstrum');
%             xlabel('Quefrency (s)');
%             ylabel('Amplitude');
%         end
%         %To search for the index of the peak in the cepstrum between 1 and 20ms, and then convert back to hertz, use:
%         [c,fx]=max(abs(C(ms1:ms20)));
%         %fprintf('Fx=%gHz\n',fs/(ms1+fx-1));
%         frequency = fs/(ms1+fx-1);
%         Formant0Cepstrum(sliceNo+1)=frequency;


        
        
        
        
        
        
%         %The time domain way of getting base frequency:
%         %This code plots the autocorrelation function for a section of speech signal:
%         fs = Fs;
%         ms2=floor(fs/400);                 % maximum speech Fx
%         ms20=floor(fs/100);                 % minimum speech Fx
%         x = (detrend(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)))).*W;
%         if debugging==2
%             % plot waveform
%             lenx = size(x);
%             lenx = lenx(2);
%             t=(0:lenx-1)/fs;        % times of sampling instants
%             subplot(2,1,1);
%             plot(t,x);
%             legend('Waveform');
%             xlabel('Time (s)');
%             ylabel('Amplitude');
%         end
%         % calculate autocorrelation
%         r=xcorr(x,ms20,'coeff');   
%         if debugging==2
%             % plot autocorrelation
%             d=(-ms20:ms20)/fs;          % times of delays
%             subplot(2,1,2);
%             plot(d,r);
%             legend('Autocorrelation');
%             xlabel('Delay (s)');
%             ylabel('Correlation coeff.');
%         end
%         %You can see that the autocorrelation function peaks at zero delay and at delays corresponding to ?? 1 period,  ?? 2 periods, etc.  We can estimate the fundamental frequency by looking for a peak in the delay interval corresponding to the normal pitch range in speech, say 2ms(=500Hz) and 20ms (=50Hz).  For example:
%         % just look at region corresponding to positive delays
%         r=r(ms20+1:2*ms20+1);
%         [rmax,tx]=max(r(ms2:ms20));
% %        fprintf('rmax=%g Fx=%gHz\n',rmax,fs/(ms2+tx-1));
%         frequency = fs/(ms2+tx-1);
%         Formant0TimeDomain(sliceNo+1)=frequency;        

        


        

        
        
        
% % This is one way of doing it - probably not the best one,
% % since the detected frequencies jump around quite a bit.
%         
%         % Making a signal zero mean could be done with detrend(signal);
%         sliceMean = mean(originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength)));
% 
%         % Pitch detection - using LPC to find the best IIR filter from
%         % a section of speech signal and then plotting the filter's frequency 
%         % response.
%         x = (originalAudio((sliceNo*fftLength/2+1):(sliceNo*fftLength/2+fftLength))-sliceMean).*W;
%         %[x,fs]=wavread('six.wav',[24120 25930]);
% 
%         % resample to 10,000Hz (optional)
%         %x=resample(x,10000,fs);
%         %fs=10000;
% 
%         if debugging==2
%             % plot waveform
%             t=(0:fftLength-1)/Fs;        % times of sampling instants
%             subplot(2,1,1);
%             plot(t,x);
%             legend('Waveform');
%             xlabel('Time (s)');
%             ylabel('Amplitude');
%         end
% 
%         %
%         % get Linear prediction filter
%         ncoeff=2+Fs/1000;           % rule of thumb for formant estimation
%         ncoeff=6;           % rule of thumb for formant estimation
%         a=lpc(x,ncoeff);
% 
%         if debugging==2
%             % plot frequency response
%             [h,f]=freqz(1,a,512,Fs);
%             subplot(2,1,2);
%             plot(f,20*log10(abs(h)+eps));
%             legend('LP Filter');
%             xlabel('Frequency (Hz)');
%             ylabel('Gain (dB)');
%         end
% 
%         %To find the formant frequencies from the filter, we need to find the locations of the resonances that make up the filter.  This involves treating the filter coefficients as a polynomial and solving for the roots of the polynomial.  Details are outside the scope of this course (see readings).  Here is the code to find estimated formant frequencies from the LP filter:
% 
% 
%         % find frequencies by root-solving
%         r=roots(a);                  % find roots of polynomial a
%         r=r(imag(r)>0.01);           % only look for roots >0Hz up to fs/2
%         ffreq=sort(atan2(imag(r),real(r))*Fs/(2*pi));
% 
%         % convert to Hz and sort
%         len = size(ffreq);
%         len = len(1);
%     %    for i=1:len
%     %        fprintf('Formant %d Frequency %.1f\n',i,ffreq(i));
%     %    end
%         ffreq(1);
%         frequency = ffreq(1);
%         if frequency < 120
%             frequency = frequency * 2;
%         end
%         if frequency < 120
%             frequency = frequency * 2;
%         end
%         Formant0LPCdirect(sliceNo+1)=frequency;
        
        
        
        



    end

    save 'Formant0FreqencyTD2.mat' Formant0TimeDomain2

    figure(5);
    clf;
    plot(Formant0LPC,'b');         %Works pretty ok, seems to always say 10Hz higher than the rest
    hold on
    plot(Formant0TimeDomain,'r');  %Works pretty ok
    plot(Formant0Cepstrum,'g');
%    plot(Formant0LPCdirect,'m'); %Not ok at all. Disable this one
    plot(Formant0Cepstrum2,'y');
    plot(Formant0TimeDomain2,'m');

end

%The time domain pitch detection works best here, let's use that one:
Formant0 = Formant0TimeDomain2;











% Now, extract some kind of very simple volume envelope for this.
%Should probably be sime kind of "When too much noise, be silent"
%When nothing at all, be silent.
%Else, be full volume.

SIDVoiceVolume = zeros(1,nofSlices);
rms = zeros(1,nofSlices);
rmsHigh = zeros(1,nofSlices);
rmsLow = zeros(1,nofSlices);

%Design a highpass filter with stopband defined from 0 to 3500Hz
% and passband defined from 4000 Hz to 20 kHz.
% Specify a passband ripple of 5% and a stopband attenuation of 40 dB:

fsamp = Fs;
fcuts = [3500 4000];
mags = [0 1];
devs = [0.05 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
figure(2)
freqz(hh)

%Design a lowpass filter with passband defined from 0 to 3500Hz
% and stopband defined from 4000 Hz to 20 kHz.
% Specify a passband ripple of 5% and a stopband attenuation of 40 dB:
mags = [1 0];
devs = [0.05 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
hhlow = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
figure(3)
freqz(hhlow)

overlapSample = 50; %nofSamples to include "outside" the slice

if loadRmsFile == 1
    load 'rms.mat'  % Contains rms, rmsHigh, rmsLow
else
    for sliceNo=1:nofSlices-2,
        sliceNo %#ok<NOPTS>
        sliceMiddleIndex = round((sliceNo + overlap/2) * sliceLength + 1) %#ok<NOPTS>
        sliceStartIndex = ceil(sliceMiddleIndex - (sliceLength/2)) %#ok<NOPTS>
        sliceEndIndex = floor(sliceMiddleIndex + (sliceLength/2)) %#ok<NOPTS>
        sliceStartIndexOverlap = ceil(sliceMiddleIndex - (fftLength/2)) %#ok<NOPTS>
        sliceEndIndexOverlap = floor(sliceMiddleIndex + (fftLength/2) - 1) %#ok<NOPTS>

        sliceLen2 = sliceEndIndex-sliceStartIndex+overlapSample*2;
        W = hanning(sliceLen2);
        % Time to estimate the noise in here:
        sliceData = detrend(originalAudio(sliceStartIndex-overlapSample:sliceEndIndex+overlapSample-1)) .* W;
        
        % Making the slice zero mean:
%        sliceData = detrend(originalAudio(sliceStartIndexOverlap:sliceEndIndexOverlap)).*fftWindow;

        %This example uses norm(x)/sqrt(n) to obtain the root-mean-square (RMS) value of an n-element vector x.
        %x = [0 1 2 3]
        %sqrt(0+1+4+9)   % Euclidean length
        %ans =
        %    3.7417
        %norm(x)
        %ans =
        %    3.7417
        %n = length(x)   % Number of elements
        %rms = 3.7417/2  % rms = norm(x)/sqrt(n)

        len = size(sliceData);
        len = len(1);
        rms(sliceNo) = norm(sliceData) / len;

        % Now, extract "how much noise" there is above 4kHz.
        % If too much, be silent.
        % Make a high pass filtered version of x
        
        xhigh = filter(hh,1,[sliceData' zeros(1,overlap*3)]);
        rmsHigh(sliceNo) = norm(xhigh) / len;

        xlow = filter(hhlow,1,[sliceData' zeros(1,overlap*3)]);
        rmsLow(sliceNo) = norm(xlow) / len;
    end
    % Save all calculated values to file:  
    save 'rms.mat' rms*
end

figure(8);
clf;
plot(rms);
hold on;
plot(rmsHigh,'y');
plot(rmsLow,'r');
legend('RMS','RMS for high frequencies > 4kHz','RMS for low frequencies < 4kHz');

% From the plot above, we shall be silent when rmsHigh > rmsLow.
maxRmsLow = max(rmsLow);
threshold = maxRmsLow * 0.03;
plot([0 nofSlices],[threshold threshold],'g');


for sliceNo=1:nofSlices-1,
    if ((rmsLow(sliceNo) > rmsHigh(sliceNo)) && (rmsLow(sliceNo) > threshold))
%        SIDVoiceVolume(sliceNo) = rmsLow(sliceNo+1);
        SIDVoiceVolume(sliceNo) = 1;
    else
        SIDVoiceVolume(sliceNo) = 0;
    end
end


% Make frequencies "nicer". First of all,
% remove all lonely spurious slices. A slice with volume>0 that has only
% "silent neighbours" V(n-1)=0 and V(n+1)=0 will be set to silent.
for sliceNo=2:nofSlices-2,
    if SIDVoiceVolume(sliceNo)~=0
        if ((SIDVoiceVolume(sliceNo-1)==0) && (SIDVoiceVolume(sliceNo+1)==0))
            SIDVoiceVolume(sliceNo) = 0;
        end
    end
end

% Make frequencies "nicer". Now, fill in the gaps.
% Remove all lonely silent slices. A slice with volume=0 that has only
% "noisy neighbours" V(n-1)!=0 and V(n+1)=!0 will be set to volume=1.
for sliceNo=2:nofSlices-2,
    if SIDVoiceVolume(sliceNo)==0
        if ((SIDVoiceVolume(sliceNo-1)~=0) && (SIDVoiceVolume(sliceNo+1)~=0))
            SIDVoiceVolume(sliceNo) = 1;
        end
    end
end
save 'SIDVoiceVolume.mat' SIDVoiceVolume

maxF0 = max(Formant0);
figure(9)
clf;
plot(SIDVoiceVolume,'.');
hold on;
plot(rmsLow / maxRmsLow,'y');
legend('SIDVoiceVolume','rms low frequencies < 4kHz');
plot(Formant0 ./ maxF0 .* SIDVoiceVolume,'r.');


% The notes of Tom's Diner are:
% I  am sit-ting in the mor-ning at  the Di-ner on   the cor-ner
% F# G# A   C#   F# G#  A   C#   F#  C#  B   A  B    A   B   A
% I  am wai-ting at the coun-ter for the man to pour the cof-fe

% and he fills it only halfway and before I even argue
% F#  F  E     C# C#   C#  B   A   F# D   C# C# B D C#
% He is looking at the window at somebody coming in
% A  B  C#  D   A  B   C#  D   A D   D C# C#  B  C#

%The note values used through the whole song are:
% Note Name   Hz                     nofSamples@7812.5Hz
% D   Hz(18)  146.8323839587038 Hz   53.206927445904853
% E   Hz(20)  164.8137784564350 Hz   47.401983457742659
% F   Hz(21)  174.6141157165020 Hz   44.741514555925860
% F#  Hz(22) 184.9972113558173 Hz    42.230366299812502
% G#  Hz(24) 207.6523487899727 Hz    37.622979203099938
% A   Hz(25) 220 Hz                  35.511363636363598
% B   Hz(27) 246.9416506280622 Hz    31.637028343051789
% C#  Hz(29) 277.1826309768723 Hz    28.185387996594418
% D   Hz(30) 293.6647679174077 Hz    26.603463722952405

%Now, cap the Formant0 frequencies to be between 140Hz and 320Hz.
baseFreq = Formant0;


% It's done already, we'll skip this part...
% for sliceNo=0:nofSlices-2,
%     if baseFreq(sliceNo+1) > 610
%         baseFreq(sliceNo+1) = baseFreq(sliceNo+1) / 2;
%     end
%     if baseFreq(sliceNo+1) < 290
%         baseFreq(sliceNo+1) = baseFreq(sliceNo+1) * 2;
%     end
%     if baseFreq(sliceNo+1) < 290
%         baseFreq(sliceNo+1) = baseFreq(sliceNo+1) * 2;
%     end
%     if (SIDVoiceVolume(sliceNo+1) == 0)
%         baseFreq(sliceNo+1) = 0;
%     end
%     
% end


x=1:nofSlices;
x2=[1 nofSlices];
figure(10);
clf;
%plot(x,baseFreq,'.');
plot(x, baseFreq .* SIDVoiceVolume,'.');
hold on;
plot(x2,[Hz(18) Hz(18)],'r');
plot(x2,[Hz(20) Hz(20)],'r');
plot(x2,[Hz(21) Hz(21)],'r');
plot(x2,[Hz(22) Hz(22)],'r');
plot(x2,[Hz(24) Hz(24)],'r');
plot(x2,[Hz(25) Hz(25)],'r');
plot(x2,[Hz(27) Hz(27)],'r');
plot(x2,[Hz(29) Hz(29)],'r');
plot(x2,[Hz(30) Hz(30)],'r');


%


% Now count the number of "phrases". The definition of
% phrase is a continuous block where the SIDVoiceVolume = 1
nofPhrases = 0;
for sliceNo=2:nofSlices-2, %Don't do the first one or the last one...
    if ((SIDVoiceVolume(sliceNo) == 1) && (SIDVoiceVolume(sliceNo-1)==0))
        nofPhrases = nofPhrases + 1;
    end
end

% There are ~276 phrases. Using "sliding granular synthesis" without
% pitching would give us approximately 32768/nofPhrases = 118 bytes per
% phrase. This is probably too little.


oversamplingRatio = 2;

if (loadX2File == 1)
    load 'filteredAudioX2'
else
    % Time to resample the originalAudio into contant-pitch audio.
    % We need to keep track of "sliceMiddleIndex" and its
    % corresponding pitch.

    % We can run out of memory while doing this, so make the oversampling
    % ratio variable:

    originalAudioX = resample(originalAudio,oversamplingRatio,1); % Use oversampling

    % Filter the audio to remove "vikningseffekten" mirroring unwanted
    % frequencies down in the pass band by exceeding the Nyqvist frequency.
    % We will have a 7812.5Hz sample rate, so we'll need to remove
    % frequencies above 3906kHz.
    % Note that we will pitch this down _after_ we've done this
    % filtering, and then pitch it back up again. So we can happily
    % use a straight 3.5kHz cutoff frequency for this one. Not really true,
    % since slices with different pitch will match to the same waveform.
    % But, hey, who's perfect? ;)

    fsamp = Fs*oversamplingRatio;
    %fcuts = [120 140 330 370];
    %mags = [0 1 0];
    %devs = [0.1 0.1 0.1];
%    fcuts = [3510 3906];
    fcuts = [3310 3906];
    mags = [1 0];
    devs = [0.1 0.1];
    [n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
    hh = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
    figure(20);
    freqz(hh);

    % Make a zero-phase filtering, to make sure that
    % the slice middle index actually points to almost
    % the same spot in the audio material.
    filteredAudioX = filtfilt(hh,1,originalAudioX);
    save 'filteredAudioX2' filteredAudioX
end


%Then, resample (non-integer resampling) with a
% spline-shaped pitch curve locally around the slice to make the 
% base frequencies equal.
% Find a wavetable that _includes_ the middle sample.
% Let the middle sample be the "positive peak value" of the wavetable.

% pitch
% ^
% |  X..
% |     ..
% |       .       ...X
% |        ..X....
% |-------------------> time
%

% The "new" time axis will be calculated by looking at the
% values of the pitch.
% We have pitch values on each slice.
% Make the spline to approximate pitch for _all_ audio values.
% First of all, calculate all the middleIndices
sliceMiddleIndices = zeros(1,nofSlices);
for sliceNo=1:nofSlices-1,
    sliceMiddleIndices(sliceNo) = round((sliceNo + overlap/2) * sliceLength + 1);
end

% Now, find pitch values corresponding to all filteredAudioX indices:
len = length(originalAudio);
xx = 1:len;
originalAudioPitch = spline(sliceMiddleIndices,baseFreq,xx);
figure(21);
plot(sliceMiddleIndices(1:100),baseFreq(1:100),'o',xx(1:10000),originalAudioPitch(1:10000));

% Now walk through filteredAudioX with a speed corresponding to the pitch.
% This will tune all singing to be the same pitch throughout the song.
% What frequency do we want the singing to be?
% We want to extract wavetables from the audio. One wavetable should be
% an integer number of words, and 
% the "lowest" frequency we want contains 53.206927445904853
% samples@7812.5Hz.
% This means that we choose a wave table length of 51 samples, which will
% fit nicely with 5 wave tables per 256 bytes.

% The frequency of filteredAudioX is 
filteredFs=Fs*oversamplingRatio
% To pick out 51 integer values when the pitch is 146.8323839587038Hz
% (Hz(18)):
% The filteredAudioX for Hz(18) contains 
Hz18nofSamples = filteredFs / Hz(18)
% samples

% We want every other frequency to contain the same number of samples.
% The speed to "walk through" the sample will be:
note=24
Hz(18) / Hz(note) * oversamplingRatio

% This will make the output audio be Fs Hz (most often 44100Hz, for easy
% listening).

filteredAudioXIndex = 2;
filteredAudioXLength = length(filteredAudioX);
constantPitchAudioIndex = 2;
finished = 0;

constantPitchAudio = zeros(1,length(filteredAudioX)); % Not quite right, but good enough...

% We need to keep track of "where" the original middleIndices went in our
% new constantPitchAudio. New record for long variable name. Whoppie!
sliceMiddleIndexConstantPitchAudio = zeros(1,nofSlices);

while (filteredAudioXIndex < filteredAudioXLength)
    % Bad zero-order interpolation:
    %pitch = filteredAudioXPitch(floor(filteredAudioIndex));
    % Better linear interpolation:
    originalAudioIndex = filteredAudioXIndex / oversamplingRatio;
    frac = originalAudioIndex - floor(originalAudioIndex);
    pitch = originalAudioPitch(floor(originalAudioIndex)) * (1-frac) + originalAudioPitch(floor(originalAudioIndex)+1) * frac;
    % The spline-interpolated pitch can and will be negative, due to
    % rand-factors and BadThings(tm). So, let's make it a little bit more
    % sane:
    if (pitch < 100)
        pitch = 100;
    end
    speed = Hz(18) / pitch * oversamplingRatio;

    % Linear interpolation for sample values has to be enough as well:
    frac = filteredAudioXIndex - floor(filteredAudioXIndex);
    constantPitchAudio(constantPitchAudioIndex) = filteredAudioX(floor(filteredAudioXIndex)) * (1-frac) + filteredAudioX(floor(filteredAudioXIndex)+1) * frac;

    % Save the index for later. We only need an integer index, so don't
    % care about doing this precisely.
    %sliceNo = ..... ToDo...
    %sliceMiddleIndices(sliceNo) = round((sliceNo + overlap/2) * sliceLength + 1);
    %index = (sliceNo + overlap/2) * sliceLength + 1;
    %(index-1)/sliceLength = sliceNo + overlap/2;
    %(index-1)/sliceLength - overlap/2 = sliceNo;
    sliceNo = (filteredAudioXIndex/oversamplingRatio - 1) / sliceLength - overlap/2;
    if (sliceNo <= 0)
        sliceNo = 1;
    end
    sliceMiddleIndexConstantPitchAudio(ceil(sliceNo)) = constantPitchAudioIndex;
    
    % Increment indices:
    filteredAudioXIndex = filteredAudioXIndex + speed;
    constantPitchAudioIndex = constantPitchAudioIndex + 1;
end

% Now, constantPitchAudio contains the whole song, at Fs Hz,
% with all frequencies pitched "down" to Hz(18) = 146.8323839587038 Hz

constantPitchAudio=constantPitchAudio(1:constantPitchAudioIndex);
save 'constantPitchAudio.mak' constantPitchAudio
wavwrite(constantPitchAudio,Fs,16,'constantPitchAudio16.wav');
save 'sliceMiddleIndexConstantPitchAudio.mak' sliceMiddleIndexConstantPitchAudio



% Wavetable extraction

% Let's grab one loopable waveform around every
% sliceMiddleIndexConstantPitchAudio
% Let the sliceMiddleIndex be in the middle of the waveform,
% and not "The first positive zero-crossing to the left of the peak",
% as it used to be.
% And, let's use just the non-silent ones.

waveformLength = round(Fs / Hz(18));   %="Almost" 300
waveforms = zeros(nofSlices,waveformLength);
waveformsNormalized = zeros(nofSlices,waveformLength);
usedSliceIndex = 1;

for sliceNo=2:nofSlices-3, %Don't do the first one or the last one...
    sliceNo
    if (SIDVoiceVolume(sliceNo) ~= 0)
        sliceMiddleIndex = sliceMiddleIndexConstantPitchAudio(sliceNo) %#ok<NOPTS>
        sliceStartIndex = floor(sliceMiddleIndex - waveformLength/2);
        sliceEndIndex = floor(sliceMiddleIndex + waveformLength/2)-1;

        %We have found our waveform:
        waveformStartIndex = sliceStartIndex;
        waveformEndIndex = sliceEndIndex;

        maxValue = max(constantPitchAudio(waveformStartIndex:waveformEndIndex));
        minValue = min(constantPitchAudio(waveformStartIndex:waveformEndIndex));
        extremeValue = max(maxValue, -minValue);

        % Copy the waveform, normalized in the range [-1.0 .. 1.0]:
        waveforms(usedSliceIndex,:) = constantPitchAudio(waveformStartIndex:waveformEndIndex)';
        waveformsNormalized(usedSliceIndex,:) = constantPitchAudio(waveformStartIndex:waveformEndIndex)' ./ extremeValue;
        usedSliceIndex = usedSliceIndex + 1;
    end
end
waveforms = waveforms(1:usedSliceIndex,:);
waveformsNormalized = waveformsNormalized(1:usedSliceIndex,:);

save 'waveforms.mat' waveforms
save 'waveformsNormalized.mat' waveformsNormalized

% Here, usedSliceIndex = 9726
% And, sum(SIDVoiceVolume) = 9725
% This is correct


%The VIC-II was manufactured with 5 micrometer NMOS technology[1] and was clocked at 17,73447 MHz (PAL)
% Use a clock freqency of 985248Hz for PAL C64
% 17734470 / 18 = 985248.333 Hz
%PAL systems have 312 raster lines and 63 processor cycles on each raster line.
%Because a bad line will steal 40 cycles, there is only 23 cycles left on each scan line.

% PAL-B systems:
%            Chip      Crystal  Dot      Processor Cycles/ Lines/
%    Host    ID        freq/Hz  clock/Hz clock/Hz  line    frame
%    ------  --------  -------- -------- --------- ------- ------
%    C64     6569      17734472  7881988    985248      63    312
%The frame rate is 985248 /     63  /  312 =  50.1245 Hz
    
% We're going to play one 8-bit sample every other rasterline.
%P A L
%Phase Alternating Line SYSTEM	
%Line/Field	625/50	
%Horizontal Freq.	15.625 kHz	
%Vertical Freq.	50 Hz
%Color Sub Carrier	4.433618 MHz	
%Video Bandwidth	5.0 MHz	
%Sound Carrier	5.5 MHz
% This is a sample playback at 7812.5Hz

%985248/7812.5, we have 126 clock cycles available
% for every 8-bit sample output. Of these, lots of them
% get wasted by badlines drawing the characters on screen,
% and for sample playback timing synchronization, and sample playback.

% The lowest note we want to reproduce is 146Hz.
% With a sampling frequency of 7812.5Hz, this is a period of 53.5 samples.
% The highest note we want to reproduce is 294Hz.
% With a sampling frequency of 7812.5Hz, this is a period of 26 samples.

% Ideally, we would like to always "skip" samples, and never hold samples.
% This makes the resample-calculations easier on the Commodore64-side.
% Hence, waveforms should be at least 54 bytes long.
% Assume waveforms are 64 bytes long.
% Then, with 32kB available for waveforms, we have
% 32*1024/64 = 512 different waveforms available.

% Maybe we could make interpolation between waveforms. Then
% this will be enough.

% Inner loop of sample playback:
% ZeroCodeStart:
%         LDA     #$11
%         STA     $D404
%         LDA     #9
%         STA     $D404
% Poi:
%         LDA     $3000
%         STA     $D401
%         LDA     #1
%         STA     $D404
%         INC     Poi-ZeroCodeStart+ZeroCodeDest+1
% SaveAnmi:
%         LDA     #$A
%         JMP     $DD0C

% Need to "render" sound at $3000-$30ff to be able to do this properly.
% Need to double buffer the sound as well.
% Each buffer should be 10ms,
% This is 78.125 samples each iteration
% We need to cheat. Sample play cannot be syncronized with the screen
% raster line.
% We need to change the slice width to be something else than 10 ms,
% something that is easier to handle when it comes to mixing the
% formants.
% Using 128 bytes @ 7812.5 Hz gives us a resolution of 
%  16.384 ms
% Using 64 bytes gives us a resolution of
%   8.192 ms
% Assuming 64 byte long waveforms, this is a pretty logical choise.
% Then, the "lowest" pitch we can play will approximately change
% waveform every period, which is nice.
% The highest pitch will change waveform every second period, which
% I hope is enough. Hence, we don't need to make any linear
% fade between formant/wave tables. It can be static during the
% whole 64 byte mixing routine.

% Need to make a mixing routine that can handle:
%  64 byte long waveforms
%  "monophonic" pitch change
%  Linear interpolation between 2 waveforms with a couple of volume levels
%  Main volume level.

% Make one mixing routine for every crossfade ratio.
% One will do "only one wavetable at 100% volume - main volume=X%"
% One will do "wavetable0 at 75% volume - wavetable1 at 25%, main volume=X%"
% One will do "wavetable0 at 50% volume - wavetable1 at 50%, main volume=X%"
% One will do "wavetable0 at 25% volume - wavetable1 at 75%, main volume=X%"

% Wavetables will have the average value #$00, and
% range #-$40 - #$3f. Length = 64 bytes.

% We need to be able to start in the middle of a Pitch table,
% so it will need to be "one period" + 64 bytes long.
% A pitch table with speed = 1.0 will be 128 bytes long.
% A pitch table with speed = 2.0 will be 64/2.0 + 64 = 96 bytes long.
% A pitch table with speed = 4.0 will be 64/4.0 + 64 = 80 bytes long.
% The pitch table will contain the numbers 0,1,2, .. 63,0,1,2...
%  counting upwards with "the speed of the pitch".
% They can be easily calculated with 6502 assembly.
% Making all pitch tables 128 bytes long seems like a good choise.
% We have 9 different notes to play, that is 1152 bytes for tables.
% We could afford to have a couple of "out of tune" pitch tables as well
%  to handle vibrato/imperfection.

% Every 8.192ms we need to calculate:
% wavetable0 pointer (one out of 512) = 9 bits
% wavetable1 pointer                  = the previous wavetable0 pointer if
%                                       set (1 bit)
% volume ratio to choose: 100%, 75/25, 66/33, 50/50 = 2 bits
% Main output volume. 0..15           = 4 bits
% 9 + 1 + 2 + 4 = 15 bits
% Doing 16000 of these is 32kB with data.

% Memory budget:
% Noise table:                = 10kB
% Volume tables: 16*256 bytes = 4kB
% Pitch tables: 9 * 128       = 1152 bytes
% Wave tables: 512 * 64 bytes = 32kB
% Program memory 0000-17ff    = 6kB
% Screen                      = 1kB
% Note values                 = 1kB (note + length for the whole song)
% We have left: 64-10-4-1-32-6-1 = 9kB
% Noise table needs to be shorter, assume a 15kB for wavetable control and
%                                            4kB for noise control

% We could skip the volume tables, then use only 4 of them...
% Then we save 3kB memory for something else... like $d000-$dfff which
% is kind of difficult to use in this context anyway.

% We could also put a notch filter on the base frequency, and play that
% with a SID oscillator as well. Then, we ruin the possibility of playing
% bass sounds with SID, since all oscillators are taken.
% One for playing wavetables, one for playing noise, one for playing
% the base frequency of the vocals.

% Wavetable gathering algorithm:
%   Oversample the original audio x8 or something.
%   Pitch original audio into a period a multiple of 64 words.
%   Do this by changing the length of the complete song, but make
%   a table of where each 8.192ms-slice starts. (A floating point pointer!)
%   Do pitch changes soft - make a spline/linear interpolation
%   between pitches.
%   Make the resampling by "walking through the original audio"
%   with a variable speed. Use linear interpolation.

%   Try to extract 1 wavetable near the start of every splice (that has
%   a volume > 0). Try to find a peak, and extract 64 bytes around that one.
%   Low pass filter the wavetable, remove all content above 3.5kHz.
%   Resample down to 7812.5Hz.

%   Put all wavetables into a masssive table.
%   Try to eliminate every wavetable by comparing it to "older" wavetables
%   or even linear combinations (100,75/25,66/33 or 50/50) of older
%   wavetables. In the time domain.
%   Repeat and adjust parameters until approximately 500 wavetables are
%   left.

% Could also rely on "self modifying waveforms", by sometimes
% keeping a percentage of the last played waveform.
% Every modification to the current waveform playing would then
% be applied with 25%, 33%, 50%, 66%, 75% or 100%.
% 100% would replace the waveform completely.
% 25% would only change the waveform "a little".
% Then, only the "starting" waveforms will be stored as complete waveforms,
% and the rest will be "differential" changes applied to the starting
% waveforms.

% Adding non-pitched drums to this one is simple.
% Just add a ADC $abcd,y anywhere, and make sure that
% wavetables gets their overall volume lowered to avoid clipping.


%Trick: could use pha for storing samples
% PHA takes 3 clock cycles.
% To be compared with STA $aaaa,y = 5    + INY = 2
% PLA can not be used for playback, since this will pull samples
% in the wrong order. Playback will do something like LDA $0100
% where the low byte needs to be incremented.
% Raster interrupts are ok, since all calculations and PHAs will
% be done in the outermost loop. The calculations cannot be done
% with a subroutine that is JSRed to, though.
% Synchronizing will have to be done with TSX, checking when to 
% do more samples.

% The other way around is bad, since PLA cannot be used for playback
% if the CIA NMI irq happens to interrupt and already ongoing timer IRQ;
% Then, the PLA will fetch the wrong value.




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

% If we put the mixing routine into above, we have 27 clocks to use for it
% ...and we need to save X and Y as well.
% STX ZeroPage    3
% STY ZeroPage    3
% LDY #0          2
% LDX #0          2
% We have 17-21 clocks left before a badline play will touch the 
% end of another.
% This could be fixed by having the replay routine
% play two samples, and making one "badline version" of the IRQ
% and one "non-badline" version.



% 100% without pitch table: (can only pitch between 50%-100% speed)
%                    ;clks
% loop:
%   inx                ;2
%   adc #$4c           ;2
%   bcc noFaster       ;2+1ifBranch
%   inx                ;2
% noFaster: 
%   ldy waveForm,x     ;4+1ifCrossingPageBoundary
%   sty poi+1          ;3
% poi:
%   ldy volumeTable    ;4
% poi2:
%   sty $b800          ;5
%   inc poi2+1         ;5
%   bpl loop           ;2+1ifBranch
%                      = 33 clks per iteration



% 100% with PHA and compressed pitch tables
% ROM:005C loc_5C:                                      ;clks
%   LDA #1                                     ;2
%   ROR $AF %Compressed pitch value, bit=0:add#1, bit=1:add#2   ;5
%   ADC poi+1                                  ;3
%   STA poi+1                                  ;3
% poi:
%   LDY  #$20                                  ;2
%   LDX     $2E00,Y  % WaveTable0 value        ;4
%   LDA     $0A00,X  % Volume/distortion table ;4
%   PHA     %Output buffer                     ;3
% ...unroll *8                                =26 clks per iteration


% 100% with PHA, and 128 bytes output length
% ROM:005C loc_5C:                                      ;clks  bytes
% ROM:005C   LDY     $AE00,X  % The pitch table         ;4       3
% ROM:005F   LDX     $2E00,Y  % WaveTable0 value        ;4       3
% ROM:0075   LDA     $0A00,X  % Volume/distortion table ;4       3
%                                           % NOTE x2 in output level!
% ROM:0078   PHA     %Output buffer                     ;3       1
% ROM:007B   TSX                                        ;2       1
% ROM:007C   BMI / BPL     loc_5C                       ;2+1ifTaken
% ROM:007E   RTS                                       =20 clks per iteration
% TSX does the following:
%    $reg->{ x } = $reg->{ sp };
%    $self->set_nz( $reg->{ x } );
% So both N and Z flags are set according to StackPointer
%The sign and zero flags reflect the result of the load
% Actually, this code does not need to be in ZeroPage.
% Unrolling it 64 times takes 64*11 = 704 bytes, and
% can be places anywhere in memory.
% This results in 17 clks per iteration.

% The other volume ratios will be a little more expensive
% in clks and memory, but using ~6kB for unrolled calculations
% seems ok - or they could be unrolled *16, having a four time counter
% somewhere.
% But, writing the wavetable-value becomes expensive if it is unrolled
% too many times.

% Need 64 bytes loops, so it is easiest to only use
% $0100-013f + $0180-$01bf

% Mixing routine becomes easy, replay will be
% Poi:
%        LDA     $3000            4
%        STA     $D401            4
%        DEC     Poi+1            5
% Branch:
%        BMI  wrap
% Save_anmi:
%        LDA #0
%        RTI
% Wrap:
%        lda Poi+1
%        and #$bf
%        sta Poi+1
%        lda Branch        %BMI=$30    BPL = $10
%        eor #$20
%        sta Branch
%        lda $save_anmi+1
%        rti


% 100%
% Y must be #$40 at start:
% ROM:005C loc_5C:                                     ;clks
% ROM:005C   LDX     $AE00,Y  % The pitch table        ;4
% ROM:005F   LDA     $2E93,X  % WaveTable0 value       ;4
% ROM:0074   TAX                                       ;2
% ROM:0075   LDA     $A00,X   %Volume/distortion table ;4
%                                           % NOTE x2 in output level!
% ROM:0078   STA     $B800,Y  %Output buffer           ;5
% ROM:007B   INY                                       ;2
% ROM:007C   BPL     loc_5C                            ;2+1ifTaken
% ROM:007E   RTS                                       =24 clks per iteration

% 75% + 25%
% Y must be #$40 at start:
% ROM:005C loc_5C:                                 ; CODE XREF: ROM:007Cj
% ROM:005C                 LDX     $AE00,Y  % The pitch table
% ROM:005F                 LDA     $2E93,X  % WaveTable1 value
%                          ASR
%                          ASR
% ROM:0065                 ADC     $3772,X  % WaveTable0 value
% ROM:0074                 TAX
% ROM:0075                 LDA     $A00,X   %Volume/distortion table
%                                           % NOTE x2/1.25 in output level!
% ROM:0078                 STA     $B800,Y  %Output buffer
% ROM:007B                 INY
% ROM:007C                 BPL     loc_5C
% ROM:007E                 RTS

% 66% + 33%
% Y must be #$40 at start:
% ROM:005C loc_5C:                                 ; CODE XREF: ROM:007Cj
% ROM:005C                 LDX     $AE00,Y  % The pitch table
% ROM:005F                 LDA     $2E93,X  % WaveTable1 value
%                          ASR
% ROM:0065                 ADC     $3772,X  % WaveTable0 value
% ROM:0074                 TAX
% ROM:0075                 LDA     $A00,X   %Volume/distortion table
%                                           % NOTE x2/1.5 in output level!
% ROM:0078                 STA     $B800,Y  %Output buffer
% ROM:007B                 INY
% ROM:007C                 BPL     loc_5C
% ROM:007E                 RTS


% 50% + 50%
% Y must be #$40 at start:
% ROM:005C loc_5C:                                 ; CODE XREF: ROM:007Cj
% ROM:005C                 LDX     $AE00,Y  % The pitch table
% ROM:005F                 LDA     $2E93,X  % WaveTable0 value
% ROM:0065                 ADC     $3772,X  % WaveTable1 value
% ROM:0074                 TAX
% ROM:0075                 LDA     $A00,X   %Volume/distortion table
%                                           % NOTE x1 in output level!
%                                           % could maybe use "no" volume
%                                           table for this one
% ROM:0078                 STA     $B800,Y  %Output buffer
% ROM:007B                 INY
% ROM:007C                 BPL     loc_5C
% ROM:007E                 RTS




% 100% without pitch table: (can only pitch between 50%-100% speed)
%                    ;clks
% loop:
%   inx                ;2
%   adc #$4c           ;2
%   bcc noFaster       ;2+1ifBranch
%   inx                ;2
% noFaster: 
%   ldy waveForm,x     ;4+1ifCrossingPageBoundary
%   sty poi+1          ;3
% poi:
%   ldy volumeTable    ;4
% poi2:
%   sty $b800          ;5
%   inc poi2+1         ;5
%   bpl loop           ;2+1ifBranch
%                      = 33 clks per iteration




