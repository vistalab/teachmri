function  mat=row2mat(vec,rows,cols);
%
%  mat=row2mat(vec, rows,cols);
%  transforms a  rowvec of size 1 X rows*cols to a mat of size rows X cols 
%  
mat=zeros(rows,cols);
[r,c]=size(vec);
if r>c % vec is a  column vector
  vec=vec';
end
for i=1:rows
    mat(i,:)=vec((i-1)*cols+1:i*cols);
end