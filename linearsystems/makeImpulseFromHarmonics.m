%
% Make movie showing sum of cosinusoids producing an impulse
%

%% X-dimension
x = [1:128]/128;
x = x - 0.5;

%% Show a couple of sums to illustrate cancellation
ff = 1;
vcNewGraphWin
Z1 = cos(2*pi*ff*x);
p = plot(x,Z1,'r:');
set(p,'linewidth',2);
l = line([-.5 .5],[0 0],'color','k'); set(l,'linewidth',2);
grid on

ff = 2;
vcNewGraphWin
Z2 = cos(2*pi*ff*x);
p = plot(x,Z2,'m:')
set(p,'linewidth',2);
l = line([-.5 .5],[0 0],'color','k'); set(l,'linewidth',2);
grid on

vcNewGraphWin
p = plot(x,(Z1 + Z2)/2,'b',x,Z1,'r:',x,Z2,'m:');
set(p,'linewidth',2);
l = line([-.5 .5],[0 0],'color','k'); set(l,'linewidth',2);
grid on


%% Cumulate cosinusoids
fName = 'impulseFromHarmonics.gif';
nFrames = 128;
Z = cos(2*pi*x);
plot(x,Z)
%  axis tight
set(gca,'xlim',[-0.5 0.5],'ylim',[-1 1]);
% set(gca,'nextplot','replacechildren','visible','off')
set(gca,'nextplot','replacechildren')
f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,nFrames) = 0;
%%
Z = zeros(1,nFrames);
for k = 1:nFrames
    Z = (Z + cos(2*pi*k*x)); 
    plot(x,Z/k)
    f = getframe;
    im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end
imwrite(im,map,fName,'DelayTime',0.2,'LoopCount',inf) %g443800
%%
fName = 'summingHarmonics.gif';
nFrames = 128;
figure;
Z = cos(2*pi*x);
plot(x,Z)

set(gca,'xlim',[-0.5 0.5],'ylim',[-1 1]);
set(gca,'nextplot','replacechildren')
f = getframe;

[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,nFrames) = 0;
%%
figure(1); clf
Z = zeros(1,nFrames);
for k = 1:16
    Z = cos(2*pi*k*x); 
    if ( k== 1 || ~mod(k,4))
        hold on; plot(x,Z,'linewidth',2); saveas(gcf,sprintf('tmp%.0d',k),'jpg'); 
    end
end
% imwrite(im,map,fName,'DelayTime',0,'LoopCount',inf) %g443800
%%
% movie(F)

Z = peaks; 
surf(Z)
axis tight
set(gca,'nextplot','replacechildren','visible','off')
f = getframe;
[im,map] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,20) = 0;
for k = 1:20 
  surf(cos(2*pi*k/20)*Z,Z)
  f = getframe;
  im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end
imwrite(im,map,'DancingPeaks.gif','DelayTime',0,'LoopCount',inf) %g443800

%% I think this works in recent Matlab
% http://www.mathworks.com/help/techdoc/import_export/f5-132794.html#f5-147
% 068, but not for Matlab 2008a
myVideo = VideoWriter('impulseCreate.avi');
myVideo.FrameRate = 15;  % Default 30
myVideo.Quality = 50;    % Default 75

open(myVideo)
writeVideo(myVideo, F);
close(myVideo);

%% http://www.mathworks.com/help/techdoc/ref/videowriter.writevideo.html
% Prepare the new file.
vidObj = VideoWriter('peaks.avi');
open(vidObj);

% Create an animation.
Z = peaks; surf(Z); 
axis tight
set(gca,'nextplot','replacechildren');

for k = 1:20 
   surf(sin(2*pi*k/20)*Z,Z)
   
   % Write each frame to the file.
   currFrame = getframe;
   writeVideo(vidObj,currFrame);
end

% Close the file.
close(vidObj);


