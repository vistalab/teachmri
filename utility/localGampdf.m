function y = localGampdf(x,a,b)
% Gamma pdf ... replaces Mathworks function if you don't have the toolbox
% 
% Example:
%  x = 1:5; a = 1; b = 1;
%  localGampdf(x,a,b)
%
% Compare with Mathworks
%  b = 1:5; x = 1; a = 1;
%  localGampdf(x,a,b)
%  0.3679  0.3033  0.2388  0.1947  0.1637
%
% We need more comparisons
%

if notDefined('a'), a = 1; end
if notDefined('b'), b = 1; end

y = ((b.^a)*gamma(a)).^-1  * x.^(a-1) .* exp(-x./b);

return
