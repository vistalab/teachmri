function [hirf, parms] = fristonHIRF(t,parms)
%
%    [hirf, parms] = fristonHIRF(t,parms)
%   
%    hirf = fristonHIRF(t,parms);
%
%Author:  Wandell
%Purpose: Illustrate Friston-Worsley HIRF.  I think this is defined in a
%Worsely chapter in that Toga book.  Or at least it is defined online, or
%hopefully in one of the readings for Psych 204.  Figure it out.  Write
%down the answer here.
%   

disp('Friston-Worsley HIRF')

if nargin < 2,  
    a(1) = 6; a(2) = 12;
    b(1:2) = 0.9;
    c = 0.35;
else
    a = parms.a; b = parms.b; c = parms.c;
end

for ii = 1:2
    d(ii) = a(ii)*b(ii);
end

% t = 0:.1:10;

parms.a = a;
parms.b = b;
parms.c = c;

hirf = (t/d(1)).^a(1).*exp(-(t - d(1))/b(1)) - c*(t/d(2)).^a(2).*exp(-(t-d(2))/b(2));

return;
