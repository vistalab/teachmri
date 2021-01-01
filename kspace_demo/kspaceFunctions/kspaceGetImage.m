function im = kspaceGetImage(k)
%
%
%
% JW, Vistasoft, 2009

imfile = k.imfile;
sz     = k.imFreq; % this is the number of pixels along one side of the image (assumed to be square)

% if not a default image, let user select it from prompt
if strcmpi(imfile, 'other')
    while ~exist('fname', 'var') || isequal(fname,0) %#ok<NODEF>
        [fname,pth] = uigetfile('*.*', 'Pick any image');
    end
     imfile = fullfile(pth, fname);
end

% get the image
im.orig     = imread(imfile);

% make sure it is gray scale
if length(size(im.orig)) > 2, im.orig = rgb2gray(im.orig); end

% rescale to desired resolution
im.orig     = imresize(im.orig, [sz, sz]);

% it will be convenient to have the image defined as a double column vector
%   for calculating dot products
im.vector   = double(im.orig(:))';

% calculate fft now and store it, so we don't have to do this again
im.fft      = fft2(im.orig);

% this is a nice way to view the fft of the image. calculate it once now
% so we don't have to do it again.
im.fftshift = fftshift(log(abs(im.fft)));

end
