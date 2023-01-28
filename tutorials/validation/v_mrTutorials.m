%% Execute the Psych 204A tutorials
% 
%
% Wandell, 2019

%% Will add more validation tests within later

chdir(fullfile(mrTeachRootPath,'tutorials'));
files = dir('tls_*.mlx');
for ii=7:numel(files)
    fprintf('Validating %s ',files(ii).name);
    run(files(ii).name);
    fprintf('\n');
end

fprintf('Done\n');

%% END