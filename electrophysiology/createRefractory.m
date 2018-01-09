function refractory = createRefractory(t,pTau,pScale)
%
%


refractory = pScale*exp(-t/pTau)';


end
