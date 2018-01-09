function res = convolution(sig,kernel)
%
%    res = convolution(sig,kernel)
%
%Author: Wandell
%Purpose:
%   Convolve (symmetric, same size) sig with kernel.  
% The center position of the kernel (zero phase shift) is the middle 
% of the array. So, if kernel = [0 0 1 0 0] the result will be equal 
% to the signal.
%
% Example:
%   sig = randn([1,10]);
%   kernel = [0 1 0];
%   res = convolution(sig,kernel);
%   clf; plot(sig,'r-'),hold on,plot(res,'bo')

res = imfilter(sig,kernel,'same','conv','symmetric');

return;

[X Y] = meshgrid(1:128,1:128);
sig = sqrt(X.^2 + Y.^2);
kernel = zeros(21,21);
kernel(11,11) = 1;
res = convolution(sig,kernel);
subplot(1,2,1); imagesc(res); colormap(gray); title('Result')
subplot(1,2,2); imagesc(sig); colormap(gray); title('Signal')
max(abs(sig(:) - res(:)))
