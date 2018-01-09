% ncolors or color
% prefix
% n_subjects
% path_name



[conds, ncolors]=hashvec(colors,epochs);

reps=zeros(ncolors,1);
all_cond=[];
for color1=1:ncolors
  ii=find(conds==color1);
  which_epoch=epochs(ii);
  reps(color1)=length(ii);
end
all_reps=[];

%color=input(' which condition? ' )

for i=1:n_subjects
  for j=1:reps(color)
    filename=[prefix '_sbj' num2str(i) '_cond' num2str(color) '_rep' num2str(j) '.tc']
    eval(['load ' path_name filename])
    x2=eval(filename(1:19));
    all_reps=[ all_reps x2];
  end
end




figure(2);clf;
plot(all_reps)
hold;
mean_rep=mean(all_reps');
ll=length(mean_rep);
t1=0:1.5:1.5*(ll-1)
plot(mean_rep,'LineWidth',4)
set(gca,'Xtick',1:ll,'XtickLabels',t1)
hold