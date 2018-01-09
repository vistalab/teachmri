st=zeros(1, 181);
st(1)=1;
%epoch 1: 1 cat
st(1)=1;

% epoch2: 2 cats
st(8: 9 )=[ 1 1] ;

%epoch 3: 4 cats
st(16:18 )=[1 1 1];

% epoch 4: 8 text
%st(26:30 )=[1 1 1 1 1];

%epoch 5: 2 cats
st(38:39)=[1 1];  
          
%epoch 6: 1 texture
%st(46)=[1];

%epoch 7: 1 cats
st(54)=[1];

%epoch 8: 8 cats
st(62:66)=[1 1 1 1 1];

%epoch 9: 1 cats
st(74)=[1];        
   
%epoch 10: 4 cats
st(82:84)=[1 1 1];

%epoch 11:2 cats
st(92:93)=[1 1];

%epoch 12: 8 texture 
% st(100:104)=[1 1 1 1 1];   

%epoch 13:2 cats
st(112:113)=[1 1];

% epoch 14:1 texture
%st(120)=[1 ];       
 
% epoch 15:8 cats   
st(128:132)=[1 1 1 1 1 ];

% epoch 16:1 cats   
st(140)=[1 ];

% epoch 17:4 cats   
st(148:150)=[1 1 1];            
% epoch 18: 1 cats   
st(158)=[1   ];
% epoch 19:2 cats   
st(166:167)=[1 1  ];       


st=[ zeros(1,9) st];

figure(1)
clf
tr=1.5
t=0:tr:12;
gain=1.6507
to=4.8;
sigma=1.8;
g=gain*gauss1D(t,to,sigma);
plot(st,'LineWidth',2)
hold
h=conv(st,g);
h=h([1:length(tc)]);
plot(h(1:length(st)),'r')
axis([ 0 190 0 6])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


set(gca,'Xtick',[0:10:190])
b=xcorr(st,h);
b1=xcorr(st,tc);
del1=find(b1==max(b1))
m=0.5*(length(b)+1)
del=find(b==max(b))
%del=del-m
delay=del1-del
t1=-delay:1:length(tc)-delay-1;
plot(t1,tc,'c')
hold
title_text=sprintf('Delay between estim. hemo and tc=%4.2f s',delay*tr);
title (title_text,'FontSize',16);
legend('stim.','hemo.','shift-tc.')
print -depsc /home/kalanit/phd/Matlab/Epi/Hemo_Model/GB2_estim_hemo_tc.eps

figure(2)
clf

plot(st,'LineWidth',2)
hold

axis([ 0 190 0 6])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


set(gca,'Xtick',[0:10:190])

b1=xcorr(st,tc);
del1=find(b1==max(b1))
m=0.5*(length(b)+1)
delay1=del1-m

t2=-delay1:1:length(tc)-delay1-1;
plot(t2,tc,'c')
hold

legend('stim.','shift-tc')
title_text=sprintf('Delay between stimulus and tc=%4.2f s',delay1*tr);
title (title_text,'FontSize',16);

print -depsc /home/kalanit/phd/Matlab/Epi/Hemo_Model/GB2_delay.eps


