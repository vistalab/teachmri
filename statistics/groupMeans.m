%% Group means and diagnostic tools
%
% Each point represents a person
% The two groups differ by 0.1 standard deviations
% But given a measurement of a person signal is not useful for 

nSamples = 1e3;                % Say a 30 x 30 region of voxels
delta = 2e-1;                  % Difference in the group means (units of sd).
idx = [1,2];                   % Two groups
X = randn(nSamples,1);         % Normal, 0 mean
Y = randn(nSamples,1) + delta; % Normal delta mean

%% Typical plots of group means and SE

mnX = mean(X); mnY = mean(Y); data = [mnX; mnY];
seX = std(X)/sqrt(numel(X)); seY = std(Y)/sqrt(numel(Y));
errhigh = [seX,seY]; 
errlow = -1*errhigh;

%%
mrvNewGraphWin();
histX = histogram(X(:));
xlabel('Measurement value');
ylabel('Number of subjects');
title(sprintf('N = %d',numel(X)));
set(gca,'xlim',[-5 5]);
legend('Population distribution')

%% One dimensional version
mrvNewGraphWin([],'wide');

subplot(1,2,1)
histX = histogram(X(:)); 
hold on;
histY = histogram(Y(:));
legend('Control','Test');
title(sprintf('N = %d',numel(X)));

%% 
subplot(1,2,2);
b = bar(idx,data); 
b.BarWidth = 0.4;
b.FaceColor ='flat';
b.CData(2,:) = [.6 0.3 .2];
b.CData(1,:) = [0 .5 .8];

hold on;
er = errorbar(idx,data,errhigh,errlow);
er.Color = [0.5 0.5 0.5];                            
er.LineStyle = 'none';
er.LineWidth = 3;
set(gca,'xlim',[0 3],'xtick',[1 2]);
str = sprintf('Test (u = %.1f)',delta);

set(gca,'xticklabel',{'Control (u = 0)';str});
ylabel('Measurement value');
grid on


%%  Show the individual sample plots

mrvNewGraphWin([],'wide');

subplot(1,2,1)
samples = randi(numel(X),[min(numel(X),500),1]);   % Limit to 500 samples
plot(idx(1),X(samples)','rs'); hold on;
plot(idx(2),Y(samples)','ko');
set(gca,'xlim',[0 3],'xtick',[1 2]);
str = sprintf('Test (u = %.1f)',delta);
set(gca,'xticklabel',{'Control (u = 0)';str});
ylabel('Measurement value'); grid on
title(sprintf('N = %d',numel(X)));



%% Typical clinical plot of the result

subplot(1,2,2)
b = bar(idx,data); 
b.BarWidth = 0.4;
b.FaceColor ='flat';
b.CData(1,:) = [1 0 0];
b.CData(2,:) = [0 0 0];

hold on;
er = errorbar(idx,data,errhigh,errlow);
er.Color = [0.5 0.5 0.5];                            
er.LineStyle = 'none';
er.LineWidth = 3;

set(gca,'xlim',[0 3],'xtick',[1 2]);
set(gca,'xticklabel',{'Control (u = 0)';str});
ylabel('Measurement value');
grid on

%% END
