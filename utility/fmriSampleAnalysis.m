load fmriRaw.mat;

clipRng = [400 1400];
cmap = gray(256);
sl = [16:23];
sl = [1:26];
sl = 16;

for(frameNum=1:size(raw,4))
  im = makeMontage(abs(raw(:,:,:,frameNum)),sl);
  im(im>clipRng(2)) = clipRng(2); 
  im(im<clipRng(1)) = clipRng(1); 
  im = im-clipRng(1);
  im = uint8(im./diff(clipRng)*255+0.5);
  m(frameNum) = im2frame(im, cmap);
end

figure;image(m(1).cdata); axis image; truesize; colormap(cmap);
movie(m,5);

figure;imagesc(abs(raw(:,:,17,1))); axis image; colormap gray;
vox = [113,65,17];
plot(abs(squeeze(raw(vox(1),vox(2),vox(3),:))))


figure;imagesc(makeMontage(abs(raw(:,:,:,1)))); axis image; colormap gray;
