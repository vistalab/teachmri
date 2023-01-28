%
% Make movie showing sum of cosinusoids producing an impulse
%

%% X-dimension
x = (1:128)/128;
x = x - 0.5;

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
%% Show sum of

v = VideoWriter('impulse','MPEG-4');
v.FrameRate = 5;
open(v);

mrvNewGraphWin;
Z = zeros(1,nFrames);
for k = 1:nFrames
    Z = (Z + cos(2*pi*k*x)); 
    plot(x,Z/k); 
    set(gca,'ylim',[-0.2 1]); 
    pause(0.1);  % Slow down for Matlab graphics to do its thing
    frame = getframe(gcf);
    writeVideo(v,frame);
end
close(v);

% imwrite(im,map,fName,'DelayTime',0,'LoopCount',inf) %g443800
%%

v = VideoWriter('sumHarmonics','MPEG-4');
v.FrameRate = 1;
open(v);

mrvNewGraphWin;
z0 = zeros(1,nFrames);
for k = 1:8
    Z = cos(2*pi*k*x); 
    if ( k== 1 || ~mod(k,2)),hold on; 
        plot(x,Z,'linewidth',2); plot(x,z0,'k--','linewidth',1);
        pause(1);
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end
close(v);

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
writeVideo(myVideo, f);
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


