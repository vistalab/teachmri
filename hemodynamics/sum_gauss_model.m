function  [estim,t]=sum_gauss_model(ng,szdat,tr,delay,sigma,gain)

%-----------------------------------------------------------------------------
% calculate linear coefficients of response to long visual
% stimulatiom by linear combinations of single hemodynamic responses.
% The consecutive visual stimuli are assumed to be consectutively spaced.
% [c, estim]=linear_coef(fMRsig,ng,szdat,[delay],[sigma],[gain])
% Method:
% The coefs are calculated using the measured fMRI response and
% a guassian model for hemodynamic response
% 
% FORMAT:
% 
% INPUT
% ng       - the number of gaussians
% szdat    - length of fMRsig
% tr       - tr
% Hemodynamic response parameters modeled as a gaussian with dispersion
% sigma, delay to and gain.
% delay       - the delay of hemodynamic response
% sigma    - the sigma of the gaussians. (Default 1.8)
% gain     - gain of the gaussian. (Default 4.95)
%
% OUTPUT
%
% estim   - the estimated signal from the least squares approximation
%

%if nargin <4
%  % enter default parameters
%  delay=4.8
%  gain=1.6507
%  sigma=1.8
%end

%----------------------------------------------------------------------------
% create vectors of gaussian centers and variances
%----------------------------------------------------------------
xc=[delay:1:delay+ng-1]';
t=[ 0:tr:(szdat-1)*tr];

% set number of functions  
%-------------------------
[sb col]= size(xc);

% build the linear system:
%-------------------------------------------------------------------------
% G - the matrix containing the basis vectors
% M - the autocorrelation matrix
% b - the crosscorrelation between basis and output on data set
%---------------------------------------------------------------------------

G=zeros(sb,szdat);
for i = 1:sb
	G(i,:) = gain*gauss1D(t,xc(i),sigma);
end;
sprintf('finished to make  basis functions\n')


estim=ones(1,ng)*G;



