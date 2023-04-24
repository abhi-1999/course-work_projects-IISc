function map =map_definition()

map.Npoly=4; %Define number of polygons

 map.poly{1}=[13,3; 15,3; 15,7; 13,7; 13,3];
 

 map.poly{2}=[6,3; 7,2; 10,2; 11,3; 11,4; 10,5; 7,5; 6,4; 6,3];
 
 map.poly{3}=[4,8; 10,7; 12,10; 6,11; 4,8];


 map.poly{4}=[15,5; 18,5; 18,7; 15,7; 15,5];
 
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
map.xrange=[0 100];
map.yrange=[0 100];


%Plot map
figure;
plot([0 100 100 0 0],[0 0 100 100 0]);
hold on

% Fill polygons

for i=1:map.Npoly    
    fill(map.poly{i}(:,1),map.poly{i}(:,2),'r')
end


    