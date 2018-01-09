%% t_shTableau
%
%   Make a tableau of spherical harmonics
%
%

%% Make this nicer
mrvNewGraphWin;
ii = 0;
maxDeg = 5;
for dd = 1:maxDeg  
    for oo = 1:dd   % Order < degree
        ii = ii + 1;
        degree = dd; order = oo;
        [x,y,z] = mrdSphericalHarmonic(degree,order);
        subplot(maxDeg,maxDeg,ii); surf(x,y,z);
        title(sprintf('O = %d D = %d',oo,dd));
        light; lighting phong
        axis off tight equal
        view(40,30); camzoom(1.5)
    end
end
