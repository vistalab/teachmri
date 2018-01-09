%% t_attenuationsFastSlow
%
% Le Bihan and Johansen-Berg Neuroimage after 25 years article
% 
% The give this formula for diffusion fast and slow and cite work from a
% rat model. It would be good  to see how agrees and disagrees with that.
% It would also be good to see if Ariel had any data on this - diffusion
% signal as a function of b value (probably gradient strength)
%
% Useful for people in Psych 204A to work on the data and ask how well the
% bi-exponential does.  Le Bihan is very confident.  But as I recall Ariel
% and the girl who worked with him had a hard time seeing the
% bi-exponential.
%
b = linspace(800,3000,10);  % The range in our human experiments
D1 = 1.68e-4; f1 = 0.17;    % Slow
D2 = 8.24e-4; f2 = 0.8;     % Fast

a = f1*exp(-b.*D1) + f2*exp(-b.*D2);

vcNewGraphWin;
semilogx(b,a);
grid on

%% What if we have some noise, say 2% of the signal level
pErr = 0.05;
nSamp = 2;
aNoise = zeros(numel(a),nSamp);
for ii=1:length(b)
    s = 1 - a(ii);
    sNoise = s + randn(1,nSamp)*sqrt(s)*pErr;
    aNoise(ii,:) = 1 - sNoise;
end

vcNewGraphWin;
for ii=1:size(aNoise,1);
    plot(b(ii)*ones(nSamp,1),aNoise(ii,:));
    hold on
end
grid on
