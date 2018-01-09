% Tutorial
% Linear Time Invariant systems
%   Temporal Impulse Response Functions
%   Corresponding Modulation Transfer Functions
%   Examples from Boynton and from Friston
%

% Set up time.  Sixty sec measured in 0.1 sec increments
%
t = [0:.1:60];

% Compute the Boynton HIRF 
%
[hirf,t,parms]= boyntonHIRF(t); hirf = ieScale(hirf,1) ;
% Boynton with slightly different parameters
% parms.tau = 1.4, parms.n =3; parms.delay = 2;
% [hirf,parms]= boyntonHIRF(t,parms);

% Normalize the hirf to a peak value of 1
plot(t,hirf,'k-'); set(gca,'xlim',[0 20]); grid on
xlabel('Time (s)')
ylabel('Normalized response')

% MTF of the Boynton HIRF
% We will 
% Make a list of the various temporal frequencies we can estimate.
% There are length(t) terms.  The frequency spacing is 1/max(t) where t is
% in seconds.
freq = [0:(length(t)-1)]/max(t);

% The Fourier Transform contains both the amplitude and phase of each of
% the terms.  Here are the amplitudes
ampHIRF = abs(fft(hirf));
ampHIRF = ieScale(ampHIRF,1);

% Let's look at only the first bunch because we know that the higher
% frequencies are not passed through.
clf ; fList = 1:20; plot(freq(fList),ampHIRF(fList),'bo-');
grid on
xlabel('Temporal frequency (Hz)');
ylabel('Amplitude');

% Let's make a movie showing how the predicted fMRI signal grows over time.
stim = zeros(1,length(t));
for ii=1:5:300
    stim(1:ii) = 1;
    res = conv2(hirf,stim);
    plot(res(1:600)); set(gca,'ylim',[-20 80],'xlim',[0,600]); l = line([ii ii],[-20 80]); pause(0.1);
    delete(l);
end

%
[hirf,parms]= fristonHIRF(t);
hirf = ieScale(hirf,1) ;
clf; plot(t,hirf,'k-'); set(gca,'xlim',[0 20]); grid on
xlabel('Time (s)')
ylabel('Normalized response')

% Let's make a movie showing how the predicted fMRI signal grows over time.
stim = zeros(1,length(t));
for ii=1:5:300
    stim(1:ii) = 1;
    res = conv2(hirf,stim);
    plot(res(1:600)); set(gca,'ylim',[-20 80],'xlim',[0,600]); l = line([ii ii],[-20 80]); pause(0.1);
    delete(l);
end

%
f = 1:20;
fftHIRF = abs(fft(hirf));
clf ; plot(fList(f),fftHIRF(f),'bo-');
grid on
xlabel('Temporal frequency (Hz)');
ylabel('Amplitude');


% We can calculate the expected responses for different signal repetition
% rates
clear signal response
tFreq = [0.025 0.05 0.1 0.2];
clf
for ii=1:length(tFreq)
    signal = square(2*pi*tFreq(ii)*t) + 1;
    fftSignal = fft(signal);
    fftHIRF = fft(hirf);
    fftResponse = fftHIRF.*fftSignal;
    response = real(ifft(fftResponse));
    plot(t,response,'r-'); set(gca,'ylim',[-30 100]); 
    str = sprintf('Signal frequency %.3f',tFreq(ii)); title(str);
    pause;
end

% Deconvolution example
ii = 1
signal = square(2*pi*tFreq(ii)*t) + 1;
fftSignal = fft(signal);
fftHIRF = fft(hirf);
fftResponse = fftHIRF.*fftSignal;
response = real(ifft(fftResponse));
plot(t,response,'r-'); set(gca,'ylim',[-30 100]); 
str = sprintf('Signal frequency %.3f',tFreq(ii)); title(str);
    
% Invert this response to try to understand the signal
fftResponse = fft(response);
fftSignalEst = fftResponse ./ fftHIRF;
signalEst = real(ifft(fftSignalEst));
plot(t,signalEst,'r-'); 
set(gca,'ylim',[-1 3]); 

% A little noise
noiseValue = 0.0001*std(response);
nResponse = response + noiseValue*randn(size(response));
plot(t,nResponse,'r-',t,response,'b-')

fftResponse = fft(nResponse);
fftSignalEst = fftResponse ./ fftHIRF;
signalEst = real(ifft(fftSignalEst));
plot(t,signalEst,'r-'); 
set(gca,'ylim',[-1 3]); 

% So, what should we do to account for this?  The general answer in the
% literature is to only find the solutions that we think are likely.  There
% are a variety of ways to enforce this idea, and we can discuss them when
% we move on to the topic of event related designs.
