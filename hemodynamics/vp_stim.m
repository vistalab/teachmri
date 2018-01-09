st=zeros(1, 300);

cows=zeros(1, 300);
cows9=zeros(1, 300);
cows79=zeros(1, 300);

cars=zeros(1, 300);
cars9=zeros(1, 300);
cars79=zeros(1, 300);

faces=zeros(1, 300);
faces9=zeros(1, 300);
faces79=zeros(1, 300);
tex=zeros(1, 300);
tt=8:6:300;
st(tt)=ones(size(tt));
ii=find(st);

faces9_index=ii([4 13 21 28 35 43 ])
faces79_index=ii([6 14 22 30 38 46 ])

cars9_index=ii([2 10 18 26 34 42 ])
cars79_index=ii([ 7 15 25 32 40 49 ])

cows9_index=ii([8 16 24 31 39 47 ])
cows79_index=ii([ 3 11 20 29 36 45])

texture_index=ii([ 5 9 12 17 19 23 27 33 37 41 44 48]);

tex(texture_index)=ones(size(texture_index));
faces9(faces9_index)=ones(size(faces9_index));
faces79(faces79_index)=ones(size(faces79_index));
faces=faces9+faces79;

cars9(cars9_index)=ones(size(cars9_index));
cars79(cars79_index)=ones(size(cars79_index));
cars=cars9+cars79;

cows9(cows9_index)=ones(size(cows9_index));
cows79(cows79_index)=ones(size(cows79_index));
cows=cows9+cows79;
objects=cows+faces+cars;

figure(1)
clf
tr=1.5
t=0:tr:12;
gain=1.6507
to=4.8;
sigma=1.8;
g=gain*gauss1D(t,to,sigma);
plot(st,'LineWidth',2)
hold
h=conv(st,g);
h=h(1:length(st));
plot(h,'r')
axis([ 0 300 0 2])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


path_name ='/hosts/vismap/rafi11/Winter99/VP/S179/';
base_filename='visual';
h=conv(st,g);
h=h(1:length(st));
write_tc(path_name,base_filename,h);


figure(2)
clf





ht=conv(tex,g);
ht=ht(1:length(st));
ho=conv(objects,g);
ho=ho(1:length(st));
plot(tex,'w')
hold
plot(objects,'r')
plot(ho,'r','LineWidth',2')
plot(ht,'w','LineWidth',2')

axis([ 0 300 0 2])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


path_name ='/hosts/vismap/rafi11/Winter99/VP/S179/';
base_filename='texture';
write_tc(path_name,base_filename,ht);

path_name ='/hosts/vismap/rafi11/Winter99/VP/S179/';
base_filename='objects';
write_tc(path_name,base_filename,ho);




