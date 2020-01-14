% T1 T2 signals, signal equations and images
%
%
% Note:
%  The images formed by MR show the signal.  If we have a T1-weighted
%  image, the signal level is inverse to the T1 value.  If we have a
%  T2-weighted signal the image intensity is monotonic with the image
%  intensity.
%
% Here are some of the signal equations from the CNI wiki page
%
% Wandell
%
% See also
%

% Spin Echo signal equation, from https://cni.stanford.edu/wiki/MR_Signal_Equations
%  S = k * PD * (1 - exp(-TR / T1)) * exp(-TE / T2)

k  = 1;
PD = 1;
T1 = 1.330; % gray matter at 3T (https://www.ncbi.nlm.nih.gov/pubmed/10232510)
T2 = 0.080; % gray matter at 3T (https://www.ncbi.nlm.nih.gov/pubmed/10232510)

x = 0.001 : 0.001 : 4;

%% T1 weighted image (Short TR, short TE)
TR = 0.200; 
TE = 0.020;

% Vary t1 to get transfer function
t1wSignal  = k * PD * (1 - exp(-TR ./ x)) * exp(-TE / T2);

% Vary TR to get recovery function
t1Recovery = k * PD * (1 - exp(-x ./ T1)) * exp(-TE / T2);

%% T2 weighted image (Long TR, long TE)
TR = 2.000; 
TE = 0.080;

% vary t2 to get transfer function
t2wSignal = k * PD * (1 - exp(-TR / T1)) * exp(-TE ./ x);

% vary TE to get decay function
t2decay   = k * PD * (1 - exp(-TR ./ T1)) * exp(-x / T2);

%% Plot
figure(1),clf

subplot(2,1,1)
plot(x,t1wSignal, x,t2wSignal, 'LineWidth', 3);
title('MR transfer function, T1 or T2 -> Pixel Intensity');
xlabel('T1 or T2 (s)'); ylabel('Pixel intensity')
legend('T1w signal', 'T2w signal', 'Location', 'best')
set(gca, 'FontSize', 16); 



subplot(2,1,2)
plot(x,t1Recovery,x,t2decay, 'LineWidth', 3);
xlabel('time (s)'); ylabel('signal')
legend(sprintf('T1 recovery (t1=%4.3fs)', T1), ...
    sprintf('T2 decay (t2=%4.3fs)', T2), 'Location', 'best')
set(gca, 'FontSize', 16); 
title('MR signal time course for T1w and T2w scans');


%%