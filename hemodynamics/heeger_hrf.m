function [hrf, t1] = heeger_hrf(t,delta,tau)
% HRF from the heeger & boynton paper 1996
%
% hrf = heeger_hrf(t,delta,tau);
%
% Example:
%  [hrf, t] = heeger_hrf(1:10); plot(t,hrf)
%

% default HRF values
if notDefined('t'), error('Time steps needed'); end
if notDefined('delta'), delta = 2.5;  end
if notDefined('tau'),   tau   = 1.25; end

t1 = (t-delta*ones(size(t)))/tau;

try     
    hrf = gampdf(t1,3);
catch
    hrf = localGampdf(t1,3);
end


return

