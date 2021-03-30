%
% This is the 5th encoder script for
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

% Takes the complete "Tom's Diner" and extracts the noise in it. Needs no "global" knowledge of the audio file, can therefore be applied to small parts of the audio file.

debugging = 1;

% We want to detect noise at the indices found in this file:

load 'audioIndices.mat'  % contains audioIndices

% So the audio can be sliced up in roughly 4-8ms slices.
% Each slice should have the following estimated characteristics:
%   Noise amplitude: 0 - 15
%   Cutoff frequency: 0 - 22050
%   Noise frequency:

% Input audio is 44100Hz, 16-bit.
% Each slice is approximately 150-300 samples.

[originalAudio,Fs,bits]=wavread('Suzanne_Vega_-_Toms_Diner_mono');

% Need to do calculations incrementally, since memory requirements
% may get out of hand if doing all at once.
% Must avoid doing global calculations like max(all) or mean(all)


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
fcuts = [3500 4000];
mags = [1 0];
devs = [0.05 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
hhlow = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
figure(3)
freqz(hhlow)



length = length(originalAudio);
t=1:length;
nofSlices = size(audioIndices);
nofSlices = nofSlices(2)

sidCutoffFreq = zeros(1,nofSlices);  %0..22050
rms = zeros(1,nofSlices);
rmsHigh = zeros(1,nofSlices);
rmsLow = zeros(1,nofSlices);
noiseLevels = zeros(1,nofSlices);

overlap = 50; %nofSamples to include "outside" the slice

for sliceNo=2:nofSlices-2,
    audioStartIndex = floor(audioIndices(sliceNo)) - overlap;
    audioEndIndex = floor(audioIndices(sliceNo+1)) + overlap - 1;
    sliceLength = audioEndIndex-audioStartIndex

    W = hanning(sliceLength+1);
    % Time to estimate the noise in here:
    sliceData = detrend(originalAudio(audioStartIndex:audioEndIndex)) .* W;

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

    if sliceNo == 540
        figure(33)
        clf
        subplot(3,1,1);
        plot(sliceData);
        subplot(3,1,2);
        plot(xhigh);
        subplot(3,1,3);
        plot(xlow);
        
        %die
    end
    
    
    
    yFFT = fft(sliceData);
% Now median filter the frequency graph for each slice,
% Since we want to estimate the noise level.
% This will make Base frequency F0 and the formants F1 F2 F3 to
% be filtered away, leaving only the noise.
    min_fwd = 0.0;
    min_back = 0.0;
    y_input = yFFT;
    y_fwd = yFFT;
    y_back = y_fwd;
    len = size(y_fwd(:,1));
    len = len(1);
    t2= 1:len;
    spd = 0.04;
    for i=1:len,
        %Estimate min of signal:
        min_fwd = min(min_fwd+spd, abs(y_input(i)));
        y_fwd(i) = min_fwd;
        %Estimate min of signal, backwards:
        min_back = min(min_back+spd, abs(y_input(len+1-i)));
        y_back(len+1-i) = min_back;
    end
    yFFTnoFormants=min(y_fwd,y_back);
%    noiseLevels(sliceNo)=sum(yFFTnoFormants(1:floor(len/2))) / len; %Sum all spectra
    noiseLevels(sliceNo)=sum(yFFTnoFormants(ceil(4000/22050*len/2):floor(len/2))) / len; %Sum spectra above 4kHz
    
end


maxRmsHigh = max(rmsHigh);
maxRmsLow = max(rmsLow);
maxRms = max(rms);
% From the plot above, we shall be silent when rmsHigh > rmsLow.
threshold = maxRmsHigh * 0.05;

figure(8);
clf;
plot(rms,'y');
hold on;
plot(rmsHigh,'b');
plot(rmsLow,'r');
plot(noiseLevels,'m');
plot([1 nofSlices],[threshold threshold],'g');
legend('RMS','RMS for high frequencies > 4kHz','RMS for low frequencies < 4kHz','noiseLevel','threshold');


maxNoiseLevel = max(noiseLevels);
thresholdNL = maxNoiseLevel * 0.25;

figure(7);
clf;
plot(noiseLevels,'m');
hold on;
plot([1 nofSlices],[thresholdNL thresholdNL],'g');
legend('noiseLevel','threshold');

sidNoiseVolume = zeros(1,nofSlices); %0,1,2,3..15
for sliceNo=1:nofSlices-2,

    
%    % One stupid way of doing it:
%    if ((rmsHigh(sliceNo) > rmsLow(sliceNo)) && (rmsHigh(sliceNo) > threshold))
%        sidNoiseVolume(sliceNo) = 15;
%    end
    
    
%     a = rmsHigh(sliceNo) - threshold;
%     d = a / ((maxRmsHigh) * 0.50); %All above 50% of max level will be max.
%     e = ceil(d * 15);
%     if (e > 15)
%         e = 15;
%     end
%     if (e < 0)
%         e = 0;
%     end
%     sidNoiseVolume(sliceNo) = e;
    

    % One stupid way of doing it:
%    if ((rmsHigh(sliceNo) > rmsLow(sliceNo)) && (rmsHigh(sliceNo) > threshold))
    if ((noiseLevels(sliceNo) > thresholdNL))
        a = noiseLevels(sliceNo) - thresholdNL;
        d = a / ((maxNoiseLevel) * 0.90); %All above 90% of max level will be max.
%        e = floor(d * 15);
        e = d * 15;
        if (e > 15)
            e = 15;
        end
        if (e < 0)
            e = 0;
        end
        sidNoiseVolume(sliceNo) = e;
    end

    
end

sidNoiseVolume(1:150) = 0; %Just skip the noise for the first "I am" in Tom's Diner

figure(9);
clf
plot(sidNoiseVolume);



% Save all calculated values to file:  
save 'SIDnoiseParameters.mat' sid*
