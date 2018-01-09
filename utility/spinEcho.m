function spinEcho(TE)
%
% Graphical implementation illustrating the Spin Echo dephasing and echo
% formation.
%
%
% TODO:  Add more vectors
%        Make the TE in real units of time and have it make sense.

if ~exist('TE','var'), TE = 16; end

cla
set(gca,'xlim',[-10,10],'ylim',[-10,10]); 
axis square;
axis(axis); grid on; xlabel('x-axis'); ylabel('y-axis');

% Original net magnetization
ma = [10,0]; [p0,r0] = cart2pol(ma(1),ma(2));
a = arrow([0,0],ma(1:2));  set(a,'edgecolor',[1,0,0])
mb = ma; 
b = arrow([0,0],mb(1:2));  set(b,'edgecolor',[0,1,0])
t = text(0,8,'90 deg pulse and dephasing');
pause(1.2)

for ii= 1:TE
    delete(a); delete(b);
    [pa,ra] = cart2pol(ma(1),ma(2)); pa = pa - pi/8; [ma(1),ma(2)] = pol2cart(pa,ra);
    a = arrow([0,0],ma);  set(a,'edgecolor',[1,0,0]);
    [pb,rb] = cart2pol(mb(1),mb(2)); pb = pb - pi/10; [mb(1),mb(2)] = pol2cart(pb,rb);
    b = arrow([0,0],mb);  set(b,'edgecolor',[0,1,0]);
    pause(0.2);
end

pause(0.7);

% Apply a 180 deg pulse that rotates the spins around the x-axis.
delete(t); t = text(0,8,'Inverting (180 deg) pulse'); pause(0.5);
delete(a); delete(b)
[pa,ra] = cart2pol(ma(1),ma(2)); pa = -pa; [ma(1),ma(2)] = pol2cart(pa,ra);
a = arrow([0,0],ma);  set(a,'edgecolor',[1,0,0])
[pb,rb] = cart2pol(mb(1),mb(2)); pb = -pb; [mb(1),mb(2)] = pol2cart(pb,rb);
b = arrow([0,0],mb);  set(b,'edgecolor',[0,1,0]);

pause(0.7);

% Now we keep going.
delete(t); t = text(0,8,'Catching up.');
for ii= 1:TE
    delete(a); delete(b);
    [pa,ra] = cart2pol(ma(1),ma(2)); pa = pa - pi/8; [ma(1),ma(2)] = pol2cart(pa,ra);
    a = arrow([0,0],ma);  set(a,'edgecolor',[1,0,0]);
    [pb,rb] = cart2pol(mb(1),mb(2)); pb = pb - pi/10; [mb(1),mb(2)] = pol2cart(pb,rb);
    b = arrow([0,0],mb);  set(b,'edgecolor',[0,1,0]);
    pause(0.2);
end
delete(t); t = text(0,8,'The echo arrives.');

return;
