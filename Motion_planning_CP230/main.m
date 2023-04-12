%% For a point robot
clear
close all
clc



map=map_definition();

q=[15,15]; %start point
goal = [800,800];

k=5; % number of points along each spine
thr_hold = 0.05;
epsilon = 0.5;
GBur = generalised_bur(q,k,thr_hold,map);
[nearest_point,nearest_point_idx]  =  findnearestpoint(GBur,goal);

if isempty(polyxpoly(map.obsx,map.obsx,[goal(1),nearest_point(1)],[goal(2),nearest_point(2)]))
    [flag,points_ss]=singlespinebur(map,goal,nearest_point,k,epsilon);
    if flag ==  1
        path(GBur,points_ss,nearest_point_idx);
    end

end
plot(GBur, 'XData', GBur.Nodes.XData, 'YData', GBur.Nodes.YData,'NodeColor','k','EdgeColor','g');
