function  kspace = kspaceGetCurrentSignal(kspace, t, im, spins, params)
%
%  kspace = kspaceGetCurrentSignal(kspace, t, imv, spins, params)
%
% Description
%
%  The variables s.r and s.i are the 'real' (s.r) or sinusoidal basis
%  matrix and the 'imaginary' (s.i) or cosinudoidal basis matrix. When we
%  multiply these basis matrices with the image, we get the kspace
%  measurement. So kspace.vals.real is the 'real' or sinusoidal recording
%  channel and kspace.vals.imag is the 'imaginary' or cosinusoidal
%  recording channel.
%
%  In the early days of MRI, there were  two antennae in the coils, one for
%  the imaginary and one for the real components. Now the signal is
%  digitized at a very high rate and the real and imaginary components are
%  computed one high rate channel.
%
% Winawer, Vistasoft, 2009


dx  = params.imRes;
dy  = params.imRes;
s.r = real(spins.total); 
s.i = imag(spins.total);  
imv = im.vector;

kspace.vector.real(t) = imv * s.r(:) * dx * dy;
kspace.vector.imag(t) = imv * s.i(:) * dx * dy;

return


