function min_d = find_min_dist_to_obstacle(root,map)
% define the polygon obstacle vertices
% poly = [1,1; 3,1; 3,4; 2,4; 2,2; 1,2]; ------------> define polygon like
% this
min_d = inf;
for j =1:map.Npoly

    % find the distance between the point and each polygon edge
    d = zeros(size(map.poly{j},1),1);
    for i = 1:size(map.poly{j},1)-1
        d(i) = point_to_line_distance(root, map.poly{j}(i,:), map.poly{j}(i+1,:));
    end
    d(end) = point_to_line_distance(root, map.poly{j}(end,:), map.poly{j}(1,:));
    
    % find the minimum distance to current obstacle
    temp_d = min(d);

    if temp_d < min_d    %if the current distance to obstacle is shortest then set it as min_d
        min_d = temp_d;
        

    end
  % plt_dc(q,map,pid,idx,min_d);
end
            