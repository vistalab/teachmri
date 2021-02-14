%% 04 BOLD: Summation or not

%% In phase
set(0, 'DefaultLineLineWidth', 2);
set(0, 'DefaultLineColor', '#000');

t = 2*pi*4*(1:512)/512;
mn = 2;
sA = sin(t) + mn;
sB = sin(t) + mn;
both = sin(t) + sin(t) + mn;

mrvNewGraphWin;

subplot(3,1,1);
plot(t,sA,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]); grid on

subplot(3,1,2);
plot(t,sB,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]); grid on

subplot(3,1,3);
plot(t,both,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]);grid on

%% Out of phase

sB = sin(t + pi) + mn;
both = sin(t) + sin(t + pi) + mn;

mrvNewGraphWin;

subplot(3,1,1);
plot(t,sA,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]); grid on

subplot(3,1,2);
plot(t,sB,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]); grid on

subplot(3,1,3);
plot(t,both,'k-');
xlabel('Time (sec)'); ylabel('Synaptic activity');
set(gca,'ylim',[0 4]);grid on