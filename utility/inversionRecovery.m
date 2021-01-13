function inversionRecovery(T1,Pulse)
%
% A graphical illustration of the Inversion Recovery idea.
%
%
% Example
%    inversionRecovery;
%    inversionRecovery(2.6,0.8);
%    inversionRecovery(3,1.2);
%    inversionRecovery(2,2.4);
%

if notDefined('T1'), T1 = 2.6; end         % T1 sec
if notDefined('Pulse'), Pulse = 0.8; end   % 90 deg pulse time
    
set(gca,'xlim',[-10,10],'ylim',[-10,10]); axis equal
axis(axis); grid on; ylabel('B0 axis'); cla

%% Original net magnetization
m = [0,10]; [p0,r0] = cart2pol(m(1),m(2));
a = arrow([0,0],m(1:2));  set(a,'edgecolor',[1,0,0])
pause(0.5)
txt = text(-2,15,'180-deg rf pulse','FontSize',14);
pause(0.4);

%% Flip the magnetization with a 180 pulse
delete(a)
[p,r] = cart2pol(m(1),m(2)); p = p0 - pi; [m(1),m(2)] = pol2cart(p,r);
a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0])

pause(0.6);

%% Let the T1 value decay for a while at the T1 rate.
for t=[0:0.15:Pulse]    % Time in seconds
    delete(a)
    r = (r0 - 2*r0*exp(-t/T1)); 
    if r > 0, p = p0; end
    [m(1),m(2)] = pol2cart(p,abs(r)); 
    a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0]);
    pause(0.4);
end

delete(txt);

%% Rotate the magnetization using a 90 deg pulse
txt = text(-2,15,'90-deg rf pulse','FontSize',14);
nSteps = 10;
for ii = 1:nSteps
    delete(a)
    [p,r] = cart2pol(m(1),m(2)); p = p - (pi/2)/nSteps; [m(1),m(2)] = pol2cart(p,r);
    a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0])
    pause(0.1)
end

%%
delete(txt);
text(-2,15,'Measure RF now.','FontSize',14);

end
