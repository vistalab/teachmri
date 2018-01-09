%
%  Keat J, Reinagel P, Reid RC, Meister M.
%  Predicting every spike: a model for the responses of visual neurons.
%  Neuron. 2001 Jun;30(3):803-17.
%
% Author: Wandell
% Purpose:  
%    With Cris, Tara, Alyssa we went through this paper and created the
%    model on the fly.  This and the other one (PredictingEverySpike) seem
%    to have our class notes.
%
%  Edited some in March 2004.  Check PredictingEverySpike2.  It seems like a
%  less advanced form of this one.

%% First, we make a Gaussian filter that will smooth out the
% original, white noise, time variable.  In this case, we are actually
% sampling time every 7.8 ms.
t = (0:100)*7.8;

% Then, we build a random stimulus for testing
randomStimulus = randn(size(t))';

% plot(randomStimulus)

clf
plot(t,randomStimulus,'r-')



%% This is the filtering function they use
% tauf is a variable that varies with cell type
% the final filter is the weighted sum of a bunch of functions
% like this one.
%

j = 1;      % index into the list of basis functions
tauf = 190;  % msec
F = zeros(size(t,2),16);
for j=1:16
    F(:,j) = sin(pi*j*((2*t/tauf) - (t/tauf).^2))';
end

% All of the values beyond tauf are supposed to be zero
F(ceil(tauf/7.8):end,:) = 0;

% Each column represents another basis function
clf; imagesc(F); colormap(gray)

%% Now any specific filter is the weighted sum.  We chose
% these weights 'cause they produced something that vaguely
% resembled what is in Figure XX.
wgts = zeros(16,1);
wgts(1) = -0.6; wgts(2) = .5; wgts(3) = 1;
testF = F*wgts;
testF = testF/abs(sum(testF));
testF = circshift(testF,floor(length(testF)/2));
clf; plot(t,testF)

% This is how we know where to place our filter so that it doesn't
% shift the time base of the output. 
% The filter needs to be centered on the vector.
%
% impulse = zeros(size(testF));
% impulse(1) = 1;
% impulse = circshift(impulse,floor(length(impulse)/2));
% stimulus{2} = convolvecirc(stimulus{1},impulse);
% plot(t,stimulus{2},'b-',t,stimulus{1},'r-')


stimulus{1} = randomStimulus;

% The output of the filtered noise is convolved with the
% designed filter, testF. This produces the stimulus we are going
% to use for deriving spikes and so forth
membranePotential = conv2(stimulus{1},testF,'same');

clf
plot(membranePotential);

%%
clf
plot(t,stimulus{1},'r-',t,membranePotential,'b-')
legend('Input','Filtered Response')
xlabel('Time (ms)'); ylabel('Response (some volt thing)');
hold on; plot(t,testF + 3); set(gca,'ylim',[-2 4])
grid on

% p defines the decay in membrane potential that determines
% the refractory period
spike = zeros(length(t),1);

% Main parameters
pTau = 132;      % ms
pScale = 0.3;   % volt
threshold = 0.53 % rabbit
p = pScale*exp(-t/pTau)';
%clf; plot(t,p,'m-')


% This is the main loop for determining when we have spikes
% You might try adjusting some of the parameters in the refractory
% period to see how the number of spikes changes
refStimulus = membranePotential;
for ii=1:length(membranePotential)
    if refStimulus(ii) > threshold
        spike(ii) = 1;
        refStimulus = refStimulus - circshift(p,ii);
    end
end

figure; plot(t,spike,'b.-')
hold on; plot(t,refStimulus+2,'g-')
hold on; plot(t,membranePotential+2,'c-')
plot(t,p-1,'m-')
legend('Spikes','Reference Stimulus','Membrand Potential','Refractory F')

%% Now, we must write the rest
% Perhaps we can coordinate this with the RGC code?

