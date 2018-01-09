function [tSeries fit] = detrendTSeries(tSeries,detrendOption,smoothFrames)
%
% detrendedTSeries = detrendTSeries(tSeries,detrendOption,[smoothFrames])
%
% detrendOption is one of the following:  
%   0 no trend removal
%   1 highpass trend removal
%   2 quartic removal
%   -1 linear trend removal
% default determined by calling 'detrendFlag' that uses blockedAnalysisParams.detrend
%
% smoothFrames only needed for detrendOption==1
%
% djh, 2/2001

%disp('Detrending tSeries...');

nFrames = size(tSeries,1);  

switch detrendOption

case 2
    % remove a quadratic function

    model = [(1:nFrames).*(1:nFrames);(1:nFrames);ones(1,nFrames)]';

    wgts = model\tSeries;
    fit = model*wgts;
    tSeries = tSeries - fit;
    

case -1  
    % remove a linear function

    model = [(1:nFrames);ones(1,nFrames)]';
    wgts = model\tSeries;
    fit = model*wgts;
    tSeries = tSeries - fit;

    
case 1
    % Do high-pass baseline removal

    [tSeries fit] = removeBaseline2(tSeries, smoothFrames);

    %tSeries = removeBaseline3(tSeries, smoothFrames);

    

otherwise

    % Do nothing

    

end
