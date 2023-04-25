%% For a point robot
clear
close all
clc



map=map_definition();

start=[8 0.9]; %start point
goal = [21 27];

plot(start(1),start(2),'r<');
plot(goal(1),goal(2),'r>');

k=300; % number of points along each spine
N= 10; %number of spines or number of points on complete bubble
max_iter = 100;
thr_hold = 1;
epsilon = 1;
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
    disp(i);
    if connected == 1
        break;
    else
        if i == 3
            disp("hdhdhdh");
        end
        [GBur,ss_flag,last_point_in_ss] = generalised_bur(goal,start,k,N,thr_hold,map);  
        
        if turn == 1
        
            GBur_start = addtobur(GBur_start,GBur);
            %             close all
            %             map=map_definition();
            %             plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor','y','EdgeColor','k');
            %             plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor','m','EdgeColor','g');
            %               hehehe(GBur_start,GBur_goal,map);
            if ss_flag == 1
                nearest_point = last_point_in_ss;
                nearest_point_idx = find_node_id(GBur_start,nearest_point);
            else
                [nearest_point,nearest_point_idx]  =  findnearestpoint(GBur_start,goal); 
            end
        else
            GBur_goal  = addtobur(GBur_goal,GBur);
            %             close all
            %             map=map_definition();
            %             plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor','y','EdgeColor','k');
            %             plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor','m','EdgeColor','g');
            %             hehehe(GBur_start,GBur_goal,map);
            if ss_flag == 1
                nearest_point = last_point_in_ss;
                nearest_point_idx = find_node_id(GBur_goal,nearest_point);
            else
                [nearest_point,nearest_point_idx]  =  findnearestpoint(GBur_goal,goal);
            end              
        
        end
    
    
        if isempty(polyxpoly(map.obsx,map.obsy,[goal(1),nearest_point(1)],[goal(2),nearest_point(2)]))
            
%             [flag,points_ss]=singlespinebur(map,goal,nearest_point,k,epsilon); %can change here i am dropping the spine 
%             if flag ==  1
%                 path(GBur_start,GBur_goal,turn,points_ss,nearest_point_idx); %plot the path 
%                 connected = 1;
%             else
%               [turn,start,goal] = swap(nearest_point,goal,turn); 
%             end
                    
                %OR

            path2(turn,GBur_goal,GBur_start,goal,nearest_point_idx);
            connected =1;
        else
            [turn,start,goal] =  swap(nearest_point,goal,turn);
        end
    end
end

plot(GBur_start, 'XData', GBur_start.Nodes.XData, 'YData', GBur_start.Nodes.YData,'NodeColor','y','EdgeColor','k');
plot(GBur_goal,'XData',GBur_goal.Nodes.XData,'YData',GBur_goal.Nodes.YData,'NodeColor','m','EdgeColor','g');