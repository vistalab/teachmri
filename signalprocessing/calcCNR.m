function CNR = calcCNR(tc,numCycles);
%  CNR = calcCNR(tc,[numCycles]):
%
% Given a time course tc, calculates the contrast-to-
% noise ratio, in decibels. Assumes tc is varying 
% between  a baseline and a signal coindition in 
% an ABAB like manner. numCyles is the total # of 
% cycles of AB in the time course.
%
%
% 04/04 ras. Developed for the psych204B tutorial on
% identifying signals in fMRI.
if ~exist('numCycles','var')        numCycles = 6;          end

numFrames = length(tc);
framesPerCycle = round(numFrames/numCycles);

tc = reshape(tc,[framesPerCycle numCycles]);

offFrames = 1:framesPerCycle/2;
onFrames = framesPerCycle/2+1:framesPerCycle;

X = tc(onFrames,:);
Y = tc(offFrames,:);

signal = mean(X(:)) - mean(Y(:));
noise = std(Y(:));

CNR = 20*log10(signal/noise);

return