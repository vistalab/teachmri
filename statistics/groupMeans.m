%% Group means and diagnostic tools
%
% Each point represents a person
% The two groups differ by 0.1 standard deviations
% But given a measurement of a person signal is not useful for 

nSubjects = 1e2;
delta = 2e-1;
idx = [1,2];                    % Two groups
X = randn(nSubjects,1);         % Normal, 0 mean
Y = randn(nSubjects,1) + delta; % Normal delta mean

%%
vcNewGraphWin([],'wide');

subplot(1,2,1)
samples = randi(numel(X),[min(numel(X),500),1]);
plot(idx(1),X(samples)','rs');
hold on;
plot(idx(2),Y(samples)','ko');
set(gca,'xlim',[0 3],'xtick',[1 2]);
set(gca,'xlim',[0 3],'xtick',[1 2]);
str = sprintf('Group B (u = %.1f)',delta);
set(gca,'xticklabel',{'Group A (u = 0)';'Group B (u = 0.1)'});
ylabel('Measurement value');
grid on
title(sprintf('N = %d',numel(X)));

%% Typical plots of group means and SE

mnX = mean(X);
mnY = mean(Y);
data = [mnX, mnY];
seX = std(X)/sqrt(numel(X));
seY = std(Y)/sqrt(numel(Y));
errhigh = [seX,seY]; 
errlow = -1*errhigh;

%% Typical clinical plot of the result

subplot(1,2,2)
b = bar(idx,data);
b.BarWidth = 0.4;
hold on;
er = errorbar(idx,data,errhigh,errlow);

er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
set(gca,'xlim',[0 3],'xtick',[1 2]);
set(gca,'xticklabel',['Group A';'Group B']);
ylabel('Measurement value');
grid on

%% END
