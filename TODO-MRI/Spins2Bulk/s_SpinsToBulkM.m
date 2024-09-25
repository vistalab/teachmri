%% 90º flip (fast), t2 relaxation (set t1 to very long)
params.nspins  = 10000;    % count
params.dt      = 0.002;    % seconds
params.nsteps  = 100; % count
params.t2      = 0.050;    % seconds 
params.t1      = 20;       % seconds 
params.larmor  = 10;       % cycles/second (slow enough to see it, but not quite laboratory fram)
params.B1freq  = 1/4/.010; % cycles/second. 1/4/.010 means a 90 deg flip in 10 ms
params.k       = 2;        % constant for Boltzmann distribution. 0 means uniform distribution, ie no magnetic field.
params.flipangle = pi/2;   % flip angle in radians
params.fliptime  = 0.025;  % when to initiate flip (seconds)

animateSpins(params);

%% same, but in rotating reference fr
params.larmor  = 0;
animateSpins(params);

%% same, but stronger magnetic field for greater spin orienation bias
params.k       = 4;
animateSpins(params);

%% watch a slow flip
params.dt      = 0.0001;   % seconds
params.nsteps  = 100; % count
params.B1freq  = 1/4/.010; % cycles/second. 1/4/.010 means a 90 deg flip in 10 ms
params.flipangle = pi/2;   % flip angle in radians
params.fliptime  = 0.001;  % when to initiate flip (seconds)

animateSpins(params);

%% t1 recovery
params.nspins  = 10000;    % count
params.dt      = 0.005;    % seconds
params.nsteps  = 200; % count
params.t1      = 0.8;       % seconds 
params.larmor  = 0;       % cycles/second (slow enough to see it, but not quite laboratory fram)
params.fliptime  = 0.050;  % when to initiate flip (seconds)

animateSpins(params);

