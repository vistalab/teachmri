function y = sincFunction(x)
% Local version of sinc function.  In Matlab sinc() is in the signal
% processing toolbox.  Not everyone has it.
%
%

i=find(x==0); x(i)= 1;                              
y = sin(pi*x)./(pi*x);                                                     

y(i) = 1;   

return;
