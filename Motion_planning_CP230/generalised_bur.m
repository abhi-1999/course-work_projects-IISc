function GBur = generalised_bur(q,k,thr_hold,map)

root =q;
 
N = 10;

dc = find_min_dist_to_obstacle(root,map); %select min distance to obstacle


GBur = Bur(root,dc,map,N);%  Initialize GBur to Bur

for i = 1:N % Iterate through all spines %changed to 2 because of points start from 2
   
    for p = 0:k-1    %Iterate through all extensions in one direction
        
        [node_id,node] = findEndpoint(GBur,root, i);    % Find endpoint of GBur in direction 

        dc = find_min_dist_to_obstacle(node,map);

        if dc < thr_hold
            break; %RRT MODE
        else
            GBur = updateGBur(GBur,root, node_id,node,dc); % Update GBur
        end 
    end
    
end

end