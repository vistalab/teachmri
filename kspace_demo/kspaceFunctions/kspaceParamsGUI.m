function [params, ok] = kspaceParamsGUI(params)
% Create Graphical User Interface for kspace demo
%   [params, ok] = kspaceParamsGUI(params)
%
% This should be remade in GUIDE

% ********************
%   User defined
% ********************

% Get user defined inputs from GUI
[params, ok]    = kspaceUserDefinedParams(params); if ~ok, return; end

% ********************
% Constants
% ********************

% Gyromagnetic ratio of hydrogen
params.gamma = 42.58 * 10^6 * 2 * pi;    % radians per Tesla (not Hz because we multiply by 2 pi)

% Main magnetic field strength
params.B0    = 3;                        % Tesla        
   
% ********************
% Derived
% ********************

% Units 

% Convert millimeters => meters ---------------------

% Field of view can be different from the image size, if desired. If
% smaller than images size, we will see aliasing (wraparound).
% It is best if resolution of the sampled image is coarser than the 
% resolution of the raw image. This is important if we would like to see 
% effects of intravoxel dephasing due to static inhomogeneity gradients. If
% the resolution of the sampled image is equal to the resolution of the raw
% image, then there can only be one field value per pixel, and hence there
% will be no dephasing. For spiral simulations, in which kspace is not
% sampled from a cartesian grid, it is also important to have greater
% resolution in the raw image, otherwise the off-grid frequencies may be
% aliased. 
params.res        = 1/1000 * params.res;
params.FOV        = 1/1000 * params.FOV;
params.FOV        = round(params.FOV / params.res / 2) * params.res * 2; 
params.freq       = params.FOV    / params.res; % This must be an even number (enforced in line above)

params.imSize     = 1/1000 * params.imSize;
params.imRes      = 1/1000 * params.imRes;
params.imFreq     = params.imSize / params.imRes;

% Convert killohertz to hertz -------------------------
params.bandwidth    = params.bandwidth * 10^3;

% Derive dwell time (in seconds) computed from bandwidth
%   'dwell time' is the duration between successive samples of kspace. 
params.dt         = 1/params.bandwidth;

% Convert milliseconds to seconds ---------------------
params.echoTime   = 1/1000 * params.echoTime;

% Convert parts per million => parts per B0 -----------
params.noiseScale = 10^-6  * params.noiseScale;

% Gradient strength
%   The maths:
%       gx*gamma*dt = 2 pi
%   This means that for each successive point sampled in an EPI scan, there
%   is an additional 2 pi phase difference across the image, hence a
%   spatial frequency increment of +/- one cycle / image 
params.gx    = 2*pi/(params.gamma*params.dt); % Tesla / meters 
params.gy    = params.gx;  

% Check that FOV is an exact multiple of pixel size.

% -------------------------
% ---- just for fun -------
ro.L = params.freq * params.dt;       % time to read out a line = nPoints * dwell time
ro.I = params.freq ^ 2 * params.dt;   % time to read out a image = nPoints^2 * dwell time
bandwidth.fr = 1/ro.L; %(Hz / pixel)
bandwidth.ph = 1/ro.I; %(Hz / pixel)
epishift     = 126 / bandwidth.ph; %#ok<NASGU> % epi shift in phase encoded direction in voxels  per ppm field shift
% fprintf('EPI shift in pixels assuming b0 noise of 1 part per million: %f\n', epishift)
% -------------------------

return


function [params, ok] = kspaceUserDefinedParams(params)

if ~exist('generalDialog.m', 'file'), addpath('mrVistaUtilities'); end
    

% imfile
dlg(1).fieldName    = 'imfile';
dlg(end).style      = 'popup';
dlg(end).string     = 'Name of image file';
dlg(end).value      = 'axialBrain.jpg';
dlg(end).list       = {'checkerboard.jpg', 'face.jpg', 'sagittalBrain.jpg', 'axialBrain.jpg', 'axialLucas.jpg', 'other'};
if ~isempty(params), dlg(end).value = params.imfile; end

% showProgress
dlg(end+1).style    = 'checkbox';
dlg(end).string     = 'Show recon point by point (cool but slow)';
dlg(end).value      = false;
dlg(end).fieldName  = 'showProgress';
if ~isempty(params), dlg(end).value = params.showProgress; end

% loop
dlg(end+1).style    = 'checkbox';
dlg(end).string     = 'Keep GUI open?';
dlg(end).value      = 1;
dlg(end).fieldName  = 'loop';
if ~isempty(params), dlg(end).value = params.loop; end

% sequenceType
dlg(end+1).style    = 'popup';
dlg(end).string     = 'Kspace trajectory';
dlg(end).list       = {'spiral', 'EPI'};
dlg(end).value      = 'EPI';
dlg(end).fieldName  = 'sequenceType';
if ~isempty(params), dlg(end).value = params.sequenceType; end

% noiseType
dlg(end+1).style    = 'popup';
dlg(end).string     = 'B0 noise';
dlg(end).list       = {'local offset', 'random offset', 'random lowpass', 'x gradient', 'y gradient', 'dc offset', 'map', 'none'};
dlg(end).value      = 'local offset';
dlg(end).fieldName  = 'noiseType';
if ~isempty(params), dlg(end).value = params.noiseType; end

% noiseScale
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'noiseScale';
dlg(end).string     = 'Noise scale (fraction of B0, ppm)';
dlg(end).value      = .5;
if ~isempty(params), dlg(end).value = params.noiseScale * 10^6; end

% FOV
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'FOV';
dlg(end).string     = 'Field of View (diameter, mm)';
dlg(end).value      = 180;
if ~isempty(params), dlg(end).value = params.FOV * 10^3; end

% res
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'res';
dlg(end).string     = 'Pixel Size, reconned image, mm';
dlg(end).value      =  2;
if ~isempty(params), dlg(end).value = params.res * 10^3; end

% imSize
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'imSize';
dlg(end).string     = 'Image Size (diameter, mm)';
dlg(end).value      = 180;
if ~isempty(params), dlg(end).value = params.imSize * 10^3; end

% imRes
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'imRes';
dlg(end).string     = 'Pixel Size, original image, mm';
dlg(end).value      = 1;
if ~isempty(params), dlg(end).value = params.imRes * 10^3; end

% dt (dwell time, in microseconds) is now computed based on pixel
% bandwidth, and so cannot be set directly by the user.

% pixel bandwith (Hz)
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'bandwidth';
dlg(end).string     = 'Bandwidth (KHz)';
dlg(end).value      =  125;
if ~isempty(params), dlg(end).value = params.bandwidth / 10^3; end

% TE
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'echoTime';
dlg(end).string     = 'Echo time (ms)';
dlg(end).value      =  30;
if ~isempty(params), dlg(end).value = params.echoTime * 10^3; end

% oversample 
% (Relevant for helping spiral recon, as suggested by Atsushi. Why this is
% necessary is a mystery. We get perfectly good data from single shot
% spirals at the Lucas Center.)
dlg(end+1).style    = 'number';
dlg(end).fieldName  = 'oversample';
dlg(end).string     = 'Overample (n shots)';
dlg(end).value      =  1;
if ~isempty(params), dlg(end).value = params.oversample; end


pos = [1 1 .25 .5];
[params, ok] = generalDialog(dlg, mfilename, pos);

return
