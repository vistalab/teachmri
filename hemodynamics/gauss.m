function g=gauss(x,xc,var)

% NAME   : gauss ;
% FORMAT : g=gauss(x,xc,var);
% PURPOSE: calculate the values of a gauss basis at point x.
% INPUT	 : x   - the point in which to calculate the base functions. 
%          xc  - the centers of the basis functions
%	   var - the variances of each basis function
% RETURNS : g
 


if size(var)~=size(xc),
 	sprintf('function gauss:: var and xc are not of the same length')
	break
end

X=x*ones(size(xc));
g=exp(-((xc-X).^2)./(2*var) );
