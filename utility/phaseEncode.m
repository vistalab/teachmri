function phaseEncode(rate,spinDir,nSteps,label)
%
% Visualization of the phase-encoding
%

if ~exist('nSteps','var'), nSteps = 15; end
if ~exist('label','var'), label = 'Gradient-Y'; end

for jj=1:4
    subplot(2,2,jj),
    set(gca,'xlim',[-10,10],'ylim',[-10,10]); 
    axis square;
    axis(axis); grid on; xlabel('x-axis'); ylabel('y-axis');
end

subplot(2,2,1), t0 = text(12,12,label); 
% t1 = text(-3,7,'F1');
% subplot(2,2,2), t2 = text(-3,7,'F1');
% subplot(2,2,3), t3 = text(-3,7,'F2');
% subplot(2,2,4), t4 = text(-3,7,'F2');

a = [];
for ii = 0:nSteps
    pause(0.2);
    if ~isempty(a), for jj=1:4, delete(a(jj)); end;  end
    for jj = 1:4
        subplot(2,2,jj)

        set(gca,'xlim',[-10,10],'ylim',[-10,10]);
        axis square;
        axis(axis); grid on; xlabel('x-axis'); ylabel('y-axis');

        
        [pa(jj),ra(jj)] = cart2pol(spinDir(jj,1),spinDir(jj,2)); 
        pa(jj) = pa(jj) - rate(jj); 
        [spinDir(jj,1),spinDir(jj,2)] = pol2cart(pa(jj),ra(jj));
        a(jj) = arrow([0,0],spinDir(jj,:));  set(a(jj),'edgecolor',[1,0,0]);
    end
end


return;
