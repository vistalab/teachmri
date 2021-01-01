function y=kaiser_bessel_kern(k,L,beta)
y=zeros(size(k));
indx=find(abs(k)<=L/2);
y(indx)=real((1/besseli(0,beta))*besseli(0,beta*sqrt(1-(2*k(indx)/L).^2)));
%y=real((1/L)*besseli(0,beta*sqrt(1-((2*k/L).^2))));
% for i=1:length(k)
%     if (k(i)<-L/2 | k(i)>L/2)
%         y(i)=0;
%     end
% end
% y=real(y);
