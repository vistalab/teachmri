function xygrid = kspaceGrid(k)
% Returns  x,y (meters) grid  representing voxel positions
%
%  thisGrid = kspaceGrid(k)
%
% Description
%   Create a grid of x,y values (in meters) to represent voxel positions.
%   This grid will have the resolution of our oringinal image, not
%   necessarily the resolution of our reconned image. This is because if we
%   are doing non-Cartesian imaging (e.g., spiral), we will want to sample
%   the non-Cartesian points in k-space at a high resolution to reduce
%   sampling artifacts.
%
% Input
%   k - space structure
%
% Output
%   xygrid.x
%   xygrid.y
%
% Winawer, Vistasoft 2009s

sz      = k.imSize; % width of image in meters
dx      = k.imRes;  % width of one pixel in meters
dy      = k.imRes;  % length of one pixel in meters

xfreq   = k.imFreq;  % number of pixels per image (should equal sz / dx)
yfreq   = k.imFreq;  % pixels are assumed to square. this could change.

[x, y] = meshgrid(linspace(0, sz-dx, xfreq),linspace(0,sz-dy, yfreq));

xygrid.x = x;
xygrid.y = y;

end
