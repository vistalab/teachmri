function gradients = kspaceEPI(params)
% Generate EPI gradients sequence
%
% [gradients, kspace] = kspaceEPI(params)

% EPI works in a kind of zigzag
% We start at the upper left corner of kspace, move positively in the freq
% encode direction, then bump down a row in the phase direction, then move
% negatively across the fr encode direction, etc.
% So we want to make the ph encode gradient blip once per row, and we want
% the freq encode gradient to alternate + / - for a row at a time.

%% Initialize variables
freq     = params.freq;
nsamples = freq^2; % the number of points we will acquire is the square of the resolution
kx       = 1/params.FOV;

gradients.T = ones(1, nsamples);
gradients.x = gradients.T*0; % ph encode
gradients.y = gradients.T*0; % fr encode

%% Frequency encode (y gradient) 
for row = 1:2:freq
    inds = 1 + (row-1) * freq : freq + (row-1) * freq;
    gradients.y(inds) = kx;
    gradients.y(inds+freq) = -kx;
end

%% x Phase encode (x gradient)
gradients.x(freq+1:freq:end-freq+1) = kx;  % ph encode blips
gradients.y(freq+1:freq:end-freq+1) = 0;  % shut off fr gradient during ph blips

%% Initial point (move to upper left of k space)
gradients.x(1) = -kx;
gradients.y(1) = -kx;
gradients.T(1) = freq/2;

%%
return

