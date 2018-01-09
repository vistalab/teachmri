%function [c, estim]=linear_coef(fMRsig,ng,szdat,tr,delay,sigma,gain)

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
% fMRsig   - the estimates of the frmi signal amd the tr locations
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
% c       - the linear combination coefficients (a column vector) 
% estim   - the estimated signal from the least squares approximation
%

%if nargin <4
%  % enter default parameters
%  delay=4.8
%  gain=4.9598
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

M=zeros(sb,sb);
for i=1:sb
	for k=1:sb
		M(i,k)=(G(:,i))'*G(:,k);
	end
end

for k=1:sb
%	b(k,1)=(fMRsig)'*G(:,k);
	b(k,1)=fMRsig*(G(k,:))';
end

% inverse the matrix by "PINV" to find coefficients.
%-----------------------------------------------------------

%INV_M=pinv(M);
sprintf('inversed matrix \n')

% get the coefficients of the RBF
%--------------------------------- 
% c - the coefficients vector determined by our data estimates .
%------------------------------------------------------------------------

%c=INV_M*b;
%c=c./1e10;
c=fMRsig*pinv(G)
sprintf('calculated coef \n')
%estim=c'*G;
estim=c*G;
estim1=ones(1,ng)*G;

figure(3)
clf;
plot(t,G','LineWidth',3)
figure(4)
clf;
plot(t,estim,'c-.','LineWidth',3)
hold
plot([0:1:szdat-1],fMRsig)
plot(t,estim1,'r--','LineWidth',3)


