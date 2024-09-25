function animateSpins(params)

% derived parameters
t                   = (1:params.nsteps) * params.dt; % seconds
params.larmorStep   = params.larmor * params.dt * 2 * pi; % radians
params.t2stepsize   = sqrt(1.9/params.t2*params.dt); % sd of radians per step for random walk causing t2 decay
flipduration        = params.flipangle / (2*pi) / params.B1freq;
params.RFpulse      = t > params.fliptime & t < params.fliptime + flipduration;

% Initialize spins at thermal equilibrium
[Spins, B_dist, M0] = initializeSpins(params);

% Bulk magnetization
M = sum(Spins)/norm(M0);

% Set up the figure
figure(1); clf

% apply rotations around sphere
for ii = 1:params.nsteps
    
    % Larmor precession (with T2 decay)
    Spins = larmorPrecess(Spins, params);

    % t2 relaxation
    Spins = t2relaxation(Spins, params);

    % t1 relaxation
    Spins = t1relaxation(Spins, params, B_dist);

    % B1 flip
    Spins = rotateB1(Spins, params, ii);
   
    % Bulk magnetization
    M(ii,:) = sum(Spins)/norm(M0);    

    % Plot instantaeous spins
    subplot(121)
    plotSpins(Spins, M0);     

    % Plot Bulk magnetization 
    subplot(122)
    plotBulk(t, M)

    % subplot(133)
    % plotElevationHistogram(Spins);

    drawnow(); % pause(params.dt)
end

% figure(1), clf; Z = M(:,3);
% f=fit(t', Z, 'A-exp(-(x-C)/B)');
% plot(f, t, Z)
% axis auto
% disp(f.B)

end

% --------------------------------------------------------------
% ************************ SUBROUTINES *************************
% --------------------------------------------------------------
function B_dist = boltzmannDistribution(k)

% x the elevation of the spin axis
x = linspace(-pi/2,pi/2, 10000);
dx = x(2)-x(1);

% Probability of spin axis elevation:
%   Boltzmann distribution
%       p ~ exp(-E/(kT));
%   The energy, E, is minimal at 90º elevation, ie the B0+ direction, and
%   declines with a cosine dependence for other elevations. But the
%   circumference of a sphere at a particular elevation is proportional to
%   abs(cosine) of that elevation, and we need to scale the probability by
%   this factor to achieve uniform distribution when k is 0. 

Energy      = @(X) -cos(X-pi/2);
Probability = @(X) exp(-k*Energy(X));
P           = @(X) Probability(X).*abs(cos(X));
PDF         = @(X) P(X) ./ sum(P(X)) / dx;

% Convert to a probability density function
fx = PDF(x);   

% convert to a cumulative probability distribution 
Fx = cumsum(fx); Fx = Fx/Fx(end);
Fx(1) = 0;  Fx(end)=1; % ensure the CDF starts at 0 and ends at 1
B_dist = makedist('PiecewiseLinear', 'x', x, 'Fx', Fx);

end

function [Spins, B_dist, M0] = initializeSpins(params)

B_dist = boltzmannDistribution(params.k);

% sample the CDF to determine spin elevations
elevation = random(B_dist, 1, params.nspins);

% now randomly generate azimuth
azimuth = rand(size(elevation))*2*pi;

% spherical to cartesian 
r = ones(size(azimuth));
[x,y,z] = sph2cart(azimuth,elevation,r);
Spins = [x; y; z]';

M0 = sum(Spins);

end


function Spins = t1relaxation(Spins, params, B)

[azimuth, elevation, r] = cart2sph(Spins(:,1), Spins(:,2), Spins(:,3));

dx   =  sqrt(params.dt) / params.t1 / sqrt(params.k) / sqrt(2);

p_up   = B.pdf(elevation+dx);
p_down = B.pdf(elevation-dx);

p_up = p_up./(p_up + p_down);

up = p_up > rand(size(elevation)); 

deltaE = dx*(up*2-1)*2;

elevation = elevation + deltaE;

[x, y, z] = sph2cart(azimuth, elevation, r);
Spins = [x y z];

end


function Spins = larmorPrecess(Spins, params)

[azimuth, elevation, r] = cart2sph(Spins(:,1), Spins(:,2), Spins(:,3));
azimuth = azimuth + params.larmorStep;
[x, y, z] = sph2cart(azimuth, elevation, r);
Spins = [x y z];

end

function Spins = t2relaxation(Spins, params)

[azimuth, elevation, r] = cart2sph(Spins(:,1), Spins(:,2), Spins(:,3));
azimuth = azimuth + randn(size(azimuth))*params.t2stepsize;
[x, y, z] = sph2cart(azimuth, elevation, r);
Spins = [x y z];

end

function Spins = rotateB1(Spins, params, stepnum)

if params.RFpulse(stepnum)
    theta = stepnum * params.larmorStep;
    deltaE = params.B1freq * 2 * pi * params.dt;
    axang = [cos(theta) sin(theta) 0 -deltaE];
    rotm = axang2rotm(axang);
    Spins = Spins*rotm;
end

end

function plotSpins(Spins, M0)

% Individual spin vectors
scatter3(Spins(:,1), Spins(:,2), Spins(:,3), 10,  ...
    '.', 'MarkerFaceColor', .8*[1 1 1], 'MarkerFaceAlpha', .3, ...
    'MarkerEdgeColor',.8*[1 1 1], 'MarkerEdgeAlpha', .3);
axis([-1 1 -1 1 -1 1]); axis square

hold on; 
plotAxes();

% Bulk magnetization
M = sum(Spins)/norm(M0);
quiver3(0, 0, 0, M(1), M(2), M(3), 'k-', 'AutoScale', 'off', 'LineWidth', 4); 
quiver3(0, 0, 0, M(1), M(2), 0, 'r-', 'AutoScale', 'off', 'LineWidth', 4); 
quiver3(0, 0, 0, 0, 0, M(3), 'g-', 'AutoScale', 'off', 'LineWidth', 4); 
    
hold off;

end

function plotAxes

plot3([-1 1], [0 0], [0 0], 'k-');
plot3([0 0], [1 -1], [0 0], 'k-');
plot3([0 0], [0 0], [-1 1], 'k-');

end

function plotBulk(t, M)

idx = size(M,1);
if idx >= 2, idx = [-1 0] + idx; end
Mz  = M(idx,3);
Mxy = vecnorm(M(idx, 1:2), 2, 2);
plot(t(idx), Mz, 'g.-', t(idx), Mxy,  'r.-');

hold on; 
axis([0 max(t) 0 1.1]); 
axis square
xlabel('Time (s)')
ylabel('Magnetization')
% legend({'Mz', 'Mxy'})

end

function plotElevationHistogram(Spins)
[~, elevation] = cart2sph(Spins(:,1), Spins(:,2), Spins(:,3));
histogram(rad2deg(elevation), 'Normalization','percentage');
axis([-90 90 0 10]); axis square; set(gca, 'YTick', []);
xlabel('Elevation (deg)')
ylabel('Probability')
end