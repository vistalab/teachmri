function signal = rfSignal(tau,netMag,tSamples,larmorFreq, ph)
%
%   signal = rfSignal(timeConstant,netMag,tSamples,larmorFreq,ph)
%
%Author: Wandell
%Purpose:
%   Estimate an rf signal based on the various parameters
%   
% Example:
%   timeConstant = 1.5;
%   netMag = 1.0;
%   tSamples = [0:0.005:1]*4*timeConstant;
%   larmorFreq = 12;
%   sig = rfSignal(timeConstant,netMag,tSamples,larmorFreq);
%   plot(tSamples,sig)


if ~exist('tau','var'),        tau = 1; end
if ~exist('netMag','var'),     netMag = 1; end
if ~exist('tSamples','var'),   tSamples = [0:0.005:1]*(4*tau); end
if ~exist('larmorFreq','var'), larmorFreq = 12; end
if ~exist('ph','var')          ph = 0; end

signal = expDecay(tau,netMag,tSamples).*cos(tSamples*larmorFreq + ph);

return;

%--------------------------------------------------------
function MzG = expDecay(tau,Mo,t)
%
%   MzG = expDecay(tau,Mo,t);
%
%Author: Wandell
%Purpose:
%    Create an exponential decay that will be used for either longitudinal
%    or transverse decay modeling.
%
% Example:
%    Mo = 1;                % Net magnetization
%    t = [0:.005:1]*4*T1;   % Measure time in several T1 periods
%    T1 = 1.5;
%    MzG = expDecay(T1,Mo,t);


MzG = Mo *exp(-t ./ tau);

return;