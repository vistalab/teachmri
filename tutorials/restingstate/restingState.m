% Psych 204a: Resting State Scrubbing Simulation

% By showing this, Howard can explain to the class that the Biswal 1995 results were
% revolutionary because they found the $0.1$ Hz signal despite the noise. It also justifies why % he has an entire slide dedicated to fMRIPrep and CONN—those tools exist primarily to handle
% the math in that MATLAB script at scale.

rng(35, 'twister');

%% Simulate a signal
fs = 0.5; % 2-second TR
t = 0:1/fs:300; % 5-minute scan
n = length(t);

%% 1. Create underlying "Neural" signal (Low-frequency 0.01-0.1 Hz)
neural_shared = lowpass(randn(size(t)), 0.1, fs);
sig1 = 0.3 * neural_shared + 0.7 * randn(size(t)); % Region A
sig2 = 0.3 * neural_shared + 0.7 * randn(size(t)); % Region B

%% 2. Add "Nuisance" (Breathing @ ~0.3 Hz + Random Motion Spike)
breathing = 0.5 * sin(2*pi*0.3*t);
motion_spike = zeros(size(t));
motion_spike(100:102) = 5.0; % Sudden head jerk

dirty_sig1 = sig1 + breathing + motion_spike;
dirty_sig2 = sig2 + breathing + motion_spike;

%% 3. "Scrubbing" - Simple version: Zeroing out the motion spike
scrubbed_sig1 = dirty_sig1;
scrubbed_sig2 = dirty_sig2;
scrubbed_sig1(100:102) = 0;
scrubbed_sig2(100:102) = 0;

%% 4. Compare Correlations
r_dirty = corr(dirty_sig1', dirty_sig2');
r_scrubbed = corr(scrubbed_sig1', scrubbed_sig2');

%% Plotting
figure('Color', 'w');
subplot(2,1,1);
plot(t, dirty_sig1, 'r', t, dirty_sig2, 'b');
title(['Raw Signals (r = ', num2str(r_dirty, '%.2f'), ') - Dominated by Motion/Breath']);
grid on;

subplot(2,1,2);
plot(t, scrubbed_sig1, 'r', t, scrubbed_sig2, 'b');
title(['Scrubbed Signals (r = ', num2str(r_scrubbed, '%.2f'), ') - Reflecting Shared Low-Freq']);
xlabel('Time (seconds)');
grid on;

fprintf('Dirty Correlation: %.2f\n', r_dirty);
fprintf('Scrubbed Correlation: %.2f\n', r_scrubbed);

%% ICA spatial calculation

% Psych 204a: ICA Spatial Sparsity Simulation
grid_size = 64;
num_voxels = grid_size^2;

% 1. Generate a Sparse "Network" (The DMN-like signal)
% Most voxels are 0 mean (Gaussian noise), a few are 1 mean (The Network)
S1 = zeros(grid_size, grid_size);
S1(20:30, 20:30) = 5; % A concentrated "spiky" source
S1 = S1 + 0.5*randn(size(S1)); % Add light background noise

% 2. Generate a Non-Sparse "Network" (Diffuse/Gaussian noise)
S2 = randn(grid_size, grid_size);

% 3. Calculate Kurtosis (A measure of Sparsity/Non-Gaussianity)
% High Kurtosis = Spiky/Sparse; Low Kurtosis = Gaussian/Diffuse
kurt1 = kurtosis(S1(:)) - 3; % Excess kurtosis
kurt2 = kurtosis(S2(:)) - 3;

% Plotting the "Spatial Demand"
figure('Color', 'w');
subplot(1,2,1);
imagesc(S1); colormap('hot'); axis image;
title(['Sparse Source (Kurtosis: ', num2str(kurt1, '%.1f'), ')']);
subtitle('ICA "loves" this: high contrast, low occupancy.');

subplot(1,2,2);
imagesc(S2); colormap('hot'); axis image;
title(['Diffuse Source (Kurtosis: ', num2str(kurt2, '%.1f'), ')']);
subtitle('ICA "hates" this: looks like a random mix.');

fprintf('Sparse Source Kurtosis: %.2f (High non-Gaussianity)\n', kurt1);
fprintf('Diffuse Source Kurtosis: %.2f (Near zero/Gaussian)\n', kurt2);

%%