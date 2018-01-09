function [t,randomStimulus, mFilter] = createRandomFilteredInput(wgts)
%
%      [randomStimulus, mFilter] = createRandomFilteredInput(wgts)
%
% Author:  The Class
% Date:    March 28, 2002
% Purpose:
%
%   Create a membrane filter based on the wgts that are sent in.
%   These weights determine how we combine the basis functions
%
%   Create some random noise (white noise) and filter it with
%   the membrane filter


% First, we make a Gaussian filter that will smooth out the
% original, white noise, time variable.  In this case, we are actually
% sampling time every 7.8 ms.
t = [0:100]*7.8;

% Then, we build a random stimulus for testing
randomStimulus = randn(size(t))';

% This is the filtering function they use
% tauf is a variable that varies with cell type
% the final filter is the weighted sum of a bunch of functions
% like this one.
%

j = 1;      % index into the list of basis functions
tauf = 190;  % msec
F = zeros(size(t,2),16);
for j=1:16
    F(:,j) = sin(pi*j*((2*t/tauf) - (t/tauf).^2))';
end

% All of the values beyond tauf are supposed to be zero
F(ceil(tauf/7.8):end,:) = 0;

% Each column represents another basis function
% clf; imagesc(F); colormap(gray)

% Now any specific filter is the weighted sum.  We chose
% these weights 'cause they produced something that vaguely
% resembled what is in Figure XX.

mFilter = F*wgts;
mFilter = mFilter/abs(sum(mFilter));
mFilter = circshift(mFilter,floor(length(mFilter)/2));

return;