function [kspace, M] = kspaceShowPlots(f, spins, gradients,...
    kspace, im, params, t, b0noise, M)  
% [kspace M] = kspaceShowPlots(f, spins, gradients,...
%    kspace, im, params, t, b0noise, M)

% if we are not done filling kspace, and we are not showing step by step
% progress, then return without doing anything
if t < length(kspace.vector.x) && params.showProgress == false
    return;
end

% Otherwise recon and plot!
kspace = kspaceRecon(kspace, params);

% ********************************
% Image and Recon
% ********************************

% set up plots and subplots
rows = 3; cols = 2; n = 1;


% Check to see if this is the first time we are plotting this recon. If so,
% we will need to set up the plots. If not, we can skip some steps.
userData  = get(f, 'UserData');
if isfield(userData, 'initialized') && t > 1
    initialize = false;
    subplot_handle = userData.subplot_handle;
else
    initialize = true;
    userData.initialized = true;
    set(f, 'UserData', userData);
end

if initialize, figure(f); colormap (gray); end
figure(f)
%-----------------------------------
% Plot 1: kspace filled by imaging
%-----------------------------------
tmp = fftshift(log(abs((kspace.grid.real + 1i*kspace.grid.imag))));
x = fftshift(kspace.grid.x);
y = fftshift(kspace.grid.y);
ma = max([tmp(isfinite(tmp)); 0]);
mi = min([tmp(isfinite(tmp)); 0]);
if ma <= mi, ma = 1; mi = 0; end
set(gca, 'CLim', [mi ma]);
if initialize
    subplot_handle(n) = subplot(rows,cols,n);
    cla
    axis image;
    imagesc(x(:), y(:), tmp);
    title('kspace filled by imaging')
    xlabel('cycles per meter'); ylabel('cycles per meter')
    hold on;
else
    axes(subplot_handle(n));
    imagesc(x(:), y(:), tmp);
end
n= n+1;

%-----------------------------------
% Plot 2: image reconned from kspace
%-----------------------------------

recon = abs(ifft2(kspace.grid.real + 1i*kspace.grid.imag));
imsize = [0 params.imSize*100];
if initialize
    subplot_handle(n) = subplot(rows,cols,n);
    cla
    imagesc(imsize, imsize, recon);
    axis image;
    title('image reconned from kspace')
    xlabel('mm'); ylabel('mm')
    grid on
    ticks = linspace(0, max(imsize), 11);
    set(gca, 'YTick', ticks)
    set(gca, 'XTick', ticks);
    set(gca, 'GridLineStyle', '-')
    set(gca,'Xcolor',[1 1 1]);
    set(gca,'Ycolor',[1 1 1]);
    hold on;
else
    axes(subplot_handle(n));
    imagesc(imsize, imsize, recon);
end
n= n+1;

%-----------------------------------
% Plot 3: kspace computed from image
%-----------------------------------
if initialize
    subplot_handle(n) = subplot(rows,cols,n);
    cla
    imagesc(x(:), y(:), im.fftshift);
    axis image;
    title('kspace computed from image')
    xlabel('cycles per meter'); ylabel('cycles per meter')
    hold on;
  
end 
n= n+1;

%-----------------------------------
% Plot 4: Original Image
%-----------------------------------1
if initialize
    subplot_handle(n) = subplot(rows,cols,n);
    cla
    imagesc(imsize, imsize, im.orig);
    axis image;
    title('Original Image');
    xlabel('mm'); ylabel('mm')
    grid on
    set(gca, 'YTick', ticks)
    set(gca, 'XTick', ticks);
    set(gca, 'GridLineStyle', '-')
    set(gca,'Xcolor',[1 1 1]);
    set(gca,'Ycolor',[1 1 1]);
    hold on;
end
n= n+1;

% ********************************
% Gradients & Spins
% ********************************

%-----------------------------------
% Plot 5: Sinusoidal spin channel
%-----------------------------------

if initialize
    subplot_handle(n) = subplot(rows,cols,n);
    cla
    imagesc(real(spins.total));    
    axis image off; hold on;     
else
    axes(subplot_handle(n));
    imagesc(real(spins.total));    
end
title(sprintf('REAL: x=%2.1f cpm, y=%2.1f cpm', kspace.vector.x(t), kspace.vector.y(t)));
n= n+1;

% ********************************
% B0 Map
% ********************************

if initialize
    subplot_handle(n) = subplot(rows,cols,n);

    cla
    imagesc(imsize, imsize, b0noise)
    axis image;
    rg = [-1 1] * max(abs(b0noise(:))); if all(rg==0), rg = [-1 1]*eps; end
    set(gca, 'CLim', rg)
    noiseMin = rg(1) * params.gamma / (2 * pi);
    noiseMax = rg(1) * params.gamma / (2 * pi);
    title(sprintf('B0 map. Range = [%2.1f %2.1f] Hz', noiseMin, noiseMax))
    xlabel('mm'); ylabel('mm')
    grid on
    set(gca, 'YTick', ticks)
    set(gca, 'XTick', ticks);
    set(gca, 'GridLineStyle', '-')
    set(gca,'Xcolor',[1 1 1]);
    set(gca,'Ycolor',[1 1 1]);
    hold on;

end
n= n+1;


if initialize
    userData.subplot_handle = subplot_handle;
    set(f, 'UserData', userData);    
end

drawnow;

%%
figure(f+1)

userData  = get(f+1, 'UserData');
if ~initialize
    subplot_handle = userData.subplot_handle;
end

%-----------------------------------
% Gradients
%-----------------------------------
if initialize
    subplot_handle(1) = subplot(2,1,1);
    cla
    axis tight ; 
    ylim([-1.1 1.1]*max(gradients.x));
    xlim([0 sum(gradients.T)]);
    title('Gradients');
    hold on;
    plot([0 cumsum(gradients.T(1:t))], [gradients.y(1) gradients.y(1:t)], 'g-', 'LineWidth', 1);
else
    axes(subplot_handle(1))
    plot([0 cumsum(gradients.T(1:t))], [gradients.y(1) gradients.y(1:t)], 'g-', 'LineWidth', 1);
end




if initialize,
    subplot_handle(2) = subplot(2,1,2);
    cla
    axis tight ; 
    ylim([-1.1 1.1]*max(gradients.x));
    xlim([0 sum(gradients.T)]);
    title('Gradients');
    hold on
    plot([0 cumsum(gradients.T(1:t))], [gradients.x(1) gradients.x(1:t)], 'r-', 'LineWidth', 1);
else
    axes(subplot_handle(2))
    plot([0 cumsum(gradients.T(1:t))], [gradients.x(1) gradients.x(1:t)], 'r-', 'LineWidth', 1);
end

if initialize
    userData.subplot_handle = subplot_handle;
    set(f+1, 'UserData', userData);    
end



end
