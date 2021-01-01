function [params, im, kspace, spins, gradients] = kspaceDemo(params)
% A demonstration of MRI imaging principles and artifacts
%
%   Written by Jonathan Winawer. 
%   Copyright 12.08.2009.
%
% To run, simply run kspaceDemo from the Matlab prompt. This will launch
% the GUI. Then go. Sample images ('face.jpg' and 'brain.jpg') downloaded
% from Google Image search.
%
% params - a struct with these fields
%   
% Notes:
%  Some ideas for improvement: 
%       - Proper gridding for spiral reconstruction 
%       - Real signal equations (e.g., gradient echo or spin echo
%           equations, with options for T1, T2, T2*, and proton density
%           maps as inputs, instead of just images)
%       - Allow arbitary field map as noise option
%       - Nicer GUI
%
% Please feel free to improve this demo if you know how to do so. -JW
%
% Winawer, Vistasoft, 2009


% Check paths
kspaceCheckPaths;

% Check Inputs
if ~exist('params', 'var') || isempty(params), params = []; end

% Define scan parameters and constants
[params, ok]          = kspaceParamsGUI(params); if ~ok, return; end

% Read in an image
im                    = kspaceGetImage(params);

% Create a grid of x,y values (in meters) to represent pixel positions
xygrid                = kspaceGrid(params);

% Create a map of B0 field inhomogeneities in units of Tesla
b0noise               = kspaceGetB0Noise(params, xygrid);

% Get gradient values and expected kspace locations as function of time
[gradients, kspace]   = kspaceMakePulseSequence(params); 

% Prepare figure and waitbar
f = kspacePrepareFigure;

if ~params.showProgress
    waitHandle = waitbar(0,'Simulating Fourier imaging. Please wait...');
end
% GO! Get yer kspace data
M        = struct('cdata', [], 'colormap',[]); % initialize a struct to store a movie
T        = length(gradients.T); % number of discrete sampling points (in time)
updates  = round((0:.1:1)*T);   

% Precompute spins
% The gradients pattern may be very repetitive (especially if we are usng
% EPI). Pre-computing can save a LOT of time.
spins = kspacePreCompute(params, gradients, xygrid, b0noise);

for t = 1:T    

    % calculate the change in spin phase at each discrete location in the image
    %   due to the current gradient values and b0 inhomogeneities
    spins  = kspaceComputeOnePoint(params, gradients, xygrid, b0noise, spins, t);
    
    % update the spin phase to account for the most recent step
    spins  = kspaceGetCurrentBasisFunctions(spins);    
    
    % get signal for this time point (fill 1 point in kspace)
    kspace = kspaceGetCurrentSignal(kspace, t, im, spins, params);

    % show the guts, if requested
    [kspace, M] = kspaceShowPlots(f, spins, gradients, kspace, im, params, t, b0noise, M);        
    
    if ~params.showProgress && ismember(t, updates), waitbar(t/T); end
end

if ~params.showProgress, close(waitHandle); end

% Save Data
kspaceSetUserData(f, params, im, kspace, spins, gradients, xygrid, M);

if params.loop, params = kspaceDemo(params); end

end
