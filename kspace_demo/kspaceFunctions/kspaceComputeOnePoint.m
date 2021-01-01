function spins = kspaceComputeOnePoint(params, gradients, xygrid, b0noise, spins, t)
% Calculate the spin phase at each discrete image location 
%       from the gradients and b0 inhomogeneities
%
% Syntax
%   step = kspaceComputeOnePoint(params, GX, GY, T);
%
% Description
%
% Inputs
%
% Outputs
%
% Winawer, Vistasoft, 2009
%
% See also

% Check to see whether we pre-computed the spin state. If so, grab it and
% move on.
if isfield(spins, 'precompute')
    spins.step = spins.precompute(:,:,spins.precomputeIndex(t));
    return
end

%% ***************************
% Define Variables
% ***************************

% Constants (these don't change - we define them here to make our equations
%               look nicer)
gamma = params.gamma;   % gyromagnetic constant for hydrogen
dt    = params.dt;      % time for discrete step in k-space sampling

gx    = params.gx;      % gradient constants in units of Tesla / meter
gy    = params.gy;      %

x     = xygrid.x;       % spatial locations in image in meters,
y     = xygrid.y;       % starting from 0,0 (upper left)

% gradients (these change over time)
if t == 0  % then this is the effect of waiting TE (echo time), which means
    % the gradients have not yet been on, and the only effect we
    % should see is depahsing due to B0 noise, if any
    GX = 0;
    GY = 0;
    T  = params.echoTime / dt;
else       % in this case our gradients are moving and we are getting images!
    GX    = gradients.x(t); % gradient scalars over time (e.g., +1, 0, -1 for EPI)
    GY    = gradients.y(t);
    
    T     = gradients.T(t); % number of dt's between samples (usually 1)
end

%% ***************************
% Compute one step
% ***************************
step.x = exp(-1i*gamma*x*gx*GX*dt*T); % spin change due to x-gradient
step.y = exp(-1i*gamma*y*gy*GY*dt*T); % spin change due to y-gradient

if strcmpi(params.noiseType, 'none') % don't calculate noise if there is none - this just takes time
    step = step.x .* step.y;              % total spin change
else
    step.e = exp(-1i*T*dt*b0noise*gamma); % spin change due to b0 error
    step = step.x .* step.y .* step.e;    % total spin change
end

spins.step = step;

% The total spin change should include the term
%           exp(-1i*gamma * B0 * dt * T)
% So we would have
%       step = step.x .* step.y .* step.e .* exp(-1i*gamma * B0 * dt * T)
% But we drop this term due to demodulation at aquisition. (Lauterber book)

end
