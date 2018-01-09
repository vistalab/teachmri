function [spikes,refStimulus] = predictEverySpike(t,noisyMembrane,threshold, refractory,sigmaP)
% 
%

spikes = zeros(length(t),1);
refStimulus = noisyMembrane;
for ii=1:length(noisyMembrane)
    if refStimulus(ii) > threshold
        spikes(ii) = 1;
        g = (1 + sigmaP*randn(1));
        refStimulus = refStimulus - circshift(g*refractory,ii);
    end
end
return;