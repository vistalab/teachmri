function spins = kspacePreCompute(params, gradients, xygrid, b0noise)
%
%
% Winawer, Vistasoft, 2009

% initial conditions
spins = [];
t     = 0;

%{
  % store the spins at all time points so we can make a compressed movie
  spins.saved = zeros([size(xygrid.x) length(gradients.T)], 'uint8');
%}

% Calculate the effect of the echo time
spins  = kspaceComputeOnePoint(params, gradients, xygrid, b0noise, spins, t);

% update the spin phase to account for the most recent step
spins  = kspaceGetCurrentBasisFunctions(spins);

% Find the unique gradient combinations
[b, m, n] = unique([gradients.y' gradients.x' gradients.T'], 'rows');

% If there are too many unique values, precomputing (1) will not be very
% helpful, and (2) will be memory intensive, so we will skip
if length(b) > 20, return; end

tmpspins = [];
for ii = 1:length(b)
    t = m(ii);
    tmpspins  = kspaceComputeOnePoint(params, gradients, xygrid, b0noise, tmpspins, t);
    spins.precompute(:,:,ii) = tmpspins.step;
end
spins.precomputeIndex = n;


end