function  rowvec=mat2row(mat, rows,cols);
%
%  rowvec=mat2row(mat, rows,cols);
%  transforms a mat of size rows X cols to a rowvec of size 1 X rows*cols
%  
rowvec=zeros(1,rows*cols); %malloc

for j=1:rows
  rowvec(1,(j-1)*cols+1: j*cols)=mat(j,:);
end

