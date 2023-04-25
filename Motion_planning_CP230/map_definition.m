function map =map_definition()

map.Npoly=7; %Define number of polygons

 map.poly{1}=[13,3; 15,3; 15,7; 13,7; 13,3];
 

 map.poly{2}=[6,3; 7,2; 10,2; 11,3; 11,4; 10,5; 7,5; 6,4; 6,3];
 
 map.poly{3}=[4,8; 10,7; 12,10; 6,11; 4,8];


 map.poly{4}=[15,5; 18,5; 18,7; 15,7; 15,5];

 map.poly{5} = [10,12; 12,14; 12,16;14,20; 10,12];

 map.poly{6} = [22,22; 24,25;15,24;22,22];
 map.poly{7} = [20,3;22,6; 26,8; 19,8;20,3];
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
map.xrange=[0 30];
map.yrange=[0 30];


%Plot map
figure;
plot([0 30 30 0 0],[0 0 30 30 0]);
hold on

% Fill polygons

for i=1:map.Npoly    
    fill(map.poly{i}(:,1),map.poly{i}(:,2),'r')
end


    