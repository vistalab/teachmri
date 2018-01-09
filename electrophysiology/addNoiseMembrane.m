function noisyMembrane = ...
    addNoiseMembrane(membranePotential,sigmaA,fixThisAutoCorValue)
%
%
%

additiveNoise = sigmaA*randn(1,length(membranePotential));

g = fspecial('gaussian',length(membranePotential),fixThisAutoCorValue);

% Old code.  Check
% s = [1,length(membranePotential)];
% g = mkGaussKernel(s,[1, fixThisAutoCorValue]); 

blurredNoise= convolvecirc(additiveNoise,g);
noisyMembrane = membranePotential + blurredNoise';

return;