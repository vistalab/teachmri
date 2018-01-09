function [x,y,z] = mrdSphericalHarmonic(degree,order)
%Compute viewable spherical harmonics
%
%  [x,y,z] = mrdSphericalHarmonic(degree,order) 
%
% These are two parameters that define the particular harmonic
% 
%
% Example - Plot the surface
%  degree = 3; order = 1;
%  [x,y,z = mrdSphericalHarmonic(degree,order);
%  mrvNewGraphWin; surf(x,y,z);
%  light; lighting phong
%  axis tight equal off
%  view(40,30); camzoom(1.5)
%
% Original code downloaded and modified from Matlab file exchange
%
% BW Vistasoft Team 2013 



% Create the sampling grid in angles
delta = pi/40;
theta = 0 : delta : pi; % altitude
phi = 0 : 2*delta : 2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);

%% Calculate the harmonic

% It is represented in the variable r, which
% depends on degree, order and theta.  But not phi, yet.
Ymn = legendre(degree,cos(theta(:,1)));
Ymn = Ymn(order+1,:)';
yy = Ymn;

% Build up yy from Ymn
for kk = 2: size(theta,1)
    yy = [yy Ymn];
end
yy = yy.*cos(order*phi);

order = max(max(abs(yy)));
rho = 5 + 2*yy/order;

%% Apply spherical coordinate equations

% We need a figure here illustrating the relationship between the two
% angles and the value of r
r = rho.*sin(theta);
x = r.*cos(phi);    % spherical coordinate equations
y = r.*sin(phi);
z = rho.*cos(theta);

return;


%% Original


% Define constants.
degree = 6;
order = 1;

% Create the grid
delta = pi/40;
theta = 0 : delta : pi; % altitude
phi = 0 : 2*delta : 2*pi; % azimuth
[phi,theta] = meshgrid(phi,theta);

% Calculate the harmonic
Ymn = legendre(degree,cos(theta(:,1)));
Ymn = Ymn(order+1,:)';
yy = Ymn;
for kk = 2: size(theta,1)
    yy = [yy Ymn];
end
yy = yy.*cos(order*phi);

order = max(max(abs(yy)));
rho = 5 + 2*yy/order;

% Apply spherical coordinate equations
r = rho.*sin(theta);
x = r.*cos(phi);    % spherical coordinate equations
y = r.*sin(phi);
z = rho.*cos(theta);

% Plot the surface
clf
surf(x,y,z)
light
lighting phong
axis tight equal off
view(40,30)
camzoom(1.5)