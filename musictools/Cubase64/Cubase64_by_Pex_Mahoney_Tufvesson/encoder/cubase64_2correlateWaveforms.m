%
% This is the second encoder script for
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

loadWaveformsNormalizedFD = 0;
loadScoreMatrix = 0;

% With all these waveforms lying around, we need to find those that
% actually matters.
% Let's score every one of them, by comparing it to all the others.
% Before, we deleted the "silent" ones. These have SIDVoiceVolume=0.
% But now, let's keep all waveforms.
% Then, put them all in a big high-score table.
% Choose the one with the highest points.
% And, "delete" all waveforms that are "almost" identical by some
% magical threshold that I'll need to make a few iterations before I can
% determine what it is.
% Repeat, until all waveform memory is taken.
% All waveforms that didn't make it... too bad
% I need a cross-coherence matrix with all waveforms compared to all other.
% From this, make a cross correlation vector which is the score for every
% waveform "how equal it is to all the others".
% When selecting a waveform, delete all the ones that are "equal" to it -
% by removing them from the score matrix.
% And then select the next waveform.

% Correlation will be better if we normalize all waveforms to +1.0 at the
% peak.
% We could choose to do this on 7812.5Hz-waveforms, 51 bytes long.
% Or we could do it with 300-word 44100Hz floating point waveforms.
% Ah, the computer feels fast today, let's use the 44100Hz waveforms!

% ToDo: cross correlate waveforms. The score matrix is too expensive.
% Just calculate the score vector directly. Or, we need to "clean out"
% the uninteresting waveforms before we come here.

% We need (15719,15719) = 250Mcorrelations
%zeros(9800,9800,'int8'); is ok
%zeros(9800,9800,'int16'); is ok
%zeros(9800,9800,'single'); is not ok - out of memory
% We could "clear out" a couple of non-used variables as well.
% We don't need the "waveforms" table until later.
% Maybe even "dump" used variables to disk, do a "clear", and
% then re-read those we want to use - to defragment virtual memory space.
% I'm running win32 here, so there's only 4GB contiguous virtual memory to use.
% After a "clear", zeros(9800,9800,'single'); is ok

% waveformsNormalized contains _all_ waveforms, not aligned in any way.

load 'waveforms.mat' waveforms
nofWaveforms = size(waveforms);
nofWaveforms = nofWaveforms(1);

% Now, let's try how to compare waveforms in the frequency domain.
% Let's select two "arbitrary" waveforms and compare these.


waveNoA = 7000;
waveNoB = 9000;

waveA = waveforms(waveNoA,:);
waveB = waveforms(waveNoB,:);


figure(1);
clf;
plot(waveA,'b');
hold on;
plot(waveB,'r');


% do fourier transform of windowed signal
fs=44100;
%waveA_d = (detrend(waveA)); %Detrending is aldready done when 
                             % grabbing the waveforms. Should probably
                             % not be done at all.
waveA_d = waveA;
%waveB_d = (detrend(waveB));
waveB_d = waveB;
waveBamp_d = waveB * 2;
YA=fft(waveA_d);
YB=fft(waveB_d);
YBamp=fft(waveBamp_d);
lenY = size(YA);
lenY=lenY(2);
% plot spectrum of bottom x Hz
hz5000=4300*lenY/fs;
f=(0:hz5000)*fs/lenY;
figure(2);
clf;
subplot(2,1,1);
lenf = size(f);
lenf = lenf(2);
plot(f,10*log10(abs(YA(1:lenf))+eps), 'b');
hold on;
plot(f,10*log10(abs(YA(1:lenf))+eps), 'b.');
plot(f,10*log10(abs(YB(1:lenf))+eps), 'r');
plot(f,10*log10(abs(YB(1:lenf))+eps), 'r.');
plot(f,10*log10(abs(YBamp(1:lenf))+eps), 'g');
plot(f,10*log10(abs(YBamp(1:lenf))+eps), 'g.');
legend('SpectrumA','','SpectrumB','');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
axis([0 4300 -50 30]);
subplot(2,1,2);
plot(f,angle(YA(1:lenf)).*180./pi, 'b');
hold on;
plot(f,angle(YA(1:lenf)).*180./pi, 'b.');
plot(f,angle(YB(1:lenf)).*180./pi, 'r');
plot(f,angle(YB(1:lenf)).*180./pi, 'r.');
%plot(f,angle(YBamp(1:lenf)).*180./pi, 'g');
%plot(f,angle(YBamp(1:lenf)).*180./pi, 'g.');



% Time to reconstruct the sound, but with the
% phases "erased"

% If we erase the phases by eliminating the
% complex part of the FFT, then we will have a definite
% zero in the time domain in the middle of the waveform.
% This is not bad,
% But, we will have a definitive maximum at the edges of the
% waveform, and that is bad, since our "useful dynamic range"
% will suffer.
% Let's try to find a better way of erasing the phase.

% This is the bad version:
%YA2 = abs(YA);
%YB2 = abs(YB);


% Let's try by adjusting the phase with some constant
% alignment:
phase = 32; % unit: degrees per frequency bin, 180 means inverse.
phaseVector = (([1:lenY] - 2) .* phase) ./ 180 .* 2 .* pi;
YA2 = abs(YA).*(cos(phaseVector) + 1.0i*sin(phaseVector));
YB2 = abs(YB).*(cos(phaseVector) + 1.0i*sin(phaseVector));
YA2(1) = 0;
YB2(1) = 0;


waveA_r = ifft(YA2,'symmetric');
waveB_r = ifft(YB2,'symmetric');


size(waveA_r)
% Move sideways to make sure that a pure sine will have a zero crossing
% at waveform start
translate = round(lenY * 14 / 51);
waveA_r = [waveA_r(translate:lenY) waveA_r(1:(translate-1))];
waveB_r = [waveB_r(translate:lenY) waveB_r(1:(translate-1))];


figure(3);
clf;
plot(waveA_r,'b');
hold on;
plot(waveB_r,'r');



figure(4);
clf;
subplot(2,1,1);
plot(f,10*log10(abs(YA2(1:lenf))+eps), 'b');
hold on;
plot(f,10*log10(abs(YA2(1:lenf))+eps), 'b.');
plot(f,10*log10(abs(YB2(1:lenf))+eps), 'r');
plot(f,10*log10(abs(YB2(1:lenf))+eps), 'r.');
legend('SpectrumA2','','SpectrumB2','');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
axis([0 4300 -50 30]);
subplot(2,1,2);
plot(f,angle(YA2(1:lenf)).*180./pi, 'b');
hold on;
plot(f,angle(YA2(1:lenf)).*180./pi, 'b.');
plot(f,angle(YB2(1:lenf)).*180./pi, 'r');
plot(f,angle(YB2(1:lenf)).*180./pi, 'r.');





% Now, let's find a correlation score for this.
% A high number indicates a good match.
% And, we should probably weight it with more
% emphasis on the lower frequencies.

highLimit=3200*lenY/fs;
f=(0:highLimit)*fs/lenY;
lenf = size(f);
lenf = lenf(2);

delta = 1e-120;

% This is the unweighted score, only comparing waveforms in the
% frequency domain between 0 Hz and highLimit Hz.
score = sum(((10*log10(abs(YA2(1:lenf))+delta)) - (20*log10(abs(YB2(1:lenf))+delta))).^2)

% Let's make a weighted score.
weight = [lenf:-1:1] / lenf * 2;  %*2 is to make the score comparable to the non-weighted one.


% And, let us have a variable amplification variable, selected to
% get as good score as possible.
% We should try to minimize this function with respect to ampDb:
% Could probably guess ampdB by comparing rms values.
%ampdB = -12
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%ampdB = -9
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%ampdB = -6
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%ampdB = -3
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%ampdB = 0
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%ampdB = 3
%weightedScore = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%
%partA = 10*log10(abs(YA2(1:lenf))+delta); 
%partB = 10*log10(abs(YB2(1:lenf))+delta);
%
%lowestScore = 1e100;
%lowestAmpdB = 100;
%for ampdB = -20:20,
%    s = sum((((ampdB + 10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2);
%    if (s<lowestScore),
%        lowestScore=s
%        lowestAmpdB = ampdB
%    end
%end



% f = fittype('a*sin(b*x)');
%f = fittype('a*x + b');
%f = fittype('abs(( i * x / b ) / ( 1 + x * f / b ))');
%f = fittype('a * (x / b) / sqrt(1 + ( x / b )^2)');
%f = fittype('sum((((x + partA) - partB) .* weight).^2)');


%starta = 0;
%lowera = -12;
%uppera = 12;
%
%options = fitoptions('Method','NonLinearLeastSquares');
%options.Weight = weight;
%options.Robust = 'off';
%options.Lower = [lowera];
%options.Upper = [uppera];
%options.StartPoint = [starta];
%options.Lower = [lowera lowerb];
%options.Upper = [uppera upperb];
%options.StartPoint = [starta startb];
%[fit1,gof,out] = fit(xdata,ydata,f,options);
%ampdB = fit1.a









% amp = 0 is equal to _no_ amplification.
% amp = 3 is equal to waveform B needs to be multiplied by 3dB, a factor 2 in
% the time domain.
% amp = 6 is equal to waveform B needs to be multiplied by 6dB, a factor 4 in
% the time domain.
% amp = 9 is equal to waveform B needs to be multiplied by 6dB, a factor 8 in
% the time domain.
% This is the multiplication factor:
%amp = 10 ^ (ampdB / 10)
%
weightedScore = sum((((10*log10(abs(YA2(1:lenf))+delta)) - (10*log10(abs(YB2(1:lenf))+delta))) .* weight).^2)
%weightedScore = sum((((10*log10(abs(YA2(1:lenf)))) - (10*log10(abs(YB2(1:lenf))))) .* weight).^2)

% And, let's visualize the weighted score, just for fun.
figure(5);
clf;
subplot(2,1,1);
plot(f,weight);
legend('weight depending on frequency');
ylabel('weight');
xlabel('f (Hz)');
hold on;
plot([f(1) f(lenf)],[0 0],'g--');

subplot(2,1,2);
weightedScoreV = (((((10*log10(abs(YA2(1:lenf)))) - (10*log10(abs(YB2(1:lenf))))).^2) .* weight));
plot(f,weightedScoreV,'b');
hold on;
plot(f,weightedScoreV,'b.');
legend('weighted score');
xlabel('f (Hz)');
plot([f(1) f(lenf)],[0 0],'g--');

%score = 2000 - sum((waveformsNormalized(waveformNo,:) - waveformsNormalized(compareNo,:)).^2);
%scoreMatrix(waveformNo,compareNo) = score;
%scoreMatrix(compareNo,waveformNo) = score; % Make it symmetric






if (loadWaveformsNormalizedFD == 1)
    load 'waveformsNormalizedFD.mat'
    load 'waveformsNormalizedFD_fft.mat'
else
    waveformsNormalizedFD = waveforms;
    waveformsNormalizedFD_fft = zeros(nofWaveforms,lenf);
    % We will need to filter all the waveforms, and normalize them
    for waveformNo=1:nofWaveforms-1,
        waveformNo
        YA=fft(waveforms(waveformNo,:));
        YA2 = abs(YA).*(cos(phaseVector) + 1.0i*sin(phaseVector));
        YA3 = ifft(YA2,'symmetric');
        maxValue = max(YA3);
        minValue = min(YA3);
        extremeValue = max(maxValue, -minValue);

        % Copy the waveform, normalized in the range [-1.0 .. 1.0]:
        waveformsNormalizedFD(waveformNo,:) = YA3 ./ extremeValue;
        
        YA4=fft(waveformsNormalizedFD(waveformNo,:));
        YA5=10*log10(abs(YA4(1:lenf))+delta);
        waveformsNormalizedFD_fft(waveformNo,:) = YA5;
    end
    save 'waveformsNormalizedFD.mat' waveformsNormalizedFD
    save 'waveformsNormalizedFD_fft.mat' waveformsNormalizedFD_fft
end


%To make this runnable on a low-memory computer (<2GB RAM)
%nofWaveforms=4000;


                                      
waveformStatus = zeros(1,nofWaveforms); 
                                      % 0: still left
                                      %-1: silent (not used anymore)
                                      % X: chosen as/similar to waveformX

if (loadScoreMatrix == 1)
    load 'scoreMatrix.mat'
else
    %Now, we will get "out of memory error" on this one if you have less than
    %4GB RAM in your computer:
%    scoreMatrix = zeros(nofWaveforms,nofWaveforms,'single');
    scoreMatrix = zeros(nofWaveforms,nofWaveforms,'uint16');
                                          % 0: not calculated yet
                                          % 65535=perfect score
                                          % The higher score, the less similar
                                          % the waveforms are
    for waveformNo=1:nofWaveforms-1,
%    for waveformNo=1067:1068,
        waveformNo
        if (waveformStatus(waveformNo) == 0)
            for compareNo=waveformNo:nofWaveforms-1,
%            for compareNo=1400:1420,
                if (waveformStatus(compareNo) == 0)
                    % What is a score?   sum(wave1 .* wave2) seems like a bad
                    % idea...
                    % Correlating frequency spectra (ignoring phase) would
                    % be a good idea. But, since the "source" of the sound
                    % comes from impulses of the vocal cords, the material
                    % is pretty well aligned when it comes to the phase of
                    % the higher overtones.
                    % Maybe   sum((wave1 - wave2)^2)
    %                score=sum(waveformsNormalized(waveformNo,:) .* waveformsNormalized(compareNo,:));
    % worst case sum = 300 * (1 -- 1)^2 = 300 * 2^2 = 1200
    
                    %YA2=fft(waveformsNormalizedFD(waveformNo,:));
                    %YB2=fft(waveformsNormalizedFD(compareNo,:));
                    %YA2 = abs(YA).*(cos(phaseVector) + 1.0i*sin(phaseVector));
                    %YB2 = abs(YB).*(cos(phaseVector) + 1.0i*sin(phaseVector));
%                    weightedScore = 65535 - 4*sum(((waveformsNormalizedFD_fft(waveformNo,:) - waveformsNormalizedFD_fft(compareNo,:)) .* weight).^2);
                    %waveformNo
                    %compareNo
%                    score = weightedScore;

%                    score = 2000 - sum((waveformsNormalized(waveformNo,:) - waveformsNormalized(compareNo,:)).^2);
                    score = 65535 - 30*sum((waveformsNormalizedFD(waveformNo,:) - waveformsNormalizedFD(compareNo,:)).^2);
                    scoreMatrix(waveformNo,compareNo) = score;
                    scoreMatrix(compareNo,waveformNo) = score; % Make it symmetric
                end
            end
        end
    end
    save 'scoreMatrix.mat' scoreMatrix
end


figure(1)
clf
plot(scoreMatrix(100,:));
hold on;



% Remove silly values from scoreMatrix.
% We need to steer away from BadThings(tm) +Infs -Infs in the scoreMatrix
%scoreMatrix = max(scoreMatrix, -1); % Let all negative values become -1.0
%scoreMatrix = min(scoreMatrix, 2001); % Let all (probably none) values clamp at 2001

% If we wanted to do the scoreMatrix a triangular matrix, then do this:
%scoreMatrix = tril(scoreMatrix); %Erase upper right values above the diagonal
% ...but we don't want to do that. ;)

chosenWaveforms = 0;
whichWaveformsAreChosen = zeros(1,nofWaveforms);
howManyWaveformsAreChosen = zeros(1,nofWaveforms);
residualScore = zeros(1,nofWaveforms);
waveformsLeft = nofWaveforms;
threshold = 65535;
thresholdHistory = zeros(1,nofWaveforms);
waveformsLeftHistory = zeros(1,nofWaveforms);


% Could probably choose more waveforms for the first ones, and then less
% and less for the coming ones...

% Make a function that takes waveformNo as input (0..254),
% and returns "howMany" to choose.
% The sum of the function should be nofWaveforms = ~10000
howManyToChoose = 400;
while ((chosenWaveforms <= 254) && (waveformsLeft >= 1) && (threshold > 1500) && (waveformsLeft > (255-chosenWaveforms)))
%This is one way of choosing how many waveforms to choose:
%    howManyToChoose = (1.0 - (chosenWaveforms) / 260) * 72
%    howManyToChoose = howManyToChoose * 0.97;
%    howManyToChoose = (1.0 - (chosenWaveforms) / 260) * 72

% But, actually this one sounds better:    
    howManyToChoose = 36;


% One version of the selection algorithm. Not the best one:    
%     % Sum the score matrix to form a score vector.
%     scoreVector = sum(scoreMatrix,1);
%     % Plot "residual score" (the sum of the score vector) after every
%     % iteration. This will give us a clue of "when to stop", depending on what
%     % our "delete-this-because-it-is-too-similar-to-one-we've-chosen"-threshold
%     % is.
%     % We need to steer away from BadThings(tm) +Infs -Infs in the scoreMatrix
%     residualScore(chosenWaveforms+1) = sum(max(min(scoreVector,2001),0));
%     
%     % scoreVector now contains "how well do I fit with the other waveforms"
%     % so, select the best-fitting one:
%     % Select the waveform with the highest score. Keep track of where
%     % it came from.
%     [maxScore, chosenWaveform] = max(scoreVector);
%     whichWaveformsAreChosen(chosenWaveforms+1) = chosenWaveform;
%     chosenWaveforms = chosenWaveforms + 1
%     
%     % Remove this, and waveforms "similar" to this.
%     % Threshold 1850 -> Finds only  30 waveforms
%     % Threshold 1875 -> Finds only  60 waveforms
%     % Threshold 1900 -> Finds only 110 waveforms
%     % Threshold 1920 -> Finds only 220 waveforms
%     % Threshold 1925 -> Finds only 260 waveforms
%     % Threshold 1940 -> Finds only 450 waveforms
%     % Threshold 1943 -> Finds only 500 waveforms
%     % Threshold 1950 -> End with a residualScore at 500 waveforms
%     threshold = 1940; % ToDo: choose a better one
%     howMany = 0;
%     
%     for waveformNo = 1:nofWaveforms,
%         if (scoreMatrix(chosenWaveform,waveformNo) >= threshold) % This hopefully includes the waveform itself ;)
%            scoreMatrix(waveformNo,:) = 0;
%            scoreMatrix(:,waveformNo) = 0;
%            waveformStatus(waveformNo) = chosenWaveform;
%            howMany = howMany + 1;
%         end
%     end
%    
%     howManyWaveformsAreChosen(chosenWaveforms) = howMany;
%     
%     % ToDo: Choose a better selection strategy. The above will select a
%     % number of waveforms that are "unique". This is not good, we should
%     % ideally choose waveforms that are used a multiple of times.
    

    
    
    
    % Start with zeroing out the diagonal in the scoreMatrix. It's either 0
    % for ???
    
    % Problem is that the scoring algorithm can see that "this is a good
    % one" - but the removing algorithm will only erase a few ones.
    
    % Set a threshold. And count the number of matches in the scoreMatrix
    % that is above this threshold. Choose the waveform with the most
    % matches. And erase those matches.
    % Then repeat, maybe changing the threshold underways. This will give
    % more "hits" per chosen waveform, I think.

    
     % Count the number of scores above threshold for a waveform:
%     scoreVector = zeros(1,nofWaveforms);
%     for waveformNo = 1:nofWaveforms,
%         scoreVector(waveformNo) = sum((scoreMatrix(waveformNo) > threshold),1);
%     end
% Easier:
    howMany = 0;
    while (howMany < howManyToChoose)
        scoreVector = sum((scoreMatrix >= threshold),1);
        [howMany, chosenWaveform] = max(scoreVector);
        if (howMany < howManyToChoose)
            threshold = threshold - 1;
        end
    end
    whichWaveformsAreChosen(chosenWaveforms+1) = chosenWaveform;
    chosenWaveforms = chosenWaveforms + 1
    threshold
    waveformsLeft
    howMany

    % Mark all waveforms similar to this for deletion. But don't delete
    % them yet, since this will destroy scores that we were about to find
    % later in the for-loop.
    for waveformNo = 1:nofWaveforms,
        if (scoreMatrix(chosenWaveform,waveformNo) >= threshold) % This hopefully includes the waveform itself ;)
           if (waveformStatus(waveformNo) == 0)
               waveformStatus(waveformNo) = -chosenWaveform;
               waveformsLeft = waveformsLeft - 1;
           end
        end
    end
    
    % Remove all waveforms that we've chosen above.
    for waveformNo = 1:nofWaveforms,
        if (waveformStatus(waveformNo) < 0)
           waveformStatus(waveformNo) = abs(waveformStatus(waveformNo));
           scoreMatrix(waveformNo,:) = -1e100;
           scoreMatrix(:,waveformNo) = -1e100;
        end
    end
    
    
%     
%     % ToDo: Choose a better selection strategy. The above will select a
%     % number of waveforms that are "unique". This is not good, we should
%     % ideally choose waveforms that are used a multiple of times.
    howManyWaveformsAreChosen(chosenWaveforms) = howMany;
    thresholdHistory(chosenWaveforms) = threshold;
    waveformsLeftHistory(chosenWaveforms) = waveformsLeft;
end

% Now, choose the ones that are left, if there's room for picking
% _all_ the waveforms one by one.
while ((chosenWaveforms < 255) && (waveformsLeft >= 1))
    scoreVector = sum((scoreMatrix >= threshold),1);
    [howMany, chosenWaveform] = max(scoreVector);
    whichWaveformsAreChosen(chosenWaveforms+1) = chosenWaveform;
    chosenWaveforms = chosenWaveforms + 1
    threshold
    waveformsLeft
    howMany

    % Mark all waveforms similar to this for deletion. But don't delete
    % them yet, since this will destroy scores that we were about to find
    % later in the for-loop.
    waveformNo = chosenWaveform;
    if (waveformStatus(waveformNo) == 0)
        waveformStatus(waveformNo) = -chosenWaveform;
        waveformsLeft = waveformsLeft - 1;
    end
    
    % Remove all waveforms that we've chosen above.
    for waveformNo = 1:nofWaveforms,
        if (waveformStatus(waveformNo) < 0)
           waveformStatus(waveformNo) = abs(waveformStatus(waveformNo));
           scoreMatrix(waveformNo,:) = 0;
           scoreMatrix(:,waveformNo) = 0;
        end
    end
    howManyWaveformsAreChosen(chosenWaveforms) = howMany;
    thresholdHistory(chosenWaveforms) = threshold;
    waveformsLeftHistory(chosenWaveforms) = waveformsLeft;
end

%TODO: Match those waveforms that are not chosen yet to their
%      "best match" among those waveforms that are chosen.
% We can either reload the scoreMatrix, or redo those
% ~254 scores that we need to choose the "most equal" waveform

waveformsLeft=sum(waveformStatus==0)
minScore = 65536;

if waveformsLeft >= 1,
    for waveformNo = 1:nofWaveforms,
        if waveformStatus(waveformNo) == 0,
            % This is a waveform that needs to be directed to one already
            % chosen. Time to find the one:
            maxScore = -1e10;
            maxWaveform = -1;
            for i=1:255,
                compareNo = whichWaveformsAreChosen(i);
                if ((waveformNo ~= compareNo) && (compareNo ~= 0)),
%                    weightedScore = 65535 - 4*sum(((waveformsNormalizedFD_fft(waveformNo,:) - waveformsNormalizedFD_fft(compareNo,:)) .* weight).^2);
                    weightedScore = 65535 - 10*sum((waveformsNormalizedFD(waveformNo,:) - waveformsNormalizedFD(compareNo,:)).^2);
                    %Check if this is the highest score yet.
                    if maxScore < weightedScore,
                        maxScore=weightedScore;
                        maxWaveform=compareNo;
                    end
                end
            end
            waveformStatus(waveformNo) = chosenWaveform;
            waveformNo
            maxScore
            if (maxScore < minScore),
                minScore = maxScore;
            end
        end
    end
end

sum(waveformStatus==0)

%When we come here, ALL waveforms have a corresponding "chosen waveform".
%Which is the best approximation we could afford.

chosenWaveforms = chosenWaveforms + 1
howManyWaveformsAreChosen(chosenWaveforms) = waveformsLeft;
thresholdHistory(chosenWaveforms) = minScore;
waveformsLeftHistory(chosenWaveforms) = sum(waveformStatus==0);


figure(2);
clf;
subplot(3,1,1);
plot(howManyWaveformsAreChosen(1:chosenWaveforms));
title('howManyWaveformsAreChosen');
subplot(3,1,2);
plot(thresholdHistory(1:chosenWaveforms));
title('thresholdHistory');
subplot(3,1,3);
plot(waveformsLeftHistory(1:chosenWaveforms));
title('waveformsLeftHistory');

figure(3);
plot(waveformStatus);


% When we have reached ~256 waveforms, stop.

save 'whichWaveformsAreChosen.mat' whichWaveformsAreChosen
save 'waveformStatus.mat' waveformStatus




% Now, we have everything to "simulate" playback.
% SIDVoiceVolume tells us when to sound, and when to be quiet.
% Every time SIDVoiceVolume == 1, increase waveformNo
% Use waveformStatus to check which waveform we shall play.
% Increase pointer into SIDVoiceVolume every 8.192ms.
% This will be a bad "sample&hold" of waveforms, no interpolation.
% But I will make a Matlab model of "how bad" this will sound,
% just to get an idea.





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

