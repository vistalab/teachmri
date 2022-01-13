function val = mrSignalEquations(sequence,varargin)
% From sequence and tissue parameters and calculate signal values
%
% Brief
%    Implementation of basic signal equations.If TE is a vector of echo
%    times, then the return will be a set of values for each echo time.
%    Otherwise, the return value will be the signal.  The PD is not
%    accounted for so all values are relative to an mean magnetization of
%    1.
%
%   References:
%      The Hornak book has most of them on a single page.
%
%      https://www.cis.rit.edu/htbooks/mri/chap-10/chap-10.htm#:~:text=Gradient%20Recalled%20Echo,detection%20circuitry%20on%20the%20imager.
%      https://mriquestions.com/spoiled-gre-parameters.html
%
% Inputs:
%   sequence - Pulse sequence name. Options are one of
%     {'inversion recovery', inversion recovery 3', 'spin echo', 'gradient echo','spgr'}
%   
% Optional key/val pairs
%   These are the pulse sequence parameters
%
%    T1, T2, T2star, TI, TR, TE, FA
%
% Return
%    val - Signal values
%   
%
% See also
%   tls_mriSignalEquations.mlx
%

%% Read the parameters
%
% The parameters necessary for the sequence should be included
% The tissue parameters should be appropriate for, well, the tissue you
% want

% Lower case, eliminate spaces
varargin = mrvParamFormat(varargin);

p = inputParser;

p.addRequired('sequence',@ischar);

p.addParameter('T1',[],@isscalar);
p.addParameter('T2',[],@isscalar);
p.addParameter('T2star',[],@isscalar);
p.addParameter('TI',[],@isscalar);
p.addParameter('TR',[],@isscalar);
p.addParameter('TE',[],@isnumeric);    % Might be a vector of times
p.addParameter('FA',[],@isscalar);

p.parse(sequence,varargin{:});

FA = p.Results.FA;
T1 = p.Results.T1;
T2 = p.Results.T2;
T2star = p.Results.T2star;
TE = p.Results.TE;
TR = p.Results.TR;
TI = p.Results.TI;

%% Do the calculation

% We could validate that the parameters are sent in correctly.

switch mrvParamFormat(sequence)
    case 'inversionrecovery'
        % 180-90
        val = (1 - 2*exp(-TI/T1)) + exp(-TR/T1);
        
    case 'inversionrecovery3'
        % 180-90-180
        val = (1 - 2*exp(-TI/T1) + exp(-TR/T1)) .* exp(-TE ./ T2);
        
    case 'spinecho'
        % TE can be a vector to permit understanding the signal
        val = (1 - exp(-TR/T1)) .* (exp(-TE / T2));
        
    case 'gradientecho'
        val = sind(FA)*(1 - exp(-TR/T1)) .* (exp(-TE ./ T2star)) / ...
            (1 - cosd(FA)*(1 - exp(-TR/T1)));
        
    case {'spoiledgradientrecalledecho','spgr'}
        % From:  https://mriquestions.com/spoiled-gre-parameters.html
        % The Ernst angle is 
        % arccos(exp(-TR/T1))
        E = exp(-TR/T1);   
        val = ((1 - E)*sind(FA) / (1 - cosd(FA)*E)) .* exp(-TE ./ T2star);
        
    otherwise
        error('Unknown sequence %s\n',sequence);
end

end