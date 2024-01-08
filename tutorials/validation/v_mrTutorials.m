%% Execute the Psych 204A tutorials
% 
% The tutorials are all live scripts now.
%
% This is not really a validation.  All it does is check that the
% scripts run.  Perhaps there should be some ieValidate()
% implementation.  But we don't have that yet.
%
%
% See also
%

%% To add more validation tests 

chdir(fullfile(mrTeachRootPath,'tutorials'));
files = dir('t_*.mlx');
for ii=1:numel(files)
    fprintf('Validating %s ',files(ii).name);
    run(files(ii).name);
    fprintf('\n');
end

fprintf('Done\n');

%% END