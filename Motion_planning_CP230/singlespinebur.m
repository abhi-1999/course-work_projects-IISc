function [flag,ss_points] = singlespinebur(map,goal,nearest_point,k,epsilon)


ss_points=goal;




flag = 0;
plot(goal(1),goal(2),'g<');
plot(nearest_point(1),nearest_point(2),'b*');
for i =1:k
    new_point = ss_points(end,:);
    euc_dist = sqrt(sum((new_point - nearest_point).^2,2));
    dc = find_min_dist_to_obstacle(new_point,map);
    if dc < euc_dist || euc_dist < epsilon   %if dc is less than eucledian distance or eucledian distance is less than threshhold then connect them 
        if size(ss_points,1) == 1
            return
        else
            ss_points(end,:) = [];
%             plot(ss_points(end,1),ss_points(end,2),'r>');
%             plot([ss_points(end,1) nearest_point(1)],[ss_points(end,2) nearest_point(2)],'g');        
            flag = 1;
            break;
        
        end
        
    else
        %find new point along the direction of spine
    
        direction = (nearest_point - new_point) / norm(nearest_point - new_point);
        new_point = new_point + direction * dc;
       
        ss_points = [ss_points;new_point];
    end
end

