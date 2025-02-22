% weightLoss
%
% 

% Suppose the effect of method A is to create a weight loss of 5 lbs, with
% a standard deviation of 0.5.   The effect of method B is to create a
% weight loss of 10 pounds with a standard deviation of 2 pounds
%
% Here is the distribution of weight loss values

plotNormal([5 10],[0.5 2],'color',{'r','b'});

%% The d' of method A and B are

dA = 5/0.5; dB = 10/2;

fprintf('Method A d'' %2f\n',dA);
fprintf('Method B d'' %2f\n',dB);

yaxisLine(gca,0);
xlabel('Weight loss (lbs)')

%%

