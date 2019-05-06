% Images for the Fourier Series
%
%  Set up the X and Y sample points.
%
x = (1:256)/256;
y = x;
[X, Y] = meshgrid(x,y);

fx = 15;  fy = 0;

im = sin(2*pi*(fx*X  + fy*Y)); 

mrvNewGraphWin; 
imagesc(im); colormap(gray); truesize;

%% Show the amplitude of the fourier transform
fftIMG = abs(fft2(im));
mrvNewGraphWin;
imagesc((-128:127),(-128:127),fftshift(fftIMG));
cmap = [0 .2 .4; .2 .2 .4; .3 .3 .4; 1 .3 .4];
colormap(cmap)
grid on; set(gca,'GridColor',[1 1 1]); axis square


%% Add a few harmonics together to start to form a line ...

% Initiate the im
fx = 0; fy = 0; im = cos(2*pi*(fx*X  + fy*Y));

for fx = 1:10
    im = im + cos(2*pi*(fx*X  + fy*Y));
end

mrvNewGraphWin([],'tall'); 
subplot(3,1,1)
colormap(gray); 
imagesc(fftshift(im))

% Now the next 20
for fx = 11:30
    im = im + cos(2*pi*(fx*X  + fy*Y));
end

subplot(3,1,2)
colormap(gray); 
imagesc(fftshift(im)); 

% Now the next 20
for fx = 31:128
    im = im + cos(2*pi*(fx*X  + fy*Y));
end

subplot(3,1,3)
colormap(gray); 
imagesc(fftshift(im));

%%
