function kspaceSetUserData(f, params, im, kspace, spins, gradients, xygrid, M)
%  kspaceSetUserData(f, params, im, kspace, spins, gradients, xygrid, M)
% 
% store kspaceDemo structures in figure. see kspaceDemo.m.
userdata.params     = params;
userdata.im         = im;
userdata.kspace     = kspace;
userdata.spins      = spins;
userdata.gradients  = gradients;
userdata.xygrid     = xygrid;
userdata.movie      = M;

set(f, 'UserData', userdata)
