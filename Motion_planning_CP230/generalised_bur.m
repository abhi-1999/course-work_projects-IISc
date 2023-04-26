function [gbur,spine_flag,spine_point] = generalised_bur(goal,start,k,N,thr_hold,map,rrt_limit)
if isnan(start(1)) 
    disp("shit");
end
root =start;
 spine_flag = 0;
 spine_point = [];

[dc,close_pt] = find_min_dist_to_obstacle(root,map); %select min distance to obstacle
if dc < thr_hold
    spine_flag =  1;
    gbur = RRT_bur(goal,root,close_pt,dc,map,rrt_limit);
    spine_point = [gbur.Nodes.XData(end) gbur.Nodes.YData(end)];
    return
end
if dc == inf
    disp("shit");
end
gbur = Bur(root,dc,map,N);%  Initialize GBur to Bur

for i = 1:N % Iterate through all spines
   
    for p = 1:k-1    %Iterate through all extensions in one direction
        
        [node_id,node] = findEndpoint(gbur,root, i);    % Find endpoint of GBur in direction 

        [dc,~] = find_min_dist_to_obstacle(node,map);

        if dc < thr_hold
            break; %RRT MODE
        else
            gbur = updateGBur(gbur,root, node_id,node,dc,map); % Update GBur
        end 
    end
    
end

end