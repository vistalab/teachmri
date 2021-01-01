function [gradients, kspace] = kspaceMakePulseSequence(params)
% Get gradients and expected kspace locations as function of time
%
% [gradients, kspace] = kspaceMakePulseSequence(params)
%
% Input
%   params.sequenceType - 'epi' or 'spiral'
%
% Output
%   gradients - Gradient sequence
%   kspace    - location through the  sequence
%
% Winawer, Vistasoft, 2009

%
sequenceType = params.sequenceType;

switch lower(sequenceType)
    case 'spiral'
        gradients = kspaceSpiral(params);
    case 'epi'
        gradients = kspaceEPI(params);
    otherwise 
        error('Unknown sequence type %s\n',sequenceType);
end

% Initialize kspace matrices
kspace = kspaceInitializeMatrices(params, gradients);

end

%{
**** Debug *********
figure(3); 
subplot(3,2,1:2); hold on;
dt = params.dt;
plot([0 cumsum(gradients.T)]*dt, [gradients.x(1) gradients.x], 'b-', 'lineWidth', 2); 
plot([0 cumsum(gradients.T)]*dt, [gradients.y(1) gradients.y], 'r-', 'lineWidth', 2); 
xlabel('time (s)')
ylabel('tesla / m ?')
title('Gradient trajectories')
%}

%{
subplot(3,2,3:6); hold on;
noversample = 2;
plot(kspace.vector.x(1:end/noversample), kspace.vector.y(1:end/noversample), 'bo-')
plot(kspace.vector.x((1:end/noversample)+end/noversample), kspace.vector.y((1:end/noversample)+end/noversample), 'ro-')
%plot(kspace.vector.x(1), kspace.vector.y(1), 'rx')
title('K Space trajectories')
xlabel('frequency (cycles per meter)')
ylabel('frequency (cycles per meter)')
axis square tight
grid on
%}