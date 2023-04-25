function map =map_definition()

map.Npoly=9; %Define number of polygons

 map.poly{1}=[13,3; 15,3; 15,7; 13,7; 13,3];
 

 map.poly{2}=[6,3; 7,2; 10,2; 11,3; 11,4; 10,5; 7,5; 6,4; 6,3];
 
 map.poly{3}=[4,8; 10,7; 12,10; 6,11; 4,8];


 map.poly{4}=[15,5; 18,5; 18,7; 15,7; 15,5];

 map.poly{5}=[6,13; 6,16; 12,16; 12,11; 6,13];

 map.poly{6}=[13,8.5; 13,15; 18,15; 18,8.5; 13,8.5];

 map.poly{7}=[6,17; 6,21; 18,21; 18,17; 6,17];

 map.poly{8}=[19,5; 19,13; 24,13; 24,5; 19,5];

 map.poly{9}=[19,14; 19,21; 24,21; 24,14; 19,14];

 % merge vertices of all obstacle
obsx=map.poly{1}(:,1).';
obsy=map.poly{1}(:,2).';
for i=2:map.Npoly
    obsx=[obsx NaN map.poly{i}(:,1).'];
    obsy=[obsy NaN map.poly{i}(:,2).'];
end
map.obsx=obsx;
map.obsy=obsy; 


%Define map range
map.xrange=[3 25];
map.yrange=[1 22];


%Plot map
figure;
plot([3 25 25 3 3],[1 1 22 22 1]);
hold on

% Fill polygons

for i=1:map.Npoly    
    fill(map.poly{i}(:,1),map.poly{i}(:,2),'r')
end


    