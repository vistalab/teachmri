function val = mrSignalEquations(sequence,varargin)
% From sequence and tissue parameters and return signal values
%
% References:
% The Hornak book has most of them on a single page.
%
%   https://www.cis.rit.edu/htbooks/mri/chap-10/chap-10.htm#:~:text=Gradient%20Recalled%20Echo,detection%20circuitry%20on%20the%20imager.
%   https://mriquestions.com/spoiled-gre-parameters.html
%

%% Dig out the parameters

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