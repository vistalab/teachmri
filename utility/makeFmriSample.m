pfile = '/biac2/wandell2/data/reading_longitude/fmri/bg040805_MotDisc_noMcNeeded_useAll/Raw/Pfiles/P06144.7.bz2';
pfileDir = '.';
cd(pfileDir);

exec(['bunzip2 -c ' pfile ' > P06144.7']);
exec('./grecons_r66 -i12 P06144.7');

d = dir(fullfile(pfileDir,'*.7.*r'));
n = length(d);
[p,f,e]=fileparts(d(1).name)
baseName = [p f];

imSize = [128 128 26];
nFrames = n/imSize(3);
raw = complex(zeros([imSize nFrames]));

for(ii=1:nFrames)
  for(jj=1:imSize(3))
    imNum = (jj-1)*nFrames+ii;
    tmpR = readRawImage(sprintf('%s.%03dr',baseName,imNum),[],[],'l');
    tmpI = readRawImage(sprintf('%s.%03di',baseName,imNum),[],[],'l');
    raw(:,:,jj,ii) = complex(tmpR, tmpI);
  end
end
figure;imagesc(makeMontage(abs(raw(:,:,:,1)))); axis image; colormap gray;

notes = 'From bg040805 (motion scan on 12 year old)';

save('fmriRaw.mat','raw','notes','pfile');

