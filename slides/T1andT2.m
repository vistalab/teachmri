%
%

% Time scale in milliseconds
t = 0:0.001:5;

% What matter T1 and T2
T1 = 0.832
T2 = 0.110;

figure;
plot(t,1 - exp(-t/T1),'b-',t,exp(-t/T2),'r-');
grid on
