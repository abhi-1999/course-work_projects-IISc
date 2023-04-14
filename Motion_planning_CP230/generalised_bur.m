function gbur = generalised_bur(start,k,thr_hold,map)

root =start;
 
N = 100;

dc = find_min_dist_to_obstacle(root,map); %select min distance to obstacle


gbur = Bur(root,dc,map,N);%  Initialize GBur to Bur

for i = 1:N % Iterate through all spines %changed to 2 because of points start from 2
   
    for p = 0:k-1    %Iterate through all extensions in one direction
        
        [node_id,node] = findEndpoint(gbur,root, i);    % Find endpoint of GBur in direction 

        dc = find_min_dist_to_obstacle(node,map);

        if dc < thr_hold
            break; %RRT MODE
        else
            gbur = updateGBur(gbur,root, node_id,node,dc); % Update GBur
        end 
    end
    
end

end