function  gradients = kspaceSpiral(params)
% Generate spiral-out gradient sequence
%
% See McRobbie et al (MRI from physics to protons), 2nd edition, p 370, box
%
% This is an Archmidean spiral, meaning
%   A = c*theta
% where A is the distance from the center of k-space, theta is the angle
% (which keeps increasing beyond 2*pi as the spiral wraps around), and c is
% a constant. In kx,ky space:
%
%   kx = 1/(2pi * FOV) * theta * sin(theta)
%   ky = 1/(2pi * FOV) * theta * cos(theta)
%
% The gradient strengths are the derivatives of the k-space
% position with respect to time. they are
%
% Gx = 1/(gamma*FOV) * dtheta/dt * (sin(theta) + theta*cos(theta))
% Gy = 1/(gamma*FOV) * dtheta/dt * (cos(theta) + theta*sin(theta))
%
% Here we will ignore gamma and dt, since they are included in our stored
% constant gx, which will be added back later: gx = 2*pi/(gamma*dt)


%% Initialize variables
% The number of kspace samples we will collect is approximately the the
% number of pixels in the reconned image, i.e., xfreq * yfreq. This
% relationship is exact for EPI, though need not be so for spiral, since we
% are interpolating anyway when we do our gridding. Noversamples is the
% number of extra sprial shots we do. Oversampling helps avoid aliasing
% problems in sampling kspace.

nsamples    = params.freq^2;
noversample = params.oversample;
FOV         = params.FOV;

gradients.T =   ones(1, nsamples * noversample);
gradients.x =  zeros(1, nsamples * noversample);
gradients.y =  zeros(1, nsamples * noversample);


for ii = 0: noversample-1
    % Define theta
    theta  = linspace(0, params.freq*pi, nsamples);
    dtheta = mode(diff(theta));

    % gradients.x (phase encode)
    inds = (1:nsamples) + ii*nsamples;
    offset = ii/noversample*2*pi; % angular offset for interleaves
    gradients.x(inds) = dtheta / (2*pi * FOV) * (sin(theta+offset) + theta.*cos(theta+offset));
    gradients.y(inds) = dtheta / (2*pi * FOV) * (cos(theta+offset) + theta.*sin(theta+offset));

    %return to center of kspace if we are doing multiple interleaves
    if ii
        previousinds = 1:inds(1)-1;
        xpos = gradients.x(previousinds) * gradients.T(previousinds)';
        ypos = gradients.y(previousinds) * gradients.T(previousinds)'; 
        gradients.x(inds(1)) = -xpos / length(previousinds);
        gradients.y(inds(1)) = -ypos / length(previousinds);
        gradients.T(inds(1)) = length(previousinds);
    end
end

%%
return
