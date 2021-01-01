function f = kspacePrepareFigure
% Prepare a figure window for out kspace demo. We use the full height of
% the display and a fraction of the width (= height / 2). We set the figure
% to figure(1). Return f, the figure window.
%
f = 1; figure(f); 
scrsz = get(0,'ScreenSize'); scrsz(3) = scrsz(4) / 2;
set(f, 'Position',scrsz)