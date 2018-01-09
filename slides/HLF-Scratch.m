pd = [0.7:0.05:1];

k = 1;  % Amount of water in the voxel

h = k*(1 - pd);
T1h = 0.4;
T1f = 3.5;

T1 = 1./( (h*(1./T1h) + (1-h)*(1./T1f)));

figure(1); 
plot(T1,h)
plot(T1,pd)
