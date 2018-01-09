function y=gamma1D(t,delta,tau,n)

y=((((t-delta)/tau).^(n-1)).*exp(-((t-delta)/tau)))/(prod(n-1)*tau);


