%% Make some FT pictures
%
%  Must do better over time.  Maybe not this year.
%
% Brian

%% A harmonic in the X dimension
x = linspace(0,1,512); y = x;
fx = 20;
fy = 0;
[X,Y] = meshgrid(x,y);
im = sin(2*pi*(fx*X + fy*Y));
imagesc(im); colormap(gray); colorbar;

%%
imFT = abs(fft2(im));
imFT = fftshift(imFT);
imagesc(imFT); colormap(cool)
mesh(imFT)

%%
fy = 12;
im = sin(2*pi*(fx*X + fy*Y));
imagesc(im); colormap(gray); colorbar;
%%
imFT = abs(fft2(im));
imFT = fftshift(imFT);
% imagesc(imFT); colormap(cool)
mesh(log10(imFT))