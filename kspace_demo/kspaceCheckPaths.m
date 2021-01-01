function kspaceCheckPaths
%  kspaceCheckPaths
%
% Check to see that necessary subroutines are on our matlab path. This
% function has no inputs or outputs. It modifies the current paths.

if ~exist('kspaceParamsGUI.m', 'file'), 
    pth = fileparts(which(mfilename));
    addpath(fullfile(pth, 'kspaceFunctions')); 
end