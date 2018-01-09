color=1;
prefix ='objt_LOK'

n_subjects=8;
load_reps;



to=4.8;
sigma=1.8;
t=0:1.5:13.5;
%
g=gauss1D(t,to,sigma);
[rows,cols]=size(all_reps(3:6,:))
rowdata=reshape(all_reps(3:6,:),1,rows*cols);
gall=g'*ones(1,cols);
rowg=reshape(gall(3:5,:),1, rows*cols);
gain=regress(rowdata',rowg')

g=gain*gauss1D(t,to,sigma);

figure(1);
clf;
plot(all_reps(:,[ 1 2 6 7 11 12 16 17 21 22 26 27  31 32  36 37]))       
hold
plot(mean(all_reps(:,[ 1 2 6 7 11 12 16 17 21 22 26 27  31 32  36 37])'),'LineWIdth',5)
plot(t,g,'c--','LineWidth',4);
t1=0:1:14 ;
g1=gain*gauss1D(t1,to,sigma);
plot(t1,g1,'r--','LineWidth',4);
set(gca,'Xtick',0:1.5:13.5,'XtickLabels',t)
axis([ 0 10 -.5 4])
grid

xlabel('time in secs','FontSize',14)
ylabel('percent signal change','FontSize',14)
title_text=sprintf('Gaussian Params: to=%4.2f, sigma=%4.2f, gain=%4.2f',to,sigma,gain);
title(title_text,'FontSize',16)
print -depsc /home/kalanit/Matlab/Epi/Hemo_Model/hemo_gauss_model.eps
% 

