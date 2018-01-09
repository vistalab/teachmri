figure(1)
clf;
t=0:1:17
time1=4
time2=6

stim1=zeros(1,18); % 1st event at time 1
stim1(time1)=1
stim2=zeros(1,18); % 2nd event at time 2
stim2(time2)=1

% Heeger & Boytom 1996 parameter estimations
delta=2
tau=1.05
n=3;
hrf=gamma1D(t,delta,tau,n); hrf(1)=0;
ll=length(g);
figure(1); plot(hrf,'-'); title('Hemodyanmic impulse response function'); set(gcf, 'color', [ 1 1 1])

figure(2)
subplot(2,2,1); plot((1:18),zeros(1,18)); hold; 
plot([ time1 time1 time1], [0 .5 1]); hold
title('Stimulus')
bold1=conv(stim1,hrf)
subplot(2,2,2); plot(t(1:18),bold1(1:18))
title('Predicted fMR Signal')

title('Stimulus shifted in time')
subplot(2,2,3);  plot((1:18),zeros(1,18)); hold;
plot([ time2 time2 time2], [0 .5 1]); hold
bold2=conv(stim2,hrf)
subplot(2,2,4); plot(t(1:18),bold2(1:18));   set(gcf, 'color', [ 1 1 1])
