%% Series of beakers, showing the response over space

% Build the time series from each of the beakers

% Maybe do it for only a few beakers, and then for more

f = (1:.1:4);   % Hz
t = (0:255)/255 * 2*pi*3;     % Three cycles at 1 Hz
sig = zeros(numel(f),numel(t));
for ii=1:numel(f)
    sig(ii,:) = sin(t*f(ii));
end

%% Here are all the time series
mrvNewGraphWin;
hold on
for ii=1:numel(f)
    plot(t,sig(ii,:)+(ii-1));
end
grid on;
xlabel('Time');
ylabel('Mxy');


%% Here is the signal at a single moment in time, but plotted across space
mrvNewGraphWin;
thisT = 50
plot(sig(:,thisT));
xlabel('Beaker position');
ylabel('Mxy')

%%



