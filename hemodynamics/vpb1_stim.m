st=zeros(1, 75);

cows=zeros(1, 75);
cows9=zeros(1, 75);
cows79=zeros(1, 75);

cars=zeros(1, 75);
cars9=zeros(1, 75);
cars79=zeros(1, 75);

faces=zeros(1, 75);
faces9=zeros(1, 75);
faces79=zeros(1, 75);
tex=zeros(1, 75);

tt=1:7:56;
tt1=2:7:56;
tt2=3:7:56;
shift=9*ones(size(tt));

st(tt+shift)=ones(size(tt));
st(tt1+shift)=ones(size(tt1));
st(tt2+shift)=ones(size(tt2));
ii=find(st);

faces=faces9+faces79;

cars=cars9+cars79;

cows=cows9+cows79;

shift=9;
texture_index=[tt(3) tt1(3) tt2(3)  tt(6) tt1(6) tt2(6)]; 
texture_index=texture_index+shift*ones(size(texture_index));
tex(texture_index)=ones(size(texture_index));



shift=9;
face_index=[tt(1) tt1(1) tt2(1)  tt(5) tt1(5) tt2(5)]; 
face_index=face_index+shift*ones(size(face_index));
faces(face_index)=ones(size(face_index));
%faces=st+faces;

cow_index=[tt(4) tt1(4) tt2(4)  tt(7) tt1(7) tt2(7)]; 
cow_index=cow_index+shift*ones(size(cow_index));
cows(cow_index)=ones(size(cow_index));
%cows=st+cows;


car_index=[tt(2) tt1(2) tt2(2)  tt(8) tt1(8) tt2(8)]; 
car_index=car_index+shift*ones(size(car_index));
cars(car_index)=ones(size(car_index));
%cars=st+cars;

objects=2*(cows+faces+cars)+tex;
tex=st+tex;
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
axis([ 0 75 0 4])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


path_name ='/brain-map/rafi3/D1999.03.17/RM17.3.99/VPB1/';
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

axis([ 0 75 0 8])
xlabel('FMRI samples tr=1.5s','FontSize',14)
ylabel('% signal change','FontSize',14)     


path_name ='/brain-map/rafi3/D1999.03.17/RM17.3.99/VPB1//';
base_filename='texture';
write_tc(path_name,base_filename,ht);

path_name ='/brain-map/rafi3/D1999.03.17/RM17.3.99/VPB1//';
base_filename='objects';
write_tc(path_name,base_filename,ho);




