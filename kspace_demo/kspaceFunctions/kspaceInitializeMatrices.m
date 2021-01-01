function kspace = kspaceInitializeMatrices(params, gradients)
% Initialize kspace
%
% Our kspace structure has two parts, a vector and a grid (square matrix).
%
% (1) Vector
% We acquire data point by point, and the points acquired may not have
% integer corodinates (for example in a spiral acquisition). Hence we
% initially store values in a vector. We need a real and a complex vector,
% as well as x and y vectors to specify the corresponding locations in
% kspace. The kspace vectors are the same length as the gradient vectors.
%
% (2) Matrix
% The kspace matrix will have the same 4 fields as the vectors (x,y, real,
% imaginary). We can create the xy grid now. We will fill the real and
% imaginary cells when we 'grid' the vector data for reconstruction. This
% will be easy for EPI sequences, since the data are acquired on the grid.
% Interpolation will be required to grid spiral acquisitions.

%% Vectors
% Convert gradient values to kspace positions
%   The important theoretical point is that the position in kspace is the
%   time integral of the gradients.
T = gradients.T;
kspace.vector.x = cumsum(gradients.x .* gradients.T);
kspace.vector.y = cumsum(gradients.y .* gradients.T);

kspace.vector.real = zeros(1, length(T));
kspace.vector.imag = zeros(1, length(T));

%% Grids
% Define the xy indices by the spatial frequencies 
nsamples    = params.freq;
freqs       = linspace(-.5,.5,nsamples+1) * 1/params.res;
freqs       = freqs(1:end-1);

[kspace.grid.x kspace.grid.y]   = meshgrid(freqs, freqs);
kspace.grid.x                   = fftshift(kspace.grid.x);
kspace.grid.y                   = fftshift(kspace.grid.y);

% Make empty kspace grids to fill later
kspace.grid.real = zeros(nsamples);
kspace.grid.imag = zeros(nsamples);

