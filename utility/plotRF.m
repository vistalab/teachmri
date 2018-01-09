function signal = plotRF(f,p,t,T1,Mo,label)
%
%
%
%
%

if ~exist('Mo','var'), Mo = 1; end
if ~exist('label','var'), label = 'Gradient-X'; end

signal = zeros(2,2,length(t));
signal(1,1,:)  = rfSignal(T1(1,1),Mo,t,f(1),p(1))';
signal(2,1,:)  = rfSignal(T1(2,1),Mo,t,f(2),p(2))';
signal(1,2,:)  = rfSignal(T1(1,2),Mo,t,f(3),p(3))';
signal(2,2,:)  = rfSignal(T1(2,2),Mo,t,f(4),p(4))';

subplot(2,2,1), plot(t,squeeze(signal(1,1,:)))
subplot(2,2,3), plot(t,squeeze(signal(2,1,:)))
subplot(2,2,2), plot(t,squeeze(signal(1,2,:)))
subplot(2,2,4), plot(t,squeeze(signal(2,2,:)))
subplot(2,2,1), t0 = text(6,1.2,'Gradient-X'); t1 = text(3,.5,'F1');
subplot(2,2,2), t2 = text(3,.5,'F2');
subplot(2,2,3), t3 = text(3,.5,'F1');
subplot(2,2,4), t4 = text(3,.5,'F2');

end