function e = arNoise(rho,nPnts)
%
%   noi = arNoise(rho,nPnts)
%
%Author: Wandell
% Purpose:
%   Build an autoregressive noise sequence based on the Worsley Chapter
%   page 254, Purdon et al. (1998)

chi1 = randn(1,nPnts);
chi2 = randn(1,nPnts);
eta = zeros(size(chi1));
eta(1) = chi1(1);
for ii=2:nPnts
    eta(ii) = rho*eta(ii-1) + chi1(ii);
    e(ii) = eta(ii) + chi2(ii);
end

return;
