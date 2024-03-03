%% Rank bi-serial correlation
%
% Based on the Havana article

% Number of subjects
N = 20;

% Difference
delta = 1;

g1 = randn(N,1);
g2 = randn(N,1) + delta;
both = [g1; g2];
[bothSorted,idx] = sort(both);

%% Rank order plot
sym = {'ro','k*'};

ieNewGraphWin;
hold on;
mn1 = 0; mn2 = 0;
for ii=1:numel(bothSorted)
    if idx(ii) < 21
        plot(ii,bothSorted(ii),sym{1});
        mn1 = mn1 + ii;
    else
        plot(ii,bothSorted(ii),sym{2});
        mn2 = mn2 + ii;
    end
end

%%  The biggest possible difference is N
%   Happens when all are 1,N and N+1,2N

N = 20;
cnt = 1000;
delta = linspace(-1,1,9);
t = ceil(sqrt(numel(delta)));

ieNewGraphWin([],'big'); tiledlayout(3,3);
for dd = 1:numel(delta)
    diff = delta(dd);
    rrb = zeros(cnt,1);
    for kk=1:cnt
        % Two normally distributed, separated by diff
        g1 = randn(N,1);
        g2 = randn(N,1) + diff;

        % Sort and calculate mean ranks
        both = [g1; g2];
        [bothSorted,idx] = sort(both);
        mn1 = 0; mn2 = 0;
        for ii=1:numel(bothSorted)
            if idx(ii) < 21, mn1 = mn1 + ii;
            else, mn2 = mn2 + ii;
            end
        end

        % Formula for rank biserial
        rrb(kk) = (mn2/N - mn1/N)/N;
    end

    % Plot
    nexttile; histogram(rrb); set(gca,'xlim',[-1 1]);
    title(['\sigma',sprintf('= %.2f, rrb = %.2f',diff, mean(rrb))]);
end

%%  Show the distribution for some diffs
diff = 1;
g1 = randn(cnt,1);
g2 = randn(cnt,1) + diff;
ieNewGraphWin([],'wide');

tiledlayout(1,3);
nexttile; histogram(g1); hold on; histogram(g2);

diff = 0.5;
g1 = randn(cnt,1);
g2 = randn(cnt,1) + diff;
nexttile; histogram(g1); hold on; histogram(g2);

diff = 0.25;
g1 = randn(cnt,1);
g2 = randn(cnt,1) + diff;
nexttile; histogram(g1); hold on; histogram(g2);

%%