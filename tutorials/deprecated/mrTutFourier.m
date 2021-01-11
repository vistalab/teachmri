%% Make some FT pictures
%
%  1.  The harmonics in (fx,fy) which are also referred to as (kx,ky)
%  by the MRI community
%  2.  
%
% BW, Vistasoft Team, 2018

%% A harmonic in the X dimension
nSamp = 512;
x = linspace(1/nSamp,1,nSamp); y = x;
fx = 32;
fy = 0;
[X,Y] = meshgrid(x,y);
im = sin(2*pi*(fx*X + fy*Y));

imagesc(im); colormap(gray);

%%
imFT = abs(fft2(im));
imFT = fftshift(imFT);

mp = colormap(cool);
mp(1:20,:) = repmat([0.1,0.2,0.3],20,1);
imagesc((x - 0.5)*(nSamp/2), (y - 0.5)*(nSamp/2), imFT.^0.3); colormap(mp);
grid on; truesize
set(gca,'GridColor',[0.9 0.9 0.9]);
xlabel('f_x'); ylabel('f_y');
% mesh(imFT)

%%
fy = 48;
fx  = 0;
im = sin(2*pi*(fx*X + fy*Y));
imagesc(im); colormap(gray); colorbar;

%%
imFT = abs(fft2(im));
imFT = fftshift(imFT);

imagesc((x - 0.5)*(nSamp/2), (y - 0.5)*(nSamp/2), imFT.^0.3); colormap(mp);
grid on;  truesize
set(gca,'GridColor',[0.9 0.9 0.9])

%%
fy = 48;
fx = 32;
im = sin(2*pi*(fx*X + fy*Y));
imagesc(im); colormap(gray); colorbar;

%%
imFT = abs(fft2(im));
imFT = fftshift(imFT);

imagesc((x - 0.5)*(nSamp/2), (y - 0.5)*(nSamp/2), imFT.^0.3); colormap(mp);
grid on; truesize
set(gca,'GridColor',[0.9 0.9 0.9]);
xlabel('f_x'); ylabel('f_y');
