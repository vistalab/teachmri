%% Linear model image

t = linspace(0,2*pi,128);
f = [1 2 3 4 5];

mrvNewGraphWin;
ii = 0;
for ff = f
    plot(t,cos(t*ff) + ii,'b'); hold on;
    ii = ii + 2;
    plot(t,sin(t*ff) + ii, 'k--'); hold on;
    ii = ii + 3.5;
end
xlabel('t (sec)')
ylabel('S(t) displaced for clarity')
legend({'cos','sin'})

%% Make the 2d basis images

sz = 128;
[x, y] = meshgrid(1:sz, 1:sz);
f1 = 7; f2 = 7;
% Calculate the image data. Note the use of meshgrid's x and y
img = sin(2 * pi * (f1 * x / sz + f2 * y / sz));

mrvNewGraphWin;
imagesc(img);
colormap(gray);
axis image
axis off
