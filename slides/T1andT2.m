%% Graphs for T1 and T2
%
% Dependency: teachmri

% Time scale in milliseconds
t = 0:0.001:5;

% What matter T1 and T2
T1 = 0.832;
T2 = 0.110;

%%
mrvNewGraphWin;
p = plot(t,1 - exp(-t/T1),'b-',t,exp(-t/T2),'r-');
set(p,'LineWidth',2);
grid on
xlabel('Time (s)');
ylabel('Relative signal size');
l = legend({'T1 recovery','T2 decay'});
set(l,'FontSize',20)

%% Comparing across two voxels with different PD
% https://www.ncbi.nlm.nih.gov/pubmed/10232510

% Gray matter
%

% Source:  Quantitative Relaxometry Metrics for Brain Metastases Compared to Normal Tissues: A Pilot MR Fingerprinting Study
% Average T2 values measured for gray matter and white matter were 110 and 80 msec, respectively. 

% Average T1 values measured for gray matter and white matter were 1331 and 832 msec, 

PD0 = 0.5;
PD1 = 0.7;
PD2 = 1;

% Source:  Quantitative Relaxometry Metrics for Brain Metastases Compared to Normal Tissues: A Pilot MR Fingerprinting Study
grayT2  = 0.108;
whiteT2 = 0.078;

t = 0:0.001:0.5;

%% Comparing T2 for gray with different PD levels
mrvNewGraphWin;
p = plot(t,PD0*exp(-t/grayT2),'g-',t,PD1*exp(-t/grayT2),'b-',t,PD2*exp(-t/grayT2),'r-');
set(p,'LineWidth',2);
grid on
xlabel('Time (s)');
ylabel('Relative signal size');
l = legend({'Small PD','Medium PD','Large PD'});
set(l,'FontSize',20)

%% Comparing T2 for white and gray
mrvNewGraphWin;
p = plot(t,PD2*exp(-t/grayT2),'r-',t,PD2*exp(-t/whiteT2),'b-');
set(p,'LineWidth',2);
grid on
xlabel('Time (s)');
ylabel('Relative signal size');
l = legend({'Gray','White'});
set(l,'FontSize',20)

%%