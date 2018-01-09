figure(1)
clf;
stim=zeros(1,18);
stim(1)=(1)
t=0:1:17

to=4.8
sigma=1.8
gain=1.6507;
g=gain*gauss1D(t,to,sigma);
ll=length(g);
subplot(4,2,1); plot(st(1:18),'*');axis([ 0 18 0 1])
title('Stimulus','FontSize',16)
c=conv(st,g)
subplot(4,2,2); plot(t(1:12),c(1:12),'LineWidth',3)
grid
axis([ 0 12 0 2]); set(gca,'Ytick',[0:1:2]); set(gca,'XtickLabels',[t])
hold
subplot(4,2,2); plot(t(1:12),g(1:12),'r--','LineWidth',2)
hold
st(2)=(1)
title('Predicted fMR Signal','FontSize',16)
legend('Convolution','Summation')

subplot(4,2,3); plot(st(1:18),'*');axis([ 0 18 0 1])
c=conv(st,g)
subplot(4,2,4); plot(t(1:12),c(1:12),'LineWidth',3);hold
axis([ 0 12 0 4]);grid;set(gca,'Ytick',[0:1:4]); set(gca,'XtickLabels',[t])


ng=2
szdat=8
tr=1.5
delay=to;
[estim,t1]=sum_gauss_model(ng,szdat,tr,delay,sigma,gain)
plot(t1,estim,'r--','LineWidth',2); hold


st(3:4)=[ 1 1]
subplot(4,2,5); plot(st,'*') ;    axis([ 0 18 0 1])
c=conv(st,g)
subplot(4,2,6); plot(t(1:15),c(1:15),'LineWidth',3); hold;
axis([ 0 15 0 6]); grid;set(gca,'Ytick',[0:1:6]);set(gca,'XtickLabels',[t])
ng=4
szdat=10
tr=1.5
[estim,t1]=sum_gauss_model(ng,szdat,tr,delay,sigma,gain);
plot(t1,estim,'r--','LineWidth',2)


st(5:8)=[1 1 1 1]                          
subplot(4,2,7); plot(st,'*'); axis([ 0 18 0 1])     

c=conv(st,g)

subplot(4,2,8); plot(t(1:18),c(1:18),'LineWidth',3);hold
axis([ 0 18 0 8]); set(gca,'Ytick',[0:1:7]);set(gca,'XtickLabels',[t])
grid
ng=8
szdat=12
[estim,t1]=sum_gauss_model(ng,szdat,tr,delay,sigma,gain);
plot(t1,estim,'r--','LineWidth',2)








