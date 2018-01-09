%% Make nicer pictures of FID
%

% Parameters for the Larmor frequency
f = 3;                  % Unit frequency
t = linspace(0,5,300);  % 400 samples in 3 seconds, 100 samples per freq
s = sin(2*pi*f*t);
e = exp(-1*t);

%% Exponential
for a = [0.5,1,0.001]
    fid =  a * s .* e;
    mrvNewGraphWin;
    p = plot(t,fid,'k-');
    set(p,'linewidth',4);
    grid on; set(gca,'ylim',[-1 1],'FontSize',24);
    xlabel('Time'); ylabel('Voltage')
end

