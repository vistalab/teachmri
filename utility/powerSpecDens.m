function [s,f] = powerSpecDens(signal)
%Power spectral density.
%  s is normalized power
%  f is normalized frequency
%
%Replaces psd() functionality
%

f = (0:(length(signal)-1))/length(signal);
s = abs(fft(signal));  s  = s/max(s(:)); 

nyquist = round(length(f)/2);
f = f(1:nyquist);
s = s(1:nyquist);

return;