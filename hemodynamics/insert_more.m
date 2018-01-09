function [xc, estimate,weights]=insert_more(place,dat,szdat,env_dat,goodness,delta)
%
% Inserts more data points if they are futher away than delta
% The new data points are calculated by linearly interpolating the old data
% points.
%
% FORMAT:
% [xc, estimate,weights]=insert_more(place,dat,szdat,env_dat,goodness,delta)
%
% INPUT:	
% place   : the vector of cumulative time, contains spike loactions.
% dat     : ISI vectors.		
% szdat   : number of spikes to use.
% env_dat : the gross estimates of the rate, lamda.
% goodness: an estimate on the goodness of our gross_estimate.
% delta   : the control  parameter, if the ISI > delta insert more data.
% 
% OUTPUT:
% xc      : the vector of rbf locations
% estimate: the updated data vector
% weights : the updated weights for the estimate

%initialize
k=1;
num_spikes=floor(dat(1)/delta);	
if num_spikes>=1
	sprintf('num_spikes=%d',num_spikes);
	for j=1:num_spikes+1
		xc(k,1)=(j-1)*delta;
		estimate(k,1)=xc(k,1)*env_dat(1);
		estimate(k,1)=estimate(k,1)/dat(1);
		weights(k,1)=xc(k,1)*goodness(1);
		weights(k,1)=weights(k,1)/dat(1);
		sprintf('xc=%d,estimate=%f',xc(k,1),estimate(k,1));
		k=k+1;	
 	end % for loop
else
	xc(k,1)=place(1);
	estimate(k,1)=env_dat(1);
	weights(k,1)=goodness(1);		
	k=k+1;
 	
end
i=1;
while i<szdat
	sprintf('i=%d',i);
	num_spikes=floor(dat(i+1)/delta);	
	if num_spikes>=1
		sprintf('num_spikes=%d',num_spikes);
		for j=1:num_spikes+1
			xc(k,1)=place(i)+(j-1)*delta;
			estimate(k,1)=(xc(k,1)-place(i))*env_dat(i+1)+(place(i+1)-xc(k,1))*env_dat(i);	
%			estimate(k,1)=estimate(k,1)/(place(i+1)-place(i));
			estimate(k,1)=estimate(k,1)/dat(i+1);
			weights(k,1)=(xc(k,1)-place(i))*goodness(i+1)+(place(i+1)-xc(k))*goodness(i);
%			weights(k,1)=weights(k,1)/(place(i+1)-place(i));
			weights(k,1)=weights(k,1)/dat(i+1);
			sprintf('xc=%d,estimate=%f',xc(k,1),estimate(k,1));
			k=k+1;	
 		end % for loop
	else
		xc(k,1)=place(i);
		estimate(k,1)=env_dat(i);
		weights(k,1)=goodness(i);		
		k=k+1;
 	

	end
i=i+1;
end










