%% For a point robot
clear
close all
clc



map=map_definition();

start=[15,15]; %start point
goal = [800,800];

k=5; % number of points along each spine
thr_hold = 0.05;
epsilon = 0.5;
max_iter = 2;
connected = 0;
turn = 1;
GBur_goal = digraph();
GBur_goal = addnode(GBur_goal,1);
GBur_goal.Nodes.XData(1) = goal(1);
GBur_goal.Nodes.YData(1) = goal(2);

GBur_start = digraph();
GBur_start = addnode(GBur_start,1);
GBur_start.Nodes.XData(1) = start(1);
GBur_start.Nodes.YData(1) = start(2);

for i = 1:max_iter
    if connected == 1
        break;
    else
        GBur = generalised_bur(start,k,thr_hold,map);
        [nearest_point,nearest_point_idx]  =  findnearestpoint(GBur,goal);
        if turn == 1
            GBur_satrt = addtobur(GBur_start,GBur);
        else
            GBur_goal  = addtobur(GBur_goal,GBur);

        end
        if isempty(polyxpoly(map.obsx,map.obsx,[goal(1),nearest_point(1)],[goal(2),nearest_point(2)]))
            [flag,points_ss]=singlespinebur(map,goal,nearest_point,k,epsilon);
            if flag ==  1
                path(GBur,points_ss,nearest_point_idx); %plot the path 
                connected = 1;
            else
              [turn,start,goal] = swap(nearest_point,goal); 
            end
        else
            [turn,start,goal] =  swap(nearest_point,goal,turn);
        end
    end
end
plot(GBur, 'XData', GBur.Nodes.XData, 'YData', GBur.Nodes.YData,'NodeColor','k','EdgeColor','g');
