% To accompany Worsley Figure 14.1
%
t = [0:.1:20];
[hirf,parms]= fristonHIRF(t);
plot(t,hirf)

% First stimulus and response
wgt1 = 1; wgt2 = 0.5;
stim1 = wgt1*[zeros(1,40),repmat([ones(1,20),zeros(1,200)],1,6),zeros(1,20)];
plot(stim1); set(gca,'ylim',[-.1 1.5]);
expectedResponse1 = conv2(stim1,hirf);
plot(expectedResponse1); grid on

% Second stimulus and response
stim2 = wgt2*[zeros(1,40),repmat([zeros(1,100),ones(1,20),zeros(1,100)],1,6),zeros(1,20)];
plot(stim2); set(gca,'ylim',[-.1 1.5]);
expectedResponse2 = conv2(stim2,hirf);
plot(expectedResponse2); grid on

% Additivity
plot(expectedResponse1 + expectedResponse2); grid on

% Notice the peaks are not wgt2/wgt1.


% Something you all should know about convolutions and harmonics
% Suppose we build a sinusoidal stimulus
freq = 1;
sig = sin(2*pi*freq*t);
plot(t,sig)

% Let's put the sinusoid through the convolution operation
[hirf,parms]= fristonHIRF(t);
tmp = conv2(sig(:),hirf,'same'); plot(tmp)

% Now, notice that whatever  hirf (function) we use for the kernel,
% the result is always a sinuoisoid
hirf = randn(size(hirf));
tmp = conv2(sig(:),hirf,'same'); plot(tmp)


% Some observations about signal and noise.  Two ways to view
% the periodic response (time and freq)
t = 0:.01:1;
freq = 4;
sig = 0.1*sin(2*pi*freq*t) + 1;
for ii= round(logspace(.3,3,6))
    noi = randn(ii,length(t));
    subplot(1,2,1), plot(t,sig+mean(noi),'b-',t,sig,'r--'); set(gca,'ylim',[0 1.5])
    xlabel('Time'); ylabel('FMRI signal')
    title(sprintf('Number of repeats: %.0d',ii))
    tmp = abs(fft(sig+mean(noi)));
    subplot(1,2,2), plot(tmp(2:20),'-o'); set(gca,'ylim',[0 10]); line([4,4],[0,20],'color','r')
    xlabel('Freq'); ylabel('Amp')
    pause
end

% Autoregressive modeling example.  Intuitions for the AR() models.
% Section 14.3.1
chi = randn(1,500);
rho = .2;
e = zeros(size(chi));
e(1) = chi(1);
for ii=2:500
    e(ii) = rho*e(ii-1) + chi(ii);
end
subplot(2,1,1); plot(e)

% Plot the central part of the autocorrelation function
[noiseAutoCorr,lags] = xcorr(e,'coeff');
l = find(abs(lags) < 20);
subplot(2,1,2); plot(lags(l),noiseAutoCorr(l)); grid on


% Autoregressive modeling example.  Intuitions for the AR(2) models.
% Section 14.3.1
rho = .8;

chi1 = randn(1,500);
chi2 = randn(1,500);
eta = zeros(size(chi1));
eta(1) = chi1(1);
for ii=2:500
    eta(ii) = rho*eta(ii-1) + chi1(ii);
    e(ii) = eta(ii) + chi2(ii);
end
subplot(2,1,1); plot(e)

% Plot the central part of the autocorrelation function
[noiseAutoCorr,lags] = xcorr(e,'coeff');
l = find(abs(lags) < 40);
subplot(2,1,2); plot(lags(l),noiseAutoCorr(l)); grid on


% Now, let's add some correlated noise to the signal.
% Consider high frequency examples with a high rho value
% Consider low frequency examples with a high or low rho value
nExamples = 8;
freq = 3; rho = 0.8
freq = 1; rho = 0.1

sig = 1*sin(2*pi*freq*t) + 1;

for ii=1:nExamples
    e = arNoise(rho,length(sig));
    clf; plot(t,sig,'b--',t,sig+e,'k-'); set(gca,'ylim',[-3 6])
    pause
end

% Talk about intensity models and effects

% Spatial smoothing discussion
% Look over gray matter and spatial smoothing issues on the cortical
% surface.
% Talk about flattening and how to average in space.


% Consider 14.12.2  Typically 'z' is chosen to be about 3 (number of
% connected voxels) for a Gaussian random field.   Once again the image
% must be a smooth stationary random field.  No notion of intrinsic shape
% of the brain.  Bring up flattening.
