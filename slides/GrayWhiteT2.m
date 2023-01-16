%% See T1andT2.m
%
% Graphs illustrating the reversal of intensity between gray and white
% depending on T1 vs T2
%
% 
% Source for T1/T2 values
% Quantitative Relaxometry Metrics for Brain Metastases Compared to
%    Normal Tissues: A Pilot MR Fingerprinting Study 
%
% See also tls_mri01MRSignalEquations.mlx

%% Tissue parameters (approximate, and varying across brain)

gT1 = 1.2;  gT2 = 0.110; gT2star = 0.11;  
wT1 = 0.8;  wT2 = 0.080; wT2star = 0.08; 
cT1 = 4.27; cT2star = 1.58;

% Here are some sequence properties, pretty standard
%
% We can adjust the timing of the RF and gradients to produce different
% echo times. 
TE = (0.00:0.02:0.40);  % 20 ms to 400 msec

%% The gray signal is higher

mrvNewGraphWin;
plot(TE,exp(-TE./gT2),'g-',TE,exp(-TE/wT2),'r-','LineWidth',2);
legend({'Gray','White'})
grid on;
xlabel('Time (s)'); ylabel('Relative intensity');

%%  The white signal is higher

TE = (0.00:0.02:5);  % 20 ms to 5 s

mrvNewGraphWin;
plot(TE,1 - exp(-TE./gT1),'g-',TE,1 - exp(-TE/wT1),'r-','LineWidth',2);
legend({'Gray','White'})
grid on;
xlabel('Time (s)'); ylabel('Relative intensity');

%%