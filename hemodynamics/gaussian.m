function g=gaussian(x,xo,y,yo,sigma)
%
% two dimension gaussian: g=gaussian(x,xo,y,yo,sigma)
%
%  INPUTS:
%  x,y            coordinates
%  xo,yo          coordinates of the center of the gaussian
%  sigma          sqrt of variance of the guassian
%  
% OUTPUT:
% g               2D  guassian

g=exp(-((x-xo).^2+(y-yo).^2)/(2*sigma*sigma));

sum_of_elmts=sum(sum(g));
g=g/sum_of_elmts;