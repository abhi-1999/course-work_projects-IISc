function [min_d, closestPt] = find_min_dist_to_obstacle(root, map)
% define the polygon obstacle vertices
% poly = [1,1; 3,1; 3,4; 2,4; 2,2; 1,2]; ------------> define polygon like
% this

min_d = inf;
closestPt = [NaN NaN];

for j = 1:map.Npoly

    % find the distance and closest point between the point and each polygon edge
    d = zeros(size(map.poly{j},1),1);
    closestPts = zeros(size(map.poly{j},1),2);
    
    for i = 1:size(map.poly{j},1)-1
        [d(i), closestPts(i,:)] = point_to_line_distance(root, map.poly{j}(i,:), map.poly{j}(i+1,:));
    end
    [d(end), closestPts(end,:)] = point_to_line_distance(root, map.poly{j}(end,:), map.poly{j}(1,:));
    
    % find the minimum distance to current obstacle
    temp_d = min(d);
    temp_closestPt = closestPts(d == temp_d, :); % choose closest point with minimum distance
    
    if temp_d < min_d
        min_d = temp_d;
        closestPt = temp_closestPt;
    end
end
closestPt = closestPt(1,:);
% plt_dc(q,map,pid,idx,min_d,closestPt);
end
