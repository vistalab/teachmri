function [hemo_res_int]= intrp_hemo(hemo_response,tr);

nl=length(hemo_response);

hemo_res_int=zeros(1,nl*tr);
hemo_res_int(1)=hemo_response(1);
trcount=0;
for i=1:nl*tr-2
  if i==1
    alpha=(i-tr)/tr
    trcount=1
  else
    trcount=fix(i/tr);
  end
  alpha=(i-(trcount*tr))/tr
      hemo_res_int(i+1)=(1-alpha)*hemo_response(trcount+1)+alpha*hemo_response(trcount+2)
    
end

hemo_res_int(nl*tr)=hemo_response(nl);
