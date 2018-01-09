function inversionRecovery(T1)
%
% Short graphical implementation illustrating the Inversion Recovery idea.
%

set(gca,'xlim',[-10,10],'ylim',[-10,10]); axis equal
axis(axis); grid on; ylabel('B0 axis'); cla

% Original net magnetization
m = [0,10]; [p0,r0] = cart2pol(m(1),m(2));
a = arrow([0,0],m(1:2));  set(a,'edgecolor',[1,0,0])
pause(0.5)
txt = text(-2,10,'180-deg rf pulse');
pause(0.4);

% Flip the magnetization with a 180 pulse
delete(a)
[p,r] = cart2pol(m(1),m(2)); p = p0 - pi; [m(1),m(2)] = pol2cart(p,r);
a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0])

pause(0.6);

% Let the T1 value decay for a while at the T1 rate.
for t=[0:0.15:0.8]    % Time in seconds
    delete(a)
    r = (r0 - 2*r0*exp(-t/T1)); 
    if r > 0, p = p0; end
    [m(1),m(2)] = pol2cart(p,abs(r)); 
    a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0]);
    pause(0.4);
end

delete(txt);
txt = text(-2,10,'90-deg rf pulse');

% Rotate the magnetization using a 90 deg pulse to measure it
for ii = [1:5]
    delete(a)
    [p,r] = cart2pol(m(1),m(2)); p = p - (pi/2)/5; [m(1),m(2)] = pol2cart(p,r);
    a = arrow([0,0],m);  set(a,'edgecolor',[1,0,0])
    pause(0.2)
end

delete(txt);
txt = text(-2,10,'Measure RF now.');

return;
