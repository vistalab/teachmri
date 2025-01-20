%% RF signal
%
% Small RF curve for a slide
%
% Not important.  But useful
%

N = 1024;
t = linspace(0,2*pi,N) - pi;
sig = cos(5*t);

g = fspecial('gaussian',[1,N],N/6);
sig = sig.*g;
plot(sig,'k-','LineWidth',4);
axis off
set(gca,'ylim',[-3,3]*10^-3)

