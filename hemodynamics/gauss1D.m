function g=gauss1D(t,to,sigma)
%
% One dimension gaussian: g=gauss1D(t,to,sigma)
% such that its sum equal 1
%  INPUTS:
%  t            time
%  to           coordinate of the center of the gaussian
%  sigma        sqrt of variance of the guassian
%  
% OUTPUT:
% g               1D  guassian

g=exp(-((t-to).^2)/(2*sigma*sigma));
%g=g/length(t);
%sum_of_elmts=sum(sum(g));
%g=g/sum_of_elmts;
