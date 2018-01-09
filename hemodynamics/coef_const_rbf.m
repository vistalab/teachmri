function [c,xc,var]=coef_const_rbf(env_dat,dat,place,szdat,delta)
% Method 1
%----------------------------------------------------------------------------
% calculate rbf coefficients by placing constantly spaced gaussian functions,
% with a constant variance
% estimate the rate values at the locations of the gaussians by first order
% ( linear interpolation)
% format c=coef_const_rbf(env_dat,dat,szdat,delta)
% INPUT
% env_dat - the estimates of the envelopes at the spikes' locations
% dat     - interspike intervals
% place   - the times of the spikes
% szdat   - length of dat, place and env_dat
% delta   - the distance between the basis function centers
% OUTPUT
% c       - the linear combination coefficients ( a column vector) 
% xc      - the centers of the gaussians ( a column vector) 
% var     - the variances of the gaussians ( a column vector) 
%----------------------------------------------------------------------------

% calculate the estimate at the first locations xc(k,1) <place(1)
%----------------------------------------------------------------
i=1;
k=1;
var_v=(8*delta)^2;
while k*delta<=place(1)
	xc(k,1)=k*delta;
	var(k,1)=var_v;
	estimate(k,1)=env_dat(1)*xc(k,1)/dat(1);
	sprintf('xc(%d)=%d place(%d)=%d\n',k,xc(k,1),i,place(i));
	k=k+1;
end;

% calculate the estimate at the rbf centers for i>1
% ------------------------------------------------
i=2;	
while i<=szdat
	if k*delta>place(i) & (k-1)*delta>=place(i-1) %delta is larger then the interval between spikes
		tmp=[env_dat(i)];
		interval=dat(i);
		sprintf(' interval less than delta i=%d\n',i)
		i=i+1;
		while k*delta>place(i)
			if i>=szdat
				break;
			else
				tmp=[tmp, env_dat(i)];
				interval=interval+dat(i);
				i=i+1;
			end
		end;
		 % increment i till k*delta is larger than place(i)
		while k*delta>place(i-1) & k*delta<=place(i)
			xc(k,1)=k*delta;
			var(k,1)=var_v;
			estimate(k,1)=mean(tmp);
			sprintf('xc(%d)=%d place(%d)=%d)\n',k,xc(k,1),i,place(i));
			k=k+1;
		end;
		i=i+1;
	else % (place(i-1)<k*delta<place(i)
		while k*delta>place(i-1) & k*delta<=place(i)
			xc(k,1) = k*delta;
			var(k,1) = var_v;
			sprintf('xc(%d)=%d place(%d)=%d\n',k,xc(k,1),i,place(i));
%first order interpolation
%--------------------------
			estimate(k,1)=env_dat(i)*(xc(k,1)-place(i-1))+env_dat(i-1)*(place(i)-xc(k,1));
			estimate(k,1)=estimate(k,1)/dat(i);  %env(xc(k,1)); %
						
%zero order interpolation	estimate(k,1)=env_dat(i);  
			k=k+1;
		end % while
		i=i+1;
	end % if else
end; % while
sprintf('finished to estimate envelope at basis functions\n')


% add gaussian at zero
%---------------------
xc=[0;xc;place(szdat)];
var=[(2*delta)^2; var;(2*delta)^2];
estimate=[estimate(1);estimate;env_dat(szdat)];

% set number of functions  
%-------------------------
[sb col]= size(xc);
sprintf('size of basis =%d\n',sb)


% build the linear system
%-------------------------
G=zeros(sb,sb);
for i = 1:sb
	G(i,:) = gauss(xc(i),xc,var)';
end;
sprintf('finished to make  basis functions\n')

% introduce eps in diagonal to make solution more stable
for i = 1:sb
	G(i,i) = G(i,i)+eps;
end;

% inverse the matrix by "PINV" to find envelope coeficients.
%-----------------------------------------------------------

INV_G=pinv(G);
sprintf('inversed matrix \n')

% get the coeficients of the RBF
%--------------------------------- 
% c      - the coeficients vector determined by our data estimates .
% real_c - the coeficients vector determined by the envalope estimates .
%------------------------------------------------------------------------

c=INV_G*estimate; 



