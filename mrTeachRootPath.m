function rootPath= mrTeachRootPath()
%
%        rootPath =mrTeachRootPath;
%
% Determine path to MR teaching directory
%
% This function MUST reside in the directory at the base of the VISTA
% teaching directory structure 
%

rootPath=which('mrTeachRootPath');

rootPath=fileparts(rootPath);

return
