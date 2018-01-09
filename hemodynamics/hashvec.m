function [conds, ncolors]=hashvec(colors,epochs);

% This function divides the relevant epochs into groups
% where each group contains epochs having the same color
% as defined by the colors vector in the parameter file
%
% Writen by Kalanit Grill Spector. Aug 1998
%
% INPUT
%
% colors      The colors vector Nepochs x 3 (rgb)
% epochs      The vector containing the epoch number corresponding to each color
%
%
% OUTPUT     
% conds       vector of length nepochs where each epoch is assigned a group number


hash=zeros(1110,1);

[Nepochs,p]=size(colors);
conds=zeros(Nepochs,1);
ncolors=1;
for i=1:Nepochs
  entry=sum([1000 100 10].*colors(i,:));
  if hash(entry)==0
    hash(entry)=ncolors;
    ncolors=ncolors+1;
    conds(i)=hash(entry);
  else
    conds(i)=hash(entry);
  end
end


ncolors=ncolors-1;