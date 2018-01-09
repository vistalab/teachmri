function mrTeachInit(rootDir)
% Initialize the directory path for the MR Tutorial files
%
%    mrTeachInit([rootDir])
%
% This routine only initializes the paths for the teaching directories.  It
% does not include the initialization needed for mrVista tutorials.  (It
% could, some day).
%
% The main tutorial files should all begin with mrTut
%
% Examples:
%   mrTeachInit('C:\u\brian\Matlab\SVN\teaching\psych204')
%   mrTeachInit(pwd);
%


if ~exist('rootDir','var') || isempty(rootDir)
    rootDir = mrTeachRootPath;
end
addpath(genpath(rootDir));

% fprintf('\n\n ******************** Welcome to the mrVista tutorial! ******************** \n\n');
% fprintf('\n\n Adding paths first... when this gets done a web browser will open up. \n');
% fprintf('\n\n The walkthrough will be on this webpage. \n');
% fprintf('\n\n (The URL is http://white.stanford.edu/~sayres/psy204/mrVistaTutorial.htm). \n');
% fprintf('\n\n Paste ''web http://white.stanford.edu/~sayres/psy204/mrVistaTutorial.htm -browser'' to open this in an external browser. \n');
% addpath(genpath('Z:\data\VISTASOFT\Anatomy\'));
% addpath(genpath('Z:\data\VISTASOFT\mrLoadRet-3.0\'));
% addpath(genpath('Z:\data\VISTASOFT\Filters\'));
% addpath(genpath('Z:\data\VISTASOFT\Teaching\'));
% web http://white.stanford.edu/~sayres/psy204/mrVistaTutorial.htm 

return